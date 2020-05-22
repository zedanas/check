pkgname=('x264')
pkgver=0.159.r2991.1771b55
pkgrel=1
epoch=3
pkgdesc='Open Source H264/AVC video encoder'
url='https://www.videolan.org/developers/x264.html'
license=('GPL')
arch=('x86_64')
depends=(
'glibc'
'libavformat.so'
'libavutil.so'
'libswscale.so'
)
makedepends=(
'ffmpeg'
'git'
'nasm'
)
provides=(
'libx264'
'libx264.so'
)
conflicts=(
'libx264'
'libx264-10bit'
'libx264-all'
)
replaces=(
'libx264'
'libx264-10bit'
'libx264-all'
)
_commit='1771b556ee45207f8711744ccbd5d42a3949b14c'
sha256sums=('SKIP')
build() {
cd $pkgname
config_opts=(
	'--prefix=/usr'
	'--bindir=/usr/bin'
	'--sbindir=/usr/bin'
	'--libdir=/usr/lib'
	'--libexecdir=/usr/lib'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--disable-debug'
	'--enable-thread'
	'--enable-cli'
	'--enable-interlaced'
	'--enable-opencl'
	'--enable-asm'
	'--enable-pic'
	'--enable-lto'
	'--enable-strip'
	'--bit-depth=all'
	'--chroma-format=all'
	'--disable-ffms'
	'--disable-avs'
	'--disable-gpac'
	'--enable-lavf'
	'--disable-lsmash'
	'--enable-swscale'
)
export CFLAGS+=' -fno-lto'
export CXXFLAGS="${CFLAGS}"
./configure "${config_opts[@]}"
make
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install-cli install-lib-shared
}
