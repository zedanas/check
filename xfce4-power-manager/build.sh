pkgname=('xfce4-power-manager')
pkgver=1.6.6
pkgrel=1
pkgdesc='Power manager for Xfce desktop'
url='https://www.xfce.org/'
license=('GPL2')
arch=('x86_64')
groups=('xfce4')
depends=(
'cairo'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'hicolor-icon-theme'
'libnotify'
'libx11'
'libxext'
'libxfce4ui'
'libxfce4util'
'libxrandr'
'pango'
'upower'
'xfce4-panel'
'xfconf'
)
makedepends=(
'intltool'
'xfce4-panel'
)
optdepends=('xfce4-panel: for the Xfce panel plugin')
source=("https://archive.xfce.org/src/xfce/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('1b7bf0d3e8af69b10f7b6a518451e01fc7888e0d9d360bc33f6c89179bb6080b')
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
	'--enable-polkit'
	'--enable-network-manager'
	'--disable-debug'
	'--enable-debug=no'
	'--with-backend=linux'
	'--with-x'
	'--enable-xfce4panel'
	'--enable-panel-plugins'
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
