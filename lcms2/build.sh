pkgname=('lcms2')
pkgver=2.9
pkgrel=2
pkgdesc='Small-footprint color management engine, version 2'
url='http://www.littlecms.com'
license=('MIT')
arch=('x86_64')
depends=(
'glibc'
'libjpeg'
'libtiff'
'zlib'
)
source=("https://downloads.sourceforge.net/sourceforge/lcms/$pkgname-$pkgver.tar.gz")
sha256sums=('48c6fdf98396fa245ed86e622028caf49b96fa22f3e5734f853f806fbc8e7d20')
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
	'--with-threads'
	'--with-jpeg'
	'--with-tiff'
	'--with-zlib'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/lcms2/LICENSE
}
