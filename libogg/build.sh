pkgname=('libogg')
pkgver=1.3.4
pkgrel=1
pkgdesc='Ogg bitstream and framing library'
url='https://www.xiph.org/ogg/'
license=('BSD')
arch=('x86_64')
depends=('glibc')
makedepends=(
'cmake'
'git'
'ninja'
)
_commit='3328abd152508614f7ce4cd491dc98d14eba7ffc'
sha256sums=('SKIP')
build() {
cd ogg
config_opts=(
	"-DCMAKE_C_FLAGS='$CFLAGS'"
	"-DCMAKE_CXX_FLAGS='$CXXFLAGS'"
	"-DCMAKE_LD_FLAGS='$LDFLAGS'"
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_BUILD_TYPE=Release'
	'-DBUILD_SHARED_LIBS=ON'
	'-DBUILD_TESTING=OFF'
	'-DINSTALL_DOCS:BOOL=ON'
	'-DINSTALL_PKG_CONFIG_MODULE=ON'
	'-DINSTALL_CMAKE_PACKAGE_MODULE=ON'
)
mkdir -p build && cd build
cmake .. -G Ninja "${config_opts[@]}"
ninja
}
package() {
cd ogg/build
DESTDIR=$pkgdir ninja install
install -Dm644 ../COPYING $pkgdir/usr/share/licenses/libogg/COPYING
}
