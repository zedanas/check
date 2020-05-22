pkgname=('isl')
pkgver=0.22.1
pkgrel=1
pkgdesc='Library for manipulating sets and relations of integer points bounded by linear constraints'
url='http://isl.gforge.inria.fr/'
license=('MIT')
arch=('x86_64')
depends=(
'glibc'
'gmp'
)
conflicts=(
'isl-git'
'isl14'
'isl15'
'isl16'
'isl17'
'isl19'
)
source=("http://isl.gforge.inria.fr/isl-$pkgver.tar.gz")
sha256sums=('f9663ced2c1e6d6737da7255d64d5faee61a4f763538b39c8f50da953fdc0b99')
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
	'--with-int=gmp'
	'--with-gmp=system'
	'--with-clang=no'
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
mkdir -p $pkgdir/usr/share/gdb/auto-load/usr/lib/
mv $pkgdir/usr/lib/libisl.so.*-gdb.py $pkgdir/usr/share/gdb/auto-load/usr/lib/
install -Dm644 LICENSE $pkgdir/usr/share/licenses/isl/LICENSE
}
