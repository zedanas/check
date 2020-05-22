pkgname=('libvorbis')
pkgver=1.3.6
pkgrel=1
pkgdesc='Vorbis codec library'
url='https://www.xiph.org/vorbis/'
license=('BSD')
arch=('x86_64')
depends=(
'glibc'
'libogg'
)
provides=(
'libvorbis.so'
'libvorbisenc.so'
'libvorbisfile.so'
)
source=("https://downloads.xiph.org/releases/vorbis/$pkgname-$pkgver.tar.gz")
sha256sums=('6ed40e0241089a42c48604dc00e362beee00036af2d8b3f46338031c9e0351cb')
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
	'--disable-docs'
	'--disable-examples'
	'--with-ogg'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/libvorbis/COPYING
}
