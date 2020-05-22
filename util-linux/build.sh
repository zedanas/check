pkgbase='util-linux'
pkgname=('util-linux' 'libutil-linux')
pkgver=2.35.1
pkgrel=1
url='https://github.com/karelzak/util-linux'
license=('GPL2')
arch=('x86_64')
makedepends=(
'systemd'
'python'
'libcap-ng'
)
_basever=${pkgver%.*}
source=(
"https://www.kernel.org/pub/linux/utils/$pkgbase/v$_basever/$pkgbase-$_basever.tar.xz"
"https://www.kernel.org/pub/linux/utils/$pkgbase/v$_basever/$pkgbase-$_basever.tar.sign"
'pam-login'
'pam-common'
'pam-runuser'
'pam-su'
'util-linux.sysusers'
'60-rfkill.rules'
'rfkill-unblock_.service'
'rfkill-block_.service'
)
sha256sums=(
'b3081b560268c1ec3367e035234e91616fa7923a0afc2b1c80a2a6d8b9dfe2c9'
'SKIP'
'993a3096c2b113e6800f2abbd5d4233ebf1a97eef423990d3187d665d3490b92'
'fc6807842f92e9d3f792d6b64a0d5aad87995a279153ab228b1b2a64d9f32f20'
'95b7cdc4cba17494d7b87f37f8d0937ec54c55de0e3ce9d9ab05ad5cc76bf935'
'51eac9c2a2f51ad3982bba35de9aac5510f1eeff432d2d63c6362e45d620afc0'
'10b0505351263a099163c0d928132706e501dd0a008dac2835b052167b14abe3'
'7423aaaa09fee7f47baa83df9ea6fef525ff9aec395c8cbd9fe848ceb2643f37'
'8ccec10a22523f6b9d55e0d6cbf91905a39881446710aa083e935e8073323376'
'a22e0a037e702170c7d88460cc9c9c2ab1d3e5c54a6985cd4a164ea7beff1b36'
)
prepare() {
cd $pkgbase-$_basever
sed -e 's/\/sbin/\/bin/g' -i configure.ac
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgbase-$_basever
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
	'--disable-gtk-doc'
	'--disable-assert'
	--enable-agetty
	--enable-bfs
	--enable-cal
	--enable-chfn-chsh
	--enable-chmem
	--enable-cramfs
	--enable-eject
	--enable-fallocate
	--enable-fdformat
	--enable-fdisks
	--enable-fsck
	--enable-hardlink
	--enable-hwclock
	--enable-ipcrm
	--enable-ipcs
	--enable-kill
	--enable-last
	--enable-libblkid
	--enable-libfdisk
	--enable-libmount
	--enable-libsmartcols
	--enable-libuuid
	--enable-line
	--enable-logger
	--enable-login
	--enable-losetup
	--enable-lslogins
	--enable-lsmem
	--enable-mesg
	--enable-minix
	--enable-more
	--enable-mount
	--enable-mountpoint
	--enable-newgrp
	--enable-nologin
	--enable-nsenter
	--enable-partx
	--enable-pg
	--enable-pivot_root
	--enable-raw
	--enable-rename
	--enable-rfkill
	--enable-runuser
	--enable-schedutils
	--enable-setpriv
	--enable-setterm
	--enable-su
	--enable-sulogin
	--enable-switch_root
	--enable-tunelp
	--enable-ul
	--enable-unshare
	--enable-utmpdump
	--enable-uuidd
	--enable-vipw
	--enable-wall
	--enable-wdctl
	--enable-wipefs
	--enable-write
	--enable-zramctl
	--enable-symvers
	--enable-tls
	--enable-widechar
	--enable-colors-default
	'--enable-usrdir-path'
	'--enable-login-stat-mail'
	'--enable-sulogin-emergency-mount'
	'--enable-fs-paths-default=/usr/bin:/usr/local/bin'
	'--with-util'
	'--with-tinfo'
	'--with-btrfs'
	'--with-audit=no'
	'--with-cryptsetup'
	'--with-cap-ng=yes'
	'--with-selinux=no'
	'--with-smack=no'
	'--with-systemd=yes'
	'--with-udev=yes'
	'--with-user=no'
	'--with-utempter=no'
	'--with-ncursesw=yes'
	'--with-python=no'
	'--with-python=no'
	'--with-readline=yes'
	'--with-slang=no'
	'--with-libz=yes'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package_util-linux() {
pkgdesc='Miscellaneous system utilities for Linux'
groups=('base' 'base-devel')
depends=(
	'coreutils'
	'glibc'
	'libcap-ng'
	'libutil-linux'
	'ncurses'
	'pam'
	'pcre2'
	'readline'
	'shadow'
	'systemd-libs'
	'zlib'
)
optdepends=(
	'python: python bindings to libmount'
	'words: default dictionary for look'
)
provides=('rfkill')
conflicts=('rfkill')
replaces=('rfkill')
backup=(
	'etc/pam.d/chfn'
	'etc/pam.d/chsh'
	'etc/pam.d/login'
	'etc/pam.d/runuser'
	'etc/pam.d/runuser-l'
	'etc/pam.d/su'
	'etc/pam.d/su-l'
)
cd $pkgbase-$_basever
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/pam-common $pkgdir/etc/pam.d/chfn
install -Dm644 $srcdir/pam-common $pkgdir/etc/pam.d/chsh
install -Dm644 $srcdir/pam-login $pkgdir/etc/pam.d/login
install -Dm644 $srcdir/pam-runuser $pkgdir/etc/pam.d/runuser
install -Dm644 $srcdir/pam-runuser $pkgdir/etc/pam.d/runuser-l
install -Dm644 $srcdir/pam-su $pkgdir/etc/pam.d/su
install -Dm644 $srcdir/pam-su $pkgdir/etc/pam.d/su-l
install -Dm644 $srcdir/util-linux.sysusers \
$pkgdir/usr/lib/sysusers.d/util-linux.conf
install -Dm644 $srcdir/rfkill-unblock_.service \
$pkgdir/usr/lib/systemd/system/rfkill-unblock@.service
install -Dm644 $srcdir/rfkill-block_.service \
$pkgdir/usr/lib/systemd/system/rfkill-block@.service
install -Dm644 $srcdir/60-rfkill.rules \
$pkgdir/usr/lib/udev/rules.d/60-rfkill.rules
chmod 4755 $pkgdir/usr/bin/{newgrp,chsh,chfn}
if [ -f $pkgdir/usr/lib/systemd/system/uuidd.socket ]; then
	sed -i '/ListenStream/ aRuntimeDirectory=uuidd' \
	$pkgdir/usr/lib/systemd/system/uuidd.socket
fi
cd $pkgdir
mkdir -p $srcdir/libutil-linux/usr/lib
mv usr/lib/lib* $srcdir/libutil-linux/usr/lib
}
package_libutil-linux() {
pkgdesc='Util-linux runtime libraries'
depends=(
	'cryptsetup'
	'glibc'
)
provides=(
	'libblkid.so'
	'libfdisk.so'
	'libmount.so'
	'libsmartcols.so'
	'libuuid.so'
)
mv $srcdir/libutil-linux/* $pkgdir
}
