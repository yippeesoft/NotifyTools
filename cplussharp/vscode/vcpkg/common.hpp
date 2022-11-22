#ifndef ASIOHTTP_COMMON_HPP
#define ASIOHTTP_COMMON_HPP
#include "Log.hpp"
// #define LOGD(logEvent)    LogSpd::Instance().d(logEvent)
//#define LOGD(format, ...) LogSpd::Instance().d(format, ##__VA_ARGS__)
#define LOGD(logEvent) LogSpd::Instance().d(logEvent)

/*
VS支持一种方式：

#define LOG(format, ...) fprintf(stdout, format, ##__VA_ARGS__) 

gcc支持两种方式：

    #define LOG(format, ...) fprintf(stdout, format, ##__VA_ARGS__)
    #define LOG(format, args...) fprintf(stdout, format, ##args) 
    */
#endif
