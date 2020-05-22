pkgname=('xorgproto')
pkgver=2019.2
pkgrel=2
pkgdesc='Combined X.Org X11 Protocol headers'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('any')
makedepends=(
'meson'
'xorg-util-macros'
)
source=(
"https://xorg.freedesktop.org/archive/individual/proto/$pkgname-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/archive/individual/proto/$pkgname-$pkgver.tar.bz2.sig"
)
sha512sums=(
'cbfdf6bb3d58d4d4e7788c9ed779402352715e9899f65594fbc527b3178f1dc5e03cebc8ba5a863b3c196a1a0f2026c2d0438207ca19f81f3c8b7da0c0667904'
'SKIP'
)
build() {
cd $pkgname-$pkgver
config_opts=()
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd $pkgname-$pkgver
ninja -C build test
}
package() {
cd $pkgname-$pkgver
DESTDIR=$pkgdir ninja -C build install
mkdir -p $pkgdir/usr/share/doc/xorgproto
install -m644 *.txt $pkgdir/usr/share/doc/xorgproto
install -m644 PM_spec $pkgdir/usr/share/doc/xorgproto
mkdir -p $pkgdir/usr/share/licenses/xorgproto
install -m644 COPYING* $pkgdir/usr/share/licenses/xorgproto
rm -f $pkgdir/usr/include/X11/extensions/{apple,windows}*
rm -f $pkgdir/usr/share/licenses/xorgproto/COPYING-{apple,windows}wmproto
rm -f $pkgdir/usr/share/pkgconfig/{apple,windows}wmproto.pc
rm -f $pkgdir/usr/share/doc/xorgproto/meson_options.txt
}
