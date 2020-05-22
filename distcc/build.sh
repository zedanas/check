pkgname=('distcc')
pkgver=3.3.3
pkgrel=4
pkgdesc='Distributed C, C++ and Objective-C compiler'
url='http://distcc.org'
license=('GPL')
arch=('x86_64')
depends=(
'glib2'
'glibc'
'gtk2'
'popt'
)
makedepends=(
'git'
'setconf'
)
optdepends=('python')
backup=(
'etc/conf.d/distccd'
'etc/distcc/hosts'
)
source=(
'distccd.conf.d'
'distccd.service'
)
sha256sums=(
'SKIP'
'43e02b461841ca2976816c244a0eca8b24820ca143f73cc0924403d75a8c012f'
'6d46844f0bebd56541e1a233f9f02a51cc17885120e832bfb37711217403d32f'
)
prepare() {
cd $pkgname
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname
config_opts=(
	'--prefix=/usr'
	'--bindir=/usr/bin'
	'--sbindir=/usr/bin'
	'--libdir=/usr/lib'
	'--libexecdir=/usr/lib'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--enable-rfc2553'
	'--disable-Werror'
	'--with-libiberty'
	'--without-gnome'
	'--without-avahi'
	'--with-gtk'
	'--without-auth'
	'--without-included-popt'
	'--disable-pump-mode'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/distccd.conf.d $pkgdir/etc/conf.d/distccd
install -Dm644 $srcdir/distccd.service $pkgdir/usr/lib/systemd/system/distccd.service
install -d $pkgdir/usr/lib/distcc/bin
for compiler in cpp c89 c99 cc gcc c++ g++ clang clang++ x86_64-pc-linux-gnu-g++ x86_64-pc-linux-gnu-gcc x86_64-pc-linux-gnu-gcc-9.2.0
do
	ln -sf /usr/bin/distcc $pkgdir/usr/lib/distcc/bin/$compiler
	ln -sf /usr/bin/distcc $pkgdir/usr/lib/distcc/$compiler
done
if [ -f $pkgdir/usr/share/distcc/distccmon-gnome.desktop ]
then
	install -d $pkgdir/usr/share/applications
	sed -e 's/distccmon-gnome-icon.png/monitor/g' \
	$pkgdir/usr/share/distcc/distccmon-gnome.desktop \
	> $pkgdir/usr/share/applications/distccmon-gnome.desktop
	rm -f $pkgdir/usr/share/distcc/distccmon-gnome.desktop
fi
rm -f $pkgdir/etc/distcc/{clients.allow,commands.allow.sh}
}
