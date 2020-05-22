pkgname=('xorg-xrdb')
pkgver=1.2.0
pkgrel=1
pkgdesc='X server resource database utility'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
groups=('xorg-apps' 'xorg')
depends=(
'glibc'
'libx11'
'libxmu'
)
makedepends=('xorg-util-macros')
optdepends=(
'gcc: for preprocessing'
'mcpp: a lightweight alternative for preprocessing'
)
source=(
"https://xorg.freedesktop.org/archive/individual/app/xrdb-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/archive/individual/app/xrdb-$pkgver.tar.bz2.sig"
)
sha512sums=(
'14e1cdfb2152fb28f1f4641b177ab236648d7e967a95b952bf4cfce8d3e1ef085e85385354e3381aaf644462e8888a1847f755ab4016ecb4cb4a715b001dd2ef'
'SKIP'
)
prepare() {
cd xrdb-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd xrdb-$pkgver
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
	'--with-cpp=/usr/bin/cpp,/usr/bin/mcpp'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd xrdb-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/xorg-xrdb/COPYING
}
