pkgname=('gdk-pixbuf2')
pkgver=2.40.0
pkgrel=2
pkgdesc='An image loading library'
url='https://wiki.gnome.org/Projects/GdkPixbuf'
license=('LGPL2.1')
arch=('x86_64')
depends=(
'glib2'
'glibc'
'shared-mime-info'
'libjpeg'
'libpng'
'libtiff'
'libx11'
)
makedepends=(
'gobject-introspection'
'docbook-xsl'
'git'
'gtk-doc'
'meson'
)
install='gdk-pixbuf2.install'
source=(
'gdk-pixbuf-query-loaders.hook'
)
sha256sums=(
'SKIP'
'9fb71d95e6a212779eb0f88dde5a3cee0df7f4d9183f8f9ce286f8cdc14428f0'
)
build() {
cd gdk-pixbuf
config_opts=(
	'-Dgio_sniffing=true'
	'-Dinstalled_tests=false'
	'-Drelocatable=false'
	'-Dman=true'
	'-Ddocs=false'
	'-Dgir=false'
	'-Djasper=false'
	'-Djpeg=true'
	'-Dpng=true'
	'-Dtiff=true'
	'-Dx11=true'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd gdk-pixbuf
ninja -C build test
}
package() {
cd gdk-pixbuf
DESTDIR=$pkgdir ninja -C build install
install -Dm644 $srcdir/gdk-pixbuf-query-loaders.hook \
$pkgdir/usr/share/libalpm/hooks/gdk-pixbuf-query-loaders.hook
rm -rf $pkgdir/usr/{lib,share}/installed-tests
}
