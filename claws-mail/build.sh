pkgname=('claws-mail')
pkgver=3.17.5
pkgrel=1
pkgdesc='A GTK+ based e-mail client'
url='https://www.claws-mail.org'
license=('GPL3')
arch=('x86_64')
depends=(
'bash'
'cairo'
'curl'
'dbus-glib'
'desktop-file-utils'
'enchant'
'expat'
'gdk-pixbuf2'
'glib2'
'glibc'
'gnutls'
'gpgme'
'gtk2'
'hicolor-icon-theme'
'libarchive'
'libcanberra'
'libgpg-error'
'libice'
'libnotify'
'librsvg'
'libsm'
'libx11'
'nettle'
'pango'
'perl'
'poppler-glib'
'startup-notification'
'zlib'
)
makedepends=(
'bogofilter'
'dillo'
'docbook-utils'
'pygtk'
'spamassassin'
)
optdepends=(
'bogofilter: adds support for spamfiltering'
'dillo: for html viewer plugin'
'ghostscript: for pdf viewer plugin'
'libxml2: for gtkhtml2_viewer and rssyl plugins'
'python: needed for some tools'
'spamassassin: adds support for spamfiltering'
)
provides=('claws')
conflicts=('claws-mail-extra-plugins')
replaces=('sylpheed-claws' 'claws-mail-extra-plugins')
source=(
"https://www.claws-mail.org/download.php?file=releases/$pkgname-$pkgver.tar.xz"
"https://www.claws-mail.org/download.php?file=releases/$pkgname-$pkgver.tar.xz.asc"
)
sha256sums=(
'daced25bfc2ab5b3f9ac2762b091ca3aede50da23e694d338dff1f066bab59be'
'SKIP'
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
	'--libexecdir=/usr/lib'
	'--sysconfdir=/etc'
	'--localstatedir=/var'
	'--enable-silent-rules'
	'--enable-shared'
	'--disable-static'
	'--disable-tests'
	'--disable-deprecated'
	'--enable-generic-umpc'
	'--disable-demo-plugin'
	'--disable-fancy-plugin'
	'--disable-crash-dialog'
	'--disable-valgrind'
	'--disable-alternate-addressbook'
	'--enable-pthread'
	'--enable-manual'
	'--enable-ipv6'
	'--enable-acpi_notifier-plugin'
	'--enable-address_keeper-plugin'
	'--enable-att_remover-plugin'
	'--enable-attachwarner-plugin'
	'--enable-bogofilter-plugin'
	'--enable-bsfilter-plugin'
	'--enable-spamassassin-plugin'
	'--enable-clamd-plugin'
	'--enable-dillo-plugin'
	'--enable-fetchinfo-plugin'
	'--enable-mailmbox-plugin'
	'--enable-managesieve-plugin'
	'--enable-newmail-plugin'
	'--disable-litehtml_viewer-plugin'
	'--disable-compface'
	'--enable-libravatar-plugin'
	'--enable-spam_report-plugin'
	'--enable-dbus'
	'--enable-enchant'
	'--enable-rssyl-plugin'
	'--enable-gnutls'
	'--with-password-encryption=gnutls'
	'--enable-pgpcore-plugin'
	'--disable-jpilot'
	'--enable-archive-plugin'
	'--disable-libetpan'
	'--disable-gdata-plugin'
	'--enable-pgpinline-plugin'
	'--enable-pgpmime-plugin'
	'--enable-smime-plugin'
	'--disable-vcalendar-plugin'
	'--disable-ldap'
	'--enable-notification-plugin'
	'--enable-svg'
	'--enable-libsm'
	'--disable-tnef_parse-plugin'
	'--disable-networkmanager'
	'--enable-perl-plugin'
	'--enable-pdf_viewer-plugin'
	'--disable-python-plugin'
	'--enable-startup-notification'
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
mkdir -p $pkgdir/usr/lib/claws-mail/tools
echo 'DISPLAY=:0 notify-send --urgency=low --expire-time=10000 --icon=claws-mail "Incoming mail" "You have received $1 new email(s)."' >> $pkgdir/usr/lib/claws-mail/tools/mail-command.sh
echo 'canberra-gtk-play --display=:0 --id=message-new-email --description="Mail notification"' >> $pkgdir/usr/lib/claws-mail/tools/mail-command.sh
chmod +x $pkgdir/usr/lib/claws-mail/tools/mail-command.sh
cd tools
cp -arvt $pkgdir/usr/lib/claws-mail/tools *.pl *.py *.sh \
kdeservicemenu multiwebsearch.conf tb2claws-mail update-po uudec uuooffice README
}
