pkgname=('libxkbfile')
pkgver=1.1.0
pkgrel=1
pkgdesc='X11 keyboard file manipulation library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libx11'
)
makedepends=('xorg-util-macros')
source=(
"https://xorg.freedesktop.org/releases/individual/lib/$pkgname-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/$pkgname-$pkgver.tar.bz2.sig"
)
sha512sums=(
'1c6a57564e916ccdc3df3c49b9f3589f701df0cec55112c12ddc35ac3ed556608c28fe98e5ba0ac1962e9a65ed1e90eb7e6169b564951bf55a7cf3499b745826'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxkbfile/COPYING
}
