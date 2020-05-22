pkgbase='lvm2'
pkgname=('lvm2' 'device-mapper')
pkgver=2.02.187
pkgrel=1
url='https://sourceware.org/lvm2/'
license=('GPL2' 'LGPL2.1')
arch=('x86_64')
groups=('base')
makedepends=(
'bash'
'git'
'libaio'
'libutil-linux'
'python'
'python2'
'readline'
'systemd'
'thin-provisioning-tools'
)
options=('emptydirs')
source=(
'lvm2_install'
'lvm2_hook'
'sd-lvm2_install'
'11-dm-initramfs.rules'
)
sha256sums=(
'SKIP'
'cc51940a8437f3c8339bb9cec7e929b2cc0852ffc8a0b2463e6f67ca2b9950f6'
'97d7c92e4954bc0108e7cd183b2eb5fe7ecc97e6f56369669e6537cb6ed45d80'
'b749c2da0e9307b0c2c3858d024a19c268e01e393e876a284fe1a302427f72f1'
'e10f24b57582d6e2da71f7c80732a62e0ee2e3b867fe84591ccdb53e80fa92e0'
)
prepare() {
cd $pkgname
sed -e '/^\[Install\]$/,$d' \
	-i scripts/dm_event_systemd_red_hat.socket.in \
	-i scripts/lvm2_lvmetad_systemd_red_hat.socket.in \
	-i scripts/lvm2_lvmpolld_systemd_red_hat.socket.in \
	-i scripts/lvm2_monitoring_systemd_red_hat.service.in
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname
config_opts=(
	'CONFIG_SHELL=/bin/bash'
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
	'--disable-static_link'
	'--disable-debug'
	'--disable-profiling'
	'--enable-ocf'
	'--enable-devmapper'
	'--enable-lvmetad'
	'--enable-lvmpolld'
	'--enable-use-lvmetad'
	'--enable-use-lvmpolld'
	'--enable-use-lvmlockd'
	'--enable-dmfilemapd'
	'--enable-dmeventd'
	'--enable-notify-dbus'
	'--enable-applib'
	'--enable-cmdlib'
	'--enable-units-compat'
	'--enable-fsadm'
	'--enable-blkdeactivate'
	'--enable-blkid_wiping'
	'--enable-ioctl'
	'--enable-o_direct'
	'--enable-write_install'
	'--enable-pkgconfig'
	'--with-optimisation=-O3'
	'--with-interface=ioctl'
	'--with-device-uid=0'
	'--with-device-gid=0'
	'--with-device-mode=0600'
	'--with-device-nodes-on=resume'
	'--with-default-name-mangling=auto'
	'--with-clvmd=none'
	'--with-cluster=internal'
	'--with-snapshots=internal'
	'--with-mirrors=internal'
	'--with-thin=internal'
	'--with-cache=internal'
	'--with-default-mirror-segtype=raid1'
	'--with-default-raid10-segtype=raid10'
	'--with-default-sparse-segtype=thin'
	'--with-default-pid-dir=/run'
	'--with-default-dm-run-dir=/run'
	'--with-default-run-dir=/run/lvm'
	'--with-default-locking-dir=/run/lock/lvm'
	'--disable-selinux'
	'--disable-python3_bindings'
	'--disable-python2_bindings'
	'--enable-readline'
	'--enable-udev_sync'
	'--enable-udev_rules'
	'--enable-udev-rule-exec-detection'
	'--enable-udev-systemd-background-jobs'
	'--with-systemdsystemunitdir=/usr/lib/systemd/system'
)
export CONFIG_SHELL=/bin/bash
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
ccd $pkgname
make -k check
}
package_lvm2() {
pkgdesc='Logical Volume Manager 2 utilities'
depends=(
	"device-mapper>=${pkgver}"
	'bash'
	'glibc'
	'libaio'
	'libutil-linux'
	'readline'
	'systemd-libs'
	'thin-provisioning-tools'
)
conflicts=(
	'lvm'
	'mkinitcpio<0.7'
)
backup=(
	'etc/lvm/lvm.conf'
	'etc/lvm/lvmlocal.conf'
)
cd $pkgname
make DESTDIR=$pkgdir install
make DESTDIR=$pkgdir install_systemd_units
make DESTDIR=$pkgdir install_systemd_generators
install -Dm644 COPYING $pkgdir/usr/share/licenses/lvm2/LICENSE
cd $pkgdir
mkdir -p etc/lvm/{archive,backup}
install -Dm644 $srcdir/lvm2_hook usr/lib/initcpio/hooks/lvm2
install -Dm644 $srcdir/lvm2_install usr/lib/initcpio/install/lvm2
install -Dm644 $srcdir/sd-lvm2_install usr/lib/initcpio/install/sd-lvm2
mkdir -p $pkgdir/usr/lib/systemd/system/{sysinit.target.wants,sockets.target.wants}
ln -sf ../lvm2-lvmetad.socket $pkgdir/usr/lib/systemd/system/sysinit.target.wants/lvm2-lvmetad.socket
ln -sf ../lvm2-lvmpolld.socket $pkgdir/usr/lib/systemd/system/sysinit.target.wants/lvm2-lvmpolld.socket
ln -sf ../lvm2-monitor.service $pkgdir/usr/lib/systemd/system/sysinit.target.wants/lvm2-monitor.service
ln -sf ../dm-event.socket $pkgdir/usr/lib/systemd/system/sockets.target.wants/dm-event.socket
mkdir -p $srcdir/device-mapper/usr/{bin,include,lib/{initcpio,pkgconfig,systemd/system,udev/rules.d},share/man/man8}
mv usr/bin/dm* $srcdir/device-mapper/usr/bin || true
mv usr/bin/blkdeactivate* $srcdir/device-mapper/usr/bin || true
mv usr/include/libdevmapper* $srcdir/device-mapper/usr/include || true
mv usr/lib/libdevmapper.so* $srcdir/device-mapper/usr/lib || true
mv usr/lib/libdevmapper-event.so* $srcdir/device-mapper/usr/lib || true
mv usr/lib/pkgconfig/devmapper* $srcdir/device-mapper/usr/lib/pkgconfig || true
mv usr/lib/systemd/system/dm-* $srcdir/device-mapper/usr/lib/systemd/system || true
mv usr/lib/systemd/system/sockets.target.wants $srcdir/device-mapper/usr/lib/systemd/system || true
mv usr/lib/udev/rules.d/10-dm.rules $srcdir/device-mapper/usr/lib/udev/rules.d || true
mv usr/lib/udev/rules.d/13-dm-disk.rules $srcdir/device-mapper/usr/lib/udev/rules.d || true
mv usr/lib/udev/rules.d/95-dm-notify.rules $srcdir/device-mapper/usr/lib/udev/rules.d || true
mv usr/share/man/man8/dm* $srcdir/device-mapper/usr/share/man/man8 || true
mv usr/share/man/man8/blkdeactivate* $srcdir/device-mapper/usr/share/man/man8 || true
install -Dm644 $srcdir/11-dm-initramfs.rules $srcdir/device-mapper/usr/lib/initcpio/udev/11-dm-initramfs.rules
}
package_device-mapper() {
pkgdesc='Device mapper userspace library and tools'
url='http://sourceware.org/dm/'
depends=(
	'bash'
	'glibc'
	'systemd-libs'
)
mv $srcdir/device-mapper/* $pkgdir
}
