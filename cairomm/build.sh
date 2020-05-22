pkgbase='cairomm'
pkgname=('cairomm' 'cairomm-docs')
pkgver=1.12.2
pkgrel=3
url='https://www.cairographics.org/cairomm/'
license=('LGPL' 'MPL')
arch=('x86_64')
makedepends=(
'git'
'mm-common'
)
_commit='e9ef515b7b8db5b4f024ddfefe5dfc03f2b8ccea'
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
	'--enable-api-exceptions'
	'--disable-tests'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package_cairomm() {
pkgdesc='C++ bindings for Cairo'
depends=(
	'cairo'
	'gcc-libs'
	'glibc'
	'libsigc++'
)
cd $pkgbase
make DESTDIR=$pkgdir install
cd $pkgdir
mkdir -p $srcdir/cairomm-docs/usr
mv usr/share $srcdir/cairomm-docs/usr || true
}
package_cairomm-docs() {
pkgdesc='C++ bindings for Cairo (documentation)'
depends=('cairomm')
options=('docs')
mv $srcdir/cairomm-docs/* $pkgdir
}
