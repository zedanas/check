pkgname=('shadow')
pkgver=4.8.1
pkgrel=1
pkgdesc='Password and account management tool suite with support for shadow files and PAM'
url='https://github.com/shadow-maint/shadow'
license=('BSD')
arch=('x86_64')
groups=('base')
depends=(
'acl'
'attr'
'bash'
'cracklib'
'glibc'
'pam'
)
makedepends=(
'docbook-xsl'
'git'
'libxslt'
)
backup=(
'etc/default/passwd'
'etc/default/useradd'
'etc/login.defs'
'etc/pam.d/chage'
'etc/pam.d/chgpasswd'
'etc/pam.d/chpasswd'
'etc/pam.d/groupadd'
'etc/pam.d/groupdel'
'etc/pam.d/groupmems'
'etc/pam.d/groupmod'
'etc/pam.d/newusers'
'etc/pam.d/passwd'
'etc/pam.d/shadow'
'etc/pam.d/useradd'
'etc/pam.d/userdel'
'etc/pam.d/usermod'
)
install='shadow.install'
source=(
'LICENSE'
'chgpasswd'
'chpasswd'
'defaults.pam'
'login.defs'
'newusers'
'passwd'
'shadow.timer'
'shadow.service'
'useradd.defaults'
)
sha1sums=(
'SKIP'
'33a6cf1e44a1410e5c9726c89e5de68b78f5f922'
'4ad0e059406a305c8640ed30d93c2a1f62c2f4ad'
'12427b1ca92a9b85ca8202239f0d9f50198b818f'
'0e56fed7fc93572c6bf0d8f3b099166558bb46f1'
'81a02eadb5f605fef5c75b6d8a03713a7041864b'
'12427b1ca92a9b85ca8202239f0d9f50198b818f'
'611be25d91c3f8f307c7fe2485d5f781e5dee75f'
'a154a94b47a3d0c6c287253b98c0d10b861226d0'
'b5540736f5acbc23b568973eb5645604762db3dd'
'c173208c5cf34528602f9931468a67b7f68abad3'
)
prepare() {
cd $pkgname
local backports=()
for commit in "${backports[@]}"; do
	git cherry-pick -n $commit
done
autoreconf -fi
sed -i '/^SUBDIRS/s/pam\.d//' etc/Makefile.in
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
	'--enable-man'
	'--enable-utmpx'
	'--enable-shadowgrp'
	'--enable-subordinate-ids'
	'--with-su'
	'--with-nscd'
	'--with-sssd'
	'--with-btrfs'
	'--with-bcrypt'
	'--with-sha-crypt'
	'--with-group-name-max-length=32'
	'--without-fcaps'
	'--with-acl'
	'--with-attr'
	'--without-audit'
	'--with-libcrack'
	'--without-selinux'
	'--with-libpam'
	'--enable-account-tools-setuid'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/login.defs $pkgdir/etc/login.defs
install -Dm644 $srcdir/useradd.defaults $pkgdir/etc/default/useradd
install -Dm644 $srcdir/passwd $pkgdir/etc/pam.d/passwd
install -Dm644 $srcdir/chgpasswd $pkgdir/etc/pam.d/chgpasswd
install -Dm644 $srcdir/chpasswd $pkgdir/etc/pam.d/chpasswd
install -Dm644 $srcdir/newusers $pkgdir/etc/pam.d/newusers
install -Dm644 $srcdir/defaults.pam $pkgdir/etc/pam.d/chage
install -Dm644 $srcdir/defaults.pam $pkgdir/etc/pam.d/groupadd
install -Dm644 $srcdir/defaults.pam $pkgdir/etc/pam.d/groupdel
install -Dm644 $srcdir/defaults.pam $pkgdir/etc/pam.d/groupmod
install -Dm644 $srcdir/defaults.pam $pkgdir/etc/pam.d/shadow
install -Dm644 $srcdir/defaults.pam $pkgdir/etc/pam.d/useradd
install -Dm644 $srcdir/defaults.pam $pkgdir/etc/pam.d/usermod
install -Dm644 $srcdir/defaults.pam $pkgdir/etc/pam.d/userdel
install -Dm644 $srcdir/$pkgname/etc/pam.d/groupmems $pkgdir/etc/pam.d/groupmems
install -Dm644 $srcdir/shadow.timer $pkgdir/usr/lib/systemd/system/shadow.timer
install -Dm644 $srcdir/shadow.service $pkgdir/usr/lib/systemd/system/shadow.service
install -dm755 $pkgdir/usr/lib/systemd/system/timers.target.wants
ln -s ../shadow.timer $pkgdir/usr/lib/systemd/system/timers.target.wants/shadow.timer
install -Dm644 $srcdir/LICENSE $pkgdir/usr/share/licenses/shadow/LICENSE
echo 'CRYPT=sha512' >> $pkgdir/etc/default/passwd
echo 'CRYPT_FILES=sha512' >> $pkgdir/etc/default/passwd
echo 'CRYPT_YP=des' >> $pkgdir/etc/default/passwd
echo 'GROUP_CRYPT=des' >> $pkgdir/etc/default/passwd
echo 'SHA512_CRYPT_FILES=1000' >> $pkgdir/etc/default/passwd
cd $pkgdir
mv usr/sbin/* usr/bin
rm -fr usr/sbin
rm -f etc/pam.d/{chfn,chsh,login,su}
rm -f usr/bin/{chfn,chsh,login,nologin,sg,su,vigr,vipw}
mv usr/bin/newgrp usr/bin/sg
rm -f usr/bin/logoutd
find usr/share/man '(' \
	-name 'chsh.1'    -o \
	-name 'chfn.1'    -o \
	-name 'su.1'      -o \
	-name 'logoutd.8' -o \
	-name 'login.1'   -o \
	-name 'nologin.8' -o \
	-name 'vipw.8'    -o \
	-name 'vigr.8'    -o \
	-name 'newgrp.1' ')' \
-delete
}
