pkgname=('xz')
pkgver=5.2.5
pkgrel=1
pkgdesc='Library and command line tools for XZ and LZMA compressed files'
url='https://tukaani.org/xz/'
license=('GPL' 'LGPL' 'custom')
arch=('x86_64')
depends=(
'glibc'
'grep'
'less'
'sh'
)
source=(
"https://tukaani.org/xz/xz-${pkgver}.tar.gz"
"https://tukaani.org/xz/xz-${pkgver}.tar.gz.sig"
)
md5sums=(
'0d270c997aff29708c74d53f599ef717'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
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
	'--disable-doc'
	'--enable-xz'
	'--enable-xzdec'
	'--enable-lzmadec'
	'--enable-lzmainfo'
	'--enable-lzma-links'
	'--enable-scripts'
	'--enable-assembler'
	'--enable-threads=yes'
	'--enable-sandbox=no'
	'--enable-unaligned-access'
	'--enable-symbol-versions'
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
mkdir -p $pkgdir/usr/share/doc/xz
install -Dm644 COPYING $pkgdir/usr/share/licenses/xz/COPYING
ln -sf /usr/share/licenses/common/GPL2/license.txt $pkgdir/usr/share/doc/xz/COPYING.GPLv2
}
