pkgname=('shared-mime-info')
pkgver=1.15
pkgrel=2
pkgdesc='Freedesktop.org Shared MIME Info'
url='https://www.freedesktop.org/wiki/Specifications/shared-mime-info-spec/'
license=('GPL2')
arch=('x86_64')
depends=(
'glib2'
'glibc'
'libxml2'
)
makedepends=(
'gettext'
'itstool'
'pkgconfig'
)
install='shared-mime-info.install'
source=(
"https://gitlab.freedesktop.org/xdg/shared-mime-info/uploads/b27eb88e4155d8fccb8bb3cd12025d5b/$pkgname-$pkgver.tar.xz"
'update-mime-database.hook'
)
sha256sums=(
'f482b027437c99e53b81037a9843fccd549243fd52145d016e9c7174a4f5db90'
'7ecdd55ff7c4331e188cf46debbcc5660edb0e2bbeb4dd87cc5b87278c292821'
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
	'--disable-update-mimedb'
)
export ac_cv_func_fdatasync=no
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
install -Dm644 $srcdir/update-mime-database.hook \
$pkgdir/usr/share/libalpm/hooks/update-mime-database.hook
}
