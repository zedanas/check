pkgname=('libwnck3')
pkgver=3.36.0
pkgrel=1
pkgdesc='Library to manage X windows and workspaces (via pagers, tasklists, etc.)'
url='https://gitlab.gnome.org/GNOME/libwnck'
license=('LGPL')
arch=('x86_64')
depends=(
'atk'
'cairo'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'libx11'
'libxrender'
'libxres'
'pango'
'startup-notification'
)
makedepends=(
'git'
'gobject-introspection'
'gtk-doc'
'meson'
)
_commit='3c469a0d7e58e36106eea7600ae2f6fd8aaed232'
sha256sums=('SKIP')
build() {
cd libwnck
config_opts=(
	'-Dgtk_doc=false'
	'-Dintrospection=disabled'
	'-Dstartup_notification=enabled'
	'-Dinstall_tools=true'
	'-Ddeprecation_flags=false'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd $pkgname
ninja -C build test
}
package() {
cd libwnck
DESTDIR=$pkgdir ninja -C build install
}
