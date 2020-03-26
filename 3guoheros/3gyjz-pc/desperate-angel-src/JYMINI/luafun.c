 
// 与lua库的交互函数,使用lua5.1.2版


  
#include <stdio.h>
#include <string.h>
#ifdef __SYMBIAN32__
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include "jymain.h"
#ifdef ANDROID
#include <android/log.h>
#endif
#include <sys/stat.h>
//#include <gl/glut.h>
extern SDL_Window* g_window;
extern SDL_Renderer* g_renderer;
extern SDL_Texture* g_screenTex;
extern int g_ScreenW;
extern int g_ScreenH;
extern int device_w;
extern int device_h;
extern int g_EnableSound;
extern int g_MusicVolume;
extern int g_SoundVolume;
extern char JY_CurrentPath[512];
time_t ticks = 0;
//以下为所有包装的lua接口函数，对应于每个实际的函数

int HAPI_DrawStr(lua_State *pL)
{
	int n = lua_gettop(pL);			//得到参数的长度
    int x=(int)lua_tonumber(pL,1);
	int y=(int)lua_tonumber(pL,2);
	const char *str=lua_tostring(pL,3);
	int color=(int)lua_tonumber(pL,4);
	int size=(int)lua_tonumber(pL,5);
	const char *fontname=lua_tostring(pL,6);
	int charset=(int)lua_tonumber(pL,7);
	int OScharset = (int) lua_tonumber(pL, 8);
	int color2 = (int)lua_tonumber(pL, 9);
	if (n > 8)
	{
		JY_DrawStr2(x, y, str, color2, size, fontname, charset, OScharset);
	}
    JY_DrawStr(x, y, str,color,size,fontname,charset,OScharset);

	return 0;
}


int HAPI_FillColor(lua_State *pL)
{
	int x1=(int)lua_tonumber(pL,1);
	int y1=(int)lua_tonumber(pL,2);
	int x2=(int)lua_tonumber(pL,3);
	int y2=(int)lua_tonumber(pL,4);
	int color=(int)lua_tonumber(pL,5);

    JY_FillColor(x1,y1,x2,y2,color);
	return 0;
}


int HAPI_Background(lua_State *pL)
{
	int x1=(int)lua_tonumber(pL,1);
	int y1=(int)lua_tonumber(pL,2);
	int x2=(int)lua_tonumber(pL,3);
	int y2=(int)lua_tonumber(pL,4);
	int Bright=(int)lua_tonumber(pL,5);
	int color=(int)lua_tonumber(pL,6);
    JY_Background(x1,y1,x2,y2,Bright,color);
	return 0;
}
int HAPI_Gauss(lua_State *pL)
{
	int x1 = (int)lua_tonumber(pL, 1);
	int y1 = (int)lua_tonumber(pL, 2);
	int x2 = (int)lua_tonumber(pL, 3);
	int y2 = (int)lua_tonumber(pL, 4);
	int n = (int)lua_tonumber(pL, 5);
	JY_Gauss(x1, y1, x2, y2, n);
	return 0;
}

int HAPI_DrawRect(lua_State *pL)
{
	int x1=(int)lua_tonumber(pL,1);
	int y1=(int)lua_tonumber(pL,2);
	int x2=(int)lua_tonumber(pL,3);
	int y2=(int)lua_tonumber(pL,4);
	int color=(int)lua_tonumber(pL,5);

    JY_DrawRect(x1,y1,x2,y2,color);
	return 0;
}
int HAPI_DrawLine(lua_State *pL)
{
	int x1 = (int)lua_tonumber(pL, 1);
	int y1 = (int)lua_tonumber(pL, 2);
	int x2 = (int)lua_tonumber(pL, 3);
	int y2 = (int)lua_tonumber(pL, 4);
	int color = (int)lua_tonumber(pL, 5);

	DrawLine32(x1, y1, x2, y2, color);
	return 0;
}

int HAPI_ShowSlow(lua_State *pL)
{
	int delay=(int)lua_tonumber(pL,1);
	int flag=(int)lua_tonumber(pL,2);
    JY_ShowSlow(delay,flag);
	return 0;
}





int HAPI_LoadPicture(lua_State *pL)
{
	 int n = lua_gettop(pL);			//得到参数的长度
	const char *str=lua_tostring(pL,1);
 

	
	int x=(int)lua_tonumber(pL,2);
	int y=(int)lua_tonumber(pL,3);
 
	//蓝烟清：传入比例
	int percent = 0;
	if (n > 3)
	{
		percent = (int)lua_tonumber(pL,4);
	}

  
    JY_LoadPicture(str,x,y,percent);
 
	return 0;
}


