pkgname=('mkinitcpio-busybox')
pkgver=1.31.1
pkgrel=1
pkgdesc='Base initramfs tools'
url='https://www.busybox.net/'
license=('GPL')
arch=('x86_64')
depends=('glibc')
source=(
"https://busybox.net/downloads/busybox-$pkgver.tar.bz2"
"https://busybox.net/downloads/busybox-$pkgver.tar.bz2.sig"
'config'
)
sha256sums=(
'd0f940a72f648943c1f2211e0e3117387c31d765137d92bd8284a3fb9752a998'
'SKIP'
'2d724738dfb062b8676a8df0488a5e288fc7ceb305633fa6b8d672a722837e81'
)
prepare() {
cd busybox-$pkgver
sed 's|^\(CONFIG_EXTRA_CFLAGS\)=.*|\1="'"$CFLAGS"'"|' "$srcdir/config" > .config
}
build() {
cd busybox-$pkgver
make
}
package() {
cd busybox-$pkgver
install -Dm755 busybox $pkgdir/usr/lib/initcpio/busybox
}
