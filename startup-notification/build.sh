pkgname=('startup-notification')
pkgver=0.12
pkgrel=6
pkgdesc='Monitor and display application startup'
url='https://www.freedesktop.org'
license=('LGPL')
arch=('x86_64')
depends=(
'glibc'
'libx11'
'libxcb'
'xcb-util'
)
source=("https://www.freedesktop.org/software/$pkgname/releases/$pkgname-$pkgver.tar.gz")
sha256sums=('3c391f7e930c583095045cd2d10eb73a64f085c7fde9d260f2652c7cb3cfbe4a')
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
	'--with-x'
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
