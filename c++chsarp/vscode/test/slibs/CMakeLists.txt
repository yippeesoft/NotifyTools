cmake_minimum_required(VERSION 2.8)
#option(USE_SPECIFIED "select to use specified function" OFF)
#add_definitions(-DUSE_SPECIFIED)

message("USE_SPECIFIED is ${TEST_SUB}")
if(TEST_SUB )
	MESSAGE( STATUS "this var key = ${TEST_SUB}.")
endif()

aux_source_directory(. DIR_LIBS_SRCS)
add_library(slibs ${DIR_LIBS_SRCS})