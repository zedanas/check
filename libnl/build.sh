pkgname=('libnl')
pkgver=3.5.0
pkgrel=2
pkgdesc='Library for applications dealing with netlink sockets'
url='https://github.com/thom311/libnl/'
license=('GPL')
arch=('x86_64')
depends=('glibc')
backup=(
'etc/libnl/classid'
'etc/libnl/pktloc'
)
source=(
"https://github.com/thom311/$pkgname/releases/download/${pkgname}${pkgver//./_}/$pkgname-$pkgver.tar.gz"
"https://github.com/thom311/$pkgname/releases/download/${pkgname}${pkgver//./_}/$pkgname-$pkgver.tar.gz.sig"
)
sha256sums=(
'352133ec9545da76f77e70ccb48c9d7e5324d67f6474744647a7ed382b5e05fa'
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
	'--enable-pthreads'
	'--enable-cli=yes'
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
