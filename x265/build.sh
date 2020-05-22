pkgname=('x265')
pkgver=3.2.1
pkgrel=1
pkgdesc='Open Source H265/HEVC video encoder'
url='https://bitbucket.org/multicoreware/x265'
license=('GPL')
arch=('x86_64')
depends=(
'gcc-libs'
'glibc'
)
makedepends=(
'cmake'
'mercurial'
'nasm'
)
provides=('libx265.so')
_commit='7fa570ead8d361bf6055cd2a881a8e15f12110ae'
sha256sums=('SKIP')
build() {
cd $pkgname
config_opts=(
	"-DCMAKE_C_FLAGS='$CFLAGS'"
	"-DCMAKE_CXX_FLAGS='$CXXFLAGS'"
	"-DCMAKE_LD_FLAGS='$LDFLAGS'"
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_BUILD_TYPE=Release'
	'-DWARNINGS_AS_ERRORS=OFF'
	'-DNATIVE_BUILD=ON'
	'-DENABLE_ASSEMBLY=ON'
	'-DENABLE_SHARED=ON'
	'-DENABLE_PIC=ON'
	'-DENABLE_HDR10_PLUS=ON'
	'-DENABLE_SVT_HEVC=OFF'
	'-DENABLE_CLI=ON'
	'-DENABLE_TESTS=OFF'
	'-DENABLE_AGGRESSIVE_CHECKS=OFF'
	'-DENABLE_SVT_HEVC=ON'
	'-DENABLE_PPA=OFF'
	'-DFPROFILE_GENERATE=OFF'
	'-DFPROFILE_USE=OFF'
	'-DCHECKED_BUILD=OFF'
	'-DHIGH_BIT_DEPTH=ON'
	'-DDETAILED_CU_STATS=OFF'
	'-DNO_ATOMICS=OFF'
	'-DEXPORT_C_API=ON'
	'-DSTATIC_LINK_CRT=OFF'
	'-DENABLE_LIBNUMA=OFF'
	'-DENABLE_LIBVMAF=OFF'
)
mkdir -p build && cd build
cmake ../source "${config_opts[@]}"
make
}
package() {
cd $pkgname/build
make DESTDIR=$pkgdir install
}
