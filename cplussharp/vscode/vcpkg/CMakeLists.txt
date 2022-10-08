cmake_minimum_required(VERSION 3.22)

cmake_policy(SET CMP0003 NEW)
project(TEST_VCPKG)
# 设置VCPKG_ROOT所在的位置
set(VCPKG_ROOT
    "E:/dev/vcpkg/scripts/buildsystems/vcpkg.cmake"
    CACHE PATH "")
set(CMAKE_TOOLCHAIN_FILE "E:/dev/vcpkg/scripts/buildsystems/vcpkg.cmake")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# "cmake.configureSettings": { "CMAKE_TOOLCHAIN_FILE":
# "E:/dev/vcpkg/scripts/buildsystems/vcpkg.cmake", }

find_package(benchmark CONFIG REQUIRED)
find_package(fmt CONFIG REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(nlohmann_json CONFIG REQUIRED)
find_package(libhv CONFIG REQUIRED)
find_package(Boost REQUIRED)

add_executable(main main.cpp)
message(STATUS "OpenSSL_LIBRARIES =  ${OpenSSL_LIBRARIES}.")
target_link_libraries(
  main
  PRIVATE fmt::fmt
          ${OPENSSL_LIBRARIES}
          nlohmann_json::nlohmann_json
          hv
          Boost::boost
          OpenSSL::Crypto
          OpenSSL::SSL)

# fetchcontent重点来了
# -------------------------------------------------------------------
# include(fetchcontent) fetchcontent_declare(   spdlog  #库名字 GIT_REPOSITORY
# https://gitee.com/mohistH/spdlog.git     # 仓库地址 GIT_TAG v1.x # 库版本 SOURCE_DIR
# ${CMAKE_CURRENT_SOURCE_DIR}/ext/spdlog # 指定库下载地址 )
# fetchcontent_makeavailable(spdlog)
