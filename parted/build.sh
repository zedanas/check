pkgname=('parted')
pkgver=3.3
pkgrel=1
pkgdesc='A program for creating, destroying, resizing, checking and copying partitions'
url='https://www.gnu.org/software/parted/parted.html'
license=('GPL3')
arch=('x86_64')
depends=(
'device-mapper'
'glibc'
'libutil-linux'
'ncurses'
'readline'
)
makedepends=('pkg-config')
source=(
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.xz"
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.xz.sig"
)
sha256sums=(
'57e2b4bd87018625c515421d4524f6e3b55175b472302056391c5f7eccb83d44'
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
	'--disable-debug'
	'--disable-assert'
	'--disable-discover-only'
	'--disable-read-only'
	'--enable-dynamic-loading'
	'--enable-pc98'
	'--enable-threads=posix'
	'--without-included-regex'
	'--enable-device-mapper'
	'--with-readline'
	'--disable-selinux'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/parted/LICENSE
}
