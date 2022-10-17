

#include <fmt/core.h>
#include <ios>
#include <nlohmann/json_fwd.hpp>
#include <stdio.h>
#include <string.h>
#include <string>
#include <iostream>
#include <fmt/format.h>

#include <iostream>
#include <string>
#include <sstream>
#include <iomanip>
#include "nlohmann/json.hpp"
#include <optional>
#include "hv/requests.h"
#include "hv/hthread.h" // import hv_gettid

#define BOOST_ASIO_ENABLE_HANDLER_TRACKING
#include <boost/beast/http/field.hpp>
#include <boost/beast/http/string_body.hpp>
#include <boost/asio/co_spawn.hpp>
#include <boost/asio/detached.hpp>
#include <boost/asio/coroutine.hpp>
#include <boost/beast/version.hpp>
#include <boost/asio/connect.hpp>
#include <boost/asio/spawn.hpp>
#include <boost/asio.hpp>
#include <boost/beast/ssl.hpp>
#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast.hpp>
#include <boost/beast/version.hpp>
#include <boost/asio/connect.hpp>
#include <boost/asio/ip/tcp.hpp>
#include <boost/asio/strand.hpp>
#include <boost/asio/ssl/error.hpp>
#include <boost/asio/ssl/stream.hpp>
#include <boost/bind.hpp>
#include <boost/thread.hpp>

#include <cstdlib>
#include <iostream>
#include <string>
#include "root_certificates.hpp"
#include <openssl/configuration.h>

#include <openssl/macros.h>
#include <openssl/ssl.h>
#include <openssl/hmac.h>

#include <coroutine>
#include "AsioHttp.hpp"
#include "Log.hpp"
using namespace nlohmann;
using namespace std;
void testFmt();
void testHMAC();
void testStd();
void testjson();
void testjsoncls();
void testhvhttp();
void testboosthttpSync();
void testNullPtr();
void test_http_async_client();
void test_http_spawn_clinet();
void test_http_co_spawn_clinet();
void test_http_co_spawn_time();
void test_http_class();
void test_union()
{
    union un
    {
        float f;
        int i;
    };
    un u;

    u.f = 1234;
    u.i = 5678;
    std::cout << u.f << std::endl;
}
void testAsan()
{
    int* ary = new int[100];
    ary[100] = 100;
}

std::thread t;

int main()
{
    std::cout << "main begin" << std::endl;
    InitSpdLog(1);
    warn(" This is a log message, {} + {} = {}\n", 1, 1, 2);
    //testAsan();
    //test_union();
    // testHMAC();
    // testStd();
    // testjson();
    // testjsoncls();
    // testhvhttp();
    // testboosthttpSync();
    // testNullPtr();
    //test_http_async_client();
    //test_http_spawn_clinet();
    // test_http_co_spawn_clinet();
    //test_http_co_spawn_time();
    test_http_class();

    std::cout << "Main thread will for 1 seconds...\n"; // 这里是为了防止stop()执行过快
    std::this_thread::sleep_for(std::chrono::seconds(1));
    std::cout << t.joinable() << " ::Main thread weak up...\n";
    if (t.joinable())
    {
        std::cout << "joinable:" << t.get_id() << std::endl;
        t.join();
    }
    std::cout << "main end" << std::endl;

    return 0;
}

#pragma region http_class
void test_http_class()
{
    std::shared_ptr<asiohttp::HttpAsio> ha = std::make_shared<asiohttp::HttpAsio>();
    ha->run();
    //ha->clear();
    return;
}
#pragma endregion http_class

#pragma region testNullPtr
class Test
{
public:
    void Say()
    {
        std::cout << "Say Test" << std::endl;
    }

    void Set(int data)
    {
        _data = data;
    }

private:
    int _data;
};
void testNullPtr()
{
    // 运行成功
    ((Test*)nullptr)->Say();
    // 运行会崩掉，尝试访问空指针所指内存(_data)
    ((Test*)nullptr)->Set(1);
}
#pragma endregion

