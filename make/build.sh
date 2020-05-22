pkgname=('make')
pkgver=4.3
pkgrel=1
pkgdesc='GNU make utility to maintain groups of programs'
url='https://www.gnu.org/software/make'
license=('GPL3')
arch=('x86_64')
groups=('base-devel')
depends=(
'glibc'
)
source=(
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.lz"
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.lz.sig"
)
md5sums=(
'd5c40e7bd1e97a7404f5d3be982f479a'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
autoreconf -fi
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
	'--disable-case-insensitive-file-system'
	'--enable-job-server'
	'--enable-posix-spawn'
	'--enable-load'
	'--without-guile'
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
