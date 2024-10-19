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
-DUSE_LIBIDN2=OFF \
-DUSE_APPLE_IDN=ON \
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
-DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
-DCMAKE_OSX_ARCHITECTURES="x86_64;arm64"
cmake --build .

popd
echo $PWD

#################### 构建 chiaki.xcframework ####################

BUILD_DIR="build"
HEADERS_DIR="build/Headers"

mkdir -p "${BUILD_DIR}/XCFramework"

pushd build/lib
echo $PWD

# 公共的头文件列表
COMMON_HEADER_FILES=(
"chiaki/audio.h"
"chiaki/audioreceiver.h"
"chiaki/audiosender.h"
"chiaki/base64.h"
"chiaki/bitstream.h"
"chiaki/common.h"
"chiaki/config.h"
"chiaki/congestioncontrol.h"
"chiaki/controller.h"
"chiaki/ctrl.h"
"chiaki/discovery.h"
"chiaki/discoveryservice.h"
"chiaki/fec.h"
"chiaki/feedback.h"
"chiaki/feedbacksender.h"
"chiaki/frameprocessor.h"
"chiaki/gkcrypt.h"
"chiaki/http.h"
"chiaki/launchspec.h"
"chiaki/log.h"
"chiaki/opusdecoder.h"
"chiaki/opusencoder.h"
"chiaki/orientation.h"
"chiaki/packetstats.h"
"chiaki/random.h"
"chiaki/regist.h"
"chiaki/remote/holepunch.h"
"chiaki/remote/rudp.h"
"chiaki/remote/rudpsendbuffer.h"
"chiaki/reorderqueue.h"
"chiaki/rpcrypt.h"
"chiaki/senkusha.h"
"chiaki/seqnum.h"
"chiaki/session.h"
"chiaki/sock.h"
"chiaki/stoppipe.h"
"chiaki/streamconnection.h"
"chiaki/takion.h"
"chiaki/takionsendbuffer.h"
"chiaki/thread.h"
"chiaki/time.h"
"chiaki/video.h"
"chiaki/videoreceiver.h"
)

# 查找并验证生成的库文件路径
STATIC_LIB_PATH=$(find . -name "libchiaki.a")

# 如果库文件未生成, 抛出错误
if [ -z "$STATIC_LIB_PATH" ]; then
    echo "Error: chiaki 静态库未生成"
    exit 1
fi

# 创建 macOS 和 iOS 的头文件目录
rm -rdf "../Headers-macos"
rm -rdf "../Headers-ios"
mkdir -p "../Headers-macos"
mkdir -p "../Headers-ios"
cp -r "../../lib/include/chiaki" "../Headers-macos"
cp -r "../../lib/include/chiaki" "../Headers-ios"
# for hFile in ${COMMON_HEADER_FILES[@]}; do
#     cp "../../lib/include/${hFile}" "../Headers-macos"
#     cp "../../lib/include/${hFile}" "../Headers-ios"
# done

# chiaki modulemap
MM_OUT_MACOS="module chiaki {\n"
MM_OUT_IOS="module chiaki {\n"

for hFile in ${COMMON_HEADER_FILES[@]}; do
    MM_OUT_MACOS+="    header \"${hFile}\"\n"
    MM_OUT_IOS+="    header \"${hFile}\"\n"
done

MM_OUT_MACOS+="    export *\n    link \"chiaki\"\n"
MM_OUT_IOS+="    export *\n    link \"chiaki\"\n"

MM_OUT_MACOS+="}\n\n"
MM_OUT_IOS+="}\n\n"

# 输出 module map 到相应的目录
printf "%b" "${MM_OUT_MACOS}" > "../Headers-macos/module.modulemap"
printf "%b" "${MM_OUT_IOS}" > "../Headers-ios/module.modulemap"

popd
echo $PWD

rm -rdf "${BUILD_DIR}/XCFramework/chiaki.xcframework"

xcodebuild -create-xcframework \
    -library "build/lib/${STATIC_LIB_PATH}" \
    -headers "${HEADERS_DIR}-macos" \
    -output "${BUILD_DIR}/XCFramework/chiaki.xcframework"

#################### 构建 opus.xcframework ####################

#################### 构建 miniupnpc.xcframework ####################

#################### 构建 jsonc.xcframework ####################

#################### 构建 mbedtls.xcframework ####################

#################### 构建 curl.xcframework ####################
