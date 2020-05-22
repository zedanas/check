pkgname=('xf86-input-libinput')
pkgver=0.29.0
pkgrel=2
pkgdesc='Generic input driver for the X.Org server based on libinput'
url='http://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
groups=('xorg-drivers')
depends=(
'glibc'
'libinput>=1.2.0'
)
makedepends=(
'X-ABI-XINPUT_VERSION=24.1'
'libx11'
'libxi'
'xorg-server-devel'
'xorgproto'
)
conflicts=(
'X-ABI-XINPUT_VERSION<24'
'X-ABI-XINPUT_VERSION>=25'
'xorg-server<1.19.0'
)
source=(
"https://xorg.freedesktop.org/releases/individual/driver/$pkgname-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/driver/$pkgname-$pkgver.tar.bz2.sig"
)
sha512sums=(
'f19ef2e9e0c1336d8e0b17853e1fe0c66ecf50e7b10b10b6c5cbafc99323694597821e15e8e358419ef3c68d1009967fd2ec3760800c85adbb71ac3ecc99954b'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/xf86-input-libinput/COPYING
}
