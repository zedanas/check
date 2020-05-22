pkgname=('e2fsprogs')
pkgver=1.45.6
pkgrel=1
pkgdesc='Ext2/3/4 filesystem utilities'
url='http://e2fsprogs.sourceforge.net'
license=('GPL' 'LGPL' 'MIT')
arch=('x86_64')
groups=('base')
depends=(
'glibc'
'libutil-linux'
'sh'
)
makedepends=('util-linux')
backup=(
'etc/e2fsck.conf'
'etc/mke2fs.conf'
)
options=('emptydirs')
source=(
"https://www.kernel.org/pub/linux/kernel/people/tytso/$pkgname/v${pkgver}/$pkgname-$pkgver.tar.xz"
"https://www.kernel.org/pub/linux/kernel/people/tytso/$pkgname/v${pkgver}/$pkgname-$pkgver.tar.sign"
'MIT-LICENSE'
)
sha256sums=(
'ffa7ae6954395abdc50d0f8605d8be84736465afc53b8938ef473fcf7ff44256'
'SKIP'
'cc45386c1d71f438ad648fd7971e49e3074ad9dbacf9dd3a5b4cb61fd294ecbb'
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
	'--disable-profile'
	'--disable-backtrace'
	'--disable-jbd-debug'
	'--disable-blkid-debug'
	'--disable-testio-debug'
	'--enable-elf-shlibs'
	'--disable-libuuid'
	'--disable-libblkid'
	'--disable-uuidd'
	'--disable-fsck'
	'--enable-e2initrd-helper'
	'--enable-tls'
	'--enable-tdb'
	'--enable-mmp'
	'--enable-lto'
	'--enable-debugfs'
	'--enable-imager'
	'--enable-resizer'
	'--enable-defrag'
	'--enable-bmap-stats'
	'--enable-bmap-stats-ops'
	'--enable-threads=posix'
	'--with-root-prefix=""'
	'--disable-fuse2fs'
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
make DESTDIR=$pkgdir install-libs
install -Dm644 ../MIT-LICENSE $pkgdir/usr/share/licenses/e2fsprogs/MIT-LICENSE
mkdir -p $pkgdir/etc
echo '[options]' >> $pkgdir/etc/e2fsck.conf
echo 'max_count_problems = 16' >> $pkgdir/etc/e2fsck.conf
echo 'log_dir = /var/log/e2fsck' >> $pkgdir/etc/e2fsck.conf
echo 'log_filename = e2fsck-%N.%h.INFO.%D-%T' >> $pkgdir/etc/e2fsck.conf
echo 'log_dir_wait = true' >> $pkgdir/etc/e2fsck.conf
mkdir -p $pkgdir/var/log/e2fsck
}
