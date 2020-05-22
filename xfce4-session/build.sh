pkgname=('xfce4-session')
pkgver=4.14.2
pkgrel=1
pkgdesc='A session manager for Xfce'
url='https://www.xfce.org/'
license=('GPL2')
arch=('x86_64')
groups=('xfce4')
depends=(
'atk'
'cairo'
'dbus'
'dbus-glib'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'hicolor-icon-theme'
'libice'
'libsm'
'libwnck3'
'libx11'
'libxfce4ui'
'libxfce4util'
'pango'
'polkit'
'polkit-gnome'
'sh'
'upower'
'which'
'xfconf'
'xorg-iceauth'
'xorg-xinit'
'xorg-xrdb'
)
makedepends=('intltool')
optdepends=(
'gnome-keyring: for keyring support when GNOME compatibility is enabled'
'xscreensaver: for locking screen with xflock4'
'xfce4-screensaver: for locking screen with xflock4'
'gnome-screensaver: for locking screen with xflock4'
'xlockmore: for locking screen with xflock4'
'slock: for locking screen with xflock4'
)
replaces=('xfce-utils')
source=(
"https://archive.xfce.org/src/xfce/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2"
'source-system-xinitrc-scripts.patch'
'xfce-polkit-gnome-authentication-agent-1.desktop'
)
sha256sums=(
'fbe3a4a60c91589a2024ce12b2d2667625a8fedcbc90ef031831f56319f597af'
'6f14d529e4c4f30cd547110bd444cee8dc70c90511a397de18acb6c1fd63ea3e'
'74c94c5f7893d714e04ec7d8b8520c978a5748757a0cdcf5128492f09f31b643'
)
prepare() {
cd $pkgname-$pkgver
patch -Np1 -i $srcdir/source-system-xinitrc-scripts.patch
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
	'--disable-legacy-sm'
	'--disable-debug'
	'--enable-debug=no'
	'--enable-linker-opts'
	'--with-backend=linux'
	'--with-x'
	'--enable-polkit'
	'--enable-upower'
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
install -D $srcdir/xfce-polkit-gnome-authentication-agent-1.desktop \
$pkgdir/etc/xdg/autostart/xfce-polkit-gnome-authentication-agent-1.desktop
}
