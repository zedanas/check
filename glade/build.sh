pkgname=('glade')
pkgver=3.22.2
pkgrel=1
pkgdesc='User Interface Builder for GTK+ applications'
url='https://glade.gnome.org/'
license=('GPL' 'LGPL')
arch=('x86_64')
depends=(
'cairo'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'libxml2'
'pango'
)
makedepends=(
'docbook-xsl'
'git'
'gnome-common'
'gobject-introspection'
'gtk-doc'
'intltool'
'itstool'
'python-gobject'
)
optdepends=('devhelp: development help')
provides=('libgladeui-2.so')
_commit='1f0e1db7178c5038b2f61dc708b0939cb21d9254'
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
	'--enable-man-pages'
	'--disable-gtk-doc'
	'--enable-debug=no'
	'--enable-introspection=no'
	'--enable-compile-warnings=minimum'
	'--enable-gladeui'
	'--disable-python'
	'--disable-webkit2gtk'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/glade/LICENSE
}
