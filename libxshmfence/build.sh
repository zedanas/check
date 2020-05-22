pkgname=('libxshmfence')
pkgver=1.3
pkgrel=1
pkgdesc='A library that exposes a event API on top of Linux futexes'
url='https://xorg.freedesktop.org/'
license=('GPL')
arch=('x86_64')
depends=('glibc')
makedepends=(
'xorg-util-macros'
'xorgproto'
)
source=(
"https://xorg.freedesktop.org/releases/individual/lib/$pkgname-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/$pkgname-$pkgver.tar.bz2.sig"
)
sha512sums=(
'c446e055f8fac62b9aa266132289a4cfc030282147974c45ce96d1768a98d1afb997470e58e4a68513174c404cbf373bdde2f0cd4b34abdbce1d89dd0b6fe2b7'
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
	'--disable-static'
	'--enable-futex'
	'--enable-visibility'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname-$pkgver
make -k check
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxshmfence/COPYING
}
