pkgname=('desktop-file-utils')
pkgver=0.24
pkgrel=2
pkgdesc='Command line utilities for working with desktop entries'
url='https://www.freedesktop.org/wiki/Software/desktop-file-utils'
license=('GPL')
arch=('x86_64')
depends=(
'glib2'
'glibc'
)
makedepends=('git')
_commit='27d370de9ca5121550c343859455d0f1515e1ec5'
source=(
'update-desktop-database.hook'
)
sha256sums=(
'SKIP'
'501f1eb35d9fbbd61666f40302b0ce63425299edf023c075986a24dc3ef18575'
)
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
install -Dm644 $srcdir/update-desktop-database.hook $pkgdir/usr/share/libalpm/hooks/update-desktop-database.hook
}
