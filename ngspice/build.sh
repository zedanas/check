pkgname=('ngspice')
pkgver=31
pkgrel=1
pkgdesc='Mixed-level/Mixed-signal circuit simulator based on Spice3f5, Ciber1b1, and Xspice.'
url='http://ngspice.sourceforge.net'
license=('BSD')
arch=('x86_64')
depends=(
'gcc-libs'
'glibc'
'libx11'
'libxaw'
'libxt'
'ncurses'
'readline'
)
source=(
"https://downloads.sourceforge.net/project/$pkgname/ng-spice-rework/$pkgver/$pkgname-$pkgver.tar.gz"
"http://ngspice.sourceforge.net/docs/$pkgname-$pkgver-manual.pdf"
)
sha1sums=(
'ab22e791cd254dfda2b32a262f212bd1d8c66fe7'
'ffa4bd6fe72469b20bc873733b72633dcbd431c0'
)
prepare() {
cd $pkgname-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cp -r $pkgname-$pkgver $pkgname-$pkgver-lib
config_opts=(
	'--prefix=/usr'
	'--bindir=/usr/bin'
	'--sbindir=/usr/bin'
	'--libdir=/usr/lib'
	'--libexecdir=/usr/lib'
	'--mandir=/usr/share/man'
	'--infodir=/usr/share/info'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--disable-debug'
	'--disable-gprof'
	'--enable-oldapps'
	'--enable-openmp'
	'--enable-predictor'
	'--enable-newtrunc'
	'--enable-experimental'
	'--enable-xspice'
	'--enable-cider'
	'--enable-pss'
	'--enable-ndev'
	'--enable-nodelimiting'
	'--enable-smoketest'
	'--disable-sense2'
	'--disable-nobypass'
	'--disable-capbypass'
	'--with-x'
	'--disable-adms'
	'--with-fftw3=no'
	'--with-editline=no'
	'--with-readline=yes'
)
cd $srcdir/$pkgname-$pkgver-lib
./configure "${config_opts[@]}" '--with-ngshared'
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
cd $srcdir/$pkgname-$pkgver
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $srcdir/$pkgname-$pkgver-lib
make DESTDIR=$pkgdir install
cd $srcdir/$pkgname-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/$pkgname-$pkgver-manual.pdf \
$pkgdir/usr/share/doc/ngspice/manual.pdf
install -Dm644 COPYING $pkgdir/usr/share/licenses/ngspice/LICENSE
}
