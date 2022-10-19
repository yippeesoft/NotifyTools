#ifndef LOG_HPP
#define LOG_HPP
//#include <spdlog/sinks/rotating_file_sink.h>
//#include <spdlog/sinks/stdout_color_sinks.h>
//#include <spdlog/spdlog.h>
//#include <spdlog/async.h>
#include <source_location>
#include <filesystem>
#include <iostream>
#include <string_view>
#include <vector>

#pragma region BOOST::LOG
#ifdef BOOSTLOG
/***
https://stackoverflow.com/questions/59210778/address-sanitizer-error-when-using-boost-serialization
clang boost  AddressSanitizer 编译问题

结果:
https://github.com/google/sanitizers/issues/1174 
GCC #92928 (might apply to Clang too) 踢到gcc

https://gcc.gnu.org/bugzilla/show_bug.cgi?id=92928
gcc: 2019的提问,2021回复 :Not a bug, the sanitizer is doing the correct thing really.

https://github.com/boostorg/serialization/issues/182
BOOST reopened this on 20 Jan 2020

https://github.com/boostorg/log/blob/develop/example/basic_usage/main.cpp
BOOST::LOG 基本例子 << expr::format_date_time< boost::posix_time::ptime > 不能通过编译
注释后,运行,asan检测出错
**/

#define BOOST_LOG_DYN_LINK       1
#define BOOST_USE_WINAPI_VERSION BOOST_WINAPI_VERSION_WIN7

#include <boost/log/common.hpp>
#include <boost/log/sinks.hpp>
#include <boost/log/sources/logger.hpp>
#include <boost/log/trivial.hpp>
#include <boost/log/attributes/named_scope.hpp>
#include <boost/log/utility/setup/console.hpp>
#include <boost/log/utility/setup/file.hpp>
#include <boost/log/utility/setup/common_attributes.hpp>

#include <boost/log/attributes/timer.hpp>
#include <boost/log/attributes/named_scope.hpp>

#include <boost/log/sources/logger.hpp>

#include <boost/log/support/date_time.hpp>

namespace asiohttp {
using namespace std;
namespace logging = boost::log;
namespace sinks = boost::log::sinks;
namespace attrs = boost::log::attributes;
namespace src = boost::log::sources;
namespace expr = boost::log::expressions;
namespace keywords = boost::log::keywords;
/*
#define S_LOG_TRACE(logEvent) \
    BOOST_LOG_FUNCTION();     \
    BOOST_LOG_SEV(Logger::Instance()._logger, boost::log::trivial::trace) << logEvent;

#define S_LOG_DEBUG(logEvent) \
    BOOST_LOG_FUNCTION();     \
    BOOST_LOG_SEV(Logger::Instance()._logger, boost::log::trivial::debug) << logEvent;

#define S_LOG_INFO(logEvent) \
    BOOST_LOG_FUNCTION();    \
    BOOST_LOG_SEV(Logger::Instance()._logger, boost::log::trivial::info) << logEvent;

#define S_LOG_WARN(logEvent) \
    BOOST_LOG_FUNCTION();    \
    BOOST_LOG_SEV(Logger::Instance()._logger, boost::log::trivial::warning) << logEvent;

#define S_LOG_ERROR(logEvent) \
    BOOST_LOG_FUNCTION();     \
    BOOST_LOG_SEV(Logger::Instance()._logger, boost::log::trivial::error) << logEvent;

#define S_LOG_FATAL(logEvent) \
    BOOST_LOG_FUNCTION();     \
    BOOST_LOG_SEV(Logger::Instance()._logger, boost::log::trivial::fatal) << logEvent;
*/
class Log
{
public:
    static Log& Instance()
    {
        static Log log;
        return log;
    }
    void init()
    {
        logging::add_console_log(std::clog, keywords::format = "%TimeStamp%: %Message%");
        logging::add_common_attributes();
        logging::core::get()->add_thread_attribute("Scope", attrs::named_scope());

        BOOST_LOG_FUNCTION();
        src::logger lg;
        BOOST_LOG(lg) << "sdfsdf";
    }

private:
    Log()
    {
    }
};
} // namespace asiohttp
#endif
#pragma endregion

