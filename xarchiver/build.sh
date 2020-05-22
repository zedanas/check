pkgname=('xarchiver')
pkgver=0.5.4.14
pkgrel=1
pkgdesc='GTK+ frontend to various command line archivers'
url='https://github.com/ib/xarchiver'
license=('GPL')
arch=('x86_64')
depends=(
'bash'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
)
makedepends=(
'docbook-xsl'
'intltool'
'xmlto'
)
optdepends=(
'arj: ARJ support'
'binutils: deb support'
'bzip2: bzip2 support'
'cpio: RPM support'
'gzip: gzip support'
'lha: LHA support'
'lrzip: lrzip support'
'lz4: LZ4 support'
'lzip: lzip support'
'lzop: LZOP support'
'p7zip: 7z support'
'tar: tar support'
'unarj: ARJ support'
'unrar: RAR support'
'unzip: ZIP support'
'xz: xz support'
'zip: ZIP support'
'zstd: zstd support'
)
source=(
"$pkgbase-$pkgver.tar.gz::https://github.com/ib/$pkgname/archive/$pkgver.tar.gz"
'xarchiver.appdata.xml'
)
sha256sums=(
'335bed86e10a1428d54196edf5c828e79ceed05049e83896114aa46f0a950a2f'
'55f41aa0e5569b446933a34ac0585443fa5bd92f03f47e1fd53daf19905cc97e'
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
	'--libexecdir=/usr/lib/xfce4'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--disable-debug'
	'--enable-debug=no'
	'--enable-doc'
	'--enable-icons'
	'--enable-plugin'
	'--disable-gtk2'
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
install -Dm644 $srcdir/$pkgname.appdata.xml $pkgdir/usr/share/metainfo/$pkgname.appdata.xml
}