int HAPI_LoadConfig(lua_State *pL)
{
	int scrW=(int)lua_tonumber(pL,1);
	int scrH=(int)lua_tonumber(pL,2);
	g_ScreenW= scrW;
	g_ScreenH= scrH;
	ExitGame();
    SDL_DestroyTexture(g_screenTex);
    SDL_DestroyRenderer(g_renderer);
    SDL_DestroyWindow(g_window);
    InitGame();           //初始化
	return 0;
}
int HAPI_LoadSoundConfig(lua_State *pL)
{
	g_MusicVolume=(int)lua_tonumber(pL,1);
	g_SoundVolume=(int)lua_tonumber(pL,2);
	BASS_SetVolume((float)(g_MusicVolume / 100.0));
	return 0;
}

int HAPI_GetKey(lua_State *pL)
{
	int flag = (int) lua_tonumber(pL, 1);
	int EventType, keyPress, x, y;
	JY_GetKey(&EventType, &keyPress, &x, &y);
	if (flag == 1){
		lua_pushnumber(pL, EventType);
		lua_pushnumber(pL, keyPress);
		lua_pushnumber(pL, x);
		lua_pushnumber(pL, y);
		return 4;
	}
	else{
		if (EventType == 2 || EventType == 3){
			if (keyPress == 3){
				keyPress = 27;
			}
			else if (keyPress == 4){
				keyPress = 888;
			}
			else if (keyPress == 5){
				keyPress = 999;
			}
			else{
				keyPress = (EventType == 2) ? 1000000 : 2000000;
				keyPress += (x * 1000 + y);
			}
		}
		lua_pushnumber(pL, keyPress);
		return 1;
	}
}

int HAPI_GetMouse(lua_State *pL)
{
	Uint32 mousemask;
	int x, y;
	mousemask = JY_GetMouse(&x, &y);
	lua_pushnumber(pL, mousemask);
	lua_pushnumber(pL, x);
	lua_pushnumber(pL, y);
	return 3;
}
int HAPI_EnableKeyRepeat(lua_State *pL)
{
	int delay=(int)lua_tonumber(pL,1);
	int interval=(int)lua_tonumber(pL,2);
    //SDL_EnableKeyRepeat(delay,interval);
	return 0;
}



int HAPI_ShowSurface(lua_State *pL)
{
  int flag=(int)lua_tonumber(pL,1);
    JY_ShowSurface(flag);
	return 0;
}

 

int HAPI_GetTime(lua_State *pL)
{
    int t;
	t=JY_GetTime();
	lua_pushnumber(pL,t);
	return 1;
}


int HAPI_Delay(lua_State *pL)
{
    int x=(int)lua_tonumber(pL,1);
    JY_Delay(x);
	return 0;
}

int HAPI_Debug(lua_State *pL)
{
 
	const char *str=lua_tostring(pL,1);
   
	 JY_Debug(str);

	return 0;
}


int HAPI_CharSet(lua_State *pL)
{
    int length;
	const char *src=lua_tostring(pL,1);
	int flag=(int)lua_tonumber(pL,2);
    char *dest;

	length =strlen(src);

    dest=(char*)malloc(length+1);

    JY_CharSet(src,dest,flag);

    lua_pushstring(pL,dest);

	SafeFree(dest);

	return 1;
}



int HAPI_SetClip(lua_State *pL)
{
 
	if(lua_isnoneornil(pL,1)==0 ){ 
		int x1=(int)lua_tonumber(pL,1);
		int y1=(int)lua_tonumber(pL,2);
		int x2=(int)lua_tonumber(pL,3);
		int y2=(int)lua_tonumber(pL,4);
		JY_SetClip(x1,y1,x2,y2);
	}
	else{
        JY_SetClip(0,0,0,0);
    }

	return 0;
}

int HAPI_PlayMIDI(lua_State *pL)
{
 
	const char *filename=lua_tostring(pL,1);

    JY_PlayMIDI(filename);

	return 0;
}

int HAPI_PlayWAV(lua_State *pL)
{
 
	const char *filename=lua_tostring(pL,1);

    JY_PlayWAV(filename);

	return 0;
}


int HAPI_PlayMPEG(lua_State *pL)
{
 
	const char *filename=lua_tostring(pL,1);
	int key=(int)lua_tonumber(pL,2);
    JY_PlayMPEG(filename,key);

	return 0;
}




int HAPI_PicInit(lua_State *pL)
{
    char *filename;
    if(lua_isnoneornil(pL,1)==0 )
        filename=(char*)lua_tostring(pL,1);	    
    else
        filename="\0";
  	
    JY_PicInit(filename); 
 
	return 0;
}

