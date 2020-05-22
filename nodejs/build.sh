pkgname=('nodejs')
pkgver=13.12.0
pkgrel=1
pkgdesc='Evented I/O for V8 javascript'
url='https://nodejs.org/'
license=('MIT')
arch=('x86_64')
depends=(
'c-ares'
'gcc-libs'
'glibc'
'icu'
'libnghttp2'
'libuv'
'openssl'
'zlib'
)
makedepends=(
'procps-ng'
'python2'
)
optdepends=('npm: nodejs package manager')
source=("nodejs-$pkgver.tar.gz::https://github.com/$pkgname/node/archive/v$pkgver.tar.gz")
sha512sums=('678da673eebcb02c54388f09175dd2f5b2c3cb22bce83b6b97a61fc78088d8e667b8f12b56e78a9d5231cbd7a6faf0b48929ba4318be974a25a34224e9a190f8')
build() {
cd node-$pkgver
config_opts=(
	'--prefix=/usr'
	'--enable-lto'
	'--dest-os=linux'
	'--dest-cpu=x86_64'
	'--without-npm'
	'--experimental-http-parser'
	'--shared-cares'
	'--with-intl=system-icu'
	'--without-intl'
	'--shared-nghttp2'
	'--shared-libuv'
	'--shared-openssl'
	'--shared-zlib'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd node-$pkgver
make -k check
}
package() {
cd node-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 LICENSE $pkgdir/usr/share/licenses/nodejs/LICENSE
}
