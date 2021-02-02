
//https://www.cnblogs.com/cdh49/p/3602211.html

#include <iostream>

#include <fstream>

#include <string>

using namespace std;

extern "C"

{

#include <lua.h>

#include <lauxlib.h>

#include <lualib.h>
};

void TestLua2();

int main()

{
    TestLua2();

    return 0;
}

void TestLua2()

{
    lua_State* L = luaL_newstate();

    luaopen_base(L); //

    luaopen_table(L); //

    luaopen_package(L); //

    luaopen_io(L); //

    luaopen_string(L); //

    luaL_openlibs(L); //打开以上所有的lib

    int valueCPP = 1;

    // 将a值压入栈顶

    lua_pushnumber(L, valueCPP);

    // 命名栈顶的值

    lua_setglobal(L, "valueCPP");

    string str;

    while (true)

    {
        cout << "输入lua文件路径:" << endl;

        getline(cin, str, '\n');

        if (luaL_loadfile(L, str.c_str())

            || lua_pcall(L, 0, 0, 0))

        {
            const char* error = lua_tostring(L, -1);

            cout << string(error) << endl;
        }
    }
}
