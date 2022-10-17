#ifndef LOG_HPP
#define LOG_HPP
#define FMT_HEADER_ONLY

#include <spdlog/sinks/rotating_file_sink.h>
#include <spdlog/sinks/stdout_color_sinks.h>
#include <spdlog/spdlog.h>

#include <source_location>
#include <filesystem>
#include <iostream>
#include <string_view>
#include <vector>

static constexpr size_t MAX_FILE_SIZE = 1024 * 1024 * 100; //  100Mb
static constexpr size_t MAX_FILE_COUNT = 10;
static constexpr std::string_view BASE_FILE_NAME = ".s/running.log";

using source_location = std::source_location;
void InitBeforeStart(int level);
[[nodiscard]] constexpr auto get_log_source_location(const source_location& location)
{
    return spdlog::source_loc{
        location.file_name(), static_cast<std::int32_t>(location.line()), location.function_name()};
}

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

void InitSpdLog(int levell)
{
    std::shared_ptr<spdlog::logger> main_logger = nullptr;

    std::vector<spdlog::sink_ptr> sinks;
    sinks.push_back(std::make_shared<spdlog::sinks::stdout_color_sink_mt>());
    sinks.push_back(std::make_shared<spdlog::sinks::rotating_file_sink_mt>(
        std::string(BASE_FILE_NAME), MAX_FILE_SIZE, MAX_FILE_COUNT));
    sinks[0]->set_pattern("[%Y-%m-%d %T.%e][%^%-8l%$][%-20s:%#] %v");
    sinks[1]->set_pattern("[%Y-%m-%d %T.%e][%-8l][%-20s:%#] %v");
    main_logger = std::make_shared<spdlog::logger>("xxx", begin(sinks), end(sinks));
    main_logger->flush_on(spdlog::level::err);
    spdlog::flush_every(std::chrono::seconds(1));

    /* set default */
    spdlog::set_default_logger(main_logger);
    main_logger->set_level(static_cast<spdlog::level::level_enum>(levell));
}
//———————————————— 版权声明：本文为CSDN博主「猪二哥」的原创文章，遵循CC 4.0 BY
//    - SA版权协议，转载请附上原文出处链接及本声明。 原文链接：https
//    : //blog.csdn.net/weixin_42254068/article/details/126566982

#endif