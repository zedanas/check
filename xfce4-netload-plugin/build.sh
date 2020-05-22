pkgname=('xfce4-netload-plugin')
pkgver=1.3.2
pkgrel=1
pkgdesc='A netload plugin for the Xfce panel'
url='https://goodies.xfce.org/projects/panel-plugins/xfce4-netload-plugin'
license=('GPL')
arch=('x86_64')
groups=('xfce4-goodies')
depends=(
'glib2'
'glibc'
'gtk3'
'libxfce4ui'
'libxfce4util'
'xfce4-panel'
)
makedepends=('intltool')
source=("https://archive.xfce.org/src/panel-plugins/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('22e40425cfe1e07b01fe275b1afddc7c788af34d9c2c7e2842166963cb41215d')
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
