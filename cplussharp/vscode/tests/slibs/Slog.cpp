#include "Slog.h"
#define SPDLOG_NAME         "SmartDispenser"
#define SPDLOG_ACTIVE_LEVEL SPDLOG_LEVEL_TRACE //必须定义这个宏,才能输出文件名和行号
#include <spdlog/sinks/rotating_file_sink.h>
#include <spdlog/spdlog.h>
#include <spdlog/sinks/stdout_color_sinks.h>
#include <unistd.h>
#include <iostream>
auto console = spdlog::stdout_color_mt("console");

#include <iostream>
#include <signal.h>
#include <execinfo.h>

/* include <execinfo.h> to use this macro */
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

void sigsegv_test()
{
    std::cout << __func__ << " begin" << std::endl;
    char* buff = NULL;
    buff[1] = buff[1]; /* will crash here */
    std::cout << __func__ << " end" << std::endl;
}

void sigsegvhandle(int signo)
{
    std::cout << "sigsegvhandle received signal: " << signo << std::endl;
    /* output callstack */
    DBG_ASSERT(0);
    /* reset signal handle to default */
    signal(signo, SIG_DFL);
    /* will receive SIGSEGV again and exit app */
}

void testLibs(std::string ss)
{
    printf("test lib cmake %d\n", 1);
    SPDLOG_LOGGER_DEBUG(console, ss); //会输出文件名和行号
    printf("%s %s %s\r\n", __func__, __FUNCTION__, __PRETTY_FUNCTION__);
    printf("Caller name: %pS\n", __builtin_return_address(0));
    pid_t pid = getpid();
    char cmd[50];
    sprintf(cmd, "pstack %d ", pid);
    // system(cmd);
}
const int a[] = {SIGHUP, SIGINT, SIGQUIT, SIGILL, SIGTRAP, SIGABRT, SIGFPE, SIGKILL, SIGSEGV};
int main()
{
    for (unsigned int i = 0; i < sizeof(a) / sizeof(int); i++)
    {
        signal(a[i], sigsegvhandle);
    }
    console->enable_backtrace(32); // Store the latest 32 messages in a buffer. Older messages will be dropped.
    // or my_logger->enable_backtrace(32)..
    for (int i = 0; i < 100; i++)
    {
        spdlog::debug("Backtrace message {}", i); // not logged yet..
    }

    // e.g. if some error happened:

    try
    {
        console->set_level(spdlog::level::debug);
        printf("test liss cmake %d\n", 1);
        // spdlog::get(SPDLOG_NAME)->info("test2"); //
        spdlog::debug("Welcome to spdlog!");
        sigsegv_test();
        int i = 100 / 0;
        printf("test lib cmake %d\n", i);
        console->dump_backtrace(); // log them now! show the last 32 messages
        SPDLOG_DEBUG("test5");
        testLibs("sssssss");
        getchar();
    }
    catch (const std::exception& e)
    {
        std::cerr << e.what() << '\n';
    }
}