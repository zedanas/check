pkgname=('slim')
pkgver=1.3.6
pkgrel=8
pkgdesc='Desktop-independent graphical login manager for X11'
url='https://sourceforge.net/projects/slim.berlios/'
license=('GPL2')
arch=('x86_64')
depends=(
'gcc-libs'
'glibc'
'libjpeg'
'libpng'
'libx11'
'libxext'
'libxft'
'libxmu'
'libxrandr'
'pam'
'ttf-font'
'xorg-xauth'
)
makedepends=(
'cmake'
'freeglut'
)
backup=(
'etc/pam.d/slim'
'etc/slim.conf'
'etc/slimlock.conf'
)
source=(
"https://downloads.sourceforge.net/project/slim.berlios/slim-$pkgver.tar.gz"
'slim-1.3.6-fix-libslim-libraries.patch'
'slim-1.3.6-add-sessiondir.patch'
'slim-1.3.6-systemd-session.patch'
'slim-1.3.6-default-path.patch'
'slim.pam'
'slimlock.pam'
)
sha256sums=(
'21defeed175418c46d71af71fd493cd0cbffd693f9d43c2151529125859810df'
'3dfa697f8c058390c7e02e7aba769475057ef8ddde945dc43b8cb7f9724dbda0'
'0dffd53a69eb9033a67fad964df6fc150ee7a483e29d8eb8b559010fbd14e5fd'
'900b7ffe723b741c05bcc0ca857f300a2131a0029c6532eb17be935451bf2c70'
'1e303eda65a06edc8c2d938ab0751ae7744effae48cc185fd27d3cc5b2561522'
'b9a77a614c451287b574c33d41e28b5b149c6d2464bdb3a5274799842bca51a4'
'dfe35488b50f19fd96526374edc16850ed37dac919834dd579392b1a7518f2ab'
)
prepare() {
cd $pkgname-$pkgver
sed -i 's|set(LIBDIR "/lib")|set(LIBDIR "/usr/lib")|' CMakeLists.txt
patch -Np1 -i $srcdir/slim-1.3.6-fix-libslim-libraries.patch
patch -Np1 -i $srcdir/slim-1.3.6-add-sessiondir.patch
patch -Np1 -i $srcdir/slim-1.3.6-systemd-session.patch
patch -Np1 -i $srcdir/slim-1.3.6-default-path.patch
}
build() {
cd $pkgname-$pkgver
config_opts=(
	"-DCMAKE_C_FLAGS='$CFLAGS'"
	"-DCMAKE_CXX_FLAGS='$CXXFLAGS'"
	"-DCMAKE_LD_FLAGS='$LDFLAGS'"
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_INSTALL_LIBDIR=/usr/lib'
	'-DCMAKE_BUILD_TYPE=Release'
	'-DBUILD_SHARED_LIBS=ON'
	'-DBUILD_SLIMLOCK=yes'
	'-DUSE_PAM=yes'
	'-DUSE_CONSOLEKIT=no'
)
mkdir -p build && cd build
cmake .. "${config_opts[@]}"
make
}
package() {
cd $pkgname-$pkgver/build
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/slim.pam $pkgdir/etc/pam.d/slim
install -Dm644 $srcdir/slimlock.pam $pkgdir/etc/pam.d/slimlock
install -Dm644 ../slimlock.conf $pkgdir/etc/slimlock.conf
	-e 's|/var/run/slim.lock|/var/lock/slim.lock|' \
	-i $pkgdir/etc/slim.conf
}
