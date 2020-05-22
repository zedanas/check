pkgname=('djvulibre')
pkgver=3.5.27
pkgrel=5
pkgdesc='Suite to create, manipulate and view DjVu ("déjà vu") documents'
url='http://djvu.sourceforge.net/'
license=('GPL2')
arch=('x86_64')
depends=(
'bash'
'gcc-libs'
'glibc'
'hicolor-icon-theme'
'libjpeg'
'libtiff'
)
makedepends=('librsvg')
provides=("libdjvu=${pkgver}")
conflicts=('libdjvu')
replaces=('libdjvu')
source=(
"https://downloads.sourceforge.net/project/djvu/DjVuLibre/$pkgver/$pkgname-$pkgver.tar.gz"
'0001-always-assume-that-cpuid-works-on-x86_64.patch'
)
sha256sums=(
'e69668252565603875fb88500cde02bf93d12d48a3884e472696c896e81f505f'
'35654b433a7bbf0bf7e039385a80034776d5134bc59ff82ef74170ef4bbc86ce'
)
prepare() {
cd $pkgname-$pkgver
patch -p1 -i $srcdir/0001-always-assume-that-cpuid-works-on-x86_64.patch
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
	'--enable-xmltools'
	'--enable-desktopfiles'
	'--with-jpeg'
	'--with-tiff'
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
for size in 22 32 48 64; do
	install -Dm644 desktopfiles/prebuilt-hi${size}-djvu.png \
	$pkgdir/usr/share/icons/hicolor/${size}x${size}/mimetypes/image-vnd.djvu.mime.png
done
}
