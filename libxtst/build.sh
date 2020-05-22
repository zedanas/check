pkgname=('libxtst')
pkgver=1.2.3
pkgrel=3
pkgdesc='X11 Testing -- Resource extension library'
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
"https://xorg.freedesktop.org/releases/individual/lib/libXtst-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXtst-$pkgver.tar.bz2.sig"
)
sha256sums=(
'4655498a1b8e844e3d6f21f3b2c4e2b571effb5fd83199d428a6ba7ea4bf5204'
'SKIP'
)
prepare() {
cd libXtst-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXtst-$pkgver
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
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd libXtst-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxtst/COPYING
}
