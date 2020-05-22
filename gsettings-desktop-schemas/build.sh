pkgname=('gsettings-desktop-schemas')
pkgver=3.36.0
pkgrel=1
pkgdesc='Shared GSettings schemas for the desktop'
url='https://gitlab.gnome.org/GNOME/gsettings-desktop-schemas'
license=('GPL')
arch=('any')
depends=('glib2')
makedepends=(
'git'
'gobject-introspection'
'meson'
)
_commit='bfcbf5ec03f84b6cffa7d8c1361953797ccd0d1e'
sha256sums=('SKIP')
build() {
cd $pkgname
config_opts=(
	'-Dintrospection=false'
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
