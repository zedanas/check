pkgname=('gawk')
pkgver=5.0.1
pkgrel=2
pkgdesc='GNU version of awk'
url='https://www.gnu.org/software/gawk/'
license=('GPL')
arch=('x86_64')
groups=('base-devel')
depends=(
'glibc'
'gmp'
'mpfr'
'readline'
)
provides=('awk')
source=(
"https://ftp.gnu.org/pub/gnu/$pkgname/$pkgname-$pkgver.tar.gz"
"https://ftp.gnu.org/pub/gnu/$pkgname/$pkgname-$pkgver.tar.gz.sig"
)
md5sums=(
'c5441c73cc451764055ee65e9a4292bb'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
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
	'--enable-extensions'
	'--disable-versioned-extension-dir'
	'--without-libsigsegv'
	'--enable-mpfr'
	'--with-readline'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname-$pkgver
make -k check
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
}
