pkgname='libuv'
pkgver=1.35.0
pkgrel=1
pkgdesc='Multi-platform support library with a focus on asynchronous I/O'
url='https://github.com/libuv/libuv'
license=('custom')
arch=('x86_64')
depends=('glibc')
makedepends=('python-sphinx')
source=("https://github.com/$pkgname/$pkgname/archive/v$pkgver/$pkgname-$pkgver.tar.gz")
sha512sums=('a05bfd7cab6ae74022e7120a48772a6594522fb5bc467c8c05eb4809d7c78b68fa4843d86e2e34a68d439767a27dbc49f3b1dcbc8df85bec64471c1b459989c3')
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
install -Dm644 LICENSE $pkgdir/usr/share/licenses/libuv/LICENSE
}
