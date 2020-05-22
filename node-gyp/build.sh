pkgname=('node-gyp')
pkgver=6.1.0
pkgrel=1
pkgdesc='Node.js native addon build tool'
url='https://github.com/nodejs/node-gyp'
license=('MIT')
arch=('any')
depends=(
'bash'
'nodejs'
'semver'
)
makedepends=('npm')
source=("https://registry.npmjs.org/$pkgname/-/$pkgname-$pkgver.tgz")
noextract=("$pkgname-$pkgver.tgz")
sha512sums=('878036cc394eba379e69a4f1d3aaf8572fbc319d7aefd954fb06c22834b866dbd8d80dfb0c44a8dfba1e8c8c349ad991dfeaef370b6ce41e8aa6dd4aacd61d37')
package() {
npm install -g --user root --prefix $pkgdir/usr $srcdir/$pkgname-$pkgver.tgz
chmod -R u=rwX,go=rX $pkgdir
rm -r $pkgdir/usr/lib/node_modules/node-gyp/node_modules/semver
mkdir -p $pkgdir/usr/share/licenses/node-gyp
ln -s ../../../lib/node_modules/node-gyp/LICENSE $pkgdir/usr/share/licenses/node-gyp/LICENSE
}
