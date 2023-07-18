cmake_minimum_required(VERSION 3.16)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")

# See docs/release_checklist.md
set(MAJOR_VERSION 2)
set(MINOR_VERSION 6)
set(MICRO_VERSION 3)
set(SDL_REQUIRED_VERSION 2.0.9)

# For historical reasons this is 3.0.0 rather than the expected 1.0.0
set(DYLIB_COMPATIBILITY_VERSION "3.0.0")

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
  message(
    FATAL_ERROR
      "Prevented in-tree built. Please create a build directory outside of the SDL_image source code and call cmake from there"
  )
endif()

project(SDL2_image)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
message(STATUS "Configuring ${PROJECT_NAME} ${PROJECT_VERSION}")

# Set defaults preventing destination file conflicts
set(SDL2IMAGE_DEBUG_POSTFIX
    "d"
    CACHE STRING "Name suffix for debug builds")
mark_as_advanced(SDL2IMAGE_DEBUG_POSTFIX)

# Assume MSVC projects don't have a package manager and need vendored
# dependencies (by default). Most other platforms have some kind of package
# manager. FIXME: consider a package manager such as conan/vcpkg instead of
# vendoring
if(MSVC)
  set(vendored_default ON)
else()
  set(vendored_default OFF)
endif()

include(CMakeDependentOption)
include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

option(CMAKE_POSITION_INDEPENDENT_CODE "Build static libraries with -fPIC" ON)
option(BUILD_SHARED_LIBS "Build the library as a shared library" ON)

option(SDL2IMAGE_INSTALL "Enable SDL2_image install target" ON)
option(SDL2IMAGE_DEPS_SHARED "Load dependencies dynamically" ON)
option(SDL2IMAGE_VENDORED "Use vendored third-party libraries"
       ${vendored_default})

option(SDL2IMAGE_SAMPLES "Build the SDL2_image sample program(s)" ON)
cmake_dependent_option(
  SDL2IMAGE_SAMPLES_INSTALL "Install the SDL2_image sample program(s)" OFF
  "SDL2IMAGE_SAMPLES;SDL2IMAGE_INSTALL" OFF)

option(SDL2IMAGE_TESTS "Build unit tests?" OFF)
cmake_dependent_option(SDL2IMAGE_TESTS_INSTALL "Install unit tests?" OFF
                       "SDL2IMAGE_TESTS;SDL2IMAGE_INSTALL" OFF)

option(SDL2IMAGE_BACKEND_STB "Use stb_image for loading JPEG and PNG files" ON)
cmake_dependent_option(
  SDL2IMAGE_BACKEND_WIC "Add WIC backend (Windows Imaging Component)" OFF WIN32
  OFF)
cmake_dependent_option(
  SDL2IMAGE_BACKEND_IMAGEIO "Use native Mac OS X frameworks for loading images"
  ON APPLE OFF)

option(SDL2IMAGE_AVIF "Support loading AVIF images" OFF)
option(SDL2IMAGE_BMP "Support loading BMP images" ON)
option(SDL2IMAGE_GIF "Support loading GIF images" ON)
option(SDL2IMAGE_JPG "Support loading JPEG images" ON)
option(SDL2IMAGE_JXL "Support loading JXL images" OFF)
option(SDL2IMAGE_LBM "Support loading LBM images" ON)
option(SDL2IMAGE_PCX "Support loading PCX images" ON)
option(SDL2IMAGE_PNG "Support loading PNG images" ON)
option(SDL2IMAGE_PNM "Support loading PNM images" ON)
option(SDL2IMAGE_QOI "Support loading QOI images" ON)
option(SDL2IMAGE_SVG "Support loading SVG images" ON)
option(SDL2IMAGE_TGA "Support loading TGA images" ON)
option(SDL2IMAGE_TIF "Support loading TIFF images" OFF)
option(SDL2IMAGE_WEBP "Support loading WEBP images" OFF)
option(SDL2IMAGE_XCF "Support loading XCF images" ON)
option(SDL2IMAGE_XPM "Support loading XPM images" ON)
option(SDL2IMAGE_XV "Support loading XV images" ON)

