pkgname=('xfce4-mount-plugin')
pkgver=1.1.3
pkgrel=1
pkgdesc='Mount/umount utility for the Xfce4 panel'
url='https://goodies.xfce.org/projects/panel-plugins/xfce4-mount-plugin'
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
source=("https://archive.xfce.org/src/panel-plugins/xfce4-mount-plugin/${pkgver%.*}/xfce4-mount-plugin-$pkgver.tar.bz2")
sha256sums=('aae5bd6b984bc78daf6b5fb9d15817a27253674a4264ad60f62ccb1aa194911e')
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
