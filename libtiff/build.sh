pkgname=('libtiff')
pkgver=4.1.0
pkgrel=1
pkgdesc='Library for manipulation of TIFF images'
url='http://www.simplesystems.org/libtiff/'
license=('custom')
arch=('x86_64')
depends=(
'freeglut'
'gcc-libs'
'glibc'
'libglvnd'
'libjpeg'
'libwebp'
'xz'
'zlib'
'zstd'
)
makedepends=(
'glu'
'jbigkit'
'mesa'
)
source=(
"https://download.osgeo.org/$pkgname/tiff-$pkgver.tar.gz"
"https://download.osgeo.org/$pkgname/tiff-$pkgver.tar.gz.sig"
)
sha256sums=(
'5d29f32517dadb6dbcd1255ea5bbc93a2b54b94fbf83653b4d65c7d6775b8634'
'SKIP'
)
prepare() {
cd tiff-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd tiff-$pkgver
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
	'--enable-ccitt'
	'--enable-packbits'
	'--enable-lzw'
	'--enable-thunder'
	'--enable-next'
	'--enable-logluv'
	'--enable-mdi'
	'--enable-cxx'
	'--with-x'
	'--enable-jbig'
	'--enable-jpeg'
	'--enable-old-jpeg'
	'--enable-webp'
	'--enable-lzma'
	'--enable-zlib'
	'--enable-pixarlog'
	'--enable-zstd'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd tiff-$pkgver
make -k check
}
package() {
cd tiff-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYRIGHT $pkgdir/usr/share/licenses/libtiff/LICENSE
}
