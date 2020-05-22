pkgname=('libxi')
pkgver=1.7.10
pkgrel=2
pkgdesc='X11 Input extension library'
url='https://xorg.freedesktop.org'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libx11'
'libxext'
'xorgproto'
)
makedepends=(
'automake'
'libxfixes'
'pkgconfig'
'xorg-util-macros'
)
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXi-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXi-$pkgver.tar.bz2.sig"
)
sha512sums=(
'591f0860bf5904897587c4990d6c852f3729a212d1ef390362d41242440e078221877c31db2232d5cc81727fe97f4e194b077f7de917e251e60641bbd06ee218'
'SKIP'
)
prepare() {
cd libXi-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXi-$pkgver
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
	'--enable-specs'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd libXi-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxi/COPYING
}
