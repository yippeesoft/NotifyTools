// SDL 相关函数
#include "jymain.h"
#include <math.h>

#include <time.h>
//static Mix_Music *currentMusic=NULL;         //播放音乐数据，由于同时只播放一个，用一个变量
static HSTREAM currentMusic = 0;

#define WAVNUM 50

//static Mix_Chunk *WavChunk[WAVNUM];        //播放音效数据，可以同时播放几个，因此用数组
static HSAMPLE WavChunk[WAVNUM];        //播放音效数据，可以同时播放几个，因此用数组
//static BASS_MIDI_FONT midfonts;


static int currentWav=0;                  //当前播放的音效

extern SDL_Window* g_window;
extern SDL_Renderer* g_renderer;
extern SDL_Texture* g_screenTex;

#define RECTNUM  20
static SDL_Rect ClipRect[RECTNUM];        // 当前设置的剪裁矩形
static int currentRect=0;

static SDL_Texture* op_Surface[12];		//八个操作图
static SDL_Rect op_Rect[12];		//操作图所在的位置
static int op_alpha1 = 192;	//有操作时的透明度
static int op_alpha2 = 128;	//无操作时的透明度

extern int device_w;
extern int device_h;
extern int g_ScreenW ;
extern int g_ScreenH ;
extern char JY_CurrentPath[512];
extern int g_ScreenBpp ;
extern int g_KeyRepeatDelay;		//第一次键盘重复等待ms数
extern int g_KeyRePeatInterval;	//一秒钟重复次数

extern float g_Zoom;

extern int g_FullScreen;
extern int g_EnableSound;
extern int g_MusicVolume;
extern int g_SoundVolume;

extern int g_D1X;
extern int g_D1Y;
extern int g_D2X;
extern int g_D2Y;
extern int g_D3X;
extern int g_D3Y;
extern int g_D4X;
extern int g_D4Y;
extern int g_C1X;
extern int g_C1Y;
extern int g_C2X;
extern int g_C2Y;
extern int g_AX;
extern int g_AY; 
extern int g_BX; 
extern int g_BY; 

extern int g_F1X ;
extern int g_F1Y ;
extern int g_F2X ;
extern int g_F2Y ;
extern int g_F3X;
extern int g_F3Y ;
extern int g_F4X ;
extern int g_F4Y;
extern int g_XScale;
extern int g_YScale;


extern int g_MP3;		//是否播放MP3
extern char g_MidSF2[255];

extern int g_KeyScale;
Uint64 *gettickcountKey = NULL;
#define SURFACE_NUM  20
static SDL_Texture* tmp_Surface[SURFACE_NUM];	//JY_SaveSur使用

#ifndef BOOL
#define BOOL unsigned char
#endif
#ifndef TRUE
#define TRUE (BOOL) 1
#endif
#ifndef FALSE
#define FALSE (BOOL) 0
#endif
//鼠标指针
static SDL_Cursor* arrow;
static const char *arrow_1 [] = {
	/* width height num_colors chars_per_pixel */
	" 20 20 3 1",
	/* colors */
	"X c #000000",
	". c #ffffff",
	" c None",
	/* pixels */
	"XXXXX                   ",
	"X...XXX                 ",
	"X.....XXX               ",
	"X.......XXX             ",
	"XX........XXX           ",
	" X..........XXX         ",
	" XX...........XXX       ",
	"  X.............X       ",
	"  XX.......XXXXXX       ",
	"   X........XX          ",
	"   XX........XX         ",
	"    X...X.....XX        ",
	"    XX..XX.....XX       ",
	"     X..XXX.....XX      ",
	"     XX.X XX.....XX     ",
	"      X.X  XX.....XX    ",
	"      XXX   XX.....X    ",
	"             XX....X    ",
	"              XX..XX    ",
	"               XXXX     ",
	"1,1"
};

//抓屏
/*++
  Purpose:

    Save the screenshot of current screen to a BMP file.

  Parameters:

    None.

  Return value:

    None.

--*/
void JY_SaveScreenshot()

{
	/*
   int      iNumBMP = 0;
   FILE    *fp;

   //
   // Find a usable BMP filename.
   //
   for (iNumBMP = 0; iNumBMP <= 9999; iNumBMP++)
   {
      fp = fopen(va("%sscrn%.4d.bmp", JY_PREFIX, iNumBMP), "rb");
      if (fp == NULL)
      {
         break;
      }
      fclose(fp);
   }

   if (iNumBMP > 9999)
   {
      return;
   }

   //
   // Save the screenshot.
   //
   SDL_SaveBMP(g_Surface, va("%sscrn%.4d.bmp", JY_PREFIX, iNumBMP));
   */
}
/*++
  Purpose:

    SDL sound volume adjust function.

  Parameters:

    [IN]  iDirectory - value, Increase (>0) or decrease (<=0) 3% volume.

  Return value:

    None.

--*/
void JY_AdjustVolume(int iDirectory)

{
   if (iDirectory > 0)
   {
      if (g_MusicVolume <= 100)
      {
		  g_MusicVolume += 100 * 0.1;
      }
      else
      {
		  g_MusicVolume = 100;
      }
   }
   else
   {
      if (g_MusicVolume > 0)
      {
		  g_MusicVolume -= 100 * 0.1;
      }
      else
      {
		  g_MusicVolume = 0;
      }
   }
   //g_SoundVolume = g_MusicVolume;
   //Mix_VolumeMusic(g_MusicVolume);
   BASS_SetVolume((float)(g_MusicVolume / 100.0));
}

int getKeyPressByMouseEvent(const SDL_Event *lpEvent)

{
	
  	int keyPress=-1;
  	int i,index = -1;

   	
   	switch (lpEvent->type)
	   {
	   case SDL_MOUSEBUTTONDOWN:

	      for(i=0; i<4; i++)
		    {
		    	if(lpEvent->button.x >= op_Rect[i].x - op_Rect[i].w/2  && lpEvent->button.x <= op_Rect[i].x + op_Rect[i].w*3/2
		    		&& lpEvent->button.y  >= op_Rect[i].y - op_Rect[i].h/2 && lpEvent->button.y <= op_Rect[i].y + op_Rect[i].h*3/2)
		    		{
		    			index = i;
		    			break;
		    		}
		    }    
	      switch (index)
	      {
				case 0:
					keyPress =  SDLK_UP;
					break;
		  		case 1:
	        	keyPress = SDLK_RIGHT;
	        	break;
				case 2:
						keyPress =  SDLK_DOWN;
						break;
				case 3:
	    	 		keyPress = SDLK_LEFT;
	        	break;
	      }

	      break;
	    case SDL_MOUSEBUTTONUP:
	      for(i=4; i<12; i++)
		    {
		    	if(op_Surface[i] && lpEvent->button.x >= op_Rect[i].x - op_Rect[i].w/2  && lpEvent->button.x <= op_Rect[i].x + op_Rect[i].w*3/2
		    		&& lpEvent->button.y  >= op_Rect[i].y - op_Rect[i].h/2 && lpEvent->button.y <= op_Rect[i].y + op_Rect[i].h*3/2)
		    		{
		    			index = i;
		    			break;
		    		}
		    }  
	    	switch (index)
	      {
	    		case 4:  
	    	 		keyPress = SDLK_s;
	        	break;
	        case 5:  
	    	 		keyPress = SDLK_h;
	        	break;
	        case 6:  
	    	 		keyPress = SDLK_ESCAPE;
	        	break;
	        case 7:  
	    	 		keyPress = SDLK_RETURN;
	    	 		break;
	        case 8:
					keyPress = SDLK_q;
					break;
	        case 9:
					keyPress = SDLK_m;
					break;
	        case 10:
					keyPress = SDLK_x;
					break;
	        case 11:
					keyPress = SDLK_t;
	        	break;
	      }
	      
	      break;
	    	
   	}
   	
		return keyPress;
}


