pkgbase='systemd'
pkgname=('systemd' 'systemd-libs' 'systemd-resolvconf' 'systemd-sysvcompat')
pkgver=245.4
pkgrel=2
url='https://www.github.com/systemd/systemd'
arch=('x86_64')
makedepends=(
'acl'
'apparmor'
'audit'
'bash-completion'
'bzip2'
'cryptsetup'
'curl'
'dbus'
'docbook-xsl'
'gettext'
'git'
'glib2'
'gnu-efi-libs'
'gnutls'
'gperf'
'hwids'
'intltool'
'iptables'
'kbd'
'kexec-tools'
'kmod'
'libcap'
'libelf'
'libgcrypt'
'libgpg-error'
'libidn'
'libidn2'
'libmicrohttpd'
'libseccomp'
'libutil-linux'
'libxkbcommon'
'libxslt'
'linux-api-headers'
'lz4'
'meson'
'openssl'
'pam'
'pcre2'
'polkit'
'python-lxml'
'qrencode'
'quota-tools'
'shadow'
'util-linux'
'xz'
'zlib'
)
options=('emptydirs')
_commit='f4d7fa4807ada3c1b7d6f67117eadbb014b67d2f'
source=(
'0001-Use-Arch-Linux-device-access-groups.patch'
'0002-make-homed-userdbd-repart-services-installable.patch'
'initcpio-hook-udev'
'initcpio-install-systemd'
'initcpio-install-udev'
'arch.conf'
'loader.conf'
'splash-arch.bmp'
'systemd-user.pam'
'systemd-hook'
'20-systemd-sysusers.hook'
'30-systemd-binfmt.hook'
'30-systemd-catalog.hook'
'30-systemd-daemon-reload.hook'
'30-systemd-hwdb.hook'
'30-systemd-sysctl.hook'
'30-systemd-tmpfiles.hook'
'30-systemd-udev-reload.hook'
'30-systemd-update.hook'
)
sha512sums=(
'SKIP'
'SKIP'
'e38c7c422c82953f9c2476a5ab8009d614cbec839e4088bff5db7698ddc84e3d8ed64f32ed323f57b1913c5c9703546f794996cb415ed7cdda930b627962a3c4'
'85d11bbbb5c10016e4a67eec051315e2e292939844f260bf698018c5bd1c516c28444f635eb15832a23e26891c4beda14bacfa57fdeda45c00f1b653abe3b123'
'f0d933e8c6064ed830dec54049b0a01e27be87203208f6ae982f10fb4eddc7258cb2919d594cbfb9a33e74c3510cfd682f3416ba8e804387ab87d1a217eb4b73'
'01de24951a05d38eca6b615a7645beb3677ca0e0f87638d133649f6dc14dcd2ea82594a60b793c31b14493a286d1d11a0d25617f54dbfa02be237652c8faa691'
'a25b28af2e8c516c3a2eec4e64b8c7f70c21f974af4a955a4a9d45fd3e3ff0d2a98b4419fe425d47152d5acae77d64e69d8d014a7209524b75a81b0edb10bf3a'
'61032d29241b74a0f28446f8cf1be0e8ec46d0847a61dadb2a4f096e8686d5f57fe5c72bcf386003f6520bc4b5856c32d63bf3efe7eb0bc0deefc9f68159e648'
'c416e2121df83067376bcaacb58c05b01990f4614ad9de657d74b6da3efa441af251d13bf21e3f0f71ddcb4c9ea658b81da3d915667dc5c309c87ec32a1cb5a5'
'5a1d78b5170da5abe3d18fdf9f2c3a4d78f15ba7d1ee9ec2708c4c9c2e28973469bc19386f70b3cf32ffafbe4fcc4303e5ebbd6d5187a1df3314ae0965b25e75'
'b90c99d768dc2a4f020ba854edf45ccf1b86a09d2f66e475de21fe589ff7e32c33ef4aa0876d7f1864491488fd7edb2682fc0d68e83a6d4890a0778dc2d6fe19'
'869dab2b1837c964add4019bb402e24e52dbb7f009850ca69fcc5deddd923eeb98eb8ee38601f6e31531f30322472fe7df09af84df27f0467708406c55885323'
'299dcc7094ce53474521356647bdd2fb069731c08d14a872a425412fcd72da840727a23664b12d95465bf313e8e8297da31259508d1c62cc2dcea596160e21c5'
'0d6bc3d928cfafe4e4e0bc04dbb95c5d2b078573e4f9e0576e7f53a8fab08a7077202f575d74a3960248c4904b5f7f0661bf17dbe163c524ab51dd30e3cb80f7'
'2b50b25e8680878f7974fa9d519df7e141ca11c4bfe84a92a5d01bb193f034b1726ea05b3c0030bad1fbda8dbb78bf1dc7b73859053581b55ba813c39b27d9dc'
'63e55b3acd14bc54320b6f2310b43398651ad4e262d4f4a0135e05d34a993e56ed673cc46e57f15b418371df5c4cef6f54486db96325e4abb1d33fb1a3946254'
'a1661ab946c6cd7d3c6251a2a9fd68afe231db58ce33c92c42594aedb5629be8f299ba08a34713327b373a3badd1554a150343d8d3e5dfb102999c281bd49154'
'9426829605bbb9e65002437e02ed54e35c20fdf94706770a3dc1049da634147906d6b98bf7f5e7516c84068396a12c6feaf72f92b51bdf19715e0f64620319de'
'da7a97d5d3701c70dd5388b0440da39006ee4991ce174777931fea2aa8c90846a622b2b911f02ae4d5fffb92680d9a7e211c308f0f99c04896278e2ee0d9a4dc'
'a50d202a9c2e91a4450b45c227b295e1840cc99a5e545715d69c8af789ea3dd95a03a30f050d52855cabdc9183d4688c1b534eaa755ebe93616f9d192a855ee3'
'825b9dd0167c072ba62cabe0677e7cd20f2b4b850328022540f122689d8b25315005fa98ce867cf6e7460b2b26df16b88bb3b5c9ebf721746dce4e2271af7b97'
)
prepare() {
cd $pkgbase-stable
git remote add -f upstream ../systemd
backports=(
	'eec394f10bbfcc3d2fc8504ad8ff5be44231abd5'
	'93c23c9297e48e594785e0bb9c51504aae5fbe3e'
)
for backport_commit in "${backports[@]}"; do
	git log --oneline -1 "${backport_commit}"
	git cherry-pick -n "${backport_commit}"
done
reverts=()
for revert_commit in "${reverts[@]}"; do
	git log --oneline -1 "${revert_commit}"
	git revert -n "$revert_commit}"
done
patch -Np1 -i $srcdir/0001-Use-Arch-Linux-device-access-groups.patch
patch -Np1 -i $srcdir/0002-make-homed-userdbd-repart-services-installable.patch
}
build() {
cd $pkgbase-stable
local _timeservers=(
	'0.arch.pool.ntp.org'
	'1.arch.pool.ntp.org'
	'2.arch.pool.ntp.org'
	'3.arch.pool.ntp.org'
)
local _nameservers=(
	'1.1.1.1'
	'9.9.9.10'
	'8.8.8.8'
	'2606:4700:4700::1111'
	'2620:fe::10'
	'2001:4860:4860::8888'
)
config_opts=(
	-Dversion-tag="${pkgver}-${pkgrel}-arch"
	-Dntp-servers="${_timeservers[*]}"
	-Ddns-servers="${_nameservers[*]}"
	'-Dtests=false'
	'-Dslow-tests=false'
	'-Dinstall-tests=false'
	'-Dima=false'
	'-Defi=true'
	'-Dbinfmt=true'
	'-Dcoredump=true'
	'-Denvironment-d=true'
	'-Dldconfig=true'
	'-Dtmpfiles=true'
	'-Dfirstboot=true'
	'-Dhibernate=true'
	'-Dportabled=true'
	'-Dhostnamed=true'
	'-Dimportd=true'
	'-Dlocaled=true'
	'-Dlogind=true'
	'-Dmachined=true'
	'-Dnetworkd=true'
	'-Dresolve=true'
	'-Drepart=true'
	'-Dpstore=true'
	'-Duserdb=true'
	'-Dhomed=true'
	'-Dtimedated=true'
	'-Dtimesyncd=true'
	'-Dbacklight=true'
	'-Dutmp=true'
	'-Drandomseed=true'
	'-Dsysusers=true'
	'-Dgshadow=true'
	'-Dadm-group=true'
	'-Dwheel-group=true'
	'-Dnss-myhostname=true'
	'-Dnss-mymachines=true'
	'-Dnss-resolve=true'
	'-Dnss-systemd=true'
	'-Ddefault-dnssec=no'
	'-Ddefault-dns-over-tls=no'
	'-Ddefault-hierarchy=hybrid'
	'-Ddefault-net-naming-scheme=latest'
	'-Ddefault-kill-user-processes=false'
	'-Dmemory-accounting-default=true'
	'-Dfallback-hostname=archlinux'
	'-Ddefault-locale=C'
	'-Drpmmacrosdir=no'
	'-Dsysvinit-path='
	'-Dsysvrcnd-path='
	'-Dhtml=false'
	'-Dman=true'
	'-Dtpm=true'
	'-Dsplit-usr=false'
	'-Dsplit-bin=false'
	'-Dlink-udev-shared=true'
	'-Dlink-systemctl-shared=true'
	'-Dlink-timesyncd-shared=true'
	'-Dlink-networkd-shared=true'
	'-Dstatic-libsystemd=false'
	'-Dstatic-libudev=false'
	'-Dcreate-log-dirs=true'
	'-Dcompat-gateway-hostname=true'
	'-Dstatus-unit-format-default=name'
	'-Dok-color=blue'
	'-Dacl=true'
	'-Dapparmor=false'
	'-Daudit=false'
	'-Dbzip2=true'
	'-Dlibcryptsetup=true'
	'-Dlibcurl=true'
	'-Ddbus=true'
	'-Dglib=true'
	'-Dgnu-efi=true'
	'-Dgnutls=false'
	'-Dhwdb=true'
	'-Dvconsole=true'
	'-Dkmod=true'
	'-Delfutils=true'
	'-Dgcrypt=true'
	'-Dlibidn=false'
	'-Dlibidn2=false'
	'-Dlibiptc=false'
	'-Dmicrohttpd=false'
	'-Dremote=false'
	'-Dp11kit=true'
	'-Dpwquality=false'
	'-Dseccomp=true'
	'-Dselinux=false'
	'-Dsmack=false'
	'-Dblkid=true'
	'-Dfdisk=true'
	'-Dxkbcommon=true'
	'-Dlz4=true'
	'-Dopenssl=true'
	'-Dpam=true'
	'-Dpcre2=true'
	'-Dpolkit=true'
	'-Dqrencode=false'
	'-Dquotacheck=false'
	'-Dgshadow=true'
	'-Drfkill=true'
	'-Dxz=true'
	'-Dzlib=true'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd $pkgname-stable
ninja -C build test
}
package_systemd() {
pkgdesc='System and service manager'
license=('GPL2' 'LGPL2.1')
groups=('base-devel')
depends=(
	'acl'
	'bash'
	'bzip2'
	'cryptsetup'
	'curl'
	'dbus'
	'glibc'
	'hwids'
	'iptables'
	'kbd'
	'kmod'
	'libcap'
	'libelf'
	'libgcrypt'
	'libgpg-error'
	'libp11-kit'
	'libseccomp'
	'libutil-linux'
	'lz4'
	'openssl'
	'pam'
	'pcre2'
	'systemd-libs'
	'util-linux'
	'xz'
	'zlib'
)
optdepends=(
	'polkit: allow administration as unprivileged user'
	'quota-tools: kernel-level quota management'
	'systemd-sysvcompat: symlink package to provide sysvinit binaries'
)
provides=(
	"systemd-tools=$pkgver"
	"udev=$pkgver"
	'nss-myhostname'
)
conflicts=(
	'nss-myhostname'
	'systemd-tools'
	'udev'
)
replaces=(
	'nss-myhostname'
	'systemd-tools'
	'udev'
)
backup=(
	'etc/hostname'
	'etc/locale.conf'
	'etc/machine-id'
	'etc/machine-info'
	'etc/vconsole.conf'
	'etc/pam.d/systemd-user'
	'etc/systemd/coredump.conf'
	'etc/systemd/journal-remote.conf'
	'etc/systemd/journal-upload.conf'
	'etc/systemd/journald.conf'
	'etc/systemd/logind.conf'
	'etc/systemd/networkd.conf'
	'etc/systemd/resolved.conf'
	'etc/systemd/sleep.conf'
	'etc/systemd/system.conf'
	'etc/systemd/timesyncd.conf'
	'etc/systemd/user.conf'
	'etc/udev/udev.conf'
)
install='systemd.install'
cd $pkgbase-stable
DESTDIR=$pkgdir ninja -C build install
install -Dm644 $srcdir/initcpio-install-systemd $pkgdir/usr/lib/initcpio/install/systemd
install -Dm644 $srcdir/initcpio-install-udev $pkgdir/usr/lib/initcpio/install/udev
install -Dm644 $srcdir/initcpio-hook-udev $pkgdir/usr/lib/initcpio/hooks/udev
install -Dm644 $srcdir/arch.conf $pkgdir/usr/share/systemd/bootctl/arch.conf
install -Dm644 $srcdir/loader.conf $pkgdir/usr/share/systemd/bootctl/loader.conf
install -Dm644 $srcdir/splash-arch.bmp $pkgdir/usr/share/systemd/bootctl/splash-arch.bmp
install -Dm755 $srcdir/systemd-hook $pkgdir/usr/share/libalpm/scripts/systemd-hook
install -Dm644 -t $pkgdir/usr/share/libalpm/hooks $srcdir/*.hook
install -Dm644 $srcdir/systemd-user.pam $pkgdir/etc/pam.d/systemd-user
install -Dm644 $srcdir/systemd-stable/tmpfiles.d/legacy.conf \
$pkgdir/usr/lib/tmpfiles.d/legacy.conf
echo 'ArchLinux' > $pkgdir/etc/hostname
echo 'LANG=en_US.utf8' >> $pkgdir/etc/locale.conf
echo 'LANGUAGE=en_US.utf8' >> $pkgdir/etc/locale.conf
echo 'LC_CTYPE="en_US.utf8"' >> $pkgdir/etc/locale.conf
echo 'LC_NUMERIC="en_US.utf8"' >> $pkgdir/etc/locale.conf
echo 'LC_TIME="en_US.utf8"' >> $pkgdir/etc/locale.conf
echo 'LC_COLLATE="en_US.utf8"' >> $pkgdir/etc/locale.conf
echo 'LC_MONETARY="en_US.utf8"' >> $pkgdir/etc/locale.conf
echo 'LC_MESSAGES="en_US.utf8"' >> $pkgdir/etc/locale.conf
echo 'LC_PAPER="en_US.utf8"' >> $pkgdir/etc/locale.conf
echo 'LC_NAME="en_US.utf8"' >> $pkgdir/etc/locale.conf
echo 'LC_ADDRESS="en_US.utf8"' >> $pkgdir/etc/locale.conf
echo 'LC_TELEPHONE="en_US.utf8"' >> $pkgdir/etc/locale.conf
echo 'LC_MEASUREMENT="en_US.utf8"' >> $pkgdir/etc/locale.conf
echo 'LC_IDENTIFICATION="en_US.utf8"' >> $pkgdir/etc/locale.conf
echo 'KEYMAP="us"' > $pkgdir/etc/vconsole.conf
echo 'PRETTY_HOSTNAME="ArchLinux"' > $pkgdir/etc/machine-info
touch $pkgdir/etc/machine-id
echo 'disable *' > $pkgdir/usr/lib/systemd/system-preset/99-default.preset
chown root:polkitd $pkgdir/usr/share/polkit-1/rules.d
chmod 0750 $pkgdir/usr/share/polkit-1/rules.d
chown root:systemd-journal $pkgdir/var/log/journal
chmod 2755 $pkgdir/var/log/journal
rm -fr $pkgdir/etc/systemd/system/*
rm -fr $pkgdir/var/log/journal/remote
rm $pkgdir/usr/share/factory/etc/{issue,nsswitch.conf}
sed	-e '/^C \/etc\/nsswitch\.conf/d' \
	-e '/^C \/etc\/issue/d' \
	-i $pkgdir/usr/lib/tmpfiles.d/etc.conf
cd $pkgdir
mkdir -p $srcdir/systemd-libs/usr/lib
mv usr/lib/lib{nss,systemd,udev}*.so* $srcdir/systemd-libs/usr/lib || true
mkdir -p $srcdir/systemd-resolvconf/usr/{bin,share/man/man1}
mv usr/bin/resolvconf $srcdir/systemd-resolvconf/usr/bin || true
mv usr/share/man/man1/resolvconf* $srcdir/systemd-resolvconf/usr/share/man/man1 || true
mkdir -p $srcdir/systemd-sysvcompat/usr/{bin,share/man/man8}
mv usr/share/man/man8/{telinit,halt,reboot,poweroff,runlevel,shutdown}.8 \
$srcdir/systemd-sysvcompat/usr/share/man/man8 || true
mv usr/bin/{halt,init,poweroff,reboot,runlevel,shutdown,telinit} \
$srcdir/systemd-sysvcompat/usr/bin || true
}
package_systemd-libs() {
pkgdesc='Systemd client libraries'
license=('LGPL2.1')
depends=(
	'glibc'
	'libgcrypt'
	'lz4'
	'xz'
)
provides=(
	'libsystemd'
	'libsystemd.so'
	'libudev.so'
)
conflicts=('libsystemd')
replaces=('libsystemd')
mv $srcdir/systemd-libs/* $pkgdir
}
package_systemd-resolvconf() {
pkgdesc='Systemd resolvconf replacement (for use with systemd-resolved)'
license=('LGPL2.1')
depends=('systemd')
provides=(
	'openresolv'
	'resolvconf'
)
conflicts=('openresolv')
mv $srcdir/systemd-resolvconf/* $pkgdir
}
package_systemd-sysvcompat() {
pkgdesc='Sysvinit compat for systemd'
license=('GPL2')
groups=('base')
depends=('systemd')
conflicts=('sysvinit')
mv $srcdir/systemd-sysvcompat/* $pkgdir
}