int HAPI_PicLoadFile(lua_State *pL)
{
	int n = lua_gettop(pL);			//得到参数的长度
	const char *idx=lua_tostring(pL,1);
	const char *grp=lua_tostring(pL,2);
	int id=(int)lua_tonumber(pL,3); 
    
 //蓝烟清：传入比例
	int percent = 100;
	int bufferlen = 100;
	if (n > 3)
	{
		percent = (int)lua_tonumber(pL, 4);
	}
	if (lua_isnoneornil(pL, 4) == 0)
		bufferlen = (int) lua_tonumber(pL, 4);

	JY_PicLoadFile(idx,grp,id, percent,bufferlen);
 
	return 0;
}
 
int HAPI_LoadPic(lua_State *pL)
{
 
	int fileid=(int)lua_tonumber(pL,1);
	int picid=(int)lua_tonumber(pL,2);
	int x=(int)lua_tonumber(pL,3);
	int y=(int)lua_tonumber(pL,4);
	int nooffset=0;
	int bright=0;
    if(lua_isnoneornil(pL,5)==0 )
        nooffset=(int)lua_tonumber(pL,5);

    if(lua_isnoneornil(pL,6)==0 )
        bright=(int)lua_tonumber(pL,6);

	int pcolor = -1;
	if (lua_isnoneornil(pL, 7) == 0)
		pcolor = (int)lua_tonumber(pL, 7);
	int nw = 0;
	if (lua_isnoneornil(pL, 8) == 0)
		nw = (int)lua_tonumber(pL, 8);
	int nh = 0;
	if (lua_isnoneornil(pL, 9) == 0)
		nh = (int)lua_tonumber(pL, 9);
	//JY_LoadPic(fileid,picid,x,y,nooffset,bright);
	JY_LoadPicColor(fileid, picid, x, y, nooffset, bright,pcolor,nw,nh);
	return 0;
} 

int HAPI_LoadPic2(lua_State *pL)
{
 
	int fileid=(int)lua_tonumber(pL,1);
	int picid=(int)lua_tonumber(pL,2);
	int picid2=(int)lua_tonumber(pL,3);
	int x=(int)lua_tonumber(pL,4);
	int y=(int)lua_tonumber(pL,5);
	int nooffset=0;
	int bright=0;

    if(lua_isnoneornil(pL,6)==0 )
        nooffset=(int)lua_tonumber(pL,6);

    if(lua_isnoneornil(pL,7)==0 )
        bright=(int)lua_tonumber(pL,7);

	int pcolor = -1;
	if (lua_isnoneornil(pL, 8) == 0)
		pcolor = (int)lua_tonumber(pL, 8);
	int nw = -1;
	if (lua_isnoneornil(pL, 9) == 0)
		nw = (int)lua_tonumber(pL, 9);
	int nh = -1;
	if (lua_isnoneornil(pL, 10) == 0)
		nh = (int)lua_tonumber(pL, 10);

	JY_LoadPicColor2(fileid, picid, picid2, x, y, nooffset, bright, pcolor, nw, nh);

	return 0;
}


int HAPI_GetPicXY(lua_State *pL)
{
	int fileid=(int)lua_tonumber(pL,1);
	int picid=(int)lua_tonumber(pL,2);

	int w,h, xoff, yoff;
	
	JY_GetPicXY(fileid,picid,&w,&h,&xoff,&yoff);
	lua_pushnumber(pL,w);
	lua_pushnumber(pL,h);
	lua_pushnumber(pL,xoff);
	lua_pushnumber(pL,yoff);
	return 4;
}






int HAPI_LoadMMap(lua_State *pL)
{
 
	const char *earth=lua_tostring(pL,1);
	const char *surface=lua_tostring(pL,2);
	const char *building=lua_tostring(pL,3);
	const char *buildx=lua_tostring(pL,4);
	const char *buildy=lua_tostring(pL,5);
	int xmax=(int)lua_tonumber(pL,6);
	int ymax=(int)lua_tonumber(pL,7);
	int x=(int)lua_tonumber(pL,8);
	int y=(int)lua_tonumber(pL,9);
  JY_LoadMMap(earth,surface,building,buildx,buildy,xmax,ymax,x,y);

	return 0;
}


int HAPI_DrawMMap(lua_State *pL)
{
	int x=(int)lua_tonumber(pL,1);
	int y=(int)lua_tonumber(pL,2);
	int mypic=(int)lua_tonumber(pL,3);

    JY_DrawMMap(x,y,mypic);
	return 0;
}

