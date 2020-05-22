pkgname=('xfburn')
pkgver=0.6.2
pkgrel=1
pkgdesc='A simple CD/DVD burning tool based on libburnia libraries'
url='https://docs.xfce.org/apps/xfburn'
license=('GPL')
arch=('x86_64')
groups=('xfce4-goodies')
depends=(
'desktop-file-utils'
'exo'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'libburn'
'libgudev'
'libisofs'
'libxfce4ui'
'libxfce4util'
)
makedepends=('intltool')
source=("https://archive.xfce.org/src/apps/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('83416e132e9bb31cd52fdc41460f96efa9ed57a290ec65f09714b83bb3d00327')
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
	'--enable-gudev'
	'--disable-gstreamer'
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
