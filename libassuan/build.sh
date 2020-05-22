pkgname=('libassuan')
pkgver=2.5.3
pkgrel=2
pkgdesc='IPC library used by some GnuPG related software'
url='https://www.gnupg.org/related_software/libassuan/'
license=('GPL')
arch=('x86_64')
depends=(
'glibc'
'libgpg-error'
'sh'
)
source=(
"https://gnupg.org/ftp/gcrypt/$pkgname/$pkgname-$pkgver.tar.bz2"
"https://gnupg.org/ftp/gcrypt/$pkgname/$pkgname-$pkgver.tar.bz2.sig"
)
sha256sums=(
'91bcb0403866b4e7c4bc1cc52ed4c364a9b5414b3994f718c70303f7f765e702'
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
