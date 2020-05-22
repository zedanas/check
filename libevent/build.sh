pkgname=('libevent')
pkgver=2.1.11
pkgrel=5
pkgdesc='An event notification library'
url='https://libevent.org/'
license=('BSD')
arch=('x86_64')
depends=(
'glibc'
'openssl'
)
makedepends=(
'cmake'
'python'
)
optdepends=('python: to use event_rpcgen.py')
source=(
"https://github.com/libevent/$pkgname/releases/download/release-$pkgver-stable/$pkgname-$pkgver-stable.tar.gz"
"https://github.com/libevent/$pkgname/releases/download/release-$pkgver-stable/$pkgname-$pkgver-stable.tar.gz.asc"
"https://raw.githubusercontent.com/$pkgname/$pkgname/release-2.1.11-stable/cmake/Uninstall.cmake.in"
'0001-Warn-if-forked-from-the-event-loop-during-event_reinit.patch'
)
sha256sums=(
'a65bac6202ea8c5609fd5c7e480e6d25de467ea1917c08290c521752f147283d'
'SKIP'
'1584d6e36642d930ac99d014a485fe886ec705b3f998d128c6d6f227e0454b72'
'436e56c74c0af0b70c43eaae6bd32b760601d2d5fa98b8d2d026ffad18474e13'
)
prepare() {
cd $pkgname-$pkgver-stable
patch -Np1 -R -i $srcdir/0001-Warn-if-forked-from-the-event-loop-during-event_reinit.patch
cp -n ../Uninstall.cmake.in cmake
}
build() {
cd $pkgname-$pkgver-stable
config_opts=(
	"-DCMAKE_C_FLAGS='$CFLAGS'"
	"-DCMAKE_CXX_FLAGS='$CXXFLAGS'"
	"-DCMAKE_LD_FLAGS='$LDFLAGS'"
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_BUILD_TYPE=Release'
	'-DCMAKE_CONFIGURATION_TYPES=Release'
	'-DCMAKE_COLOR_MAKEFILE=ON'
	'-DCMAKE_VERBOSE_MAKEFILE=FALSE'
	'-DBUILD_TESTING=OFF'
	'-DEVENT__LIBRARY_TYPE=SHARED'
	'-DEVENT__DISABLE_BENCHMARK=OFF'
	'-DEVENT__DISABLE_CLOCK_GETTIME=OFF'
	'-DEVENT__DISABLE_DEBUG_MODE=ON'
	'-DEVENT__DISABLE_GCC_WARNINGS=ON'
	'-DEVENT__DISABLE_MM_REPLACEMENT=OFF'
	'-DEVENT__DISABLE_REGRESS=ON'
	'-DEVENT__DISABLE_SAMPLES=ON'
	'-DEVENT__DISABLE_TESTS=ON'
	'-DEVENT__DISABLE_THREAD_SUPPORT=OFF'
	'-DEVENT__ENABLE_GCC_FUNCTION_SECTIONS=OFF'
	'-DEVENT__ENABLE_GCC_HARDENING=OFF'
	'-DEVENT__ENABLE_GCC_WARNINGS=OFF'
	'-DEVENT__ENABLE_VERBOSE_DEBUG=OFF'
	'-DEVENT__DISABLE_OPENSSL=OFF'
)
mkdir -p build && cd build
cmake .. "${config_opts[@]}"
make
}
package() {
cd $pkgname-$pkgver-stable/build
make DESTDIR=$pkgdir install
install -Dm644 ../LICENSE $pkgdir/usr/share/licenses/libevent/LICENSE
}
