pkgname=('libnfnetlink')
pkgver=1.0.1
pkgrel=3
pkgdesc='Low-level library for netfilter related kernel/userspace communication'
url='https://www.netfilter.org/projects/libnfnetlink/'
license=('GPL')
arch=('x86_64')
depends=('glibc')
source=(
"https://www.netfilter.org/projects/$pkgname/files/$pkgname-$pkgver.tar.bz2"
"https://www.netfilter.org/projects/$pkgname/files/$pkgname-$pkgver.tar.bz2.sig"
)
sha512sums=(
'2ec2cd389c04e21c8a02fb3f6d6f326fc33ca9589577f1739c23d883fe2ee9feaa16e83b6ed09063ad886432e49565dc3256277d035260aca5aab17954b46104'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/libnfnetlink/COPYING
}
