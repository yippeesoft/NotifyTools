#include "Slog.h"
#define SPDLOG_NAME         "SmartDispenser"
#define SPDLOG_ACTIVE_LEVEL SPDLOG_LEVEL_TRACE //必须定义这个宏,才能输出文件名和行号
#include <spdlog/sinks/rotating_file_sink.h>
#include <spdlog/spdlog.h>
#include <spdlog/sinks/stdout_color_sinks.h>
#include <unistd.h>
#include <iostream>
auto console = spdlog::stdout_color_mt("console");
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

int main()
{
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
        int kk = 100 / 0;
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