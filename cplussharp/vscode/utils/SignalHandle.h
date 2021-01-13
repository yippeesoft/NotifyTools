#pragma once
#ifndef SF_SINGLEHANDLE_H
#define SF_SINGLEHANDLE_H
#include <iostream>
#include <signal.h>
#include <execinfo.h>
namespace sfutils {

#define DBG_ASSERT(x)                                                                                 \
    do                                                                                                \
    {                                                                                                 \
        if (x) { break; }                                                                             \
        std::cout << "###### file:" << __FILE__ << " line:" << __LINE__ << " ######" << std::endl;    \
        void* pptrace_raw[32] = {0};                                                                  \
        char** pptrace_str = NULL;                                                                    \
        int trace_num = 0, iloop = 0;                                                                 \
        trace_num = backtrace(pptrace_raw, 32);                                                       \
        pptrace_str = (char**)backtrace_symbols(pptrace_raw, trace_num);                              \
        for (iloop = 0; iloop < trace_num; iloop++) { std::cout << pptrace_str[iloop] << std::endl; } \
        if (pptrace_str) { delete pptrace_str; }                                                      \
    } while (0);

class SignalHandle
{
public:
    static SignalHandle& GetInstance();

private:
    static SignalHandle _instance;
    static int signals[9];
    static void sigsegvhandle(int signo);

protected:
    SignalHandle(/* args */);
    ~SignalHandle();
};

} // namespace sfutils

#endif
