pkgname=('iptables')
pkgver=1.8.4
pkgrel=1
epoch=1
pkgdesc='Linux kernel packet control tool'
url='https://www.netfilter.org/projects/iptables/index.html'
license=('GPL2')
arch=('x86_64')
depends=(
'bash'
'glibc'
'libmnl'
'libnfnetlink'
'libnftnl'
'libpcap'
'sh'
)
makedepends=('linux-api-headers')
provides=(
'arptables'
'ebtables'
'iptables'
)
conflicts=(
'arptables'
'ebtables'
'iptables'
)
backup=(
'etc/ethertypes'
'etc/iptables/iptables.rules'
'etc/iptables/ip6tables.rules'
)
source=(
"https://www.netfilter.org/projects/$pkgname/files/$pkgname-$pkgver.tar.bz2"
"https://www.netfilter.org/projects/$pkgname/files/$pkgname-$pkgver.tar.bz2.sig"
'empty.rules'
'simple_firewall.rules'
'empty-filter.rules'
'empty-mangle.rules'
'empty-nat.rules'
'empty-raw.rules'
'empty-security.rules'
'arptables.service'
'ebtables.service'
'iptables.service'
'ip6tables.service'
'iptables-legacy-flush'
'iptables-nft-flush'
)
sha1sums=(
'cd5fe776fb2b0479b3234758fc333777caa1239b'
'SKIP'
'83b3363878e3660ce23b2ad325b53cbd6c796ecf'
'f085a71f467e4d7cb2cf094d9369b0bcc4bab6ec'
'd9f9f06b46b4187648e860afa0552335aafe3ce4'
'c45b738b5ec4cfb11611b984c21a83b91a2d58f3'
'1694d79b3e6e9d9d543f6a6e75fed06066c9a6c6'
'7db53bb882f62f6c677cc8559cff83d8bae2ef73'
'ebbd1424a1564fd45f455a81c61ce348f0a14c2e'
'95b0ee26f03132a948fea9f2136b2e2e6a4b40fe'
'b668ba50d55030c68431a95756bc1f291d74b2b2'
'8d66d21fa4cbfe2a80478301af94ba54f65e4ea0'
'9cec592787e32451f58fa608ea057870e07aa704'
'd10af7780d1634778d898c709e2d950aa1561856'
'15c1684f3e671f4d0ede639a7c9c08e1a841511c'
)
prepare() {
cd $pkgname-$pkgver
rm include/linux/types.h
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
	'--libexecdir=/usr/lib/iptables'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--enable-ipv4'
	'--enable-ipv6'
	'--enable-devel'
	'--enable-libipq'
	'--enable-bpf-compiler'
	'--enable-nfsynproxy'
	'--enable-nftables'
	'--disable-connlabel'
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
for _x in {arp,eb,ip,ip6}tables{,-restore,-save} iptables-xml; do
	if [[ legacy = nft || $_x = ip* ]]; then
		ln -sf xtables-legacy-multi $pkgdir/usr/bin/$_x
	else
		rm $pkgdir/usr/bin/$_x
	fi
done
mkdir -p $pkgdir/usr/share/iptables
install -Dm644 $srcdir/empty.rules $pkgdir/etc/iptables/iptables.rules
install -Dm644 $srcdir/empty.rules $pkgdir/etc/iptables/ip6tables.rules
install -Dm644 $srcdir/empty.rules $pkgdir/etc/iptables/empty.rules
install -Dm644 $srcdir/simple_firewall.rules $pkgdir/etc/iptables/simple_firewall.rules
install -Dm644 $srcdir/empty-{filter,mangle,nat,raw,security}.rules $pkgdir/usr/share/iptables
install -Dm644 $srcdir/simple_firewall.rules $pkgdir/usr/share/iptables
install -Dm644 $srcdir/iptables.service $pkgdir/usr/lib/systemd/system/iptables.service
install -Dm644 $srcdir/ip6tables.service $pkgdir/usr/lib/systemd/system/ip6tables.service
install -Dm755 $srcdir/iptables-legacy-flush $pkgdir/usr/lib/systemd/scripts/iptables-flush
}
