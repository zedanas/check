pkgname=('gnome-icon-theme')
pkgver=3.12.0
pkgrel=5
pkgdesc='GNOME icon theme'
url='http://www.gnome.org'
license=('GPL')
arch=('any')
depends=(
'gnome-icon-theme-symbolic'
'gtk-update-icon-cache'
'hicolor-icon-theme'
)
makedepends=(
'icon-naming-utils'
'intltool'
)
source=("https://download.gnome.org/sources/$pkgname/${pkgver:0:4}/$pkgname-$pkgver.tar.xz")
sha256sums=('359e720b9202d3aba8d477752c4cd11eced368182281d51ffd64c8572b4e503a')
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
rm -f $pkgdir/usr/share/icons/gnome/icon-theme.cache
}
