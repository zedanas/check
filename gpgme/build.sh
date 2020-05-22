pkgbase='gpgme'
pkgname=('gpgme' 'qgpgme' 'python-gpgme')
pkgver=1.13.1
pkgrel=4
url='http://www.gnupg.org/related_software/gpgme/'
license=('LGPL')
arch=('x86_64')
makedepends=(
'gnupg'
'libgpg-error'
'python'
'qt5-base'
'swig'
)
source=(
"https://www.gnupg.org/ftp/gcrypt/$pkgbase/$pkgbase-$pkgver.tar.bz2"
"https://www.gnupg.org/ftp/gcrypt/$pkgbase/$pkgbase-$pkgver.tar.bz2.sig"
)
sha256sums=(
'c4e30b227682374c23cddc7fdb9324a99694d907e79242a25a4deeedb393be46'
'SKIP'
)
prepare() {
cd $pkgname-$pkgver
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgbase-$pkgver
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
	'--disable-fd-passing'
	'--enable-linux-getdents'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgbase-$pkgver
make -k check
}
package_gpgme() {
pkgdesc='A C wrapper library for GnuPG'
depends=(
	'gcc-libs'
	'glibc'
	'gnupg>=2'
	'libassuan'
	'libgpg-error'
	'sh'
)
cd $pkgbase-$pkgver
make DESTDIR=$pkgdir install
cd $pkgdir
mkdir -p $srcdir/qgpgme/usr/{include,lib/cmake}
mv usr/include/{qgpgme,QGpgME} $srcdir/qgpgme/usr/include || true
mv usr/lib/cmake/QGpgme $srcdir/qgpgme/usr/lib/cmake || true
mv usr/lib/libqgpgme.* $srcdir/qgpgme/usr/lib || true
mkdir -p $srcdir/python-gpgme/usr/lib
mv usr/lib/python3* $srcdir/python-gpgme/usr/lib || true
rm -fr usr/lib/python2*
}
package_qgpgme() {
pkgdesc='Qt bindings for GPGme'
depends=(
	'gcc-libs'
	'glibc'
	'gpgme'
	'libgpg-error'
	'qt5-base'
)
mv $srcdir/qgpgme/* $pkgdir
}
package_python-gpgme() {
pkgdesc='Python bindings for GPGme'
depends=(
	'glibc'
	'gpgme'
	'python'
)
mv $srcdir/python-gpgme/* $pkgdir
}
