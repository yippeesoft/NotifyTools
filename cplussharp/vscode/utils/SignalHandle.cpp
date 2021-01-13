#include "SignalHandle.h"

namespace sfutils {
SignalHandle SignalHandle::_instance;
SignalHandle::SignalHandle(/* args */)
{
}

SignalHandle::~SignalHandle()
{
    for (unsigned int i = 0; i < sizeof(signals) / sizeof(int); i++)
    {
        signal(signals[i], sigsegvhandle);
    }
}
SignalHandle& SignalHandle::GetInstance()
{
    std::cout << "SignalHandle::GetInstance()" << std::endl;
    return _instance;
}

void SignalHandle::sigsegvhandle(int signo)
{
    std::cout << "sigsegvhandle received signal: " << signo << std::endl;
    /* output callstack */
    DBG_ASSERT(0);
    /* reset signal handle to default */
    signal(signo, SIG_DFL);
    /* will receive SIGSEGV again and exit app */
}

} // namespace sfutils