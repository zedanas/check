pkgname=('sysstat')
pkgver=12.3.1
pkgrel=1
pkgdesc='A collection of performance monitoring tools (iostat,isag,mpstat,pidstat,sadf,sar)'
url='http://pagesperso-orange.fr/sebastien.godard/'
license=('GPL')
arch=('x86_64')
depends=(
'glibc'
'lm_sensors'
'sh'
)
makedepends=('systemd')
optdepends=(
'tk: to use isag'
'gnuplot: to use isag'
)
backup=(
'etc/conf.d/sysstat'
'etc/conf.d/sysstat.ioconf'
)
options=('emptydirs')
source=(
"http://pagesperso-orange.fr/sebastien.godard/$pkgname-$pkgver.tar.xz"
'lib64-fix.patch'
)
sha512sums=(
'81bb33da68f132a08ece0f162e9bd40406d9663b83b4830fe3495016af84d24bbe3b938a1ddde522a7e1d44a9bc45b71f6c32b6725de0822c76bec538ba55bf7'
'46ec3eebb12232d30cddba60f16a57cd8d625513cf002d9e501797a6660f9da9cb4116ec81d0c292644fb6d91eb05c7be458da667260b238bcfef532a020b114'
)
prepare() {
cd $pkgname-$pkgver
patch -p1 -i $srcdir/lib64-fix.patch
sed -e 's|SYSCONFIG_DIR=/etc/sysconfig|SYSCONFIG_DIR=/etc/conf.d|g' -i configure.in
sed -e "s/LFLAGS =/LFLAGS =$LDFLAGS /g" -i Makefile.in
autoreconf -fi
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
	'--disable-debuginfo'
	'--enable-stripping'
	'--enable-documentation'
	'--enable-compress-manpg'
	'--enable-file-attr'
	'--enable-collect-all'
	'--enable-install-cron'
	'--enable-copy-only'
	'--enable-sensors'
	'--disable-pcp'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/sysstat/LICENSE
}
