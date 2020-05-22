pkgname=('strace')
pkgver=5.5
pkgrel=1
pkgdesc='A diagnostic, debugging and instructional userspace tracer'
url='https://strace.io/'
license=('BSD')
arch=('x86_64')
depends=(
'glibc'
'libelf'
'perl'
'sh'
)
source=(
"https://github.com/$pkgname/$pkgname/releases/download/v$pkgver/$pkgname-$pkgver.tar.xz"
"https://github.com/$pkgname/$pkgname/releases/download/v$pkgver/$pkgname-$pkgver.tar.xz.asc"
)
sha1sums=(
'ebacd8fb078aabc2e4a856657bac299589641d28'
'SKIP'
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
	'--enable-mpers=yes'
	'--enable-stacktrace=yes'
	'--with-libdw'
	'--with-libiberty'
	'--without-libunwind'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/strace/LICENSE
}
