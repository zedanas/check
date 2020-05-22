pkgname=('libpng')
pkgver=1.6.37
pkgrel=1
pkgdesc='A collection of routines used to create PNG format graphics files'
url='http://www.libpng.org/pub/png/libpng.html'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'sh'
'zlib'
)
source=(
"https://downloads.sourceforge.net/sourceforge/$pkgname/$pkgname-$pkgver.tar.xz"
"https://downloads.sourceforge.net/sourceforge/$pkgname-apng/$pkgname-$pkgver-apng.patch.gz"
)
sha256sums=(
'505e70834d35383537b6491e7ae8641f1a4bed1876dbfe361201fc80868d88ca'
'823bb2d1f09dc7dae4f91ff56d6c22b4b533e912cbd6c64e8762255e411100b6'
)
prepare() {
cd $pkgname-$pkgver
gzip -cd $srcdir/libpng-$_apngver-apng.patch.gz | patch -Np1
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
	'--enable-hardware-optimizations'
	'--enable-intel-sse'
	'--enable-unversioned-links'
	'--enable-unversioned-libpng-pc'
	'--enable-unversioned-libpng-config'
	'--with-binconfigs'
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
install -Dm644 LICENSE $pkgdir/usr/share/licenses/libpng/LICENSE
cd contrib/pngminus
make LDFLAGS=$LDFLAGS PNGLIB_SHARED="-L $pkgdir/usr/lib -lpng" png2pnm pnm2png
install -m755 png2pnm pnm2png $pkgdir/usr/bin/
}
