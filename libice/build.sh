pkgname='libice'
pkgver=1.0.10
pkgrel=2
pkgdesc='X11 Inter-Client Exchange library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=('glibc')
makedepends=(
'xorg-util-macros'
'xorgproto'
'xtrans>=1.2.5'
)
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libICE-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libICE-$pkgver.tar.bz2.sig"
)
sha512sums=(
'2f1ef2c32c833c71894a08fa7e7ed53f301f6c7bd22485d71c12884d8e8b36b99f362ec886349dcc84d08edc81c8b2cea035320831d64974edeba021b433c468'
'SKIP'
)
prepare() {
cd libICE-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libICE-$pkgver
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
	'--enable-docs'
	'--enable-specs'
	'--enable-unix-transport'
	'--disable-tcp-transport'
	'--disable-ipv6'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd libICE-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libice/COPYING
}
