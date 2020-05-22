pkgname=('smartmontools')
pkgver=7.1
pkgrel=1
pkgdesc='Control and monitor S.M.A.R.T. enabled ATA and SCSI Hard Drives'
url='http://smartmontools.sourceforge.net'
license=('GPL')
arch=('x86_64')
depends=(
'gcc-libs'
'glibc'
'libcap-ng'
'systemd-libs'
'sh'
)
optdepends=('s-nail: to get mail alerts to work')
backup=(
'etc/conf.d/smartd'
'etc/smartd.conf'
)
options=('emptydirs')
source=(
"https://downloads.sourceforge.net/sourceforge/$pkgname/$pkgname-$pkgver.tar.gz"
"https://downloads.sourceforge.net/sourceforge/$pkgname/$pkgname-$pkgver.tar.gz.asc"
'smartd.conf'
)
sha256sums=(
'3f734d2c99deb1e4af62b25d944c6252de70ca64d766c4c7294545a2e659b846'
'SKIP'
'c2c0f2f6b4a3f3d76da1c7706139297aef6e3f2a705eb7fdd800544812427c74'
)
prepare() {
cd $pkgname-$pkgver
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
	'--disable-sample'
	'--enable-fast-lebe'
	'--enable-scsi-cdb-check'
	'--with-nvme-devicescan=yes'
	'--with-update-smart-drivedb=yes'
	'--with-savestates=yes'
	'--with-attributelog=yes'
	'--with-working-snprintf=yes'
	'--with-signal-func=sigaction'
	'--with-cxx11-option=auto'
	'--with-cxx11-regex=no'
	'--with-drivedbdir=yes'
	'--with-initscriptdir=no'
	'--with-smartdscriptdir=/usr/share/smartmontools'
	'--with-smartdplugindir=/usr/share/smartmontools/smartd_warning.d'
	'--with-gnupg=yes'
	'--with-libcap-ng=yes'
	'--with-selinux=no'
	'--with-libsystemd=yes'
	'--with-systemdenvfile=yes'
	'--with-systemdsystemunitdir=yes'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname-$pkgver
sed	-e 's:/etc/default/smartmontools:/etc/conf.d/smartd:g' \
	-e 's:smartd_opts:SMARTD_ARGS:g' \
	-i smartd.service
make DESTDIR=$pkgdir install
install -Dm644 $srcdir/smartd.conf $pkgdir/etc/conf.d/smartd
}
