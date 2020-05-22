pkgname=('sshfs')
pkgver=3.7.0
pkgrel=1
pkgdesc='FUSE client based on the SSH File Transfer Protocol'
url='https://github.com/libfuse/sshfs'
license=('GPL')
arch=('x86_64')
depends=(
'fuse3'
'glib2'
'glibc'
'openssh'
)
makedepends=(
'meson'
'python-docutils'
)
source=(
"https://github.com/libfuse/$pkgname/releases/download/$pkgname-$pkgver/$pkgname-$pkgver.tar.xz"
"https://github.com/libfuse/$pkgname/releases/download/$pkgname-$pkgver/$pkgname-$pkgver.tar.xz.asc"
)
sha256sums=(
'6e7e86831f3066b356e7f16e22f1b8a8f177fda05146f6a5eb821c2fd0541c34'
'SKIP'
)
build() {
cd $pkgname-$pkgver
arch-meson build
ninja -C build
}
package() {
cd $pkgname-$pkgver
DESTDIR=$pkgdir ninja -C build install
}
