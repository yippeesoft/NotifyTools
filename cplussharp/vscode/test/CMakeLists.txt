cmake_minimum_required(VERSION 3.15)

project(vsc2 VERSION 0.1.0)

if ( CMAKE_SYSTEM_NAME MATCHES "Windows" )
    set( my_std_pre "/std:" )
else()
    set( my_std_pre "-std=" )
endif()

#set( basic_cxx17 "c++17" )
#set( str_cxx17 "${my_std_pre}${basic_cxx17}" )

#include( CheckCXXCompilerFlag )
#check_cxx_compiler_flag( "${str_cxx17}" _cpp_17_flag_supported )
#if ( _cpp_17_flag_supported )
#    set( CMAKE_CXX_STANDARD 17 )
#endif()

set(CMAKE_CXX_STANDARD 11)
if(WIN32)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
endif()

include(CTest)
enable_testing()



# add_subdirectory(slibs)
# add_subdirectory(sftests)

set(Boost_USE_STATIC_LIBS ON) 
set(Boost_USE_MULTITHREADED ON)  
set(Boost_USE_STATIC_RUNTIME OFF) 
set(BOOST_NO_SYSTEM_PATHS ON)
# set(BOOST_ROOT  "../boost-install")
#find_package(OpenCV 3.1 EXACT REQUIRED PATHS /usr/local/opencv3.1)

#Could NOT find Boost (missing: regex) 
# remove COMPONENTS  regex
# execute_process(COMMAND "${CMAKE_COMMAND}" "-E" "environment")
# : Print out all accessible variables in a script
MESSAGE(STATUS "execute_process")

execute_process(COMMAND "ls" "-l" "../boost-install")

set(Boost_USE_STATIC_LIBS ON)
set(Boost_USE_STATIC_RUNTIME ON)
if(WIN32)
    set(Boost_USE_MULTITHREADED ON)
    set(Boost_ARCHITECTURE "-x64")
    set(Boost_VERSION_MACRO 107500)
    set(Boost_COMPILER "-vc142")
    set(Boost_VERSION_STRING "1_75")
    set(Boost_ADDITIONAL_VERSIONS "1.75.0")
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
endif()
set(Boost_DEBUG ON) 
find_package(Boost COMPONENTS filesystem regex)

if(NOT Boost_FOUND)
    message(FATAL_ERROR "Not found Boost  ${BOOST_ROOT}")
endif()
MESSAGE(STATUS "Boost_INCLUDE_DIRS: ${Boost_INCLUDE_DIRS}")
MESSAGE(STATUS "Boost_LIBRARY_DIRS: ${Boost_LIBRARY_DIRS}")
MESSAGE(STATUS "Boost_LIBRARIES: ${Boost_LIBRARIES}")
# set(BOOST_INCLUDE_DIR "./boost-install/include")

#begin 操作系统检测
MESSAGE(STATUS "operation system is ${CMAKE_SYSTEM}")
IF (CMAKE_SYSTEM_NAME MATCHES "Linux")
    MESSAGE(STATUS "current platform: Linux ")
    # set(BOOST_INCLUDE_DIR "./boost-install/include/")    
ELSEIF (CMAKE_SYSTEM_NAME MATCHES "Windows")
    MESSAGE(STATUS "current platform: Windows")
    #windows install自动加 boost-1_72
    # set(BOOST_INCLUDE_DIR "./boost-install/include/boost-1_72")    
ELSEIF (CMAKE_SYSTEM_NAME MATCHES "FreeBSD")
	MESSAGE(STATUS "current platform: FreeBSD")
ELSE ()
	MESSAGE(STATUS "other platform: ${CMAKE_SYSTEM_NAME}")
ENDIF (CMAKE_SYSTEM_NAME MATCHES "Linux")

# set(BOOST_LIB_DIR "./boost-install/lib")
include_directories("./sftests")
#begin find_package 标准  Boost变量
include_directories(${Boost_INCLUDE_DIRS})
link_directories(${Boost_LIBRARY_DIRS})
add_executable(vsc2 main.cpp)
target_include_directories(vsc2
        PRIVATE
            ${BOOST_INCLUDEDIR})
target_link_libraries (vsc2 glog spdlog::spdlog ${Boost_LIBRARIES})

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)


#FIND_PATH(myHeader hello.h)
#INCLUDE_DIRECTORIES(${myHeader})
#FIND_LIBRARY(HELLO_LIBRARY libhello.so)
#TARGET_LINK_LIBRARIES(main ${HELLO_LIBRARY})