int HAPI_GetMMap(lua_State *pL)
{
	int x=(int)lua_tonumber(pL,1);
	int y=(int)lua_tonumber(pL,2);
	int flag=(int)lua_tonumber(pL,3);
    int v;
    v=JY_GetMMap(x,y,flag);
	lua_pushnumber(pL,v);
	return 1;
}

int HAPI_UnloadMMap(lua_State *pL)
{
    JY_UnloadMMap();
	return 0;
}


int HAPI_FullScreen(lua_State *pL)
{
    JY_FullScreen();
	return 0;
}


 
int HAPI_LoadSMap(lua_State *pL)
{
 

	const char *Sfilename=lua_tostring(pL,1);
	const char *tempfilename=lua_tostring(pL,2);
	int num=(int)lua_tonumber(pL,3);

	int x_max=(int)lua_tonumber(pL,4);
	int y_max=(int)lua_tonumber(pL,5);
	const char *Dfilename=lua_tostring(pL,6);
    int d_num1=(int)lua_tonumber(pL,7);
	int d_num2=(int)lua_tonumber(pL,8);

    JY_LoadSMap(Sfilename,tempfilename,num,x_max,y_max,Dfilename,d_num1,d_num2);

	return 0;
}

 

int HAPI_SaveSMap(lua_State *pL)
{
 
 
	const char *Sfilename=lua_tostring(pL,1);
	const char *Dfilename=lua_tostring(pL,2); 
    
	JY_SaveSMap(Sfilename,Dfilename);
	return 0;
}

 


int HAPI_GetS(lua_State *pL)
{

    int id=(Sint16)lua_tonumber(pL,1);
    int x=(int)lua_tonumber(pL,2);
    int y=(int)lua_tonumber(pL,3);
    int level=(int)lua_tonumber(pL,4);

	int v;
	v=JY_GetS(id,x,y,level);

	lua_pushnumber(pL,v);
	return 1;

}

int HAPI_SetS(lua_State *pL)
{

    int id=(int)lua_tonumber(pL,1);
    int x=(int)lua_tonumber(pL,2);
    int y=(int)lua_tonumber(pL,3);
    int level=(int)lua_tonumber(pL,4);
    int v=(int)lua_tonumber(pL,5);

	JY_SetS(id,x,y,level,v);

	return 0;

}
 
int HAPI_GetD(lua_State *pL)
{
	Sint16 v = -1;
    int Sceneid=(Sint16)lua_tonumber(pL,1);
    int id=(Sint16)lua_tonumber(pL,2);
    int i=(int)lua_tonumber(pL,3);
 

    v=JY_GetD(Sceneid,id,i);
    

	lua_pushnumber(pL,v);
	return 1;

}

int HAPI_SetD(lua_State *pL)
{

    int Sceneid=(Sint16)lua_tonumber(pL,1);
    int id=(Sint16)lua_tonumber(pL,2);
    int i=(int)lua_tonumber(pL,3);
    int v=(int)lua_tonumber(pL,4); 

 
    JY_SetD(Sceneid,id,i,v);

	return 0;

}

int HAPI_DrawSMap(lua_State *pL)
{
	int sceneid=(Sint16)lua_tonumber(pL,1);
	int x=(int)lua_tonumber(pL,2);
	int y=(int)lua_tonumber(pL,3);
	int xoff=(int)lua_tonumber(pL,4);
	int yoff=(int)lua_tonumber(pL,5);
	int mypic=(int)lua_tonumber(pL,6);
 
    JY_DrawSMap(sceneid,x,y,xoff,yoff,mypic);
 
	return 0;
}




int HAPI_LoadWarMap(lua_State *pL)
{
 
	const char *WarIDXfilename=lua_tostring(pL,1);
	const char *WarGRPfilename=lua_tostring(pL,2);
    int mapid=(int)lua_tonumber(pL,3);
	int num=(int)lua_tonumber(pL,4);
	int x_max=(int)lua_tonumber(pL,5);
    int y_max=(int)lua_tonumber(pL,6);

    JY_LoadWarMap(WarIDXfilename,WarGRPfilename,mapid,num,x_max,y_max);

	return 0;
}


 
int HAPI_GetWarMap(lua_State *pL)
{

    int x=(int)lua_tonumber(pL,1);
    int y=(int)lua_tonumber(pL,2);
    int level=(int)lua_tonumber(pL,3);
 

	Sint16 v;
	v=JY_GetWarMap(x,y,level);

	lua_pushnumber(pL,v);
	return 1;

}

