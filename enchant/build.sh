pkgname=('enchant')
pkgver=2.2.8
pkgrel=1
pkgdesc='A wrapper library for generic spell checking'
url='https://abiword.github.io/enchant/'
license=('LGPL')
arch=('x86_64')
depends=(
'gcc-libs'
'glib2'
'glibc'
'hunspell'
)
makedepends=('git')
source=("$pkgname-$pkgver.tar.gz::https://github.com/AbiWord/$pkgname/archive/v$pkgver.tar.gz")
sha512sums=('8dbb584c54c46defec35b2ba54befbf22302a60e579d60df543dc68bd545b6ad7dec3050fc4027e26844fbaf56c28071e1e6573a93e65738591133ac6d3ff6dc')
prepare() {
cd $pkgname-$pkgver
./bootstrap
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
	'--disable-valgrind-tests'
	'--enable-relocatable'
	'--without-aspell'
	'--without-hspell'
	'--with-hunspell'
	'--without-voikko'
	'--without-nuspell'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
}
