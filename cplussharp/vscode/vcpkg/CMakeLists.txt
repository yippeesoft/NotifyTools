# cmake_minimum_required(VERSION 3.22)
set(CMAKE_CXX_STANDARD 20)
if(CMAKE_COMPILER_IS_GNUCXX)
  # 检查GNU编译是否支持 -Wa,-mbig-obj
  include(CheckCXXCompilerFlag)
  check_cxx_compiler_flag("-Wa,-mbig-obj" GNU_BIG_OBJ_FLAG_ENABLE)
  message(STATUS GNU_BIG_OBJ_FLAG_ENABLE=${GNU_BIG_OBJ_FLAG_ENABLE})
endif()
add_compile_options("$<$<C_COMPILER_ID:MSVC>:/utf-8>")
add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")

# file too big
add_compile_options("$<$<C_COMPILER_ID:MSVC>:/bigobj>")
add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/bigobj>")

# add_compile_options("$<$<C_COMPILER_ID:GNU>:-Wa,-mbig-obj>")
# add_compile_options("$<$<CXX_COMPILER_ID:GNU>:-Wa,-mbig-obj>")

# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Os -Wall -s") set(CMAKE_CXX_FLAGS
# "${CMAKE_CXX_FLAGS} -Os -Wall -s -Wno-unknown-pragmas -Wno-unused-variable")
# https://stackoverflow.com/questions/68165932/cannot-build-boost-asio-with-clang-12-on-windows
# msvc clang编译asio失败

# vs2022会自动加上 1> Environment settings: CXXFLAGS=-fsanitize=address
# CFLAGS=-fsanitize=address 需要在cmakesetting中查找删除

# vs2022使用asan导致asio等运行报错 set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fsanitize=address
# -fno-omit-frame-pointer /std:c++20  ")

# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}  -fsanitize=address
# -fno-omit-frame-pointer  /std:c++20  ")

# set(CMAKE_LINKER_FLAGS "${CMAKE_LINKER_FLAGS} -fsanitize=address
# -fsanitize-recover=address -fno-omit-frame-pointer -O0 -Wall  -lasan -lstdc++
# /std:c++20  " )

# set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fsanitize=address
# -lasan -lstdc++ /std:c++20  ")

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
find_package(glog CONFIG REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(nlohmann_json CONFIG REQUIRED)
find_package(libhv CONFIG REQUIRED)

# SET(Boost_USE_STATIC_LIBS ON)
set(CMAKE_LINKER_FLAGS "${CMAKE_LINKER_FLAGS} -DBOOST_LOG_DYN_LINK ")
find_package(Boost REQUIRED COMPONENTS thread coroutine coroutine log log_setup)
# find_package(glog REQUIRED)

add_executable(main main.cpp)
find_path(CPPCODEC_INCLUDE_DIRS "cppcodec/base32_crockford.hpp")
target_include_directories(main PRIVATE ${CPPCODEC_INCLUDE_DIRS})


message(STATUS "OpenSSL_LIBRARIES =  ${OpenSSL_LIBRARIES}.")
message(
  STATUS
    "Boost_LIBRARIES =  ${Boost_LIBRARIES}.  ${Boost_LOG_LIBRARY} ${Boost_LOG_SETUP_LIBRARY})"
)
target_link_libraries(
  main
  PRIVATE fmt::fmt
          ${OPENSSL_LIBRARIES}
          nlohmann_json::nlohmann_json
          hv
          Boost::boost
          Boost::thread
          Boost::coroutine
          Boost::filesystem
          glog::glog
          ${Boost_LOG_LIBRARY}
          ${Boost_LOG_SETUP_LIBRARY}
          OpenSSL::Crypto
          OpenSSL::SSL)

# fetchcontent重点来了
# -------------------------------------------------------------------
# include(fetchcontent) fetchcontent_declare(   spdlog  #库名字 GIT_REPOSITORY
# https://gitee.com/mohistH/spdlog.git     # 仓库地址 GIT_TAG v1.x # 库版本 SOURCE_DIR
# ${CMAKE_CURRENT_SOURCE_DIR}/ext/spdlog # 指定库下载地址 )
# fetchcontent_makeavailable(spdlog)
