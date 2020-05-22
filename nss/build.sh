pkgbase='nss'
pkgname=('nss' 'ca-certificates-mozilla')
_nsprver=4.25
pkgver=3.51
pkgrel=1
url='https://developer.mozilla.org/en-US/docs/Mozilla/Projects/NSS'
license=('MPL' 'GPL')
arch=('x86_64')
makedepends=(
'gyp'
'perl'
'python'
'python2'
)
source=(
"https://ftp.mozilla.org/pub/security/nss/releases/NSS_${pkgver//./_}_RTM/src/nss-${pkgver}.tar.gz"
'certdata2pem.py'
'bundle.sh'
)
sha256sums=(
'75348b3b3229362486c57a880db917da1f96ef4eb639dc9cc2ff17d72268459c'
'd2a1579dae05fd16175fac27ef08b54731ecefdf414085c610179afcf62b096c'
'3bfadf722da6773bdabdd25bdf78158648043d1b7e57615574f189a88ca865dd'
)
build() {
cd $pkgbase-$pkgver/$pkgbase
mkdir -p certs && cd certs
ln -s ../lib/ckfw/builtins/certdata.txt
ln -s ../lib/ckfw/builtins/nssckbi.h
python $srcdir/certdata2pem.py
cd .. && sh ../../bundle.sh
config_opts=(
	'--opt'
	'--gcc'
	'--target=x64'
	'--disable-tests'
	'--enable-libpkix'
	'--system-nspr'
	'--system-sqlite'
)
./build.sh "${config_opts[@]}"
}
package_nss() {
pkgdesc='Network Security Services'
depends=(
	"nspr>=${_nsprver}"
	'gcc-libs'
	'glibc'
	'p11-kit>=0.23.19'
	'sh'
	'sqlite'
	'zlib'
)
cd $pkgbase-$pkgver/$pkgbase
mkdir -p $pkgdir/usr/{bin,lib,include/nss,share/man/man1}
mv ../dist/Release/bin/* $pkgdir/usr/bin
mv ../dist/Release/lib/*.so $pkgdir/usr/lib
mv ../dist/Release/lib/*.chk $pkgdir/usr/lib
mv ../dist/public/nss/*.h $pkgdir/usr/include/nss
install -t $pkgdir/usr/share/man/man1 -m644 doc/nroff/*
{ read _vmajor; read _vminor; read _vpatch; } \
sed pkg/pkg-config/nss-config.in \
-e "s,@libdir@,/usr/lib,g" \
-e "s,@prefix@,/usr/bin,g" \
-e "s,@exec_prefix@,/usr/bin,g" \
-e "s,@includedir@,/usr/include/nss,g" \
-e "s,@MOD_MAJOR_VERSION@,${_vmajor},g" \
-e "s,@MOD_MINOR_VERSION@,${_vminor},g" \
-e "s,@MOD_PATCH_VERSION@,${_vpatch},g" |
install -D /dev/stdin $pkgdir/usr/bin/nss-config
sed pkg/pkg-config/nss.pc.in \
-e "s,%libdir%,/usr/lib,g" \
-e "s,%prefix%,/usr,g" \
-e "s,%exec_prefix%,/usr/bin,g" \
-e "s,%includedir%,/usr/include/nss,g" \
-e "s,%NSPR_VERSION%,${_nsprver},g" \
-e "s,%NSS_VERSION%,${pkgver},g" |
install -Dm644 /dev/stdin $pkgdir/usr/lib/pkgconfig/nss.pc
ln -s nss.pc $pkgdir/usr/lib/pkgconfig/mozilla-nss.pc
ln -sf libnssckbi-p11-kit.so $pkgdir/usr/lib/libnssckbi.so
rm -f $pkgdir/usr/bin/{hw-support,pwdecrypt}
rm -f $pkgdir/usr/share/man/man1/{derdump.1,pp.1,vfychain.1,vfyserv.1}
}
package_ca-certificates-mozilla() {
pkgdesc="Mozilla's set of trusted CA certificates"
depends=('ca-certificates-utils>=20181109-3')
install -Dm644 $pkgbase-$pkgver/$pkgbase/ca-bundle.trust.p11-kit \
$pkgdir/usr/share/ca-certificates/trust-source/mozilla.trust.p11-kit
}
