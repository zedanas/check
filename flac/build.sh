pkgbase='flac'
pkgname=('flac' 'flac-doc')
pkgver=1.3.3
pkgrel=1
url='https://xiph.org/flac/'
license=('BSD' 'GPL')
arch=('x86_64')
makedepends=(
'doxygen'
'nasm'
)
source=("https://downloads.xiph.org/releases/$pkgbase/$pkgbase-$pkgver.tar.xz")
sha256sums=('213e82bd716c9de6db2f98bcadbc4c24c7e2efe8c75939a1a84e28539c4e1748')
prepare() {
cd $pkgbase-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgbase-$pkgver
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
	'--disable-debug'
	'--disable-examples'
	'--disable-64-bit-words'
	'--enable-doxygen-docs'
	'--enable-asm-optimizations'
	'--enable-sse'
	'--enable-avx'
	'--enable-stack-smash-protection'
	'--enable-xmms-plugin'
	'--enable-cpplibs'
	'--enable-ogg'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgbase-$pkgver
make -k check
}
package_flac() {
pkgdesc='Free Lossless Audio Codec'
depends=(
	'gcc-libs'
	'glibc'
	'libogg'
)
provides=(
	'libFLAC.so'
	'libFLAC++.so'
)
cd $pkgbase-$pkgver
make DESTDIR=$pkgdir install
cd $pkgdir
install -Dm644 $srcdir/$pkgbase-$pkgver/COPYING.Xiph \
$pkgdir/usr/share/licenses/flac/LICENSE
mkdir -p $srcdir/flac-doc/usr/share
mv usr/share/doc $srcdir/flac-doc/usr/share || true
}
package_flac-doc() {
pkgdesc='Developer documentation for the Free Lossless Audio Codec'
depends=('flac')
mv $srcdir/flac-doc/* $pkgdir
install -Dm644 $srcdir/$pkgbase-$pkgver/COPYING.Xiph \
$pkgdir/usr/share/licenses/flac-doc/LICENSE
}
