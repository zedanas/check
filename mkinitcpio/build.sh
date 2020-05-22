pkgname=('mkinitcpio')
pkgver=27
pkgrel=3
pkgdesc='Modular initramfs image creation utility'
url='https://projects.archlinux.org/mkinitcpio.git/'
license=('GPL')
arch=('any')
depends=(
'awk'
'bash'
'coreutils'
'filesystem>=2011.10-1'
'findutils'
'grep'
'gzip'
'kmod'
'libarchive'
'mkinitcpio-busybox>=1.19.4-2'
'systemd'
'util-linux>=2.23'
)
optdepends=(
'bzip2: Use bzip2 compression for the initramfs image'
'lz4: Use lz4 compression for the initramfs image'
'lzop: Use lzo compression for the initramfs image'
'mkinitcpio-nfs-utils: Support for root filesystem on NFS'
'xz: Use lzma or xz compression for the initramfs image'
)
provides=('initramfs')
backup=('etc/mkinitcpio.conf')
install='mkinitcpio.install'
options=('emptydirs')
source=(
"https://sources.archlinux.org/other/$pkgname/$pkgname-$pkgver.tar.gz"
"https://sources.archlinux.org/other/$pkgname/$pkgname-$pkgver.tar.gz.sig"
'0001-mkinitcpio-remove-preset-pacsave.patch'
'0002-mkinitcpio-fix-builtin.patch'
)
sha256sums=(
'e6bff1cb78b677538eb9aace900b715fd59de8fc210b74fb9d899dfaa32bc354'
'SKIP'
'845569fa760f70c868ecb3dc8ae9667287970526dddaf403fdafcb716e8b3d51'
'd097f3df15ba9fefd3771f9f784e1c31c8d5ff1d9d6885a46fc6b5188e419796'
)
prepare() {
cd $pkgname-$pkgver
patch -Np1 -i $srcdir/0001-mkinitcpio-remove-preset-pacsave.patch
patch -Np1 -i $srcdir/0002-mkinitcpio-fix-builtin.patch
}
check() {
cd $pkgname-$pkgver
make -k check
}
package() {
cd $pkgname-$pkgver
make DESTDIR=$pkgdir install
}