int HAPI_SetWarMap(lua_State *pL)
{

    int x=(int)lua_tonumber(pL,1);
    int y=(int)lua_tonumber(pL,2);
    int level=(int)lua_tonumber(pL,3);
	int v=(int)lua_tonumber(pL,4);
	JY_SetWarMap(x,y,level,v);

	return 0;

}

int HAPI_CleanWarMap(lua_State *pL)
{

    int level=(int)lua_tonumber(pL,1);
	int v=(int)lua_tonumber(pL,2);
	JY_CleanWarMap(level,v);

	return 0;

}

int HAPI_DrawWarMap(lua_State *pL)
{
	int n = lua_gettop(pL);			//得到参数的长度
	int flag=(int)lua_tonumber(pL,1);
	int x=(int)lua_tonumber(pL,2);
	int y=(int)lua_tonumber(pL,3);
	int v1=(int)lua_tonumber(pL,4);
	int v2=(int)lua_tonumber(pL,5);
	int v3=(int)lua_tonumber(pL,6);
	int v4=(int)lua_tonumber(pL,7);

	int v5 = -1;
	int ex = -1;
	int ey = -1;

	if(n >= 8)
		v5=(int)lua_tonumber(pL,8);
	if(n >= 9)
		ex=(int)lua_tonumber(pL,9);
	if(n >= 10)
		ey=(int)lua_tonumber(pL,10);

    JY_DrawWarMap(flag,x,y,v1,v2,v3,v4,v5,ex,ey);
	return 0;
}

int HAPI_SaveSur(lua_State *pL){		//保存屏幕到临时表面
	int x=(int)lua_tonumber(pL,1);
	int y=(int)lua_tonumber(pL,2);
	int w=(int)lua_tonumber(pL,3);
	int h=(int)lua_tonumber(pL,4);
	int id = JY_SaveSur(x, y, w, h);
	lua_pushnumber(pL, id);
	return 1;
}
int HAPI_LoadSur(lua_State *pL){			//加载临时表面到屏幕
	int id=(int)lua_tonumber(pL,1);
	int x=(int)lua_tonumber(pL,2);
	int y=(int)lua_tonumber(pL,3);
	JY_LoadSur(id, x, y);
	return 0;
}
int HAPI_FreeSur(lua_State *pL){				//释放
	int id=(int)lua_tonumber(pL,1);
	JY_FreeSur(id);
	return 0;
}

int HAPI_ScreenWidth(lua_State *pL)				//屏幕宽度
{
	lua_pushnumber(pL, device_w);
	return 1;
}
int HAPI_ScreenHeight(lua_State *pL)			//屏幕高度
{
	lua_pushnumber(pL, device_h);
	return 1;
}

int HAPI_LoadPNGPath(lua_State *pL)				//按图片读取PNG
{
	int n = lua_gettop(pL);			//得到参数的长度
	const char *path=lua_tostring(pL,1);
    int fileid=(int)lua_tonumber(pL,2);
	int num=(int)lua_tonumber(pL,3);
	int percent = 0;
	const char* suffix = "png";

	if(n>3)
		percent=(int)lua_tonumber(pL,4);

	if(n>4)
		suffix=lua_tostring(pL,5);

    JY_LoadPNGPath(path, fileid, num, percent, suffix);

	return 0;
}
int HAPI_LoadPNG(lua_State *pL)				//按图片读取PNG
{
	int n = lua_gettop(pL);			//得到参数的长度
    int fileid=(int)lua_tonumber(pL,1);
	int picid=(int)lua_tonumber(pL,2);
	int x=(int)lua_tonumber(pL,3);
	int y=(int)lua_tonumber(pL,4);
	int flag = 0;
	int value = 0;
	int px = 0;
	int py = 0;
	int pw = -1;
	int ph = -1;

	if(n>4)
		flag=(int)lua_tonumber(pL,5);
	if(n>5)
		value=(int)lua_tonumber(pL,6);
	if(n>6)
	{
		px=(int)lua_tonumber(pL,7);
		py=(int)lua_tonumber(pL,8);
		pw=(int)lua_tonumber(pL,9);
		ph=(int)lua_tonumber(pL,10);


	}

    JY_LoadPNG(fileid, picid, x,y,flag,value, px, py, pw, ph);

	return 0;
}

int HAPI_GetPNGXY(lua_State *pL)
{
	int fileid=(int)lua_tonumber(pL,1);
	int picid=(int)lua_tonumber(pL,2);

	int w,h,xoff,yoff;
	
	JY_GetPNGXY(fileid,picid,&w,&h,&xoff,&yoff);
	lua_pushnumber(pL,w);
	lua_pushnumber(pL,h);
	lua_pushnumber(pL,xoff);
	lua_pushnumber(pL,yoff);

	return 4;
}

