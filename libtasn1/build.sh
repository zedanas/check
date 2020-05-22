pkgname=('libtasn1')
pkgver=4.16.0
pkgrel=1
pkgdesc='The ASN.1 library used in GNUTLS'
url='https://www.gnu.org/software/libtasn1/'
license=('GPL3' 'LGPL')
arch=('x86_64')
depends=('glibc')
source=(
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.gz"
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.gz.sig"
)
sha256sums=(
'0e0fb0903839117cb6e3b56e68222771bebf22ad7fc2295a0ed7d576e8d4329d'
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
	'--disable-gtk-doc'
	'--disable-valgrind-tests'
	'--with-packager=Archlinux'
	'--with-packager-bug-reports=http://bugs.archlinux.org/'
)
export CODE_COVERAGE_LDFLAGS=$LDFLAGS
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
