pkgname=('libpsl')
pkgver=0.21.0
pkgrel=2
pkgdesc='Public Suffix List library'
url='https://github.com/rockdaboot/libpsl'
license=('MIT')
arch=('x86_64')
depends=(
'glibc'
)
makedepends=(
'gtk-doc'
'libxslt'
'publicsuffix-list'
'python'
)
provides=('libpsl.so')
source=(
"https://github.com/rockdaboot/$pkgname/releases/download/$pkgname-$pkgver/libpsl-$pkgver.tar.gz"
"libpsl-gtk-doc-1.30-fix.patch::https://github.com/rockdaboot/$pkgname/commit/87d1add318b5e5d09977f7f374e923577b6ff3be.patch"
"libpsl-0.21.0-build-fix.patch::https://github.com/rockdaboot/$pkgname/commit/9347024221f4a9d63f9dcafcda13362a7c8d92fe.patch"
)
sha512sums=(
'165c4f0b0640a813d512bd916e1532e32e43c8c81a5efd048f3a5b07b1b3c9129b4c4b5008b8b11a7c1b3914caea17564321389cd350bf1d687d53a97f2afa4d'
'9cca44a70c7e26bc6016767bce8888e5902c97eff92d004ca2ab659ee289a9e079fab62820f0f684ac25922260175c74c08c1dfca6dd1db6333c37edf38b8048'
'692d6dd6f64653f6e355df0b6cfe519a5c202d966deab066123e814591692a28a805fe794dc57dd6f9ab357b4e0dd8dfdf842239ec39f303fc33d98019e7f24e'
)
prepare() {
cd $pkgname-$pkgver
patch -p1 -i $srcdir/libpsl-gtk-doc-1.30-fix.patch
patch -p1 -i $srcdir/libpsl-0.21.0-build-fix.patch
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
	'--disable-gtk-doc'
	'--enable-man'
	'--disable-ubsan'
	'--disable-asan'
	'--with-psl-file=/usr/share/publicsuffix/effective_tld_names.dat'
	'--with-psl-testfile=/usr/share/publicsuffix/test_psl.txt'
	'--disable-runtime'
	'--disable-builtin'
	'--disable-runtime'
	'--disable-builtin'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/libpsl/LICENSE
}
