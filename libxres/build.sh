pkgname=('libxres')
pkgver=1.2.0
pkgrel=1
pkgdesc='X11 Resource extension library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libx11'
'libxext'
)
makedepends=(
'xorgproto'
'xorg-util-macros'
)
source=("https://xorg.freedesktop.org/releases/individual/lib/libXres-$pkgver.tar.bz2")
sha256sums=('ff75c1643488e64a7cfbced27486f0f944801319c84c18d3bd3da6bf28c812d4')
prepare() {
cd libXres-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXres-$pkgver
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
cd libXres-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxres/COPYING
}