#pragma region boosthttp
template<bool isRequest, class SyncReadStream, class DynamicBuffer>
auto read_and_print_body(std::ostream& os, SyncReadStream& stream, DynamicBuffer& buffer, boost::beast::error_code& ec)
{
    namespace net = boost::asio;
    namespace beast = boost::beast;
    namespace http = beast::http;
    using net::ip::tcp;
    struct
    {
        size_t hbytes = 0, bbytes = 0;
    } ret;

#ifdef readstream
    // Read the response status line. The response streambuf will automatically
    // grow to accommodate the entire line. The growth may be limited by passing
    // a maximum size to the streambuf constructor.
    boost::asio::streambuf response;
    boost::asio::read_until(stream, response, "\r\n");

    // Check that response is OK.
    std::istream response_stream(&response);
    std::string http_version;
    response_stream >> http_version;
    unsigned int status_code;
    response_stream >> status_code;
    std::string status_message;
    std::getline(response_stream, status_message);
    string srespcode = fmt::format("ver:{0} ; code: {1} ;status:{2}\n", http_version, status_code, status_message);
    fmt::print(srespcode + "\nheader\n");
    // 传说中的包头可以读下来了
    std::string header;
    std::vector<string> headers;
    while (std::getline(response_stream, header) && header != "\r")
    {
        fmt::print(header);
        fmt::print("\n");
        headers.push_back(header);
    }
#endif

#ifdef emptybody
    // // Start with an empty_body parser
    boost::beast::http::response<boost::beast::http::file_body> req0;
    req0.body().open("body.html", beast::file_mode::write_new, ec);
    http::read(stream, buffer, req0);
    std::cout << "file_body:" << req0.result_int() << req0.has_content_length() << ";ver:" << req0.reason();

#endif
#define bufferbodyparser
#ifdef bufferbodyparser
    http::parser<isRequest, http::buffer_body> p;
    ret.hbytes = http::read_header(stream, buffer, p, ec);
    std::cout << p.get().result() << p.get().result_int() << p.get().has_content_length()
              << " ;content_length: " << p.get()[boost::beast::http::field::content_length] << std::endl;

    while (!p.is_done())
    {
        char buf[512];
        p.get().body().data = buf;
        p.get().body().size = sizeof(buf);
        int trns = http::read_some(stream, buffer, p, ec);
        ret.bbytes += trns;
        if (ec) return ret;
        os.write(buf, sizeof(buf) - p.get().body().size);
        std::cout << trns << "\n" << p.get().body().size << "\n" << std::endl;
    }
#endif
    return ret;
}

#pragma region test_http_co_spawn_time
namespace asio = boost::asio;
boost::asio::cancellation_signal cancel_signal_2;
boost::asio::awaitable<void> coro_test(asio::io_context& ctx)
{
    boost::asio::steady_timer timer(ctx);
    timer.expires_after(std::chrono::seconds(1));
    co_await timer.async_wait(asio::use_awaitable);
    std::cout << "coro_test" << std::endl;
    co_return;
}

void ctxrun(asio::io_context& ctx)
{
    ctx.run();
}

void test()
{
    asio::io_context ctx{}; //被释放了
    asio::co_spawn(ctx, coro_test(ctx), boost::asio::detached);
    t = std::thread(ctxrun, std::ref(ctx));
    t.join();
    std::cout << "test2" << std::endl;
}
struct structfun
{
    void fun()
    {
        std::this_thread::sleep_for(std::chrono::seconds(2));
        std::cout << "fun" << std::endl;
    }
};
void threadfun()
{
    structfun sfun;
    t = std::thread(&structfun::fun, &sfun);
}
void test_http_co_spawn_time()
{
    //threadfun();
    //t.join();
    test();

    std::this_thread::sleep_for(std::chrono::seconds(2));

    std::cout << "enendd" << std::endl;
}

