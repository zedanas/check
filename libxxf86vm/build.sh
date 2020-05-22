pkgname=('libxxf86vm')
pkgver=1.1.4
pkgrel=3
pkgdesc='X11 XFree86 video mode extension library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libx11'
'libxext'
)
makedepends=(
'xorg-util-macros'
'xorgproto'
)
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXxf86vm-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXxf86vm-$pkgver.tar.bz2.sig"
)
sha512sums=(
'c5f92d86e143db02ebb36bcd25618acaa2cb2831f5a23800a06dd431cd73b6702d95de8fe7407ce626336bf614c288d5256f4d87ea7781fad2ab6c517cbf09e0'
'SKIP'
)
prepare() {
cd libXxf86vm-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXxf86vm-$pkgver
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
cd libXxf86vm-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxxf86vm/COPYING
}
