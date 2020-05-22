pkgname=('libjpeg-turbo')
pkgver=2.0.4
pkgrel=1
pkgdesc='JPEG image codec with accelerated baseline compression and decompression'
url='https://libjpeg-turbo.org/'
license=('custom')
arch=('x86_64')
depends=('glibc')
makedepends=(
'cmake'
'nasm'
'jdk8-openjdk'
)
provides=('libjpeg=8.2.2')
source=(
"https://downloads.sourceforge.net/project/$pkgname/$pkgver/$pkgname-$pkgver.tar.gz"
"https://downloads.sourceforge.net/project/$pkgname/$pkgver/$pkgname-$pkgver.tar.gz.sig"
)
sha256sums=(
'33dd8547efd5543639e890efbf2ef52d5a21df81faf41bb940657af916a23406'
'SKIP'
)
build() {
cd $pkgname-$pkgver
config_opts=(
	"-DCMAKE_C_FLAGS='$CFLAGS'"
	"-DCMAKE_CXX_FLAGS='$CXXFLAGS'"
	"-DCMAKE_LD_FLAGS='$LDFLAGS'"
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_INSTALL_LIBDIR=/usr/lib'
	'-DCMAKE_BUILD_TYPE=Release'
	'-DFLOATTEST=sse'
	'-DENABLE_SHARED=ON'
	'-DENABLE_STATIC=OFF'
	'-DREQUIRE_SIMD=ON'
	'-DFORCE_INLINE=ON'
	'-DWITH_12BIT=OFF'
	'-DWITH_ARITH_DEC=ON'
	'-DWITH_ARITH_ENC=ON'
	'-DWITH_JAVA=ON'
	'-DWITH_JPEG7=OFF'
	'-DWITH_JPEG8=ON'
	'-DWITH_MEM_SRCDST=ON'
	'-DWITH_SIMD=ON'
	'-DWITH_TURBOJPEG=ON'
)
cmake "${config_opts[@]}"
make
}
check() {
cd $pkgname-$pkgver
make -k check
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
install -m644 jpegint.h $pkgdir/usr/include
install -Dm644 LICENSE.md $pkgdir/usr/share/licenses/libjpeg-turbo/LICENSE
}
