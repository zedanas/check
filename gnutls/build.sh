pkgname=('gnutls')
pkgver=3.6.13
pkgrel=1
pkgdesc='A library which provides a secure layer over a reliable transport layer'
url='https://www.gnutls.org/'
license=('GPL3' 'LGPL2.1')
arch=('x86_64')
depends=(
'gcc-libs'
'glibc'
'gmp'
'libp11-kit'
'libtasn1'
'libunistring'
'nettle'
)
checkdepends=('net-tools')
source=(
"https://www.gnupg.org/ftp/gcrypt/$pkgname/v3.6/$pkgname-$pkgver.tar.xz"
"https://www.gnupg.org/ftp/gcrypt/$pkgname/v3.6/$pkgname-$pkgver.tar.xz.sig"
)
sha256sums=(
'32041df447d9f4644570cf573c9f60358e865637d69b7e59d1159b7240b52f38'
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
	'--disable-tests'
	'--enable-manpages'
	'--disable-doc'
	'--disable-gtk-doc'
	'--enable-sha1-support'
	'--enable-ssl2-support'
	'--enable-ssl3-support'
	'--enable-alpn-support'
	'--enable-dtls-srtp-support'
	'--enable-heartbeat-support'
	'--enable-srp-authentication'
	'--enable-psk-authentication'
	'--enable-anon-authentication'
	'--enable-dhe'
	'--enable-ecdhe'
	'--enable-gost'
	'--enable-ocsp'
	'--disable-cryptodev'
	'--enable-cxx'
	'--enable-tools'
	'--enable-hardware-acceleration'
	'--enable-padlock'
	'--enable-fips140-mode'
	'--enable-non-suiteb-curves'
	'--enable-openssl-compatibility'
	'--enable-local-libopts'
	'--enable-libopts-install'
	'--enable-threads=posix'
	'--with-libregex'
	'--with-default-trust-store-pkcs11=pkcs11:model=p11-kit-trust;manufacturer=PKCS%2311%20Kit'
	'--disable-guile'
	'--without-idn'
	'--without-included-libtasn1'
	'--without-included-unistring'
	'--with-p11-kit'
	'--without-tpm'
	'--disable-libdane'
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
}
