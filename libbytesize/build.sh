pkgname=('libbytesize')
pkgver=2.2
pkgrel=1
pkgdesc='A tiny library providing a C "class" for working with arbitrary big sizes in bytes'
url='https://github.com/rhinstaller/libbytesize'
license=('LGPL')
arch=('x86_64')
depends=(
'glibc'
'gmp'
'mpfr'
'pcre2'
)
makedepends=('gtk-doc')
source=("$pkgname-$pkgver.tar.gz::https://github.com/rhinstaller/$pkgname/archive/$pkgver.tar.gz")
sha512sums=('dba1d6f6e898c9ef851169b95b4c3bb52680c3fd5507b6024cc9b36e0cec47de6a6b3f7c5c11c1a943e6906119ceac435c44b4edee8e2221800c0b5330e542fe')
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
	'--with-gtk-doc'
	'--without-python3'
	'--without-tools'
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
install -Dm644 LICENSE $pkgdir/usr/share/licenses/libbytesize/LICENSE
}
