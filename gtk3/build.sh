pkgbase='gtk3'
pkgname=('gtk3' 'gtk-update-icon-cache')
pkgver=3.24.17
pkgrel=2
epoch=1
url='https://www.gtk.org/'
license=('LGPL')
arch=('x86_64')
makedepends=(
'git'
'glib2-docs'
'gobject-introspection'
'gtk-doc'
'meson'
'sassc'
'wayland-protocols'
)
_commit='4480c0ffc6858f8a324f841a318a6ed4b57dd629'
source=(
'settings.ini'
'gtk-query-immodules-3.0.hook'
'gtk-update-icon-cache.hook'
'gtk-update-icon-cache.script'
)
sha256sums=(
'SKIP'
'01fc1d81dc82c4a052ac6e25bf9a04e7647267cc3017bc91f9ce3e63e5eb9202'
'a0319b6795410f06d38de1e8695a9bf9636ff2169f40701671580e60a108e229'
'2d435e3bec8b79b533f00f6d04decb1d7c299c6e89b5b175f20be0459f003fe8'
'f1d3a0dbfd82f7339301abecdbe5f024337919b48bd0e09296bb0e79863b2541'
)
build() {
cd gtk
config_opts=(
	'-Dman=true'
	'-Dgtk_doc=true'
	'-Dprofiler=false'
	'-Dintrospection=false'
	'-Ddemos=true'
	'-Dexamples=true'
	'-Dtests=false'
	'-Dinstalled_tests=false'
	'-Dbroadway_backend=false'
	'-Dprint_backends=file'
	'-Dbuiltin_immodules=no'
	'-Dcolord=no'
	'-Dcloudproviders=false'
	'-Dx11_backend=true'
	'-Dxinerama=yes'
	'-Dmir_backend=false'
	'-Dwayland_backend=false'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
package_gtk3() {
pkgdesc='GObject-based multi-platform GUI toolkit'
depends=(
	'adwaita-icon-theme'
	'at-spi2-atk'
	'atk'
	'cairo'
	'desktop-file-utils'
	'fontconfig'
	'freetype2'
	'fribidi'
	'gdk-pixbuf2'
	'glib2'
	'glibc'
	'gtk-update-icon-cache'
	'harfbuzz'
	'libcanberra'
	'libepoxy'
	'libx11'
	'libxcomposite'
	'libxcursor'
	'libxdamage'
	'libxext'
	'libxfixes'
	'libxi'
	'libxinerama'
	'libxrandr'
	'pango'
	'shared-mime-info'
)
provides=(
	'gtk3-print-backends'
	'libgtk-3.so'
	'libgdk-3.so'
	'libgailutil-3.so'
)
conflicts=('gtk3-print-backends')
replaces=("gtk3-print-backends<=3.22.26-1")
install='gtk3.install'
cd gtk
DESTDIR=$pkgdir ninja -C build install
cd $pkgdir
install -Dm644 $srcdir/settings.ini usr/share/gtk-3.0/settings.ini
install -Dm644 $srcdir/gtk-query-immodules-3.0.hook \
usr/share/libalpm/hooks/gtk-query-immodules-3.0.hook
mkdir -p $srcdir/gtk-update-icon-cache/usr/bin
mv usr/bin/gtk-update-icon-cache \
$srcdir/gtk-update-icon-cache/usr/bin/gtk-update-icon-cache || true
}
package_gtk-update-icon-cache() {
pkgdesc='GTK+ icon cache updater'
depends=(
	'bash'
	'gdk-pixbuf2'
	'glib2'
	'glibc'
	'hicolor-icon-theme'
)
mv $srcdir/gtk-update-icon-cache/* $pkgdir
install -D $srcdir/gtk-update-icon-cache.script \
$pkgdir/usr/share/libalpm/scripts/gtk-update-icon-cache
install -Dm644 $srcdir/gtk-update-icon-cache.hook \
$pkgdir/usr/share/libalpm/hooks/gtk-update-icon-cache.hook
}
