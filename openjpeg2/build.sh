pkgname=('openjpeg2')
pkgver=2.3.1
pkgrel=1
pkgdesc='An open source JPEG 2000 codec'
url='https://github.com/uclouvain/openjpeg'
license=('custom: BSD')
arch=('x86_64')
depends=(
'glibc'
'lcms2'
'libpng'
'libtiff'
)
makedepends=(
'cmake'
'doxygen'
)
source=("$pkgname-$pkgver.tar.gz::https://github.com/uclouvain/openjpeg/archive/v$pkgver.tar.gz")
sha256sums=('63f5a4713ecafc86de51bfad89cc07bb788e9bba24ebbf0c4ca637621aadb6a9')
build() {
cd openjpeg-$pkgver
config_opts=(
	"-DCMAKE_C_FLAGS='$CFLAGS'"
	"-DCMAKE_CXX_FLAGS='$CXXFLAGS'"
	"-DCMAKE_LD_FLAGS='$LDFLAGS'"
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_INSTALL_LIBDIR=/usr/lib'
	'-DCMAKE_BUILD_TYPE=Release'
	'-DBUILD_PKGCONFIG_FILES=ON'
	'-DBUILD_STATIC_LIBS=OFF'
	'-DBUILD_SHARED_LIBS=ON'
	'-DBUILD_TESTING=OFF'
	'-DBUILD_UNIT_TESTS=OFF'
	'-DBUILD_DOC=ON'
	'-DBUILD_CODEC=ON'
	'-DBUILD_JAVA=OFF'
	'-DBUILD_JP3D=OFF'
	'-DBUILD_JPIP=OFF'
	'-DBUILD_JPWL=OFF'
	'-DBUILD_MJ2=OFF'
	'-DBUILD_VIEWER=OFF'
	'-DBUILD_THIRDPARTY=OFF'
	'-DBUILD_PKGCONFIG_FILES=ON'
	'-DBUILD_LUTS_GENERATOR=ON'
	'-DOPJ_USE_THREAD=ON'
	'-DOPJ_DISABLE_TPSOT_FIX=OFF'
	'-DWITH_ASTYLE=FALSE'
)
mkdir -p build && cd build
cmake .. "${config_opts[@]}"
make
}
package() {
options=(!emptydirs)
cd openjpeg-$pkgver/build
make DESTDIR=$pkgdir install
install -Dm644 LICENSE.txt $pkgdir/usr/share/licenses/openjpeg2/LICENSE
}
