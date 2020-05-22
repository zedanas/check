pkgname='faad2'
pkgver=2.9.1
pkgrel=2
pkgdesc='ISO AAC audio decoder'
url='https://github.com/knik0/faad2'
license=('GPL2')
arch=('x86_64')
depends=(
'glibc'
)
provides=(
'faad'
'libfaad.so'
'libfaad_drm.so'
)
source=("$pkgname-$pkgver.tar.gz::https://github.com/knik0/$pkgname/archive/${pkgver//./_}.tar.gz")
sha256sums=('7fa33cff76abdda5a220ca5de0b2e05a77354f3b97f735193c2940224898aa9a')
prepare() {
cd $pkgname-${pkgver//./_}
autoreconf -fi
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname-${pkgver//./_}
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
	'--with-drm'
	'--without-mpeg4ip'
	'--without-xmms'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname-${pkgver//./_}
make -k check
}
package() {
cd $pkgname-${pkgver//./_}
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/faad2/LICENSE
}
