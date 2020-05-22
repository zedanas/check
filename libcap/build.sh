pkgname=('libcap')
pkgver=2.33
pkgrel=1
pkgdesc='POSIX 1003.1e capabilities'
url='https://sites.google.com/site/fullycapable/'
license=('GPL2')
arch=('x86_64')
depends=(
'glibc'
'attr'
)
makedepends=('linux-api-headers')
provides=('libcap.so')
source=(
"https://kernel.org/pub/linux/libs/security/linux-privs/libcap2/$pkgname-$pkgver.tar.xz"
"https://kernel.org/pub/linux/libs/security/linux-privs/libcap2/$pkgname-$pkgver.tar.sign"
)
sha256sums=(
'08edeaba2757021aeec45c4eeec52566675e0e0f5d4f057284d729e04f2643d6'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
sed -e "s/-O2/$CFLAGS/" -i Make.Rules
sed -e "s/LDFLAGS :=/LDFLAGS := $LDFLAGS/" -i Make.Rules
}
build() {
cd $pkgname-$pkgver
make KERNEL_HEADERS=/usr/include
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir RAISE_SETFCAP=no prefix=/usr lib=/lib install
install -Dm644 pam_cap/capability.conf \
$pkgdir/usr/share/doc/libcap/capability.conf.example
}
