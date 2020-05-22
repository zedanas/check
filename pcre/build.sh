pkgname=('pcre')
pkgver=8.44
pkgrel=1
pkgdesc='A library that implements Perl 5-style regular expressions'
url='https://www.pcre.org/'
license=('BSD')
arch=('x86_64')
depends=(
'bash'
'bzip2'
'gcc-libs'
'glibc'
'readline'
'zlib'
)
source=(
"https://ftp.pcre.org/pub/$pkgname/$pkgname-$pkgver.tar.bz2"
"https://ftp.pcre.org/pub/$pkgname/$pkgname-$pkgver.tar.bz2.sig"
)
sha512sums=(
'f26d850aab5228799e58ac8c2306fb313889332c39e29b118ef1de57677c5c90f970d68d3f475cabc64f8b982a77f04eca990ff1057f3ccf5e19bd137997c4ac'
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
	'--enable-pcre8'
	'--enable-pcre16'
	'--enable-pcre32'
	'--enable-cpp'
	'--enable-utf'
	'--enable-jit'
	'--enable-pcregrep-jit'
	'--enable-newline-is-lf'
	'--enable-unicode-properties'
	'--enable-pcregrep-libbz2'
	'--disable-pcretest-libedit'
	'--enable-pcretest-libreadline'
	'--enable-pcregrep-libz'
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
install -Dm644 LICENCE $pkgdir/usr/share/licenses/pcre/LICENCE
}
