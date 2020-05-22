pkgbase='poppler'
pkgname=('poppler' 'poppler-glib' 'poppler-qt5')
pkgver=0.87.0
pkgrel=1
url='https://poppler.freedesktop.org/'
license=('GPL')
arch=('x86_64')
makedepends=(
'cmake'
'git'
'gobject-introspection'
'gtk-doc'
'gtk3'
'icu'
'pkgconfig'
'poppler-data'
'python'
)
_commit='72bff390035819a4ccb54c767265aba2792eaf3b'
source=(
"https://poppler.freedesktop.org/$pkgbase-$pkgver.tar.xz"
"https://poppler.freedesktop.org/$pkgbase-$pkgver.tar.xz.sig"
)
sha256sums=(
'6f602b9c24c2d05780be93e7306201012e41459f289b8279a27a79431ad4150e'
'SKIP'
'SKIP'
)
prepare() {
cd $pkgbase-$pkgver
sed -e 's/<openjpeg.h>/\"\/usr\/include\/openjpeg-2.3\/openjpeg.h"/g' -i poppler/JPEG2000Stream.cc
}
build() {
cd $pkgbase-$pkgver
config_opts=(
	"-DCMAKE_C_FLAGS='$CFLAGS'"
	"-DCMAKE_CXX_FLAGS='$CXXFLAGS'"
	"-DCMAKE_LD_FLAGS='$LDFLAGS'"
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_INSTALL_LIBDIR=/usr/lib'
	'-DCMAKE_BUILD_TYPE=Release'
	'-DENABLE_GOBJECT_INTROSPECTION=OFF'
	'-DBUILD_SHARED_LIBS=ON'
	'-DBUILD_CPP_TESTS=OFF'
	'-DBUILD_GTK_TESTS=OFF'
	'-DBUILD_QT5_TESTS=OFF'
	'-DENABLE_GTK_DOC=ON'
	'-DENABLE_UTILS=ON'
	'-DENABLE_CPP=ON'
	'-DENABLE_SPLASH=ON'
	'-DENABLE_UNSTABLE_API_ABI_HEADERS=ON'
	'-DWITH_GTK=ON'
	'-DSPLASH_CMYK=OFF'
	'-DWITH_Cairo=ON'
	'-DENABLE_LIBCURL=ON'
	'-DFONT_CONFIGURATION=fontconfig'
	'-DENABLE_GLIB=ON'
	'-DWITH_GLIB=ON'
	'-DENABLE_CMS=lcms2'
	'-DWITH_JPEG=ON'
	'-DENABLE_DCTDECODER=libjpeg'
	'-DWITH_PNG=ON'
	'-DWITH_TIFF=ON'
	'-DWITH_NSS3=ON'
	'-DENABLE_LIBOPENJPEG=openjpeg2'
	'-DENABLE_QT5=ON'
	'-DENABLE_ZLIB=ON'
)
mkdir -p build && cd build
cmake .. "${config_opts[@]}"
make
}
package_poppler() {
pkgdesc='PDF rendering library based on xpdf 3.0'
depends=(
	'cairo'
	'curl'
	'fontconfig'
	'freetype2'
	'gcc-libs'
	'glibc'
	'lcms2'
	'libjpeg'
	'libpng'
	'libtiff'
	'nspr'
	'nss'
	'openjpeg2'
	'zlib'
)
optdepends=('poppler-data: encoding data to display PDF documents containing CJK characters')
conflicts=(
	"poppler-qt3<$pkgver"
	"poppler-qt4<$pkgver"
)
cd $pkgbase-$pkgver/build
make DESTDIR=$pkgdir install
cd $pkgdir
mkdir -p $srcdir/poppler-glib/usr/{include/poppler,lib/pkgconfig}
mv usr/include/poppler/glib $srcdir/poppler-glib/usr/include/poppler || true
mv usr/lib/libpoppler-glib* $srcdir/poppler-glib/usr/lib || true
mv usr/lib/pkgconfig/poppler-glib.pc $srcdir/poppler-glib/usr/lib/pkgconfig || true
mkdir -p $srcdir/poppler-qt5/usr/{include/poppler,lib/pkgconfig}
mv usr/include/poppler/qt5 $srcdir/poppler-qt5/usr/include/poppler || true
mv usr/lib/libpoppler-qt5* $srcdir/poppler-qt5/usr/lib || true
mv usr/lib/pkgconfig/poppler-qt5.pc $srcdir/poppler-qt5/usr/lib/pkgconfig || true
}
package_poppler-glib() {
pkgdesc='Poppler glib bindings'
depends=(
	"poppler=$pkgver"
	'cairo'
	'freetype2'
	'gcc-libs'
	'glib2'
	'glibc'
)
mv $srcdir/poppler-glib/* $pkgdir
}
package_poppler-qt5() {
pkgdesc='Poppler Qt5 bindings'
depends=(
	"poppler=$pkgver"
	'freetype2'
	'gcc-libs'
	'glibc'
	'qt5-base'
)
mv $srcdir/poppler-qt5/* $pkgdir
}
