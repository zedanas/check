pkgname=('gnupg')
pkgver=2.2.20
pkgrel=1
pkgdesc='Complete and free implementation of the OpenPGP standard'
url='https://www.gnupg.org/'
license=('GPL')
arch=('x86_64')
depends=(
'bzip2'
'glibc'
'gnutls'
'libassuan'
'libgcrypt'
'libgpg-error'
'libksba'
'libusb'
'npth'
'readline'
'sh'
'sqlite'
'zlib'
)
makedepends=(
'libusb-compat'
'pcsclite'
)
checkdepends=('openssh')
optdepends=(
'libusb-compat: scdaemon'
'pcsclite: scdaemon'
)
provides=(
'dirmngr'
"gnupg2=${pkgver}"
)
conflicts=(
'dirmngr'
'gnupg2'
)
replaces=(
'dirmngr'
'gnupg2'
)
install='install'
source=(
"https://gnupg.org/ftp/gcrypt/$pkgname/$pkgname-$pkgver.tar.bz2"
"https://gnupg.org/ftp/gcrypt/$pkgname/$pkgname-$pkgver.tar.bz2.sig"
'self-sigs-only.patch'
)
sha256sums=(
'04a7c9d48b74c399168ee8270e548588ddbe52218c337703d7f06373d326ca30'
'SKIP'
'0130c43321c16f53ab2290833007212f8a26b1b73bd4edc2b2b1c9db2b2d0218'
)
prepare() {
cd $pkgname-$pkgver
patch -R -p1 -i $srcdir/self-sigs-only.patch
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
	'--libexecdir=/usr/lib/gnupg'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--disable-werror'
	'--disable-npth-debug'
	'--disable-all-tests'
	'--enable-optimization'
	'--enable-exec'
	'--enable-photo-viewers'
	'--enable-dirmngr-auto-start'
	'--enable-regex'
	'--enable-doc'
	'--enable-gpg-is-gpg2'
	'--enable-gpg'
	'--enable-gpgsm'
	'--enable-scdaemon'
	'--enable-g13'
	'--enable-dirmngr'
	'--enable-symcryptrun'
	'--enable-gpgtar'
	'--enable-wks-tools'
	'--enable-libdns'
	'--enable-trust-models'
	'--enable-tofu'
	'--enable-gpg-rsa'
	'--enable-gpg-ecdh'
	'--enable-gpg-ecdsa'
	'--enable-gpg-eddsa'
	'--enable-gpg-idea'
	'--enable-gpg-cast5'
	'--enable-gpg-blowfish'
	'--enable-gpg-aes128'
	'--enable-gpg-aes192'
	'--enable-gpg-aes256'
	'--enable-gpg-twofish'
	'--enable-gpg-camellia128'
	'--enable-gpg-camellia192'
	'--enable-gpg-camellia256'
	'--enable-gpg-md5'
	'--enable-gpg-rmd160'
	'--enable-gpg-sha224'
	'--enable-gpg-sha384'
	'--enable-gpg-sha512'
	'--with-capabilities'
	'--with-tar'
	'--with-regex'
	'--enable-bzip2'
	'--enable-gnutls'
	'--disable-ldap'
	'--disable-selinux-support'
	'--enable-card-support'
	'--enable-ccid-driver'
	'--disable-ntbtls'
	'--with-readline'
	'--enable-sqlite'
	'--enable-zip'
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
ln -s gpg2 $pkgdir/usr/bin/gpg
ln -s gpgv2 $pkgdir/usr/bin/gpgv
cd doc/examples/systemd-user
for i in *.*; do
	install -Dm644 $i $pkgdir/usr/lib/systemd/user/$i
done
}
