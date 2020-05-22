pkgname=('libxfce4ui')
pkgver=4.14.1
pkgrel=2
pkgdesc='Commonly used Xfce widgets among Xfce applications'
url='https://www.xfce.org/'
license=('GPL2')
arch=('x86_64')
depends=(
'atk'
'cairo'
'gdk-pixbuf2'
'glade'
'glib2'
'glibc'
'gtk2'
'gtk3'
'hicolor-icon-theme'
'libice'
'libsm'
'libx11'
'libxfce4util'
'pango'
'startup-notification'
'xfconf'
)
makedepends=(
'gobject-introspection'
'gtk-doc'
'intltool'
'vala'
)
source=("http://archive.xfce.org/src/xfce/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('c449075eaeae4d1138d22eeed3d2ad7032b87fb8878eada9b770325bed87f2da')
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
	'--enable-keyboard-library'
	'--disable-static'
	'--disable-tests'
	'--disable-gtk-doc'
	'--disable-debug'
	'--enable-debug=no'
	'--enable-visibility'
	'--with-x'
	'--with-vendor-info=Arch_Linux'
	'--enable-gladeui'
	'--enable-gtk2'
	'--enable-startup-notification'
	'--enable-introspection=no'
	'--enable-vala=no'
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
