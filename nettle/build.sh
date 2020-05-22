pkgname='nettle'
pkgver=3.5.1
pkgrel=2
pkgdesc='A low-level cryptographic library'
url='https://www.lysator.liu.se/~nisse/nettle'
license=('GPL2')
arch=('x86_64')
depends=(
'glibc'
'gmp'
)
checkdepends=('valgrind')
source=(
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.gz"
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.gz.sig"
)
sha256sums=(
'75cca1998761b02e16f2db56da52992aef622bf55a3b45ec538bc2eedadc9419'
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
	'--disable-fat'
	'--disable-documentation'
	'--enable-public-key'
	'--enable-assembler'
	'--enable-openssl'
	'--enable-x86-aesni'
	'--disable-x86-sha-ni'
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
}
