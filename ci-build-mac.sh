#!/bin/bash
# On Mac, we don't build Stdlib, just the compiler, since macOS doesn't support cross compiling for non-Darwin targets.
set -e
sourcedir="$PWD"
# install dependencies
brew install ninja llvm
# start build
cd swift
utils/build-script --release \
	--llvm-targets-to-build "X86;WebAssembly" \
	--llvm-max-parallel-lto-link-jobs 1 --swift-tools-max-parallel-lto-link-jobs 1 \
	--stdlib-deployment-targets "macosx-x86_64" \
	--extra-cmake-options="-DSWIFT_WASM_WASI_SDK_PATH=/usr/local/opt/llvm" \
	--install-swift \
	--install-prefix="/opt/swiftwasm-sdk" \
	--install-destdir="$sourcedir/install" \
	--installable-package="$sourcedir/swiftwasm-mac.tar.gz"
	"$@"
# copy the result
cp "$sourcedir/swiftwasm-mac.tar.gz" "$BUILD_ARTIFACTSTAGINGDIRECTORY/"

