pkgname=('usbutils')
pkgver=012
pkgrel=2
pkgdesc='USB Device Utilities'
url='http://linux-usb.sourceforge.net/'
license=('GPL')
arch=('x86_64')
groups=('base')
depends=(
'glibc'
'hwids'
'libusb'
'sh'
'systemd-libs'
)
optdepends=(
'python: for lsusb.py usage'
'coreutils: for lsusb.py usage'
)
source=(
"https://www.kernel.org/pub/linux/utils/usb/$pkgname/$pkgname-$pkgver.tar.xz"
"https://www.kernel.org/pub/linux/utils/usb/$pkgname/$pkgname-$pkgver.tar.sign"
)
md5sums=(
'0da98eb80159071fdbb00905390509d9'
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
