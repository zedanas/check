pkgname=('libarchive')
pkgver=3.4.2
pkgrel=1
pkgdesc='Multi-format archive and compression library'
url='https://libarchive.org/'
license=('BSD')
arch=('x86_64')
depends=(
'acl'
'attr'
'bzip2'
'expat'
'glibc'
'lz4'
'lzo'
'openssl'
'xz'
'zlib'
'zstd'
)
provides=('libarchive.so')
source=(
"https://github.com/$pkgname/$pkgname/releases/download/v${pkgver}/$pkgname-$pkgver.tar.xz"
"https://github.com/$pkgname/$pkgname/releases/download/v${pkgver}/$pkgname-$pkgver.tar.xz.asc"
)
sha256sums=(
'd8e10494b4d3a15ae9d67a130d3ab869200cfd60b2ab533b391b0a0d5500ada1'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
autoreconf -fi
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
	'--enable-bsdtar'
	'--enable-bsdcat'
	'--enable-bsdcpio'
	'--enable-posix-regex-lib'
	'--with-iconv'
	'--with-cng'
	'--with-libb2'
	'--enable-acl'
	'--enable-xattr'
	'--with-bz2lib'
	'--with-expat'
	'--without-xml2'
	'--with-lz4'
	'--with-lzo2'
	'--without-mbedtls'
	'--without-nettle'
	'--with-openssl'
	'--with-lzma'
	'--with-zlib'
	'--with-zstd'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/libarchive/COPYING
}
