#ifndef REQBEAN_HEADER_INCLUDED
#define REQBEAN_HEADER_INCLUDED

#include <string>
#include <vector>
namespace iot {
class ReqBean
{
public:
    int Read(std::string sFileName);
    int Write(std::string sFileName);

    int fromjson(std::string strjson);
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
        : auth(""),
          bid(""),
          disk(""),
          hardware_version(""),
          ip(""),
          mac(""),
          marks(""),
          memory(""),
          model(""),
          name(""),
          network(""),
          password(""),
          port(),
          protocol_version(""),
          sn(""),
          type(""),
          username("")
    {
    }
};
} // namespace iot
#endif
