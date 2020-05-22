pkgbase='llvm'
pkgname=('llvm' 'llvm-libs' 'llvm-ocaml')
pkgver=9.0.1
pkgrel=2
url='https://llvm.org/'
license=('custom:Apache 2.0 with LLVM Exception')
arch=('x86_64')
makedepends=(
'cmake'
'doxygen'
'libedit'
'libffi'
'libxml2'
'ncurses'
'ninja'
'ocaml'
'ocaml-ctypes'
'ocaml-findlib'
'python-recommonmark'
'python-sphinx'
)
source=(
"https://github.com/llvm/llvm-project/releases/download/llvmorg-$pkgver/$pkgname-$pkgver.src.tar.xz"
"https://github.com/llvm/llvm-project/releases/download/llvmorg-$pkgver/$pkgname-$pkgver.src.tar.xz.sig"
'llvm-config.h'
)
sha256sums=(
'00a1ee1f389f81e9979f3a640a01c431b3021de0d42278f6508391a2f0b81c9a'
'SKIP'
'597dc5968c695bbdbb0eac9e8eb5117fcd2773bc91edf5ec103ecffffab8bc48'
)
build() {
cd $pkgbase-$pkgver.src
config_opts=(
	"-DCMAKE_C_FLAGS='$CFLAGS -fno-lto'"
	"-DCMAKE_CXX_FLAGS='$CXXFLAGS -fno-lto'"
	"-DCMAKE_LD_FLAGS='$LDFLAGS'"
	"-DFFI_INCLUDE_DIR=$(pkg-config --variable=includedir libffi)"
	'-DCMAKE_INSTALL_PREFIX=/usr'
	'-DCMAKE_BUILD_TYPE=Release'
	'-DLLVM_BUILD_RUNTIME=ON'
	'-DLLVM_BUILD_RUNTIMES=ON'
	'-DLLVM_BUILD_TOOLS=ON'
	'-DLLVM_BUILD_UTILS=ON'
	'-DLLVM_BUILD_DOCS=ON'
	'-DLLVM_BUILD_TESTS=ON'
	'-DLLVM_BUILD_LLVM_DYLIB=ON'
	'-DLLVM_LINK_LLVM_DYLIB=ON'
	'-DLLVM_APPEND_VC_REV=ON'
	'-DLLVM_ENABLE_ASSERTIONS=OFF'
	'-DLLVM_ENABLE_BACKTRACES=OFF'
	'-DLLVM_ENABLE_THREADS=ON'
	'-DLLVM_ENABLE_PIC=ON'
	'-DLLVM_ENABLE_LTO=OFF'
	'-DLLVM_ENABLE_RTTI=ON'
	'-DLLVM_ENABLE_DOXYGEN=OFF'
	'-DLLVM_ENABLE_SPHINX=ON'
	'-DLLVM_INSTALL_UTILS=ON'
	'-DLLVM_INSTALL_MODULEMAPS=OFF'
	'-DLLVM_INSTALL_BINUTILS_SYMLINKS=OFF'
	'-DLLVM_OPTIMIZED_TABLEGEN=ON'
	'-DLLVM_BINUTILS_INCDIR=/usr/include'
	'-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=AVR'
	'-DSPHINX_WARNINGS_AS_ERRORS=OFF'
	'-DSPHINX_OUTPUT_HTML=OFF'
	'-DSPHINX_OUTPUT_MAN=ON'
	'-DLLVM_ENABLE_LIBCXX=ON'
	'-DLLVM_ENABLE_LIBEDIT=ON'
	'-DLLVM_ENABLE_FFI=ON'
	'-DLLVM_ENABLE_LIBXML2=ON'
	'-DLLVM_ENABLE_TERMINFO=ON'
	'-DLLVM_ENABLE_ZLIB=ON'
)
mkdir -p build && cd build
cmake .. -G Ninja "${config_opts[@]}"
ninja all ocaml_doc
}
check() {
cd $pkgbase-$pkgver.src/build
ninja check
}
package_llvm() {
pkgdesc='Collection of modular and reusable compiler and toolchain technologies'
depends=(
	'gcc-libs'
	'glibc'
	'llvm-libs'
	'ncurses'
	'zlib'
)
optdepends=('python-setuptools: for using lit (LLVM Integrated Tester)')
cd $pkgbase-$pkgver.src/build
DESTDIR=$pkgdir ninja install
install -Dm644 ../LICENSE.TXT $pkgdir/usr/share/licenses/llvm/LICENSE
pushd ../utils/lit
python3 setup.py install --root=$pkgdir -O1
popd
rm -fr $pkgdir/usr/share/doc/llvm/html/{_sources,.buildinfo}
cd $pkgdir
mkdir -p $srcdir/llvm-libs/usr/lib/bfd-plugins
mv usr/lib/lib{LLVM,LTO}*.so* $srcdir/llvm-libs/usr/lib || true
mv usr/lib/LLVMgold.so $srcdir/llvm-libs/usr/lib || true
mkdir -p $srcdir/llvm-ocaml/usr/{lib,share/doc/llvm-ocaml}
mv usr/lib/ocaml $srcdir/llvm-ocaml/usr/lib || true
mv usr/share/doc/llvm/ocaml-html $srcdir/llvm-ocaml/usr/share/doc/llvm-ocaml/html || true
}
package_llvm-libs() {
pkgdesc='LLVM runtime libraries'
depends=(
	'gcc-libs'
	'glibc'
	'libedit'
	'libffi'
	'libxml2'
	'ncurses'
	'zlib'
)
mv $srcdir/llvm-libs/* $pkgdir
ln -s ../LLVMgold.so $pkgdir/usr/lib/bfd-plugins/LLVMgold.so
install -Dm644 $srcdir/llvm-$pkgver.src/LICENSE.TXT \
$pkgdir/usr/share/licenses/llvm-libs/LICENSE
}
package_llvm-ocaml() {
pkgdesc='OCaml bindings for LLVM'
depends=(
	'llvm'
	'ocaml-ctypes'
	'ocaml=4.09.0'
)
mv $srcdir/llvm-ocaml/* $pkgdir
install -Dm644 $srcdir/llvm-$pkgver.src/LICENSE.TXT \
$pkgdir/usr/share/licenses/llvm-ocaml/LICENSE
}
