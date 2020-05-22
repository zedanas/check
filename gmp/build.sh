pkgname=('gmp')
pkgver=6.2.0
pkgrel=1
pkgdesc='A free library for arbitrary precision arithmetic'
url='https://gmplib.org/'
license=('LGPL3' 'GPL')
arch=('x86_64')
depends=(
'gcc-libs'
'glibc'
'sh'
)
source=(
"https://gmplib.org/download/$pkgname/$pkgname-$pkgver.tar.lz"
"https://gmplib.org/download/$pkgname/$pkgname-$pkgver.tar.lz.sig"
)
md5sums=(
'e3e08ac185842a882204ba3c37985127'
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
	'--disable-profiling'
	'--enable-assembly'
	'--enable-fft'
	'--enable-fat'
	'--enable-cxx'
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
