pkgname=('xcb-util')
pkgver=0.4.0
pkgrel=2
pkgdesc='Utility libraries for XC Binding'
url='https://xcb.freedesktop.org'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libxcb>=1.7'
)
makedepends=(
'gperf'
'xorg-util-macros'
)
source=("https://xcb.freedesktop.org/dist/$pkgname-$pkgver.tar.bz2")
sha512sums=('e60aaa6f582eacd05896c5fd7c8417938318a1288146f3a5b339f77eed24e211c6099963f8813daa621c94173d2934228936b491c0ed79b09a8a67d835867d0e')
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
	'--disable-devel-docs'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/xcb-util/COPYING
}
