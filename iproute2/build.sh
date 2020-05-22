pkgname=('iproute2')
pkgver=5.5.0
pkgrel=1
pkgdesc='IP Routing Utilities'
url='https://git.kernel.org/pub/scm/network/iproute2/iproute2.git'
license=('GPL2')
arch=('x86_64')
groups=('base')
depends=(
'bash'
'db'
'glibc'
'iptables'
'libcap'
'libelf'
'libmnl'
)
provides=('iproute')
backup=(
'etc/iproute2/ematch_map'
'etc/iproute2/rt_dsfield'
'etc/iproute2/rt_protos'
'etc/iproute2/rt_realms'
'etc/iproute2/rt_scopes'
'etc/iproute2/rt_tables'
)
options=('emptydirs')
source=(
"https://www.kernel.org/pub/linux/utils/net/$pkgname/$pkgname-$pkgver.tar.xz"
"https://www.kernel.org/pub/linux/utils/net/$pkgname/$pkgname-$pkgver.tar.sign"
'0001-make-iproute2-fhs-compliant.patch'
)
sha256sums=(
'bac543435cac208a11db44c9cc8e35aa902befef8750594654ee71941c388f7b'
'SKIP'
'f60fefe4c17d3b768824bb50ae6416292bcebba06d73452e23f4147b46b827d3'
)
prepare() {
cd $pkgname-$pkgver
patch -Np1 -i $srcdir/0001-make-iproute2-fhs-compliant.patch
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
make
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir SBINDIR=/usr/bin install
install -Dm0644 include/libnetlink.h $pkgdir/usr/include/libnetlink.h
install -Dm0644 lib/libnetlink.a $pkgdir/usr/lib/libnetlink.a
}