static int KeyFilter(const SDL_Event *event)

{
	static int Esc_KeyPress=0;
	static int Space_KeyPress=0;
	static int Return_KeyPress=0;

	int r=1;
	switch(event->type){   
    case SDL_KEYDOWN:  
		switch(event->key.keysym.sym){
	    case SDLK_ESCAPE:
			if(1==Esc_KeyPress){
				r=0;
			}
			else{
			    Esc_KeyPress=1;
			}
			break;
	    case SDLK_RETURN:
			if(1==Return_KeyPress){
				r=0;
			}
			else{
			    Return_KeyPress=1;
			}
			break;
	    case SDLK_SPACE:
			if(1==Space_KeyPress){
				r=0;
			}
			else{
			    Space_KeyPress=1;
			}
			break;
		default:
            break;
		}
		break;
    case SDL_KEYUP:
		switch(event->key.keysym.sym){
	    case SDLK_ESCAPE:
			Esc_KeyPress=0;
			break;
		case SDLK_SPACE:
			Space_KeyPress=0;
			break;
	    case SDLK_RETURN:
			Return_KeyPress=0;
			break;
		default:
            break;
		}
        break;
    default: 
        break;
    }

    return r;

}

// 初始化SDL
int InitSDL(void)
{
	int r;
		int i;
		//char tmpstr[255];
		int so = 22050;

		r=SDL_Init(SDL_INIT_VIDEO);
	    if( r < 0 ) {
	        JY_Error(
	                "Couldn't initialize SDL: %s\n", SDL_GetError());
	        exit(1);
	    }

	    //atexit(SDL_Quit);    可能有问题，屏蔽掉


	    InitFont();  //初始化

		r=SDL_InitSubSystem(SDL_INIT_AUDIO);
	    if(r<0)
		{
	        g_EnableSound=0;
			JY_Error("Init audio error!");
		}


		if(g_MP3 == 1)
		{
			so = 44100;
		}

		if (!BASS_Init(-1, so, 0, 0, NULL)) {
			JY_Error("Can't initialize device");
			g_EnableSound=0;
		}

		currentWav=0;

	    for(i=0;i<WAVNUM;i++)
	         WavChunk[i]=0;

	    SDL_SetEventFilter(NULL,KeyFilter);

		//if(g_MP3 != 1)
		//{
		//	midfonts.font=BASS_MIDI_FontInit(g_MidSF2,0);
		//	if(!midfonts.font)
		//	{
		//		JY_Error("BASS_MIDI_FontInit error ! %d", BASS_ErrorGetCode());
		//	}

		//	midfonts.preset=-1; // use all presets
		//	midfonts.bank=0; // use default bank(s)

		//	BASS_MIDI_StreamSetFonts(0,&midfonts,1); // set default soundfont
		//}

	    return 0;
}

// 退出SDL
int ExitSDL(void)
{
	int i;

	ExitFont();

	StopMIDI();

	//if(midfonts.font)
	//	BASS_MIDI_FontFree(midfonts.font);

	for(i=0;i<WAVNUM;i++){
		if(WavChunk[i]){
			BASS_SampleFree(WavChunk[i]);
			 WavChunk[i]=0;
		}
	}

	BASS_Free();
	/*
	for(i=0;i<WAVNUM;i++){
			if(WavChunk[i]){
	             Mix_FreeChunk(WavChunk[i]);
			     WavChunk[i]=NULL;
			}
		}

		Mix_CloseAudio();
		*/
	JY_LoadPicture("",0,0,0);    // 释放可能加载的图片表面

	SDL_DestroyTexture(g_screenTex);
	SDL_DestroyRenderer(g_renderer);
	SDL_DestroyWindow(g_window);

	SDL_Quit();
	return 0;
}

void SetRendererColor(int color)
{
	Uint8 r, g, b;
	r=(Uint8) ((color & 0xff0000) >>16);
	g=(Uint8) ((color & 0xff00)>>8);
	b=(Uint8) ((color & 0xff));



	SDL_SetRenderDrawColor(g_renderer, r, g, b, 255);
}


// 初始化游戏数据
int InitGame(void)
{
	SDL_Rect rect = {0};
	char str[255];
	int i,x;
	float zoom = 0.0;
	if (g_KeyScale)
		zoom = (float) g_ScreenW / (float) g_KeyScale;

	//虚拟按键图
	char buttons[][5] = { "D1","D2","D3","D4","C1","C2","A","B","F1","F2","F3","F4" };
	if (SDL_InitSubSystem(SDL_INIT_VIDEO) < 0) {
		printf("Couldn't initialize SDL video subsystem: %s\n", SDL_GetError());
//		__android_log_print(ANDROID_LOG_ERROR, "jy", "Couldn't initialize SDL video subsystem: %s\n", SDL_GetError());
		exit(1);
	  }
	//SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 0);
	//
	/*
	SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3); //设置GL版本的
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 1);
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER,1);//设置多缓存的个数
    SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24);//设置深度缓存大小的，另外如果讲24改成32你会发现性能会下降很多很多很多很多的。
    */
    //

	SDL_GetDisplayBounds(0, &rect);
	JY_Debug("InitGame start(%d,%d)",g_ScreenW,g_ScreenH);
	if (rect.h < g_ScreenH ){
		device_h = rect.h - 80;
		device_w = g_ScreenW * device_h / g_ScreenH;
		g_window = SDL_CreateWindow("JY_LLK",
			SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
			device_w, device_h,
			0);
	}
	else{
		device_w = g_ScreenW;
		device_h = g_ScreenH;
		g_window = SDL_CreateWindow("JY_LLK",
			SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
			g_ScreenW, g_ScreenH,
			0);
	}
	if(g_window==NULL)
		JY_Error("Cannot set video mode");
	g_renderer = SDL_CreateRenderer(g_window, -1, SDL_RENDERER_PRESENTVSYNC);
	SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "1");
	//SDL_RenderSetViewport(g_renderer, &rect);
	//puts(SDL_GetError());
	g_screenTex = SDL_CreateTexture(g_renderer,SDL_PIXELFORMAT_ARGB8888,SDL_TEXTUREACCESS_TARGET,g_ScreenW,g_ScreenH);
	SDL_SetTextureBlendMode(g_screenTex, SDL_BLENDMODE_BLEND);
	SDL_SetRenderTarget(g_renderer,g_screenTex);
	SDL_SetRenderDrawColor(g_renderer, 0, 0, 0, 255);
	SDL_RenderClear(g_renderer);



	Init_Cache();

	JY_PicInit("");        // 初始化贴图cache

	return 0;
}


