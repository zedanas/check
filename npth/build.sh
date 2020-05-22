pkgname=('npth')
pkgver=1.6
pkgrel=2
pkgdesc='New portable threads library'
url='https://git.gnupg.org/cgi-bin/gitweb.cgi?p=npth.git'
license=('LGPL')
arch=('x86_64')
depends=(
'glibc'
'sh'
)
source=(
"ftp://ftp.gnupg.org/gcrypt/$pkgname/$pkgname-$pkgver.tar.bz2"
"ftp://ftp.gnupg.org/gcrypt/$pkgname/$pkgname-$pkgver.tar.bz2.sig"
)
sha256sums=(
'1393abd9adcf0762d34798dc34fdcf4d0d22a8410721e76f1e3afcd1daa4e2d1'
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
	'--enable-tests'
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
