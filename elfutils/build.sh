pkgbase='elfutils'
pkgname=('elfutils' 'libelf')
pkgver=0.178
pkgrel=2
url='https://sourceware.org/elfutils/'
license=('LGPL3' 'GPL' 'GPL3')
arch=('x86_64')
makedepends=(
'bzip2'
'curl'
'gcc-libs'
'glibc'
'libarchive'
'libmicrohttpd'
'sh'
'sqlite'
'xz'
'zlib'
)
options=('staticlibs')
source=(
"ftp://sourceware.org/pub/$pkgbase/$pkgver/$pkgbase-$pkgver.tar.bz2"
"ftp://sourceware.org/pub/$pkgbase/$pkgver/$pkgbase-$pkgver.tar.bz2.sig"
)
sha1sums=(
'5f52d04105a89e50caf69cea40629c323c1eccd9'
'SKIP'
)
prepare() {
cd $pkgbase-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgbase-$pkgver
config_opts=(
	'--prefix=/usr'
	'--bindir=/usr/bin'
	'--sbindir=/usr/bin'
	'--libdir=/usr/lib'
	'--libexecdir=/usr/lib'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--program-prefix=eu-'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--enable-thread-safety'
	'--enable-deterministic-archives'
	'--enable-symbol-versioning'
	'--with-bzlib'
	'--disable-debuginfod'
	'--with-lzma'
	'--with-zlib'
)
export CFLAGS+=' -fno-lto -Wno-error'
export CXXFLAGS="${CFLAGS}"
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgbase-$pkgver
make -k check
}
package_elfutils() {
pkgdesc='Utilities to handle ELF object files and DWARF debugging information'
depends=(
	"libelf=$pkgver-$pkgrel"
	'gcc-libs'
	'glibc'
	'sh'
)
cd $pkgbase-$pkgver
make DESTDIR=$pkgdir install
cd $pkgdir
mkdir -p $srcdir/libelf/usr
mv $pkgdir/usr/{lib,include} $srcdir/libelf/usr || true
}
package_libelf() {
pkgdesc='Libraries to handle ELF object files and DWARF debugging information'
depends=(
	'bzip2'
	'glibc'
	'xz'
	'zlib'
)
mv $srcdir/libelf/* $pkgdir
}