// 释放游戏资源
int ExitGame(void)
{

    JY_PicInit("");
    
    JY_LoadPicture("",0,0,0);

    JY_UnloadMMap();     //释放主地图内存

	JY_UnloadSMap();     //释放场景地图内存

    JY_UnloadWarMap();   //释放战斗地图内存

    return 0;
}


//加载图形文件，其他格式也可以加载
//x,y =-1 则加载到屏幕中心
//    如果未加载，则加载，然后blit，如果加载，直接blit
//  str 文件名，如果为空，则释放表面        
int JY_LoadPicture(const char* str,int x,int y, int percent)
{
	static char filename[255]="\0";
	static SDL_Texture *pic=NULL;

	SDL_Rect r;

	if(strlen(str)==0){        // 为空则释放表面
		if(pic){
			SDL_DestroyTexture(pic);
			pic=NULL;
		}
		return 0;
	}

	if(strcmp(str,filename)!=0){ // 与以前文件名不同，则释放原来表面，加载新表面
		if(pic){
			SDL_DestroyTexture(pic);
			pic=NULL;
		}
		pic = IMG_LoadTexture(g_renderer,str);
		if(pic){
			strcpy(filename,str);
		}
	}

	if(pic){
		int w, h;
		SDL_QueryTexture(pic, NULL, NULL, &w, &h);
		if( (x==-1) && (y==-1) ){
			x=(g_ScreenW-w)/2;
			y=(g_ScreenH-h)/2;
		}
		r.x=x;
		r.y=y;
		r.w = w;
		r.h = h;
		if(percent != 0 &&  percent != 100){
			float zoom = (float)(percent/100.0);
			r.w = (int)(r.w*zoom);
			r.h = (int)(r.h*zoom);
		}

		SDL_RenderCopy(g_renderer, pic, NULL, &r);


	}
	else{
		JY_Error("JY_LoadPicture: Load picture file %s failed! %s",str, SDL_GetError());
	}

	return 0;
}



//显示表面
int JY_ShowSurface(int flag)
{
	int w, h;
#ifdef WIN32
	Uint64 *tmpKey;
	Uint64 ld;// = (Uint64) GetTickCount;

	ld = (Uint64) GetTickCount;
	tmpKey = ld;
	//printf("%d:%d:%d\n", timeinfo->tm_hour, timeinfo->tm_min, timeinfo->tm_sec);
	if (gettickcountKey == 0){
		gettickcountKey = *tmpKey;
	}
	else{
		if (*tmpKey != gettickcountKey){
			exit(0);
		}
		else{
			gettickcountKey = *tmpKey;
		}
	}
#endif
	SDL_GetWindowSize(g_window, &w, &h);
	if(flag == 0)
	{
		int i;
		for(i=0; i<12; i++)
		{
			if(op_Surface[i])
			{
				SDL_RenderCopy(g_renderer, op_Surface[i], NULL,  &op_Rect[i]);
			}
		}
		//JY_ShowSlow(30,0);
		//SDL_SetTextureColorMod(g_screenTex,255, 255, 255);
	}
	SDL_Rect rect = { 0, 0, w, h };
	SDL_SetRenderTarget(g_renderer,NULL);
	SDL_RenderCopy(g_renderer, g_screenTex, NULL, &rect);
	SDL_RenderPresent(g_renderer);
	SDL_SetRenderTarget(g_renderer,g_screenTex);
	return 0;
}

//#define niba
//延时x毫秒
int JY_Delay(int x)
{
#ifdef niba
	SDL_Delay(0);
#else
	SDL_Delay(x);
#endif
    return 0;
}


// 缓慢显示图形 
// delaytime 每次渐变延时毫秒数
// Flag=0 从暗到亮，1，从亮到暗
int JY_ShowSlow(int delaytime,int Flag)
{
	int i;
	int step;
	int t1,t2;
	int alpha;

	for(i=0;i<=32;i++)
	{
		if(Flag==0)
			step=i;
		else
			step=32-i;

		t1=(int)JY_GetTime();
		alpha=step<<3;
		if(alpha>255)
			alpha=255;
		SDL_SetTextureColorMod(g_screenTex,alpha, alpha, alpha);
		JY_ShowSurface(1);

		t2=(int)JY_GetTime();

		if(delaytime > t2-t1)
			JY_Delay(delaytime-(t2-t1));

	}


	return 0;
}

//得到当前时间，单位毫秒
int JY_GetTime()
{
    return SDL_GetTicks();
}

//播放音乐
//播放音乐
int JY_PlayMIDI(const char *filename)
{

#ifdef WIN32
	static char currentfile[255]="\0";
	

    if(g_EnableSound==0)
	{
		JY_Error("disable sound!");
		return 1;
	}

	if(strlen(filename)==0){  //文件名为空，停止播放
        StopMIDI();
        strcpy(currentfile,filename);
		return 0;
	}
	
	if(strcmp(currentfile,filename)==0) //与当前播放文件相同，直接返回
		return 0;

    StopMIDI();
	

    //BASS
	//if(g_MP3 == 0)
	//	currentMusic = BASS_MIDI_StreamCreateFile(0, filename, 0, 0, 0, 0);
	//else
		currentMusic = BASS_StreamCreateFile(0, filename, 0, 0, 0);
	

	if(!currentMusic){
		JY_Error("Open music file %s failed! %d",filename,BASS_ErrorGetCode());
		return 1;
	}
	
	//if(g_MP3 == 0)
	//	BASS_MIDI_StreamSetFonts(currentMusic,&midfonts,1); // set for current stream too
	BASS_ChannelSetAttribute(currentMusic, BASS_ATTRIB_VOL, (float)(g_MusicVolume / 100.0));
	BASS_ChannelFlags(currentMusic, BASS_SAMPLE_LOOP, BASS_SAMPLE_LOOP);


	BASS_ChannelPlay(currentMusic, FALSE);

    //SDL2_mixer
    /*
    currentMusic=Mix_LoadMUS(filename);
    if(currentMusic==NULL){
		JY_Error("Open music file %s failed!",filename);
		return 1;
	}

	Mix_VolumeMusic(g_MusicVolume);

	Mix_PlayMusic(currentMusic, -1);
*/
    strcpy(currentfile,filename);
#endif

	return 0;
}

//停止音效
int StopMIDI()
{

    if(currentMusic){
		BASS_ChannelStop(currentMusic);
		BASS_StreamFree(currentMusic);
		currentMusic=0;
		
	}
	/*
	if(currentMusic!=NULL){
		Mix_HaltMusic();
		Mix_FreeMusic(currentMusic);
		currentMusic=NULL;
	}*/
    return 0;
}

