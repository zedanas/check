pkgname=('qalculate-gtk')
pkgver=3.8.0
pkgrel=2
pkgdesc='GTK frontend for libqalculate'
url='https://qalculate.github.io/'
license=('GPL')
arch=('x86_64')
depends=(
'cairo'
'gcc-libs'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'libqalculate'
'pango'
)
makedepends=('intltool')
optdepends=('yelp: for displaying the help')
source=("https://github.com/Qalculate/$pkgname/releases/download/v$pkgver/$pkgname-$pkgver.tar.gz")
sha256sums=('9a2abf5f5c06f6a3a58d41844de7a666d0304c0c261bc2acd1f64ed105a0cd5c')
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
