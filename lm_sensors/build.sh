pkgname=('lm_sensors')
pkgver=3.6.0
pkgrel=1
pkgdesc='Collection of user space tools for general SMBus access and hardware monitoring'
url='https://hwmon.wiki.kernel.org/lm_sensors'
license=('GPL' 'LGPL')
arch=('x86_64')
depends=(
'bash'
'glibc'
'perl'
)
makedepends=(
'git'
'sed'
)
optdepends=('rrdtool: for logging with sensord')
backup=(
'etc/conf.d/sensord'
'etc/healthd.conf'
'etc/sensors3.conf'
)
options=('emptydirs')
source=(
"https://github.com/${pkgname//_/-}/${pkgname//_/-}/archive/V${pkgver//./-}.tar.gz"
'healthd'
'healthd.conf'
'healthd.service'
'sensord.conf'
)
sha256sums=(
'0591f9fa0339f0d15e75326d0365871c2d4e2ed8aa1ff759b3a55d3734b7d197'
'0ac9afb2a9155dd74ab393756ed552cd542dde1081149beb2ab4ec7ff55b8f4a'
'5d17a366b175cf9cb4bb0115c030d4b8d91231546f713784a74935b6e533da9f'
'2638cd363e60f8d36bcac468f414a6ba29a1b5599f40fc651ca953858c8429d7'
'23bebef4c250f8c0aaba2c75fd3d2c8ee9473cc91a342161a9f5b3a34ddfa9e5'
)
prepare() {
cd lm-sensors-${pkgver//./-}
sed -e 's|/etc/sysconfig|/etc/conf.d|' -i prog/{detect/sensors-detect,init/{sensord,lm_sensors}.service}
sed -e 's/EnvironmentFile=/EnvironmentFile=-/' -i prog/init/lm_sensors.service
sed -e "s/-O2/$CFLAGS/" -i Makefile
sed -e "s/EXLDFLAGS :=/EXLDFLAGS := $LDFLAGS /g" -i Makefile
}
build() {
cd lm-sensors-${pkgver//./-}
make PREFIX=/usr
}
package() {
cd lm-sensors-${pkgver//./-}
make PREFIX=/usr SBINDIR=/usr/bin MANDIR=/usr/share/man DESTDIR=$pkgdir install
install -Dm755 $srcdir/healthd $pkgdir/usr/bin/healthd
install -Dm644 $srcdir/healthd.conf $pkgdir/etc/healthd.conf
install -Dm644 $srcdir/sensord.conf $pkgdir/etc/conf.d/sensord
install -Dm644 $srcdir/healthd.service $pkgdir/usr/lib/systemd/system/healthd.service
install -Dm644 prog/init/*.service $pkgdir/usr/lib/systemd/system/
install -Dm644 COPYING $pkgdir/usr/share/licenses/lm_sensors/LICENSE
}
