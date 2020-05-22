pkgname=('libxau')
pkgver=1.0.9
pkgrel=2
pkgdesc='X11 authorisation library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'xorgproto'
)
makedepends=('pkgconfig')
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXau-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXau-$pkgver.tar.bz2.sig"
)
sha512sums=(
'3ca454ba466a807ea28b0f715066d73dc76ad312697b121d43e4d5766215052e9b7ffb8fe3ed3e496fa3f2a13f164ac692ff85cc428e26731b679f0f06a1d562'
'SKIP'
)
prepare() {
cd libXau-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXau-$pkgver
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
	'--enable-xthreads'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd libXau-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxau/COPYING
}
