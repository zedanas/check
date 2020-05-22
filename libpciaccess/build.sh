pkgname=('libpciaccess')
pkgver=0.16
pkgrel=1
pkgdesc='X11 PCI access library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'zlib'
)
makedepends=('xorg-util-macros')
source=(
"https://xorg.freedesktop.org/releases/individual/lib/$pkgname-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/$pkgname-$pkgver.tar.bz2.sig"
)
sha512sums=(
'2f250048a270dfc0823d4bdd613aa272c58a80eaafd922850f56c4b6f7a45a263ed4cf521b52b49f04484ea44ebefb7407d079aa058318a5751ffb181e38fed1'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname-$pkgver
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
	'--with-zlib'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libpciaccess/COPYING
}
