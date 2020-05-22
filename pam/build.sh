pkgname=('pam')
pkgver=1.3.1
pkgrel=2
pkgdesc='PAM (Pluggable Authentication Modules) library'
url='http://linux-pam.org'
license=('GPL2')
arch=('x86_64')
depends=(
'cracklib'
'glibc'
'pambase'
'sh'
)
makedepends=(
'docbook-xml>=4.4'
'docbook-xsl'
'flex'
'w3m'
)
backup=(
'etc/environment'
'etc/default/passwd'
'etc/security/access.conf'
'etc/security/group.conf'
'etc/security/limits.conf'
'etc/security/namespace.conf'
'etc/security/namespace.init'
'etc/security/pam_env.conf'
'etc/security/time.conf'
)
source=(
"https://github.com/linux-pam/linux-pam/releases/download/v$pkgver/Linux-PAM-$pkgver.tar.xz"
"https://github.com/linux-pam/linux-pam/releases/download/v$pkgver/Linux-PAM-$pkgver.tar.xz.asc"
)
md5sums=(
'558ff53b0fc0563ca97f79e911822165'
'SKIP'
)
prepare() {
cd Linux-PAM-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd Linux-PAM-$pkgver
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
	'--disable-pamlocking'
	'--enable-pie'
	'--enable-lckpwdf'
	'--enable-read-both-confs'
	'--with-randomdev=yes'
	'--disable-audit'
	'--enable-cracklib'
	'--enable-db=no'
	'--disable-prelude'
	'--disable-selinux'
	'--disable-nis'
	'--enable-db=no'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd Linux-PAM-$pkgver
make -k check
}
package() {
cd Linux-PAM-$pkgver
make DESTDIR=$pkgdir install
chmod +s $pkgdir/usr/bin/unix_chkpwd
rm $pkgdir/usr/share/doc/Linux-PAM/sag-pam_userdb.html
}
