pkgname=('xfdesktop')
pkgver=4.14.2
pkgrel=1
pkgdesc='A desktop manager for Xfce'
url='https://www.xfce.org/'
license=('GPL2')
arch=('x86_64')
groups=('xfce4')
depends=(
'cairo'
'dbus'
'dbus-glib'
'exo'
'garcon'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'hicolor-icon-theme'
'libnotify'
'libwnck3'
'libx11'
'libxfce4ui'
'libxfce4util'
'pango'
'thunar'
'xfconf'
)
makedepends=('intltool')
conflicts=('xfce4-menueditor')
replaces=('xfce4-menueditor')
source=("https://archive.xfce.org/src/xfce/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('a30534461fea907f969f608a11c84be0b1aaad687c591c32cd56a9d274ea3e74')
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
	'--enable-gio-unix'
	'--enable-thunarx'
	'--disable-debug'
	'--enable-debug=no'
	'--with-x'
	'--enable-desktop-menu'
	'--enable-notifications'
	'--enable-desktop-icons'
	'--enable-file-icons'
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
