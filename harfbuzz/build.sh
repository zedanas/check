pkgbase='harfbuzz'
pkgname=('harfbuzz' 'harfbuzz-icu')
pkgver=2.6.4
pkgrel=2
url='https://www.freedesktop.org/wiki/Software/HarfBuzz'
license=('MIT')
arch=('x86_64')
makedepends=(
'cairo'
'git'
'gobject-introspection'
'gtk-doc'
'icu'
'python'
'ragel'
)
checkdepends=(
'python-fonttools'
'python-setuptools'
)
_commit='3a74ee528255cc027d84b204a87b5c25e47bff79'
sha256sums=('SKIP')
prepare() {
cd $pkgbase
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgbase
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
	'--disable-gtk-doc'
	'--enable-introspection=no'
	'--with-ucdn=yes'
	'--with-gobject=yes'
	'--with-fontconfig=yes'
	'--with-cairo=yes'
	'--with-freetype=yes'
	'--with-libstdc++=yes'
	'--with-glib=yes'
	'--with-graphite2=yes'
	'--with-icu=yes'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgbase
make -k check
}
package_harfbuzz() {
pkgdesc='OpenType text shaping engine'
depends=(
	'cairo'
	'freetype2'
	'gcc-libs'
	'glib2'
	'glibc'
	'graphite'
)
cd $pkgbase
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/harfbuzz/COPYING
cd $pkgdir
mkdir -p $srcdir/harfbuzz-icu/usr/{include/harfbuzz,lib/pkgconfig}
mv usr/lib/libharfbuzz-icu* $srcdir/harfbuzz-icu/usr/lib || true
mv usr/lib/pkgconfig/harfbuzz-icu.pc $srcdir/harfbuzz-icu/usr/lib/pkgconfig || true
mv usr/include/harfbuzz/hb-icu.h $srcdir/harfbuzz-icu/usr/include/harfbuzz || true
}
package_harfbuzz-icu() {
pkgdesc="OpenType text shaping engine (ICU integration)"
depends=(
	'glibc'
	'harfbuzz'
	'icu'
)
mv $srcdir/harfbuzz-icu/* $pkgdir
install -Dm644 $srcdir/$pkgbase/COPYING $pkgdir/usr/share/licenses/harfbuzz-icu/COPYING
}