#pragma endregion
//https://www.boost.org/doc/libs/develop/libs/beast/example/http/client/sync/http_client_sync.cpp
//C++ 使用boost实现http客户端——同步、异步、协程
#pragma region test_http_co_spaw_clinet
//https://www.boost.org/doc/libs/1_80_0/doc/html/boost_asio/example/cpp20/coroutines/echo_server.cpp
void fail(boost::system::error_code ec, char const* what)
{
    std::cerr << what << ":code:" << ec.value() << ":msg:" << ec.message() << "\n";
}
void canceled(boost::asio::cancellation_state cs)
{
    std::cout << "cancellation_state: "
              << static_cast<typename std::underlying_type<boost::asio::cancellation_type>::type>(cs.cancelled())
              << " :  ";
    if (cs.cancelled() == boost::asio::cancellation_type::all) { std::cout << "all"; };
    if (cs.cancelled() == boost::asio::cancellation_type::none) { std::cout << "none"; };
    if (cs.cancelled() == boost::asio::cancellation_type::partial) { std::cout << "partial"; };
    if (cs.cancelled() == boost::asio::cancellation_type::terminal) { std::cout << "terminal"; };
    if (cs.cancelled() == boost::asio::cancellation_type::total) { std::cout << "total"; };
    //<< static_cast<typename std::underlying_type<boost::asio::cancellation_type>::type>(cs.cancelled())
    std::cout << "" << std::endl;
}
boost::asio::awaitable<void> co_wait_async(boost::asio::ip::tcp::resolver resolver, boost::asio::ip::tcp::socket socket)
{
    boost::asio::cancellation_state cs;
    for (int i = 0; i < 0; i++)
    {
        cs = co_await boost::asio::this_coro::cancellation_state;
        canceled(cs);
        std::cout << i << ": sleep_for:";

        std::this_thread::sleep_for(std::chrono::seconds(1));
    }
    try
    {
        using tcp = boost::asio::ip::tcp;    // from <boost/asio/ip/tcp.hpp>
        namespace http = boost::beast::http; // from <boost/beast/http.hpp>
        auto const host = "www.163.com";
        auto const port = "80";
        auto const target = "/loading.html";
        int version = 11;

        std::cout << "co_wait_async\n" << std::endl;
        auto [ec, endpoint]
            = co_await resolver.async_resolve(host, port, boost::asio::as_tuple(boost::asio::use_awaitable));
        if (ec) { fail(ec, "resolve"); }
        std::cout << endpoint.size() << " ;async_resolve\n" << std::endl;
        for (auto ep : endpoint) { std::cout << ep.endpoint().address() << ep.endpoint().port() << std::endl; }

        std::cout << "async_resolve1\n" << std::endl;

        boost::asio::ip::tcp::endpoint m_ep(boost::asio::ip::address::from_string("aaa", ec), 80);
        if (ec) { fail(ec, "from_string"); }
        //m_ep = boost::asio::ip::tcp::endpoint(boost::asio::ip::address::from_string("aaa"), 80);

        cs = co_await boost::asio::this_coro::cancellation_state;
        canceled(cs);

        auto [ec1, n] = co_await boost::asio::async_connect(
            socket, endpoint.begin(), endpoint.end(), boost::asio::as_tuple(boost::asio::use_awaitable));
        if (ec) { fail(ec, "async_connect"); }
        std::cout << "async_connect\n" << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(1));
        cs = co_await boost::asio::this_coro::cancellation_state;
        canceled(cs);
        http::request<http::string_body> req{http::verb::get, target, version};
        req.set(http::field::host, host);
        req.set(http::field::user_agent, BOOST_BEAST_VERSION_STRING);
        std::cout << "request set \n" << std::endl;
        auto [ec2, n1] = co_await http::async_write(socket, req, boost::asio::as_tuple(boost::asio::use_awaitable));
        boost::beast::flat_buffer b;
        std::cout << "async_write\n" << std::endl;
        /*
	https://www.boost.org/doc/libs/1_80_0/doc/html/boost_asio/overview/core/cancellation.html
	https://www.boost.org/doc/libs/1_80_0/doc/html/boost_asio/overview/composition/cpp20_coroutines.html#boost_asio.overview.composition.cpp20_coroutines.coroutines_and_per_operation_cancellation
	boost::asio::cancellation_signal cancel_signal_;
	boost::asio::async_read(
		socket, b,
		boost::asio::bind_cancellation_slot(cancel_signal_.slot(), [](boost::system::error_code e, std::size_t n) {}));
	*/

        http::response<http::dynamic_body> res;
        auto [ecx, n2] = co_await http::async_read(socket, b, res, boost::asio::as_tuple(boost::asio::use_awaitable));
        std::cout << "async_read\n" << std::endl;
        std::cout << res << std::endl;
        boost::system::error_code ecc;
        socket.shutdown(tcp::socket::shutdown_both, ecc);
        std::cout << "shutdown\n" << std::endl;
    }
    catch (exception e)
    {
        std::cout << " !!!!!!!excep:: " << e.what() << std::endl;
    }
    co_return;
}
void signal_handler(const boost::system::error_code& err, int signal)
{
    switch (signal)
    {
    case SIGINT: std::cout << "SIGNINT" << std::endl; break;
    case SIGTERM: std::cout << "SIGNTERM" << std::endl; break;
    default: break;
    }
}
boost::asio::cancellation_signal cancel_signal_;
void test_http_co_spawn_clinet()
{
    boost::asio::io_context io_context;
    boost::asio::signal_set signals(io_context, SIGINT, SIGTERM);
    //signals.async_wait([&](auto, auto) { io_context.stop(); });
    //signals.async_wait(signal_handler);

    boost::asio::ip::tcp::resolver resolver{io_context};
    boost::asio::ip::tcp::socket socket{io_context};

    co_spawn(
        io_context, co_wait_async(std::move(resolver), std::move(socket)),
        boost::asio::bind_cancellation_slot(cancel_signal_.slot(), boost::asio::detached));

    std::cout << "co_spawn\n" << std::endl;
    boost::system::error_code ec;
    //io_context.run(ec);
    t = (std::thread([&io_context]() { io_context.run(); }));

    for (int i = 0; i < 1; i++)
    {
        std::this_thread::sleep_for(std::chrono::seconds(1));
        cancel_signal_.emit(boost::asio::cancellation_type::none);
        std::cout << "test_http_co_spawn_clinet end cancel_signal_ emit \n" << std::endl;
    }

    std::cout << t.get_id() << " :: test_http_co_spawn_clinet end cancel_signal_ emit end \n" << std::endl;
}
#pragma endregion

