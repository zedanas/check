pkgname=('semver')
pkgver=7.1.3
pkgrel=1
pkgdesc='The semantic version parser used by npm'
url='https://github.com/npm/node-semver'
license=('ISC')
arch=('any')
depends=('nodejs')
makedepends=('npm')
source=("https://registry.npmjs.org/$pkgname/-/$pkgname-$pkgver.tgz")
noextract=("$pkgname-$pkgver.tgz")
sha512sums=('7a4334cdf880f5208196c29ad97d61c72c622382f707a11b5499247604179d210468794676fca874caee4e2ba549158c301e0d788b9834c0bdad3293cfdec6c4')
package() {
npm install -g --user root --prefix $pkgdir/usr $srcdir/semver-$pkgver.tgz
mkdir -p $pkgdir/usr/share/licenses/semver
ln -s ../../../lib/node_modules/semver/LICENSE $pkgdir/usr/share/licenses/semver/LICENSE
}
