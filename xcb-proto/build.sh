pkgname=('xcb-proto')
pkgver=1.14
pkgrel=1
pkgdesc='XML-XCB protocol descriptions'
url='https://xcb.freedesktop.org/'
license=('custom')
arch=('any')
makedepends=(
'libxml2'
'python'
)
source=(
"https://xorg.freedesktop.org/archive/individual/proto/$pkgname-$pkgver.tar.xz"
"https://xorg.freedesktop.org/archive/individual/proto/$pkgname-$pkgver.tar.xz.sig"
)
sha512sums=(
'de66d568163b6da2be9d6c59984f3afa3acd119a781378638045fd68018665ef5c9af98f024e9962ba3eb7c7a4d85c27ba70ffafceb2324ccc6940f34de16690'
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
check() {
cd $pkgname-$pkgver
make -k check
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/xcb-proto/COPYING
}
