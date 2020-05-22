pkgname=('xorg-setxkbmap')
pkgver=1.3.2
pkgrel=1
pkgdesc='Set the keyboard using the X Keyboard Extension'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
groups=('xorg' 'xorg-apps')
depends=(
'glibc'
'libx11'
'libxkbfile'
)
makedepends=('xorg-util-macros')
source=(
"http://xorg.freedesktop.org/releases/individual/app/setxkbmap-$pkgver.tar.bz2"
"http://xorg.freedesktop.org/releases/individual/app/setxkbmap-$pkgver.tar.bz2.sig"
)
sha512sums=(
'bfa8015dee0d8d3fdbbd89afbd71c8606ce168d6edca8521d5ed05a00fecbea39bc4bfcce84b71458bdeb34c60bd80a5df27e0691ccee3966443ecdc937faf38'
'SKIP'
)
prepare() {
cd setxkbmap-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd setxkbmap-$pkgver
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
cd setxkbmap-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/xorg-setxkbmap/COPYING
}
