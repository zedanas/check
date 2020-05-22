pkgname=('libatasmart')
pkgver=0.19
pkgrel=4
pkgdesc='ATA S.M.A.R.T. Reading and Parsing Library'
url='http://0pointer.de/blog/projects/being-smart.html'
license=('LGPL')
arch=('x86_64')
depends=(
'glibc'
'systemd-libs'
)
makedepends=('systemd')
source=(
"http://0pointer.de/public/$pkgname-$pkgver.tar.xz"
'0001-Dont-test-undefined-bits.patch'
'0002-Drop-our-own-many-bad-sectors-heuristic.patch'
)
sha256sums=(
'61f0ea345f63d28ab2ff0dc352c22271661b66bf09642db3a4049ac9dbdb0f8d'
'ab19d6985bb524774607280a2ee62c48de01785660ff5206d80f778b6404188c'
'9bb5ca3431f76c182c5b076e2db9378d696608c2ff1d53d01e55c530ba293ce1'
)
prepare() {
cd $pkgname-$pkgver
patch -p1 -i $srcdir/0001-Dont-test-undefined-bits.patch
patch -p1 -i $srcdir/0002-Drop-our-own-many-bad-sectors-heuristic.patch
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
}
