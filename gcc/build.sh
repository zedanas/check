pkgbase='gcc'
pkgname=('gcc' 'gcc-libs')
pkgver=9.3.0
pkgrel=1
url='https://gcc.gnu.org'
license=('GPL' 'LGPL' 'FDL' 'custom')
arch=('x86_64')
makedepends=(
'binutils'
'doxygen'
'git'
'gmp'
'isl'
'libmpc'
'mpfr'
'python'
'zlib'
)
checkdepends=(
'dejagnu'
'inetutils'
)
options=('staticlibs')
source=(
"https://ftp.gnu.org/gnu/gcc/gcc-$pkgver/gcc-$pkgver.tar.xz"
"https://ftp.gnu.org/gnu/gcc/gcc-$pkgver/gcc-$pkgver.tar.xz.sig"
'c89'
'c99'
)
sha256sums=(
'71e197867611f6054aa1119b13a0c0abac12834765fe2d81f35ac57f84f742d1'
'SKIP'
'de48736f6e4153f03d0a5d38ceb6c6fdb7f054e8f47ddd6af0a3dbf14f27b931'
'2513c6d9984dd0a2058557bf00f06d8d5181734e41dcfe07be7ed86f2959622a'
)
prepare() {
cd $pkgbase-$pkgver
sed '/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/' -i {libiberty,gcc}/configure
sed  's/lib64/lib/' -i gcc/config/i386/t-linux64
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgbase-$pkgver
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
	'--enable-static'
	'--disable-werror'
	'--disable-multilib'
	'--disable-multiarch'
	'--disable-bootstrap'
	'--disable-debug'
	'--disable-libunwind-exceptions'
	'--disable-vtable-verify'
	'--enable-cet=auto'
	'--enable-ld=yes'
	'--enable-gold=yes'
	'--enable-decimal-float=yes'
	'--enable-compressed-debug-sections=all'
	'--enable-languages=c,c++,lto'
	'--enable-threads=posix'
	'--enable-symvers=gnu'
	'--enable-clocale=gnu'
	'--enable-checking=release'
	'--enable-coverage=noopt'
	'--enable-plugin'
	'--enable-lto'
	'--enable-nls'
	'--enable-multibyte'
	'--enable-host-shared'
	'--enable-linux-futex'
	'--enable-tls'
	'--disable-libada'
	'--disable-libssp'
	'--enable-libmpx'
	'--enable-libquadmath'
	'--enable-install-libiberty'
	'--enable-linker-build-id'
	'--enable-default-pie'
	'--enable-default-ssp'
	'--enable-gnu-indirect-function'
	'--enable-gnu-unique-object'
	'--enable-initfini-array'
	'--enable-__cxa_atexit'
	'--enable-c99'
	'--enable-cstdio=stdio'
	'--enable-long-long'
	'--enable-wchar_t'
	'--enable-extern-template'
	'--disable-concept-checks'
	'--disable-fully-dynamic-string'
	'--disable-libstdcxx-pch'
	'--disable-libstdcxx-debug'
	'--enable-libstdcxx-verbose'
	'--enable-libstdcxx-visibility'
	'--enable-libstdcxx-dual-abi'
	'--enable-libstdcxx-threads'
	'--enable-libstdcxx-filesystem-ts'
	'--enable-libstdcxx-allocator=auto'
	'--with-libstdcxx-lock-policy=auto'
	'--with-pic'
	'--with-demangler-in-ld'
	'--with-linker-hash-style=gnu'
	'--with-diagnostics-color=auto'
	'--with-bugurl=https://bugs.archlinux.org'
	'--with-gmp'
	'--with-isl'
	'--with-mpc'
	'--with-mpfr'
	'--with-system-zlib'
)
export CFLAGS+=' -fno-lto'
export CXXFLAGS+=' -fno-lto'
./configure "${config_opts[@]}"
make
make -C $CHOST/libstdc++-v3/doc doc-man-doxygen
}
check() {
cd $pkgbase-$pkgver
make -k check
}
package_gcc() {
pkgdesc='The GNU Compiler Collection - C and C++ frontends'
groups=('base-devel')
depends=(
	"gcc-libs=$pkgver-$pkgrel"
	'bash'
	'binutils>=2.28'
	'glibc'
	'gmp'
	'isl'
	'libmpc'
	'mpfr'
	'zlib'
)
provides=('gcc-multilib')
replaces=('gcc-multilib')
cd $pkgbase-$pkgver
make DESTDIR=$pkgdir install
make DESTDIR=$pkgdir install-fixincludes
make DESTDIR=$pkgdir -C $CHOST/libstdc++-v3/doc doc-install-man
install -Dm755 $srcdir/c89 $pkgdir/usr/bin/c89
install -Dm755 $srcdir/c99 $pkgdir/usr/bin/c99
ln -s gcc $pkgdir/usr/bin/cc
mkdir -p $pkgdir/usr/lib/bfd-plugins
ln -s /usr/lib/gcc/$CHOST/${pkgver%%+*}/liblto_plugin.so \
$pkgdir/usr/lib/bfd-plugins/liblto_plugin.so
mkdir -p $pkgdir/usr/share/gdb/auto-load/usr/lib/
mv $pkgdir/usr/lib/libstdc++.so.6.*-gdb.py $pkgdir/usr/share/gdb/auto-load/usr/lib
cd $pkgdir
mkdir -p $srcdir/gcc-libs/usr/{lib,share/info}
mv usr/lib/libasan* $srcdir/gcc-libs/usr/lib || true
mv usr/lib/libatomic* $srcdir/gcc-libs/usr/lib || true
mv usr/lib/libcilkrts* $srcdir/gcc-libs/usr/lib || true
mv usr/lib/libgcc_s* $srcdir/gcc-libs/usr/lib || true
mv usr/lib/libgomp* $srcdir/gcc-libs/usr/lib || true
mv usr/lib/libitm* $srcdir/gcc-libs/usr/lib || true
mv usr/lib/liblsan* $srcdir/gcc-libs/usr/lib || true
mv usr/lib/libmpx* $srcdir/gcc-libs/usr/lib || true
mv usr/lib/libmpxwrappers* $srcdir/gcc-libs/usr/lib || true
mv usr/lib/libquadmath* $srcdir/gcc-libs/usr/lib || true
mv usr/lib/libsanitizer* $srcdir/gcc-libs/usr/lib || true
mv usr/lib/libssp* $srcdir/gcc-libs/usr/lib || true
mv usr/lib/libstdc++* $srcdir/gcc-libs/usr/lib || true
mv usr/lib/libtsan* $srcdir/gcc-libs/usr/lib || true
mv usr/lib/libubsan* $srcdir/gcc-libs/usr/lib || true
mv usr/share/info/libgomp* $srcdir/gcc-libs/usr/share/info || true
mv usr/share/info/libitm* $srcdir/gcc-libs/usr/share/info || true
mv usr/share/info/libquadmath* $srcdir/gcc-libs/usr/share/info || true
}
package_gcc-libs() {
pkgdesc='Runtime libraries shipped by GCC'
groups=('base')
depends=('glibc>=2.27')
provides=(
	'gcc-libs-multilib'
	'libasan.so'
	'liblsan.so'
	'libtsan.so'
	'libubsan.so'
)
replaces=('gcc-libs-multilib')
mv $srcdir/gcc-libs/* $pkgdir
}
