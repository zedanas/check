pkgname=('libwebp')
pkgver=1.1.0
pkgrel=1
pkgdesc='WebP library and conversion tools'
url='https://developers.google.com/speed/webp/'
license=('BSD')
arch=('x86_64')
depends=(
'freeglut'
'giflib'
'glibc'
'libglvnd'
'libjpeg'
'libpng'
'libtiff'
)
makedepends=(
'git'
'glu'
'mesa'
)
_commit='d7844e9762b61c9638c263657bd49e1690184832'
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
	'--disable-asserts'
	'--enable-threading'
	'--enable-near-lossless'
	'--enable-swap-16bit-csp'
	'--enable-sse4.1'
	'--enable-sse2'
	'--enable-libwebpmux'
	'--enable-libwebpdemux'
	'--enable-libwebpdecoder'
	'--enable-libwebpextras'
	'--enable-wic'
	'--enable-gif'
	'--enable-gl'
	'--enable-jpeg'
	'--enable-png'
	'--enable-tiff'
	'--disable-sdl'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname
make -k check
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libwebp/COPYING
}
