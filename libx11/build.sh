pkgname=('libx11')
pkgver=1.6.9
pkgrel=6
pkgdesc='X11 client-side library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libxcb'
'xorgproto'
)
makedepends=(
'xorg-util-macros'
'xtrans'
)
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libX11-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libX11-$pkgver.tar.bz2.sig"
)
sha512sums=(
'fc18f0dc17ade1fc37402179f52e1f2b9c7b7d3a1a9590fea13046eb0c5193b4796289431cd99388eac01e8e59de77db45d2c9675d4f05ef8cf3ba6382c3dd31'
'SKIP'
)
prepare() {
cd libX11-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libX11-$pkgver
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
	'--enable-specs'
	'--enable-xthreads'
	'--enable-composecache'
	'--enable-xcms'
	'--enable-xlocale'
	'--enable-xkb'
	'--enable-xlocaledir'
	'--enable-loadable-i18n'
	'--enable-loadable-xcursor'
	'--disable-xf86bigfont'
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
check() {
cd libX11-$pkgver
make -k check
}
package() {
cd libX11-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libx11/COPYING
}
