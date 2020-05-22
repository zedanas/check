pkgname=('libffi')
pkgver=3.2.1
pkgrel=4
pkgdesc='Portable foreign function interface library'
url='https://sourceware.org/libffi/'
license=('MIT')
arch=('x86_64')
depends=('glibc')
checkdepends=('dejagnu')
source=("ftp://sourceware.org/pub/$pkgname/$pkgname-$pkgver.tar.gz")
sha1sums=('280c265b789e041c02e5c97815793dfc283fb1e6')
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
	'--enable-pax_emutramp'
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
install -Dm644 LICENSE $pkgdir/usr/share/licenses/libffi/LICENSE
}
