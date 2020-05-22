pkgname='libblockdev'
pkgver=2.23
pkgrel=3
pkgdesc='A library for manipulating block devices'
url='https://github.com/rhinstaller/libblockdev'
license=('LGPL')
arch=('x86_64')
depends=(
'cryptsetup'
'device-mapper'
'glib2'
'glibc'
'kmod'
'libbytesize'
'libutil-linux'
'nss'
'parted'
'systemd-libs'
'volume_key'
)
makedepends=(
'autoconf-archive'
'gobject-introspection'
'gtk-doc'
'python'
'python2'
'systemd'
)
source=("$pkgname-$pkgver.tar.gz::https://github.com/rhinstaller/$pkgname/archive/$pkgver-1.tar.gz")
sha512sums=('e1e9976d24bdd8775310c9b25c31eb3b0e2d06a295b75f0c281def694104664f42abbbec307fbeb7c960ba5059299d0da66aa7afb26850c3640a8e73ea777aaf')
prepare() {
cd $pkgname-$pkgver-1
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname-$pkgver-1
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
	'--disable-tests'
	'--enable-debug=no'
	'--enable-introspection=no'
	'--with-gtk-doc'
	'--with-bcache'
	'--with-loop'
	'--with-swap'
	'--with-crypto'
	'--with-escrow'
	'--with-dm'
	'--without-lvm'
	'--without-lvm_dbus'
	'--without-mpath'
	'--without-dmraid'
	'--with-tools'
	'--with-btrfs'
	'--with-mdraid'
	'--with-kbd'
	'--without-vdo'
	'--without-nvdimm'
	'--with-part'
	'--with-fs'
	'--without-python3'
	'--without-python2'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname-$pkgver-1
make -k check
}
package() {
cd $pkgname-$pkgver-1
make DESTDIR=$pkgdir install
install -Dm644 LICENSE $pkgdir/usr/share/licenses/libblockdev/LICENSE
}