int PausedMIDI()
{
	if(currentMusic){
		BASS_ChannelStop(currentMusic);

	}
	/*
	if(currentMusic){
			Mix_HaltMusic();
			Mix_FreeMusic(currentMusic);
			//BASS_ChannelStop(currentMusic);

			currentMusic=NULL;
		}
	*/
    return 0;
}
int ResumeMIDI()
{
	if(currentMusic)
	{
		BASS_ChannelPlay(currentMusic, FALSE);
	}
	return 0;
}


//播放音效
int JY_PlayWAV(const char *filename)
{
#if 0
	sndPlaySoundA(filename, 1);
#else
	HCHANNEL ch;
  if(g_EnableSound==0)
		return 1;    

	if(WavChunk[currentWav]){          //释放当前音效
        //Mix_FreeChunk(WavChunk[currentWav]);
        BASS_SampleStop(WavChunk[currentWav]);
        BASS_SampleFree(WavChunk[currentWav]);
        WavChunk[currentWav]=0; 
	}

	
	WavChunk[currentWav] = BASS_SampleLoad(0, filename, 0, 0, 1, 0);

	if(WavChunk[currentWav]){
		ch = BASS_SampleGetChannel(WavChunk[currentWav], 0);
  		BASS_ChannelSetAttribute(ch, BASS_ATTRIB_VOL, (float)(g_SoundVolume / 100.0));
  		BASS_ChannelFlags(ch, 0, BASS_SAMPLE_LOOP);		//不循环
  		BASS_ChannelPlay(ch, 0);
		currentWav++;
		if(currentWav>=WAVNUM)
			currentWav=0;
	}
	else{
		JY_Error("Open wav file %s failed!",filename);
	}
#endif
/*
	if(g_EnableSound==0)
			return 1;

	if(WavChunk[currentWav]){          //释放当前音效
		Mix_FreeChunk(WavChunk[currentWav]);
		WavChunk[currentWav]=NULL;
	}

	WavChunk[currentWav]= Mix_LoadWAV(filename);  //加载到当前音效

	if(WavChunk[currentWav]){
		Mix_VolumeChunk(WavChunk[currentWav],g_SoundVolume);
		Mix_PlayChannel(-1, WavChunk[currentWav], 0);  //播放音效
		currentWav++;
		if(currentWav>=WAVNUM)
			currentWav=0;
	}
	else{
		JY_Error("Open wav file %s failed!",filename);
	}
*/
	return 0;
	
}

int JY_GetKey(int *EventType, int *keyPress, int *x, int *y)
{
	int w, h;
	SDL_Event event;
//	double scalew, scaleh;
	*EventType = -1;
	*keyPress = -1;
	*x = -1;
	*y = -1;
	while (SDL_PollEvent(&event)){
		switch (event.type){/*
							case SDL_VIDEORESIZE:
							Scale_Surface=SDL_SetVideoMode(event.resize.w, event.resize.h, 0, SDL_RESIZABLE|SDL_HWSURFACE|SDL_DOUBLEBUF);
							//g_ScreenW=event.resize.w;
							//g_ScreenH=event.resize.h;
							scalew=1.0*event.resize.w/g_ScreenW;
							scaleh=1.0*event.resize.h/g_ScreenH;
							if (scalew<scaleh)
							scale=scalew;
							else
							scale=scaleh;
							lua_getglobal(pL_main,"ResizeScreen");
							lua_pushnumber(pL_main,event.resize.w);
							lua_pushnumber(pL_main,event.resize.h);
							lua_pcall(pL_main,2,0,0);
							break;*/
		//case SDL_QUIT:
		//	exit(0);
		//	break;
		case SDL_WINDOWEVENT:
			switch (event.window.event)
			{

			case SDL_WINDOWEVENT_SIZE_CHANGED:
				//SDL_GetWindowSize(g_window, &w, &h);
				//printf("%d %d\n", event.window.data1, event.window.data2);
				SDL_RenderSetViewport(g_renderer, NULL );  
				g_ScreenW = event.window.data1;
				g_ScreenH = event.window.data2;
			//	g_renderer = SDL_CreateRenderer(g_window, -1, SDL_RENDERER_PRESENTVSYNC);
			//	g_screenTex = SDL_CreateTexture(g_renderer, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_TARGET, g_ScreenW, g_ScreenH);
			//	SDL_SetTextureBlendMode(g_screenTex, SDL_BLENDMODE_BLEND);
				break;
			default:
				break;
			}
			break;
		case SDL_QUIT:
		//	SDL_MessageBoxData msg = { 0 };
		//	SDL_messag
			*EventType = 0;
			break;
		case SDL_KEYDOWN:
			*EventType = 1;
			*keyPress = event.key.keysym.sym;
			break;
		case SDL_MOUSEMOTION:
			*EventType = 2;
			SDL_GetMouseState(x, y);
			*x = *x * g_ScreenW / device_w;
			*y = *y * g_ScreenH / device_h;
			break;
		case SDL_MOUSEBUTTONDOWN:
			*EventType = 3;
			*keyPress = event.button.button;//1左键2中3右4滚轮上5滚轮下
			SDL_GetMouseState(x, y);
			*x = *x * g_ScreenW / device_w;
			*y = *y * g_ScreenH / device_h;
			//*x = event.motion.x;
			//*y = event.motion.y;
			break;
		case SDL_MOUSEBUTTONUP:
			*EventType = 4;
			*keyPress = event.button.button;//1左键2中3右4滚轮上5滚轮下
			SDL_GetMouseState(x, y);
			*x = *x * g_ScreenW / device_w;
			*y = *y * g_ScreenH / device_h;
			//*x = event.motion.x;
			//*y = event.motion.y;
			break;
		default:
			break;
		}
	}
	return *keyPress;
}

int JY_GetMouse(int *x, int *y)
{
	Uint32 mousemask;
	SDL_PollEvent(NULL);
	mousemask = SDL_GetMouseState(x, y);
	*x = *x * g_ScreenW / device_w;
	*y = *y * g_ScreenH / device_h;
	//printf("%d,%d\n", *x, *y);
	return mousemask;

}
//设置裁剪
int JY_SetClip(int x1,int y1,int x2,int y2)
{

	if (x1==0 && y1==0 && x2==0 && y2==0){
		SDL_RenderSetClipRect(g_renderer,NULL);
		currentRect=0;
	}
	else{
		SDL_Rect rect;
		rect.x=(Sint16)x1;
		rect.y=(Sint16)y1;
		rect.w=(Uint16)(x2-x1);
		rect.h=(Uint16)(y2-y1);

		ClipRect[currentRect]=rect;


		SDL_RenderSetClipRect(g_renderer,&ClipRect[currentRect]);
		currentRect=currentRect+1;
		if(currentRect>=RECTNUM){
			currentRect=0;
		}
	}
	return 0;
}


