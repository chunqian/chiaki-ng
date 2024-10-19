#!/usr/bin/env bash

set -eu

#################### 构建 opus ####################

pushd third-party/opus
echo $PWD

mkdir -p build
pushd build
cmake .. -DCMAKE_BUILD_TYPE=Release \
-DOPUS_BUILD_SHARED_LIBRARY=OFF \
-DOPUS_BUILD_TESTING=OFF \
-DOPUS_BUILD_PROGRAMS=OFF \
-DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
-DCMAKE_OSX_ARCHITECTURES="x86_64;arm64"
cmake --build .

popd
popd
echo $PWD

#################### 构建 miniupnp ####################

pushd third-party/miniupnp/miniupnpc
echo $PWD

mkdir -p build
pushd build
cmake .. -DCMAKE_BUILD_TYPE=Release \
-DUPNPC_BUILD_STATIC=ON \
-DUPNPC_BUILD_SHARED=OFF \
-DUPNPC_BUILD_TESTS=OFF \
-DUPNPC_BUILD_SAMPLE=OFF \
-DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
-DCMAKE_OSX_ARCHITECTURES="x86_64;arm64"
cmake --build .

popd
popd
echo $PWD

#################### 构建 json-c ####################

pushd third-party/json-c
echo $PWD

mkdir -p build
pushd build
cmake .. -DCMAKE_BUILD_TYPE=Release \
-DBUILD_STATIC_LIBS=ON \
-DBUILD_SHARED_LIBS=OFF \
-DBUILD_APPS=OFF \
-DBUILD_TESTING=OFF \
-DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
-DCMAKE_OSX_ARCHITECTURES="x86_64;arm64"
cmake --build .

popd
popd
echo $PWD

#################### 构建 mbedtls ####################

pushd third-party/mbedtls
echo $PWD

mkdir -p build
pushd build
cmake .. -DCMAKE_BUILD_TYPE=Release \
-DENABLE_PROGRAMS=OFF \
-DENABLE_TESTING=OFF \
-DMBEDTLS_FATAL_WARNINGS=OFF \
-DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
-DCMAKE_OSX_ARCHITECTURES="x86_64;arm64"
cmake --build .

popd
popd
echo $PWD

#################### 构建 curl ####################

pushd third-party/curl
echo $PWD

mkdir -p build
pushd build
cmake .. -DCMAKE_BUILD_TYPE=Release \
-DBUILD_CURL_EXE=OFF \
-DBUILD_SHARED_LIBS=OFF \
-DBUILD_STATIC_LIBS=ON \
-DBUILD_STATIC_CURL=OFF \
-DCURL_USE_MBEDTLS=ON \
-DCURL_USE_LIBPSL=OFF \
-DCURL_USE_PKGCONFIG=OFF \
-DUSE_NGHTTP2=OFF \
-DENABLE_WEBSOCKETS=ON \
-DHTTP_ONLY=ON \
-DCURL_WERROR=OFF \
-DMBEDTLS_INCLUDE_DIR="../../mbedtls/include" \
-DMBEDTLS_LIBRARY="../../mbedtls/build/library/libmbedtls.a" \
-DMBEDX509_LIBRARY="../../mbedtls/build/library/libmbedx509.a" \
-DMBEDCRYPTO_LIBRARY="../../mbedtls/build/library/libmbedcrypto.a" \
-DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
-DCMAKE_OSX_ARCHITECTURES="x86_64;arm64"
cmake --build .

popd
popd
echo $PWD

#################### 构建 chiaki ####################

mkdir -p build
pushd build
cmake .. -DCMAKE_BUILD_TYPE=Release \
-DCHIAKI_ENABLE_TESTS=OFF \
-DCHIAKI_ENABLE_CLI=OFF \
-DCHIAKI_ENABLE_GUI=OFF \
-DCHIAKI_ENABLE_ANDROID=OFF \
-DCHIAKI_ENABLE_BOREALIS=OFF \
-DCHIAKI_ENABLE_SETSU=OFF \
-DCHIAKI_ENABLE_STEAMDECK_NATIVE=OFF \
-DCHIAKI_LIB_ENABLE_OPUS=ON \
-DCHIAKI_ENABLE_SPEEX=OFF \
-DCHIAKI_ENABLE_RUDP=ON \
-DCHIAKI_ENABLE_FFMPEG_DECODER=OFF \
-DCHIAKI_ENABLE_PI_DECODER=OFF \
-DCHIAKI_LIB_ENABLE_MBEDTLS=ON \
-DCHIAKI_LIB_MBEDTLS_EXTERNAL_PROJECT=ON \
-DCHIAKI_LIB_OPENSSL_EXTERNAL_PROJECT=OFF \
-DCHIAKI_GUI_ENABLE_SDL_GAMECONTROLLER=OFF \
-DCHIAKI_CLI_ARGP_STANDALONE=OFF \
-DCHIAKI_ENABLE_STEAM_SHORTCUT=OFF \
-DCHIAKI_USE_SYSTEM_JERASURE=OFF \
-DCHIAKI_USE_SYSTEM_NANOPB=OFF \
-DCHIAKI_USE_SYSTEM_CURL=OFF \
-DCURL_INCLUDE_DIR="../third-party/curl/include" \
-DCURL_LIBRARY="../third-party/curl/build/lib/libcurl.a" \
-DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
-DCMAKE_OSX_ARCHITECTURES="x86_64;arm64"
cmake --build .
