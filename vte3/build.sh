pkgbase='vte3'
pkgname=('vte3' 'vte-common')
pkgver=0.60.1
pkgrel=1
url='https://wiki.gnome.org/Apps/Terminal/VTE'
license=('LGPL')
arch=('x86_64')
makedepends=(
'git'
'glade'
'gobject-introspection'
'gperf'
'gtk-doc'
'intltool'
'meson'
'vala'
)
_commit='606a55cbe2f1aba42023f19f3b2d2ccf4c90573b'
sha256sums=('SKIP')
build() {
cd vte
config_opts=(
	'-Db_lto=false'
	'-Ddebugg=false'
	'-Ddocs=true'
	'-Dgir=false'
	'-Diconv=true'
	'-Da11y=true'
	'-Dfribidi=true'
	'-Dgnutls=true'
	'-Dgtk3=true'
	'-Dgtk4=false'
	'-Dicu=true'
	'-D_systemd=true'
	'-Dvapi=false'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd vte
ninja -C build test
}
package_vte3() {
pkgdesc='Virtual Terminal Emulator widget for use with GTK3'
depends=(
	'atk'
	'cairo'
	'fribidi'
	'gcc-libs'
	'gdk-pixbuf2'
	'glib2'
	'glibc'
	'gnutls'
	'gtk3'
	'icu'
	'pango'
	'pcre2'
	'systemd-libs'
	'vte-common'
	'zlib'
)
provides=('libvte-2.91.so')
cd vte
DESTDIR=$pkgdir ninja -C build install
cd $pkgdir
mkdir -p $srcdir/vte-common/usr/lib
mv etc $srcdir/vte-common || true
mv usr/lib/vte-urlencode-cwd $srcdir/vte-common/usr/lib || true
mv usr/lib/systemd $srcdir/vte-common/usr/lib || true
}
package_vte-common() {
pkgdesc='Files shared by VTE libraries'
depends=(
	'glibc'
	'sh'
)
mv $srcdir/vte-common/* $pkgdir
}
