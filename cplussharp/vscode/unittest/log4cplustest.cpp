#include <log4cplus/log4cplus.h>
#include <gtest/gtest.h>
#include <iostream>
#include <sstream>
using namespace std;

using namespace log4cplus;
using namespace log4cplus::helpers;

// log4cplus: C++17 API更新有点快
// log4cxx: 臃肿, 需要引用apr(Apache Portable Runtime)
// log4cpp: 落后, 最后更新于2007年,而且下载的包不完整。

void log4cplusConsole()
{
    //用Initializer类进行初始化
    log4cplus::Initializer initializer;

    //第1步：创建ConsoleAppender
    log4cplus::SharedAppenderPtr appender(new log4cplus::ConsoleAppender());

    //第2步：设置Appender的名称和输出格式（SimpleLayout）
    appender->setName(LOG4CPLUS_TEXT("console"));
    appender->setLayout(std::unique_ptr<log4cplus::Layout>(new log4cplus::SimpleLayout));

    //第3步：获得一个Logger实例，并设置其日志输出等级阈值
    log4cplus::Logger logger = log4cplus::Logger::getInstance(LOG4CPLUS_TEXT("test"));
    logger.setLogLevel(log4cplus::INFO_LOG_LEVEL);

    //第4步：为Logger实例添加ConsoleAppender
    logger.addAppender(appender);

    //第5步：使用宏将日志输出
    LOG4CPLUS_INFO(logger, LOG4CPLUS_TEXT("Hello world"));
}

void log4cplusfile()
{
    //用Initializer类进行初始化
    log4cplus::Initializer initializer;

    //第1步：创建ConsoleAppender和FileAppender(参数app表示内容追加到文件)
    log4cplus::SharedAppenderPtr consoleAppender(new log4cplus::ConsoleAppender);
    log4cplus::SharedAppenderPtr fileAppender(new log4cplus::FileAppender(
        LOG4CPLUS_TEXT("log.txt"),
        std::ios_base::app));

    //第2步：设置Appender的名称和输出格式
    //ConsoleAppender使用SimpleLayout
    //FileAppender使用PatternLayout
    consoleAppender->setName(LOG4CPLUS_TEXT("console"));
    consoleAppender->setLayout(std::unique_ptr<log4cplus::Layout>(new log4cplus::SimpleLayout()));
    fileAppender->setName(LOG4CPLUS_TEXT("file"));

    //https://blog.csdn.net/guotianqing/article/details/103929188
    log4cplus::tstring pattern = LOG4CPLUS_TEXT("%D{%m/%d/%y %H:%M:%S,%Q} [%t] %-5p %c - %m %F [%l]%n");
    fileAppender->setLayout(std::unique_ptr<log4cplus::Layout>(new log4cplus::PatternLayout(pattern)));

    //第3步：获得一个Logger实例，并设置其日志输出等级阈值
    log4cplus::Logger logger = log4cplus::Logger::getInstance(LOG4CPLUS_TEXT("test"));
    logger.setLogLevel(log4cplus::INFO_LOG_LEVEL);

    //第4步：为Logger实例添加ConsoleAppender和FileAppender
    logger.addAppender(consoleAppender);
    logger.addAppender(fileAppender);

    //第5步：使用宏将日志输出
    LOG4CPLUS_INFO(logger, LOG4CPLUS_TEXT("Hello world"));
}

void log4cplusroolfile()
{
    //用Initializer类进行初始化
    log4cplus::Initializer initializer;

    //第1步：创建ConsoleAppender和FileAppender(参数app表示内容追加到文件)
    log4cplus::SharedAppenderPtr consoleAppender(new log4cplus::ConsoleAppender);
    log4cplus::SharedAppenderPtr roolfileAppender(new log4cplus::RollingFileAppender(
        LOG4CPLUS_TEXT("logg.log"), 5 * 1024, 5, std::ios_base::app));

    //第2步：设置Appender的名称和输出格式
    //ConsoleAppender使用SimpleLayout
    //FileAppender使用PatternLayout
    consoleAppender->setName(LOG4CPLUS_TEXT("console"));
    consoleAppender->setLayout(std::unique_ptr<log4cplus::Layout>(new log4cplus::SimpleLayout()));
    roolfileAppender->setName(LOG4CPLUS_TEXT("file"));

    //https://blog.csdn.net/guotianqing/article/details/103929188
    log4cplus::tstring pattern = LOG4CPLUS_TEXT("%D{%m/%d/%y %H:%M:%S,%Q} [%t] %-5p %c - %m  [%l]%n");
    roolfileAppender->setLayout(std::unique_ptr<log4cplus::Layout>(new log4cplus::PatternLayout(pattern)));

    //第3步：获得一个Logger实例，并设置其日志输出等级阈值
    log4cplus::Logger logger = log4cplus::Logger::getInstance(LOG4CPLUS_TEXT("test"));
    logger.setLogLevel(log4cplus::INFO_LOG_LEVEL);

    //第4步：为Logger实例添加ConsoleAppender和FileAppender
    // logger.addAppender(consoleAppender);
    logger.addAppender(roolfileAppender);
    stringstream ss;
    string hl = "Hello world";
    //第5步：使用宏将日志输出
    for (int i = 0; i < 20000; i++)
    {
        ss << i;
        LOG4CPLUS_INFO(logger, LOG4CPLUS_TEXT(hl + ss.str()));
        ss.str("");
        ss.clear();
    }
}

GTEST_API_ int main(int argc, char** argv)
{
    testing::InitGoogleTest(&argc, argv);

    int rtn = RUN_ALL_TESTS();
    log4cplusroolfile();

    return 0;
}