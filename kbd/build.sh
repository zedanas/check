pkgname=('kbd')
pkgver=2.2.0
pkgrel=5
pkgdesc='Keytable files and keyboard utilities'
url='http://www.kbd-project.org'
license=('GPL')
arch=('x86_64')
depends=(
'glibc'
'pam'
'sh'
)
makedepends=(
'check'
'git'
)
provides=('vlock')
conflicts=('vlock')
replaces=('vlock')
source=(
'fix-euro2.patch'
'kbd-fix-loadkmap-compat.patch'
)
md5sums=(
'SKIP'
'd869200acbc0aab6a9cafa43cb140d4e'
'730b1054fbd88b87c27c5565bd7d4fc6'
)
prepare() {
cd $pkgname
mv data/keymaps/i386/qwertz/cz{,-qwertz}.map
mv data/keymaps/i386/olpc/es{,-olpc}.map
mv data/keymaps/i386/olpc/pt{,-olpc}.map
mv data/keymaps/i386/fgGIod/trf{,-fgGIod}.map
mv data/keymaps/i386/colemak/{en-latin9,colemak}.map
patch -Np1 -i ../fix-euro2.patch
git cherry-pick -n 15a74479
git cherry-pick -n acf93e44
git cherry-pick -n 7e27102b
patch -p1 -i ../kbd-fix-loadkmap-compat.patch
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
	'--datadir=/usr/share/kbd'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--disable-tests'
	'--enable-vlock'
	'--enable-libkeymap'
	'--enable-optional-progs'
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
}
