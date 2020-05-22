pkgname=('libinput')
pkgver=1.15.4
pkgrel=1
pkgdesc='Input device management and event handling library'
url='https://www.freedesktop.org/wiki/Software/libinput/'
license=('custom:X11')
arch=('x86_64')
depends=(
'glibc'
'libevdev'
'libudev.so'
'mtdev'
'systemd-libs'
)
makedepends=(
'meson'
)
optdepends=(
'gtk3: libinput debug-gui'
'python-pyudev: libinput measure'
'python-evdev: libinput measure'
)
source=(
"https://freedesktop.org/software/$pkgname/$pkgname-$pkgver.tar.xz"
"https://freedesktop.org/software/$pkgname/$pkgname-$pkgver.tar.xz.sig"
)
sha512sums=(
'4659818952dc729cd5bdb78ebe21edbbacbf8a66a592b13ba30f3bb4c4e264208ec94440a253cfa4edc8b2ef904954eecea6be0f8d63cf239e3858d3abb64a80'
'SKIP'
)
build() {
cd $pkgname-$pkgver
config_opts=(
	'-Ddocumentation=false'
	'-Dinstall-tests=false'
	'-Dtests=false'
	'-Dlibwacom=false'
	'-Ddebug-gui=false'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
package() {
cd $pkgname-$pkgver
DESTDIR=$pkgdir ninja -C build install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libinput/COPYING
}