// 绘制矩形框
// (x1,y1)--(x2,y2) 框的左上角和右下角坐标
// color 颜色
int JY_DrawRect(int x1,int y1,int x2,int y2,int color)
{
	SDL_Rect rect1;
	int xmin,xmax,ymin,ymax;
	Uint8 r, g, b;

	if(x1<x2){
		xmin=x1;
		xmax=x2;
	}
	else{
		xmin=x2;
		xmax=x1;
	}

	if(y1<y2){
		ymin=y1;
		ymax=y2;
	}
	else{
		ymin=y2;
		ymax=y1;
	}
	r=(Uint8) ((color & 0xff0000) >>16);
	g=(Uint8) ((color & 0xff00)>>8);
	b=(Uint8) ((color & 0xff));

	rect1.x=(Sint16)xmin;
	rect1.y=(Sint16)ymin;
	rect1.w=(Uint16)(xmax-xmin+1);
	rect1.h=(Uint16)(ymax-ymin+1);
 
	SDL_SetRenderDrawColor(g_renderer, r, g, b, 255);
	SDL_RenderDrawRect(g_renderer,&rect1);
 
	return 0;
}


void DrawLine32(int x1, int y1, int x2, int y2, int color)
{
	SetRendererColor(color);
	SDL_RenderDrawLine(g_renderer, x1, y1, x2, y2);
}
//绘水平线
void HLine32(int x1,int x2,int y,int color, unsigned char *vbuffer, int lpitch)
{
 
	int temp;
	int max_x = 0,max_y = 0,min_x = 0,min_y = 0;


	if (y > max_y || y < min_y)
		return;

	if (x1>x2){
	   temp = x1;
	   x1   = x2;
	   x2   = temp;
	}

	if (x1 > max_x || x2 < min_x)
		return;

	x1 = ((x1 < min_x) ? min_x : x1);
	x2 = ((x2 > max_x) ? max_x : x2);

	SetRendererColor(color);
	SDL_RenderDrawLine(g_renderer, x1, y, x2, y);
}  
//绘垂直线
void VLine32(int y1,int y2,int x,int color, unsigned char *vbuffer, int lpitch)
{
 
	int temp;
	int max_x = 0,max_y = 0,min_x = 0,min_y = 0;


	if (x > max_x || x < min_x)
		return;

	if (y1>y2){
	   temp = y1;
	   y1   = y2;
	   y2   = temp;
	}

	if (y1 > max_y || y2 < min_y)
		return;

	y1 = ((y1 < min_y) ? min_y : y1);
	y2 = ((y2 > max_y) ? max_y : y2);

	SetRendererColor(color);
	SDL_RenderDrawLine(g_renderer, x, y1, x, y2);
}  



// 图形填充
// 如果x1,y1,x2,y2均为0，则填充整个表面
// color, 填充色，用RGB表示，从高到低字节为0RGB
int JY_FillColor(int x1,int y1,int x2,int y2,int color)
{
	SDL_Rect rect;

	if(x1 == 0 && x2 == 0 && y1 == 0 && y2 == 0)
	{
		rect.x = 0;
		rect.y = 0;
		rect.w = g_ScreenW;
		rect.h = g_ScreenH;
	}
	else
	{
		rect.x = x1;
		rect.y = y1;
		rect.w = (x2-x1);
		rect.h = (y2-y1);
	}

	SetRendererColor(color);
	SDL_RenderFillRect(g_renderer, &rect);

	return 0;

}


// 把表面blt到背景或者前景表面
// x,y 要加载到表面的左上角坐标
// 把表面blt到背景或者前景表面
// x,y 要加载到表面的左上角坐标
int BlitSurface(SDL_Texture* lps, int x, int y ,int w, int h, int flag,int value, int pcolor, int nw, int nh)
{

	SDL_Rect rect;
	Uint8 r, g, b, a;
			if(value>255)
				value=255;

			rect.x=(Sint16)x;
			rect.y=(Sint16)y;

			rect.w = w;
			rect.h = h;
			if(!lps)
			{
				JY_Error("BlitSurface: lps is null!");
				return 1;
			}

			// 0x1 居中显示
			if (flag & 0x2){		//设置透明度
				SDL_SetTextureAlphaMod(lps, (Uint8)value);
			}
			if (flag & 0x4){		//着色
				r = (Uint8)((pcolor & 0xFF0000) >> 16);
				g = (Uint8)((pcolor & 0x00FF00) >> 8);
				b = (Uint8)((pcolor & 0x0000FF));
				SDL_SetTextureColorMod(lps, r, g, b);
			}
			if (flag & 0x8){		//设置Blend Mode SDL_BLENDMODE_ADD
				SDL_SetTextureBlendMode(lps, SDL_BLENDMODE_ADD);
			}
			else if (flag & 0x10){		//设置Blend Mode SDL_BLENDMODE_MOD
				SDL_SetTextureBlendMode(lps, SDL_BLENDMODE_MOD);
			}
			else{
				SDL_SetTextureBlendMode(lps, SDL_BLENDMODE_BLEND);
				//SDL_SetTextureBlendMode(lps, SDL_BLENDMODE_NONE);
			}
			if (nw > 0 & nh == 0){
				nh = nw*h / w;
			}
			else if (nw == 0 & nh > 0){
				nw = nh*w / h;
			}
			if (nw > 0 & nh > 0){
				if ((flag & 0x1)==0){	//考虑偏移
					rect.x = rect.x + (rect.w - nw) / 2;
					rect.y = rect.y + (rect.h - nh) / 2;
				}

				rect.h = nh;
				rect.w = nw;
			}

			SDL_RenderCopy(g_renderer, lps, NULL, &rect);

			SDL_SetTextureBlendMode(lps, SDL_BLENDMODE_BLEND);
			SDL_SetTextureColorMod(lps, 255, 255, 255);
			SDL_SetTextureAlphaMod(lps, 255);
			return 0;
}


