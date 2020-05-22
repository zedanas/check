pkgname=('libopenraw')
pkgver=0.1.3
pkgrel=1
pkgdesc='Library for decoding RAW files'
url='https://libopenraw.freedesktop.org/'
license=('LGPL')
arch=('x86_64')
depends=(
'gcc-libs'
'gdk-pixbuf2'
'glib2'
'glibc'
'libjpeg-turbo'
)
makedepends=(
'boost'
'libxml2'
)
source=(
"https://libopenraw.freedesktop.org/download/$pkgname-$pkgver.tar.bz2"
"https://libopenraw.freedesktop.org/download/$pkgname-$pkgver.tar.bz2.asc"
)
sha256sums=(
'6405634f555849eb01cb028e2a63936e7b841151ea2a1571ac5b5b10431cfab9'
'SKIP'
)
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
	'--disable-static-boost'
	'--enable-gnome'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname-$pkgver
make -k check
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
}
