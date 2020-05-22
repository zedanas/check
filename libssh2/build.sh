pkgname=('libssh2')
pkgver=1.9.0
pkgrel=2
pkgdesc='A library implementing the SSH2 protocol as defined by Internet Drafts'
url='https://www.libssh2.org/'
license=('BSD')
arch=('x86_64')
depends=(
'glibc'
'openssl'
'zlib'
)
provides=('libssh2.so')
source=(
"https://www.libssh2.org/download/$pkgname-$pkgver.tar.gz"
"https://www.libssh2.org/download/$pkgname-$pkgver.tar.gz.asc"
)
md5sums=(
'1beefafe8963982adc84b408b2959927'
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
	'--disable-werror'
	'--disable-debug'
	'--enable-gex-new'
	'--enable-hidden-symbols'
	'--disable-examples-build'
	'--with-crypto=openssl'
	'--with-libz'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/libssh2/LICENSE
}
