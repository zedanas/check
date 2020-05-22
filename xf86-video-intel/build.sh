pkgname=('xf86-video-intel')
pkgver=2.99.918
pkgrel=1
epoch=1
pkgdesc='X.org Intel i810/i830/i915/945G/G965+ video drivers'
url='https://01.org/linuxgraphics'
license=('custom')
arch=('x86_64')
groups=('xorg-drivers')
depends=(
'glibc'
'libdrm'
'libpciaccess'
'libx11'
'libxcb'
'libxcursor'
'libxdamage'
'libxext'
'libxfixes'
'libxinerama'
'libxrandr'
'libxrender'
'libxshmfence'
'libxss'
'libxtst'
'libxv'
'libxvmc'
'pixman'
'systemd-libs'
'xcb-util>=0.3.9'
'mesa'
)
makedepends=(
'X-ABI-VIDEODRV_VERSION=24.0'
'git'
'intel-gpu-tools'
'xorg-server-devel'
)
provides=(
'xf86-video-intel-sna'
'xf86-video-intel-uxa'
)
conflicts=(
'X-ABI-VIDEODRV_VERSION<24'
'X-ABI-VIDEODRV_VERSION>=25'
'xf86-video-i810'
'xf86-video-intel-legacy'
'xf86-video-intel-sna'
'xf86-video-intel-uxa'
'xorg-server<1.20'
)
replaces=(
'xf86-video-intel-sna'
'xf86-video-intel-uxa'
)
install='xf86-video-intel.install'
_commit='f66d39544bb8339130c96d282a80f87ca1606caf'
sha256sums=('SKIP')
prepare() {
cd $pkgname
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
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
	'--disable-debug'
	'--enable-backlight'
	'--enable-backlight-helper'
	'--enable-gen4asm'
	'--enable-dri'
	'--enable-dri1'
	'--enable-dri2'
	'--enable-dri3'
	'--enable-create2'
	'--enable-async-swap'
	'--with-default-dri=3'
	'--with-default-accel'
	'--enable-sna'
	'--enable-uxa'
	'--enable-xaa'
	'--enable-dga'
	'--enable-tear-free'
	'--enable-xvmc'
	'--enable-kms'
	'--enable-ums'
	'--enable-tools'
	'--enable-udev'
)
export CFLAGS+=' -fno-lto'
export CFLAGS="${CFLAGS/-fno-plt}"
export CXXFLAGS="${CFLAGS}"
export LDFLAGS="${LDFLAGS/,-z,now}"
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname
make -k check
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/xf86-video-intel/LICENSE
}
