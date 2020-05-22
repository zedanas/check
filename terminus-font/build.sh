pkgname=('terminus-font')
pkgver=4.48
pkgrel=1
pkgdesc='Monospace bitmap font (for X11 and console)'
url='http://terminus-font.sourceforge.net/'
license=('GPL2' 'custom:OFL')
arch=('any')
depends=(
'fontconfig'
'xorg-fonts-encodings'
)
makedepends=(
'fontconfig'
'python3'
'xorg-bdftopcf'
'xorg-mkfontdir'
'xorg-mkfontscale'
)
optdepends=('xorg-fonts-alias')
source=(
"https://downloads.sourceforge.net/project/$pkgname/$pkgname-$pkgver/$pkgname-$pkgver.tar.gz"
'fix-75-yes-terminus.patch'
)
sha256sums=(
'34799c8dd5cec7db8016b4a615820dfb43b395575afbb24fc17ee19c869c94af'
'ddd86485cf6d54e020e36f1c38c56e8b21b57c23a5d76250e15c1d16fed9caa5'
)
prepare() {
cd $pkgname-$pkgver
patch -p1 -i $srcdir/fix-75-yes-terminus.patch
}
build() {
cd $pkgname-$pkgver
config_opts=(
	'--prefix=/usr'
	'--x11dir=/usr/share/fonts/misc'
	'--psfdir=/usr/share/kbd/consolefonts'
)
./configure "${config_opts[@]}"
make
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 75-yes-terminus.conf $pkgdir/etc/fonts/conf.avail/75-yes-terminus.conf
install -Dm644 OFL.TXT $pkgdir/usr/share/licenses/terminus-font/LICENSE
mkdir -p $pkgdir/etc/fonts/conf.d
cd $pkgdir/etc/fonts/conf.d
ln -sf ../conf.avail/75-yes-terminus.conf ../conf.d/75-yes-terminus.conf
}
