pkgbase='gdb'
pkgname=('gdb' 'gdb-common')
pkgver=9.1
pkgrel=2
url='https://www.gnu.org/software/gdb/'
license=('GPL3')
arch=('x86_64')
makedepends=(
'expat'
'guile2.0'
'ncurses'
'python'
'texinfo'
'xz'
)
source=(
"https://ftp.gnu.org/gnu/gdb/$pkgname-$pkgver.tar.xz"
"https://ftp.gnu.org/gnu/gdb/$pkgname-$pkgver.tar.xz.sig"
)
sha1sums=(
'a50e13e1eecea468ea28c4a23d8c5a84f4db25be'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
sed '/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/' -i libiberty/configure
sed	-e 's|../libctf/.libs/libctf.a|/usr/lib/libctf.so|g' -i gdb/Makefile.in
sed	-e 's|$(BFD_DIR)/libbfd.a|/usr/lib/libbfd.so|g' -i gdb/Makefile.in
sed	-e 's|$(OPCODES_DIR)/libopcodes.a|/usr/lib/libopcodes.so|g' -i gdb/Makefile.in
}
build() {
cd $pkgname-$pkgver
config_opts=(
	'--prefix=/usr'
	'--bindir=/usr/bin'
	'--sbindir=/usr/bin'
	'--libdir=/usr/lib'
	'--libexecdir=/usr/lib'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--disable-werror'
	'--disable-multilib'
	'--enable-ld=yes'
	'--enable-gold=yes'
	'--enable-decimal-float=yes'
	'--enable-compressed-debug-sections=all'
	'--enable-liboffloadmic=host'
	'--enable-threads=posix'
	'--enable-64-bit-archive'
	'--enable-plugins'
	'--enable-lto'
	'--enable-secureplt'
	'--enable-gdbserver'
	'--enable-multi-ice'
	'--enable-tui'
	'--enable-multibyte'
	'--enable-host-shared'
	'--enable-vtable-verify'
	'--enable-libquadmath'
	'--enable-libquadmath-support'
	'--with-mmap'
	'--with-pic'
	'--with-mpc'
	'--with-gmp'
	'--with-system-gdbinit=/etc/gdb/gdbinit'
	'--with-bugurl=https://bugs.archlinux.org'
	'--without-included-regex'
	'--without-static-standard-libraries'
	'--without-babeltrace'
	'--with-expat'
	'--without-guile'
	'--without-isl'
	'--without-intel-pt'
	'--with-mpfr'
	'--with-curses'
	'--without-python'
	'--with-system-readline'
	'--with-lzma'
	'--with-system-zlib'
)
mkdir -p build && cd build
../configure "${config_opts[@]}"
make
}
package_gdb() {
pkgdesc='The GNU Debugger'
depends=(
	"gdb-common=$pkgver"
	'bash'
	'binutils'
	'expat'
	'gcc-libs'
	'glibc'
	'mpfr'
	'ncurses'
	'readline'
	'xz'
	'zlib'
)
backup=('etc/gdb/gdbinit')
cd $pkgname-$pkgver/build
make DESTDIR=$pkgdir install
cd $pkgdir
mkdir -p etc/gdb
touch etc/gdb/gdbinit
rm -f $pkgdir/usr/include/{ansidecl,bfd,bfdlink,dis-asm,plugin-api,symcat,ctf,ctf-api,bfd_stdint,diagnostics}.h
rm -f $pkgdir/usr/share/info/bfd.info
rm -f $pkgdir/usr/lib/{libbfd,libopcodes,libctf,libctf-nobfd}{.a,*.so*}
mkdir -p $srcdir/gdb-common/usr/share
mv usr/share/gdb $srcdir/gdb-common/usr/share
}
package_gdb-common() {
pkgdesc='Common files for GNU Debugger'
depends=(
)
mv $srcdir/gdb-common/* $pkgdir
}
