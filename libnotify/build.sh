pkgname=('libnotify')
pkgver=0.7.9
pkgrel=1
pkgdesc='Library for sending desktop notifications'
url='https://developer.gnome.org/notification-spec/'
license=('LGPL')
arch=('x86_64')
depends=(
'gdk-pixbuf2'
'glib2'
'glibc'
)
makedepends=(
'docbook-xsl'
'git'
'gnome-common'
'gobject-introspection'
'gtk-doc'
'gtk3'
'meson'
'xmlto'
)
provides=('libnotify.so')
_commit='98a4bf483a69c6436311bcb9834d9d93235c96b7'
sha256sums=('SKIP')
build() {
cd $pkgname
config_opts=(
	'-Dtests=false'
	'-Dman=true'
	'-Dgtk_doc=true'
	'-Ddocbook_docs=disabled'
	'-Dintrospection=disabled'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
package() {
cd $pkgname
DESTDIR=$pkgdir ninja -C build install
}
