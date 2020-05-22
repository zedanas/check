pkgname=('dbus-glib')
pkgver=0.110
pkgrel=1
pkgdesc='GLib bindings for DBUS'
url='https://www.freedesktop.org/wiki/Software/DBusBindings'
license=('GPL')
arch=('x86_64')
depends=(
'dbus'
'expat'
'glib2'
'glibc'
)
makedepends=(
'python'
'gtk-doc'
)
source=(
"https://dbus.freedesktop.org/releases/$pkgname/$pkgname-$pkgver.tar.gz"
"https://dbus.freedesktop.org/releases/$pkgname/$pkgname-$pkgver.tar.gz.asc"
)
sha256sums=(
'7ce4760cf66c69148f6bd6c92feaabb8812dee30846b24cd0f7395c436d7e825'
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
	'--enable-gtk-doc'
	'--disable-tests'
	'--disable-asserts'
	'--disable-checks'
	'--disable-bash-completion'
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
