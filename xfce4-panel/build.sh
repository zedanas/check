pkgname=('xfce4-panel')
pkgver=4.14.3
pkgrel=1
pkgdesc='Panel for the Xfce desktop environment'
url='https://www.xfce.org/'
license=('GPL2')
arch=('x86_64')
groups=('xfce4')
depends=(
'atk'
'bash'
'cairo'
'dbus'
'dbus-glib'
'desktop-file-utils'
'exo'
'garcon'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk2'
'gtk3'
'hicolor-icon-theme'
'libwnck3'
'libx11'
'libxext'
'libxfce4ui'
'libxfce4util'
'pango'
'xfconf'
)
makedepends=(
'gobject-introspection'
'gtk-doc'
'intltool'
'vala'
)
source=("https://archive.xfce.org/src/xfce/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('ef22324d26e5af735134bb10f85b6e16525ac9f48be8d2f6b634142fbfcabbc9')
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
	'--disable-gtk-doc'
	'--disable-debug'
	'--enable-debug=no'
	'--enable-introspection=no'
	'--enable-visibility'
	'--enable-linker-opts'
	'--with-x'
	'--enable-gtk2'
	'--enable-vala=no'
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