cmake_dependent_option(SDL2IMAGE_JPG_SAVE "Add JPEG save support" ON
                       SDL2IMAGE_JPG OFF)
cmake_dependent_option(SDL2IMAGE_PNG_SAVE "Add PNG save support" ON
                       SDL2IMAGE_PNG OFF)

set(LIBAVIF_MINIMUM_VERSION "0.9.1")
if(SDL2IMAGE_VENDORED AND SDL2IMAGE_AVIF)
  set(SDL2IMAGE_AVIF_VENDORED ON)
else()
  set(SDL2IMAGE_AVIF_VENDORED OFF)
endif()
cmake_dependent_option(
  SDL2IMAGE_AVIF_SHARED
  "Dynamically load AVIF support (requires shared libavif)"
  ${SDL2IMAGE_DEPS_SHARED} SDL2IMAGE_AVIF OFF)

if(SDL2IMAGE_VENDORED
   AND SDL2IMAGE_JPG
   AND NOT
       (SDL2IMAGE_BACKEND_WIC
        OR SDL2IMAGE_BACKEND_STB
        OR SDL2IMAGE_BACKEND_IMAGEIO))
  set(SDL2IMAGE_JPG_VENDORED ON)
else()
  set(SDL2IMAGE_JPG_VENDORED OFF)
endif()
cmake_dependent_option(
  SDL2IMAGE_JPG_SHARED
  "Dynamically load JPG support (requires shared libjpeg)"
  ${SDL2IMAGE_DEPS_SHARED}
  "SDL2IMAGE_JPG;NOT SDL2IMAGE_BACKEND_WIC;NOT SDL2IMAGE_BACKEND_STB;NOT SDL2IMAGE_BACKEND_IMAGEIO"
  OFF)

if(SDL2IMAGE_VENDORED AND SDL2IMAGE_JXL)
  set(SDL2IMAGE_JXL_VENDORED ON)
else()
  set(SDL2IMAGE_JXL_VENDORED OFF)
endif()
cmake_dependent_option(
  SDL2IMAGE_JXL_SHARED "Dynamically load JXL support (requires shared libjxl)"
  ${SDL2IMAGE_DEPS_SHARED} SDL2IMAGE_JXL OFF)

if(SDL2IMAGE_VENDORED
   AND SDL2IMAGE_PNG
   AND NOT
       (SDL2IMAGE_BACKEND_WIC
        OR SDL2IMAGE_BACKEND_STB
        OR SDL2IMAGE_BACKEND_IMAGEIO))
  set(SDL2IMAGE_PNG_VENDORED ON)
else()
  set(SDL2IMAGE_PNG_VENDORED OFF)
endif()
cmake_dependent_option(
  SDL2IMAGE_PNG_SHARED
  "Dynamically load PNG support (requires shared libpng)"
  ${SDL2IMAGE_DEPS_SHARED}
  "SDL2IMAGE_PNG;NOT SDL2IMAGE_BACKEND_WIC;NOT SDL2IMAGE_BACKEND_STB;NOT SDL2IMAGE_BACKEND_IMAGEIO"
  OFF)

if(SDL2IMAGE_VENDORED AND SDL2IMAGE_TIF)
  set(SDL2IMAGE_TIF_VENDORED ON)
else()
  set(SDL2IMAGE_TIF_VENDORED OFF)
endif()
cmake_dependent_option(
  SDL2IMAGE_TIF_SHARED
  "Dynamically load TIFF support (requires shared libtiff)"
  ${SDL2IMAGE_DEPS_SHARED} SDL2IMAGE_TIF OFF)

if(SDL2IMAGE_VENDORED AND SDL2IMAGE_WEBP)
  set(SDL2IMAGE_WEBP_VENDORED ON)
else()
  set(SDL2IMAGE_WEBP_VENDORED OFF)
