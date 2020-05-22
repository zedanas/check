pkgname='at-spi2-atk'
pkgver=2.34.2
pkgrel=1
pkgdesc='A GTK+ module that bridges ATK to D-Bus at-spi'
url='https://wiki.gnome.org/Accessibility'
license=('LGPL')
arch=('x86_64')
depends=(
'at-spi2-core'
'atk'
'dbus'
'glib2'
'glibc'
)
makedepends=(
'git'
'meson'
)
_commit='eac8e935128753f8204ecc3904e6e3e7b231e3ea'
sha256sums=('SKIP')
build() {
cd $pkgname
config_opts=(
	'-Ddisable_p2p=false'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
package() {
cd $pkgname
DESTDIR=$pkgdir ninja -C build install
}
