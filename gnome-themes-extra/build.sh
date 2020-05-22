pkgname='gnome-themes-extra'
pkgver=3.28
pkgrel=1
pkgdesc='Extra Themes for GNOME Applications'
url='https://gitlab.gnome.org/GNOME/gnome-themes-extra'
license=('LGPL2.1')
arch=('x86_64')
groups=('gnome')
depends=(
'cairo'
'glib2'
'glibc'
'gtk2'
)
makedepends=(
'intltool'
'gtk3'
'git'
)
optdepends=('gtk-engines: HighContrast GTK2 theme')
provides=("gnome-themes-standard=$pkgver")
conflicts=('gnome-themes-standard')
replaces=('gnome-themes-standard<3.27.92')
_commit='9f581269243dd7e76b3eb8cec9cf4128ab17da9e'
sha256sums=('SKIP')
prepare() {
cd $pkgname
mkdir m4
intltoolize
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
	'--disable-glibtest'
	'--enable-gtk3-engine'
	'--enable-gtk2-engine'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install
}
