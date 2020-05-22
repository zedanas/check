pkgname='icu'
pkgver=65.1
pkgrel=3
pkgdesc='International Components for Unicode library'
url='http://www.icu-project.org/'
license=('custom:icu')
arch=('x86_64')
depends=(
'gcc-libs'
'glibc'
'sh'
)
makedepends=('python')
provides=(
'libicudata.so'
'libicui18n.so'
'libicuio.so'
'libicutest.so'
'libicutu.so'
'libicuuc.so'
)
source=(
"https://github.com/unicode-org/icu/releases/download/release-${pkgver//./-}/icu4c-${pkgver//./_}-src.tgz"
"https://github.com/unicode-org/icu/releases/download/release-${pkgver//./-}/icu4c-${pkgver//./_}-src.tgz.asc"
'icu-65.1-initialized-buffer-uloc_getKeywordValue.patch::https://github.com/unicode-org/icu/commit/fab4c3c719.patch'
'icu-65.1-prevent-SEGV_MAPERR-in-append.patch::https://github.com/unicode-org/icu/commit/b7d08bc04a.patch'
)
sha512sums=(
'8f1ef33e1f4abc9a8ee870331c59f01b473d6da1251a19ce403f822f3e3871096f0791855d39c8f20c612fc49cda2c62c06864aa32ddab2dbd186d2b21ce9139'
'SKIP'
'8898fe0fa9805304cd2fc02c00ab1131861836f4d11887f82450c2378666cb03bce0c5038d3f0bdcdd1c1cdee2a00a61ef85602ed0e0c74ad2e58578b1940123'
'580283cdd95fb7b8410cb3a6c0f47a6c8e53e0fdc9c213b04cd133ba4120381533ff2aef89ddab968150754bd9ca3a536d5c592c6881e625eb8ee6de8723de1b'
)
prepare() {
cd $pkgname
patch -p2 -i ../icu-65.1-initialized-buffer-uloc_getKeywordValue.patch
patch -p2 -i ../icu-65.1-prevent-SEGV_MAPERR-in-append.patch
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname/source
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
	'--enable-release'
	'--disable-debug'
	'--disable-tracing'
	'--disable-tests'
	'--disable-fuzzer'
	'--disable-samples'
	'--enable-tools'
	'--enable-extras'
	'--enable-icuio'
	'--enable-layoutex'
	'--enable-plugins'
	'--enable-renaming'
	'--enable-draft'
	'--enable-auto-cleanup'
	'--enable-icu-config'
	'--disable-dyload'
	'--disable-weak-threads'
	'--with-library-bits=64'
	'--with-data-packaging=library'
)
export CFLAGS+=' -fno-lto'
export CXXFLAGS+=' -fno-lto'
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname/source
make -k check
}
package() {
cd $pkgname/source
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/icu/LICENSE $pkgdir/usr/share/licenses/icu/LICENSE
}
