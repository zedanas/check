pkgname=('hwids')
pkgver=20200306
pkgrel=1
pkgdesc='Hardware identification databases'
url='https://github.com/gentoo/hwids'
license=('GPL2')
arch=('any')
makedepends=('git')
md5sums=('SKIP')
package() {
cd hwids
install -Dm644 pci.ids $pkgdir/usr/share/hwdata/pci.ids
install -Dm644 usb.ids $pkgdir/usr/share/hwdata/usb.ids
}
