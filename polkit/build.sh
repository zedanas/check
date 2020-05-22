pkgname=('polkit')
pkgver=0.116
pkgrel=5
pkgdesc='Application development toolkit for controlling system-wide privileges'
url='https://www.freedesktop.org/wiki/Software/polkit/'
license=('LGPL')
arch=('x86_64')
depends=(
'expat'
'gcc-libs'
'glib2'
'glibc'
'js60'
'pam'
'systemd-libs'
)
makedepends=(
'autoconf-archive'
'git'
'gobject-introspection'
'gtk-doc'
'intltool'
)
backup=('etc/pam.d/polkit-1')
options=('emptydirs')
_commit='941e9329f8d3d43ace8335d206365b212824e686'
sha256sums=('SKIP')
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
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--disable-test'
	'--enable-man-pages'
	'--disable-gtk-doc'
	'--disable-examples'
	'--enable-introspection=no'
	'--with-os-type=redhat'
	'--enable-libsystemd-login=yes'
	'--with-authfw=pam'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname
make -k check
}
package() {
cd $pkgname
make DESTDIR=$pkgdir \
	dbusconfdir=/usr/share/dbus-1/system.d \
	rulesdir=/usr/share/polkit-1/rules.d \
	install
mkdir -p $pkgdir/usr/lib/sysusers.d
echo -e 'u polkitd 102 "PolicyKit daemon"\nm polkitd proc' \
> $pkgdir/usr/lib/sysusers.d/polkit.conf
chmod 644 $pkgdir/usr/lib/sysusers.d/polkit.conf
chown root:polkitd $pkgdir/{etc,usr/share}/polkit-1/rules.d
chmod 750 $pkgdir/{etc,usr/share}/polkit-1/rules.d
}
