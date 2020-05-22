pkgname=('fontconfig')
pkgver=2.13.92
pkgrel=1
epoch=2
pkgdesc='A library for configuring and customizing font access'
url='https://www.freedesktop.org/wiki/Software/fontconfig/'
license=('custom')
arch=('x86_64')
depends=(
'expat'
'freetype2'
'glibc'
)
makedepends=(
'git'
'gperf'
)
install='fontconfig.install'
options=('emptydirs')
_commit='75eadca26648abf69497691ff0f4c7803b9ff23c'
source=(
'fontconfig.hook'
)
sha256sums=(
'SKIP'
'8883f7e6e9d574ed52b89256507a6224507925715ddc85b3dfab9683df2f1e25'
)
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
	'--disable-docs'
	'--enable-iconv'
	'--with-xmldir=/etc/fonts'
	'--with-templatedir=/etc/fonts/conf.avail'
	'--with-default-fonts=/usr/share/fonts'
	'--with-add-fonts=/usr/local/share/fonts'
	'--with-default-hinting=slight'
	'--disable-libxml2'
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
install -Dm644 $srcdir/fontconfig.hook $pkgdir/usr/share/libalpm/hooks/fontconfig.hook
install -Dm644 COPYING $pkgdir/usr/share/licenses/fontconfig/COPYING
}
