pkgname=('upower')
pkgver=0.99.11
pkgrel=1
pkgdesc='Abstraction for enumerating power devices, listening to device events and querying history and statistics'
url='https://upower.freedesktop.org'
license=('GPL')
arch=('x86_64')
depends=(
'glib2'
'glibc'
'libgudev'
'libusb'
'systemd'
)
makedepends=(
'docbook-xsl'
'git'
'gobject-introspection'
'gtk-doc'
'intltool'
'python'
)
backup=('etc/UPower/UPower.conf')
options=('emptydirs')
_commit='e1548bba61206a05bbc318b3d49ae24571755ac6'
md5sums=('SKIP')
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
	'--disable-deprecated'
	'--disable-tests'
	'--enable-man-pages'
	'--enable-gtk-doc'
	'--enable-introspection=no'
	'--with-backend=linux'
	'--without-idevice'
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
