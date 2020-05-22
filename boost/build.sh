pkgbase='boost'
pkgname=('boost' 'boost-libs')
pkgver=1.72.0
pkgrel=1
url='https://www.boost.org/'
license=('custom')
arch=('x86_64')
makedepends=(
'bzip2'
'gcc-libs'
'glibc'
'icu'
'python2'
'python2-numpy'
'xz'
'zlib'
'zstd'
)
source=("https://dl.bintray.com/boostorg/release/${pkgver}/source/${pkgbase}_${pkgver//./_}.tar.bz2")
sha256sums=('59c9b274bc451cf91a9ba1dd2c7fdcaf5d60b1b3aa83f2c9fa143417cc660722')
build() {
cd ${pkgbase}_${pkgver//./_}
config_opts=(
	'--prefix=/usr'
	'--libdir=/usr/lib'
	'--includedir=/usr/include'
	'--with-toolset=gcc'
	'--with-libraries=all'
	'--with-icu'
	'--with-python=python2'
)
./bootstrap.sh "${config_opts[@]}"
echo 'using mpi ;' >> project-config.jam
build_opts=(
	"cflags=${CPPFLAGS} ${CFLAGS} -fPIC"
	"cxxflags=${CPPFLAGS} ${CXXFLAGS} -fPIC -std=c++14"
	"linkflags=${LDFLAGS}"
	'debug-symbols=off'
	'variant=release'
	'threading=multi'
	'link=shared,static'
	'runtime-link=shared'
	'--stagedir=release'
	'--layout=system'
	'--build-dir=build'
	'--build-type=minimal'
)
local JOBS="$(sed -e 's/.*\(-j *[0-9]\+\).*/\1/' <<< ${MAKEFLAGS})"
./b2 stage $JOBS "${build_opts[@]}"
}
package_boost() {
pkgdesc='Free peer-reviewed portable C++ source libraries - development headers'
depends=("boost-libs=$pkgver")
optdepends=(
	'python: for python bindings'
	'python2: for python2 bindings'
)
cd ${pkgbase}_${pkgver//./_}
local JOBS="$(sed -e 's/.*\(-j *[0-9]\+\).*/\1/' <<< ${MAKEFLAGS})"
./b2 install $JOBS --prefix=$pkgdir/usr
mkdir -p $pkgdir/usr/share/boostbook
cp -a tools/boostbook/{xsl,dtd} $pkgdir/usr/share/boostbook
install -Dm644 LICENSE_1_0.txt $pkgdir/usr/share/licenses/boost/LICENSE
cd $pkgdir
mkdir -p $srcdir/boost-libs/usr/lib
mv usr/lib/*.so* $srcdir/boost-libs/usr/lib || true
}
package_boost-libs() {
pkgdesc='Free peer-reviewed portable C++ source libraries - runtime libraries'
depends=(
	'bzip2'
	'gcc-libs'
	'glibc'
	'icu>=55.1'
	'xz'
	'zlib'
	'zstd'
)
provides=(
	'libboost_atomic.so'
	'libboost_chrono.so'
	'libboost_container.so'
	'libboost_context.so'
	'libboost_contract.so'
	'libboost_coroutine.so'
	'libboost_date_time.so'
	'libboost_fiber.so'
	'libboost_filesystem.so'
	'libboost_graph.so'
	'libboost_graph_parallel.so'
	'libboost_iostreams.so'
	'libboost_locale.so'
	'libboost_log.so'
	'libboost_log_setup.so'
	'libboost_math_c99.so'
	'libboost_math_c99f.so'
	'libboost_math_c99l.so'
	'libboost_math_tr1.so'
	'libboost_math_tr1f.so'
	'libboost_math_tr1l.so'
	'libboost_mpi.so'
	'libboost_prg_exec_monitor.so'
	'libboost_program_options.so'
	'libboost_random.so'
	'libboost_regex.so'
	'libboost_serialization.so'
	'libboost_stacktrace_addr2line.so'
	'libboost_stacktrace_basic.so'
	'libboost_stacktrace_noop.so'
	'libboost_system.so'
	'libboost_thread.so'
	'libboost_timer.so'
	'libboost_type_erasure.so'
	'libboost_unit_test_framework.so'
	'libboost_wave.so'
	'libboost_wserialization.so'
)
mv $srcdir/boost-libs/* $pkgdir
install -Dm644 ${pkgbase}_${pkgver//./_}/LICENSE_1_0.txt \
$pkgdir/usr/share/licenses/boost-libs/LICENSE
}
