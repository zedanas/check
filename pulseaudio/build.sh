pkgbase='pulseaudio'
pkgname=('pulseaudio' 'libpulse' 'pulseaudio-zeroconf' 'pulseaudio-lirc' 'pulseaudio-jack' 'pulseaudio-bluetooth' 'pulseaudio-equalizer')
pkgver=13.0
pkgrel=3
url="https://www.freedesktop.org/wiki/Software/PulseAudio/"
license=('GPL')
arch=('x86_64')
makedepends=(
'attr'
'autoconf-archive'
'avahi'
'bluez'
'bluez-libs'
'check'
'dbus'
'fftw'
'git'
'gtk3'
'intltool'
'jack2'
'libasyncns'
'libcap'
'libsm'
'libsndfile'
'libsoxr'
'libtool'
'libxtst'
'lirc'
'meson'
'openssl'
'orc'
'rtkit'
'sbc'
'speexdsp'
'systemd'
'tdb'
'webrtc-audio-processing'
'xmltoman'
)
_commit='200618b32f0964a479d69c9b6e5073e6931c370a'
source=(
'0001-meson-Define-TUNNEL_SINK-for-module-tunnel-sink.patch'
)
sha256sums=(
'SKIP'
'4ff133e2847baad5bb6798b5816d67551cfba2efabb2f1f348628d7217abd07d'
)
prepare() {
cd $pkgbase
patch -p1 -i $srcdir/0001-meson-Define-TUNNEL_SINK-for-module-tunnel-sink.patch
}
build() {
cd $pkgbase
config_opts=(
	'-Dman=true'
	'-Dtests=false'
	'-Dgsettings=enabled'
	'-Dgtk=enabled'
	'-Dipv6=true'
	'-Dadrian-aec=true'
	'-Dlegacy-database-entry-format=false'
	'-Drunning-from-build-tree=false'
	'-Dsystem_user=pulse'
	'-Dsystem_group=pulse'
	'-Daccess_group=pulse-access'
	'-Dpulsedsp-location=/usr/lib/pulseaudio'
	'-Dudevrulesdir=/usr/lib/udev/rules.d'
	'-Dalsa=enabled'
	'-Davahi=enabled'
	'-Ddbus=enabled'
	'-Dfftw=enabled'
	'-Ddatabase=gdbm'
	'-Dglib=enabled'
	'-Djack=enabled'
	'-Dasyncns=disabled'
	'-Dsamplerate=disabled'
	'-Dx11=enabled'
	'-Dsoxr=disabled'
	'-Dsystemd=enabled'
	'-Dudev=enabled'
	'-Dhal-compat=false'
	'-Dlirc=enabled'
	'-Dopenssl=enabled'
	'-Dorc=disabled'
	'-Dbluez5=true'
	'-Dbluez5-ofono-headset=true'
	'-Dbluez5-native-headset=true'
	'-Dspeex=disabled'
	'-Dwebrtc-aec=disabled'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd $pkgbase
ninja -C build test
}
package_pulseaudio() {
pkgdesc="A featureful, general-purpose sound server"
depends=(
	"libpulse=$pkgver-$pkgrel"
	'alsa-lib'
	'bash'
	'dbus'
	'gdbm'
	'glib2'
	'glibc'
	'libcap'
	'libice'
	'libsm'
	'libsndfile'
	'libtool'
	'libx11'
	'libxcb'
	'libxtst'
	'openssl'
	'systemd-libs'
)
optdepends=('pulseaudio-alsa: ALSA configuration (recommended)')
replaces=('pulseaudio-xen<=9.0')
backup=(
	'etc/pulse/daemon.conf'
	'etc/pulse/default.pa'
	'etc/pulse/system.pa'
)
install="pulseaudio.install"
cd $pkgbase
DESTDIR=$pkgdir ninja -C build install
cd $pkgdir
rm etc/dbus-1/system.d/pulseaudio-system.conf
sed -e '/flat-volumes/iflat-volumes = no' -i etc/pulse/daemon.conf
sed -e '/autospawn/iautospawn = no' -i etc/pulse/client.conf
sed -e '/Load several protocols/aload-module module-dbus-protocol' -i etc/pulse/default.pa
mkdir -p $srcdir/libpulse/{etc/pulse,usr/{bin,lib/pulseaudio,share/man/man{1,5}}}
mv etc/pulse/client.conf $srcdir/libpulse/etc/pulse || true
mv usr/bin/pa{cat,ctl,dsp,mon,play,rec,record} $srcdir/libpulse/usr/bin || true
mv usr/lib/libpulse{,-simple,-mainloop-glib}.so* $srcdir/libpulse/usr/lib || true
mv usr/lib/{cmake,pkgconfig} $srcdir/libpulse/usr/lib || true
mv usr/lib/pulseaudio/libpulse{dsp,common-*}.so $srcdir/libpulse/usr/lib/pulseaudio || true
mv usr/include $srcdir/libpulse/usr || true
mv usr/share/man/man1/pa{cat,ctl,dsp,mon,play,rec,record}.1 $srcdir/libpulse/usr/share/man/man1 || true
mv usr/share/man/man5/pulse-client.conf.5 $srcdir/libpulse/usr/share/man/man5 || true
mv usr/share/vala $srcdir/libpulse/usr/share || true
mkdir -p $srcdir/{zeroconf,lirc,jack,bluetooth,equalizer}/usr/lib/pulse-$pkgver/modules \
$srcdir/{gconf/usr/lib/pulse,equalizer/usr/bin}
mv usr/lib/pulse-$pkgver/modules/{libavahi-wrap,module-{zeroconf-{publish,discover},raop-discover}}.so \
$srcdir/zeroconf/usr/lib/pulse-$pkgver/modules || true
mv usr/lib/pulse-$pkgver/modules/module-lirc.so \
$srcdir/lirc/usr/lib/pulse-$pkgver/modules || true
mv usr/lib/pulse-$pkgver/modules/module-jack{-sink,-source,dbus-detect}.so \
$srcdir/jack/usr/lib/pulse-$pkgver/modules || true
mv usr/lib/pulse-$pkgver/modules/{libbluez5-util,module-{bluetooth-{discover,policy},bluez5-{discover,device}}}.so \
$srcdir/bluetooth/usr/lib/pulse-$pkgver/modules || true
mv usr/lib/pulse-$pkgver/modules/module-equalizer-sink.so \
$srcdir/equalizer/usr/lib/pulse-$pkgver/modules || true
mv usr/bin/qpaeq \
$srcdir/equalizer/usr/bin || true
}
package_libpulse() {
pkgdesc="$pkgdesc (client library)"
license=('LGPL')
depends=(
	'dbus'
	'glib2'
	'glibc'
	'libsndfile'
	'libxcb'
	'systemd-libs'
)
backup=('etc/pulse/client.conf')
mv $srcdir/libpulse/* $pkgdir
}
package_pulseaudio-zeroconf() {
pkgdesc="Zeroconf support for PulseAudio"
depends=(
	"libpulse=$pkgver-$pkgrel"
	"pulseaudio=$pkgver-$pkgrel"
	'avahi'
	'dbus'
	'glibc'
)
mv $srcdir/zeroconf/* $pkgdir
}
package_pulseaudio-lirc() {
pkgdesc="IR (lirc) support for PulseAudio"
depends=(
	"libpulse=$pkgver-$pkgrel"
	"pulseaudio=$pkgver-$pkgrel"
	'glibc'
	'lirc'
)
mv $srcdir/lirc/* $pkgdir
}
package_pulseaudio-jack() {
pkgdesc="Jack support for PulseAudio"
depends=(
	"libpulse=$pkgver-$pkgrel"
	"pulseaudio=$pkgver-$pkgrel"
	'dbus'
	'glibc'
	'jack2'
)
mv $srcdir/jack/* $pkgdir
}
package_pulseaudio-bluetooth() {
pkgdesc="Bluetooth support for PulseAudio"
depends=(
	"libpulse=$pkgver-$pkgrel"
	"pulseaudio=$pkgver-$pkgrel"
	'dbus'
	'glibc'
	'sbc'
)
mv $srcdir/bluetooth/* $pkgdir
}
package_pulseaudio-equalizer() {
pkgdesc="Equalizer for PulseAudio"
license=('AGPL3')
depends=(
	"libpulse=$pkgver-$pkgrel"
	"pulseaudio=$pkgver-$pkgrel"
	'dbus'
	'fftw'
	'glibc'
)
mv $srcdir/equalizer/* $pkgdir
}
