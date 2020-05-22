pkgname=('db')
pkgver=5.3.28
pkgrel=5
pkgdesc='The Berkeley DB embedded database system'
url='https://www.oracle.com/technology/software/products/berkeley-db/index.html'
license=('custom')
arch=('x86_64')
depends=(
'gcc-libs'
'glibc'
'sh'
)
source=(
"https://download.oracle.com/berkeley-db/$pkgname-$pkgver.tar.gz"
'atomic.patch'
)
sha1sums=(
'fa3f8a41ad5101f43d08bc0efb6241c9b6fc1ae9'
'70a51fe2a39a21652ef01767a9c8a30515b95a33'
)
prepare() {
cd $pkgname-$pkgver
patch -p0 -i $srcdir/atomic.patch
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname-$pkgver/build_unix
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
	'--disable-diagnostic'
	'--disable-test'
	'--enable-hash'
	'--enable-heap'
	'--enable-queue'
	'--enable-replication'
	'--enable-verify'
	'--enable-partition'
	'--enable-compression'
	'--enable-statistics'
	'--enable-mutexsupport'
	'--enable-atomicsupport'
	'--enable-log_checksum'
	'--enable-sql'
	'--disable-sql_compat'
	'--enable-sql_codegen'
	'--disable-java'
	'--disable-jdbc'
	'--disable-tcl'
	'--disable-mingw'
	'--disable-dump185'
	'--enable-compat185'
	'--enable-amalgamation'
	'--enable-dbm'
	'--enable-localization'
	'--enable-stripped_messages'
	'--with-cryptography=yes'
	'--enable-cxx'
	'--enable-stl'
)
../dist/configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make LIBSO_LIBS=-lpthread
}
package() {
cd $pkgname-$pkgver/build_unix
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/$pkgname-$pkgver/LICENSE $pkgdir/usr/share/licenses/db/LICENSE
mkdir -p $pkgdir/usr/share/doc/db
mv $pkgdir/usr/docs/* $pkgdir/usr/share/doc/db
rm -fr $pkgdir/usr/docs/
}
