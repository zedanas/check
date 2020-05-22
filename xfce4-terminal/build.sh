pkgname=('xfce4-terminal')
pkgver=0.8.9.2
pkgrel=1
pkgdesc='A modern terminal emulator primarily for the Xfce desktop environment'
url='https://www.xfce.org/'
license=('GPL2')
arch=('x86_64')
groups=('xfce4')
depends=(
'cairo'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'hicolor-icon-theme'
'libx11'
'libxfce4ui'
'libxfce4util'
'pango'
'vte3'
'xfconf'
)
makedepends=('intltool')
conflicts=('terminal')
replaces=('terminal')
source=("https://archive.xfce.org/src/apps/$pkgname/0.8/$pkgname-$pkgver.tar.bz2")
sha256sums=('9ba23bf86d350ef8a95d2dfb50bbd1bbb2144d82985a779ec28caf47faaeeeeb')
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
	'--disable-gen-doc'
	'--disable-debug'
	'--enable-linker-opts'
	'--enable-debug=no'
	'--without-utempter'
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
