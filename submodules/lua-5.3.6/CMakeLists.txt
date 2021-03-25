cmake_minimum_required(VERSION 3.10)
project (LUA C)

# the following two variables are defined for the use of packages 
# that wish to link or compile against lua
set (LUA_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/src")
set (LUA_LIBRARIES lua)

add_subdirectory (src)
# https://github.com/shanfl/Note/blob/9226fdc65781b5a8215992866d384cfcd0d44e9a/lua_cmake.md