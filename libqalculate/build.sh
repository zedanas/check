pkgname=('libqalculate')
pkgver=3.8.0
pkgrel=1
pkgdesc='Multi-purpose desktop calculator'
url='https://qalculate.github.io/'
license=('GPL')
arch=('x86_64')
depends=(
'curl'
'gcc-libs'
'glibc'
'gmp'
'icu'
'libxml2'
'mpfr'
'readline'
)
makedepends=(
'doxygen'
'intltool'
)
optdepends=('gnuplot: for plotting support')
source=("https://github.com/Qalculate/$pkgname/releases/download/v$pkgver/$pkgname-$pkgver.tar.gz")
sha256sums=('d8fcf445677ced76c13db5bd31af96f069f83041a264ac4df0d065af47b2e1ae')
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
	'--disable-tests'
	'--disable-defs2doc'
	'--enable-textport'
	'--with-libcurl'
	'--with-icu'
	'--with-readline'
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
