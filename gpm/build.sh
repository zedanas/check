pkgname=('gpm')
pkgver=1.20.8
pkgrel=1
pkgdesc='A mouse server for the console and xterm'
url='http://www.nico.schottelius.org/software/gpm/'
license=('GPL')
arch=('x86_64')
depends=(
'glibc'
'ncurses'
'sh'
)
makedepends=('git')
_commit='1fd19417b8a4dd9945347e98dfa97e4cfd798d77'
source=(
'0001-glibc-sigemptyset.patch'
'gpm.sh'
'gpm.service'
)
sha256sums=(
'SKIP'
'61f901aae46ff79679a058758151dc93901dcd9ea938fabb0765554993b8cb09'
'f41e90dcf6c0c6c4b8eff1c69039a20eb6b38ea851ffd1fa47ba311bf83d6ed8'
'dc7d2463f6670ff2c1646a571ffad51f7c603793c25c6f685efad13cbb444034'
)
prepare() {
cd $pkgname
patch -p1 -i $srcdir/0001-glibc-sigemptyset.patch
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
	'--with-curses'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install
install -Dm755 ../gpm.sh $pkgdir/etc/profile.d/gpm.sh
install -Dm644 ../gpm.service $pkgdir/usr/lib/systemd/system/gpm.service
cd $pkgdir/usr/lib/
ln -s libgpm.so.2.* libgpm.so
}
