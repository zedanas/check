pkgname=('libxvmc')
pkgver=1.0.12
pkgrel=2
pkgdesc='X11 Video Motion Compensation extension library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libx11'
'libxext'
)
makedepends=(
'libxv'
'pkgconfig'
)
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXvMC-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXvMC-$pkgver.tar.bz2.sig"
)
sha512sums=(
'62cb9a72b20af3b081d2d555a253b0e2b8b26b31f4fad10bd3e53bbf96e1663b61bd8df2b78b16f18218cd37cce0c9e6809ae16ded226b37a8b199e41b223955'
'SKIP'
)
prepare() {
cd libXvMC-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXvMC-$pkgver
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
check() {
cd libXvMC-$pkgver
make -k check
}
package() {
cd libXvMC-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxvmc/LICENSE
}
