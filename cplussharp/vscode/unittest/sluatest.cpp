
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
LUALIB_API int fun(lua_State* l)
{
    if (l == nullptr)
        return 0;
    cout << "cpp fun print " << endl;
    return 0;
}

LUALIB_API int add(lua_State* l)
{
    if (l == nullptr)
        return 0;
    int n=lua_gettop(l);
    if(n!=2)
    {
        lua_pushstring(l,"参数错误！");
        lua_error(l);
        return 0;
    }
    int a=luaL_checkinteger(l,-2);
    int b=luaL_checkinteger(l,-1);
    cout << "add print " << endl;
    lua_pushnumber(l,a+b);
    lua_pushnumber(l,a-b);
    return 2;
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

    // while (true)
    luaL_loadstring(L, "print('c++ = ' .. valueCPP)");
    lua_pcall(L, 0, 0, 0);

    lua_pushcfunction(L,fun);
    lua_setglobal(L,"aaaaffunc");
    luaL_loadstring(L, "print('c++ = ' .. aaaaffunc())");
    lua_pcall(L, 0, 0, 0);

    lua_pushcfunction(L,add);
    lua_setglobal(L,"add");
    luaL_loadstring(L, "local a,b =add(99,88) \n print('c++ = ' .. a .. b)");
    lua_pcall(L, 0, 0, 0);
    {
        cout << "输入lua文件路径:" << endl;

        // getline(cin, str, '\n');

        // if (luaL_loadfile(L, str.c_str())

        //     || lua_pcall(L, 0, 0, 0))

        // {
        //     const char* error = lua_tostring(L, -1);

        //     cout << string(error) << endl;
        // }
    }
    lua_close(L);
}
