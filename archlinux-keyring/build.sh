pkgname=('archlinux-keyring')
pkgver=20200108
pkgrel=1
pkgdesc='Arch Linux PGP keyring'
url='https://projects.archlinux.org/archlinux-keyring.git/'
license=('GPL')
arch=('any')
install="archlinux-keyring.install"
source=(
"https://sources.archlinux.org/other/$pkgname/$pkgname-$pkgver.tar.gz"
"https://sources.archlinux.org/other/$pkgname/$pkgname-$pkgver.tar.gz.sig"
)
sha256sums=(
'ecd1dbae1cb4886bf68ccbcff2194ba5626787b112f10e71d84a502fd45f7b0f'
'SKIP'
)
package() {
cd $pkgname-$pkgver
make PREFIX=/usr DESTDIR=$pkgdir install
}
