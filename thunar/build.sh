pkgname=('thunar')
pkgver=1.8.14
pkgrel=1
pkgdesc='Modern file manager for Xfce'
url='https://docs.xfce.org/xfce/thunar/start'
license=('GPL2' 'LGPL2.1')
arch=('x86_64')
groups=('xfce4')
depends=(
'atk'
'cairo'
'dbus-glib'
'desktop-file-utils'
'exo'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'hicolor-icon-theme'
'libexif'
'libgudev'
'libice'
'libnotify'
'libsm'
'libx11'
'libxfce4ui'
'libxfce4util'
'pango'
'pcre'
'sh'
'xfce4-panel'
'xfconf'
)
makedepends=('intltool')
optdepends=(
'gvfs: for trash support, mounting with udisk and remote filesystems'
'thunar-archive-plugin: create and deflate archives'
'thunar-media-tags-plugin: view/edit id3/ogg tags'
'thunar-volman: manages removable devices'
'tumbler: for thumbnail previews'
)
source=("https://archive.xfce.org/src/xfce/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('8ac57b1f5842d5bd348bbb6dac4714f5ad1f22de651d8ec6a7099ceb19fa219f')
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
	'--enable-introspection=no'
	'--enable-linker-opts'
	'--enable-gio-unix'
	'--enable-apr-plugin'
	'--enable-sbr-plugin'
	'--enable-tpa-plugin'
	'--enable-uca-plugin'
	'--with-x'
	'--enable-dbus'
	'--enable-exif'
	'--enable-gudev'
	'--enable-notifications'
	'--enable-wallpaper-plugin'
	'--enable-pcre'
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
