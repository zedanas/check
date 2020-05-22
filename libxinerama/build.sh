pkgname=('libxinerama')
pkgver=1.1.4
pkgrel=2
pkgdesc='X11 Xinerama extension library'
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
source=("https://xorg.freedesktop.org/releases/individual/lib/libXinerama-$pkgver.tar.bz2")
sha512sums=('cff777ad942614fbf6bc6d8529f399e62debf3ecbf6cc0694a94e38c022bf929ffd5636fb59f55533c394d89b23af3ea51fa5128927f12a85787e16239330f14')
prepare() {
cd libXinerama-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXinerama-$pkgver
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
cd libXinerama-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxinerama/COPYING
}
