pkgname=('xorg-xinit')
pkgver=1.4.1
pkgrel=1
pkgdesc='X.Org initialisation program'
url='https://xorg.freedesktop.org/'
license=('custom')
arch=('x86_64')
depends=(
'glibc'
'libx11'
'xorg-xauth'
'xorg-xmodmap'
'xorg-xrdb'
)
makedepends=('xorg-util-macros')
optdepends=(
'xorg-twm'
'xterm'
)
backup=(
'etc/X11/xinit/xserverrc'
'etc/X11/xinit/xinitrc'
)
source=(
"https://xorg.freedesktop.org/releases/individual/app/xinit-$pkgver.tar.bz2"
"https://xorg.freedesktop.org/releases/individual/app/xinit-$pkgver.tar.bz2.sig"
'06_move_serverauthfile_into_tmp.diff'
'fs25361.patch'
'fs46369.patch'
'xserverrc'
)
sha512sums=(
'6cbc5d025a891c419f3f4493381b2fca57a67d78df866d2f16a83426f86bad6eca7f240fac12b25cbcc63df0fec41f625407184e044898602d66483715315340'
'SKIP'
'99216b2d50052a0bafede9a2db1744a8b0313ccbc02c609502ddacb8684fc56c6f2656e6521c848880033b25005bb14a1bce0d6fefade85141ed56aad07dadf3'
'12a89cbb26902e135bb21f945c8de86526ff879c9f20a2601157f6a39899f021ed2970cee9e4fbcd4c13af6fe78e7902dd1f7ce1928fc914d681453bf848c0f8'
'8a36bff3c472763a9a46b9a36b8b4a15f03e6fb0387b12efba27f15dc500faa2a3f92c0f7e217a0b00da7c78682c7af6357cc6b88b550ece9bc89c477412b7e0'
'f86d96d76bcb340021e7904925f0029f8662e4dfc32489198b3a8695dca069da496539e2287249c763fe9c4d8d5d591fd18fe49a0bee822cbbd0eb712efbb89b'
)
prepare() {
cd xinit-$pkgver
patch -Np1 -i $srcdir/06_move_serverauthfile_into_tmp.diff
patch -Np1 -i $srcdir/fs25361.patch
patch -Np1 -i $srcdir/fs46369.patch
sed -i -e 's/XSLASHGLOB.sh/XSLASHGLOB/' xinitrc.cpp
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd xinit-$pkgver
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
	'--with-xinitdir=/etc/X11/xinit'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd xinit-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/xserverrc $pkgdir/etc/X11/xinit/xserverrc
install -Dm644 COPYING $pkgdir/usr/share/licenses/xorg-xinit/COPYING
}
