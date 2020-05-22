pkgname=('mc')
pkgver=4.8.24
pkgrel=2
pkgdesc='A file manager that emulates Norton Commander'
url='https://midnight-commander.org/'
license=('GPL')
arch=('x86_64')
depends=(
'bash'
'e2fsprogs'
'glib2'
'glibc'
'gpm'
'libssh2'
'ncurses'
'pcre'
'perl'
)
makedepends=(
'libx11'
'libxt'
'unzip'
)
optdepends=(
'aspell: spelling corrections'
'cabextract: ucab extfs'
'cdparanoia: audio extfs'
'cdrkit: iso9660 extfs'
'cvs: CVS support'
'gawk: hp48+ extfs'
'mtools: a+ extfs'
'p7zip: support for 7zip archives'
'perl: needed by several extfs scripts'
'python2-boto: s3+ extfs'
'python2-pytz: s3+ extfs'
'samba: VFS support'
'unace: uace extfs'
'unarj: uarj extfs'
'unrar: urar extfs'
'zip: uzip extfs'
)
backup=(
'etc/mc/edit.indent.rc'
'etc/mc/filehighlight.ini'
'etc/mc/mc.ext'
'etc/mc/mc.keymap'
'etc/mc/mc.menu'
'etc/mc/mcedit.menu'
'etc/mc/sfs.ini'
)
source=(
"http://ftp.midnight-commander.org/$pkgname-$pkgver.tar.xz"
'mc-mksh-subshell-v2.patch'
'mc-python3.patch'
)
sha256sums=(
'859f1cc070450bf6eb4d319ffcb6a5ac29deb0ac0d81559fb2e71242b1176d46'
'5147afa3f9dfc00d8b7b36bbb144bcdb78d86301a0f8196686262a9eee41fb96'
'10ab8b8c03770f8fe51f0bdbf0d66a44313bf2eed687cf769397909c07d8e8d5'
)
prepare() {
cd $pkgname-$pkgver
patch -p1 -i $srcdir/mc-mksh-subshell-v2.patch
patch -p1 -i $srcdir/mc-python3.patch
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
	'--enable-mclib'
	'--enable-charset'
	'--enable-background'
	'--enable-threads=posix'
	'--disable-tests'
	'--disable-assert'
	'--disable-doxygen-man'
	'--disable-doxygen-doc'
	'--disable-doxygen-dot'
	'--disable-doxygen-rtf'
	'--disable-doxygen-xml'
	'--disable-doxygen-chm'
	'--disable-doxygen-chi'
	'--disable-doxygen-html'
	'--disable-doxygen-ps'
	'--disable-doxygen-pdf'
	'--enable-vfs'
	'--enable-vfs-cpio'
	'--enable-vfs-extfs'
	'--enable-vfs-fish'
	'--enable-vfs-ftp'
	'--enable-vfs-sfs'
	'--enable-vfs-sftp'
	'--enable-vfs-smb'
	'--enable-vfs-tar'
	'--with-homedir'
	'--with-subshell'
	'--with-internal-edit'
	'--with-diff-viewer'
	'--with-mmap'
	'--with-x'
	'--without-glib-static'
	'--disable-aspell'
	'--enable-vfs-undelfs'
	'--with-search-engine=glib'
	'--with-gpm-mouse'
	'--enable-vfs-sftp'
	'--with-x'
	'--with-screen=ncurses'
	'--with-pcre'
	'--with-search-engine=pcre'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
rm -f $pkgdir/etc/mc/mc.keymap
cp $pkgdir/etc/mc/mc.default.keymap $pkgdir/etc/mc/mc.keymap
}
