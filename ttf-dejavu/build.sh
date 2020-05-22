pkgname=('ttf-dejavu')
pkgver=2.37
pkgrel=2
pkgdesc='Font family based on the Bitstream Vera Fonts with a wider range of characters'
url='https://dejavu-fonts.github.io/'
license=('custom')
arch=('any')
depends=(
'fontconfig'
'xorg-fonts-encodings'
'xorg-mkfontdir'
'xorg-mkfontscale'
)
provides=('ttf-font')
source=(
"https://downloads.sourceforge.net/project/dejavu/dejavu/$pkgver/dejavu-fonts-ttf-$pkgver.tar.bz2"
'remove-generic-name-assignment-and-aliasing.patch'
)
sha256sums=(
'fa9ca4d13871dd122f61258a80d01751d603b4d3ee14095d65453b4e846e17d7'
'21d85a4f6ea7856074a4eb5c5fce6a10e764d11ff4336e92c4f009815efebb0c'
)
prepare() {
cd dejavu-fonts-ttf-$pkgver
patch -p1 -i $srcdir/remove-generic-name-assignment-and-aliasing.patch
}
package() {
cd dejavu-fonts-ttf-$pkgver
mkdir -p $pkgdir/usr/share/fonts/TTF
install -m644 ttf/*.ttf $pkgdir/usr/share/fonts/TTF/
mkdir -p $pkgdir/etc/fonts/{conf.avail,conf.d}
install -m644 fontconfig/*.conf $pkgdir/etc/fonts/conf.avail/
install -Dm644 LICENSE $pkgdir/usr/share/licenses/ttf-dejavu/LICENSE
cd $pkgdir/etc/fonts/conf.avail
for config in *; do
	ln -sf ../conf.avail/$config ../conf.d/$config
done
}
