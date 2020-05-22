pkgname=('which')
pkgver=2.21
pkgrel=5
pkgdesc='A utility to show the full path of commands'
url='https://savannah.gnu.org/projects/which'
license=('GPL3')
arch=('x86_64')
groups=('base-devel')
depends=(
'bash'
'glibc'
)
source=("https://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.gz")
md5sums=('097ff1a324ae02e0a3b0369f07a7544a')
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
	'--enable-iberty'
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
