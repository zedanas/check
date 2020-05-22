pkgname=('libcroco')
pkgver=0.6.13
pkgrel=1
pkgdesc='A CSS parsing library'
url='https://git.gnome.org/browse/libcroco'
license=('LGPL')
arch=('x86_64')
depends=(
'glib2'
'glibc'
'libxml2'
'sh'
)
makedepends=(
'intltool'
'git'
'gtk-doc'
)
_commit='7e15ca6c2c29a4b78367e6efa6195b331a92b2a7'
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
	'--enable-checks=no'
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
