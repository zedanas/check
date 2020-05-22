pkgname=('hardinfo')
pkgver=0.5.1.817
pkgrel=1
pkgdesc='A system information and benchmark tool'
url='https://github.com/lpereira/hardinfo'
license=('GPL2')
arch=('x86_64')
depends=(
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk2'
'libsoup'
'libx11'
'pango'
)
makedepends=(
'cmake'
'git'
)
_commit='877ea2bc7777626c6fe77b6934a09261f1f1409e'
sha1sums=('SKIP')
prepare() {
cd $pkgname
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname
config_opts=(
	"-DCMAKE_C_FLAGS='$CFLAGS -fno-lto'"
	"-DCMAKE_CXX_FLAGS='$CXXFLAGS -fno-lto'"
	"-DCMAKE_LD_FLAGS='$LDFLAGS'"
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_INSTALL_LIBDIR=lib'
	'-DCMAKE_BUILD_TYPE=Release'
	'-DHARDINFO_NOSYNC=OFF'
	'-DHARDINFO_GTK3=OFF'
)
mkdir -p build && cd build
cmake .. "${config_opts[@]}"
make
}
package() {
cd $pkgname/build
make DESTDIR=$pkgdir install
install -Dm644 ../LICENSE $pkgdir/usr/share/licenses/hardinfo/LICENSE
}
