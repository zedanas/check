pkgname=('xorg-fonts-encodings')
pkgver=1.0.5
pkgrel=1
pkgdesc='X.org font encoding files'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('any')
groups=('xorg' 'xorg-fonts')
makedepends=(
'xorg-font-util'
'xorg-mkfontscale'
'xorg-util-macros'
)
source=(
"https://xorg.freedesktop.org/releases/individual/font/encodings-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/font/encodings-$pkgver.tar.bz2.sig"
)
sha512sums=(
'920e49f0b3545f181a1574ca3280ac9adef1e68fe27566c195dd7013f728d355c0d759132789357fcf8fa7391fcbe1e17edf2bd85aa5611df5a4d99740011008'
'SKIP'
)
prepare() {
cd encodings-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd encodings-$pkgver
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
	'--enable-gzip-small-encodings'
	'--enable-gzip-large-encodings'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd encodings-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/xorg-fonts-encodings/COPYING
cd $pkgdir/usr/share/fonts/encodings/large
mkfontscale -b -s -l -n -r -p /usr/share/fonts/encodings/large -e . .
cd $pkgdir/usr/share/fonts/encodings/
mkfontscale -b -s -l -n -r -p /usr/share/fonts/encodings -e . -e large .
}
