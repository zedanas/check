pkgname=('cairo')
pkgver=1.17.3
pkgrel=2
pkgdesc='2D graphics library with support for multiple output devices'
url='https://cairographics.org/'
license=('LGPL' 'MPL')
arch=('x86_64')
depends=(
'fontconfig'
'freetype2'
'glib2'
'glibc'
'libglvnd'
'libpng'
'libx11'
'libxcb'
'libxrender'
'lzo'
'pixman'
'zlib'
)
makedepends=(
'git'
'gtk-doc'
'librsvg'
'libspectre'
'poppler-glib'
'gtk2'
)
checkdepends=(
'gsfonts'
'ttf-dejavu'
)
source=(
'0001-image-compositor-Remove-the-right-glyph-from-pixman-.patch'
)
sha256sums=(
'SKIP'
'262bf1cebc04eaae93dbfab56045ad800b3b027be303ca2611375645108f171f'
)
prepare() {
cd $pkgname
patch -Np1 -i $srcdir/0001-image-compositor-Remove-the-right-glyph-from-pixman-.patch
cp /usr/share/aclocal/gtk-doc.m4 build/aclocal.gtk-doc.m4
cp /usr/share/gtk-doc/data/gtk-doc.make build/Makefile.am.gtk-doc
sed -i 's/have_png/use_png/g' configure.ac
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname
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
	'--disable-full-testing'
	'--disable-valgrind'
	'--disable-gtk-doc'
	'--enable-atomic'
	'--enable-full-testing'
	'--enable-pthread=yes'
	'--enable-trace=no'
	'--enable-symbol-lookup=auto'
	'--enable-test-surfaces=yes'
	'--enable-tee=yes'
	'--with-x'
	'--enable-cogl=no'
	'--enable-directfb=no'
	'--enable-fc=yes'
	'--enable-ft=yes'
	'--enable-gobject=yes'
	'--enable-drm=no'
	'--enable-gl=yes'
	'--enable-egl=yes'
	'--enable-glx=yes'
	'--enable-png=yes'
	'--enable-svg=yes'
	'--enable-ps=yes'
	'--enable-xlib-xcb=yes'
	'--enable-xlib=yes'
	'--enable-xcb=yes'
	'--enable-xcb-shm=yes'
	'--enable-xlib-xrender=yes'
	'--enable-interpreter=yes'
	'--enable-gallium=no'
	'--enable-pdf=yes'
	'--enable-script=yes'
	'--enable-xml=yes'
)
./configure "${config_opts[@]}"
if [ -f libtool ]; then
	sed -e "s/ -shared / $LDFLAGS\0/g" -i libtool
fi
make
}
package() {
cd $pkgname
make DESTDIR=$pkgdir install
}
