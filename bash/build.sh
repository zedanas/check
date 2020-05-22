pkgname='bash'
pkgver=5.0.016
pkgrel=1
pkgdesc='The GNU Bourne Again shell'
url='https://www.gnu.org/software/bash/bash.html'
license=('GPL')
arch=('x86_64')
groups=('base')
depends=(
'glibc'
'readline>=7.0'
)
optdepends=('bash-completion: for tab completion')
provides=('sh')
backup=(
'etc/bash.bashrc'
'etc/bash.bash_logout'
'etc/skel/.bashrc'
'etc/skel/.bash_profile'
'etc/skel/.bash_logout'
)
_basever=${pkgver%.*}
source=(
"https://ftp.gnu.org/gnu/bash/bash-$_basever.tar.gz"
"https://ftp.gnu.org/gnu/bash/bash-$_basever.tar.gz.sig"
'dot.bashrc'
'dot.bash_profile'
'dot.bash_logout'
'system.bashrc'
'system.bash_logout'
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-001"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-001.sig"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-002"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-002.sig"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-003"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-003.sig"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-004"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-004.sig"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-005"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-005.sig"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-006"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-006.sig"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-007"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-007.sig"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-008"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-008.sig"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-009"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-009.sig"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-010"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-010.sig"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-011"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-011.sig"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-012"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-012.sig"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-013"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-013.sig"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-014"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-014.sig"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-015"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-015.sig"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-016"
"https://ftp.gnu.org/gnu/bash/bash-$_basever-patches/bash${_basever//./}-016.sig"
)
md5sums=(
'2b44b47b905be16f45709648f671820b'
'SKIP'
'027d6bd8f5f6a06b75bb7698cb478089'
'2902e0fee7a9168f3a4fd2ccd60ff047'
'42f4400ed2314bd7519c020d0187edc5'
'd8f3f334e72c0e30032eae1a1229aef1'
'472f536d7c9e8250dc4568ec4cfaf294'
'b026862ab596a5883bb4f0d1077a3819'
'SKIP'
'2f4a7787365790ae57f36b311701ea7e'
'SKIP'
'af7f2dd93fd5429fb5e9a642ff74f87d'
'SKIP'
'b60545b273bfa4e00a760f2c648bed9c'
'SKIP'
'875a0bedf48b74e453e3997c84b5d8a4'
'SKIP'
'4a8ee95adb72c3aba03d9e8c9f96ece6'
'SKIP'
'411560d81fde2dc5b17b83c3f3b58c6f'
'SKIP'
'dd7cf7a784d1838822cad8d419315991'
'SKIP'
'c1b3e937cd6dccbb7fd772f32812a0da'
'SKIP'
'19b41e73b03602d0e261c471b53e670c'
'SKIP'
'414339330a3634137081a97f2c8615a8'
'SKIP'
'1870268f62b907221b078ad109e1fa94'
'SKIP'
'40d923af4b952b01983ed4c889ae2653'
'SKIP'
'57857b22053c8167677e5e5ac5c6669b'
'SKIP'
'c4c6ea23d09a74eaa9385438e48fdf02'
'SKIP'
'a682ed6fa2c2e7a7c3ba6bdeada07fb5'
'SKIP'
)
prepare() {
cd $pkgname-$_basever
patch -p0 -i $srcdir/bash${_basever//./}-001
patch -p0 -i $srcdir/bash${_basever//./}-002
patch -p0 -i $srcdir/bash${_basever//./}-003
patch -p0 -i $srcdir/bash${_basever//./}-004
patch -p0 -i $srcdir/bash${_basever//./}-005
patch -p0 -i $srcdir/bash${_basever//./}-006
patch -p0 -i $srcdir/bash${_basever//./}-007
patch -p0 -i $srcdir/bash${_basever//./}-008
patch -p0 -i $srcdir/bash${_basever//./}-009
patch -p0 -i $srcdir/bash${_basever//./}-010
patch -p0 -i $srcdir/bash${_basever//./}-011
patch -p0 -i $srcdir/bash${_basever//./}-012
patch -p0 -i $srcdir/bash${_basever//./}-013
patch -p0 -i $srcdir/bash${_basever//./}-014
patch -p0 -i $srcdir/bash${_basever//./}-015
patch -p0 -i $srcdir/bash${_basever//./}-016
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
	'--disable-profiling'
	'--enable-alias'
	'--enable-arith-for-command'
	'--enable-array-variables'
	'--enable-bang-history'
	'--enable-brace-expansion'
	'--enable-casemod-attributes'
	'--enable-casemod-expansions'
	'--enable-command-timing'
	'--enable-cond-command'
	'--enable-cond-regexp'
	'--enable-coprocesses'
	'--enable-debugger'
	'--enable-direxpand-default'
	'--enable-directory-stack'
	'--enable-disabled-builtins'
	'--enable-dparen-arithmetic'
	'--enable-extended-glob'
	'--enable-extended-glob-default'
	'--enable-function-import'
	'--enable-glob-asciiranges-default'
	'--enable-help-builtin'
	'--enable-history'
	'--enable-job-control'
	'--enable-multibyte'
	'--enable-net-redirections'
	'--enable-process-substitution'
	'--enable-progcomp'
	'--enable-prompt-string-decoding'
	'--enable-readline'
	'--enable-restricted'
	'--enable-select'
	'--enable-separate-helpfiles'
	'--enable-single-help-strings'
	'--disable-xpg-echo-default'
	'--without-bash-malloc'
	'--with-installed-readline=yes'
	'--with-curses=yes'
)
export CFLAGS+=" -DSYS_BASHRC='\"/etc/bash.bashrc\"' -DSYS_BASH_LOGOUT='\"/etc/bash.bash_logout\"' -DNON_INTERACTIVE_LOGIN_SHELLS"
export CXXFLAGS="${CFLAGS}"
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname-$_basever
make -k check
}
package() {
cd $pkgname-$_basever
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/system.bashrc $pkgdir/etc/bash.bashrc
install -Dm644 $srcdir/system.bash_logout $pkgdir/etc/bash.bash_logout
install -Dm644 $srcdir/dot.bashrc $pkgdir/etc/skel/.bashrc
install -Dm644 $srcdir/dot.bash_profile $pkgdir/etc/skel/.bash_profile
install -Dm644 $srcdir/dot.bash_logout $pkgdir/etc/skel/.bash_logout
ln -s bash $pkgdir/usr/bin/sh
rm -f $pkgdir/usr/lib/bash/Makefile.inc
}
