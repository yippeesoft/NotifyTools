# aux_source_directory(. DIR_UTILTEST_SRCS)
macro(sf_add_unittest name)
  set(CMAKE_CXX_STANDARD 17)
  find_package(
    OpenSSL
    COMPONENTS Crypto SSL
    REQUIRED)
  if(OPENSSL_FOUND)
    message("OPENSSL_FOUND ${name} ${OPENSSL_ROOT_DIR}  ${OPENSSL_SSL_LIBRARY}")
  else()
    message("OPENSSL_NOT_FOUND")
  endif()

  # if(MSVC_VERSION GREATER_EQUAL "1900") include(CheckCXXCompilerFlag)
  # check_cxx_compiler_flag("/std:c++latest" _cpp_latest_flag_supported)
  # if(_cpp_latest_flag_supported) add_compile_options("/std:c++latest") endif()
  # endif()
  if(MSVC)
    # add_compile_options("/std:c++17") add_definitions("-std=c++17")
  endif()
  if(MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /std:c++17")
  endif()
  add_executable(${name} ${name}.cpp)
  target_include_directories(${name} PRIVATE)
  target_link_libraries(
    ${name}
    PRIVATE utils
            -fsanitize=address
            -g3
            -fno-omit-frame-pointer
            ${CURL_LIB_NAME}
            ${OPENSSL_SSL_LIBRARY}
            -rdynamic
            lua
            pugixml
            tinyxml2
            jsoncpp_static)

  # add test to a virtual project group
  set_property(TARGET ${name} PROPERTY FOLDER "examples")
endmacro()
# link_directories("${workspaceFolder}/openssl-1.1.1i/install/lib")
# set(OPENSSL_ROOT_DIR "${workspaceFolder}/openssl-1.1.1i/install")
# set(OPENSSL_INCLUDE_DIR "${workspaceFolder}/openssl-1.1.1i/install/include")
# set(OPENSSL_CRYPTO_LIBRARY "${workspaceFolder}/openssl-1.1.1i/install/lib")
if(BUILD_WITH_QT)
  message(STATUS "qtdir ${Qt5_Dir}")
  execute_process(COMMAND "ls " "-l" "${Qt5_DIR}")
  find_package(Qt5 REQUIRED COMPONENTS Widgets WebEngineWidgets)
  if(Qt5_FOUND)
    message("Qt5_FOUND")
  else()
    message("Qt5_NOT_FOUND")
  endif()
endif()

link_directories("/usr/local/lib")
include_directories(include /usr/local/include)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../utils)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../utils
                    ${CMAKE_CURRENT_SOURCE_DIR}/../submodules/cpp-httplib)

# set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fno-omit-frame-pointer
# -fsanitize=address") set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}
# -fno-omit-frame-pointer -fsanitize=address") set(CMAKE_LINKER_FLAGS_DEBUG
# "${CMAKE_LINKER_FLAGS_DEBUG} -fno-omit-frame-pointer -fsanitize=address")
# add_definitions(-fsanitize=address -g3 -fno-omit-frame-pointer)
include(CTest)
enable_testing()
# add_executable(utilstest ${DIR_UTILTEST_SRCS}) target_link_libraries(
# utilstest spdlog::spdlog utils -fsanitize=address gtest pthread -rdynamic)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)

# sf_add_unittest(singaltest)
sf_add_unittest(log4cplustest)
sf_add_unittest(sloghandletest)
sf_add_unittest(shttphandletest)
sf_add_unittest(scurltest)
sf_add_unittest(sluatest)
sf_add_unittest(sxmltest)
sf_add_unittest(sjsontest)
