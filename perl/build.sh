pkgname=('perl')
pkgver=5.30.2
pkgrel=1
pkgdesc='A highly capable, feature-rich programming language'
url='https://www.perl.org'
license=('GPL' 'PerlArtistic')
arch=('x86_64')
groups=('base')
depends=(
'bash'
'db'
'gdbm>=1.17'
'glibc'
)
provides=(
'perl-archive-tar=2.32'
'perl-attribute-handlers=1.01'
'perl-autodie=2.29'
'perl-autoloader=5.74'
'perl-autouse=1.11'
'perl-base=2.27'
'perl-bignum=0.51'
'perl-carp=1.50'
'perl-compress-raw-bzip2=2.089'
'perl-compress-raw-zlib=2.084'
'perl-config-perl-v=0.32'
'perl-constant=1.33'
'perl-cpan-meta-requirements=2.140'
'perl-cpan-meta-yaml=0.018'
'perl-cpan-meta=2.150010'
'perl-cpan=2.22'
'perl-data-dumper=2.174'
'perl-db_file=1.843'
'perl-devel-ppport=3.52'
'perl-devel-selfstubber=1.06'
'perl-digest-md5=2.55'
'perl-digest-sha=6.02'
'perl-digest=1.17_01'
'perl-dumpvalue=1.18'
'perl-encode=3.01'
'perl-encoding-warnings=0.13'
'perl-env=1.04'
'perl-experimental=0.020'
'perl-exporter=5.73'
'perl-extutils-cbuilder=0.280231'
'perl-extutils-constant=0.25'
'perl-extutils-install=2.14'
'perl-extutils-makemaker=7.34'
'perl-extutils-manifest=1.72'
'perl-extutils-parsexs=3.40'
'perl-file-fetch=0.56'
'perl-file-path=2.16'
'perl-file-temp=0.2309'
'perl-filter-simple=0.95'
'perl-filter-util-call=1.59'
'perl-getopt-long=2.5'
'perl-http-tiny=0.076'
'perl-i18n-collate=1.02'
'perl-i18n-langtags=0.43'
'perl-if=0.0608'
'perl-io-compress=2.084'
'perl-io-socket-ip=0.39'
'perl-io-zlib=1.10'
'perl-io=1.40'
'perl-ipc-cmd=1.02'
'perl-ipc-sysv=2.07'
'perl-json-pp=4.02'
'perl-lib=0.65'
'perl-libnet=3.11'
'perl-locale-maketext-simple=0.21_01'
'perl-locale-maketext=1.29'
'perl-math-bigint-fastcalc=0.5008'
'perl-math-bigint=1.999816'
'perl-math-bigrat=0.2614'
'perl-math-complex=1.5901'
'perl-memoize=1.03_01'
'perl-mime-base64=3.15'
'perl-module-corelist=5.20200314'
'perl-module-load-conditional=0.68'
'perl-module-load=0.34'
'perl-module-loaded=0.08'
'perl-module-metadata=1.000036'
'perl-net-ping=2.71'
'perl-params-check=0.38'
'perl-parent=0.237'
'perl-pathtools=3.78'
'perl-perl-ostype=1.010'
'perl-perlfaq=5.20190126'
'perl-perlio-via-quotedprint=0.08'
'perl-pod-checker=1.73'
'perl-pod-escapes=1.07'
'perl-pod-parser=1.63'
'perl-pod-perldoc=3.2801'
'perl-pod-simple=3.35'
'perl-pod-usage=1.69'
'perl-podlators=5.006'
'perl-safe=2.40'
'perl-scalar-list-utils=1.50'
'perl-search-dict=1.07'
'perl-selfloader=1.25'
'perl-socket=2.027'
'perl-storable=3.15'
'perl-sys-syslog=0.35'
'perl-term-ansicolor=4.06'
'perl-term-cap=1.17'
'perl-term-complete=1.403'
'perl-term-readline=1.17'
'perl-test-harness=3.42'
'perl-test-simple=1.302162'
'perl-test=1.31'
'perl-text-abbrev=1.02'
'perl-text-balanced=2.03'
'perl-text-parsewords=3.30'
'perl-text-tabs=2013.0523'
'perl-thread-queue=3.13'
'perl-thread-semaphore=2.13'
'perl-threads-shared=1.60'
'perl-threads=2.22'
'perl-tie-file=1.02'
'perl-tie-refhash=1.39'
'perl-time-hires=1.9760'
'perl-time-local=1.28'
'perl-time-piece=1.33'
'perl-unicode-collate=1.27'
'perl-unicode-normalize=1.26'
'perl-version=0.9924'
'perl-xsloader=0.30'
)
options=('emptydirs')
source=(
"https://www.cpan.org/src/5.0/$pkgname-$pkgver.tar.xz"
'perlbin.sh'
'perlbin.csh'
'perlbin.fish'
'detect-old-perl-modules.sh'
'detect-old-perl-modules.hook'
)
sha512sums=(
'b945c95f44a58b9cc920c926e23017c4270c0dc8daf0bf8169cd7c8f6b8f980f1780bee4fbd525df518edc50f08364ba65988cb17e72a1667f50226459b65087'
'b7678078d64cc593a3503c45f023c49915d0d703f1cea8282f4191f1e3aa62764cc6cfcae3dc3828101415b8e15d5ed8b1b79d423ef387550ae33172b0de92bc'
'53eb0cddfd637014f3d3a101665db8dcafe5ac5bf3d319a259974334eb89c1c405097518ae96b6d18e520194633c7be57c9b2cd9ae6398443eb08f1a2008d112'
'881e2efe05ba818cd7300f126800b56bb0685cb5c9c5fb7e67ef6aaf5abd17d2391a979d5d16d109c5111f4b35504ba83d19b0e6eda4431e8421fcbea19d2f1a'
'bd48af7a6209f2ad51aa1747a7238ecb11607a53f61460d873202bf14b55c3b7dd6f66f4a9f2cac8a24240313789a9a44dbc81b73587de46a6b1866bdfca5e26'
'6b5b2ba606d443da22c6c1a754829abd36f3fdfef1089bcf06c8f9db0217f2c2f02ebc14958ffa7afe618c9a80bd1025e76704f67466c0c3db7d40ef2c0e56b3'
)
build() {
cd $pkgname-$pkgver
config_opts=(
	'-des'
	"-Dcppflags=$CPPFLAGS"
	"-Dccflags=$CFLAGS"
	"-Dcccdlflags=-fPIC"
	"-Doptimize=$CFLAGS"
	"-Dldflags=$LDFLAGS"
	"-Dlddlflags=$LDFLAGS -shared"
	'-DEBUGGING=none'
	'-Dusemorebits'
	'-Dusethreads'
	'-Duseshrplib'
	'-Dman1ext=1p'
	'-Dman3ext=3pm'
	'-Dinc_version_list=none'
	'-Dprefix=/usr'
	'-Dsiteprefix=/usr'
	'-Dvendorprefix=/usr'
	'-Dbin=/usr/bin'
	'-Dsitebin=/usr/bin'
	'-Dvendorbin=/usr/bin'
	'-Dscriptdir=/usr/bin/core_perl'
	'-Dsitescript=/usr/bin/site_perl'
	'-Dvendorscript=/usr/bin/vendor_perl'
	'-Dprivlib=/usr/share/perl5/core_perl'
	'-Dsitelib=/usr/share/perl5/site_perl'
	'-Dvendorlib=/usr/share/perl5/vendor_perl'
	"-Darchlib=/usr/lib/perl5/${pkgver%.*}/core_perl"
	"-Dsitearch=/usr/lib/perl5/${pkgver%.*}/site_perl"
	"-Dvendorarch=/usr/lib/perl5/${pkgver%.*}/vendor_perl"
)
./Configure "${config_opts[@]}"
make
}
check() {
cd $pkgname-$pkgver
make test
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/perlbin.sh $pkgdir/etc/profile.d/perlbin.sh
install -Dm644 $srcdir/perlbin.csh $pkgdir/etc/profile.d/perlbin.csh
install -Dm755 $srcdir/perlbin.fish $pkgdir/usr/share/fish/vendor_conf.d/perlbin.fish
install -Dm755 $srcdir/detect-old-perl-modules.sh $pkgdir/usr/share/libalpm/scripts/detect-old-perl-modules.sh
install -Dm644 $srcdir/detect-old-perl-modules.hook $pkgdir/usr/share/libalpm/hooks/detect-old-perl-modules.hook
mkdir -p $pkgdir/usr/bin/site_perl
mkdir -p $pkgdir/usr/bin/vendor_perl
sed	-e '/^man1ext=/ s/1perl/1p/' \
	-e '/^man3ext=/ s/3perl/3pm/' \
	-e "/^cf_email=/ s/'.*'/''/" \
	-e "/^perladmin=/ s/'.*'/''/" \
	-i $pkgdir/usr/lib/perl5/${pkgver%.*}/core_perl/Config_heavy.pl
sed -e '/(makepl_arg =>/   s/""/"INSTALLDIRS=site"/' \
	-e '/(mbuildpl_arg =>/ s/""/"installdirs=site"/' \
	-i $pkgdir/usr/share/perl5/core_perl/CPAN/FirstTime.pm
rm $pkgdir/usr/bin/perl$pkgver
find $pkgdir -name perllocal.pod -delete
find $pkgdir -name .packlist -delete
}
