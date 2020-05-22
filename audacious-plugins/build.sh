pkgname=('audacious-plugins')
pkgver=3.10.1
pkgrel=4
pkgdesc='Plugins for Audacious'
url='https://audacious-media-player.org/'
license=('BSD' 'GPL')
arch=('x86_64')
depends=(
"audacious>=$pkgver"
'alsa-lib'
'cairo'
'curl'
'faad2'
'ffmpeg'
'flac'
'gcc-libs'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk2'
'lame'
'libglvnd'
'libnotify'
'libogg'
'libpulse'
'libsndfile'
'libvorbis'
'libx11'
'libxcomposite'
'libxml2'
'libxrender'
'pango'
'pulseaudio'
'zlib'
)
makedepends=('python')
source=("https://distfiles.audacious-media-player.org/audacious-plugins-$pkgver.tar.bz2")
sha256sums=('eec3177631f99729bf0e94223b627406cc648c70e6646e35613c7b55040a2642')
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
	'--disable-oss4'
	'--enable-console'
	'--enable-mpris2'
	'--enable-songchange'
	'--enable-filewriter'
	'--disable-qt'
	'--disable-adplug'
	'--enable-alsa'
	'--enable-scrobbler2'
	'--enable-aac'
	'--with-ffmpeg=ffmpeg'
	'--enable-flac'
	'--disable-amidiplug'
	'--enable-gtk'
	'--disable-jack'
	'--enable-filewriter_mp3'
	'--disable-bs2b'
	'--disable-cdaudio'
	'--disable-cue'
	'--enable-glspectrum'
	'--disable-mms'
	'--disable-modplug'
	'--enable-notify'
	'--enable-pulse'
	'--disable-resample'
	'--disable-speedpitch'
	'--disable-sid'
	'--enable-sndfile'
	'--disable-soxr'
	'--enable-vorbis'
	'--enable-hotkey'
	'--enable-aosd'
	'--with-system-libxml2=yes'
	'--disable-lirc'
	'--disable-mpg123'
	'--disable-neon'
	'--disable-sdlout'
	'--disable-sdlout'
	'--disable-sndio'
	'--disable-wavpack'
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
install -Dm644 COPYING $pkgdir/usr/share/licenses/audacious-plugins/LICENSE
}
