pkgname=('libmnl')
pkgver=1.0.4
pkgrel=3
pkgdesc='Minimalistic user-space library oriented to Netlink developers.'
url='https://www.netfilter.org/projects/libmnl/'
license=('LGPL2.1')
arch=('x86_64')
depends=('glibc')
source=(
"https://www.netfilter.org/projects/$pkgname/files/$pkgname-$pkgver.tar.bz2"
"https://www.netfilter.org/projects/$pkgname/files/$pkgname-$pkgver.tar.bz2.sig"
)
sha1sums=(
'2db40dea612e88c62fd321906be40ab5f8f1685a'
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
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
}
