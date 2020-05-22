pkgbase='fuse3'
pkgname=('fuse3' 'fuse-common')
pkgver=3.9.1
pkgrel=1
url='https://github.com/libfuse/libfuse'
license=('GPL2')
arch=('x86_64')
makedepends=(
'pkgconfig'
'meson'
'udev'
)
source=(
"https://github.com/libfuse/libfuse/releases/download/fuse-$pkgver/fuse-$pkgver.tar.xz"
"https://github.com/libfuse/libfuse/releases/download/fuse-$pkgver/fuse-$pkgver.tar.xz.asc"
)
sha256sums=(
'1bafcfd6c66ba35b7b0beb822532a9106eb8409ad6cde988888fde85f89be645'
'SKIP'
)
build() {
cd fuse-$pkgver
config_opts=(
	'-Ddisable-mtab=false'
	'-Dutils=true'
	'-Duseroot=true'
	'-Dexamples=false'
)
export CFLAGS+=' -fno-lto'
export CXXFLAGS="${CFLAGS}"
arch-meson build "${config_opts[@]}"
ninja -C build
}
package_fuse3() {
pkgdesc='A library that makes it possible to implement a filesystem in a userspace program.'
depends=(
	'fuse-common'
	'glibc'
)
cd fuse-$pkgver
DESTDIR=$pkgdir ninja -C build install
cd $pkgdir
rm -fr dev
mkdir -p $srcdir/fuse-common/etc
mv etc/fuse.conf $srcdir/fuse-common/etc
rm -fr etc
}
package_fuse-common() {
pkgdesc='Common files for fuse2/3 packages'
depends=()
backup=('etc/fuse.conf')
mv $srcdir/fuse-common/* $pkgdir
}
