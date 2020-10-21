cmake_minimum_required (VERSION 3.8)
project(vsc2 VERSION 0.1.0)

include(CTest)
enable_testing()

if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/submoules/glog/CMakeLists.txt")
    message(FATAL_ERROR "The submodules glog were not downloaded! Please update submodules with \"git submodule update --init  --recursive \" and try again.")
else()
    # glslang requires c++11
    set(CMAKE_CXX_STANDARD 11)
    message("Building with glog")
    add_subdirectory(submoules/glog)

	#add_definitions(-DUSE_SPECIFIED)
	set(TEST_SUB "0" CACHE INTERNAL "TEST_SUB" )
	add_subdirectory(slibs)
endif()


add_executable(vsc2 main.cpp)
target_link_libraries (vsc2 glog)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)
