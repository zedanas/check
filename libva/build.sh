pkgname=('libva')
pkgver=2.7.0
pkgrel=1
pkgdesc='Video Acceleration (VA) API for Linux'
url='https://01.org/linuxmedia/vaapi'
license=('MIT')
arch=('x86_64')
depends=(
'glibc'
'libdrm'
'libgl'
'libx11'
'libxext'
'libxfixes'
)
makedepends=(
'git'
'libglvnd'
'mesa'
'meson'
)
optdepends=(
'intel-media-driver: backend for Intel GPUs (>= Broadwell)'
'libva-intel-driver: backend for Intel GPUs (<= Haswell)'
'libva-vdpau-driver: backend for Nvidia and AMD GPUs'
)
provides=(
'libva-drm.so'
'libva-glx.so'
'libva-wayland.so'
'libva-x11.so'
'libva.so'
)
backup=('etc/libva.conf')
sha256sums=('SKIP')
build() {
cd $pkgname
config_opts=(
	'-Denable_docs=true'
	'-Denable_va_messaging=true'
	'-Ddisable_drm=false'
	'-Dwith_glx=yes'
	'-Dwith_x11=yes'
	'-Dwith_wayland=no'
)
export CFLAGS+=' -DENABLE_VA_MESSAGING'
arch-meson build "${config_opts[@]}"
ninja -C build
}
package() {
cd $pkgname
DESTDIR=$pkgdir ninja -C build install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libva/LICENSE
cd $pkgdir
mkdir -p etc
echo 'LIBVA_MESSAGING_LEVEL=1' > etc/libva.conf
}