int HAPI_3DBox(lua_State *pL)
{
	return 0;
	//glLoadIdentity();							// 重置当前的模型观察矩阵
	//glTranslatef(-1.5f,0.0f,-6.0f);						// 左移 1.5 单位，并移入屏幕 6.0
	//glBegin(GL_TRIANGLES);							// 绘制三角形
	//	glVertex3f( 0.0f, 1.0f, 0.0f);					// 上顶点
	//	glVertex3f(-1.0f,-1.0f, 0.0f);					// 左下
	//	glVertex3f( 1.0f,-1.0f, 0.0f);					// 右下
	//glEnd();
}

// byte数组lua函数
/*  lua 调用形式：(注意，位置都是从0开始
     handle=Byte_create(size);
	 Byte_release(h);
	 handle=Byte_loadfile(h,filename,start,length);
     Byte_savefile(h,filename,start,length);
     v=Byte_get16(h,start);
	 Byte_set16(h,start,v);
     v=Byte_getu16(h,start);
	 Byte_setu16(h,start,v);
     v=Byte_get32(h,start);
	 Byte_set32(h,start,v);
	 str=Byte_getstr(h,start,length);
	 Byte_setstr(h,start,length,str);
  */

int Byte_create(lua_State *pL)
{
	int x=(int)lua_tonumber(pL,1);
    char *p=(char *)lua_newuserdata(pL,x);                //创建userdata，不需要释放了。
	int i;

	if(p==NULL){
		fprintf(stderr,"Byte_create:cannot malloc memory\n");
		return 1;
	}
	for(i=0;i<x;i++)
		p[i]=0;

	return 1;
}


int Byte_loadfile(lua_State *pL)
{
	char *p=(char *)lua_touserdata(pL,1);
	const char *filename=lua_tostring(pL,2);
	int start=(int)lua_tonumber(pL,3);
	int length=(int)lua_tonumber(pL,4);

 
    
	FILE *fp;
    if((fp=fopen(filename,"rb"))==NULL){
        fprintf(stderr,"Byte_loadfile:file not open ---%s",filename);
		
		return 1;
	}
	fseek(fp,start,SEEK_SET);
    fread(p,1,length,fp);
	fclose(fp);
	return 0;
}

int Byte_getfiletime(lua_State *pL){
	time_t clockticks = 0;
	const char *filename = lua_tostring(pL, 1);
	struct stat mstat;
	if (stat(filename, &mstat) == 0){
		clockticks = mstat.st_mtime;
	}
	lua_pushnumber(pL, (unsigned long)clockticks);
}
int Byte_savefile(lua_State *pL)
{
	char *p = (char *) lua_touserdata(pL, 1);
	const char *filename = lua_tostring(pL, 2);
	int start = (int) lua_tonumber(pL, 3);
	int length = (int) lua_tonumber(pL, 4);
	FILE *fp;

	if ((fp = fopen(filename, "r+b")) == NULL){
		fprintf(stderr, "file not open ---%s", filename);
		return 1;
	}
	fseek(fp, start, SEEK_SET);
	fwrite(p, 1, length, fp);
	fclose(fp);
	return 0;
}

int Config_GetPath(lua_State *pL)
{
	lua_pushstring(pL,JY_CurrentPath);
	return 1;
}

