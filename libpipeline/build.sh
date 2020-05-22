pkgname=('libpipeline')
pkgver=1.5.2
pkgrel=1
pkgdesc='A C library for manipulating pipelines of subprocesses in a flexible and convenient way'
url='https://nongnu.org/libpipeline/'
license=('GPL')
arch=('x86_64')
depends=('glibc')
source=(
"https://download.savannah.gnu.org/releases/$pkgname/$pkgname-$pkgver.tar.gz"
"https://download.savannah.gnu.org/releases/$pkgname/$pkgname-$pkgver.tar.gz.asc"
)
sha256sums=(
'fd59c649c1ae9d67604d1644f116ad4d297eaa66f838e3dfab96b41e85b059fb'
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
