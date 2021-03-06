pkgname=('chromium')
pkgver=76.0.3809.100
pkgrel=1
pkgdesc='A web browser built for speed, simplicity, and security'
url='https://www.chromium.org/Home'
license=('BSD')
arch=('x86_64')
depends=(
'alsa-lib'
'at-spi2-atk'
'at-spi2-core'
'atk'
'cairo'
'dbus'
'desktop-file-utils'
'expat'
'ffmpeg'
'freetype2'
'gcc-libs'
'gdk-pixbuf2'
'glib2'
'glibc'
'gtk3'
'harfbuzz'
'hicolor-icon-theme'
'icu'
'libjpeg-turbo'
'libpciaccess'
'libpng'
'libpulse'
'libutil-linux'
'libvpx'
'libx11'
'libxcb'
'libxcomposite'
'libxcursor'
'libxdamage'
'libxext'
'libxfixes'
'libxi'
'libxrandr'
'libxrender'
'libxss'
'libxtst'
'nspr'
'nss'
'opus'
'pango'
'pulseaudio'
'ttf-font'
'xdg-utils'
'zlib'
)
makedepends=(
'clang'
'git'
'gn'
'gperf'
'java-runtime-headless'
'lld'
'mesa'
'ninja'
'nodejs'
'pipewire'
'python'
'python2'
'yasm'
)
optdepends=(
'gnome-keyring: for storing passwords in GNOME keyring'
'kdialog: needed for file dialogs in KDE'
'kwallet: for storing passwords in KWallet'
'pepper-flash: support for Flash content'
'pipewire: WebRTC desktop sharing under Wayland'
)
install='chromium.install'
source=(
"https://commondatastorage.googleapis.com/chromium-browser-official/$pkgname-$pkgver.tar.xz"
'chromium-widevine.patch'
'chromium-skia-harmony.patch'
)
sha256sums=(
'8cd93ada3e0837ced512f69783400991d3b82e0d9622e04fab5922877577d26d'
'd081f2ef8793544685aad35dea75a7e6264a2cb987ff3541e6377f4a3650a28b'
'771292942c0901092a402cc60ee883877a99fb804cb54d568c8c6c94565a48e1'
)
prepare() {
cd $pkgname-$pkgver
sed 's/OFFICIAL_BUILD/GOOGLE_CHROME_BUILD/' \
	-i tools/generate_shim_headers/generate_shim_headers.py
sed -e 's/\<xmlMalloc\>/malloc/' \
	-e 's/\<xmlFree\>/free/' \
	-i third_party/blink/renderer/core/xml/*.cc \
	third_party/blink/renderer/core/xml/parser/xml_document_parser.cc \
	third_party/libxml/chromium/libxml_utils.cc
patch -Np1 -i $srcdir/chromium-widevine.patch
patch -Np0 -i $srcdir/chromium-skia-harmony.patch
sed '1s|python$|&2|' -i third_party/dom_distiller_js/protoc_plugins/*.py
mkdir -p third_party/node/linux/node-linux-x64/bin
ln -sf /usr/bin/node third_party/node/linux/node-linux-x64/bin/
}
build() {
cd $pkgname-$pkgver
config_opts=(
	'treat_warnings_as_errors=false'
	'fieldtrial_testing_like_official_build=true'
	'clang_use_chrome_plugins=false'
	'linux_use_bundled_binutils=false'
	'remove_webcore_debug_symbols=true'
	'is_clang=true'
	'is_debug=false'
	'is_official_build=true'
	'is_desktop_linux=true'
	'is_nacl_glibc=true'
	'ffmpeg_branding="Chrome"'
	'proprietary_codecs=true'
	'optimize_webui=true'
	'strip_debug_info=true'
	'use_sysroot=false'
	'use_custom_libcxx=false'
	'use_gold=false'
	'use_gio=true'
	'use_udev=true'
	'use_kerberos=true'
	'use_xkbcommon=true'
	'use_egl=true'
	'use_openh264=true'
	'use_v4lplugin=true'
	'enable_profiling=false'
	'enable_reporting=true'
	'enable_service_discovery=true'
	'enable_session_service=true'
	'enable_supervised_users=true'
	'enable_nacl=false'
	'enable_plugins=true'
	'enable_extensions=true'
	'enable_websockets=true'
	'enable_widevine=true'
	'enable_swiftshader=true'
	'enable_native_notifications=true'
	'enable_native_window_nav_buttons=true'
	'enable_desktop_in_product_help=true'
	'enable_basic_printing=true'
	'enable_basic_print_dialog=true'
	'enable_print_preview=true'
	'enable_hangout_services_extension=true'
	'enable_cbcs_encryption_scheme=true'
	'enable_av1_decoder=true'
	'enable_mpeg_h_audio_demuxing=true'
	'enable_ffmpeg_video_decoders=true'
	'enable_pdf=true'
	'pdf_enable_v8=true'
	'rtc_build_examples=false'
	'rtc_build_tools=true'
	'rtc_build_json=true'
	'rtc_build_ssl=true'
	'rtc_build_libevent=true'
	'rtc_build_libsrtp=true'
	'rtc_build_usrsctp=true'
	'rtc_builtin_ssl_root_certificates=true'
	'rtc_enable_external_auth=true'
	'rtc_enable_libevent=true'
	'rtc_enable_sctp=true'
	'rtc_use_lto=true'
	'rtc_use_x11=true'
	'rtc_use_gtk=true'
	'rtc_use_metal_rendering=true'
	'rtc_use_h264=true'
	'rtc_use_pipewire=true'
	'symbol_level=0'
	'blink_symbol_level=0'
	'google_api_key="AIzaSyDwr302FpOSkGRpLlUpPThNTDPbXcIn_FM"'
	'google_default_client_id="413772536636.apps.googleusercontent.com"'
	'google_default_client_secret="0ZChLK6AxeA3Isu96MkwqDR4"'
	'custom_toolchain="//build/toolchain/linux/unbundle:default"'
	'host_toolchain="//build/toolchain/linux/unbundle:default"'
	'use_alsa=true'
	'use_dbus=true'
	'media_use_ffmpeg=true'
	'use_webaudio_ffmpeg=true'
	'use_system_freetype=true'
	'pdf_bundle_freetype=false'
	'use_glib=true'
	'use_gtk=true'
	'use_system_harfbuzz=true'
	'disable_file_support=false'
	'use_system_lcms2=false'
	'use_cups=false'
	'use_gnome_keyring=false'
	'use_system_libjpeg=true'
	'use_libjpeg_turbo=true'
	'use_libpci=true'
	'use_system_libpng=true'
	'media_use_libvpx=true'
	'rtc_build_libvpx=true'
	'rtc_libvpx_build_vp9=true'
	'rtc_build_opus=true'
	'rtc_include_opus=true'
	'rtc_opus_support_120ms_ptime=true'
	'rtc_opus_variable_complexity=true'
	'use_pulseaudio=true'
	'link_pulseaudio=true'
	'use_system_zlib=true'
)
export CC=clang
export CXX=clang++
export AR=ar
export NM=nm
export CFLAGS='-march=native -O3 -pipe'
export CXXFLAGS="${CFLAGS}"
gn gen out/Release --args="${config_opts[*]}" --script-executable=/usr/bin/python2
ninja -C out/Release chrome
}
package() {
cd $pkgname-$pkgver
mkdir -p $pkgdir/usr/{bin,lib/chromium/locales}
install -Dm755 out/Release/chrome $pkgdir/usr/lib/chromium/chromium
install -Dm644 out/Release/{*.pak,*.bin} $pkgdir/usr/lib/chromium/
install -Dm644 out/Release/icudtl.dat $pkgdir/usr/lib/chromium/icudtl.dat
install -Dm644 out/Release/locales/*.pak $pkgdir/usr/lib/chromium/locales/
install -Dm644 chrome/installer/linux/common/desktop.template $pkgdir/usr/share/applications/chromium.desktop
install -Dm644 chrome/app/resources/manpage.1.in $pkgdir/usr/share/man/man1/chromium.1
install -Dm644 LICENSE $pkgdir/usr/share/licenses/chromium/LICENSE
ln -sf /usr/lib/chromium/chromium $pkgdir/usr/bin/chromium
sed	-e "s/@@MENUNAME@@/Chromium/g" \
	-e "s/@@PACKAGE@@/chromium/g" \
	-e "s/@@USR_BIN_SYMLINK_NAME@@/chromium/g" \
	-i $pkgdir/usr/share/applications/chromium.desktop \
	-i $pkgdir/usr/share/man/man1/chromium.1
for size in 16 32; do
	install -Dm644 chrome/app/theme/default_100_percent/chromium/product_logo_${size}.png \
	$pkgdir/usr/share/icons/hicolor/${size}x${size}/apps/chromium.png
done
for size in 22 24 48 64 128 256; do
	install -Dm644 chrome/app/theme/chromium/product_logo_${size}.png \
	$pkgdir/usr/share/icons/hicolor/${size}x${size}/apps/chromium.png
done
}
