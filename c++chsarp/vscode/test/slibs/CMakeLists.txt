cmake_minimum_required(VERSION 2.8)
aux_source_directory(. DIR_LIBS_SRCS)
add_library(slibs ${DIR_LIBS_SRCS})