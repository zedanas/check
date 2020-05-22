pkgname=('xorg-xmodmap')
pkgver=1.0.10
pkgrel=1
pkgdesc='Utility for modifying keymaps and button mappings'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
groups=('xorg-apps' 'xorg')
depends=(
'glibc'
'libx11'
)
makedepends=('xorg-util-macros')
source=(
"https://xorg.freedesktop.org/archive/individual/app/xmodmap-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/archive/individual/app/xmodmap-$pkgver.tar.bz2.sig"
)
sha512sums=(
'324c7dcef843186088f16b3bc47485eb3c9b4331e56ce43b692deb4bb3d4f4f27512480e91a379cceac8383df920dc5e37cd825246b50b6343291cec48134c04'
'SKIP'
)
prepare() {
cd xmodmap-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd xmodmap-$pkgver
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
cd xmodmap-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/xorg-xmodmap/COPYING
}
