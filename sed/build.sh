pkgname=('sed')
pkgver=4.8
pkgrel=1
pkgdesc='GNU stream editor'
url='https://www.gnu.org/software/sed/'
license=('GPL3')
arch=('x86_64')
groups=('base-devel')
depends=(
'acl'
'attr'
'glibc'
)
makedepends=('gettext')
source=(
"https://ftp.gnu.org/pub/gnu/$pkgname/$pkgname-$pkgver.tar.xz"
"https://ftp.gnu.org/pub/gnu/$pkgname/$pkgname-$pkgver.tar.xz.sig"
)
sha256sums=(
'f79b0cfea71b37a8eeec8490db6c5f7ae7719c35587f21edb0617f370eeff633'
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
	'--disable-assert'
	'--enable-i18n'
	'--enable-threads=posix'
	'--without-included-regex'
	'--enable-acl'
	'--without-selinux'
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
