
#include <fmt/core.h>
#include <ios>
#include <nlohmann/json_fwd.hpp>
#include <stdio.h>
#include <string.h>
#include <string>
#include <iostream>
#include <fmt/format.h>

#include <iostream>
#include <iostream>
#include <string>
#include <string>
#include <sstream>
#include <iomanip>
#include "nlohmann/json.hpp"
#include <optional>
#include "hv/requests.h"
#include "hv/hthread.h" // import hv_gettid

#include <boost/beast/ssl.hpp>
#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast.hpp>
#include <boost/beast/version.hpp>
#include <boost/asio/connect.hpp>
#include <boost/asio/ip/tcp.hpp>

#include <boost/asio/ssl/error.hpp>
#include <boost/asio/ssl/stream.hpp>
#include <cstdlib>
#include <iostream>
#include <string>
#include "root_certificates.hpp"

#include <openssl/ssl.h>
#include <openssl/hmac.h>

using namespace nlohmann;
using namespace std;
void testFmt();
void testHMAC();
void testStd();
void testjson();
void testjsoncls();
void testhvhttp();
void testboosthttp();
int main()
{
    testHMAC();
    // testStd();
    // testjson();
    // testjsoncls();
    // testhvhttp();
    // testboosthttp();
    return 0;
}

#pragma region boosthttp
template<bool isRequest, class SyncReadStream, class DynamicBuffer>
auto read_and_print_body(
    std::ostream& os,
    SyncReadStream& stream,
    DynamicBuffer& buffer,
    boost::beast::error_code& ec)
{
    namespace net = boost::asio;
    namespace beast = boost::beast;
    namespace http = beast::http;
    using net::ip::tcp;
    struct
    {
        size_t hbytes = 0, bbytes = 0;
    } ret;
    http::parser<isRequest, http::buffer_body> p;
    ret.hbytes = http::read_header(stream, buffer, p, ec);

    while (!p.is_done())
    {
        char buf[512];
        p.get().body().data = buf;
        p.get().body().size = sizeof(buf);
        ret.bbytes += http::read_some(stream, buffer, p, ec);
        if (ec)
            return ret;
        os.write(buf, sizeof(buf) - p.get().body().size);
    }
    return ret;
}
//https://www.boost.org/doc/libs/develop/libs/beast/example/http/client/sync/http_client_sync.cpp
//C++ 使用boost实现http客户端——同步、异步、协程
void testboosthttp()
{
    using tcp = boost::asio::ip::tcp;    // from <boost/asio/ip/tcp.hpp>
    namespace http = boost::beast::http; // from <boost/beast/http.hpp>
    namespace net = boost::asio;         // from <boost/asio.hpp>
    namespace ssl = net::ssl;            // from <boost/asio/ssl.hpp>
    namespace beast = boost::beast;      // from <boost/beast.hpp>
    try
    {
        auto const host = "www.163.com"; //要访问的主机名
        auto const port = "443";         //http服务端口
        auto const target = "/";         //要获取的文档
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
        if (ec && ec != boost::system::errc::not_connected)
            throw boost::system::system_error{ec};

        // If we get here then the connection is closed gracefully
    }
    catch (std::exception const& e)
    {
        std::cerr << " Error: " << e.what() << std::endl;
        return; //EXIT_FAILURE;
    }
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
        if (resp == NULL)
        {
            printf("request failed!\n");
        }
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
    while (!finished)
    {
        hv_delay(100);
    }
    printf("finished! %d\n", finished);
}

