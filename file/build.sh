pkgname=('file')
pkgver=5.38
pkgrel=3
pkgdesc='File type identification utility'
url='https://www.darwinsys.com/file/'
license=('custom')
arch=('x86_64')
groups=('base-devel')
depends=(
'bzip2'
'glibc'
'libseccomp'
'xz'
'zlib'
)
source=(
"ftp://ftp.astron.com/pub/$pkgname/$pkgname-$pkgver.tar.gz"
"ftp://ftp.astron.com/pub/$pkgname/$pkgname-$pkgver.tar.gz.asc"
'file-5.38-seccomp-tcgets.patch'
'0001-Revert-Don-t-depend-on-the-execute-bit-to-determine-.patch'
)
sha256sums=(
'593c2ffc2ab349c5aea0f55fedfe4d681737b6b62376a9b3ad1e77b2cc19fa34'
'SKIP'
'da6197e89ca53bd4f0d9009fa3a18c6fdb66dc07eb92e6bd77207eadb4548cfe'
'5636b444d147d6598c3defd0ce0a9b28056f2f64b09ef7f032337ed0308b8490'
)
prepare() {
cd $pkgname-$pkgver
patch -p1 -i $srcdir/file-5.38-seccomp-tcgets.patch
patch -p1 -i $srcdir/0001-Revert-Don-t-depend-on-the-execute-bit-to-determine-.patch
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
	'--datadir=/usr/share/file'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--enable-elf'
	'--enable-elf-core'
	'--enable-fsect-man5'
	'--enable-bzlib'
	'--enable-libseccomp'
	'--enable-xzlib'
	'--enable-zlib'
)
export CFLAGS+=' -pthread'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/file/COPYING
}
