pkgname=('libxext')
pkgver=1.3.4
pkgrel=2
pkgdesc='X11 miscellaneous extensions library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libx11'
)
makedepends=(
'xorg-util-macros'
'xorgproto'
)
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXext-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXext-$pkgver.tar.bz2.sig"
)
sha512sums=(
'09146397d95f80c04701be1cc0a9c580ab5a085842ac31d17dfb6d4c2e42b4253b89cba695e54444e520be359883a76ffd02f42484c9e2ba2c33a5a40c29df4a'
'SKIP'
)
prepare() {
cd libXext-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXext-$pkgver
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
	'--enable-specs'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd libXext-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxext/COPYING
}
