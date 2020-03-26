
// 主程序
// 本程序为游泳的鱼编写。
// 版权所无，您可以以任何方式使用代码

#include <stdio.h>
#include <time.h>
#include "jymain.h"
// 全程变量

SDL_Window* g_window;
SDL_Renderer* g_renderer;
SDL_Texture* g_screenTex;

int g_ScreenW=480 ;          // 屏幕宽高
int g_ScreenH=800 ;
int device_w=480 ;
int device_h=800 ;
int g_ScreenBpp=16 ;         // 屏幕色深
int g_FullScreen=0;
int g_EnableSound=1;         // 声音开关 0 关闭 1 打开
int g_MusicVolume=32;           // 音乐声音大小
int g_SoundVolume=32;           // 音效声音大小

int g_XScale=18;             //贴图x,y方向一半大小
int g_YScale=9;

//各个地图绘制时xy方向需要多绘制的余量。保证可以全部显示
int g_MMapAddX;              
int g_MMapAddY;
int g_SMapAddX;
int g_SMapAddY;
int g_WMapAddX;
int g_WMapAddY;

int g_KeyRepeatDelay = 150;		//第一次键盘重复等待ms数
int g_KeyRePeatInterval = 30;	//一秒钟重复次数

int g_MAXCacheNum=1000;     //最大缓存数量

static int IsDebug=0;         //是否打开跟踪文件
int g_LoadFullS=1;          //是否全部加载S文件
int g_LoadMMapType=0;          //是否全部加载M文件
int g_LoadMMapScope=0;       
int g_PreLoadPicGrp=0;      //是否预先加载贴图文件的grp

int g_D1X = -1;
int g_D1Y = -1;
int g_D2X = -1;
int g_D2Y = -1;
int g_D3X = -1;
int g_D3Y = -1;
int g_D4X = -1;
int g_D4Y = -1;
int g_C1X = -1;
int g_C1Y = -1;
int g_C2X = -1;
int g_C2Y = -1;
int g_AX = -1;
int g_AY = -1;
int g_BX = -1;
int g_BY = -1;

int g_F1X = -1;
int g_F1Y = -1;
int g_F2X = -1;
int g_F2Y = -1;
int g_F3X = -1;
int g_F3Y = -1;
int g_F4X = -1;
int g_F4Y = -1;

float g_Zoom = 1;		//图片放大
int g_MP3 = 0;			//是否打开MP3
char g_MidSF2[255];		//音色库对应的文件

static char JYMain_Lua[255];  //lua主函数

char JY_CurrentPath[512];
int g_KeyScale = 960;

SDL_Texture* g_WarMoveTex[4];

//定义的lua接口函数名
static const struct luaL_Reg jylib [] = {
      {"Debug", HAPI_Debug},

      //{"GetKey", HAPI_GetKey},
	  { "GetKey", HAPI_GetKey},
      {"GetMouse", HAPI_GetMouse},
      {"EnableKeyRepeat", HAPI_EnableKeyRepeat},

      {"Delay", HAPI_Delay},
      {"GetTime", HAPI_GetTime},
  
      {"CharSet", HAPI_CharSet},
      {"DrawStr", HAPI_DrawStr},

      
      {"SetClip",HAPI_SetClip},
      {"FillColor", HAPI_FillColor},
	  { "Background", HAPI_Background },
	  { "Gauss", HAPI_Gauss },
	  { "DrawRect", HAPI_DrawRect },
	  { "DrawLine", HAPI_DrawLine },

      {"ShowSurface", HAPI_ShowSurface},
      {"ShowSlow", HAPI_ShowSlow},

      {"PicInit", HAPI_PicInit},
      {"PicGetXY", HAPI_GetPicXY},
      {"PicLoadCache", HAPI_LoadPic},
      {"PicLoadCache2", HAPI_LoadPic2},
      {"PicLoadFile", HAPI_PicLoadFile},

      {"FullScreen", HAPI_FullScreen},

      {"LoadPicture", HAPI_LoadPicture},
      {"LoadConfig", HAPI_LoadConfig},
      {"LoadSoundConfig", HAPI_LoadSoundConfig},

      {"PlayMIDI", HAPI_PlayMIDI},
      {"PlayWAV", HAPI_PlayWAV},
      {"PlayMPEG", HAPI_PlayMPEG},
      
	  {"LoadMMap", HAPI_LoadMMap},
      {"DrawMMap", HAPI_DrawMMap},
      {"GetMMap", HAPI_GetMMap},
	  {"UnloadMMap", HAPI_UnloadMMap},
 
      {"LoadSMap", HAPI_LoadSMap},
      {"SaveSMap", HAPI_SaveSMap},
      {"GetS", HAPI_GetS},
      {"SetS", HAPI_SetS},
      {"GetD", HAPI_GetD},
      {"SetD", HAPI_SetD},
      {"DrawSMap", HAPI_DrawSMap},

      {"LoadWarMap", HAPI_LoadWarMap},
      {"GetWarMap", HAPI_GetWarMap},
      {"SetWarMap", HAPI_SetWarMap},
      {"CleanWarMap", HAPI_CleanWarMap},

      {"DrawWarMap", HAPI_DrawWarMap},
      {"SaveSur", HAPI_SaveSur},
		  {"LoadSur", HAPI_LoadSur},
		  {"FreeSur", HAPI_FreeSur},
		  {"GetScreenW", HAPI_ScreenWidth},
		  {"GetScreenH", HAPI_ScreenHeight},
      {"LoadPNGPath",HAPI_LoadPNGPath},
		{"LoadPNG",HAPI_LoadPNG},
		{ "GetPNGXY", HAPI_GetPNGXY },

	  
      {NULL, NULL}
    };
 
