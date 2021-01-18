#pragma once
#ifndef SF_SLOGHANDLES_H
#define SF_SLOGHANDLES_H
#include <iostream>
#define SFLOG_LOG4CPLUS
#ifdef SFLOG_LOG4CPLUS
#include <log4cplus/log4cplus.h>
#define Slog(x) LOG4CPLUS_INFO(SlogHandle::GetInstance().getLogger(), LOG4CPLUS_TEXT(x));
#else
#define Slog(x)
#endif
namespace sfutils {

class SlogHandle
{
public:
    static SlogHandle& GetInstance();

private:
    static SlogHandle _instance;

private:
#ifdef SFLOG_LOG4CPLUS
    //用Initializer类进行初始化
    log4cplus::Initializer initializer;
    log4cplus::Logger _logger;

#endif
public:
#ifdef SFLOG_LOG4CPLUS
    log4cplus::Logger getLogger()
    {
        return _logger;
    };
#endif
    bool init();

protected:
    SlogHandle(/* args */);
    ~SlogHandle();
};

} // namespace sfutils
#endif