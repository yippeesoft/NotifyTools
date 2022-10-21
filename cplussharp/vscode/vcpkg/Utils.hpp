#ifndef UTILS_HPP
#define UTILS_HPP
#include <filesystem>
namespace asiohttp {
using namespace std;
namespace fs = std::filesystem;
class Utils
{
public:
#pragma region FILEPATH
    //https://www.jianshu.com/p/ee0551294f5c
    static string getFileName(string file)
    {
        string s = fs::path(file).filename().string().c_str();
        return s;
    }
    static bool isFile(string file)
    {
        return fs::is_regular_file(file);
    }
    static bool isDir(string file)
    {
        return fs::is_directory(file);
    }
#pragma endregion
};
} // namespace asiohttp
#endif