static const struct luaL_Reg bytelib[] = {
	{ "create", Byte_create },
	{ "loadfile", Byte_loadfile },
	{ "savefile", Byte_savefile },
	{ "get8", Byte_get8 },
	{ "set8", Byte_set8 },
	{ "get16", Byte_get16 },
	{ "set16", Byte_set16 },
	{ "getu16", Byte_getu16 },
	{ "setu16", Byte_setu16 },
	{ "get32", Byte_get32 },
	{ "set32", Byte_set32 },
	{ "get64", Byte_get64 },
	{ "set64", Byte_set64 },
	{ "getstr", Byte_getstr },
	{ "setstr", Byte_setstr },
	{ "hash", Byte_RSHash }, //Byte_RSHash Byte_BKDHash
	{"getfiletime",Byte_getfiletime},
	{ NULL, NULL }
};
static const struct luaL_Reg configLib [] = {

		{"GetPath", Config_GetPath},
		 {NULL, NULL}
};

static void GetModes (int *width, int *height)
{
	char buf[10];
	FILE *fp = fopen(_("resolution.txt"), "r");

  if (!fp) {
      JY_Error("GetModes: cannot open resolution.txt");
      return ;
  }
  
  //宽
  memset(buf, 0, 10);
	fgets(buf, 10, fp);
	*width = atoi(buf);

	//高
	memset(buf, 0, 10);
  fgets(buf, 10, fp);
	*height = atoi(buf);
  
  JY_Debug("GetModes: width=%d, height=%d", *width, *height);
  
  fclose(fp);
}



// 主程序
int main(int argc, char *argv [])
{

	lua_State *pL_main;

	//GetModes(&g_ScreenW,&g_ScreenH);
	//	__android_log_print(ANDROID_LOG_INFO, "jy", "path = %s", JY_CurrentPath);



	remove(_(DEBUG_FILE));
	remove(_(ERROR_FILE));    //设置stderr输出到文件

	pL_main = luaL_newstate();
	luaL_openlibs(pL_main);

	lua_newtable(pL_main);
	luaL_setfuncs(pL_main, jylib, 0);
	lua_pushvalue(pL_main, -1);
	lua_setglobal(pL_main, "lib");

	lua_newtable(pL_main);
	luaL_setfuncs(pL_main, bytelib, 0);
	lua_pushvalue(pL_main, -1);
	lua_setglobal(pL_main, "Byte");

	lua_newtable(pL_main);
	luaL_setfuncs(pL_main, configLib, 0);
	lua_pushvalue(pL_main, -1);
	lua_setglobal(pL_main, "config");

	JY_Debug("Lua_Config();");
	Lua_Config(pL_main, _(CONFIG_FILE));        //读取lua配置文件，设置参数

	JY_Debug("InitSDL();");
	InitSDL();           //初始化SDL

	JY_Debug("InitGame();");
	InitGame();          //初始化游戏数据


	g_WarMoveTex[0] = createPolygonTexture(255, 255, 255, 128);
	g_WarMoveTex[1] = createPolygonTexture(255, 255, 255, 64);
	g_WarMoveTex[2] = createPolygonTexture(0, 0, 0, 128);
	g_WarMoveTex[3] = createPolygonTexture(0, 0, 0, 64);


	JY_Debug("LoadMB();");
	LoadMB(_(HZMB_FILE));  //加载汉字字符集转换码表

	JY_Debug("Lua_Main();");
	Lua_Main(pL_main);          //调用Lua主函数，开始游戏

	JY_Debug("ExitGame();");
	ExitGame();       //释放游戏数据

	JY_Debug("ExitSDL();");
	ExitSDL();        //退出SDL

	JY_Debug("main() end;");

	//关闭lua
	lua_close(pL_main);
	exit(0);
}


