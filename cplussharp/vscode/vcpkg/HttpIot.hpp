#ifndef HTTPIOT_HPP
#define HTTPIOT_HPP
#include <hv/requests.h>
namespace iot {
class Httpiot
{
public:
    void postLogin()
    {
        auto resp = requests::post("127.0.0.1:8080/echo", "hello,world!");
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
};
} // namespace iot
#endif