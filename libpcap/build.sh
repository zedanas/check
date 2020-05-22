pkgname=('libpcap')
pkgver=1.9.1
pkgrel=2
pkgdesc='A system-independent interface for user-level packet capture'
url='https://www.tcpdump.org/'
license=('BSD')
arch=('x86_64')
depends=(
'dbus'
'glibc'
'libnl'
'sh'
)
makedepends=(
'bluez-libs'
'flex'
)
source=(
"https://www.tcpdump.org/release/$pkgname-$pkgver.tar.gz"
"https://www.tcpdump.org/release/$pkgname-$pkgver.tar.gz.sig"
'mgmt.h'
)
sha256sums=(
'635237637c5b619bcceba91900666b64d56ecb7be63f298f601ec786ce087094'
'SKIP'
'7c85da5330ce7ecb6934795c02c652b9e344461302cf74804a4692c3e2e1e7e2'
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
	'--disable-yydebug'
	'--disable-optimizer-dbg'
	'--enable-usb'
	'--enable-ipv6'
	'--enable-netmap'
	'--enable-rdma'
	'--enable-protochain'
	'--enable-packet-ring'
	'--enable-remote'
	'--enable-bluetooth'
	'--enable-dbus'
	'--with-libnl'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 LICENSE $pkgdir/usr/share/licenses/libpcap/LICENSE
mkdir -p $pkgdir/usr/include/net
cd $pkgdir/usr/include/net && ln -s ../pcap-bpf.h bpf.h
}
