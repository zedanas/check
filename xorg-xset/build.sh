pkgname=('xorg-xset')
pkgver=1.2.4
pkgrel=1
pkgdesc='User preference utility for X'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
groups=('xorg-apps' 'xorg')
depends=(
'glibc'
'libx11'
'libxext'
'libxmu'
)
makedepends=('xorg-util-macros')
source=(
"https://xorg.freedesktop.org/archive/individual/app/xset-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/archive/individual/app/xset-$pkgver.tar.bz2.sig"
)
sha512sums=(
'f24714c9a82081a09d3054bbad98553de9366992f22eaf3e2bcadbb58fad1d3dad2547fef6fa9898d8a9df064573c29df9d82a5c801fa92248604c95f65dc83d'
'SKIP'
)
prepare() {
cd xset-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd xset-$pkgver
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
	'--without-xf86misc'
	'--without-fontcache'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd xset-$pkgver
make -k check
}
package() {
cd xset-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/xorg-xset/LICENSE
}
