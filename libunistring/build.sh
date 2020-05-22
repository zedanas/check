pkgname=('libunistring')
pkgver=0.9.10
pkgrel=2
pkgdesc='Library for manipulating Unicode strings and C strings'
url='https://www.gnu.org/software/libunistring/'
license=('GPL')
arch=('x86_64')
depends=('glibc')
source=(
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.xz"
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.xz.sig"
)
md5sums=(
'db08bb384e81968957f997ec9808926e'
'SKIP'
)
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
	'--disable-static'
	'--enable-relocatable'
	'--enable-namespacing'
	'--enable-threads=posix'
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
