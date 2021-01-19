cmake_minimum_required(VERSION 3.15)

# 打印变量 get_cmake_property(_variableNames VARIABLES) foreach (_variableName
# ${_variableNames}) message(STATUS "${_variableName}=${${_variableName}}")
# endforeach()
project(vscc VERSION 0.1.0)
set(CMAKE_CXX_STANDARD 17)
if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/submodules/spdlog/CMakeLists.txt")
  message(
    FATAL_ERROR
      "The submodules spdlog were not downloaded! Please update submodules with \"git submodule update --init  --recursive \" and try again."
  )
else()

  add_subdirectory(submodules/spdlog)
  add_subdirectory(submodules/googletest)
  add_subdirectory(submodules/log4cplus)
  message("Building with cpp-httplib")
  set(OPENSSL_ROOT_DIR "${workspaceFolder}/openssl-1.1.1i/install")
  set(OPENSSL_INCLUDE_DIR "${workspaceFolder}/openssl-1.1.1i/install/include")
  set(OPENSSL_CRYPTO_LIBRARY "${workspaceFolder}/openssl-1.1.1i/install/lib")
  find_package(
    OpenSSL "1.1.1"
    COMPONENTS Crypto SSL
    REQUIRED)
  if(OPENSSL_FOUND)
    message(WARNING "OPENSSL_FOUND")
  else()
    message(WARNING "OPENSSL_NOT_FOUND")
  endif()
  add_subdirectory(submodules/cpp-httplib)
endif()

add_subdirectory(cplussharp/vscode)
