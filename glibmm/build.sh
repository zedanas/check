pkgbase='glibmm'
pkgname=('glibmm' 'glibmm-docs')
pkgver=2.64.2
pkgrel=1
url='https://www.gtkmm.org/'
license=('LGPL')
arch=('x86_64')
makedepends=(
'clang'
'git'
'meson'
'mm-common'
'perl-xml-parser'
)
checkdepends=('glib-networking')
_commit='e775940669cb6d93f37ddc2b4cd7da446dfa482c'
sha256sums=('SKIP')
build() {
cd $pkgbase
config_opts=(
	'-Dmaintainer-mode=true'
	'-Dbuild-documentation=true'
	'-Dbuild-examples=false'
	'-Dbuild-deprecated-api=true'
	'-Ddebug-refcounting=false'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd $pkgbase
ninja -C build test
}
package_glibmm() {
pkgdesc='C++ bindings for GLib'
depends=(
	'gcc-libs'
	'glib2'
	'glibc'
	'libsigc++'
	'perl'
)
cd $pkgbase
DESTDIR=$pkgdir ninja -C build install
cd $pkgdir
mkdir -p $srcdir/glibmm-docs/usr
mv usr/share $srcdir/glibmm-docs/usr || true
}
package_glibmm-docs() {
pkgdesc='C++ bindings for GLib (documentation)'
depends=('glibmm')
options=('docs')
mv $srcdir/glibmm-docs/* $pkgdir
}
