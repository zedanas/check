pkgname=('ncurses')
pkgver=6.2
pkgrel=1
pkgdesc='System V Release 4.0 curses emulation library'
url='https://invisible-island.net/ncurses/ncurses.html'
license=('MIT')
arch=('x86_64')
depends=(
'gcc-libs'
'glibc'
'gpm'
'sh'
)
provides=(
'libformw.so'
'libmenuw.so'
'libncurses++w.so'
'libncursesw.so'
'libpanelw.so'
)
replaces=('alacritty-terminfo')
source=(
"https://ftp.gnu.org/pub/gnu/ncurses/ncurses-$pkgver.tar.gz"
"https://ftp.gnu.org/pub/gnu/ncurses/ncurses-$pkgver.tar.gz.sig"
)
md5sums=(
'e812da327b1c2214ac1aed440ea3ae8d'
'SKIP'
)
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
	'--disable-assertions'
	'--enable-widec'
	'--enable-pc-files'
	'--enable-sp-funcs'
	'--enable-const'
	'--enable-sigwinch'
	'--enable-ext-funcs'
	'--enable-ext-colors'
	'--enable-ext-putwin'
	'--enable-ext-mouse'
	'--enable-tcap-names'
	'--enable-db-install'
	'--enable-opaque-curses'
	'--enable-opaque-form'
	'--enable-opaque-menu'
	'--enable-opaque-panel'
	'--with-normal'
	'--with-shared'
	'--without-debug'
	'--without-develop'
	'--without-profile'
	'--without-ada'
	'--with-manpages'
	'--with-progs'
	'--with-tack'
	'--with-tests'
	'--with-pcre2'
	'--with-pkg-config'
	'--with-pkg-config-libdir=/usr/lib/pkgconfig'
	'--with-manpage-format=normal'
	'--without-hashed-db'
	'--with-cxx'
	'--with-cxx-binding'
	'--with-cxx-shared'
	'--with-gpm'
	'--without-dlsym'
)
./configure "${config_opts[@]}"
make
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 COPYING $pkgdir/usr/share/licenses/ncurses/LICENSE
for lib in ncurses ncurses++ form panel menu; do
	echo "INPUT(-l${lib}w)" > $pkgdir/usr/lib/lib${lib}.so
	ln -s ${lib}w.pc $pkgdir/usr/lib/pkgconfig/${lib}.pc
done
for lib in tic tinfo; do
	echo "INPUT(libncursesw.so.${pkgver:0:1})" > $pkgdir/usr/lib/lib${lib}.so
	ln -s libncursesw.so.${pkgver:0:1} $pkgdir/usr/lib/lib${lib}.so.${pkgver:0:1}
	ln -s ncursesw.pc $pkgdir/usr/lib/pkgconfig/${lib}.pc
done
echo "INPUT(-lncursesw)" > $pkgdir/usr/lib/libcursesw.so
ln -s libncurses.so $pkgdir/usr/lib/libcurses.so
}
