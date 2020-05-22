pkgname=('libxslt')
pkgver=1.1.34
pkgrel=2
pkgdesc='XML stylesheet transformation library'
url='http://xmlsoft.org/XSLT/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libgcrypt'
'libxml2'
'sh'
)
makedepends=('git')
checkdepends=(
'docbook-xml'
'python'
)
options=('emptydirs')
_commit='3653123f992db24cec417d12600f4c67388025e3'
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
	'--without-debug'
	'--without-debugger'
	'--without-profiler'
	'--with-plugins'
	'--with-crypto'
	'--without-python'
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
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/libxslt/COPYING
}
