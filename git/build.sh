pkgname=('git')
pkgver=2.26.0
pkgrel=1
pkgdesc='The fast distributed version control system'
url='https://git-scm.com/'
license=('GPL2')
arch=('x86_64')
depends=(
'bash'
'curl'
'expat'
'glibc'
'grep'
'openssh'
'openssl'
'pcre2'
'perl'
'shadow'
'zlib'
)
makedepends=(
'asciidoc'
'python2'
'xmlto'
)
optdepends=(
'tk: gitk and git gui'
'perl-libwww: git svn'
'perl-term-readkey: git svn'
'perl-mime-tools: git send-email'
'perl-net-smtp-ssl: git send-email TLS support'
'perl-authen-sasl: git send-email TLS support'
'perl-mediawiki-api: git mediawiki support'
'perl-datetime-format-iso8601: git mediawiki support'
'perl-lwp-protocol-https: git mediawiki https support'
'perl-cgi: gitweb (web interface) support'
'python: git svn & git p4'
'subversion: git svn'
'org.freedesktop.secrets: keyring credential helper'
'libsecret: libsecret credential helper'
)
provides=('git-core')
replaces=('git-core')
install='git.install'
source=(
"https://www.kernel.org/pub/software/scm/$pkgname/$pkgname-$pkgver.tar.xz"
"https://www.kernel.org/pub/software/scm/$pkgname/$pkgname-$pkgver.tar.sign"
'0001-git-p4-python.patch'
'git-daemon@.service'
'git-daemon.socket'
'git-sysusers.conf'
)
sha256sums=(
'9ece0dcb07a5e0d7366a92b613b201cca11ae368ab7687041364b3e756e495d6'
'SKIP'
'0d19345aaeaeb374f8bfc30b823e8f53cb128c56b68c6504bbdd8766c03d1df9'
'14c0b67cfe116b430645c19d8c4759419657e6809dfa28f438c33a005245ad91'
'ac4c90d62c44926e6d30d18d97767efc901076d4e0283ed812a349aece72f203'
'7630e8245526ad80f703fac9900a1328588c503ce32b37b9f8811674fcda4a45'
)
prepare() {
cd $pkgname-$pkgver
patch -p1 -i $srcdir/0001-git-p4-python.patch
make configure
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
	'--enable-pthreads'
	'--with-pager=less'
	'--with-editor=mcedit'
	'--with-curl'
	'--with-expat'
	'--with-openssl'
	'--with-libpcre2'
	'--without-libpcre1'
	'--without-tcltk'
)
./configure "${config_opts[@]}"
export PYTHON_PATH=/usr/bin/python2
make all man
make -C contrib/diff-highlight
make -C contrib/subtree
make -C contrib/mw-to-git
if check_rule 'libsecret & glib2'; then
	make -C contrib/credential/libsecret
fi
if check_rule 'libgnome-keyring'; then
	make -C contrib/credential/gnome-keyring
fi
}
check() {
cd $pkgname-$pkgver
export PYTHON_PATH=/usr/bin/python2
mkdir -p /dev/shm/git-test
jobs=$(expr "$MAKEFLAGS" : '.*\(-j[0-9]*\).*') || true
SHELL=/bin/sh
make NO_SVN_TESTS=y \
DEFAULT_TEST_TARGET=prove \
GIT_PROVE_OPTS="$jobs -Q" \
GIT_TEST_OPTS="--root=/dev/shm/git-test" \
test
}
package() {
cd $pkgname-$pkgver
export PYTHON_PATH=/usr/bin/python2
make DESTDIR=$pkgdir install install-man
mkdir -p $pkgdir/usr/share/bash-completion/completions/
install -m 0644 ./contrib/completion/git-completion.bash $pkgdir/usr/share/bash-completion/completions/git
mkdir -p $pkgdir/usr/share/git/
install -m 0644 ./contrib/completion/git-prompt.sh $pkgdir/usr/share/git/git-prompt.sh
make -C contrib/subtree DESTDIR=$pkgdir install install-man
make -C contrib/mw-to-git DESTDIR=$pkgdir install
if [ -f contrib/credential/libsecret/git-credential-libsecret ]; then
	install -m 0755 contrib/credential/libsecret/git-credential-libsecret \
	$pkgdir/usr/lib/git-core
fi
if [ -f contrib/credential/gnome-keyring/git-credential-gnome-keyring ]; then
	install -m 0755 contrib/credential/gnome-keyring/git-credential-gnome-keyring \
	$pkgdir/usr/lib/git-core
fi
install -Dm644 $srcdir/git-daemon@.service $pkgdir/usr/lib/systemd/system/git-daemon@.service
install -Dm644 $srcdir/git-daemon.socket $pkgdir/usr/lib/systemd/system/git-daemon.socket
install -Dm644 $srcdir/git-sysusers.conf $pkgdir/usr/lib/sysusers.d/git.conf
cd $pkgdir
mkdir -p usr/share/perl5/vendor_perl
mv usr/share/perl5/Git* usr/share/perl5/vendor_perl
rm -fr Git
}
