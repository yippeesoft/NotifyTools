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
class Test
{
public:
    static void testYaml()
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

class Syss
{
public:
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
        return path.empty() ? false : true;
    }
};

} // namespace weasel_cfg

#endif