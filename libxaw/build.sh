pkgname=('libxaw')
pkgver=1.0.13
pkgrel=2
pkgdesc='X11 Athena Widget library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libx11'
'libxext'
'libxmu'
'libxpm'
'libxt'
)
makedepends=('xorg-util-macros')
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXaw-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXaw-$pkgver.tar.bz2.sig"
)
sha512sums=(
'd768a39f7111802493fa1df1b80d858e4139ceeb883d45ff13ce3b7a0e775a7d2834b7ad157c8330117f04c32f38979795332dd7a119adb2344fcb1aa9cf1e2f'
'SKIP'
)
prepare() {
cd libXaw-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXaw-$pkgver
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
	'--enable-xaw6'
	'--enable-xaw7'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd libXaw-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxaw/COPYING
}
