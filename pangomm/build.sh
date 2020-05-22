pkgbase='pangomm'
pkgname=('pangomm' 'pangomm-docs')
pkgver=2.42.1
pkgrel=2
url='https://www.gtkmm.org/'
license=('LGPL')
arch=('x86_64')
makedepends=(
'cairomm-docs'
'git'
'glibmm-docs'
'meson'
'mm-common'
)
_commit='7dfc6c3372faaa4a7c492d08f09881b02095145b'
sha256sums=('SKIP')
build() {
cd $pkgbase
config_opts=(
	'-Dmaintainer-mode=true'
	'-Dbuild-deprecated-api=true'
	'-Dbuild-documentation=true'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd $pkgbase
ninja -C build test
}
package_pangomm() {
pkgdesc='C++ bindings for Pango'
depends=(
	'cairomm'
	'gcc-libs'
	'glib2'
	'glibc'
	'glibmm'
	'libsigc++'
	'pango'
)
cd $pkgbase
DESTDIR=$pkgdir ninja -C build install
cd $pkgdir
mkdir -p $srcdir/pangomm-docs/usr
mv usr/share $srcdir/pangomm-docs/usr || true
}
package_pangomm-docs() {
pkgdesc='C++ bindings for Pango (documentation)'
depends=()
options=('docs')
mv $srcdir/pangomm-docs/* $pkgdir
}