#pragma region spawn

void do_session(
    std::string const& host, std::string const& port, std::string const& target, int version,
    boost::asio::io_context& ioc, boost::asio::yield_context yield)
{
    using tcp = boost::asio::ip::tcp;    // from <boost/asio/ip/tcp.hpp>
    namespace http = boost::beast::http; // from <boost/beast/http.hpp>

    boost::system::error_code ec;
    tcp::resolver resolver{ioc};
    tcp::socket socket{ioc};

    auto const results = resolver.async_resolve(host, port, yield[ec]);
    if (ec) { return fail(ec, "resolve"); }
    boost::asio::async_connect(socket, results.begin(), results.end(), yield[ec]);
    if (ec) { return fail(ec, "async_connect"); }
    http::request<http::string_body> req{http::verb::get, target, version};
    req.set(http::field::host, host);
    req.set(http::field::user_agent, BOOST_BEAST_VERSION_STRING);
    http::async_write(socket, req, yield[ec]);
    if (ec) { return fail(ec, "write"); }
    boost::beast::flat_buffer b;
    http::response<http::dynamic_body> res;
    http::async_read(socket, b, res, yield[ec]);
    if (ec) { return fail(ec, "read"); }
    std::cout << res << std::endl;
    socket.shutdown(tcp::socket::shutdown_both, ec);
    if (ec && ec != boost::system::errc::not_connected) { return fail(ec, "shutdown"); }
}
void test_http_spawn_clinet()
{
    auto const host = "www.baidu.com";
    auto const port = "80";
    auto const target = "/loading.html";
    int version = 11;

    boost::asio::io_context ioc;
    boost::asio::spawn(
        ioc, std::bind(
                 &do_session, std::string(host), std::string(port), std::string(target), version, std::ref(ioc),
                 std::placeholders::_1));
    ioc.run();
}

#pragma endregion

#pragma region async
namespace beast = boost::beast;   // from <boost/beast.hpp>
namespace http = beast::http;     // from <boost/beast/http.hpp>
namespace net = boost::asio;      // from <boost/asio.hpp>
using tcp = boost::asio::ip::tcp; // from <boost/asio/ip/tcp.hpp>
// Performs an HTTP GET and prints the response

