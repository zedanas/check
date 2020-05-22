pkgname=('pkcs11-helper')
pkgver=1.26.0
pkgrel=1
pkgdesc='A library that simplifies the interaction with PKCS11 providers for end-user applications using a simple API and optional OpenSSL engine'
url='https://github.com/OpenSC/pkcs11-helper'
license=('GPL' 'BSD')
arch=('x86_64')
depends=(
'glibc'
'gnutls'
'nss'
'openssl'
)
makedepends=('doxygen')
source=("https://github.com/OpenSC/$pkgname/releases/download/$pkgname-${pkgver%.0}/$pkgname-$pkgver.tar.bz2")
sha256sums=('e886ec3ad17667a3694b11a71317c584839562f74b29c609d54c002973b387be')
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
	'--disable-tests'
	'--enable-doc'
	'--enable-threading'
	'--enable-token'
	'--enable-data'
	'--enable-certificate'
	'--enable-slotevent'
	'--enable-crypto-engine-gnutls'
	'--enable-crypto-engine-mbedtls'
	'--enable-crypto-engine-nss'
	'--enable-openssl'
	'--enable-crypto-engine-openssl'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/pkcs11-helper/LICENSE
}
