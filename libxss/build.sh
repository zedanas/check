pkgname=('libxss')
pkgver=1.2.3
pkgrel=2
pkgdesc='X11 Screen Saver extension library'
url='https://gitlab.freedesktop.org/xorg/lib/libxscrnsaver'
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
source=("https://xorg.freedesktop.org/releases/individual/lib/libXScrnSaver-$pkgver.tar.bz2")
sha512sums=('7ea628324a11b25ee82c7b11c6bf98f37de219354de51c1e29467b5de422669ba1ab121f3b9dc674093c8f3960e93c5d5428122f5539092f79bc8451c768354a')
prepare() {
cd libXScrnSaver-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXScrnSaver-$pkgver
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
cd libXScrnSaver-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxss/COPYING
}
