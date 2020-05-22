pkgname=('ethtool')
pkgver=5.4
pkgrel=1
epoch=1
pkgdesc='Utility for controlling network drivers and hardware'
url='https://www.kernel.org/pub/software/network/ethtool/'
license=('GPL')
arch=('x86_64')
depends=('glibc')
source=(
"https://www.kernel.org/pub/software/network/$pkgname/$pkgname-$pkgver.tar.xz"
"https://www.kernel.org/pub/software/network/$pkgname/$pkgname-$pkgver.tar.sign"
)
sha1sums=(
'67113d5adf08ec0cb2a3cb3b5de63280de6f7f3b'
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
	'--enable-pretty-dump'
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
install -Dm644 LICENSE $pkgdir/usr/share/licenses/ethtool/LICENSE
}
