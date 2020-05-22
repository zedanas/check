pkgbase='unrar'
pkgname=('unrar' 'libunrar')
pkgver=5.9.2
pkgrel=1
epoch=1
url='https://www.rarlab.com/rar_add.htm'
license=('custom')
arch=('x86_64')
source=("https://www.rarlab.com/rar/unrarsrc-$pkgver.tar.gz")
sha256sums=('73d3baf18cf0a197976af2794a848893c35e7d42cee0ff364c89d2e476ebdaa6')
prepare() {
cd $pkgbase
sed -e "s/-O2/$CFLAGS/" -i makefile
sed -e "s/LDFLAGS=/LDFLAGS=$LDFLAGS /" -i makefile
}
build() {
cd $pkgbase
make clean
make unrar
make clean
make lib
}
package_unrar() {
pkgdesc='The RAR uncompression program'
depends=(
	'gcc-libs'
	'glibc'
)
cd $pkgbase
make DESTDIR=$pkgdir/usr install-unrar
install -Dm644 license.txt $pkgdir/usr/share/licenses/unrar/LICENSE
}
package_libunrar() {
pkgdesc='Library and header file for applications that use libunrar'
depends=(
	'gcc-libs'
	'glibc'
)
cd $pkgbase
mkdir -p $pkgdir/usr/lib
make DESTDIR=$pkgdir/usr install-lib
install -Dm644 dll.hpp $pkgdir/usr/include/unrar/dll.hpp
install -Dm644 license.txt $pkgdir/usr/share/licenses/libunrar/LICENSE
}
