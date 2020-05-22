pkgname=('libedit')
pkgver=20191231_3.1
pkgrel=1
pkgdesc='Command line editor library providing generic line editing, history, and tokenization functions'
url='https://thrysoee.dk/editline/'
license=('BSD')
arch=('x86_64')
depends=(
'glibc'
'ncurses'
)
source=("https://thrysoee.dk/editline/$pkgname-${pkgver/_/-}.tar.gz")
sha256sums=('dbb82cb7e116a5f8025d35ef5b4f7d4a3cdd0a3909a146a39112095a2d229071')
prepare() {
cd $pkgname-${pkgver/_/-}
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname-${pkgver/_/-}
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
	'--disable-examples'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname-${pkgver/_/-}
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libedit/LICENSE
rm $pkgdir/usr/share/man/man3/history.3
cp $pkgdir/usr/share/man/man3/editline.3 $pkgdir/usr/share/man/man3/el.3
}
