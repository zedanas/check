pkgname=('libevdev')
pkgver=1.9.0
pkgrel=1
pkgdesc="Wrapper library for evdev devices"
url='https://www.freedesktop.org/wiki/Software/libevdev/'
license=('custom:X11')
arch=('x86_64')
depends=('glibc')
makedepends=(
'check'
'doxygen'
'python2'
'valgrind'
)
source=(
"https://freedesktop.org/software/$pkgname/$pkgname-$pkgver.tar.xz"
"https://freedesktop.org/software/$pkgname/$pkgname-$pkgver.tar.xz.sig"
)
sha512sums=(
'6e7589b5776437ac23fbf65b3194fb1dd3a68a294696145060cdd97bcdeb9b04f355f2be028dc1a5efe98ef2cafca15e4f61115edf5d62591e3a8944dc95942a'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/libevdev/COPYING
}
