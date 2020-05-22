pkgname=('xfce4-notifyd')
pkgver=0.4.4
pkgrel=2
pkgdesc='Notification daemon for the Xfce desktop'
url='https://goodies.xfce.org/projects/applications/xfce4-notifyd'
license=('GPL2')
arch=('x86_64')
groups=('xfce4-goodies')
depends=(
'cairo'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'hicolor-icon-theme'
'libnotify'
'libx11'
'libxfce4ui'
'libxfce4util'
'xfce4-panel'
'xfconf'
)
makedepends=(
'intltool'
'python'
'xfce4-dev-tools'
)
provides=('notification-daemon')
source=("https://archive.xfce.org/src/apps/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('090571acf94c423003426cb779fb23e8545c68bab6485563b589c7def8a21b55')
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
	'--enable-dbus-start-daemon'
	'--with-x'
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
