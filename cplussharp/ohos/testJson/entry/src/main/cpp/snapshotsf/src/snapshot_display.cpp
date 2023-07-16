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

#include <cstdio>
#include <image_type.h>
#include <iosfwd>
#include <iostream>
#include <memory>
#include <ostream>
#include <refbase.h>

#include "display_manager.h"
#include "snapshot_utils.h"

using namespace OHOS;
using namespace OHOS::Media;
using namespace OHOS::Rosen;

int main(int argc, char *argv[])
{
    CmdArgments cmdArgments;
    cmdArgments.fileName = "";

    if (!SnapShotUtils::ProcessArgs(argc, argv, cmdArgments)) {
        return 0;
    }

    auto display = DisplayManager::GetInstance().GetDisplayById(cmdArgments.displayId);
    if (display == nullptr) {
        std::cout << "error: GetDisplayById " << cmdArgments.displayId << " error!" << std::endl;
        return -1;
    }

    std::cout << "process: display " << cmdArgments.displayId <<
        ": width " << display->GetWidth() << ", height " << display->GetHeight() << std::endl;

    // get PixelMap from DisplayManager API
    std::shared_ptr<OHOS::Media::PixelMap> pixelMap = nullptr;
    if (!cmdArgments.isWidthSet && !cmdArgments.isHeightSet) {
        pixelMap = DisplayManager::GetInstance().GetScreenshot(cmdArgments.displayId); // default width & height
    } else {
        if (!cmdArgments.isWidthSet) {
            cmdArgments.width = display->GetWidth();
            std::cout << "process: reset to display's width " << cmdArgments.width << std::endl;
        }
        if (!cmdArgments.isHeightSet) {
            cmdArgments.height = display->GetHeight();
            std::cout << "process: reset to display's height " << cmdArgments.height << std::endl;
        }
        if (!SnapShotUtils::CheckWidthAndHeightValid(cmdArgments.width, cmdArgments.height)) {
            std::cout << "error: width " << cmdArgments.width << " height " <<
            cmdArgments.height << " invalid!" << std::endl;
            return -1;
        }
        const Media::Rect rect = {0, 0, display->GetWidth(), display->GetHeight()};
        const Media::Size size = {cmdArgments.width, cmdArgments.height};
        constexpr int rotation = 0;
        pixelMap = DisplayManager::GetInstance().GetScreenshot(cmdArgments.displayId, rect, size, rotation);
    }

    bool ret = false;
    if (pixelMap != nullptr) {
        ret = SnapShotUtils::WriteToJpegWithPixelMap(cmdArgments.fileName, *pixelMap);
    }
    if (!ret) {
        std::cout << "\nerror: snapshot display " << cmdArgments.displayId <<
            ", write to " << cmdArgments.fileName.c_str() << " as jpeg failed!" << std::endl;
        return -1;
    }

    std::cout << "\nsuccess: snapshot display " << cmdArgments.displayId << " , write to " <<
        cmdArgments.fileName.c_str() << " as jpeg, width " << pixelMap->GetWidth() <<
        ", height " << pixelMap->GetHeight() << std::endl;
    return 0;
}