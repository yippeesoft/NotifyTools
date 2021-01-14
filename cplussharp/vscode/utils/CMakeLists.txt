aux_source_directory(. DIR_UTILS_SRCS)
link_directories("/usr/local/lib")
include_directories(include /usr/local/include)

# set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fno-omit-frame-pointer
# -fsanitize=address") set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}
# -fno-omit-frame-pointer -fsanitize=address") set(CMAKE_LINKER_FLAGS_DEBUG
# "${CMAKE_LINKER_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
# add_definitions(-fsanitize=address -g3 -fno-omit-frame-pointer)
# -fsanitize=address
include(CTest)
enable_testing()
add_library(utils ${DIR_UTILS_SRCS})
target_link_libraries(utils spdlog::spdlog gtest pthread log4cplus log4cplus)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)
