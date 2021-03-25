project(lua_project)
set(lua_core 
        lapi.c 
        lcode.c 
        lctype.c 
        ldebug.c 
        ldo.c 
        ldump.c 
        lfunc.c 
        lgc.c 
        llex.c
        lmem.c 
        lobject.c 
        lopcodes.c 
        lparser.c 
        lstate.c 
        lstring.c 
        ltable.c
        ltm.c 
        lundump.c
        lvm.c 
        lzio.c
    )
set(lua_lib 
        lauxlib.c 
        lbaselib.c
        lbitlib.c 
        lcorolib.c 
        ldblib.c 
        liolib.c
        lmathlib.c 
        loslib.c 
        lstrlib.c 
        ltablib.c 
        loadlib.c
        linit.c
        lutf8lib.c
    )
add_library(lua STATIC ${lua_core} ${lua_lib})


add_executable(luac luac.c)
add_executable(luaexe lua.c)
if(MSVC)
target_link_libraries(luac lua)
target_link_libraries(luaexe lua)
else()
target_link_libraries(luac lua m)
target_link_libraries(luaexe lua m)
endif()