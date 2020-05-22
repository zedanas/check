pkgname=('mtdev')
pkgver=1.1.6
pkgrel=1
pkgdesc='A stand-alone library which transforms all variants of kernel MT events to the slotted type B protocol'
url='https://bitmath.org/code/mtdev/'
license=('custom:MIT')
arch=('x86_64')
depends=('glibc')
source=("http://bitmath.org/code/$pkgname/$pkgname-$pkgver.tar.bz2")
sha512sums=('859fb0803f330ecaae69f80713ff5a5235c0cb00de6d5ac2717ad82cea856a92b866f0c272ecfe743186abcf925f95585149ba4828b4c91555cfeb2f2a1c98f1')
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/mtdev/LICENSE
}
