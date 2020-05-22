pkgname=('nmap')
pkgver=7.80
pkgrel=2
pkgdesc='Utility for network discovery and security auditing'
url='https://nmap.org/'
license=('GPL2')
arch=('x86_64')
depends=(
'gcc-libs'
'glibc'
'libpcap'
'openssl'
'pcre'
'sh'
)
makedepends=('python2')
optdepends=('python2: various scripts')
source=(
"https://nmap.org/dist/$pkgname-$pkgver.tar.bz2"
"https://nmap.org/dist/sigs/$pkgname-$pkgver.tar.bz2.asc"
)
sha256sums=(
'fcfa5a0e42099e12e4bf7a68ebe6fde05553383a682e816a7ec9256ab4773faa'
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
	'--with-ndiff'
	'--with-nping'
	'--with-ncat'
	'--with-nmap-update'
	'--with-libnsock'
	'--without-zenmap'
	'--with-libdnet=included'
	'--with-liblinear=included'
	'--with-libpcap'
	'--with-libssh2=included'
	'--without-liblua'
	'--with-openssl'
	'--with-libpcre'
	'--with-libz=included'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/nmap/LICENSE
}
