pkgname=('findutils')
pkgver=4.7.0
pkgrel=2
pkgdesc='GNU utilities to locate files'
url='https://www.gnu.org/software/findutils'
license=('GPL3')
arch=('x86_64')
groups=('base-devel')
depends=(
'glibc'
'sh'
)
source=(
"ftp://ftp.gnu.org/pub/gnu/$pkgname/$pkgname-$pkgver.tar.xz"
"ftp://ftp.gnu.org/pub/gnu/$pkgname/$pkgname-$pkgver.tar.xz.sig"
)
sha1sums=(
'bd2fae4add80334173e03272aeed5635d4a0fa03'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
autoreconf -fi
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
	'--disable-debug'
	'--disable-assert'
	'--enable-threads=posix'
	'--enable-leaf-optimisation'
	'--enable-d_type-optimization'
	'--without-included-regex'
	'--with-fts'
	'--without-selinux'
)
sed -e '/^SUBDIRS/s/locate//' \
	-e 's/frcode locate updatedb//' \
	-i Makefile.in
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make -C locate dblocation.texi
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
