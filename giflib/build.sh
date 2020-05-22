pkgname='giflib'
pkgver=5.2.1
pkgrel=1
pkgdesc='Library for reading and writing gif images'
url='http://giflib.sourceforge.net/'
license=('MIT')
arch=('x86_64')
depends=('glibc')
makedepends=(
'docbook-xml'
'docbook-xsl'
'xmlto'
)
provides=('libgif.so')
source=(
"https://downloads.sourceforge.net/project/$pkgname/$pkgname-$pkgver.tar.gz"
'giflib-5.1.9-fix-missing-quantize-API-symbols.patch'
'giflib-5.1.9-make-flags.patch'
)
sha512sums=(
'4550e53c21cb1191a4581e363fc9d0610da53f7898ca8320f0d3ef6711e76bdda2609c2df15dc94c45e28bff8de441f1227ec2da7ea827cb3c0405af4faa4736'
'5de1e8724f5221fa3637b4e6a482f650f7608673e2c9200233290018ec8a0bf1beea049b3979b5f57dbf2b2a5fda409324e636e9af10582fd01c71d92d4de3b3'
'b9afd436c31b971087485c7b476f796817e6ee4f237ef8a0e61e47f8ac59fbe5e673d7194895fcc9aafbb79f133469d27c2f69041ae0cccd9acb78667c0222dd'
)
prepare() {
cd $pkgname-$pkgver
patch -p1 -i $srcdir/giflib-5.1.9-fix-missing-quantize-API-symbols.patch
patch -p1 -i $srcdir/giflib-5.1.9-make-flags.patch
}
build() {
cd $pkgname-$pkgver
make
}
check() {
cd $pkgname-$pkgver
make -k check
}
package() {
cd $pkgname-$pkgver
make PREFIX=/usr DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/giflib/LICENSE
}
