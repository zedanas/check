pkgname='geany-plugins'
pkgver=1.36
pkgrel=4
pkgdesc='Plugins for Geany'
url='https://plugins.geany.org/'
license=('GPL')
arch=('x86_64')
depends=(
"geany>=$pkgver"
'cairo'
'enchant'
'gdk-pixbuf2'
'geany'
'glib2'
'glibc'
'gpgme'
'gtk3'
'libsoup'
'libxml2'
'pango'
'vte3'
)
makedepends=(
'cppcheck'
'intltool'
)
source=(
"https://plugins.geany.org/$pkgname/$pkgname-$pkgver.tar.bz2"
"https://plugins.geany.org/$pkgname/$pkgname-$pkgver.tar.bz2.sig"
)
sha256sums=(
'ebe18dd699292174622e8cb8745b020ada8a5be3b604ab980af36e8518df7ce6'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
autoreconf -fi
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
	'--disable-multiterm'
	'--disable-devhelp'
	'--enable-utilslib'
	'--enable-peg-markdown'
	'--enable-addons'
	'--enable-autoclose'
	'--enable-automark'
	'--enable-codenav'
	'--enable-commander'
	'--enable-debugger'
	'--enable-defineformat'
	'--enable-geanyctags'
	'--enable-geanydoc'
	'--enable-geanyextrasel'
	'--enable-geanyinsertnum'
	'--enable-latex'
	'--enable-geanymacro'
	'--enable-geanynumberedbookmarks'
	'--enable-keyrecord'
	'--enable-lineoperations'
	'--enable-lipsum'
	'--enable-pairtaghighlighter'
	'--enable-shiftcolumn'
	'--enable-tableconvert'
	'--enable-xmlsnippets'
	'--enable-scope'
	'--enable-vimode'
	'--enable-overview'
	'--enable-pohelper'
	'--disable-cppcheck'
	'--disable-geanygendoc'
	'--enable-spellcheck'
	'--enable-sendmail'
	'--enable-treebrowser'
	'--enable-geanypg'
	'--disable-gtkspell'
	'--disable-geanyvc'
	'--disable-gitchangebar'
	'--disable-workbench'
	'--enable-geniuspaste'
	'--enable-updatechecker'
	'--enable-pretty_printer'
	'--disable-geanylua'
	'--enable-geanyminiscript'
	'--enable-geanyprj'
	'--enable-projectorganizer'
	'--disable-geanypy'
	'--disable-markdown'
	'--disable-webhelper'
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
