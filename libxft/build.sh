pkgname=('libxft')
pkgver=2.3.3
pkgrel=1
pkgdesc='FreeType-based font drawing library for X'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'fontconfig'
'freetype2'
'glibc'
'libx11'
'libxrender'
)
makedepends=('pkgconfig')
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXft-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXft-$pkgver.tar.bz2.sig"
)
sha512sums=(
'28fdaf3baa3b156a4a7fdd6e39c4d8026d7d21eaa9be27c9797c8d329dab691a1bc82ea6042f9d4729a9343d93787536fb7e4b606f722f33cbe608b2e79910e8'
'SKIP'
)
prepare() {
cd libXft-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXft-$pkgver
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
cd libXft-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxft/COPYING
}
