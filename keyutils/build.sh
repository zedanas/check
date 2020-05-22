pkgname=('keyutils')
pkgver=1.6.1
pkgrel=3
pkgdesc='Linux Key Management Utilities'
url='https://www.kernel.org/'
license=('GPL2' 'LGPL2.1')
arch=('x86_64')
depends=(
'glibc'
'sh'
)
makedepends=('git')
backup=('etc/request-key.conf')
options=('emptydirs')
source=(
'request-key.conf.patch'
'reproducible.patch'
)
sha256sums=(
'SKIP'
'203c602c61ed94ccd423a0a453d74143d678c641a9a4486367576ee8af2cb8d6'
'7bb7400b2b8c8f0288c86ec9191f8964a1e682745a204013d5fc7c2e1a253d8e'
)
prepare() {
cd $pkgname
patch -Np0 -i $srcdir/request-key.conf.patch
patch -Np1 -i $srcdir/reproducible.patch
}
build() {
cd $pkgname
make CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}
package() {
cd $pkgname
make DESTDIR=$pkgdir SBINDIR=/usr/bin BINDIR=/usr/bin LIBDIR=/usr/lib USRLIBDIR=/usr/lib install
}
