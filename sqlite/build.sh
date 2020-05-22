pkgbase='sqlite'
pkgname=('sqlite' 'sqlite-tcl' 'sqlite-analyzer' 'sqlite-doc')
pkgver=3.31.1
pkgrel=1
pkgdesc='A C library that implements an SQL database engine'
url='https://www.sqlite.org/'
license=('custom:Public Domain')
arch=('x86_64')
makedepends=(
'readline'
'tcl'
'zlib'
)
_srcver=3310100
source=(
"https://www.sqlite.org/2020/$pkgbase-src-$_srcver.zip"
"https://www.sqlite.org/2020/$pkgbase-doc-$_srcver.zip"
'license.txt'
)
sha1sums=(
'b75b19eede97a65d78eba627cb92c93c203f1e03'
'3b6241f788e568b6ae5a20b3630e67729860b2eb'
'f34f6daa4ab3073d74e774aad21d66878cf26853'
)
prepare() {
cd sqlite-src-$_srcver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd sqlite-src-$_srcver
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
	'--disable-amalgamation'
	'--enable-memsys3'
	'--enable-memsys5'
	'--enable-fts3'
	'--enable-fts4'
	'--enable-fts5'
	'--enable-json1'
	'--enable-update-limit'
	'--enable-geopoly'
	'--enable-rtree'
	'--enable-session'
	'--enable-releasemode'
	'--enable-threadsafe'
	'--enable-load-extension'
	'--enable-tempstore=yes'
	'--disable-editline'
	'--enable-readline'
	'--enable-tcl'
)
export CPPFLAGS+=" -DSQLITE_ENABLE_COLUMN_METADATA=1 \
-DSQLITE_ENABLE_UNLOCK_NOTIFY \
-DSQLITE_ENABLE_DBSTAT_VTAB=1 \
-DSQLITE_ENABLE_FTS3_TOKENIZER=1 \
-DSQLITE_SECURE_DELETE \
-DSQLITE_MAX_VARIABLE_NUMBER=250000 \
-DSQLITE_MAX_EXPR_DEPTH=10000"
TCLLIBDIR=/usr/lib/sqlite${pkgver} ./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
make showdb showjournal showstat4 showwal sqldiff sqlite3_analyzer
}
package_sqlite() {
pkgdesc='A C library that implements an SQL database engine'
depends=(
	'glibc'
	'readline'
	'zlib'
)
provides=("sqlite3=$pkgver")
replaces=('sqlite3')
cd sqlite-src-$_srcver
make DESTDIR=$pkgdir install
install -m755 showdb showjournal showstat4 showwal sqldiff $pkgdir/usr/bin/
install -Dm644 sqlite3.1 $pkgdir/usr/share/man/man1/sqlite3.1
install -Dm644 $srcdir/license.txt $pkgdir/usr/share/licenses/sqlite/license.txt
cd $pkgdir/usr/lib/
ln -s libsqlite3-$pkgver.so.0 libsqlite3.so.0
ln -s libsqlite3-$pkgver.so.0.8.6 libsqlite3.so.0.8.6
cd $pkgdir
mkdir -p $srcdir/sqlite-tcl/usr/lib
mv usr/lib/sqlite* $srcdir/sqlite-tcl/usr/lib
}
package_sqlite-tcl() {
pkgdesc='Sqlite Tcl Extension Architecture (TEA)'
depends=(
	'glibc'
	'sqlite'
)
provides=("sqlite3-tcl=$pkgver")
replaces=('sqlite3-tcl')
mv $srcdir/sqlite-tcl/* $pkgdir
install -Dm644 $srcdir/sqlite-src-$_srcver/autoconf/tea/doc/sqlite3.n \
$pkgdir/usr/share/man/mann/sqlite3.n
install -Dm644 $srcdir/license.txt $pkgdir/usr/share/licenses/sqlite-tcl/license.txt
}
package_sqlite-analyzer() {
pkgdesc='An analysis program for sqlite3 database files'
depends=(
	'glibc'
	'sqlite'
	'tcl'
)
install -Dm755 sqlite-src-$_srcver/sqlite3_analyzer \
$pkgdir/usr/bin/sqlite3_analyzer || true
}
package_sqlite-doc() {
pkgdesc='Sqlite documentation'
depends=('sqlite')
provides=("sqlite3-doc=$pkgver")
replaces=('sqlite3-doc')
mkdir -p $pkgdir/usr/share/doc/sqlite
cp -r $srcdir/sqlite-doc-$_srcver/* $pkgdir/usr/share/doc/sqlite/
}