class session : public std::enable_shared_from_this<session>
{
    // Report a failure
    void fail(beast::error_code ec, char const* what)
    {
        std::cerr << what << ": " << ec.message() << "\n";
    }

    tcp::resolver resolver_;
    beast::tcp_stream stream_;
    beast::flat_buffer buffer_; // (Must persist between reads)
    http::request<http::empty_body> req_;
    http::response<http::string_body> res_;

public:
    // Objects are constructed with a strand to
    // ensure that handlers do not execute concurrently.
    explicit session(net::io_context& ioc) : resolver_(net::make_strand(ioc)), stream_(net::make_strand(ioc))
    {
    }

    // Start the asynchronous operation
    void run(char const* host, char const* port, char const* target, int version)
    {
        // Set up an HTTP GET request message
        req_.version(version);
        req_.method(http::verb::get);
        req_.target(target);
        req_.set(http::field::host, host);
        req_.set(http::field::user_agent, BOOST_BEAST_VERSION_STRING);

        // Look up the domain name
        resolver_.async_resolve(host, port, beast::bind_front_handler(&session::on_resolve, shared_from_this()));
    }

    void on_resolve(beast::error_code ec, tcp::resolver::results_type results)
    {
        if (ec) return fail(ec, "resolve");

        // Set a timeout on the operation
        stream_.expires_after(std::chrono::seconds(30));

        // Make the connection on the IP address we get from a lookup
        stream_.async_connect(results, beast::bind_front_handler(&session::on_connect, shared_from_this()));
    }

    void on_connect(beast::error_code ec, tcp::resolver::results_type::endpoint_type)
    {
        if (ec) return fail(ec, "connect");

        // Set a timeout on the operation
        stream_.expires_after(std::chrono::seconds(30));

        // Send the HTTP request to the remote host
        http::async_write(stream_, req_, beast::bind_front_handler(&session::on_write, shared_from_this()));
    }

    void on_write(beast::error_code ec, std::size_t bytes_transferred)
    {
        boost::ignore_unused(bytes_transferred);

        if (ec) return fail(ec, "write");

        // Receive the HTTP response
        http::async_read(stream_, buffer_, res_, beast::bind_front_handler(&session::on_read, shared_from_this()));
    }

    void on_read(beast::error_code ec, std::size_t bytes_transferred)
    {
        boost::ignore_unused(bytes_transferred);

        if (ec) return fail(ec, "read");

        // Write the message to standard out
        std::cout << res_.body().size() << "\n" << res_ << std::endl;

        // Gracefully close the socket
        stream_.socket().shutdown(tcp::socket::shutdown_both, ec);

        // not_connected happens sometimes so don't bother reporting it.
        if (ec && ec != beast::errc::not_connected) return fail(ec, "shutdown");

        // If we get here then the connection is closed gracefully
    }
};

void test_http_async_client()
{
    net::io_context ioc;
    auto const host = "www.baidu.com"; //要访问的主机名
    auto const port = "80";            //http服务端口
    auto const target = "/";           //要获取的文档
    // auto const url = "https://www.baidu.com";
    int version = 11;
    // Launch the asynchronous operation
    std::make_shared<session>(ioc)->run(host, port, target, version);
    // Run the I/O service. The call will return when
    // the get operation is complete.
    // ioc.run(); //堵塞
#ifdef stdthread
    std::thread t([&ioc]() { ioc.run(); });
    t.detach();

    //t.join();
#endif
    std::function<void()> accumulator = [&ioc]() { ioc.run(); };
    boost::thread(boost::bind(accumulator));
}
#pragma endregion

#pragma region testboosthttpSync

void testtt()
{
    auto const host = "www.baidu.com";
    auto const port = "80";
    auto const target = "/loading.html";
    int version = 11;
}

