pkgname=('libsecret')
pkgver=0.20.2
pkgrel=1
pkgdesc='Library for storing and retrieving passwords and other secrets'
url='https://wiki.gnome.org/Projects/Libsecret'
license=('LGPL')
arch=('x86_64')
depends=(
'glib2'
'glibc'
'libgcrypt'
)
makedepends=(
'docbook-xsl'
'git'
'gobject-introspection'
'gtk-doc'
'meson'
)
checkdepends=(
'dbus-glib'
'gjs'
'python-dbus'
'python-gobject'
)
optdepends=(
'gnome-keyring: key storage service, or use any other service implementing org.freedesktop.secrets'
)
provides=('libsecret-1.so')
_commit='eb4f967e9f18d5e2fa18f00d863d9193e1f0aa7d'
sha256sums=('SKIP')
build() {
cd $pkgname
config_opts=(
	'-Ddebugging=false'
	'-Dmanpage=true'
	'-Dgtk_doc=true'
	'-Dgcrypt=true'
	'-Dvapi=false'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd $pkgname
dbus-run-session ninja -C build test
}
package() {
cd $pkgname
DESTDIR=$pkgdir ninja -C build install
}
