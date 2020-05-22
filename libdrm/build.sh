pkgname=('libdrm')
pkgver=2.4.100
pkgrel=1
pkgdesc="Userspace interface to kernel DRM services"
url="https://dri.freedesktop.org/"
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libpciaccess'
)
makedepends=(
'cmake'
'docbook-xsl'
'libxslt'
'meson'
'udev'
'valgrind'
)
checkdepends=('cairo')
replaces=(
'libdrm-new'
'libdrm-nouveau'
)
source=(
"https://dri.freedesktop.org/$pkgname/$pkgname-$pkgver.tar.bz2"
'no-drmdevice-test.diff'
'COPYING'
)
sha512sums=(
'4d3a5556e650872944af52f49de395e0ce8ac9ac58530e39a34413e94dc56c231ee71b8b8de9fb944263515a922b3ebbf7ddfebeaaa91543c2604f9bcf561247'
'f1dd5d8c2270c092ccb8e4f92a0da9ab27706dfa22dcedd3fb2414b968ced9333c8bf62baf0219b822e43dce0d804d1dd5cc27d09b0afe8c01967c1784d4a4bb'
'b0ca349b882a4326b19f81f22804fabdb6fb7aef31cdc7b16b0a7ae191bfbb50c7daddb2fc4e6c33f1136af06d060a273de36f6f3412ea326f16fa4309fda660'
)
prepare() {
cd $pkgname-$pkgver
patch -Np1 -i ../no-drmdevice-test.diff
}
build() {
cd $pkgname-$pkgver
config_opts=(
	'-Dman-pages=true'
	'-Dudev=false'
	'-Dvalgrind=false'
	'-Dcairo-tests=true'
	'-Dinstall-test-programs=false'
	'-Dlibkms=true'
	'-Dintel=true'
	'-Dradeon=true'
	'-Damdgpu=true'
	'-Dnouveau=true'
	'-Dvmwgfx=true'
	'-Domap=true'
	'-Dexynos=true'
	'-Dtegra=true'
	'-Dvc4=true'
	'-Detnaviv=true'
	'-Dfreedreno=true'
	'-Dfreedreno-kgsl=true'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd $pkgname-$pkgver
ninja -C build test
}
package() {
cd $pkgname-$pkgver
DESTDIR=$pkgdir ninja -C build install
install -Dm644 ../COPYING $pkgdir/usr/share/licenses/libdrm/COPYING
}
