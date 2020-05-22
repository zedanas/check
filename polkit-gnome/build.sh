pkgname=('polkit-gnome')
pkgver=0.105
pkgrel=4
pkgdesc='Legacy polkit authentication agent for GNOME'
url='https://www.freedesktop.org/wiki/Software/polkit/'
license=('LGPL')
arch=('x86_64')
depends=(
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'polkit'
)
makedepends=('intltool')
source=(
"https://download.gnome.org/sources/$pkgname/$pkgver/$pkgname-$pkgver.tar.xz"
'polkit-gnome-authentication-agent-1.desktop'
)
sha512sums=(
'eae2504959bca6f2b53dbad1b743fc0414b82897e62623af80ee74c4080a10d6b07a4c90151ee1264891f27373321b8697ac8a747cba5254c765b4cd9161bd42'
'8b24b7a39556e6a17284e052baa7af81237401e4010049839871ea5487643c92b2600f513213b9003a1a452492540e1d1cf6a5faf7a2ce5a28ad4f00e4b835aa'
)
build() {
cd $pkgname-$pkgver
config_opts=(
	'--prefix=/usr'
	'--bindir=/usr/bin'
	'--sbindir=/usr/bin'
	'--libexecdir=/usr/lib/polkit-gnome'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--disable-debug'
)
./configure ${config_opts[@]}
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/polkit-gnome-authentication-agent-1.desktop \
$pkgdir/usr/share/applications/polkit-gnome-authentication-agent-1.desktop
}
