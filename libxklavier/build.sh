pkgname=('libxklavier')
pkgver=5.4
pkgrel=2
pkgdesc='High-level API for X Keyboard Extension'
url='https://www.freedesktop.org/wiki/Software/LibXklavier/'
license=('LGPL')
arch=('x86_64')
depends=(
'glib2'
'glibc'
'iso-codes'
'libx11'
'libxi'
'libxkbfile'
'libxml2'
'xkeyboard-config'
)
makedepends=(
'git'
'gobject-introspection'
'gtk-doc'
'intltool'
'libxfixes'
)
_commit='396955bd2ba2db34a42b3807b03155fcc11dfe50'
sha256sums=('SKIP')
prepare() {
cd $pkgname
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname
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
	'--enable-xkb-support'
	'--enable-xmodmap-support'
	'--enable-introspection=no'
	'--enable-vala=no'
	'--with-xkb-bin-base=/usr/bin'
	'--with-xmodmap-base=/usr/share/X11/xkb'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install
}
