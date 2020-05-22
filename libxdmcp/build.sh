pkgname=('libxdmcp')
pkgver=1.1.3
pkgrel=2
pkgdesc='X11 Display Manager Control Protocol library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'xorgproto'
)
makedepends=('xorg-util-macros')
source=(
"https://xorg.freedesktop.org/releases/individual/lib/libXdmcp-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/lib/libXdmcp-$pkgver.tar.bz2.sig"
)
sha512sums=(
'cb1d4650f97d66e73acd2465ec7d757b9b797cce2f85e301860a44997a461837eea845ec9bd5b639ec5ca34c804f8bdd870697a5ce3f4e270b687c9ef74f25ec'
'SKIP'
)
prepare() {
cd libXdmcp-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libXdmcp-$pkgver
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
	'--enable-docs'
	'--disable-unit-tests'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd libXdmcp-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxdmcp/COPYING
}