//Lua主函数
int Lua_Main(lua_State *pL_main)
{
	int result=0; 

	//初始化lua
 
    //注册lua函数
    //luaL_register(pL_main,"lib", jylib);
    //luaL_register(pL_main, "Byte", bytelib);





	//加载lua文件
    result=luaL_loadfile(pL_main, JYMain_Lua);
    switch(result){
    case LUA_ERRSYNTAX:
    	JY_Error("load lua file %s error: syntax error!\n",JYMain_Lua);
        break;
    case LUA_ERRMEM:
    	JY_Error("load lua file %s error: memory allocation error!\n",JYMain_Lua);
        break;
    case LUA_ERRFILE:
    	JY_Error("load lua file %s error: can not open file!\n",JYMain_Lua);
        break;    
    }
    
	result=lua_pcall(pL_main, 0, LUA_MULTRET, 0);
    
    //调用lua的主函数JY_Main    
   	lua_getglobal(pL_main,"JY_Main");
	result=lua_pcall(pL_main,0,0,0);

 
   

	return 0;
}


//Lua读取配置信息
int Lua_Config(lua_State *pL, const char *filename)
{
	int result = 0;




	//加载lua配置文件
	result = luaL_loadfile(pL, filename);
	switch (result){
	case LUA_ERRSYNTAX:
		fprintf(stderr, "load lua file %s error: syntax error!\n", filename);
		break;
	case LUA_ERRMEM:
		fprintf(stderr, "load lua file %s error: memory allocation error!\n", filename);
		break;
	case LUA_ERRFILE:
		fprintf(stderr, "load lua file %s error: can not open file!\n", filename);
		break;
	}

	result = lua_pcall(pL, 0, LUA_MULTRET, 0);

	lua_getglobal(pL, "CONFIG");            //读取config定义的值

	if (getfield(pL, "Width") != 0){
		g_ScreenW = getfield(pL, "Width");
		//device_w = g_ScreenW;
	}
	if (getfield(pL, "Height") != 0){
		g_ScreenH = getfield(pL, "Height");
		//device_h = g_ScreenH;
	}
	g_ScreenBpp = getfield(pL, "bpp");
	g_FullScreen = getfield(pL, "FullScreen");
	g_XScale = getfield(pL, "XScale");
	g_YScale = getfield(pL, "YScale");
	g_EnableSound = getfield(pL, "EnableSound");
	IsDebug = getfield(pL, "Debug");
	g_MMapAddX = getfield(pL, "MMapAddX");
	g_MMapAddY = getfield(pL, "MMapAddY");
	g_SMapAddX = getfield(pL, "SMapAddX");
	g_SMapAddY = getfield(pL, "SMapAddY");
	g_WMapAddX = getfield(pL, "WMapAddX");
	g_WMapAddY = getfield(pL, "WMapAddY");

	g_SoundVolume = getfield(pL, "SoundVolume");
	g_MusicVolume = getfield(pL, "MusicVolume");

	g_MAXCacheNum = getfield(pL, "MAXCacheNum");
	g_LoadFullS = getfield(pL, "LoadFullS");

	g_KeyRepeatDelay = getfield(pL, "KeyRepeatDelay");
	g_KeyRePeatInterval = getfield(pL, "KeyRePeatInterval");

	g_D1X = getfield(pL, "D1X");
	g_D1Y = getfield(pL, "D1Y");
	g_D2X = getfield(pL, "D2X");
	g_D2Y = getfield(pL, "D2Y");
	g_D3X = getfield(pL, "D3X");
	g_D3Y = getfield(pL, "D3Y");
	g_D4X = getfield(pL, "D4X");
	g_D4Y = getfield(pL, "D4Y");
	g_C1X = getfield(pL, "C1X");
	g_C1Y = getfield(pL, "C1Y");
	g_C2X = getfield(pL, "C2X");
	g_C2Y = getfield(pL, "C2Y");
	g_AX = getfield(pL, "AX");
	g_AY = getfield(pL, "AY");
	g_BX = getfield(pL, "BX");
	g_BY = getfield(pL, "BY");

	g_F1X = getfield(pL, "F1X");
	g_F1Y = getfield(pL, "F1Y");
	g_F2X = getfield(pL, "F2X");
	g_F2Y = getfield(pL, "F2Y");
	g_F3X = getfield(pL, "F3X");
	g_F3Y = getfield(pL, "F3Y");
	g_F4X = getfield(pL, "F4X");
	g_F4Y = getfield(pL, "F4Y");

	g_Zoom = (float) (getfield(pL, "Zoom") / 100.0);
	g_MP3 = getfield(pL, "MP3");
	getfieldstr(pL, "MidSF2", g_MidSF2);

	getfieldstr(pL, "JYMain_Lua", JYMain_Lua);

	g_KeyScale = getfield(pL, "KeyScale");

	return 0;
}


