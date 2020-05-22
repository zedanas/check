pkgname=('garcon')
pkgver=0.6.4
pkgrel=1
pkgdesc='Implementation of the freedesktop.org menu specification'
url='https://www.xfce.org/'
license=('LGPL')
arch=('x86_64')
groups=('xfce4')
depends=(
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk2'
'gtk3'
'libxfce4ui'
'libxfce4util'
)
makedepends=(
'intltool'
'gtk-doc'
'python3'
)
replaces=('libxfce4menu')
source=("http://archive.xfce.org/src/xfce/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('d75e4753037a74733c07b71b8db7a656d869869f0f107f6411a306bbc87a762d')
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
	'--enable-gtk-doc'
	'--enable-linker-opts'
	'--disable-debug'
	'--enable-debug=no'
	'--enable-gtk2'
	'--enable-libxfce4ui'
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
