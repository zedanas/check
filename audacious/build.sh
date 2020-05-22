pkgname='audacious'
pkgver=3.10.1
pkgrel=2
pkgdesc='Lightweight, advanced audio player focused on audio quality'
url='https://audacious-media-player.org/'
license=('BSD')
arch=('x86_64')
depends=(
'adwaita-icon-theme'
'audacious-plugins'
'cairo'
'desktop-file-utils'
'gcc-libs'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk2'
'hicolor-icon-theme'
'pango'
)
makedepends=('python')
optdepends=('unzip: zipped skins support')
provides=('audacious-player')
conflicts=('audacious-player')
replaces=('audacious-player')
source=("https://distfiles.$pkgname-media-player.org/$pkgname-$pkgver.tar.bz2")
sha256sums=('8366e840bb3c9448c2cf0cf9a0800155b0bd7cc212a28ba44990c3d2289c6b93')
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
	'--enable-dbus'
	'--enable-gtk'
	'--disable-qt'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/audacious/LICENSE
}
