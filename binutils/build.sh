pkgname=('binutils')
pkgver=2.34
pkgrel=2
pkgdesc='A set of programs to assemble and manipulate binary and object files'
url='https://www.gnu.org/software/binutils/'
license=('GPL')
arch=('x86_64')
groups=('base-devel')
depends=(
'elfutils'
'gcc-libs'
'glibc'
'zlib'
)
makedepends=('git')
checkdepends=(
'bc'
'dejagnu'
)
conflicts=('binutils-multilib')
replaces=('binutils-multilib')
options=('staticlibs')
source=(
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.xz"
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.xz.sig"
)
md5sums=(
'664ec3a2df7805ed3464639aaae332d6'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
sed '/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/' -i libiberty/configure
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
	'--enable-static'
	'--disable-werror'
	'--disable-checking'
	'--disable-multilib'
	'--disable-bootstrap'
	'--disable-vtable-verify'
	'--enable-separate-code'
	'--disable-default-strings-all'
	'--enable-targets=x86_64-pep'
	'--enable-default-hash-style=gnu'
	'--enable-ld=yes'
	'--enable-gold=yes'
	'--enable-got=target'
	'--enable-compressed-debug-sections=all'
	'--enable-deterministic-archives'
	'--enable-threads=posix'
	'--enable-plugins'
	'--enable-lto'
	'--enable-nls'
	'--enable-host-shared'
	'--enable-relro'
	'--enable-secureplt'
	'--enable-libssp'
	'--enable-libquadmath'
	'--enable-libstdcxx'
	'--enable-liboffloadmic=host'
	'--enable-elf-stt-common'
	'--enable-x86-relax-relocations'
	'--enable-install-libbfd'
	'--enable-initfini-array'
	'--with-mmap'
	'--with-pic'
	'--with-isl'
	'--with-mpc'
	'--with-mpfr'
	'--with-gmp'
	'--without-debuginfod'
	'--without-static-standard-libraries'
	'--with-lib-path=/usr/lib:/usr/local/lib'
	'--with-bugurl=https://bugs.archlinux.org'
	'--with-system-zlib'
)
./configure "${config_opts[@]}"
make configure-host && make
}
check() {
cd $pkgname-$pkgver
make LDFLAGS= -k check
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir tooldir=/usr install
rm -f $pkgdir/usr/share/man/man1/{dlltool,nlmconv,windres,windmc}*
}
