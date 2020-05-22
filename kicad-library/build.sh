pkgbase='kicad-library'
pkgname=('kicad-library' 'kicad-library-3d')
pkgver=5.1.5
pkgrel=1
url='https://kicad.github.io/'
license=('GPL')
arch=('any')
makedepends=(
'cmake'
'tar'
)
source=(
"kicad-sym.$pkgver.tgz::https://github.com/KiCad/kicad-symbols/archive/$pkgver.tar.gz"
"kicad-foot.$pkgver.tgz::https://github.com/KiCad/kicad-footprints/archive/$pkgver.tar.gz"
"kicad-3d.$pkgver.tgz::https://github.com/KiCad/kicad-packages3D/archive/$pkgver.tar.gz"
)
md5sums=(
'943175449bd7a5e2733a16e896786da4'
'7722484abaf84a78dadc925070a07f7f'
'13ec0aeb37f90c5f6385ce3948cce778'
)
build() {
config_opts=(
	"-DCMAKE_C_FLAGS='$CFLAGS'"
	"-DCMAKE_CXX_FLAGS='$CXXFLAGS'"
	"-DCMAKE_LD_FLAGS='$LDFLAGS'"
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_BUILD_TYPE=Release'
)
cd $srcdir/kicad-symbols-$pkgver
mkdir -p build && cd build
cmake .. "${config_opts[@]}"
cd $srcdir/kicad-footprints-$pkgver
mkdir -p build && cd build
cmake .. "${config_opts[@]}"
cd $srcdir/kicad-packages3D-$pkgver
mkdir -p build && cd build
cmake .. "${config_opts[@]}"
}
package_kicad-library() {
pkgdesc='Kicad component and footprint libraries'
depends=()
cd $srcdir/kicad-symbols-$pkgver/build
make DESTDIR=$pkgdir install
cd $srcdir/kicad-footprints-$pkgver/build
make DESTDIR=$pkgdir install
}
package_kicad-library-3d() {
pkgdesc='Kicad 3D render model libraries'
depends=()
cd $srcdir/kicad-packages3D-$pkgver/build
make DESTDIR=$pkgdir install
}
