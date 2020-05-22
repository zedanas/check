pkgname=('numactl')
pkgver=2.0.13
pkgrel=2
pkgdesc='Simple NUMA policy support'
url='http://oss.sgi.com/projects/libnuma/'
license=('LGPL2.1' 'GPL2')
arch=('x86_64')
depends=('glibc')
provides=('libnuma.so')
source=("https://github.com/$pkgname/$pkgname/releases/download/v${pkgver}/$pkgname-$pkgver.tar.gz")
sha512sums=('f7b747eb8f3ded9f3661cb0fc7b65b5ed490677f881f8fe6a000baf714747515853b4e5c8781b014241180bf16e9f0bfdf2c6f758725e34b4938696ba496b72a')
prepare() {
cd $pkgname-$pkgver
autoreconf -fi
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
)
export CFLAGS+=' -fno-lto'
export CXXFLAGS+="${CFLAGS}"
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname-$pkgver
make -k check
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
rm -rf $pkgdir/usr/share/man/man2
}
