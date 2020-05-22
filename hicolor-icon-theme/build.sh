pkgname=('hicolor-icon-theme')
pkgver=0.17
pkgrel=1
pkgdesc='Freedesktop.org Hicolor icon theme'
url='https://www.freedesktop.org/wiki/Software/icon-theme/'
license=('GPL2')
arch=('any')
source=("https://icon-theme.freedesktop.org/releases/hicolor-icon-theme-$pkgver.tar.xz")
sha256sums=('317484352271d18cbbcfac3868eab798d67fff1b8402e740baa6ff41d588a9d8')
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
}
