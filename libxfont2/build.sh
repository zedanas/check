pkgname=('libxfont2')
pkgver=2.0.4
pkgrel=2
pkgdesc='X11 font rasterisation library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'bzip2'
'freetype2'
'glibc'
'libfontenc'
'zlib'
)
makedepends=(
'xorg-util-macros'
'xorgproto'
'xtrans'
)
source=(
"https://xorg.freedesktop.org/archive/individual/lib/libXfont2-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/archive/individual/lib/libXfont2-$pkgver.tar.bz2.sig"
)
sha512sums=(
'7cf6c58e520e48e24fc4f05fec760fcbeaaac0cedeed57dded262c855e1515cc34cd033222945a0b016f6857b83009fc2a6946c7d632c2f7bb0060f8e8a8a106'
'SKIP'
)
prepare() {
cd libXfont2-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXfont2-$pkgver
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
	'--enable-devel-docs'
	'--disable-ipv6'
	'--disable-tcp-transport'
	'--enable-unix-transport'
	'--enable-fc'
	'--enable-builtins'
	'--enable-pcfformat'
	'--enable-bdfformat'
	'--enable-snfformat'
	'--with-bzip2'
	'--enable-freetype'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd libXfont2-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxfont2/COPYING
}
