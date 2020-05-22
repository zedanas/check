pkgname=('libusb')
pkgver=1.0.23
pkgrel=2
pkgdesc='Library that provides generic access to USB devices'
url='https://libusb.info/'
license=('LGPL')
arch=('x86_64')
depends=(
'glibc'
'systemd-libs'
)
makedepends=('systemd')
provides=(
"libusbx=$pkgver"
'libusb-1.0.so'
)
conflicts=('libusbx')
replaces=(
'libusb1'
'libusbx'
)
source=("https://github.com/$pkgname/$pkgname/releases/download/v$pkgver/$pkgname-$pkgver.tar.bz2")
md5sums=('1e29700f6a134766d32b36b8d1d61a95')
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
	'--disable-log'
	'--disable-debug-log'
	'--disable-system-log'
	'--disable-examples-build'
	'--disable-tests-build'
	'--enable-timerfd'
	'--enable-udev'
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
