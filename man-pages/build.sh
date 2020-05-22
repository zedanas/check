pkgname=('man-pages')
pkgver=5.05
pkgrel=2
pkgdesc='Linux man pages'
url='http://man7.org/linux/man-pages/index.html'
license=('GPL' 'custom')
arch=('any')
groups=('base')
_posixver=2013-a
source=(
"https://www.kernel.org/pub/linux/docs/man-pages/man-pages-$pkgver.tar.xz"
"https://www.kernel.org/pub/linux/docs/man-pages/man-pages-$pkgver.tar.sign"
"https://www.kernel.org/pub/linux/docs/man-pages/man-pages-posix/man-pages-posix-$_posixver.tar.xz"
"https://www.kernel.org/pub/linux/docs/man-pages/man-pages-posix/man-pages-posix-$_posixver.tar.sign"
)
sha256sums=(
'd5b135b1196d9258138610dbc47190d8b9ac9dee7f8ee6d9196f7fc6a036eb47'
'SKIP'
'19633a5c75ff7deab35b1d2c3d5b7748e7bd4ef4ab598b647bb7e7f60b90a808'
'SKIP'
)
build() {
cd $pkgname-$pkgver
mkdir -p man0
for sect in 0 1 3; do
	mv $srcdir/$pkgname-posix-2013-a/man${sect}p/* man${sect}
done
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/$pkgname-posix-2013-a/POSIX-COPYRIGHT $pkgdir/usr/share/licenses/man-pages/POSIX-COPYRIGHT
cd $pkgdir
rm -f usr/share/man/man1/{chgrp,chmod,chown,cp,dir,dd}.1
rm -f usr/share/man/man1/{df,dircolors,du,install,ln,ls}.1
rm -f usr/share/man/man1/{mkdir,mkfifo,mknod,mv,rm,rmdir}.1
rm -f usr/share/man/man1/{touch,vdir}.1
rm -f usr/share/man/man5/passwd.5
rm -f usr/share/man/man3/getspnam.3
rm -f usr/share/man/man1/diff.1
rm -f usr/share/man/man4/mouse.4
rm -f usr/share/man/man5/attr.5
rm -f usr/share/man/man4/lirc.4
rm -f usr/share/man/man7/{keyrings.7,persistent-keyring.7,process-keyring.7,session-keyring.7,thread-keyring.7,user-keyring.7,user-session-keyring.7}
rm -f usr/share/man/man5/tzfile.5
rm -f usr/share/man/man8/{tzselect,zdump,zic}.8
}
