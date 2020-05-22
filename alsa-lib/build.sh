pkgname=('alsa-lib')
pkgver=1.2.2
pkgrel=1
pkgdesc='An alternative implementation of Linux sound support'
url='https://www.alsa-project.org'
license=('LGPL2.1')
arch=('x86_64')
depends=(
'glibc'
)
makedepends=('python2')
optdepends=('python2: for python smixer plugin')
provides=(
'libasound.so'
'libatopology.so'
)
source=("https://www.alsa-project.org/files/pub/lib/$pkgname-$pkgver.tar.bz2")
sha512sums=('d21adb3ff998918c7d1820f9ce2aaf4202dd45ccb87cb092d49da8b2402b6ddaad06325be0fd59f17393a5d9958e3743bfccb4b14bdb947a42e7d791d73c7033')
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
	'--disable-old-symbols'
	'--enable-mixer'
	'--enable-pcm'
	'--enable-rawmidi'
	'--enable-hwdep'
	'--enable-seq'
	'--enable-ucm'
	'--enable-topology'
	'--enable-old-symbols'
	'--enable-thread-safety'
	'--without-debug'
	'--without-wordexp'
	'--with-versioned'
	'--with-libdl'
	'--with-pthread'
	'--with-librt'
	'--with-pcm-plugins=all'
	'--with-ctl-plugins=all'
	'--disable-python'
	'--disable-python2'
)
export CFLAGS+=' -fno-lto'
export CXXFLAGS="${CFLAGS}"
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
}
