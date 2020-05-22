pkgbase='gvfs'
pkgname=('gvfs' 'gvfs-afc' 'gvfs-goa' 'gvfs-google' 'gvfs-gphoto2' 'gvfs-mtp' 'gvfs-nfs' 'gvfs-smb')
pkgver=1.44.1
pkgrel=1
url='https://wiki.gnome.org/Projects/gvfs'
license=('LGPL')
arch=('x86_64')
groups=('gnome')
makedepends=(
'avahi'
'cmake'
'dbus'
'docbook-xsl'
'fuse2'
'fuse3'
'gcc-libs'
'gcr'
'git'
'glib2'
'glibc'
'gnome-online-accounts'
'gsettings-desktop-schemas'
'gtk-doc'
'gtk3'
'intltool'
'libarchive'
'libbluray'
'libcdio-paranoia'
'libgcrypt'
'libgdata'
'libgphoto2'
'libgudev'
'libimobiledevice'
'libmtp'
'libnfs'
'libplist'
'libsecret'
'libsoup'
'libusb'
'libxml2'
'meson'
'openssh'
'polkit'
'psmisc'
'python'
'smbclient'
'systemd-libs'
'udisks2'
)
_commit='0071ed715da2c6ace52c4e772205c01eca209f25'
source=(
'gvfsd.hook'
)
sha256sums=(
'SKIP'
'd3b714db35b2ce75d7f6d528044554decbb9149a98425aff119a071ca0a25282'
)
prepare() {
cd $pkgbase
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgbase
config_opts=(
	'-D man=true'
	'-D devel_utils=false'
	'-D installed_tests=false'
	'-D dnssd=false'
	'-D fuse=true'
	'-D gcr=false'
	'-D goa=true'
	'-D google=true'
	'-D archive=true'
	'-D bluray=false'
	'-D cdda=false'
	'-D gcrypt=true'
	'-D afp=true'
	'-D gphoto2=true'
	'-D gudev=true'
	'-D afc=true'
	'-D mtp=true'
	'-D nfs=true'
	'-D keyring=true'
	'-D http=true'
	'-D logind=true'
	'-D libusb=true'
	'-D admin=true'
	'-D smb=true'
	'-D sftp=true'
	'-D udisks2=true'
)
arch-meson build ${config_opts[@]}
ninja -C build
}
package_gvfs() {
pkgdesc='Virtual filesystem implementation for GIO'
depends=(
	'fuse3'
	'glib2'
	'glibc'
	'gsettings-desktop-schemas>=3.34.0'
	'libarchive'
	'libgcrypt'
	'libgudev'
	'libsecret'
	'libsoup'
	'libxml2'
	'polkit'
	'psmisc'
	'systemd-libs'
	'udisks2'
)
replaces=(
	'gvfs-obexftp'
	'gvfs-afp'
)
optdepends=(
	'gvfs-afc: AFC (mobile devices) support'
	'gvfs-goa: gnome-online-accounts (e.g. OwnCloud) support'
	'gvfs-google: Google Drive support'
	'gvfs-gphoto2: gphoto2 (PTP camera/MTP media player) support'
	'gvfs-mtp: MTP device support'
	'gvfs-nfs: NFS support'
	'gvfs-smb: SMB/CIFS (Windows client) support'
	'gtk3: Recent files support'
)
cd $pkgbase
DESTDIR=$pkgdir ninja -C build install
install -Dm644 ../gvfsd.hook $pkgdir/usr/share/libalpm/hooks/gvfsd.hook
install -d -o root -g polkitd -m 750 $pkgdir/usr/share/polkit-1/rules.d
mkdir -p $srcdir/gvfs-{afc,goa,gphoto2,mtp}/usr/{lib/{gvfs,systemd/user},share/{dbus-1/services,gvfs/{mounts,remote-volume-monitors}}} \
$srcdir/gvfs-{google,nfs,smb}/usr/{lib/gvfs,share/gvfs/mounts} \
$srcdir/gvfs-smb/usr/share/{GConf/gsettings,glib-2.0/schemas}
cd $pkgdir
mv usr/lib/gvfs-afc-volume-monitor \
$srcdir/gvfs-afc/usr/lib || true
mv usr/lib/systemd/user/gvfs-afc-volume-monitor.service \
$srcdir/gvfs-afc/usr/lib/systemd/user || true
mv usr/share/gvfs/remote-volume-monitors/afc.monitor \
$srcdir/gvfs-afc/usr/share/gvfs/remote-volume-monitors || true
mv usr/share/dbus-1/services/org.gtk.vfs.AfcVolumeMonitor.service \
$srcdir/gvfs-afc/usr/share/dbus-1/services || true
mv usr/lib/gvfsd-afc \
$srcdir/gvfs-afc/usr/lib || true
mv usr/share/gvfs/mounts/afc.mount \
$srcdir/gvfs-afc/usr/share/gvfs/mounts || true
mv usr/lib/gvfs-goa-volume-monitor \
$srcdir/gvfs-goa/usr/lib || true
mv usr/lib/systemd/user/gvfs-goa-volume-monitor.service \
$srcdir/gvfs-goa/usr/lib/systemd/user || true
mv usr/share/gvfs/remote-volume-monitors/goa.monitor \
$srcdir/gvfs-goa/usr/share/gvfs/remote-volume-monitors || true
mv usr/share/dbus-1/services/org.gtk.vfs.GoaVolumeMonitor.service \
$srcdir/gvfs-goa/usr/share/dbus-1/services || true
mv usr/lib/gvfsd-google \
$srcdir/gvfs-google/usr/lib || true
mv usr/share/gvfs/mounts/google.mount \
$srcdir/gvfs-google/usr/share/gvfs/mounts || true
mv usr/lib/gvfs-gphoto2-volume-monitor \
$srcdir/gvfs-gphoto2/usr/lib || true
mv usr/lib/systemd/user/gvfs-gphoto2-volume-monitor.service \
$srcdir/gvfs-gphoto2/usr/lib/systemd/user || true
mv usr/share/gvfs/remote-volume-monitors/gphoto2.monitor \
$srcdir/gvfs-gphoto2/usr/share/gvfs/remote-volume-monitors || true
mv usr/share/dbus-1/services/org.gtk.vfs.GPhoto2VolumeMonitor.service \
$srcdir/gvfs-gphoto2/usr/share/dbus-1/services || true
mv usr/lib/gvfsd-gphoto2 \
$srcdir/gvfs-gphoto2/usr/lib || true
mv usr/share/gvfs/mounts/gphoto2.mount \
$srcdir/gvfs-gphoto2/usr/share/gvfs/mounts || true
mv usr/lib/gvfs-mtp-volume-monitor \
$srcdir/gvfs-mtp/usr/lib || true
mv usr/lib/systemd/user/gvfs-mtp-volume-monitor.service \
$srcdir/gvfs-mtp/usr/lib/systemd/user || true
mv usr/share/gvfs/remote-volume-monitors/mtp.monitor \
$srcdir/gvfs-mtp/usr/share/gvfs/remote-volume-monitors || true
mv usr/share/dbus-1/services/org.gtk.vfs.MTPVolumeMonitor.service \
$srcdir/gvfs-mtp/usr/share/dbus-1/services || true
mv usr/lib/gvfsd-mtp \
$srcdir/gvfs-mtp/usr/lib || true
mv usr/share/gvfs/mounts/mtp.mount \
$srcdir/gvfs-mtp/usr/share/gvfs/mounts || true
mv usr/lib/gvfsd-nfs \
$srcdir/gvfs-nfs/usr/lib || true
mv usr/share/gvfs/mounts/nfs.mount \
$srcdir/gvfs-nfs/usr/share/gvfs/mounts || true
mv usr/lib/gvfsd-smb \
$srcdir/gvfs-smb/usr/lib || true
mv usr/lib/gvfsd-smb-browse \
$srcdir/gvfs-smb/usr/lib || true
mv usr/share/gvfs/mounts/smb.mount \
$srcdir/gvfs-smb/usr/share/gvfs/mounts || true
mv usr/share/gvfs/mounts/smb-browse.mount \
$srcdir/gvfs-smb/usr/share/gvfs/mounts || true
mv usr/share/glib-2.0/schemas/org.gnome.system.smb.gschema.xml \
$srcdir/gvfs-smb/usr/share/glib-2.0/schemas || true
mv usr/share/GConf/gsettings/gvfs-smb.convert \
$srcdir/gvfs-smb/usr/share/GConf/gsettings || true
rm -f usr/lib/gvfs-{afc,goa,gphoto2,mtp}-volume-monitor
rm -f usr/lib/systemd/user/gvfs-{afc,goa,gphoto2,mtp}-volume-monitor.service
rm -f usr/share/gvfs/remote-volume-monitors/{afc,goa,gphoto2,mtp}.monitor
rm -f usr/share/dbus-1/services/org.gtk.vfs.{Afc,Goa,GPhoto2,MTP}VolumeMonitor.service
rm -f usr/lib/gvfsd-{afc,google,gphoto2,mtp,nfs,smb,smb-browse}
rm -f usr/share/gvfs/mounts/{afc,google,gphoto2,mtp,nfs,smb,smb-browse}.mount
rm -f usr/share/glib-2.0/schemas/org.gnome.system.smb.gschema.xml
rm -f usr/share/GConf/gsettings/gvfs-smb.convert
}
package_gvfs-afc() {
pkgdesc='Virtual filesystem implementation for GIO (AFC backend; Apple mobile devices)'
depends=(
	"gvfs=$pkgver"
	'glib2'
	'glibc'
	'libimobiledevice'
	'libplist'
)
mv $srcdir/gvfs-afc/* $pkgdir
}
package_gvfs-goa() {
pkgdesc='Virtual filesystem implementation for GIO (Gnome Online Accounts backend; cloud storage)'
depends=(
	"gvfs=$pkgver"
	'glib2'
	'glibc'
	'gnome-online-accounts'
)
mv $srcdir/gvfs-goa/* $pkgdir
}
package_gvfs-google() {
pkgdesc='Virtual filesystem implementation for GIO (Google Drive backend)'
depends=(
	"gvfs-goa=$pkgver"
	'glib2'
	'glibc'
	'gnome-online-accounts'
	'libgdata'
)
mv $srcdir/gvfs-google/* $pkgdir
}
package_gvfs-gphoto2() {
pkgdesc='Virtual filesystem implementation for GIO (gphoto2 backend; PTP camera, MTP media player)'
depends=(
	"gvfs=$pkgver"
	'glib2'
	'glibc'
	'libgphoto2'
	'libgudev'
)
mv $srcdir/gvfs-gphoto2/* $pkgdir
}
package_gvfs-mtp() {
pkgdesc='Virtual filesystem implementation for GIO (MTP backend; Android, media player)'
depends=(
	"gvfs=$pkgver"
	'glib2'
	'glibc'
	'libgudev'
	'libmtp'
	'libusb'
)
mv $srcdir/gvfs-mtp/* $pkgdir
}
package_gvfs-nfs() {
pkgdesc='Virtual filesystem implementation for GIO (NFS backend)'
depends=(
	"gvfs=$pkgver"
	'glib2'
	'glibc'
	'libnfs'
)
install="gvfs-nfs.install"
mv $srcdir/gvfs-nfs/* $pkgdir
}
package_gvfs-smb() {
pkgdesc='Virtual filesystem implementation for GIO (SMB/CIFS backend; Windows client)'
depends=(
	"gvfs=$pkgver"
	'glib2'
	'glibc'
	'smbclient'
)
mv $srcdir/gvfs-smb/* $pkgdir
}