void testhvhttpSync()
{
    auto resp = requests::get("http://163.com");
    if (resp == NULL)
    {
        printf("request failed!\n");
    }
    else
    {
        printf("%d %s\r\n", resp->status_code, resp->status_message());
        printf("%s\n", resp->body.c_str());
    }

    resp = requests::post("https://skynet-dev.starnetiot.net/api/skynet-iot/login", "hello,world!");
    if (resp == NULL)
    {
        printf("request failed!\n");
    }
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
        if (opt == std::nullopt)
        {
            j = nullptr;
        }
        else
        {
            j = *opt; // this will call adl_serializer<T>::to_json which will
                      // find the free function to_json in T's namespace!
        }
    }

    static void from_json(const json& j, std::optional<T>& opt)
    {
        if (j.is_null())
        {
            opt = std::nullopt;
        }
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
NLOHMANN_JSON_SERIALIZE_ENUM(TestEnum, {
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
    for (int i = 0; i < 10; ++i)
    {
        s.testVec.push_back(i);
    }
    s.subTestStruct.test = 99;

    std::cout << "TestStruct test: " << s.test
              << ", testBool: " << s.testBool
              << ", testEnum: " << (int)s.testEnum
              << ", testOpt: " << (s.testOpt.has_value() && s.testOpt.value())
              << ", testVec: { ";
    for (auto val : s.testVec)
    {
        std::cout << val << ",";
    }
    std::cout << "\b"
              << " }";
    std::cout << ", subTestStruct.test: " << s.subTestStruct.test;
    std::cout << std::endl;

    nlohmann ::to_json(j, s);
    std::cout << "dump:" << j.dump() << std::endl;
}
void testjson()
{
    json j2 = {
        {"pi", 3.141},
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
    for (int i = 0; i < len; i++)
    {
        ss << std::setw(2) << static_cast<unsigned>(data[i]);
    }
    fmt::print(ss.str());
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
    unsigned char data[] = {
        0x00, 0x01, 0x00, 0x48, 0x21, 0x12, 0xa4, 0x42, 0x78, 0x2b, 0x66, 0x6b, 0x32, 0x34, 0x30, 0x6b, 0x4e, 0x51, 0x6a, 0x56, 0x00, 0x06, 0x00, 0x0d, 0x36, 0x37, 0x76, 0x32, 0x37, 0x30, 0x37, 0x35, 0x3a, 0x31, 0x33, 0x42, 0x5a, 0x00, 0x00, 0x00, 0xc0, 0x57, 0x00, 0x04, 0x00, 0x02, 0x00, 0x00, 0x80, 0x2a, 0x00, 0x08, 0x70, 0xfb, 0xe5, 0x05, 0x91, 0xbf, 0x83, 0x3c, 0x00, 0x24, 0x00, 0x04, 0x6e, 0x7e, 0x1e, 0xff};

    unsigned char result[20] = {0};
    unsigned int resultlen = 20;

    string strtest = "abcdabcd";
    const unsigned char* sss = (unsigned char*)strtest.data(); // reinterpret_cast<unsigned char*>(const_cast<char*>(strtest.c_str()));

    //可参照 https://github.com/qiniu/c-sdk/ 判断ssl版本
    unsigned char* ss = HMAC(EVP_sha1(), key, strlen(key), sss, sizeof(sss), result, &resultlen);
    fmt::print("HMAC\n\n");
    for (int i = 0; i < resultlen; i++)
        printf("%02x", result[i]);
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
        HMAC_CTX* ctx = HMAC_CTX_new();
        HMAC_Init(ctx, key, strlen(key), EVP_sha1());
        HMAC_Update(ctx, sss, sizeof(sss) / 2);
        HMAC_Update(ctx, sss, sizeof(sss) / 2);
        HMAC_Final(ctx, result, &resultlen);
        fmt::print("\n\nHMAC_Final\n\n");
        for (int i = 0; i < resultlen; i++)
            printf("%02x", result[i]);
    }

    // std::cout << OPENSSL_VERSION_NUMBER << " ret " << OPENSSL_API_LEVEL << std::endl;
    // for (int i = 0; i < strlen((char*)ss); i++)
    //     printf("%02x", ss[i]);
    fmt::print("\n\n");
    // for (int i = 0; i < resultlen; i++)
    //     printf("%02x", result[i]);
}