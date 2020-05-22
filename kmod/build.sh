pkgname=('kmod')
pkgver=27
pkgrel=1
pkgdesc='Linux kernel module management tools and library'
url='https://git.kernel.org/?p=utils/kernel/kmod/kmod.git;a=summary'
license=('GPL2')
arch=('x86_64')
depends=(
'bash'
'glibc'
'openssl'
'xz'
'zlib'
)
makedepends=('gtk-doc')
checkdepends=(
'libelf'
'linux-headers'
)
provides=(
'module-init-tools=3.16'
'libkmod.so'
)
conflicts=('module-init-tools')
replaces=('module-init-tools')
options=('emptydirs')
source=(
"https://www.kernel.org/pub/linux/utils/kernel/$pkgname/$pkgname-$pkgver.tar.xz"
"https://www.kernel.org/pub/linux/utils/kernel/$pkgname/$pkgname-$pkgver.tar.sign"
'depmod-search.conf'
'depmod.hook'
'depmod.script'
)
md5sums=(
'3973a74786670d3062d89a827e266581'
'SKIP'
'dd62cbf62bd8f212f51ef8c43bec9a77'
'e179ace75721e92b04b2e145b69dab29'
'18fb3d1f6024a5a84514c8276cb3ebff'
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
	'--disable-debug'
	'--disable-experimental'
	'--enable-test-modules'
	'--enable-tools'
	'--enable-logging'
	'--enable-manpages'
	'--enable-gtk-doc'
	'--with-openssl'
	'--disable-python'
	'--with-xz'
	'--with-zlib'
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
install -Dm644 $srcdir/depmod-search.conf $pkgdir/usr/lib/depmod.d/search.conf
install -Dm644 $srcdir/depmod.hook $pkgdir/usr/share/libalpm/hooks/60-depmod.hook
install -Dm755 $srcdir/depmod.script $pkgdir/usr/share/libalpm/scripts/depmod
for tool in {ins,ls,rm,dep}mod mod{probe,info}; do
	ln -s kmod $pkgdir/usr/bin/$tool
done
mkdir -p $pkgdir/{etc,usr/lib}/{depmod,modprobe}.d
}
