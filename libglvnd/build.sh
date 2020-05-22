pkgname=('libglvnd')
pkgver=1.3.1
pkgrel=1
pkgdesc='The GL Vendor-Neutral Dispatch library'
url='https://github.com/NVIDIA/libglvnd'
license=('custom:BSD-like')
arch=('x86_64')
depends=(
'glibc'
'libx11'
)
makedepends=(
'libxext'
'meson'
'python'
'xorgproto'
)
provides=(
'libegl'
'libgl'
'libgles'
)
source=(
"$pkgname-$pkgver.tar.gz::https://gitlab.freedesktop.org/glvnd/$pkgname/-/archive/v${pkgver}/$pkgname-v${pkgver}.tar.gz"
'LICENSE'
)
sha512sums=(
'f10b24ea983ee27813b7b64f13419d309479e34f3a1e4304f57ed01732d66df8d9d2c1e4f76577fc0827305d1b0a2fcea18445ce2953641f1d8452aa65b22e14'
'bf0f4a7e04220a407400f89226ecc1f798cc43035f2538cc8860e5088e1f84140baf0d4b0b28f66e4b802d4d6925769a1297c24e1ba39c1c093902b2931781a5'
)
prepare() {
cd $pkgname-v$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname-v$pkgver
config_opts=(
	'-Dasm=enabled'
	'-Dtls=enabled'
	'-Degl=true'
	'-Dglx=enabled'
	'-Dgles1=true'
	'-Dgles2=true'
	'-Dheaders=true'
	'-Dx11=enabled'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
package() {
cd $pkgname-v$pkgver
DESTDIR=$pkgdir ninja -C build install
install -Dm644 ../LICENSE $pkgdir/usr/share/licenses/libglvnd/COPYING
}
