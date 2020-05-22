pkgname=('xfwm4')
pkgver=4.14.0
pkgrel=1
pkgdesc='Xfce window manager'
url='https://www.xfce.org/'
license=('GPL2')
arch=('x86_64')
groups=('xfce4')
depends=(
'cairo'
'dbus-glib'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'hicolor-icon-theme'
'libepoxy'
'libwnck3'
'libx11'
'libxcomposite'
'libxdamage'
'libxext'
'libxfce4ui'
'libxfce4util'
'libxfixes'
'libxi'
'libxinerama'
'libxrandr'
'libxrender'
'pango'
'startup-notification'
'xfconf'
)
makedepends=(
'intltool'
'libdrm'
)
source=("http://archive.xfce.org/src/xfce/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('b4182bf8dc63d092f120a51fcae0eb54b9bd4aa4f8486f47e5a65a108322b615')
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
	'--enable-libdrm'
	'--enable-xpresent'
	'--enable-xsync'
	'--disable-debug'
	'--enable-debug=no'
	'--with-x'
	'--enable-epoxy'
	'--enable-compositor'
	'--enable-randr'
	'--enable-render'
	'--enable-startup-notification'
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
