pkgname=('hunspell')
pkgver=1.7.0
pkgrel=2
pkgdesc='Spell checker and morphological analyzer library and program'
url='https://hunspell.github.io/'
license=('GPL' 'LGPL' 'MPL')
arch=('x86_64')
depends=(
'gcc-libs'
'glibc'
'ncurses'
'perl'
'readline'
'sh'
)
optdepends=('perl: for ispellaff2myspell')
source=("$pkgname-$pkgver.tar.gz::https://github.com/$pkgname/$pkgname/archive/v${pkgver}.tar.gz")
sha256sums=('bb27b86eb910a8285407cf3ca33b62643a02798cf2eef468c0a74f6c3ee6bc8a')
prepare() {
cd $pkgname-$pkgver
autoreconf -fi
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
	'--enable-threads'
	'--with-ui'
	'--with-readline'
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
cd $pkgdir/usr/lib
ln -s libhunspell-?.?.so libhunspell.so
}