endif()
cmake_dependent_option(
  SDL2IMAGE_WEBP_SHARED
  "Dynamically load WEBP support (requires shared libwebp)"
  ${SDL2IMAGE_DEPS_SHARED} SDL2IMAGE_WEBP OFF)

if(SDL2IMAGE_PNG_VENDORED)
  set(SDL2IMAGE_ZLIB ON)
else()
  set(SDL2IMAGE_ZLIB OFF)
endif()

if(SDL2IMAGE_VENDORED AND SDL2IMAGE_PNG_VENDORED)
  set(SDL2IMAGE_ZLIB_VENDORED ON)
else()
  set(SDL2IMAGE_ZLIB_VENDORED OFF)
endif()
if(SDL2IMAGE_PNG_SHARED)
  set(SDL2IMAGE_ZLIB_SHARED ON)
else()
  set(SDL2IMAGE_ZLIB_SHARED OFF)
endif()

# Save BUILD_SHARED_LIBS variable
set(SDL2IMAGE_BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})

if(SDL2IMAGE_BUILD_SHARED_LIBS)
  set(sdl2_image_export_name SDL2_image)
  set(sdl2_image_install_name_infix shared)
  set(sdl2_target_name SDL2::SDL2)
else()
  set(sdl2_image_export_name SDL2_image-static)
  set(sdl2_image_install_name_infix static)
  set(sdl2_target_name SDL2::SDL2-static)
endif()

set(SDL2_DIR "G:/SFDEV/github-webview/SDL/build/inst/cmake")
find_package(SDL2)
set(SDL2_Image_DIR "G:/SFDEV/github-webview/SDL_image/build/inst/cmake/")
find_package(SDL2_Image)
# Set PROJECT_VERSION of subprojects to "" if it's project call does not set
# VERSION
cmake_policy(SET CMP0048 NEW)

# Allow cmake_dependent_option to use "Full Condition Syntax"
if(POLICY CMP0127)
  cmake_policy(SET CMP0127 NEW)
endif()

# OpenGL is required by dependencies of (dependencies of) some vendored
# libraries
if(NOT DEFINED OpenGL_GL_PREFERENCE)
  set(OpenGL_GL_PREFERENCE GLVND)
endif()

if(SDL2IMAGE_BUILD_SHARED_LIBS)
  # Make sure static library dependencies are built with -fPIC when building a
  # shared SDL2_image
  set(CMAKE_POSITION_INDEPENDENT_CODE ON)
endif()

set(INSTALL_EXTRA_TARGETS)
set(PC_LIBS)
set(PC_REQUIRES)

set(SDL2IMAGE_SAMPLES ON)
if(SDL2IMAGE_SAMPLES)

  add_executable(showimage showimage.cpp)

  # find_package(SDL2main)

  foreach(prog showimage)
    set(SDL2::SDL2main
        "G:/SFDEV/github-webview/SDL/build/inst/lib/SDL2maind.lib")

    target_link_libraries(${prog} PRIVATE SDL2_image::${sdl2_image_export_name})
    if(TARGET SDL2::SDL2main)
      target_link_libraries(${prog} PRIVATE SDL2::SDL2main)
    endif()
    target_link_libraries(${prog} PRIVATE ${sdl2_target_name})

    if(SDL2IMAGE_SAMPLES_INSTALL)
      install(TARGETS ${prog} RUNTIME DESTINATION "{CMAKE_INSTALL_BINDIR}")
    endif()
  endforeach()
endif()

# add_library(SDL2::image INTERFACE IMPORTED GLOBAL)
# set_target_properties(SDL2::image PROPERTIES INTERFACE_LINK_LIBRARIES
# "SDL2_image") if(CMAKE_VERSION VERSION_GREATER_EQUAL "3.17")
# set_target_properties( SDL2::image PROPERTIES DEPRECATION "Use
# SDL2_image::SDL2_image or SDL2_image::SDL2_image-static instead") endif()
