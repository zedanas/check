pkgname=('libxfce4util')
pkgver=4.14.0
pkgrel=1
pkgdesc='Basic utility non-GUI functions for Xfce'
url='https://www.xfce.org/'
license=('GPL2')
arch=('x86_64')
depends=(
'glib2'
'glibc'
)
makedepends=(
'intltool'
'gobject-introspection'
'gtk-doc'
'vala'
)
source=("https://archive.xfce.org/src/xfce/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('32ad79b7992ec3fd863e8ff2f03eebda8740363ef9d7d910a35963ac1c1a6324')
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
	'--disable-gtk-doc'
	'--disable-debug'
	'--enable-debug=no'
	'--enable-vala=no'
	'--enable-introspection=no'
	'--enable-visibility'
	'--enable-linker-opts'
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
