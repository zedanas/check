pkgname='xorg-iceauth'
pkgver=1.0.8
pkgrel=1
pkgdesc='ICE authority file utility'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
groups=('xorg-apps' 'xorg')
depends=(
'glibc'
'libice'
)
makedepends=(
'xorg-util-macros'
'xorgproto'
)
source=(
"https://xorg.freedesktop.org/archive/individual/app/iceauth-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/archive/individual/app/iceauth-$pkgver.tar.bz2.sig"
)
sha512sums=(
'9d4520adf951b16a3e784349dbb70d5d8176b74b956f8adc63abf55d049745c113b03ccfa60a281fc39b487db3742302dc6287c9985ce83a0157bf4674df2af1'
'SKIP'
)
prepare() {
cd iceauth-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd iceauth-$pkgver
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
cd iceauth-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/xorg-iceauth/COPYING
}
