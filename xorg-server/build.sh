pkgbase='xorg-server'
pkgname=('xorg-server' 'xorg-server-common' 'xorg-server-devel' 'xorg-server-xephyr' 'xorg-server-xnest' 'xorg-server-xvfb' 'xorg-server-xwayland')
pkgver=1.20.8
pkgrel=1
url='https://xorg.freedesktop.org'
license=('custom')
arch=('x86_64')
groups=('xorg')
makedepends=(
'bash'
'dbus'
'egl-wayland'
'glibc'
'libdrm'
'libepoxy'
'libgl'
'libpciaccess'
'libx11'
'libxau'
'libxaw'
'libxcb'
'libxdmcp'
'libxext'
'libxfont2'
'libxi'
'libxkbfile'
'libxmu'
'libxrender'
'libxres'
'libxshmfence'
'libxtst'
'libxv'
'mesa'
'meson'
'nettle'
'pixman'
'systemd-libs'
'wayland'
'wayland-protocols'
'which'
'xcb-util'
'xcb-util-image'
'xcb-util-keysyms'
'xcb-util-renderutil'
'xcb-util-wm'
'xf86-input-libinput'
'xkeyboard-config'
'xorg-font-util'
'xorg-setxkbmap'
'xorg-util-macros'
'xorg-xauth'
'xorg-xkbcomp'
'xorgproto'
'xtrans'
)
options=('emptydirs')
source=(
"https://xorg.freedesktop.org/releases/individual/xserver/$pkgbase-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/xserver/$pkgbase-$pkgver.tar.bz2.sig"
'xserver-autobind-hotplug.patch'
'0001-v2-FS-58644.patch'
'0002-fix-libshadow-2.patch'
'xvfb-run'
'xvfb-run.1'
)
sha512sums=(
'ab0ec0fcbf490c61558b9297f61b58fd2dedb676c78bef6431dc9166054743b43a0091b88a8b3f4e81d1f539909440ee7e188a298cefabe13ea89159639cd805'
'SKIP'
'd84f4d63a502b7af76ea49944d1b21e2030dfd250ac1e82878935cf631973310ac9ba1f0dfedf10980ec6c7431d61b7daa4b7bbaae9ee477b2c19812c1661a22'
'74e1aa0c101e42f0f25349d305641873b3a79ab3b9bb2d4ed68ba8e392b4db2701fcbc35826531ee2667d3ee55673e4b4fecc2a9f088141af29ceb400f72f363'
'3d3be34ad9fa976daec53573d3a30a9f1953341ba5ee27099af0141f0ef7994fa5cf84dc08aae848380e6abfc10879f9a67f07601c7a437abf8aef13a3ec9fe1'
'73c8ead9fba6815dabfec0a55b3a53f01169f6f2d14ac4a431e53b2d96028672dbd6b50a3314568847b37b1e54ea4fc02bdf677feabb3b2697af55e2e5331810'
'de5e2cb3c6825e6cf1f07ca0d52423e17f34d70ec7935e9dd24be5fb9883bf1e03b50ff584931bd3b41095c510ab2aa44d2573fd5feaebdcb59363b65607ff22'
)
prepare() {
cd $pkgbase-$pkgver
patch -Np1 -i $srcdir/xserver-autobind-hotplug.patch
patch -Np1 -i $srcdir/0001-v2-FS-58644.patch
patch -Np1 -i $srcdir/0002-fix-libshadow-2.patch
}
build() {
cd $pkgbase-$pkgver
config_opts=(
	'-Dos_vendor="Arch Linux"'
	'-Dhal=false'
	'-Ddmx=false'
	'-Dipv6=false'
	'-Dlisten_tcp=false'
	'-Dlisten_unix=true'
	'-Dlisten_local=true'
	'-Dmitshm=true'
	'-Dxvmc=true'
	'-Dxace=true'
	'-Dxcsecurity=true'
	'-Ddpms=true'
	'-Dvgahw=true'
	'-Dvbe=true'
	'-Dint10=x86emu'
	'-Dlinux_apm=true'
	'-Dlinux_acpi=true'
	'-Dsuid_wrapper=true'
	'-Dxorg=true'
	'-Dxvfb=true'
	'-Dxnest=true'
	'-Dxephyr=true'
	'-Ddri1=true'
	'-Ddri2=true'
	'-Ddri3=true'
	'-Dxv=true'
	'-Ddga=true'
	'-Dxres=true'
	'-Dxinerama=true'
	'-Dscreensaver=true'
	'-Dxf86bigfont=true'
	'-Dxkb_default_rules=evdev'
	'-Dxkb_default_model=pc105'
	'-Dxkb_default_layout=us'
	'-Dxkb_default_options=grp:lwin_toggle,grp_led:scroll,caps:capslock,altwin:meta_alt,terminate:ctrl_alt_bksp'
	'-Dxkb_dir=/usr/share/X11/xkb'
	'-Dxkb_output_dir=/var/lib/xkb'
	'-Dsystemd_logind=true'
	'-Dglamor=true'
	'-Dglx=true'
	'-Dpciaccess=true'
	'-Dsecure-rpc=false'
	'-Dudev=true'
	'-Dxdmcp=true'
	'-Dxdm-auth-1=true'
	'-Dxwayland=true'
	'-Dxwayland_eglstream=true'
)
export CFLAGS="${CFLAGS/-fno-plt}"
export CXXFLAGS="${CXXFLAGS/-fno-plt}"
export LDFLAGS="${LDFLAGS/,-z,now}"
arch-meson build "${config_opts[@]}"
ninja -C build
}
package_xorg-server() {
pkgdesc='Xorg X server'
depends=(
	'bash'
	'dbus'
	'glibc'
	'libdrm'
	'libepoxy'
	'libgl'
	'libpciaccess'
	'libxau'
	'libxdmcp'
	'libxfont2'
	'libxshmfence'
	'mesa-libgl'
	'nettle'
	'pixman'
	'systemd-libs'
	'xf86-input-libinput'
	'xorg-server-common'
)
provides=(
	'X-ABI-EXTENSION_VERSION=10.0'
	'X-ABI-VIDEODRV_VERSION=24.0'
	'X-ABI-XINPUT_VERSION=24.1'
	'x-server'
)
conflicts=(
	'glamor-egl'
	'nvidia-utils<=331.20'
	'xf86-video-modesetting'
)
replaces=(
	'glamor-egl'
	'xf86-video-modesetting'
)
install='xorg-server.install'
cd $pkgbase-$pkgver
DESTDIR=$pkgdir ninja -C build install
install -Dm644 COPYING $pkgdir/usr/share/licenses/xorg-server/COPYING
ln -s /usr/bin/Xorg $pkgdir/usr/bin/X
cd $pkgdir
mkdir -p etc/X11/xorg.conf.d
mkdir -p $srcdir/xorg-server-common/{usr/{lib/xorg,share/man/man1},var/lib/xkb}
mv usr/lib/xorg/protocol.txt \
$srcdir/xorg-server-common/usr/lib/xorg || true
mv usr/share/man/man1/Xserver.1 \
$srcdir/xorg-server-common/usr/share/man/man1 || true
mv var $srcdir/xorg-server-common || true
mkdir -p $srcdir/xorg-server-xephyr/usr/{bin,share/man/man1}
mv usr/bin/Xephyr $srcdir/xorg-server-xephyr/usr/bin || true
mv usr/share/man/man1/Xephyr.1 \
$srcdir/xorg-server-xephyr/usr/share/man/man1 || true
mkdir -p $srcdir/xorg-server-xvfb/usr/{bin,share/man/man1}
mv usr/bin/Xvfb $srcdir/xorg-server-xvfb/usr/bin || true
mv usr/share/man/man1/Xvfb.1 \
$srcdir/xorg-server-xvfb/usr/share/man/man1 || true
mkdir -p $srcdir/xorg-server-xnest/usr/{bin,share/man/man1}
mv usr/bin/Xnest $srcdir/xorg-server-xnest/usr/bin || true
mv usr/share/man/man1/Xnest.1 \
$srcdir/xorg-server-xnest/usr/share/man/man1 || true
mkdir -p $srcdir/xorg-server-xwayland/usr/bin
mv usr/bin/Xwayland $srcdir/xorg-server-xwayland/usr/bin || true
mkdir -p $srcdir/xorg-server-devel/usr/{lib,share}
mv usr/include $srcdir/xorg-server-devel/usr || true
mv usr/lib/pkgconfig $srcdir/xorg-server-devel/usr/lib || true
mv usr/share/aclocal $srcdir/xorg-server-devel/usr/share || true
}
package_xorg-server-common() {
pkgdesc='Xorg server common files'
depends=(
	'xkeyboard-config'
	'xorg-setxkbmap'
	'xorg-xkbcomp'
)
mv $srcdir/xorg-server-common/* $pkgdir
install -Dm644 $pkgbase-$pkgver/COPYING $pkgdir/usr/share/licenses/xorg-server-common/COPYING
}
package_xorg-server-xephyr() {
pkgdesc='A nested X server that runs as an X application'
depends=(
	'glibc'
	'libepoxy'
	'libgl'
	'libx11'
	'libxau'
	'libxcb'
	'libxdmcp'
	'libxfont2'
	'libxshmfence'
	'nettle'
	'pixman'
	'systemd-libs'
	'xcb-util'
	'xcb-util-image'
	'xcb-util-keysyms'
	'xcb-util-renderutil'
	'xcb-util-wm'
	'xorg-server-common'
)
mv $srcdir/xorg-server-xephyr/* $pkgdir
install -Dm644 $pkgbase-$pkgver/COPYING $pkgdir/usr/share/licenses/xorg-server-xephyr/COPYING
}
package_xorg-server-xvfb() {
pkgdesc='Virtual framebuffer X server'
depends=(
	'bash'
	'glibc'
	'libgl'
	'libxau'
	'libxdmcp'
	'libxfont2'
	'nettle'
	'pixman'
	'systemd-libs'
	'which'
	'xorg-server-common'
	'xorg-xauth'
)
mv $srcdir/xorg-server-xvfb/* $pkgdir
install -Dm755 $srcdir/xvfb-run $pkgdir/usr/bin/xvfb-run
install -Dm644 $srcdir/xvfb-run.1 $pkgdir/usr/share/man/man1/xvfb-run.1
install -Dm644 $pkgbase-$pkgver/COPYING $pkgdir/usr/share/licenses/xorg-server-xvfb/COPYING
}
package_xorg-server-xnest() {
pkgdesc='A nested X server that runs as an X application'
depends=(
	'glibc'
	'libx11'
	'libxau'
	'libxdmcp'
	'libxext'
	'libxfont2'
	'nettle'
	'pixman'
	'systemd-libs'
	'xorg-server-common'
)
mv $srcdir/xorg-server-xnest/* $pkgdir
install -Dm644 $pkgbase-$pkgver/COPYING $pkgdir/usr/share/licenses/xorg-server-xnest/COPYING
}
package_xorg-server-xwayland() {
pkgdesc='Run X clients under wayland'
depends=(
	'glibc'
	'libdrm'
	'libepoxy'
	'libgl'
	'libxau'
	'libxdmcp'
	'libxfont2'
	'libxshmfence'
	'mesa-libgl'
	'nettle'
	'pixman'
	'systemd-libs'
	'wayland'
	'xorg-server-common'
)
mv $srcdir/xorg-server-xwayland/* $pkgdir
install -Dm644 $pkgbase-$pkgver/COPYING $pkgdir/usr/share/licenses/xorg-server-xwayland/COPYING
}
package_xorg-server-devel() {
pkgdesc='Development files for the X.Org X server'
depends=(
	'libpciaccess'
	'mesa'
	'xorg-util-macros'
	'xorgproto'
)
mv $srcdir/xorg-server-devel/* $pkgdir
install -Dm644 $pkgbase-$pkgver/COPYING $pkgdir/usr/share/licenses/xorg-server-devel/COPYING
}
