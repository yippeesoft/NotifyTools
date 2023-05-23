#ifndef __SYS_WEASEL_
#define __SYS_WEASEL_

#include <string>
#include <windows.h>
#include <winerror.h>
#include <iostream>
#include <format>
#include <shlobj.h>
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
                if (!path.empty())
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
    }
};

} // namespace weasel_cfg

#endif