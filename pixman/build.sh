pkgname=('pixman')
pkgver=0.38.4
pkgrel=1
pkgdesc='The pixel-manipulation library for X and cairo'
url='https://cgit.freedesktop.org/pixman/'
license=('custom')
arch=('x86_64')
depends=('glibc')
makedepends=(
'meson'
'libpng'
)
source=("https://xorg.freedesktop.org/releases/individual/lib/$pkgname-$pkgver.tar.bz2")
sha1sums=('87e1abc91ac4e5dfcc275f744f1d0ec3277ee7cd')
build() {
cd $pkgname-$pkgver
config_opts=(
	'-Dloongson-mmi=disabled'
	'-Dvmx=disabled'
	'-Darm-simd=disabled'
	'-Dneon=disabled'
	'-Diwmmxt=disabled'
	'-Diwmmxt2=false'
	'-Dmips-dspr2=disabled'
	'-Dmmx=enabled'
	'-Dsse2=enabled'
	'-Dssse3=enabled'
	'-Dgnu-inline-asm=enabled'
	'-Dopenmp=enabled'
	'-Dgnuplot=true'
	'-Dgtk=disabled'
	'-Dlibpng=enabled'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd $pkgname-$pkgver
ninja -C build test
}
package() {
cd $pkgname-$pkgver
DESTDIR=$pkgdir ninja -C build install
install -Dm644 COPYING $pkgdir/usr/share/licenses/pixman/COPYING
}
