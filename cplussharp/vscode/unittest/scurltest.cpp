/***************************************************************************
 *                                  _   _ ____  _
 *  Project                     ___| | | |  _ \| |
 *                             / __| | | | |_) | |
 *                            | (__| |_| |  _ <| |___
 *                             \___|\___/|_| \_\_____|
 *
 * Copyright (C) 1998 - 2020, Daniel Stenberg, <daniel@haxx.se>, et al.
 *
 * This software is licensed as described in the file COPYING, which
 * you should have received as part of this distribution. The terms
 * are also available at https://curl.se/docs/copyright.html.
 *
 * You may opt to use, copy, modify, merge, publish, distribute and/or sell
 * copies of the Software, and permit persons to whom the Software is
 * furnished to do so, under the terms of the COPYING file.
 *
 * This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
 * KIND, either express or implied.
 *
 ***************************************************************************/
#include <stdio.h>

#include <curl/curl.h>
#include <iostream>
#include <math.h>
#include <thread>
using namespace std;
/* <DESC>
 * Get a single file from an FTP server.
 * </DESC>
 */

struct FtpFile
{
    const char* filename;
    FILE* stream;
};

static size_t my_fwrite(void* buffer, size_t size, size_t nmemb, void* stream)
{
    struct FtpFile* out = (struct FtpFile*)stream;
    if (!out->stream)
    {
        /* open file for writing */
        out->stream = fopen(out->filename, "wb");
        if (!out->stream)
            return -1; /* failure, can't open file to write */
    }
    return fwrite(buffer, size, nmemb, out->stream);
}
#if LIBCURL_VERSION_NUM >= 0x073d00
/* In libcurl 7.61.0, support was added for extracting the time in plain
   microseconds. Older libcurl versions are stuck in using 'double' for this
   information so we complicate this example a bit by supporting either
   approach. */
#define TIME_IN_US                              1
#define TIMETYPE                                curl_off_t
#define TIMEOPT                                 CURLINFO_TOTAL_TIME_T
#define MINIMAL_PROGRESS_FUNCTIONALITY_INTERVAL 3000000
#else
#define TIMETYPE                                double
#define TIMEOPT                                 CURLINFO_TOTAL_TIME
#define MINIMAL_PROGRESS_FUNCTIONALITY_INTERVAL 1
#endif

#define STOP_DOWNLOAD_AFTER_THIS_MANY_BYTES 6000

struct myprogress
{
    double lastruntime;
    CURL* curl;
};
bool ftp=true;
int progress_func(void* p,
                  curl_off_t dltotal, curl_off_t dlnow,
                  curl_off_t ultotal, curl_off_t ulnow)
{
    struct myprogress* myp = (struct myprogress*)p;
    CURL* curl = myp->curl;
    curl_off_t curtime = 0;

    if ((curtime - myp->lastruntime) >= MINIMAL_PROGRESS_FUNCTIONALITY_INTERVAL)
    {
        myp->lastruntime = curtime;
#ifdef TIME_IN_US
        fprintf(stderr, "TOTAL TIME: %" CURL_FORMAT_CURL_OFF_T ".%06ld\r\n",
                (curtime / 1000000), (long)(curtime % 1000000));
#else
        fprintf(stderr, "TOTAL TIME: .%06ld\r\n", curtime);
#endif
    }
    // fprintf(stderr, "TOTAL TIME: %" CURL_FORMAT_CURL_OFF_T ".%06ld\r\n",
    //         (curtime / 1000000), (long)(curtime % 1000000));
    fprintf(stderr, "TOTAsssL TIME: %f\r\n", myp->lastruntime);
    fprintf(stderr, "UP: %" CURL_FORMAT_CURL_OFF_T " of %" CURL_FORMAT_CURL_OFF_T "  DOWN: %" CURL_FORMAT_CURL_OFF_T " of %" CURL_FORMAT_CURL_OFF_T "\n",
            ulnow, ultotal, dlnow, dltotal);
    if (ftp==false)
        return 1;
    return 0;
}

void curl_ftp_down()
{
    CURL* curl;
    CURLcode res;
    struct FtpFile ftpfile = {
        "curl.tar.gz", /* name to store the file as if successful */
        NULL};

    curl_global_init(CURL_GLOBAL_DEFAULT);

    curl = curl_easy_init();
    if (curl)
    {
        struct myprogress prog;
        prog.lastruntime = 0;
        prog.curl = curl;
        /*
     * You better replace the URL with one that works!
     */
        curl_easy_setopt(curl, CURLOPT_URL,
                         "ftp://192.168.65.142/gghc.mp4");
        /* Define our callback to get called when there's data to be written */
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, my_fwrite);
        /* Set a pointer to our struct to pass to the callback */
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &ftpfile);

        /* Switch on full protocol/debug output */
        curl_easy_setopt(curl, CURLOPT_VERBOSE, 1L);
        curl_easy_setopt(curl, CURLOPT_USERPWD, "a:a");

        curl_easy_setopt(curl, CURLOPT_NOPROGRESS, false);               //设为false 下面才能设置进度响应函数
        curl_easy_setopt(curl, CURLOPT_XFERINFOFUNCTION, progress_func); //进度响应函数
        curl_easy_setopt(curl, CURLOPT_XFERINFODATA, &prog);
        //  *CURLOPT_LOW_SPEED_LIMIT:设置一个长整形数，控制传送多少字节。
        //     *CURLOPT_LOW_SPEED_TIME:设置一个长整形数，控制多少秒传送CURLOPT_LOW_SPEED_LIMIT规定的字节数。
        curl_easy_setopt(curl, CURLOPT_LOW_SPEED_TIME, 1);
        curl_easy_setopt(curl, CURLOPT_LOW_SPEED_LIMIT, 500);

        //这里限速 100KB/s
        curl_easy_setopt(curl, CURLOPT_MAX_RECV_SPEED_LARGE, (curl_off_t)20 * 1024);

        res = curl_easy_perform(curl);

        /* always cleanup */
        curl_easy_cleanup(curl);

        if (CURLE_OK != res)
        {
            /* we failed */
            fprintf(stderr, "curl told us %d\n", res);
        }
    }

    if (ftpfile.stream)
        fclose(ftpfile.stream); /* close the local file */

    curl_global_cleanup();
}
void fun(int& a)
{
    a = 1;
}

void fun2(int* a)
{
    *a = 1;
}

int main(void)
{
    int a = 0;
    int* b = &a;
    std::thread t(fun2, b);
    t.join();
    cout << a << endl;

    thread curl(curl_ftp_down);
    std::this_thread::sleep_for(std::chrono::milliseconds(5000));
    cout<<"end 1"<<endl;
    ftp=false;
    curl.join();
    cout<<"end 2"<<endl;
    return 0;
}
