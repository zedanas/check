pkgname=('xfce4-settings')
pkgver=4.14.2
pkgrel=1
pkgdesc='Settings manager of the Xfce desktop'
url='https://www.xfce.org/'
license=('GPL2')
arch=('x86_64')
groups=('xfce4')
depends=(
'adwaita-icon-theme'
'cairo'
'dbus'
'dbus-glib'
'exo'
'fontconfig'
'garcon'
'gdk-pixbuf2'
'glib2'
'glibc'
'gnome-icon-theme'
'gnome-themes-standard'
'gtk3'
'libnotify'
'libx11'
'libxcursor'
'libxfce4ui'
'libxfce4util'
'libxi'
'libxklavier'
'libxrandr'
'pango'
'sh'
'upower'
'xfconf'
)
makedepends=(
'intltool'
'libcanberra'
'xf86-input-libinput'
)
optdepends=('libcanberra: for sound control')
source=(
"https://archive.xfce.org/src/xfce/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2"
'default-xsettings-xml.patch'
)
sha256sums=(
'ebf70ff83e4fd0cb33fa0c3e871ca4df5127a505b30b83a6f780cf3f181b0af5'
'8e9a6c70ab0ceb5d91b637dc290768f8a47edb5d7b6e2eebc4459dbc4ee040d7'
)
prepare() {
cd $pkgname-$pkgver
patch -Np1 -i $srcdir/default-xsettings-xml.patch
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
	'--enable-pluggable-dialogs'
	'--disable-debug'
	'--enable-debug=no'
	'--enable-linker-opts'
	'--disable-colord'
	'--with-x'
	'--enable-xrandr'
	'--enable-upower-glib'
	'--enable-libnotify'
	'--enable-xcursor'
	'--enable-xorg-libinput'
	'--enable-libxklavier'
	'--enable-sound-settings'
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
