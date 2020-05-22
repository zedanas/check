pkgname=('ristretto')
pkgver=0.10.0
pkgrel=2
pkgdesc='Fast and lightweight picture-viewer for Xfce4'
url='https://docs.xfce.org/apps/ristretto/start'
license=('GPL')
arch=('x86_64')
groups=('xfce4-goodies')
depends=(
'cairo'
'file'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'libexif'
'libx11'
'libxfce4ui'
'libxfce4util'
'pango'
'xfconf'
)
makedepends=(
'intltool'
'xfce4-dev-tools'
)
optdepends=(
'librsvg: SVG support'
'tumbler: thumbnailing support'
)
source=("https://archive.xfce.org/src/apps/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('16225dd74245eb6e0f82b9c72c6112f161bb8d8b11f3fc77277b7bc3432d4769')
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
