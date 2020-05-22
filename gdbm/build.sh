pkgname=('gdbm')
pkgver=1.18.1
pkgrel=3
pkgdesc='GNU database library'
url='https://www.gnu.org/software/gdbm/gdbm.html'
license=('GPL3')
arch=('x86_64')
depends=(
'glibc'
'readline'
'sh'
)
source=(
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.gz"
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.gz.sig"
)
md5sums=(
'988dc82182121c7570e0cb8b4fcd5415'
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
	'--enable-memory-mapped-io'
	'--enable-libgdbm-compat'
	'--enable-gdbm-export'
	'--with-readline'
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
mkdir -p $pkgdir/usr/include/gdbm
ln -sf ../gdbm.h $pkgdir/usr/include/gdbm/gdbm.h
ln -sf ../ndbm.h $pkgdir/usr/include/gdbm/ndbm.h
ln -sf ../dbm.h  $pkgdir/usr/include/gdbm/dbm.h
}