//读取lua表中的整型
int getfield(lua_State *pL,const char *key)
{
	int result;
	lua_getfield(pL,-1,key);
	result=(int)lua_tonumber(pL,-1);
	lua_pop(pL,1);
	return result;
}



//读取lua表中的字符串
int getfieldstr(lua_State *pL,const char *key,char *str)
{
 
	const char *tmp;
	lua_getfield(pL,-1,key);
	tmp=(const char *)lua_tostring(pL,-1);
	strcpy(str,tmp); 
	lua_pop(pL,1);
	return 0;
}

int System_Paused()
{
	PausedMIDI();
	return 0;
}

int System_Resume()
{
	ResumeMIDI();

	JY_ShowSurface(0);
	return 0;
}



//以下为几个通用函数



// 调试函数
// 输出到debug.txt中
int JY_Debug(const char * fmt,...)
{
    time_t t;
	FILE *fp;
    struct tm *newtime;
    va_list argptr;
	char string[1024];
	// concatenate all the arguments in one string
	va_start(argptr, fmt);
	vsnprintf(string, sizeof(string), fmt, argptr);
	va_end(argptr);
    if(IsDebug==0)
        return 0;

	fp=fopen(_("debug.txt"),"a+t");
	if (fp){
		time(&t);
		newtime = localtime(&t);
		//    __android_log_print(ANDROID_LOG_INFO, "jy", "%02d:%02d:%02d %s\r\n",newtime->tm_hour,newtime->tm_min,newtime->tm_sec,string);
		fprintf(fp, "%02d:%02d:%02d %s\r\n", newtime->tm_hour, newtime->tm_min, newtime->tm_sec, string);
		fclose(fp);
	}
	return 0;
}
// 调试函数
// 输出到error.txt中
int JY_Error(const char * fmt,...)
{
    time_t t;
	FILE *fp;
    struct tm *newtime;
 
    va_list argptr;
    char string[1024];
       
	va_start(argptr, fmt);
	vsnprintf(string, sizeof(string), fmt, argptr);
	va_end(argptr);
	fp=fopen(_("error.txt"),"a+t");
	if (fp){
		time(&t);
		newtime = localtime(&t);
		//__android_log_print(ANDROID_LOG_INFO, "jy", "%02d:%02d:%02d %s\n",newtime->tm_hour,newtime->tm_min,newtime->tm_sec,string);
		fprintf(fp, "%02d:%02d:%02d %s\n", newtime->tm_hour, newtime->tm_min, newtime->tm_sec, string);
		fclose(fp);
	}
	return 0;
} 

// 限制x大小
int limitX(int x, int xmin, int xmax)
{
    if(x>xmax)
		x=xmax;
	if(x<xmin)
		x=xmin;
	return x;
}



// 返回文件长度，若为0，则文件可能不存在
int FileLength(const char *filename)
{
    FILE   *f;  
    int ll;
    if((f=fopen(filename,"rb"))==NULL){
        return 0;            // 文件不存在，返回
	}
    fseek(f,0,SEEK_END);  
    ll=ftell(f);    //这里得到的len就是文件的长度了
    fclose(f);   
	return ll;
}

char *
va(
   const char *format,
   ...
)
/*++
  Purpose:

    Does a varargs printf into a temp buffer, so we don't need to have
    varargs versions of all text functions.

  Parameters:

    format - the format string.

  Return value:

    Pointer to the result string.

--*/
{
   static char string[256];
   va_list     argptr;

   va_start(argptr, format);
   vsnprintf(string, 256, format, argptr);
   va_end(argptr);

   return string;
}

