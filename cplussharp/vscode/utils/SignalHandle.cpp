#include "SignalHandle.h"
#include "spdlog/spdlog.h"
namespace sfutils {
SignalHandle SignalHandle::_instance;
int SignalHandle::signals[] = {SIGHUP, SIGINT, SIGQUIT, SIGILL, SIGTRAP, SIGABRT, SIGFPE, SIGKILL, SIGSEGV};
SignalHandle::SignalHandle(/* args */)
{
    for (unsigned int i = 0; i < sizeof(signals) / sizeof(int); i++)
    {
        signal(signals[i], sigsegvhandle);
    }
}

SignalHandle::~SignalHandle()
{
}
SignalHandle& SignalHandle::GetInstance()
{
    std::cout << "SignalHandle::GetInstance()" << std::endl;
    return _instance;
}

void SignalHandle::sigsegvhandle(int signo)
{
    // https://www.cnblogs.com/zhangchengxin/p/7767213.html
    // boost stacktrace堆栈保存
    // https://blog.csdn.net/jxgz_leo/article/details/53458366

    // https://blog.csdn.net/halazi100/article/details/84037452
    std::cout << "sigsegvhandle received signal: " << signo << "\t" << strsignal(signo) << std::endl;
    // printf("__builtin_return_address %s(0): %p\n", __func__, __builtin_return_address(0));
    // printf("__builtin_return_address %s(1): %p\n", __func__, __builtin_return_address(1));
    /* output callstack */
    DBG_ASSERT(0);

    /* reset signal handle to default */
    signal(signo, SIG_DFL);
    /* will receive SIGSEGV again and exit app */
}

} // namespace sfutils