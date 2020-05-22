pkgbase='ca-certificates'
pkgname=('ca-certificates' 'ca-certificates-utils')
pkgver=20181109
pkgrel=3
pkgdesc='Common CA certificates'
url='https://src.fedoraproject.org/rpms/ca-certificates'
license=('GPL2')
arch=('any')
makedepends=(
'asciidoc'
'p11-kit'
)
options=('emptydirs')
source=(
'update-ca-trust'
'update-ca-trust.8.txt'
'update-ca-trust.hook'
)
sha256sums=(
'ba98e00f80f94e2648b66252119d1b0da2339b8c83860cd69738e5c4e2d0fcc3'
'acf571f7d7a9df2149a373017280e8f22d07a2d36600256fa48159d22ab74751'
'3a3833ebd6f9cdef2e534a273653f973a4354d4f9368577d0d73236b014b7748'
)
build() {
asciidoc.py -v -d manpage -b docbook update-ca-trust.8.txt
xsltproc --nonet -o update-ca-trust.8 /etc/asciidoc/docbook-xsl/manpage.xsl update-ca-trust.8.xml
}
package_ca-certificates() {
pkgdesc='Common CA certificates (default providers)'
depends=(
	'ca-certificates-mozilla'
	'ca-certificates-utils'
)
conflicts=('ca-certificates-cacert<=20140824-4')
replaces=('ca-certificates-cacert<=20140824-4')
}
package_ca-certificates-utils() {
pkgdesc='Common CA certificates (utilities)'
depends=(
	'bash'
	'coreutils'
	'findutils'
	'p11-kit>=0.23.1'
)
provides=(
	'ca-certificates'
	'ca-certificates-java'
)
conflicts=('ca-certificates-java')
replaces=('ca-certificates-java')
install -Dm755 update-ca-trust $pkgdir/usr/bin/update-ca-trust
install -Dm644 update-ca-trust.8 $pkgdir/usr/share/man/man8/update-ca-trust.8
install -Dm644 update-ca-trust.hook $pkgdir/usr/share/libalpm/hooks/update-ca-trust.hook
mkdir -p $pkgdir/{etc,usr/share}/$pkgbase/trust-source/{anchors,blacklist}
mkdir -p $pkgdir/etc/{ssl/certs/{edk2,java},$pkgbase/extracted}
ln -sr $pkgdir/etc/$pkgbase/extracted/tls-ca-bundle.pem $pkgdir/etc/ssl/cert.pem
ln -sr $pkgdir/etc/$pkgbase/extracted/tls-ca-bundle.pem $pkgdir/etc/ssl/certs/ca-certificates.crt
}
