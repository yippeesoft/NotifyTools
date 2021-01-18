#include <iostream>
#include "httplib.h"
#include <iostream>
#include <string>
using namespace std;
void helloword(const httplib::Request& req, httplib::Response& rsp)
{
    printf("httplib server recv a req: %s %s\n ", req.path.c_str(), req.remote_addr.c_str());
    // std::string str = R "( <html  lang= ><h1> 武汉, 加油！</h1></html>)";
    // std::string s1 = R "a(C:\Users\Administrator\Desktop\RWtest\write.txt)a";
    std::string s= R"foo(
C:\Users\Administrator\Desktop\RWtes
    )foo";
    const char* s1 = R"foo(
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
</head>
<h1> 武汉, 加油！</h1></html>
)foo";
    rsp.set_content(s, "text/html"); //最后一个参数是正文类型
    rsp.status = 200;
}
int main(int argc, char** argv)
{
    httplib::Server srv;
    srv.Get("/", helloword);
    srv.listen("0.0.0.0", 9000);

    getchar();
    return 0;
}