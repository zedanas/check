pkgbase='transmission'
pkgname=('transmission-cli' 'transmission-gtk')
pkgver=2.94
pkgrel=2
url='http://www.transmissionbt.com/'
license=('MIT')
arch=('x86_64')
makedepends=(
'curl'
'gtk3'
'intltool'
'libevent'
'systemd'
)
source=(
"https://github.com/$pkgbase/$pkgbase-releases/raw/master/$pkgbase-$pkgver.tar.xz"
'transmission-2.90-libsystemd.patch'
'transmission-cli.sysusers'
'transmission-cli.tmpfiles'
)
sha256sums=(
'35442cc849f91f8df982c3d0d479d650c6ca19310a994eccdaa79a4af3916b7d'
'9f8f4bb532e0e46776dbd90e75557364f495ec95896ee35900ea222d69bda411'
'641310fb0590d40e00bea1b5b9c843953ab78edf019109f276be9c6a7bdaf5b2'
'1266032bb07e47d6bcdc7dabd74df2557cc466c33bf983a5881316a4cc098451'
)
prepare() {
cd $pkgbase-$pkgver
patch -p1 -i $srcdir/transmission-2.90-libsystemd.patch
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
	'--enable-nls'
	'--enable-utp'
	'--enable-cli'
	'--with-gtk'
	'--with-inotify'
	'--with-systemd-daemon'
	'--enable-daemon'
	'--with-crypto=openssl'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package_transmission-cli() {
pkgdesc='Fast, easy, and free BitTorrent client (CLI tools, daemon and web client)'
depends=(
	'curl'
	'glibc'
	'libevent'
	'openssl'
	'systemd-libs'
	'zlib'
)
cd $pkgbase-$pkgver
make DESTDIR=$pkgdir install
install -Dm644 daemon/transmission-daemon.service \
$pkgdir/usr/lib/systemd/system/transmission.service
install -Dm644 $srcdir/transmission-cli.sysusers \
$pkgdir/usr/lib/sysusers.d/transmission.conf
install -Dm644 $srcdir/transmission-cli.tmpfiles \
$pkgdir/usr/lib/tmpfiles.d/transmission.conf
install -Dm644 COPYING $pkgdir/usr/share/licenses/transmission-cli/COPYING
cd $pkgdir
mkdir -p $srcdir/transmission-gtk/usr/{bin,share/man/man1}
mv usr/bin/transmission-gtk $srcdir/transmission-gtk/usr/bin || true
mv usr/share/man/man1/transmission-gtk*	$srcdir/transmission-gtk/usr/share/man/man1 || true
mv usr/share/applications $srcdir/transmission-gtk/usr/share || true
mv usr/share/icons $srcdir/transmission-gtk/usr/share || true
mv usr/share/locale $srcdir/transmission-gtk/usr/share || true
mv usr/share/pixmaps $srcdir/transmission-gtk/usr/share || true
}
package_transmission-gtk() {
pkgdesc='Fast, easy, and free BitTorrent client (GTK+ GUI)'
depends=(
	'curl'
	'desktop-file-utils'
	'gdk-pixbuf2'
	'glib2'
	'glibc'
	'gtk3'
	'hicolor-icon-theme'
	'libevent'
	'openssl'
	'pango'
	'zlib'
)
optdepends=(
	'libnotify: Desktop notification support'
	'transmission-cli: daemon and web support'
)
cd $pkgbase-$pkgver
mv $srcdir/transmission-gtk/* $pkgdir
install -Dm644 COPYING $pkgdir/usr/share/licenses/transmission-gtk/COPYING
}
