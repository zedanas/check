pkgname=('xf86-input-evdev')
pkgver=2.10.6
pkgrel=1
pkgdesc='X.org evdev input driver'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
groups=('xorg-drivers')
depends=(
'glibc'
'libevdev'
'mtdev'
'systemd-libs'
)
makedepends=(
'X-ABI-XINPUT_VERSION=24.1'
'xorg-server-devel'
'xorgproto'
)
conflicts=(
'X-ABI-XINPUT_VERSION<24.1'
'X-ABI-XINPUT_VERSION>=25'
'xorg-server<1.19.0'
)
source=(
"https://xorg.freedesktop.org/releases/individual/driver/$pkgname-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/driver/$pkgname-$pkgver.tar.bz2.sig"
)
sha512sums=(
'560b0a6491d50a46913a5890a35c0367e59f550670993493bd9712d712a9747ddaa6fe5086daabf2fcafa24b0159383787eb273da4a2a60c089bfc0a77ad2ad1'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/xf86-input-evdev/COPYING
}
