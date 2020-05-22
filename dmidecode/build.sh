pkgname=('dmidecode')
pkgver=3.2
pkgrel=1
pkgdesc='Desktop Management Interface table related utilities'
url='https://www.nongnu.org/dmidecode'
license=('GPL')
arch=('x86_64')
depends=('glibc')
source=(
"https://download.savannah.nongnu.org/releases/$pkgname/$pkgname-$pkgver.tar.xz"
"https://download.savannah.nongnu.org/releases/$pkgname/$pkgname-$pkgver.tar.xz.sig"
)
sha256sums=(
'077006fa2da0d06d6383728112f2edef9684e9c8da56752e97cd45a11f838edd'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
sed -e 's:sbin:bin:g' -i Makefile
}
build() {
cd $pkgname-$pkgver
make CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS"
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir prefix=/usr install
install -Dm644 LICENSE $pkgdir/usr/share/licenses/dmidecode/LICENSE
}
