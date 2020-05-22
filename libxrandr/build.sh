pkgname=('libxrandr')
pkgver=1.5.2
pkgrel=2
pkgdesc='X11 RandR extension library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libx11'
'libxext'
'libxrender'
)
makedepends=(
'xorg-util-macros'
'xorgproto'
)
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXrandr-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXrandr-$pkgver.tar.bz2.sig"
)
sha512sums=(
'fcd005f9839e7ef980607128a5d76d7b671cc2f5755949e03c569c500d7e987cb3f6932750ab8bf6e2c1086ec69dde09d5831f0c2098b9f9ad46be4f56db0d87'
'SKIP'
)
prepare() {
cd libXrandr-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXrandr-$pkgver
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
cd libXrandr-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxrandr/COPYING
}
