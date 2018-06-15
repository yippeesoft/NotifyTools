aux_source_directory (. SRC_LIST)

message(${SRC_LIST})
link_directories(../../../../FaceDetection/build)
link_directories(../../../../FaceAlignment/build)
# add external libraries
find_package(OpenCV REQUIRED)
enable_testing ()
set(src_files 
    SeetaFace.cpp
    )

# Build shared library
add_library(seetaface_lib SHARED ${src_files})
target_link_libraries(
    seetaface_lib
    ${OpenCV_LIBS}
)
set(sftest_required_libs seetaface_lib )

include_directories(${OpenCV_INCLUDE_DIRS})
list(APPEND sftest_required_libs ${OpenCV_LIBS})
add_executable(sftest sftest.cpp)
target_link_libraries(sftest ${sftest_required_libs} viplnet ${OpenCV_LIBS} seeta_facedet_lib seeta_fa_lib opencv_imgproc opencv_highgui opencv_imgcodecs)