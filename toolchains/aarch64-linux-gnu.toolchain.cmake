set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(CMAKE_C_COMPILER "aarch64-linux-gnu-gcc")
set(CMAKE_CXX_COMPILER "aarch64-linux-gnu-g++")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CMAKE_C_FLAGS "-march=armv8-a")
set(CMAKE_CXX_FLAGS "-march=armv8-a")

# cache flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "c flags")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}" CACHE STRING "c++ flags")
#-DHTTPLIB_REQUIRE_OPENSSL=OFF  -DOPENSSL_ROOT_DIR=${CMAKE_SOURCE_DIR}/openssl-1.1.1i/install    
#-DOPENSSL_INCLUDE_DIR=${CMAKE_SOURCE_DIR}/openssl-1.1.1i/install/include     
#-DOPENSSL_CRYPTO_LIBRARY=../openssl-1.1.1i/install/lib/libcrypto.a    
#-DOPENSSL_SSL_LIBRARY=../openssl-1.1.1i/install/lib/libssl.a
set(OPENSSL_ROOT_DIR  "${CMAKE_SOURCE_DIR}/openssl-1.1.1i/install") 
set(OPENSSL_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/openssl-1.1.1i/install/include")
set(OPENSSL_CRYPTO_LIBRARY "${CMAKE_SOURCE_DIR}/openssl-1.1.1i/install/lib/libcrypto.a")
set(DOPENSSL_SSL_LIBRARY "${CMAKE_SOURCE_DIR}/openssl-1.1.1i/install/lib/libssl.a")
set(HTTPLIB_REQUIRE_OPENSSL OFF)
