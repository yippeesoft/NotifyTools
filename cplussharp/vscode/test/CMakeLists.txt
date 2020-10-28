cmake_minimum_required (VERSION 3.8)
project(vsc2 VERSION 0.1.0)
if ( CMAKE_SYSTEM_NAME MATCHES "Windows" )
    set( my_std_pre "/std:" )
else()
    set( my_std_pre "-std=" )
endif()

set( basic_cxx17 "c++17" )
set( str_cxx17 "${my_std_pre}${basic_cxx17}" )

include( CheckCXXCompilerFlag )
check_cxx_compiler_flag( "${str_cxx17}" _cpp_17_flag_supported )
if ( _cpp_17_flag_supported )
    set( CMAKE_CXX_STANDARD 17 )
endif()
include(CTest)
enable_testing()

if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/submodules/glog/CMakeLists.txt")
    message(FATAL_ERROR "The submodules glog were not downloaded! Please update submodules with \"git submodule update --init  --recursive \" and try again.")
else()
    # glslang requires c++11
    #set(CMAKE_CXX_STANDARD 11)
    message("Building with glog")
    add_subdirectory(submodules/glog)

	#add_definitions(-DUSE_SPECIFIED)
	set(TEST_SUB "0" CACHE INTERNAL "TEST_SUB" )
	add_subdirectory(slibs)
endif()

set(CMAKE_CXX_STANDARD 11)
set(BOOST_INCLUDE_DIR "./boost-install/include")

MESSAGE(STATUS "operation system is ${CMAKE_SYSTEM}")
IF (CMAKE_SYSTEM_NAME MATCHES "Linux")
    MESSAGE(STATUS "current platform: Linux ")
    set(BOOST_INCLUDE_DIR "./boost-install/include/")    
ELSEIF (CMAKE_SYSTEM_NAME MATCHES "Windows")
    MESSAGE(STATUS "current platform: Windows")
    #windows install自动加 boost-1_72
    set(BOOST_INCLUDE_DIR "./boost-install/include/boost-1_72")    
ELSEIF (CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
	MESSAGE(STATUS "current platform: FreeBSD")
ELSE ()
	MESSAGE(STATUS "other platform: ${CMAKE_SYSTEM_NAME}")
ENDIF (CMAKE_SYSTEM_NAME MATCHES "Linux")

set(BOOST_LIB_DIR "./boost-install/lib")


include_directories(${BOOST_INCLUDE_DIR})
link_directories(${BOOST_LIB_DIR})
add_executable(vsc2 main.cpp)
target_include_directories(vsc2
        PRIVATE
            ${BOOST_INCLUDE_DIR})
target_link_libraries (vsc2 glog)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)
