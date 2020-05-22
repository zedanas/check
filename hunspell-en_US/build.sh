pkgname='hunspell-en_US'
pkgver=2019.10.06
pkgrel=1
pkgdesc='US English hunspell dictionaries'
url='http://wordlist.aspell.net/dicts/'
license=('LGPL' 'custom:scowl')
arch=('any')
depends=('hunspell')
optdepends=('hunspell: the spell checking libraries and apps')
replaces=('hunspell-en')
conflicts=('hunspell-en')
source=("http://downloads.sourceforge.net/project/wordlist/speller/$pkgver/hunspell-en_US-large-$pkgver.zip")
sha1sums=('270cac9f07e6312266560cb4b63afb03a7d4f291')
package() {
mkdir -p $pkgdir/usr/share/myspell/dicts
install -Dm644 en_US-large.dic $pkgdir/usr/share/hunspell/en_US.dic
install -Dm644 en_US-large.aff $pkgdir/usr/share/hunspell/en_US.aff
ln -s ../../hunspell/en_US.dic $pkgdir/usr/share/myspell/dicts/en_US.dic
ln -s ../../hunspell/en_US.aff $pkgdir/usr/share/myspell/dicts/en_US.aff
}
