pkgbase='mesa'
pkgname=('mesa' 'libva-mesa-driver' 'mesa-vdpau'  'opencl-mesa' 'vulkan-intel' 'vulkan-mesa-layer' 'vulkan-radeon')
pkgver=20.0.4
pkgrel=1
url='https://www.mesa3d.org/'
license=('custom')
arch=('x86_64')
makedepends=(
'bash'
'clang'
'elfutils'
'expat'
'gcc-libs'
'glib2'
'glibc'
'glslang'
'gtk3'
'libclc'
'libdrm'
'libelf'
'libepoxy'
'libglvnd'
'libomxil-bellagio'
'libunwind'
'libva'
'libvdpau'
'libx11'
'libxcb'
'libxdamage'
'libxext'
'libxfixes'
'libxml2'
'libxrandr'
'libxshmfence'
'libxv'
'libxvmc'
'libxxf86vm'
'llvm'
'lm_sensors'
'meson'
'python-mako'
'valgrind'
'wayland'
'wayland-protocols'
'xorgproto'
'zlib'
'zstd'
)
source=(
"https://mesa.freedesktop.org/archive/$pkgbase-$pkgver.tar.xz"
"https://mesa.freedesktop.org/archive/$pkgbase-$pkgver.tar.xz.sig"
'LICENSE'
)
sha512sums=(
'17d8bc3b56779a8e5648d81da9ee97b66bcec015710801edce4e8055fbb314cd9ebc1d112e3035480ba844c7d9ae6b5b1f1eac0cc0817e69e9253a7748451a55'
'SKIP'
'f9f0d0ccf166fe6cb684478b6f1e1ab1f2850431c06aa041738563eb1808a004e52cdec823c103c9e180f03ffc083e95974d291353f0220fe52ae6d4897fecc7'
)
build() {
cd $pkgbase-$pkgver
config_opts=(
	'-Dvalgrind=false'
	'-Dbuild-tests=false'
	'-Dinstall-intel-gpu-tests=false'
	'-Dxlib-lease=true'
	'-Dasm=true'
	'-Dopengl=true'
	'-Degl=true'
	'-Dgles1=true'
	'-Dgles2=true'
	'-Dgbm=true'
	'-Ddri3=true'
	'-Dopencl-spirv=false'
	'-Dshared-glapi=true'
	'-Dshared-swr=true'
	'-Dgallium-va=true'
	'-Dgallium-xa=true'
	'-Dgallium-nine=true'
	'-Dgallium-extra-hud=true'
	'-Dgallium-drivers=r300,r600,radeonsi,nouveau,svga,virgl,swrast,swr,iris'
	'-Dosmesa=gallium'
	'-Dosmesa-bits=8'
	'-Dshader-cache=true'
	'-Dvulkan-overlay-layer=true'
	'-Dvulkan-drivers=intel,amd'
	'-Dglx-direct=true'
	'-Dglx-read-only-text=false'
	'-Dglx=dri'
	'-Dprefer-iris=true'
	'-Ddri-drivers=i915,i965,nouveau'
	'-Dswr-arches=avx,avx2'
	'-Dtools=glsl,nir,intel,intel-ui,xvmc'
	'-Dgallium-opencl=icd'
	'-Dplatforms=x11,drm'
	'-Dglvnd=true'
	'-Dgallium-omx=disabled'
	'-Dlibunwind=false'
	'-Dgallium-vdpau=true'
	'-Dllvm=true'
	'-Dshared-llvm=true'
	'-Dlmsensors=true'
	'-Dselinux=false'
	'-Dgallium-xvmc=true'
	'-Dvalgrind=false'
	'-Dzstd=true'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
package_mesa() {
pkgdesc='An open-source implementation of the OpenGL specification'
depends=(
	'bash'
	'expat'
	'gcc-libs'
	'glib2'
	'glibc'
	'gtk3'
	'libdrm'
	'libelf'
	'libepoxy'
	'libx11'
	'libxcb'
	'libxdamage'
	'libxext'
	'libxfixes'
	'libxshmfence'
	'libxv'
	'libxvmc'
	'libxxf86vm'
	'llvm-libs'
	'lm_sensors'
	'zlib'
	'zstd'
)
optdepends=(
	'opengl-man-pages: for the OpenGL API man pages'
	'mesa-vdpau: for accelerated video playback'
	'libva-mesa-driver: for accelerated video playback'
)
provides=(
	'ati-dri'
	'intel-dri'
	'mesa-dri'
	'mesa-libgl'
	'nouveau-dri'
	'opengl-driver'
	'svga-dri'
)
conflicts=(
	'ati-dri'
	'intel-dri'
	'mesa-dri'
	'mesa-libgl'
	'nouveau-dri'
	'svga-dri'
)
replaces=(
	'ati-dri'
	'intel-dri'
	'mesa-dri'
	'mesa-libgl'
	'nouveau-dri'
	'svga-dri'
)
backup=('etc/drirc')
cd $pkgbase-$pkgver
DESTDIR=$pkgdir ninja -C build install
cd $pkgdir
mkdir -p $srcdir/libva-mesa-driver/usr/lib/dri
mv usr/lib/dri/*_drv_video.so $srcdir/libva-mesa-driver/usr/lib/dri || true
mkdir -p $srcdir/mesa-vdpau/usr/lib/vdpau
mv usr/lib/vdpau/* $srcdir/mesa-vdpau/usr/lib/vdpau || true
rm -fr usr/lib/vdpau
mkdir -p $srcdir/opencl-mesa/{etc/OpenCL/vendors,usr/lib/gallium-pipe}
mv etc/OpenCL/vendors/mesa.icd $srcdir/opencl-mesa/etc/OpenCL/vendors || true
mv usr/lib/gallium-pipe/pipe_*.so $srcdir/opencl-mesa/usr/lib/gallium-pipe || true
mv usr/lib/lib*OpenCL* $srcdir/opencl-mesa/usr/lib || true
rm -fr etc/OpenCL usr/lib/gallium-pipe
mkdir -p $srcdir/vulkan-intel/usr/{lib,include/vulkan,share/vulkan/icd.d}
mv usr/share/vulkan/icd.d/intel_icd*.json $srcdir/vulkan-intel/usr/share/vulkan/icd.d || true
mv usr/lib/libvulkan_intel.so $srcdir/vulkan-intel/usr/lib/ || true
mv usr/include/vulkan/vulkan_intel.h $srcdir/vulkan-intel/usr/include/vulkan || true
rm -fr usr/include/vulkan
mkdir -p $srcdir/vulkan-mesa-layer/usr/{lib,share/vulkan/explicit_layer.d}
mv usr/share/vulkan/explicit_layer.d/VkLayer_MESA_overlay.json $srcdir/vulkan-mesa-layer/usr/share/vulkan/explicit_layer.d || true
mv usr/lib/libVkLayer_MESA_overlay.so $srcdir/vulkan-mesa-layer/usr/lib || true
mkdir -p $srcdir/vulkan-radeon/usr/{lib,share/vulkan/icd.d}
mv usr/share/vulkan/icd.d/radeon_icd*.json $srcdir/vulkan-radeon/usr/share/vulkan/icd.d || true
mv usr/lib/libvulkan_radeon.so $srcdir/vulkan-radeon/usr/lib || true
rm -fr usr/share/vulkan
}
package_libva-mesa-driver() {
pkgdesc='VA-API implementation for gallium'
depends=(
	'expat'
	'gcc-libs'
	'glibc'
	'libdrm'
	'libelf'
	'libx11'
	'libxcb'
	'libxshmfence'
	'llvm-libs'
	'zlib'
	'zstd'
)
mv $srcdir/libva-mesa-driver/* $pkgdir
install -Dm644 $srcdir/LICENSE $pkgdir/usr/share/licenses/libva-mesa-driver/LICENSE
}
package_mesa-vdpau() {
pkgdesc='Mesa VDPAU drivers'
depends=(
	'expat'
	'gcc-libs'
	'glibc'
	'libdrm'
	'libelf'
	'libx11'
	'libxcb'
	'libxshmfence'
	'llvm-libs'
	'zlib'
	'zstd'
)
mv $srcdir/mesa-vdpau/* $pkgdir
install -Dm644 $srcdir/LICENSE $pkgdir/usr/share/licenses/mesa-vdpau/LICENSE
}
package_opencl-mesa() {
pkgdesc='OpenCL support for AMD/ATI Radeon mesa drivers'
depends=(
	'clang'
	'expat'
	'gcc-libs'
	'glibc'
	'libdrm'
	'libelf'
	'llvm-libs'
	'zlib'
	'zstd'
)
optdepends=('opencl-headers: headers necessary for OpenCL development')
provides=('opencl-driver')
mv $srcdir/opencl-mesa/* $pkgdir
install -Dm644 $srcdir/LICENSE $pkgdir/usr/share/licenses/opencl-mesa/LICENSE
}
package_vulkan-intel() {
pkgdesc='Intel Vulkan mesa driver'
depends=(
	'expat'
	'gcc-libs'
	'glibc'
	'libdrm'
	'libx11'
	'libxcb'
	'libxshmfence'
	'zlib'
	'zstd'
)
optdepends=('vulkan-mesa-layer: a vulkan layer to display information using an overlay')
provides=('vulkan-driver')
mv $srcdir/vulkan-intel/* $pkgdir
install -Dm644 $srcdir/LICENSE $pkgdir/usr/share/licenses/vulkan-intel/LICENSE
}
package_vulkan-mesa-layer() {
pkgdesc='Vulkan overlay layer to display information about the application'
depends=(
	'gcc-libs'
	'glibc'
)
mv $srcdir/vulkan-mesa-layer/* $pkgdir
install -Dm644 $srcdir/LICENSE $pkgdir/usr/share/licenses/vulkan-radeon/LICENSE
}
package_vulkan-radeon() {
pkgdesc='Radeon Vulkan mesa driver'
depends=(
	'expat'
	'gcc-libs'
	'glibc'
	'libdrm'
	'libelf'
	'libx11'
	'libxcb'
	'libxshmfence'
	'llvm-libs'
	'zlib'
	'zstd'
)
optdepends=('vulkan-mesa-layer: a vulkan layer to display information using an overlay')
provides=('vulkan-driver')
mv $srcdir/vulkan-radeon/* $pkgdir
install -Dm644 $srcdir/LICENSE $pkgdir/usr/share/licenses/vulkan-radeon/LICENSE
}
