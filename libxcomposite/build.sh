pkgname=('libxcomposite')
pkgver=0.4.5
pkgrel=2
pkgdesc='X11 Composite extension library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libx11'
'libxfixes'
)
makedepends=(
'xorg-util-macros'
'xorgproto'
)
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXcomposite-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXcomposite-$pkgver.tar.bz2.sig"
)
sha512sums=(
'502fd51fd9097bb3ca72174ac5b25b9d3b1ff240d32c4765199df03d89337d94b4ddea49e90b177b370862430089d966ce9c38988337156352cfeae911c2d3d5'
'SKIP'
)
prepare() {
cd libXcomposite-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXcomposite-$pkgver
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
cd libXcomposite-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxcomposite/COPYING
}
