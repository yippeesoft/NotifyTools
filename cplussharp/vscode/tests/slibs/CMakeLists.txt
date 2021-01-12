aux_source_directory(. DIR_LIBS_SRCS)
# set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
# set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
# set(CMAKE_LINKER_FLAGS_DEBUG "${CMAKE_LINKER_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
# add_definitions(-fsanitize=address -g3 -fno-omit-frame-pointer)

add_executable(slibs ${DIR_LIBS_SRCS})
target_link_libraries (slibs spdlog::spdlog )