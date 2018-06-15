aux_source_directory (. SRC_LIST)

message(${SRC_LIST})
link_directories(../../../../FaceDetection/build)
link_directories(../../../../FaceAlignment/build)
# add external libraries
find_package(OpenCV REQUIRED)

set(src_files 
    SeetaFace.cpp
    )

# Build shared library
add_library(seetaface_lib SHARED ${src_files})
set(facedet_required_libs seetaface_lib)