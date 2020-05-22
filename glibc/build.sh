pkgname=('glibc')
pkgver=2.31
pkgrel=2
pkgdesc='GNU C Library'
url='https://www.gnu.org/software/libc'
license=('GPL' 'LGPL')
arch=('x86_64')
groups=('base')
depends=(
'filesystem'
'linux-api-headers>=4.10'
'tzdata'
)
makedepends=(
'git'
'python'
)
backup=(
'etc/gai.conf'
'etc/locale.gen'
'etc/nscd.conf'
)
options=('emptydirs' 'staticlibs')
install='glibc.install'
_commit='a6aaabd036d735a1b412f441bf6c706832655598'
source=(
"https://ftp.gnu.org/gnu/glibc/glibc-$pkgver.tar.xz"
"https://ftp.gnu.org/gnu/glibc/glibc-$pkgver.tar.xz.sig"
'locale.gen.txt'
'locale-gen'
'lib32-glibc.conf'
'sdt.h'
'sdt-config.h'
'bz20338.patch'
)
md5sums=(
'78a720f17412f3c3282be5a6f3363ec6'
'SKIP'
'07ac979b6ab5eeb778d55f041529d623'
'476e9113489f93b348b21e144b6a8fcf'
'6e052f1cb693d5d3203f50f9d4e8c33b'
'91fec3b7e75510ae2ac42533aa2e695e'
'680df504c683640b02ed4a805797c0b2'
'430673eccc78e52c249aa4b0f1786450'
)
prepare() {
cd $pkgname-$pkgver
patch -p1 -i $srcdir/bz20338.patch
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
	'--disable-werror'
	'--disable-profile'
	'--disable-multi-arch'
	'--enable-sanity-checks'
	'--enable-timezone-tools'
	'--enable-hidden-plt'
	'--enable-pt_chown'
	'--enable-stackguard-randomization'
	'--enable-stack-protector=strong'
	'--enable-lock-elision=yes'
	'--enable-tunables=yes'
	'--enable-add-ons'
	'--enable-bind-now'
	'--enable-static-pie'
	'--enable-mathvec'
	'--enable-crypt'
	'--enable-cet'
	'--enable-nscd'
	'--enable-build-nscd'
	'--with-headers=/usr/include'
	'--with-bugurl=https://bugs.archlinux.org'
	'--without-gd'
	'--without-selinux'
	'--disable-nss-crypt'
)
mkdir -p build && cd build
echo "slibdir=/usr/lib" >> configparms
echo "rtlddir=/usr/lib" >> configparms
echo "sbindir=/usr/bin" >> configparms
echo "rootsbindir=/usr/bin" >> configparms
export CPPFLAGS=${CPPFLAGS/-D_FORTIFY_SOURCE=2/}
export CFLAGS=${CFLAGS/-fno-plt/}
export CXXFLAGS=${CXXFLAGS/-fno-plt/}
export LDFLAGS=${LDFLAGS/,-z,now/}
export CFLAGS+=' -fno-lto'
export CXXFLAGS+=' -fno-lto'
../configure "${config_opts[@]}"
make
}
check() {
cd $pkgname-$pkgver/build
make -k check
}
package() {
cd $pkgname-$pkgver/build
make DESTDIR=$pkgdir install
install -dm755 $pkgdir/var/db/nscd
install -Dm644 ../nscd/nscd.conf $pkgdir/etc/nscd.conf
install -Dm644 ../nscd/nscd.service $pkgdir/usr/lib/systemd/system/nscd.service
install -Dm644 ../nscd/nscd.tmpfiles $pkgdir/usr/lib/tmpfiles.d/nscd.conf
install -Dm644 ../posix/gai.conf $pkgdir/etc/gai.conf
install -dm755 $pkgdir/usr/lib/locale
install -Dm644 $srcdir/locale.gen.txt $pkgdir/etc/locale.gen
install -Dm755 $srcdir/locale-gen $pkgdir/usr/bin/locale-gen
install -Dm644 $srcdir/sdt.h $pkgdir/usr/include/sys/sdt.h
install -Dm644 $srcdir/sdt-config.h $pkgdir/usr/include/sys/sdt-config.h
sed	-e '1,3d' \
	-e 's|/| |g' \
	-e 's|\\| |g' \
	../localedata/SUPPORTED >> $pkgdir/etc/locale.gen
rm -f $pkgdir/etc/ld.so.{cache,conf}
rm -f $pkgdir/usr/bin/{tzselect,zdump,zic}
}
