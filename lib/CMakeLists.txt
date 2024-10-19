
set(HEADER_FILES
        include/chiaki/session.h
        include/chiaki/common.h
        include/chiaki/sock.h
        include/chiaki/thread.h
        include/chiaki/base64.h
        include/chiaki/http.h
        include/chiaki/log.h
        include/chiaki/ctrl.h
        include/chiaki/rpcrypt.h
        include/chiaki/takion.h
        include/chiaki/senkusha.h
        include/chiaki/streamconnection.h
        include/chiaki/ecdh.h
        include/chiaki/launchspec.h
        include/chiaki/random.h
        include/chiaki/gkcrypt.h
        include/chiaki/audio.h
        include/chiaki/audioreceiver.h
        include/chiaki/audiosender.h
        include/chiaki/video.h
        include/chiaki/videoreceiver.h
        include/chiaki/frameprocessor.h
        include/chiaki/packetstats.h
        include/chiaki/seqnum.h
        include/chiaki/discovery.h
        include/chiaki/congestioncontrol.h
        include/chiaki/stoppipe.h
        include/chiaki/reorderqueue.h
        include/chiaki/discoveryservice.h
        include/chiaki/feedback.h
        include/chiaki/feedbacksender.h
        include/chiaki/controller.h
        include/chiaki/takionsendbuffer.h
        include/chiaki/time.h
        include/chiaki/fec.h
        include/chiaki/regist.h
        include/chiaki/opusdecoder.h
        include/chiaki/opusencoder.h
        include/chiaki/orientation.h
        include/chiaki/bitstream.h
        include/chiaki/remote/holepunch.h
        include/chiaki/remote/rudp.h
        include/chiaki/remote/rudpsendbuffer.h)

set(SOURCE_FILES
        src/common.c
        src/sock.c
        src/session.c
        src/thread.c
        src/base64.c
        src/http.c
        src/log.c
        src/ctrl.c
        src/rpcrypt.c
        src/takion.c
        src/senkusha.c
        src/utils.h
        src/pb_utils.h
        src/streamconnection.c
        src/ecdh.c
        src/launchspec.c
        src/random.c
        src/gkcrypt.c
        src/audio.c
        src/audioreceiver.c
        src/audiosender.c
        src/videoreceiver.c
        src/frameprocessor.c
        src/packetstats.c
        src/discovery.c
        src/congestioncontrol.c
        src/stoppipe.c
        src/reorderqueue.c
        src/discoveryservice.c
        src/feedback.c
        src/feedbacksender.c
        src/controller.c
        src/takionsendbuffer.c
        src/time.c
        src/fec.c
        src/regist.c
        src/opusdecoder.c
        src/opusencoder.c
        src/orientation.c
        src/bitstream.c
        src/remote/holepunch.c
        src/remote/rudp.c
        src/remote/rudpsendbuffer.c)

if(CHIAKI_ENABLE_FFMPEG_DECODER)
    list(APPEND HEADER_FILES include/chiaki/ffmpegdecoder.h)
    list(APPEND SOURCE_FILES src/ffmpegdecoder.c)
endif()
set(CHIAKI_LIB_ENABLE_PI_DECODER "${CHIAKI_ENABLE_FFMPEG_DECODER}")

if(CHIAKI_ENABLE_PI_DECODER)
    list(APPEND HEADER_FILES include/chiaki/pidecoder.h)
    list(APPEND SOURCE_FILES src/pidecoder.c)
endif()
set(CHIAKI_LIB_ENABLE_PI_DECODER "${CHIAKI_ENABLE_PI_DECODER}")

add_subdirectory(protobuf)
set_source_files_properties(${CHIAKI_LIB_PROTO_SOURCE_FILES} ${CHIAKI_LIB_PROTO_HEADER_FILES} PROPERTIES GENERATED TRUE)
include_directories("${CHIAKI_LIB_PROTO_INCLUDE_DIR}")

add_library(chiaki-lib ${HEADER_FILES} ${SOURCE_FILES} ${CHIAKI_LIB_PROTO_SOURCE_FILES} ${CHIAKI_LIB_PROTO_HEADER_FILES})
configure_file(config.h.in include/chiaki/config.h)
target_include_directories(chiaki-lib PUBLIC "${CMAKE_CURRENT_BINARY_DIR}/include")

if(CMAKE_C_COMPILER_ID STREQUAL GNU OR CMAKE_C_COMPILER_ID STREQUAL Clang)
    target_compile_options(chiaki-lib PRIVATE -Wall)
endif()

add_dependencies(chiaki-lib chiaki-pb)
set_target_properties(chiaki-lib PROPERTIES OUTPUT_NAME chiaki)

if(WIN32)
    target_link_libraries(chiaki-lib wsock32 ws2_32 bcrypt iphlpapi)
endif()

if(APPLE)
    target_link_libraries(chiaki-lib "-framework CoreServices")
endif()

target_include_directories(chiaki-lib PUBLIC "${CMAKE_SOURCE_DIR}/lib/include")

find_package(Threads REQUIRED)
target_link_libraries(chiaki-lib Threads::Threads)

#################### json-c ####################

target_include_directories(chiaki-lib PRIVATE "${CMAKE_SOURCE_DIR}/third-party/json-c")

