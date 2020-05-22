pkgname=('libburn')
pkgver=1.5.2
pkgrel=1
pkgdesc='Library for reading, mastering and writing optical discs'
url='https://dev.lovelyhq.com/libburnia'
license=('GPL')
arch=('x86_64')
depends=(
'glibc'
)
source=(
"http://files.libburnia-project.org/releases/$pkgname-$pkgver.tar.gz"
"http://files.libburnia-project.org/releases/$pkgname-$pkgver.tar.gz.sig"
)
sha256sums=(
'7b32db1719d7f6516cce82a9d00dfddfb3581725db732ea87d41ea8ef0ce5227'
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
	'--disable-debug'
	'--disable-dvd-obs-64k'
	'--disable-dvd-obs-pad'
	'--disable-track-src-odirect'
	'--enable-versioned-libs'
	'--enable-libdir-pkgconfig'
	'--enable-ldconfig-at-install'
	'--disable-libcdio'
	'--disable-pkg-check-modules'
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
