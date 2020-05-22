pkgbase='xcursor-vanilla-dmz'
pkgname=('xcursor-vanilla-dmz' 'xcursor-vanilla-dmz-aa')
pkgver=0.4.5
pkgrel=1
url='http://jimmac.musichall.cz/'
license=('CCPL:by-nc-sa')
arch=('any')
makedepends=('xorg-xcursorgen')
source=("http://ftp.de.debian.org/debian/pool/main/d/dmz-cursor-theme/dmz-cursor-theme_$pkgver.tar.xz")
sha256sums=('b719a64ed9c51905743105e5a50b15492695929ab2d6fca2cea760d52ccd1f5c')
build() {
cd $srcdir/dmz-cursor-theme-$pkgver/DMZ-White/pngs
./make.sh
cd $srcdir/dmz-cursor-theme-$pkgver/DMZ-Black/pngs
./make.sh
}
package_xcursor-vanilla-dmz() {
pkgdesc='Vanilla DMZ cursor theme'
cd dmz-cursor-theme-$pkgver
mkdir -p $pkgdir/usr/share/icons/Vanilla-DMZ/cursors
cp -a DMZ-White/xcursors/* $pkgdir/usr/share/icons/Vanilla-DMZ/cursors
install -Dm644 DMZ-White/index.theme $pkgdir/usr/share/icons/Vanilla-DMZ/index.theme
}
package_xcursor-vanilla-dmz-aa() {
pkgdesc='Vanilla DMZ AA cursor theme'
cd dmz-cursor-theme-$pkgver
mkdir -p $pkgdir/usr/share/icons/Vanilla-DMZ-AA/cursors
cp -a DMZ-Black/xcursors/* $pkgdir/usr/share/icons/Vanilla-DMZ-AA/cursors
install -Dm644 DMZ-Black/index.theme $pkgdir/usr/share/icons/Vanilla-DMZ-AA/index.theme
}
