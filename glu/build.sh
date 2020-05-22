pkgname=('glu')
pkgver=9.0.1
pkgrel=1
pkgdesc='Mesa OpenGL Utility library'
url='https://cgit.freedesktop.org/mesa/glu/'
license=('LGPL')
arch=('x86_64')
depends=(
'gcc-libs'
'glibc'
'libglvnd'
)
source=(
"https://mesa.freedesktop.org/archive/$pkgname/$pkgname-$pkgver.tar.xz"
"https://mesa.freedesktop.org/archive/$pkgname/$pkgname-$pkgver.tar.xz.sig"
)
sha512sums=(
'8a6dae5b4bd63efb96d15f23ccda4ad9c2ffaa964897e5fa63d1e58360d8d4e6732c5efd2109dba04155d5fc457ab1718a65cf9b544ce0d452679ba988d04018'
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
	'--disable-debug'
	'--disable-osmesa'
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
