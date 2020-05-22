pkgname='c-ares'
pkgver=1.16.0
pkgrel=1
pkgdesc='C library that performs DNS requests and name resolves asynchronously'
url='https://c-ares.haxx.se/'
license=('custom')
arch=('x86_64')
depends=('glibc')
source=(
"https://c-ares.haxx.se/download/$pkgname-$pkgver.tar.gz"
"https://c-ares.haxx.se/download/$pkgname-$pkgver.tar.gz.asc"
'LICENSE'
)
sha512sums=(
'9f5def3206d61682e66c2173b18a8dd76138e6eb53bfe06a5830408cce9a70895d2148be23064ff18e0fd25b4f4b2c3cfe77e040744cc80dcce6ffec3ea534a9'
'SKIP'
'55e8607392c5f82ed85e3580fa632dfdc2dcd0b1a5e918dc61d00532c15c11ecb709f6007b65805c1fbe8fcd21ee794c9e4a9638c97ac1f4960b2654010a4d0a'
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
	'--disable-werror'
	'--disable-debug'
	'--disable-curldebug'
	'--enable-optimize=-O3'
	'--enable-libgcc'
	'--enable-tests'
	'--enable-nonblocking'
	'--enable-symbol-hiding'
	'--disable-expose-statics'
	'--with-random'
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
install -Dm644 $srcdir/LICENSE $pkgdir/usr/share/licenses/c-ares/LICENSE
}
