pkgbase='dbus'
pkgname=('dbus' 'dbus-docs')
pkgver=1.12.16
pkgrel=5
url='https://wiki.freedesktop.org/www/Software/dbus/'
license=('GPL' 'custom')
arch=('x86_64')
makedepends=(
'autoconf-archive'
'docbook-xsl'
'doxygen'
'git'
'glib2'
'graphviz'
'python'
'systemd'
'xmlto'
'yelp-tools'
)
options=('emptydirs')
_commit='23cc709db8fab94f11fa48772bff396b20aea8b0'
source=(
'dbus-reload.hook'
)
sha256sums=(
'SKIP'
'd636205622d0ee3b0734360225739ef0c7ad2468a09489e6ef773d88252960f3'
)
prepare() {
cd $pkgbase
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgbase
config_opts=(
	'--prefix=/usr'
	'--bindir=/usr/bin'
	'--sbindir=/usr/bin'
	'--libdir=/usr/lib'
	'--libexecdir=/usr/lib/dbus-1.0'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--enable-debug=no'
	'--disable-developer'
	'--disable-verbose-mode'
	'--disable-asserts'
	'--disable-launchd'
	'--disable-checks'
	'--disable-tests'
	'--disable-embedded-tests'
	'--disable-modular-tests'
	'--disable-installed-tests'
	'--enable-inotify'
	'--enable-epoll'
	'--enable-stats'
	'--enable-xml-docs'
	'--enable-doxygen-docs'
	'--enable-x11-autolaunch'
	'--with-dbus-user=dbus'
	'--with-test-user=nobody'
	'--with-system-pid-file=/run/dbus/pid'
	'--with-system-socket=/run/dbus/system_bus_socket'
	'--with-console-auth-dir=/run/console/'
	'--disable-apparmor'
	'--disable-libaudit'
	'--disable-selinux'
	'--enable-systemd'
	'--enable-user-session'
	'--with-x'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgbase
make -k check
}
package_dbus() {
pkgdesc='Freedesktop.org message bus system'
depends=(
	'expat'
	'glibc'
	'libx11'
	'systemd-libs'
)
provides=(
	'libdbus'
	'libdbus-1.so'
)
conflicts=('libdbus')
replaces=('libdbus')
cd $pkgbase
make DESTDIR=$pkgdir install
install -Dm644 ../dbus-reload.hook $pkgdir/usr/share/libalpm/hooks/dbus-reload.hook
install -Dm644 COPYING $pkgdir/usr/share/licenses/dbus/COPYING
echo 'u dbus 81 "System Message Bus"' | install -Dm644 /dev/stdin $pkgdir/usr/lib/sysusers.d/dbus.conf
rm -f $pkgdir/etc/dbus-1/{system.conf,session.conf}
rm -r $pkgdir/{etc,var}
mkdir -p $srcdir/dbus-docs/usr/share/doc
if [ -d usr/share/doc ]; then
	mv usr/share/doc/* $srcdir/dbus-docs/usr/share/doc
	rm -fr usr/share/doc
fi
}
package_dbus-docs() {
pkgdesc='Freedesktop.org message bus system (documentation)'
depends=('dbus')
options=('docs')
cd $pkgbase
mv $srcdir/dbus-docs/* $pkgdir
install -Dm644 COPYING $pkgdir/usr/share/licenses/dbus-docs/COPYING
}
