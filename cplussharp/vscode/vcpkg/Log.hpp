#ifndef LOG_HPP
#define LOG_HPP
//#include <spdlog/sinks/rotating_file_sink.h>
//#include <spdlog/sinks/stdout_color_sinks.h>
//#include <spdlog/spdlog.h>
//#include <spdlog/async.h>
#include <filesystem>
#include <iostream>
#include <string_view>
#include <vector>
#include <source_location>

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
// #define BOOST_USE_WINAPI_VERSION BOOST_WINAPI_VERSION_WIN7

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

#include <glog/logging.h>
#include <spdlog/spdlog.h>
#include <spdlog/cfg/env.h>
#include <spdlog/sinks/basic_file_sink.h>
#include <spdlog/sinks/rotating_file_sink.h>

#include "Utils.hpp"

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
class BoostLog
{
public:
    static BoostLog& Instance()
    {
        static BoostLog log;
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
    BoostLog()
    {
    }
};

//GLOG没有滚动日志

using namespace std;
class GLog
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
    GLog(const GLog&) = delete;
    GLog& operator=(const GLog&) = delete;
    static GLog& Instance()
    {
        static GLog log;
        return log;
    }
    ~GLog()
    {
    }

private:
    string processname_;
    GLog()
    {
    }
};
using source_location = std::source_location;
constexpr std::string_view filename_only(std::source_location location = std::source_location::current())
{
    std::string_view s = location.file_name();
    return s.substr(s.find_last_of('/') + 1);
}
[[nodiscard]] constexpr auto get_log_source_location(const source_location& location)
{
    std::string_view s = location.file_name(); //filename_only(location);
    //(location.file_name());
    int i = s.find_last_of('\\');
    return spdlog::source_loc{
        s.substr(i + 1).data(), static_cast<std::int32_t>(location.line()), location.function_name()};
}
class LogSpd
{
public:
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
    void warn(format_with_location fmt, Args&&... args)
    {
        spdlog::default_logger_raw()->log(fmt.loc, spdlog::level::warn, fmt.value, std::forward<Args>(args)...);
    }
    template<typename... Args>
    void d(format_with_location fmt, Args&&... args)
    {
        //spdlog::debug(s);
        console_->log(fmt.loc, spdlog::level::debug, fmt.value, std::forward<Args>(args)...);
    }
    void Init(std::string processname, std::string filename, size_t maxfilesize = 1024, size_t maxfiles = 1)
    {
        spdlog::cfg::load_env_levels();

        // Runtime log levels
        spdlog::set_level(spdlog::level::info); // Set global log level to info
        //spdlog::debug("This message should not be displayed!");
        spdlog::set_level(spdlog::level::trace); // Set specific logger's log level
        //spdlog::debug("This message should be displayed..");

        // Customize msg format for all loggers
        //spdlog::set_pattern("[%H:%M:%S %z] [%^%L%$] [thread %t] %v");
        //spdlog::info("This an info message with custom format");
        spdlog::set_pattern("%+"); // back to default format
        spdlog::set_level(spdlog::level::trace);

        console_ = spdlog::stdout_color_mt(processname + "console");

        console_->set_level(spdlog::level::trace);
        console_->set_pattern("[%Y-%m-%d %H:%M:%S.%e][thread %t][%@,%!][%l] : %v");

        rotating_ = spdlog::rotating_logger_mt(processname + "file", filename, maxfilesize, maxfiles);
        rotating_->set_level(spdlog::level::trace);
    }
    LogSpd(const LogSpd&) = delete;
    LogSpd& operator=(const LogSpd&) = delete;
    static LogSpd& Instance()
    {
        static LogSpd log;
        return log;
    }
    ~LogSpd()
    {
    }

private:
    LogSpd(){};
    std::shared_ptr<spdlog::logger> console_;
    std::shared_ptr<spdlog::logger> rotating_;
};

class Log
{
public:
    void static Init(std::string processname, std::string filename, size_t maxfilesize = 1024, size_t maxfiles = 1)
    {
        LogSpd::Instance().Init(processname, filename, maxfilesize, maxfiles);
    }
};
} // namespace asiohttp
#endif