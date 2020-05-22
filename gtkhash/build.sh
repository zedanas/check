pkgbase='gtkhash'
pkgname=('gtkhash' 'gtkhash-nemo' 'gtkhash-nautilus' 'gtkhash-thunar' 'gtkhash-caja')
pkgver=1.2
pkgrel=1
url='http://gtkhash.sourceforge.net/'
license=('GPL')
arch=('x86_64')
makedepends=(
'caja'
'intltool'
'libnautilus-extension'
'librsvg'
'mhash'
'nemo'
'peony'
'thunar'
)
source=("https://github.com/tristanheaven/$pkgbase/releases/download/v$pkgver/$pkgbase-$pkgver.tar.xz")
sha256sums=('bd870bac6e14babfb6268b617a42e4bcd776559dd80dd62ad9f7cc28b773b8b2')
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
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--disable-schemas-compile'
	'--disable-debug'
	'--enable-gtkhash'
	'--enable-appstream'
	'--enable-internal-md6'
	'--enable-glib-checksums'
	'--enable-linux-crypto'
	'--enable-caja'
	'--with-gtk=3.0'
	'--disable-blake2'
	'--enable-gcrypt'
	'--enable-nautilus'
	'--disable-mbedtls'
	'--disable-mhash'
	'--enable-nemo'
	'--enable-nettle'
	'--enable-libcrypto'
	'--disable-peony'
	'--enable-thunar'
	'--with-thunarx=3'
	'--enable-zlib'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package_gtkhash() {
pkgdesc='A GTK+ utility for computing message digests or checksums'
depends=(
	'glib2'
	'glibc'
	'gtk3'
	'libgcrypt'
	'nettle'
	'openssl'
	'zlib'
)
cd $pkgbase-$pkgver
make DESTDIR=$pkgdir install
cd $pkgdir
mkdir -p $srcdir/gtkhash-nemo/usr/{lib,share/appdata}
mv usr/lib/nemo/ $srcdir/gtkhash-nemo/usr/lib || true
mv usr/share/appdata/nemo-* $srcdir/gtkhash-nemo/usr/share/appdata || true
mkdir -p $srcdir/gtkhash-nautilus/usr/{lib,share/appdata}
mv usr/lib/nautilus $srcdir/gtkhash-nautilus/usr/lib || true
mv usr/share/appdata/nautilus-* $srcdir/gtkhash-nautilus/usr/share/appdata || true
mkdir -p $srcdir/gtkhash-thunar/usr/{lib,share/appdata}
mv usr/lib/thunarx-3 $srcdir/gtkhash-thunar/usr/lib || true
mv usr/share/appdata/thunar-* $srcdir/gtkhash-thunar/usr/share/appdata || true
mkdir -p $srcdir/gtkhash-caja/usr/{lib,share/appdata}
mv usr/lib/caja $srcdir/gtkhash-caja/usr/lib || true
mv usr/share/appdata/caja-* $srcdir/gtkhash-caja/usr/share/appdata || true
rm -fr usr/lib
}
package_gtkhash-nemo() {
pkgdesc='A GTK+ utility for computing message digests or checksums (Nemo filemanager plugin)'
depends=(
	'glib2'
	'glibc'
	'gtk3'
	'gtkhash'
	'libgcrypt'
	'nemo'
	'nettle'
	'openssl'
	'zlib'
)
mv $srcdir/gtkhash-nemo/* $pkgdir
}
package_gtkhash-nautilus() {
pkgdesc='A GTK+ utility for computing message digests or checksums (Nautilus filemanager plugin)'
depends=(
	'glib2'
	'glibc'
	'gtk3'
	'gtkhash'
	'libgcrypt'
	'libnautilus-extension'
	'nettle'
	'openssl'
	'zlib'
)
mv $srcdir/gtkhash-nautilus/* $pkgdir
}
package_gtkhash-thunar() {
pkgdesc='A GTK+ utility for computing message digests or checksums (Thunar filemanager plugin)'
depends=(
	'glib2'
	'glibc'
	'gtk3'
	'gtkhash'
	'libgcrypt'
	'nettle'
	'openssl'
	'thunar'
	'zlib'
)
mv $srcdir/gtkhash-thunar/* $pkgdir
}
package_gtkhash-caja() {
pkgdesc='A GTK+ utility for computing message digests or checksums (Caja filemanager plugin)'
depends=(
	'caja'
	'glib2'
	'glibc'
	'gtk3'
	'gtkhash'
	'libgcrypt'
	'nettle'
	'openssl'
	'zlib'
)
mv $srcdir/gtkhash-caja/* $pkgdir
}
