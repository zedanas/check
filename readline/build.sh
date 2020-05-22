pkgname=('readline')
pkgver=8.0.004
pkgrel=1
pkgdesc='GNU readline library'
url='https://tiswww.case.edu/php/chet/readline/rltop.html'
license=('GPL')
arch=('x86_64')
depends=(
'glibc'
'libncursesw.so'
'ncurses'
)
provides=(
'libhistory.so'
'libreadline.so'
)
backup=('etc/inputrc')
_basever=${pkgver%.*}
source=(
"https://ftp.gnu.org/gnu/readline/readline-$_basever.tar.gz"
"https://ftp.gnu.org/gnu/readline/readline-$_basever.tar.gz.sig"
"https://ftp.gnu.org/gnu/readline/readline-$_basever-patches/readline${_basever//./}-001"
"https://ftp.gnu.org/gnu/readline/readline-$_basever-patches/readline${_basever//./}-001.sig"
"https://ftp.gnu.org/gnu/readline/readline-$_basever-patches/readline${_basever//./}-002"
"https://ftp.gnu.org/gnu/readline/readline-$_basever-patches/readline${_basever//./}-002.sig"
"https://ftp.gnu.org/gnu/readline/readline-$_basever-patches/readline${_basever//./}-003"
"https://ftp.gnu.org/gnu/readline/readline-$_basever-patches/readline${_basever//./}-003.sig"
"https://ftp.gnu.org/gnu/readline/readline-$_basever-patches/readline${_basever//./}-004"
"https://ftp.gnu.org/gnu/readline/readline-$_basever-patches/readline${_basever//./}-004.sig"
'inputrc'
)
md5sums=(
'7e6c1f16aee3244a69aba6e438295ca3'
'SKIP'
'c3e27b8a0d8e37a4172654e5f3ef2eec'
'SKIP'
'2e631f1973dfe4b0ef042c40b8fdb47e'
'SKIP'
'9d2344b399237fa7abdbcf966b364c97'
'SKIP'
'0c0406762a9afcd34c6a77268fea0ccb'
'SKIP'
'58d54966c1191db45973cb3191ac621a'
)
prepare() {
cd $pkgname-$_basever
patch -p0 -i $srcdir/readline${_basever//./}-001
patch -p0 -i $srcdir/readline${_basever//./}-002
patch -p0 -i $srcdir/readline${_basever//./}-003
patch -p0 -i $srcdir/readline${_basever//./}-004
sed -i 's|-Wl,-rpath,$(libdir) ||g' support/shobj-conf
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname-$_basever
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
	'--disable-install-examples'
	'--enable-multibyte'
	'--with-curses'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make SHLIB_LIBS=-lncurses
}
package() {
cd $pkgname-$_basever
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/inputrc $pkgdir/etc/inputrc
}
