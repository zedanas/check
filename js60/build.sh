pkgname=('js60')
pkgver=60.9.0
pkgrel=2
pkgdesc='JavaScript interpreter and libraries - Version 60'
url='https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey'
license=('MPL')
arch=('x86_64')
depends=(
'gcc-libs'
'glibc'
'icu'
'readline'
'sh'
'zlib'
)
makedepends=(
'autoconf2.13'
'python2'
'zip'
)
source=(
"https://archive.mozilla.org/pub/firefox/releases/${pkgver}esr/source/firefox-${pkgver}esr.source.tar.xz"
"https://archive.mozilla.org/pub/firefox/releases/${pkgver}esr/source/firefox-${pkgver}esr.source.tar.xz.asc"
'bug1415202.patch'
)
sha256sums=(
'9f453c8cc5669e46e38f977764d49a36295bf0d023619d9aac782e6bb3e8c53f'
'SKIP'
'0b410aa6ebd0236cd3ea524340c2da2235973a42cd0eaa90f7f394cd5bcbab95'
)
prepare() {
cd firefox-$pkgver
patch -Np1 -i $srcdir/bug1415202.patch
}
build() {
cd firefox-$pkgver
config_opts=(
	'--prefix=/usr'
	'--libdir=/usr/lib'
	'--disable-debug'
	'--disable-debug-symbols'
	'--disable-rust-debug'
	'--disable-jemalloc'
	'--disable-tests'
	'--enable-project'
	'--enable-release'
	'--enable-optimize'
	'--enable-hardening'
	'--enable-linker=gold'
	'--enable-gold'
	'--enable-pie'
	'--enable-strip'
	'--enable-js-shell'
	'--enable-shared-js'
	'--enable-export-js'
	'--enable-posix-nspr-emulation'
	'--enable-pipeline-operator'
	'--enable-more-deterministic'
	'--with-pthreads'
	'--with-intl-api'
	'--with-system-icu'
	'--enable-readline'
	'--with-system-zlib'
)
export PYTHON=/usr/bin/python2
mkdir -p build && cd build
sh ../js/src/configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd firefox-$pkgver/build
make DESTDIR=$pkgdir install
chmod a-x $pkgdir/usr/lib/pkgconfig/*.pc
chmod a-x $pkgdir/usr/include/mozjs-60/*.h
rm $pkgdir/usr/lib/*.ajs
}
