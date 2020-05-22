pkgname=('opus')
pkgver=1.3.1
pkgrel=1
pkgdesc='Totally open, royalty-free, highly versatile audio codec'
url='https://www.opus-codec.org/'
license=('BSD')
arch=('x86_64')
depends=('glibc')
makedepends=('doxygen')
source=("https://archive.mozilla.org/pub/$pkgname/$pkgname-$pkgver.tar.gz")
sha256sums=('65b58e1e25b2a114157014736a3d9dfeaad8d41be1c8179866f144a2fb44ff9d')
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
	'--disable-assertions'
	'--disable-extra-programs'
	'--enable-doc'
	'--enable-asm'
	'--enable-rtcd'
	'--enable-intrinsics'
	'--enable-custom-modes'
	'--enable-rfc8251'
	'--enable-check-asm'
	'--enable-hardening'
	'--enable-stack-protector'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/opus/LICENSE
}
