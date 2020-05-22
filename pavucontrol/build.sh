pkgname=('pavucontrol')
pkgver=4.0
pkgrel=1
epoch=1
pkgdesc='PulseAudio Volume Control'
url='https://freedesktop.org/software/pulseaudio/pavucontrol/'
license=('GPL')
arch=('x86_64')
depends=(
'atkmm'
'gcc-libs'
'glib2'
'glibc'
'glibmm'
'gtk3'
'gtkmm3'
'libcanberra'
'libpulse'
'libsigc++'
)
makedepends=(
'git'
'intltool'
'lynx'
)
optdepends=('pulseaudio: Audio backend')
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
