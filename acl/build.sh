pkgname=('acl')
pkgver=2.2.53
pkgrel=2
pkgdesc='Access control list utilities, libraries and headers'
url='https://savannah.nongnu.org/projects/acl'
license=('LGPL')
arch=('x86_64')
depends=(
'attr'
'glibc'
)
makedepends=('gettext')
provides=('xfsacl')
conflicts=('xfsacl')
replaces=('xfsacl')
source=(
"https://download.savannah.gnu.org/releases/$pkgname/$pkgname-$pkgver.tar.gz"
"https://download.savannah.gnu.org/releases/$pkgname/$pkgname-$pkgver.tar.gz.sig"
)
sha256sums=(
'06be9865c6f418d851ff4494e12406568353b891ffe1f596b34693c387af26c7'
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
	'--disable-debug'
)
export CFLAGS+=' -fno-lto'
export CXXFLAGS+=' -fno-lto'
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
}
