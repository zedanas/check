pkgname=('libsndfile')
pkgver=1.0.28
pkgrel=3
pkgdesc='A C library for reading and writing files containing sampled sound'
url='http://www.mega-nerd.com/libsndfile'
license=('LGPL2.1')
arch=('x86_64')
depends=(
'alsa-lib'
'flac'
'glibc'
'libogg'
'libvorbis'
'sqlite'
)
checkdepends=('python2')
provides=('libsndfile.so')
source=(
"http://www.mega-nerd.com/$pkgname/files/$pkgname-$pkgver.tar.gz"
"http://www.mega-nerd.com/$pkgname/files/$pkgname-$pkgver.tar.gz.asc"
)
sha512sums=(
'890731a6b8173f714155ce05eaf6d991b31632c8ab207fbae860968861a107552df26fcf85602df2e7f65502c7256c1b41735e1122485a3a07ddb580aa83b57f'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
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
	'--enable-octave'
	'--enable-full-suite'
	'--enable-cpu-clip'
	'--enable-external-libs'
	'--enable-stack-smash-protection'
	'--enable-alsa'
	'--enable-sqlite'
)
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
}
