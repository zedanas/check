pkgname=('curl')
pkgver=7.69.1
pkgrel=1
pkgdesc='An URL retrieval utility and library'
url='https://curl.haxx.se'
license=('MIT')
arch=('x86_64')
depends=(
'bash'
'brotli'
'ca-certificates'
'glibc'
'libnghttp2'
'libssh2'
'openssl'
'zlib'
)
provides=('libcurl.so')
source=(
"https://curl.haxx.se/download/$pkgname-$pkgver.tar.gz"
"https://curl.haxx.se/download/$pkgname-$pkgver.tar.gz.asc"
)
sha512sums=(
'c0bc5e52fd3f52e095f61cf2724de57f2698317dd19ca8c331575f3998d08b067adefcb57dc5274747276a5556df89465fe13976774af885804fa81ca417887f'
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
	'--enable-optimize'
	'--enable-symbol-hiding'
	'--disable-werror'
	'--disable-debug'
	'--disable-curldebug'
	'--disable-manual'
	'--disable-esni'
	'--enable-http'
	'--enable-ftp'
	'--enable-file'
	'--enable-proxy'
	'--enable-dict'
	'--enable-telnet'
	'--enable-tftp'
	'--enable-pop3'
	'--enable-imap'
	'--enable-smb'
	'--enable-smtp'
	'--enable-gopher'
	'--enable-cookies'
	'--enable-http-auth'
	'--enable-doh'
	'--enable-mime'
	'--enable-ipv6'
	'--enable-alt-svc'
	'--enable-libcurl-option'
	'--enable-versioned-symbols'
	'--enable-threaded-resolver'
	'--enable-pthreads'
	'--enable-libgcc'
	'--enable-verbose'
	'--enable-crypto-auth'
	'--enable-ntlm-wb'
	'--enable-unix-sockets'
	'--enable-sspi'
	'--enable-dateparse'
	'--enable-netrc'
	'--enable-progress-meter'
	'--enable-dnsshuffle'
	'--enable-rt'
	'--with-ca-fallback'
	'--with-default-ssl-backend=openssl'
	'--without-axtls'
	'--without-bearssl'
	'--with-brotli'
	'--disable-ares'
	'--with-ca-bundle=/etc/ssl/certs/ca-certificates.crt'
	'--without-gnutls'
	'--without-gssapi'
	'--without-libidn2'
	'--disable-ldap'
	'--disable-ldaps'
	'--without-ldap-lib'
	'--without-lber-lib'
	'--without-libmetalink'
	'--with-nghttp2'
	'--without-nghttp3'
	'--without-libpsl'
	'--disable-rtsp'
	'--without-librtmp'
	'--without-libssh'
	'--with-libssh2'
	'--without-mbedtls'
	'--without-mesalink'
	'--disable-tls-srp'
	'--without-ngtcp2'
	'--without-nss'
	'--with-ssl'
	'--enable-openssl-auto-load-config'
	'--without-polarssl'
	'--with-quiche'
	'--without-wolfssl'
	'--without-cyassl'
	'--with-zlib'
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
make DESTDIR=$pkgdir install -C scripts
install -Dm644 COPYING $pkgdir/usr/share/licenses/curl/COPYING
}
