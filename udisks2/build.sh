pkgname='udisks2'
pkgver=2.8.4
pkgrel=2
pkgdesc='Disk Management Service, version 2'
url='https://www.freedesktop.org/wiki/Software/udisks'
license=('GPL2')
arch=('x86_64')
depends=(
'acl'
'glib2'
'glibc'
'libatasmart'
'libblockdev'
'libgudev'
'libutil-linux'
'polkit'
'systemd-libs'
)
makedepends=(
'docbook-xsl'
'gobject-introspection'
'parted'
'gtk-doc'
)
optdepends=(
'gptfdisk: GUID partition table support'
'ntfs-3g: NTFS filesystem management support'
'dosfstools: VFAT filesystem management support'
)
backup=('etc/udisks2/udisks2.conf')
source=("https://github.com/storaged-project/udisks/archive/udisks-$pkgver.tar.gz")
sha512sums=('6a002f45e9713e891f8944138541db13665b8dad76a84bcd7449a4aa3a966dfb45cf8629812dec1827ce2ea8790b3eafa235cca4a00ceac2430c8cadfa25ec49')
prepare() {
cd udisks-udisks-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd udisks-udisks-$pkgver
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
	'--enable-man'
	'--enable-gtk-doc'
	'--enable-debug=no'
	'--enable-introspection=no'
	'--enable-fhs-media'
	'--enable-bcache'
	'--enable-btrfs'
	'--enable-zram'
	'--disable-lvm2'
	'--disable-lvmcache'
	'--disable-vdo'
	'--with-systemdsystemunitdir=/usr/lib/systemd/system'
	'--enable-acl'
	'--disable-iscsi'
	'--disable-lsm'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd udisks-udisks-$pkgver
make -k check
}
package() {
cd udisks-udisks-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/udisks2/LICENSE
}
