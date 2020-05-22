pkgname=('libxfixes')
pkgver=5.0.3
pkgrel=3
pkgdesc='X11 miscellaneous "fixes" extension library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libx11'
)
makedepends=(
'xorg-util-macros'
'xorgproto'
)
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXfixes-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXfixes-$pkgver.tar.bz2.sig"
)
sha256sums=(
'de1cd33aff226e08cefd0e6759341c2c8e8c9faf8ce9ac6ec38d43e287b22ad6'
'SKIP'
)
prepare() {
cd libXfixes-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXfixes-$pkgver
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
cd libXfixes-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxfixes/COPYING
}