void testboosthttpSync()
{
    using tcp = boost::asio::ip::tcp;    // from <boost/asio/ip/tcp.hpp>
    namespace http = boost::beast::http; // from <boost/beast/http.hpp>
    namespace net = boost::asio;         // from <boost/asio.hpp>
    namespace ssl = net::ssl;            // from <boost/asio/ssl.hpp>
    namespace beast = boost::beast;      // from <boost/beast.hpp>
    try
    {
        auto const host = "www.baidu.com"; //要访问的主机名
        auto const port = "443";           //http服务端口
        auto const target = "/";           //要获取的文档
        // auto const url = "https://www.baidu.com";
        int version = 11;

        // The io_context is required for all I/O
        boost::asio::io_context ioc;

        // These objects perform our I/O
        tcp::resolver resolver{ioc};
        tcp::socket socket{ioc};
        // The SSL context is required, and holds certificates

        // The SSL context is required, and holds certificates
        ssl::context ctx(ssl::context::tlsv12_client);

        // This holds the root certificate used for verification
        load_root_certificates(ctx);

        // Verify the remote server's certificate
        ctx.set_verify_mode(ssl::verify_none);
        beast::ssl_stream<beast::tcp_stream> stream(ioc, ctx);

        // Set SNI Hostname (many hosts need this to handshake successfully)
        if (!SSL_set_tlsext_host_name(stream.native_handle(), host))
        {
            beast::error_code ec{static_cast<int>(::ERR_get_error()), net::error::get_ssl_category()};
            throw beast::system_error{ec};
        }

        // Look up the domain name

        auto const results = resolver.resolve(host, port);

        // Make the connection on the IP address we get from a lookup
        // boost::asio::connect(socket, results.begin(), results.end());
        // Make the connection on the IP address we get from a lookup
        beast::get_lowest_layer(stream).connect(results);

        // Perform the SSL handshake
        stream.handshake(ssl::stream_base::client);
        // Set up an HTTP GET request message
        http::request<http::string_body> req{http::verb::get, target, version};
        req.set(http::field::host, host);
        req.set(http::field::user_agent, BOOST_BEAST_VERSION_STRING);

        // Send the HTTP request to the remote host
        http::write(stream, req);

        // This buffer is used for reading and must be persisted
        boost::beast::flat_buffer buffer;

        // Declare a container to hold the response
        http::response<http::dynamic_body> res;
        // Gracefully close the socket
        boost::system::error_code ec;
        read_and_print_body<false>(std::cout, stream, buffer, ec);
        // Receive the HTTP response
        // http::read(stream, buffer, res);

        // Write the message to standard out
        // std::cout << res.body().size() << std::endl;
        std::cerr << " shutdown 0: " << std::endl;
        socket.close(ec);
        // socket.shutdown(boost::asio::socket_base::shutdown_type::shutdown_both, ec);
        // socket.lowest_layer().cancel(ec);
        if (ec == net::error::eof)
        {
            // Rationale:
            // http://stackoverflow.com/questions/25587403/boost-asio-ssl-async-shutdown-always-finishes-with-an-error
            ec = {};
        }
        std::cerr << " shutdown 1: " << ec << std::endl;
        // not_connected happens sometimes
        // so don't bother reporting it.
        //
        if (ec && ec != boost::system::errc::not_connected) throw boost::system::system_error{ec};

        // If we get here then the connection is closed gracefully
    }
    catch (std::exception const& e)
    {
        std::cerr << " Error: " << e.what() << std::endl;
    }
    std::cerr << "\n std::this_thread::get_id() : " << std::this_thread::get_id() << std::endl;
    return; //EXIT_FAILURE;
}
#pragma endregion

#pragma region HVHTTP
int functionn()
{
    static int i, state = 0;
    switch (state)
    {
    case 0: /* start of function */
        for (i = 0; i < 10; i++)
        {
            printf("%d\t", i);
            state = 1; /* so we will come back to "case 1" */
            return i;
        case 1: printf("1%d\t", i); ; /* resume control straight after the return */
        }
    }
    return -1;
}

