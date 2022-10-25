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

#include "common.hpp"

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
        //asio::co_spawn(ctx_, coro_test(), boost::asio::detached
        asio::co_spawn(ctx_, co_httpGet("www.163.com", "80"), boost::asio::detached);
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

    bool httpGet(
        std::string const host, std::string port, std::string const target = "/", std::string const scheme = "https",
        int version = 11)
    {
        auto fu
            = boost::asio ::co_spawn(ctx_, co_httpGet(host, port, scheme, target, version), boost::asio::use_future);
        return fu.get();
    }
    boost::asio::awaitable<bool> co_httpGet(
        std::string host, std::string port, std::string const& scheme = "https", std::string const& target = "/",
        int version = 11)
    {
        //大文件导致: body limit exceeded [beast.http:9]
        bool result = false;
        //LOGD("{}", do_session);
        try
        {
#if 0
            auto [ec, endpoint]
                = co_await resolver_.async_resolve(host, port, boost::asio::as_tuple(boost::asio::use_awaitable));
            if (ec)
            {
                LOGE(ec);
                co_return result;
            }
#endif
            auto endpoints = co_await resolver_.async_resolve(host, port, boost::asio::use_awaitable);

            auto tcpp
                = co_await asio::async_connect(socket_, endpoints.begin(), endpoints.end(), boost::asio::use_awaitable);
            http::request<http::string_body> req{http::verb::get, target, version};
            req.set(http::field::host, host);
            req.set(http::field::user_agent, BOOST_BEAST_VERSION_STRING);

            auto writelen = co_await http::async_write(socket_, req, asio::use_awaitable);

            boost::beast::flat_buffer buff;
            http::response<http::dynamic_body> res;
            auto readlen = co_await http::async_read(socket_, buff, res, asio::use_awaitable);

            std::cout << "read:" << (fmt::format("async_read: {}", readlen)) << std::endl;

            std::cout << "reason:" << res.reason() << res["Content-Length"] << std::endl;
            std::cout << fmt::format("async_read:len: {}   {}", readlen, 444) << std::endl;
            result = true;
        }
        catch (std::exception e)
        {
            LOGD(e.what());
        }
        co_return result;
    }

private:
    asio::io_context ctx_{};
    boost::system::error_code ec_;
    tcp::resolver resolver_{ctx_};
    tcp::socket socket_{ctx_};

    std::jthread jthread_;
    asio::executor_work_guard<asio::io_context::executor_type> guard_;

    boost::asio::cancellation_state cs;
};
}; // namespace asiohttp

#endif