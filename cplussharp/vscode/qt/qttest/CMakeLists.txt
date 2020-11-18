cmake_minimum_required(VERSION 3.10)
set(PrjName "example")
PROJECT(${PrjName})
set(CMAKE_CXX_STANDARD 17)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

if(CMAKE_VERSION VERSION_LESS "3.7.0")
    set(CMAKE_INCLUDE_CURRENT_DIR ON)
endif()

# Add a compiler flag
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")

# Make this a GUI application on Windows
if(WIN32)
    set(CMAKE_WIN32_EXECUTABLE ON)
endif()

if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/stb_image/stb_image.h")
    message(FATAL_ERROR "The submodules stb were not downloaded! Please update submodules with \"git submodule update --init\" and try again.")
else()
    include_directories(${PrjName} SYSTEM PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/stb_image/")
endif()

find_package(Qt5 REQUIRED COMPONENTS Widgets)
SET(QT_DONT_USE_QTGUI TRUE)
include_directories( ${QT_USE_FILE} )


#INCLUDE(${QT_USE_FILE})
ADD_EXECUTABLE(${PrjName} qtmain.cpp MainWidget1.cpp)
target_link_libraries(${PrjName} Qt5::Widgets)


