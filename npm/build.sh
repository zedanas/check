pkgname=('npm')
pkgver=6.14.4
pkgrel=1
pkgdesc='A package manager for javascript'
url='https://www.npmjs.com/'
license=('custom:Artistic')
arch=('any')
depends=(
'bash'
'node-gyp'
'nodejs'
'semver'
)
makedepends=(
'marked-man'
'procps-ng'
)
source=("$pkgname-$pkgver.tar.gz::https://github.com/$pkgname/cli/archive/v$pkgver.tar.gz")
sha512sums=('94d1d2438d504357b4908f40b58a1380aaef14fab2ba5bf9cd705ec29b73b409879cae6e9435424294e53ebc69fcf5a831d1979d8b81bc2859448ecb5ef5334c')
prepare() {
cd cli-$pkgver
mkdir -p man/man1
}
build() {
cd cli-$pkgver
make
}
package() {
cd cli-$pkgver
make NPMOPTS="--prefix=\"$pkgdir/usr\"" install
chmod -R u=rwX,go=rX $pkgdir
rm -r $pkgdir/usr/lib/node_modules/npm/node_modules/{,.bin/}semver
rm -r $pkgdir/usr/lib/node_modules/npm/node_modules/{,.bin/}node-gyp
sed -i '/node-gyp.js/c\  exec /usr/bin/node-gyp "$@"' \
$pkgdir/usr/lib/node_modules/npm/node_modules/npm-lifecycle/node-gyp-bin/node-gyp \
$pkgdir/usr/lib/node_modules/npm/bin/node-gyp-bin/node-gyp
install -Dm644 $srcdir/cli-$pkgver/LICENSE $pkgdir/usr/share/licenses/$pkgname/LICENSE
}
