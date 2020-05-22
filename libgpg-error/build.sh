pkgname=('libgpg-error')
pkgver=1.37
pkgrel=1
pkgdesc='Support library for libgcrypt'
url='https://www.gnupg.org'
license=('LGPL')
arch=('x86_64')
depends=(
'glibc'
'readline'
'sh'
)
source=(
"ftp://ftp.gnupg.org/gcrypt/$pkgname/$pkgname-$pkgver.tar.bz2"
"ftp://ftp.gnupg.org/gcrypt/$pkgname/$pkgname-$pkgver.tar.bz2.sig"
)
sha1sums=(
'6dff83371e0c03fe9ba468cc23d528a8c247785a'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
autoreconf -fi
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
	'--enable-doc'
	'--enable-tests'
	'--enable-languages'
	'--enable-threads=posix'
	'--with-readline'
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
