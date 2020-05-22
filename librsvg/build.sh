pkgname='librsvg'
pkgver=2.48.2
pkgrel=1
epoch=2
pkgdesc='SVG rendering library'
url='https://wiki.gnome.org/Projects/LibRsvg'
license=('LGPL')
arch=('x86_64')
depends=(
'cairo'
'fontconfig'
'gcc-libs'
'gdk-pixbuf2'
'glib2'
'glibc'
'libxml2'
'pango'
)
makedepends=(
'git'
'gobject-introspection'
'gtk-doc'
'intltool'
'rust'
'vala'
)
checkdepends=('ttf-dejavu')
provides=("librsvg-${pkgver%%.*}.so")
_commit='6aec8c8dfb1178058ea8f660b768c05a53c12db7'
source=(
'lto.diff'
)
sha256sums=(
'SKIP'
'3cc8ad1af515b2cb4071f0647319c1cf3280dc054875634239061800af1616b6'
)
prepare() {
cd $pkgname
git apply -3 ../lto.diff
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
	'--disable-static'
	'--disable-debug'
	'--disable-gtk-doc'
	'--disable-installed-tests'
	'--disable-always-build-tests'
	'--enable-tools'
	'--enable-pixbuf-loader'
	'--enable-introspection=no'
	'--enable-vala=no'
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
