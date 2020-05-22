pkgbase='p11-kit'
pkgname=('p11-kit' 'libp11-kit')
pkgver=0.23.20
pkgrel=3
url='https://p11-glue.freedesktop.org'
license=('BSD')
arch=('x86_64')
makedepends=(
'git'
'gtk-doc'
'libffi'
'libtasn1'
'meson'
'systemd'
)
sha256sums=('SKIP')
build() {
cd $pkgname
config_opts=(
	'-Dstrict=false'
	'-Dman=true'
	'-Dgtk_doc=true'
	'-Dtrust_module=enabled'
	'-Dmodule_path=/usr/lib/pkcs11'
	'-Dtrust_paths=/etc/ca-certificates/trust-source:/usr/share/ca-certificates/trust-source'
	'-Dlibffi=enabled'
	'-Dhash_impl=internal'
	'-Dsystemd=enabled'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd $pkgname-stable
ninja -C build test
}
package_p11-kit() {
depends=(
	"libp11-kit=$pkgver-$pkgrel"
	'glibc'
	'libsystemd.so'
	'libtasn1'
)
install='p11-kit.install'
cd $pkgname
DESTDIR=$pkgdir ninja -C build install
install -Dm644 COPYING $pkgdir/usr/share/licenses/p11-kit/LICENSE
ln -srf $pkgdir/usr/bin/update-ca-trust $pkgdir/usr/lib/p11-kit/trust-extract-compat
cd $pkgdir
mkdir -p $srcdir/libp11-kit/usr/{lib,share}
mv usr/include $srcdir/libp11-kit/usr || true
mv usr/lib/{p11-kit-proxy.so,libp11-kit.*} $srcdir/libp11-kit/usr/lib || true
mv usr/lib/{pkcs11,pkgconfig} $srcdir/libp11-kit/usr/lib || true
mv usr/share/{locale,p11-kit} $srcdir/libp11-kit/usr/share || true
}
package_libp11-kit() {
depends=(
	'glibc'
	'libffi'
	'libtasn1'
)
provides=('libp11-kit.so')
mv $srcdir/libp11-kit/* $pkgdir
}
