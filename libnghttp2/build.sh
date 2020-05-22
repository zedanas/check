pkgname=('libnghttp2')
pkgver=1.40.0
pkgrel=1
pkgdesc='Framing layer of HTTP/2 is implemented as a reusable C library'
url='https://nghttp2.org/'
license=('MIT')
arch=('x86_64')
depends=('glibc')
makedepends=(
)
conflicts=('nghttp2<1.20.0-2')
source=("https://github.com/nghttp2/nghttp2/releases/download/v$pkgver/nghttp2-$pkgver.tar.xz")
sha512sums=('3f9b989c4bd9571b11bb9d59fe2dfd5596ba3962babfc836587d5047e780400a6cf46e43c602caa25ca83c03b84a1629953140d45223099b193df54a719745ce')
prepare() {
cd nghttp2-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd nghttp2-$pkgver
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
	'--disable-werror'
	'--disable-debug'
	'--disable-assert'
	'--enable-threads'
	'--disable-app'
	'--disable-examples'
	'--disable-hpack-tools'
	'--disable-python-bindings'
	'--enable-failmalloc'
	'--enable-lib-only'
	'--enable-asio-lib'
	'--with-libxml2'
	'--with-systemd'
	'--with-boost=yes'
	'--without-jemalloc'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd nghttp2-$pkgver
make -k check
}
package() {
cd nghttp2-$pkgver/lib
make DESTDIR=$pkgdir install
install -Dm644 ../COPYING $pkgdir/usr/share/licenses/libnghttp2/COPYING
}
