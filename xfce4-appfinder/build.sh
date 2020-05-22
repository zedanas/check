pkgname=('xfce4-appfinder')
pkgver=4.14.0
pkgrel=1
pkgdesc='An application finder for Xfce'
url='https://www.xfce.org/'
license=('GPL2')
arch=('x86_64')
groups=('xfce4')
depends=(
'garcon'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'hicolor-icon-theme'
'libxfce4ui'
'libxfce4util'
'xfconf'
)
makedepends=('intltool')
replaces=('xfce-utils')
source=("https://archive.xfce.org/src/xfce/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('7ec175d4954fceb2e76cbfbca76ac4a4f53fe799d097a14117e7de68e88a4d98')
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
	'--disable-debug'
	'--enable-debug=no'
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
