/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

#include <gtest/gtest.h>
#include "display.h"
#include "display_manager.h"
#include "snapshot_utils.h"
#include "common_test_utils.h"

using namespace testing;
using namespace testing::ext;

namespace OHOS {
namespace Rosen {
namespace {
    constexpr int BPP = 4;
}
class SnapshotUtilsTest : public testing::Test {
public:
    static void SetUpTestCase();
    static void TearDownTestCase();
    virtual void SetUp() override;
    virtual void TearDown() override;
    const std::string defaultFile_ = "/data/snapshot_display_1.jpeg";
    const int defaultBitDepth_ = 8;
};

void SnapshotUtilsTest::SetUpTestCase()
{
    CommonTestUtils::InjectTokenInfoByHapName(0, "com.ohos.systemui", 0);
}

void SnapshotUtilsTest::TearDownTestCase()
{
}

void SnapshotUtilsTest::SetUp()
{
}

void SnapshotUtilsTest::TearDown()
{
}

namespace {
/**
 * @tc.name: Check01
 * @tc.desc: Check if default jpeg is valid file names
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, Check01, Function | SmallTest | Level3)
{
    ASSERT_EQ(true, SnapShotUtils::CheckFileNameValid(defaultFile_));
}

/**
 * @tc.name: Check02
 * @tc.desc: Check custom jpeg is valid file names
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, Check02, Function | SmallTest | Level3)
{
    std::string fileName = "/data/test.jpeg";
    ASSERT_EQ(true, SnapShotUtils::CheckFileNameValid(fileName));
}

/**
 * @tc.name: Check03
 * @tc.desc: Check random path is invalid file names
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, Check03, Function | SmallTest | Level3)
{
    std::string fileName1 = "/path/to/test/1.jpeg";
    ASSERT_EQ(false, SnapShotUtils::CheckFileNameValid(fileName1));
    std::string fileName2 = "";
    ASSERT_EQ(false, SnapShotUtils::CheckFileNameValid(fileName2));
    std::string fileName3 = "/data/test.png";
    ASSERT_EQ(false, SnapShotUtils::CheckFileNameValid(fileName3));
}

/**
 * @tc.name: RGBA8888ToRGB88801
 * @tc.desc: RGBA8888 to RGB888 using invalid params
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, RGBA8888ToRGB88801, Function | SmallTest | Level3)
{
    ASSERT_FALSE(SnapShotUtils::RGBA8888ToRGB888(nullptr, nullptr, -1));
}

/**
 * @tc.name: WriteRgb888ToJpeg01
 * @tc.desc: write rgb888 to jpeg using invalid data
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, WriteRgb888ToJpeg01, Function | SmallTest | Level3)
{
    uint8_t *data = nullptr;
    FILE *file = fopen(defaultFile_.c_str(), "wb");
    ASSERT_FALSE(SnapShotUtils::WriteRgb888ToJpeg(file, 100, 100, data));
}

/**
 * @tc.name: WriteRgb888ToJpeg02
 * @tc.desc: write rgb888 to jpeg using invalid file
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, WriteRgb888ToJpeg02, Function | SmallTest | Level3)
{
    uint8_t *data = new uint8_t;
    FILE *file = nullptr;
    ASSERT_FALSE(SnapShotUtils::WriteRgb888ToJpeg(file, 100, 100, data));
}

/**
 * @tc.name: Write01
 * @tc.desc: Write default jpeg using valid file names and valid PixelMap
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, Write01, Function | MediumTest | Level3)
{
    DisplayId id = DisplayManager::GetInstance().GetDefaultDisplayId();
    std::shared_ptr<Media::PixelMap> pixelMap = DisplayManager::GetInstance().GetScreenshot(id);
    ASSERT_NE(nullptr, pixelMap);
    ASSERT_EQ(true, SnapShotUtils::WriteToJpegWithPixelMap(defaultFile_, *pixelMap));
}

/**
 * @tc.name: Write02
 * @tc.desc: Write default jpeg using valid file names and valid WriteToJpegParam
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, Write02, Function | MediumTest | Level3)
{
    DisplayId id = DisplayManager::GetInstance().GetDefaultDisplayId();
    std::shared_ptr<Media::PixelMap> pixelMap = DisplayManager::GetInstance().GetScreenshot(id);
    ASSERT_NE(nullptr, pixelMap);
    WriteToJpegParam param = {
        .width = pixelMap->GetWidth(),
        .height = pixelMap->GetHeight(),
        .stride = pixelMap->GetRowBytes(),
        .format = pixelMap->GetPixelFormat(),
        .data = pixelMap->GetPixels()
    };
    ASSERT_EQ(true, SnapShotUtils::WriteToJpeg(defaultFile_, param));
}

/**
 * @tc.name: Write03
 * @tc.desc: Write custom jpeg using valid file names and valid WriteToJpegParam
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, Write03, Function | MediumTest | Level3)
{
    DisplayId id = DisplayManager::GetInstance().GetDefaultDisplayId();
    std::shared_ptr<Media::PixelMap> pixelMap = DisplayManager::GetInstance().GetScreenshot(id);
    ASSERT_NE(nullptr, pixelMap);
    WriteToJpegParam param = {
        .width = (pixelMap->GetWidth() / 2),
        .height = (pixelMap->GetWidth() / 2),
        .stride = pixelMap->GetRowBytes(),
        .format = pixelMap->GetPixelFormat(),
        .data = pixelMap->GetPixels()
    };
    ASSERT_EQ(false, SnapShotUtils::WriteToJpeg(defaultFile_, param));
}

/**
 * @tc.name: Write04
 * @tc.desc: Write pixel map with jpeg, using fd
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, Write04, Function | MediumTest | Level3)
{
    DisplayId id = DisplayManager::GetInstance().GetDefaultDisplayId();
    std::shared_ptr<Media::PixelMap> pixelMap = DisplayManager::GetInstance().GetScreenshot(id);
    ASSERT_EQ(true, SnapShotUtils::WriteToJpegWithPixelMap(0, *pixelMap));
}

/**
 * @tc.name: Write05
 * @tc.desc: Write custom jpeg using invalid file names and valid WriteToJpegParam
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, Write05, Function | MediumTest | Level3)
{
    WriteToJpegParam param = {
        .width = 256,
        .height = 256,
        .stride = 256 * BPP,
        .format = Media::PixelFormat::UNKNOWN,
        .data = new uint8_t
    };
    ASSERT_FALSE(SnapShotUtils::WriteToJpeg("", param));
}

/**
 * @tc.name: Write06
 * @tc.desc: Write custom jpeg using valid file names and invalid WriteToJpegParam
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, Write06, Function | MediumTest | Level3)
{
    WriteToJpegParam param = {
        .width = 256,
        .height = 256,
        .stride = 256 * BPP,
        .format = Media::PixelFormat::UNKNOWN,
        .data = nullptr
    };
    ASSERT_FALSE(SnapShotUtils::WriteToJpeg(defaultFile_, param));
}

/**
 * @tc.name: Write07
 * @tc.desc: Write custom jpeg using valid fd and invalid WriteToJpegParam
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, Write07, Function | MediumTest | Level3)
{
    WriteToJpegParam param = {
        .width = 256,
        .height = 256,
        .stride = 256 * BPP,
        .format = Media::PixelFormat::UNKNOWN,
        .data = nullptr
    };
    ASSERT_FALSE(SnapShotUtils::WriteToJpeg(1, param));
}

/**
 * @tc.name: CheckWHValid
 * @tc.desc: Check width and height whether valid
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, CheckWHValid, Function | SmallTest | Level3)
{
    ASSERT_EQ(false, SnapShotUtils::CheckWHValid(0));
    ASSERT_EQ(true, SnapShotUtils::CheckWHValid(DisplayManager::MAX_RESOLUTION_SIZE_SCREENSHOT));
    ASSERT_EQ(false, SnapShotUtils::CheckWHValid(DisplayManager::MAX_RESOLUTION_SIZE_SCREENSHOT + 1));
}

/**
 * @tc.name: CheckParamValid01
 * @tc.desc: Check jpeg param whether valid width
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, CheckParamValid01, Function | SmallTest | Level3)
{
    WriteToJpegParam paramInvalidWidth = {
        .width = DisplayManager::MAX_RESOLUTION_SIZE_SCREENSHOT + 1,
        .height = 0,
        .stride = 0,
        .format = Media::PixelFormat::UNKNOWN,
        .data = nullptr
    };
    ASSERT_EQ(false, SnapShotUtils::CheckParamValid(paramInvalidWidth));
}

/**
 * @tc.name: CheckParamValid02
 * @tc.desc: Check jpeg param whether valid height
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, CheckParamValid02, Function | SmallTest | Level3)
{
    WriteToJpegParam paramInvalidHeight = {
        .width = DisplayManager::MAX_RESOLUTION_SIZE_SCREENSHOT,
        .height = 0,
        .stride = 0,
        .format = Media::PixelFormat::UNKNOWN,
        .data = nullptr
    };
    ASSERT_EQ(false, SnapShotUtils::CheckParamValid(paramInvalidHeight));
}

/**
 * @tc.name: CheckParamValid03
 * @tc.desc: Check jpeg param whether valid stride
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, CheckParamValid03, Function | SmallTest | Level3)
{
    WriteToJpegParam paramInvalidStride = {
        .width = 256,
        .height = 256,
        .stride = 1,
        .format = Media::PixelFormat::UNKNOWN,
        .data = nullptr
    };
    ASSERT_EQ(false, SnapShotUtils::CheckParamValid(paramInvalidStride));
}

/**
 * @tc.name: CheckParamValid04
 * @tc.desc: Check jpeg param whether valid data
 * @tc.type: FUNC
 */
HWTEST_F(SnapshotUtilsTest, CheckParamValid04, Function | SmallTest | Level3)
{
    WriteToJpegParam paramInvalidData = {
        .width = 256,
        .height = 256,
        .stride = 256 * BPP,
        .format = Media::PixelFormat::UNKNOWN,
        .data = nullptr
    };
    ASSERT_EQ(false, SnapShotUtils::CheckParamValid(paramInvalidData));
}
}
} // namespace Rosen
} // namespace OHOS