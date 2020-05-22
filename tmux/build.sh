pkgname=('tmux')
pkgver=3.0_a
pkgrel=1
pkgdesc='A terminal multiplexer'
url='https://github.com/tmux/tmux/wiki'
license=('BSD')
arch=('x86_64')
depends=(
'glibc'
'libevent'
'ncurses'
)
source=(
"https://github.com/$pkgname/$pkgname/releases/download/${pkgver/_/}/$pkgname-${pkgver/_/}.tar.gz"
'LICENSE'
)
sha256sums=(
'4ad1df28b4afa969e59c08061b45082fdc49ff512f30fc8e43217d7b0e5f8db9'
'b5de80619e4884ced2dfe0a96020e85dcfb715a831ecdfdd7ce8c97b5a6ff2cc'
)
build() {
cd $pkgname-${pkgver/_/}
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
	'--disable-debug'
	'--disable-utempter'
	'--disable-utf8proc'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname-${pkgver/_/}
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/LICENSE $pkgdir/usr/share/licenses/tmux/LICENSE
}
