pkgname=('libxv')
pkgver=1.0.11
pkgrel=3
pkgdesc='X11 Video extension library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libx11'
'libxext'
)
makedepends=(
'pkgconfig'
'xorgproto'
)
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXv-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXv-$pkgver.tar.bz2.sig"
)
sha256sums=(
'd26c13eac99ac4504c532e8e76a1c8e4bd526471eb8a0a4ff2a88db60cb0b088'
'SKIP'
)
prepare() {
cd libXv-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXv-$pkgver
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
cd libXv-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxv/COPYING
}
