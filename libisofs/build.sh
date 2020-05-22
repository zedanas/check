pkgname=('libisofs')
pkgver=1.5.2
pkgrel=1
pkgdesc='Library to pack up hard disk files and directories into a ISO 9660 disk image'
url='https://dev.lovelyhq.com/libburnia'
license=('GPL')
arch=('x86_64')
depends=(
'acl'
'attr'
'glibc'
'zlib'
)
source=(
"http://files.libburnia-project.org/releases/$pkgname-$pkgver.tar.gz"
"http://files.libburnia-project.org/releases/$pkgname-$pkgver.tar.gz.sig"
)
sha256sums=(
'ef5a139600b3e688357450e52381e40ec26a447d35eb8d21524598c7b1675500'
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
	'--enable-libjte'
	'--enable-versioned-libs'
	'--enable-libdir-pkgconfig'
	'--enable-ldconfig-at-install'
	'--enable-libacl'
	'--enable-xattr'
	'--enable-zlib'
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
