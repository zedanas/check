pkgname=('libxpm')
pkgver=3.5.13
pkgrel=1
pkgdesc='X11 pixmap library'
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
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXpm-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXpm-$pkgver.tar.bz2.sig"
)
sha512sums=(
'3b8f6e926272f39b1d95135c2274c00f5aaee1f9fb2ef79f71628df5edeb7ba20158819ef6a778101cc4092493a3b5b613c53634fdccadcc0fc85f0605e5e9a5'
'SKIP'
)
prepare() {
cd libXpm-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXpm-$pkgver
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
	'--enable-stat-zfile'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd libXpm-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxpm/COPYING
}
