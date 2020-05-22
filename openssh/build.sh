pkgname=('openssh')
pkgver=8.2p1
pkgrel=3
pkgdesc='Premier connectivity tool for remote login with the SSH protocol'
url='https://www.openssh.com/portable.html'
license=('custom:BSD')
arch=('x86_64')
depends=(
'glibc'
'libedit'
'openssl'
'pam'
'sh'
'zlib'
)
makedepends=('linux-headers')
optdepends=(
'xorg-xauth: X11 forwarding'
'x11-ssh-askpass: input passphrase in X'
)
backup=(
'etc/pam.d/sshd'
'etc/ssh/ssh_authorized_keys'
'etc/ssh/ssh_banner'
'etc/ssh/ssh_config'
'etc/ssh/sshd_config'
)
install='install'
options=('emptydirs')
source=(
"https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/$pkgname-$pkgver.tar.gz"
"https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/$pkgname-$pkgver.tar.gz.asc"
'sshdgenkeys.service'
'sshd.service'
'sshd.conf'
'sshd.pam'
'glibc-2.31.patch'
)
sha256sums=(
'43925151e6cf6cee1450190c0e9af4dc36b41c12737619edff8bcebdff64e671'
'SKIP'
'4031577db6416fcbaacf8a26a024ecd3939e5c10fe6a86ee3f0eea5093d533b7'
'e40f8b7c8e5e2ecf3084b3511a6c36d5b5c9f9e61f2bb13e3726c71dc7d4fbc7'
'4effac1186cc62617f44385415103021f72f674f8b8e26447fc1139c670090f6'
'64576021515c0a98b0aaf0a0ae02e0f5ebe8ee525b1e647ab68f369f81ecd846'
'25b4a4d9e2d9d3289ef30636a30e85fa1c71dd930d5efd712cca1a01a5019f93'
)
prepare() {
cd $pkgname-$pkgver
patch -p1 -i $srcdir/glibc-2.31.patch
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname-$pkgver
config_opts=(
	'--prefix=/usr'
	'--bindir=/usr/bin'
	'--sbindir=/usr/bin'
	'--libdir=/usr/lib'
	'--libexecdir=/usr/lib/ssh'
	'--sysconfdir=/etc/ssh'
	'--localstatedir=/var'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--enable-strip'
	'--enable-pkcs11'
	'--enable-lastlog'
	'--enable-utmp'
	'--enable-utmpx'
	'--enable-wtmp'
	'--enable-wtmpx'
	'--enable-libutil'
	'--enable-pututline'
	'--enable-pututxline'
	'--enable-etc-default-login'
	'--with-pie'
	'--with-stackprotect'
	'--with-hardening'
	'--with-shadow'
	'--with-md5-passwords'
	'--with-mantype=man'
	'--with-sandbox=seccomp_filter'
	'--with-privsep-user=nobody'
	'--with-xauth=/usr/bin/xauth'
	'--with-maildir=/var/spool/mail'
	'--with-pid-dir=/run'
	'--with-default-path=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin'
	'--without-ipaddr-display'
	'--without-4in6'
	'--without-audit'
	'--without-kerberos5'
	'--without-ldns'
	'--with-libedit'
	'--disable-security-key'
	'--without-selinux'
	'--with-openssl'
	'--with-ssl-engine'
	'--with-openssl-header-check'
	'--with-pam'
	'--with-zlib'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname-$pkgver
make -k tests
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/sshdgenkeys.service $pkgdir/usr/lib/systemd/system/sshdgenkeys.service
install -Dm644 $srcdir/sshd.service $pkgdir/usr/lib/systemd/system/sshd.service
install -Dm644 $srcdir/sshd.conf $pkgdir/usr/lib/tmpfiles.d/sshd.conf
install -Dm644 $srcdir/sshd.pam $pkgdir/etc/pam.d/sshd
install -Dm755 contrib/findssl.sh $pkgdir/usr/bin/findssl.sh
install -Dm755 contrib/ssh-copy-id $pkgdir/usr/bin/ssh-copy-id
install -Dm644 contrib/ssh-copy-id.1 $pkgdir/usr/share/man/man1/ssh-copy-id.1
install -Dm644 LICENCE $pkgdir/usr/share/licenses/openssh/LICENCE
touch $pkgdir/etc/ssh/ssh_authorized_keys
echo '
                            Welcome to Arch Linux!
                   Please authenticate yourself to log in.' > $pkgdir/etc/ssh/ssh_banner
	-i $pkgdir/etc/ssh/sshd_config
ln -sf ssh.1.gz $pkgdir/usr/share/man/man1/slogin.1.gz
}
