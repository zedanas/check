pkgname='tumbler'
pkgver=0.2.8
pkgrel=1
pkgdesc='D-Bus service for applications to request thumbnails'
url='https://www.xfce.org/'
license=('GPL2' 'LGPL')
arch=('x86_64')
groups=('xfce4')
depends=(
'cairo'
'curl'
'ffmpegthumbnailer'
'freetype2'
'gdk-pixbuf2'
'glib2'
'glibc'
'libgsf'
'libjpeg-turbo'
'libopenraw'
'libpng'
'poppler-glib'
)
makedepends=(
'intltool'
'python'
)
source=("https://archive.xfce.org/src/xfce/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('0999b9a3deb57010956db6630ae7205813999147043171049a7b6c333be93e96')
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
	'--disable-gtk-doc'
	'--disable-debug'
	'--enable-debug=no'
	'--enable-linker-opts'
	'--enable-cover-thumbnailer'
	'--enable-ffmpeg-thumbnailer'
	'--enable-font-thumbnailer'
	'--enable-pixbuf-thumbnailer'
	'--enable-desktop-thumbnailer'
	'--disable-gstreamer-thumbnailer'
	'--enable-odf-thumbnailer'
	'--enable-jpeg-thumbnailer'
	'--enable-raw-thumbnailer'
	'--enable-xdg-cache'
	'--enable-poppler-thumbnailer'
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
