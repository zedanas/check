pkgname=('json-c')
pkgver=0.13.1
pkgrel=3
pkgdesc='A JSON implementation in C'
url='https://github.com/json-c/json-c/wiki'
license=('MIT')
arch=('x86_64')
depends=('glibc')
makedepends=('git')
sha256sums=('SKIP')
prepare() {
cd $pkgname
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname
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
	'--enable-threading'
	'--enable-rdrand'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname
make -k check
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/json-c/LICENSE
}
