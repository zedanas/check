pkgname=('libass')
pkgver=0.14.0
pkgrel=1
pkgdesc='A portable library for SSA/ASS subtitles rendering'
url='https://github.com/libass/libass/'
license=('BSD')
arch=('x86_64')
depends=(
'fontconfig'
'fribidi'
'glibc'
'harfbuzz'
'libfreetype.so'
)
makedepends=('nasm')
provides=('libass.so')
source=("https://github.com/$pkgname/$pkgname/releases/download/$pkgver/$pkgname-$pkgver.tar.xz")
sha256sums=('881f2382af48aead75b7a0e02e65d88c5ebd369fe46bc77d9270a94aa8fd38a2')
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
	'--disable-test'
	'--disable-profile'
	'--disable-require-system-font-provider'
	'--enable-asm'
	'--disable-large-tiles'
	'--enable-fontconfig'
	'--enable-harfbuzz'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/libass/COPYING
}
