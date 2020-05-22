pkgname=('xfce4-cpugraph-plugin')
pkgver=1.1.0
pkgrel=1
pkgdesc='CPU graph plugin for the Xfce4 panel'
url='https://goodies.xfce.org/projects/panel-plugins/xfce4-cpugraph-plugin'
license=('GPL' 'custom')
arch=('x86_64')
groups=('xfce4-goodies')
depends=(
'cairo'
'glib2'
'glibc'
'gtk3'
'libxfce4ui'
'libxfce4util'
'xfce4-panel'
)
makedepends=('intltool')
source=("https://archive.xfce.org/src/panel-plugins/$pkgnamen/${pkgver%.*}/$pkgname-$pkgver.tar.bz2")
sha256sums=('3ece0a24e55827e0d9b6314129906da60513acdc1748d9dece9f50526e906ba4')
prepare() {
cd $pkgname-$pkgver
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
	'--libexecdir=/usr/lib'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--disable-debug'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/xfce4-cpugraph-plugin/LICENSE
}
