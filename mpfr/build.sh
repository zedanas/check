pkgname='mpfr'
pkgver=4.0.2
pkgrel=2
pkgdesc='Multiple-precision floating-point library'
url='https://www.mpfr.org/'
license=('LGPL')
arch=('x86_64')
depends=(
'glibc'
'gmp>=5.0'
)
source=(
"http://www.mpfr.org/$pkgname-$pkgver/$pkgname-$pkgver.tar.xz"
"http://www.mpfr.org/$pkgname-$pkgver/$pkgname-$pkgver.tar.xz.asc"
)
sha256sums=(
'1d3be708604eae0e42d578ba93b390c2a145f17743a744d8f3f8c2ad5855a38a'
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
	'--disable-assert'
	'--disable-logging'
	'--disable-warnings'
	'--enable-thread-safe'
	'--enable-shared-cache'
	'--enable-decimal-float'
	'--enable-float128'
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
make -k check-exported-symbols
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
}
