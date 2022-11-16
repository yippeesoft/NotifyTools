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
    HttpAsio() : guard_{asio::make_work_guard(ioc_)}
    {
        jthread_ = std::jthread([this]() { ioc_.run(); });
    }
    template<class F>
    void run(F f)
    {
        boost::asio::post(ioc_, f);
    }

    void run()
    {
        //asio::co_spawn(ctx_, coro_test(), boost::asio::detached
        asio::co_spawn(ioc_, co_httpGet("www.163.com", "80"), boost::asio::detached);
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
        ioc_.stop();
        jthread_.join();
    }

    bool httpDownload(
        std::string const host, std::string port, std::string const target = "/", std::string const scheme = "https",
        int version = 11)
    {
        auto fu = boost::asio ::co_spawn(
            ioc_, co_httpDownload(host, port, scheme, target, version), boost::asio::use_future);
        return fu.get();
    }

    //https://github.com/boostorg/beast/issues/2335
    //https://www.boost.org/doc/libs/1_80_0/libs/beast/doc/html/beast/using_http/parser_stream_operations/read_large_response_body.html
    //https://www.boost.org/doc/libs/1_80_0/libs/beast/doc/html/beast/using_http/parser_stream_operations/incremental_read.html

    /*
    https://www.boost.org/doc/libs/1_80_0/libs/beast/doc/html/beast/using_http/parser_stream_operations.html
    Non-trivial algorithms need to do more than receive entire messages at once, such as:

    Receive the header first and body later.
    Receive a large body using a fixed-size buffer.
    Receive a message incrementally: bounded work in each I/O cycle.
    这些不是网络基本操作么,,,,
    */
    boost::asio::awaitable<bool> co_httpDownload(
        std::string host, std::string port, std::string const& scheme = "https", std::string const& target = "/",
        int version = 11)
    {
        bool result = false;
        //LOGD("{}", do_session);
        try
        {
            auto endpoints = co_await resolver_.async_resolve(host, port, boost::asio::use_awaitable);

            auto tcpp
                = co_await asio::async_connect(socket_, endpoints.begin(), endpoints.end(), boost::asio::use_awaitable);

            http::request<http::string_body> req{http::verb::get, target, version};
            req.set(http::field::host, host);
            req.set(http::field::user_agent, BOOST_BEAST_VERSION_STRING);

            auto writelen = co_await http::async_write(socket_, req, asio::use_awaitable);
            boost::beast::flat_buffer buffer;
            {
                //https://www.boost.org/doc/libs/1_80_0/libs/beast/doc/html/beast/more_examples/change_body_type.html
                //https://www.boost.org/doc/libs/1_80_0/libs/beast/doc/html/beast/using_http/parser_stream_operations/incremental_read.html
                //还是 limit exceeded
                http::parser<false, http::buffer_body> req0;

                // Read just the header. Otherwise, the empty_body
                // would generate an error if body octets were received.
                error_code ec;
                http::read_header(socket_, buffer, req0);
                std::cout << req0.get()[http::field::content_type] << req0.get()[http::field::content_length];
            }
            if (0)
            {
                http::parser<false, http::buffer_body> p;

                //读头也会 limit exceeded
                auto readlen = co_await http::async_read_header(socket_, buffer, p, asio::use_awaitable);
                std::cout << p.get().result() << p.get().result_int() << p.get().has_content_length()
                          << " ;content_length: " << p.get()[boost::beast::http::field::content_length] << std::endl;

                //大文件导致: body limit exceeded
                boost::beast::flat_buffer buff;
                http::response<http::file_body> res;
                // res.body().size()
                res.body().open("d:/ttt.test", boost::beast::file_mode::write_new, ec_);

                readlen = co_await http::async_read(socket_, buff, res, asio::use_awaitable);
                res.body().close();
                LOGD(fmt::format("async_read: {}", readlen));
            }
            //std::cout << "read:" << (fmt::format("async_read: {}", readlen)) << std::endl;

            result = true;
        }
        catch (std::exception e)
        {
            LOGD(e.what());
        }
        co_return result;
    }

    bool httpGet(
        std::string const host, std::string port, std::string const target = "/", std::string const scheme = "https",
        int version = 11)
    {
        auto fu
            = boost::asio ::co_spawn(ioc_, co_httpGet(host, port, scheme, target, version), boost::asio::use_future);
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

            //std::cout << "read:" << (fmt::format("async_read: {}", readlen)) << std::endl;
            LOGD(fmt::format("async_read: {}", readlen));
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
    asio::io_context ioc_{};
    boost::system::error_code ec_;
    tcp::resolver resolver_{ioc_};
    tcp::socket socket_{ioc_};

    std::jthread jthread_;
    asio::executor_work_guard<asio::io_context::executor_type> guard_;

    boost::asio::cancellation_state cs;
};
}; // namespace asiohttp

#endif