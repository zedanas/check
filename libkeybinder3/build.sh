pkgname=('libkeybinder3')
pkgver=0.3.2
pkgrel=3
pkgdesc='A library for registering global keyboard shortcuts'
url='https://github.com/engla/keybinder/tree/keybinder-3.0'
license=('MIT')
arch=('x86_64')
depends=(
'glib2'
'glibc'
'gtk3'
'libx11'
)
makedepends=(
'gtk-doc'
'gobject-introspection'
)
optdepends=('lua-lgi: lua bindings')
source=(
"https://github.com/kupferlauncher/keybinder/releases/download/keybinder-3.0-v$pkgver/keybinder-3.0-$pkgver.tar.gz"
"https://github.com/kupferlauncher/keybinder/releases/download/keybinder-3.0-v$pkgver/keybinder-3.0-$pkgver.tar.gz.sig"
'libkeybinder3-gtk-doc.patch::https://github.com/kupferlauncher/keybinder/pull/18.patch'
)
sha1sums=(
'd23c12440b54cb0f40e7e876c22001dc7b5714b0'
'SKIP'
'32333351bda812c4449e943f7da860fe443a4d0a'
)
prepare() {
cd keybinder-3.0-$pkgver
patch -p1 -i $srcdir/libkeybinder3-gtk-doc.patch
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd keybinder-3.0-$pkgver
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
	'--enable-introspection=no'
	'--disable-gtk-doc'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd keybinder-3.0-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libkeybinder3/COPYING
}
