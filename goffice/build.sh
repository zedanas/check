pkgname=('goffice')
pkgver=0.10.46
pkgrel=1
pkgdesc='A GLib/GTK+ set of document-centric objects and charting library'
url='https://git.gnome.org/browse/goffice'
license=('GPL')
arch=('x86_64')
depends=(
'atk'
'cairo'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'libgsf'
'librsvg'
'libxml2'
'libxslt'
'pango'
)
makedepends=(
'autoconf-archive'
'git'
'gobject-introspection'
'gtk-doc'
'intltool'
)
_commit='0da5282a9179cf63f8f0e6637f05aef595fec3e4'
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
	'--enable-gtk-doc'
	'--enable-introspection=no'
	'--with-config-backend=keyfile'
	'--with-long-double'
	'--with-gtk'
	'--with-lasem=no'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install
}
