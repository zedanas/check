pkgname=('libxcb')
pkgver=1.14
pkgrel=1
pkgdesc='X11 client-side library'
url='https://xcb.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libxau'
'libxdmcp'
'xcb-proto'
)
makedepends=(
'libxslt'
'python'
'xorg-util-macros'
'xorgproto'
)
source=(
"https://xorg.freedesktop.org/archive/individual/lib/$pkgname-$pkgver.tar.xz"
"https://xorg.freedesktop.org/archive/individual/lib/$pkgname-$pkgver.tar.xz.sig"
)
sha512sums=(
'b90a23204b0d2c29d8b115577edb01df0465e02d6a8876550fecd62375d24a5d5f872ddd5946772ddba077cadce75b12c7a6d218469dc30b5b92bc82188e8bc6'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
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
	'--disable-devel-docs'
	'--enable-composite'
	'--enable-damage'
	'--enable-dpms'
	'--enable-dri2'
	'--enable-dri3'
	'--enable-ge'
	'--enable-glx'
	'--enable-present'
	'--enable-randr'
	'--enable-record'
	'--enable-render'
	'--enable-resource'
	'--enable-screensaver'
	'--enable-shape'
	'--enable-shm'
	'--enable-sync'
	'--enable-xevie'
	'--enable-xfixes'
	'--enable-xfree86-dri'
	'--enable-xinerama'
	'--enable-xinput'
	'--enable-xkb'
	'--enable-xprint'
	'--enable-selinux'
	'--enable-xtest'
	'--enable-xv'
	'--enable-xvmc'
	'--without-doxygen'
	'--without-serverside-support'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname-$pkgver
make -k check
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxcb/COPYING
}
