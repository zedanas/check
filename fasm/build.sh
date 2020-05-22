pkgname=('fasm')
pkgver=1.73.13
pkgrel=1
pkgdesc='Fast and efficient self-assembling x86 assembler for DOS, Windows and Linux operating systems'
url='https://flatassembler.net/'
license=('custom')
arch=('x86_64')
source=("https://flatassembler.net/$pkgname-$pkgver.tgz")
sha256sums=('c85caaf6cd8b7fd71f64d3408648cc121ce79c975b32e73d418ecbaacf8189bc')
package() {
cd $pkgname
install -Dm755 $srcdir/fasm/fasm.x64 $pkgdir/usr/bin/fasm
install -Dm644 fasm.txt $pkgdir/usr/share/doc/fasm/fasm.txt
install -Dm644 whatsnew.txt $pkgdir/usr/share/doc/fasm/whatsnew.txt
install -Dm644 license.txt $pkgdir/usr/share/licenses/fasm/LICENSE
}
