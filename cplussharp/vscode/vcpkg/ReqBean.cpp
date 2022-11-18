#include "ReqBean.hpp"
#include <algorithm>
#include <fstream>
#include "json/json.h" //json-cpp, tested with version 0.5
//#include "nlohmann/json.hpp"
using namespace iot;

void ReqBean::SetDefault(void)
{
}

int ReqBean::Read(std::string sFileName)
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

    auth = root.get("auth", "Og==").asString();
    bid = root.get("bid", "aaa").asString();
    if (root["data"].type() != Json::arrayValue)
    {
        return 1;
    }
    data.resize(root["data"].size());
    for (unsigned int i = 0; i < root["data"].size(); i++)
    {
        data[i].packageName = root["data"][i].get("packageName", "com.naodianzi.jie.mnzcyx").asString();
        data[i].version = root["data"][i].get("version", "1.2.5").asString();
    }
    disk = root.get("disk", "12408848384/2221903872").asString();
    hardware_version = root.get("hardware_version", "5.8.3").asString();
    ip = root.get("ip", "eth0:192.168.65.225").asString();
    mac = root.get("mac", "eth0:be:fc:42:6e:1f:94").asString();
    marks = root.get("marks", "box").asString();
    memory = root.get("memory", "2094247936/571047936").asString();
    model = root.get("model", "111").asString();
    name = root.get("name", "222").asString();
    network = root.get("network", "").asString();
    password = root.get("password", "").asString();
    port = root.get("port", 8384).asInt();
    protocol_version = root.get("protocol_version", "3.0").asString();
    sn = root.get("sn", "333").asString();
    if (root["status"].type() != Json::arrayValue)
    {
        return 1;
    }
    for (unsigned int i = 0; i < root["status"].size(); i++)
    {
        if (root["status"][i].type() != Json::stringValue)
        {
            return 1;
        }
        status.push_back(root["status"][i].asString().c_str());
    }
    if (root["results"].type() != Json::arrayValue)
    {
        return 1;
    }
    for (unsigned int i = 0; i < root["results"].size(); i++)
    {
        if (root["results"][i].type() != Json::stringValue)
        {
            return 1;
        }
        results.push_back(root["results"][i].asString().c_str());
    }
    type = root.get("type", "android").asString();
    username = root.get("username", "").asString();

    return 0;
}

int ReqBean::fromjson(std::string strjson)
{
    Json::Value root; // will contains the root value after parsing.
    Json::Reader reader;

    SetDefault();

    try
    {
        bool parsingSuccessful = reader.parse(strjson, root);
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

    auth = root.get("auth", "").asString();
    bid = root.get("bid", "").asString();
    if (root["data"].type() != Json::arrayValue)
    {
        return 1;
    }
    data.resize(root["data"].size());
    for (unsigned int i = 0; i < root["data"].size(); i++)
    {
        data[i].packageName = root["data"][i].get("packageName", "").asString();
        data[i].version = root["data"][i].get("version", "").asString();
    }
    disk = root.get("disk", "").asString();
    hardware_version = root.get("hardware_version", "").asString();
    ip = root.get("ip", "").asString();
    mac = root.get("mac", "").asString();
    marks = root.get("marks", "").asString();
    memory = root.get("memory", "").asString();
    model = root.get("model", "").asString();
    name = root.get("name", "").asString();
    network = root.get("network", "").asString();
    password = root.get("password", "").asString();
    port = root.get("port", 0).asInt();
    protocol_version = root.get("protocol_version", "").asString();
    sn = root.get("sn", "").asString();
    if (root["status"].type() != Json::arrayValue)
    {
        return 1;
    }
    for (unsigned int i = 0; i < root["status"].size(); i++)
    {
        if (root["status"][i].type() != Json::stringValue)
        {
            return 1;
        }
        status.push_back(root["status"][i].asString().c_str());
    }
    if (root["results"].type() != Json::arrayValue)
    {
        return 1;
    }
    for (unsigned int i = 0; i < root["results"].size(); i++)
    {
        if (root["results"][i].type() != Json::stringValue)
        {
            return 1;
        }
        results.push_back(root["results"][i].asString().c_str());
    }
    type = root.get("type", "").asString();
    username = root.get("username", "").asString();

    return 0;
};
std::string ReqBean::tojson()
{
    Json::Value root;
    Json::StyledWriter writer;

    root["auth"] = auth;
    root["bid"] = bid;
    for (unsigned int i = 0; i < root["data"].size(); i++)
    {
        root["data"][i]["packageName"] = data[i].packageName;
        root["data"][i]["version"] = data[i].version;
    }
    root["disk"] = disk;
    root["hardware_version"] = hardware_version;
    root["ip"] = ip;
    root["mac"] = mac;
    root["marks"] = marks;
    root["memory"] = memory;
    root["model"] = model;
    root["name"] = name;
    root["network"] = network;
    root["password"] = password;
    root["port"] = port;
    root["protocol_version"] = protocol_version;
    root["sn"] = sn;
    for (unsigned int i = 0; i < status.size(); i++) { root["status"][i] = status[i]; }
    for (unsigned int i = 0; i < results.size(); i++) { root["results"][i] = results[i]; }
    root["type"] = type;
    root["username"] = username;

    std::string outputConfig = writer.write(root);

    return outputConfig;
};
int ReqBean::Write(std::string sFileName)
{
    Json::Value root;
    Json::StyledWriter writer;

    root["auth"] = auth;
    root["bid"] = bid;
    for (unsigned int i = 0; i < root["data"].size(); i++)
    {
        root["data"][i]["packageName"] = data[i].packageName;
        root["data"][i]["version"] = data[i].version;
    }
    root["disk"] = disk;
    root["hardware_version"] = hardware_version;
    root["ip"] = ip;
    root["mac"] = mac;
    root["marks"] = marks;
    root["memory"] = memory;
    root["model"] = model;
    root["name"] = name;
    root["network"] = network;
    root["password"] = password;
    root["port"] = port;
    root["protocol_version"] = protocol_version;
    root["sn"] = sn;
    for (unsigned int i = 0; i < status.size(); i++) { root["status"][i] = status[i]; }
    for (unsigned int i = 0; i < results.size(); i++) { root["results"][i] = results[i]; }
    root["type"] = type;
    root["username"] = username;

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
}
