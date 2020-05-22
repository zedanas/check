pkgname=('gzip')
pkgver=1.10
pkgrel=3
pkgdesc='GNU compression utility'
url='https://www.gnu.org/software/gzip/'
license=('GPL3')
arch=('x86_64')
groups=('base-devel')
depends=(
'bash'
'glibc'
'grep'
'less'
'sh'
)
source=(
"https://ftp.gnu.org/pub/gnu/$pkgname/$pkgname-$pkgver.tar.xz"
"https://ftp.gnu.org/pub/gnu/$pkgname/$pkgname-$pkgver.tar.xz.sig"
)
md5sums=(
'691b1221694c3394f1c537df4eee39d3'
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
