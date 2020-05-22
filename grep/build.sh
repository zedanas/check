pkgname=('grep')
pkgver=3.4
pkgrel=1
pkgdesc='A string search utility'
url='https://www.gnu.org/software/grep/'
license=('GPL3')
arch=('x86_64')
groups=('base-devel')
depends=(
'bash'
'glibc'
'pcre'
)
makedepends=('texinfo')
source=(
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.xz"
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.xz.sig"
)
sha256sums=(
'58e6751c41a7c25bfc6e9363a41786cff3ba5709cf11d5ad903cf7cce31cc3fb'
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
	'--disable-assert'
	'--enable-threads=posix'
	'--without-included-regex'
	'--enable-perl-regexp'
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
