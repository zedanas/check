pkgname='freetype2'
pkgver=2.10.1
pkgrel=2
pkgdesc='Font rasterization library'
url='https://www.freetype.org/'
license=('GPL')
arch=('x86_64')
depends=(
'bzip2'
'glibc'
'harfbuzz'
'libpng'
'sh'
'zlib'
)
makedepends=('libx11')
provides=('libfreetype.so')
backup=('etc/profile.d/freetype2.sh')
install='freetype2.install'
source=(
"https://download-mirror.savannah.gnu.org/releases/freetype/freetype-$pkgver.tar.xz"
"https://download-mirror.savannah.gnu.org/releases/freetype/freetype-$pkgver.tar.xz.sig"
'0001-Enable-table-validation-modules.patch'
'0002-Enable-infinality-subpixel-hinting.patch'
'0003-Enable-long-PCF-family-names.patch'
'0004-Properly-handle-phantom-points-for-variation-fonts-5.patch'
'freetype2.sh'
)
sha1sums=(
'79874ef4eaa52025126b71d836453b8279bdd331'
'SKIP'
'77b68e06e417783ca57c7f8d73c67feb9e230a6e'
'67dc149d576cea17fe3eb9addcef19bb59b6d5be'
'3559f8bb0aadef51ecef2f93c33164109e12b549'
'aba1f28bbbf4ff94413096e3d55ac79071a210e2'
'bc6df1661c4c33e20f5ce30c2da8ad3c2083665f'
)
prepare() {
cd freetype-$pkgver
patch -Np1 -i $srcdir/0001-Enable-table-validation-modules.patch
patch -Np1 -i $srcdir/0002-Enable-infinality-subpixel-hinting.patch
patch -Np1 -i $srcdir/0003-Enable-long-PCF-family-names.patch
patch -Np1 -i $srcdir/0004-Properly-handle-phantom-points-for-variation-fonts-5.patch
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd freetype-$pkgver
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
	'--enable-freetype-config'
	'--with-bzip2=yes'
	'--with-harfbuzz=yes'
	'--with-png=yes'
	'--with-zlib=yes'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd freetype-$pkgver
make -k check
}
package() {
cd freetype-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/freetype2.sh $pkgdir/etc/profile.d/freetype2.sh
}
