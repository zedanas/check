pkgname=('lz4')
pkgver=1.9.2
pkgrel=2
epoch=1
pkgdesc='Extremely fast compression algorithm'
url='http://www.lz4.org/'
license=('GPL2')
arch=('x86_64')
depends=('glibc')
makedepends=('git')
checkdepends=('diffutils')
md5sums=('SKIP')
prepare() {
cd $pkgname
sed -e "s/CFLAGS   ?= -O3/CFLAGS   ?= $CFLAGS/" -i programs/Makefile
}
build() {
cd $pkgname
make
}
check() {
cd $pkgname
make -k test
}
package() {
cd $pkgname
make DESTDIR=$pkgdir PREFIX=/usr install
}