# 手动查找 json-c 库, 优先查找自定义路径
find_library(JSONC_LIB NAMES json-c HINTS "${CMAKE_SOURCE_DIR}/third-party/json-c/build")

# 如果找到库, 打印路径并链接
if (JSONC_LIB)
    message(STATUS "Found json-c at: ${JSONC_LIB}")
    target_link_libraries(chiaki-lib ${JSONC_LIB})
else()
    message(FATAL_ERROR "Could not find json-c library.")
endif()

#################### miniupnpc ####################

target_include_directories(chiaki-lib PRIVATE "${CMAKE_SOURCE_DIR}/third-party/miniupnp/miniupnpc/include")

# 手动查找 miniupnpc 库, 优先查找自定义路径
find_library(MINIUPNPC_LIB NAMES miniupnpc HINTS "${CMAKE_SOURCE_DIR}/third-party/miniupnp/miniupnpc/build")

# 如果找到库, 打印路径并链接
if (MINIUPNPC_LIB)
    message(STATUS "Found miniupnpc at: ${MINIUPNPC_LIB}")
    target_link_libraries(chiaki-lib ${MINIUPNPC_LIB})
else()
    message(FATAL_ERROR "Could not find miniupnpc library.")
endif()

#################### opus ####################

if(CHIAKI_LIB_ENABLE_OPUS)
    add_definitions(-DCHIAKI_LIB_ENABLE_MBEDTLS)
    target_include_directories(chiaki-lib PRIVATE "${CMAKE_SOURCE_DIR}/third-party/opus/include")

    # 手动查找 opus 库, 优先查找自定义路径
    find_library(OPUS_LIB NAMES opus HINTS "${CMAKE_SOURCE_DIR}/third-party/opus/build")

    # 如果找到库, 打印路径并链接
    if (OPUS_LIB)
        message(STATUS "Found opus at: ${OPUS_LIB}")
        target_link_libraries(chiaki-lib ${OPUS_LIB})
    else()
        message(FATAL_ERROR "Could not find opus library.")
    endif()
endif()

#################### mbedtls ####################

if(CHIAKI_LIB_ENABLE_MBEDTLS)
    if(CHIAKI_LIB_MBEDTLS_EXTERNAL_PROJECT)
        target_include_directories(chiaki-lib PRIVATE "${CMAKE_SOURCE_DIR}/third-party/mbedtls/include")

        # 手动查找 mbedtls 库, 优先查找自定义路径
        find_library(MBEDTLS_LIB NAMES mbedtls HINTS "${CMAKE_SOURCE_DIR}/third-party/mbedtls/build/library")
        find_library(MBEDX509_LIB NAMES mbedx509 HINTS "${CMAKE_SOURCE_DIR}/third-party/mbedtls/build/library")
        find_library(MBEDCRYPTO_LIB NAMES mbedcrypto HINTS "${CMAKE_SOURCE_DIR}/third-party/mbedtls/build/library")

        # 检查是否找到库
        if (MBEDTLS_LIB AND MBEDX509_LIB AND MBEDCRYPTO_LIB)
            message(STATUS "Found mbedtls libraries:")
            message(STATUS " - mbedtls: ${MBEDTLS_LIB}")
            message(STATUS " - mbedx509: ${MBEDX509_LIB}")
            message(STATUS " - mbedcrypto: ${MBEDCRYPTO_LIB}")

            # 链接库到 chiaki-lib
            target_link_libraries(chiaki-lib ${MBEDTLS_LIB} ${MBEDX509_LIB} ${MBEDCRYPTO_LIB})
        else()
            message(FATAL_ERROR "Could not find all required mbedtls libraries.")
        endif()
    else()
        # provided by mbedtls-static (mbedtls-devel)
        find_library(MBEDTLS mbedtls)
        find_library(MBEDX509 mbedx509)
        find_library(MBEDCRYPTO mbedcrypto)
        target_link_libraries(chiaki-lib ${MBEDTLS} ${MBEDX509} ${MBEDCRYPTO})
    endif()
elseif(CHIAKI_LIB_OPENSSL_EXTERNAL_PROJECT)
    target_link_libraries(chiaki-lib OpenSSL_Crypto)
else()
    # default
    find_package(OpenSSL REQUIRED)
    target_link_libraries(chiaki-lib OpenSSL::Crypto)
endif()

if (CHIAKI_USE_SYSTEM_CURL)
    target_link_libraries(chiaki-lib CURL::libcurl_shared)
else()
    target_link_libraries(chiaki-lib CURL::libcurl_static)
endif()
target_link_libraries(chiaki-lib Nanopb::nanopb)
target_link_libraries(chiaki-lib Jerasure::Jerasure)

if(CHIAKI_ENABLE_FFMPEG_DECODER)
    target_link_libraries(chiaki-lib FFMPEG::avcodec FFMPEG::avutil)
endif()

if(CHIAKI_ENABLE_PI_DECODER)
    target_link_libraries(chiaki-lib ILClient::ILClient)
endif()

if(CHIAKI_LIB_ENABLE_OPUS)
    target_link_libraries(chiaki-lib ${Opus_LIBRARIES})
endif()

# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fanalyzer")
if(CHIAKI_ENABLE_TESTS)
    add_executable(holepunch-test include/chiaki/remote/holepunch.h src/remote/holepunch-test.c)
    target_link_libraries(holepunch-test chiaki-lib)
endif()