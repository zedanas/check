pkgname='kicad'
pkgver=5.1.5
pkgrel=1
pkgdesc='Electronic schematic and printed circuit board (PCB) design tools'
url='http://kicad-pcb.org/'
license=('GPL')
arch=('x86_64')
depends=(
'cairo'
'desktop-file-utils'
'gcc-libs'
'glew'
'glibc'
'glu'
'hicolor-icon-theme'
'libglvnd'
'ngspice'
'openssl'
'pixman'
'wxgtk-common'
'wxgtk3'
)
makedepends=(
'boost'
'cmake'
'gettext'
'glm'
'mesa'
'opencascade'
'python-wxpython'
'swig'
'zlib'
)
optdepends=(
'kicad-library: for footprints and symbols'
'kicad-library-3d: for 3d models of components'
)
source=(
"https://launchpad.net/$pkgname/5.0/$pkgver/+download/$pkgname-$pkgver.tar.xz"
"kicad-i18n.$pkgver.tar.gz::https://github.com/KiCad/$pkgname-i18n/archive/$pkgver.tar.gz"
)
sha512sums=(
'5ca19e219da07a906f13e236849eb4497c9f827726a5cd13aceffe1d8c7dee480823bf3e949527f59a805eb3b8176fad51576ae663dd07b10e2822f2b37866a5'
'68e6602fcc7e73c22a594b45ecf53a956af8a134e28e86242bfaa4087df21c04b24ae4df9928f00c2cee7eb0631a02a4de1cd09547b36a466fb324f983ea5363'
)
build() {
cd $srcdir/$pkgbase-$pkgver
config_opts=(
	"-DCMAKE_C_FLAGS='$CFLAGS -fno-lto'"
	"-DCMAKE_CXX_FLAGS='$CXXFLAGS -fno-lto'"
	"-DCMAKE_LD_FLAGS='$LDFLAGS'"
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_INSTALL_LIBDIR=lib'
	'-DKICAD_INSTALL_DEMOS=OFF'
	'-DKICAD_BUILD_QA_TESTS=ON'
	'-DCMAKE_BUILD_TYPE=Release'
	'-DBUILD_GITHUB_PLUGIN=OFF'
	'-DUSE_WX_GRAPHICS_CONTEXT=OFF'
	'-DUSE_WX_OVERLAY=ON'
	'-DBoost_INCLUDE_DIR=/usr/include/boost'
	'-DwxWidgets_CONFIG_EXECUTABLE=/usr/bin/wx-config-gtk3'
	'-DKICAD_SPICE=ON'
	'-DKICAD_USE_OCC=OFF'
	'-DKICAD_USE_OCE=OFF'
	'-DKICAD_SCRIPTING=OFF'
	'-DKICAD_SCRIPTING_ACTION_MENU=OFF'
	'-DKICAD_SCRIPTING_MODULES=OFF'
	'-DKICAD_SCRIPTING_WXPYTHON=OFF'
	'-DKICAD_SCRIPTING_WXPYTHON_PHOENIX=OFF'
	'-DKICAD_SCRIPTING_PYTHON3=OFF'
)
mkdir -p build && cd build
cmake .. "${config_opts[@]}"
make
cd $srcdir/$pkgname-i18n-$pkgver
config_opts=(
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_BUILD_TYPE=Release'
)
mkdir -p build && cd build
cmake .. "${config_opts[@]}"
make
}
package() {
cd $srcdir/$pkgbase-$pkgver/build
make DESTDIR=$pkgdir install
cd $srcdir/$pkgname-i18n-$pkgver/build
make DESTDIR=$pkgdir install
}