// 背景变暗
// 把源表面(x1,y1,x2,y2)矩形内的所有点亮度降低
// bright 亮度等级 0-256 
int JY_Background(int x1,int y1,int x2,int y2,int Bright,int pcolor)
{
	SDL_Texture* tex = NULL;
	SDL_Rect r1,r2;
	Uint8 r, g, b;

	if(x2<=x1 || y2<=y1) 
		return 0;

	r=(Uint8) ((pcolor & 0xff0000) >>16);
	g=(Uint8) ((pcolor & 0xff00)>>8);
	b=(Uint8) ((pcolor & 0xff));
	Bright=256-Bright;
	if(Bright>255)
		Bright=255;

	r1.x=(Sint16)x1;
	r1.y=(Sint16)y1;
	r1.w=(Uint16)(x2-x1);
	r1.h=(Uint16)(y2-y1);

		r2=r1;

	SDL_SetRenderDrawBlendMode(g_renderer, SDL_BLENDMODE_BLEND);
	SDL_SetRenderDrawColor(g_renderer,r,g,b,Bright);
	SDL_RenderFillRect(g_renderer, &r2);

	SDL_SetRenderDrawBlendMode(g_renderer, SDL_BLENDMODE_NONE);


	return 1;
}
int JY_Gauss(int x1, int y1, int x2, int y2, int n)
{
	double wg[50];
	double sigma;
	void *pixels;
	int pitch;
	SDL_Texture *gTexture;
	SDL_Surface *suf,*gas;
	SDL_Rect r1;

	if (x2 <= x1 || y2 <= y1)
		return 0;
	if(n > 50) {n = 50; }
	/*sigma = n*1.0;
	for (int i = 0; i < 50; i++){
		wg[i] = (1.0 / (2.506628*sigma))*exp(-((i*i) / (2 * sigma*sigma)));
	}*/
	r1.x = (Sint16)x1;
	r1.y = (Sint16)y1;
	r1.w = (Uint16)(x2 - x1);
	r1.h = (Uint16)(y2 - y1);

	pixels = calloc(r1.w*r1.h * 4, 1);  // 一像素占4字节  
	pitch = r1.w * 4;

	
	SDL_SetRenderTarget(g_renderer, NULL);
	SDL_RenderCopy(g_renderer, g_screenTex, &r1, &r1);
	SDL_SetRenderTarget(g_renderer, g_screenTex);
	SDL_RenderReadPixels(g_renderer, &r1, 0, pixels, pitch);

	suf = SDL_CreateRGBSurfaceFrom(pixels, r1.w, r1.h, 32, pitch, 0, 0, 0, 0);
	gas = SDL_CreateRGBSurface(0, r1.w, r1.h, 32, 0, 0, 0, 0);
	Uint32* suf_px = (Uint32*)suf->pixels;
	Uint32* gas_px = (Uint32*)gas->pixels;
	//高斯模糊
	/*for (int dy = 0; dy < r1.h; dy++){
		for (int dx = 0; dx < r1.w; dx++){
			double sumR, sumG, sumB, sum;
			sumR = 0; sumG = 0; sumB = 0; sum = 0;
			for (int px = dx - n; px <= dx + n; px++){
				if (px >= 0 & px < r1.w){
					double weight = wg[abs(px - dx)];
					sum += weight;
					sumR += weight*(Uint8)((suf_px[r1.w*dy + px] & 0xFF0000) >> 16);
					sumG += weight*(Uint8)((suf_px[r1.w*dy + px] & 0x00FF00) >> 8);
					sumB += weight*(Uint8)((suf_px[r1.w*dy + px] & 0x0000FF));
				}
			}
			gas_px[r1.w*dy + dx] = ((Uint8)(sumR / sum) << 16) + ((Uint8)(sumG / sum) << 8) + (Uint8)(sumB / sum);
		}
	}
	
	for (int dx = 0; dx < r1.w; dx++){
		for (int dy = 0; dy < r1.h; dy++){
			double sumR, sumG, sumB, sum;
			sumR = 0; sumG = 0; sumB = 0; sum = 0;
			for (int py = dy - n; py <= dy + n; py++){
				if (py >= 0 & py < r1.h){
					double weight = wg[abs(py - dy)];
					sum += weight;
					sumR += weight*(Uint8)((gas_px[r1.w*py + dx] & 0xFF0000) >> 16);
					sumG += weight*(Uint8)((gas_px[r1.w*py + dx] & 0x00FF00) >> 8);
					sumB += weight*(Uint8)((gas_px[r1.w*py + dx] & 0x0000FF));
				}
			}
			suf_px[r1.w*dy + dx] = ((Uint8)(sumR / sum) << 16) + ((Uint8)(sumG / sum) << 8) + (Uint8)(sumB / sum);
		}
	}*/
	//均值模糊
	for (int dy = 0; dy < r1.h; dy++){
		Uint8 pr[1024], pg[1024], pb[1024];
		Uint8 apr[1024], apg[1024], apb[1024];
		for (int dx = 0; dx < r1.w; dx++){
			pr[dx] = (Uint8)((suf_px[r1.w*dy + dx] & 0xFF0000) >> 16);
			pg[dx] = (Uint8)((suf_px[r1.w*dy + dx] & 0x00FF00) >> 8);
			pb[dx] = (Uint8)(suf_px[r1.w*dy + dx] & 0x0000FF);
		}
		for (int dx = 1; dx < r1.w-1; dx++){
			apr[dx] = (pr[dx - 1] + pr[dx] + pr[dx + 1]) / 3;
			apg[dx] = (pg[dx - 1] + pg[dx] + pg[dx + 1]) / 3;
			apb[dx] = (pb[dx - 1] + pb[dx] + pb[dx + 1]) / 3;
		}
		//apr[0] = (pr[0]*2 + pr[1]) / 3; apg[0] = (pg[0]*2 + pg[1]) / 3; apb[0] = (pb[0]*2 + pb[1]) / 3;
		//apr[r1.w - 1] = (pr[r1.w - 2] + pr[r1.w - 1] * 2) / 3; apg[r1.w - 1] = (pg[r1.w - 2] + pg[r1.w - 1] * 2) / 3; apb[r1.w - 1] = (pb[r1.w - 2] + pb[r1.w - 1] * 2) / 3;
		//apr[0] = apr[1]; apg[0] = apg[1]; apb[0] =apb[1];
		//apr[r1.w - 1] = apr[r1.w - 2]; apg[r1.w - 1] = apg[r1.w - 2]; apb[r1.w - 1] = apb[r1.w - 2];
		for (int dx = 0; dx < r1.w; dx++){
			int sumR, sumG, sumB, sum;
			sumR = 0; sumG = 0; sumB = 0; sum = 0;
			int st = max(dx - n, 3);
			int ed = min(dx + n, r1.w-3);
			for (int px = st; px < ed; px+=3){
				sum += 1;
				sumR += apr[px];
				sumG += apg[px];
				sumB += apb[px];
			}
			gas_px[r1.w*dy + dx] = ((sumR / sum) << 16) | ((sumG / sum) << 8) | (sumB / sum);
		}
	}
	//四角不模糊，圆角效果
	for (int i = 0; i < 7; i++)								{ gas_px[i] = suf_px[i]; }
	for (int i = r1.w - 7; i < r1.w + 4; i++)				{ gas_px[i] = suf_px[i]; }
	for (int i = r1.w * 2 - 4; i < r1.w*2 + 3; i++)			{ gas_px[i] = suf_px[i]; }
	for (int i = r1.w * 3 - 3; i < r1.w * 3 + 2; i++)		{ gas_px[i] = suf_px[i]; }
	for (int i = r1.w * 4 - 2; i < r1.w * 4 + 1; i++)		{ gas_px[i] = suf_px[i]; }
	for (int i = r1.w * 5 - 1; i < r1.w * 5 + 1; i++)		{ gas_px[i] = suf_px[i]; }
	for (int i = r1.w * 6 - 1; i < r1.w * 6 + 1; i++)		{ gas_px[i] = suf_px[i]; }
	for (int i = r1.w * 7 - 1; i < r1.w * 7; i++)			{ gas_px[i] = suf_px[i]; }

	for (int i = r1.w * (r1.h - 7); i < r1.w * (r1.h - 7)+1; i++)				{ gas_px[i] = suf_px[i]; }
	for (int i = r1.w * (r1.h - 6) - 1; i < r1.w * (r1.h - 6) + 1; i++)			{ gas_px[i] = suf_px[i]; }
	for (int i = r1.w * (r1.h - 5) - 1; i < r1.w * (r1.h - 5) + 1; i++)			{ gas_px[i] = suf_px[i]; }
	for (int i = r1.w * (r1.h - 4) - 1; i < r1.w * (r1.h - 4) + 2; i++)			{ gas_px[i] = suf_px[i]; }
	for (int i = r1.w * (r1.h - 3) - 2; i < r1.w * (r1.h - 3) + 3; i++)			{ gas_px[i] = suf_px[i]; }
	for (int i = r1.w * (r1.h - 2) - 3; i < r1.w * (r1.h - 2) + 4; i++)			{ gas_px[i] = suf_px[i]; }
	for (int i = r1.w * (r1.h - 1) - 4; i < r1.w * (r1.h - 1) + 7; i++)			{ gas_px[i] = suf_px[i]; }
	for (int i = r1.w * r1.h - 7; i < r1.w * r1.h; i++)							{ gas_px[i] = suf_px[i]; }


	for (int dx = 0; dx < r1.w; dx++){
		Uint8 pr[1024], pg[1024], pb[1024];
		Uint8 apr[1024], apg[1024], apb[1024];
		for (int dy = 0; dy < r1.h; dy++){
			pr[dy] = (Uint8)((gas_px[r1.w*dy + dx] & 0xFF0000) >> 16);
			pg[dy] = (Uint8)((gas_px[r1.w*dy + dx] & 0x00FF00) >> 8);
			pb[dy] = (Uint8)(gas_px[r1.w*dy + dx] & 0x0000FF);
		}
		for (int dy = 1; dy < r1.h-1; dy++){
			apr[dy] = (pr[dy - 1] + pr[dy] + pr[dy + 1]) / 3;
			apg[dy] = (pg[dy - 1] + pg[dy] + pg[dy + 1]) / 3;
			apb[dy] = (pb[dy - 1] + pb[dy] + pb[dy + 1]) / 3;
		}
		//apr[0] = (pr[0]*2 + pr[1]) / 3; apg[0] = (pg[0]*2 + pg[1]) / 3; apb[0] = (pb[0]*2 + pb[1]) / 3;
		//apr[r1.h-1] = (pr[r1.h - 2] + pr[r1.h-1]*2) / 3; apg[r1.h-1] = (pg[r1.h - 2] + pg[r1.h-1]*2) / 3; apb[r1.h-1] = (pb[r1.h - 2] + pb[r1.h-1]*2) / 3;
		for (int dy = 0; dy < r1.h; dy++){
			int sumR, sumG, sumB, sum;
			sumR = 0; sumG = 0; sumB = 0; sum = 0;
			int st = max(dy - n, 3);
			int ed = min(dy + n, r1.h-3);
			for (int py = st; py < ed; py+=3){
				sum += 1;
				sumR += apr[py];
				sumG += apg[py];
				sumB += apb[py];
			}
			suf_px[r1.w*dy + dx] = ((sumR / sum) << 16) + ((sumG / sum) << 8) + (sumB / sum);
		}
	}
	//四角不模糊，圆角效果
	for (int i = 0; i < 7; i++)								{ suf_px[i] = gas_px[i]; }
	for (int i = r1.w - 7; i < r1.w + 4; i++)				{ suf_px[i] = gas_px[i]; }
	for (int i = r1.w * 2 - 4; i < r1.w * 2 + 3; i++)		{ suf_px[i] = gas_px[i]; }
	for (int i = r1.w * 3 - 3; i < r1.w * 3 + 2; i++)		{ suf_px[i] = gas_px[i]; }
	for (int i = r1.w * 4 - 2; i < r1.w * 4 + 1; i++)		{ suf_px[i] = gas_px[i]; }
	for (int i = r1.w * 5 - 1; i < r1.w * 5 + 1; i++)		{ suf_px[i] = gas_px[i]; }
	for (int i = r1.w * 6 - 1; i < r1.w * 6 + 1; i++)		{ suf_px[i] = gas_px[i]; }
	for (int i = r1.w * 7 - 1; i < r1.w * 7; i++)			{ suf_px[i] = gas_px[i]; }

	for (int i = r1.w * (r1.h - 7); i < r1.w * (r1.h - 7) + 1; i++)				{ suf_px[i] = gas_px[i]; }
	for (int i = r1.w * (r1.h - 6) - 1; i < r1.w * (r1.h - 6) + 1; i++)			{ suf_px[i] = gas_px[i]; }
	for (int i = r1.w * (r1.h - 5) - 1; i < r1.w * (r1.h - 5) + 1; i++)			{ suf_px[i] = gas_px[i]; }
	for (int i = r1.w * (r1.h - 4) - 1; i < r1.w * (r1.h - 4) + 2; i++)			{ suf_px[i] = gas_px[i]; }
	for (int i = r1.w * (r1.h - 3) - 2; i < r1.w * (r1.h - 3) + 3; i++)			{ suf_px[i] = gas_px[i]; }
	for (int i = r1.w * (r1.h - 2) - 3; i < r1.w * (r1.h - 2) + 4; i++)			{ suf_px[i] = gas_px[i]; }
	for (int i = r1.w * (r1.h - 1) - 4; i < r1.w * (r1.h - 1) + 7; i++)			{ suf_px[i] = gas_px[i]; }
	for (int i = r1.w * r1.h - 7; i < r1.w * r1.h; i++)							{ suf_px[i] = gas_px[i]; }






	gTexture = SDL_CreateTextureFromSurface(g_renderer, suf);
	SDL_RenderCopy(g_renderer, gTexture, NULL, &r1);
	SDL_DestroyTexture(gTexture);
	SDL_FreeSurface(suf);
	SDL_FreeSurface(gas);
	free(pixels);
	return 1;
}


