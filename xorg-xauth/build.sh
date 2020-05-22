pkgname=('xorg-xauth')
pkgver=1.1
pkgrel=1
pkgdesc='X.Org authorization settings program'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
groups=('xorg' 'xorg-apps')
depends=(
'glibc'
'libx11'
'libxau'
'libxext'
'libxmu'
)
makedepends=('xorg-util-macros')
source=(
"https://xorg.freedesktop.org/releases/individual/app/xauth-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/app/xauth-$pkgver.tar.bz2.sig"
)
sha512sums=(
'b6ecd59a853a491ef45bf8cfbff63bed36645f81cb79ae9d18458b57f7502bccf92f0d979d3337578518646f680ad379e67b1dac15a927cbb11372733e7a3a0c'
'SKIP'
)
prepare() {
cd xauth-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd xauth-$pkgver
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
	'--disable-ipv6'
	'--disable-tcp-transport'
	'--enable-unix-transport'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd xauth-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/xorg-xauth/COPYING
}
