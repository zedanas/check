pkgname=('libgudev')
pkgver=233
pkgrel=1
pkgdesc='GObject bindings for libudev'
url='https://wiki.gnome.org/Projects/libgudev'
license=('LGPL2.1')
arch=('x86_64')
depends=(
'glib2'
'glibc'
'systemd-libs'
)
makedepends=(
'git'
'gnome-common'
'gtk-doc'
'systemd'
)
provides=('libgudev-1.0.so')
_commit='f76d04cbb66f9c0ef7f744ebc12f0336a4dc9170'
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
	'--disable-umockdev'
	'--enable-gtk-doc'
	'--enable-introspection=no'
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