//播放mpeg
// esckey 停止播放的按键
int JY_PlayMPEG(const char* filename,int esckey)
{

    return 0;
} 


// 全屏切换
int JY_FullScreen()
{    

  
	return 0;
}



//保存屏幕到临时表面
int JY_SaveSur(int x,int y,int w,int h)
{ 
	int id=-1;
	int i;
	SDL_Rect r1;
	for(i=0;i<SURFACE_NUM;i++)
	{
		if(tmp_Surface[i]==NULL)
		{
			id=i;
			break;
		}
	}

	if(id==-1)
		return -1;

	/*x = 0;
	y = 0;
	w = g_ScreenW;
	h = g_ScreenH;*/
	
	r1.x=(Sint16)x;
	r1.y=(Sint16)y;
	r1.w=(Uint16)(w-x);
	r1.h=(Uint16)(h-y);

	tmp_Surface[id] = SDL_CreateTexture(g_renderer,SDL_PIXELFORMAT_ARGB8888,SDL_TEXTUREACCESS_TARGET,r1.w,r1.h);

	SDL_SetRenderTarget(g_renderer, tmp_Surface[id]);
	SDL_RenderClear(g_renderer);
	SDL_RenderCopy(g_renderer, g_screenTex, &r1, NULL);

	SDL_SetRenderTarget(g_renderer, g_screenTex);

	return id;
}

