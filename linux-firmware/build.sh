pkgname=('linux-firmware')
pkgver=20200316.8eb0b28
pkgrel=1
pkgdesc='Firmware files for Linux'
url='https://git.kernel.org/?p=linux/kernel/git/firmware/$pkgname.git;a=summary'
license=('GPL2' 'GPL3' 'custom')
arch=('any')
groups=('base')
makedepends=('git')
conflicts=(
'linux-firmware-git'
'kernel26-firmware'
'ar9170-fw'
'iwlwifi-1000-ucode'
'iwlwifi-3945-ucode'
'iwlwifi-4965-ucode'
'iwlwifi-5000-ucode'
'iwlwifi-5150-ucode'
'iwlwifi-6000-ucode'
'rt2870usb-fw'
'rt2x00-rt61-fw'
'rt2x00-rt71w-fw'
)
replaces=(
'kernel26-firmware'
'ar9170-fw'
'iwlwifi-1000-ucode'
'iwlwifi-3945-ucode'
'iwlwifi-4965-ucode'
'iwlwifi-5000-ucode'
'iwlwifi-5150-ucode'
'iwlwifi-6000-ucode'
'rt2870usb-fw'
'rt2x00-rt61-fw'
'rt2x00-rt71w-fw'
)
options=(!strip)
_commit='8eb0b281511d6455ca9151e52f694dc982193251'
sha256sums=('SKIP')
package() {
cd $pkgname
make FIRMWAREDIR=/usr/lib/firmware DESTDIR=$pkgdir install
mkdir -p $pkgdir/usr/lib/tmpfiles.d
echo 'w /sys/devices/system/cpu/microcode/reload - - - - 1' \
> $pkgdir/usr/lib/tmpfiles.d/linux-firmware.conf
mkdir -p $pkgdir/usr/share/licenses/linux-firmware
install -Dm644 LICEN* WHENCE $pkgdir/usr/share/licenses/linux-firmware
}
