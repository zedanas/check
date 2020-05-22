pkgname=('xfce4-screenshooter')
pkgver=1.9.7
pkgrel=1
pkgdesc='Plugin that makes screenshots for the Xfce panel'
url='https://goodies.xfce.org/projects/applications/xfce4-screenshooter'
license=('GPL2')
arch=('x86_64')
groups=('xfce4-goodies')
depends=(
'cairo'
'exo'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'hicolor-icon-theme'
'libsoup'
'libx11'
'libxext'
'libxfce4ui'
'libxfce4util'
'libxfixes'
'libxml2'
'xfce4-panel'
)
makedepends=(
'intltool'
'python'
)
conflicts=('xfce4-screenshooter-plugin')
replaces=('xfce4-screenshooter-plugin')
source=("http://archive.xfce.org/src/apps/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('0f7161053a23a6413376f4d17db6b774d4849384a9b1ffe01fdb2b0035a070d1')
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
	'--enable-xfixes'
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
