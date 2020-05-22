pkgname=('grub')
pkgver=2.04
pkgrel=5
epoch=2
pkgdesc='GNU GRand Unified Bootloader (2)'
url='https://www.gnu.org/software/grub/'
license=('GPL3')
arch=('x86_64')
depends=(
'device-mapper'
'freetype2'
'glibc'
'sh'
'xz'
)
makedepends=(
'autogen'
'gettext'
'git'
'help2man'
'python'
'rsync'
'texinfo'
'ttf-dejavu'
)
optdepends=(
'dosfstools: For grub-mkrescue FAT FS and EFI support'
'efibootmgr: For grub-install EFI support'
'libisoburn: Provides xorriso for generating grub rescue iso using grub-mkrescue'
'mtools: For grub-mkrescue FAT FS support'
'os-prober: To detect other OSes when generating grub.cfg in BIOS systems'
)
provides=(
"grub-efi-x86_64"
'grub-bios'
'grub-common'
'grub-emu'
)
conflicts=(
"grub-efi-x86_64"
'grub-bios'
'grub-common'
'grub-emu'
'grub-legacy'
)
replaces=(
"grub-efi-x86_64"
'grub-bios'
'grub-common'
'grub-emu'
)
backup=(
'etc/default/grub'
'etc/grub.d/40_custom'
)
install='grub.install'
_commit='8a245d5c1800627af4cefa99162a89c7a46d8842'
_gnulib='be584c56eb1311606e5ea1a36363b97bddb6eed3'
_unifont='12.1.03'
source=(
"https://ftp.gnu.org/gnu/unifont/unifont-$_unifont/unifont-$_unifont.bdf.gz"
"https://ftp.gnu.org/gnu/unifont/unifont-$_unifont/unifont-$_unifont.bdf.gz.sig"
'0003-10_linux-detect-archlinux-initramfs.patch'
'0004-add-GRUB_COLOR_variables.patch'
'grub.default'
)
sha256sums=(
'SKIP'
'SKIP'
'SKIP'
'6067bda8daa1f3c49d8876107992e19fc9ab905ad54c01c3131b9649977c3746'
'SKIP'
'171415ab075d1ac806f36c454feeb060f870416f24279b70104bba94bd6076d4'
'a5198267ceb04dceb6d2ea7800281a42b3f91fd02da55d2cc9ea20d47273ca29'
'690adb7943ee9fedff578a9d482233925ca3ad3e5a50fffddd27cf33300a89e3'
)
prepare() {
cd $pkgname
patch -p1 -i $srcdir/0003-10_linux-detect-archlinux-initramfs.patch
patch -p1 -i $srcdir/0004-add-GRUB_COLOR_variables.patch
sed 's|/usr/share/fonts/dejavu|/usr/share/fonts/dejavu /usr/share/fonts/TTF|g' -i configure.ac
sed 's| ro | rw |g' -i util/grub.d/10_linux.in
sed 's|GNU/Linux|Linux|' -i util/grub.d/10_linux.in
./bootstrap	--gnulib-srcdir=$srcdir/gnulib --no-git
if [ -x autogen.sh ]; then
	NOCONFIGURE=1 ./autogen.sh
fi
}
build() {
cd $pkgname
mkdir $pkgname-extras
cp -r $srcdir/$pkgname-extras/915resolution $pkgname-extras/915resolution
export GRUB_CONTRIB=$srcdir/$pkgname/grub-extras/
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
	'--disable-werror'
	'--disable-efiemu'
	'--disable-mm-debug'
	'--disable-grub-emu-sdl'
	'--disable-grub-emu-pci'
	'--disable-libzfs'
	'--enable-threads=posix'
	'--enable-cache-stats'
	'--enable-boot-time'
	'--target=x86_64'
	'--with-platform=pc'
	'--with-bootdir=/boot'
	'--with-grubdir=grub'
	'--without-included-regex'
	'--enable-device-mapper'
	'--enable-grub-mkfont'
	'--enable-grub-themes'
	'--disable-grub-mount'
	'--enable-liblzma'
)
unset CPPFLAGS
unset CFLAGS
unset CXXFLAGS
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
cd $pkgname
make DESTDIR=$pkgdir bashcompletiondir=/usr/share/bash-completion/completions install
install -Dm644 COPYING $pkgdir/usr/share/licenses/grub/LICENSE
cd $pkgdir
rm -f usr/lib/grub/i386-pc/*.module || true
rm -f usr/lib/grub/i386-pc/*.image || true
rm -f usr/lib/grub/i386-pc/{kernel.exec,gdb_grub,gmodule.pl} || true
install -Dm644 $srcdir/grub.default etc/default/grub
}
