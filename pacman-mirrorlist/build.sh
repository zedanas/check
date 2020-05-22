pkgname=('pacman-mirrorlist')
pkgver=20200207
pkgrel=1
pkgdesc='Arch Linux mirror list for use by pacman'
url='https://www.archlinux.org/mirrorlist/'
license=('GPL')
arch=('any')
backup=('etc/pacman.d/mirrorlist')
source=('mirrorlist')
sha256sums=('5dbceeb270ae663f8ce05780d77ed9f5bceb1c266c255a870512c948f50bca77')
package() {
install -Dm644 $srcdir/mirrorlist $pkgdir/etc/pacman.d/mirrorlist
}
