pkgname=('libexif')
pkgver=0.6.21
pkgrel=3
pkgdesc='A library to parse an EXIF file and read the data from those tags'
url='https://sourceforge.net/projects/libexif'
license=('LGPL')
arch=('x86_64')
depends=('glibc')
source=("https://downloads.sourceforge.net/sourceforge/$pkgname/$pkgname-$pkgver.tar.bz2")
sha256sums=('16cdaeb62eb3e6dfab2435f7d7bccd2f37438d21c5218ec4e58efa9157d4d41a')
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
	'--enable-docs'
	'--disable-internal-docs'
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
