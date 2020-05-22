pkgname=('linux-api-headers')
pkgver=5.4.17
pkgrel=1
pkgdesc='Kernel headers sanitized for use in userspace'
url='https://www.gnu.org/software/libc'
license=('GPL2')
arch=('any')
makedepends=('rsync')
source=(
"https://www.kernel.org/pub/linux/kernel/v${pkgver:0:1}.x/linux-$pkgver.tar.xz"
"https://www.kernel.org/pub/linux/kernel/v${pkgver:0:1}.x/linux-$pkgver.tar.sign"
)
md5sums=(
'208ec24f003490b25a671cd3d9483b9c'
'SKIP'
)
build() {
cd linux-$pkgver
make mrproper
make headers_check
}
package() {
cd linux-$pkgver
make INSTALL_HDR_PATH=$pkgdir/usr headers_install
rm -r $pkgdir/usr/include/drm
}
