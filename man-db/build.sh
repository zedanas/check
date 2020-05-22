pkgname=('man-db')
pkgver=2.9.1
pkgrel=2
pkgdesc='A utility for reading man pages'
url='https://www.nongnu.org/man-db/'
license=('GPL' 'LGPL')
arch=('x86_64')
groups=('base')
depends=(
'bash'
'gdbm'
'glibc'
'groff'
'less'
'libpipeline'
'libseccomp'
'zlib'
)
makedepends=('po4a')
optdepends=('gzip')
provides=('man')
conflicts=('man')
replaces=('man')
backup=('etc/man_db.conf')
install='man-db.install'
source=(
"https://savannah.nongnu.org/download/$pkgname/$pkgname-$pkgver.tar.xz"
"https://savannah.nongnu.org/download/$pkgname/$pkgname-$pkgver.tar.xz.asc"
'snapdir.diff'
'convert-mans'
)
sha512sums=(
'ae2d1e9f293795c63f5a9a1a765478a9a59cbe5fe6f759647be5057c1ae53f90baee8d5467921f3d0102300f2111a5026eeb25f78401bcb16ce45ad790634977'
'SKIP'
'f24a8152c82c3b99dab2c34654382512f226bb6b0e5e3b1376d577019a4cca0f4e5a9ac92c62ed7ea5cf0ed3ad94509d34f455d845bc5fb026ef908da82cd5fe'
'0b159285da20008f0fc0afb21f1eaebd39e8df5b0594880aa0e8a913b656608b8d16bb8d279d9e62d7aae52f62cb9b2fc49e237c6711f4a5170972b38d345535'
)
prepare() {
cd $pkgname-$pkgver
patch -Np0 -i $srcdir/snapdir.diff
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
	'--disable-setuid'
	'--disable-cats'
	'--enable-manual'
	'--enable-mb-groff'
	'--enable-automatic-create'
	'--enable-cache-owner=root'
	'--enable-mandirs=GNU'
	'--enable-threads=posix'
	'--without-included-regex'
	'--with-db=gdbm'
	'--with-libseccomp'
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
cd $pkgdir
install -Dm755 $srcdir/convert-mans usr/bin/convert-mans
install -dm755 usr/lib/systemd/system/timers.target.wants
ln -s ../man-db.timer usr/lib/systemd/system/timers.target.wants/man-db.timer
}
