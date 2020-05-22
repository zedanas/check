pkgname=('libxmu')
pkgver=1.1.3
pkgrel=1
pkgdesc='X11 miscellaneous micro-utility library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libx11'
'libxext'
'libxt'
)
makedepends=('xorg-util-macros')
source=("https://xorg.freedesktop.org/releases/individual/lib/libXmu-$pkgver.tar.bz2")
sha512sums=('8c6cc65b22aa031ad870dd92736681a068a0878a425a53dbed909943da1136c4a24034d467cfd3785c3a8d78f66850b69f1ebe1eb24aaf9bc176b1d171a5c762')
prepare() {
cd libXmu-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXmu-$pkgver
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
	'--enable-docs'
	'--disable-ipv6'
	'--disable-tcp-transport'
	'--enable-unix-transport'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd libXmu-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxmu/COPYING
}
