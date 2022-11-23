#ifndef HTTPIOT_HPP
#define HTTPIOT_HPP
#include <hv/requests.h>
#include <hv/axios.h>
#include <hv/http_client.h>
#include "Log.hpp"
using namespace hv;
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

    typedef std::function<void(size_t received_bytes, size_t total_bytes)> wget_progress_cb;

    static int wget(const char* url, const char* filepath, wget_progress_cb progress_cb = NULL, bool use_range = true)
    {
        int ret = 0;
        HttpClient cli;
        HttpRequest req;
        HttpResponse resp;

        // HEAD
        req.method = HTTP_HEAD;
        req.url = url;
        ret = cli.send(&req, &resp);
        if (ret != 0)
        {
            fprintf(stderr, "request error: %d\n", ret);
            return ret;
        }
        printd("%s", resp.Dump(true, false).c_str());
        if (resp.status_code == HTTP_STATUS_NOT_FOUND)
        {
            fprintf(stderr, "404 Not Found\n");
            return 404;
        }

        // use Range?
        int range_bytes = 1 << 20; // 1M
        long from = 0, to = 0;
        size_t content_length = hv::from_string<size_t>(resp.GetHeader("Content-Length"));
        if (use_range)
        {
            use_range = false;
            std::string accept_ranges = resp.GetHeader("Accept-Ranges");
            // use Range if server accept_ranges and content_length > 1M
            if (resp.status_code == 200 && accept_ranges == "bytes" && content_length > range_bytes)
            {
                use_range = true;
            }
        }

        // open file
        std::string filepath_download(filepath);
        filepath_download += ".download";
        HFile file;
        if (use_range)
        {
            ret = file.open(filepath_download.c_str(), "ab");
            from = file.size();
        }
        else
        {
            ret = file.open(filepath_download.c_str(), "wb");
        }
        if (ret != 0)
        {
            fprintf(stderr, "Failed to open file %s\n", filepath_download.c_str());
            return ret;
        }
        printf("Save file to %s ...\n", filepath);

        // GET
        req.method = HTTP_GET;
        req.timeout = 3600; // 1h
        if (!use_range)
        {
            size_t received_bytes = 0;
            req.http_cb = [&file, &content_length, &received_bytes,
                           &progress_cb](HttpMessage* resp, http_parser_state state, const char* data, size_t size) {
                if (state == HP_HEADERS_COMPLETE)
                {
                    content_length = hv::from_string<size_t>(resp->GetHeader("Content-Length"));
                    printd("%s", resp->Dump(true, false).c_str());
                }
                else if (state == HP_BODY)
                {
                    if (data && size)
                    {
                        file.write(data, size);
                        received_bytes += size;

                        if (progress_cb)
                        {
                            progress_cb(received_bytes, content_length);
                        }
                    }
                }
            };
            ret = cli.send(&req, &resp);
            if (ret != 0)
            {
                fprintf(stderr, "request error: %d\n", ret);
                goto error;
            }
            goto success;
        }

        // Range: bytes=from-to
        while (from < content_length)
        {
            to = from + range_bytes - 1;
            if (to >= content_length)
                to = content_length - 1;
            req.SetRange(from, to);
            printd("%s", req.Dump(true, false).c_str());
            ret = cli.send(&req, &resp);
            if (ret != 0)
            {
                fprintf(stderr, "request error: %d\n", ret);
                goto error;
            }
            printd("%s", resp.Dump(true, false).c_str());
            file.write(resp.body.data(), resp.body.size());
            from = to + 1;

            if (progress_cb)
            {
                progress_cb(from, content_length);
            }
        }

success:
        file.close();
        //ret = file.rename(filepath);
        if (ret != 0)
        {
            fprintf(stderr, "mv %s => %s failed: %s:%d\n", filepath_download.c_str(), filepath, strerror(ret), ret);
        }
        return ret;
error:
        file.close();
        // file.remove();
        return ret;
    }
};
} // namespace iot
#endif