void test_http_async_client(int& finished)
{
    printf("test_http_async_client request thread tid=%ld\n", hv_gettid());
    HttpRequestPtr req(new HttpRequest);
    req->method = HTTP_POST;

    req->url = "https://skynet-dev.starnetiot.net/api/skynet-iot/login";
    req->headers["Connection"] = "keep-alive";
    req->body = "this is an async request.";
    req->timeout = 10;
    http_client_send_async(req, [&finished](const HttpResponsePtr& resp) {
        printf("test_http_async_client response thread tid=%ld\n", hv_gettid());
        if (resp == NULL) { printf("request failed!\n"); }
        else
        {
            printf("%d %s\r\n", resp->status_code, resp->status_message());
            printf("%s\n", resp->body.c_str());
        }
        finished = 111;
    });
}

void testhvhttp()
{
    functionn();
    int finished = 0;
    test_http_async_client(finished);

    // demo wait async ResponseCallback
    while (!finished) { hv_delay(100); }
    printf("finished! %d\n", finished);
}

void testhvhttpSync()
{
    auto resp = requests::get("http://163.com");
    if (resp == NULL) { printf("request failed!\n"); }
    else
    {
        printf("%d %s\r\n", resp->status_code, resp->status_message());
        printf("%s\n", resp->body.c_str());
    }

    resp = requests::post("https://skynet-dev.starnetiot.net/api/skynet-iot/login", "hello,world!");
    if (resp == NULL) { printf("request failed!\n"); }
    else
    {
        printf("%d %s\r\n", resp->status_code, resp->status_message());
        printf("%s\n", resp->body.c_str());
    }
}
#pragma endregion

#pragma region json
enum class TestEnum : int
{
    Left = 0,
    Right
};

struct SubTestStruct
{
    int test = 0;
};

struct TestStruct
{
    int test = 0;
    bool testBool = false;
    TestEnum testEnum = TestEnum::Left;
    std::optional<bool> testOpt;
    std::vector<int> testVec;
    SubTestStruct subTestStruct;
};
// nl 不直接支持 optional， 使用 adl_serializer 可以支持任意类型的序列化
// https://github.com/nlohmann/json/pull/2117
// https://github.com/nlohmann/json#how-do-i-convert-third-party-types
namespace nlohmann {
template<typename T>
struct adl_serializer<std::optional<T>>
{
    static void to_json(json& j, const std::optional<T>& opt)
    {
        if (opt == std::nullopt) { j = nullptr; }
        else
        {
            j = *opt; // this will call adl_serializer<T>::to_json which will
                      // find the free function to_json in T's namespace!
        }
    }

    static void from_json(const json& j, std::optional<T>& opt)
    {
        if (j.is_null()) { opt = std::nullopt; }
        else
        {
            opt = j.get<T>(); // same as above, but with
                              // adl_serializer<T>::from_json
        }
    }
};
} // namespace nlohmann

NLOHMANN_DEFINE_TYPE_NON_INTRUSIVE(SubTestStruct, test)
NLOHMANN_DEFINE_TYPE_NON_INTRUSIVE(TestStruct, test, testBool, testEnum, testOpt, testVec, subTestStruct)
// 序列化enum
NLOHMANN_JSON_SERIALIZE_ENUM(
    TestEnum, {
                  {TestEnum::Left, "Left"},
                  {TestEnum::Right, "Right"},
              })
void testjsoncls()
{
    json j;
    TestStruct s;
    s.test = 100;
    s.testBool = true;
    s.testOpt = true;
    for (int i = 0; i < 10; ++i) { s.testVec.push_back(i); }
    s.subTestStruct.test = 99;

    std::cout << "TestStruct test: " << s.test << ", testBool: " << s.testBool << ", testEnum: " << (int)s.testEnum
              << ", testOpt: " << (s.testOpt.has_value() && s.testOpt.value()) << ", testVec: { ";
    for (auto val : s.testVec) { std::cout << val << ","; }
    std::cout << "\b"
              << " }";
    std::cout << ", subTestStruct.test: " << s.subTestStruct.test;
    std::cout << std::endl;

    nlohmann::to_json(j, s);
    std::cout << "dump:" << j.dump() << std::endl;
}
void testjson()
{
    json j2
        = {{"pi", 3.141},
           {"happy", true},

           {"name", "Niels"},
           {"nothing", nullptr},
           {"answer", {{"everything", 42}}},
           {"list", {1, 0, 2}},
           {"object", {{"currency", "USD"}, {"value", 42.99}}}};

    cout << j2.size() << j2["answer"]["everything"] << j2["object"]["value"] << endl;
    string str2 = R"(D:\workdataDJ\code\vas_pgg_proj)";

    std::cout << j2.dump() << std::endl;

    auto j3 = json::parse(R"({" happy ": true, " pi ": 3.141})");
}
#pragma endregion