/*
int Byte_get8(lua_State *pL)
{
	short *p = (short *) lua_touserdata(pL, 1);
	int start = (int) lua_tonumber(pL, 2);
	char v;
	JYdecrypt(p + start, (char *) &v, 1);
	lua_pushnumber(pL, v);
	return 1;
}

int Byte_set8(lua_State *pL)
{
	short *p = (short *) lua_touserdata(pL, 1);
	int start = (int) lua_tonumber(pL, 2);
	char tmp = (char) lua_tonumber(pL, 3);
	JYencrypt((char *)&tmp, p + start, 1);
	return 0;
}
int Byte_get16(lua_State *pL)
{
	short *p = (short *) lua_touserdata(pL, 1);
	int start = (int) lua_tonumber(pL, 2);
	short v;
	JYdecrypt(p + start, (char *) &v, 2);
	lua_pushnumber(pL, v);
	return 1;
}

int Byte_set16(lua_State *pL)
{
	short *p = (short *) lua_touserdata(pL, 1);
	int start = (int) lua_tonumber(pL, 2);
	short tmp = (short) lua_tonumber(pL, 3);
	JYencrypt((char *)&tmp, p + start, 2);
	return 0;
}

int Byte_getu16(lua_State *pL)
{
	short *p = (short *) lua_touserdata(pL, 1);
	int start = (int) lua_tonumber(pL, 2);
	unsigned short v;
	JYdecrypt(p + start, (char *) &v, 2);
	lua_pushnumber(pL, v);
	return 1;
}

int Byte_setu16(lua_State *pL)
{
	short *p = (short *) lua_touserdata(pL, 1);
	int start = (int) lua_tonumber(pL, 2);
	unsigned short tmp = (unsigned short) lua_tonumber(pL, 3);
	JYencrypt((char *)&tmp, p + start, 2);
	return 0;

}

int Byte_get32(lua_State *pL)
{
	short *p = (short *) lua_touserdata(pL, 1);
	int start = (int) lua_tonumber(pL, 2);
	int v;
	JYdecrypt(p + start, (char*) &v, 4);
	lua_pushnumber(pL, v);
	return 1;
}

int Byte_set32(lua_State *pL)
{
	short *p = (short *) lua_touserdata(pL, 1);
	int start = (int) lua_tonumber(pL, 2);
	int tmp = (int) lua_tonumber(pL, 3);
	JYencrypt((char *)&tmp, p + start, 4);
	return 0;
}

int Byte_get64(lua_State *pL)
{
	short *p = (short *) lua_touserdata(pL, 1);
	int start = (int) lua_tonumber(pL, 2);
	long v;
	JYdecrypt(p + start, (char*) &v, 8);
	lua_pushnumber(pL, v);
	return 1;
}

int Byte_set64(lua_State *pL)
{
	short *p = (short *) lua_touserdata(pL, 1);
	int start = (int) lua_tonumber(pL, 2);
	long tmp = (long) lua_tonumber(pL, 3);
	JYencrypt((char *)&tmp, p + start, 8);
	return 0;
}

int Byte_getstr(lua_State *pL)
{
	short *p = (short *) lua_touserdata(pL, 1);
	int start = (int) lua_tonumber(pL, 2);
	int length = (int) lua_tonumber(pL, 3);
	char *s = (char*) malloc(length + 1);
	JYdecrypt(p + start, s, length);
	s[length] = '\0';
	lua_pushstring(pL, s);
	SafeFree(s);
	return 1;
}

int Byte_setstr(lua_State *pL)
{
	short *p = (short *) lua_touserdata(pL, 1);
	int start = (int) lua_tonumber(pL, 2);
	int length = (int) lua_tonumber(pL, 3);
	const char *s = lua_tostring(pL, 4);
	char *q = (char *) malloc(length);
	int i;
	int l = (int) strlen(s);
	for (i = 0; i<length; i++)
		q[i] = 0;
	JYencrypt(q, p + start, length);
	if (l>length) l = length;
	JYencrypt(s, p + start, l);

	lua_pushstring(pL, s);
	SafeFree(q);

	return 1;
}*/

int Byte_get8(lua_State *pL)
{
	char *p = (char *)lua_touserdata(pL, 1);
	int start = (int)lua_tonumber(pL, 2);

	short v = *(char*)(p + start);
	lua_pushnumber(pL, v);
	return 1;
}

int Byte_set8(lua_State *pL)
{
	char *p = (char *)lua_touserdata(pL, 1);
	int start = (int)lua_tonumber(pL, 2);
	char v = (char)lua_tonumber(pL, 3);
	*(char*)(p + start) = v;
	return 0;
}
int Byte_get16(lua_State *pL)
{
	char *p = (char *)lua_touserdata(pL, 1);
	int start = (int)lua_tonumber(pL, 2);

	short v = *(short*)(p + start);
	lua_pushnumber(pL, v);
	return 1;
}

int Byte_set16(lua_State *pL)
{
	char *p = (char *)lua_touserdata(pL, 1);
	int start = (int)lua_tonumber(pL, 2);
	short v = (short)lua_tonumber(pL, 3);
	*(short*)(p + start) = v;
	return 0;
}

int Byte_getu16(lua_State *pL)
{
	char *p = (char *)lua_touserdata(pL, 1);
	int start = (int)lua_tonumber(pL, 2);

	unsigned short v = *(unsigned short*)(p + start);
	lua_pushnumber(pL, v);
	return 1;
}

int Byte_setu16(lua_State *pL)
{
	char *p = (char *)lua_touserdata(pL, 1);
	int start = (int)lua_tonumber(pL, 2);
	unsigned short v = (unsigned short)lua_tonumber(pL, 3);
	*(unsigned short*)(p + start) = v;
	return 0;

}

int Byte_get32(lua_State *pL)
{
	char *p = (char *)lua_touserdata(pL, 1);
	int start = (int)lua_tonumber(pL, 2);

	int v = *(int*)(p + start);
	lua_pushnumber(pL, v);
	return 1;
}

