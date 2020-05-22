pkgname=('adwaita-icon-theme')
pkgver=3.36.0
pkgrel=1
pkgdesc='GNOME standard icons'
url='https://git.gnome.org/browse/adwaita-icon-theme'
license=('LGPL3' 'CCPL:by-sa')
arch=('any')
depends=(
'gtk-update-icon-cache'
'hicolor-icon-theme'
'librsvg'
)
makedepends=(
'git'
'gtk3'
'intltool'
)
_commit='a7a71ea4f2b61e6ce00e4b0681169df92fdb14a1'
sha256sums=('SKIP')
prepare() {
cd $pkgname
autoreconf -fi
}
build() {
cd $pkgname
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
check() {
cd $pkgname
make -k check
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install
}
