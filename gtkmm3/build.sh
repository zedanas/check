pkgbase='gtkmm3'
pkgname=('gtkmm3' 'gtkmm3-docs')
pkgver=3.24.2
pkgrel=1
pkgdesc='C++ bindings for GTK+ 3'
url='http://www.gtkmm.org/'
license=('LGPL')
arch=('x86_64')
makedepends=(
'atkmm-docs'
'cairomm-docs'
'git'
'glibmm-docs'
'mm-common'
'pangomm-docs'
)
_commit='72c50bb8629558e1f0df3d86c16e4290cc94fd5e'
sha256sums=('SKIP')
prepare() {
cd gtkmm
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd gtkmm
config_opts=(
	'--prefix=/usr'
	'--bindir=/usr/bin'
	'--sbindir=/usr/bin'
	'--libdir=/usr/lib'
	'--libexecdir=/usr/lib'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--enable-documentation'
	'--enable-maintainer-mode'
	'--enable-deprecated-api'
	'--enable-api-atkmm'
	'--enable-x11-backend=yes'
	'--enable-wayland-backend=no'
	'--enable-broadway-backend=no'
	'--enable-warnings=no'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd gtkmm
make -k check
}
package_gtkmm3() {
pkgdesc='C++ bindings for gtk3'
depends=(
	'atkmm'
	'cairomm'
	'gcc-libs'
	'gdk-pixbuf2'
	'glib2'
	'glibc'
	'glibmm'
	'gtk3'
	'libsigc++'
	'pangomm'
)
cd gtkmm
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/gtkmm3/LICENSE
cd $pkgdir
mkdir -p $srcdir/gtkmm3-docs/usr
mv usr/share $srcdir/gtkmm3-docs/usr || true
}
package_gtkmm3-docs() {
pkgdesc='C++ bindings for gtk3 (documentation)'
depends=('gtkmm3')
options=('docs')
mv $srcdir/gtkmm3-docs/* $pkgdir
}
