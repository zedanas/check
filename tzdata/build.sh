pkgname=('tzdata')
pkgver=2019c
pkgrel=3
pkgdesc='Sources for time zone and daylight saving time data'
url='http://www.iana.org/time-zones'
license=('custom: public domain')
arch=('x86_64')
depends=(
'bash'
'glibc'
)
source=(
"https://www.iana.org/time-zones/repository/releases/tzcode${pkgver}.tar.gz"
"https://www.iana.org/time-zones/repository/releases/tzcode${pkgver}.tar.gz.asc"
"https://www.iana.org/time-zones/repository/releases/tzdata${pkgver}.tar.gz"
"https://www.iana.org/time-zones/repository/releases/tzdata${pkgver}.tar.gz.asc"
)
sha512sums=(
'61ef36385f501c338c263081486de0d1fccd454b86f8777b0dbad4ea3f21bbde059d0a91c23e207b167ed013127d3db8b7528f0188814a8b44d1f946b19d9b8b'
'SKIP'
'2921cbb2fd44a6b8f7f2ed42c13fbae28195aa5c2eeefa70396bc97cdbaad679c6cc3c143da82cca5b0279065c02389e9af536904288c12886bf345baa8c6565'
'SKIP'
)
prepare() {
cd $srcdir
sed -i "s:sbin:bin:g" Makefile
}
package() {
timezones=(
	'africa'
	'antarctica'
	'asia'
	'australasia'
	'backward'
	'etcetera'
	'europe'
	'factory'
	'northamerica'
	'pacificnew'
	'southamerica'
	'systemv'
)
cd $srcdir
make LFLAGS=$LDFLAGS DESTDIR=$pkgdir install
zic -y ./yearistype -d $pkgdir/usr/share/zoneinfo ${timezones[@]}
zic -y ./yearistype -d $pkgdir/usr/share/zoneinfo/posix ${timezones[@]}
zic -y ./yearistype -d $pkgdir/usr/share/zoneinfo/right -L leapseconds ${timezones[@]}
zic -y ./yearistype -d $pkgdir/usr/share/zoneinfo -p America/New_York
install -m444 -t $pkgdir/usr/share/zoneinfo iso3166.tab zone1970.tab zone.tab
rm -f $pkgdir/etc/localtime
install -Dm644 LICENSE $pkgdir/usr/share/licenses/tzdata/LICENSE
}
