pkgname='brotli'
pkgver=1.0.7
pkgrel=3
pkgdesc='Brotli compression library'
url='https://github.com/google/brotli'
license=('MIT')
arch=('x86_64')
depends=('glibc')
makedepends=(
'cmake'
'python-setuptools'
'python2-setuptools'
)
source=("$pkgname-$pkgver.tar.gz::https://github.com/google/$pkgname/archive/v${pkgver}.tar.gz")
sha512sums=('a82362aa36d2f2094bca0b2808d9de0d57291fb3a4c29d7c0ca0a37e73087ec5ac4df299c8c363e61106fccf2fe7f58b5cf76eb97729e2696058ef43b1d3930a')
build() {
cd $pkgname-$pkgver
config_opts=(
	"-DCMAKE_C_FLAGS='$CFLAGS'"
	"-DCMAKE_CXX_FLAGS='$CXXFLAGS'"
	"-DCMAKE_LD_FLAGS='$LDFLAGS'"
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_INSTALL_LIBDIR=/usr/lib'
	'-DCMAKE_BUILD_TYPE=Release'
	'-DBUILD_TESTING=OFF'
)
mkdir -p build && cd build
cmake .. "${config_opts[@]}"
make
}
check() {
cd $pkgname-$pkgver/build
make -k check
}
package() {
cd $pkgname-$pkgver/build
make DESTDIR=$pkgdir install
install -Dm644 ../LICENSE $pkgdir/usr/share/licenses/brotli/LICENSE
}
