pkgname=('xorg-mkfontscale')
pkgver=1.2.1
pkgrel=2
pkgdesc='Create an index of scalable font files for X'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
groups=('xorg-apps' 'xorg')
depends=(
'bash'
'bzip2'
'freetype2'
'glibc'
'libfontenc'
'zlib'
)
makedepends=(
'xorg-util-macros'
'xorgproto'
)
provides=('xorg-mkfontdir')
conflicts=('xorg-mkfontdir')
replaces=('xorg-mkfontdir')
install='xorg-mkfontscale.install'
source=(
"https://xorg.freedesktop.org/archive/individual/app/mkfontscale-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/archive/individual/app/mkfontscale-$pkgver.tar.bz2.sig"
'xorg-mkfontscale.hook'
'xorg-mkfontscale.script'
)
sha512sums=(
'4d243160e1f7f8dfa6a8f53349c1a42a55fc99426455ebdef58352c5e951fce8b4f1fbd1061a76c9a148095b002eac372db1ae5e2647d2ccb4886635b317b18c'
'SKIP'
'3c42bd72d88200a63159e84f8b04045aaf5c176ef98711a4196fad92a96467103368212e13571a8eeef929b2c7affe6c40797f67596fccc955750dcf7c1b3646'
'2a53d38c85b962eaee534f6f3fad4122412a7200c6787fd8216eb191904e2e3727400606a73d6f09017016f6c1360e5148afbb8fbe16e35c5e5cd55dec635387'
)
prepare() {
cd mkfontscale-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd mkfontscale-$pkgver
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
	'--with-bzip2'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd mkfontscale-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/xorg-mkfontscale/COPYING
install -Dm644 $srcdir/xorg-mkfontscale.hook $pkgdir/usr/share/libalpm/hooks/xorg-mkfontscale.hook
install -D $srcdir/xorg-mkfontscale.script $pkgdir/usr/share/libalpm/scripts/xorg-mkfontscale
}