#if GLOG //GLOG没有滚动日志
#include <glog/logging.h>
class Log
{
public:
    void d(string s)
    {
        LOG(INFO) << s;
    }
    void Init(string processname)
    {
        if (google::IsGoogleLoggingInitialized()) { return; };
        FLAGS_colorlogtostderr = true;           // 带颜色的输出
        FLAGS_stderrthreshold = 0;               // 输出到控制台
        FLAGS_timestamp_in_logfile_name = false; //去掉每次不同时间戳文件名
        FLAGS_max_log_size = 1;
        FLAGS_stop_logging_if_full_disk = 1; //https://code.google.com/archive/p/google-glog/issues/22
        processname_ = string(processname);
        google::InitGoogleLogging(processname_.data());
        google::SetLogDestination(google::GLOG_INFO, "./logtestInfo");
        google::InstallFailureSignalHandler();
        google::SetLogFilenameExtension(".log"); //
    }
    Log(const Log&) = delete;
    Log& operator=(const Log&) = delete;
    static Log& getInstance()
    {
        static Log log;
        return log;
    }
    ~Log()
    {
    }

private:
    string processname_;
    Log()
    {
    }
};
#endif
#if SPDLOGG //asan 内存检测失败
[[nodiscard]] constexpr auto get_log_source_location(const source_location& location)
{
    return spdlog::source_loc{
        location.file_name(), static_cast<std::int32_t>(location.line()), location.function_name()};
}
class Log
{
public:
    Log(){};
    struct format_with_location
    {
        std::string_view value;
        spdlog::source_loc loc;

        template<typename String>
        format_with_location(const String& s, const source_location& location = source_location::current())
            : value{s}, loc{get_log_source_location(location)}
        {
        }
    };

    template<typename... Args>
    void warn(format_with_location fmt_, Args&&... args)
    {
        // !cpp20 above should warp fmt_.value with fmt::runtime
        spdlog::default_logger_raw()->log(
            fmt_.loc, spdlog::level::warn, fmt::runtime(fmt_.value), std::forward<Args>(args)...);
    }
    void multi_sink_example2()
    {
        spdlog::init_thread_pool(8192, 1);
        auto stdout_sink = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();
        auto rotating_sink = std::make_shared<spdlog::sinks::rotating_file_sink_mt>("mylog.txt", 1024 * 1024 * 10, 3);
        std::vector<spdlog::sink_ptr> sinks{stdout_sink, rotating_sink};
        auto logger = std::make_shared<spdlog::async_logger>(
            "loggername", sinks.begin(), sinks.end(), spdlog::thread_pool(), spdlog::async_overflow_policy::block);
        spdlog::register_logger(logger);
    }
    void InitSpdLog(int levell)
    {
        sinks.push_back(std::make_shared<spdlog::sinks::stdout_color_sink_mt>());
        sinks.push_back(std::make_shared<spdlog::sinks::rotating_file_sink_mt>(
            std::string(BASE_FILE_NAME), MAX_FILE_SIZE, MAX_FILE_COUNT));
        sinks[0]->set_pattern("[%Y-%m-%d %T.%e][%^%-8l%$][%-20s:%#] %v");
        sinks[1]->set_pattern("[%Y-%m-%d %T.%e][%-8l][%-20s:%#] %v");
        main_logger = std::make_shared<spdlog::logger>("xxx", begin(sinks), end(sinks));
        main_logger->flush_on(spdlog::level::err);
        spdlog::flush_every(std::chrono::seconds(1));
        main_logger->set_level(static_cast<spdlog::level::level_enum>(levell));
        /* set default */
        spdlog::register_logger(main_logger);
    }

private:
    static constexpr size_t MAX_FILE_SIZE = 1024 * 1024 * 100; //  100Mb
    static constexpr size_t MAX_FILE_COUNT = 10;
    static constexpr std::string_view BASE_FILE_NAME = "./running.log";
    std::shared_ptr<spdlog::logger> main_logger = nullptr;

    std::vector<spdlog::sink_ptr> sinks;
};
#endif

#endif