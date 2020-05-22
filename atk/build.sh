pkgname=('atk')
pkgver=2.36.0
pkgrel=1
pkgdesc='The interface definitions of accessibility infrastructure'
url='https://gitlab.gnome.org/GNOME/atk'
license=('LGPL')
arch=('x86_64')
depends=(
'glib2'
'glibc'
)
makedepends=(
'git'
'gobject-introspection'
'gtk-doc'
'meson'
)
provides=('libatk-1.0.so')
_commit='dbe95f6170ae1f4bb76c755506b4e3dd3990d5aa'
sha256sums=('SKIP')
build() {
cd $pkgname
config_opts=(
	'-Ddocs=false'
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
