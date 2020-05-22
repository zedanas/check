pkgname=('lzo')
pkgver=2.10
pkgrel=3
pkgdesc='Portable lossless data compression library'
url='https://www.oberhumer.com/opensource/lzo'
license=('GPL')
arch=('x86_64')
depends=('glibc')
source=("http://www.oberhumer.com/opensource/$pkgname/download/$pkgname-$pkgver.tar.gz")
sha1sums=('4924676a9bae5db58ef129dc1cebce3baa3c4b5d')
prepare() {
cd lzo-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd lzo-$pkgver
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
	'--enable-asm'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
gcc $CFLAGS -fpic -Iinclude/lzo -o minilzo/minilzo.o -c minilzo/minilzo.c
gcc $LDFLAGS -shared -o libminilzo.so.0 -Wl,-soname,libminilzo.so.0 minilzo/minilzo.o
}
check() {
cd lzo-$pkgver
make -k check
make -k test
}
package() {
cd lzo-$pkgver
make DESTDIR=$pkgdir install
install -m 755 libminilzo.so.0 $pkgdir/usr/lib
install -p -m 644 minilzo/minilzo.h $pkgdir/usr/include/lzo
cd $pkgdir/usr/lib && ln -s libminilzo.so.0 libminilzo.so
}
