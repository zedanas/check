pkgname=('pciutils')
pkgver=3.6.4
pkgrel=1
pkgdesc='PCI bus configuration space access library and tools'
url='https://mj.ucw.cz/sw/pciutils/'
license=('GPL2')
arch=('x86_64')
groups=('base')
depends=(
'glibc'
'hwids'
'kmod'
'sh'
'systemd-libs'
'zlib'
)
makedepends=('git')
md5sums=('SKIP')
build() {
cd $pkgname
config_opts=(
	"OPT=$CFLAGS -fPIC -DPIC"
	'DNS=yes'
	'ZLIB=yes'
	'HWDB=yes'
	'LIBKMOD=yes'
)
make "${config_opts[@]}" SHARED=no lib/libpci.a
cp lib/libpci.a $srcdir/
make clean && make "${config_opts[@]}" SHARED=yes all
}
package() {
cd $pkgname
make PREFIX=/usr SBINDIR=/usr/bin DESTDIR=$pkgdir SHARED=yes install install-lib
install -Dm644 COPYING $pkgdir/usr/share/licenses/pciutils/LICENSE
rm $pkgdir/usr/share/pci.ids.gz
}
