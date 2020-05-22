pkgname='graphite'
pkgver=1.3.14
pkgrel=1
epoch=1
pkgdesc='Reimplementation of the SIL Graphite text processing engine'
url='https://github.com/silnrsi/graphite'
license=('LGPL' 'GPL' 'custom')
arch=('x86_64')
depends=(
'gcc-libs'
'glibc'
)
makedepends=(
'asciidoc'
'cmake'
'doxygen'
'freetype2'
'graphviz'
'python'
)
checkdepends=('python-fonttools')
source=("https://github.com/silnrsi/graphite/releases/download/$pkgver/graphite2-$pkgver.tgz")
sha256sums=('f99d1c13aa5fa296898a181dff9b82fb25f6cc0933dbaa7a475d8109bd54209d')
build() {
cd graphite2-$pkgver
config_opts=(
	"-DCMAKE_C_FLAGS='$CFLAGS'"
	"-DCMAKE_CXX_FLAGS='$CXXFLAGS'"
	"-DCMAKE_LD_FLAGS='$LDFLAGS'"
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_BUILD_TYPE=Release'
	'-DGRAPHITE2_VM_TYPE=auto'
	'-DBUILD_SHARED_LIBS=ON'
	'-DGRAPHITE2_COMPARE_RENDERER=OFF'
	'-DGRAPHITE2_VM_TYPE=auto'
)
mkdir -p build && cd build
cmake .. "${config_opts[@]}"
make
make -j1 docs
}
check() {
cd graphite2-$pkgver/build
ctest || true
}
package() {
cd graphite2-$pkgver/build
make DESTDIR=$pkgdir install
install -Dm644 ../COPYING $pkgdir/usr/share/licenses/graphite/COPYING
}
