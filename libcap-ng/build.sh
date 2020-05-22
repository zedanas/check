pkgname=('libcap-ng')
pkgver=0.7.10
pkgrel=1
pkgdesc='Library making programming with POSIX capabilities easier than traditional libcap'
url='https://people.redhat.com/sgrubb/libcap-ng/'
license=('LGPL2.1')
arch=('x86_64')
depends=('glibc')
source=("${pkgname}-${pkgver}.tar.gz::https://github.com/stevegrubb/$pkgname/archive/v${pkgver}.tar.gz")
sha512sums=('371dc1c1f6e2999ef4b4173e12338e9a794e9f48bd5ce8fb4d0c05884cff277ecf24f51e4b300487f9b5f52d93de7eeb1542ebb49c82226d06dd44fa76092367')
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
	'--without-debug'
	'--without-python'
	'--without-python3'
	'--with-warn'
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
}
