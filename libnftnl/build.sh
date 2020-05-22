pkgname=('libnftnl')
pkgver=1.1.5
pkgrel=1
pkgdesc='Netfilter library providing interface to the nf_tables subsystem'
url='https://netfilter.org/projects/libnftnl/'
license=('GPL2')
arch=('x86_64')
depends=(
'glibc'
'libmnl'
)
source=(
"http://netfilter.org/projects/$pkgname/files/$pkgname-$pkgver.tar.bz2"
"http://netfilter.org/projects/$pkgname/files/$pkgname-$pkgver.tar.bz2.sig"
'01-flowtable.patch::https://git.netfilter.org/libnftnl/patch/?id=b2388765e0c4405442faa13845419f6a35d0134c'
)
sha1sums=(
'a923bae5b028a30c5c8aa4c0f71445885867274b'
'SKIP'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
patch -p1 -i ../01-flowtable.patch
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
