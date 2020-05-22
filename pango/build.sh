pkgname=('pango')
pkgver=1.44.8
pkgrel=1
epoch=1
pkgdesc='A library for layout and rendering of text'
url='https://www.pango.org/'
license=('LGPL')
arch=('x86_64')
depends=(
'cairo'
'fontconfig'
'freetype2'
'fribidi'
'glib2'
'glibc'
'harfbuzz'
'libx11'
'libxft'
'libxrender'
)
makedepends=(
'git'
'gobject-introspection'
'gtk-doc'
'help2man'
'meson'
)
checkdepends=(
'ttf-dejavu'
'cantarell-fonts'
)
provides=(
'libpangocairo-1.0.so'
'libpangoft2-1.0.so'
'libpangoxft-1.0.so'
)
_commit='73b46b04c724335ad73534cc69955baa2388b861'
source=(
'0001-Use-shape-flags-for-tab-width.patch'
'test.diff'
)
sha256sums=(
'SKIP'
'd87bf1bb8dcd7edba0d8f49ddc7fd6bd9965f21a38f186fbfb297828ad53f4d1'
'401b51f3aee44510fc94878b5549ff4a4a6d79584b5d6df2dd7e0978b9d574ce'
)
prepare() {
cd $pkgname
git apply -3 $srcdir/0001-Use-shape-flags-for-tab-width.patch
git apply -3 $srcdir/test.diff
}
build() {
cd $pkgname
config_opts=(
	'-Dgtk_doc=true'
	'-Dintrospection=false'
	'-Dinstall-tests=false'
	'-Duse_fontconfig=true'
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
}
