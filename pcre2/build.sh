pkgname=('pcre2')
pkgver=10.34
pkgrel=3
pkgdesc='A library that implements Perl 5-style regular expressions. 2nd version'
url='https://www.pcre.org/'
license=('BSD')
arch=('x86_64')
depends=(
'bash'
'bzip2'
'glibc'
'readline'
'zlib'
)
source=(
"https://ftp.pcre.org/pub/pcre/$pkgname-$pkgver.tar.bz2"
"https://ftp.pcre.org/pub/pcre/$pkgname-$pkgver.tar.bz2.sig"
)
sha512sums=(
'77ad75f8b0b8bbfc2f57932596151bca25b06bd621e0f047e476f38cd127f43e2052460b95c281a7e874aad2b7fd86c8f3413f4a323abb74b9440a42d0ee9524'
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
	'--disable-static'
	'--disable-debug'
	'--enable-pcre2-8'
	'--enable-pcre2-16'
	'--enable-pcre2-32'
	'--enable-unicode'
	'--enable-jit'
	'--enable-pcre2grep-jit'
	'--enable-pcre2grep-callout'
	'--enable-pcre2grep-callout-fork'
	'--enable-percent-zt'
	'--enable-fuzz-support'
	'--enable-pcre2grep-libbz2'
	'--disable-pcre2test-libedit'
	'--enable-pcre2test-libreadline'
	'--enable-pcre2grep-libz'
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
install -Dm644 LICENCE $pkgdir/usr/share/licenses/pcre2/LICENCE
}
