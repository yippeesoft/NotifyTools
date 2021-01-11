aux_source_directory(. DIR_LIBS_SRCS)
add_executable(slibs ${DIR_LIBS_SRCS})
target_link_libraries (slibs spdlog::spdlog)