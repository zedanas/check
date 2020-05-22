pkgname=('gnome-icon-theme-symbolic')
pkgver=3.12.0
pkgrel=5
pkgdesc='GNOME icon theme, symbolic icons'
url='http://www.gnome.org'
license=('GPL')
arch=('any')
depends=(
'gtk-update-icon-cache'
'hicolor-icon-theme'
'librsvg'
)
makedepends=(
'icon-naming-utils'
'intltool'
)
source=("https://download.gnome.org/sources/$pkgname/${pkgver:0:4}/$pkgname-$pkgver.tar.xz")
sha256sums=('851a4c9d8e8cb0000c9e5e78259ab8b8e67c5334e4250ebcc8dfdaa33520068b')
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
	'--enable-icon-mapping'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
}