//加载临时表面到屏幕
int JY_LoadSur(int id, int x, int y)
{
	SDL_Rect r1;
	int w, h;
	if (id<0||id>SURFACE_NUM-1||tmp_Surface[id]==NULL){
		return 1;
	}
	SDL_QueryTexture(tmp_Surface[id], 0, 0, &w, &h);
	r1.x=(Sint16)x;
	r1.y=(Sint16)y;
	r1.w = (Uint16)w;
	r1.h = (Uint16)h;

	SDL_RenderCopy(g_renderer, tmp_Surface[id], NULL, &r1);
	return 0;
}

//释放
int JY_FreeSur(int id)
{
	if (id<0||id>SURFACE_NUM-1||tmp_Surface[id]==NULL){
		return 1;
	}

	if(tmp_Surface[id]!=NULL){
		SDL_DestroyTexture(tmp_Surface[id]);
		tmp_Surface[id]=NULL;
	}
	return 0;
}

static int gfxPrimitivesCompareInt(const void *a, const void *b)
{
	return (*(const int *) a) - (*(const int *) b);
}

static int hline(Sint16 x1, Sint16 x2, Sint16 y)
{
	return SDL_RenderDrawLine(g_renderer, x1, y, x2, y);
}

SDL_Texture* createPolygonTexture(Uint8 r, Uint8 g, Uint8 b, Uint8 a)
{
	int result;
	int i;
	int y, xa, xb;
	int miny, maxy;
	int x1, y1;
	int x2, y2;
	int ind1, ind2;
	int ints;
	int *gfxPrimitivesPolyInts = NULL;
	int *gfxPrimitivesPolyIntsNew = NULL;
	int gfxPrimitivesPolyAllocated = 0;

	const Sint16 vx[] = {0, g_XScale, g_XScale*2, g_XScale};
	const Sint16 vy[] = {g_YScale, g_YScale*2, g_YScale, 0};
	int n = 4;

	SDL_Texture* tex = SDL_CreateTexture(g_renderer,SDL_PIXELFORMAT_ARGB8888,SDL_TEXTUREACCESS_TARGET ,g_XScale*2,g_YScale*2);

	/*
	* Vertex array NULL check
	*/
	if (vx == NULL) {
		return tex;
	}
	if (vy == NULL) {
		return tex;
	}

	/*
	* Sanity check number of edges
	*/
	if (n < 3) {
		return tex;
	}


	/*
	* Allocate temp array, only grow array
	*/
	if (!gfxPrimitivesPolyAllocated) {
		gfxPrimitivesPolyInts = (int *) malloc(sizeof(int) * n);
		gfxPrimitivesPolyAllocated = n;
	} else {
		if (gfxPrimitivesPolyAllocated < n) {
			gfxPrimitivesPolyIntsNew = (int *) realloc(gfxPrimitivesPolyInts, sizeof(int) * n);
			if (!gfxPrimitivesPolyIntsNew) {
				if (!gfxPrimitivesPolyInts) {
					free(gfxPrimitivesPolyInts);
					gfxPrimitivesPolyInts = NULL;
				}
				gfxPrimitivesPolyAllocated = 0;
			} else {
				gfxPrimitivesPolyInts = gfxPrimitivesPolyIntsNew;
				gfxPrimitivesPolyAllocated = n;
			}
		}
	}

	/*
	* Check temp array
	*/
	if (gfxPrimitivesPolyInts==NULL) {
		gfxPrimitivesPolyAllocated = 0;
	}


	/*
	* Check temp array again
	*/
	if (gfxPrimitivesPolyInts==NULL) {
		return tex;
	}

	/*
	* Determine Y maxima
	*/
	miny = vy[0];
	maxy = vy[0];
	for (i = 1; (i < n); i++) {
		if (vy[i] < miny) {
			miny = vy[i];
		} else if (vy[i] > maxy) {
			maxy = vy[i];
		}
	}

	/*
	* Draw, scanning y
	*/
	result = 0;
	SDL_SetTextureBlendMode(tex,SDL_BLENDMODE_BLEND);
	SDL_SetRenderTarget(g_renderer, tex);
	SDL_SetRenderDrawColor(g_renderer, 255, 255, 255, 0);
	SDL_RenderClear(g_renderer);
	for (y = miny; (y <= maxy); y++) {
		ints = 0;
		for (i = 0; (i < n); i++) {
			if (!i) {
				ind1 = n - 1;
				ind2 = 0;
			} else {
				ind1 = i - 1;
				ind2 = i;
			}
			y1 = vy[ind1];
			y2 = vy[ind2];
			if (y1 < y2) {
				x1 = vx[ind1];
				x2 = vx[ind2];
			} else if (y1 > y2) {
				y2 = vy[ind1];
				y1 = vy[ind2];
				x2 = vx[ind1];
				x1 = vx[ind2];
			} else {
				continue;
			}
			if ( ((y >= y1) && (y < y2)) || ((y == maxy) && (y > y1) && (y <= y2)) ) {
				gfxPrimitivesPolyInts[ints++] = ((65536 * (y - y1)) / (y2 - y1)) * (x2 - x1) + (65536 * x1);
			}
		}

		qsort(gfxPrimitivesPolyInts, ints, sizeof(int), gfxPrimitivesCompareInt);

		/*
		* Set color
		*/
		result = 0;
	    result |= SDL_SetRenderDrawBlendMode(g_renderer, (a == 255) ? SDL_BLENDMODE_NONE : SDL_BLENDMODE_BLEND);
		result |= SDL_SetRenderDrawColor(g_renderer, r, g, b, a);

		for (i = 0; (i < ints); i += 2) {
			xa = gfxPrimitivesPolyInts[i] + 1;
			xa = (xa >> 16) + ((xa & 32768) >> 15);
			xb = gfxPrimitivesPolyInts[i+1] - 1;
			xb = (xb >> 16) + ((xb & 32768) >> 15);
			result |= hline(xa, xb, y);
		}

		SDL_SetRenderDrawColor(g_renderer, 160, 215, 160, 215);
		SDL_RenderDrawLine(g_renderer, vx[0], vy[0], vx[1], vy[1]);
		SDL_RenderDrawLine(g_renderer, vx[1], vy[1], vx[2], vy[2]);
		SDL_RenderDrawLine(g_renderer, vx[2], vy[2], vx[3], vy[3]);
		SDL_RenderDrawLine(g_renderer, vx[3], vy[3], vx[0], vy[0]);
	}

	SDL_SetRenderDrawBlendMode(g_renderer, SDL_BLENDMODE_NONE);
	SDL_SetRenderTarget(g_renderer, g_screenTex);

	return tex;
}
