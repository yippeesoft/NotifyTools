/*
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "snapshot_utils.h"

#include <cerrno>
#include <climits>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <getopt.h>
#include <hitrace_meter.h>
#include <image_type.h>
#include <iostream>
#include <ostream>
#include <csetjmp>
#include <pixel_map.h>
#include "jpeglib.h"
#include <securec.h>
#include <string>
#include <sys/time.h>

using namespace OHOS::Rosen;

namespace OHOS {
constexpr int MAX_TIME_STR_LEN = 40;
constexpr int YEAR_SINCE = 1900;
constexpr int32_t RGB565_PIXEL_BYTES = 2;
constexpr int32_t RGB888_PIXEL_BYTES = 3;
constexpr int32_t RGBA8888_PIXEL_BYTES = 4;
constexpr uint8_t B_INDEX = 0;
constexpr uint8_t G_INDEX = 1;
constexpr uint8_t R_INDEX = 2;
constexpr uint8_t SHIFT_2_BIT = 2;
constexpr uint8_t SHITF_3_BIT = 3;
constexpr uint8_t SHIFT_5_BIT = 5;
constexpr uint8_t SHIFT_8_BIT = 8;
constexpr uint8_t SHIFT_11_BIT = 11;
constexpr uint8_t SHIFT_16_BIT = 16;

constexpr uint16_t RGB565_MASK_BLUE = 0xF800;
constexpr uint16_t RGB565_MASK_GREEN = 0x07E0;
constexpr uint16_t RGB565_MASK_RED = 0x001F;
constexpr uint32_t RGBA8888_MASK_BLUE = 0x000000FF;
constexpr uint32_t RGBA8888_MASK_GREEN = 0x0000FF00;
constexpr uint32_t RGBA8888_MASK_RED = 0x00FF0000;

struct MissionErrorMgr : public jpeg_error_mgr {
    jmp_buf environment;
};

void mission_error_exit(j_common_ptr cinfo)
{
    if (cinfo == nullptr || cinfo->err == nullptr) {
        std::cout << __func__ << ": param is invalid." << std::endl;
        return;
    }
    auto err = (MissionErrorMgr*)cinfo->err;
    longjmp(err->environment, 1);
}

const char *VALID_SNAPSHOT_PATH = "/data";
const char *DEFAULT_SNAPSHOT_PREFIX = "/snapshot";
const char *VALID_SNAPSHOT_SUFFIX = ".jpeg";

void SnapShotUtils::PrintUsage(const std::string &cmdLine)
{
    std::cout << "usage: " << cmdLine.c_str() <<
        " [-i displayId] [-f output_file] [-w width] [-h height] [-m]" << std::endl;
}

std::string SnapShotUtils::GenerateFileName(int offset)
{
    timeval tv;
    std::string fileName = VALID_SNAPSHOT_PATH;

    fileName += DEFAULT_SNAPSHOT_PREFIX;
    if (gettimeofday(&tv, nullptr) == 0) {
        tv.tv_sec += offset; // add offset second
        struct tm *tmVal = localtime(&tv.tv_sec);
        if (tmVal != nullptr) {
            char timeStr[MAX_TIME_STR_LEN] = { 0 };
            snprintf_s(timeStr, sizeof(timeStr), sizeof(timeStr) - 1,
                "_%04d-%02d-%02d_%02d-%02d-%02d",
                tmVal->tm_year + YEAR_SINCE, tmVal->tm_mon + 1, tmVal->tm_mday,
                tmVal->tm_hour, tmVal->tm_min, tmVal->tm_sec);
            fileName += timeStr;
        }
    }
    fileName += VALID_SNAPSHOT_SUFFIX;
    return fileName;
}

bool SnapShotUtils::CheckFileNameValid(const std::string &fileName)
{
    if (fileName.length() <= strlen(VALID_SNAPSHOT_SUFFIX)) {
        std::cout << "error: fileName " << fileName.c_str() << " invalid, file length too short!" << std::endl;
        return false;
    }
    // check file path
    std::string fileDir = fileName;
    auto pos = fileDir.find_last_of("/");
    if (pos != std::string::npos) {
        fileDir.erase(pos + 1);
    } else {
        fileDir = "."; // current work dir
    }
    char resolvedPath[PATH_MAX] = { 0 };
    char *realPath = realpath(fileDir.c_str(), resolvedPath);
    if (realPath == nullptr) {
        std::cout << "error: fileName " << fileName.c_str() << " invalid, realpath nullptr!" << std::endl;
        return false;
    }
    if (strncmp(realPath, VALID_SNAPSHOT_PATH, strlen(VALID_SNAPSHOT_PATH)) != 0) {
        std::cout << "error: fileName " << fileName.c_str() << " invalid, realpath "
            << realPath << " must dump at dir: " << VALID_SNAPSHOT_PATH << std::endl;
        return false;
    }

    // check file suffix
    const char *fileNameSuffix = fileName.c_str() + (fileName.length() - strlen(VALID_SNAPSHOT_SUFFIX));
    if (strncmp(fileNameSuffix, VALID_SNAPSHOT_SUFFIX, strlen(VALID_SNAPSHOT_SUFFIX)) == 0) {
        return true; // valid suffix
    }

    std::cout << "error: fileName " << fileName.c_str() <<
        " invalid, suffix must be " << VALID_SNAPSHOT_SUFFIX << std::endl;
    return false;
}

bool SnapShotUtils::CheckWHValid(int32_t param)
{
    return (param > 0) && (param <= DisplayManager::MAX_RESOLUTION_SIZE_SCREENSHOT);
}

bool SnapShotUtils::CheckWidthAndHeightValid(int32_t w, int32_t h)
{
    return CheckWHValid(w) && CheckWHValid(h);
}

bool SnapShotUtils::CheckParamValid(const WriteToJpegParam &param)
{
    switch (param.format) {
        case Media::PixelFormat::RGBA_8888:
            if (param.stride != param.width * RGBA8888_PIXEL_BYTES) {
                return false;
            }
            break;
        case Media::PixelFormat::RGB_565:
            if (param.stride != param.width * RGB565_PIXEL_BYTES) {
                return false;
            }
            break;
        case Media::PixelFormat::RGB_888:
            if (param.stride != param.width * RGB888_PIXEL_BYTES) {
                return false;
            }
            break;
        default:
            std::cout << __func__ << ": unsupported pixel format: " <<
                static_cast<uint32_t>(param.format) << std::endl;
            return false;
    }
    if (!CheckWidthAndHeightValid(param.width, param.height)) {
        return false;
    }
    if (param.data == nullptr) {
        return false;
    }
    return true;
}

bool SnapShotUtils::RGBA8888ToRGB888(const uint8_t* rgba8888Buf, uint8_t *rgb888Buf, int32_t size)
{
    if (rgba8888Buf == nullptr || rgb888Buf == nullptr || size <= 0) {
        std::cout << __func__ << ": params are invalid." << std::endl;
        return false;
    }
    const uint32_t* rgba8888 = reinterpret_cast<const uint32_t*>(rgba8888Buf);
    for (int32_t i = 0; i < size; i++) {
        rgb888Buf[i * RGB888_PIXEL_BYTES + R_INDEX] = (rgba8888[i] & RGBA8888_MASK_RED) >> SHIFT_16_BIT;
        rgb888Buf[i * RGB888_PIXEL_BYTES + G_INDEX] = (rgba8888[i] & RGBA8888_MASK_GREEN) >> SHIFT_8_BIT;
        rgb888Buf[i * RGB888_PIXEL_BYTES + B_INDEX] = rgba8888[i] & RGBA8888_MASK_BLUE;
    }
    return true;
}

bool SnapShotUtils::RGB565ToRGB888(const uint8_t* rgb565Buf, uint8_t *rgb888Buf, int32_t size)
{
    if (rgb565Buf == nullptr || rgb888Buf == nullptr || size <= 0) {
        std::cout << __func__ << ": params are invalid." << std::endl;
        return false;
    }
    const uint16_t* rgb565 = reinterpret_cast<const uint16_t*>(rgb565Buf);
    for (int32_t i = 0; i < size; i++) {
        rgb888Buf[i * RGB888_PIXEL_BYTES + R_INDEX] = (rgb565[i] & RGB565_MASK_RED);
        rgb888Buf[i * RGB888_PIXEL_BYTES + G_INDEX] = (rgb565[i] & RGB565_MASK_GREEN) >> SHIFT_5_BIT;
        rgb888Buf[i * RGB888_PIXEL_BYTES + B_INDEX] = (rgb565[i] & RGB565_MASK_BLUE) >> SHIFT_11_BIT;
        rgb888Buf[i * RGB888_PIXEL_BYTES + R_INDEX] <<= SHITF_3_BIT;
        rgb888Buf[i * RGB888_PIXEL_BYTES + G_INDEX] <<= SHIFT_2_BIT;
        rgb888Buf[i * RGB888_PIXEL_BYTES + B_INDEX] <<= SHITF_3_BIT;
    }
    return true;
}

// The method will NOT release file.
bool SnapShotUtils::WriteRgb888ToJpeg(FILE* file, uint32_t width, uint32_t height, const uint8_t* data)
{
    if (data == nullptr) {
        std::cout << "error: data error, nullptr!" << std::endl;
        return false;
    }

    if (file == nullptr) {
        std::cout << "error: file is null" << std::endl;
        return false;
    }

    struct jpeg_compress_struct jpeg;
    struct MissionErrorMgr jerr;
    jpeg.err = jpeg_std_error(&jerr);
    jerr.error_exit = mission_error_exit;
    if (setjmp(jerr.environment)) {
        jpeg_destroy_compress(&jpeg);
        std::cout << "error: lib jpeg exit with error!" << std::endl;
        return false;
    }

    jpeg_create_compress(&jpeg);
    jpeg.image_width = width;
    jpeg.image_height = height;
    jpeg.input_components = RGB888_PIXEL_BYTES;
    jpeg.in_color_space = JCS_RGB;
    jpeg_set_defaults(&jpeg);

    constexpr int32_t quality = 75;
    jpeg_set_quality(&jpeg, quality, TRUE);

    jpeg_stdio_dest(&jpeg, file);
    jpeg_start_compress(&jpeg, TRUE);
    JSAMPROW rowPointer[1];
    for (uint32_t i = 0; i < jpeg.image_height; i++) {
        rowPointer[0] = const_cast<uint8_t *>(data + i * jpeg.image_width * RGB888_PIXEL_BYTES);
        (void)jpeg_write_scanlines(&jpeg, rowPointer, 1);
    }

    jpeg_finish_compress(&jpeg);
    jpeg_destroy_compress(&jpeg);
    return true;
}

bool SnapShotUtils::WriteToJpeg(const std::string &fileName, const WriteToJpegParam &param)
{
    bool ret = false;
    if (!CheckFileNameValid(fileName)) {
        return ret;
    }
    if (!CheckParamValid(param)) {
        std::cout << "error: invalid param." << std::endl;
        return ret;
    }
    HITRACE_METER_FMT(HITRACE_TAG_WINDOW_MANAGER, "snapshot:WriteToJpeg(%s)", fileName.c_str());

    FILE *file = fopen(fileName.c_str(), "wb");
    if (file == nullptr) {
        std::cout << "error: open file [" << fileName.c_str() << "] error, " << errno << "!" << std::endl;
        return ret;
    }
    std::cout << "snapshot: pixel format is: " << static_cast<uint32_t>(param.format) << std::endl;
    if (param.format == Media::PixelFormat::RGBA_8888) {
        int32_t rgb888Size = param.stride * param.height * RGB888_PIXEL_BYTES / RGBA8888_PIXEL_BYTES;
        uint8_t *rgb888 = new uint8_t[rgb888Size];
        ret = RGBA8888ToRGB888(param.data, rgb888, rgb888Size / RGB888_PIXEL_BYTES);
        if (ret) {
            std::cout << "snapshot: convert rgba8888 to rgb888 successfully." << std::endl;
            ret = WriteRgb888ToJpeg(file, param.width, param.height, rgb888);
        }
        delete[] rgb888;
    } else if (param.format == Media::PixelFormat::RGB_565) {
        int32_t rgb888Size = param.stride * param.height * RGB888_PIXEL_BYTES / RGB565_PIXEL_BYTES;
        uint8_t *rgb888 = new uint8_t[rgb888Size];
        ret = RGB565ToRGB888(param.data, rgb888, rgb888Size / RGB888_PIXEL_BYTES);
        if (ret) {
            std::cout << "snapshot: convert rgb565 to rgb888 successfully." << std::endl;
            ret = WriteRgb888ToJpeg(file, param.width, param.height, rgb888);
        }
        delete[] rgb888;
    } else if (param.format == Media::PixelFormat::RGB_888) {
        ret = WriteRgb888ToJpeg(file, param.width, param.height, param.data);
    } else {
        std::cout << "snapshot: invalid pixel format." << std::endl;
    }
    if (fclose(file) != 0) {
        std::cout << "error: close file failed!" << std::endl;
        ret = false;
    }
    return ret;
}

bool SnapShotUtils::WriteToJpeg(int fd, const WriteToJpegParam &param)
{
    bool ret = false;
    if (!CheckParamValid(param)) {
        std::cout << "error: invalid param." << std::endl;
        return ret;
    }

    FILE *file = fdopen(fd, "wb");
    if (file == nullptr) {
        return ret;
    }
    std::cout << "snapshot: pixel format is: " << static_cast<uint32_t>(param.format) << std::endl;
    if (param.format == Media::PixelFormat::RGBA_8888) {
        int32_t rgb888Size = param.stride * param.height * RGB888_PIXEL_BYTES / RGBA8888_PIXEL_BYTES;
        uint8_t *rgb888 = new uint8_t[rgb888Size];
        ret = RGBA8888ToRGB888(param.data, rgb888, rgb888Size / RGB888_PIXEL_BYTES);
        if (ret) {
            std::cout << "snapshot: convert rgba8888 to rgb888 successfully." << std::endl;
            ret = WriteRgb888ToJpeg(file, param.width, param.height, rgb888);
        }
        delete[] rgb888;
    } else if (param.format == Media::PixelFormat::RGB_565) {
        int32_t rgb888Size = param.stride * param.height * RGB888_PIXEL_BYTES / RGB565_PIXEL_BYTES;
        uint8_t *rgb888 = new uint8_t[rgb888Size];
        ret = RGB565ToRGB888(param.data, rgb888, rgb888Size / RGB888_PIXEL_BYTES);
        if (ret) {
            std::cout << "snapshot: convert rgb565 to rgb888 successfully." << std::endl;
            ret = WriteRgb888ToJpeg(file, param.width, param.height, rgb888);
        }
        delete[] rgb888;
    } else if (param.format == Media::PixelFormat::RGB_888) {
        ret = WriteRgb888ToJpeg(file, param.width, param.height, param.data);
    } else {
        std::cout << "snapshot: invalid pixel format." << std::endl;
    }
    if (fclose(file) != 0) {
        std::cout << "error: close file failed!" << std::endl;
        ret = false;
    }
    return ret;
}

bool SnapShotUtils::WriteToJpegWithPixelMap(const std::string &fileName, Media::PixelMap &pixelMap)
{
    WriteToJpegParam param;
    param.width = static_cast<uint32_t>(pixelMap.GetWidth());
    param.height = static_cast<uint32_t>(pixelMap.GetHeight());
    param.data = pixelMap.GetPixels();
    param.stride = static_cast<uint32_t>(pixelMap.GetRowBytes());
    param.format = pixelMap.GetPixelFormat();
    return SnapShotUtils::WriteToJpeg(fileName, param);
}

bool SnapShotUtils::WriteToJpegWithPixelMap(int fd, Media::PixelMap &pixelMap)
{
    WriteToJpegParam param;
    param.width = static_cast<uint32_t>(pixelMap.GetWidth());
    param.height = static_cast<uint32_t>(pixelMap.GetHeight());
    param.data = pixelMap.GetPixels();
    param.stride = static_cast<uint32_t>(pixelMap.GetRowBytes());
    param.format = pixelMap.GetPixelFormat();
    return SnapShotUtils::WriteToJpeg(fd, param);
}

bool SnapShotUtils::ProcessDisplayId(Rosen::DisplayId &displayId, bool isDisplayIdSet)
{
    if (!isDisplayIdSet) {
        displayId = DisplayManager::GetInstance().GetDefaultDisplayId();
    } else {
        bool validFlag = false;
        auto displayIds = DisplayManager::GetInstance().GetAllDisplayIds();
        for (auto id: displayIds) {
            if (displayId == id) {
                validFlag = true;
                break;
            }
        }
        if (!validFlag) {
            std::cout << "error: displayId " << static_cast<int64_t>(displayId) << " invalid!" << std::endl;
            std::cout << "tips: supported displayIds:" << std::endl;
            for (auto dispId: displayIds) {
                std::cout << "\t" << dispId << std::endl;
            }
            return false;
        }
    }
    return true;
}

bool SnapShotUtils::ProcessArgs(int argc, char * const argv[], CmdArgments &cmdArgments)
{
    int opt = 0;
    const struct option longOption[] = {
        { "id", required_argument, nullptr, 'i' },
        { "width", required_argument, nullptr, 'w' },
        { "height", required_argument, nullptr, 'h' },
        { "file", required_argument, nullptr, 'f' },
        { "help", required_argument, nullptr, 'm' },
        { nullptr, 0, nullptr, 0 }
    };
    while ((opt = getopt_long(argc, argv, "i:w:h:f:m", longOption, nullptr)) != -1) {
        switch (opt) {
            case 'i': // display id
                cmdArgments.displayId = static_cast<DisplayId>(atoll(optarg));
                cmdArgments.isDisplayIdSet = true;
                break;
            case 'w': // output width
                cmdArgments.width = atoi(optarg);
                cmdArgments.isWidthSet = true;
                break;
            case 'h': // output height
                cmdArgments.height = atoi(optarg);
                cmdArgments.isHeightSet = true;
                break;
            case 'f': // output file name
                cmdArgments.fileName = optarg;
                break;
            case 'm': // help
            default:
                SnapShotUtils::PrintUsage(argv[0]);
                return false;
        }
    }

    if (!ProcessDisplayId(cmdArgments.displayId, cmdArgments.isDisplayIdSet)) {
        return false;
    }

    if (cmdArgments.fileName == "") {
        cmdArgments.fileName = GenerateFileName();
        std::cout << "process: set filename to " << cmdArgments.fileName.c_str() << std::endl;
    }

    // check fileName
    if (!SnapShotUtils::CheckFileNameValid(cmdArgments.fileName)) {
        std::cout << "error: filename " << cmdArgments.fileName.c_str() << " invalid!" << std::endl;
        return false;
    }
    return true;
}
}