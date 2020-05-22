pkgname=('xfce4-mailwatch-plugin')
pkgver=1.2.0
pkgrel=8
pkgdesc='Multi-protocol, multi-mailbox mail watcher for the Xfce4 panel'
url='https://goodies.xfce.org/projects/panel-plugins/xfce4-mailwatch-plugin'
license=('GPL2')
arch=('x86_64')
groups=('xfce4-goodies')
depends=(
'bash'
'exo'
'gdk-pixbuf2'
'glib2'
'glibc'
'gnutls'
'gtk2'
'libgcrypt'
'libxfce4ui'
'libxfce4util'
'xfce4-panel'
)
makedepends=('intltool')
source=("http://archive.xfce.org/src/panel-plugins/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('624acc8229a8593c0dfeb28f883f4958119a715cc81cecdbaf29efc8ab1edcad')
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
	'--disable-ipv6'
	'--disable-debug'
	'--enable-debug=no'
	'--with-x'
	'--enable-ssl'
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
mkdir -p $pkgdir/usr/lib/xfce4/session
echo 'DISPLAY=:0 notify-send --urgency=low --expire-time=10000 --icon=mail-notification "Incoming mail" "Check the mailbox. You have a new messages."' >> $pkgdir/usr/lib/xfce4/session/new-email
echo 'canberra-gtk-play --display=:0 --id=message-new-email --description="Mail notification"' >> $pkgdir/usr/lib/xfce4/session/new-email
chmod +x $pkgdir/usr/lib/xfce4/session/new-email
}
