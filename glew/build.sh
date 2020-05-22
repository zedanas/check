pkgname=('glew')
pkgver=2.1.0
pkgrel=1
pkgdesc='The OpenGL Extension Wrangler Library'
url='http://glew.sourceforge.net'
license=('BSD' 'MIT' 'GPL')
arch=('x86_64')
depends=(
'glibc'
'libglvnd'
'libx11'
)
source=("https://downloads.sourceforge.net/$pkgname/$pkgname-$pkgver.tgz")
sha1sums=('18eca05460d0b61709fc115e632b6fe320718b44')
prepare() {
cd $pkgname-$pkgver
sed  's/lib64/lib/' -i config/Makefile.linux
sed -e "s/-O2/$CFLAGS/" -i config/Makefile.linux
sed -e "s/-shared/$LDFLAGS -shared/" -i config/Makefile.linux
}
build() {
cd $pkgname-$pkgver
make
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install.all
install -Dm644 LICENSE.txt $pkgdir/usr/share/licenses/glew/LICENSE
}
