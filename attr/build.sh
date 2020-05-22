pkgname=('attr')
pkgoname=('attr')
pkgver=2.4.48
pkgrel=2
pkgdesc='Extended attribute support library for ACL support'
url='https://savannah.nongnu.org/projects/attr'
license=('LGPL')
arch=('x86_64')
depends=('glibc')
makedepends=('gettext')
provides=('xfsattr')
conflicts=('xfsattr')
replaces=('xfsattr')
backup=('etc/xattr.conf')
source=(
"https://download.savannah.gnu.org/releases/$pkgoname/$pkgoname-$pkgver.tar.gz"
"https://download.savannah.gnu.org/releases/$pkgoname/$pkgoname-$pkgver.tar.gz.sig"
)
sha256sums=(
'5ead72b358ec709ed00bbf7a9eaef1654baad937c001c044fe8b74c57f5324e7'
'SKIP'
)
prepare() {
cd $pkgoname-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgoname-$pkgver
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
	'--disable-debug'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgoname-$pkgver
make DESTDIR=$pkgdir install
}
