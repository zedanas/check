pkgname=('iso-codes')
pkgver=4.4
pkgrel=1
pkgdesc='Lists of the country, language, and currency names'
url='https://salsa.debian.org/iso-codes-team/iso-codes'
license=('LGPL')
arch=('any')
makedepends=(
'git'
'python'
)
_commit='38edb926592954b87eb527124da0ec68d2a748f3'
sha256sums=('SKIP')
prepare() {
cd $pkgname
autoreconf -fi
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
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname
make DESTDIR=$pkgdir pkgconfigdir=/usr/lib/pkgconfig install
}
