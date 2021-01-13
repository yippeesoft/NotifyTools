#include "SignalHandle.h"
#include <gtest/gtest.h>
using namespace sfutils;
TEST(testCase, test0)
{
    int i = 100 / 0;
    EXPECT_EQ(2 + 3, 5);
}
void sigsegv_test()
{
    std::cout << __func__ << " begin" << std::endl;
    char* buff = NULL;
    buff[1] = buff[1]; /* will crash here */
    std::cout << __func__ << " end" << std::endl;
}
GTEST_API_ int main(int argc, char** argv)
{
    testing::InitGoogleTest(&argc, argv);
    SignalHandle::GetInstance();
    sigsegv_test();
    return RUN_ALL_TESTS();
}