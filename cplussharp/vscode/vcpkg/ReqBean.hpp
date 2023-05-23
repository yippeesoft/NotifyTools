#ifndef REQBEAN_HEADER_INCLUDED
#define REQBEAN_HEADER_INCLUDED

#include <string>
#include <vector>
#include <algorithm>
#include <fstream>
#include "json/json.h" //json-cpp, tested with version 0.5
namespace iot {

class ReqBean
{
public:
    int Read(std::string sFileName);
    int Write(std::string sFileName);

    int fromjson(std::string json);
    std::string tojson();
    void SetDefault(void);
    std::string auth;
    std::string bid;
    struct Data
    {
        std::string packageName;
        std::string version;
        Data(void) : packageName("com.naodianzi.jie.mnzcyx"), version("1.2.5")
        {
        }
    };
    std::vector<Data> data;
    std::string disk;
    std::string hardware_version;
    std::string ip;
    std::string mac;
    std::string marks;
    std::string memory;
    std::string model;
    std::string name;
    std::string network;
    std::string password;
    int port;
    std::string protocol_version;
    std::string sn;
    std::vector<std::string> status;
    std::vector<std::string> results;
    std::string type;
    std::string username;
    ReqBean(void)
        : auth("Og=="),
          bid("aaa"),
          disk("12408848384/2221903872"),
          hardware_version("5.8.3"),
          ip("eth0:192.168.65.225"),
          mac("eth0:be:fc:42:6e:1f:94"),
          marks("box"),
          memory("2094247936/571047936"),
          model("111"),
          name("222"),
          network(""),
          password(""),
          port(8384),
          protocol_version("3.0"),
          sn("333"),
          type("android"),
          username("")
    {
        data.push_back(Data());
    }
};
} // namespace iot
#endif
