pkgname='xdg-utils'
pkgver=1.1.4
pkgrel=1
pkgdesc='Command line tools that assist applications with a variety of desktop integration tasks'
url='https://www.freedesktop.org/wiki/Software/xdg-utils/'
license=('MIT')
arch=('any')
depends=(
'file'
'sh'
'which'
'xorg-xset'
)
makedepends=(
'docbook-xsl'
'git'
'lynx'
'xmlto'
)
optdepends=(
'exo: for Xfce support in xdg-open'
'kde-cli-tools: for KDE Plasma5 support in xdg-open'
'pcmanfm: for LXDE support in xdg-open'
'perl-file-mimeinfo: for generic support in xdg-open'
'perl-net-dbus: Perl extension to dbus used in xdg-screensaver'
'perl-x11-protocol: Perl X11 protocol used in xdg-screensaver'
'xorg-xprop: for Xfce support in xdg-open'
)
options=('emptydirs')
_commit='9816ebb3e6fd9f23e993b8b7fcbd56f92d9c9197'
sha256sums=('SKIP')
prepare() {
cd $pkgname
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
install -Dm644 LICENSE $pkgdir/usr/share/licenses/xdg-utils/LICENSE
mkdir -p $pkgdir/usr/share/desktop-directories
}
