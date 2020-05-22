pkgname=('xorg-xkbcomp')
pkgver=1.4.3
pkgrel=1
pkgdesc='X Keyboard description compiler'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
groups=('xorg-apps' 'xorg')
depends=(
'glibc'
'libx11'
'libxkbfile'
)
makedepends=(
'git'
'xorg-util-macros'
)
source=(
"https://xorg.freedesktop.org/releases/individual/app/xkbcomp-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/app/xkbcomp-$pkgver.tar.bz2.sig"
)
sha512sums=(
'827713c0413aecdcad2b61edb7b8c7c7a002e18505b9041f570e2f680907193cb5ff8a5b424695e21110b2d06c145cbf0e397e52347421ee946f06e2a51f135d'
'SKIP'
)
prepare() {
cd xkbcomp-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd xkbcomp-$pkgver
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
cd xkbcomp-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/xorg-xkbcomp/COPYING
}
