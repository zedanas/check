pkgname=('libxrender')
pkgver=0.9.10
pkgrel=3
pkgdesc='X Rendering Extension client library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libx11>=1.3.4'
)
makedepends=('xorgproto')
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXrender-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXrender-$pkgver.tar.bz2.sig"
)
sha256sums=(
'c06d5979f86e64cabbde57c223938db0b939dff49fdb5a793a1d3d0396650949'
'SKIP'
)
prepare() {
cd libXrender-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXrender-$pkgver
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
cd libXrender-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxrender/COPYING
}
