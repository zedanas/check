pkgname=('libgsf')
pkgver=1.14.46
pkgrel=1
pkgdesc='An extensible I/O abstraction library for dealing with structured file formats'
url='https://gitlab.gnome.org/GNOME/libgsf.git'
license=('GPL' 'LGPL')
arch=('x86_64')
depends=(
'bzip2'
'gdk-pixbuf2'
'glib2'
'glibc'
'libxml2'
'zlib'
)
makedepends=(
'git'
'gtk-doc'
'autoconf-archive'
'intltool'
)
checkdepends=(
'perl-xml-parser'
'unzip'
)
_commit='7f927f09a47eb674606295b776d8cccc4554859a'
sha256sums=('SKIP')
prepare() {
cd $pkgname
sed -e 's/0.19.4/0.20/g' -i configure.ac
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
	'--with-bz2'
	'--with-gdk-pixbuf'
	'--with-zlib'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname
make -k check
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install
}
