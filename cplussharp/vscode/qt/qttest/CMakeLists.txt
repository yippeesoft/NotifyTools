cmake_minimum_required(VERSION 3.10)

PROJECT(example)
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


find_package(Qt5 REQUIRED COMPONENTS Widgets)
SET(QT_DONT_USE_QTGUI TRUE)
include_directories( ${QT_USE_FILE} )


#INCLUDE(${QT_USE_FILE})
ADD_EXECUTABLE(example qtmain.cpp MainWidget1.cpp)
target_link_libraries(example Qt5::Widgets)


