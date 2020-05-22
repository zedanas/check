pkgname=('iana-etc')
pkgver=20200327
pkgrel=1
pkgdesc='/etc/protocols and /etc/services provided by IANA'
url='https://www.iana.org/protocols'
license=('custom:none')
arch=('any')
backup=(
'etc/protocols'
'etc/services'
)
source=(
'https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xml'
'https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xml'
'LICENSE'
)
sha256sums=(
'SKIP'
'SKIP'
'dd37e92942d5a4024f1c77df49d61ca77fc6284691814903a741785df61f78cb'
)
package() {
cd $srcdir
mkdir -p $pkgdir/etc
gawk -F "[<>]" '
BEGIN { printf "\
\n\
(/<record/) { v=n=d="" }
(/<value/) { v=$3 }
(/<description/) { d=$3 }
(/<name/ && $3!~/ /) { n=$3 }
END { print "\n\
' protocol-numbers.xml > $pkgdir/etc/protocols
gawk -F "[<>]" '
BEGIN { printf "\
\n\
(/<record/) { n=u=p=c=d="" }
(/<name/ && !/\(/) { n=$3 }
(/<number/) { u=$3 }
(/<protocol/) { p=$3 }
(/<description/) { d=$3 }
(/Unassigned/ || /Reserved/ || /historic/) { c=1 }
END { print "\n\
' service-names-port-numbers.xml > $pkgdir/etc/services
install -Dm644 LICENSE $pkgdir/usr/share/licenses/iana-etc/COPYING
}
