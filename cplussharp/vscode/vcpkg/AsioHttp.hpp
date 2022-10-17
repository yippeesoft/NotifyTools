#ifndef ASIO_HTTP_HPP
#define ASIO_HTTP_HPP
#include <thread>
#include <iostream>
#include <source_location>

#include <boost/asio.hpp>
#include <boost/asio/co_spawn.hpp>
#include <boost/asio/executor_work_guard.hpp>
#include <boost/asio/io_context.hpp>
#include <boost/bind.hpp>
#include <boost/thread.hpp>

#include <boost/beast/http.hpp>
#include <boost/asio/ip/tcp.hpp>

#define FMT_HEADER_ONLY
#include <spdlog/sinks/rotating_file_sink.h>
#include <spdlog/sinks/stdout_color_sinks.h>
#include <spdlog/spdlog.h>

namespace asiohttp {
namespace asio = boost::asio;
using tcp = boost::asio::ip::tcp;
namespace http = boost::beast::http;
class HttpAsio
{
public:
    HttpAsio() : guard_{asio::make_work_guard(ctx_)}
    {
        jthread_ = std::jthread([this]() { ctx_.run(); });
    }
    template<class F>
    void run(F f)
    {
        boost::asio::post(ctx_, f);
    }

    void run()
    {
        asio::co_spawn(ctx_, coro_test(), boost::asio::detached);
    }

    boost::asio::awaitable<void> coro_test()
    {
        auto executor = co_await asio::this_coro::executor;
        boost::asio::steady_timer timer(executor);
        timer.expires_after(std::chrono::seconds(1));
        co_await timer.async_wait(asio::use_awaitable);
        std::cout << "class coro_test\n";
        co_return;
    }
    ~HttpAsio()
    {
        std::cout << "~httpasio" << std::endl;
    }
    void clear()
    {
        ctx_.stop();
        jthread_.join();
    }

    void log(boost::system::error_code ec, const std::source_location& location = std::source_location::current())
    {
        std::cout << "Debug:" << location.file_name() << ':' << location.line() << ' ' << ec.value() << ":"
                  << ec.message() << std::endl;
        ;
    }
    void log(std::string_view msg, const std::source_location& location = std::source_location::current())
    {
        std::cout << "Debug:" << location.file_name() << ':' << location.line() << ' ' << msg << std::endl;
        ;
    }

public:
    boost::asio::awaitable<bool> do_session(
        std::string const& host, std::string const& port, std::string const& scheme = "https",
        std::string const& target = "/", int version = 11)
    {
        bool result = false;
        log("do_session");
        auto [ec, endpoint]
            = co_await resolver_.async_resolve(host, port, boost::asio::as_tuple(boost::asio::use_awaitable));
        if (ec)
        {
            log(ec);
            co_return result;
        }
    }

private:
    asio::io_context ctx_{};
    boost::system::error_code ec_;
    tcp::resolver resolver_{ctx_};
    tcp::socket socket_{ctx_};

    std::jthread jthread_;
    asio::executor_work_guard<asio::io_context::executor_type> guard_;
};
}; // namespace asiohttp

#endif