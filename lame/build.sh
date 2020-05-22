pkgname=('lame')
pkgver=3.100
pkgrel=2
pkgdesc='A high quality MPEG Audio Layer III (MP3) encoder'
url='http://lame.sourceforge.net/'
license=('LGPL')
arch=('x86_64')
depends=(
'glibc'
'ncurses'
)
makedepends=('nasm')
source=("https://downloads.sourceforge.net/$pkgname/$pkgname-$pkgver.tar.gz")
sha256sums=('ddfe36cab873794038ae2c1210557ad34857a4b6bdc515785d1da9e175b1da1e')
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
	'--disable-gtktest'
	'--disable-mp3x'
	'--enable-nasm'
	'--enable-decoder'
	'--enable-frontend'
	'--enable-dynamic-frontends'
	'--enable-analyzer-hooks'
	'--enable-mp3rtp'
	'--enable-debug=no'
	'--enable-expopt=full'
	'--with-fileio=lame'
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
