#porting-thirdparty-cmake

project(testcmake)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)
#target_link_libraries("/home/sf/openhormony-master/out/ohos-arm-release/obj/third_party/musl/usr/lib/arm-linux-ohosmusl/")
set(OHOS_SYSROOT_PATH "/home/sf/openhormony-master/out/ohos-arm-release/obj/third_party/musl/")
SET(SYSROOT_PATH "/home/sf/openhormony-master/out/ohos-arm-release/packages/phone/system/bin/")

set(CMAKE_CROSSCOMPILING TRUE)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_CXX_COMPILER_ID Clang)
set(CMAKE_TOOLCHAIN_PREFIX llvm-)
#指定c编译工具（确保工具链所在路径已经添加到了PATH环境变量中）和编译标志，使用clang编译时标志中必须指定--target，否则无法交叉编译。
set(CMAKE_C_COMPILER clang)
set(CMAKE_C_FLAGS "--target=arm-linux-ohosmusl -D__clang__ -march=armv7-a -w")
#指定c++编译工具（确保工具链所在路径已经添加到了PATH环境变量中）和编译标志，必须指定--target，否则无法交叉编译。
set(CMAKE_CXX_COMPILER clang++) 
set(CMAKE_CXX_FLAGS "--target=arm-linux-ohosmusl -D__clang__ -march=armv7-a -w")
#指定链接工具和链接标志，必须指定--target和--sysroot，其中OHOS_ROOT_PATH可通过cmake命令后缀参数来指定。
set(MY_LINK_FLAGS "--target=arm-linux-ohosmusl --sysroot=${OHOS_SYSROOT_PATH}")
set(CMAKE_LINKER clang)
set(CMAKE_CXX_LINKER clang++)
set(CMAKE_C_LINKER clang)
set(CMAKE_C_LINK_EXECUTABLE
    "${CMAKE_C_LINKER} ${MY_LINK_FLAGS} <FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
set(CMAKE_CXX_LINK_EXECUTABLE
    "${CMAKE_CXX_LINKER} ${MY_LINK_FLAGS} <FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>")
#指定链接库的查找路径。
set(CMAKE_SYSROOT ${OHOS_SYSROOT_PATH})

add_executable(testcmake testcmake.cpp)