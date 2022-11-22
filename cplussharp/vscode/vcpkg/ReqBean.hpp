#ifndef REQBEAN_HEADER_INCLUDED
#define REQBEAN_HEADER_INCLUDED

#include <string>
#include <vector>
#include <algorithm>
#include <fstream>
#include "json/json.h" //json-cpp, tested with version 0.5
namespace iot {


class Settings
{
public:
    void  SetDefault(void){};

    int Read(std::string sFileName)
    {
        Json::Value root; // will contains the root value after parsing.
        Json::Reader reader;

        SetDefault();

        try
        {
            std::ifstream ifs(sFileName.c_str());
            std::string strConfig((std::istreambuf_iterator<char>(ifs)), std::istreambuf_iterator<char>());
            ifs.close();
            bool parsingSuccessful = reader.parse(strConfig, root);
            if (!parsingSuccessful)
            {
                return 2;
            }
        }
        catch (...)
        {
            return 1;
        }
        if (root.type() != Json::objectValue)
        {
            return 1;
        }

        version = root.get("version", "XXXXXX").asString();
        if (root["data"].type() != Json::arrayValue)
        {
            return 1;
        }
        data.resize(root["data"].size());
        for (unsigned int i = 0; i < root["data"].size(); i++)
        {
            data[i].AAA = root["data"][i].get("AAA", "123").asString();
            data[i].BBB = root["data"][i].get("BBB", "1").asString();
        }

        return 0;
    };

    int  Write(std::string sFileName)
    {
        Json::Value root;
        Json::StyledWriter writer;

        root["version"] = version;
        for (unsigned int i = 0; i < data.size(); i++)
        {
            root["data"][i]["AAA"] = data[i].AAA;
            root["data"][i]["BBB"] = data[i].BBB;
        }

        std::string outputConfig = writer.write(root);

        try
        {
            std::ofstream ofs(sFileName.c_str());
            ofs << outputConfig;
            ofs.close();
        }
        catch (...)
        {
            return 1;
        }

        return 0;
    };
   
    std::string version;
    struct Data
    {
        std::string AAA;
        std::string BBB;
        Data(void) : AAA("123"), BBB("1")
        {
        }
    };
    std::vector<Data> data;
    Settings(void) : version("XXXXXX")
    {
        data.push_back(Data());
    }
};

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
