pkgname='libxml2'
pkgver=2.9.10
pkgrel=1
pkgdesc='XML parsing library, version 2'
url='http://www.xmlsoft.org/'
license=('MIT')
arch=('x86_64')
depends=(
'glibc'
'icu'
'readline'
'sh'
'xz'
'zlib'
)
makedepends=(
'python2'
'python'
'git'
)
_commit='41a34e1f4ffae2ce401600dbb5fe43f8fe402641'
source=(
'libxml2-2.9.8-python3-unicode-errors.patch'
'https://www.w3.org/XML/Test/xmlts20130923.tar.gz'
)
sha256sums=(
'SKIP'
'37eb81a8ec6929eed1514e891bff2dd05b450bcf0c712153880c485b7366c17c'
'9b61db9f5dbffa545f4b8d78422167083a8568c59bd1129f94138f936cf6fc1f'
)
prepare() {
cd $pkgname
patch -p1 -i $srcdir/libxml2-2.9.8-python3-unicode-errors.patch
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname
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
	'--disable-static'
	'--enable-ipv6=yes'
	'--enable-rebuild-docs=no'
	'--without-minimum'
	'--without-debug'
	'--without-mem-debug'
	'--without-run-debug'
	'--without-thread-alloc'
	'--without-fexceptions'
	'--with-threads'
	'--with-c14n'
	'--with-catalog'
	'--with-docbook'
	'--with-history'
	'--with-ftp'
	'--with-html'
	'--with-http'
	'--with-output'
	'--with-regexps'
	'--with-schemas'
	'--with-schematron'
	'--with-valid'
	'--with-writer'
	'--with-xinclude'
	'--with-xpath'
	'--with-xptr'
	'--with-modules'
	'--with-pattern'
	'--with-push'
	'--with-reader'
	'--with-sax1'
	'--with-tree'
	'--with-legacy'
	'--with-iconv'
	'--with-iso8859x'
	'--with-icu'
	'--without-python'
	'--without-python'
	'--with-readline'
	'--with-lzma'
	'--with-zlib'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname
make -k check
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxml2/COPYING
}
