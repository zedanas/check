pkgname=('gtk2')
pkgver=2.24.32
pkgrel=2
pkgdesc='GObject-based multi-platform GUI toolkit (legacy)'
url='https://www.gtk.org/'
license=('LGPL')
arch=('x86_64')
depends=(
'atk'
'cairo'
'desktop-file-utils'
'fontconfig'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk-update-icon-cache'
'libx11'
'libxcomposite'
'libxcursor'
'libxdamage'
'libxext'
'libxfixes'
'libxi'
'libxinerama'
'libxrandr'
'libxrender'
'pango'
'shared-mime-info'
)
makedepends=(
'git'
'gtk-doc'
'python2'
)
optdepends=(
'adwaita-icon-theme: Default icon theme'
'gnome-themes-standard: Default widget theme'
'python2: gtk-builder-convert'
)
provides=(
'libgailutil.so'
'libgdk-x11-2.0.so'
'libgtk-x11-2.0.so'
)
install='gtk2.install'
source=(
'gtkrc'
'gtk-query-immodules-2.0.hook'
'xid-collision-debug.patch'
)
sha256sums=(
'SKIP'
'bc968e3e4f57e818430130338e5f85a5025e21d7e31a3293b8f5a0e58362b805'
'9656a1efc798da1ac2dae94e921ed0f72719bd52d4d0138f305b993f778f7758'
'd758bb93e59df15a4ea7732cf984d1c3c19dff67c94b957575efea132b8fe558'
)
prepare() {
cd gtk+
patch -Np1 -i $srcdir/xid-collision-debug.patch
sed -i '1s/python$/&2/' gtk/gtk-builder-convert
sed -i 's/1.15/1.16/g' autogen.sh
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd gtk+
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
	'--enable-shm'
	'--enable-man'
	'--disable-gtk-doc'
	'--disable-glibtest'
	'--disable-test-print-backend'
	'--disable-papi'
	'--enable-xkb'
	'--enable-rebuilds'
	'--enable-visibility'
	'--enable-modules'
	'--enable-debug=no'
	'--enable-introspection=no'
	'--enable-explicit-deps=yes'
	'--with-gdktarget=x11'
	'--with-x'
	'--disable-cups'
	'--enable-xinerama'
	'--with-xinput=yes'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd gtk+
make DESTDIR=$pkgdir install
cd $pkgdir
install -Dm644 $srcdir/gtkrc usr/share/gtk-2.0/gtkrc
install -Dm644 $srcdir/gtk-query-immodules-2.0.hook usr/share/libalpm/hooks/gtk-query-immodules-2.0.hook
rm usr/bin/gtk-update-icon-cache
rm usr/share/man/man1/gtk-update-icon-cache.1
}
