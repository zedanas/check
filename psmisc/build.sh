pkgname=('psmisc')
pkgver=23.3
pkgrel=2
pkgdesc='Miscellaneous procfs tools'
url='http://psmisc.sourceforge.net/'
license=('GPL')
arch=('x86_64')
groups=('base')
depends=(
'glibc'
'ncurses'
)
source=("http://downloads.sourceforge.net/$pkgname/$pkgname-$pkgver.tar.xz")
sha256sums=('41750e1a5abf7ed2647b094f58127c73dbce6876f77ba4e0a7e0995ae5c7279a')
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
	'--disable-ipv6'
	'--enable-harden-flags'
	'--enable-mountinfo-list'
	'--disable-selinux'
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
