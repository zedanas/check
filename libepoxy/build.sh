pkgname=('libepoxy')
pkgver=1.5.4
pkgrel=1
pkgdesc='Library handling OpenGL function pointer management'
url='https://github.com/anholt/libepoxy'
license=('MIT')
arch=('x86_64')
depends=('glibc')
makedepends=(
'doxygen'
'git'
'mesa-libgl'
'meson'
)
_commit='09edbe01d901c0f01e866aa08455c6d9ee6fd0ac'
sha256sums=('SKIP')
build() {
cd $pkgname
config_opts=(
	'-Dx11=true'
	'-Dglx=yes'
	'-Degl=yes'
	'-Ddocs=false'
	'-Dtests=false'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd $pkgname
ninja -C build test
}
package() {
cd $pkgname
DESTDIR=$pkgdir ninja -C build install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libepoxy/COPYING
}
