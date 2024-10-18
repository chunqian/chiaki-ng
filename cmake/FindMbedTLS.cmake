# FindMbedTLS.cmake
# 查找 MbedTLS 库并提供 MbedTLS::mbedtls, MbedTLS::mbedcrypto, MbedTLS::mbedx509 目标

# 查找头文件
find_path(MbedTLS_INCLUDE_DIR mbedtls PATH_SUFFIXES include)

# 查找库文件
find_library(MbedTLS_LIBRARY NAMES mbedtls)
find_library(MbedCrypto_LIBRARY NAMES mbedcrypto)
find_library(MbedX509_LIBRARY NAMES mbedx509)

# 使用 find_package_handle_standard_args 来检查库和包含路径
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MbedTLS
	FOUND_VAR MbedTLS_FOUND
	REQUIRED_VARS
		MbedTLS_LIBRARY
		MbedCrypto_LIBRARY
		MbedX509_LIBRARY
		MbedTLS_INCLUDE_DIR
)

# 如果找到了 MbedTLS
if(MbedTLS_FOUND)
	# 设置库和包含目录
	set(MbedTLS_LIBRARIES ${MbedTLS_LIBRARY} ${MbedCrypto_LIBRARY} ${MbedX509_LIBRARY})
	set(MbedTLS_INCLUDE_DIRS ${MbedTLS_INCLUDE_DIR})

	# 创建 MbedTLS::mbedtls 导入目标
	if(NOT TARGET MbedTLS::mbedtls)
		add_library(MbedTLS::mbedtls UNKNOWN IMPORTED)
		set_target_properties(MbedTLS::mbedtls PROPERTIES
			IMPORTED_LOCATION "${MbedTLS_LIBRARY}"
			INTERFACE_INCLUDE_DIRECTORIES "${MbedTLS_INCLUDE_DIRS}"
		)
	endif()

	# 创建 MbedTLS::mbedcrypto 导入目标
	if(NOT TARGET MbedTLS::mbedcrypto)
		add_library(MbedTLS::mbedcrypto UNKNOWN IMPORTED)
		set_target_properties(MbedTLS::mbedcrypto PROPERTIES
			IMPORTED_LOCATION "${MbedCrypto_LIBRARY}"
			INTERFACE_INCLUDE_DIRECTORIES "${MbedTLS_INCLUDE_DIRS}"
		)
	endif()

	# 创建 MbedTLS::mbedx509 导入目标
	if(NOT TARGET MbedTLS::mbedx509)
		add_library(MbedTLS::mbedx509 UNKNOWN IMPORTED)
		set_target_properties(MbedTLS::mbedx509 PROPERTIES
			IMPORTED_LOCATION "${MbedX509_LIBRARY}"
			INTERFACE_INCLUDE_DIRECTORIES "${MbedTLS_INCLUDE_DIRS}"
		)
	endif()
endif()
