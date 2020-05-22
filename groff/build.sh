pkgname=('groff')
pkgver=1.22.4
pkgrel=3
pkgdesc='GNU troff text-formatting system'
url='https://www.gnu.org/software/groff/groff.html'
license=('GPL')
arch=('x86_64')
groups=('base-devel')
depends=(
'bash'
'gcc-libs'
'glibc'
'perl'
'libx11'
'libxaw'
'libxmu'
'libxt'
)
makedepends=(
'netpbm'
'psutils'
)
optdepends=(
'netpbm: for use together with man -H command interaction in browsers'
'psutils: for use together with man -H command interaction in browsers'
)
source=(
"ftp://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.gz"
"ftp://ftp.gnu.org/gnu/$pkgname/$pkgname-$pkgver.tar.gz.sig"
'site.tmac'
)
sha256sums=(
'e78e7b4cb7dec310849004fa88847c44701e8d133b5d4c13057d876c1bad0293'
'SKIP'
'af59ecde597ce9f8189368a7739279a5f8a391139fe048ef6b4e493ed46e5f5f'
)
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
	'--without-uchardet'
	'--with-doc=no'
	'--with-compatibility-wrappers=check'
	'--with-x'
	'--with-appresdir=/usr/share/X11/app-defaults'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname-$pkgver
make -k check
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
ln -s eqn $pkgdir/usr/bin/geqn
ln -s tbl $pkgdir/usr/bin/gtbl
ln -s soelim $pkgdir/usr/bin/zsoelim
cp $srcdir/site.tmac $pkgdir/usr/share/groff/site-tmac/man.local
cp $srcdir/site.tmac $pkgdir/usr/share/groff/site-tmac/mdoc.local
}
