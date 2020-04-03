LOCAL_PATH := $(call my-dir)

###########################
#
# MAIN shared library
#
###########################

include $(CLEAR_VARS)

 

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_C_INCLUDES)

LOCAL_SRC_FILES := \
	$(subst $(LOCAL_PATH)/,, \
	$(LOCAL_PATH)/*.c) \
	jymain.c \
	$(wildcard $(LOCAL_PATH)/*.c) )



LOCAL_CFLAGS += -DGL_GLEXT_PROTOTYPES
LOCAL_CFLAGS += \
	-Wall -Wextra \
	-Wdocumentation \
	-Wdocumentation-unknown-command \
	-Wmissing-prototypes \
	-Wunreachable-code-break \
	-Wunneeded-internal-declaration \
	-Wmissing-variable-declarations \
	-Wfloat-conversion \
	-Wshorten-64-to-32 \
	-Wunreachable-code-return \
	-Wshift-sign-overflow \
	-Wstrict-prototypes \
	-Wkeyword-macro \
 
 
LOCAL_LDLIBS := -ldl -lGLESv1_CM -lGLESv2 -lOpenSLES -llog -landroid

ifeq ($(NDK_DEBUG),1)
    cmd-strip :=
endif
 
 
  

LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
  
 

LOCAL_LDFLAGS += $(LOCAL_PATH)/libSDL2.so $(LOCAL_PATH)/liblua.so  $(LOCAL_PATH)/libSDL2_image.so $(LOCAL_PATH)/libSDL2_ttf.so $(LOCAL_PATH)/libbass.so $(LOCAL_PATH)/libbassmidi.so 
#注意： 引用第三方动态库*.so, 不能用LOCAL_SHARED_LIBRARIES := liblive555这种方式，否则会报错：

LOCAL_MODULE    := main
LOCAL_SRC_FILES := jymain.c luafun.c sdlfun.c piccache.c charset.c mainmap.c

include $(BUILD_SHARED_LIBRARY) 

