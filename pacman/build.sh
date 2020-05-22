pkgname=('pacman')
pkgver=5.2.1
pkgrel=4
pkgdesc='A library-based package manager with dependency support'
url='https://www.archlinux.org/pacman/'
license=('GPL')
arch=('x86_64')
groups=('base-devel')
depends=(
'archlinux-keyring'
'bash'
'curl'
'glibc'
'gpgme'
'libarchive'
'openssl'
'pacman-mirrorlist'
'perl'
)
makedepends=('asciidoc')
checkdepends=(
'python'
'fakechroot'
)
optdepends=('perl-locale-gettext: translation support in makepkg-template')
provides=('libalpm.so')
backup=(
'etc/pacman.conf'
'etc/makepkg.conf'
)
options=('emptydirs')
source=(
"https://sources.archlinux.org/other/$pkgname/$pkgname-$pkgver.tar.gz"
"https://sources.archlinux.org/other/$pkgname/$pkgname-$pkgver.tar.gz.sig"
'pacman-5.2.1-fix-pactest-package-tar-format.patch::https://git.archlinux.org/pacman.git/patch/?id=b9faf652735c603d1bdf849a570185eb721f11c1'
'makepkg-fix-one-more-file-seccomp-issue.patch'
'pacman.conf'
'makepkg.conf'
)
sha256sums=(
'1930c407265fd039cb3a8e6edc82f69e122aa9239d216d9d57b9d1b9315af312'
'SKIP'
'SKIP'
'e481a161bba76729cd434c97e0b319ddfcb1d93b2e4890d72b4e8a32982531d9'
'3353f363088c73f1f86a890547c0f87c7473e5caf43bbbc768c2e9a7397f2aa2'
'8c100b64450f5a19a16325dd05c143d49395bdeb96bd957f863cde4b95d3cb86'
)
prepare() {
cd $pkgname-$pkgver
patch -p1 -i $srcdir/pacman-5.2.1-fix-pactest-package-tar-format.patch
patch -p1 -i $srcdir/makepkg-fix-one-more-file-seccomp-issue.patch
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
	'--enable-git-version'
	'--disable-static'
	'--disable-debug'
	'--enable-doc'
	'--disable-doxygen'
	'--with-file-seccomp=yes'
	'--with-scriptlet-shell=/usr/bin/bash'
	'--with-ldconfig=/usr/bin/ldconfig'
	'--with-libcurl'
	'--with-gpgme'
	'--with-crypto=openssl'
)
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
cd $pkgdir
install -Dm644 $srcdir/pacman.conf etc/pacman.conf
install -Dm644 $srcdir/makepkg.conf etc/makepkg.conf
}
