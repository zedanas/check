pkgname=('libmpc')
pkgver=1.1.0
pkgrel=2
pkgdesc='Library for the arithmetic of complex numbers with arbitrarily high precision'
url='http://www.multiprecision.org/'
license=('LGPL')
arch=('x86_64')
depends=(
'glibc'
'gmp'
'mpfr'
)
source=(
"https://ftp.gnu.org/gnu/mpc/mpc-$pkgver.tar.gz"
"https://ftp.gnu.org/gnu/mpc/mpc-$pkgver.tar.gz.sig"
)
md5sums=(
'4125404e41e482ec68282a2e687f6c73'
'SKIP'
)
prepare() {
cd mpc-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd mpc-$pkgver
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
	'--disable-logging'
	'--disable-valgrind-tests'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd mpc-$pkgver
make -k check
}
package() {
cd mpc-$pkgver
make DESTDIR=$pkgdir install
mv $pkgdir/usr/share/info/mpc.info $pkgdir/usr/share/info/libmpc.info
}
