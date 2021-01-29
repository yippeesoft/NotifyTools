cmake_minimum_required(VERSION 3.15)

message("打印变量开始")
get_cmake_property(_variableNames VARIABLES)
foreach(_variableName ${_variableNames})
  # message(STATUS"${_variableName}=${${_variableName}}")
endforeach()
message("打印变量结束 ")
# execute_process(COMMAND "${CMAKE_COMMAND}" "-E" "environment")
message("打印环境变量结束 ")
project(vscc VERSION 0.1.0)
set(CMAKE_CXX_STANDARD 17)
if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/submodules/spdlog/CMakeLists.txt")
  message(
    FATAL_ERROR
      "The submodules spdlog were not downloaded! Please update submodules with \"git submodule update --init  --recursive \" and try again."
  )
else()

  # set(SPDLOG_BUILD_TESTS OFF)
  add_subdirectory(submodules/spdlog)
  # set(INSTALL_GTEST OFF)
  add_subdirectory(submodules/googletest)
  set(LOG4CPLUS_BUILD_TESTING OFF)
  set(WITH_UNIT_TESTS OFF)
  # set(LOG4CPLUS_ENABLE_DECORATED_LIBRARY_NAME OFF) set(UNICODE OFF)
  set(LOG4CPLUS_ENABLE_DECORATED_LIBRARY_NAME
      OFF
      CACHE
        BOOL
        "Turns on resulting file name decoration for static and UNICODE builds."
        FORCE)
  set(UNICODE
      OFF
      CACHE BOOL "Build with tchar = wchar_t" FORCE)
  set(BUILD_SHARED_LIBS FALSE)
  add_subdirectory(submodules/log4cplus)
  # message("Building with cpp-httplib
  # ${workspaceFolder}/openssl-1.1.1i/install") set(OPENSSL_ROOT_DIR
  # "${workspaceFolder}/openssl-1.1.1i/install") set(OPENSSL_INCLUDE_DIR
  # "${workspaceFolder}/openssl-1.1.1i/install/include")
  # set(OPENSSL_CRYPTO_LIBRARY "${workspaceFolder}/openssl-1.1.1i/install/lib")
  # set(HTTPLIB_USE_OPENSSL_IF_AVAILABLE OFF)
  set(BUILD_WITH_QT ON)
  if(CMAKE_C_COMPILER MATCHES ".*arm|aarch64.*")
    set(BUILD_WITH_QT OFF)
    message("CMAKE_C_COMPILER aarch64 ${BUILD_WITH_QT}")
    set(OPENSSL_ROOT_DIR "${CMAKE_SOURCE_DIR}/openssl-1.1.1i/install")
    set(OPENSSL_INCLUDE_DIR
        "${CMAKE_SOURCE_DIR}/openssl-1.1.1i/install/include")
    set(OPENSSL_CRYPTO_LIBRARY
        "${CMAKE_SOURCE_DIR}/openssl-1.1.1i/install/lib/libcrypto.a")
    set(DOPENSSL_SSL_LIBRARY
        "${CMAKE_SOURCE_DIR}/openssl-1.1.1i/install/lib/libssl.a")
  endif()

  if(MSVC)
    message(STATUS "MSVC_FOUND")
    set(OPENSSL_ROOT_DIR "${CMAKE_SOURCE_DIR}/openssl-1.1.1i/installw")
    set(OPENSSL_INCLUDE_DIR
        "${CMAKE_SOURCE_DIR}/openssl-1.1.1i/installw/include")
    set(OPENSSL_CRYPTO_LIBRARY
        "${CMAKE_SOURCE_DIR}/openssl-1.1.1i/installw/lib/libcrypto.lib")
    set(DOPENSSL_SSL_LIBRARY
        "${CMAKE_SOURCE_DIR}/openssl-1.1.1i/installw/lib/libssl.lib")
    set(Qt5_DIR
        "${CMAKE_SOURCE_DIR}/qtvs2019/Qt/5.14.2/msvc2017_64/lib/cmake/Qt5")
  else()
    message(STATUS "${CMAKE_C_COMPILER} NOT MSVC")

  endif()
  include_directories(include submodules/log4cplus/include)
  link_directories("ubmodules/log4cplus/src/${CMAKE_BUILD_TYPE}")
  find_package(
    OpenSSL
    COMPONENTS Crypto SSL
    REQUIRED)
  if(OPENSSL_FOUND)
    message("OPENSSL_FOUND ${name} ${OPENSSL_ROOT_DIR}  ${OPENSSL_SSL_LIBRARY}")    
    include_directories(${workspaceFolder}/openssl-1.1.1i/install/include)
  else()
    message("OPENSSL_NOT_FOUND")
  endif()
  # OPENSSL

  # CURL
  if(MSVC)
    message(STATUS "MSVC_FOUND")
    set(CURL_DIR "${CMAKE_SOURCE_DIR}/curl-7.74.0/installw")
    set(CURL_LIBRARY "${CMAKE_SOURCE_DIR}/curl-7.74.0/installw/lib")
    set(CURL_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/curl-7.74.0/installw/include")     
  endif()
  if(ARM)
    set(CURL_DIR "${CMAKE_SOURCE_DIR}/curl-7.74.0/installa")
    set(CURL_LIBRARY "${CMAKE_SOURCE_DIR}/curl-7.74.0/installa/lib")
    set(CURL_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/curl-7.74.0/installa/include")
  endif()
  find_package(CURL)
  if(CURL_FOUND)
    message("CURL_FOUND ${name} ${CURL_INCLUDE_DIR} ${CURL_LIBRARY}")    
    include_directories(${CMAKE_SOURCE_DIR}/curl-7.74.0/installw/include)
  else()
    message("CURL_NOT_FOUND")
  endif()
  # CURL

  include_directories(include submodules/log4cplus/include)
  link_directories("ubmodules/log4cplus/src/${CMAKE_BUILD_TYPE}")

  add_subdirectory(submodules/cpp-httplib)
  include_directories(include submodules/cpp-httplib/)
endif()

add_subdirectory(cplussharp/vscode)
