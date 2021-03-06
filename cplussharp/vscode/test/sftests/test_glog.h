#ifndef TEST_GLOG_H
#define TEST_GLOG_H
#include <iostream>

#if GLOG
#include "glog/logging.h"

#include <fstream>
#include <cstdlib>
using namespace std;
enum level
{
    INFO = 0,
    WARINIG = 1,
    ERROR = 2,
    FATAL = 3
};

void test_glog()
{
    for (int i = 1; i < 101; i++)
    {
        //满足i==100才会打印
        LOG_IF(INFO, i == 100) << "LOG_IF(INFO,I==100),google::COUNTER=" << google::COUNTER << " i=" << i << endl;

        //每隔10次打印一次，对于刷屏的日志控制很好
        LOG_EVERY_N(INFO, 10) << "LOG_EVERY_N(INFO,10) google::COUNTER=" << google::COUNTER << " i=" << i;

        //满足i > 50的条件后，每隔10次打印一次，对于刷屏的日志控制很好
        LOG_IF_EVERY_N(WARNING, (i > 50), 10) << "LOG_IF_ERVER_N(INFO,(I>50),10) google::COUNTER=" << google::COUNTER << " i=" << i;

        //只打印前5次
        LOG_FIRST_N(ERROR, 5) << "LOG_FIRST_N(error,5) google::COUNTER="
                              << " i=" << i;

        //每次都打印
        LOG(ERROR) << "TEST BY TOPSLUO" << endl;
    }
}

int test_glog_main(int argc)
{
    google::InitGoogleLogging("vsc2");
    FLAGS_stderrthreshold = INFO;
    FLAGS_colorlogtostderr = true;
    google::SetStderrLogging(INFO);                   //设置级别高于google::INFO的日志同时输出到屏幕
    google::SetLogDestination(ERROR, "./log/error_"); //设置google::ERROR级别的日志存储路径和文件名前缀
    google::SetLogDestination(WARINIG, "./log/warning_");
    google::SetLogDestination(INFO, "./log/info_");
    FLAGS_logbufsecs = 0;                   //缓冲日志输出，默认为30秒，此处改为立刻
    FLAGS_max_log_size = 100;               //最大日志大小为100M
    FLAGS_stop_logging_if_full_disk = true; //当磁盘被写满时，停止日志输出
    google::SetLogFilenameExtension("91_"); //设置文件名扩展，如平台，或者其它需要区分的信息
    google::InstallFailureSignalHandler();  //捕捉core dumped
    //google::InstallFailureWriter(&SignalHandle);//默认捕捉SIGSEGV信息输出会输出到sdtdrr

    test_glog();

    google::ShutdownGoogleLogging(); //GLOG内存清理，一般与  google::InitGoogleLogging配对使用
    return 0;
}
#else
int test_glog_main(int argc)
{
    std::cout << "test_glog_main no glog \n";
    return 0;
}
#endif

#endif
