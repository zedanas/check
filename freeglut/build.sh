pkgname=('freeglut')
pkgver=3.2.1
pkgrel=1
pkgdesc='Provides functionality for small OpenGL programs'
url='http://freeglut.sourceforge.net/'
license=('MIT')
arch=('x86_64')
depends=(
'glibc'
'libgl'
'libx11'
'libxi'
'libxrandr'
'libxxf86vm'
)
makedepends=(
'cmake'
'glu'
'mesa'
)
provides=('glut')
conflicts=('glut')
replaces=('glut')
source=("https://downloads.sourceforge.net/$pkgname/$pkgname-$pkgver.tar.gz")
sha512sums=('aced4bbcd36269ce6f4ee1982e0f9e3fffbf18c94f785d3215ac9f4809b992e166c7ada496ed6174e13d77c0f7ef3ca4c57d8a282e96cbbe6ff086339ade3b08')
build() {
cd $pkgname-$pkgver
config_opts=(
	"-DCMAKE_C_FLAGS='$CFLAGS'"
	"-DCMAKE_CXX_FLAGS='$CXXFLAGS'"
	"-DCMAKE_LD_FLAGS='$LDFLAGS'"
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_INSTALL_LIBDIR=lib'
	'-DCMAKE_BUILD_TYPE=Release'
	'-DFREEGLUT_BUILD_SHARED_LIBS=ON'
	'-DFREEGLUT_BUILD_STATIC_LIBS=OFF'
	'-DFREEGLUT_BUILD_DEMOS=OFF'
	'-DFREEGLUT_REPLACE_GLUT=ON'
	'-DFREEGLUT_GLES=OFF'
	'-DFREEGLUT_PRINT_ERRORS=ON'
	'-DFREEGLUT_PRINT_WARNINGS=ON'
	'-DFREEGLUT_WAYLAND=OFF'
)
mkdir -p build && cd build
cmake .. "${config_opts[@]}"
make
}
package() {
cd $pkgname-$pkgver/build
make DESTDIR=$pkgdir install
install -Dm644 ../COPYING $pkgdir/usr/share/licenses/freeglut/LICENSE
cd $pkgdir/usr/lib/pkgconfig
ln -s glut.pc freeglut.pc
}
