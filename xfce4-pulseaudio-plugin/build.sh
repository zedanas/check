pkgname=('xfce4-pulseaudio-plugin')
pkgver=0.4.2
pkgrel=2
pkgdesc='Pulseaudio plugin for Xfce4 panel'
url='https://goodies.xfce.org/projects/panel-plugins/xfce4-pulseaudio-plugin'
license=('GPL2')
arch=('x86_64')
groups=('xfce4-goodies')
depends=(
'glib2'
'glibc'
'gtk-update-icon-cache'
'gtk3'
'libkeybinder3'
'libnotify'
'libpulse'
'libwnck3'
'libxfce4ui'
'libxfce4util'
'xfce4-panel'
'xfconf'
)
makedepends=(
'dbus-glib'
'git'
'intltool'
'xfce4-dev-tools'
)
optdepends=('pavucontrol: default pulseaudio mixer')
_commit='b7a76fa7d7176c4cad4dd432a9629f3fa78ed708'
sha256sums=('SKIP')
prepare() {
cd $pkgname
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname
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
	'--enable-maintainer-mode'
	'--enable-mpris2'
	'--disable-debug'
	'--enable-debug=no'
	'--with-x'
	'--with-mixer-command=pavucontrol'
	'--enable-keybinder'
	'--enable-libnotify'
	'--enable-wnck'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install
}
