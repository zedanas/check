pkgname=('nspr')
pkgver=4.25
pkgrel=1
pkgdesc='Netscape Portable Runtime'
url='https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSPR'
license=('MPL' 'GPL')
arch=('x86_64')
depends=(
'glibc'
'sh'
)
makedepends=('zip')
source=("https://ftp.mozilla.org/pub/mozilla.org/$pkgname/releases/v$pkgver/src/$pkgname-$pkgver.tar.gz")
sha256sums=('0bc309be21f91da4474c56df90415101c7f0c7c7cab2943cd943cd7896985256')
prepare() {
cd $pkgname-$pkgver/$pkgname
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname-$pkgver/$pkgname
config_opts=(
	'--prefix=/usr'
	'--bindir=/usr/bin'
	'--sbindir=/usr/bin'
	'--libdir=/usr/lib'
	'--libexecdir=/usr/lib'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--disable-debug'
	'--disable-debug-symbols'
	'--enable-optimize'
	'--enable-mdupdate'
	'--disable-cplus'
	'--enable-strip'
	'--enable-ipv6'
	'--enable-64bit'
	'--disable-x32'
	'--with-pthreads'
	'--with-mozilla'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname-$pkgver/$pkgname
make DESTDIR=$pkgdir install
ln -s nspr.pc $pkgdir/usr/lib/pkgconfig/mozilla-nspr.pc
rm -f $pkgdir/usr/bin/{compile-et.pl,prerr.properties}
rm -fr $pkgdir/usr/include/nspr/md
}
