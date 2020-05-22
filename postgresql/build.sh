pkgbase='postgresql'
pkgname=('postgresql' 'postgresql-libs')
pkgver=12.2
pkgrel=1
pkgdesc='Sophisticated object-relational DBMS'
url='https://www.postgresql.org/'
license=('custom:PostgreSQL')
arch=('x86_64')
makedepends=(
'clang'
'gcc-libs'
'icu'
'krb5'
'libldap'
'libutil-linux'
'libxml2'
'libxslt'
'llvm'
'openssl'
'pam'
'perl'
'python'
'readline'
'systemd'
'tcl'
'zlib'
)
source=(
"https://ftp.postgresql.org/pub/source/v${pkgver}/$pkgbase-$pkgver.tar.bz2"
'postgresql-run-socket.patch'
'postgresql-perl-rpath.patch'
'postgresql.pam'
'postgresql.service'
'postgresql-check-db-dir'
'postgresql.sysusers'
'postgresql.tmpfiles'
)
sha256sums=(
'ad1dcc4c4fc500786b745635a9e1eba950195ce20b8913f50345bb7d5369b5de'
'8538619cb8bea51078b605ad64fe22abd6050373c7ae3ad6595178da52f6a7d9'
'5f73b54ca6206bd2c469c507830261ebd167baca074698d8889d769c33f98a31'
'57dfd072fd7ef0018c6b0a798367aac1abb5979060ff3f9df22d1048bb71c0d5'
'25fb140b90345828dc01a4f286345757e700a47178bab03d217a7a5a79105b57'
'bb24b8ce8c69935b7527ed54e10a8823068e31c8aa5b8ffea81ce6993264e8db'
'7fa8f0ef3f9d40abd4749cc327c2f52478cb6dfb6e2405bd0279c95e9ff99f12'
'4a4c0bb9ceb156cc47e9446d8393d1f72b4fe9ea1d39ba17213359df9211da57'
)
prepare() {
cd $pkgname-$pkgver
patch -p1 -i $srcdir/postgresql-run-socket.patch
patch -p1 -i $srcdir/postgresql-perl-rpath.patch
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgbase-$pkgver
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
	'--enable-spinlocks'
	'--enable-atomics'
	'--enable-thread-safety'
	'--disable-profiling'
	'--disable-debug'
	'--disable-cassert'
	'--disable-tap-tests'
	'--disable-depend'
	'--enable-float4-byval'
	'--enable-float8-byval'
	'--with-uuid=e2fs'
	'--with-system-tzdata=/usr/share/zoneinfo'
	'--with-icu'
	'--without-gssapi'
	'--without-ldap'
	'--without-selinux'
	'--with-libxml'
	'--with-libxslt'
	'--with-llvm'
	'--with-openssl'
	'--with-pam'
	'--with-perl'
	'--without-python'
	'--with-readline'
	'--with-systemd'
	'--without-tcl'
	'--with-zlib'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package_postgresql() {
pkgdesc='Sophisticated object-relational DBMS'
depends=(
	"postgresql-libs>=${pkgver}"
	'gcc-libs'
	'glibc'
	'icu'
	'libutil-linux'
	'libxml2'
	'libxslt'
	'llvm-libs'
	'openssl>=1.0.0'
	'pam'
	'perl'
	'sh'
	'systemd-libs'
	'zlib'
)
optdepends=('postgresql-old-upgrade: upgrade from previous major version using pg_upgrade')
backup=('etc/pam.d/postgresql')
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
make -C contrib DESTDIR=$pkgdir install
make -C doc/src/sgml DESTDIR=$pkgdir install-man
install -Dm 755 $srcdir/postgresql-check-db-dir $pkgdir/usr/bin/postgresql-check-db-dir
install -Dm 644 $srcdir/postgresql.pam $pkgdir/etc/pam.d/postgresql
install -Dm 644 $srcdir/postgresql.service $pkgdir/usr/lib/systemd/system/postgresql.service
install -Dm 644 $srcdir/postgresql.sysusers $pkgdir/usr/lib/sysusers.d/postgresql.conf
install -Dm 644 $srcdir/postgresql.tmpfiles $pkgdir/usr/lib/tmpfiles.d/postgresql.conf
cd $pkgdir
mkdir -p $srcdir/postgresql-libs/usr/{bin,include/postgresql,lib,share/{man/man1,postgresql}}
for util in clusterdb createdb createuser dropdb dropuser ecpg pg_config pg_dump pg_dumpall pg_isready pg_restore psql reindexdb vacuumdb
do
	mv usr/bin/$util $srcdir/postgresql-libs/usr/bin || true
	mv usr/share/man/man1/$util.1 $srcdir/postgresql-libs/usr/share/man/man1/ || true
done
mv usr/include/*.h $srcdir/postgresql-libs/usr/include || true
mv usr/include/libpq $srcdir/postgresql-libs/usr/include/ || true
mv usr/include/postgresql/informix $srcdir/postgresql-libs/usr/include/postgresql/ || true
mv usr/include/postgresql/internal $srcdir/postgresql-libs/usr/include/postgresql/ || true
mv usr/lib/pkgconfig $srcdir/postgresql-libs/usr/lib/ || true
mv usr/lib/*.so* $srcdir/postgresql-libs/usr/lib || true
mv usr/share/postgresql/pg_service.conf.sample $srcdir/postgresql-libs/usr/share/postgresql || true
mv usr/share/postgresql/psqlrc.sample $srcdir/postgresql-libs/usr/share/postgresql || true
rmdir usr/share/doc/postgresql/html
}
package_postgresql-libs() {
pkgdesc='Libraries for use with PostgreSQL'
depends=(
	'glibc'
	'openssl>=1.0.0'
	'readline>=6.0'
	'zlib'
)
provides=('postgresql-client')
conflicts=('postgresql-client')
mv $srcdir/postgresql-libs/* $pkgdir
}
