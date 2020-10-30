#ifndef TEST_BOOST_H
#define TEST_BOOST_H

#ifdef __cplusplus
extern "C"
{
#endif

#define BOOST 1
#if BOOST

#include <boost/tuple/tuple.hpp>
#include <boost/tuple/tuple_comparison.hpp>
#include <boost/tuple/tuple_io.hpp>
#include <boost/random.hpp>
#include <boost/random/random_device.hpp>
#include <boost/regex.hpp>

    void test_regx_boost()
    {
        boost::regex reg("\\d{2,3}");
        assert(boost::regex_match("234", reg) == true);
    }
    int test_boost()
    {
        boost::tuple<int, char, float> t(2, 'a', 0.9);
        std::cout << t << std::endl;

        std::time_t now = std::time(0);
        boost::random::mt19937 gen(now);

        //输出最大值和最小值
        std::cout << boost::random::mt19937::min() << ":" << boost::random::mt19937::max() << std::endl;

        //产生5个随机数,
        for (int i = 0; i < 5; ++i)
        {
            std::cout << gen() << "-";
        }
        std::cout << std::endl;

        test_regx_boost();
        return 0;
    }
#endif

#ifdef __cplusplus
}
#endif
#endif
