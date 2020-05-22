pkgname=('thunar-volman')
pkgver=0.9.5
pkgrel=2
pkgdesc='Automatic management of removeable devices in Thunar'
url='https://goodies.xfce.org/projects/thunar-plugins/thunar-volman'
license=('GPL2')
arch=('x86_64')
groups=('xfce4')
depends=(
'exo'
'glib2'
'glibc'
'gtk3'
'hicolor-icon-theme'
'libgudev'
'libnotify'
'libxfce4ui'
'libxfce4util'
'pango'
'thunar'
'xfconf'
)
makedepends=('intltool')
source=("https://archive.xfce.org/src/xfce/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('7ea7c6693334f2248cf399586af8974dfb7db9aad685ee31ac100e62e19a1837')
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
	'--enable-debug=no'
	'--enable-linker-opts'
	'--enable-notifications'
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
