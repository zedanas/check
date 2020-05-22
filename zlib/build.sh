pkgbase='zlib'
pkgname=('zlib' 'minizip')
pkgver=1.2.11
pkgrel=4
epoch=1
url='https://www.zlib.net/'
license=('custom')
arch=('x86_64')
options=('staticlibs')
source=(
"https://zlib.net/zlib-$pkgver.tar.gz"
"https://zlib.net/zlib-$pkgver.tar.gz.asc"
)
md5sums=(
'1c9f62f0778697a09d36121ead88e08e'
'SKIP'
)
prepare() {
cd $pkgbase-$pkgver
grep -A 24 '^  Copyright' zlib.h > LICENSE
cd contrib/minizip
autoreconf --install
}
build() {
cd $pkgbase-$pkgver
config_opts=(
	'--prefix=/usr'
)
./configure "${config_opts[@]}"
make
cd contrib/minizip
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
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgbase-$pkgver
make -k check
cd contrib/minizip
make -k check
}
package_zlib() {
pkgdesc='Compression library implementing the deflate compression method found in gzip and PKZIP'
depends=('glibc')
cd $pkgbase-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 LICENSE $pkgdir/usr/share/licenses/zlib/LICENSE
}
package_minizip() {
pkgdesc='Mini zip and unzip based on zlib'
depends=(
	'glibc'
	'zlib'
)
cd $pkgbase-$pkgver/contrib/minizip
make DESTDIR=$pkgdir install
rm $pkgdir/usr/include/minizip/crypt.h
install -Dm644 ../../LICENSE $pkgdir/usr/share/licenses/minizip/LICENSE
}
