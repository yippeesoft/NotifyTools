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

    // sum = i / j;
    EXPECT_EQ(2 + 3, 5);
};
class Test1
{
    SlogHandle s1 = SlogHandle::getLogger("test1");

public:
    void test11()
    {
        SlogW(s1, "aaaaa");
    }
};
class Test2
{
    SlogHandle s2 = SlogHandle::getLogger("test2");

public:
    void test22()
    {
        SlogE(s2, "bbbb");
    }
};
int main(int argc, char** argv)
{
    testing::InitGoogleTest(&argc, argv);

    Test1 t1;
    Test2 t2;
    printf("%s %d\n", __FUNCTION__, __LINE__);
    printf("%s\n", (std::to_string(__LINE__).append("\t").append(__FUNCTION__)).c_str());
    SlogHandle::Configure("llog.txt");
    for (int i = 0; i < 200; i++)
    {
        t1.test11();
        t2.test22();
    }
    return 0;
}