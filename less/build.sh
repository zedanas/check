pkgname=('less')
pkgoname=('less')
pkgver=551
pkgrel=3
pkgdesc='A terminal based program for viewing text files'
url='http://www.greenwoodsoftware.com/less'
license=('GPL3')
arch=('x86_64')
groups=('base')
depends=(
'glibc'
'ncurses'
'pcre'
)
provides=('less')
conflicts=('less')
replaces=('less')
source=(
"http://www.greenwoodsoftware.com/$pkgname/$pkgname-$pkgver.tar.gz"
"$pkgname-$pkgver.tar.gz::http://www.greenwoodsoftware.com/$pkgname/$pkgname-$pkgver.sig"
)
md5sums=(
'4ad4408b06d7a6626a055cb453f36819'
'SKIP'
)
prepare() {
cd $pkgoname-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgoname-$pkgver
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
	'--with-secure'
	'--with-editor=mcedit'
	'--with-regex=pcre'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgoname-$pkgver
make DESTDIR=$pkgdir install
}
