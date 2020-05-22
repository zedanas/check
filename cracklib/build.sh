pkgname=('cracklib')
pkgver=2.9.7
pkgrel=2
pkgdesc='Password Checking Library'
url='https://github.com/cracklib/cracklib'
license=('GPL')
arch=('x86_64')
depends=(
'bash'
'glibc'
'zlib'
)
source=("https://github.com/$pkgname/$pkgname/releases/download/v$pkgver/$pkgname-$pkgver.tar.gz")
md5sums=('48a0c8810ec4780b99c0a4f9931c21c6')
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
	'--without-python'
	'--with-zlib'
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
mkdir -p $pkgdir/usr/share/dict
ln -sf /usr/share/cracklib/cracklib-small $pkgdir/usr/share/dict/cracklib-small
sh ./util/cracklib-format dicts/cracklib-small \
| sh ./util/cracklib-packer $pkgdir/usr/share/cracklib/pw_dict
}
