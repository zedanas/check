pkgname=('xkeyboard-config')
pkgver=2.29
pkgrel=1
pkgdesc='X keyboard configuration files'
url='https://www.freedesktop.org/wiki/Software/XKeyboardConfig'
license=('custom')
arch=('any')
makedepends=(
'intltool'
'libxslt'
'xorg-xkbcomp'
)
provides=('xkbdata')
conflicts=('xkbdata')
replaces=('xkbdata')
options=('emptydirs')
source=(
"https://xorg.freedesktop.org/archive/individual/data/$pkgname/$pkgname-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/archive/individual/data/$pkgname/$pkgname-$pkgver.tar.bz2.sig"
)
sha512sums=(
'202255af097f3063d76341d1b4a7672662dc645f9bcd7afa87bc966a41db4c20fc6b8f4fbe2fcaec99b6bc458eac10129141a866a165857c46282f6705b78670'
'SKIP'
)
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
	'--enable-compat-rules'
	'--with-xkb-base=/usr/share/X11/xkb'
	'--with-xkb-rules-symlink=xorg'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
install -dm755 $pkgdir/var/lib/xkb
install -Dm644 COPYING $pkgdir/usr/share/licenses/xkeyboard-config/COPYING
mkdir -p $pkgdir/var/lib/xkb
}
