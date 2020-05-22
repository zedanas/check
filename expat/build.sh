pkgname=('expat')
pkgver=2.2.9
pkgrel=3
pkgdesc='An XML parser library'
url='https://libexpat.github.io/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
)
makedepends=('cmake')
source=(
"https://github.com/libexpat/libexpat/releases/download/R_${pkgver//./_}/expat-${pkgver}.tar.bz2"
"https://github.com/libexpat/libexpat/releases/download/R_${pkgver//./_}/expat-${pkgver}.tar.bz2.asc"
)
sha256sums=(
'f1063084dc4302a427dabcca499c8312b3a32a29b7d2506653ecc8f950a9a237'
'SKIP'
)
build() {
cd $pkgname-$pkgver
config_opts=(
	"-DCMAKE_C_FLAGS='$CFLAGS'"
	"-DCMAKE_CXX_FLAGS='$CXXFLAGS'"
	"-DCMAKE_LD_FLAGS='$LDFLAGS'"
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_BUILD_TYPE=Release'
	'-DEXPAT_SHARED_LIBS=ON'
	'-DEXPAT_BUILD_TOOLS=ON'
	'-DEXPAT_BUILD_DOCS=OFF'
	'-DEXPAT_BUILD_EXAMPLES=OFF'
	'-DEXPAT_BUILD_FUZZERS=OFF'
	'-DEXPAT_BUILD_TESTS=ON'
	'-DEXPAT_WARNINGS_AS_ERRORS=OFF'
	'-DEXPAT_ENABLE_INSTALL=ON'
	'-DEXPAT_CHAR_TYPE=char'
	'-DEXPAT_LARGE_SIZE=OFF'
	'-DEXPAT_MIN_SIZE=OFF'
	'-DEXPAT_DTD=ON'
	'-DEXPAT_NS=ON'
	'-DEXPAT_ATTR_INFO=OFF'
	'-DEXPAT_DEV_URANDOM=ON'
	'-DEXPAT_WITH_GETRANDOM=ON'
	'-DEXPAT_WITH_SYS_GETRANDOM=ON'
	'-DEXPAT_WITH_LIBBSD=OFF'
)
mkdir -p build && cd build
cmake .. "${config_opts[@]}"
make
}
check() {
cd $pkgname-$pkgver/build
make -k tests
}
package() {
cd $pkgname-$pkgver/build
make DESTDIR=$pkgdir install
install -Dm644 ../COPYING $pkgdir/usr/share/licenses/expat/COPYING
}
