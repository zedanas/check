pkgname=('at-spi2-core')
pkgver=2.36.0
pkgrel=1
pkgdesc='Protocol definitions and daemon for D-Bus at-spi'
url='https://gitlab.gnome.org/GNOME/at-spi2-core'
license=('GPL2')
arch=('x86_64')
depends=(
'dbus'
'glib2'
'glibc'
'libx11'
'libxtst'
)
makedepends=(
'dbus-broker'
'git'
'gtk-doc'
'meson'
)
optdepends=('dbus-broker: Alternative bus implementation')
_commit='cf08453489c221499dc8a7c17e0955131f9dedf7'
sha256sums=('SKIP')
build() {
cd $pkgname
config_opts=(
	'-Denable_docs=false'
	'-Denable-introspection=no'
	'-Ddefault_bus=dbus-daemon'
	'-Denable-x11=yes'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
package() {
cd $pkgname
DESTDIR=$pkgdir ninja -C build install
}
