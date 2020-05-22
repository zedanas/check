pkgname=('geany')
pkgver=1.36
pkgrel=1
pkgdesc='Fast and lightweight IDE'
url='https://www.geany.org/'
license=('GPL')
arch=('x86_64')
depends=(
'atk'
'cairo'
'gcc-libs'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'pango'
)
makedepends=(
'doxygen'
'intltool'
'python-lxml'
)
optdepends=(
'geany-plugins: additional functionality'
'vte3: embedded terminal support'
)
source=("https://download.geany.org/$pkgname-${pkgver/.0}.tar.bz2")
sha256sums=('9184dd3dd40b7b84fca70083284bb9dbf2ee8022bf2be066bdc36592d909d53e')
prepare() {
cd $pkgname-${pkgver/.0}
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname-${pkgver/.0}
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
	'--disable-binreloc'
	'--enable-plugins'
	'--enable-socket'
	'--enable-vte'
	'--disable-html-docs'
	'--disable-pdf-docs'
	'--disable-api-docs'
	'--disable-gtkdoc-header'
	'--enable-gtk3'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname-${pkgver/.0}
make DESTDIR=$pkgdir install
}
