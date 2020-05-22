pkgname=('libsm')
pkgver=1.2.3
pkgrel=1
pkgdesc='X11 Session Management library'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libice'
'libutil-linux'
)
makedepends=(
'xorg-util-macros'
'xtrans'
)
source=("https://xorg.freedesktop.org/releases/individual/lib/libSM-$pkgver.tar.bz2")
sha512sums=('74c42e27029db78475e62025b4711dbac5e22d2f8e8a24be98a1c31b03c0fc4afe859928f851800ea0b76854f12147900dc4f27bbfd3d8ea45daaaf24b70a903')
prepare() {
cd libSM-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd libSM-$pkgver
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
	'--enable-unix-transport'
	'--disable-tcp-transport'
	'--disable-ipv6'
	'--enable-docs'
	'--with-libuuid'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd libSM-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libsm/COPYING
}
