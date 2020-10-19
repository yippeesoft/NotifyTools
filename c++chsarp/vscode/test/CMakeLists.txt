cmake_minimum_required (VERSION 3.8)
project(vsc2 VERSION 0.1.0)

include(CTest)
enable_testing()

if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/submoules/log4cplus/CMakeLists.txt")
    message(FATAL_ERROR "The submodules log4cplus were not downloaded! Please update submodules with \"git submodule update --init\" and try again.")
else()
    # glslang requires c++11
    set(CMAKE_CXX_STANDARD 17)
    message("Building with log4cplus")
    add_subdirectory(submoules/log4cplus)
endif()

add_executable(vsc2 main.cpp)
target_link_libraries (vsc2 log4cplus)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)
