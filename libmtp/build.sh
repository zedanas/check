pkgname=('libmtp')
pkgver=1.1.17
pkgrel=1
pkgdesc='Library implementation of the Media Transfer Protocol'
url='http://libmtp.sourceforge.net'
license=('LGPL')
arch=('x86_64')
depends=(
'glibc'
'libgcrypt'
'libusb'
)
makedepends=('doxygen')
source=(
"https://downloads.sourceforge.net/$pkgname/$pkgname-$pkgver.tar.gz"
"https://downloads.sourceforge.net/$pkgname/$pkgname-$pkgver.tar.gz.asc"
)
sha256sums=(
'f8a34cf52d9f9b9cb8c7f26b12da347d4af7eb904c13189602e4c6b62d1a79dc'
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
	'--enable-doxygen'
	'--enable-mtpz'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/libmtp/LICENSE
}
