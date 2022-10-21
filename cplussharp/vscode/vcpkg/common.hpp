#ifndef ASIOHTTP_COMMON_HPP
#define ASIOHTTP_COMMON_HPP
#include "Log.hpp"
#define LOGD(logEvent) LogSpd::Instance().d(logEvent)
#define LOGE(logEvent) LogSpd::Instance().d(logEvent)
#endif