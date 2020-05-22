pkgname=('volume_key')
pkgver=0.3.12
pkgrel=2
pkgdesc='A library for manipulating storage volume encryption keys and storing them separately from volumes to handle forgotten passphrases'
url='https://pagure.io/volume_key'
license=('GPL')
arch=('x86_64')
depends=(
'cryptsetup'
'glib2'
'glibc'
'gpgme'
'libutil-linux'
'nspr'
'nss'
)
makedepends=('swig')
source=("https://releases.pagure.org/$pkgname/$pkgname-$pkgver.tar.xz")
sha512sums=('d056154c9b9d23e4eb661946dd59ed97e116903a3afcff9d9e29258408082f33dcbb69958724143f6bf191a3da488a03b6c02af287790990ed6459e29d66553c')
prepare() {
cd $pkgname-$pkgver
autoreconf -fi
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
	'--without-python'
	'--without-python3'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/volume_key/LICENSE
rm -fr $pkgdir/usr/lib/python*
}
