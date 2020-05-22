pkgbase='libcanberra'
pkgname=('libcanberra' 'libcanberra-pulse' 'libcanberra-gstreamer')
pkgver=0.30
pkgrel=2
url='http://0pointer.de/lennart/projects/libcanberra'
license=('LGPL')
arch=('x86_64')
makedepends=(
'alsa-lib'
'gcc-libs'
'git'
'glib2'
'glibc'
'gstreamer'
'gtk-doc'
'gtk2'
'gtk3'
'libcanberra'
'libcanberra-default-sounds'
'libltdl'
'libpulse'
'libudev.so'
'libvorbis'
'libx11'
'lynx'
)
_commit='c0620e432650e81062c1967cc669829dbd29b310'
source=(
'libcanberra.xinit'
)
sha256sums=(
'SKIP'
'a0d0b135d3fea5c703a5f84208b79d66f671b082ae85f67b629ee2568a7ddc30'
)
prepare() {
cd $pkgbase
sed -e 's/freedesktop/default/g' -i src/sound-theme-spec.c
sed -e 's|freedesktop/stereo|default/stereo|g' -i src/test-canberra.c
	-e '/ConditionPathExists=/d' \
	-i src/canberra-system-bootup.service.in \
	-i src/canberra-system-shutdown.service.in \
	-i src/canberra-system-shutdown-reboot.service.in
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgbase
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
	'--disable-oss'
	'--enable-null'
	'--enable-gtk-doc'
	'--with-builtin=dso'
	'--enable-alsa'
	'--enable-gstreamer'
	'--enable-gtk'
	'--enable-gtk3'
	'--enable-pulse'
	'--enable-udev'
	'--disable-tdb'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package_libcanberra() {
pkgdesc='A small and lightweight implementation of the XDG Sound Theme Specification'
depends=(
	'alsa-lib'
	'glib2'
	'glibc'
	'gtk2'
	'gtk3'
	'libcanberra-default-sounds'
	'libltdl'
	'libudev.so'
	'libvorbis'
	'libx11'
	'sh'
)
optdepends=(
	'libcanberra-pulse: PulseAudio driver'
	'libcanberra-gstreamer: GStreamer driver'
)
cd $pkgbase
make -j1 DESTDIR=$pkgdir install
install -Dm755 $srcdir/libcanberra.xinit \
$pkgdir/etc/X11/xinit/xinitrc.d/40-libcanberra-gtk-module.sh
mkdir -p $pkgdir/etc/xdg/autostart
ln -s /usr/share/gnome/autostart/libcanberra-login-sound.desktop \
$pkgdir/etc/xdg/autostart/libcanberra-login-sound.desktop
cd $pkgdir
mkdir -p $srcdir/libcanberra-pulse/usr/lib/libcanberra-${pkgver%%+*}
mv usr/lib/libcanberra-${pkgver%%+*}/libcanberra-pulse.so \
$srcdir/libcanberra-pulse/usr/lib/libcanberra-${pkgver%%+*} || true
mkdir -p $srcdir/libcanberra-gstreamer/usr/lib/libcanberra-${pkgver%%+*}
mv usr/lib/libcanberra-${pkgver%%+*}/libcanberra-gstreamer.so \
$srcdir/libcanberra-gstreamer/usr/lib/libcanberra-${pkgver%%+*} || true
}
package_libcanberra-pulse() {
pkgdesc='PulseAudio plugin for libcanberra'
depends=(
	"libcanberra=$pkgver-$pkgrel"
	'glibc'
	'libpulse'
)
mv $srcdir/libcanberra-pulse/* $pkgdir
}
package_libcanberra-gstreamer() {
pkgdesc='GStreamer plugin for libcanberra'
depends=(
	"libcanberra=$pkgver-$pkgrel"
	'glib2'
	'glibc'
	'gstreamer'
)
mv $srcdir/libcanberra-gstreamer/* $pkgdir
}
