pkgname=('libxt')
pkgver=1.2.0
pkgrel=1
pkgdesc='X11 toolkit intrinsics library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libice'
'libsm'
'libx11'
)
makedepends=('xorg-util-macros')
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXt-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXt-$pkgver.tar.bz2.sig"
)
sha512sums=(
'06248508b6fe5dfba8ceb4518475f656162351d78136eeb5d65086d680dabe9aca7bba3c94347f9c13ef03f82dab3ac19d0952ee610bc8c51c14cee7cf65f0b1'
'SKIP'
)
prepare() {
cd libXt-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXt-$pkgver
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
	'--enable-const'
	'--enable-geo-tattler'
	'--disable-unit-tests'
	'--enable-xkb'
	'--with-perl'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd libXt-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxt/COPYING
}
