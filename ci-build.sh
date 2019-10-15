#!/bin/bash
set -e
sourcedir="$PWD"
# install dependencies
sudo apt update
sudo apt install apt-transport-https ca-certificates gnupg \
	software-properties-common wget git cmake ninja-build clang python uuid-dev \
	libicu-dev icu-devtools libbsd-dev libedit-dev libxml2-dev libsqlite3-dev \
	swig libpython-dev libncurses5-dev pkg-config libblocksruntime-dev \
	libcurl4-openssl-dev systemtap-sdt-dev tzdata rsync
# install latest cmake
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | sudo apt-key add -
sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ xenial main'
sudo apt update
apt install cmake
# install the WASI sdk
wget -O wasisdk.deb "https://github.com/swiftwasm/wasi-sdk/releases/download/20190421.6/wasi-sdk_3.19gefb17cb478f9.m_amd64.deb"
sudo dpkg -i wasisdk.deb
# download ICU
wget -O icu.tar.xz "https://github.com/swiftwasm/icu4c-wasi/releases/download/20190421.3/icu4c-wasi.tar.xz"
tar xf icu.tar.xz
# start build
cd swift
utils/build-script --release --wasm \
	--llvm-targets-to-build "X86;WebAssembly" \
	--llvm-max-parallel-lto-link-jobs 1 --swift-tools-max-parallel-lto-link-jobs 1 \
	--wasm-wasi-sdk "/opt/wasi-sdk" \
	--wasm-icu-uc "todo" \
	--wasm-icu-uc-include "$sourcedir/icu_out/include" \
	--wasm-icu-i18n "todo" \
	--wasm-icu-i18n-include "todo" \
	--wasm-icu-data "todo" \
	--build-swift-static-stdlib \
	--install-swift \
	--install-prefix="/opt/swiftwasm-sdk" \
	--install-destdir="$sourcedir/install" \
	--installable-package="$sourcedir/swiftwasm.tar.gz"
# copy the result
cp "$sourcedir/swiftwasm.tar.gz" "$BUILD_ARTIFACTSTAGINGDIRECTORY/"

