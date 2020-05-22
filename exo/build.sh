pkgname=('exo')
pkgver=0.12.11
pkgrel=1
pkgdesc='Application library for Xfce'
url='https://www.xfce.org/'
license=('GPL2' 'LGPL')
arch=('x86_64')
groups=('xfce4')
depends=(
'atk'
'cairo'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk2'
'gtk3'
'hicolor-icon-theme'
'libx11'
'libxfce4ui'
'libxfce4util'
'pango'
'perl'
'sh'
)
makedepends=(
'gtk-doc'
'intltool'
'perl-uri'
)
source=("https://archive.xfce.org/src/xfce/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('ec892519c08a67f3e0a1f0f8d43446e26871183e5aa6be7f82e214f388d1e5b6')
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
	'--enable-gio-unix'
	'--enable-visibility'
	'--enable-linker-opts'
	'--disable-debug'
	'--enable-debug=no'
	'--enable-gtk-doc'
	'--with-x'
	'--enable-gtk2'
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
