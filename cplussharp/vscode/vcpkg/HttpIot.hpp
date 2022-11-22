#ifndef HTTPIOT_HPP
#define HTTPIOT_HPP
#include <hv/requests.h>
#include <hv/axios.h>
#include <hv/http_client.h>
#include "Log.hpp"
namespace iot {
class Httpiot
{
public:
    ReqBean req;
    void initTestreq()
    {
        req.ip = "1.1.1.1";
        req.type = "aaa";
        req.port = 1234;
        req.auth = "Og==";
        req.mac = "aa:ff:gg:ee::kk";
        req.hardware_version = "1.1";
        req.marks = "box";
        req.model = "111";
        req.name = "aaa";
    }
    void postLogin()
    {
        //initTestreq();
        std::string datas = req.tojson();
        std::string logg = std::format("req:{}\n", datas);
        LOGD(logg);
        HttpRequest* req = new HttpRequest();
        req->method = HTTP_POST;
        req->url = "https://192.168.65.144:3001";
        req->headers["Connection"] = "keep-alive";

        req->headers["Authorization"] = "1655429553:8nuZoH5zbXr6EhSMn4l2nQmz8zE=";

        req->headers["Content-Type"] = "application/json";
        //req->headers["Content-Length"] = datas.length();
        req->headers["Cache-Control"] = "no-cache";
        req->body = datas;
        hv::HttpClient sync_client;
        //auto resp = requests::post("https://192.168.65.144:3001", datas, headers);
        HttpResponse resp;
        int ret = sync_client.send(req, &resp);
        if (ret != 0)
        {
            printf("request failed!\n");
        }
        else
        {
            printf("%d %s\r\n", resp.status_code, resp.status_message());
            printf("%s\n", resp.body.c_str());
        }
    }
};
} // namespace iot
#endif