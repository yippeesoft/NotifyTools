#include "SlogHandle.h"
namespace sfutils {
SlogHandle SlogHandle::_instance;
SlogHandle::SlogHandle(/* args */)
{
}

SlogHandle::~SlogHandle()
{
}
SlogHandle& SlogHandle::GetInstance()
{
    std::cout << "SlogHandle::GetInstance()" << std::endl;
    return _instance;
}
bool SlogHandle::init()
{
#ifdef SFLOG_LOG4CPLUS
    //第1步：创建ConsoleAppender
    log4cplus::SharedAppenderPtr appender(new log4cplus::ConsoleAppender());

    //第2步：设置Appender的名称和输出格式（SimpleLayout）
    appender->setName(LOG4CPLUS_TEXT("console1111"));
    appender->setLayout(std::unique_ptr<log4cplus::Layout>(new log4cplus::SimpleLayout));

    //第3步：获得一个Logger实例，并设置其日志输出等级阈值
    _logger = log4cplus::Logger::getInstance(LOG4CPLUS_TEXT("aaaa"));
    _logger.setLogLevel(log4cplus::INFO_LOG_LEVEL);

    //第4步：为Logger实例添加ConsoleAppender
    _logger.addAppender(appender);
#endif
    return true;
}
} // namespace sfutils