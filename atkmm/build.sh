pkgbase='atkmm'
pkgname=('atkmm' 'atkmm-docs')
pkgver=2.28.0
pkgrel=1
url='https://www.gtkmm.org/'
license=('LGPL')
arch=('x86_64')
makedepends=(
'git'
'mm-common'
'perl'
'glibmm-docs'
)
_commit='e1f4d5394a7982cc3c82ca63676a2928cd8819c1'
sha256sums=('SKIP')
prepare() {
cd $pkgbase
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgbase
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
	'--enable-maintainer-mode'
	'--enable-documentation'
	'--enable-deprecated-api'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package_atkmm() {
pkgdesc='C++ bindings for ATK'
depends=(
	'atk'
	'gcc-libs'
	'glib2'
	'glibc'
	'glibmm'
	'libsigc++'
)
cd $pkgbase
make DESTDIR=$pkgdir install
cd $pkgdir
mkdir -p $srcdir/atkmm-docs/usr
mv usr/share $srcdir/atkmm-docs/usr || true
}
package_atkmm-docs() {
pkgdesc='C++ bindings for ATK (documentation)'
depends=('atkmm')
options=('docs')
mv $srcdir/atkmm-docs/* $pkgdir
}
