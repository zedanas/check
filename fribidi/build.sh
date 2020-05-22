pkgname=('fribidi')
pkgver=1.0.9
pkgrel=1
pkgdesc='A Free Implementation of the Unicode Bidirectional Algorithm'
url='https://github.com/fribidi/fribidi/'
license=('LGPL')
arch=('x86_64')
depends=('glibc')
makedepends=(
'git'
'meson'
)
provides=('libfribidi.so')
_commit='f9e8e71a6fbf4a4619481284c9f484d10e559995'
sha256sums=('SKIP')
build() {
cd $pkgname
config_opts=(
	'-Ddeprecated=false'
	'-Ddocs=false'
)
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd $pkgname
ninja -C build test
}
package() {
cd $pkgname
DESTDIR=$pkgdir ninja -C build install
}
