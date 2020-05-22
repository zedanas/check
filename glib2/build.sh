pkgbase='glib2'
pkgname=('glib2' 'glib2-docs')
pkgver=2.64.1
pkgrel=1
url='https://wiki.gnome.org/Projects/GLib'
arch=('x86_64')
makedepends=(
'attr'
'dbus'
'gettext'
'git'
'gtk-doc'
'libelf'
'libffi'
'libmount.so'
'libutil-linux'
'meson'
'pcre'
'python'
'shared-mime-info'
'zlib'
)
checkdepends=('desktop-file-utils')
_commit='24d272511c7ae8bb4c46dce0b0c67eca8d2ca3e5'
source=(
'noisy-glib-compile-schemas.diff'
'glib-compile-schemas.hook'
'gio-querymodules.hook'
)
sha256sums=(
'SKIP'
'81a4df0b638730cffb7fa263c04841f7ca6b9c9578ee5045db6f30ff0c3fc531'
'64ae5597dda3cc160fc74be038dbe6267d41b525c0c35da9125fbf0de27f9b25'
'557c88177f011ced17bdeac1af3f882b2ca33b386a866fdf900b35f927a2bbe8'
)
prepare() {
cd glib
patch -Np1 -i $srcdir/noisy-glib-compile-schemas.diff
}
build() {
cd glib
config_opts=(
	'-Dman=true'
	'-Ddtrace=false'
	'-Dsystemtap=false'
	'-Dgtk_doc=true'
	'-Diconv=auto'
	'-Dforce_posix_threads=false'
	'-Dinstalled_tests=false'
	'-Dnls=enabled'
	'-Dxattr=true'
	'-Dfam=false'
	'-Dlibmount=enabled'
	'-Dselinux=disabled'
	'-Dinternal_pcre=false'
)
export CFLAGS+=' -DG_DISABLE_CAST_CHECKS'
arch-meson build "${config_opts[@]}"
ninja -C build
}
check() {
cd glib
ninja -C build test
}
package_glib2() {
pkgdesc='Low level core library'
license=('LGPL2.1')
depends=(
	'attr'
	'bash'
	'glibc'
	'libelf'
	'libffi'
	'libmount.so'
	'pcre'
	'zlib'
)
provides=(
	'libgio-2.0.so'
	'libglib-2.0.so'
	'libgmodule-2.0.so'
	'libgobject-2.0.so'
	'libgthread-2.0.so'
)
optdepends=('python: gdbus-codegen, glib-genmarshal, glib-mkenums, gtester-report')
cd glib
DESTDIR=$pkgdir ninja -C build install
cd $pkgdir
install -Dm644 -t usr/share/libalpm/hooks $srcdir/*.hook
mkdir -p $srcdir/glib2-docs/usr/share/gtk-doc
mv usr/share/gtk-doc $srcdir/glib2-docs/usr/share || true
}
package_glib2-docs() {
pkgdesc="Documentation for GLib"
license=('LGPL2.1' 'custom')
depends=('glib2')
options=('docs')
mv $srcdir/glib2-docs/* $pkgdir
install -Dm644 $srcdir/glib/docs/reference/COPYING $pkgdir/usr/share/licenses/glib2-docs/COPYING
}
