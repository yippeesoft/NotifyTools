#pragma once
#ifndef SF_SLOGHANDLES_H
#define SF_SLOGHANDLES_H
#include <iostream>
#define SFLOG_LOG4CPLUS
#ifdef SFLOG_LOG4CPLUS
#include <log4cplus/log4cplus.h>
using namespace log4cplus;
// LOG4CPLUS_INFO(SlogHandle::GetInstance().getLogger(), LOG4CPLUS_TEXT(x));
// #define Slog(log, x) LOG4CPLUS_WARN(log._logger, LOG4CPLUS_TEXT(x));
#define SlogW(log, x) LOG4CPLUS_WARN(log._logger, LOG4CPLUS_TEXT(std::to_string(__LINE__).append("\t").append(__FUNCTION__).append("\t").append(x)));
#define SlogI(log, x) LOG4CPLUS_INFO(log._logger, LOG4CPLUS_TEXT(std::to_string(__LINE__).append("\t").append(__FUNCTION__).append("\t").append(x)));
#define SlogE(log, x) LOG4CPLUS_ERROR(log._logger, LOG4CPLUS_TEXT(std::to_string(__LINE__).append("\t").append(__FUNCTION__).append("\t").append(x)));
#else
#define SlogW(log, x)
#define SlogI(log, x)
#define SlogE(log, x)
#endif
namespace sfutils {

class SlogHandle
{
#ifdef SFLOG_LOG4CPLUS
public:
    //用Initializer类进行初始化
    log4cplus::Initializer initializer;
    static SharedAppenderPtr consoleAppender;
    static SharedAppenderPtr rollfileAppender;
    Logger _logger;

public:
    static void Configure(std::string logfilename)
    {
        log4cplus::tstring pattern = LOG4CPLUS_TEXT("%D{%m/%d/%y %H:%M:%S,%Q} [%t] %-5p %c - %m  %n");
        consoleAppender = new ConsoleAppender;
        consoleAppender->setName(LOG4CPLUS_TEXT("console"));

        consoleAppender->setLayout(std::unique_ptr<log4cplus::Layout>(new log4cplus::PatternLayout(pattern)));
        // consoleAppender->setLayout(std::unique_ptr<log4cplus::Layout>(new log4cplus::SimpleLayout()));

        rollfileAppender = new RollingFileAppender(logfilename, 5 * 1024, 5, std::ios_base::app);
        rollfileAppender->setName(LOG4CPLUS_TEXT("file"));
        // log4cplus::tstring pattern = LOG4CPLUS_TEXT("%D{%m/%d/%y %H:%M:%S,%Q} [%t] %-5p %c - %m %F [%l]%n");

        rollfileAppender->setLayout(std::unique_ptr<log4cplus::Layout>(new log4cplus::PatternLayout(pattern)));

        Logger::getRoot().addAppender(consoleAppender);
        Logger::getRoot().addAppender(rollfileAppender);
        Logger::getRoot().setLogLevel(log4cplus::INFO_LOG_LEVEL);
    }
    static SlogHandle getLogger(std::string logname)
    {
        SlogHandle _slog;
        _slog._logger = Logger::getInstance(logname);
        return _slog;
    };
    void w(std::string msg)
    {
        LOG4CPLUS_WARN(_logger, LOG4CPLUS_TEXT(msg));
    }
#endif
    bool init();

public:
    SlogHandle(/* args */){};
    SlogHandle(const SlogHandle& slogg)
    {
#ifdef SFLOG_LOG4CPLUS
        this->_logger = slogg._logger;
#endif
    };
    ~SlogHandle(){};
};
#ifdef SFLOG_LOG4CPLUS
SharedAppenderPtr SlogHandle::consoleAppender;
SharedAppenderPtr SlogHandle::rollfileAppender;

#endif
} // namespace sfutils
#endif