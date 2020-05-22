pkgname=('libxcursor')
pkgver=1.2.0
pkgrel=1
pkgdesc='X cursor management library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libx11'
'libxfixes'
'libxrender'
)
makedepends=('xorg-util-macros')
optdepends=('gnome-themes-standard: fallback icon theme')
backup=('usr/share/icons/default/index.theme')
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXcursor-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXcursor-$pkgver.tar.bz2.sig"
'index.theme'
)
sha512sums=(
'2b12d0fd17e311ce269dbba58588698885815eb07aa44d48525ed5cd9e5f379bb90138a792a191e2f74888ab10b3ca9a4f507f21de0984ed79748973ab927a03'
'SKIP'
'489a07b5c9c50b9ddbd10093c79a07d34f2f1c9b4f053ecd68a9f300e201f7b92890b92f0bb4963dfeaa1b158f43149d615b07d1e70523de41565eff7dd5fccb'
)
prepare() {
cd libXcursor-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXcursor-$pkgver
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
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd libXcursor-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/index.theme $pkgdir/usr/share/icons/default/index.theme
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxcursor/COPYING
}