void testStd()
{
    std::stringstream ss;
    ss << std::uppercase << std::hex << std::setfill('0');
    std::string data = "1111111111";
    int len = data.size();
    for (int i = 0; i < len; i++) { ss << std::setw(2) << static_cast<unsigned>(data[i]); }
    fmt::print("{0}", ss.get());
    std::cout << std::hex << 42 << std::endl;
}
void testFmt()
{
    fmt::print("fm1t!!!");
    std::string s = fmt::format("I'd rather be {1} than {0}.", "right", "happy");

    fmt::print("{0}\n", s);
}
void testHMAC()
{
    //key value
    const char key[] = "745s295z8lv458ll46w2467ta460562n";
    //data in hex, /or you can init with text
    unsigned char data[]
        = {0x00, 0x01, 0x00, 0x48, 0x21, 0x12, 0xa4, 0x42, 0x78, 0x2b, 0x66, 0x6b, 0x32, 0x34, 0x30, 0x6b, 0x4e,
           0x51, 0x6a, 0x56, 0x00, 0x06, 0x00, 0x0d, 0x36, 0x37, 0x76, 0x32, 0x37, 0x30, 0x37, 0x35, 0x3a, 0x31,
           0x33, 0x42, 0x5a, 0x00, 0x00, 0x00, 0xc0, 0x57, 0x00, 0x04, 0x00, 0x02, 0x00, 0x00, 0x80, 0x2a, 0x00,
           0x08, 0x70, 0xfb, 0xe5, 0x05, 0x91, 0xbf, 0x83, 0x3c, 0x00, 0x24, 0x00, 0x04, 0x6e, 0x7e, 0x1e, 0xff};

    unsigned char result[20] = {0};
    unsigned int resultlen = 20;

    string strtest = "abcdabcd";
    const unsigned char* sss
        = (unsigned char*)strtest.data(); // reinterpret_cast<unsigned char*>(const_cast<char*>(strtest.c_str()));

    //可参照 https://github.com/qiniu/c-sdk/ 判断ssl版本
    unsigned char* ss = HMAC(EVP_sha1(), key, strlen(key), sss, sizeof(sss), result, &resultlen);
    fmt::print("HMAC\n\n");
    for (int i = 0; i < resultlen; i++) printf("%02x", result[i]);
    // ss = HMAC(EVP_sha1(), key, strlen(key), sss, sizeof(sss) / 2, result, &resultlen);
    {
        //改用libressl
        //复制FindLibreSSL.cmake到 ....\cmake\share\cmake-3.22\Modules\FindLibreSSL.cmake
        //https://github.com/openssl/openssl/issues/1093
        /* Under Win32 these are defined in wincrypt.h */
        /* 修改 x509.h
		#ifdef OPENSSL_SYS_WIN32

		#include <windows.h>
		#undef X509_NAME
		#undef X509_EXTENSIONS
		#endif
				*/
#if libressl
        HMAC_CTX* ctx = HMAC_CTX_new();
        EVP_MAC_init HMAC_Init(ctx, key, strlen(key), EVP_sha1());
        HMAC_Update(ctx, sss, sizeof(sss) / 2);
        HMAC_Update(ctx, sss, sizeof(sss) / 2);
        HMAC_Final(ctx, result, &resultlen);
        fmt::print("\n\nHMAC_Final\n\n");
        for (int i = 0; i < resultlen; i++) printf("%02x", result[i]);
        HMAC_CTX_free(ctx);
#endif
    }

    // std::cout << OPENSSL_VERSION_NUMBER << " ret " << OPENSSL_API_LEVEL << std::endl;
    // for (int i = 0; i < strlen((char*)ss); i++)
    //     printf("%02x", ss[i]);
    fmt::print("\n\n");
    // for (int i = 0; i < resultlen; i++)
    //     printf("%02x", result[i]);
}