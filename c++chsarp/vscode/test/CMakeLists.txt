cmake_minimum_required(VERSION 3.0.0)
project(vsc2 VERSION 0.1.0)

include(CTest)
enable_testing()

find_package (glog 0.3.4 REQUIRED)

add_executable(vsc2 main.cpp)
target_link_libraries (vsc2 glog::glog)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)
