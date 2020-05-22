pkgname=('ipcalc')
pkgver=0.41
pkgrel=6
pkgdesc="Calculates IP broadcast, network, Cisco wildcard mask, and host ranges"
url='http://jodies.de/ipcalc'
license=('GPL')
arch=('any')
depends=('perl')
source=("http://jodies.de/$pkgname-archive/$pkgname-${pkgver}.tar.gz")
sha512sums=('089eb2b9a38b07caa182ff11547a93d86aed570311fc8cd9e636c7546ab4d15acc854b9d79bbba9c797dcfbbedd1d6f4d521aec97bf613905fe5198a29c9889d')
package() {
cd $pkgname-$pkgver
install -Dm755 ipcalc $pkgdir/usr/bin/ipcalc
install -Dm644 license $pkgdir/usr/share/licenses/ipcalc/LICENSE
}
