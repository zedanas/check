pkgname=('evince')
pkgver=3.36.0
pkgrel=1
pkgdesc='Document viewer (PDF, Postscript, djvu, tiff, dvi, XPS, SyncTex support with gedit, comics books (cbr,cbz,cb7 and cbt))'
url='https://wiki.gnome.org/Apps/Evince'
license=('GPL')
arch=('x86_64')
groups=('gnome')
depends=(
'atk'
'cairo'
'djvulibre'
'gcc-libs'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'libarchive'
'libsecret'
'libtiff'
'libxml2'
'pango'
'poppler-glib'
'zlib'
)
makedepends=(
'appstream-glib'
'docbook-xsl'
'git'
'gnome-common'
'gobject-introspection'
'gtk-doc'
'intltool'
'itstool'
'meson'
'python'
'yelp-tools'
)
optdepends=(
'texlive-bin: DVI support'
'gvfs: bookmark support and session saving'
)
provides=(
'libevdocument3.so'
'libevview3.so'
)
_commit='605711b172378fb55192b984455e0af8e00b3181'
sha256sums=('SKIP')
build() {
cd $pkgname
config_opts=(
	'-Dgtk_doc=true'
	'-Ddbus=true'
	'-Dviewer=true'
	'-Dpreviewer=true'
	'-Dthumbnailer=true'
	'-Dintrospection=false'
	'-Dgtk_unix_print=enabled'
	'-Ddjvu=enabled'
	'-Dbrowser_plugin=true'
	'-Dthumbnail_cache=disabled'
	'-Dgspell=disabled'
	'-Dmultimedia=disabled'
	'-Dcomics=enabled'
	'-Dxps=disabled'
	'-Dnautilus=false'
	'-Dkeyring=enabled'
	'-Dps=disabled'
	'-Dtiff=enabled'
	'-Dpdf=enabled'
	'-Dt1lib=disabled'
	'-Ddvi=disabled'
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
