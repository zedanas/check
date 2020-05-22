pkgname='hunspell-ru_RU'
pkgver=20131101
pkgrel=2
pkgdesc='Russian hunspell dictionary'
url='https://code.google.com/p/hunspell-ru/'
license=('LGPL3')
arch=('any')
depends=('hunspell')
source=("$pkgname-$pkgver.tar.gz::https://bitbucket.org/Shaman_Alex/russian-dictionary-hunspell/downloads/ru_RU_UTF-8_$pkgver.zip")
sha256sums=('c9c30ca305705691fea4810137763f3b790676aa534a5cd6dfc9b45659aa9408')
package() {
mkdir -p $pkgdir/usr/share/myspell/dicts
install -Dm644 ru_RU.dic $pkgdir/usr/share/hunspell/ru_RU.dic
install -Dm644 ru_RU.aff $pkgdir/usr/share/hunspell/ru_RU.aff
ln -s ../../hunspell/ru_RU.dic $pkgdir/usr/share/myspell/dicts/ru_RU.dic
ln -s ../../hunspell/ru_RU.aff $pkgdir/usr/share/myspell/dicts/ru_RU.aff
}
