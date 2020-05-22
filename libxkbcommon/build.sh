pkgbase='libxkbcommon'
pkgname=('libxkbcommon' 'libxkbcommon-x11' 'libxkbcommon-doc')
pkgver=0.10.0
pkgrel=1
url='https://xkbcommon.org/'
license=('custom')
arch=('x86_64')
makedepends=(
'doxygen'
'git'
'graphviz'
'libxcb'
'meson'
'wayland'
'wayland-protocols'
)
checkdepends=(
'libgl'
'xorg-server-xvfb'
)
_commit='e3c3420a7146f4ea6225d6fb417baa05a79c8202'
sha256sums=('SKIP')
build() {
cd $pkgbase
config_opts=(
	'-Denable-docs=true'
	'-Denable-x11=true'
	'-Denable-wayland=true'
	'-Ddefault-rules=evdev'
	'-Ddefault-model=pc105'
	'-Ddefault-layout=us,ru(winkeys)'
	'-Ddefault-variant=base'
	'-Ddefault-options=grp:lwin_toggle,grp_led:scroll,caps:capslock,altwin:meta_alt,terminate:ctrl_alt_bksp'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd $pkgbase
xvfb-run -a
ninja -C build test
}
package_libxkbcommon() {
pkgdesc='Keymap handling library for toolkits and window systems'
depends=(
	'glibc'
	'xkeyboard-config'
)
cd $pkgbase
DESTDIR=$pkgdir ninja -C build install
install -Dm644 LICENSE $pkgdir/usr/share/licenses/libxkbcommon/LICENSE
cd $pkgdir
mkdir -p $srcdir/libxkbcommon-x11/usr/{include/xkbcommon,lib/pkgconfig}
mv usr/lib/*x11* $srcdir/libxkbcommon-x11/usr/lib
mv usr/lib/pkgconfig/*x11* $srcdir/libxkbcommon-x11/usr/lib/pkgconfig
mv usr/include/xkbcommon/*x11* $srcdir/libxkbcommon-x11/usr/include/xkbcommon
mkdir -p $srcdir/libxkbcommon-doc/usr/share
mv usr/share/doc $srcdir/libxkbcommon-doc/usr/share
}
package_libxkbcommon-x11() {
pkgdesc='Keyboard handling library using XKB data for X11 XCB clients'
depends=(
	'glibc'
	'libxcb'
	'libxkbcommon'
)
mv $srcdir/libxkbcommon-x11/* $pkgdir
install -Dm644 $pkgbase/LICENSE $pkgdir/usr/share/licenses/libxkbcommon-x11/LICENSE
}
package_libxkbcommon-doc() {
pkgdesc='API documentation for libxkbcommon'
depends=('libxkbcommon')
mv $srcdir/libxkbcommon-doc/* $pkgdir
install -Dm644 $pkgbase/LICENSE $pkgdir/usr/share/licenses/libxkbcommon-doc/LICENSE
}
