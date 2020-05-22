pkgname=('bzip2')
pkgver=1.0.8
pkgrel=3
pkgdesc='A high-quality data compression program'
url='https://sourceware.org/bzip2/'
license=('custom')
arch=('x86_64')
groups=('base')
depends=(
'glibc'
'grep'
'less'
'sh'
)
source=(
"https://sourceware.org/pub/$pkgname/$pkgname-$pkgver.tar.gz"
"https://sourceware.org/pub/$pkgname/$pkgname-$pkgver.tar.gz.sig"
)
sha256sums=(
'ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
sed -e "s/-O2/$CFLAGS/" -i Makefile Makefile-libbz2_so
sed -e "s/ -shared / $LDFLAGS\0/g" -i Makefile-libbz2_so
}
build() {
cd $pkgname-$pkgver
make -f Makefile-libbz2_so
make LDFLAGS=$LDFLAGS
}
check() {
cd $pkgname-$pkgver
make -k check
}
package() {
cd $pkgname-$pkgver
make PREFIX=$pkgdir/usr install
install -Dm644 LICENSE $pkgdir/usr/share/licenses/bzip2/LICENSE
install -m755 libbz2.so.* $pkgdir/usr/lib
ln -sf libbz2.so.$pkgver $pkgdir/usr/lib/libbz2.so
ln -sf libbz2.so.$pkgver $pkgdir/usr/lib/libbz2.so.1
ln -sf libbz2.so.$pkgver $pkgdir/usr/lib/libbz2.so.1.0
cd $pkgdir
rm usr/lib/libbz2.a
mkdir -p usr/share
mv usr/man usr/share
ln -sf bzip2.1 usr/share/man/man1/bunzip2.1
ln -sf bzip2.1 usr/share/man/man1/bzcat.1
ln -sf bzip2.1 usr/share/man/man1/bzip2recover.1
ln -sf bzgrep $pkgdir/usr/bin/bzegrep
ln -sf bzgrep $pkgdir/usr/bin/bzfgrep
ln -sf bzmore $pkgdir/usr/bin/bzless
ln -sf bzdiff $pkgdir/usr/bin/bzcmp
}
