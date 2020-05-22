pkgname=('gnumeric')
pkgver=1.12.46
pkgrel=2
pkgdesc='A GNOME Spreadsheet Program'
url='https://www.gnome.org/projects/gnumeric/'
license=('GPL')
arch=('x86_64')
depends=(
'atk'
'cairo'
'gdk-pixbuf2'
'glib2'
'glibc'
'goffice'
'gtk3'
'libgsf'
'libxml2'
'pango'
'perl'
'zlib'
)
makedepends=(
'autoconf-archive'
'docbook-xml'
'git'
'gobject-introspection'
'gtk-doc'
'intltool'
'pygobject-devel'
'python2-gobject'
'yelp-tools'
)
optdepends=(
'perl: for perl plugin support'
'yelp: for viewing the help manual'
)
_commit='40f0abbc353028a9a06bbfcd530763d1e9f900de'
source=(
'revert-warnings.patch'
)
sha256sums=(
'SKIP'
'bcafca016b809000c2a5bf911e2e3dfa4de28f9e541d9964574cac5c7ce09e53'
)
prepare() {
cd $pkgname
patch -Np0 -i $srcdir/revert-warnings.patch
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
	'--disable-schemas-compile'
	'--enable-component'
	'--enable-gtk-doc'
	'--enable-introspection=no'
	'--with-paradox'
	'--with-gtk'
	'--without-gda'
	'--without-psiconv'
	'--with-perl'
	'--without-python'
	'--with-zlib'
)
PYTHON=/usr/bin/python2 ./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install
}