int Byte_set32(lua_State *pL)
{
	char *p = (char *)lua_touserdata(pL, 1);
	int start = (int)lua_tonumber(pL, 2);
	int v = (int)lua_tonumber(pL, 3);
	*(int*)(p + start) = v;
	return 0;
}
int Byte_get64(lua_State *pL)
{
	char *p = (char *)lua_touserdata(pL, 1);
	int start = (int)lua_tonumber(pL, 2);

	long v = *(long*)(p + start);
	lua_pushnumber(pL, v);
	return 1;
}

int Byte_set64(lua_State *pL)
{
	char *p = (char *)lua_touserdata(pL, 1);
	int start = (int)lua_tonumber(pL, 2);
	long v = (int)lua_tonumber(pL, 3);
	*(long*)(p + start) = v;
	return 0;
}

int Byte_getstr(lua_State *pL)
{
	char *p = (char *)lua_touserdata(pL, 1);
	int start = (int)lua_tonumber(pL, 2);
	int length = (int)lua_tonumber(pL, 3);
	char *s = (char*)malloc(length + 1);
	int i;
	for (i = 0; i<length; i++)
		s[i] = p[start + i];

	s[length] = '\0';
	lua_pushstring(pL, s);
	SafeFree(s);
	return 1;
}

int Byte_setstr(lua_State *pL)
{
	char *p = (char *)lua_touserdata(pL, 1);
	int start = (int)lua_tonumber(pL, 2);
	int length = (int)lua_tonumber(pL, 3);
	const char *s = lua_tostring(pL, 4);
	int i;
	int l = (int)strlen(s);
	for (i = 0; i<length; i++)
		p[start + i] = 0;

	if (l>length) l = length;

	for (i = 0; i<l; i++)
		p[start + i] = s[i];


	lua_pushstring(pL, s);

	return 1;
}
int Byte_RSHash(lua_State *pL)
{
	char *p = (char *) lua_touserdata(pL, 1);
	int length = (int) lua_tonumber(pL, 2);
	int b = 378551;
	int a = 63689;
	int i;
	long hash = 0;
	for (i = 0; i < length; i++)
	{
		hash = hash*a + *(char*) (p + i);
		a = a*b;
	}
	lua_pushnumber(pL, hash);
	return 1;
}
int Byte_BKDHash(lua_State *pL)
{
	char *p = (char *) lua_touserdata(pL, 1);
	int length = (int) lua_tonumber(pL, 2);
	unsigned int seed = 1313; // 31 131 1313 13131 131313 etc..
	int i;
	unsigned int hash = 0;
	for (i = 0; i < length; i++)
	{
		hash = hash * seed + *(unsigned char*) (p + i);
		hash = hash & 0x7FFFFFFF;
	}
	lua_pushnumber(pL, hash);
	return 1;
}

void JYencrypt(char *s, short *d, int length)
{
	int i;
	short n;
	char tmp;
	char seed[32] =
	{
		(char) 9, (char) 137, (char) 78, (char) 87,
		(char) 139, (char) 219, (char) 52, (char) 98,
		(char) 239, (char) 109, (char) 129, (char) 235,
		(char) 7, (char) 179, (char) 176, (char) 248,
		(char) 4, (char) 32, (char) 223, (char) 18,
		(char) 79, (char) 68, (char) 97, (char) 30,
		(char) 49, (char) 77, (char) 70, (char) 3,
		(char) 40, (char) 100, (char) 101, (char) 189,
	};
	for (i = 0; i < length; i++)
	{
		n = (short) (rand() % 32);
		tmp = *(s + i) ^ seed[n];
		n += (rand() % 8) << 15;
		*(d + i) = (((short) (tmp)) << 5) | n;
	}
//	return 0;
}
void JYdecrypt(short *s, char *d, int length)
{
	char seed[32] =
	{
		(char) 9, (char) 137, (char) 78, (char) 87,
		(char) 139, (char) 219, (char) 52, (char) 98,
		(char) 239, (char) 109, (char) 129, (char) 235,
		(char) 7, (char) 179, (char) 176, (char) 248,
		(char) 4, (char) 32, (char) 223, (char) 18,
		(char) 79, (char) 68, (char) 97, (char) 30,
		(char) 49, (char) 77, (char) 70, (char) 3,
		(char) 40, (char) 100, (char) 101, (char) 189,
	};
	int i;
	short n;
	for (i = 0; i < length; i++)
	{
		n = *(s + i);
		*(d + i) = ((char) ((n & 8160) >> 5)) ^ (seed[n & 31]);
	}
}
