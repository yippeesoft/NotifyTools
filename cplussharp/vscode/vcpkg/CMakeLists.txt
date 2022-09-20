cmake_minimum_required(VERSION 3.22)
 
# 设置VCPKG_ROOT所在的位置
set(VCPKG_ROOT "E:/dev/vcpkg/scripts/buildsystems/vcpkg.cmake" CACHE PATH "")
set(CMAKE_TOOLCHAIN_FILE "E:/dev/vcpkg/scripts/buildsystems/vcpkg.cmake")
 
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# "cmake.configureSettings": {
#   "CMAKE_TOOLCHAIN_FILE": "E:/dev/vcpkg/scripts/buildsystems/vcpkg.cmake",
# }


project(TEST_VCPKG)
find_package(benchmark CONFIG REQUIRED)
find_package(fmt CONFIG REQUIRED)

add_executable(main main.cpp)

target_link_libraries(main PRIVATE fmt::fmt) 
