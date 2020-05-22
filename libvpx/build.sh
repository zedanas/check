pkgname=('libvpx')
pkgver=1.8.2
pkgrel=1
pkgdesc='VP8 and VP9 codec'
url='https://www.webmproject.org/'
license=('BSD')
arch=('x86_64')
depends=(
'gcc-libs'
'glibc'
)
makedepends=(
'git'
'nasm'
)
provides=('libvpx.so')
sha256sums=('SKIP')
build() {
cd $pkgname
config_opts=(
	'--prefix=/usr'
	'--libdir=/usr/lib'
	'--target=x86_64-linux-gcc'
	'--cpu=native'
	'--enable-optimizations'
	'--enable-shared'
	'--disable-static'
	'--disable-debug'
	'--disable-docs'
	'--enable-libs'
	'--enable-tools'
	'--enable-pic'
	'--enable-multithread'
	'--enable-runtime-cpu-detect'
	'--enable-better-hw-compatibility'
	'--enable-vp8'
	'--enable-postproc'
	'--enable-temporal-denoising'
	'--enable-vp9'
	'--enable-vp9-postproc'
	'--enable-vp9-temporal-denoising'
	'--enable-vp9-highbitdepth'
	'--enable-multi-res-encoding'
	'--enable-spatial-resampling'
	'--enable-webm-io'
	'--enable-libyuv'
	'--enable-install-bins'
	'--enable-install-libs'
	'--disable-install-docs'
	'--disable-install-srcs'
	'--disable-codec-srcs'
	'--disable-debug-libs'
	'--disable-unit-tests'
	'--disable-internal-stats'
	'--disable-decode-perf-tests'
	'--disable-encode-perf-tests'
	'--disable-realtime-only'
	'--disable-onthefly-bitpacking'
	'--disable-postproc-visualizer'
	'--disable-error-concealment'
	'--disable-coefficient-range-checking'
)
export CFLAGS+=' -fno-lto'
export CXXFLAGS="${CFLAGS}"
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname
make DIST_DIR=$pkgdir/usr install
install -Dm644 LICENSE $pkgdir/usr/share/licenses/libvpx/LICENSE
}
