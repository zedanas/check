pkgname=('libid3tag')
pkgver=0.15.1b
pkgrel=9
pkgdesc='Library for id3 tagging'
url='https://www.underbit.com/products/mad/'
license=('GPL')
arch=('x86_64')
depends=(
'glibc'
'zlib'
)
makedepends=('gperf')
source=(
"ftp://ftp.mars.org/pub/mpeg/${pkgname}-${pkgver}.tar.gz"
'id3tag.pc'
'10_utf16.diff'
'11_unknown_encoding.diff'
'CVE-2008-2109.patch'
'libid3tag-gperf.patch'
)
md5sums=(
'e5808ad997ba32c498803822078748c3'
'8bb41fd814fafcc37ec8bc88f5545a4a'
'4f9df4011e6a8c23240fff5de2d05f6e'
'3ca856b97924d48a0fdfeff0bd83ce7d'
'c51822ea6301b1ca469975f0c9ee8e34'
'85502349069e61eaeea4610b1ea6cb56'
)
prepare() {
cd $pkgname-$pkgver
patch -p1 -i $srcdir/10_utf16.diff
patch -p1 -i $srcdir/11_unknown_encoding.diff
patch -Np0 -i $srcdir/CVE-2008-2109.patch
patch -p1 -i $srcdir/libid3tag-gperf.patch
rm compat.c frametype.c
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
	'--disable-debugging'
	'--disable-profiling'
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
install -Dm644 $srcdir/id3tag.pc $pkgdir/usr/lib/pkgconfig/id3tag.pc
}
