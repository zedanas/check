pkgname=('ltrace')
pkgver=0.7.3
pkgrel=3
pkgdesc='Tracks runtime library calls in dynamically linked programs'
url='https://www.ltrace.org/'
license=('GPL')
arch=('x86_64')
depends=(
'glibc'
'libelf'
)
makedepends=('dejagnu')
backup=('etc/ltrace.conf')
source=("https://sources.archlinux.org/other/$pkgname/$pkgname-$pkgver.tar.bz2")
sha256sums=('0e6f8c077471b544c06def7192d983861ad2f8688dd5504beae62f0c5f5b9503')
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
	'--disable-werror'
	'--disable-debug'
	'--without-libunwind'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/ltrace/LICENSE
}
