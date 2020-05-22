pkgname=('easytag')
pkgver=2.4.3
pkgrel=2
pkgdesc='Simple application for viewing and editing tags in audio files'
url='https://wiki.gnome.org/Apps/EasyTAG'
license=('GPL')
arch=('x86_64')
depends=(
'flac'
'gcc-libs'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'id3lib'
'libid3tag'
'libogg'
'libvorbis'
)
makedepends=(
'docbook-xsl'
'intltool'
'itstool'
'python'
)
source=("https://download.gnome.org/sources/$pkgname/${pkgver:0:3}/$pkgname-$pkgver.tar.xz")
sha256sums=('fc51ee92a705e3c5979dff1655f7496effb68b98f1ada0547e8cbbc033b67dd5')
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
	'--enable-tests'
	'--disable-schemas-compile'
	'--enable-man'
	'--enable-flac'
	'--enable-id3v23'
	'--enable-mp3'
	'--disable-nautilus-actions'
	'--enable-ogg'
	'--disable-opus'
	'--disable-speex'
	'--disable-mp4'
	'--disable-wavpack'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
check() {
cd $pkgname-$pkgver
make -k check
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
}
