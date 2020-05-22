pkgname=('openvpn')
pkgver=2.4.8
pkgrel=4
pkgdesc='An easy-to-use, robust and highly configurable VPN (Virtual Private Network)'
url='https://openvpn.net/index.php/open-source.html'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'iproute2'
'lz4'
'lzo'
'openssl'
'pam'
'pkcs11-helper'
'systemd-libs'
)
makedepends=(
'git'
'systemd'
)
optdepends=(
'easy-rsa: easy CA and certificate handling'
)
options=('emptydirs')
sha256sums=('SKIP')
prepare() {
cd $pkgname
autoreconf -fi
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
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
	'--disable-debug'
	'--disable-werror'
	'--disable-strict-options'
	'--disable-async-push'
	'--enable-crypto'
	'--enable-server'
	'--enable-management'
	'--enable-pf'
	'--enable-port-share'
	'--enable-fragment'
	'--enable-multihome'
	'--enable-plugins'
	'--enable-plugin-down-root'
	'--enable-def-auth'
	'--enable-async-push'
	'--enable-ofb-cfb'
	'--enable-x509-alt-username'
	'--enable-iproute2'
	'--disable-selinux'
	'--enable-lz4'
	'--enable-lzo'
	'--with-crypto-library=openssl'
	'--enable-plugin-auth-pam'
	'--disable-pam-dlopen'
	'--enable-pkcs11'
	'--enable-systemd'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname
make -k check
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install
mkdir -p $pkgdir/etc/openvpn/{client,server}
install -Dm644 COPYING $pkgdir/usr/share/licenses/openvpn/LICENSE
}
