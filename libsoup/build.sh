pkgname=('libsoup')
pkgver=2.70.0
pkgrel=1
pkgdesc='HTTP client/server library for GNOME'
url='https://wiki.gnome.org/Projects/libsoup'
license=('LGPL')
arch=('x86_64')
depends=(
'brotli'
'glib2'
'glibc'
'libpsl'
'libxml2'
'sqlite'
'zlib'
)
makedepends=(
'git'
'gtk-doc'
'intltool'
'python'
'vala'
'meson'
)
checkdepends=(
'apache'
'php-apache'
)
optdepends=('samba: Windows Domain SSO')
provides=(
'libsoup-2.4.so'
'libsoup-gnome-2.4.so'
)
_commit='3857ea93dd3775d68010efed7ad3245714fee379'
sha256sums=('SKIP')
prepare() {
cd $pkgname
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname
config_opts=(
	'-Dntlm=disabled'
	'-Dgnome=true'
	'-Dgtk_doc=true'
	'-Dtests=false'
	'-Dinstalled_tests=false'
	'-Dintrospection=disabled'
	'-Dbrotli=enabled'
	'-Dtls_check=false'
	'-Dgssapi=disabled'
	'-Dvapi=disabled'
)
arch-meson build ${config_opts[@]}
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
