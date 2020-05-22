pkgbase='libsigc++'
pkgname=('libsigc++' 'libsigc++-docs')
pkgver=2.10.3
pkgrel=1
url='http://libsigc.sourceforge.net/'
license=('LGPL')
arch=('x86_64')
makedepends=(
'doxygen'
'git'
'graphviz'
'libxslt'
'meson'
'mm-common'
)
_commit='88fdb3a14ec67de233fed22646fc9b14c24367f5'
sha256sums=('SKIP')
build() {
cd libsigcplusplus
config_opts=(
	'-Dwarnings=min'
	'-Dvalidation=false'
	'-Dmaintainer-mode=true'
	'-Dbuild-documentation=true'
	'-Dbuild-deprecated-api=true'
	'-Dbuild-pdf=false'
	'-Dbuild-examples=false'
	'-Dbenchmark=false'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd libsigcplusplus
ninja -C build test
}
package_libsigc++ () {
pkgdesc='Callback Framework for C++'
depends=(
	'gcc-libs'
	'glibc'
)
provides=("libsigc++2.0=$pkgver")
conflicts=('libsigc++2.0')
replaces=('libsigc++2.0')
cd libsigcplusplus
DESTDIR=$pkgdir ninja -C build install
cd $pkgdir
mkdir -p $srcdir/libsig-docs/usr
mv usr/share $srcdir/libsig-docs/usr || true
}
package_libsigc++-docs() {
pkgdesc='Callback Framework for C++ (documentation)'
depends=('libsigc++')
provides=("libsigc++2.0-docs=$pkgver")
conflicts=('libsigc++2.0-docs')
replaces=('libsigc++2.0-docs')
mv $srcdir/libsig-docs/* $pkgdir
}
