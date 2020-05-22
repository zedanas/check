pkgname=('libksba')
pkgver=1.3.5
pkgrel=2
pkgdesc='A CMS and X.509 access library'
url='https://www.gnupg.org/related_software/libksba/index.html'
license=('GPL')
arch=('x86_64')
depends=(
'bash'
'glibc'
'libgpg-error'
)
source=(
"https://www.gnupg.org/ftp/gcrypt/$pkgname/$pkgname-$pkgver.tar.bz2"
"https://www.gnupg.org/ftp/gcrypt/$pkgname/$pkgname-$pkgver.tar.bz2.sig"
)
sha1sums=(
'a98385734a0c3f5b713198e8d6e6e4aeb0b76fde'
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
	'--enable-optimization'
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
