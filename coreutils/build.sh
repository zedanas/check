pkgname=('coreutils')
pkgver=8.32
pkgrel=1
pkgdesc='The basic file, shell and text manipulation utilities of the GNU operating system'
url='https://www.gnu.org/software/coreutils/'
license=('GPL3')
arch=('x86_64')
groups=('base')
depends=(
'acl'
'attr'
'glibc'
'gmp'
'libcap'
'openssl'
)
source=(
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.xz"
"https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.xz.sig"
)
sha256sums=(
'4458d8de7849df44ccab15e16b1548b285224dbba5f08fac070c1c0e0bcc4cfa'
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
	'--enable-threads=posix'
	'--enable-no-install-program=groups,hostname,kill,uptime'
	'--with-linux-crypto'
	'--without-included-regex'
	'--enable-acl'
	'--enable-xattr'
	'--with-gmp'
	'--enable-libcap'
	'--without-selinux'
	'--disable-libsmack'
	'--with-openssl'
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
