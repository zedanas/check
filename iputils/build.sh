pkgname=('iputils')
pkgver=20190709
pkgrel=2
pkgdesc='Network monitoring tools, including ping'
url='http://www.skbuff.net/iputils/'
license=('GPL')
arch=('x86_64')
groups=('base')
depends=(
'glibc'
'libcap'
'openssl'
)
makedepends=(
'docbook-xsl'
'git'
'meson'
'perl-sgmls'
)
optdepends=('xinetd: for tftpd')
conflicts=(
'arping'
'netkit-base'
'netkit-tftpd'
)
replaces=('netkit-base')
install='iputils.install'
_commit='13e0084'
source=(
'fix-setuid-redeclared.patch'
)
sha1sums=(
'SKIP'
'ea7c400d1c397d514de718957c28730d87cef656'
)
prepare() {
cd $pkgname
patch -p1 -i $srcdir/fix-setuid-redeclared.patch
}
build() {
cd $pkgname
config_opts=(
	'-DENABLE_RDISC_SERVER=true'
	'-DNINFOD_MESSAGES=true'
	'-DUSE_GETTEXT=true'
	'-DNO_SETCAP_OR_SUID=false'
	'-DBUILD_MANS=true'
	'-DBUILD_HTML_MANS=false'
	'-DBUILD_ARPING=true'
	'-DBUILD_CLOCKDIFF=true'
	'-DBUILD_PING=true'
	'-DBUILD_RARPD=true'
	'-DBUILD_RDISC=true'
	'-DBUILD_TFTPD=true'
	'-DBUILD_TRACEPATH=true'
	'-DBUILD_TRACEROUTE6=true'
	'-DBUILD_NINFOD=true'
	'-DUSE_CAP=true'
	'-DUSE_IDN=false'
	'-DUSE_CRYPTO=openssl'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
package() {
cd $pkgname
DESTDIR=$pkgdir ninja -C build install
install -Dm644 LICENSE $pkgdir/usr/share/licenses/iputils/LICENSE
}
