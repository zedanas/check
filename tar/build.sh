pkgname=('tar')
pkgver=1.32
pkgrel=3
pkgdesc='Utility used to store, backup, and transport files'
url='https://www.gnu.org/software/tar/'
license=('GPL3')
arch=('x86_64')
groups=('base')
depends=(
'acl'
'attr'
'glibc'
)
source=(
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.xz"
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.xz.sig"
)
md5sums=(
'83e38700a80a26e30b2df054e69956e5'
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
	'--libexecdir=/usr/lib/tar'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--disable-backup-scripts'
	'--without-included-regex'
	'--enable-acl'
	'--with-posix-acls'
	'--with-xattrs'
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
