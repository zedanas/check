pkgname=('xvidcore')
pkgver=1.3.7
pkgrel=1
pkgdesc='XviD is an open source MPEG-4 video codec'
url='https://www.xvid.org/'
license=('GPL')
arch=('x86_64')
depends=('glibc')
makedepends=('nasm')
provides=('libxvidcore.so')
source=("https://downloads.xvid.com/downloads/$pkgname-$pkgver.tar.gz")
sha256sums=('abbdcbd39555691dd1c9b4d08f0a031376a3b211652c0d8b3b8aa9be1303ce2d')
prepare() {
cd xvidcore/build/generic
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd xvidcore/build/generic
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
	'--disable-idebug'
	'--disable-iprofile'
	'--disable-gnuprofile'
	'--enable-assembly'
	'--enable-pthread'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
 cd xvidcore/build/generic
make DESTDIR=$pkgdir install
}
