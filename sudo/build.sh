pkgname='sudo'
pkgver=1.8.31.p1
pkgrel=1
pkgdesc='Give certain users the ability to run some commands as root'
url='https://www.sudo.ws/sudo/'
license=('custom')
arch=('x86_64')
groups=('base-devel')
depends=(
'glibc'
'libgcrypt'
'pam'
'zlib'
)
makedepends=(
'libsasl'
'sssd'
)
backup=(
'etc/sudoers'
'etc/sudo.conf'
'etc/pam.d/sudo'
)
options=('emptydirs')
install='sudo.install'
source=(
"https://www.sudo.ws/$pkgname/dist/$pkgname-${pkgver/.p/p}.tar.gz"
"https://www.sudo.ws/$pkgname/dist/$pkgname-${pkgver/.p/p}.tar.gz.sig"
'sudo.pam'
)
sha256sums=(
'c73cfdfbc1c5cc259fcc3a355e1bacfed99c5580daeadec9704a24cd5e6d15d8'
'SKIP'
'd1738818070684a5d2c9b26224906aad69a4fea77aabd960fc2675aee2df1fa2'
)
prepare() {
cd $pkgname-${pkgver/.p/p}
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname-${pkgver/.p/p}
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
	'--enable-authentication'
	'--enable-root-mailer'
	'--enable-root-sudo'
	'--enable-setreuid'
	'--enable-setresuid'
	'--enable-shadow'
	'--enable-log-host'
	'--enable-shell-sets-home'
	'--enable-path-info'
	'--enable-hardening'
	'--enable-poll'
	'--enable-tmpfiles.d'
	'--enable-shared-libutil'
	'--disable-static-sudoers'
	'--disable-noargs-shell'
	'--disable-env-debug'
	'--disable-env-reset'
	'--disable-admin-flag'
	'--disable-offensive-insults'
	'--enable-pie'
	'--with-man'
	'--with-mdoc'
	'--without-AFS'
	'--without-DCE'
	'--without-passwd'
	'--without-aixauth'
	'--without-fwtk'
	'--without-opie'
	'--without-skey'
	'--without-SecurID'
	'--with-tty-tickets'
	'--with-interfaces'
	'--with-fqdn'
	'--with-ignore-dot'
	'--with-logfac=auth'
	'--with-goodpri=notice'
	'--with-badpri=alert'
	'--with-mailto=root'
	'--with-mail-if-no-user'
	'--with-mail-if-no-host'
	'--with-mail-if-noperms'
	'--with-runas-default=root'
	'--with-timeout=5'
	'--with-passwd-tries=3'
	'--with-password-timeout=5'
	'--with-sudoers-mode=0440'
	'--with-sudoers-uid=0'
	'--with-sudoers-gid=0'
	'--with-umask=022'
	'--with-editor=mcedit'
	'--with-env-editor'
	'--with-insults'
	'--with-all-insults'
	'--without-devel'
	'--without-lecture'
	'--without-long-otp-prompt'
	'--without-umask-override'
	'--without-secure-path'
	'--without-sendmail'
	'--with-rundir=/run/sudo'
	'--with-vardir=/var/db/sudo'
	'--with-logging=file'
	'--without-linux-audit'
	'--disable-gss-krb5-ccache-name'
	'--without-kerb5'
	'--enable-gcrypt'
	'--without-ldap'
	'--disable-sasl'
	'--without-selinux'
	'--disable-openssl'
	'--enable-pam-session'
	'--with-pam'
	'--with-pam-login'
	'--without-sssd'
	'--enable-zlib'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname-${pkgver/.p/p}
make -k check
}
package() {
cd $pkgname-${pkgver/.p/p}
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/sudo.pam $pkgdir/etc/pam.d/sudo
install -Dm644 doc/LICENSE $pkgdir/usr/share/licenses/sudo/LICENSE
touch $pkgdir/etc/sudo.conf
rm $pkgdir/etc/sudoers.dist
rm -fr $pkgdir/run
}
