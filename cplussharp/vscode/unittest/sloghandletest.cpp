#include "SlogHandle.h"
#include <gtest/gtest.h>
using namespace sfutils;
#include <stdlib.h>
TEST(testCase, test0)
{
    int i, j, sum;
    sum = 0;
    j = 0;
    i = 6;
    Slog("AAAAAAAAAAAAAAA");
    // sum = i / j;
    EXPECT_EQ(2 + 3, 5);
}

GTEST_API_ int main(int argc, char** argv)
{
    testing::InitGoogleTest(&argc, argv);
    SlogHandle::GetInstance().init();
    int rtn = RUN_ALL_TESTS();

    return 0;
}