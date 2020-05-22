pkgname=('libfontenc')
pkgver=1.1.4
pkgrel=1
pkgdesc='X11 font encoding library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'zlib'
)
makedepends=(
'pkgconfig'
'xorgproto'
)
source=(
"https://xorg.freedesktop.org/releases/individual/lib/$pkgname-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/$pkgname-$pkgver.tar.bz2.sig"
)
sha512sums=(
'76fa851d00113241f15fdd5b5bb7e927b8d8b9a82ce3fcb0678b8c7e32cb5e8d898c4bda1d60dafb7748145049d3240627ac34a2360c64e98a7a912ea7c30582'
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
	'--with-encodingsdir=/usr/share/fonts/encodings'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/libfontenc/COPYING
}
