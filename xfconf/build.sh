pkgname=('xfconf')
pkgver=4.14.1
pkgrel=1
pkgdesc='Flexible, easy-to-use configuration management system'
url='https://www.xfce.org/'
license=('GPL2')
arch=('x86_64')
groups=('xfce4')
depends=(
'dbus'
'dbus-glib'
'glib2'
'glibc'
'libxfce4util'
)
makedepends=(
'gobject-introspection'
'gtk-doc'
'intltool'
'vala'
)
source=("https://archive.xfce.org/src/xfce/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('b893e0a329aee00902fec2f0509f56916c9dcc7844e1b1f9e3c7399458290d59')
prepare() {
cd $pkgname-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname-$pkgver
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
	'--disable-checks'
	'--disable-profiling'
	'--disable-debug'
	'--enable-debug=no'
	'--enable-gtk-doc'
	'--enable-visibility'
	'--enable-linker-opts'
	'--enable-perl-bindings'
	'--enable-gsettings-backend'
	'--enable-introspection=no'
	'--enable-vala=no'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
}
