# aux_source_directory(. DIR_UTILTEST_SRCS)
macro(sf_add_unittest name)
  set(CMAKE_CXX_STANDARD 17)
  add_executable(${name} ${name}.cpp)
  target_include_directories(${name} PRIVATE)
  target_link_libraries(
    ${name}
    PRIVATE utils
            spdlog::spdlog
            log4cplus
            httplib
            -fsanitize=address
            -g3
            -fno-omit-frame-pointer
            gtest
            pthread
            -rdynamic)

  # add test to a virtual project group
  set_property(TARGET ${name} PROPERTY FOLDER "examples")
endmacro()
# link_directories("${workspaceFolder}/openssl-1.1.1i/install/lib")
# set(OPENSSL_ROOT_DIR "${workspaceFolder}/openssl-1.1.1i/install")
# set(OPENSSL_INCLUDE_DIR "${workspaceFolder}/openssl-1.1.1i/install/include")
# set(OPENSSL_CRYPTO_LIBRARY "${workspaceFolder}/openssl-1.1.1i/install/lib")
find_package(
  OpenSSL
  COMPONENTS Crypto SSL
  REQUIRED)
if(OPENSSL_FOUND)
  message(WARNING "OPENSSL_FOUND")
else()
  message(WARNING "OPENSSL_NOT_FOUND")
endif()
include_directories(${workspaceFolder}/openssl-1.1.1i/install/include)
link_directories("/usr/local/lib")
include_directories(include /usr/local/include)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../utils)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/../utils
                    ${workspaceFolder}/submodules/cpp-httplib)
# set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fno-omit-frame-pointer
# -fsanitize=address") set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}
# -fno-omit-frame-pointer -fsanitize=address") set(CMAKE_LINKER_FLAGS_DEBUG
# "${CMAKE_LINKER_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
# add_definitions(-fsanitize=address -g3 -fno-omit-frame-pointer)
include(CTest)
enable_testing()
# add_executable(utilstest ${DIR_UTILTEST_SRCS}) target_link_libraries(
# utilstest spdlog::spdlog utils -fsanitize=address gtest pthread -rdynamic)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)

# sf_add_unittest(singaltest)
sf_add_unittest(log4cplustest)
sf_add_unittest(sloghandletest)
sf_add_unittest(shttphandletest)
