pkgname=('thunar-archive-plugin')
pkgver=0.4.0
pkgrel=2
pkgdesc='Create and extract archives in Thunar'
url='https://goodies.xfce.org/projects/thunar-plugins/thunar-archive-plugin'
license=('GPL2')
arch=('x86_64')
groups=('xfce4-goodies')
depends=(
'bash'
'glib2'
'glibc'
'gtk3'
'hicolor-icon-theme'
'thunar'
)
makedepends=(
'intltool'
'xfce4-dev-tools'
)
optdepends=(
'file-roller'
'ark'
'xarchiver'
)
source=("https://archive.xfce.org/src/thunar-plugins/$pkgname/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('bf82fa86a388124eb3c4854249c30712b2922e61789607268ee14548549b3115')
prepare() {
cd $pkgname-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 xdt-autogen
fi
}
build() {
cd $pkgname-$pkgver
config_opts=(
	'--prefix=/usr'
	'--bindir=/usr/bin'
	'--sbindir=/usr/bin'
	'--libdir=/usr/lib'
	'--libexecdir=/usr/lib/xfce4'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--disable-debug'
	'--enable-debug=no'
	'--enable-linker-opts'
)
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
