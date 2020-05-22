pkgname=('popt')
pkgver=1.16
pkgrel=12
pkgdesc='A commandline option parser'
url='http://rpm5.org'
license=('custom')
arch=('x86_64')
depends=('glibc')
options=('staticlibs')
source=("ftp://anduin.linuxfromscratch.org/BLFS/$pkgname/$pkgname-$pkgver.tar.gz")
sha1sums=('cfe94a15a2404db85858a81ff8de27c8ff3e235e')
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
	'--enable-static'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/popt/LICENSE
}
