pkgname=('lostfiles')
pkgver=4.03
pkgrel=1
pkgdesc='Find orphaned files not owned by any Arch packages'
url='https://github.com/graysky2/lostfiles'
license=('GPL2')
arch=('any')
depends=('bash')
source=("$pkgname-$pkgver.tar.xz::https://github.com/graysky2/$pkgname/archive/v$pkgver.tar.gz")
sha256sums=('577a68a712f46bb75f31880519dcbb84b7be24598e8b2e0eb9037ff7dde3133b')
build() {
cd $pkgname-$pkgver
make
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
}
