pkgname=('libtool')
pkgver=2.4.7
pkgrel=11
pkgdesc='A generic library support script'
url='https://www.gnu.org/software/libtool'
license=('GPL')
arch=('x86_64')
groups=('base-devel')
depends=(
'glibc'
'sh'
'tar'
)
makedepends=(
"gcc>=9.3.0"
'git'
'help2man'
)
checkdepends=('gcc-fortran')
provides=(
"libltdl=$pkgver"
"libtool-multilib=$pkgver"
)
conflicts=(
'libltdl'
'libtool-multilib'
)
replaces=(
'libltdl'
'libtool-multilib'
)
_commit='b88cebd510add4420dd8f5367e3cc6e6e1f267cd'
source=(
'git+https://git.savannah.gnu.org/git/gnulib.git'
'gnulib-bootstrap::git+https://github.com/gnulib-modules/bootstrap.git'
'no_hostname.patch'
)
sha256sums=(
'SKIP'
'SKIP'
'SKIP'
'693aabb24a6e7ce21fe0b5d14394e19edcb8476663b5afa4463f9fa0df24d946'
)
prepare() {
cd $pkgname
patch -p1 -i $srcdir/no_hostname.patch
git submodule init
git config --local submodule.gnulib.url $srcdir/gnulib
git config --local submodule.gl-mod/bootstrap.url $srcdir/gnulib-bootstrap
git submodule update
./bootstrap
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
	'--enable-ltdl-install'
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
