cmake_minimum_required(VERSION 3.15)

# 打印变量 get_cmake_property(_variableNames VARIABLES) foreach (_variableName
# ${_variableNames}) message(STATUS "${_variableName}=${${_variableName}}")
# endforeach()
project(vscc VERSION 0.1.0)

if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/submodules/spdlog/CMakeLists.txt")
  message(
    FATAL_ERROR
      "The submodules spdlog were not downloaded! Please update submodules with \"git submodule update --init  --recursive \" and try again."
  )
else()
  message("Building with spdlog")
  add_subdirectory(submodules/spdlog)
  add_subdirectory(submodules/googletest)
  add_subdirectory(submodules/log4cplus)
endif()

add_subdirectory(cplussharp/vscode)
