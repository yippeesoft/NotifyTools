#ifndef ASIO_HTTP_HPP
#define ASIO_HTTP_HPP

#include <boost/asio.hpp>
#include <boost/asio/co_spawn.hpp>
#include <boost/asio/executor_work_guard.hpp>
#include <boost/asio/io_context.hpp>
#include <boost/bind.hpp>
#include <boost/thread.hpp>
#include <iostream>
#include <thread>

namespace asiohttp {
namespace asio = boost::asio;
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
        std::cout << "coro_test\n";
        co_return;
    }
    ~HttpAsio()
    {
    }
    void clear()
    {
        ctx_.stop();
        jthread_.join();
    }

private:
    asio::io_context ctx_{};
    std::jthread jthread_;
    asio::executor_work_guard<asio::io_context::executor_type> guard_;
};
}; // namespace asiohttp

#endif