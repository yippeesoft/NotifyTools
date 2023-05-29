#ifndef __SYS_WEASEL_
#define __SYS_WEASEL_

#include <string>
#include <windows.h>
#include <winerror.h>
#include <iostream>
#include <format>
#include <shlobj.h>
#include <fstream>
#include <cstdint>
#include <filesystem>
#include "yaml-cpp/yaml.h"

#include "weasel.custom.yaml.h"
#include "luna_pinyin_simp.custom.yaml.h"
namespace fs = std::filesystem;

using namespace std;

namespace weasel_cfg {

class Log
{
public:
    static void d(string s)
    {
        std::cout << s << std::endl;
    }
};

class Syss
{
public:
    static YAML::Node readYaml(string filename, std::vector<std::string> xxpath)
    {
        fs::path path = filename;

        YAML::Node config = YAML::LoadFile(filename);
        YAML::Node nodee = config;
        for (auto str : xxpath)
        {
            nodee = nodee[str];
            if (nodee.IsNull()) return nodee;
        }
        return nodee;
    }

    static bool readYaml(string filename, std::vector<std::string> xxpath, bool def)
    {
        if (!fs::exists(filename)) return def;
        YAML::Node nodee = readYaml(filename, xxpath);
        if (nodee.IsScalar())
        {
            string tt = typeid(def).name();
            if (tt == "bool") return nodee.as<bool>();
        }
        return def;
    }
    static int readYaml(string filename, std::vector<std::string> xxpath, int def)
    {
        if (!fs::exists(filename)) return def;
        YAML::Node nodee = readYaml(filename, xxpath);
        if (nodee.IsScalar())
        {
            string tt = typeid(def).name();
            if (tt == "int") return nodee.as<int>();
        }
        return def;
    }

    //https://stackoverflow.com/questions/49514417/manipulating-nodes-in-yaml-cpp
    //https://stackoverflow.com/users/112/jesse-beder
    template<typename T, typename Iter>
    static void setConfigParam(YAML::Node node, Iter begin, Iter end, T value)
    {
        if (begin == end)
        {
            return;
        }
        const auto& tag = *begin;
        if (std::next(begin) == end)
        {
            node[tag] = value;
            return;
        }
        if (!node[tag])
        {
            node[tag] = YAML::Node(YAML::NodeType::Map);
        }
        setConfigParam(node[tag], std::next(begin), end, value);
    }
    template<typename T>
    static bool saveYaml(string filename, std::vector<std::string> xxpath, T def)
    {
        YAML::Node nodee;
        if (fs::exists(filename))
        {
            nodee = YAML::LoadFile(filename);
        }
        else
        {
            nodee = YAML::Node(YAML::NodeType::Map);
        }
        setConfigParam(nodee, xxpath.begin(), xxpath.end(), def);
        ofstream fout(filename);
        fout << nodee;
        fout.close();
        return true;
    }
    static bool GetCfgPath(string& path)
    {
        HKEY hkey = HKEY_CURRENT_USER;
        string subkey = "SOFTWARE\\Rime\\Weasel";
        string keydir = "RimeUserDir";
        HKEY hKeyResult = NULL;
        long result = ::RegOpenKeyEx(hkey, subkey.c_str(), 0, KEY_QUERY_VALUE, &hKeyResult);
        if (result != ERROR_SUCCESS)
        {
            Log::d(std::format("{}", "RegOpenKeyEx err"));
            return false;
        }
        DWORD dwDataType = 0;
        DWORD dwSize = 0;
        result = ::RegQueryValueEx(hKeyResult, keydir.c_str(), 0, &dwDataType, NULL, &dwSize);
        if (result != ERROR_SUCCESS)
        {
            Log::d(std::format("{}::{}", "RegQueryValueEx err", dwSize));
            return false;
        }
        Log::d(std::format("{} {}", "RegQueryValueEx  ", dwDataType));
        if (dwDataType == REG_SZ)
        {
            //分配内存大小
            char* lpValue = new char[dwSize + 1];
            memset(lpValue, 0, dwSize * sizeof(char));
            //获取注册表中指定的键所对应的值
            if (ERROR_SUCCESS == ::RegQueryValueEx(hKeyResult, keydir.c_str(), 0, &dwDataType, (LPBYTE)lpValue, &dwSize))
            {
                path = (lpValue);
                Log::d(std::format("{}::{}", " RegQueryValueEx  ", path));
                delete[] lpValue;
                if (path.empty())
                {
                    char buff[1024] = {0};
                    bool ret = ::SHGetSpecialFolderPath(0, buff, CSIDL_APPDATA, false);
                    if (ret)
                    {
                        path = buff;
                    }
                }
            }
            else
            {
                Log::d(std::format("{}", "RegQueryValueEx2 err"));
            }
        }
        ::RegCloseKey(hKeyResult);
        if (path.empty()) return false;
        path += "/rime";
        return true;
    }
};

class Test
{
public:
    static void testYaml()
    {
        string p;
        Syss::GetCfgPath(p);
        Log::d(p);

        bool b = false;
        std::vector<std::string> xxpath;

        if (0)
        {
            xxpath.push_back("patch");
            xxpath.push_back("styleaaa/horizontal");
            //b = Syss::saveYaml("./testconfig.yaml", xxpath, 123);

            b = Syss::saveYaml(p + "/weasel.custom.yaml", xxpath, 123);
            Log::d(std::format("saveYaml {}", b));
        }

        if (0)
        {
            cout << typeid(b).name() << "\n";
            std::vector<std::string> xxpath;
            xxpath.push_back("patch");
            xxpath.push_back("style/horizontal");
            b = Syss::readYaml(p + "/weasel.custom.yaml", xxpath, b);
            Log::d(std::format("readYaml {}", b));
            int k = 5;
            xxpath.clear();
            xxpath.push_back("patch");
            xxpath.push_back("menu/page_size");
            k = Syss::readYaml(p + "/default.custom.yaml", xxpath, k);
            Log::d(std::format("readYaml {}", k));
        }

        if (0)
        {
            YAML::Node config = YAML::Load((char*)LUNA_PINYIN_SIMP_CUSTOM_YAML__DATA);
            //YAML::LoadFile("z:/1.yaml");
            //YAML::Load((char*)LUNA_PINYIN_SIMP_CUSTOM_YAML__DATA);
            Log::d("aaa");
            YAML::Node patch = config["patch"]["speller/algebra"];
            std::cout << patch.Type();
            /*   const std::string username = patch.as<std::string>();
            Log::d(std::format("{} {}", username, patch.as<bool>()));*/
            auto it = patch.begin();
            for (; it != patch.end(); it++)
            {
                std::cout << (*(it)) << std::endl;
            }
        }
    }
    static void testYaml1()
    {
        YAML::Node config = YAML::LoadFile("z:/default.custom.yaml");
        Log::d("aaa");
        YAML::Node patch = config["patch"]["schema_list"];
        std::cout << patch.Type();
        auto it = patch.begin();
        for (; it != patch.end(); it++)
        {
            std::cout << (*(it))["schema"] << std::endl;
        }

        // const std::string username = patch["distribution_code_name"].as<std::string>();
        // Log::d(std::format("{}", username));
    }
};

} // namespace weasel_cfg

#endif
