pkgname=('xfce4-taskmanager')
pkgver=1.2.2
pkgrel=1
pkgdesc='Easy to use task manager'
url='https://goodies.xfce.org/projects/applications/xfce4-taskmanager'
license=('GPL2')
arch=('x86_64')
groups=('xfce4-goodies')
depends=(
'cairo'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'libwnck3'
'libx11'
'libxmu'
)
makedepends=('intltool')
source=("https://archive.xfce.org/src/apps/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('e49a61c819a4fd9286a65ae61605984f327c8b26cf939289f644e656bfa20e13')
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
	'--with-x'
	'--disable-gtk2'
	'--enable-wnck3'
	'--disable-wnck'
	'--enable-gksu'
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
