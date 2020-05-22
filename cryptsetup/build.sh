pkgname=('cryptsetup')
pkgver=2.3.1
pkgrel=1
pkgdesc='Userspace setup tool for transparent encryption of block devices using dm-crypt'
url='https://gitlab.com/cryptsetup/cryptsetup/'
license=('GPL')
arch=('x86_64')
groups=('base')
depends=(
'bash'
'device-mapper'
'glibc'
'json-c'
'libutil-linux'
'openssl'
'popt'
)
makedepends=('util-linux')
source=(
"https://www.kernel.org/pub/linux/utils/$pkgname/v${pkgver%.*}/$pkgname-${pkgver}.tar.xz"
"https://www.kernel.org/pub/linux/utils/$pkgname/v${pkgver%.*}/$pkgname-${pkgver}.tar.sign"
'hooks-encrypt'
'install-encrypt'
'install-sd-encrypt'
)
sha256sums=(
'92aba4d559a2cf7043faed92e0f22c5addea36bd63f8c039ba5a8f3a159fe7d2'
'SKIP'
'416aa179ce3c6a7a5eee0861f1f0a4fafac91b69e84a2aae82b6e5a6140e31e2'
'd325dc239ecc9a5324407b0782da6df2573e8491251836d6c4e65fa61339ce57'
'31d816b3650a57512a5f9b52c1995fa65a161faa8b37975d07c9a1b8e1a119db'
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
	'--disable-static-cryptsetup'
	'--enable-keyring'
	'--enable-kernel_crypto'
	'--enable-blkid'
	'--enable-fips'
	'--enable-luks-adjust-xts-keysize'
	'--with-default-luks-format=LUKS2'
	'--disable-libargon2'
	'--enable-internal-argon2'
	'--enable-internal-sse-argon2'
	'--disable-pwquality'
	'--disable-selinux'
	'--with-crypto_backend=openssl'
	'--disable-passwdqc'
	'--enable-cryptsetup'
	'--enable-veritysetup'
	'--enable-cryptsetup-reencrypt'
	'--enable-integritysetup'
	'--enable-udev'
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
install -D -m0644 $srcdir/hooks-encrypt $pkgdir/usr/lib/initcpio/hooks/encrypt
install -D -m0644 $srcdir/install-encrypt $pkgdir/usr/lib/initcpio/install/encrypt
install -D -m0644 $srcdir/install-sd-encrypt $pkgdir/usr/lib/initcpio/install/sd-encrypt
install -Dm644 COPYING $pkgdir/usr/share/licenses/cryptsetup/LICENSE
}
