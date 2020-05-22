pkgname=('libxdamage')
pkgver=1.1.5
pkgrel=2
pkgdesc='X11 damaged region extension library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libx11'
'libxfixes'
)
makedepends=(
'pkgconfig'
'xorgproto'
)
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXdamage-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXdamage-$pkgver.tar.bz2.sig"
)
sha512sums=(
'a3ca6cc33b1727f717a3e2aa5593f660508a81a47918a0aa949e9e8fba105e303fe5071983b48caac92feea0fe6e8e01620805e4d19b41f21f20d837b191c124'
'SKIP'
)
prepare() {
cd libXdamage-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXdamage-$pkgver
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
cd libXdamage-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxdamage/COPYING
}
