pkgname='libgcrypt'
pkgver=1.8.5
pkgrel=2
pkgdesc='General purpose cryptographic library based on the code from GnuPG'
url='https://www.gnupg.org'
license=('LGPL')
arch=('x86_64')
depends=(
'glibc'
'libcap'
'libgpg-error'
'sh'
)
source=(
"https://gnupg.org/ftp/gcrypt/$pkgname/$pkgname-$pkgver.tar.bz2"
"https://gnupg.org/ftp/gcrypt/$pkgname/$pkgname-$pkgver.tar.bz2.sig"
)
sha1sums=(
'2d8781e92f88706707a1e76fb628b499ad538a30'
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
	'--enable-doc'
	'--enable-asm'
	'--enable-optimization'
	'--enable-noexecstack'
	'--enable-aesni-support'
	'--enable-pclmul-support'
	'--enable-sse41-support'
	'--enable-drng-support'
	'--enable-avx-support'
	'--enable-avx2-support'
	'--enable-jent-support'
	'--enable-dev-random'
	'--with-capabilities'
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
