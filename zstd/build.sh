pkgname='zstd'
pkgver=1.4.4
pkgrel=1
pkgdesc='Zstandard - Fast real-time compression algorithm'
url='https://www.zstd.net/'
license=('BSD' 'GPL2')
arch=('x86_64')
depends=(
'gcc-libs'
'glibc'
'lz4'
'sh'
'xz'
'zlib'
)
makedepends=('gtest')
source=("$pkgname-$pkgver.tar.gz::https://github.com/facebook/$pkgname/archive/v${pkgver}.tar.gz")
sha256sums=('a364f5162c7d1a455cc915e8e3cf5f4bd8b75d09bc0f53965b0c9ca1383c52c8')
build() {
cd $pkgname-$pkgver
make && make zstdmt && make -C contrib/pzstd
}
check() {
cd $pkgname-$pkgver
make -k check && make -C contrib/pzstd test
}
package() {
cd $pkgname-$pkgver
make PREFIX=/usr DESTDIR=$pkgdir install
install -Dm755 zstdmt $pkgdir/usr/bin/zstdmt
install -Dm755 contrib/pzstd/pzstd $pkgdir/usr/bin/pzstd
install -Dm644 LICENSE $pkgdir/usr/share/licenses/zstd/LICENSE
}
