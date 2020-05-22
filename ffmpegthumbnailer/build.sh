pkgname='ffmpegthumbnailer'
pkgver=2.2.2
pkgrel=1
pkgdesc='Lightweight video thumbnailer that can be used by file managers.'
url='https://github.com/dirkvdb/ffmpegthumbnailer'
license=('GPL2')
arch=('x86_64')
depends=(
'ffmpeg'
'gcc-libs'
'glibc'
'libjpeg'
'libpng'
)
makedepends=('cmake')
optdepends=('gvfs: support for gio uris')
source=("https://github.com/dirkvdb/$pkgname/archive/$pkgver.tar.gz")
sha1sums=('1b35a8afc94edd9135baef9e5259a40b4c0d4d79')
build() {
cd $pkgname-$pkgver
config_opts=(
	"-DCMAKE_C_FLAGS='$CFLAGS'"
	"-DCMAKE_CXX_FLAGS='$CXXFLAGS'"
	"-DCMAKE_LD_FLAGS='$LDFLAGS'"
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_INSTALL_LIBDIR=/usr/lib'
	'-DCMAKE_BUILD_TYPE=Release'
	'-DENABLE_SHARED=ON'
	'-DENABLE_STATIC=OFF'
	'-DENABLE_TESTS=OFF'
	'-DENABLE_GIO=ON'
	'-DENABLE_THUMBNAILER=ON'
	'-DHAVE_JPEG=ON'
	'-DHAVE_PNG=ON'
)
mkdir -p build && cd build
cmake .. "${config_opts[@]}"
make
}
package() {
cd $pkgname-$pkgver/build
make DESTDIR=$pkgdir install
}
