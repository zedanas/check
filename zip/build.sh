pkgname=('zip')
pkgver=3.0
pkgrel=8
pkgdesc='Compressor/archiver for creating and modifying zipfiles'
url='http://www.info-zip.org/Zip.html'
license=('custom')
arch=('x86_64')
depends=(
'bzip2'
'glibc'
)
_pkgver=${pkgver/./}
source=(
"https://downloads.sourceforge.net/infozip/${pkgname}${pkgver/./}.tar.gz"
'zipnote.patch'
)
sha256sums=(
'f0e8bb1f9b7eb0b01285495a2699df3a4b766784c1765a8f1aeedf63c0806369'
'89249a3f1fdf838b795ce432a2d763fdbe913d6a146541e41b7a2e2769291ba0'
)
prepare() {
cd ${pkgname}${pkgver/./}
patch -p1 -i $srcdir/zipnote.patch
sed -e "s/CFLAGS_NOOPT =/CFLAGS_NOOPT = $CPPFLAGS $CFLAGS/" -i unix/Makefile
sed -e "s/LFLAGS1=''/LFLAGS1=$LDFLAGS/" -i unix/configure
}
build() {
cd ${pkgname}${pkgver/./}
make -f unix/Makefile generic_gcc
}
package() {
cd ${pkgname}${pkgver/./}
make -f unix/Makefile prefix=$pkgdir/usr MANDIR=$pkgdir/usr/share/man/man1 install
install -Dm644 LICENSE $pkgdir/usr/share/licenses/zip/LICENSE
}
