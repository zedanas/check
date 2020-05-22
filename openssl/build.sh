pkgname=('openssl')
pkgver=1.1.1.f
pkgrel=1
pkgdesc='The Open Source toolkit for Secure Sockets Layer and Transport Layer Security'
url='https://www.openssl.org'
license=('custom:BSD')
arch=('x86_64')
depends=(
'glibc'
'perl'
)
optdepends=('ca-certificates')
provides=('openssl')
conflicts=('openssl')
replaces=('openssl')
backup=('etc/ssl/openssl.cnf')
options=('emptydirs')
_ver=1.1.1f
source=(
"https://www.openssl.org/source/$pkgname-$_ver.tar.gz"
"https://www.openssl.org/source/$pkgname-$_ver.tar.gz.asc"
'ca-dir.patch'
)
sha256sums=(
'186c6bfe6ecfba7a5b48c47f8a1673d0f3b0e5ba2e25602dd23b629975da3f35'
'SKIP'
'0938c8d68110768db4f350a7ec641070686904f2fe7ba630ac94399d7dc8cc5e'
)
prepare() {
cd $pkgname-$_ver
patch -p0 -i $srcdir/ca-dir.patch
}
build() {
cd $pkgname-$_ver
config_opts=(
	'--prefix=/usr'
	'--libdir=lib'
	'--openssldir=/etc/ssl'
	'--release'
	'threads'
	'shared'
	'enable-ec_nistp_64_gcc_128'
	'enable-heartbeats'
	'no-ssl3-method'
	'no-sctp'
	'zlib'
	'zlib-dynamic'
)
./config "${config_opts[@]}"
make
}
check() {
cd $pkgname-$_ver
patch -p0 -R -i $srcdir/ca-dir.patch
make -k test
patch -p0 -i $srcdir/ca-dir.patch
}
package() {
cd $pkgname-$_ver
make DESTDIR=$pkgdir MANSUFFIX=ssl install
install -Dm644 LICENSE $pkgdir/usr/share/licenses/openssl/LICENSE
}
