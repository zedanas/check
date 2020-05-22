pkgname=('lshw')
pkgver=B.02.18
pkgrel=3
pkgdesc='A small tool to provide detailed information on the hardware configuration of the machine'
url='https://ezix.org/project/wiki/HardwareLiSter'
license=('GPL')
arch=('x86_64')
depends=(
'gcc-libs'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk2'
'hwids'
)
makedepends=(
'gcc'
'gtk2'
'sqlite'
)
optdepends=('gtk2')
source=(
"https://ezix.org/software/files/$pkgname-$pkgver.tar.gz"
'https://ezix.org/src/pkg/lshw/commit/fbdc6ab15f7eea0ddcd63da355356ef156dd0d96.patch'
)
sha256sums=(
'ae22ef11c934364be4fd2a0a1a7aadf4495a0251ec6979da280d342a89ca3c2f'
'8fe3bf1f8afee4538d1ce3e26ceecfe609c78ef08e3682eba83ce29bf53af64c'
)
prepare() {
cd $pkgname-$pkgver
patch -p1 -i $srcdir/fbdc6ab15f7eea0ddcd63da355356ef156dd0d96.patch
sed -e "s/CXXFLAGS=/CXXFLAGS=$CPPFLAGS $CXXFLAGS /" -i src/Makefile src/gui/Makefile
sed -e "s/LDFLAGS=-L.\/core\/ -g/LDFLAGS=-L.\/core\/ -g $LDFLAGS/" -i src/Makefile
sed -e "s/LDFLAGS=/LDFLAGS=$LDFLAGS/" -i src/gui/Makefile
}
build() {
cd $pkgname-$pkgver
make SBINDIR=/usr/bin
make SBINDIR=/usr/bin gui
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir SBINDIR=/usr/bin install
make DESTDIR=$pkgdir SBINDIR=/usr/bin install-gui
install -Dm644 src/gui/integration/gtk-lshw.desktop $pkgdir/usr/share/applications/gtk-lshw.desktop
install -Dm644 src/gui/integration/gtk-lshw.pam $pkgdir/usr/share/doc/lshw/gtk-lshw.pam
install -Dm644 src/gui/integration/console.apps $pkgdir/usr/share/doc/lshw/console.apps
install -Dm644 COPYING $pkgdir/usr/share/licenses/lshw/LICENSE
rm -f $pkgdir/usr/share/lshw/{pci,usb}.ids
}
