pkgname=('procps-ng')
pkgver=3.3.16
pkgrel=1
pkgdesc='Utilities for monitoring your system and its processes'
url='https://gitlab.com/procps-ng/procps'
license=('GPL' 'LGPL')
arch=('x86_64')
groups=('base')
depends=(
'glibc'
'ncurses'
'systemd-libs'
)
makedepends=(
'intltool'
'systemd'
)
provides=(
'procps'
'sysvinit-tools'
)
conflicts=(
'procps'
'sysvinit-tools'
)
replaces=(
'procps'
'sysvinit-tools'
)
install='install'
source=("https://downloads.sourceforge.net/project/$pkgname/Production/${pkgname}-${pkgver}.tar.xz")
sha256sums=('925eacd65dedcf9c98eb94e8978bbfb63f5de37294cc1047d81462ed477a20af')
prepare() {
cd $pkgname-$pkgver
sed 's:<ncursesw/:<:g' -i watch.c
}
build() {
cd $pkgname-$pkgver
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
	'--disable-w-from'
	'--disable-kill'
	'--enable-skill'
	'--enable-pidof'
	'--enable-numa'
	'--enable-watch8bit'
	'--enable-sigwinch'
	'--enable-modern-top'
	'--enable-wide-percent'
	'--enable-wide-memory'
	'--enable-w-from'
	'--disable-examples'
	'--with-elogind'
	'--with-systemd'
	'--with-ncurses'
	'--disable-libselinux'
)
export CFLAGS+=' -fno-lto'
export CXXFLAGS="${CFLAGS}"
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
}
