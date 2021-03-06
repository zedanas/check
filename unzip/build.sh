pkgname=('unzip')
pkgver=6.0
pkgrel=13
pkgdesc='For extracting and viewing files in .zip archives'
url='https://www.info-zip.org/UnZip.html'
license=('custom')
arch=('x86_64')
depends=(
'bash'
'glibc'
'grep'
)
source=(
"https://downloads.sourceforge.net/infozip/${pkgname}${pkgver/./}.tar.gz"
'overflow-fsize.patch'
'cve20149636.patch'
'test_compr_eb.patch'
'getZip64Data.patch'
'crc32.patch'
'empty-input.patch'
'csiz-underflow.patch'
'nextbyte-overflow.patch'
)
sha1sums=(
'abf7de8a4018a983590ed6f5cbd990d4740f8a22'
'2852ce1a9db8d646516f8828436a44d34785a0b3'
'e8c0bc17c63eeed97ad62b86845d75c849bcf4f8'
'614c3e7fa7d6da7c60ea2aa79e36f4cbd17c3824'
'691d0751bf0bc98cf9f9889dee39baccabefdc4d'
'82c9fe9172779a0ee92a187d544e74e8f512b013'
'4f77b01454fd2ffa69bfad985bfbdc579ee26010'
'dccc6d6a5aed0098031bbd7cc4275ab9b10a2177'
'b325fac556abf169264ed5ae364b9136016e43f3'
)
prepare() {
cd ${pkgname}${pkgver/./}
patch -p1 -i $srcdir/overflow-fsize.patch
patch -p1 -i $srcdir/cve20149636.patch
patch -i $srcdir/test_compr_eb.patch
patch -i $srcdir/getZip64Data.patch
patch -i $srcdir/crc32.patch
patch -p1 -i $srcdir/empty-input.patch
patch -p1 -i $srcdir/csiz-underflow.patch
patch -p1 -i $srcdir/nextbyte-overflow.patch
sed -e "s/CF_NOOPT =/CF_NOOPT = $CFLAGS/" -i unix/Makefile
sed -e "s/LFLAGS1=\"\"/LFLAGS1=$LDFLAGS/" -i unix/configure
}
build() {
cd ${pkgname}${pkgver/./}
make -f unix/Makefile generic_gcc
}
package() {
cd ${pkgname}${pkgver/./}
make -f unix/Makefile prefix=$pkgdir/usr MANDIR=$pkgdir/usr/share/man/man1 install
install -Dm644 LICENSE $pkgdir/usr/share/licenses/unzip/LICENSE
}
