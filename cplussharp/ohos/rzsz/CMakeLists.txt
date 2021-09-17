project(rzz)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_LINKER clang)
set(CMAKE_CXX_LINKER clang++)

add_executable(rzz rz.c)