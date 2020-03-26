function JY_Main() --主程序入口
 os.remove("debug.txt"); --清除以前的debug输出
 xpcall(JY_Main_sub,myErrFun); --捕获调用错误
end

function JY_Main_sub() --真正的游戏主程序入口

--dofile(CONFIG.ScriptPath .. "jymainpc.lua");

 SetGlobalConst();
 SetGlobal();
 --禁止访问全程变量
 setmetatable(_G,{ __newindex =function (_,n)
 error("attempt read write to undeclared variable " .. n,2);
 end,
 __index =function (_,n)
 error("attempt read read to undeclared variable " .. n,2);
 end,
 } );
 lib.Debug("JY_Main start.");
 math.randomseed(tostring(os.time()):reverse():sub(1, 6)) --初始化随机数发生器
 lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRePeatInterval); --设置键盘重复率
 lib.PicInit(CC.PaletteFile); --加载原来的256色调色板
 lib.GetKey();
 YJZMain();
end


function pjlv()
local lv_t={}
local cz=0
for i=1,JY.PersonNum-1 do
if JY.Person[i]["君主"]==1 then
table.insert(lv_t,JY.Person[i]["等级"]);
cz=cz+1
end
end

table.sort(lv_t,function(a,b) return b<a end)

for ii=1,cz do
table.insert(lv_t,1)
--lib.Debug("lv="..lv_t[ii])
end

local lv=0
for ii=1,cz do
lv=lv+lv_t[ii]
end

lv=math.modf(lv/cz)  --得到我方所有部队的平均等级
--lib.Debug("pjlv="..lv)
return lv
end

function myErrFun(err) --错误处理，打印错误信息
 lib.Debug(err); --输出错误信息
 lib.Debug(debug.traceback()); --输出调用堆栈信息
end

function SetGlobal() --设置游戏内部使用的全程变量
 JY={};
 JY.Status=GAME_START --游戏当前状态
 --保存R×数据
 JY.Base={}; --基本数据
 JY.PersonNum=0; --人物个数
 JY.Person={}; --人物数据
 JY.BingzhongNum=0; --人物个数
 JY.Bingzhong={}; --人物数据
 JY.SceneNum=0; --场景个数
 JY.Scene={}; --场景数据
 JY.ItemNum=0; --道具个数
 JY.Item={}; --道具数据
 JY.MagicNum=0; --策略个数
 JY.Magic={}; --策略数据
 JY.SkillNum=0; --特技个数
 JY.Skill={}; --特技数据
 JY.SubScene=-1; --当前子场景编号
 JY.SubSceneX=0; --子场景显示位置偏移，场景移动指令使用
 JY.SubSceneY=0;

 JY.Darkness=0; --=0 屏幕正常显示，=1 不显示，屏幕全黑

 JY.MmapMusic=-1; --切换大地图音乐，返回主地图时，如果设置，则播放此音乐

 JY.CurrentBGM=-1; --当前播放的音乐id，用来在关闭音乐时保存音乐id．
 JY.EnableMusic=1; --是否播放音乐 1 播放，0 不播放
 JY.EnableSound=1; --是否播放音效 1 播放，0 不播放
 JY.LLK_N=0;
 
 JY.Dark=true;
 JY.Smap={};
 JY.Tid=0; --SMAP时，当前选择的人物 或 正在说话的人物
 JY.EventID=1;
 JY.LoadedPic=0;
 JY.MenuPic={
 num=0,
 pic={},
 x={},
 y={},
 }
 JY.Death=0; --用于战场事件-"当消灭XX时触发"
 JY.ReFreshTime=0;
 War={};
 War.Person={};
 TeamSelect={}; --用于储存战斗前人物选择
end


function CleanMemory() --清理lua内存
 if CONFIG.CleanMemory==1 then
 collectgarbage("collect");
 --lib.Debug(string.format("Lua memory=%d",collectgarbage("count")));
 end
end

function Game_Cycle()
 for i=JY.Base["事件333"]+1,9999,1 do
 PlayBGM(math.random(19));
local llk=false

if CONFIG.PC then
llk=lianliankan2(i+9)
else
llk=lianliankan(i+9)
end

 if llk then
 if i>JY.Base["事件333"] and i<=30 then
 JY.Base["事件333"]=i;
 end
 else
 return;
 end
 end
end

function lianliankan(level)
 local B={};
 local num;
 local headbox={};
 local X_Num,Y_Num;
 local pic_w,pic_h;
 local x_off,y_off;
 local limit,start_time,now_time;
 local mid_point={
 x={},
 y={},
 };
 local select_a={
 x=0,
 y=0,
 };
 local select_b={
 x=0,
 y=0,
 };
 lib.SetClip(0,0,0,0);
 lib.FillColor(0,0,0,0,0);
 lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],0);
 pic_w,pic_h=lib.PicGetXY(0,0);
 X_Num=math.modf(CC.ScreenW/pic_w);
 Y_Num=math.modf(CC.ScreenH*15/16/pic_h);
 if X_Num~=math.modf(X_Num/2)*2 and Y_Num~=math.modf(Y_Num/2)*2 then
 if CC.ScreenW-pic_w*X_Num<CC.ScreenH*15/16-pic_h*Y_Num then
 X_Num=X_Num-1;
 else
 Y_Num=Y_Num-1;
 end
 end
 if X_Num<6 or Y_Num<4 then
 WarDrawStrBoxConfirm("屏幕分辨率设置过小！",C_WHITE,true)
 return false;
 end
 x_off=math.modf((CC.ScreenW-pic_w*X_Num)/2);
 y_off=math.modf(CC.ScreenH/16+(CC.ScreenH*15/16-pic_h*Y_Num)/2);
 num=X_Num*Y_Num/2;
 limit=X_Num*Y_Num*(10+level)*100+5000;
 for i=1,Y_Num do
 B[i]={};
 end
 for i=1,math.min(level,50) do
 local flag=true;
 while flag do
 headbox[i]=math.random(228);
 flag=false;
 for j=1,i-1 do
 if headbox[i]==headbox[j] then
 flag=true;
 break;
 end
 end
 end
 end
 --[[
 for y=1,Y_Num do --这一段极其无效率
 for x=1,X_Num do
 if B[y][x]==nil then
 local headid=headbox[math.random(level)]*2;
 B[y][x]=headid;
 local flag=true;
 while flag do
 local i=math.random(Y_Num);
 local j=math.random(X_Num);
 if B[i][j]==nil then
 B[i][j]=headid;
 flag=false;
 end
 end
 end
 end
 end
 ]]--
 for i=0,X_Num*Y_Num-1,2 do
 local y=1+math.modf(i/X_Num);
 local x=1+i%X_Num;
 local headid=headbox[math.random(level)]*2;
 B[y][x]=headid;
 if x==X_Num then
 B[y+1][1]=headid;
 else
 B[y][x+1]=headid;
 end
 end
 for x1=1,X_Num do
 for x2=x1+1,X_Num do
 for y1=1,Y_Num do
 for y2=y1+1,Y_Num do
 if math.random(2)==1 then
 B[y1][x1],B[y2][x2]=B[y2][x2],B[y1][x1];
 end
 end
 end
 end
 end
 for y1=1,Y_Num do
 for y2=y1+1,Y_Num do
 if math.random(2)==1 then
 B[y1],B[y2]=B[y2],B[y1];
 end
 end
 end
 local function SHOW()
 for y=1,Y_Num do
 for x=1,X_Num do
 if B[y][x]>-1 then
 --if (x==select_a.x and y==select_a.y) or (x==select_b.x and y==select_b.y) then
 --lib.PicLoadCache(0,B[y][x],pic_w*(x-1)+x_off,pic_h*(y-1)+y_off,3,128);
 --DrawBox(pic_w*(x-1)+x_off,pic_h*(y-1)+y_off,pic_w*x+x_off,pic_h*y+y_off,C_WHITE);
 --else
 lib.PicLoadCache(0,B[y][x],pic_w*(x-1)+x_off,pic_h*(y-1)+y_off,1);
 --end
 end
 end
 end
 
 if select_a.x~=0 and select_a.y~=0 then
 DrawBox(pic_w*(select_a.x-1)+x_off,pic_h*(select_a.y-1)+y_off,pic_w*select_a.x+x_off,pic_h*select_a.y+y_off,C_WHITE);
 end
 if select_b.x~=0 and select_b.y~=0 then
 DrawBox(pic_w*(select_b.x-1)+x_off,pic_h*(select_b.y-1)+y_off,pic_w*select_b.x+x_off,pic_h*select_b.y+y_off,C_WHITE);
 end
 --DrawTime()
 end
 local function DrawTime()
 now_time=lib.GetTime();
 lib.FillColor(0,0,CC.ScreenW,CC.ScreenH/16,RGB(192,192,192));
 DrawString(0,0,string.format("Level:%d",level-9),C_ORANGE,16);
 DrawBox(160,3,CC.ScreenW-4,CC.ScreenH/16-5,C_WHITE);
 DrawBox(160,3,160+(CC.ScreenW-164)*(start_time+limit-now_time)/limit,CC.ScreenH/16-5,C_WHITE);
 end
 local function Delay(t)
 for i=1,t,10 do
 DrawTime();
 lib.ShowSurface(0);
 lib.Delay(10);
 end
 end
 local function FIND(t,cx,cy,direct_old)
 if t>3 then
 return false;
 end
 mid_point.x[t]=cx;
 mid_point.y[t]=cy;
 for d=1,4 do
 if d~=direct_old then
 for i=1,math.max(X_Num,Y_Num) do
 local nx=cx+CC.DirectX[d]*i;
 local ny=cy+CC.DirectY[d]*i;
 --lib.Debug(string.format("第%d次寻找，当前x=%d,y=%d,d=%d,目标%d,%d",t,nx,ny,d,select_b.x,select_b.y))
 if nx==select_b.x and ny==select_b.y then
 mid_point.x[t+1]=nx;
 mid_point.y[t+1]=ny;
 mid_point.x[t+2]=nil;
 mid_point.y[t+2]=nil;
 return true;
 end
 if nx<1 or nx>X_Num or ny<1 or ny>Y_Num or B[ny][nx]~=-1 then
 break;
 end
 if FIND(t+1,nx,ny,d) then
 return true;
 end
 end
 end
 end
 return false;
 end
 local function FIND()
 local len_min=(X_Num+Y_Num)*2;
 for x=1,X_Num do
 local flag=true;
 local step;
 if select_b.y>select_a.y then
 step=1;
 elseif select_b.y==select_a.y then
 step=0;
 else
 step=-1;
 end
 if step~=0 then
 for y=select_a.y+step,select_b.y-step,step do
 if B[y][x]~=-1 then
 flag=false;
 break;
 end
 end
 end
 if flag then
 if select_a.x>x then
 step=1;
 elseif select_a.x==x then
 step=0;
 else
 step=-1;
 end
 if step~=0 and x~=select_a.x then
 for xx=x,select_a.x-step,step do
 if B[select_a.y][xx]~=-1 then
 flag=false;
 break;
 end
 end
 end
 if flag then
 if select_b.x>x then
 step=1;
 elseif select_b.x==x then
 step=0;
 else
 step=-1;
 end
 if step~=0 and x~=select_b.x then
 for xx=x,select_b.x-step,step do
 if B[select_b.y][xx]~=-1 then
 flag=false;
 break;
 end
 end
 end
 if flag then
 local len=math.abs(x-select_a.x)+math.abs(x-select_b.x)+math.abs(select_a.y-select_a.y);
 if len<len_min then
 len_min=len;
 mid_point.x[1]=select_a.x;
 mid_point.y[1]=select_a.y;
 mid_point.x[2]=x;
 mid_point.y[2]=select_a.y;
 mid_point.x[3]=x;
 mid_point.y[3]=select_b.y;
 mid_point.x[4]=select_b.x;
 mid_point.y[4]=select_b.y;
 end
 end
 end
 end
 end
 for y=1,Y_Num do
 local flag=true;
 local step;
 if select_b.x>select_a.x then
 step=1;
 elseif select_b.x==select_a.x then
 step=0;
 else
 step=-1;
 end
 if step~=0 then
 for x=select_a.x+step,select_b.x-step,step do
 if B[y][x]~=-1 then
 flag=false;
 break;
 end
 end
 end
 if flag then
 if select_a.y>y then
 step=1;
 elseif select_a.y==y then
 step=0;
 else
 step=-1;
 end
 if step~=0 and y~=select_a.y then
 for yy=y,select_a.y-step,step do
 if B[yy][select_a.x]~=-1 then
 flag=false;
 break;
 end
 end
 end
 if flag then
 if select_b.y>y then
 step=1;
 elseif select_b.y==y then
 step=0;
 else
 step=-1;
 end
 if step~=0 and y~=select_b.y then
 for yy=y,select_b.y-step,step do
 if B[yy][select_b.x]~=-1 then
 flag=false;
 break;
 end
 end
 end
 if flag then
 local len=math.abs(y-select_a.y)+math.abs(y-select_b.y)+math.abs(select_a.x-select_a.x);
 if len<len_min then
 len_min=len;
 mid_point.x[1]=select_a.x;
 mid_point.y[1]=select_a.y;
 mid_point.x[2]=select_a.x;
 mid_point.y[2]=y;
 mid_point.x[3]=select_b.x;
 mid_point.y[3]=y;
 mid_point.x[4]=select_b.x;
 mid_point.y[4]=select_b.y;
 end
 end
 end
 end
 end
 if len_min<(X_Num+Y_Num)*2 then
 --lib.Debug('y')
 
 return true;
 else
 return false;
 end
 end
 lib.FillColor(0,0,0,0,0);
 start_time=lib.GetTime();
 now_time=start_time;
 SHOW();
 lib.ShowSurface(0);
 lib.Delay(20);
 while num>0 do
 if (now_time-start_time)>limit then
 WarDrawStrBoxConfirm("失败，游戏即将结束．",C_WHITE,true)
PicCatchIni()
 return false;
 end
 local eventtype,keypress,x,y=lib.GetMouse(1);
 if eventtype==3 and keypress==3 then
 PlayWavE(1);
 if WarDrawStrBoxYesNo('结束游戏吗？',C_WHITE,true) then
PicCatchIni()
 return false;
 end
 end
 if eventtype==3 then
 local X=1+math.modf((x-x_off)/pic_w);
 local Y=1+math.modf((y-y_off)/pic_h);
 if x-x_off>=0 and y-y_off>=0 and X>=1 and X<=X_Num and Y>=1 and Y<=Y_Num and B[Y][X]~=-1 then
 if (select_a.x==0 or select_a.y==0) then
 select_a.x=X;
 select_a.y=Y;
 PlayWavE(0);
 elseif select_a.x==X and select_a.y==Y then
 select_a.x=0;
 select_a.x=0;
 PlayWavE(1);
 else
 if (select_b.x==0 or select_b.y==0) then
 select_b.x=X;
 select_b.y=Y;
 PlayWavE(0);
 elseif select_b.x==X and select_b.y==Y then
 select_b.x=0;
 select_b.x=0;
 PlayWavE(1);
 else
 WarDrawStrBoxConfirm("发生异常，游戏即将结束！",C_WHITE,true);
 return false;
 end
 end
 end
 if select_a.x~=0 and select_a.y~=0 and select_b.x~=0 and select_b.y~=0 then
 lib.FillColor(0,0,0,0,0);
 SHOW();
 --lib.ShowSurface(0);
 Delay(50);
 if B[select_a.y][select_a.x]==B[select_b.y][select_b.x] and FIND(1,select_a.x,select_a.y,-1) then
 B[select_a.y][select_a.x]=-1;
 B[select_b.y][select_b.x]=-1;
 num=num-1;
 for t=1,3 do
 if mid_point.x[t]~=mid_point.x[t+1] or mid_point.y[t]~=mid_point.y[t+1] then
 DrawBox(pic_w*mid_point.x[t]+x_off-pic_w/2,pic_h*mid_point.y[t]+y_off-pic_h/2,
 pic_w*mid_point.x[t+1]+x_off-pic_w/2,pic_h*mid_point.y[t+1]+y_off-pic_h/2,C_WHITE);
 end
 --lib.DrawRect
 end
 PlayWavE(11);
 --lib.ShowSurface(0);
 Delay(250);
 else
 PlayWavE(3);
 Delay(400);
 end
 select_a.x=0;
 select_a.y=0;
 select_b.x=0;
 select_b.y=0;
 end
 lib.FillColor(0,0,0,0,0);
 SHOW();
 --lib.ShowSurface(0);
 Delay(10);
 end
 --lib.FillColor(0,0,0,0,0);
 --SHOW();
 --lib.ShowSurface(0);
 Delay(10);
 end
 WarDrawStrBoxConfirm(string.format("恭喜！进入第%d关",level-8),C_WHITE,true)
 GetMoney(100) --每过一关 获得100金
 lib.ShowSurface(0);
 lib.Delay(500);
 return true;
end

function lianliankan2(level)
 local B={};
 local num;
 local headbox={};
 local X_Num,Y_Num;
 local pic_w,pic_h;
 local x_off,y_off;
 local limit,start_time,now_time;
 local mid_point={
 x={},
 y={},
 };
 local select_a={
 x=0,
 y=0,
 };
 local select_b={
 x=0,
 y=0,
 };
 lib.SetClip(0,0,0,0);
 lib.FillColor(0,0,0,0,0);
 lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],0);
 pic_w,pic_h=lib.PicGetXY(0,0);
 X_Num=math.modf(CC.ScreenW/pic_w);
 Y_Num=math.modf(CC.ScreenH*15/16/pic_h);
 if X_Num~=math.modf(X_Num/2)*2 and Y_Num~=math.modf(Y_Num/2)*2 then
 if CC.ScreenW-pic_w*X_Num<CC.ScreenH*15/16-pic_h*Y_Num then
 X_Num=X_Num-1;
 else
 Y_Num=Y_Num-1;
 end
 end
 if X_Num<6 or Y_Num<4 then
 WarDrawStrBoxConfirm("屏幕分辨率设置过小！",C_WHITE,true)
 return false;
 end
 x_off=math.modf((CC.ScreenW-pic_w*X_Num)/2);
 y_off=math.modf(CC.ScreenH/16+(CC.ScreenH*15/16-pic_h*Y_Num)/2);
 num=X_Num*Y_Num/2;
 limit=X_Num*Y_Num*(10+level)*100+5000;
 for i=1,Y_Num do
 B[i]={};
 end
 for i=1,math.min(level,50) do
 local flag=true;
 while flag do
 headbox[i]=math.random(228);
 flag=false;
 for j=1,i-1 do
 if headbox[i]==headbox[j] then
 flag=true;
 break;
 end
 end
 end
 end
 --[[
 for y=1,Y_Num do --这一段极其无效率
 for x=1,X_Num do
 if B[y][x]==nil then
 local headid=headbox[math.random(level)]*2;
 B[y][x]=headid;
 local flag=true;
 while flag do
 local i=math.random(Y_Num);
 local j=math.random(X_Num);
 if B[i][j]==nil then
 B[i][j]=headid;
 flag=false;
 end
 end
 end
 end
 end
 ]]--
 for i=0,X_Num*Y_Num-1,2 do
 local y=1+math.modf(i/X_Num);
 local x=1+i%X_Num;
 local headid=headbox[math.random(level)]*2;
 B[y][x]=headid;
 if x==X_Num then
 B[y+1][1]=headid;
 else
 B[y][x+1]=headid;
 end
 end
 for x1=1,X_Num do
 for x2=x1+1,X_Num do
 for y1=1,Y_Num do
 for y2=y1+1,Y_Num do
 if math.random(2)==1 then
 B[y1][x1],B[y2][x2]=B[y2][x2],B[y1][x1];
 end
 end
 end
 end
 end
 for y1=1,Y_Num do
 for y2=y1+1,Y_Num do
 if math.random(2)==1 then
 B[y1],B[y2]=B[y2],B[y1];
 end
 end
 end
 local function SHOW()
 for y=1,Y_Num do
 for x=1,X_Num do
 if B[y][x]>-1 then
 --if (x==select_a.x and y==select_a.y) or (x==select_b.x and y==select_b.y) then
 --lib.PicLoadCache(0,B[y][x],pic_w*(x-1)+x_off,pic_h*(y-1)+y_off,3,128);
 --DrawBox(pic_w*(x-1)+x_off,pic_h*(y-1)+y_off,pic_w*x+x_off,pic_h*y+y_off,C_WHITE);
 --else
 lib.PicLoadCache(0,B[y][x],pic_w*(x-1)+x_off,pic_h*(y-1)+y_off,1);
 --end
 end
 end
 end
 
 if select_a.x~=0 and select_a.y~=0 then
 DrawBox(pic_w*(select_a.x-1)+x_off,pic_h*(select_a.y-1)+y_off,pic_w*select_a.x+x_off,pic_h*select_a.y+y_off,C_WHITE);
 end
 if select_b.x~=0 and select_b.y~=0 then
 DrawBox(pic_w*(select_b.x-1)+x_off,pic_h*(select_b.y-1)+y_off,pic_w*select_b.x+x_off,pic_h*select_b.y+y_off,C_WHITE);
 end
 --DrawTime()
 end
 local function DrawTime()
 now_time=lib.GetTime();
 lib.FillColor(0,0,CC.ScreenW,CC.ScreenH/16,RGB(192,192,192));
 DrawString(0,0,string.format("Level:%d",level-9),C_ORANGE,16);
 DrawBox(160,3,CC.ScreenW-4,CC.ScreenH/16-5,C_WHITE);
 DrawBox(160,3,160+(CC.ScreenW-164)*(start_time+limit-now_time)/limit,CC.ScreenH/16-5,C_WHITE);
 end
 local function Delay(t)
 for i=1,t,10 do
 DrawTime();
 lib.ShowSurface(0);
 lib.Delay(10);
 end
 end
 local function FIND(t,cx,cy,direct_old)
 if t>3 then
 return false;
 end
 mid_point.x[t]=cx;
 mid_point.y[t]=cy;
 for d=1,4 do
 if d~=direct_old then
 for i=1,math.max(X_Num,Y_Num) do
 local nx=cx+CC.DirectX[d]*i;
 local ny=cy+CC.DirectY[d]*i;
 --lib.Debug(string.format("第%d次寻找，当前x=%d,y=%d,d=%d,目标%d,%d",t,nx,ny,d,select_b.x,select_b.y))
 if nx==select_b.x and ny==select_b.y then
 mid_point.x[t+1]=nx;
 mid_point.y[t+1]=ny;
 mid_point.x[t+2]=nil;
 mid_point.y[t+2]=nil;
 return true;
 end
 if nx<1 or nx>X_Num or ny<1 or ny>Y_Num or B[ny][nx]~=-1 then
 break;
 end
 if FIND(t+1,nx,ny,d) then
 return true;
 end
 end
 end
 end
 return false;
 end
 local function FIND()
 local len_min=(X_Num+Y_Num)*2;
 for x=1,X_Num do
 local flag=true;
 local step;
 if select_b.y>select_a.y then
 step=1;
 elseif select_b.y==select_a.y then
 step=0;
 else
 step=-1;
 end
 if step~=0 then
 for y=select_a.y+step,select_b.y-step,step do
 if B[y][x]~=-1 then
 flag=false;
 break;
 end
 end
 end
 if flag then
 if select_a.x>x then
 step=1;
 elseif select_a.x==x then
 step=0;
 else
 step=-1;
 end
 if step~=0 and x~=select_a.x then
 for xx=x,select_a.x-step,step do
 if B[select_a.y][xx]~=-1 then
 flag=false;
 break;
 end
 end
 end
 if flag then
 if select_b.x>x then
 step=1;
 elseif select_b.x==x then
 step=0;
 else
 step=-1;
 end
 if step~=0 and x~=select_b.x then
 for xx=x,select_b.x-step,step do
 if B[select_b.y][xx]~=-1 then
 flag=false;
 break;
 end
 end
 end
 if flag then
 local len=math.abs(x-select_a.x)+math.abs(x-select_b.x)+math.abs(select_a.y-select_a.y);
 if len<len_min then
 len_min=len;
 mid_point.x[1]=select_a.x;
 mid_point.y[1]=select_a.y;
 mid_point.x[2]=x;
 mid_point.y[2]=select_a.y;
 mid_point.x[3]=x;
 mid_point.y[3]=select_b.y;
 mid_point.x[4]=select_b.x;
 mid_point.y[4]=select_b.y;
 end
 end
 end
 end
 end
 for y=1,Y_Num do
 local flag=true;
 local step;
 if select_b.x>select_a.x then
 step=1;
 elseif select_b.x==select_a.x then
 step=0;
 else
 step=-1;
 end
 if step~=0 then
 for x=select_a.x+step,select_b.x-step,step do
 if B[y][x]~=-1 then
 flag=false;
 break;
 end
 end
 end
 if flag then
 if select_a.y>y then
 step=1;
 elseif select_a.y==y then
 step=0;
 else
 step=-1;
 end
 if step~=0 and y~=select_a.y then
 for yy=y,select_a.y-step,step do
 if B[yy][select_a.x]~=-1 then
 flag=false;
 break;
 end
 end
 end
 if flag then
 if select_b.y>y then
 step=1;
 elseif select_b.y==y then
 step=0;
 else
 step=-1;
 end
 if step~=0 and y~=select_b.y then
 for yy=y,select_b.y-step,step do
 if B[yy][select_b.x]~=-1 then
 flag=false;
 break;
 end
 end
 end
 if flag then
 local len=math.abs(y-select_a.y)+math.abs(y-select_b.y)+math.abs(select_a.x-select_a.x);
 if len<len_min then
 len_min=len;
 mid_point.x[1]=select_a.x;
 mid_point.y[1]=select_a.y;
 mid_point.x[2]=select_a.x;
 mid_point.y[2]=y;
 mid_point.x[3]=select_b.x;
 mid_point.y[3]=y;
 mid_point.x[4]=select_b.x;
 mid_point.y[4]=select_b.y;
 end
 end
 end
 end
 end
 if len_min<(X_Num+Y_Num)*2 then
 --lib.Debug('y')
 
 return true;
 else
 return false;
 end
 end
 lib.FillColor(0,0,0,0,0);
 start_time=lib.GetTime();
 now_time=start_time;
 SHOW();
 lib.ShowSurface(0);
 lib.Delay(20);
 while num>0 do
 if (now_time-start_time)>limit then
 WarDrawStrBoxConfirm("失败，游戏即将结束．",C_WHITE,true)
PicCatchIni()
 return false;
 end
 local eventtype,keypress,x,y=lib.GetKey(1);
 if eventtype==3 and keypress==3 then
 PlayWavE(1);
 if WarDrawStrBoxYesNo('结束游戏吗？',C_WHITE,true) then
PicCatchIni()
 return false;
 end
 end
 if eventtype==3 then
 local X=1+math.modf((x-x_off)/pic_w);
 local Y=1+math.modf((y-y_off)/pic_h);
 if x-x_off>=0 and y-y_off>=0 and X>=1 and X<=X_Num and Y>=1 and Y<=Y_Num and B[Y][X]~=-1 then
 if (select_a.x==0 or select_a.y==0) then
 select_a.x=X;
 select_a.y=Y;
 PlayWavE(0);
 elseif select_a.x==X and select_a.y==Y then
 select_a.x=0;
 select_a.x=0;
 PlayWavE(1);
 else
 if (select_b.x==0 or select_b.y==0) then
 select_b.x=X;
 select_b.y=Y;
 PlayWavE(0);
 elseif select_b.x==X and select_b.y==Y then
 select_b.x=0;
 select_b.x=0;
 PlayWavE(1);
 else
 WarDrawStrBoxConfirm("发生异常，游戏即将结束！",C_WHITE,true);
 return false;
 end
 end
 end
 if select_a.x~=0 and select_a.y~=0 and select_b.x~=0 and select_b.y~=0 then
 lib.FillColor(0,0,0,0,0);
 SHOW();
 --lib.ShowSurface(0);
 Delay(50);
 if B[select_a.y][select_a.x]==B[select_b.y][select_b.x] and FIND(1,select_a.x,select_a.y,-1) then
 B[select_a.y][select_a.x]=-1;
 B[select_b.y][select_b.x]=-1;
 num=num-1;
 for t=1,3 do
 if mid_point.x[t]~=mid_point.x[t+1] or mid_point.y[t]~=mid_point.y[t+1] then
 DrawBox(pic_w*mid_point.x[t]+x_off-pic_w/2,pic_h*mid_point.y[t]+y_off-pic_h/2,
 pic_w*mid_point.x[t+1]+x_off-pic_w/2,pic_h*mid_point.y[t+1]+y_off-pic_h/2,C_WHITE);
 end
 --lib.DrawRect
 end
 PlayWavE(11);
 --lib.ShowSurface(0);
 Delay(250);
 else
 PlayWavE(3);
 Delay(400);
 end
 select_a.x=0;
 select_a.y=0;
 select_b.x=0;
 select_b.y=0;
 end
 lib.FillColor(0,0,0,0,0);
 SHOW();
 --lib.ShowSurface(0);
 Delay(10);
 end
 --lib.FillColor(0,0,0,0,0);
 --SHOW();
 --lib.ShowSurface(0);
 Delay(10);
 end
 WarDrawStrBoxConfirm(string.format("恭喜！进入第%d关",level-8),C_WHITE,true)
 GetMoney(100) --每过一关 获得100金
 lib.ShowSurface(0);
 lib.Delay(500);
 return true;
end

--绘制一个带背景的白色方框，四角凹进
function DrawBox(x1,y1,x2,y2,color) --绘制一个带背景的白色方框
 local s=4;
 --lib.Background(x1,y1+s,x1+s,y2-s,128); --阴影，四角空出
 --lib.Background(x1+s,y1,x2-s,y2,128);
 --lib.Background(x2-s,y1+s,x2,y2-s,128);
 lib.Background(x1+4,y1,x2-4,y1+s,128);
 lib.Background(x1+1,y1+1,x1+s,y1+s,128);
 lib.Background(x2-s,y1+1,x2-1,y1+s,128);
 lib.Background(x1,y1+4,x2,y2-4,128);
 lib.Background(x1+1,y2-s,x1+s,y2-1,128);
 lib.Background(x2-s,y2-s+1,x2-1,y2,128);
 lib.Background(x1+4,y2-s,x2-4,y2,128);
 --lib.FillColor(x1,y1,x2,y2,C_RED,100);
 
 local r,g,b=GetRGB(color);
 local color2=RGB(math.modf(r/2),math.modf(g/2),math.modf(b/2));
 DrawBox_1(x1-1,y1-1,x2-1,y2-1,color2);
 DrawBox_1(x1+1,y1-1,x2+1,y2-1,color2);
 DrawBox_1(x1-1,y1+1,x2-1,y2+1,color2);
 DrawBox_1(x1+1,y1+1,x2+1,y2+1,color2);
 DrawBox_1(x1,y1,x2,y2,color);
end

--绘制四角凹进的方框
function DrawBox_1(x1,y1,x2,y2,color) --绘制四角凹进的方框
 local s=4;
 --lib.DrawRect(x1+s,y1,x2-s,y1,color);
 --lib.DrawRect(x2-s,y1,x2-s,y1+s,color);
 --lib.DrawRect(x2-s,y1+s,x2,y1+s,color);
 --lib.DrawRect(x2,y1+s,x2,y2-s,color);
 --lib.DrawRect(x2,y2-s,x2-s,y2-s,color);
 --lib.DrawRect(x2-s,y2-s,x2-s,y2,color);
 --lib.DrawRect(x2-s,y2,x1+s,y2,color);
 --lib.DrawRect(x1+s,y2,x1+s,y2-s,color);
 --lib.DrawRect(x1+s,y2-s,x1,y2-s,color);
 --lib.DrawRect(x1,y2-s,x1,y1+s,color);
 --lib.DrawRect(x1,y1+s,x1+s,y1+s,color);
 --lib.DrawRect(x1+s,y1+s,x1+s,y1,color);
 lib.DrawRect(x1+s,y1,x2-s,y1,color);
 lib.DrawRect(x1+s,y2,x2-s,y2,color);
 lib.DrawRect(x1,y1+s,x1,y2-s,color);
 lib.DrawRect(x2,y1+s,x2,y2-s,color);
 lib.DrawRect(x1+2,y1+1,x1+s-1,y1+1,color);
 lib.DrawRect(x1+1,y1+2,x1+1,y1+s-1,color);
 lib.DrawRect(x2-s+1,y1+1,x2-2,y1+1,color);
 lib.DrawRect(x2-1,y1+2,x2-1,y1+s-1,color);
 
 lib.DrawRect(x1+2,y2-1,x1+s-1,y2-1,color);
 lib.DrawRect(x1+1,y2-s+1,x1+1,y2-2,color);
 lib.DrawRect(x2-s+1,y2-1,x2-2,y2-1,color);
 lib.DrawRect(x2-1,y2-s+1,x2-1,y2-2,color);
end
--绘制一个带背景的白色方框，四角凹进
function DrawBox(x1,y1,x2,y2,color,bjcolor) --绘制一个带背景的白色方框
 local s=4
 bjcolor=bjcolor or 0;
 if bjcolor>=0 then
 lib.Background(x1,y1+s,x1+s,y2-s,128,bjcolor); --阴影，四角空出
 lib.Background(x1+s,y1,x2-s,y2,128,bjcolor);
 lib.Background(x2-s,y1+s,x2,y2-s,128,bjcolor);
 end
 if color>=0 then
 local r,g,b=GetRGB(color);
 DrawBox_1(x1+1,y1,x2,y2,RGB(math.modf(r/2),math.modf(g/2),math.modf(b/2)));
 DrawBox_1(x1,y1,x2-1,y2-1,color);
 end
end
--修改后的drawbox，边框加粗
function DrawGameBox(x1,y1,x2,y2)
 --[[
 lib.DrawRect(x1,y1,x2-1,y1,C_WHITE);
 lib.DrawRect(x1,y1+1,x2-2,y1+1,C_WHITE);
 lib.DrawRect(x1+2,y1+2,x2-2,y1+2,M_SlateGray);
 lib.DrawRect(x1+2,y1+3,x2-3,y1+3,M_SlateGray);
 
 lib.DrawRect(x1,y1+2,x1,y2,C_WHITE);
 lib.DrawRect(x1+1,y1+2,x1+1,y2-1,C_WHITE);
 lib.DrawRect(x1+2,y1+4,x1+2,y2-2,M_SlateGray);
 lib.DrawRect(x1+3,y1+4,x1+3,y2-3,M_SlateGray);
 
 lib.DrawRect(x2-3,y1+4,x2-3,y2-2,C_WHITE);
 lib.DrawRect(x2-2,y1+3,x2-2,y2-2,C_WHITE);
 lib.DrawRect(x2-1,y1+1,x2-1,y2,M_SlateGray);
 lib.DrawRect(x2,y1,x2,y2,M_SlateGray);
 
 lib.DrawRect(x1+4,y2-3,x2-4,y2-3,C_WHITE);
 lib.DrawRect(x1+3,y2-2,x2-4,y2-2,C_WHITE);
 lib.DrawRect(x1+2,y2-1,x2-2,y2-1,M_SlateGray);
 lib.DrawRect(x1+1,y2,x2-2,y2,M_SlateGray);
 ]]--
 lib.PicLoadCache(4,260*2,x1,y1,1);
end
function WarFillColor(x1,y1,x2,y2,clarity,color,size)
 color=color or M_Red;
 clarity=clarity or 128;
 size=size or 8;
 local flag1=true;
 for y=y1,y2-1,size do
 local flag2=flag1;
 for x=x1,x2-1,size do
 if flag2 then
 lib.Background(x,y,x+size,y+size,clarity,color);
 end
 flag2=not flag2;
 end
 flag1=not flag1;
 end
end
--显示阴影字符串
function DrawString(x,y,str,color,size) --显示阴影字符串

if CONFIG.PC then
if CC.FontType==0 then
lib.DrawStr(x-1,y,str,color,size,0,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1);
lib.DrawStr(x,y,str,color,size,0,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1);
elseif CC.FontType==1 then
lib.DrawStr(x,y,str,color,size,0,CC.FontName,CC.SrcCharSet,CC.OSCharSet);
end

else
 if CC.FontType==0 then
 lib.DrawStr(x-1,y,str,color,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1);
 lib.DrawStr(x,y,str,color,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1);
 elseif CC.FontType==1 then
 lib.DrawStr(x,y,str,color,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet);
 end
end
 --local r,g,b=GetRGB(color);
 --lib.DrawStr(x+1,y+1,str,RGB(math.modf(r/2),math.modf(g/2),math.modf(b/2)),size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1)
 --lib.DrawStr(x+1,y+1,str,0,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1)
 --lib.DrawStr(x-1,y,str,color,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1)
 --lib.DrawStr(x,y,str,color,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1)
 --lib.DrawStr(x,y,str,color,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet);
end
function DrawString2(x,y,str,color,size) --显示阴影字符串
 lib.DrawStr(x-2,y,str,C_BLACK,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1);
 lib.DrawStr(x+1,y,str,C_BLACK,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1);
 DrawString(x,y,str,color,size);
end
--显示带框的字符串
--(x,y) 坐标，如果都为-1,则在屏幕中间显示
function DrawStrBox(x,y,str,color,size) --显示带框的字符串
 local ll=#str;
 local w=size*ll/2+2*CC.MenuBorderPixel;
 local h=size+2*CC.MenuBorderPixel;
 if x==-1 then
 x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2;
 end
 if y==-1 then
 y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2;
 end

 DrawBox(x,y,x+w-1,y+h-1,C_WHITE);
 DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel,str,color,size);
end
function DrawStrBox(x,y,str,color,size,bjcolor) --显示带框的字符串
 
 local strarray={}
 local num,maxlen;
 maxlen=0
 num,strarray=Split(str,'*')
 for i=1,num do
 local len=#strarray[i];
 if len>maxlen then
 maxlen=len
 end
 end
 if maxlen==0 then
 return;
 end
 local w=size*maxlen/2+2*CC.MenuBorderPixel;
 local h=2*CC.MenuBorderPixel+size*num;
 if x==-1 then
 x=(CC.ScreenW-size/2*maxlen-2*CC.MenuBorderPixel)/2;
 end
 if y==-1 then
 y=(CC.ScreenH-size*num-2*CC.MenuBorderPixel)/2;
 end
 if x<0 then
 x=CC.ScreenW-size/2*maxlen-2*CC.MenuBorderPixel+x;
 end
 if y<0 then
 y=CC.ScreenH-size*num-2*CC.MenuBorderPixel+y;
 end
 DrawBox(x,y,x+w-1,y+h-1,C_WHITE,bjcolor);
 for i=1,num do
 DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel+size*(i-1),strarray[i],color,size);
 end
end
function DrawStr(x,y,str,color,size) --显示字符串,会分行
 
 local strarray={}
 local num,maxlen;
 maxlen=0
 num,strarray=Split(str,'*')
 for i=1,num do
 local len=#strarray[i];
 if len>maxlen then
 maxlen=len
 end
 end
 if maxlen==0 then
 return;
 end
 for i=1,num do
 DrawString(x,y+size*(i-1),strarray[i],color,size);
 end
end
function Split(szFullString,szSeparator)
 local nFindStartIndex = 1
 local nSplitIndex = 1
 local nSplitArray = {}
 while true do
 local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
 if not nFindLastIndex then
 nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
 break
 end
 nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
 nFindStartIndex = nFindLastIndex + string.len(szSeparator)
 nSplitIndex = nSplitIndex + 1
 end
 return nSplitIndex,nSplitArray
end
--显示并询问Y/N，如果点击Y，则返回true, N则返回false
--(x,y) 坐标，如果都为-1,则在屏幕中间显示
--改为用菜单询问是否
function DrawStrBoxYesNo(x,y,str,color,size) --显示字符串并询问Y/N
 lib.GetKey();
 local ll=#str;
 local w=size*ll/2+2*CC.MenuBorderPixel;
 local h=size+2*CC.MenuBorderPixel;
 if x==-1 then
 x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2;
 end
 if y==-1 then
 y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2;
 end

 DrawStrBox(x,y,str,color,size);
 local menu={{"确定/是",nil,1},
 {"取消/否",nil,2}};

 local r=ShowMenu(menu,2,0,x+w-4*size-2*CC.MenuBorderPixel,y+h+CC.MenuBorderPixel,0,0,1,0,size*0.8,C_ORANGE, C_WHITE)

 if r==1 then
 return true;
 else
 return false;
 end

end
function WarShowTarget(firstShow) --显示任务目标
 -- notWar true notwar, false in war
 lib.GetKey();
 local x,y;
 local w,h=320,192;
 local size=16;
 x=16+576/2;
 y=32+432/2;
 x=x-w/2;
 y=y-h/2;
 local x1=x+254
 local x2=x1+52
 local y1=y+148;
 local y2=y1+24;
 local str="";
 local T={[0]="０","１","２","３","４","５","６","７","８","９",
 "１０","１１","１２","１３","１４","１５","１６","１７","１８","１９",
 "２０","２１","２２","２３","２４","２５","２６","２７","２８","２９",
 "３０","３１","３２","３３","３４","３５","３６","３７","３８","３９",
 "４０","４１","４２","４３","４４","４５","４６","４７","４８","４９",
 "５０","５１","５２","５３","５４","５５","５６","５７","５８","５９",
 "６０","６１","６２","６３","６４","６５","６６","６７","６８","６９",
 "７０","７１","７２","７３","７４","７５","７６","７７","７８","７９",
 "８０","８１","８２","８３","８４","８５","８６","８７","８８","８９",
 "９０","９１","９２","９３","９４","９５","９６","９７","９８","９９",
 "１００","１０１","１０２","１０３","１０４","１０５","１０６","１０７","１０８","１０９",
 "１１０","１１１","１１２","１１３","１１４","１１５","１１６","１１７","１１８","１１９",
 "１２０","１２１","１２２","１２３","１２４","１２５","１２６","１２７","１２８","１２９",
 "１３０","１３１","１３２","１３３","１３４","１３５","１３６","１３７","１３８","１３９",
 "１４０","１４１","１４２","１４３","１４４","１４５","１４６","１４７","１４８","１４９",
 "１５０","１５１","１５２","１５３","１５４","１５５","１５６","１５７","１５８","１５９",
 "１６０","１６１","１６２","１６３","１６４","１６５","１６６","１６７","１６８","１６９",
 "１７０","１７１","１７２","１７３","１７４","１７５","１７６","１７７","１７８","１７９",
 "１８０","１８１","１８２","１８３","１８４","１８５","１８６","１８７","１８８","１８９",
 "１９０","１９１","１９２","１９３","１９４","１９５","１９６","１９７","１９８","１９９",
 "２００",};
 if firstShow then
 PlayWavE(0);
 str="限制回数"..T[War.MaxTurn];
 else
 str="现在回数　"..T[War.Turn].."／"..T[War.MaxTurn];
 end
 local function redraw(flag)
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 lib.PicLoadCache(4,81*2,x,y,1);
 DrawString(x+16,y+16,War.WarName,C_WHITE,size);
 DrawString(x+240,y+16,"胜利条件",C_WHITE,size);
 DrawStr(x+32,y+56,War.WarTarget,C_WHITE,size);
 DrawStr(x+24,y+152,str,C_WHITE,size);
 if flag==1 then
 lib.PicLoadCache(4,56*2,x1,y1,1);
 end
 ReFresh();
 end
 local current=0;
 while true do
 redraw(current);
 getkey();
 if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
 current=1;
 elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
 current=0;
 PlayWavE(0);
 redraw(current);
 WarDelay(4);
 return;
 else
 current=0;
 end
 end
end

function DrawItemStatus(id,pid) --显示物品属性
local str=JY.Item[id]["说明"]

if CC.Enhancement then
if id==JY.Person[pid]["武器"] and JY.Person[pid]["姓名"]==JY.Item[id]["专属特技人"] then
str=str.."*特效："..JY.Skill[JY.Item[id]["专属特技"]]["说明"]
elseif id==JY.Person[pid]["武器"] and JY.Item[id]["特技"]>0 then
str=str.."*特效："..JY.Skill[JY.Item[id]["特技"]]["说明"]
end
end

DrawStrStatus(JY.Item[id]["名称"],str);
end

function DrawSkillStatus(id) --显示技能属性
 DrawStrStatus(JY.Skill[id]["名称"],JY.Skill[id]["说明"]);
end

function DrawBingZhongStatus(id) --显示兵种属性
 DrawStrStatus(JY.Bingzhong[id]["名称"],JY.Bingzhong[id]["说明"]);
end

function DrawLieZhuan(name) --显示列传
 DrawStrStatus("三国英杰列传 - "..name,CC.LieZhuan[name]);
end

function DrawStrStatus(str1,str2) --显示属性
 lib.GetKey();
 local x,y;
 local w,h=320,128;
 local size=16;
 local notWar=true;
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 x=16+(576-0)/2;
 y=32+(432-0)/2;
 notWar=false;
 elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 x=16+(640-0)/2;
 y=16+(400-0)/2;
 notWar=true;
 else
 x=(CC.ScreenW-0)/2;
 y=(CC.ScreenH-0)/2;
 notWar=true;
 end
 x=x-w/2;
 y=y-h/2;
 local x1=x+254
 local x2=x1+52
 local y1=y+92;
 local y2=y1+24;
 local function redraw(flag)
 JY.ReFreshTime=lib.GetTime();
 if not notWar then
 DrawWarMap();
 end
 lib.PicLoadCache(4,80*2,x,y,1);
 DrawString(x+16,y+10,str1,C_Name,size); --old y=16
 DrawStr(x+16,y+28,GenTalkString(str2,18),C_WHITE,size); --old y=36
 if flag==1 then
 lib.PicLoadCache(4,56*2,x1,y1,1);
 end
 if notWar then
 ShowScreen();
 else
 ReFresh();
 end
 end
 local current=0;
 PlayWavE(0);
 while true do
 redraw(current);
 getkey();
 if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
 current=1;
 elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
 current=0;
 PlayWavE(0);
 redraw(current);
 if notWar then
 lib.Delay(100);
 else
 WarDelay(4);
 end
 return;
 else
 current=0;
 end
 end
end
function WarDrawStrBoxConfirm(str,color,notWar) --显示字符串并询问Y/N
 lib.GetKey();
 local x,y;
 local size=16;
 local strarray={}
 local num,maxlen;
 maxlen=0
 str=str.."* ";
 num,strarray=Split(str,'*')
 for i=1,num do
 local len=#strarray[i];
 if len>maxlen then
 maxlen=len
 end
 end
 if maxlen==0 then
 return;
 end
 local w=size*maxlen/2+2*CC.MenuBorderPixel;
 local h=2*CC.MenuBorderPixel+size*num+6*(num-1);
 --x=16+768/2;
 --y=32+528/2;
 --if notWar then
 -- x=CC.ScreenW/2;
 -- y=CC.ScreenH/2;
 --end
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 x=16+(576-0)/2;
 y=32+(432-0)/2;
 elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 x=16+(640-0)/2;
 y=16+(400-0)/2;
 else
 x=(CC.ScreenW-0)/2;
 y=(CC.ScreenH-0)/2;
 end
 local x4=x+w/2;
 local x3=x4-52;
 local x2=x4-56
 local x1=x3-56
 local y2=y+h/2;
 local y1=y2-24;
 local function redraw(flag)
 JY.ReFreshTime=lib.GetTime();
 if not notWar then
 DrawWarMap();
 end
 if notWar then
 --DrawYJZBox((CC.ScreenW-w)/2,(CC.ScreenH-h)/2,str,color); 
 DrawYJZBox(-1,-1,str,color,notWar);
 else
 DrawYJZBox(-1,-1,str,color);
 end
 if flag==2 then
 lib.PicLoadCache(4,56*2,x3,y1,1);
 else
 lib.PicLoadCache(4,55*2,x3,y1,1);
 end
 if notWar then
 ShowScreen();
 else
 ReFresh();
 end
 end
 local current=0;
 while true do
 redraw(current);
 getkey();
 if MOUSE.HOLD(x3+1,y1+1,x4-1,y2-1) then
 current=2;
 elseif MOUSE.CLICK(x3+1,y1+1,x4-1,y2-1) then
 current=0;
 PlayWavE(0);
 redraw(current);
 if notWar then
 lib.Delay(100);
 else
 WarDelay(4);
 end
 return false;
 else
 current=0;
 end
 end
end
function WarDrawStrBoxYesNo(str,color,notWar) --显示字符串并询问Y/N
 lib.GetKey();
 local x,y;
 local size=16;
 local strarray={}
 local num,maxlen;
 maxlen=0;
 str=str.."* ";
 num,strarray=Split(str,'*')
 for i=1,num do
 local len=#strarray[i];
 if len>maxlen then
 maxlen=len
 end
 end
 if maxlen==0 then
 return;
 end
 local w=size*maxlen/2+2*CC.MenuBorderPixel;
 local h=2*CC.MenuBorderPixel+size*num+6*(num-1);
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 x=16+(576)/2;
 y=32+(432)/2;
 elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 x=16+(640)/2;
 y=16+(400)/2;
 else
 x=(CC.ScreenW)/2;
 y=(CC.ScreenH)/2;
 end
 local x4=x+w/2;
 local x3=x4-52;
 local x2=x4-56
 local x1=x3-56
 local y2=y+h/2;
 local y1=y2-24;
 local function redraw(flag)
 JY.ReFreshTime=lib.GetTime();
 if not notWar then
 DrawWarMap();
 end
 if notWar then
 --DrawYJZBox((CC.ScreenW-w)/2,(CC.ScreenH-h)/2,str,color);
 DrawYJZBox(-1,-1,str,color,notWar);
 else
 DrawYJZBox(-1,-1,str,color);
 end
 if flag==1 then
 lib.PicLoadCache(4,52*2,x1,y1,1);
 else
 lib.PicLoadCache(4,51*2,x1,y1,1);
 end
 if flag==2 then
 lib.PicLoadCache(4,54*2,x3,y1,1);
 else
 lib.PicLoadCache(4,53*2,x3,y1,1);
 end
 if notWar then
 ShowScreen();
 else
 ReFresh();
 end
 end
 local current=0;
 while true do
 redraw(current);
 getkey();
 if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
 current=1;
 elseif MOUSE.HOLD(x3+1,y1+1,x4-1,y2-1) then
 current=2;
 elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
 current=0;
 PlayWavE(0);
 redraw(current);
 if notWar then
 lib.Delay(100);
 else
 WarDelay(4);
 end
 return true;
 elseif MOUSE.CLICK(x3+1,y1+1,x4-1,y2-1) then
 current=0;
 PlayWavE(0);
 redraw(current);
 if notWar then
 lib.Delay(100);
 else
 WarDelay(4);
 end
 return false;
 else
 current=0;
 end
 end
end
--显示字符串并等待击键，字符串带框，显示在屏幕中间
function DrawStrBoxWaitKey(s,color,size) --显示字符串并等待击键
 lib.GetKey();
 lib.FillColor(0,0,0,0,0);
 DrawStrBox(-1,-1,s,color,size);
 ShowScreen();
 WaitKey();
end
function DrawStrBoxWaitKey(s,color) --显示字符串并等待击键
 lib.GetKey();
 local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
 DrawYJZBox(-1,-1,s,color,true)
 ShowScreen();
 WaitKey();
 lib.LoadSur(sid,0,0);
 lib.FreeSur(sid);
 ShowScreen();
end
function WarDrawStrBoxWaitKey(s,color,x,y) --显示字符串并等待击键 适用于战斗，画面保持刷新
 x=x or -1;
 y=y or -1;
 lib.GetKey();
 while true do
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 DrawYJZBox(x,y,s,color);
 local eventtype,keypress,x,y=lib.GetMouse(1);
 ReFresh();
 if eventtype==1 or eventtype==3 then
 break;
 end
 end
end
function WarDrawStrBoxDelay(s,color,x,y,n) --显示字符串并等待击键 适用于战斗，画面保持刷新
 x=x or -1;
 y=y or -1;
 n=n or 36;
 lib.GetKey();
 for i=1,n do
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 DrawYJZBox(x,y,s,color);
 local eventtype,keypress,x,y=lib.GetMouse(1);
 ReFresh();
 if eventtype==1 or eventtype==3 then
 break;
 end
 end
end
function DrawYJZBox(x,y,str,color,notWar) --显示带框的字符串
 notWar=notWar or false;
 local size=16;
 local strarray={}
 local num,maxlen;
 maxlen=0
 num,strarray=Split(str,'*')
 for i=1,num do
 local len=#strarray[i];
 if len>maxlen then
 maxlen=len
 end
 end
 if maxlen==0 then
 return;
 end
 local w=size*maxlen/2+2*CC.MenuBorderPixel;
 local h=2*CC.MenuBorderPixel+size*num+6*(num-1);
 if x==-1 then
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 x=16+(576-w)/2;
 elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 x=16+(640-w)/2;
 else
 x=(CC.ScreenW-w)/2;
 end
 end
 if y==-1 then
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 y=32+(432-h)/2;
 elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 y=16+(400-h)/2;
 else
 y=(CC.ScreenH-h)/2;
 end
 end
 if x<0 then
 x=CC.ScreenW-size/2*maxlen-2*CC.MenuBorderPixel+x;
 end
 if y<0 then
 y=CC.ScreenH-size*num-2*CC.MenuBorderPixel+y;
 end
 local boxw,boxh;
 boxw=16*math.modf(w/16)+16+14;
 boxh=16*math.modf(h/16)+16+14;
 local boxx=x-(boxw-w)/2;
 local boxy=y-(boxh-h)/2;
 --382x126
 --Left Top
 lib.SetClip(boxx,boxy,boxx+boxw/2,boxy+boxh/2);
 lib.PicLoadCache(4,50*2,boxx,boxy,1);
 lib.SetClip(0,0,0,0);
 --Left Bot
 lib.SetClip(boxx,boxy+boxh/2,boxx+boxw/2,boxy+boxh);
 lib.PicLoadCache(4,50*2,boxx,boxy+boxh-126,1);
 lib.SetClip(0,0,0,0);
 --Right Top
 lib.SetClip(boxx+boxw/2,boxy,boxx+boxw,boxy+boxh/2);
 lib.PicLoadCache(4,50*2,boxx+boxw-382,boxy,1);
 lib.SetClip(0,0,0,0);
 --Right Bot
 lib.SetClip(boxx+boxw/2,boxy+boxh/2,boxx+boxw,boxy+boxh);
 lib.PicLoadCache(4,50*2,boxx+boxw-382,boxy+boxh-126,1);
 lib.SetClip(0,0,0,0);
 --
 lib.SetClip(boxx+7,boxy+7,boxx+boxw-7,boxy+boxh-7);
 lib.PicLoadCache(4,50*2,boxx,boxy,1);
 lib.SetClip(0,0,0,0);
 for i=1,num do
 DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel+(size+6)*(i-1),strarray[i],color,size);
 end
end

function DrawYJZBox_sub(x,y,w,h)
 local boxw,boxh;
 boxw=16*math.modf(w/16)+16+14;
 boxh=16*math.modf(h/16)+16+14;
 local boxx=x-(boxw-w)/2;
 local boxy=y-(boxh-h)/2;
 --382x126
 --Left Top
 lib.SetClip(boxx,boxy,boxx+boxw/2,boxy+boxh/2);
 lib.PicLoadCache(4,50*2,boxx,boxy,1);
 lib.SetClip(0,0,0,0);
 --Left Bot
 lib.SetClip(boxx,boxy+boxh/2,boxx+boxw/2,boxy+boxh);
 lib.PicLoadCache(4,50*2,boxx,boxy+boxh-126,1);
 lib.SetClip(0,0,0,0);
 --Right Top
 lib.SetClip(boxx+boxw/2,boxy,boxx+boxw,boxy+boxh/2);
 lib.PicLoadCache(4,50*2,boxx+boxw-382,boxy,1);
 lib.SetClip(0,0,0,0);
 --Right Bot
 lib.SetClip(boxx+boxw/2,boxy+boxh/2,boxx+boxw,boxy+boxh);
 lib.PicLoadCache(4,50*2,boxx+boxw-382,boxy+boxh-126,1);
 lib.SetClip(0,0,0,0);
end
function WarDrawStrBoxDelay2(s,color,x,y,n) --显示字符串并等待击键 适用于战斗，画面保持刷新
 x=x or -1;
 y=y or -1;
 n=n or 16;
 lib.GetKey();
 for i=1,n do
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 DrawYJZBox2(x,y,s,color);
 lib.GetKey();
 ReFresh();
 end
end
function DrawYJZBox2(x,y,str,color) --显示带框的字符串
 local size=16;
 local strarray={}
 local num,maxlen;
 maxlen=0
 num,strarray=Split(str,'*')
 for i=1,num do
 local len=#strarray[i];
 if len>maxlen then
 maxlen=len
 end
 end
 if maxlen==0 then
 return;
 end
 local w=size*maxlen/2+2*CC.MenuBorderPixel;
 local h=2*CC.MenuBorderPixel+size*num+6*(num-1);
 
 if x==-1 then
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 x=16+(576-w)/2;
 elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 x=16+(640-w)/2;
 else
 x=(CC.ScreenW-w)/2;
 end
 end
 if y==-1 then
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 y=32+(432-h)/2;
 elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 y=16+(400-h)/2;
 else
 y=(CC.ScreenH-h)/2;
 end
 end
 if x<0 then
 x=CC.ScreenW-size/2*maxlen-2*CC.MenuBorderPixel+x;
 end
 if y<0 then
 y=CC.ScreenH-size*num-2*CC.MenuBorderPixel+y;
 end
 local boxw,boxh;
 boxw=16*math.modf(w/16)+16+14;
 boxh=16*math.modf(h/16)+16+14;
 local boxx=x-(boxw-w)/2;
 local boxy=y-(boxh-h)/2;
 --382x126
 --Left Top
 lib.SetClip(boxx,boxy,boxx+boxw/2,boxy+boxh/2);
 lib.PicLoadCache(4,60*2,boxx,boxy,1);
 lib.SetClip(0,0,0,0);
 --Left Bot
 lib.SetClip(boxx,boxy+boxh/2,boxx+boxw/2,boxy+boxh);
 lib.PicLoadCache(4,60*2,boxx,boxy+boxh-110,1);
 lib.SetClip(0,0,0,0);
 --Right Top
 lib.SetClip(boxx+boxw/2,boxy,boxx+boxw,boxy+boxh/2);
 lib.PicLoadCache(4,60*2,boxx+boxw-142,boxy,1);
 lib.SetClip(0,0,0,0);
 --Right Bot
 lib.SetClip(boxx+boxw/2,boxy+boxh/2,boxx+boxw,boxy+boxh);
 lib.PicLoadCache(4,60*2,boxx+boxw-142,boxy+boxh-110,1);
 lib.SetClip(0,0,0,0);
 --
 lib.SetClip(boxx+7,boxy+7,boxx+boxw-7,boxy+boxh-7);
 lib.PicLoadCache(4,50*2,boxx,boxy,1);
 lib.SetClip(0,0,0,0);
 for i=1,num do
 DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel+(size+6)*(i-1),strarray[i],color,size);
 end
end
function ShowScreen()
 if JY.Dark then
 Light();
 else
 lib.ShowSurface(0);
 end
end

function RGB(r,g,b) --设置颜色RGB
 return r*65536+g*256+b;
end

function GetRGB(color) --分离颜色的RGB分量
 color=color%(65536*256);
 local r=math.floor(color/65536);
 color=color%65536;
 local g=math.floor(color/256);
 local b=color%256;
 return r,g,b
end

--等待键盘输入
function WaitKey(flag) --等待键盘输入
 local keyPress=-1;
 while true do
 local eventtype,keypress,x,y=lib.GetMouse(1);
 if eventtype==1 or eventtype==3 then
 MOUSE.status='IDLE';
 break;
 end
 lib.Delay(20);
 end
 lib.Delay(100);
 return keyPress;
end

function LoadRecord(id) -- 读取游戏进度
 Dark();
 local t1=lib.GetTime();
 local data=Byte.create(4*8);
 --读取savedata
 Byte.loadfile(data,CC.SavedataFile,0,4*8);
 CC.font=Byte.get16(data,0);
 CC.MusicVolume=Byte.get16(data,2);
 CC.SoundVolume=Byte.get16(data,4);
CC.zdby=Byte.get16(data,6);
CC.cldh=Byte.get16(data,8);
CC.MoveSpeed=Byte.get16(data,10);
Config();
PicCatchIni();
 --lib.LoadSoundConfig(CC.MusicVolume,CC.SoundVolume);
 --读取R*.idx文件
 Byte.loadfile(data,CC.R_IDXFilename[0],0,4*8);
 local idx={}
 idx[0]=100;
 for i =1,8 do
 idx[i]=Byte.get32(data,4*(i-1));
 end
 --读取R*.grp文件
 JY.Data_Base=Byte.create(idx[1]-idx[0]); --基本数据
 Byte.loadfile(JY.Data_Base,CC.R_GRPFilename[id],idx[0],idx[1]-idx[0]);
 --设置访问基本数据的方法，这样就可以用访问表的方式访问了．而不用把二进制数据转化为表．节约加载时间和空间
 local meta_t={
 __index=function(t,k)
 return GetDataFromStruct(JY.Data_Base,0,CC.Base_S,k);
 end,

 __newindex=function(t,k,v)
 SetDataFromStruct(JY.Data_Base,0,CC.Base_S,k,v);
 end
 }
 setmetatable(JY.Base,meta_t);
 
 JY.PersonNum=math.floor((idx[2]-idx[1])/CC.PersonSize); --人物 /newgamesave和实际存档 混合读取
 JY.Data_Person_Base=Byte.create(CC.PersonSize*JY.PersonNum);
 JY.Data_Person=Byte.create(CC.PersonSize*JY.PersonNum);
 Byte.loadfile(JY.Data_Person_Base, CC.R_GRPFilename[0],idx[1],CC.PersonSize*JY.PersonNum);
 Byte.loadfile(JY.Data_Person, CC.R_GRPFilename[id],idx[1],CC.PersonSize*JY.PersonNum);
 for i=0,JY.PersonNum-1 do
 JY.Person[i]={};
 if i<421 then
 local meta_t={
 __index=function(t,k)
 return GetPersonData(i*CC.PersonSize,CC.Person_S,k); --421以前的人物混合读取，421以后为新武将
 end,

 __newindex=function(t,k,v)
 SetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k,v);
 end
 }
 setmetatable(JY.Person[i],meta_t);
 else
 local meta_t={
 __index=function(t,k)
 return GetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k);
 end,

 __newindex=function(t,k,v)
 SetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k,v);
 end
 }
 setmetatable(JY.Person[i],meta_t);
 end
 end
 JY.BingzhongNum=math.floor((idx[3]-idx[2])/CC.BingzhongSize); --兵种 /读取newgamesave
 JY.Data_Bingzhong=Byte.create(CC.BingzhongSize*JY.BingzhongNum);
 Byte.loadfile(JY.Data_Bingzhong,CC.R_GRPFilename[0],idx[2],CC.BingzhongSize*JY.BingzhongNum);
 for i=0,JY.BingzhongNum-1 do
 JY.Bingzhong[i]={};
 local meta_t={
 __index=function(t,k)
 return GetDataFromStruct(JY.Data_Bingzhong,i*CC.BingzhongSize,CC.Bingzhong_S,k);
 end,

 __newindex=function(t,k,v)
 SetDataFromStruct(JY.Data_Bingzhong,i*CC.BingzhongSize,CC.Bingzhong_S,k,v);
 end
 }
 setmetatable(JY.Bingzhong[i],meta_t);
 end
 JY.SceneNum=math.floor((idx[4]-idx[3])/CC.SceneSize); --场景
 JY.Data_Scene=Byte.create(CC.SceneSize*JY.SceneNum);
 Byte.loadfile(JY.Data_Scene,CC.R_GRPFilename[id],idx[3],CC.SceneSize*JY.SceneNum);
 for i=0,JY.SceneNum-1 do
 JY.Scene[i]={};
 local meta_t={
 __index=function(t,k)
 return GetDataFromStruct(JY.Data_Scene,i*CC.SceneSize,CC.Scene_S,k);
 end,

 __newindex=function(t,k,v)
 SetDataFromStruct(JY.Data_Scene,i*CC.SceneSize,CC.Scene_S,k,v);
 end
 }
 setmetatable(JY.Scene[i],meta_t);
 end
 JY.ItemNum=math.floor((idx[5]-idx[4])/CC.ItemSize); --道具 /读取newgamesave
 JY.Data_Item=Byte.create(CC.ItemSize*JY.ItemNum);
 Byte.loadfile(JY.Data_Item,CC.R_GRPFilename[0],idx[4],CC.ItemSize*JY.ItemNum);
 for i=0,JY.ItemNum-1 do
 JY.Item[i]={};
 local meta_t={
 __index=function(t,k)
 return GetDataFromStruct(JY.Data_Item,i*CC.ItemSize,CC.Item_S,k);
 end,

 __newindex=function(t,k,v)
 SetDataFromStruct(JY.Data_Item,i*CC.ItemSize,CC.Item_S,k,v);
 end
 }
 setmetatable(JY.Item[i],meta_t);
 end
 JY.MagicNum=math.floor((idx[6]-idx[5])/CC.MagicSize); --策略 /读取newgamesave
 JY.Data_Magic=Byte.create(CC.MagicSize*JY.MagicNum);
 Byte.loadfile(JY.Data_Magic,CC.R_GRPFilename[0],idx[5],CC.MagicSize*JY.MagicNum);
 for i=0,JY.MagicNum-1 do
 JY.Magic[i]={};
 local meta_t={
 __index=function(t,k)
 return GetDataFromStruct(JY.Data_Magic,i*CC.MagicSize,CC.Magic_S,k);
 end,

 __newindex=function(t,k,v)
 SetDataFromStruct(JY.Data_Magic,i*CC.MagicSize,CC.Magic_S,k,v);
 end
 }
 setmetatable(JY.Magic[i],meta_t);
 end
 JY.SkillNum=math.floor((idx[7]-idx[6])/CC.SkillSize); --特技 /读取newgamesave
 JY.Data_Skill=Byte.create(CC.SkillSize*JY.SkillNum);
 Byte.loadfile(JY.Data_Skill,CC.R_GRPFilename[0],idx[6],CC.SkillSize*JY.SkillNum);
 for i=0,JY.SkillNum-1 do
 JY.Skill[i]={};
 local meta_t={
 __index=function(t,k)
 return GetDataFromStruct(JY.Data_Skill,i*CC.SkillSize,CC.Skill_S,k);
 end,

 __newindex=function(t,k,v)
 SetDataFromStruct(JY.Data_Skill,i*CC.SkillSize,CC.Skill_S,k,v);
 end
 }
 setmetatable(JY.Skill[i],meta_t);
 end
 collectgarbage();
 lib.Debug(string.format("Loadrecord%d time=%d",id,lib.GetTime()-t1));
 
 JY.Smap={};
 for i=1,JY.SceneNum-1 do
 if JY.Scene[i]["人物"]>0 then
 AddPerson(JY.Scene[i]["人物"],JY.Scene[i]["坐标X"],JY.Scene[i]["坐标Y"],JY.Scene[i]["方向"]);
 end
 end
 JY.SubScene=JY.Base["当前场景"];
 JY.EventID=JY.Base["当前事件"];
 JY.CurrentBGM=JY.Base["当前音乐"];
 JY.LLK_N=0;

 if CC.font==1 then
CC.FontName=CONFIG.CurrentPath.."font/font.ttf"
 end

 if JY.Base["游戏模式"]==1 then
CC.Enhancement=true
 else
CC.Enhancement=false
 end

 if id>0 then

 if ((JY.Status==GAME_SMAP_MANUAL or JY.Status==GAME_START) and JY.Base["战场存档"]==0) then
 DrawSMap();
 end

 if ((JY.Status==GAME_WMAP or JY.Status==GAME_START) and JY.Base["战场存档"]==1) then
 end

 JY.Status=JY.Base["当前状态"];

 if JY.Base["战场存档"]==1 then
 WarLoad(id);
 end

 if JY.CurrentBGM>=0 then
 PlayBGM(JY.CurrentBGM);
 end

 Light();

 end

end

function fileexist(filename) --检测文件是否存在
 local inp=io.open(filename,"rb");
 if inp==nil then
 return false;
 end
 inp:close();
 return true;
end
function copyfile(source,destination)
 local sourcefile = io.open(source,"rb")
 local destinationfile = io.open(destination,"wb")
 destinationfile:write(sourcefile:read("*a"))
 sourcefile:close()
 destinationfile:close()
end
-- 写游戏进度
-- id=0 新进度，=1/2/3 进度
function SaveRecord(id) -- 写游戏进度
 local t1=lib.GetTime()
 --
 if JY.Status==GAME_WMAP then
 JY.Base["战场存档"]=1;
 else
 JY.Base["战场存档"]=0;
 end
 JY.Base["时间"]=string.sub(os.date("%m/%d/%y %X"),0,14);
 JY.Base["当前状态"]=JY.Status;
 JY.Base["当前事件"]=JY.EventID;
 JY.Base["当前场景"]=JY.SubScene;
 JY.Base["当前音乐"]=JY.CurrentBGM;
 for i=1,JY.SceneNum-1 do
 JY.Scene[i]["人物"]=0;
 JY.Scene[i]["坐标X"]=0;
 JY.Scene[i]["坐标Y"]=0;
 JY.Scene[i]["方向"]=0;
 end
 local n=#JY.Smap;
 for i=1,math.min(n,JY.SceneNum-1) do
 JY.Scene[i]["人物"]=JY.Smap[i][1];
 JY.Scene[i]["坐标X"]=JY.Smap[i][2];
 JY.Scene[i]["坐标Y"]=JY.Smap[i][3];
 JY.Scene[i]["方向"]=JY.Smap[i][4];
 end
 local data=Byte.create(4*8);
 --读取savedata
 Byte.set16(data,0,CC.font);
 Byte.set16(data,2,CC.MusicVolume);
 Byte.set16(data,4,CC.SoundVolume);
Byte.set16(data,6,CC.zdby)
Byte.set16(data,8,CC.cldh)
Byte.set16(data,10,CC.MoveSpeed)
 Byte.savefile(data,CC.SavedataFile,0,4*8);
 --读取R*.idx文件
 Byte.loadfile(data,CC.R_IDXFilename[0],0,4*8);
 local idx={}
 idx[0]=100;
 for i =1,8 do
 idx[i]=Byte.get32(data,4*(i-1));
 end

 --写R*.grp文件
 if true then--not fileexist(CC.R_GRPFilename[id]) then
 copyfile(CC.R_GRPFilename[0],CC.R_GRPFilename[id])
 end
 
 Byte.savefile(JY.Data_Base,CC.R_GRPFilename[id],idx[0],idx[1]-idx[0]);

 Byte.savefile(JY.Data_Person,CC.R_GRPFilename[id],idx[1],CC.PersonSize*JY.PersonNum);

 --Byte.savefile(JY.Data_Bingzhong,CC.R_GRPFilename[id],idx[2],CC.BingzhongSize*JY.BingzhongNum);

 Byte.savefile(JY.Data_Scene,CC.R_GRPFilename[id],idx[3],CC.SceneSize*JY.SceneNum);

 --Byte.savefile(JY.Data_Wugong,CC.R_GRPFilename[id],idx[4],CC.WugongSize*JY.WugongNum);

 --Byte.savefile(JY.Data_Shop,CC.R_GRPFilename[id],idx[5],CC.ShopSize*JY.ShopNum);
 lib.Debug(string.format("SaveRecord time=%d",lib.GetTime()-t1));

end
--从数据的结构中翻译数据
--data 二进制数组
--offset data中的偏移
--t_struct 数据的结构，在jyconst中有很多定义
--key 访问的key
function GetDataFromStruct(data,offset,t_struct,key) --从数据的结构中翻译数据，用来取数据
 local t=t_struct[key];
 local r;
 if t[2]==0 then
 if t[3]==1 then
 r=Byte.get8(data,t[1]+offset);
 else
 r=Byte.get16(data,t[1]+offset);
 end
 elseif t[2]==1 then
 r=Byte.getu16(data,t[1]+offset);
 elseif t[2]==2 then
 if CC.SrcCharSet==1 then
 r=lib.CharSet(Byte.getstr(data,t[1]+offset,t[3]),0);
 else
 r=Byte.getstr(data,t[1]+offset,t[3]);
 end
 end
 
 return r;
end
function SetDataFromStruct(data,offset,t_struct,key,v) --从数据的结构中翻译数据，保存数据
 local t=t_struct[key];
 
 if t[2]==0 then
 if t[3]==1 then
 Byte.set8(data,t[1]+offset,v);
 else
 Byte.set16(data,t[1]+offset,v);
 end
 elseif t[2]==1 then
 Byte.setu16(data,t[1]+offset,v);
 elseif t[2]==2 then
 local s;
 if CC.SrcCharSet==1 then
 s=lib.CharSet(v,1);
 else
 s=v;
 end
 Byte.setstr(data,t[1]+offset,t[3],s);
 end
end
function GetPersonData(offset,t_struct,key)
 if t_struct[key][4] then
 return GetDataFromStruct(JY.Data_Person,offset,t_struct,key);
 else
 return GetDataFromStruct(JY.Data_Person_Base,offset,t_struct,key);
 end
end
function between(v,Min,Max)
 if Min>Max then
 Min,Max=Max,Min;
 end
 if v>=Min and v<=Max then
 return true;
 end
 return false;
end
function ResizeScreen(w,h)
 return
end
function Light() --场景变亮
 if JY.Dark then
 JY.Dark=false;
 lib.ShowSlow(CC.FrameNum,0);
 lib.GetKey();
 end
end
function Dark() --场景变黑
 if not JY.Dark then
 JY.Dark=true;
 lib.ShowSlow(CC.FrameNum,1);
 lib.GetKey();
 end
end
--播放MP3
function PlayBGM(id)
 id=id or 0
 JY.CurrentBGM=id;
 if JY.EnableMusic==0 then
 return ;
 end
 if id>=0 and id<=19 then
 lib.PlayMIDI(string.format(CC.BGMFile,id));
 end
end
function StopBGM()
 JY.CurrentBGM=-1;
 lib.PlayMIDI("");
end
--播放音效e**
function PlayWavE(id) --播放音效e**
 if JY.EnableSound==0 then
 return ;
 end
 if id>=0 then
 lib.PlayWAV(string.format(CC.EFile,id));
 end
end
--产生对话显示需要的字符串，即每隔n个中文字符加一个星号
function GenTalkString(str,n) --产生对话显示需要的字符串
 local tmpstr="";
 local num=0;
 for s in string.gmatch(str .. "*","(.-)%*") do --去掉对话中的所有*. 字符串尾部加一个星号，避免无法匹配
 tmpstr=tmpstr .. s;
 end

 local newstr="";
 while #tmpstr>0 do
 num=num+1;
 local w=0;
 while w<#tmpstr do
 local v=string.byte(tmpstr,w+1); --当前字符的值
 if v>=128 then
 w=w+2;
 else
 w=w+1;
 end
 if w >= 2*n-1 then --为了避免跨段中文字符
 break;
 end
 end

 if w<#tmpstr then
 if w==2*n-1 and string.byte(tmpstr,w+1)<128 then
 newstr=newstr .. string.sub(tmpstr,1,w+1) .. "*";
 tmpstr=string.sub(tmpstr,w+2,-1);
 else
 newstr=newstr .. string.sub(tmpstr,1,w) .. "*";
 tmpstr=string.sub(tmpstr,w+1,-1);
 end
 else
 newstr=newstr .. tmpstr;
 break;
 end
 end
 return newstr,num;
end

function ShowMenu(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor) --通用菜单函数

 if JY.Status==GAME_START then
local mstr="三国志英杰传复刻版"
local msize=50
DrawString(160,30,mstr,C_ORANGE,msize)
mstr="纵横天下"
DrawString(285,90,mstr,C_ORANGE,msize)
mstr="大武侠论坛出品"
DrawString(210,400,mstr,C_ORANGE,msize)
 end

 local w=0;
 local h=0; --边框的宽高
 local i=0;
 local num=0; --实际的显示菜单项
 local newNumItem=0; --能够显示的总菜单项数
 size=size or CC.Fontbig;
 size=16;
 color=color or C_ORANGE;
 selectColor=selectColor or C_WHITE;
 lib.GetKey();

 local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH);
 local newMenu={}; -- 定义新的数组，以保存所有能显示的菜单项

 --计算能够显示的总菜单项数
 for i=1,numItem do
 if menuItem[i][3]>0 then
 newNumItem=newNumItem+1;
 newMenu[newNumItem]={menuItem[i][1],menuItem[i][2],menuItem[i][3],i,1}; --新数组多了[4],保存和原数组的对应
 --新数组多了[5], 代表对齐 123 左中右
 if string.sub(menuItem[i][1],1,1)=="@" then
 newMenu[newNumItem][1]=string.sub(menuItem[i][1],2);
 newMenu[newNumItem][5]=2;
 end
 end
 end

 --计算实际显示的菜单项数
 if numShow==0 or numShow > newNumItem then
 num=newNumItem;
 else
 num=numShow;
 end

 --计算边框实际宽高
 local maxlength=0;
 if x2==0 and y2==0 then
 for i=1,newNumItem do
 if string.len(newMenu[i][1])>maxlength then
 maxlength=string.len(newMenu[i][1]);
 end
 end
 w=size*maxlength/2+2*CC.MenuBorderPixel; --按照半个汉字计算宽度，一边留4个象素
 h=(size+CC.RowPixel)*num+CC.MenuBorderPixel; --字之间留4个象素，上面再留4个象素
 else
 w=x2-x1;
 h=y2-y1;
 num=math.min(num,(math.modf(h/(size+CC.RowPixel))));
 end
 --[[
 if x1==0 and y1==0 then
 x1=(CC.ScreenW-w)/2;
 y1=(CC.ScreenH-h)/2;
 end
 if x1==-1 then
 x1=(CC.ScreenW-w)/2;
 end
 if y1==-1 then
 y1=(CC.ScreenH-h)/2;
 end]]--
 
 local start=1; --显示的第一项

 local current =0; --当前选择项
 for i=1,newNumItem do
 if newMenu[i][3]==2 then
 current=i;
 break;
 end
 end
 if current > num then
 start=1+current-num;
 end
 --[[
 if numShow~=0 then
 current=1;
 end]]--
 if JY.Menu_keep then
 start=JY.Menu_start;
 current=JY.Menu_current;
 end
 local keyPress =-1;
 local returnValue =0;
 
 local x_off,y_off,row_off,h_off=0,0,0,0;
 
 if isBox==1 then
 x_off=3;
 y_off=7;
 row_off=4;
 h_off=8;
 w=80;
 h=16+24*num;
 elseif isBox==2 then
 x_off=4;
 y_off=6;
 row_off=4;
 h_off=8;
 w=144;
 h=16+24*num;
 elseif isBox==20 then --2的加宽版本
 x_off=4;
 y_off=6;
 row_off=4;
 h_off=8;
 w=420;
 h=16+24*num;
 elseif isBox==3 then --baseon 2，调整宽度
 x_off=4;
 y_off=6;
 row_off=4;
 h_off=8;
 w=96;
 h=16+24*num;
 elseif isBox==4 then
 x_off=11;
 y_off=9;
 row_off=0;
 h_off=12;
 w=112;
 h=16+8+20*num;
 elseif isBox==5 then --策略<=8用
 x_off=4;
 y_off=9;
 row_off=0;
 h_off=12;
 w=104;
 h=16+8+20*num;
 elseif isBox==6 then --策略>8用
 x_off=4;
 y_off=9;
 row_off=0;
 h_off=12;
 w=120-20;
 h=16+8+20*num;
 elseif isBox==9 then
 DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
 end
 
 if x1==-1 or x1==0 then
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 x1=16+(576-w)/2;
 elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 x1=16+(640-w)/2;
 else
 x1=(CC.ScreenW-w)/2;
 end
 end
 if y1==-1 or y1==0 then
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 y1=32+(432-h)/2;
 elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 y1=16+(400-h)/2;
 else
 y1=(CC.ScreenH-h)/2;
 end
 end
 local function redraw(flag)
 if num~=0 then --暂且这样改
 --Cls(x1,y1,x1+w,y1+h);
 if isBox==1 then
 lib.SetClip(x1,y1,x1+w,y1+8+24*num);
 lib.PicLoadCache(4,0*2,x1,y1,1);
 lib.SetClip(0,0,0,0);
 lib.SetClip(x1,y1+8+24*math.max(0,(num-8)),x1+w,y1+8+24*num+8);
 lib.PicLoadCache(4,0*2,x1,y1+16+24*num-256,1);
 lib.SetClip(0,0,0,0);
 elseif isBox==2 then
 --[[
 local x,y,w,h=400,128,80,48
 lib.FillColor(x,y,x+w,y+h,C_ORANGE)
 lib.SetClip(x,y,x+w,y+h);
 lib.FillColor(0,0,0,0,C_WHITE)
 lib.PicLoadCache(4,20*2,8,8,1);
 lib.SetClip(0,0,0,0);
 lib.SetClip(0,0,0,0);]]--
 lib.SetClip(x1,y1,x1+w,y1+7+24*num);
 lib.PicLoadCache(4,60*2,x1,y1,1);
 lib.SetClip(0,0,0,0);
 lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8);
 lib.PicLoadCache(4,60*2,x1,y1+14+24*num-110,1);
 lib.SetClip(0,0,0,0);
 elseif isBox==20 then
 lib.SetClip(x1,y1,x1+w,y1+7+24*num);
 lib.PicLoadCache(4,70*2,x1,y1,1);
 lib.SetClip(0,0,0,0);
 lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8);
 lib.PicLoadCache(4,70*2,x1,y1+14+24*num-110,1);
 lib.SetClip(0,0,0,0);
 elseif isBox==3 then
 lib.SetClip(x1,y1,x1+w,y1+7+24*num);
 lib.PicLoadCache(4,63*2,x1,y1,1);
 lib.SetClip(0,0,0,0);
 lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8);
 lib.PicLoadCache(4,63*2,x1,y1+14+24*num-182,1);
 lib.SetClip(0,0,0,0);
 elseif isBox==4 then
 lib.SetClip(x1,y1,x1+w,y1+h);
 lib.PicLoadCache(4,59*2,x1,y1,1);
 lib.SetClip(0,0,0,0);
 lib.SetClip(x1,y1+h-8,x1+w,y1+h);
 lib.PicLoadCache(4,59*2,x1,y1-(384-h),1);
 lib.SetClip(0,0,0,0);
 elseif isBox==5 then
 lib.SetClip(x1,y1,x1+w,y1+h);
 lib.PicLoadCache(4,66*2,x1,y1,1);
 lib.SetClip(0,0,0,0);
 lib.SetClip(x1,y1+h-8,x1+w,y1+h);
 lib.PicLoadCache(4,66*2,x1,y1-(384-h),1);
 lib.SetClip(0,0,0,0);
 elseif isBox==6 then
 lib.SetClip(x1,y1,x1+w+20,y1+h);
 lib.PicLoadCache(4,67*2,x1,y1,1);
 lib.SetClip(0,0,0,0);
 lib.SetClip(x1,y1+h-32,x1+w+20,y1+h);
 lib.PicLoadCache(4,67*2,x1,y1-(384-h),1);
 lib.SetClip(0,0,0,0);
 
 local nn=newNumItem-num;
 local nn_row=120;
 lib.PicLoadCache(4,68*2,x1+98,y1+24+nn_row*(start-1)/nn,1);
 elseif isBox==9 then
 DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
 end
 end

 for i=start,start+num-1 do
 local drawColor=color; --设置不同的绘制颜色
 local menustr=newMenu[i][1];
 local dx=0;
 if newMenu[i][5]==2 then
 dx=size*(maxlength-string.len(menustr))/2/2;
 end
 if i==current then
 drawColor=selectColor;
 end
 if isBox==1 then
 if i==current then
 lib.PicLoadCache(4,2*2,x1+6,y1+9+24*(i-1),1);
 DrawString(x1+dx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 else
 lib.PicLoadCache(4,1*2,x1+6,y1+9+24*(i-1),1);
 DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 end
 elseif isBox==2 then
 if i==current then
 lib.PicLoadCache(4,62*2,x1+6,y1+8+24*(i-1),1);
 DrawString(x1+dx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 else
 lib.PicLoadCache(4,61*2,x1+6,y1+8+24*(i-1),1);
 DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 end
 elseif isBox==20 then
 if i==current then
 lib.PicLoadCache(4,72*2,x1+6,y1+8+24*(i-1),1);
 DrawString(x1+dx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 else
 lib.PicLoadCache(4,71*2,x1+6,y1+8+24*(i-1),1);
 DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 end
 elseif isBox==3 then
 if i==current then
 lib.PicLoadCache(4,65*2,x1+6,y1+8+24*(i-1),1);
 DrawString(x1+dx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 else
 lib.PicLoadCache(4,64*2,x1+6,y1+8+24*(i-1),1);
 DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 end
 elseif isBox==4 then
 if i==current then
 lib.DrawRect(x1+12,y1+12+20*(i-1),x1+99,y1+12+20*(i),C_WHITE);
 DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 else
 DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 end
 elseif isBox==5 then
 if i==current then
 lib.DrawRect(x1+12,y1+12+20*(i-1),x1+91,y1+12+20*(i),C_WHITE);
 DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 else
 DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 end
 elseif isBox==6 then
 if i==current then
 lib.DrawRect(x1+12,y1+12+20*(i-start),x1+91,y1+12+20*(i-start+1),C_WHITE);
 DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 else
 DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 end
 else
 DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 end
 

 end
 if flag then
 lib.Background(x1,y1,x1+w,y1+h,128);
 end
 end
 local wait=true;
 while wait do
 JY.ReFreshTime=lib.GetTime();
 lib.LoadSur(sid);
 redraw();
 ReFresh();
 local eventtype,keyPress,mx,my=getkey();
 mx,my=MOUSE.x,MOUSE.y;
 if eventtype==3 and keyPress==3 then
 if isEsc==1 then
 wait=false;
 end
 end
 
 if mx>x1+6 and mx<x1+w-6 and my>y1+h_off and my<y1+h-h_off then
 current=math.modf((my-y1-h_off)/(size+CC.RowPixel+row_off));
 if MOUSE.HOLD(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
 current=limitX(start+current,1,newNumItem);
 elseif MOUSE.CLICK(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
 local sel=limitX(start+current,1,newNumItem);
 current=0;
 PlayWavE(0);
 JY.ReFreshTime=lib.GetTime();
 lib.LoadSur(sid);
 redraw();
 ReFresh(CC.OpearteSpeed/2);
 if newMenu[sel][2]==nil then
 returnValue=newMenu[sel][4];
 wait=false;
 else
 redraw();
 JY.MenuPic.num=JY.MenuPic.num+1;
 JY.MenuPic.pic[JY.MenuPic.num]=lib.SaveSur(x1,y1,x1+w,y1+h);
 JY.MenuPic.x[JY.MenuPic.num]=x1;
 JY.MenuPic.y[JY.MenuPic.num]=y1;
 local r=newMenu[sel][2](newMenu[sel][4]); --调用菜单函数
 lib.FreeSur(JY.MenuPic.pic[JY.MenuPic.num]);
 JY.MenuPic.num=JY.MenuPic.num-1;
 if r==1 then
 returnValue=newMenu[sel][4];
 wait=false;
 end
 end
 elseif between(isBox,4,6) and MOUSE.IN(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
 current=limitX(start+current,1,newNumItem);
 --elseif isBox==6 and MOUSE.IN(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7-16,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
 -- current=limitX(start+current,1,newNumItem);
 else
 current=0;
 end
 elseif isBox==6 then
 local nn=newNumItem-num
 local nn_row=120;
 local nn_x=x1+99;
 local nn_y=y1+24+nn_row*start/nn;
 if MOUSE.HOLD(nn_x,y1+24,nn_x+12,y1+24+136) then
 nn_y=MOUSE.y-8;
 start=1+math.modf((nn_y-y1-24)*nn/nn_row);
 start=limitX(start,1,nn+1)
 elseif MOUSE.CLICK(nn_x,y1+9,nn_x+16,y1+24) then
 start=limitX(start-1,1,nn+1);
 elseif MOUSE.CLICK(nn_x,y1+161,nn_x+16,y1+176) then
 start=limitX(start+1,1,nn+1);
 end
 current=0;
 else
 current=0;
 end
 end
 --Cls(x1,y1,x1+w+1,y1+h+1,0,1);
 if returnValue==0 then
 PlayWavE(1);
 end
 lib.LoadSur(sid);
 lib.FreeSur(sid);
 return returnValue;
end

function WarShowMenu(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor) --通用菜单函数
 local w=0;
 local h=0; --边框的宽高
 local i=0;
 local num=0; --实际的显示菜单项
 local newNumItem=0; --能够显示的总菜单项数
 size=size or CC.Fontbig;
 size=16;
 color=color or C_ORANGE;
 selectColor=selectColor or C_WHITE;
 lib.GetKey();

 local newMenu={}; -- 定义新的数组，以保存所有能显示的菜单项

 --计算能够显示的总菜单项数
 for i=1,numItem do
 if menuItem[i][3]>0 then
 newNumItem=newNumItem+1;
 newMenu[newNumItem]={menuItem[i][1],menuItem[i][2],menuItem[i][3],i}; --新数组多了[4],保存和原数组的对应
 end
 end

 --计算实际显示的菜单项数
 if numShow==0 or numShow > newNumItem then
 num=newNumItem;
 else
 num=numShow;
 end

 --计算边框实际宽高
 local maxlength=0;
 if x2==0 and y2==0 then
 for i=1,newNumItem do
 if string.len(newMenu[i][1])>maxlength then
 maxlength=string.len(newMenu[i][1]);
 end
 end
 w=size*maxlength/2+2*CC.MenuBorderPixel; --按照半个汉字计算宽度，一边留4个象素
 h=(size+CC.RowPixel)*num+CC.MenuBorderPixel; --字之间留4个象素，上面再留4个象素
 else
 w=x2-x1;
 h=y2-y1;
 num=math.min(num,(math.modf(h/(size+CC.RowPixel))));
 end
 --[[
 if x1==0 and y1==0 then
 x1=(CC.ScreenW-w)/2;
 y1=(CC.ScreenH-h)/2;
 end
 if x1==-1 then
 x1=(CC.ScreenW-w)/2;
 end
 if y1==-1 then
 y1=(CC.ScreenH-h)/2;
 end]]--
 
 local start=1; --显示的第一项

 local current =0; --当前选择项
 for i=1,newNumItem do
 if newMenu[i][3]==2 then
 current=i;
 break;
 end
 end
 if current > num then
 start=1+current-num;
 end
 --[[
 if numShow~=0 then
 current=1;
 end]]--
 if JY.Menu_keep then
 start=JY.Menu_start;
 current=JY.Menu_current;
 end
 local keyPress =-1;
 local returnValue =0;
 
 local x_off,y_off,row_off,h_off=0,0,0,0;
 
 if isBox==1 then
 x_off=3;
 y_off=7;
 row_off=4;
 h_off=8;
 w=80;
 h=16+24*num;
 elseif isBox==2 then
 x_off=4;
 y_off=6;
 row_off=4;
 h_off=8;
 w=144;
 h=16+24*num;
 elseif isBox==3 then --baseon 2，调整宽度
 x_off=4;
 y_off=6;
 row_off=4;
 h_off=8;
 w=96;
 h=16+24*num;
 elseif isBox==4 then
 x_off=11;
 y_off=9;
 row_off=0;
 h_off=12;
 w=112;
 h=16+8+20*num;
 elseif isBox==5 then --策略<=8用
 x_off=4;
 y_off=9;
 row_off=0;
 h_off=12;
 w=104;
 h=16+8+20*num;
 elseif isBox==6 then --策略>8用
 x_off=4;
 y_off=9;
 row_off=0;
 h_off=12;
 w=120-20;
 h=16+8+20*num;
 elseif isBox==9 then
 DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
 end
 if x1==-1 then
 x1=(CC.ScreenW-w)/2;
 end
 if y1==-1 then
 y1=(CC.ScreenH-h)/2
 end
 local function redraw(flag)
 if num~=0 then --暂且这样改
 --Cls(x1,y1,x1+w,y1+h);
 if isBox==1 then
 lib.SetClip(x1,y1,x1+w,y1+8+24*num);
 lib.PicLoadCache(4,0*2,x1,y1,1);
 lib.SetClip(0,0,0,0);
 lib.SetClip(x1,y1+8+24*math.max(0,(num-8)),x1+w,y1+8+24*num+8);
 lib.PicLoadCache(4,0*2,x1,y1+16+24*num-256,1);
 lib.SetClip(0,0,0,0);
 elseif isBox==2 then
 lib.SetClip(x1,y1,x1+w,y1+7+24*num);
 lib.PicLoadCache(4,60*2,x1,y1,1);
 lib.SetClip(0,0,0,0);
 lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8);
 lib.PicLoadCache(4,60*2,x1,y1+14+24*num-110,1);
 lib.SetClip(0,0,0,0);
 elseif isBox==3 then
 lib.SetClip(x1,y1,x1+w,y1+7+24*num);
 lib.PicLoadCache(4,63*2,x1,y1,1);
 lib.SetClip(0,0,0,0);
 lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8);
 lib.PicLoadCache(4,63*2,x1,y1+14+24*num-110,1);
 lib.SetClip(0,0,0,0);
 elseif isBox==4 then
 lib.SetClip(x1,y1,x1+w,y1+h);
 lib.PicLoadCache(4,59*2,x1,y1,1);
 lib.SetClip(0,0,0,0);
 lib.SetClip(x1,y1+h-8,x1+w,y1+h);
 lib.PicLoadCache(4,59*2,x1,y1-(384-h),1);
 lib.SetClip(0,0,0,0);
 elseif isBox==5 then
 lib.SetClip(x1,y1,x1+w,y1+h);
 lib.PicLoadCache(4,66*2,x1,y1,1);
 lib.SetClip(0,0,0,0);
 lib.SetClip(x1,y1+h-8,x1+w,y1+h);
 lib.PicLoadCache(4,66*2,x1,y1-(384-h),1);
 lib.SetClip(0,0,0,0);
 elseif isBox==6 then
 lib.SetClip(x1,y1,x1+w+20,y1+h);
 lib.PicLoadCache(4,67*2,x1,y1,1);
 lib.SetClip(0,0,0,0);
 lib.SetClip(x1,y1+h-32,x1+w+20,y1+h);
 lib.PicLoadCache(4,67*2,x1,y1-(384-h),1);
 lib.SetClip(0,0,0,0);
 
 local nn=newNumItem-num;
 local nn_row=120;
 lib.PicLoadCache(4,68*2,x1+98,y1+24+nn_row*(start-1)/nn,1);
 elseif isBox==9 then
 DrawBox(x1,y1,x1+w,y1+h,C_WHITE);
 end
 end

 for i=start,start+num-1 do
 local drawColor=color; --设置不同的绘制颜色
 local menustr=newMenu[i][1];
 if i==current then
 drawColor=selectColor;
 end
 if isBox==1 then
 if i==current then
 lib.PicLoadCache(4,2*2,x1+6,y1+9+24*(i-1),1);
 DrawString(x1+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 else
 lib.PicLoadCache(4,1*2,x1+6,y1+9+24*(i-1),1);
 DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 end
 elseif isBox==2 then
 if i==current then
 lib.PicLoadCache(4,62*2,x1+6,y1+8+24*(i-1),1);
 DrawString(x1+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 else
 lib.PicLoadCache(4,61*2,x1+6,y1+8+24*(i-1),1);
 DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 end
 elseif isBox==3 then
 if i==current then
 lib.PicLoadCache(4,65*2,x1+6,y1+8+24*(i-1),1);
 DrawString(x1+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 else
 lib.PicLoadCache(4,64*2,x1+6,y1+8+24*(i-1),1);
 DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 end
 elseif isBox==4 then
 if i==current then
 lib.DrawRect(x1+12,y1+12+20*(i-1),x1+99,y1+12+20*(i),C_WHITE);
 DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 else
 DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 end
 elseif isBox==5 then
 if i==current then
 lib.DrawRect(x1+12,y1+12+20*(i-1),x1+91,y1+12+20*(i),C_WHITE);
 DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 else
 DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 end
 elseif isBox==6 then
 if i==current then
 lib.DrawRect(x1+12,y1+12+20*(i-start),x1+91,y1+12+20*(i-start+1),C_WHITE);
 DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 else
 DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 end
 else
 DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
 menustr,drawColor,size);
 end
 

 end
 if flag then
 lib.Background(x1,y1,x1+w,y1+h,128);
 end
 end
 local wait=true;
 while wait do
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 redraw();
 ReFresh();
 local eventtype,keyPress,mx,my=getkey();
 mx,my=MOUSE.x,MOUSE.y;
 if eventtype==3 and keyPress==3 then
 if isEsc==1 then
 wait=false;
 end
 end
 if mx>x1+6 and mx<x1+w-6 and my>y1+h_off and my<y1+h-h_off then
 current=math.modf((my-y1-h_off)/(size+CC.RowPixel+row_off));
 if MOUSE.HOLD(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
 current=limitX(start+current,1,newNumItem);
 elseif MOUSE.CLICK(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
 local sel=limitX(start+current,1,newNumItem);
 current=0;
 PlayWavE(0);
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 redraw();
 ReFresh(CC.OpearteSpeed);
 if newMenu[sel][2]==nil then
 returnValue=newMenu[sel][4];
 wait=false;
 else
 redraw();
 JY.MenuPic.num=JY.MenuPic.num+1;
 JY.MenuPic.pic[JY.MenuPic.num]=lib.SaveSur(x1,y1,x1+w,y1+h);
 JY.MenuPic.x[JY.MenuPic.num]=x1;
 JY.MenuPic.y[JY.MenuPic.num]=y1;
 local r=newMenu[sel][2](newMenu[sel][4]); --调用菜单函数
 lib.FreeSur(JY.MenuPic.pic[JY.MenuPic.num]);
 JY.MenuPic.num=JY.MenuPic.num-1;
 if r==1 then
 returnValue=newMenu[sel][4];
 wait=false;
 end
 end
 elseif between(isBox,4,6) and MOUSE.IN(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
 current=limitX(start+current,1,newNumItem);
 --elseif isBox==6 and MOUSE.IN(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7-16,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
 -- current=limitX(start+current,1,newNumItem);
 else
 current=0;
 end
 elseif isBox==6 then
 local nn=newNumItem-num
 local nn_row=120;
 local nn_x=x1+99;
 local nn_y=y1+24+nn_row*start/nn;
 if MOUSE.HOLD(nn_x,y1+24,nn_x+12,y1+24+136) then
 nn_y=MOUSE.y-8;
 start=1+math.modf((nn_y-y1-24)*nn/nn_row);
 start=limitX(start,1,nn+1)
 elseif MOUSE.CLICK(nn_x,y1+9,nn_x+16,y1+24) then
 start=limitX(start-1,1,nn+1);
 elseif MOUSE.CLICK(nn_x,y1+161,nn_x+16,y1+176) then
 start=limitX(start+1,1,nn+1);
 end
 current=0;
 else
 current=0;
 end
 end

 --Cls(x1,y1,x1+w+1,y1+h+1,0,1);
 if returnValue==0 then
 PlayWavE(1);
 end
 --[[
 for i=1,CC.OpearteSpeed do
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 redraw();
 ReFresh();
 end]]--
 return returnValue;
 
end

--原jyconfig

--设置全局变量CC，保存游戏中使用的常数
function SetGlobalConst()
 -- SDL 键码定义，这里名字仍然使用directx的名字
 VK_ESCAPE=27
 VK_Y=121
 VK_N=110
 VK_SPACE=32
 VK_RETURN=13

 SDLK_UP=273
 SDLK_DOWN=274
 SDLK_LEFT=276
 SDLK_RIGHT=275

 if CONFIG.Rotate==0 then
 VK_UP=SDLK_UP;
 VK_DOWN=SDLK_DOWN;
 VK_LEFT=SDLK_LEFT;
 VK_RIGHT=SDLK_RIGHT;
 else --右转90度
 VK_UP=SDLK_RIGHT;
 VK_DOWN=SDLK_LEFT;
 VK_LEFT=SDLK_UP;
 VK_RIGHT=SDLK_DOWN;
 end

 -- 游戏中颜色定义
 C_STARTMENU=RGB(132, 0, 4) -- 开始菜单颜色
 C_RED=RGB(216, 20, 24) -- 开始菜单选中项颜色

 C_WHITE=RGB(236, 236, 236); --游戏内常用的几个颜色值
 C_ORANGE=RGB(252, 148, 16);
 C_GOLD=RGB(236, 200, 40);
 C_BLACK=RGB(0,0,0);
 
 M_Black=RGB(0,0,0);
 M_Sienna=RGB(160,82,45);
 M_DarkOliveGreen=RGB(85,107,47);
 M_DarkGreen=RGB(0,100,0);
 M_DarkSlateBlue=RGB(72,61,139);
 M_Navy=RGB(0,0,128);
 M_Indigo=RGB(75,0,130);
 M_DarkSlateGray=RGB(47,79,79);
 M_DarkRed=RGB(139,0,0);
 M_DarkOrange=RGB(255,140,0); --(239,101,0)
 M_Olive=RGB(128,128,0);
 M_Green=RGB(0,128,0);
 M_Teal=RGB(0,128,128);
 M_Blue=RGB(0,0,255);
 M_SlateGray=RGB(112,128,144);
 M_DimGray=RGB(105,105,105);
 M_Red=RGB(255,0,0);
 M_SandyBrown=RGB(244,164,96);
 M_YellowGreen=RGB(154,205,50);
 M_SeaGreen=RGB(46,139,87);
 M_MediumTurquoise=RGB(72,209,204);
 M_RoyalBlue=RGB(65,105,225);
 M_Purple=RGB(128,0,128);
 M_Gray=RGB(128,128,128);
 M_Magenta=RGB(255,0,255);
 M_Orange=RGB(255,165,0);
 M_Yellow=RGB(255,255,0);
 M_Lime=RGB(0,255,0);
 M_Cyan=RGB(0,255,255);
 M_DeepSkyBlue=RGB(0,191,255);
 M_DarkOrchid=RGB(153,50,204);
 M_Silver=RGB(192,192,192);
 M_Pink=RGB(255,192,203);
 M_Wheat=RGB(245,222,179);
 M_LemonChiffon=RGB(255,250,205);
 M_PaleGreen=RGB(152,251,152);
 M_PaleTurquoise=RGB(175,238,238);
 M_LightBlue=RGB(173,216,230);
 M_Plum=RGB(221,160,221);
 M_White=RGB(255,255,255);
 
 C_Name=RGB(255,207,85);

 -- 游戏状态定义
 GAME_START =0 --开始画面,各种选单，事件不开启
 GAME_SMAP_AUTO =1; --场景地图，禁止玩家操作，事件开启
 GAME_SMAP_MANUAL =2; --场景地图，开启玩家操作，事件开启
 GAME_MMAP =3; --大地图，禁止玩家操作，事件开启
 GAME_WMAP =4; --战斗地图，事件开启
 GAME_WMAP2 =5; --战斗地图，用于连续战斗
 GAME_DEAD =6; --死亡画面
 GAME_END =7; --结束
 GAME_WARWIN =8; --战斗胜利
 GAME_WARLOSE =9; --战斗失败
 --战斗事件类型
 War_Event_Turn=1; --回合开始时
 War_Event_Move=2; --人物移动后
 War_Event_Move=3; --
 --游戏数据全局变量
 CC={}; --定义游戏中使用的常量，这些可以在修改游戏时修改之
 CC.Debug=0
CC.font=0
CC.zdsh=0
CC.cldh=1
CC.MoveSpeed=0
 CC.FPS=false
CC.AIXS=false
CC.XYXS=false
CC.RWTS=false
CC.KZAI=false
CC.WXXD=false


 CC.PASCODE= { 
 "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
 "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
 ".","/","?","*","+","-",
 }
 --config
 CC.FontType=0;
 CC.MusicVolume=CONFIG.MusicVolume;
 CC.SoundVolume=CONFIG.SoundVolume
 
 CC.SrcCharSet=0; --源代码的字符集 0 gb 1 big5，用于转换R×。 如果源码被转换为big5，则应设为1
 CC.OSCharSet=CONFIG.OSCharSet; --OS 字符集，0 GB, 1 Big5
 CC.FontName=CONFIG.FontName; --显示字体

 CC.ScreenW=CONFIG.Width; --显示窗口宽高
 CC.ScreenH=CONFIG.Height;

 --定义记录文件名。S和D由于是固定大小，因此不再定义idx了。
 CC.R_IDXFilename={[0]=CONFIG.DataPath .. "newgame.idx",
 CONFIG.DataPath .. "r1.idx",
 CONFIG.DataPath .. "r2.idx",
 CONFIG.DataPath .. "r3.idx",
 CONFIG.DataPath .. "r4.idx",
 CONFIG.DataPath .. "r5.idx",};
 CC.R_GRPFilename={[0]=CONFIG.DataPath .. "newgame.grp",
 CONFIG.DataPath .. "SAVE0.sav",
 CONFIG.DataPath .. "SAVE1.sav",
 CONFIG.DataPath .. "SAVE2.sav",
 CONFIG.DataPath .. "SAVE3.sav",
 CONFIG.DataPath .. "SAVE4.sav",};
 CC.S_Filename={[0]=CONFIG.DataPath .. "allsin.grp",
 CONFIG.DataPath .. "s1.grp",
 CONFIG.DataPath .. "s2.grp",
 CONFIG.DataPath .. "s3.grp",};

 CC.TempS_Filename=CONFIG.DataPath .. "allsinbk.grp";

 CC.D_Filename={[0]=CONFIG.DataPath .. "alldef.grp",
 CONFIG.DataPath .. "d1.grp",
 CONFIG.DataPath .. "d2.grp",
 CONFIG.DataPath .. "d3.grp",};

 CC.PaletteFile=CONFIG.DataPath .. "mmap.col";
 CC.SavedataFile=CONFIG.DataPath .. "savedata.grp";
 CC.MapFile=CONFIG.DataPath .. "HEXZMAP.R3";
 CC.FirstFile=CONFIG.PicturePath .. "title.png";
 CC.DeadFile=CONFIG.PicturePath .. "dead.png";

 CC.MMapFile={CONFIG.DataPath .. "earth.002",
 CONFIG.DataPath .. "surface.002",
 CONFIG.DataPath .. "building.002",
 CONFIG.DataPath .. "buildx.002",
 CONFIG.DataPath .. "buildy.002"};

 --各种贴图文件名。
 CC.MMAPPicFile={CONFIG.DataPath .. "mmap.idx",CONFIG.DataPath .. "mmap.grp"};
 CC.SMAPPicFile={CONFIG.DataPath .. "smap.idx",CONFIG.DataPath .. "smap.grp"};
 CC.WMAPPicFile={CONFIG.DataPath .. "wmap.idx",CONFIG.DataPath .. "wmap.grp"};
 CC.EFT={CONFIG.DataPath .. "eft.idx",CONFIG.DataPath .. "eft.grp"};
 CC.FightPicFile={CONFIG.DataPath .. "fight%03d.idx",CONFIG.DataPath .. "fight%03d.grp"}; --此处为字符串格式，类似于C中printf的格式。

 CC.HeadPicFile={CONFIG.DataPath .. "hdgrp.idx",CONFIG.DataPath .. "hdgrp.grp"};
 CC.UIPicFile={CONFIG.DataPath .. "ui.idx",CONFIG.DataPath .. "ui.grp"};
 CC.ThingPicFile={CONFIG.DataPath .. "thing.idx",CONFIG.DataPath .. "thing.grp"};


 CC.BGMFile=CONFIG.SoundPath .. "M%02d.mp3";
 CC.ATKFile=CONFIG.SoundPath .. "atk%02d.wav";
 CC.EFile=CONFIG.SoundPath .. "Se%02d.wav";

 CC.WarFile=CONFIG.DataPath .. "war.sta";
 CC.WarMapFile={CONFIG.DataPath .. "warfld.idx",
 CONFIG.DataPath .. "warfld.grp"};

 CC.TalkIdxFile=CONFIG.ScriptPath .. "oldtalk.idx";
 CC.TalkGrpFile=CONFIG.ScriptPath .. "oldtalk.grp";

 
 
 --定义记录文件R×结构。 lua不支持结构，无法直接从二进制文件中读取，因此需要这些定义，用table中不同的名字来仿真结构。
 CC.TeamNum=16; --队伍人数
 CC.MyThingNum=400 --主角物品数量
 CC.Kungfunum=5 --角色武功数量
 CC.MaxKungfuNum=80
 CC.Base_S={}; --保存基本数据的结构，以便以后存取
 CC.Base_S["姓名"]={0,2,14}; --nouse
 CC.Base_S["章节名"]={14,2,28}; --章节名
 CC.Base_S["时间"]={42,2,14}; --存档保存时间
 CC.Base_S["未使用"]={56,2,14}; --nouse
 CC.Base_S["现在地"]={70,2,14};
 CC.Base_S["当前状态"]={84,0,2};
 CC.Base_S["当前事件"]={86,0,2};
 CC.Base_S["当前场景"]={88,0,2};
 CC.Base_S["当前音乐"]={90,0,2};
 CC.Base_S["道具屋"]={92,0,2};
 CC.Base_S["武将数量"]={94,0,2};
 CC.Base_S["敌军追击"]={96,0,2};
 CC.Base_S["战场存档"]={98,0,2};
 CC.Base_S["我军等级"]={100,0,2} -- 起始位置(从0开始)，数据类型(0有符号 1无符号，2字符串)，长度
 CC.Base_S["档案版本"]={102,0,2};
 CC.Base_S["游戏模式"]={104,0,2};
 CC.Base_S["人Y"]={106,0,2};
 CC.Base_S["人X1"]={108,0,2};
 CC.Base_S["人Y1"]={110,0,2};
 CC.Base_S["人方向"]={112,0,2};
 CC.Base_S["船X"]={114,0,2};
 CC.Base_S["船Y"]={116,0,2};
 CC.Base_S["船X1"]={118,0,2};
 CC.Base_S["船Y1"]={120,0,2};
 CC.Base_S["船方向"]={122,0,2};
 CC.Base_S["黄金"]={124,1,2};
 CC.Base_S["战场名称"]={150,2,50}; --
 CC.Base_S["战场目标"]={200,2,100}; --

 for i=1,CC.TeamNum do
 CC.Base_S["队伍" .. i]={128+2*(i-1),0,2};
 end
 CC.Base_S["仇敌数量"]={160,0,2};
 for i=1,CC.MyThingNum do
 CC.Base_S["物品" .. i]={162+4*(i-1),0,2};
 CC.Base_S["物品数量" .. i]={164+4*(i-1),0,2};
 end
 for i=1,200 do
 CC.Base_S["称号" .. i]={1762+2*(i-1),0,2};
 end
 for i=0,2000-1 do
 CC.Base_S["事件" .. i]={2162+2*i,0,2};
 end
 
 CC.WarDataSize=186; --战斗数据大小 war.sta数据结构
 CC.WarData_S={}; --战斗数据结构
 CC.WarData_S["代号"]={0,0,2};
 CC.WarData_S["名称"]={2,2,10};
 CC.WarData_S["地图"]={12,0,2};
 CC.WarData_S["经验"]={14,0,2};
 CC.WarData_S["音乐"]={16,0,2};
 for i=1,6 do
 CC.WarData_S["手动选择参战人" .. i]={18+(i-1)*2,0,2};
 CC.WarData_S["自动选择参战人" .. i]={30+(i-1)*2,0,2};
 CC.WarData_S["我方X" .. i]={42+(i-1)*2,0,2};
 CC.WarData_S["我方Y" .. i]={54+(i-1)*2,0,2};
 end
 for i=1,20 do
 CC.WarData_S["敌人" .. i]={66+(i-1)*2,0,2};
 CC.WarData_S["敌方X" .. i]={106+(i-1)*2,0,2};
 CC.WarData_S["敌方Y" .. i]={146+(i-1)*2,0,2};
 end
 --
 CC.PersonSize=150; --每个人物数据占用字节
 CC.Person_S={}; --保存人物数据的结构，以便以后存取
 CC.Person_S["代号"]={0,0,2,true} --true 实际存储 false 不存储
 CC.Person_S["形象"]={2,0,2,true}
 CC.Person_S["战斗动作"]={4,0,2,true}
 CC.Person_S["头像代号"]={6,0,2,true}
 CC.Person_S["新头像代号"]={8,0,2,true}
 CC.Person_S["姓名"]={10,2,14,true}
 CC.Person_S["外号"]={24,2,14,true}
 CC.Person_S["君主"]={38,0,2,true}
 CC.Person_S["性别"]={40,0,2,true}
 CC.Person_S["等级"]={42,0,2,true}
 CC.Person_S["移动"]={44,0,2,true}
 CC.Person_S["经验"]={46,0,2,true}
 CC.Person_S["武力"]={48,0,2,true}
 CC.Person_S["智力"]={50,0,2,true}
 CC.Person_S["统率"]={52,0,2,true}
 CC.Person_S["武力经验"]={54,0,2,true}
 CC.Person_S["智力经验"]={56,0,2,true}
 CC.Person_S["统率经验"]={58,0,2,true}
 CC.Person_S["天赋"]={60,0,2,false}
 CC.Person_S["勇猛"]={62,0,2,false}
 CC.Person_S["冷静"]={64,0,2,false}
 CC.Person_S["兵种"]={66,0,2,true}
 CC.Person_S["兵力"]={68,0,2,true}
 CC.Person_S["最大兵力"]={70,0,2,true}
 CC.Person_S["策略"]={72,0,2,true}
 CC.Person_S["最大策略"]={74,0,2,true}
 CC.Person_S["士气"]={76,0,2,true}
 CC.Person_S["攻击"]={78,0,2,true}
 CC.Person_S["防御"]={80,0,2,true}
 CC.Person_S["暴击"]={82,0,2,false}
 CC.Person_S["连击"]={84,0,2,false}
 CC.Person_S["回马"]={86,0,2,false}
 CC.Person_S["秘技1"]={88,0,2,false}
 CC.Person_S["暗器"]={90,0,2,false}
 CC.Person_S["奋战"]={92,0,2,false}
 CC.Person_S["急救"]={94,0,2,false}
 CC.Person_S["底力"]={96,0,2,false}
 CC.Person_S["怒发"]={98,0,2,false}
 CC.Person_S["威风"]={100,0,2,false}
 CC.Person_S["不屈"]={102,0,2,false}
 CC.Person_S["强运"]={104,0,2,false}
 CC.Person_S["一击"]={106,0,2,false}
 CC.Person_S["武力2"]={108,0,2,true}
 CC.Person_S["智力2"]={110,0,2,true}
 CC.Person_S["统率2"]={112,0,2,true}
 CC.Person_S["武器"]={114,0,2,true}
 CC.Person_S["防具"]={116,0,2,true}
 CC.Person_S["辅助"]={118,0,2,true}
 for i=1,8 do
 CC.Person_S["道具"..i]={118+i*2,0,2,true}
 end
 CC.Person_S["成长"]={136,0,2,false}
 for i=1,6 do
 CC.Person_S["特技"..i]={136+i*2,0,2,false}
 end

 CC.BingzhongSize=232; --每个兵种数据占用字节
 CC.Bingzhong_S={}; --保存兵种数据的结构，以便以后存取
 CC.Bingzhong_S["代号"]={0,0,2}
 CC.Bingzhong_S["名称"]={2,2,14}
 CC.Bingzhong_S["说明"]={16,2,100}
 CC.Bingzhong_S["策略成长"]={116,0,2}
 CC.Bingzhong_S["音效"]={118,0,2}
 CC.Bingzhong_S["攻击音效"]={120,0,2}
 CC.Bingzhong_S["移动速度"]={122,0,2}
 CC.Bingzhong_S["基础兵力"]={124,0,2}
 CC.Bingzhong_S["兵力增长"]={126,0,2}
 CC.Bingzhong_S["攻击"]={128,0,2}
 CC.Bingzhong_S["防御"]={130,0,2}
 CC.Bingzhong_S["移动"]={132,0,1}
 CC.Bingzhong_S["攻击范围"]={133,0,1}
 CC.Bingzhong_S["可反击"]={134,0,1}
 CC.Bingzhong_S["被反击"]={135,0,1}
 CC.Bingzhong_S["有效"]={136,0,2}
 CC.Bingzhong_S["贴图1"]={138,0,2}
 CC.Bingzhong_S["贴图2"]={140,0,2}
 CC.Bingzhong_S["贴图3"]={142,0,2}
 CC.Bingzhong_S["敌军偏移"]={144,0,2}
 CC.Bingzhong_S["友军偏移"]={146,0,2}
 CC.Bingzhong_S["我军偏移"]={148,0,2}
 CC.Bingzhong_S["克制1"]={150,0,2}
 CC.Bingzhong_S["克制2"]={152,0,2}
 CC.Bingzhong_S["克制3"]={154,0,2}
 CC.Bingzhong_S["克制4"]={156,0,2}
 CC.Bingzhong_S["克制5"]={158,0,2}
 CC.Bingzhong_S["克制6"]={160,0,2}
 CC.Bingzhong_S["克制7"]={162,0,2}
 CC.Bingzhong_S["克制8"]={164,0,2}
 CC.Bingzhong_S["克制9"]={166,0,2}
 CC.Bingzhong_S["无用17"]={168,0,2}
 CC.Bingzhong_S["无用18"]={170,0,2}
 CC.Bingzhong_S["远程"]={172,0,2}
 CC.Bingzhong_S["骑马"]={174,0,2}
 for i=0,19 do
 CC.Bingzhong_S["地形"..i]={176+1*i,0,1}
 end
 for i=1,36 do
 CC.Bingzhong_S["策略"..i]={195+1*i,0,1}
 end
 
 CC.SceneSize=10; --每个场景数据占用字节
 CC.Scene_S={}; --保存场景数据的结构，以便以后存取
 CC.Scene_S["代号"]={0,0,2}
 CC.Scene_S["人物"]={2,0,2}
 CC.Scene_S["坐标X"]={4,0,2}
 CC.Scene_S["坐标Y"]={6,0,2}
 CC.Scene_S["方向"]={8,0,2}
 
 CC.ItemSize=274; --每个道具数据占用字节
 CC.Item_S={}; --保存道具数据的结构，以便以后存取
 CC.Item_S["代号"]={0,0,2}
 CC.Item_S["名称"]={2,2,14}
 CC.Item_S["说明"]={16,2,200}
 CC.Item_S["类型"]={216,0,2}
 CC.Item_S["效果"]={218,0,2}
 CC.Item_S["武力"]={220,0,2}
 CC.Item_S["智力"]={222,0,2}
 CC.Item_S["统率"]={224,0,2}
 CC.Item_S["移动"]={226,0,2}
 CC.Item_S["攻击"]={228,0,2}
 CC.Item_S["策略攻击"]={230,0,2}
 CC.Item_S["防御"]={232,0,2}
 CC.Item_S["需等级"]={234,0,2}
 CC.Item_S["需兵种"]={236,0,2}
 CC.Item_S["需兵种1"]={236,0,2}
 CC.Item_S["需兵种2"]={238,0,2}
 CC.Item_S["需兵种3"]={240,0,2}
 CC.Item_S["需兵种4"]={242,0,2}
 CC.Item_S["需兵种5"]={244,0,2}
 CC.Item_S["需兵种6"]={246,0,2}
 CC.Item_S["需兵种7"]={248,0,2}
 CC.Item_S["价值"]={250,0,2}
 CC.Item_S["装备位"]={252,0,2}
 CC.Item_S["优先级"]={254,0,2}
 CC.Item_S["特技"]={256,0,2}
 CC.Item_S["专属特技人"]={258,2,14}
 CC.Item_S["专属特技"]={272,0,2}

 
 CC.MagicSize=30; --每个策略数据占用字节
 CC.Magic_S={}; --保存策略数据的结构，以便以后存取
 CC.Magic_S["代号"]={0,0,2}
 CC.Magic_S["名称"]={2,2,14}
 CC.Magic_S["类型"]={16,0,2}
 CC.Magic_S["消耗"]={18,0,2}
 CC.Magic_S["效果"]={20,0,2}
 CC.Magic_S["施展范围"]={22,0,2}
 CC.Magic_S["效果范围"]={24,0,2}
 CC.Magic_S["动画"]={26,0,2}
 CC.Magic_S["音效"]={28,0,2}

 CC.SkillSize=228; --每个特技数据占用字节
 CC.Skill_S={}; --保存特技数据的结构，以便以后存取
 CC.Skill_S["代号"]={0,0,2}
 CC.Skill_S["名称"]={2,2,14}
 CC.Skill_S["说明"]={16,2,200}
 CC.Skill_S["参数1"]={216,0,2}
 CC.Skill_S["参数2"]={218,0,2}
 CC.Skill_S["参数3"]={220,0,2}
 CC.Skill_S["参数4"]={222,0,2}
 CC.Skill_S["参数5"]={224,0,2}
 CC.Skill_S["参数6"]={226,0,2}
 
 CC.DX={[0]=2,-2,-2,2}; --不同方向x，y的加减值，用于走路改变坐标值
 CC.DY={[0]=-1,1,-1,1};
 --1,2,3,4 下 上 左 右
 CC.DirectX={0,0,-1,1}; --不同方向x，y的加减值，用于走路改变坐标值
 CC.DirectY={1,-1,0,0};

 CC.RowPixel=4 -- 每行字的间距像素数

 CC.MenuBorderPixel=5 -- 菜单四周边框留的像素数，也用于绘制字符串的box四周留得像素
 CC.MouseClickType=0; --0 满足1且2，1只检查初始点击位置， 2只检查最终释放位置
 CC.OpearteSpeed=4 --游戏操作反应速度
 CC.WarDelay=1 --战斗操作反应速度
 CC.FrameNum=35; --帧数 baseline 40
 CC.LastWords={
 ["刘备"]="我的梦想，不能实现了……", --刘备
 ["关羽"]="兄长，我对不起您……", --关羽
 ["张飞"]="大哥，对不起，没想到会被……", --张飞
 ["关兴"]="我玷污了父亲大人的名声……", --关兴
 ["马谡"]="糟了，不应是这种结局……", --马谡
 ["张苞"]="我玷污了父亲大人的名声……", --张苞
 ["赵云"]="没有完成使命，是武将的耻辱……", --赵云
 ["孙乾"]="主公，我没有守住。", --孙乾
 ["糜竺"]="主公，不能再打下去了，是我的过错……", --糜竺
 ["简雍"]="糟了，现在只有退兵了。", --简雍
 ["徐庶"]="没想到我的计谋被识破……", --徐庶
 ["伊籍"]="刘备大人，不能再打下去了，是我的过错。", --伊籍
 ["刘封"]="现在不得不撤退了……", --刘封
 ["诸葛亮"]="没有完成主公的期望，请允许我们撤退。", --诸葛亮
 ["魏延"]="即使拿出全部武力，也不能打啊！", --魏延
 ["关平"]="现在不得不撤退了……", --关平
 ["庞统"]="计谋被识破了，你这个混帐……", --庞统
 ["周仓"]="关羽将军，是我的过错……", --周仓
 ["黄忠"]="我亦老迈无用了，在战场厮杀不如……", --黄忠
 ["马良"]="主公，是我的失策……", --马良
 ["法正"]="主公，是我的失策……", --法正
 ["马超"]="我不认输！再杀一场！", --马超
 ["严颜"]="最近，挥动大刀不利落了……", --严颜
 ["马岱"]="我军……怎么打了大败仗……", --马岱
 ["藩宫"]="哎呀，我的武艺也就这些了……", --藩宫
 ["姜维"]="我不服！主公，再给我一次机会！", --姜维
 ["刘禅"]="父亲大人，我是怕上战场的……", --刘禅
 ["陈到"]="撤退是为了今后得胜。", --陈到
 --caocao
 ["曹操"]="难道天不佑我吗……太不甘心了！", --曹操
 ["夏侯惇"]="对不起、孟德！", --夏侯惇
 ["夏侯渊"]="我不会忘记这个屈辱的！", --夏侯渊
 ["曹仁"]="可恶！太嚣张了！", --曹仁
 ["曹洪"]="挫折才是好男儿成长的食粮。", --曹洪
 ["郭嘉"]="真是气死我也。", --郭嘉
 ["于禁"]="本该不是如此的！", --于禁
 ["许褚"]="喔喔喔、这下不行了！撤退！", --许褚
 ["荀彧"]="撤退也是一种战术。", --荀彧
 ["荀攸"]="太遗憾了……", --荀攸
 ["程昱"]="三十六计走为上策。", --程昱
 ["徐晃"]="快快撤兵！！", --徐晃
 ["张辽"]="这次我张辽败得太大意了，撤退！", --张辽 --失策！！
 ["满宠"]="既然如此……干脆撤退吧！", --满宠
 ["贾诩"]="嗯……、难道我失算了？", --贾诩
 ["刘晔"]="技不如人，回去再练过吧。", --刘晔
 ["张郃"]="原来我的本事还差远了……。", --张郃
 ["李典"]="事已至此，只有撤退了。", --李典
 ["曹彰"]="父亲…………！", --曹彰
 ["曹丕"]="怎么可能输给这种家伙……。", --曹丕
 ["司马懿"]="撤退是明智之举。", --司马懿
 ["庞德"]="暂且退兵吧。", --庞德
 ["乐进"]="唔唔唔、撤退吧。", --乐进
 ["典韦"]="主公！！我对不起您！", --典韦
 ["孙坚"]="没办法，撤退，*再打下去只会无谓地牺牲。", --孙坚
 ["陈宫"]="情况不妙，看来撤退才是明智之举。*撤退！", --陈宫
 ["吕蒙"]="失策！！", --吕蒙
 ["太史慈"]="今所志未遂，奈何死乎！", --太史慈
 --[2]="哦哦？居然打退了我关羽！？", --关羽
 ["貂蝉"]="我无法再战了…、请您保重……。", --貂蝉
 ["胡笛"]="啊！？*难道这是要逼我读档重来的节奏吗…………", --胡笛
 ["hnc"]="看来还得继续去攒节操才行。",
 }
 CC.AtkWords={
 ["刘备"]="这是万民的愤怒！", --刘备
 ["关羽"]="你最好记着我！*我就是关羽关云长！", --关羽
 ["张飞"]="我乃燕人张翼德也，谁敢与我一战！", --张飞
 ["关兴"]="关家还有我关兴！！", --关兴
 ["张苞"]="这是燕人的血统！！", --张苞
 ["赵云"]="吾乃常山赵子龙也！", --赵云
 ["刘封"]="喔喔…………一击毕命！", --刘封
 ["诸葛亮"]="山人自有妙计．", --诸葛亮
 ["魏延"]="谁敢杀我！？", --魏延
 ["关平"]="我不会辜负父亲期望的！", --关平
 ["周仓"]="俺不能给君爷丢脸！！看招吧！！", --周仓
 ["黄忠"]="交过手就知道我老不老了！", --黄忠
 ["马良"]="马氏五常，白眉最良！！", --马良
 ["马超"]="让你一辈子忘不了锦马超之名！", --马超
 ["严颜"]="廉颇不服老，严颜更益壮！", --严颜
 ["马岱"]="你准备受死吧！", --马岱
 ["藩宫"]="神力助我！", --藩宫
 ["姜维"]="呵呵，吾乃天水姜伯约，汝中计了！！", --姜维
 ["李严"]="让你知道西川李正方的厉害！", --李严
 ["祝融"]="火舌飞舞！", --祝融
 ["陈到"]="赐教！", --陈到
 ["徐庶"]="某乃颍川徐元直，看剑！",
 --caocao
 ["曹操"]="宁教我负天下人，*休教天下人负我！", --曹操
 ["黄盖"]="年轻人，接我刚猛的鞭笞吧！", --黄盖
 ["夏侯惇"]="挡我者死！*让开让开……！", --夏侯惇
 ["夏侯渊"]="神弓开！箭火炽！", --夏侯渊
 ["曹仁"]="上将曹仁在此，受死吧！", --曹仁
 ["曹洪"]="送你去投胎！", --曹洪
 ["于禁"]="一口气解决你！", --于禁
 ["许褚"]="把你劈成肉包！", --许褚
 ["徐晃"]="这就是你我实力的差距。", --徐晃
 ["张辽"]="你的破碇已暴露无遗！", --张辽
 ["张郃"]="精神集中！*呀啊啊啊啊…………！", --张郃
 ["李典"]="吾乃李曼成，得罪了！", --李典
 ["甘宁"]="让你见识我称霸长江之上的刀法！", --甘宁
 ["周瑜"]="谈笑间叫尔等灰飞烟灭！", --周瑜
 ["吕蒙"]="吾已非昔日阿蒙，你觉悟吧！", --吕蒙
 ["太史慈"]="大丈夫生于乱世，*当带三尺剑立不世之功！", --太史慈
 ["周泰"]="九江周幼平在此，吃我一刀！", --周泰
 ["丁奉"]="大丈夫求功名取富贵全在今日，杀！", --丁奉
 ["凌统"]="偏将军凌公绩在此，受死吧！", --凌统
 ["张任"]="结果你，只需一招！", --张任
 ["曹彰"]="一枪一个结果了尔等吧！", --曹彰
 ["曹丕"]="你给我站着别动！", --曹丕
 ["庞德"]="哼，苟延残喘！", --庞德
 ["乐进"]="乐文谦在此，吃我一枪！", --乐进
 ["曹真"]="不要惹我生气！", --曹真
 ["王平"]="我王子均打仗绝不多言！", --王平
 ["典韦"]="典韦在此，休伤吾主！", --典韦
 ["颜良"]="无名小卒何敢拦路！",
 ["文丑"]="喝！！某乃大将文丑是也！",
 ["公孙瓒"]="白马义从，威震天下！",
 ["吕布"]="这就是我和你的差距！",
 ["高顺"]="陷阵营，随我杀！",
 ["陈宫"]="略施小计！",
 ["貂蝉"]="貂蝉纷舞！一闪即逝！",
 ["胡笛"]="十级野球拳！*你，能挡的住吗？",
 ["hnc"]="世事皆虚幻，唯节操长存。",
 }
 CC.LieZhuan={
 ["？？？"]="不明身份的武将。",
 ["武松"]="《水浒传》中的角色，因排行第二，又名武二郎，血溅鸳鸯楼后，为躲避官府改作头陀打扮，江湖人称「行者武松」，曾在景阳冈徒手打死吊睛白额虎。",
 ["鲁智深"]="《水浒传》中的角色，本名鲁达，又因其天性不喜被拘束且好抱打不平，故又被人称作「花和尚」，为人慷慨大方，嫉恶如仇，豪爽直率，但粗中有细。",
 ["陈平"]="西汉王朝的开国功臣之一，刘邦还定三秦时归降于汉，成为汉高祖刘邦的重要谋士，先后参加楚汉战争和平定异姓王侯叛乱诸役，六出奇计，协助刘邦统一天下。",
 ["胡笛"]="据说是从一个名叫「大武侠论坛」的奇怪地方穿越而来，自称是「武林中人」，武艺绝强但言谈怪异，时常会说一些别人听不懂的词汇。似乎是三国之外的最强武将。",
 ["hnc"]="据说是从一个名叫「黑山之巅」的所谓「企鹅群」里穿越而来，智力不高却擅长一种叫做「脑补」的东西，自称是黑山众里最有节操的存在。",
 ["貂蝉"]="中国古代四大美女之一。东汉末年司徒王允的义女，作为「连环计」的执行者，成为家喻户晓、妇孺皆知的「人中杰」、「女中英」。",
 ["刘备"]="蜀汉的开国皇帝，西汉中山靖王刘胜的后裔，从黄巾之乱初期，就以白身组织义军讨伐贼党，最终从无数豪强中脱颖而出，鼎立于三国乱世，谥号蜀汉昭烈帝。",
 ["曹操"]="字孟德，黄巾之乱初期，就以骑都尉的身份前往各地讨伐贼党。常年的南征北战，构架出了魏国的强大基础。谥号魏武帝",
 ["关羽"]="字云长，蜀汉五虎将之首，刘备、张飞的结义兄弟。为人忠肝义胆、智勇双全，过五关斩六将，水淹七军，威震华夏，留下千古美名。",
 ["张飞"]="字翼德，蜀汉五虎将之一，刘备、关羽的结义兄弟。勇悍绝伦，曾单枪匹马拒曹军于长坂，刘备入川时，他领兵出战攻无不克，后被封为车骑将军。",
 ["赵云"]="蜀汉五虎将之一，字子龙，常山真定人。曾先后为袁绍、公孙瓒效力，最后追随刘备。长坂坡之战时，单骑杀入曹操百万大军中，七进七出，最终救出了刘备之子。",
 ["黄忠"]="蜀汉五虎将之一，字汉升。老当益壮，使用弓箭可百步穿杨，曾与关羽大战数日不分胜负。定军山之战时，临阵斩杀曹军主将夏侯渊，威震华夏。",
 ["马超"]="蜀汉五虎将之一，字孟起，少年时代就因武勇过人而盛名远扬，人称「锦马超」。曾大败曹军，曹操感叹道：「马儿不死，吾无葬地也。」，后随刘备入川，官拜骠骑将军、斄乡侯。",
 ["简雍"]="字宪和，刘备的同乡，从义军时代起就开始追随刘备，经常作为使者，四处为刘备奔走。为人性格沉静，处事淡然。",
 ["董卓"]="字仲颖，东汉并州刺史，奉大将军何进之命入京。趁乱把持朝政，废少帝，自居太师之位，「赞拜不名、入朝不趋、剑履上殿」，暴虐无度，最终被王允的连环计所破，死于吕布之手。",
 ["吕布"]="三国第一猛将，被誉为「人中吕布」的无双战将，但生性反复无常，数次反噬其主，在抵挡曹操攻城时，被反叛的部下生擒，最终死于白门楼。",
 ["华雄"]="董卓部下猛将，十八路联军讨伐董卓时把守汜水关，曾先后数次击破联军的进攻，并斩杀了不少联军的大将，最后被当时还是马弓手的关羽所斩杀。",
 ["李儒"]="董卓的女婿，同时也是董卓属下的头号智囊，董卓的很多暴政都是出自李儒的献策，曾识破王允、貂蝉等人的「连环计」，但董卓不听劝诫，导致被杀，董卓死后也因同罪被王允诛杀。",
 ["孔融"]="字文举，孔子第二十代孙，「建安七子」之一，东汉北海太守，十八路讨伐董卓联军之一，性好宾客，喜抨议时政，言辞激烈，后因被曹操猜忌，而为其所杀。",
 ["袁绍"]="字本初，出身于东汉名门，十八路讨伐董卓联军的盟主。董卓死后，为争霸中原，与曹操展开对决，但因太过优柔寡断，在官渡之战时大败。",
 ["孙坚"]="孙武的后裔，人称「江东猛虎」，因讨伐黄巾有功而被册封为长沙太守，在讨伐董卓联军时担任先锋。后与刘表、袁术争斗时死于襄阳，谥号武烈帝。",
 ["袁术"]="东汉南阳太守，袁绍的异母兄弟，将孙策作为借兵马抵押的传国玉玺据为己有，进而称帝，但因残暴无度导致灭亡。",
 ["公孙瓒"]="东汉北平太守，与刘备一起师从于卢植，所率骑兵均为骑乘纯白色战马，又被称为「白马义从」，在讨伐黄巾和镇压异族时都立下显赫威名。",
 ["程普"]="吴将，惯用铁脊蛇矛，孙氏三代元老，身经百战。赤壁之战时出任副都督，协助大都督周瑜击败了曹操百万渡江大军。",
 ["黄盖"]="吴将，孙坚起兵时就开始为其效力的老将，擅使铁鞭。赤壁之战时，配合周瑜上演「苦肉计」诈降曹操，最终乘机放火，葬送了曹操的百万大军。",
 ["陶谦"]="东汉徐州牧，讨伐董卓的十八路诸侯之一，因部下劫杀曹操老父，被震怒的曹操讨伐，后被刘备所止。病危时将徐州交托给刘备",
 ["夏侯惇"]="魏将，字元让，勇烈异常，讨伐吕布时被曹性暗箭射中失去左目，仍高呼「父精母血，不可弃也」，拔箭啖目后，反杀曹性。曹丕即位后，任魏国大将军。",
 ["夏侯渊"]="魏将，字妙才，夏侯惇的堂弟，擅长急袭的名将，定军山之战时，误中蜀将法正的计谋，被黄忠斩杀。",
 ["曹仁"]="魏将，曹操的族弟，自曹操起兵时就跟随曹操南征北战，弓马娴熟，赤壁之战后守备军事重地荆州，曹丕即位后，任魏国大司马。",
 ["曹洪"]="魏将，曹操的族弟，自曹操起兵时就跟随曹操南征北战，数次救曹操于危难中，曹丕即位后，任魏国骠骑将军。",
 ["李肃"]="董卓属下大臣，吕布的同乡，以赤兔马为礼物，凭三寸不烂之舌说服吕布归降董卓，后参与王允的「连环计」，成功将董卓骗入宫中伏杀。",
 ["胡轸"]="字文才，凉州人。东汉末年董卓部将，与华雄同守汜水关，后带领五千人与孙坚部将程普交战，斗不数合，被程普刺中咽喉，死于马下。",
 ["杨昂"]="东汉末年张鲁部将。曾奉张鲁之命，率兵助马超争夺凉州。曹操攻打汉中时。与张鲁之弟张卫一同守卫阳平关，双方攻防多日，终为曹操所破。",
 ["黄权"]="字公衡，刘备入川后，成为刘备部下，伐吴时统帅水军，蜀军被火烧连营后，他孤立无援，不得已降魏，但投降后，他仍然对刘备忠心不改。",
 ["阎圃"]="巴西安汉人。张鲁部下谋士，张鲁听信杨松谗言欲斩庞德时，曾极力劝阻，后随张鲁一同投降曹操。",
 ["公孙越"]="公孙瓒之弟，袁绍为夺冀州，诱公孙瓒起兵。事后公孙瓒派公孙越出使袁绍，欲瓜分冀州，袁绍假意答应，却暗中派人冒充董卓家将把公孙越乱箭射死。公孙瓒闻讯后大怒，遂起兵攻打袁绍。",
 ["曹豹"]=" 陶谦部将，曹操伐徐州时，与刘备一同在郯县以东迎击曹操，却被曹操击破 。后仕刘备为下邳相 ，于刘备与袁术交战时守下邳，反迎吕布入城 ，后被张飞所杀 。",
 ["赵岑"]="《三国演义》虚构人物，董卓部将，十八路诸侯联军讨伐董卓时，随华雄救援汜水关，董卓迁都后献关投降孙坚。",
 ["关兴"]="字安国，关羽次子。在刘备调解下，与张苞结为义兄弟，征吴时为报父仇而战，立下了大功，没有辱没名将之后的名声，诸葛亮给了他很高的评价。",
 ["马谡"]="字幼常，马良之弟。才华外露，被诸葛亮当做接班人，但刘备临终时说他言过其实不可大用，在街亭之战中，他纸上谈兵导致失败，被诸葛亮挥泪斩首。",
 ["廖化"]="字元俭，关羽千里寻兄时收的部下。五虎大将死后，他是为数不多的勇将之一，很受诸葛亮信赖。诸葛亮死后，他与姜维等人一起支撑蜀国。",
 ["沙摩柯"]="蛮王，长得碧眼红面，率兵帮助刘备进攻东吴，在战斗中射死了名将甘宁。陆逊火烧八百里连营后，他在率部败退的途中，被吴将周泰斩杀。",
 ["王甫"]="字国山，蜀国随军司马，关羽进攻襄阳时，忠告关羽留神荆州的防守。关羽杀出麦城后，他死守麦城，但是不久后得知关羽死讯，便从城楼跳下自杀。",
 ["刘岱"]="兖州刺史。曾以第四镇诸侯身份参与讨伐董卓。后来归顺曹操，去讨伐当时正在徐州的刘备。被打败后，又被刘备释放，去与曹操说和。",
 ["袁胤"]="袁术之侄，袁术死后，他护送着袁术的灵柩和妻小逃往庐江，在途中全部被杀。玉玺也被夺走，后来落到曹操手里。",
 ["张苞"]="张飞的长子，为报杀父之仇参加夷陵之战，立下了显赫战功，诸葛亮对他和关兴寄予厚望，常常带在身边，在参加北伐时，不幸摔伤致死。",
 ["韩当"]="字义公，东吴孙氏三代老将。参加了扬州进攻战，赤壁之战、进攻关羽和夷陵之战等众多战役，指挥东吴水军的一翼。",
 ["李傕"]="董卓爱将。董卓被杀之后，与郭汜一起率军以报仇为名重占长安。杀王允，挟献帝，逐吕布，继续推行暴政。后来中了杨彪的离间计，与郭汜自相残杀。",
 ["郭汜"]="董卓部将，董卓被杀后，听从贾诩建议，率兵急袭长安，杀死王允等人，并与李傕共掌朝政。后来沦为山贼，被部下伍习所杀。",
 ["田丰"]="字元皓，袁绍的谋士。博学多才，具有优秀军师的素质。但由于性格刚直而不能迎合袁绍。官渡之战中，因主张打持久战激怒袁绍，被囚禁。",
 ["沮授"]="袁绍的谋士。献计战胜公孙瓒，其智谋不亚于诸葛亮。在官渡之战中，力主与曹操进行持久战，但不被重视。袁绍兵败后被擒，企图盗马逃走未成，被斩首。",
 ["颜良"]="袁绍部下猛将，与文丑一起被誉为「勇冠三军」之将。官渡之战任先锋，斩杀宋宪、魏续，败徐晃，使曹军众将失色，不敢与他交手，后被当时寄身曹营的关羽斩杀。",
 ["文丑"]="河北最强大的袁绍军中，堪与颜良并称的猛将。在官渡之战时，为报颜良被杀之仇而出征，虽中了曹操的诱兵之计，仍击退张辽、徐晃，但也死于关羽刀下。",
 ["逢纪"]="字元图，袁绍的幕僚，献计夺取了翼州，解决了袁绍缺少军粮的威机使袁绍逐渐成为北方第一大势力，对抗意识强烈，官渡之战后进言，逼得田丰自杀。",
 ["许攸"]="字子远，袁绍的谋士。官渡之战时，因袁绍不信任他，而投降以前的密友曹操，并带来了袁军囤粮于乌巢的重要情报，为曹军战胜袁绍立下了大功。",
 ["陈震"]="字孝起，袁绍部下，刘备寄居袁绍处时，他曾为刘备给当时身在曹营的关羽送信，后来跟随刘备，刘备任荆州牧时，任命他为从事。",
 ["郭嘉"]="字奉孝，曹操最信赖的谋臣，平定河北时病陨，年仅三十八岁。曹操大哭曰「天丧吾也」，赤壁大败后，曹操叹息道「若奉孝在，绝不使吾有此大失也」。",
 ["于禁"]="字文则，严谨忠实，在官渡之战中立下大功，甚得曹操的赏识，被推举为五大将之一。但后来却变得贪生怕死，在樊城被关羽水淹七军擒获后，甚至祈求活命。",
 ["孙乾"]="字公祐，原是陶谦部下，陶谦死后，他辅佐继任的刘备，作为刘备早期的外交官和参谋多次建功，刘备入川后，他的待遇仅次于糜竺。",
 ["糜竺"]="字子仲，本是富商，在陶谦手下任别驾从事。陶谦死后辅佐刘备，刘备入川后，他被任命为安汉将军，地位甚至在诸葛亮之上。",
 ["陈登"]="字元龙，陈珪之子。刘备接替陶谦掌管徐州后，他成为刘备部下。刘备军大败于曹操后，他投降曹操，献上徐州。",
 ["典韦"]="被誉为「古之恶来」的勇将。因其勇猛甚得曹操喜爱，被任命为近卫军统帅。张绣夜袭曹营时，为护曹操逃脱，他舍命坚守辕门，站立而死，死后许久仍无人敢近。",
 ["许褚"]="字仲康，很受曹操信任，与典韦一起统领曹操的近卫军。在与西凉军交战时，曾赤膊与马超激斗良久，不分胜负。后曹操危难，他拼死护主，被曹操赐名为「虎痴」。",
 ["荀彧"]="字文若，有王佐之才。曹操称之为「吾之张良也」，备受重用。是卓越的战略家，官渡之战中鼓励一度消沉的曹操，并于最后使曹军大捷。",
 ["纪灵"]="袁绍部下，惯使三尖两刃刀。刘备率兵进攻时，力敌名将关羽，不分胜负。后来奉袁绍之命进攻刘备，但由于吕布从中调停而退兵。",
 ["董昭"]="字公仁，东汉的正议郎，劝献帝和曹操迁都许昌。后亲自写成奏文，推举曹操就任魏公。",
 ["高顺"]="吕布部将，是跟随吕布转战各地的猛将，绰号「陷阵营」。吕布败北后，他也被俘，一言不发，昂然就义。",
 ["魏续"]="吕布部将。与宋宪、侯成一起背叛吕布，投降曹操。官渡之战时，与颜良单挑，仅一回合即被斩杀。",
 ["宋宪"]="吕布麾下大将。见同僚侯成因琐碎小事被棒责，与侯成和魏续一起投降曹操。后来与袁绍军交战时，被猛将颜良斩杀。",
 ["陈宫"]="字公台，帮助行刺董卓失败的曹操，并与之同行。但见曹操滥杀无辜，鄙而弃之，后成为吕布的谋臣。虽然多次献计，但最终还是与吕布一起被杀。",
 ["荀攸"]="字公达，荀彧之侄。与荀彧一起为曹操效力。擅长军事，经常在战场上献计，击败敌军。赤壁之战中，他与程昱一起任随军参谋。",
 ["程昱"]="字仲德，经荀彧保举辅佐曹操，是曹操的主要军师之一。兖州被夺后，激励垂头丧气的曹操，鼓舞斗志。在仓亭之战时，献「十面埋伏」之计大破袁绍。",
 ["徐晃"]="字公明，曹操部下五大将之一。原为杨奉部下，被满宠说服后改仕曹操。曾为救援樊城，突破敌军的重重包围，曹操为他的果敢勇猛而惊叹。",
 ["张辽"]="字文远，智勇双全的一代名将，曹操部下五大将之首。其指挥才能在合肥战役时发挥的淋漓尽致，仅以八百精兵就大破东吴十万大军，威震逍遥津。",
 ["候成"]="吕布部将，与曹军对峙时，无意中违反吕布禁酒令而遭毒打，怀恨在心，与魏续、宋宪一起叛变，盗走吕布赤兔马降曹。",
 ["糜芳"]="字子芳，糜竺之弟，关羽的部下，镇守荆州南郡。听从博士仁的劝说，背叛关羽投降了东吴，后返回蜀国，被刘备追究罪责，遭处决。",
 ["满宠"]="字伯宁，被刘晔举荐，效力于曹操，曾说服徐晃降曹。在协助曹仁时，曹仁一度想放弃樊城，他力劝曹仁坚守，并最终取得胜利。并大胜过呼应蜀军北伐的吴军。",
 ["曹性"]="吕布麾下大将。见同僚高顺被夏侯惇追赶，于阵中放箭，正中夏侯惇左目。不一会被盛怒的夏侯惇斩杀。",
 ["车胄"]="东汉之车骑将军。讨伐吕布之后，刘备赴许昌时，他替代刘备治理徐州。刘备返回徐州后，他奉曹操命令暗杀刘备，但被关羽发觉后，反被斩杀。",
 ["吴班"]="字元雄，蜀将吴懿的族弟，讨伐东吴时，首仗战胜孙桓，并在夷陵把孙桓包围，后来参加北伐，被魏将张虎，乐綝射杀。",
 ["审配"]="袁绍的首席幕僚，官渡之战时两度献策，但都被刘晔破解，袁绍死后，辅佐袁尚与袁谭相争，造成袁家灭亡，被曹操俘虏后不投降，朝袁绍陵墓方向跪拜后就义。",
 ["郭图"]="袁绍的谋臣，常与慎重的沮授对立。官渡之战时持主战论，因为形势判断有误，导致袁军大败。袁绍死后辅佐袁谭，抵抗曹军而战死。",
 ["贾诩"]="字文和，年轻时就被比为「张良·陈平」的谋士。任曹操的谋臣时发挥了卓越的才智。曹丕之所以能即位，他有极大的功劳。",
 ["刘表"]="字景升，「江南八俊」之一。由于多疑和处事优柔寡断而多次失去夺取天下的机会。他死后，家族内部内杠，给了曹操一个进攻的良机。",
 ["朱灵"]="曹操麾下武将，刘备讨伐袁术之时任随军监军，但是没有完成监视的任务，空手而归。",
 ["陈琳"]="字孔璋，「建安七子」之一，被袁绍以记室（书记）录用，袁绍伐曹操之檄文的作者，此文极出色，连被骂的曹操都倍加赞赏。",
 ["刘晔"]="字子阳。受郭嘉推荐，辅佐曹操。在官渡之战时，献投石车图破了审配土山下射之计。效力于曹氏三代并多次献计，任魏国太中大夫。",
 ["张绣"]="张济之侄，张济死后，他率军帮助刘表，与曹操交战。在军师贾诩的指导下，屡屡获胜。后来听从贾诩劝告，归顺了曹操，获得重用。",
 ["张郃"]="字儁乂，起初是袁绍部下。官渡之战时，与高览一起投奔曹操。是五大将之一，屡立战功。连诸葛亮也承认他勇猛过人，是蜀国的大患。",
 ["高览"]="袁绍麾下大将。在官渡之战时，曾与曹营猛将许褚交过手，后来与同僚张郃一起归顺曹操。在汝南之战中，被刘备部将赵云刺死。",
 ["淳于琼"]="袁绍手下大将。原与曹操、袁绍一样，同是西园八校尉之一。官渡之战时，在乌巢看守军粮，因贪酒误事，被曹操趁机火攻后，导致袁军大败。",
 ["李异"]="吴将，孙桓部将。跟随孙桓与蜀军作战。惯使镀金斧。在向落马的蜀将张苞挥斧的瞬间，被疾驰而来的蜀将关兴斩首。",
 ["徐庶"]="字元直，司马徽的门生，曾任刘备军师。因老母被曹操所囚，只得离开刘备改仕曹操，但终生未为曹操设一策。在离开刘备前，向他推荐了卧龙诸葛亮。",
 ["蔡瑁"]="刘表就任荆州牧时招聘来的名士之一，是刘表之妻蔡氏的弟弟。刘表死后，他拥立刘琮，把荆州出卖给了曹操。赤壁之战时任水军都督，被中了周瑜离间计的曹操斩首。",
 ["伊籍"]="字机伯，原为刘表幕僚，曾向刘备透露的卢妨主和蔡瑁加害刘备的计谋，后改仕刘备，著有《蜀科》，此人理智伶俐，连孙权也叹服于他的能言善辩。",
 ["马腾"]="字寿成，西凉猛将，东汉名将马援之后。受献帝衣带诏之托，与董承等十三人共立血书，誓杀曹操。实情败露后，被曹操诱到京城杀害。",
 ["李典"]="字曼成，魏破虏将军。从讨伐黄巾军时就跟随曹操，历经百战。性格冷静慎重，多次制止同僚的胡作非为。与张辽、乐进一起镇守合肥。",
 ["刘封"]="刘备的养子，由于守卫上庸时，拒绝派兵增援被东吴围困后身陷绝境的关羽，因此激怒了刘备，在成都被斩。",
 ["蒯越"]="字异度，蒯良之弟。秦汉时代的谋士蒯通的后裔。以足智多谋著称，曹操在得到他后高兴的说：「吾不喜得荆州，喜得异度也」。",
 ["文聘"]="刘表麾下将领，刘琮献荆州投降后，他也不得已降曹。曹操很赏识他的忠义，封他为关内侯，曹丕伐吴大败时，他背负曹丕逃脱。",
 ["吕旷"]="袁尚部将，吕翔之兄。先降袁谭，接受了将军印。但后来把印献给了曹操，改投曹操。与其弟一起进攻新野时，被赵云一枪刺死。",
 ["吕翔"]="袁尚部将，吕旷之弟。常常与其兄一起参战，为曹仁部将，与其兄一起进攻借居新野的刘备，被张飞一矛刺死。",
 ["诸葛亮"]="字孔明，号卧龙先生，蜀汉丞相，刘备三顾茅庐请他出仕后，出计献策，使无立身之地的刘备能建立蜀汉，刘备死后，继承遗志，为扶汉室鞠躬尽瘁，死而后已。",
 ["魏延"]="字文长，受刘备重托，任汉中太守，武艺高强，为蜀汉屡立战功，因为与诸葛亮有嫌隙，故在其死后反叛，被授锦囊妙计的杨仪等杀死。",
 ["关平"]="河北关定之子，关羽的义子，作为其义父的左右手而转战南北，因他性情稳重谦和，很受其部下诸将的爱戴，后与关羽一起在麦城被杀。",
 ["张允"]="刘表部将，蔡瑁的心腹。与蔡瑁一起投降曹操，任曹操的水军副都督，由于熟习水阵，被周瑜用反间计，使曹操怀疑他们有加害之心，与蔡瑁一起被斩。",
 ["夏侯恩"]="曹操的背剑官。负责掌管曹操的青缸剑。在长坂坡抢夺民财时死于赵云剑下，青缸剑被赵云所获。",
 ["周瑜"]="字公谨，人称美周郎。东吴都督，遵孙策遗命辅佐年幼的孙权，智谋高远，是东吴的栋梁。在赤壁之战中，以五万破曹军八十三万，创造了以少胜多的杰出战例。",
 ["甘宁"]="字兴霸，是吴军首屈一指的勇将，曾仅率百骑夜袭曹营而无一伤亡，使孙权欢呼：「曹操有张辽，吾有甘兴霸」，很得孙权信任。",
 ["太史慈"]="字子义，原为刘繇部下。武艺高强，尤擅弓箭，曾与孙策单挑，不分胜负。后被孙策俘获，感孙策的仁德而降，为东吴的建国立下大功。",
 ["周仓"]="原为黄巾军余党，非常崇拜关羽，在卧牛山做强盗时，巧遇千里走单骑的关羽，于是跟随关羽作为部将奋战沙场，关羽遇害时，他自刎殉身而死。",
 ["虞翻"]="字仲翔，原是会稽郡吏。太守王朗被孙策打败后，他成为孙策的部下。为救治身负重伤的周泰，他推荐了名医华佗。后来担任说客说服了博士仁。",
 ["薛综"]="字敬文，应孙权之召，辅佐孙权。善理民政，文书也很优秀，后任东吴太子少傅，曾与诸葛亮论战。",
 ["陆绩"]="字公纪，陆逊的同族，精通周易和天文。幼年时拜见袁绍，偷偷把待客的蜜柑藏在袖子里，被发现后，他解释说要带回家去孝敬母亲。这个故事一时被传为佳话。",
 ["蒋钦"]="字公奕。与周泰一起归顺孙策。攻打南郡时任先锋，被曹仁击败，几乎被周瑜问罪斩首。在征讨关羽时，指挥水军围困关羽。",
 ["周泰"]="字幼平，因勇猛备受孙权信任。在宣城他为了护主，身负十二伤；后来在合肥战役中又救了孙权。孙权因此在宴席上将他身上的伤一一指给众人，盛赞其勇。",
 ["陈武"]="字子烈，吴将。黄面赤眼，容貌怪异。在孙策与刘繇交战时投奔孙策。在赤壁之战中，出任第四队大将出战，在濡须与庞德交手，因战袍被挂住而被杀。",
 ["毛阶"]="字孝先，受满宠推荐，投到曹操帐下任从事。擅长内政，建议曹操重视农业。赤壁之战中，在蔡瑁被杀后，他和于禁一起被任命为水军都督。",
 ["陈矫"]="字季弼，与曹仁一起镇守荆州南郡，但是败在诸葛亮的妙计下。后来成为魏国尚书令，帮助曹丕登基做了皇帝。明帝时升任司徒。",
 ["曹纯"]="字子和，曹仁之弟。率领曹操军的精锐部队「虎豹骑」出兵救援守南郡的曹仁，被吴将周瑜打败。",
 ["马良"]="字季常，人称白眉马良，刘备入川后，他是关羽的主要谋士，与诸葛亮交厚，尊亮为兄，力谏刘备不要打夷陵却不被采纳，在诸葛亮南征时病死于蜀。",
 ["刘度"]="荆州南部零陵太守。在其子刘贤和部下刑道荣被进攻的刘备军打败后，率兵投降。诸葛亮仍令他继任零陵太守。",
 ["刘贤"]="零陵太守刘度之子。与刘备军交战不敌，被张飞生擒。以劝说其父投降为条件被释放。因为如约投降，被允许为刘备效力。",
 ["赵范"]="桂阳太守。投降进攻荆州南部的赵云，因与赵云同年、同月、同乡而结为兄弟。欲把兄嫂嫁给赵云，被赵云以不义为由拒绝。",
 ["金旋"]="武陵太守，张飞率军攻打荆州南部时，不听从部下巩志献城的主张而率兵出城迎战张飞，不敌而欲回城时，被欲降刘备的巩志射杀。",
 ["巩志"]="武陵太守金旋手下从事，建议投降却不被采纳，金旋败于张飞后逃回后被其刺杀，取金旋之头投降刘备，被刘备任命接任武陵太守。",
 ["孙瑜"]="字仲异，孙静的次子，孙权的堂兄。周瑜借口入川攻击荆州时，率军与周瑜会合。",
 ["张松"]="字永年，刘璋的部下。为防止张鲁进犯，劝刘备入蜀，并献上西川地图，与法正、孟达作为刘备的内应，导致了后来的三国鼎立和他自己的悲惨命运。",
 ["法正"]="字孝直，为刘备取蜀立下了大功。擅长谋略，向刘备进言攻打汉中，使曹操为之震动。后在夷陵之战时，众人都不能劝阻刘备，诸葛亮叹息道：「若法孝直在……」。",
 ["刘璋"]="字季玉，刘焉之子。为了防止张鲁入侵，请刘备入川，却被刘备趁机夺了基业，为了使百姓免遭涂炭，不顾将士们的一再劝告，献成都投降。",
 ["孟达"]="字子庆，刘备入川时，他为内应，颇立功绩，后因不肯救助危急中的关羽，恐刘备处罚而降魏。深得曹丕的宠爱，被破格提拔，后谋反不成被司马懿杀死。",
 ["李恢"]="字德昂，原是刘璋部下，因料刘璋必败，于是投降刘备。说服领兵前来救援刘璋的马超，使其归顺刘备，后参加了南征和北伐。",
 ["张任"]="刘璋手下名将，在落凤坡射死了刘备的军师庞统，后中了诸葛亮之计战败被俘，拒绝刘备的劝降，说完「忠臣不仕二主」后，浩然就义。",
 ["邓贤"]="刘璋部将，曾随刘贵等人一起拜访异人紫虚上人，占卜自己今后的命运，可是虽然知道了命运也不能挽回，后中黄忠之箭而死。",
 ["杨怀"]="刘璋麾下大将，镇守涪水关，与高沛合谋企图暗算刘备，但是计划在实施前就败露了，因此被刘备捉住后处斩。",
 ["高沛"]="刘璋手下大将，与杨怀一起负责守备涪水关，企图暗算刘备，被刘备军师庞统识破，斩之。",
 ["吴懿"]="字子远，刘璋的义兄。刘备攻打西川时投降，改仕刘备后参加了北伐，其妹嫁给了刘备，生刘理，刘永。",
 ["吴兰"]="蜀将，刘备入川时成为刘备部下，担任马超的副将与魏国作战，屡立战功。在斜谷之战时，与曹操之子曹彰交手，不敌被杀。",
 ["雷铜"]="刘璋手下大将，与吴懿等人率军与刘备军交战，被包围后投降。守备巴西时，英勇善战，抵抗来犯的魏将张郃。但后来中了埋伏，被张郃刺死。",
 ["严颜"]="蜀将，在刘璋手下众将中以勇猛著称，任巴西太守，顽强抵抗张飞的猛攻，在中计被俘后，被张飞的诚意打动而降，而后成为老将黄忠的副将，建立了奇功。",
 ["马岱"]="马超的堂弟，与马超一起归顺刘备，南征北战屡建战功，诸葛亮很赏识他的忠义和才干，诸葛亮死前，亲授锦囊妙计给他，杀掉了反叛的魏延。",
 ["张鲁"]="字公祺，五斗米道的「师君」。在汉中建立了教团国家。遭到曹操进攻后，把粮食封仓留给曹军。曹操感叹于他的仁爱，在他投降后厚待他。",
 ["张卫"]="五斗米道的教祖张鲁之弟，极力主张与曹操对战。后与曹军战于巴中，战而无功，被许褚斩杀。",
 ["霍峻"]="字仲邈，刘表麾下大将，刘备掌握荆州后，受孟达推荐，效力于刘备，主要负责守备葭萌关，吴将霍戈之父。",
 ["司马懿"]="字仲达，侍奉曹氏四代的著名谋臣。以杰出的聪明才智，使诸葛亮六出祁山都无功而返，保住了三秦之地。后排除异己，掌握实权，为建立晋王朝打下基础。",
 ["庞德"]="字令明，马超的心腹猛将。被曹操擒获后降曹，为曹军建功。关羽攻樊城时，他抬棺战关羽，几乎将关羽击败。后被关羽水淹七军，被俘后不降而死。",
 ["乐进"]="字文谦，本是曹操麾下的文官，后来转为武将，被列为五大将之一。他与张辽、李典共同把守合肥，抵御东吴进攻，立下了赫赫战功。",
 ["司马师"]="字子元，司马懿的长子。有智谋，擅长谋略。父亲死后，掌握了魏国实权。但由于废魏主曹芳等专横之举，导致毋丘俭、文钦反叛。在对吴作战时死于军中",
 ["司马昭"]="字子尚，司马懿的次子。其思虑之深不在其兄之下，善于笼络人心。其兄死后，他接掌兵权。因平定蜀国有功，位升相国，其势显赫，成为实质上的皇帝。",
 ["刘辟"]="黄巾贼大将。黄巾之乱被镇压后，与龚都一起率领余部盘踞在汝南。一直协助刘备并把汝南让给了刘备。后在与曹军部将高览交战时被杀死。",
 ["刘循"]="刘璋的长子，奉父命率军防守雒城，抵御往成都进军的刘备军，坚守近一年后，城破被俘，后被刘备封为奉车中郎将。",
 ["杨松"]="张鲁麾下宠臣，贪图金银财宝而无远大眼光的小人。接受敌人的贿赂，孤立马超。张鲁降曹后，他被曹操以卖主之罪斩首。",
 ["王平"]="字子均。原是魏牙门将军，因对蜀作战时不受上司徐晃重视，遂降蜀。在南征北伐中表现活跃。街亭之战时任马谡副将，持正确意见，却不被马谡采纳。",
 ["李严"]="字正方，原是刘璋部下，于刘备入川时归顺，其勇猛与黄忠不分高下，得到刘备的高度评价，与诸葛亮等人同为刘备托孤之臣。",
 ["韩暹"]="河东郡「白波贼」大将。汉献帝去洛阳时，他与董承、杨奉等一起护卫。畏惧曹操的威势，与杨奉联手对抗曹操。后来被关羽、张飞所杀。",
 ["蒋琬"]="字公琰，冷静沉着，被诸葛亮认为是可担国事重任的人才，诸葛亮死后任蜀国尚书令，主管政事。",
 ["费禕"]="字文伟，诸葛亮的参谋，是颇有能力的文官，留守后方支援北伐，诸葛亮死后，他继承遗志，与蒋琬一起支撑走向没落的蜀国。",
 ["董承"]="东汉车骑将军，因为其妹嫁给献帝为妻，故被称为「国舅」，奉献帝衣带诏之命，联合刘备等人欲暗杀曹操，但被下人发现后报告曹操，因此惨遭杀害。",
 ["杨仪"]="字威公，蜀臣，任长史参加北伐，与魏延不和，这也是诸葛亮死后魏延反叛的原因之一，自恃功高常口出怨言，被贬为庶人。",
 ["向宠"]="蜀将，向朗之侄，诸葛亮在「出师表」中评价他的性情、处事公正，有军事才华，北伐时，奉命留守后方。",
 ["向朗"]="刘备属下大臣，原仕刘表，刘表死后归顺刘备，辅佐关羽守备荆州，是向宠的叔父。",

 ["李明"]="「三国志英杰传」中的虚构人物。泰山的山贼首领，因听闻刘备的仁德，故主动归降。",
 ["藩宫"]="「三国志英杰传」中的虚构人物。在淳于琼的进攻下守卫信都城，战后感念刘备相救之恩，加入刘备麾下",
 ["赵何"]="「三国志英杰传」中的虚构人物。彭城的山贼首领，彭城之战时被刘备收服。",
 ["董梁"]="「三国志英杰传」中的虚构人物。夏丘的山贼首领，夏丘之战时迫于刘备军的强大战力而投降。",
 ["陈到"]="字叔至，蜀将。自豫州时就跟随刘备，统率白毦兵。名位仅次于赵云，以忠勇著称，后被封为亭侯。",
 ["吕建"]="魏将。徐晃副将，关羽围樊城，吕建及徐商打着徐晃旗号，前赴偃城与关平交战。徐晃自引精兵五百，循沔水去袭偃城之后，大败关羽。",
 ["徐商"]="魏将。徐晃副将，关羽围樊城，吕建及徐商打着徐晃旗号，前赴偃城与关平交战。徐晃自引精兵五百，循沔水去袭偃城之后，大败关羽。",
 ["荀爽"]="字慈明，荀彧的叔父，荀爽兄弟八人被称为「荀氏八龙」。若论才学，荀爽当数八龙之首。有「荀氏八龙，慈明无双」的评赞。参与司徒王允谋除董卓之义举，举事前病卒。",
 ["李丰"]="袁术部将。袁术与曹操作战不利，败逃淮南，留李丰、梁纲、乐就、陈纪守寿春城，后城破，四人皆被斩首。 ",
 ["杜袭"]="字子绪，颍川郡定陵县人。东汉末及曹魏官员。魏明帝时期，出任曹真和司马懿的军师、太中大夫，晋封平阳乡侯，去世后谥号定侯。",
 ["赵累"]="蜀将，隶属于关羽，任关羽所置的都督一职。荆州失守后，随关羽逃离麦城时，被吴将马忠于临沮夹石擒获。",
 ["耿武"]="在冀州牧韩馥帐下任长史。韩馥听信荀谌、辛评之言，欲让袁绍参与州事，耿武谏阻未果，与关纯一起伏于城外欲刺杀绍，被颜良斩杀。",
 ["关纯"]="韩馥部将。韩馥听信荀谌、辛评之言，欲让袁绍参与州事，耿武谏阻未果，与耿武伏于城外欲刺杀绍，被文丑斩杀。",
 ["严纲"]="公孙瓒部下冀州刺史。与袁绍军在清河作战时，被袁军大将麹义斩杀",
 ["麴义"]="原是韩馥部将，后仕袁绍。界桥之战时，清河之战时斩杀公孙瓒部下大将严纲",
 ["朱然"]="吴将。夷陵之战中率领水军追击被陆逊火烧连营的刘备，但是遇到救援而来的赵云，大败而归。",
 ["张邈"]="陈留太守，讨伐董卓时任第六镇诸侯加盟。虽是曹操的挚友，却听从了陈宫的劝告反对曹操。让吕布进攻兖州，最后被打败。",
 ["徐荣"]="董卓部将。追击中了吕布伏兵而大败的曹军，一箭射中曹操肩头，但是却被随后赶来救援的夏侯惇斩杀。",
 ["刘琦"]="刘表长子。因后母蔡夫人欲让其弟刘琮继承荆州而命在旦夕，从诸葛亮处求得计策，主动要求守备江夏而得以逃脱，后成为荆州刺史。",
 ["刘琮"]="刘表次子。有蔡瑁等人为后盾继承了荆州，投降南下而来的曹操，被任命为青州刺史，但在前往青州上任的途中被曹操的手下暗杀。",
 ["庞统"]="刘备的谋士，与诸葛亮师出同门。二人并称伏龙、凤雏。被任命为入川总指挥，因立功心切而冒进，在落凤坡被伏击，死于乱箭之下。",
 ["祝融"]="南蛮王孟获之妻，据说是传说中火神祝融的后裔。武艺超群，善使飞刀。生擒了张嶷、马忠，但自己却被魏延、马岱俘虏。",
 ["诸葛均"]="诸葛瑾、诸葛亮的弟弟。与二哥诸葛亮在卧龙岗一起过着晴耕雨读的生活。诸葛亮出仕后，他也任蜀汉长水校尉",
 ["司马徽"]="号水镜先生，诸葛亮、庞统、徐庶等人的授业恩师。留宿越过檀溪逃来的刘备，并告知卧龙和凤雏的所在。",
 ["刘禅"]="蜀汉第二代皇帝，平庸敦厚之人。晚年沉迷于酒色之中，宠爱宦官黄皓，成为蜀汉灭亡的主要原因之一。其幼名「阿斗」成为昏庸的代名词。",
 ["曹植"]="曹操第四子，与曹丕争夺太子之位。极富才华，传世的诗文佳作颇多，在杜甫之前，一直被人称为「诗圣」。",
 ["姜维"]="蜀汉大将。原为魏国效力，第一次北伐时归降蜀汉。诸葛亮临终时将兵法传授给他，寄予厚望。但是其后九度北伐无果，耗尽了蜀汉的国力。",
 ["曹真"]="魏将。曹丕死时的托孤之臣。任大都督，与蜀汉的北伐军作战时，在诸葛亮的妙计下连翻败北，继而收到诸葛亮挑衅的信件，气愤而死。",
 ["曹彰"]="曹操第三子，武勇过人，曾赤手搏杀过猛兽，绰号「黄须儿」。在汉中争夺战中，救出了被敌军追击的曹操。",
 ["曹丕"]="魏国开国皇帝，曹操的次子。继承魏王之位后，逼迫献帝禅让，夺取了帝位。谥号魏文帝。",
 ["曹休"]="魏将。曹丕时代任征东大将军。对吴作战时，中了周鲂的计谋，大败而归，因心痛发作而死。",
 ["管亥"]="黄巾贼将领。黄巾之乱后率领数万余党袭击北海，与前来救援的刘备军会战，和关羽力斗数十回合，最终不敌，被关羽斩杀。",
 ["丁奉"]="吴将。初次上阵时就打败了魏国名将张辽，与张布一起诛杀孙琳，并升任大将军，在东吴后期的作战中，发挥了关键的作用。",
 ["徐盛"]="吴将，勇猛顽强，身经百战，不屈服于任何强敌。曹丕进攻东吴时，被任命为安东将军，用疑兵之计吓退魏军，为以后的胜利奠定了基础。",
 ["凌统"]="字公绩，吴将凌操之子。与甘宁有杀父之仇，常想报复。但后来与乐进单挑时险些被斩，幸得甘宁及时相救，二人才终于和解，并结为生死之交。",
 ["牛金"]="曹仁属下大将。对吴作战中，将甘宁困在夷陵城，但是被前来救援的周瑜冲破包围。为了扭转劣势，夜袭周瑜营寨，但是被识破，导致大败。",
 ["潘璋"]="字文珪。与朱然协力生擒了关羽，并因此功获赏关羽的青龙偃月刀。后来在被关兴追杀途中，恍惚看到关羽的亡灵，正在惊愕之际被关兴斩杀。。",
 ["邢道荣"]="刘度属下大将。与刘备军对阵，但是不敌张飞、赵云而投降，被释放后又卷土重来，被赵云一枪从马上挑落。",
 ["吕蒙"]="字子明。原是一介武夫，受孙权教诲，学习文武之道，成长为智勇兼备的名将。鲁肃死后就任东吴都，最早看出陆逊的才干，与陆逊合作，击败并杀死了关羽。",
 ["陆逊"]="字伯言，孙权的军师。用兵谋略不在前任军师周瑜之下。献计夺取荆州，击败关羽。夷陵之战任吴军统帅，击败了来势汹汹的刘备大军。",
 ["张昭"]="字子布，「江东二张」之一，长于内政。孙策临终时对孙权说：「外事不决问周瑜，内事不决问张昭」。孙权经常向他征求意见，视之如父。",
 ["诸葛瑾"]="字子瑜，诸葛亮之兄。经鲁肃推举仕吴。为人敦厚诚实，因此深受孙权信任。孙策死后，劝孙权顺曹操而拒袁绍。后期为吴蜀修好而屡次出使蜀国。",
 ["夏侯兰"]="常山真定人，与赵云是同乡，自小相识。随曹军进攻新野时，为赵云所擒，后经赵云劝说，加入刘备军。",
 ["夏侯杰"]="曹操麾下武将。长坂坡之战时，指挥曹军攻击刘备，但是在长坂坡前，被断后的张飞一声怒吼，吓得心胆俱裂，从马背上跌落而死。",
 ["夏侯尚"]="魏将。夏侯惇之侄。在定军山之战中被俘，与陈式交换人质，得以归魏。后来成为曹真属下，以三路大军进攻东吴，但是败给了陆逊。",
 ["夏侯德"]="魏将。夏侯惇之侄、夏侯尚之兄。守备天荡山。被敌将严颜放火烧山，只顾灭火之际，不慎被严颜斩杀。",
 ["孙权"]="字仲谋，孙坚次子。继承父兄的伟业，统治江东。多谋善断，招贤纳士，并能做到人尽其才，因此取得赤壁之战的胜利。是吴王朝第一代皇帝。",
 ["鲁肃"]="字子敬。一直主张联刘抗曹。在赤壁之战时辅佐周瑜，联合刘备打败了曹操。与周瑜交情深厚，周瑜死后，继任吴国大都督。",
 ["孙恒"]="字叔武，孙策赐其姓孙。在夷陵之战中任左都督，丧部下李异、孙旌两员大将，并被蜀军围困在夷陵城。在顽强坚守之下，等到了陆逊的援军。",
 ["陈纪"]="袁术部将。曾任九江太守。袁术与曹操作战不利，败逃淮南，留李丰、梁纲、乐就、陈纪守寿春城，后城破，四人皆被斩首。",
 ["许汜"]="有国士之名，吕布帐下谋士。兴平元年为兖州从事中郎，与张超、陈宫等背曹操而迎吕布为兖州牧。吕布败亡之后，前往荆州投靠刘表。",
 ["王楷"]="吕布麾下谋士。吕布被曹操围困时，和许汜一起前往联络袁术，但被袁术拒绝。",
 ["郝萌"]="吕布部将。在袁术的怂恿下反叛吕布，被其部将曹性以及吕布部将高顺所阻，并最终为高顺所杀。",
 ["孙观"]="字仲台，兖州泰山人。泰山寇之一，后降曹操，官至振威将军、青州刺史，爵吕都亭侯。",
 ["路昭"]="魏将。袁术欲经徐州北投袁绍，曹操遣刘备督朱灵、路昭截击袁术，军未至袁术已病死。朱灵、路昭等人还后，刘备杀徐州刺史车胄而据徐州。",
 ["王忠"]="魏将。扶风人。少为亭长。后归曹操，拜为中郎将，从征讨。曹魏建立后，任轻车将军之职，于魏明帝年间去世。",
 ["韩猛"]="又名韩若、韩荀，袁绍部下。官渡之战时被袁绍派往攻击曹军粮道，破曹仁于鸡洛山。后被派往运粮，被徐晃与史涣击败，辎重被烧。荀攸评价曰「韩猛锐而轻敌」。",
 ["蒋奇"]="袁绍部将。官渡之战时被袁绍遣去救援乌巢粮仓的途中，被张辽的伏兵击破，混乱之际被张辽斩杀。",
 ["马忠"]="吴将，在潘璋部下任司马。吕蒙率军攻关羽时，马忠于章乡俘获关羽及其子关平、都督赵累等，平定荆州。",
 ["乐就"]="袁术部将。袁术与曹操作战不利，败逃淮南，留李丰、梁纲、乐就、陈纪守寿春城，后城破，四人皆被斩首。",

 ["谢旌"]="吴将。陆逊击破关羽压制荆州后，派其统领三千步兵，同李异率三千兵力攻打蜀军。击破詹晏、邓辅、郭睦等人，并拿下陈凤。此外，在陆逊的指挥下击破文布、邓凯。",
 ["辛明"]="《三国演义》中虚构人物，为袁绍属下部将。官渡之战中，袁绍误中曹操疑兵之计，派其分兵五万前去救黎阳。兵力空虚时被曹操直冲中军，袁绍军大败。",
 ["张武"]="刘备在依附刘表时，助其解决了荆州以张武、陈孙为首的叛乱。赵云在阵前斩杀敌将张武后得到名马的卢，进而献给了刘备。",
 ["陈孙"]="刘备在依附刘表时，助其解决了荆州以张武、陈孙为首的叛乱。赵云在阵前斩杀敌将张武后得到名马的卢，陈孙随赶来夺。被张飞一矛刺死。",
 ["王威"]="荆州刺史刘表部下，乃忠义之士。刘表亡后，刘琮投降曹操，曹操表刘琮为青州刺史，使远离故乡，时只有王威追随。曹操复遣于禁追杀刘琮等人，王威亦于乱军中殉主。",
 ["韩浩"]="因忠勇而闻名，是曹操的心腹将领，被委以执掌禁军的重责。时荒乱乏粮，韩浩议急农救荒，曹操遂兴屯田，升任其为护军。随军攻克柳城，改任中护军，封万岁亭侯。",
 ["李珪"]="荆州幕官，劝刘琮让位于兄长刘琦，并请刘备入主荆州。遭到蔡瑁斥责，怒斥蔡瑁专权，瑁大怒，喝令左右推出斩之，至死仍大骂不绝。",
 ["王粲"]="字仲宣，山阳郡高平人。东汉末年著名文学家，「建安七子」之首，由于其文才出众，被称为「七子之冠冕」。初仕刘表，后归曹操。",
 ["宋忠"]="字仲子，东汉末学者，南阳章陵人。与綦母闿等撰《五经章句》，称为《后定》；又注《易》，有《周易注》十卷，俱佚。另著有《太玄经注》九卷，《法言注》十三卷。",
 ["晏明"]="曹洪副将，身长一丈，膀大腰圆，臂力过人，善使三尖两刃刀。长坂坡之战时遇赵云，自恃武力，于是领军围捕赵云，不三合，被赵云一枪刺倒。",
 ["马延"]="本为袁尚部下都督将军，曹操平定河北时大败袁尚，袁尚退保滥口。马延与张顗等临阵投降。",
 ["焦触"]="袁熙帐下大将。曹操征讨袁熙时。张南、焦触等反叛，进攻袁熙和袁尚，熙、尚败逃三郡乌丸。焦触自号幽州刺史，驱率诸郡太守令长，背袁向曹。",
 ["张南"]="袁熙帐下大将。曹操征讨袁熙时。张南、焦触等反叛，进攻袁熙和袁尚，熙、尚败逃三郡乌丸。焦触自号幽州刺史，驱率诸郡太守令长，背袁向曹。",
 ["阚泽"]="字德润，会稽山阴人，学者。性谦恭笃慎，孙权称尊号后为尚书，嘉禾时为中书令、侍中，赤乌时为太子太傅，去世后孙权曾因痛惜感悼而食不进者数日。",
 ["蔡阳"]="曹操部将，汝南太守。奉曹操之命攻击与刘备联合的汝南贼龚都等人，兵败后被刘备所杀。",
 ["蔡中"]="蔡瑁的族弟。周瑜设反间计杀掉蔡瑁、张允后，曹操遂使蔡中、蔡和往吴军处诈降，周瑜知而纳之，令在甘宁手下为前部。后被甘宁引的深入曹寨，一刀斩其于马下。",
 ["顾雍"]="为人少言语，不饮酒，严厉正大。孙权任命他为会稽郡丞，行太守事，后不断升迁，官至吴国丞相。为相十九年，多进良言，有功于吴，病逝后孙权亲自临吊，谥曰肃侯。",
 ["步骘"]="字子山，孙权属下幕僚。东吴攻打荆州关羽时，他探知了关羽和曹仁的战况，为东吴偷袭成功立下了大功。孙权称帝后，他任骠骑将军，后来任丞相。",
 ["严峻"]="宦官。庐江人左慈知补导之术，峻曾从其问受。",
 ["蔡勋"]="刘表麾下大将。刘表的重臣蔡瑁之弟，与兄长一起投降曹操。在三江口与吴军交战时，被吴将甘宁射杀。",
 ["陈应"]="《三国演义》中虚构人物。刘备命赵云攻去桂阳，鲍隆与陈应恃勇而战，被赵云所败。太守赵范纳降后，嫁嫂不成恼羞成怒，鲍隆与陈应至赵云营中诈降，为赵云识破所杀。",
 ["韩玄"]="韩浩之兄。曾为刘表手下任从事，后任长沙太守，于赤壁战后投降刘备。",
 ["杨龄"]="《三国演义》中虚构人物。长沙太守韩玄麾下管军校尉。刘备派遣关羽攻打长沙时，杨龄自告奋勇与关羽交锋，战不三合，就被斩杀。",
 ["吕范"]="字子衡，东吴重臣。随孙策、孙权征伐四方，对稳定江东做出了杰出的贡献，孙权将其比之于吴汉。拜大司马，印绶未下，已病卒。孙权悲痛不已，遣使者追赠大司马印绶。",
 ["王累"]="刘璋部下，益州从事，曾倒悬于城门劝谏刘璋不要迎接刘备入蜀，然而不被听从。",
 ["冷苞"]="刘璋部将。奉命守备雒县，与魏延战到三十合，黄忠引军援之，抵敌不住败走，被擒。其后诈降，被放归后复引军来攻，又为魏延所擒，被斩首。",
 ["杨任"]="张鲁部将。曹操攻汉中时，他奉命与杨昂一同镇守阳平关，杨昂阵亡后逃回汉中。曹操攻取阳平关后，他自告奋勇出战，被夏侯渊用拖刀计斩于马下。",
 ["陈式"]="蜀将。是刘备军中重要的基层指挥官。后期成长为高级将领。在诸葛亮的军事指挥下有过攻克魏国两个郡的辉煌战绩。",
 ["郝昭"]="字伯道，魏将。少年从军，屡立战功。后受曹真的推荐镇守陈仓，防御蜀汉。诸葛亮率军北伐时，曾为郝昭所阻，劝降不成，被迫退军。因此被封为列侯。",
 ["杨修"]="字德祖，太尉杨彪之子。学问渊博，极聪慧，任丞相府主簿。史载「是时，军国多事，修总知外内，事皆称意」。后被曹操以「前后漏泄言教，交关诸侯」之罪收杀。",
 ["费观"]="字宾伯，刘璋的女婿，是蜀汉四相之一费祎的族父，为人善于交接。以参军随李严据守绵竹，后与李严一同投降刘备。",

 ["献帝"]="暂无列传。",
 ["王铁"]="「三国志英杰传」中的虚构人物。",
 ["刘贵"]="「三国志英杰传」中的虚构人物。",
 ["鲍龙"]="「三国志英杰传」中的虚构人物。",
 ["蒋然"]="「三国志英杰传」中的虚构人物。",
 ["羽则"]="「三国志英杰传」中的虚构人物。",
 ["周比"]="「三国志英杰传」中的虚构人物。",
 ["杨彦"]="「三国志英杰传」中的虚构人物。",
 ["杨纲"]="「三国志英杰传」中的虚构人物。",
 ["侯累"]="「三国志英杰传」中的虚构人物。",
 ["陈蒋"]="「三国志英杰传」中的虚构人物。",
 ["李雄"]="「三国志英杰传」中的虚构人物。",
 ["严双"]="「三国志英杰传」中的虚构人物。",
 ["朱康"]="「三国志英杰传」中的虚构人物。",
 ["吴祖"]="「三国志英杰传」中的虚构人物。",
 ["孟肃"]="「三国志英杰传」中的虚构人物。",
 ["程德"]="「三国志英杰传」中的虚构人物。",
 ["张荻"]="「三国志英杰传」中的虚构人物。",
 ["高苍"]="「三国志英杰传」中的虚构人物。",
 ["宋费"]="「三国志英杰传」中的虚构人物。",
 ["韩英"]="「三国志英杰传」中的虚构人物。",
 ["郭适"]="「三国志英杰传」中的虚构人物。",
 ["杨玄"]="「三国志英杰传」中的虚构人物。",
 }
 CC.Enhancement=false;
 --CC.Enhancement=true;
 CC.SkillExp={
 [0]={1,2,3,6,8,12},
 [1]={2,3,6,8,12,16},
 [2]={3,6,9,12,15,18},
 [3]={1,2,4,8,16,32},
 [4]={2,3,5,10,15,29},
 [5]={3,5,10,12,18,24},
 [6]={10,13,16,19,22,25},
 [7]={10,11,12,30,31,32},
 [8]={6,12,18,27,40,52},--{6,12,18,27,36,45},
 [9]={11,12,21,22,41,42},
 [10]={6,12,24,36,48,60},--{12,18,24,36,48,60},
 [11]={15,21,27,33,39,51},
 [12]={4,8,16,24,36,55},--{1,2,3,4,5,50},
 [13]={20,25,30,35,40,45},
 [14]={24,28,32,36,40,48},
 [15]={30,35,40,45,50,60},
 }
 --S.RGP
 War={};
 Pic={};
 Drama={};
end

function SRPG()
 local step=4;
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap(War.CX,War.CY);
 Light();
 ReFresh();
 WarCheckStatus();
 local WEA={[0]="晴","晴","晴","雲","雨","雨","？"}
 while JY.Status==GAME_WMAP and War.Turn<=War.MaxTurn do
 --第X回合 X
 WarDrawStrBoxDelay(string.format('第%d回合 %s',War.Turn,WEA[War.Weather]),C_WHITE);
 WarCheckStatus();
 --我军操作
 if JY.Status==GAME_WMAP then
 WarDrawStrBoxDelay('玩家军队状况',C_WHITE);
 War.ControlStatus='select';
War.ControlEnable=true
 end
 while JY.Status==GAME_WMAP do
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap(War.CX,War.CY);
 if CC.XYXS then
 DrawString(8,CC.ScreenH-24,string.format("%d,%d",War.MX,War.MY),C_WHITE,16);
 end
 ReFresh();
 if opn() then
 break;
 end
 end
 --AI行动
 if JY.Status==GAME_WMAP then
 War.ControlStatus='AI';
 AI();
 end
 
 War.Turn=War.Turn+1; --回合+1
 if JY.Status==GAME_WMAP and War.Turn<=War.MaxTurn then
 --Weather
 local wea=math.random(6)-1;
 if War.Weather<wea then
 War.Weather=War.Weather+1;
 elseif War.Weather>wea then
 War.Weather=War.Weather-1;
 end
 if War.Weather==0 then
 War.Weather=5;
 elseif War.Weather==5 then
 War.Weather=0;
 end
 --全军可操作
 for i,v in pairs(War.Person) do
 if v.live then
 v.active=true;
 WarResetStatus(i);
 end
 end
 --恢复
 WarRest();
 end
 end
 if JY.Status==GAME_WMAP and War.Turn>War.MaxTurn then
 if War.Leader1==1 then
 WarLastWords(GetWarID(1));
 WarAction(18,GetWarID(1));
 end
 JY.Status=GAME_WARLOSE;
 if DoEvent(JY.EventID) then
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN then
 DoEvent(JY.EventID);
 end
 end
 end
 Dark();
end

function ReFresh(n)
 n=n or 1;
 local frame_t=CC.FrameNum*n;
 local t1,t2;
 t1=JY.ReFreshTime;
 t2=lib.GetTime();
 if CC.FPS or CC.Debug==1 then
 lib.FillColor(4,4,72,20,0)
 if t2-t1<frame_t then
 lib.DrawStr(4,4,string.format("FPS=%d",30),C_WHITE,16,CC.FontName,CC.SrcCharSet,CC.OSCharSet);
 else
 lib.DrawStr(4,4,string.format("FPS=%d",1050/(t2-t1)),C_WHITE,16,CC.FontName,CC.SrcCharSet,CC.OSCharSet);
 end
 end
 ShowScreen();
 if t2-t1<frame_t then
 lib.Delay(frame_t+t1-t2);
 end
end
function control()
 local eventtype,keypress,x,y=getkey();
 x,y=MOUSE.x,MOUSE.y;
 if eventtype==3 and keypress==3 then
 return -1;
 end
 local pid=0;
 if War.SelID>0 then
 pid=War.Person[War.SelID].id;
 elseif War.CurID>0 then
 pid=War.Person[War.CurID].id;
 elseif War.LastID>0 then
 pid=War.Person[War.LastID].id;
 end
 if MOUSE.EXIT() then
 PlayWavE(0);
 if WarDrawStrBoxYesNo('结束游戏吗？',C_WHITE) then
 WarDelay(CC.WarDelay);
 if WarDrawStrBoxYesNo('再玩一次吗？',C_WHITE) then
 WarDelay(CC.WarDelay);
 JY.Status=GAME_START;
 else
 WarDelay(CC.WarDelay);
 JY.Status=GAME_END;
 end
 end
 elseif War.CY>1 and MOUSE.HOLD(16+War.BoxWidth*1,32+War.BoxDepth*0,16+War.BoxWidth*(War.MW-1),32+War.BoxDepth*1) then
 War.CY=War.CY-1;
 War.MY=War.MY-1;
 MOUSE.enableclick=false;
 elseif War.CY<War.Depth-War.MD+1 and MOUSE.HOLD(16+War.BoxWidth*1,32+War.BoxDepth*(War.MD-1),16+War.BoxWidth*(War.MW-1),32+War.BoxDepth*War.MD) then
 War.CY=War.CY+1;
 War.MY=War.MY+1;
 MOUSE.enableclick=false;
 elseif War.CX>1 and MOUSE.HOLD(16+War.BoxWidth*0,32+War.BoxDepth*1,16+War.BoxWidth*1,32+War.BoxDepth*(War.MD-1)) then
 War.CX=War.CX-1;
 War.MX=War.MX-1;
 MOUSE.enableclick=false;
 elseif War.CX<War.Width-War.MW+1 and MOUSE.HOLD(16+War.BoxWidth*(War.MW-1),32+War.BoxDepth*1,16+War.BoxWidth*War.MW,32+War.BoxDepth*(War.MD-1)) then
 War.CX=War.CX+1;
 War.MX=War.MX+1;
 MOUSE.enableclick=false;
 elseif MOUSE.HOLD(War.MiniMapCX,War.MiniMapCY,War.MiniMapCX+War.Width*4,War.MiniMapCY+War.Depth*4) then
 War.CX=limitX(math.modf((x-War.MiniMapCX)/4-War.MW/2)+1,1,War.Width-War.MW+1);
 War.CY=limitX(math.modf((y-War.MiniMapCY)/4-War.MD/2)+1,1,War.Depth-War.MD+1);
 elseif MOUSE.CLICK(616,81,680,161) then
PersonStatus(pid,"","",1);
 --local name=JY.Person[pid]["姓名"];
 --if type(CC.LieZhuan[name])=='string' then
 --DrawLieZhuan(name);
 --end
 elseif CC.Enhancement and pid>0 and MOUSE.CLICK(644,294,678,313) then
 if JY.Person[pid]["等级"]>=CC.SkillExp[JY.Person[pid]["成长"]][1] then
 DrawSkillStatus(JY.Person[pid]["特技1"])
 end
 elseif CC.Enhancement and pid>0 and MOUSE.CLICK(680,294,714,313) then
 if JY.Person[pid]["等级"]>=CC.SkillExp[JY.Person[pid]["成长"]][2] then
 DrawSkillStatus(JY.Person[pid]["特技2"])
 end
 elseif CC.Enhancement and pid>0 and MOUSE.CLICK(716,294,740,313) then
 if JY.Person[pid]["等级"]>=CC.SkillExp[JY.Person[pid]["成长"]][3] then
 DrawSkillStatus(JY.Person[pid]["特技3"])
 end
 elseif CC.Enhancement and pid>0 and MOUSE.CLICK(644,314,678,333) then
 if JY.Person[pid]["等级"]>=CC.SkillExp[JY.Person[pid]["成长"]][4] then
 DrawSkillStatus(JY.Person[pid]["特技4"])
 end
 elseif CC.Enhancement and pid>0 and MOUSE.CLICK(680,314,714,333) then
 if JY.Person[pid]["等级"]>=CC.SkillExp[JY.Person[pid]["成长"]][5] then
 DrawSkillStatus(JY.Person[pid]["特技5"])
 end
 elseif CC.Enhancement and pid>0 and MOUSE.CLICK(716,314,740,333) then
 if JY.Person[pid]["等级"]>=CC.SkillExp[JY.Person[pid]["成长"]][6] then
 DrawSkillStatus(JY.Person[pid]["特技6"])
 end
 elseif MOUSE.IN(16,32,16+War.BoxWidth*War.MW,32+War.BoxDepth*War.MD) and War.ControlStatus~="checkDX" then
 local mx,my=math.modf((x-16)/War.BoxWidth),math.modf((y-32)/War.BoxDepth);
 War.InMap=true;
 War.MX=mx+War.CX;
 War.MY=my+War.CY;
 War.CurID=GetWarMap(War.MX,War.MY,2);
 if War.CurID>0 then
 War.LastID=War.CurID;
 end
 if MOUSE.CLICK(16+War.BoxWidth*mx+1,32+War.BoxDepth*my+1,16+War.BoxWidth*(mx+1)-1,32+War.BoxDepth*(my+1)-1) then
 return 2,x,y;
 else
 return 1,x,y;
 end
 else
 War.InMap=false;
 end
 return 0;
end
function BoxBack()
 if War.SelID>0 then
 War.MX=War.Person[War.SelID].x;
 War.MY=War.Person[War.SelID].y;
 local x,y;
 x=War.MX-math.modf(War.MW/2);
 y=War.MY-math.modf(War.MD/2);
 x=limitX(x,1,War.Width-War.MW+1);
 y=limitX(y,1,War.Depth-War.MD+1);
 if War.CX<x and War.MX>War.CX+War.MW-4 then
 for i=War.CX,x do
 War.CX=i;
 WarDelay();
 end
 elseif War.CX>x and War.MX<War.CX+3 then
 for i=War.CX,x,-1 do
 War.CX=i;
 WarDelay();
 end
 end
 if War.CY<y and War.MY>War.CY+War.MD-4 then
 for i=War.CY,y do
 War.CY=i;
 WarDelay();
 end
 elseif War.CY>y and War.MY<War.CY+3 then
 for i=War.CY,y,-1 do
 War.CY=i;
 WarDelay();
 end
 end
 War.InMap=true;
 War.CurID=War.SelID;
 --War.CurID=0;
 WarDelay(CC.WarDelay);
 end
end

function opn()
 local event,x,y=control();
 if War.ControlStatus=="select" then
 if event>0 then
 if between(x,16,79) and between(y,8,23) then
 War.FunButtom=1;
 else
 War.FunButtom=0;
 end
 end
 if event==-1 then
 return ESCMenu();
 elseif event==2 then
 if War.CurID>0 then --选择人
 if not War.Person[War.CurID].active and CC.WXXD==false then
 PlayWavE(2);
 JY.ReFreshTime=lib.GetTime();
 War.SelID=War.CurID;
 CleanWarMap(4,0);
 CleanWarMap(10,0);
 War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep);
 War_CalAtkFW(War.CurID);
 DrawWarMap();
 ReFresh();
 WarDrawStrBoxWaitKey('命令已执行完毕．',C_WHITE);
 CleanWarMap(4,1);
 CleanWarMap(10,0);
 War.SelID=0;

 elseif War.Person[War.CurID].enemy and CC.KZAI==false then
 PlayWavE(2);
 JY.ReFreshTime=lib.GetTime();
 War.SelID=War.CurID;
 CleanWarMap(4,0);
 CleanWarMap(10,0);
 War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep);
 War_CalAtkFW(War.CurID);
 DrawWarMap();
 ReFresh();
 WarDrawStrBoxWaitKey('不是我军部队．',C_WHITE);
 CleanWarMap(4,1);
 CleanWarMap(10,0);
 War.SelID=0;

 elseif War.Person[War.CurID].friend and CC.KZAI==false then
 PlayWavE(2);
 JY.ReFreshTime=lib.GetTime();
 War.SelID=War.CurID;
 CleanWarMap(4,0);
 CleanWarMap(10,0);
 War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep);
 War_CalAtkFW(War.CurID);
 DrawWarMap();
 ReFresh();
 WarDrawStrBoxWaitKey('不能操作的部队．',C_WHITE);
 CleanWarMap(4,1);
 CleanWarMap(10,0);
 War.SelID=0;

 elseif War.Person[War.CurID].troubled and CC.KZAI==false then
 PlayWavE(2);
 JY.ReFreshTime=lib.GetTime();
 War.SelID=War.CurID;
 CleanWarMap(4,0);
 CleanWarMap(10,0);
 War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep);
 War_CalAtkFW(War.CurID);
 DrawWarMap();
 ReFresh();
 WarDrawStrBoxWaitKey('混乱中不听指挥．',C_WHITE);
 CleanWarMap(4,1);
 CleanWarMap(10,0);
 War.SelID=0;
 else
 PlayWavE(0);
 War.SelID=War.CurID;
 CleanWarMap(4,0);
 CleanWarMap(10,0);
 War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep);
 War_CalAtkFW(War.CurID);
 War.ControlStatus="move";
 end

 elseif War.InMap then --非人，但是在地图范围内
 PlayWavE(0);
 War.DXpic=lib.SaveSur(16+War.BoxWidth*(War.MX-War.CX),32+War.BoxDepth*(War.MY-War.CY),16+War.BoxWidth*(War.MX-War.CX+1),32+War.BoxDepth*(War.MY-War.CY+1));
 --War.ControlStatus="checkDX";
 while true do
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 WarCheckDX();
 ReFresh();
 local eventtype,keypress=getkey();
 if (eventtype==3 and keypress==3) or MOUSE.CLICK(16,32,16+War.BoxWidth*War.MW,32+War.BoxDepth*War.MD) then
 break;
 end
 end
 PlayWavE(1);
 lib.FreeSur(War.DXpic);
 end
 end
 elseif War.ControlStatus=="checkDX" then
 if event==2 or event==-1 then
 PlayWavE(1);
 lib.FreeSur(War.DXpic);
 War.ControlStatus="select";
 end
 elseif War.ControlStatus=="move" then
 if event==2 then
 if not War.InMap then --不在地图范围内
 
 elseif War.Person[War.SelID].enemy and CC.KZAI==false then
 --不是我军部队．
 PlayWavE(2);
 WarDrawStrBoxWaitKey('不是我军部队．',C_WHITE);
 War.SelID=0;
 War.ControlStatus="select";
 CleanWarMap(4,1);
 CleanWarMap(10,0);
 elseif War.Person[War.SelID].friend and CC.KZAI==false then
 --不能操作的部队．
 PlayWavE(2);
 WarDrawStrBoxWaitKey('不能操作的部队．',C_WHITE);
 War.SelID=0;
 War.ControlStatus="select";
 CleanWarMap(4,1);
 CleanWarMap(10,0);
 elseif GetWarMap(War.MX,War.MY,4)==0 or (GetWarMap(War.MX,War.MY,2)>0 and GetWarMap(War.MX,War.MY,2)~=War.SelID) then
 --不是在移动范围里．
 PlayWavE(2);
 WarDrawStrBoxWaitKey('不是在移动范围里．',C_WHITE);
 else
 CleanWarMap(10,0);
 PlayWavE(0);
 War.OldX=War.Person[War.SelID].x;
 War.OldY=War.Person[War.SelID].y;
 War_MovePerson(War.MX,War.MY);
 War.ControlStatus="actionMenu";
 CleanWarMap(4,1);
 end
 elseif event==-1 then
 PlayWavE(1);
 War.SelID=0;
 War.ControlStatus="select";
 CleanWarMap(4,1);
 CleanWarMap(10,0);
 end
 elseif War.ControlStatus=="actionMenu" then
 local scl=War.SelID;
 local pid=War.Person[scl].id;
 BoxBack();
 local menux,menuy=0,0;
 local mx=War.Person[War.SelID].x;
 local my=War.Person[War.SelID].y;
 if mx-War.CX>math.modf(War.MW/2) then
 menux=16+War.BoxWidth*(mx-War.CX)-80;
 else
 menux=16+War.BoxWidth*(mx-War.CX+1);
 end
 local m={
 {"　攻击",nil,1},
 {"　乱射",nil,0},
 {"　天变",nil,0},
 {"　策略",WarMagicMenu,1},
 {"　道具",WarItemMenu,1},
 {"　休息",nil,1},
 {"等级设置",nil,0},
 {"回复状态",nil,0},
 {"兵种变更",nil,0},
 {"得到物品",nil,0},
 }
 local menu_num=4;
 if CC.RWTS then
 m[7][3]=1;
 m[8][3]=1;
 m[9][3]=1;
 m[10][3]=1;
 menu_num=menu_num+3;
 end
 if (between(War.Person[scl].bz,4,6) or War.Person[scl].bz==22) and CC.Enhancement and WarCheckSkill(scl,44) then --乱射
 m[2][1]="　"..JY.Skill[44]["名称"];
 m[2][3]=1;
 menu_num=menu_num+1;
 end
 if not (between(War.Person[scl].bz,4,6) or between(War.Person[scl].bz,21,22)) and CC.Enhancement and WarCheckSkill(scl,48) then --乱舞
 m[2][1]="　"..JY.Skill[48]["名称"];
 if m[2][3]==0 then
 menu_num=menu_num+1;
 end
 m[2][3]=1;
 end
 if CC.Enhancement and WarCheckSkill(scl,5) then --天变
 m[3][3]=1;
 menu_num=menu_num+1;
 end
 menuy=math.min(32+War.BoxDepth*(my-War.CY),CC.ScreenH-32-24*menu_num);
 local r=WarShowMenu(m,#m,0,menux,menuy,0,0,1,1,16,C_WHITE,C_WHITE);
 WarDelay(CC.WarDelay);

 if r==1 then
 WarSetAtkFW(War.SelID,War.Person[War.SelID].atkfw);
 local eid=WarSelectAtk(false,11);
 if eid>0 then

local xsgj=false
if CC.Enhancement and WarCheckSkill(eid,117) then
if JY.Person[War.Person[eid].id]["兵力"]>0 and (not War.Person[eid].troubled) then
if JY.Bingzhong[War.Person[eid].bz]["可反击"]==1 and JY.Bingzhong[War.Person[scl].bz]["被反击"]==1 then
xsgj=true
 elseif CC.Enhancement then
if WarCheckSkill(eid,102) then --刘备装备雌雄双剑 被攻击时必定反击
xsgj=true
elseif WarCheckSkill(eid,42) then --反击(特技)
xsgj=true

 end
 end
end
end

 if xsgj then
 --检查是否在攻击范围内
 xsgj=false;
 local xs_arrary=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,War.Person[eid].atkfw);
 for n=1,xs_arrary.num do
 if between(xs_arrary[n][1],1,War.Width) and between(xs_arrary[n][2],1,War.Depth) then
 if GetWarMap(xs_arrary[n][1],xs_arrary[n][2],2)==scl then
 xsgj=true
 break;
 end
 end
 end
 end

 if xsgj then
 --反击概率＝我军武将武力÷150
if CC.Enhancement and WarCheckSkill(eid,102) then --刘备装备雌雄双剑 被攻击时必定反击
WarAtk(eid,scl,1)
WarResetStatus(scl)
 elseif CC.Enhancement and WarCheckSkill(eid,19) then --报复

 if math.random(100)<=JY.Person[War.Person[eid].id]["武力2"] then

--丈八蛇矛
local smfj=0
local smsh=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
if CC.Enhancement and WarCheckSkill(eid,107) then
smsh=1
end

if smsh==1 and smfj==1 then
 WarAtk(eid,scl);
 WarResetStatus(scl);
if JY.Person[War.Person[scl].id]["兵力"]>0 then
 WarAtk(eid,scl);
 WarResetStatus(scl);
end
elseif smfj==1 then
 WarAtk(eid,scl,1);
 WarResetStatus(scl);
if JY.Person[War.Person[scl].id]["兵力"]>0 then
 WarAtk(eid,scl,1);
 WarResetStatus(scl);
end
elseif smsh==1 then
 WarAtk(eid,scl);
 WarResetStatus(scl);
else
 WarAtk(eid,scl,1);
 WarResetStatus(scl);
end

if CC.Enhancement and WarCheckSkill(scl,103) then
 WarAtk(scl,eid,1);
 WarResetStatus(eid);
end
 end
 else
 if math.random(150)<=JY.Person[War.Person[eid].id]["武力2"] then

--丈八蛇矛
local smfj=0
local smsh=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
if CC.Enhancement and WarCheckSkill(eid,107) then
smsh=1
end

if smsh==1 and smfj==1 then
 WarAtk(eid,scl);
 WarResetStatus(scl);
if JY.Person[War.Person[scl].id]["兵力"]>0 then
 WarAtk(eid,scl);
 WarResetStatus(scl);
end
elseif smfj==1 then
 WarAtk(eid,scl,1);
 WarResetStatus(scl);
if JY.Person[War.Person[scl].id]["兵力"]>0 then
 WarAtk(eid,scl,1);
 WarResetStatus(scl);
end
elseif smsh==1 then
 WarAtk(eid,scl);
 WarResetStatus(scl);
else
 WarAtk(eid,scl,1);
 WarResetStatus(scl);
end

if CC.Enhancement and WarCheckSkill(scl,103) then
 WarAtk(scl,eid,1);
 WarResetStatus(eid);
end
 end
 end
 end

if JY.Person[War.Person[scl].id]["兵力"]>0 then
 WarAtk(scl,eid);
 WarResetStatus(eid);
end

--混乱攻击
if CC.Enhancement and WarCheckSkill(scl,116) then
if JY.Person[War.Person[eid].id]["兵力"]>0 then
 War.Person[eid].troubled=true
 War.Person[eid].action=7
 WarDelay(2);
 WarDrawStrBoxDelay(JY.Person[War.Person[eid].id]["姓名"].."混乱了！",C_WHITE);
end
end

--引导攻击
local ydgj=0
if CC.Enhancement and WarCheckSkill(scl,109) then
ydgj=2
elseif CC.Enhancement and WarCheckSkill(scl,108) then
ydgj=1
end

if ydgj==1 and War.YD==0 then
if JY.Person[War.Person[eid].id]["兵力"]<=0 then
War.YD=1
AI_Sub(scl,1)
end

elseif ydgj==2 then
local yd=eid
while yd~=0 do
if JY.Person[War.Person[yd].id]["兵力"]<=0 then
yd=AI_Sub(scl,1)
else
break
end
end
end

if CC.Enhancement and (JY.Person[pid]["武器"]==59 or WarCheckSkill(scl,114)) then --英雄之剑 穿刺攻击

local xx=War.Person[eid].x
local yy=War.Person[eid].y
local dx=mx-xx
local dy=my-yy
local eid2=0

if dx>0 and dy==0 then --先确定被攻击者在攻击者左边方向
if GetWarMap(xx-1,yy,2)>0 then --然后确认是被攻击者左边那一格的对象
eid2=GetWarMap(xx-1,yy,2) --获取这一格的人物id编号
if War.Person[eid].enemy==War.Person[eid2].enemy then --最后确定该人物与被攻击者同阵营
WarAtk(scl,eid2) --攻击
WarResetStatus(eid2)
end
end
end

if dx<0 and dy==0 and GetWarMap(xx+1,yy,2)>0 then --右
eid2=GetWarMap(xx+1,yy,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end

if dx==0 and dy>0 and GetWarMap(xx,yy-1,2)>0 then --上
eid2=GetWarMap(xx,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end

if dx==0 and dy<0 and GetWarMap(xx,yy+1,2)>0 then --下
eid2=GetWarMap(xx,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end

if dx>0 and dy>0 and GetWarMap(xx-1,yy-1,2)>0 and dx==dy then --左上
eid2=GetWarMap(xx-1,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end

if dx<0 and dy>0 and GetWarMap(xx+1,yy-1,2)>0 and dx==-(dy) then --右上
eid2=GetWarMap(xx+1,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end

if dx>0 and dy<0 and GetWarMap(xx-1,yy+1,2)>0 and -(dx)==dy then --左下
eid2=GetWarMap(xx-1,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end

if dx<0 and dy<0 and GetWarMap(xx+1,yy+1,2)>0 and dx==dy then --右下
eid2=GetWarMap(xx+1,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end

end

 --反击
local fsfj=false --装备青龙偃月刀的人不是关羽时封杀反击
if CC.Enhancement and WarCheckSkill(scl,105) then
fsfj=true
end

 if JY.Person[War.Person[eid].id]["兵力"]>0 and (not War.Person[eid].troubled) and fsfj==false and xsgj==false then
 --只有贼兵（山贼、恶贼、义贼）和武术家能反击敌军的物理攻击。
 --攻击方兵种为骑兵、贼兵、猛兽兵团、武术家、异民族时，才可能产生反击。
--攻击方兵种为步兵、弓兵、军乐队、妖术师、运输队时，不可能发生反击。
--攻击方为新增兵种时，都可以产生反击

 local fj_flag=false;
if JY.Bingzhong[War.Person[eid].bz]["可反击"]==1 and JY.Bingzhong[War.Person[scl].bz]["被反击"]==1 then
 fj_flag=true;

elseif CC.Enhancement and WarCheckSkill(eid,102) then --刘备装备雌雄双剑 被攻击时必定反击
fj_flag=true

 elseif CC.Enhancement and WarCheckSkill(eid,42) then --反击(特技)
 fj_flag=true;
 end

 if fj_flag then
 --检查是否在攻击范围内
 fj_flag=false;
 local fj_arrary=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,War.Person[eid].atkfw);
 for n=1,fj_arrary.num do
 if between(fj_arrary[n][1],1,War.Width) and between(fj_arrary[n][2],1,War.Depth) then
 if GetWarMap(fj_arrary[n][1],fj_arrary[n][2],2)==scl then
 fj_flag=true;
 break;
 end
 end
 end
 end
 
 if fj_flag then
 --反击概率＝我军武将武力÷150
if CC.Enhancement and WarCheckSkill(eid,102) then --刘备装备雌雄双剑 被攻击时必定反击
WarAtk(eid,scl,1)
WarResetStatus(scl)

 elseif CC.Enhancement and WarCheckSkill(eid,19) then --报复
 if math.random(100)<=JY.Person[War.Person[eid].id]["武力2"] then

--丈八蛇矛
local smfj=0
local smsh=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
if CC.Enhancement and WarCheckSkill(eid,107) then
smsh=1
end

if smsh==1 and smfj==1 then
 WarAtk(eid,scl);
 WarResetStatus(scl);
if JY.Person[War.Person[scl].id]["兵力"]>0 then
 WarAtk(eid,scl);
 WarResetStatus(scl);
end
elseif smfj==1 then
 WarAtk(eid,scl,1);
 WarResetStatus(scl);
if JY.Person[War.Person[scl].id]["兵力"]>0 then
 WarAtk(eid,scl,1);
 WarResetStatus(scl);
end
elseif smsh==1 then
 WarAtk(eid,scl);
 WarResetStatus(scl);
else
 WarAtk(eid,scl,1);
 WarResetStatus(scl);
end

if CC.Enhancement and WarCheckSkill(scl,103) then
 WarAtk(scl,eid,1);
 WarResetStatus(eid);
end

 end
 else
 if math.random(150)<=JY.Person[War.Person[eid].id]["武力2"] then

--丈八蛇矛
local smfj=0
local smsh=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
if CC.Enhancement and WarCheckSkill(eid,107) then
smsh=1
end

if smsh==1 and smfj==1 then
 WarAtk(eid,scl);
 WarResetStatus(scl);
if JY.Person[War.Person[scl].id]["兵力"]>0 then
 WarAtk(eid,scl);
 WarResetStatus(scl);
end
elseif smfj==1 then
 WarAtk(eid,scl,1);
 WarResetStatus(scl);
if JY.Person[War.Person[scl].id]["兵力"]>0 then
 WarAtk(eid,scl,1);
 WarResetStatus(scl);
end
elseif smsh==1 then
 WarAtk(eid,scl);
 WarResetStatus(scl);
else
 WarAtk(eid,scl,1);
 WarResetStatus(scl);
end

if CC.Enhancement and WarCheckSkill(scl,103) then
 WarAtk(scl,eid,1);
 WarResetStatus(eid);
end

 end
 end
 end
 end
 --
 if War.Person[scl].live then
 War.Person[scl].active=false;
 War.Person[scl].action=0;
 end
 WarResetStatus(scl);
 War.SelID=scl;
 WarCheckStatus();
 War.LastID=scl;
 War.CurID=0;
 War.SelID=0;
 War.ControlStatus="select";
 return CheckActive();
 end

 elseif r==2 then
 --War_CalAtkFW(scl);
 local skillid=44;
 if m[2][1]=="　"..JY.Skill[48]["名称"] then
 skillid=48;
 end
 WarSetAtkFW(scl,War.Person[scl].atkfw);
 WarDelay(CC.WarDelay);
 if WarDrawStrBoxYesNo(string.format("%s将使用技能『%s』，可以吗？",JY.Person[pid]["姓名"],JY.Skill[skillid]["名称"]),C_WHITE) then
 --CleanWarMap(10,0);
 CleanWarMap(4,1);
 local atkarray=WarGetAtkFW(War.Person[scl].x,War.Person[scl].y,War.Person[scl].atkfw);
 local eidarray={};
 local eidnum=0;
 for i=1,atkarray.num do
 local ex=atkarray[i][1];
 local ey=atkarray[i][2];
 if between(ex,1,War.Width) and between(ey,1,War.Depth) then
 local eid=GetWarMap(ex,ey,2);
 if eid>0 then
 if War.Person[scl].enemy~=War.Person[eid].enemy then
 if (not War.Person[eid].hide) and War.Person[eid].live then
 eidnum=eidnum+1;
 eidarray[eidnum]=eid;
 end
 end
 end
 end
 end
 if eidnum==0 then
 PlayWavE(2);
 WarDrawStrBoxWaitKey('攻击范围内没有敌军．',C_WHITE);
 else
 local n=math.random(2);
 if skillid==44 then --乱射
 n=n+math.modf(eidnum/2)+math.random(3)-math.random(4);
 elseif skillid==48 then --乱舞
 n=n+eidnum-1+math.random(3)-math.random(4);
 end
 n=limitX(n,2,JY.Skill[skillid]["参数1"]);
 for t=1,n do
 local eid,index;
 if eidnum==0 then
 break;
 elseif eidnum==1 then
 index=1;
 else
 index=math.random(eidnum);
 end
 eid=eidarray[index];
 if War.Person[eid].live and War.Person[scl].live and (not War.Person[scl].troubled) then
 if skillid==44 then --乱射
 WarAtk(scl,eid,2);
 elseif skillid==48 then --乱舞
 WarAtk(scl,eid,3);
 end
 WarResetStatus(eid);
 end
 if not War.Person[eid].live then
 table.remove(eidarray,index);
 eidnum=eidnum-1;
 end
 end
 --
 if War.Person[scl].live then
 War.Person[scl].active=false;
 War.Person[scl].action=0;
 end
 WarResetStatus(scl);
 War.SelID=scl;
 WarCheckStatus();
 War.LastID=scl;
 War.CurID=0;
 War.SelID=0;
 War.ControlStatus="select";
 return CheckActive();
 end
 else
 --CleanWarMap(10,0);
 CleanWarMap(4,1);
 end
 elseif r==3 then
 WarDelay(CC.WarDelay);
 if WarDrawStrBoxYesNo(JY.Person[pid]["姓名"].."将使用技能『天变』，可以吗？",C_WHITE) then
 local wzmenu={
 {"　 晴",nil,1},
 {"　 雲",nil,1},
 {"　 雨",nil,1},
 };
 if between(War.Weather,0,2) then
 wzmenu[1][3]=0;
 elseif between(War.Weather,4,5) then
 wzmenu[3][3]=0;
 else
 wzmenu[2][3]=0;
 end
 local r=ShowMenu(wzmenu,3,0,0,0,0,0,1,1,16,C_WHITE,C_WHITE);
 if r>0 then
 local str1={"万能的神灵啊！*答应我们的祈求，改变天气吧！",
 "向上天传达我们的心愿，*请满足我们的愿望，*出现我们所期待的天气吧．",
 "开始变天了．*全体将士注意，*准备行动．",
 "准备进行祈雨．*全体站好，现在开始祈雨．",
 "上天啊！听听我的呼声吧！*下场大雨，施恩人间吧！"}
 local str2={"大家看见了吧？*这就是我的秘术！*平日修炼的成果．",
 "成功了！*这就是超常人的能力，*能控制天气的神奇力量！",
 "进行的很顺利，*大家对此都很惊讶！",
 "大雨倾盆而下．",
 "哈！大雨！*老天开眼了，*老天站在我们这边．"}
 if r==3 then
 talk(pid,str1[math.random(5)]);
 else
 talk(pid,str1[math.random(3)]);
 end
 if math.random(100)<JY.Person[pid]["智力2"] then
 if r==1 then
 War.Weather=math.random(3)-1;
 elseif r==2 then
 War.Weather=3;
 else
 War.Weather=math.random(2)+3;
 end
 PlayWavE(11);
 WarDrawStrBoxWaitKey('成功了．',C_WHITE);
 if r==3 then
 talk(pid,str2[math.random(5)]);
 else
 talk(pid,str2[math.random(3)]);
 end
 else
 PlayWavE(2);
 WarDrawStrBoxWaitKey('失败了．',C_WHITE);
 end
 --
 WarAddExp(scl,8);
 War.Person[scl].active=false;
 War.Person[scl].action=0;
 WarResetStatus(scl);
 War.SelID=scl;
 WarCheckStatus();
 War.LastID=scl;
 War.CurID=0;
 War.SelID=0;
 War.ControlStatus="select";
 return CheckActive();
 end
 end
 elseif r==4 then
 War.Person[scl].active=false;
 War.Person[scl].action=0;
 WarResetStatus(scl);
 War.SelID=scl;
 WarCheckStatus();
 War.LastID=scl;
 War.CurID=0;
 War.SelID=0;
 War.ControlStatus="select";
 WarDelay(CC.WarDelay);
 return CheckActive();
 elseif r==5 then
 War.Person[scl].active=false;
 War.Person[scl].action=0;
 WarResetStatus(scl);
 War.SelID=scl;
 WarCheckStatus();
 War.LastID=scl;
 War.CurID=0;
 War.SelID=0;
 War.ControlStatus="select";
 WarDelay(CC.WarDelay);
 return CheckActive();
 elseif r==6 then
 War.Person[scl].active=false;
 War.Person[scl].action=0;
 WarResetStatus(scl);
 War.SelID=scl;
 WarCheckStatus();
 War.LastID=scl;
 War.CurID=0;
 War.SelID=0;
 War.ControlStatus="select";
 WarDelay(CC.WarDelay);
 return CheckActive();
 elseif r==7 then
local djb={}
for i=1,99 do
djb[i]=i
end
local lv=LvMenu(djb)
if lv>0 then
JY.Person[pid]["等级"]=lv
end
 elseif r==8 then
JY.Person[pid]["兵力"]=JY.Person[pid]["最大兵力"]
JY.Person[pid]["士气"]=100
JY.Person[pid]["策略"]=JY.Person[pid]["最大策略"]
 elseif r==9 then
 local bz=War.Person[scl].bz;
 local bzmenu={};
 for index=1,JY.BingzhongNum-1 do
 bzmenu[index]={fillblank(JY.Bingzhong[index]["名称"],11),nil,0}
 if JY.Bingzhong[index]["有效"]==1 then
 bzmenu[index][3]=1;
 end
 end
 local r=ShowMenu(bzmenu,JY.BingzhongNum-1,8,0,0,0,0,6,1,16,C_WHITE,C_WHITE);
 if r>0 then
 bz=r;

 local x=145;
 local y=CC.ScreenH/2;
 local size=16;
 lib.PicLoadCache(4,50*2,x,y,1);
 DrawString(x+16,y+16,JY.Bingzhong[bz]["名称"],C_Name,size);
 DrawStr(x+16,y+36,GenTalkString(JY.Bingzhong[bz]["说明"],18),C_WHITE,size);
 if talkYesNo(War.Person[War.SelID].id,"转职为"..JY.Bingzhong[bz]["名称"].."，*可以吗？") then
 WarBingZhongUp(War.SelID,bz);
end

 end

elseif r==10 then
local wp={}
for wpid=1,JY.ItemNum-1 do
wp[wpid]={fillblank(JY.Item[wpid]["名称"],11),nil,0}
if wpid<181 and JY.Item[wpid]["类型"]>0 then
wp[wpid][3]=1
end
end
local rr=ShowMenu(wp,#wp,8,0,0,0,0,6,1,16,C_WHITE,C_WHITE);
if rr>0 then
 local x=145;
 local y=CC.ScreenH/2;
 local size=16;
 lib.PicLoadCache(4,50*2,x,y,1);
 DrawString(x+16,y+16,JY.Item[rr]["名称"],C_Name,size);
 DrawStr(x+16,y+36,GenTalkString(JY.Item[rr]["说明"],18),C_WHITE,size);
 
 if talkYesNo(War.Person[War.SelID].id,"得到"..JY.Item[rr]["名称"].."，*可以吗？") then

 for i=1,8 do
 if JY.Person[War.Person[War.SelID].id]["道具"..i]==0 then
 JY.Person[War.Person[War.SelID].id]["道具"..i]=rr
 break;
 end

if i==8 and JY.Person[War.Person[War.SelID].id]["道具"..i]>0 then
WarDrawStrBoxWaitKey('道具已满',C_WHITE)
end

 end

end
end


 elseif r==0 then
 CleanWarMap(4,1);
 CleanWarMap(10,0);
 SetWarMap(War.Person[scl].x,War.Person[scl].y,2,0);
 SetWarMap(War.OldX,War.OldY,2,War.SelID);
 War.Person[scl].x=War.OldX;
 War.Person[scl].y=War.OldY;
 BoxBack();
 ReSetAttrib(pid,false);
 War.SelID=0;
 War.ControlStatus="select";
 end
 else --异常控制状态回复
 War.ControlStatus="select";
 end
 return false;
end

function WarSelectAtk(flag,fw)
 --flag true: select us or friend
 --flag fasle: select enemy
 flag=flag or false;
 fw=fw or 0;
--标记
 War.ControlStatus="selectAtk";
 local tmp=JY.MenuPic.num;
 JY.MenuPic.num=0;
 while true do
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap(War.CX,War.CY);
 ReFresh()
 local event,x,y=control();
 if event==1 then
 CleanWarMap(10,0);
 if GetWarMap(War.MX,War.MY,4)>0 and fw>0 then
 local array=WarGetAtkFW(War.MX,War.MY,fw);
 for i=1,array.num do
 local mx,my=array[i][1],array[i][2];
 if between(mx,1,War.Width) and between(my,1,War.Depth) then
 if flag then
 SetWarMap(mx,my,10,2);
 else
 SetWarMap(mx,my,10,1);
 end
 end
 end
 end
 elseif event==2 then
 --if not War.InMap then --地图范围外

 --else
 if GetWarMap(War.MX,War.MY,4)>0 then
 local eid=GetWarMap(War.MX,War.MY,2);
 if eid>0 then--and eid~=War.SelID then
 if flag then --select us or friend
 if War.Person[eid].enemy==War.Person[War.SelID].enemy then
 PlayWavE(0);
 CleanWarMap(4,1);
 CleanWarMap(10,0);
 BoxBack();
 JY.MenuPic.num=tmp;
 return eid;
 else
 PlayWavE(2);
 WarDrawStrBoxWaitKey('是敌方部队．',C_WHITE);
 end
 else --select enemy
 if War.Person[eid].enemy~=War.Person[War.SelID].enemy then
 PlayWavE(0);
 CleanWarMap(4,1);
 CleanWarMap(10,0);
 BoxBack();
 JY.MenuPic.num=tmp;
 return eid;
 else
 PlayWavE(2);
 WarDrawStrBoxWaitKey('不能攻击我方．',C_WHITE);
 end
 end
 else
 PlayWavE(2);
 --WarDrawStrBoxWaitKey('没有敌人．',C_WHITE);
 end
 else
 PlayWavE(2);
 if flag then
 WarDrawStrBoxWaitKey('不在范围内．',C_WHITE);
 else
 WarDrawStrBoxWaitKey('不在攻击范围内．',C_WHITE);
 end
 end
 elseif event==-1 then
 PlayWavE(1);
 CleanWarMap(4,1);
 CleanWarMap(10,0);
 BoxBack();
 JY.MenuPic.num=tmp;
War.ControlStatus="actionMenu"
 return 0;
 end
 end
 JY.MenuPic.num=tmp;
end

function WarCheckDX()
 local menux,menuy;
 local dx=GetWarMap(War.MX,War.MY,1);
 --size = 16
 --w/h = 112 / 60
 if War.MX-War.CX>math.modf(War.MW/2) then
 menux=16+War.BoxWidth*(War.MX-War.CX)-136;
 else
 menux=16+War.BoxWidth*(War.MX-War.CX+1);
 end
 if War.MY-War.CY>math.modf(War.MD/2) then
 menuy=32+War.BoxWidth*(War.MY-War.CY)-40;
 else
 menuy=32+War.BoxWidth*(War.MY-War.CY);
 end
 lib.Background(menux,menuy,menux+136,menuy+86,160);
 menux=menux+8;
 menuy=menuy+8;
 lib.LoadSur(War.DXpic,menux,menuy);
 DrawGameBox(menux,menuy,menux+War.BoxWidth,menuy+War.BoxDepth,C_WHITE,-1);
 DrawString(menux+56,menuy+8,"防御效果",C_WHITE,16);
 local T={[0]="０％","２０％","３０％","－％","０％","－％","０％","５％",
 "５％","－％","－％","０％","－％","３０％","１０％","０％",
 "０％","－％","－％","－％",}
 DrawString(menux+88-#T[dx]*4,menuy+32,T[dx],C_WHITE,16);
--森林 20 山地 30 村庄 5
--草原 5 鹿寨 30 兵营 10
 -- 00 平原 01 森林 02 山地 03 河流 04 桥梁 05 城墙 06 城池 07 草原
 -- 08 村庄 09 悬崖 0A 城门 0B 荒地 0C 栅栏 0D 鹿砦 0E 兵营 0F 粮仓
 -- 10 宝物库 11 房舍 12 火焰 13 浊流
 DrawString(menux,menuy+56,War.DX[dx],C_WHITE,16);
 if dx==8 or dx==13 or dx==14 then
 DrawString(menux+56,menuy+56,"有恢复",C_WHITE,16);
 end
 --村庄、鹿砦可以恢复士气和兵力．兵营可以恢复兵力，但不能恢复士气．
 --玉玺可以恢复兵力和士气，援军报告可以恢复兵力，赦命书可以恢复士气．
 --地形和宝物的恢复能力不能叠加，也就是说，处于村庄地形上再持有恢复性宝物，与没有持有恢复性宝物效果相同．但如果地形只能恢复兵力（如兵营），但宝物可以恢复兵力，这种情况下，兵力士气都能得到自动恢复．
end

function fillblank(s,num)
 local len=num-string.len(s);
 if len<=0 then
 return string.sub(s,1,num);
 else
 local left,right;
 left=math.modf(len/2);
 right=len-left;
 return string.format(string.format("%%%ds%%s%%%ds",left,right),"",s,"")
 end
end

--使用策略
function WarMagicMenu()
 local id=War.SelID;
 local pid=War.Person[id].id;
 local bz=JY.Person[pid]["兵种"];
 local lv=JY.Person[pid]["等级"];
 local menux,menuy=0,0;
 local menu_off=16;
 local mx=War.Person[id].x;
 local my=War.Person[id].y;
 if mx-War.CX>math.modf(War.MW/2) then
 menux=16+War.BoxWidth*(mx-War.CX)-104-menu_off;
 else
 menux=16+War.BoxWidth*(mx-War.CX+1)+menu_off;
 end
 local m={};
 local n=0;
local eid=0
local eid2=0
local eid3=0
local eid4=0

 for i=1,JY.MagicNum-1 do
 --if between(JY.Bingzhong[bz]["策略"..i],1,lv) then

if CC.Enhancement and WarCheckSkill(id,101) then --策略模仿
if GetWarMap(mx-1,my,2)>0 then --左
eid=GetWarMap(mx-1,my,2)
end
if GetWarMap(mx+1,my,2)>0 then --右
eid2=GetWarMap(mx+1,my,2)
end
if GetWarMap(mx,my-1,2)>0 then --上
eid3=GetWarMap(mx,my-1,2)
end
if GetWarMap(mx,my+1,2)>0 then --下
eid4=GetWarMap(mx,my+1,2)
end
end

 if WarHaveMagic(id,i) or eid>0 and WarHaveMagic(eid,i) or eid2>0 and WarHaveMagic(eid2,i) or eid3>0 and WarHaveMagic(eid3,i) or eid4>0 and WarHaveMagic(eid4,i) then
 n=n+1;

if CC.Enhancement and (JY.Person[pid]["武器"]==12 or WarCheckSkill(id,112)) then --七星剑 策略值消耗减半
m[i]={fillblank(JY.Magic[i]["名称"],8)..string.format("% 2d",math.modf(JY.Magic[i]["消耗"]/2)),nil,1};
else
m[i]={fillblank(JY.Magic[i]["名称"],8)..string.format("% 2d",JY.Magic[i]["消耗"]),nil,1};
end

 else
 m[i]={"",nil,0};
 end
 end
 menuy=math.min(32+War.BoxDepth*(my-War.CY)+menu_off,CC.ScreenH-16-(16+8+20*math.min(n,8))-menu_off);
 local r;
 if n==0 then
 PlayWavE(2);
 WarDrawStrBoxWaitKey("没有可用策略．",C_WHITE);
 return 0;
 elseif n<=8 then
 r=WarShowMenu(m,JY.MagicNum-1,0,menux,menuy,0,0,5,1,16,C_WHITE,C_WHITE);
 else
 r=WarShowMenu(m,JY.MagicNum-1,8,menux,menuy,0,0,6,1,16,C_WHITE,C_WHITE);
 end
 if r>0 then

local clxh=JY.Magic[r]["消耗"]
if CC.Enhancement and (JY.Person[pid]["武器"]==12 or WarCheckSkill(id,112)) then --七星剑 策略值消耗减半
clxh=math.modf(clxh/2)
end

 if JY.Person[pid]["策略"]<clxh then
 PlayWavE(2);
 WarDrawStrBoxWaitKey("策略值不足．",C_WHITE);
 else
 local MenuPicNum=JY.MenuPic.num;
 JY.MenuPic.num=0;
 if WarMagicMenu_sub(id,r,false) then

if CC.Enhancement and (JY.Person[pid]["武器"]==12 or WarCheckSkill(id,112)) then --七星剑 策略值消耗减半
JY.Person[pid]["策略"]=JY.Person[pid]["策略"]-math.modf(JY.Magic[r]["消耗"]/2)
else
 JY.Person[pid]["策略"]=JY.Person[pid]["策略"]-JY.Magic[r]["消耗"];
end

 JY.MenuPic.num=MenuPicNum;
 return 1;
 end
 JY.MenuPic.num=MenuPicNum;
 end
 end
 return 0;
end

function WarMagicMenu_sub(id,r,ItemFlag)
 local kind=JY.Magic[r]["类型"];
 if kind==1 then --火系
 if between(War.Weather,4,5) then
 WarDrawStrBoxConfirm("雨天不能使用火攻．",C_WHITE);
 else
 WarDrawStrBoxDelay("用火攻攻击敌人．",C_WHITE);
 WarSetAtkFW(id,JY.Magic[r]["施展范围"]);
 local eid=WarSelectAtk(false,JY.Magic[r]["效果范围"]);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 if WarMagicCheck(id,eid,r) then
 WarDrawStrBoxDelay(JY.Magic[r]["名称"].."之计",C_WHITE);
 WarMagic(id,eid,r,ItemFlag);
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["效果范围"]==11 then
if JY.Person[War.Person[eid].id]["兵力"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end

 return true;
 else
 WarDrawStrBoxConfirm("敌人在森林、草原、平原、城池，*存在的场合才能使用．",C_WHITE);
 end
 end
 end
 elseif kind==2 then --水系
 WarDrawStrBoxDelay("用水攻攻击敌人．",C_WHITE);
 WarSetAtkFW(id,JY.Magic[r]["施展范围"]);
 local eid=WarSelectAtk(false,JY.Magic[r]["效果范围"]);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 if WarMagicCheck(id,eid,r) then
 WarDrawStrBoxDelay(JY.Magic[r]["名称"].."之计",C_WHITE);
 WarMagic(id,eid,r,ItemFlag);

if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["效果范围"]==11 then
if JY.Person[War.Person[eid].id]["兵力"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end

 return true;
 else
 WarDrawStrBoxConfirm("敌人在桥梁、平原，*存在的场合才能使用．",C_WHITE);
 end
 end
 elseif kind==3 then --落石系
 WarDrawStrBoxDelay("用落石攻击敌人．",C_WHITE);
 WarSetAtkFW(id,JY.Magic[r]["施展范围"]);
 local eid=WarSelectAtk(false,JY.Magic[r]["效果范围"]);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 if WarMagicCheck(id,eid,r) then
 WarDrawStrBoxDelay(JY.Magic[r]["名称"].."之计",C_WHITE);
 WarMagic(id,eid,r,ItemFlag);

if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["效果范围"]==11 then
if JY.Person[War.Person[eid].id]["兵力"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end

 return true;
 else
 WarDrawStrBoxConfirm("敌人在山地、荒地，*存在的场合才能使用．",C_WHITE);
 end
 end
 elseif kind==4 then --假情报系
 WarDrawStrBoxDelay("使敌人混乱．",C_WHITE);
 WarSetAtkFW(id,JY.Magic[r]["施展范围"]);
 local eid=WarSelectAtk(false,JY.Magic[r]["效果范围"]);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 WarMagic(id,eid,r,ItemFlag);
 return true;
 end
 elseif kind==5 then --牵制系
 WarDrawStrBoxDelay("重挫敌人士气．",C_WHITE);
 WarSetAtkFW(id,JY.Magic[r]["施展范围"]);
 local eid=WarSelectAtk(false,JY.Magic[r]["效果范围"]);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 WarMagic(id,eid,r,ItemFlag);
 return true;
 end
 elseif kind==6 then --激励系
 WarDrawStrBoxDelay("恢复士气值．",C_WHITE);
 --恢复范围内的士气值部队．
 WarSetAtkFW(id,JY.Magic[r]["施展范围"]);
 local eid=WarSelectAtk(true,JY.Magic[r]["效果范围"]);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 WarMagic(id,eid,r,ItemFlag);
 return true;
 end
 elseif kind==7 then --援助系
 WarDrawStrBoxDelay("恢复兵力．",C_WHITE);
 --恢复范围内的兵力部队
 WarSetAtkFW(id,JY.Magic[r]["施展范围"]);
 local eid=WarSelectAtk(true,JY.Magic[r]["效果范围"]);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 WarMagic(id,eid,r,ItemFlag);
 return true;
 end
 elseif kind==8 then --看护系
 WarDrawStrBoxDelay("恢复兵力和士气值．",C_WHITE);
 WarSetAtkFW(id,JY.Magic[r]["施展范围"]);
 local eid=WarSelectAtk(true,JY.Magic[r]["效果范围"]);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 WarMagic(id,eid,r,ItemFlag);
 return true;
 end
 elseif kind==9 then --毒系
 WarDrawStrBoxDelay("用毒攻击敌人．",C_WHITE);
 WarSetAtkFW(id,JY.Magic[r]["施展范围"]);
 local eid=WarSelectAtk(false,JY.Magic[r]["效果范围"]);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 if WarMagicCheck(id,eid,r) then
 WarDrawStrBoxDelay(JY.Magic[r]["名称"].."之计",C_WHITE);
 WarMagic(id,eid,r,ItemFlag);

if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["效果范围"]==11 then
if JY.Person[War.Person[eid].id]["兵力"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end

 return true;
 else
 WarDrawStrBoxConfirm("未知错误引起的无法使用．",C_WHITE);
 end
 end
 elseif kind==10 then --落雷系
 if between(War.Weather,3,5) then
 WarDrawStrBoxDelay("用落雷攻击敌人．",C_WHITE);
 WarSetAtkFW(id,JY.Magic[r]["施展范围"]);
 local eid=WarSelectAtk(false,JY.Magic[r]["效果范围"]);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 if WarMagicCheck(id,eid,r) then
 WarDrawStrBoxDelay(JY.Magic[r]["名称"].."之计",C_WHITE);
 WarMagic(id,eid,r,ItemFlag);

if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["效果范围"]==11 then
if JY.Person[War.Person[eid].id]["兵力"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end

 return true;
 else
 WarDrawStrBoxConfirm("晴天不能使用落雷．",C_WHITE);
 end
 end
 else
 WarDrawStrBoxConfirm("晴天不能使用落雷．",C_WHITE);
 end
 elseif kind==11 then --炸弹
 WarDrawStrBoxDelay("用炸弹攻击敌人．",C_WHITE);
 WarSetAtkFW(id,JY.Magic[r]["施展范围"]);
 local eid=WarSelectAtk(false,JY.Magic[r]["效果范围"]);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 if WarMagicCheck(id,eid,r) then
 WarDrawStrBoxDelay("投掷炸弹．",C_WHITE);
 WarMagic(id,eid,r,ItemFlag);
 return true;
 else
 WarDrawStrBoxConfirm("未知错误引起的无法使用．",C_WHITE);
 end
 end
 end
 return false;
end
function WarMagicHitRatio(wid,eid,mid)
 if between(JY.Magic[mid]["类型"],6,8) then
 return 1;
 end
 local p1=JY.Person[War.Person[wid].id];
 local p2=JY.Person[War.Person[eid].id];
 local a=p1["智力2"]*p1["等级"]/100+p1["智力2"];
 local b=(p2["智力2"]*p2["等级"]/100+p2["智力2"])/4;
 if CC.Enhancement then
 if JY.Magic[mid]["类型"]==2 and (WarCheckSkill(eid,3) or WarCheckSkill(eid,23)) then --水神/藤甲
 a=1;
 b=2;
 end
 if JY.Magic[mid]["类型"]==1 and WarCheckSkill(eid,4) then --火神
 a=1;
 b=2;
 end
 if JY.Magic[mid]["类型"]==4 and WarCheckSkill(eid,20) then --沉着
 a=1;
 b=2;
 end
 if WarCheckSkill(wid,17) then --神算
 --a=a+p1["智力"];
 a=a*2;
 end
 if WarCheckSkill(eid,18) then --识破
 --b=b+p2["智力"]/4;
 b=b*2;
 end
 end
 if JY.Magic[mid]["类型"]==4 then
 b=b*2;
 end
 if p2["兵种"]==13 or p2["兵种"]==16 or p2["兵种"]==19 then
 --b=b*2;
 b=b*1.5;
 end
 local v=1-b/a;
 v=limitX(v,0,1);
 return v;
end

--策略使用效果
function WarMagic(wid,eid,mid,ItemFlag)
War.ControlStatus="actionMenu"
 ItemFlag=ItemFlag or false;
 local mx=War.Person[eid].x;
 local my=War.Person[eid].y;
 local d1,d2=WarAutoD(wid,eid);
 local atkarray=WarGetAtkFW(mx,my,JY.Magic[mid]["效果范围"]);
 War.Person[wid].action=2;
 War.Person[wid].frame=0;
 War.Person[wid].d=d1;
 WarDelay(4);
 PlayWavE(8);
 WarDelay(8);
 PlayWavE(39);
 WarDelay(12);
 War.Person[wid].action=0;
 for i=atkarray.num,1,-1 do
 local x,y=atkarray[i][1],atkarray[i][2];
 local id=GetWarMap(x,y,2);
 if id>0 and War.Person[id].live and (not War.Person[id].hide) then
 if War.Person[id].enemy==War.Person[eid].enemy then
 
 else
 table.remove(atkarray,i);
 atkarray.num=atkarray.num-1;
 end
 else
 table.remove(atkarray,i);
 atkarray.num=atkarray.num-1;
 end
 end
 
 
 for i=1,atkarray.num do
 local x,y=atkarray[i][1],atkarray[i][2];
 local id=GetWarMap(x,y,2);
 if id>0 and War.Person[id].live and (not War.Person[id].hide) then --table.remove后必然为true
 if War.Person[id].enemy==War.Person[eid].enemy then --table.remove后必然为true
 local id1=War.Person[wid].id;
 local id2=War.Person[id].id;
 local hitratio=WarMagicHitRatio(wid,id,mid);
 if ItemFlag then
 hitratio=1;
 end
 local hurt,sq_hurt,jy,jy2=WarMagicHurt(wid,id,mid,ItemFlag);
 d1,d2=WarAutoD(wid,id);
 if between(JY.Magic[mid]["类型"],6,8) then

 if JY.Magic[mid]["类型"]==6 then
 --基本士气恢复值＝策略基本威力＋补给方等级÷10
 --士气恢复随机修正值是一个随机整数，在0到（基本士气恢复值÷10－1）之间。
 --补给效果＝基本士气恢复值＋士气恢复随机修正值
 if ItemFlag then
 sq_hurt=JY.Magic[mid]["效果"];
 else
 sq_hurt=JY.Magic[mid]["效果"]+JY.Person[id1]["等级"]/10;
 end
 sq_hurt=math.modf(sq_hurt*(1+math.random()/10));
 sq_hurt=limitX(sq_hurt,0,War.Person[id].sq_limited-JY.Person[id2]["士气"]);
 hurt=-1;
 if atkarray.num==1 then
 WarDrawStrBoxDelay(JY.Person[id2]["姓名"].."的士气值上升．",C_WHITE);
 end

 elseif JY.Magic[mid]["类型"]==7 then
 --基本兵力恢复值＝策略基本威力＋补给方智力×补给方等级÷20
 --兵力恢复随机修正值是一个随机整数，在0到（基本兵力恢复值÷10－1）之间。
 --补给效果＝基本兵力恢复值＋兵力恢复随机修正值
 if ItemFlag then
 hurt=JY.Magic[mid]["效果"];
 else
 hurt=JY.Magic[mid]["效果"]+JY.Person[id1]["智力2"]*JY.Person[id1]["等级"]/20;
 if CC.Enhancement then
 if WarCheckSkill(eid,41) then --补给
 hurt=math.modf(hurt*(100+JY.Skill[41]["参数1"])/100)
 end
 end
 end
 hurt=math.modf(hurt*(1+math.random()/10));
 hurt=limitX(hurt,0,JY.Person[id2]["最大兵力"]-JY.Person[id2]["兵力"]);
 sq_hurt=-1;
 if atkarray.num==1 then
 WarDrawStrBoxDelay(JY.Person[id2]["姓名"].."的兵力上升．",C_WHITE);
 end

 elseif JY.Magic[mid]["类型"]==8 then
 local hp={600,1200,1800};
 local sp={30,40,50};
 if ItemFlag then
 hurt=hp[JY.Magic[mid]["效果"]];
 sq_hurt=sp[JY.Magic[mid]["效果"]];
 else
 hurt=hp[JY.Magic[mid]["效果"]]+JY.Person[id1]["智力2"]*JY.Person[id1]["等级"]/20;
 sq_hurt=sp[JY.Magic[mid]["效果"]]+JY.Person[id1]["等级"]/10;
 if CC.Enhancement then
 if WarCheckSkill(eid,41) then --补给
 hurt=math.modf(hurt*(100+JY.Skill[41]["参数1"])/100)
 end
 end
 end
 hurt=math.modf(hurt*(1+math.random()/10));
 hurt=limitX(hurt,0,JY.Person[id2]["最大兵力"]-JY.Person[id2]["兵力"]);
 sq_hurt=math.modf(sq_hurt*(1+math.random()/10));
 sq_hurt=limitX(sq_hurt,0,War.Person[id].sq_limited-JY.Person[id2]["士气"]);
 if atkarray.num==1 then
 WarDrawStrBoxDelay(JY.Person[id2]["姓名"].."的兵力和士气值上升．",C_WHITE);
 end
 end
 PlayMagic(mid,x,y,id1);
 if hurt>=0 then
 War.Person[id].hurt=hurt;
 WarDelay(8);
 War.Person[id].hurt=-1;
 end
 if sq_hurt>=0 then
 War.Person[id].hurt=sq_hurt;
 WarDelay(8);
 War.Person[id].hurt=-1;
 end
 local t=16;
 t=math.min(16,(math.modf(math.max( 2,math.abs(hurt)/50,math.abs(sq_hurt)))));
 local oldbl=JY.Person[id2]["兵力"];
 local oldsq=JY.Person[id2]["士气"];
 for ii=0,t do
 if hurt>0 then
 JY.Person[id2]["兵力"]=oldbl+hurt*ii/t;
 end
 if sq_hurt>0 then
 JY.Person[id2]["士气"]=oldsq+sq_hurt*ii/t;
 end
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 DrawStatusMini(id);
 lib.GetKey();
 ReFresh();
 end
 JY.ReFreshTime=lib.GetTime();
 ReFresh(CC.OpearteSpeed*4);
 WarDelay(4);
 if JY.Magic[mid]["类型"]==6 or JY.Magic[mid]["类型"]==8 then
 WarTroubleShooting(id);
 end
 if i==atkarray.num then
 if atkarray.num>1 then
 if JY.Magic[mid]["类型"]==6 then
 if War.Person[id].enemy then
 WarDrawStrBoxDelay("敌军的士气值恢复了．",C_WHITE);
 else
 WarDrawStrBoxDelay("我军的士气值恢复了．",C_WHITE);
 end
 elseif JY.Magic[mid]["类型"]==7 then
 if War.Person[id].enemy then
 WarDrawStrBoxDelay("敌军的兵力恢复了．",C_WHITE);
 else
 WarDrawStrBoxDelay("我军的兵力恢复了．",C_WHITE);
 end
 elseif JY.Magic[mid]["类型"]==8 then
 if War.Person[id].enemy then
 WarDrawStrBoxDelay("敌军的兵力和士气值恢复了．",C_WHITE);
 else
 WarDrawStrBoxDelay("我军的兵力和士气值恢复了．",C_WHITE);
 end
 end
 end
 jy=8;
 if CC.Enhancement then
 jy=JY.Magic[mid]["消耗"];
 end
 if (JY.Person[id1]["兵种"]==13 or JY.Person[id1]["兵种"]==19) then
 jy=math.modf(jy*2);
 end
 if not (War.Person[wid].enemy or ItemFlag) then
 WarAddExp(wid,jy);
 end
 end
 ReSetAttrib(id1,false);
 ReSetAttrib(id2,false);
 WarResetStatus(id);
 elseif JY.Magic[mid]["类型"]==4 then --假情报系
 jy=8;
 if CC.Enhancement then
 jy=JY.Magic[mid]["消耗"];
 end
 if math.random()<hitratio then
 War.Person[id].action=4;
 War.Person[id].frame=0;
 War.Person[id].d=d2;
 PlayMagic(mid,x,y,id1);
 War.Person[id].hurt=-1;
 if War.Person[id].troubled then
 WarDelay(2);
 WarDrawStrBoxDelay(JY.Person[id2]["姓名"].."更加混乱了！",C_WHITE);
 else
 War.Person[id].troubled=true
 War.Person[id].action=7
 WarDelay(2);
 WarDrawStrBoxDelay(JY.Person[id2]["姓名"].."混乱了！",C_WHITE);
 end
 else
 War.Person[id].action=3;
 War.Person[id].frame=0;
 War.Person[id].d=d2;
 PlayMagic(mid,x,y,id1);
 PlayWavE(81);
 WarDelay(8);
 War.Person[id].hurt=-1;
 WarDrawStrBoxDelay(JY.Person[id1]["姓名"].."的计谋失败了！",C_WHITE);
 end
 if i==atkarray.num then
 if not (War.Person[wid].enemy or ItemFlag) then
 WarAddExp(wid,jy);
 end
 end
 ReSetAttrib(id1,false);
 ReSetAttrib(id2,false);
 WarResetStatus(id);
 
 elseif JY.Magic[mid]["类型"]==5 then --牵制系
 jy=8;
 if CC.Enhancement then
 jy=JY.Magic[mid]["消耗"];
 end
 if math.random()<hitratio then
 hurt=0;
 --士气损伤＝策略基本士气损伤＋攻击方等级÷10－防御方等级÷10
 if ItemFlag then
 sq_hurt=math.modf(JY.Magic[mid]["效果"]-JY.Person[id2]["等级"]/10);
 else
 sq_hurt=math.modf(JY.Magic[mid]["效果"]+JY.Person[id1]["等级"]/10-JY.Person[id2]["等级"]/10);
 end
 sq_hurt=limitX(sq_hurt,0,JY.Person[id2]["士气"]);
 War.Person[id].action=4;
 War.Person[id].frame=0;
 War.Person[id].d=d2;
 WarDrawStrBoxDelay(JY.Person[id2]["姓名"].."的士气值下降．",C_WHITE);
 PlayMagic(mid,x,y,id1);
 War.Person[id].hurt=sq_hurt;
 WarDelay(8);
 War.Person[id].hurt=-1;
 local t=16;
 t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/50,math.abs(sq_hurt)))));
 local oldbl=JY.Person[id2]["兵力"];
 local oldsq=JY.Person[id2]["士气"];
 for i=1,t do
 JY.Person[id2]["兵力"]=oldbl-hurt*i/t;
 JY.Person[id2]["士气"]=oldsq-sq_hurt*i/t;
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 DrawStatusMini(eid);
 lib.GetKey();
 ReFresh();
 end
 JY.ReFreshTime=lib.GetTime();
 ReFresh(CC.OpearteSpeed*4);
 WarDelay(4);
 WarGetTrouble(id);
 else
 War.Person[id].action=3;
 War.Person[id].frame=0;
 War.Person[id].d=d2;
 PlayMagic(mid,x,y,id1);
 War.Person[id].hurt=0;
 PlayWavE(81);
 WarDelay(8);
 War.Person[id].hurt=-1;
 WarDrawStrBoxDelay(JY.Person[id1]["姓名"].."的计谋失败了！",C_WHITE);
 end
 if i==atkarray.num then
 if not (War.Person[wid].enemy or ItemFlag) then
 WarAddExp(wid,jy);
 end
 end
 ReSetAttrib(id1,false);
 ReSetAttrib(id2,false);
 WarResetStatus(id);
 elseif WarMagicCheck(wid,id,mid) then
 if math.random()<hitratio then
 War.Person[id].action=4;
 War.Person[id].frame=0;
 War.Person[id].d=d2;
 PlayMagic(mid,x,y,id1);
 War.Person[id].hurt=hurt;
 WarDelay(8);
 War.Person[id].hurt=-1;
 local t=16;
 t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/50,math.abs(sq_hurt)))));
 local oldbl=JY.Person[id2]["兵力"];
 local oldsq=JY.Person[id2]["士气"];
 for i=1,t do
 JY.Person[id2]["兵力"]=oldbl-hurt*i/t;
 JY.Person[id2]["士气"]=oldsq-sq_hurt*i/t;
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 DrawStatusMini(id);
 lib.GetKey();
 ReFresh();
 end
 JY.ReFreshTime=lib.GetTime();
 ReFresh(CC.OpearteSpeed*4);
 WarDelay(4);
 WarGetTrouble(id);
 
 if CC.Enhancement then
 if JY.Magic[mid]["类型"]==3 then --落石系
 if WarCheckSkill(wid,15) then --落沙
 if math.random(100)<=JY.Skill[15]["参数1"] then
 if JY.Person[id2]["兵力"]>0 then
 if not War.Person[id].troubled then
 War.Person[id].troubled=true
 War.Person[id].action=7
 WarDelay(2);
 WarDrawStrBoxDelay(JY.Person[id2]["姓名"].."混乱了！",C_WHITE);
 end
 end
 end
 end
 end
 end
 
 if not (War.Person[wid].enemy) then
 WarAddExp(wid,jy);

 local id1=War.Person[wid].id;
if CC.Enhancement and JY.Person[id1]["智力"]<100 and (not War.Person[wid].enemy) then
JY.Person[id1]["智力经验"]=JY.Person[id1]["智力经验"]+2

if JY.Person[id1]["智力经验"]>=200 then
JY.Person[id1]["智力经验"]=JY.Person[id1]["智力经验"]-200
 local MenuPicNum=JY.MenuPic.num;
 JY.MenuPic.num=0;
 local oldaction=War.Person[wid].action;
 --转圈，升级动作
 War.Person[wid].action=0;
 for t=1,2 do
 War.Person[wid].d=3;
 WarDelay(3);
 War.Person[wid].d=2;
 WarDelay(3);
 War.Person[wid].d=4;
 WarDelay(3);
 War.Person[wid].d=1;
 WarDelay(3);
 end
 PlayWavE(12);
 War.Person[wid].action=6;
 for i=0,256,8 do
 War.Person[wid].effect=i;
 WarDelay(1);
 end
 for i=240,0,-8 do
 War.Person[wid].effect=i;
 WarDelay(1);
 end
 WarDrawStrBoxWaitKey(JY.Person[id1]["姓名"].."成功凝练出一枚智力种",C_WHITE);
 ReSetAttrib(id1,false);
 War.Person[wid].action=oldaction;
 JY.MenuPic.num=MenuPicNum;

for n=1,8 do
if JY.Person[id1]["道具"..n]==0 then
JY.Person[id1]["道具"..n]=72
break
end
end

end
end

 end
 ReSetAttrib(id1,false);
 ReSetAttrib(id2,false);
 WarResetStatus(id);
 else
 War.Person[id].action=3;
 War.Person[id].frame=0;
 War.Person[id].d=d2;
 PlayMagic(mid,x,y,id1);
 War.Person[id].hurt=0;
 PlayWavE(81);
 WarDelay(8);
 War.Person[id].hurt=-1;
 if not (War.Person[wid].enemy) then
 WarAddExp(wid,jy2);

 local id1=War.Person[wid].id;
if CC.Enhancement and JY.Person[id1]["智力"]<100 and (not War.Person[wid].enemy) then
JY.Person[id1]["智力经验"]=JY.Person[id1]["智力经验"]+1

if JY.Person[id1]["智力经验"]>=200 then
JY.Person[id1]["智力经验"]=JY.Person[id1]["智力经验"]-200
 local MenuPicNum=JY.MenuPic.num;
 JY.MenuPic.num=0;
 local oldaction=War.Person[wid].action;
 --转圈，升级动作
 War.Person[wid].action=0;
 for t=1,2 do
 War.Person[wid].d=3;
 WarDelay(3);
 War.Person[wid].d=2;
 WarDelay(3);
 War.Person[wid].d=4;
 WarDelay(3);
 War.Person[wid].d=1;
 WarDelay(3);
 end
 PlayWavE(12);
 War.Person[wid].action=6;
 for i=0,256,8 do
 War.Person[wid].effect=i;
 WarDelay(1);
 end
 for i=240,0,-8 do
 War.Person[wid].effect=i;
 WarDelay(1);
 end
 WarDrawStrBoxWaitKey(JY.Person[id1]["姓名"].."成功凝练出一枚智力种",C_WHITE);
 ReSetAttrib(id1,false);
 War.Person[wid].action=oldaction;
 JY.MenuPic.num=MenuPicNum;

for n=1,8 do
if JY.Person[id1]["道具"..n]==0 then
JY.Person[id1]["道具"..n]=72
break
end
end

end
end

 end
 ReSetAttrib(id1,false);
 ReSetAttrib(id2,false);
 WarResetStatus(id);
 WarDrawStrBoxDelay(JY.Person[id1]["姓名"].."的计策失败了！",C_WHITE);
 end
 end
 end
 end
 end
 WarResetStatus(wid);
end

function PlayMagic(mid,x,y,pid)
 if CC.cldh==0 then
 return;
 end
 local eft=JY.Magic[mid]["动画"];
 local pic_w,pic_h=lib.PicGetXY(0,eft*2);
 local frame=pic_h/pic_w;
 if eft==241 then
 frame=7;
 elseif eft==242 then
 frame=13;
 elseif eft==243 then
 frame=13;
 end
 pic_h=pic_h/frame;
 local str=JY.Person[pid]["姓名"]..'的策略';
 local sx,sy;
 sx=16+War.BoxWidth*(x-War.CX+0.5)-pic_w/2;
 sy=32+War.BoxDepth*(y-War.CY+1)-pic_h;
 PlayWavE(JY.Magic[mid]["音效"]);
 local rpt=2;
 if between(JY.Magic[mid]["类型"],4,8) then
 rpt=1;
 end
 for i=1,frame do
 for n=1,rpt do
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 DrawYJZBox2(-256,64,str,C_WHITE);
 lib.SetClip(sx,sy,sx+pic_w,sy+pic_h);
 lib.PicLoadCache(0,eft*2,sx,sy-pic_h*(i-1),1);
 lib.SetClip(0,0,0,0);
 lib.GetKey();
 ReFresh();
 end
 end
end
function WarMagicCheck(wid,eid,mid)
 local kind=JY.Magic[mid]["类型"];
 local dx=GetWarMap(War.Person[eid].x,War.Person[eid].y,1);
 if between(kind,4,8) or kind==9 or kind==11 then
 return true;
 end
 --weather
 if kind==1 and between(War.Weather,4,5) then
 return false;
 end
 if kind==10 and between(War.Weather,3,5) then
 return true;
 end
 --dx
 if CC.Enhancement then
 if WarCheckSkill(wid,46) then --地理
 return true;
 end
 end
 if kind==1 and (dx==0 or dx==1 or dx==6 or dx==7) then
 return true;
 end
 if kind==2 and (dx==0 or dx==4) then
 return true;
 end
 if kind==3 and (dx==2 or dx==11) then
 return true;
 end
 return false;
end

--策略伤害
function WarMagicHurt(wid,eid,mid,ItemFlag)
 ItemFlag=ItemFlag or false;
 local id1=War.Person[wid].id;
 local id2=War.Person[eid].id;
 local p1=JY.Person[id1];
 local p2=JY.Person[id2];
 local hurt=JY.Magic[mid]["效果"];
 if ItemFlag then
 --hurt=hurt-(p2["智力"]*p2["等级"]/50+p2["智力"]);
 hurt=hurt-(p2["智力2"]*p2["等级"]/40+p2["智力2"]);
 else
 --hurt=hurt+(p1["智力"]*p1["等级"]/50+p1["智力"])*2-(p2["智力"]*p2["等级"]/50+p2["智力"]);
 hurt=hurt+(p1["智力2"]*p1["等级"]/40+p1["智力2"])*2-(p2["智力2"]*p2["等级"]/40+p2["智力2"]);
 end
 if p2["兵种"]==13 or p2["兵种"]==16 or p2["兵种"]==19 then
 hurt=hurt/2;
 end
 --[[
 如果被防御方在树林中，且策略是焦热系策略
 策略攻击杀伤＝策略攻击杀伤＋策略攻击杀伤÷4
 如果当前天气是雨天，且策略是漩涡系策略
 策略攻击杀伤＝策略攻击杀伤＋策略攻击杀伤÷4
 ]]--
 local dx=GetWarMap(War.Person[eid].x,War.Person[eid].y,1);
 if JY.Magic[mid]["类型"]==1 and dx==1 then
 hurt=hurt*1.25;
 end
 if JY.Magic[mid]["类型"]==2 and between(War.Weather,4,5) then
 hurt=hurt*1.25;
 end
 if JY.Magic[mid]["类型"]==10 and between(War.Weather,4,5) then
 hurt=hurt*1.1;
 end
 local item_atk=0;
 if p1["武器"]>0 then
 item_atk=item_atk+JY.Item[p1["武器"]]["策略攻击"];
 end
 if p1["防具"]>0 then
 item_atk=item_atk+JY.Item[p1["防具"]]["策略攻击"];
 end
 if p1["辅助"]>0 then
 item_atk=item_atk+JY.Item[p1["辅助"]]["策略攻击"];
 end
 if item_atk~=0 then
 hurt=hurt*(100+item_atk)/100;
 end
 if CC.Enhancement then
 if JY.Magic[mid]["类型"]==1 and WarCheckSkill(wid,12) then --火计
 hurt=hurt*(100+JY.Skill[12]["参数1"])/100;
 end
 if JY.Magic[mid]["类型"]==2 and WarCheckSkill(wid,11) then --水计
 hurt=hurt*(100+JY.Skill[11]["参数1"])/100;
 end
 if JY.Magic[mid]["类型"]==3 and WarCheckSkill(wid,14) then --落石
 hurt=hurt*(100+JY.Skill[14]["参数1"])/100;
 end
 if (between(JY.Magic[mid]["类型"],1,3) or between(JY.Magic[mid]["类型"],9,10)) and WarCheckSkill(wid,39) then --毒计
 hurt=hurt*(100+JY.Skill[39]["参数1"])/100;
 end
 if (between(JY.Magic[mid]["类型"],1,3) or between(JY.Magic[mid]["类型"],9,10)) and WarCheckSkill(wid,50) then --深谋
 hurt=hurt*(100+JY.Skill[50]["参数1"])/100;
 end
 
 if JY.Magic[mid]["类型"]==1 and WarCheckSkill(eid,13) then --灭火
 hurt=hurt*(100-JY.Skill[13]["参数1"])/100;
 end
 if JY.Magic[mid]["类型"]==1 and WarCheckSkill(eid,4) then --火神
 hurt=1;
 end
 if JY.Magic[mid]["类型"]==2 and WarCheckSkill(eid,3) then --水神
 hurt=1;
 end
 if (between(JY.Magic[mid]["类型"],1,3) or between(JY.Magic[mid]["类型"],9,10)) then
 if WarCheckSkill(eid,16) then --明镜
 hurt=hurt*(100-JY.Skill[16]["参数1"])/100;
 end
 if WarCheckSkill(eid,37) then --虎视
 hurt=hurt*(100-JY.Skill[37]["参数1"])/100;
 end
 end
 if WarCheckSkill(eid,23) then --藤甲
 if JY.Magic[mid]["类型"]==1 then
 hurt=hurt*(100+JY.Skill[23]["参数2"])/100;
 end
 if JY.Magic[mid]["类型"]==2 then
 hurt=1;
 end
 end
 end
 hurt=math.modf(hurt*(1+math.random()/50));
 if hurt<1 then
 hurt=1;
 end
 -- 如果攻击伤害大于防御方兵力，则攻击伤害=防御方兵力
 if hurt>p2["兵力"] then
 hurt=p2["兵力"];
 end
 --士气降幅＝攻击伤害÷（防御方等级＋5）÷3
 local sq_hurt=math.modf(hurt/(p2["等级"]+5)/3);
 if sq_hurt==0 then
 if hurt>0 then
 sq_hurt=1;
 else
 sq_hurt=0;
 end
 end
 sq_hurt=limitX(sq_hurt,0,p2["士气"]);
 --经验值获得
 local jy=0;
 local jy2=0; --策略失败时的经验
 --敌军部队不能获得经验值．
 if p1["等级"]<99 and (not War.Person[wid].enemy) then--and (not War.Person[wid].friend) then
 --经验值由两部分构成：基本经验值和奖励经验值．
 local part1,part2=0,0;
 --当攻击方等级低于等于防御方等级时：
 if p1["等级"]<=p2["等级"] then
 --基本经验值＝（防御方等级－攻击方等级＋3）×2
 part1=(p2["等级"]-p1["等级"]+3)*2;
 --如果基本经验值大于16，则基本经验值＝16．
 if part1>16 then
 part1=16;
 end
 --提高获取经验
if CC.Enhancement then
 part1=(p2["等级"]-p1["等级"]+5)*2;
 if part1>24 then
 part1=24;
 end
end
 --当攻击方等级高于防御方等级时：
 else
 --基本经验值＝4
 part1=4;

if CC.Enhancement then
 part1=8; --提高获取经验
end

 end
 --如果杀死敌人，可以获得奖励经验值：
 if hurt==p2["兵力"] then
 --如果杀死敌军主将
 if War.Person[eid].leader then
 --奖励经验值＝48
 part2=48;
 --如果杀死的不是敌军主将，且敌军等级高于我军
 elseif p2["等级"]>p1["等级"] then
 --奖励经验值＝32
 part2=32;
 --如果杀死的不是敌军主将，且敌军等级低于等于我军
 else
 --奖励经验值＝64÷（攻击方等级－防御方等级＋2）
 part2=math.modf(64/(p1["等级"]-p2["等级"]+2));
 --提高获取经验
if CC.Enhancement then
 part2=32-(p1["等级"]-p2["等级"])*4;
 part2=limitX(part2,8,48);
end

 end
 end
 --最终获得的经验值＝基本经验值＋奖励经验值．
 jy=part1+part2;
 jy2=part1;
 end
 
 if JY.Magic[mid]["类型"]==11 then
 hurt=limitX((math.random(15)+90)*15,0,p2["兵力"]);
 sq_hurt=limitX(math.random(10)+30,0,p2["士气"]);
 jy=0;
 jy2=0;
 end
 
 return hurt,sq_hurt,jy,jy2;
end

function WarItemMenu()
 local id=War.SelID;
 local pid=War.Person[id].id;
 if JY.Person[pid]["道具1"]==0 then
 --PlayWavE(2);
 WarDrawStrBoxWaitKey("没有道具！",C_WHITE);
 return;
 end
 local menux,menuy=0,0;
 local menu_off=16;
 local mx=War.Person[id].x;
 local my=War.Person[id].y;
 if mx-War.CX>math.modf(War.MW/2) then
 menux=16+War.BoxWidth*(mx-War.CX)-80-menu_off;
 else
 menux=16+War.BoxWidth*(mx-War.CX+1)+menu_off;
 end
 menuy=math.min(32+War.BoxDepth*(my-War.CY)+menu_off,CC.ScreenH-16-112-menu_off);
 local m={
 {"　使用",WarItemMenu_sub,1},
 {"　交给",WarItemMenu_sub,1},
 {"　丢掉",WarItemMenu_sub,1},
 {"　观看",WarItemMenu_sub,1},
 };
 local r=WarShowMenu(m,4,0,menux,menuy,menux+80,menuy+112,1,1,16,C_WHITE,C_WHITE);
 if r>0 then
 return 1;
 else
 return 0;
 end
end

function WarItemMenu_sub(kind)
 local id=War.SelID;
 local pid=War.Person[id].id;
 local menux,menuy=0,0;
 local menu_off=16;
 local mx=War.Person[id].x;
 local my=War.Person[id].y;
 if mx-War.CX>math.modf(War.MW/2) then
 menux=16+War.BoxWidth*(mx-War.CX)-80-menu_off*2;
 else
 menux=16+War.BoxWidth*(mx-War.CX+1)+menu_off*2;
 end
 menuy=math.min(12+War.BoxDepth*(my-War.CY)+menu_off*2,CC.ScreenH-16-132-menu_off*2);
 local m={};
 for i=1,8 do
 local itemid=JY.Person[pid]["道具"..i];
 if itemid>0 then
 if kind==1 then
 m[i]={fillblank(JY.Item[itemid]["名称"],10),Item_Use,1};
 elseif kind==2 then
 m[i]={fillblank(JY.Item[itemid]["名称"],10),Item_Send,1};
 elseif kind==3 then
 m[i]={fillblank(JY.Item[itemid]["名称"],10),Item_Scrap,1};
 elseif kind==4 then
 m[i]={fillblank(JY.Item[itemid]["名称"],10),Item_Check,1};
 else
 m[i]={fillblank(JY.Item[itemid]["名称"],10),nil,1};
 end
 else
 m[i]={"",nil,0};
 end
 end
 local r=WarShowMenu(m,8,0,menux,menuy,0,0,4,1,16,C_WHITE,C_WHITE);
 if r>0 then
 return 1;
 else
 return 0;
 end
end

--使用道具
function Item_Use(i)
 local id=War.SelID;
 local pid=War.Person[id].id;
 local itemid=JY.Person[pid]["道具"..i];
 local kind=JY.Item[itemid]["类型"];
 if between(kind,1,2) then
 local mid=JY.Item[itemid]["效果"];
 local MenuPicNum=JY.MenuPic.num;
 JY.MenuPic.num=0;

 if WarMagicMenu_sub(id,mid,true) then
 JY.MenuPic.num=MenuPicNum;
 for n=i,7 do
 JY.Person[pid]["道具"..n]=JY.Person[pid]["道具"..(n+1)];
 end
 JY.Person[pid]["道具8"]=0;
 return 1;
 end

 JY.MenuPic.num=MenuPicNum;
 elseif kind==3 then
 --confirm
 if not WarDrawStrBoxYesNo(string.format('将部队变成%s．',JY.Bingzhong[JY.Item[itemid]["效果"]]["名称"]),C_WHITE) then
 return 0;
 elseif JY.Item[itemid]["需兵种"]>0 and JY.Person[pid]["兵种"]~=JY.Item[itemid]["需兵种"] then
 PlayWavE(2);
 WarDrawStrBoxDelay("需要"..JY.Bingzhong[JY.Item[itemid]["需兵种"]]["名称"].."．",C_WHITE);
 return 0;
 elseif JY.Person[pid]["等级"]<JY.Item[itemid]["需等级"] then
 PlayWavE(2);
 WarDrawStrBoxDelay("等级不足．",C_WHITE);
 return 0;
 else
 WarBingZhongUp(War.SelID,JY.Item[itemid]["效果"]);
 for n=i,7 do
 JY.Person[pid]["道具"..n]=JY.Person[pid]["道具"..(n+1)];
 end
 JY.Person[pid]["道具8"]=0;

 return 1;
 end

elseif kind==8 then --武力种
if not WarDrawStrBoxYesNo('提升武力值．',C_WHITE) then
 return 0;
 elseif JY.Person[pid]["武力"]>=100 then
 PlayWavE(2);
 WarDrawStrBoxDelay("无法提升．",C_WHITE);
 return 0;
 else
 local MenuPicNum=JY.MenuPic.num;
 JY.MenuPic.num=0;
 local oldaction=War.Person[War.SelID].action;
 --使用物品动作
 War.Person[War.SelID].action=0;
 War.Person[War.SelID].d=1;
 WarDelay(2);
 PlayWavE(41);
 War.Person[War.SelID].action=6;
 WarDelay(16);
 --转圈，升级动作
 War.Person[War.SelID].action=0;
 for t=1,2 do
 War.Person[War.SelID].d=3;
 WarDelay(3);
 War.Person[War.SelID].d=2;
 WarDelay(3);
 War.Person[War.SelID].d=4;
 WarDelay(3);
 War.Person[War.SelID].d=1;
 WarDelay(3);
 end
 PlayWavE(12);
 War.Person[War.SelID].action=6;
 for i=0,256,8 do
 War.Person[War.SelID].effect=i;
 WarDelay(1);
 end
 for i=240,0,-8 do
 War.Person[War.SelID].effect=i;
 WarDelay(1);
 end
JY.Person[pid]["武力"]=JY.Person[pid]["武力"]+1
 WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."的基础武力提升至".. JY.Person[pid]["武力"],C_WHITE);
 ReSetAttrib(pid,false);
 War.Person[War.SelID].action=oldaction;
 JY.MenuPic.num=MenuPicNum;
JY.Person[pid]["道具"..i]=0
 for n=i,7 do
 JY.Person[pid]["道具"..n]=JY.Person[pid]["道具"..(n+1)];
 end
 JY.Person[pid]["道具8"]=0;
 return 1;
 end

elseif kind==9 then --智力种
if not WarDrawStrBoxYesNo('提升智力值．',C_WHITE) then
 return 0;
 elseif JY.Person[pid]["智力"]>=100 then
 PlayWavE(2);
 WarDrawStrBoxDelay("无法提升．",C_WHITE);
 return 0;
 else
 local MenuPicNum=JY.MenuPic.num;
 JY.MenuPic.num=0;
 local oldaction=War.Person[War.SelID].action;
 --使用物品动作
 War.Person[War.SelID].action=0;
 War.Person[War.SelID].d=1;
 WarDelay(2);
 PlayWavE(41);
 War.Person[War.SelID].action=6;
 WarDelay(16);
 --转圈，升级动作
 War.Person[War.SelID].action=0;
 for t=1,2 do
 War.Person[War.SelID].d=3;
 WarDelay(3);
 War.Person[War.SelID].d=2;
 WarDelay(3);
 War.Person[War.SelID].d=4;
 WarDelay(3);
 War.Person[War.SelID].d=1;
 WarDelay(3);
 end
 PlayWavE(12);
 War.Person[War.SelID].action=6;
 for i=0,256,8 do
 War.Person[War.SelID].effect=i;
 WarDelay(1);
 end
 for i=240,0,-8 do
 War.Person[War.SelID].effect=i;
 WarDelay(1);
 end
JY.Person[pid]["智力"]=JY.Person[pid]["智力"]+1
 WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."的基础智力提升至".. JY.Person[pid]["智力"],C_WHITE);
 ReSetAttrib(pid,false);
 War.Person[War.SelID].action=oldaction;
 JY.MenuPic.num=MenuPicNum;
JY.Person[pid]["道具"..i]=0
 for n=i,7 do
 JY.Person[pid]["道具"..n]=JY.Person[pid]["道具"..(n+1)];
 end
 JY.Person[pid]["道具8"]=0;
 return 1;
 end

elseif kind==10 then --统率种
if not WarDrawStrBoxYesNo('提升统率值．',C_WHITE) then
 return 0;
 elseif JY.Person[pid]["统率"]>=100 then
 PlayWavE(2);
 WarDrawStrBoxDelay("无法提升．",C_WHITE);
 return 0;
 else
 local MenuPicNum=JY.MenuPic.num;
 JY.MenuPic.num=0;
 local oldaction=War.Person[War.SelID].action;
 --使用物品动作
 War.Person[War.SelID].action=0;
 War.Person[War.SelID].d=1;
 WarDelay(2);
 PlayWavE(41);
 War.Person[War.SelID].action=6;
 WarDelay(16);
 --转圈，升级动作
 War.Person[War.SelID].action=0;
 for t=1,2 do
 War.Person[War.SelID].d=3;
 WarDelay(3);
 War.Person[War.SelID].d=2;
 WarDelay(3);
 War.Person[War.SelID].d=4;
 WarDelay(3);
 War.Person[War.SelID].d=1;
 WarDelay(3);
 end
 PlayWavE(12);
 War.Person[War.SelID].action=6;
 for i=0,256,8 do
 War.Person[War.SelID].effect=i;
 WarDelay(1);
 end
 for i=240,0,-8 do
 War.Person[War.SelID].effect=i;
 WarDelay(1);
 end
JY.Person[pid]["统率"]=JY.Person[pid]["统率"]+1
 WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."的基础统率提升至".. JY.Person[pid]["统率"],C_WHITE);
 ReSetAttrib(pid,false);
 War.Person[War.SelID].action=oldaction;
 JY.MenuPic.num=MenuPicNum;
JY.Person[pid]["道具"..i]=0
 for n=i,7 do
 JY.Person[pid]["道具"..n]=JY.Person[pid]["道具"..(n+1)];
 end
 JY.Person[pid]["道具8"]=0;
 return 1;
 end

elseif kind==13 then --经验种
if not WarDrawStrBoxYesNo(JY.Person[pid]["姓名"]..'提升等级．',C_WHITE) then
 return 0;
 elseif JY.Person[pid]["等级"]>=99 then
 PlayWavE(2);
 WarDrawStrBoxDelay("无法提升．",C_WHITE);
 return 0;
 else

 local MenuPicNum=JY.MenuPic.num;
 JY.MenuPic.num=0;
 local oldaction=War.Person[War.SelID].action;
 --使用物品动作
 War.Person[War.SelID].action=0;
 War.Person[War.SelID].d=1;
 WarDelay(2);
 PlayWavE(41);
 War.Person[War.SelID].action=6;
 WarDelay(16);
 --转圈，升级动作
 War.Person[War.SelID].action=0;
 for t=1,2 do
 War.Person[War.SelID].d=3;
 WarDelay(3);
 War.Person[War.SelID].d=2;
 WarDelay(3);
 War.Person[War.SelID].d=4;
 WarDelay(3);
 War.Person[War.SelID].d=1;
 WarDelay(3);
 end
 PlayWavE(12);
 War.Person[War.SelID].action=6;
 for i=0,256,8 do
 War.Person[War.SelID].effect=i;
 WarDelay(1);
 end
 for i=240,0,-8 do
 War.Person[War.SelID].effect=i;
 WarDelay(1);
 end
JY.Person[pid]["等级"]=JY.Person[pid]["等级"]+1
 WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."的等级提升至".. JY.Person[pid]["等级"],C_WHITE);
 ReSetAttrib(pid,false);
 War.Person[War.SelID].action=oldaction;
 JY.MenuPic.num=MenuPicNum;

JY.Person[pid]["道具"..i]=0
 for n=i,7 do
 JY.Person[pid]["道具"..n]=JY.Person[pid]["道具"..(n+1)];
 end
 JY.Person[pid]["道具8"]=0;

return 1
end

 else
 PlayWavE(2);
 WarDrawStrBoxDelay("没有能使用的道具．",C_WHITE);
 return 0;
 end
end

--交出了．
function Item_Send(i)
 local id=War.SelID;
 local pid=War.Person[id].id;
 local itemid=JY.Person[pid]["道具"..i];
 WarSetAtkFW(War.SelID,21);
 local eid=WarSelectAtk(true,11);
 if eid>0 then
 local EID=War.Person[eid].id;
 if JY.Person[EID]["道具8"]>0 then
 PlayWavE(2);
 WarDrawStrBoxDelay("携带品已经满了，不能再给了．",C_WHITE);
 return 0;
 else
 for n=1,8 do
 if JY.Person[EID]["道具"..n]==0 then
 JY.Person[EID]["道具"..n]=itemid;
 break;
 end
 end
 for n=i,7 do
 JY.Person[pid]["道具"..n]=JY.Person[pid]["道具"..(n+1)];
 end
 JY.Person[pid]["道具8"]=0;
 WarDrawStrBoxWaitKey("交出了"..JY.Item[itemid]["名称"].."．",C_WHITE);
 ReSetAttrib(pid,false);
 ReSetAttrib(EID,false);
 return 1;
 end
 else
 return 0;
 end
end
function Item_Scrap(i)
 local id=War.SelID;
 local pid=War.Person[id].id;
 local itemid=JY.Person[pid]["道具"..i];
 WarDrawStrBoxWaitKey("丢掉了"..JY.Item[itemid]["名称"].."．",C_WHITE);
 for n=i,7 do
 JY.Person[pid]["道具"..n]=JY.Person[pid]["道具"..(n+1)];
 end
 JY.Person[pid]["道具8"]=0;
 ReSetAttrib(id,false);
 return 1;
end
function Item_Check(i)
 local id=War.SelID;
 local pid=War.Person[id].id;
 local itemid=JY.Person[pid]["道具"..i];
 DrawItemStatus(itemid,pid);
 return 0;
end
function WarAutoD(id1,id2)
 local x1,y1=War.Person[id1].x,War.Person[id1].y;
 local x2,y2=War.Person[id2].x,War.Person[id2].y;
 local dx=math.abs(x1-x2);
 local dy=math.abs(y1-y2);
 if dx==0 and dy==0 then
 return War.Person[id1].d,War.Person[id1].d;
 end
 if dy>dx then
 if y1>y2 then
 return 2,1;
 else
 return 1,2;
 end
 else
 if x1>x2 then
 return 3,4;
 else
 return 4,3;
 end
 end
end
----------------------------------------------------------------
-- BZSuper(bz1,bz2)
-- 返回兵种克制关系
-- true 克制 false 不被克制
----------------------------------------------------------------
function BZSuper(bz1,bz2)
 for i=1,9 do
 if JY.Bingzhong[bz1]["克制"..i]==bz2 then
 return true; --bz1 克制 bz2
 end
 end
 return false; --不被克制
end

function WarAtkHurt(pid,eid,flag)
 flag=flag or 0;
 local id1=War.Person[pid].id;
 local id2=War.Person[eid].id;
 local p1=JY.Person[id1];
 local p2=JY.Person[id2];
 --攻击防御
 local atk=p1["攻击"];
 local def=p2["防御"];
 --防御修正，兵种克制
--武器特效和人物特技效果优先于兵种相克
 if CC.Enhancement and (p1["武器"]==10 or WarCheckSkill(pid,110)) then --兵种克制 装备倚天剑后必克制
 def=def*3/4;
 elseif CC.Enhancement and (p2["武器"]==11 or WarCheckSkill(eid,111)) then --兵种被克制 装备青釭剑后不被克制
 def=def*5/4;

 elseif BZSuper(p1["兵种"],p2["兵种"]) then --兵种克制
 def=def*3/4;
 elseif BZSuper(p2["兵种"],p1["兵种"]) then --兵种被克制
 def=def*5/4;
 end
 --地形杀伤修正
 local T={[0]=0,20,30,0,0, --森林　20　山地　30
 0,0,5,5,0, --村庄　 5 草原　 5
 0,0,0,30,10, --鹿寨　30　兵营　10
 0,0,0,0,0,
 0,0,0,0,0,
 0,0,0,0,0}
 local dx=GetWarMap(War.Person[eid].x,War.Person[eid].y,1);
 --基本物理杀伤＝（攻击方攻击力－防御力修正值÷2）×（100－地形杀伤修正）÷100
 local hurt=(atk-def/2);
 if CC.Enhancement then
 hurt=hurt*limitX(100+War.Person[pid].atk_buff-War.Person[eid].def_buff,10,200)/100;
 if WarCheckSkill(eid,23) then --藤甲
 hurt=hurt*(100-JY.Skill[23]["参数1"])/100;
 end
 if WarCheckSkill(eid,47) then --倾国
 hurt=hurt*(100-JY.Skill[47]["参数1"])/100;
 end
 else
 hurt=hurt*(100-T[dx])/100;
 end
 
 if flag==1 then --反击？
 hurt=hurt/2;
 elseif flag==2 then --乱射？
 hurt=hurt/3;
 elseif flag==3 then --连击？
 hurt=hurt*0.8;
 end
 hurt=math.modf(hurt);
 if CC.Enhancement then
 if WarCheckSkill(eid,43) then --狼顾
if hurt>p2["最大兵力"]/5 then
hurt=p2["最大兵力"]/5
end
 end
 end

if CC.Enhancement and WarCheckSkill(eid,104) then --关羽 青龙偃月刀 被攻击时必定格挡
if hurt>p2["最大兵力"]/5 then
hurt=p2["最大兵力"]/5
end
end

if CC.Enhancement and (p1["武器"]==60 or WarCheckSkill(pid,115)) then --霸王之剑 攻击时必定暴击
if WarCheckSkill(eid,23) or WarCheckSkill(eid,43) or WarCheckSkill(eid,47) then --拥有 藤甲 狼顾 倾国 特技时免疫特效
WarDrawStrBoxDelay('暴击特效无法触发',C_WHITE)
else
if hurt<p2["兵力"]*0.4 then
hurt=p2["兵力"]*0.4
end
end
end

 if hurt<atk/20 then
 hurt=math.modf(atk/20);
 end
 --如果攻击伤害<=0，则攻击伤害=1．
 if hurt<1 then
 hurt=1;
 end
 local flag2=0
 if hurt>=p2["最大兵力"]*0.4 then
 flag2=2; --暴击
 elseif hurt>=p2["兵力"]+p2["最大兵力"]/5 then
 flag2=2; --暴击
 elseif hurt<=p2["最大兵力"]/5 then
 flag2=1; --格挡
 end
 -- 如果攻击伤害大于防御方兵力，则攻击伤害=防御方兵力
 if hurt>p2["兵力"] then
 hurt=p2["兵力"];
 end
 --士气降幅＝攻击伤害÷（防御方等级＋5）÷3
 local sq_hurt=math.modf(hurt/(p2["等级"]+5)/3);
 if sq_hurt==0 then
 if hurt>0 then
 sq_hurt=1;
 else
 sq_hurt=0;
 end
 end

if CC.Enhancement and (p1["武器"]==14 or WarCheckSkill(pid,113)) then --三尖刀 攻击时额外减少敌方士气
sq_hurt=sq_hurt+10
end

 sq_hurt=limitX(sq_hurt,0,p2["士气"]);
 --经验值获得
 local jy=0;
 --敌军部队不能获得经验值．
 if p1["等级"]<99 and (not War.Person[pid].enemy) then--and (not War.Person[pid].friend) then
 --经验值由两部分构成：基本经验值和奖励经验值．
 local part1,part2=0,0;
 --当攻击方等级低于等于防御方等级时：
 if p1["等级"]<=p2["等级"] then
 --基本经验值＝（防御方等级－攻击方等级＋3）×2
 part1=(p2["等级"]-p1["等级"]+3)*2
 --如果基本经验值大于16，则基本经验值＝16．
 if part1>16 then
 part1=16;
 end
 --提高获取经验
if CC.Enhancement then
 part1=(p2["等级"]-p1["等级"]+5)*2;
 if part1>24 then
 part1=24;
 end
end
 --当攻击方等级高于防御方等级时：
 else
 --基本经验值＝4
 part1=4;

if CC.Enhancement then
 part1=8; --提高获取经验
end

 end
 --如果杀死敌人，可以获得奖励经验值：
 if hurt==p2["兵力"] then
 --如果杀死敌军主将
 if War.Person[eid].leader then
 --奖励经验值＝48
 part2=48;
 --如果杀死的不是敌军主将，且敌军等级高于我军
 elseif p2["等级"]>p1["等级"] then
 --奖励经验值＝32
 part2=32;
 --如果杀死的不是敌军主将，且敌军等级低于等于我军
 else
 --奖励经验值＝64÷（攻击方等级－防御方等级＋2）
 part2=math.modf(64/(p1["等级"]-p2["等级"]+2));
 --提高获取经验
if CC.Enhancement then
 part2=32-(p1["等级"]-p2["等级"])*4;
 part2=limitX(part2,8,48);
end

 end
 end
 --最终获得的经验值＝基本经验值＋奖励经验值．
 jy=part1+part2;
 end
 
 return hurt,sq_hurt,jy,flag2;
end

function WarAtk(pid,eid,flag)
 flag=flag or 0;
 War.ControlEnableOld=War.ControlEnable;
 War.ControlEnable=false;
 War.InMap=false;
 local hurt,sq_hurt,jy,flag2=WarAtkHurt(pid,eid,flag);
 --flag2 0 普通 1格挡 2暴击
 local id1=War.Person[pid].id;
 local id2=War.Person[eid].id;
 local str;
 if flag==1 then
 str=JY.Person[id1]["姓名"]..'的反击';
 elseif flag==2 then
 str=JY.Person[id1]["姓名"]..'的乱射';
 elseif flag==3 then
 str=JY.Person[id1]["姓名"]..'的连击';
 else
 str=JY.Person[id1]["姓名"]..'的攻击';
 end
 local n=CC.OpearteSpeed;
 local d1,d2=WarAutoD(pid,eid);
 War.Person[pid].d=d1;
 WarDelay();
 if flag2==2 then
 PlayWavE(6);
 WarAtkWords(pid);
 end
 War.Person[pid].action=2;
 War.Person[pid].frame=0;
 WarDelay();
 PlayWavE(War.Person[pid].atkwav);
 for i=1,n*2 do
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 DrawYJZBox2(-256,64,str,C_WHITE);
 ReFresh();
 end
 for i=0,3 do
 War.Person[pid].frame=i;
 if i==0 and flag2==2 then
 PlayWavE(33);
 for t=8,192,8 do
 JY.ReFreshTime=lib.GetTime();
 War.Person[pid].effect=t;
 DrawWarMap();
 DrawYJZBox2(-256,64,str,C_WHITE);
 ReFresh();
 end
 War.Person[pid].effect=0;
 end
 if i==3 then
 War.Person[eid].hurt=hurt;
 War.Person[eid].frame=0;
 War.Person[eid].d=d2;
 if War.Person[eid].troubled then
 PlayWavE(35);
 elseif flag2==1 then
 War.Person[eid].action=3;
 PlayWavE(30);
 elseif flag2==2 then
 War.Person[eid].effect=240;
 War.Person[eid].action=4;
 PlayWavE(36);
 else
 War.Person[eid].effect=240;
 War.Person[eid].action=4;
 PlayWavE(35);
 end
 for t=1,n do
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 DrawYJZBox2(-256,64,str,C_WHITE);
 ReFresh();
 end
 end
 for t=1,n do
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 DrawYJZBox2(-256,64,str,C_WHITE);
 ReFresh();
 end
 end
 War.Person[eid].effect=0;
 for i=1,n*2 do
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 DrawYJZBox2(-256,64,str,C_WHITE);
 ReFresh();
 end
 War.Person[eid].hurt=-1;
 --敌军兵力减少 显示
 local t=16;
 t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/50,math.abs(sq_hurt)))));
 local oldbl=JY.Person[id2]["兵力"];
 local oldsq=JY.Person[id2]["士气"];
 for i=0,t do
 JY.ReFreshTime=lib.GetTime();
 JY.Person[id2]["兵力"]=oldbl-hurt*i/t;
 JY.Person[id2]["士气"]=oldsq-sq_hurt*i/t;
 DrawWarMap();
 DrawStatusMini(eid);
 lib.GetKey();
 ReFresh();
 end
 JY.ReFreshTime=lib.GetTime();
 ReFresh(CC.OpearteSpeed*4);
 WarDelay(4);
 WarGetTrouble(eid);
 --攻心 显示
 if CC.Enhancement then
 if WarCheckSkill(pid,33) then --攻心
 if hurt>0 and JY.Person[id1]["兵力"]<JY.Person[id1]["最大兵力"] then
 local t=16;
 hurt=math.modf(hurt*JY.Skill[33]["参数1"]/100);
 hurt=limitX(hurt,1,JY.Person[id1]["最大兵力"]-JY.Person[id1]["兵力"])
 t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/25))));
 local oldbl=JY.Person[id1]["兵力"];
 for i=0,t do
 JY.ReFreshTime=lib.GetTime();
 JY.Person[id1]["兵力"]=oldbl+hurt*i/t;
 DrawWarMap();
 DrawStatusMini(pid);
 lib.GetKey();
 ReFresh();
 end
 JY.ReFreshTime=lib.GetTime();
 ReFresh(CC.OpearteSpeed*4);
 WarDelay(4);
 end
 end
 end

local flag3=flag2
if flag2==0 then flag3=2 end
if flag2==1 then flag3=1 end
if flag2==2 then flag3=3 end

if CC.Enhancement and JY.Person[id2]["统率"]<100 and (not War.Person[eid].enemy) then
JY.Person[id2]["统率经验"]=JY.Person[id2]["统率经验"]+flag3

if JY.Person[id2]["统率经验"]>=200 then
JY.Person[id2]["统率经验"]=JY.Person[id2]["统率经验"]-200
 local MenuPicNum=JY.MenuPic.num;
 JY.MenuPic.num=0;
 local oldaction=War.Person[eid].action;
 --转圈，升级动作
 War.Person[eid].action=0;
 for t=1,2 do
 War.Person[eid].d=3;
 WarDelay(3);
 War.Person[eid].d=2;
 WarDelay(3);
 War.Person[eid].d=4;
 WarDelay(3);
 War.Person[eid].d=1;
 WarDelay(3);
 end
 PlayWavE(12);
 War.Person[eid].action=6;
 for i=0,256,8 do
 War.Person[eid].effect=i;
 WarDelay(1);
 end
 for i=240,0,-8 do
 War.Person[eid].effect=i;
 WarDelay(1);
 end
 WarDrawStrBoxWaitKey(JY.Person[id2]["姓名"].."成功凝练出一枚统率种",C_WHITE);
 ReSetAttrib(id2,false);
 War.Person[eid].action=oldaction;
 JY.MenuPic.num=MenuPicNum;

for n=1,8 do
if JY.Person[id2]["道具"..n]==0 then
JY.Person[id2]["道具"..n]=73
break
end
end

end
end

 --经验以及升级
 WarAddExp(pid,jy);

if CC.Enhancement and JY.Person[id1]["武力"]<100 and (not War.Person[pid].enemy) then
JY.Person[id1]["武力经验"]=JY.Person[id1]["武力经验"]+flag3

if JY.Person[id1]["武力经验"]>=200 then
JY.Person[id1]["武力经验"]=JY.Person[id1]["武力经验"]-200
 local MenuPicNum=JY.MenuPic.num;
 JY.MenuPic.num=0;
 local oldaction=War.Person[pid].action;
 --转圈，升级动作
 War.Person[pid].action=0;
 for t=1,2 do
 War.Person[pid].d=3;
 WarDelay(3);
 War.Person[pid].d=2;
 WarDelay(3);
 War.Person[pid].d=4;
 WarDelay(3);
 War.Person[pid].d=1;
 WarDelay(3);
 end
 PlayWavE(12);
 War.Person[pid].action=6;
 for i=0,256,8 do
 War.Person[pid].effect=i;
 WarDelay(1);
 end
 for i=240,0,-8 do
 War.Person[pid].effect=i;
 WarDelay(1);
 end
 WarDrawStrBoxWaitKey(JY.Person[id1]["姓名"].."成功凝练出一枚武力种",C_WHITE);
 ReSetAttrib(id1,false);
 War.Person[pid].action=oldaction;
 JY.MenuPic.num=MenuPicNum;

for n=1,8 do
if JY.Person[id1]["道具"..n]==0 then
JY.Person[id1]["道具"..n]=71
break
end
end

end

end

 if War.Person[pid].active then
 War.Person[pid].action=1;
 else
 War.Person[pid].action=0;
 end
 if War.Person[eid].active then
 War.Person[eid].action=1;
 else
 War.Person[eid].action=0;
 end
 ReSetAttrib(id1,false);
 ReSetAttrib(id2,false);
 War.Person[pid].frame=-1;
 War.Person[eid].frame=-1;
 War.ControlEnable=War.ControlEnableOld;

 if CC.Enhancement then
 if War.Person[pid].bz==27 and flag==0 then --舞女可连击
 if JY.Person[id2]["兵力"]>0 then
 WarAtk(pid,eid,3)
 end
 end
 end
end
----------------------------------------------------------------
-- WarAction(kind,id1,id2)
-- 战场上显示各种动作 id一般为人物id
-- kind: 0.转向 id1人物id, id2 方向id 1234下上左右
-- 1.自动转向
-- 3.攻击|无 4.攻击|被击中 5.攻击|防御 6.攻击|攻击
-- 7.暴击|无 8.暴击|被击中 9.暴击|防御 10.暴击|暴击
-- 11.双击|无 12.
-- 15.防御 16.撤退(含防御) 17.败退 18.死亡
-- 19.喘气
----------------------------------------------------------------
function WarAction(kind,id1,id2)
 if JY.Status~=GAME_WMAP and JY.Status~=GAME_WARWIN and JY.Status~=GAME_WARLOSE then
 return;
 end
 local controlstatus=War.ControlEnable;
 War.ControlEnable=false;
 War.InMap=false;
 id1=id1 or 1;
 id2=id2 or id1;
 local pid=GetWarID(id1);
 local eid=GetWarID(id2);
 local n=CC.OpearteSpeed;
 WarPersonCenter(pid);
 if (not War.Person[pid].live) or War.Person[pid].hide then
 
 elseif kind==0 then
 if between(id2,1,4) then
 War.Person[pid].action=0;
 War.Person[pid].frame=0;
 WarDelay(n);
 if War.Person[pid].d~=id2 then
 War.Person[pid].d=id2;
 PlayWavE(6);
 WarDelay(n*2);
 end
 end
 elseif kind==1 then
 local d1,d2=WarAutoD(pid,eid);
 WarAction(0,id1,d1);
 WarAction(0,id2,d2);
 elseif kind==2 then
 
 elseif kind==3 then
 War.Person[pid].action=2;
 War.Person[pid].frame=0;
 PlayWavE(War.Person[pid].atkwav);
 WarDelay(n);
 for i=0,3 do
 War.Person[pid].frame=i;
 if i==3 then
 PlayWavE(7);
 WarDelay(n);
 end
 WarDelay(n);
 end
 War.Person[eid].effect=0;
 WarDelay(n*2);
 elseif kind==4 then
 local d1,d2=WarAutoD(pid,eid);
 --War.Person[pid].d=d1;
 WarAction(0,id1,d1);
 War.Person[pid].action=2;
 War.Person[pid].frame=0;
 PlayWavE(War.Person[pid].atkwav);
 WarDelay(n);
 for i=0,3 do
 War.Person[pid].frame=i;
 if i==3 then
 War.Person[eid].frame=0;
 War.Person[eid].d=d2;
 War.Person[eid].effect=240;
 War.Person[eid].action=4;
 PlayWavE(35);
 WarDelay(n);
 end
 WarDelay(n);
 end
 War.Person[eid].effect=0;
 WarDelay(n*2);
 elseif kind==5 then
 local d1,d2=WarAutoD(pid,eid);
 --War.Person[pid].d=d1;
 WarAction(0,id1,d1);
 War.Person[pid].action=2;
 War.Person[pid].frame=0;
 PlayWavE(War.Person[pid].atkwav);
 for t=1,n do
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 ReFresh();
 end
 lib.GetKey();
 for i=0,3 do
 War.Person[pid].frame=i;
 if i==3 then
 War.Person[eid].frame=0;
 War.Person[eid].d=d2;
 War.Person[eid].action=3;
 PlayWavE(30);
 WarDelay(n);
 end
 WarDelay(n);
 end
 War.Person[eid].effect=0;
 WarDelay(n*2);
 elseif kind==6 then
 WarAction(1,id1,id2);
 War.Person[pid].action=2;
 War.Person[eid].action=2;
 for i=0,3 do
 War.Person[pid].frame=i;
 War.Person[eid].frame=i;
 if i==3 then
 PlayWavE(30);
 WarDelay(n);
 end
 WarDelay(n);
 end
 WarDelay(n*2);
 elseif kind==7 then
 War.Person[pid].action=2;
 War.Person[pid].frame=0;
 PlayWavE(War.Person[pid].atkwav);
 WarDelay(n);
 for i=0,3 do
 War.Person[pid].frame=i;
 if i==0 then
 PlayWavE(33);
 for t=8,192,8 do
 War.Person[pid].effect=t;
 WarDelay(1);
 end
 War.Person[pid].effect=0;
 end
 if i==3 then
 PlayWavE(7);
 WarDelay(n);
 end
 WarDelay(n);
 end
 War.Person[eid].effect=0;
 WarDelay(n*2);
 elseif kind==8 then
 local d1,d2=WarAutoD(pid,eid);
 WarAction(0,id1,d1);
 --War.Person[pid].d=d1;
 War.Person[pid].action=2;
 War.Person[pid].frame=0;
 PlayWavE(War.Person[pid].atkwav);
 WarDelay(n);
 for i=0,3 do
 War.Person[pid].frame=i;
 if i==0 then
 PlayWavE(33);
 for t=8,192,8 do
 War.Person[pid].effect=t;
 WarDelay(1);
 end
 War.Person[pid].effect=0;
 end
 if i==3 then
 War.Person[eid].frame=0;
 War.Person[eid].d=d2;
 War.Person[eid].effect=240;
 War.Person[eid].action=4;
 PlayWavE(36);
 WarDelay(n);
 end
 WarDelay(n);
 end
 War.Person[eid].effect=0;
 WarDelay(n*2);
 elseif kind==9 then
 local d1,d2=WarAutoD(pid,eid);
 WarAction(0,id1,d1);
 --War.Person[pid].d=d1;
 War.Person[pid].action=2;
 War.Person[pid].frame=0;
 PlayWavE(War.Person[pid].atkwav);
 WarDelay(n);
 lib.GetKey();
 for i=0,3 do
 War.Person[pid].frame=i;
 if i==0 then
 PlayWavE(33);
 for t=8,192,8 do
 War.Person[pid].effect=t;
 WarDelay(1);
 end
 lib.GetKey();
 War.Person[pid].effect=0;
 end
 if i==3 then
 War.Person[eid].frame=0;
 War.Person[eid].d=d2;
 War.Person[eid].action=3;
 War.Person[eid].effect=256;
 PlayWavE(31);
 WarDelay(n);
 end
 War.Person[eid].effect=0;
 WarDelay(n);
 end
 War.Person[eid].effect=0;
 WarDelay(n*2);
 lib.GetKey();
 elseif kind==10 then
 WarAction(1,id1,id2);
 War.Person[pid].action=2;
 War.Person[eid].action=2;
 for i=0,3 do
 War.Person[pid].frame=i;
 War.Person[eid].frame=i;
 if i==0 then
 PlayWavE(33);
 for t=8,192,8 do
 War.Person[pid].effect=t;
 War.Person[eid].effect=t;
 WarDelay(1);
 end
 lib.GetKey();
 War.Person[pid].effect=0;
 War.Person[eid].effect=0;
 end
 if i==3 then
 War.Person[pid].effect=192;
 War.Person[eid].effect=192;
 PlayWavE(31);
 WarDelay(n);
 end
 WarDelay(n);
 end
 War.Person[pid].effect=0;
 War.Person[eid].effect=0;
 WarDelay(n*2);
 elseif kind==11 then
 
 elseif kind==12 then
 
 elseif kind==13 then
 
 elseif kind==14 then
 
 elseif kind==15 then
 War.Person[pid].action=3;
 War.Person[pid].frame=0;
 WarDelay(n*2);
 elseif kind==16 then
 War.Person[pid].action=0;
 War.Person[pid].frame=0;
 WarDelay(n);
 War.Person[pid].d=1;
 PlayWavE(6);
 WarDelay(n*2);
 War.Person[pid].action=3;
 War.Person[pid].frame=0;
 WarDelay(n*2);
 PlayWavE(17);
 for t=0,-256,-8 do
 War.Person[pid].effect=t;
 WarDelay(1);
 end
 WarDelay(n*2);
 War.Person[pid].action=9;
 War.Person[pid].live=false;
 SetWarMap(War.Person[pid].x,War.Person[pid].y,2,0);
 WarDelay(n*4);
 --WarDrawStrBoxDelay(JY.Person[War.Person[pid].id]["姓名"].."撤退了！",C_WHITE);
 if War.Person[pid].enemy then
 War.EnemyNum=War.EnemyNum-1;
 end
 elseif kind==17 then
 War.Person[pid].action=5;
 WarDelay(n);
 for i=1,5 do
 War.Person[pid].frame=0;
 if War.Person[pid].action==9 then
 War.Person[pid].action=5;
 PlayWavE(16);
 else
 War.Person[pid].action=9;
 end
 WarDelay(n);
 end
 War.Person[pid].frame=-1;
 War.Person[pid].action=9;
 War.Person[pid].live=false;
 SetWarMap(War.Person[pid].x,War.Person[pid].y,2,0);
 WarDelay(n*2);
 WarDrawStrBoxDelay(JY.Person[War.Person[pid].id]["姓名"].."撤退了！",C_WHITE);
 if War.Person[pid].enemy then
 War.EnemyNum=War.EnemyNum-1;
 end
 elseif kind==18 then
 War.Person[pid].frame=0;
 War.Person[pid].action=5;
 for i=1,6 do
 if War.Person[pid].action==9 then
 War.Person[pid].action=5;
 else
 War.Person[pid].action=9;
 end

 WarDelay(n-1);
 lib.GetKey();
 end
 for i=1,16 do
 if War.Person[pid].action==9 then
 War.Person[pid].action=5;
 else
 War.Person[pid].action=9;
 end
 WarDelay(n-2);
 lib.GetKey();
 end
 PlayWavE(22);
 War.Person[pid].action=5;
 for i=128,256,12 do
 War.Person[pid].effect=i
 WarDelay(n);
 end
 WarDelay(n*2);
 War.Person[pid].frame=-1;
 War.Person[pid].action=9;
 War.Person[pid].live=false;
 SetWarMap(War.Person[pid].x,War.Person[pid].y,2,0);
 WarDelay(n*4);
 WarDrawStrBoxDelay(JY.Person[War.Person[pid].id]["姓名"].."阵亡了！",C_WHITE);
 if War.Person[pid].enemy then
 War.EnemyNum=War.EnemyNum-1;
 end
 elseif kind==19 then
 War.Person[pid].action=5;
 War.Person[pid].frame=0;
 for i=0,5 do
 War.Person[pid].frame=1-War.Person[pid].frame;
 WarDelay(n*2);
 end
 WarDelay(n*2);
 end
 WarResetStatus(pid);
 WarResetStatus(eid);
 War.ControlEnable=controlstatus;
end

----------------------------------------------------------------
-- WarLastWords(wid)
-- 战场人物遗言
----------------------------------------------------------------
function WarLastWords(wid)
 local wp=War.Person[wid];
 local name=JY.Person[wp.id]["姓名"];
 if true then--not wp.enemy then
 if type(CC.LastWords[name])=='string' then
 if wp.id==1 then
 PlayBGM(4);
 end
if CC.zdsh==0 or wp.id==1 then
 talk( wp.id,CC.LastWords[name]);
end
 end
 end
end
----------------------------------------------------------------
-- WarAtkWords(wid)
-- 战场人物暴击台词
----------------------------------------------------------------
function WarAtkWords(wid)
 local wp=War.Person[wid];
 local name=JY.Person[wp.id]["姓名"];
 if CC.zdsh==0 then--not wp.enemy then
 if type(CC.AtkWords[name])=='string' then
 talk( wp.id,CC.AtkWords[name]);
 else
 local str={
 "喔喔喔……！", "哈啊啊……！", "呀啊啊……！", "喝……！", "唔喔喔……！",
 "杀啊啊……！", "看招啊……！", "吃我一记！！", "杀……！", "去死吧！！！",
 "唷呵……！", "呀呔……！", "嗯嗯嗯……！", "唔唔唔……！", "呼呼呼……！",
 "嗯嗯！？", "哼！！", "嗯嗯嗯！", "讨厌！！", "哎呀！！",
 "………………。", "…………！", "准备接招吧！！", "准备受死吧！", "着！！"
 }
 local n=math.random(40);
 if type(str[n])=='string' then
 talk( wp.id,str[n]);
 end
 end
 end
end
----------------------------------------------------------------
-- WarResetStatus(wid)
-- 用于各种行动后，使战场人物动作回复默认状态
----------------------------------------------------------------
function WarResetStatus(wid)
 if between(wid,1,War.PersonNum) then
 local v=War.Person[wid];
 v.frame=-1;
 if v.live then
 local id=v.id;
 if JY.Person[id]["兵力"]<=0 then
 if v.action~=9 then
 v.action=5;
 WarDelay(4);
 JY.Death=id;
 DoEvent(JY.EventID);
 JY.Death=0;
 if v.action~=9 then
 WarLastWords(wid);
 if id==1 then
 WarAction(18,id);
 else
 WarAction(17,id);
 end
 end
 end
 elseif v.troubled then
 v.action=7;
 elseif JY.Person[id]["兵力"]/JY.Person[id]["最大兵力"]<=0.30 then
 v.action=5;
 elseif v.active then
 v.action=1;
 else
 v.action=0;
 end
 if v.ai==6 then
 if v.x==v.ai_dx and v.y==v.ai_dy then
 v.ai=4;
 end
 end
 if CC.Enhancement then
 ReSetAttrib(id,false); 
 end
 end
 end
 ReSetAllBuff();
end

--获得经验值
function WarAddExp(id,Exp)
 if Exp<=0 then
 return;
 end
 local pid=War.Person[id].id;
 if JY.Person[pid]["等级"]>=99 then
 return;
 end
 local oldExp=JY.Person[pid]["经验"];
local lvupflag=false;

 for i=0,Exp do
 JY.Person[pid]["经验"]=oldExp+i;

 for t=1,1 do
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 DrawStatusMini(id,true);
 lib.GetKey();
 ReFresh();
 end

 if JY.Person[pid]["经验"]==100 then
 lvupflag=true;
 WarLvUp(id);
JY.Person[pid]["经验"]=0
oldExp=JY.Person[pid]["经验"]
 end

 end

 JY.ReFreshTime=lib.GetTime();
 ReFresh(CC.OpearteSpeed*3);
 WarDelay(4);
 
 JY.Person[pid]["经验"]=oldExp+Exp;
end

function WarAddExp2(id,Exp)--经验以及升级，但是无任何显示
end

function WarLvUp(id)--升级，以及动画
 if id==0 then
 return;
 end
 War.SelID=id;
 BoxBack();
 local pid=War.Person[id].id;
 War.Person[id].action=0;
 for t=1,2 do
 War.Person[id].d=3;
 WarDelay(3);
 War.Person[id].d=2;
 WarDelay(3);
 War.Person[id].d=4;
 WarDelay(3);
 War.Person[id].d=1;
 WarDelay(3);
 end
 PlayWavE(11);
 War.Person[id].action=6;
 WarDelay(16);
 WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."的等级上升了！",C_WHITE);
 local magic={};
 for mid=1,JY.MagicNum-1 do
 magic[mid]=false;
 if WarHaveMagic(id,mid) then
 magic[mid]=true;
 end
 end
 JY.Person[pid]["等级"]=limitX(JY.Person[pid]["等级"]+1,1,99);
 ReSetAttrib(pid,false);
 WarResetStatus(id);
 WarDelay(4);
 --提示技能策略习得
 for i=1,6 do
 if JY.Person[pid]["等级"]==CC.SkillExp[JY.Person[pid]["成长"]][i] then
 PlayWavE(11);
 WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."习得技能"..JY.Skill[JY.Person[pid]["特技"..i]]["名称"].."！",C_WHITE);
 break;
 end
 end
 local str="";
 for mid=1,JY.MagicNum-1 do
 if not magic[mid] then
 if WarHaveMagic(id,mid) then
 if str=="" then
 str=JY.Magic[mid]["名称"];
 else
 str=str.."、"..JY.Magic[mid]["名称"];
 end
 end
 end
 end
 if #str>0 then
 PlayWavE(11);
 WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."习得策略"..str.."！",C_WHITE);
 end
 War.LastID=War.SelID;
 War.SelID=0;
end

function WarBingZhongUp(id,bzid)--兵种变更，动画
 if id==0 then
 return;
 end
 local MenuPicNum=JY.MenuPic.num;
 JY.MenuPic.num=0;
 local pid=War.Person[id].id;
 local oldaction=War.Person[id].action;
 --使用物品动作
 War.Person[id].action=0;
 War.Person[id].d=1;
 WarDelay(2);
 PlayWavE(41);
 War.Person[id].action=6;
 WarDelay(16);
 --转圈，升级动作
 War.Person[id].action=0;
 for t=1,2 do
 War.Person[id].d=3;
 WarDelay(3);
 War.Person[id].d=2;
 WarDelay(3);
 War.Person[id].d=4;
 WarDelay(3);
 War.Person[id].d=1;
 WarDelay(3);
 end
 PlayWavE(12);
 War.Person[id].action=6;
 for i=0,256,8 do
 War.Person[id].effect=i;
 WarDelay(1);
 end
 JY.Person[pid]["兵种"]=bzid;
 War.Person[id].bz=bzid;
 War.Person[id].movewav=JY.Bingzhong[bzid]["音效"]; --移动音效
 War.Person[id].atkwav=JY.Bingzhong[bzid]["攻击音效"]; --攻击音效
 War.Person[id].movestep=JY.Bingzhong[bzid]["移动"]; --移动范围
 War.Person[id].movespeed=JY.Bingzhong[bzid]["移动速度"]; --移动速度
 War.Person[id].atkfw=JY.Bingzhong[bzid]["攻击范围"]; --攻击范围
 War.Person[id].pic=WarGetPic(id);
 for i=240,0,-8 do
 War.Person[id].effect=i;
 WarDelay(1);
 end
 WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."的兵种成为"..JY.Bingzhong[bzid]["名称"].."了！",C_WHITE);
 ReSetAttrib(pid,false);
 War.Person[id].action=oldaction;
 JY.MenuPic.num=MenuPicNum;

for n=1,8 do
if JY.Person[pid]["道具"..n]==0 then
JY.Person[pid]["道具"..n]=173
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."得到一枚经验种",C_WHITE)
break
end
end

end

--
function limitX(x,minv,maxv) --限制x的范围
 if x<minv then
 x=minv;
 elseif x>maxv then
 x=maxv;
 end
 return x
end
function SetWarConst()
 War.DX={[0]="平原","森林","山地","河流","桥梁",
 "城墙","城池","草原","村庄","悬崖",
 "城门","荒地","栅栏","鹿砦","兵营",
 "粮仓","宝物库","房舍","火焰","浊流"}
 -- 00 平原 01 森林 02 山地 03 河流 04 桥梁 05 城墙 06 城池 07 草原
 -- 08 村庄 09 悬崖 0A 城门 0B 荒地 0C 栅栏 0D 鹿砦 0E 兵营 0F 粮仓
 -- 10 宝物库 11 房舍 12 火焰 13 浊流
 War.Width=64; --地图尺寸
 War.Depth=64;
 War.MW=12; --old game 13
 War.MD=9; --old game 11
 War.BoxWidth=48; --地图方格尺寸
 War.BoxDepth=48;
 War.CX=1; --左上角方格位置
 War.CY=1;
 War.MX=1; --方格所在位置
 War.MY=1;
 War.OldX=0; --记录人物移动前坐标
 War.OldY=0;
 War.InMap=false; --标记鼠标是否在地图范围内
 War.OldMX=-1; --记录MXMY for 鼠标操作 移动窗口用
 War.OldMY=-1;
 War.DXpic=0; --记录当前地形图片
 War.FrameT=0;
 War.Frame=0;
 War.MoveScreenFrame=0;
 War.ControlStatus="select"
 War.PersonNum=0;
 War.Weather=math.random(6)-1;
 War.Turn=1; --当前回合
 War.MaxTurn=30; --最大回合
 War.Leader1=-1;
 War.Leader2=-1;
 War.CurID=0;
 War.SelID=0;
 War.LastID=0; --就是CurID，当移动到非人物时，保持上一个人物ID
 War.EnemyNum=0;
 War.FunButtom=0; --当前所处于的按钮
 War.ControlEnableOld=true;
 War.ControlEnable=true;
War.YD=0
end
----------------------------------------------------------------
-- DrawWarMap()
-- 显示战场地图
----------------------------------------------------------------
function DrawWarMap()
 local x,y=War.CX,War.CY;
 lib.FillColor(0,0,0,0,0);
 local x0,y0=x,y;
 local cx,cy=16,32
 x0=limitX(x0,0,War.Width);
 y0=limitX(y0,0,War.Depth);
 local xoff=x-math.modf(x);
 local yoff=y-math.modf(y);
 lib.SetClip(cx,cy,cx+War.BoxWidth*War.MW,cy+War.BoxDepth*War.MD);
 lib.PicLoadCache(0,War.MapID*2,cx-War.BoxWidth*(x-1),cy-War.BoxDepth*(y-1),1);
 lib.SetClip(0,0,0,0);

 for i=x,x+War.MW-1 do
 for j=y,y+War.MD-1 do
 local v=GetWarMap(i,j,1);
 if v==18 then
 lib.PicLoadCache(4,(250+War.Frame%2)*2,cx+War.BoxWidth*(i-x),cy+War.BoxDepth*(j-y),1);
 elseif v==19 then
 lib.PicLoadCache(4,(252+War.Frame%2)*2,cx+War.BoxWidth*(i-x),cy+War.BoxDepth*(j-y),1);
 end
 end
 end
 
 for x=War.CX,math.min(War.CX+War.MW,War.Width) do
 for y=War.CY,math.min(War.CY+War.MD,War.Depth) do
 if GetWarMap(x,y,4)==0 then --不可移动
 lib.Background(cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),cx+War.BoxWidth*(x-War.CX+1),cy+War.BoxDepth*(y-War.CY+1),128);
 end
 if GetWarMap(x,y,10)==1 then --攻击范围
 lib.PicLoadCache(4,261*2,cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),1);
 elseif GetWarMap(x,y,10)==2 then --治疗范围
 lib.PicLoadCache(4,262*2,cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),1);
 end
 end
 end
 
 if War.InMap then
 DrawGameBox(cx+War.BoxWidth*(War.MX-War.CX),cy+War.BoxDepth*(War.MY-War.CY),cx+War.BoxWidth*(War.MX-War.CX+1),cy+War.BoxDepth*(War.MY-War.CY+1),C_WHITE,-1);
 end
 local size=48;
 local size2=64;
 for i,v in pairs(War.Person) do
 if v.live and (not v.hide) then
 if between(v.x,x,x+War.MW-1) and between(v.y,y,y+War.MD-1) then--limit XY
 local frame;
 if v.frame>=0 then
 frame=v.frame;
 else
 frame=War.Frame;
 end
 local left=cx+War.BoxWidth*(v.x-x);
 local top=cy+War.BoxDepth*(v.y-y);
 --0静止 1移动 2攻击 3防御 4被攻击 5喘气 7混乱 9不存在
 --v.action=7 测试混乱图片用
 if v.action==0 then
 if v.effect==0 then
 lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1);
 if not v.active then
 lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1+2+4,128);
 end
 elseif v.effect>0 then
 lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1);
 lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1+2+8,v.effect);
 elseif v.effect<0 then
 lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1+2,256+v.effect);
 end
 elseif v.action==1 then
 if v.effect==0 then
 lib.PicLoadCache(1,(v.pic+frame%2+(v.d-1)*4)*2,left,top,1);
 elseif v.effect>0 then
 lib.PicLoadCache(1,(v.pic+frame%2+(v.d-1)*4)*2,left,top,1);
 lib.PicLoadCache(1,(v.pic+frame%2+(v.d-1)*4)*2,left,top,1+2+8,v.effect);
 elseif v.effect<0 then
 lib.PicLoadCache(1,(v.pic+frame%2+(v.d-1)*4)*2,left,top,1+2,256+v.effect);
 end
 elseif v.action==2 then
 if v.effect==0 then
 lib.PicLoadCache(1,(v.pic+30+frame+4*(v.d-1))*2,left+(size-size2)/2,top+(size-size2)/2,1);
 elseif v.effect>0 then
 lib.PicLoadCache(1,(v.pic+30+frame+4*(v.d-1))*2,left+(size-size2)/2,top+(size-size2)/2,1);
 lib.PicLoadCache(1,(v.pic+30+frame+4*(v.d-1))*2,left+(size-size2)/2,top+(size-size2)/2,1+2+8,v.effect); 
 elseif v.effect<0 then
 lib.PicLoadCache(1,(v.pic+30+frame+4*(v.d-1))*2,left+(size-size2)/2,top+(size-size2)/2,1+2,256+v.effect); 
 end
 elseif v.action==3 then
 if v.effect==0 then
 lib.PicLoadCache(1,(v.pic+22+(v.d-1))*2,left,top,1);
 elseif v.effect>0 then
 lib.PicLoadCache(1,(v.pic+22+(v.d-1))*2,left,top,1);
 lib.PicLoadCache(1,(v.pic+22+(v.d-1))*2,left,top,1+2+8,v.effect);
 elseif v.effect<0 then
 lib.PicLoadCache(1,(v.pic+22+(v.d-1))*2,left,top,1+2,256+v.effect);
 end
 elseif v.action==4 then
 if v.effect==0 then
 lib.PicLoadCache(1,(v.pic+26+(v.d-1)%2)*2,left,top,1);
 elseif v.effect>0 then
 lib.PicLoadCache(1,(v.pic+26+(v.d-1)%2)*2,left,top,1);
 lib.PicLoadCache(1,(v.pic+26+(v.d-1)%2)*2,left,top,1+2+8,v.effect);
 elseif v.effect<0 then
 lib.PicLoadCache(1,(v.pic+26+(v.d-1)%2)*2,left,top,1+2,256+v.effect);
 end
 elseif v.action==5 then
 if v.effect==0 then
 if v.active then
 lib.PicLoadCache(1,(v.pic+20+frame%2)*2,left,top,1);
 else
 lib.PicLoadCache(1,(v.pic+20)*2,left,top,1);
 lib.PicLoadCache(1,(v.pic+20)*2,left,top,1+2+4,128);
 end
 elseif v.effect>0 then
 lib.PicLoadCache(1,(v.pic+20+frame%2)*2,left,top,1);
 lib.PicLoadCache(1,(v.pic+20+frame%2)*2,left,top,1+2+8,v.effect);
 elseif v.effect<0 then
 lib.PicLoadCache(1,(v.pic+20+frame%2)*2,left,top,1+2,256+v.effect);
 end
 elseif v.action==6 then
 if v.effect==0 then
 lib.PicLoadCache(1,(v.pic+28)*2,left,top,1);
 elseif v.effect>0 then
 lib.PicLoadCache(1,(v.pic+28)*2,left,top,1);
 lib.PicLoadCache(1,(v.pic+28)*2,left,top,1+2+8,v.effect);
 elseif v.effect<0 then
 lib.PicLoadCache(1,(v.pic+28)*2,left,top,1+2,256+v.effect);
 end
 elseif v.action==7 then --混乱
 local hlpic=5010;
 if v.enemy then
 hlpic=5012;
 elseif v.friend then
 hlpic=5014;
 else
 hlpic=5010;
 end
 lib.PicLoadCache(1,(hlpic+frame%2)*2,left,top,1);
 end
 if v.hurt>=0 then
 DrawString(left+size/2-#(v.hurt.."")*5,top,v.hurt,C_WHITE,20);
 end
 
 end
 end
 end

 if War.InMap then
 if War.CY>1 and between(War.MX-War.CX,1,War.MW-2) and War.MY==War.CY then
 lib.PicLoadCache(4,240*2,16+War.BoxWidth*(War.MX-War.CX)+13,32+War.BoxDepth*(War.MY-War.CY)+12,1);
 elseif War.CY<War.Depth-War.MD+1 and between(War.MX-War.CX,1,War.MW-2) and War.MY==War.CY+War.MD-1 then
 lib.PicLoadCache(4,244*2,16+War.BoxWidth*(War.MX-War.CX)+13,32+War.BoxDepth*(War.MY-War.CY)+12,1);
 elseif War.CX>1 and between(War.MY-War.CY,1,War.MD-2) and War.MX==War.CX then
 lib.PicLoadCache(4,246*2,16+War.BoxWidth*(War.MX-War.CX)+12,32+War.BoxDepth*(War.MY-War.CY)+13,1);
 elseif War.CX<War.Width-War.MW+1 and between(War.MY-War.CY,1,War.MD-2) and War.MX==War.CX+War.MW-1 then
 lib.PicLoadCache(4,242*2,16+War.BoxWidth*(War.MX-War.CX)+12,32+War.BoxDepth*(War.MY-War.CY)+13,1);
 end
 end

 if War.ControlStatus=="select" then
 if War.ControlEnable and War.CurID>0 then
--if War.CurID>0 then
 DrawStatusMini(War.CurID)
 end

--标记
elseif War.ControlStatus=="selectAtk" then
if War.ControlEnable then
local eid=GetWarMap(War.MX,War.MY,2);
if eid>0 then
DrawStatusMini(eid)
end
end

 elseif War.ControlStatus=="checkDX" then
 local menux,menuy;
 local dx=GetWarMap(War.MX,War.MY,1);

 if War.MX-War.CX>math.modf(War.MW/2) then
 menux=16+War.BoxWidth*(War.MX-War.CX)-136;
 else
 menux=16+War.BoxWidth*(War.MX-War.CX+1);
 end

 if War.MY-War.CY>math.modf(War.MD/2) then
 menuy=32+War.BoxWidth*(War.MY-War.CY)-40;
 else
 menuy=32+War.BoxWidth*(War.MY-War.CY);
 end

 lib.Background(menux,menuy,menux+136,menuy+86,160);
 menux=menux+8;
 menuy=menuy+8;
 lib.LoadSur(War.DXpic,menux,menuy);
 DrawString(menux+56,menuy+8,"防御效果",C_WHITE,16);
 local T={[0]="０％","２０％","３０％","－％","０％","－％","０％","５％",
 "５％","－％","－％","０％","－％","３０％","１０％","０％",
 "０％","－％","－％","－％",}
 DrawString(menux+88-#T[dx]*4,menuy+32,T[dx],C_WHITE,16);
--森林 20 山地 30 村庄 5
--草原 5 鹿寨 30 兵营 10
 -- 00 平原 01 森林 02 山地 03 河流 04 桥梁 05 城墙 06 城池 07 草原
 -- 08 村庄 09 悬崖 0A 城门 0B 荒地 0C 栅栏 0D 鹿砦 0E 兵营 0F 粮仓
 -- 10 宝物库 11 房舍 12 火焰 13 浊流
 DrawString(menux,menuy+56,War.DX[dx],C_WHITE,16);

 if dx==8 or dx==13 or dx==14 then
 DrawString(menux+56,menuy+56,"有恢复",C_WHITE,16);
 end

 --村庄、鹿砦可以恢复士气和兵力．兵营可以恢复兵力，但不能恢复士气．
 --玉玺可以恢复兵力和士气，援军报告可以恢复兵力，赦命书可以恢复士气．
 --地形和宝物的恢复能力不能叠加，也就是说，处于村庄地形上再持有恢复性宝物，与没有持有恢复性宝物效果相同．但如果地形只能恢复兵力（如兵营），但宝物可以恢复兵力，这种情况下，兵力士气都能得到自动恢复．
 end

 --Status
 --lib.SetClip(0,0,0,0);
 if CC.Enhancement then
 lib.PicLoadCache(4,205*2,0,0,1);
 else
 lib.PicLoadCache(4,205*2,0,0,1);
 end
 DrawString(381-#War.WarName*16/2/2,8,War.WarName,C_WHITE,16);
 --weather
 if War.Weather<3 then --晴
 lib.PicLoadCache(4,190*2,724,35,1);
 elseif War.Weather>3 then --雨
 lib.PicLoadCache(4,192*2,724,35,1);
 else --云
 lib.PicLoadCache(4,191*2,724,35,1);
 end
 if War.ControlStatus=="select" then
 if War.FunButtom==1 then
 lib.PicLoadCache(4,57*2,15,7,1);
 end
 end
 --lib.SetClip(0+War.BoxWidth*War.MW,0,CC.ScreenW,CC.ScreenH);
 DrawStatus();
 --minimap
 --lib.PicLoadCache(0,200+War.MapID*2,888,460+24);
 lib.PicLoadCache(0,200+War.MapID*2,War.MiniMapCX,War.MiniMapCY,1);
 for i=1,War.Width do
 for j=1,War.Depth do
 if GetWarMap(i,j,9)~=0 then
 local x=War.MiniMapCX+(i-1)*4;
 local y=War.MiniMapCY+(j-1)*4;
 lib.FillColor(x,y,x+4,y+4,M_DarkOrchid);
 end
 end
 end
 for i,v in pairs(War.Person) do
 if v.live and (not v.hide) then
 local color=M_Blue;
 if v.enemy then
 color=M_Red;
 elseif v.friend then
 color=M_DarkOrange;
 end
 local x=War.MiniMapCX+(v.x-1)*4;
 local y=War.MiniMapCY+(v.y-1)*4;
 lib.FillColor(x,y,x+4,y+4,color);
 end
 end
 lib.DrawRect(War.MiniMapCX+(War.CX-1)*4,War.MiniMapCY+(War.CY-1)*4,War.MiniMapCX+(War.CX+War.MW-1)*4,War.MiniMapCY+(War.CY+War.MD-1)*4,M_Yellow);
 --lib.SetClip(0,0,0,0);
 
 for i=1,JY.MenuPic.num do
 lib.LoadSur(JY.MenuPic.pic[i],JY.MenuPic.x[i],JY.MenuPic.y[i]);
 end
 
 War.FrameT=War.FrameT+1;
 if War.FrameT>=32 then
 War.FrameT=0;
 end
 War.Frame=math.modf(War.FrameT/8);
end

function DrawStatusMini(id,flag)
 flag=flag or false;
 local pid=War.Person[id].id;
 local x,y=War.Person[id].x,War.Person[id].y
 local bz=JY.Person[pid]["兵种"];
 local menux,menuy;
 if x-War.CX>math.modf(War.MW/2) then
 menux=16+War.BoxWidth*(x-War.CX)-180;
 else
 menux=16+War.BoxWidth*(x-War.CX+1);
 end
 if y-War.CY>math.modf(War.MD/2) then
 menuy=32+War.BoxWidth*(y-War.CY)-32;
 else
 menuy=32+War.BoxWidth*(y-War.CY);
 end
 lib.Background(menux,menuy,menux+180,menuy+80,160);
 menux=menux+2;
 menuy=menuy+2;
 local color=M_Cyan;
 local str="我军";
 if War.Person[id].enemy then
 color=M_Red;
 str="敌军";
 elseif War.Person[id].friend then
 color=M_DarkOrange;
 str="友军";
 end
 if War.Person[id].troubled then
 end
 DrawString(menux,menuy,JY.Person[pid]["姓名"],color,16);
 DrawString(menux+64,menuy,JY.Bingzhong[bz]["名称"].."　Lv"..JY.Person[pid]["等级"],C_WHITE,16);

 local len=120;
 local T={
 100*JY.Person[pid]["兵力"]/JY.Person[pid]["最大兵力"],
 --100*JY.Person[pid]["策略"]/JY.Person[pid]["最大策略"],
 math.min(100*JY.Person[pid]["士气"]/100,100),
 100*JY.Person[pid]["经验"]/100,
 }
 local n=2;
 if flag then
 n=3;
 end
 for i=1,n do
 local color;
 if T[i]<30 then
 color=210;
 elseif T[i]<70 then
 color=211;
 else
 color=212;
 end
 lib.FillColor(menux+48,menuy+4+i*20,menux+48+len,menuy+4+10+i*20,C_BLACK);
 lib.SetClip(menux+48,menuy+4+i*20,menux+48+len*T[i]/100,menuy+4+10+i*20);
 lib.PicLoadCache(4,color*2,menux+48,menuy+4+i*20,1);
 lib.SetClip(0,0,0,0);
 end
 menuy=menuy+20;
 DrawString(menux,menuy,string.format("兵力　　 %4d/%d",JY.Person[pid]["兵力"],JY.Person[pid]["最大兵力"]),C_WHITE,16);
 menuy=menuy+20;
 DrawString(menux,menuy,string.format("士气　　 %4d/100",JY.Person[pid]["士气"]),C_WHITE,16);
 --DrawString(menux,menuy,string.format("策略 %4d/%d",JY.Person[pid]["策略"],JY.Person[pid]["最大策略"]),C_WHITE,16);
 menuy=menuy+20;
 if flag then
 DrawString(menux,menuy,string.format("经验　　 %4d/100",JY.Person[pid]["经验"]),C_WHITE,16);
 else
 local T={[0]="","＋２０％","＋３０％","","","","","＋５％",
 "＋５％","","","","","＋３０％","＋１０％","",
 "","","","",}
 local dx=GetWarMap(x,y,1);
 DrawString(menux,menuy,string.format("%s %s %s",str,War.DX[dx],T[dx]),C_WHITE,16);
 end
end
--旧风格
function DrawStatus()
 local id;
 if War.SelID>0 then
 id=War.SelID;
 elseif War.CurID>0 then
 id=War.CurID;
 elseif War.LastID>0 then
 id=War.LastID;
 else
 return;
 end
 local pid=War.Person[id].id;
 local p=JY.Person[pid];
 local x=805;
 local y=140;
 local size=16;
 local len=100;
 local T={
 {"兵 力","士气值","攻击力","防御力","策略值","经验值"},
 {100*p["兵力"]/p["最大兵力"],p["士气"],math.min(p["攻击"]/20,100),math.min(p["防御"]/20,100),100*p["策略"]/p["最大策略"],p["经验"]},
 {p["兵力"].."/"..p["最大兵力"],""..p["士气"],""..p["攻击"],""..p["防御"],p["策略"].."/"..p["最大策略"],""..p["经验"]},
 }
 local x_off=x-785;
 DrawString(785+x_off,78,p["姓名"].."　"..JY.Bingzhong[p["兵种"]]["名称"],C_WHITE,size);
 DrawString(900+x_off,78,"等级"..p["等级"],C_WHITE,size);
 DrawString(820+x_off,105,p["武力"],C_WHITE,size);
 DrawString(875+x_off,105,p["智力"],C_WHITE,size);
 DrawString(930+x_off,105,p["统率"],C_WHITE,size);
 for i=1,6 do
 DrawString(x,y,T[1][i],C_WHITE,size);
 local color;
 if T[2][i]<30 then
 color=210;
 elseif T[2][i]<70 then
 color=211;
 else
 color=212;
 end
 lib.FillColor(x+64,y+3,x+64+len,y+3+10,C_BLACK);
 lib.SetClip(x+64,y+3,x+64+len*T[2][i]/100,y+3+10);
 lib.PicLoadCache(4,color*2,x+64,y+3,1);
 lib.SetClip(0,0,0,0);
 DrawString(x+64+len/2-size*#T[3][i]/4,y,T[3][i],C_WHITE,size);
 y=y+size+12;
 end
end
--新风格
function DrawStatus()
 local id;
 if War.SelID>0 then
 id=War.SelID;
 elseif War.CurID>0 then
 id=War.CurID;
 elseif War.LastID>0 then
 id=War.LastID;
 else
 return;
 end
 local wp=War.Person[id];
 local pid=War.Person[id].id;
 local p=JY.Person[pid];
 local x=801-48*4;
 local y=190;
 local size=16;
 local len=90;
 local T={
 {"兵 力","士气值","攻击力","防御力","策略值","经验值"},
 {math.min(100*p["兵力"]/p["最大兵力"],100),math.min(p["士气"],100),math.min(p["攻击"]/20,100),math.min(p["防御"]/20,100),math.min(100*p["策略"]/math.max(p["最大策略"],1),100),p["经验"]},
 {p["兵力"].."/"..p["最大兵力"],""..p["士气"],""..p["攻击"],""..p["防御"],p["策略"].."/"..p["最大策略"],""..p["经验"]},
 }
 local x_off=x-785;
 lib.PicLoadCache(4,230*2,800-48*4,73,1);
 lib.PicLoadCache(2,p["头像代号"]*2,808-48*4,81,1);
 lib.PicLoadCache(4,227*2,884-48*4,79,1);
 lib.PicLoadCache(4,228*2,884-48*4,109,1);
 lib.PicLoadCache(4,229*2,884-48*4,139,1);
 DrawString(x,y-size-3,p["姓名"].."　"..JY.Bingzhong[p["兵种"]]["名称"].."Lv"..p["等级"],C_WHITE,size);
 --DrawString(x+104,y-size-4,"Lv"..p["等级"],C_WHITE,size);
 --DrawString(932,87,p["武力"],C_WHITE,size);
 --DrawString(932,117,p["智力"],C_WHITE,size);
 --DrawString(932,147,p["统率"],C_WHITE,size);
 for i,v in pairs({"武力2","智力2","统率2"}) do
 DrawString2(916-48*4,54+i*30,string.format("%d",p[v]),C_WHITE,size);
 end

if CC.Enhancement then
if not War.Person[id].enemy then
local menux=670
local menuy=79
local wljy=p["武力经验"]
if p["武力"]==100 then wljy=200 end
lib.FillColor(menux+48,menuy+4+20,menux+48+33,menuy+4+10+20,C_BLACK);
 lib.SetClip(menux+48,menuy+4+20,menux+48+33*wljy/200,menuy+4+10+20);
 lib.PicLoadCache(4,212*2,menux+48,menuy+4+20,1);
 lib.SetClip(0,0,0,0);

local str=string.format("%d",math.modf(wljy/2)).."％"
if wljy==200 then str="MAX" end DrawString2(916-49*4,68+30,str,C_WHITE,16)

menuy=109
local zljy=p["智力经验"]
if p["智力"]==100 then zljy=200 end
lib.FillColor(menux+48,menuy+4+20,menux+48+33,menuy+4+10+20,C_BLACK);
 lib.SetClip(menux+48,menuy+4+20,menux+48+33*zljy/200,menuy+4+10+20);
 lib.PicLoadCache(4,212*2,menux+48,menuy+4+20,1);
 lib.SetClip(0,0,0,0);

str=string.format("%d",math.modf(zljy/2)).."％"
if zljy==200 then str="MAX" end DrawString2(916-49*4,68+60,str,C_WHITE,16)

menuy=139
local tljy=p["统率经验"]
if p["统率"]==100 then tljy=200 end
lib.FillColor(menux+48,menuy+4+20,menux+48+33,menuy+4+10+20,C_BLACK);
 lib.SetClip(menux+48,menuy+4+20,menux+48+33*tljy/200,menuy+4+10+20);
 lib.PicLoadCache(4,212*2,menux+48,menuy+4+20,1);
 lib.SetClip(0,0,0,0);

str=string.format("%d",math.modf(tljy/2)).."％"
if tljy==200 then str="MAX" end DrawString2(916-49*4,68+90,str,C_WHITE,16)
end
end

 for i=1,6 do
 DrawString(x,y,T[1][i],C_WHITE,size);
 local color;
 if T[2][i]<30 then
 color=210;
 elseif T[2][i]<70 then
 color=211;
 else
 color=212;
 end
 lib.FillColor(x+52,y+3,x+52+len,y+3+10,C_BLACK);
lib.SetClip(x+52,y+3,x+52+len*T[2][i]/100,y+3+10);
 lib.PicLoadCache(4,color*2,x+52,y+3,1);
 lib.SetClip(0,0,0,0);
 DrawString2(x+52+len/2-size*#T[3][i]/4,y,T[3][i],C_WHITE,size);
 y=y+size+2;
 end


 local leader=0;
 local forcename="";
 leader=p["君主"]; --默认就是自己的君主
 if leader==0 then --当没有设定时
 if wp.enemy then --敌人 就用敌人主帅的君主
 leader=JY.Person[War.Leader2]["君主"];
 end
 end
 if leader>0 then
 forcename=JY.Person[leader]["姓名"]
 else
 if wp.enemy then
 forcename="敌军";
 elseif wp.friend then
 forcename="友军";
 else
 forcename="我军";
 end
 end

 --[[
 local forcename="";
 if wp.enemy then
 forcename="敌军";
 elseif wp.friend then
 forcename="友军";
 else
 forcename="我军";
 end
 ]]--

 DrawString(632-#forcename*16/2/2,40,forcename,C_WHITE,16);
 
 
 if CC.Enhancement then
 DrawString(x,y,"技能",C_WHITE,size);
 DrawSkillTable(pid,x+34,y);
 y=y+42;
 DrawString(x,y,string.format("攻 %+03d％ 防 %+03d％",wp.atk_buff,wp.def_buff),C_WHITE,size);
 y=y+20;
 end
 
 if CC.AIXS then
 x=300
 y=CC.ScreenH-size
 if wp.ai==0 then
 DrawString(x,y,"AI: 被动出击",C_WHITE,size);
 elseif wp.ai==1 then
 DrawString(x,y,"AI: 主动出击",C_WHITE,size);
 elseif wp.ai==2 then
 DrawString(x,y,"AI: 坚守原地",C_WHITE,size);
 elseif wp.ai==3 then
 DrawString(x,y,"AI: 攻击 "..JY.Person[wp.aitarget]["姓名"],C_WHITE,size);
 elseif wp.ai==4 then
 DrawString(x,y,"AI: 攻击 "..wp.ai_dx..","..wp.ai_dy,C_WHITE,size);
 elseif wp.ai==5 then
 DrawString(x,y,"AI: 跟随 "..JY.Person[wp.aitarget]["姓名"],C_WHITE,size);
 elseif wp.ai==6 then
 DrawString(x,y,"AI: 移至 "..wp.ai_dx..","..wp.ai_dy,C_WHITE,size);
 else
 DrawString(x,y,"AI: 其他 "..wp.aitarget.." "..wp.ai_dx..","..wp.ai_dy,C_WHITE,size);
 end
 end
end

function DrawSkillTable(pid,x,y)
 local p=JY.Person[pid];
 local cx,cy
 local box_w=36;
 local box_h=20;
 for i=1,6 do
 local cx=x+box_w*((i-1)%3);
 local cy=y+box_h*math.modf((i-1)/3);
 lib.DrawRect(cx,cy,cx+box_w,cy,C_WHITE);
 lib.DrawRect(cx,cy+box_h,cx+box_w,cy+box_h,C_WHITE);
 lib.DrawRect(cx,cy,cx,cy+box_h,C_WHITE);
 lib.DrawRect(cx+box_w,cy,cx+box_w,cy+box_h,C_WHITE);
 lib.Background(cx+1,cy+1,cx+box_w,cy+box_h,240,M_Blue);
 if p["等级"]>=CC.SkillExp[p["成长"]][i] then
 DrawString(cx+2,cy+2,JY.Skill[p["特技"..i]]["名称"],C_WHITE,16);
 else
 DrawString(cx+2,cy+2,"？？",M_Gray,16);
 end
 end
end

function CleanWarMap(lv,v)
 for x=1,War.Width do
 for y=1,War.Depth do
 SetWarMap(x,y,lv,v);
 end
 end
end
function GetWarMap(x,y,lv)
 if x>0 and x<=War.Width and y>0 and y<=War.Depth then
 if lv==1 then
 if War.Map[War.Width*War.Depth*(9-1)+War.Width*(y-1)+x]==1 then
 return 18;
 elseif War.Map[War.Width*War.Depth*(9-1)+War.Width*(y-1)+x]==2 then
 return 19;
 else
 return War.Map[War.Width*War.Depth*(lv-1)+War.Width*(y-1)+x];
 end
 else
 return War.Map[War.Width*War.Depth*(lv-1)+War.Width*(y-1)+x];
 end
 else
 --JY.Person[999]["XX"]=1
 lib.Debug(string.format("error!GetWarMap x=%d,y=%d,width=%d,depth=%d",x,y,War.Width,War.Depth));
 --WarDrawStrBoxConfirm("error!GetWarMap",C_WHITE,true);
 return 0;
 end
end
function SetWarMap(x,y,lv,v)
 if x>0 and x<=War.Width and y>0 and y<=War.Depth then
 War.Map[War.Width*War.Depth*(lv-1)+War.Width*(y-1)+x]=v;
 return 1;
 else
 lib.Debug(string.format("error!SetWarMap x=%d,y=%d,v=%d,width=%d,depth=%d",x,y,v,War.Width,War.Depth));
 return 0;
 end
end
function filelength(filename) --得到文件长度
 local inp=io.open(filename,"rb");
 if inp==nil then
 return -1;
 end
 local l= inp:seek("end");
 inp:close();
 return l;
end
function LoadWarMap(id)
 local len=filelength(CC.MapFile);
 local data=Byte.create(len);
 Byte.loadfile(data,CC.MapFile,0,len);
 local map_num=58;
 local idx1,idx2,idx3,idx4=Byte.get8(data,16+256+12*id+8),Byte.get8(data,16+256+12*id+9),Byte.get8(data,16+256+12*id+10),Byte.get8(data,16+256+12*id+11);
 if idx1<0 then
 idx1=idx1+256
 end
 if idx2<0 then
 idx2=idx2+256
 end
 if idx3<0 then
 idx3=idx3+256
 end
 if idx4<0 then
 idx4=idx4+256
 end
 local idx=idx4+256*idx3+256^2*idx2+256^3*idx1;
 War.Width=Byte.get8(data,idx)/2;
 War.Depth=Byte.get8(data,idx+1)/2;
 War.MiniMapCX=680-War.Width*2;
 War.MiniMapCY=411-War.Depth*2;
 War.Map={};
 CleanWarMap(1,0); --地形
 CleanWarMap(2,0); --wid
 CleanWarMap(3,0); --
 CleanWarMap(4,1); --选择范围
 CleanWarMap(5,-1); --攻击价值
 CleanWarMap(6,-1); --策略价值
 CleanWarMap(7,0); --选择的策略
 CleanWarMap(8,0); --AI强化用，我军的攻击范围
 CleanWarMap(9,0); --水火控制
 CleanWarMap(10,0); --攻击范围，显示用
 idx=idx+2+4*War.Width*War.Depth;
 for i=1,War.Width*War.Depth do
 local v=Byte.get8(data,idx+(i-1));
 if v<0 or v>19 then
 lib.Debug(string.format("!!Error, MapID=%d,idx=%d,v=%d",id,i,v))
 v=0;
 end
 War.Map[i]=v;--Byte.get8(data,idx+(i-1));
 end
end
----------------------------------------------------------------
-- WarSearchMove(id,x,y)
-- 寻找移动到x,y的最近路径
-- flag,为true时无视敌人拦路
----------------------------------------------------------------
function WarSearchMove(id,x,y,flag)
 flag=flag or false
 local stepmax=256;
 CleanWarMap(4,0); --第4层坐标用来设置移动，先都设为0
 local steparray={}; --用数组保存第n步的坐标．
 for i=0,stepmax do
 steparray[i]={};
 steparray[i].num=0;
 steparray[i].x={};
 steparray[i].y={};
 steparray[i].m={};
 end
 SetWarMap(x,y,4,stepmax+1);
 steparray[0].num=1;
 steparray[0].x[1]=x;
 steparray[0].y[1]=y;
 steparray[0].m[1]=stepmax;
 for i=0,stepmax-1 do --根据第0步的坐标找出第1步，然后继续找
 WarSearchMove_sub(steparray,i,id,flag);
 if steparray[i+1].num==0 then
 break;
 end
 end
 return;
end
function WarSearchMove_sub(steparray,step,id,flag) --设置下一步可移动的坐标
 local num=0;
 local step1=step+1;
 local pid=War.Person[id].id;
 local bz=JY.Person[pid]["兵种"];
 for i=1,steparray[step].num do
 if steparray[step].m[i]>0 then
 local x=steparray[step].x[i];
 local y=steparray[step].y[i];
 for d=1,4 do--当前步数的相邻格
 local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d];
 if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
 local v=GetWarMap(nx,ny,4);
 local dx=GetWarMap(nx,ny,1);

local elyd=JY.Bingzhong[bz]["地形"..dx]
if CC.Enhancement and WarCheckSkill(id,118) then
elyd=1
end

 if v==0 and steparray[step].m[i]>=elyd and War_CanMoveXY(nx,ny,id,flag) then
 num=num+1;
 steparray[step1].x[num]=nx;
 steparray[step1].y[num]=ny;
 if CheckZOC(id,nx,ny) then
 steparray[step1].m[num]=steparray[step].m[i]-elyd-JY.Bingzhong[bz]["移动"];
 else
 steparray[step1].m[num]=steparray[step].m[i]-elyd
 end
 SetWarMap(nx,ny,4,steparray[step1].m[num]+1);
 end
 end
 end
 end
 end
 steparray[step1].num=num;
end
----------------------------------------------------------------
-- WarSearchBZ(id)
-- 寻找最近我方指定兵种
----------------------------------------------------------------
function WarSearchBZ(id,bzid)
 local stepmax=256;
 CleanWarMap(4,0); --第4层坐标用来设置移动，先都设为0，
 local x=War.Person[id].x;
 local y=War.Person[id].y;
 local steparray={}; --用数组保存第n步的坐标．
 for i=0,stepmax do
 steparray[i]={};
 steparray[i].num=0;
 steparray[i].x={};
 steparray[i].y={};
 steparray[i].m={};
 end
 SetWarMap(x,y,4,stepmax+1);
 steparray[0].num=1;
 steparray[0].x[1]=x;
 steparray[0].y[1]=y;
 steparray[0].m[1]=stepmax;
 for i=0,stepmax-1 do --根据第0步的坐标找出第1步，然后继续找
 local eid=WarSearchBZ_sub(steparray,i,id,bzid,true);
 if eid>0 then
 return eid;
 end
 if steparray[i+1].num==0 then
 break;
 end
 end
 return 0;
end
function WarSearchBZ_sub(steparray,step,id,bzid,flag) --设置下一步可移动的坐标
 local num=0;
 local step1=step+1;
 local pid=War.Person[id].id;
 local bz=JY.Person[pid]["兵种"];
 for i=1,steparray[step].num do
 if steparray[step].m[i]>0 then
 local x=steparray[step].x[i];
 local y=steparray[step].y[i];
 for d=1,4 do--当前步数的相邻格
 local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d];
 if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
 local v=GetWarMap(nx,ny,4);
 local dx=GetWarMap(nx,ny,1);

local elyd=JY.Bingzhong[bz]["地形"..dx]
if CC.Enhancement and WarCheckSkill(id,118) then
elyd=1
end

 if v==0 and steparray[step].m[i]>=elyd and War_CanMoveXY(nx,ny,id,flag) then
 num=num+1;
 steparray[step1].x[num]=nx;
 steparray[step1].y[num]=ny;
 steparray[step1].m[num]=steparray[step].m[i]-elyd
 SetWarMap(nx,ny,4,steparray[step1].m[num]+1);
 local eid=GetWarMap(nx,ny,2);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) and War.Person[id].enemy==War.Person[eid].enemy then
 -- 有人 活着 非伏兵 
 if bzid==War.Person[eid].bz and JY.Person[War.Person[eid].id]["策略"]>=6 then
 return eid;
 end
 end
 end
 end
 end
 end
 end
 steparray[step1].num=num;
 return 0;
end
----------------------------------------------------------------
-- WarSearchEnemy(id)
-- 寻找最近敌人
----------------------------------------------------------------
function WarSearchEnemy(id)
 local stepmax=256;
 CleanWarMap(4,0); --第4层坐标用来设置移动，先都设为0，
 local x=War.Person[id].x;
 local y=War.Person[id].y;
 local steparray={}; --用数组保存第n步的坐标．
 for i=0,stepmax do
 steparray[i]={};
 steparray[i].num=0;
 steparray[i].x={};
 steparray[i].y={};
 steparray[i].m={};
 end
 SetWarMap(x,y,4,stepmax+1);
 steparray[0].num=1;
 steparray[0].x[1]=x;
 steparray[0].y[1]=y;
 steparray[0].m[1]=stepmax;
 local eidbk=0;
 for i=0,stepmax-1 do --根据第0步的坐标找出第1步，然后继续找
 local eid=WarSearchEnemy_sub(steparray,i,id,true);
 if eid>0 then
 return eid;
 end
 if eidbk==0 and eid<0 then
 eidbk=-eid;
 end
 if steparray[i+1].num==0 then
 break;
 end
 end
 return eidbk;
end
function WarSearchEnemy_sub(steparray,step,id,flag) --设置下一步可移动的坐标
 local num=0;
 local step1=step+1;
 local pid=War.Person[id].id;
 local bz=JY.Person[pid]["兵种"];
 local eidbk=0;
 for i=1,steparray[step].num do
 if steparray[step].m[i]>0 then
 local x=steparray[step].x[i];
 local y=steparray[step].y[i];
 for d=1,4 do--当前步数的相邻格
 local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d];
 if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
 local v=GetWarMap(nx,ny,4);
 local dx=GetWarMap(nx,ny,1);

local elyd=JY.Bingzhong[bz]["地形"..dx]
if CC.Enhancement and WarCheckSkill(id,118) then
elyd=1
end

 if v==0 and steparray[step].m[i]>=elyd and War_CanMoveXY(nx,ny,id,flag) then
 num=num+1;
 steparray[step1].x[num]=nx;
 steparray[step1].y[num]=ny;
 steparray[step1].m[num]=steparray[step].m[i]-elyd
 SetWarMap(nx,ny,4,steparray[step1].m[num]+1);
 local eid=GetWarMap(nx,ny,2);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) and War.Person[id].enemy~=War.Person[eid].enemy then
 -- 有人 活着 非伏兵 敌人 
 --在已经搜寻过的坐标里，存在可以攻击的坐标
 local array=WarGetAtkFW(nx,ny,War.Person[id].atkfw);
 for n=1,array.num do
 if between(array[n][1],1,War.Width) and between(array[n][2],1,War.Depth) then
 if GetWarMap(array[n][1],array[n][2],4)>0 and GetWarMap(array[n][1],array[n][2],2)==0 then
 return eid;
 end
 end
 end
 eidbk=-eid;
 --return eid;
 end
 end
 end
 end
 end
 end
 steparray[step1].num=num;
 return 0;
end
----------------------------------------------------------------
-- War_CalAtkFW(wid)
-- 显示wid的攻击范围
----------------------------------------------------------------
function War_CalAtkFW(wid)
 local array=WarGetAtkFW(War.Person[wid].x,War.Person[wid].y,War.Person[wid].atkfw);
 for i=1,array.num do
 local mx,my=array[i][1],array[i][2];
 if between(mx,1,War.Width) and between(my,1,War.Depth) then
 SetWarMap(mx,my,10,1);
 end
 end
end

--计算可移动步数
--id 战斗人id，
--stepmax 最大步数，
--flag=0 移动，物品不能绕过，1 武功，用毒医疗等，不考虑挡路．
function War_CalMoveStep(id,stepmax,flag) --计算可移动步数

 CleanWarMap(4,0); --第4层坐标用来设置移动，先都设为0，

 local x=War.Person[id].x;
 local y=War.Person[id].y;

 local steparray={}; --用数组保存第n步的坐标．
 for i=0,stepmax do
 steparray[i]={};
 steparray[i].num=0;
 steparray[i].x={};
 steparray[i].y={};
 steparray[i].m={};
 end

 --SetWarMap(x,y,4,1);
 SetWarMap(x,y,4,stepmax+1);
 steparray[0].num=1;
 steparray[0].x[1]=x;
 steparray[0].y[1]=y;
 steparray[0].m[1]=stepmax;
 for i=0,stepmax-1 do --根据第0步的坐标找出第1步，然后继续找
 War_FindNextStep(steparray,i,id,flag);
 if steparray[i+1].num==0 then
 break;
 end
 end

 return steparray;

end

function War_FindNextStep(steparray,step,id,flag) --设置下一步可移动的坐标
 local num=0;
 local step1=step+1;
 local pid=War.Person[id].id;
 local bz=JY.Person[pid]["兵种"];
 for i=1,steparray[step].num do
 if steparray[step].m[i]>0 then
 local x=steparray[step].x[i];
 local y=steparray[step].y[i];
 for d=1,4 do--当前步数的相邻格
 local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d];
 if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
 local v=GetWarMap(nx,ny,4);
 local dx=GetWarMap(nx,ny,1);

local elyd=JY.Bingzhong[bz]["地形"..dx]
if CC.Enhancement and WarCheckSkill(id,118) then
elyd=1
end

 if v==0 and steparray[step].m[i]>=elyd and War_CanMoveXY(nx,ny,id,flag) then
 num=num+1;
 steparray[step1].x[num]=nx;
 steparray[step1].y[num]=ny;
 if (not flag) and CheckZOC(id,nx,ny) then
 steparray[step1].m[num]=0;
 else
 steparray[step1].m[num]=steparray[step].m[i]-elyd
 end
 SetWarMap(nx,ny,4,steparray[step1].m[num]+1);
 end
 end
 end
 end
 end
 steparray[step1].num=num;
end
function CheckZOC(id,x,y)
 if CC.Enhancement then
 if WarCheckSkill(id,34) then --强行
 return false;
 end
 end
 for d=1,4 do--当前步数的相邻格
 local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d];
 if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
 local eid=GetWarMap(nx,ny,2);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) and War.Person[id].enemy~=War.Person[eid].enemy then
 return true;
 end
 end
 end
 return false;
end
function War_CanMoveXY(x,y,pid,flag) --坐标是否可以通过，判断移动时使用
 local id1=War.Person[pid].id;
 local bz=JY.Person[id1]["兵种"];
 local dx=GetWarMap(x,y,1);
 if JY.Bingzhong[bz]["地形"..dx]==0 then
 return false;
 end
 local eid=GetWarMap(x,y,2);
 if eid>0 and (not flag) and War.Person[eid].live and (not War.Person[eid].hide) and War.Person[pid].enemy~=War.Person[eid].enemy then
 return false;
 end
 return true;
end
function WarCanExistXY(x,y,pid) --坐标是否可以通过
 local id1=War.Person[pid].id;
 local bz=JY.Person[id1]["兵种"];
 local dx=GetWarMap(x,y,1);
 if JY.Bingzhong[bz]["地形"..dx]==0 then
 return false;
 end
 local eid=GetWarMap(x,y,2);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 return false;
 end
 return true;
end
function War_MovePerson(x,y,flag) --移动人物到位置x,y
 War.ControlEnableOld=War.ControlEnable;
 War.ControlEnable=false;
 War.InMap=false;
 flag=flag or 0;
 local movenum=GetWarMap(x,y,4);
 local dx,dy=x,y;
 local movetable={}; -- 记录每步移动
 local mx,my=War.Person[War.SelID].x,War.Person[War.SelID].y;
 local dm=GetWarMap(mx,my,4);
 local start=dm;
 local str=JY.Person[War.Person[War.SelID].id]["姓名"]..'的移动';
 for i=1,dm do
 if mx==x and my==y then
 start=i-1;
 break;
 end
 movetable[i]={};
 movetable[i].x=x;
 movetable[i].y=y;
 local fx,fy;
 for d=1,4 do
 local nx,ny=x-CC.DirectX[d],y-CC.DirectY[d];
 if between(nx,1,War.Width) and between(ny,1,War.Depth) then
 local v=GetWarMap(nx,ny,4);
 if v>movenum then
 movenum=v;
 fx,fy=nx,ny;
 movetable[i].direct=d;
 end
 end
 end
 x,y=fx,fy;
 end
 --8是标准速度，6偏快，4很快,3极快，12慢,16
 local step=War.Person[War.SelID].movespeed;
 if CC.MoveSpeed==1 then
 step=1
 end
 SetWarMap(War.Person[War.SelID].x,War.Person[War.SelID].y,2,0);
 SetWarMap(dx,dy,2,War.SelID);
 War.ControlEnable=false;
 War.InMap=false;
 War.Person[War.SelID].action=1;
 local sframe=0;
 for i=start,1,-1 do
 War.Person[War.SelID].d=movetable[i].direct;
 local cx=War.Person[War.SelID].x+CC.DirectX[movetable[i].direct];
 local cy=War.Person[War.SelID].y+CC.DirectY[movetable[i].direct];
 if War.SelID>0 then
 if not between(War.CX,cx-War.MW+1,cx-1) then
 War.CX=limitX(War.CX,cx-War.MW+3,cx-3);
 War.CX=limitX(War.CX,1,War.Width-War.MW+1);
 end
 if not between(War.CY,cy-War.MD+1,cy-1) then
 War.CY=limitX(War.CY,cy-War.MD+2,cy-2);
 War.CY=limitX(War.CY,1,War.Depth-War.MD+1);
 end
 end
 for t=1,step do
 War.Person[War.SelID].x=War.Person[War.SelID].x+CC.DirectX[movetable[i].direct]/step;
 War.Person[War.SelID].y=War.Person[War.SelID].y+CC.DirectY[movetable[i].direct]/step;
 lib.GetKey(1);
 --War.Person[War.SelID].frame=math.modf((step*(i-1)+t)/2)%2;
 War.Person[War.SelID].frame=math.modf(sframe/4)%2;
 --[[
 if (step*(i-1)+t)%8==1 then
 PlayWavE(War.Person[War.SelID].movewav);
 end]]--
 if sframe==0 then
 PlayWavE(War.Person[War.SelID].movewav);
 end
 if sframe==7 then
 sframe=0;
 else
 sframe=sframe+1;
 end
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 DrawYJZBox2(-256,64,str,C_WHITE);
 ReFresh();
 end
 War.Person[War.SelID].x=cx;
 War.Person[War.SelID].y=cy;
 end
 --PlayWavE(War.Person[War.SelID].movewav);
 if War.Person[War.SelID].active then
 War.Person[War.SelID].action=1;
 else
 War.Person[War.SelID].action=0;
 end
 War.Person[War.SelID].frame=-1;
 War.Person[War.SelID].x=dx;
 War.Person[War.SelID].y=dy;
 BoxBack();
 local pid=War.Person[War.SelID].id;
 ReSetAttrib(pid,false);
 ReSetAllBuff();
 --War.CurID=War.SelID;
 War.CurID=0;
 War.ControlEnable=War.ControlEnableOld;
end

function ReSetAttrib(id,flag)
 local p=JY.Person[id];
 local wid=GetWarID(id);

 if wid>0 then
 War.Person[wid].sq_limited=100;
 else
 p["士气"]=100;
 end

 if CC.Enhancement then
 if CheckSkill(id,7) then --威风
 if wid>0 then
 War.Person[wid].sq_limited=JY.Skill[7]["参数1"];
 else
 p["士气"]=JY.Skill[7]["参数1"];
 end
 end
 end

 if wid>0 and flag then
 p["士气"]=War.Person[wid].sq_limited;
 end

 if CC.Enhancement and wid>0 then
 if CheckSkill(id,31) then --精兵
 if p["士气"]<JY.Skill[31]["参数1"] then
 p["士气"]=math.min(War.Person[wid].sq_limited,JY.Skill[31]["参数1"]);
 end
 end
 end

 local bid=p["兵种"];
 local b=JY.Bingzhong[bid];
 p["最大兵力"]=b["基础兵力"]+b["兵力增长"]*(p["等级"]-1);
 if CC.Enhancement then
 if CheckSkill(id,6) then --雄师
 p["最大兵力"]=b["基础兵力"]+JY.Skill[6]["参数1"]+(b["兵力增长"]+JY.Skill[6]["参数2"])*(p["等级"]-1);
 end
 end

 if wid>0 and CC.Enhancement then
 if CheckSkill(id,45) then --霸气
 War.Person[wid].atkfw=JY.Skill[45]["参数1"];
 end
 end
 
 --Get Weapon
 local weapon1=0;
 local weapon2=0;
 local weapon3=0;
 for i=1,8 do
 local item=p["道具"..i]
 if item>0 then
 local canuse=false;
 if JY.Item[item]["需兵种1"]==0 then
 canuse=true;
 else
 for n=1,7 do
 if JY.Item[item]["需兵种"..n]==p["兵种"] then
 canuse=true;
 break;
 end
 end
 end
 if p["等级"]<JY.Item[item]["需等级"] then
 canuse=false;
 end
 if canuse then
 if JY.Item[item]["装备位"]==1 then
 if weapon1==0 or JY.Item[item]["优先级"]>JY.Item[weapon1]["优先级"] then
 weapon1=item;
 end
 elseif JY.Item[item]["装备位"]==2 then
 if weapon2==0 or JY.Item[item]["优先级"]>JY.Item[weapon2]["优先级"] then
 weapon2=item;
 end
 elseif JY.Item[item]["装备位"]==3 then
 if weapon3==0 or JY.Item[item]["优先级"]>JY.Item[weapon3]["优先级"] then
 weapon3=item;
 end
 end
 end
 end
 end
 p["武器"]=weapon1;
 p["防具"]=weapon2;
 p["辅助"]=weapon3;
 
 --计算武器加成后的属性
 local p_wuli=p["武力"];
 local p_tongshuai=p["统率"];
 local p_zhili=p["智力"];
 local atk,def,mov=0,0,0;
 mov=b["移动"];
 if weapon1>0 then
 p_wuli=p_wuli+JY.Item[weapon1]["武力"];
 p_zhili=p_zhili+JY.Item[weapon1]["智力"];
 p_tongshuai=p_tongshuai+JY.Item[weapon1]["统率"];
 atk=atk+JY.Item[weapon1]["攻击"];
 def=def+JY.Item[weapon1]["防御"];
 mov=mov+JY.Item[weapon1]["移动"];
 end
 if weapon2>0 then
 p_wuli=p_wuli+JY.Item[weapon2]["武力"];
 p_zhili=p_zhili+JY.Item[weapon2]["智力"];
 p_tongshuai=p_tongshuai+JY.Item[weapon2]["统率"];
 atk=atk+JY.Item[weapon2]["攻击"];
 def=def+JY.Item[weapon2]["防御"];
 mov=mov+JY.Item[weapon2]["移动"];
 end
 if weapon3>0 then
 p_wuli=p_wuli+JY.Item[weapon3]["武力"];
 p_zhili=p_zhili+JY.Item[weapon3]["智力"];
 p_tongshuai=p_tongshuai+JY.Item[weapon3]["统率"];
 atk=atk+JY.Item[weapon3]["攻击"];
 def=def+JY.Item[weapon3]["防御"];
 mov=mov+JY.Item[weapon3]["移动"];
 end
 p["武力2"]=p_wuli;
 p["智力2"]=p_zhili;
 p["统率2"]=p_tongshuai;
 --p["最大策略"]=math.modf(p["智力"]*(p["等级"]+10)/40);
 p["最大策略"]=math.modf(p_zhili*(p["等级"]+10)/40)+b["策略成长"]*p["等级"];
 p["策略"]=limitX(p["策略"],0,p["最大策略"]);
 --（（4000÷（140－武力）＋兵种基本攻击力×2＋士气）×（等级＋10）÷10）×（100＋宝物攻击加成）÷100
 p["攻击"]=math.modf(((4000/math.max(140-p_wuli,30))*(p["等级"]+10)/10+(b["攻击"]+p["士气"])*(p["等级"]+10)/10)*(100+atk)/100);
 p["防御"]=math.modf(((4000/math.max(140-p_tongshuai,30))*(p["等级"]+10)/10+(b["防御"]+p["士气"])*(p["等级"]+10)/10)*(100+def)/100);
 if CC.Enhancement then
 if CheckSkill(id,30) then --无双
 p["攻击"]=p["攻击"]+JY.Skill[30]["参数1"]*p["等级"];
 p["防御"]=p["防御"]+JY.Skill[30]["参数1"]*p["等级"];
 else --有无双，则不考虑勇武和坚韧
 if CheckSkill(id,8) then --勇武
 p["攻击"]=p["攻击"]+JY.Skill[8]["参数1"]*p["等级"];
 end
 if CheckSkill(id,9) then --坚韧
 p["防御"]=p["防御"]+JY.Skill[9]["参数1"]*p["等级"];
 end
 end
 if JY.Bingzhong[p["兵种"]]["远程"]>0 and CheckSkill(id,24) then --强弓
 p["攻击"]=p["攻击"]+JY.Skill[24]["参数1"]*p["等级"];
 p["防御"]=p["防御"]+JY.Skill[24]["参数1"]*p["等级"];
 end
 if JY.Bingzhong[p["兵种"]]["骑马"]>0 and CheckSkill(id,25) then --强骑
 p["攻击"]=p["攻击"]+JY.Skill[25]["参数1"]*p["等级"];
 p["防御"]=p["防御"]+JY.Skill[25]["参数1"]*p["等级"];
 end
 if CheckSkill(id,10) then --速攻
 mov=mov+JY.Skill[10]["参数1"];
 end
 end
 p["移动"]=mov;
 if wid>0 then
 War.Person[wid].movestep=mov;
 end

 if flag then
 p["兵力"]=p["最大兵力"];
 p["策略"]=p["最大策略"];
 else
 p["兵力"]=limitX(p["兵力"],0,p["最大兵力"]);
 end
 
 --Buff
 if wid>0 then
 ReSetBuff(wid);
 end
end

function ReSetAllBuff()
 for wid,wp in pairs(War.Person) do
 if wp.live and (not wp.hide) then
 ReSetBuff(wid);
 end
 end
end

function ReSetBuff(wid)
 if wid>0 and CC.Enhancement then
 local pid=War.Person[wid].id;
 local p=JY.Person[pid];
 War.Person[wid].atk_buff=0;
 War.Person[wid].def_buff=0;
 --地形
 local T={[0]=0,20,30,0,0, --森林　20　山地　30
 0,0,5,5,0, --村庄　 5 草原　 5
 0,0,0,30,10, --鹿寨　30　兵营　10
 0,0,0,0,0,
 0,0,0,0,0,
 0,0,0,0,0}
 local dx=GetWarMap(War.Person[wid].x,War.Person[wid].y,1);
 War.Person[wid].def_buff=War.Person[wid].def_buff+T[dx];
 --背水
 if WarCheckSkill(wid,28) then
 War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[28]["参数2"]*math.modf(100*(p["最大兵力"]-p["兵力"])/p["最大兵力"]/JY.Skill[28]["参数1"]);
 War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[28]["参数2"]*math.modf(100*(p["最大兵力"]-p["兵力"])/p["最大兵力"]/JY.Skill[28]["参数1"]);
 else
 --猛者
 if WarCheckSkill(wid,27) then
 War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[27]["参数2"]*math.modf(100*(p["最大兵力"]-p["兵力"])/p["最大兵力"]/JY.Skill[27]["参数1"]);
 end
 --不屈
 if WarCheckSkill(wid,26) then
 War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[26]["参数2"]*math.modf(100*(p["最大兵力"]-p["兵力"])/p["最大兵力"]/JY.Skill[26]["参数1"]);
 end
 end
 
 --伏兵
 if War.Person[wid].was_hide then
 if WarCheckSkill(wid,21) then
 War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[21]["参数1"];
 War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[21]["参数1"];
 end
 end
 --谨慎
 if WarCheckSkill(wid,29) then
 War.Person[wid].atk_buff=War.Person[wid].atk_buff-JY.Skill[29]["参数1"];
 War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[29]["参数2"];
 end
 --城战
 if WarCheckSkill(wid,32) then
 -- 00 平原 01 森林 02 山地 03 河流 04 桥梁 05 城墙 06 城池 07 草原
 -- 08 村庄 09 悬崖 0A 城门 0B 荒地 0C 栅栏 0D 鹿砦 0E 兵营 0F 粮仓
 -- 10 宝物库 11 房舍 12 火焰 13 浊流
 if dx==6 or dx==13 or dx==14 then
 War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[32]["参数1"];
 end
 end
 --龙胆
 if WarCheckSkill(wid,49) then
 local value=0;
 local array=WarGetAtkFW(War.Person[wid].x,War.Person[wid].y,2);
 for i=1,4 do
 local eid=GetWarMap(array[i][1],array[i][2],2);
 if eid>0 then
 if War.Person[wid].enemy~=War.Person[eid].enemy then
 value=value+JY.Skill[49]["参数1"];
 end
 end
 end
 for i=5,8 do
 local eid=GetWarMap(array[i][1],array[i][2],2);
 if eid>0 then
 if War.Person[wid].enemy~=War.Person[eid].enemy then
 value=value+JY.Skill[49]["参数2"];
 end
 end
 end
 War.Person[wid].atk_buff=War.Person[wid].atk_buff+value;
 War.Person[wid].def_buff=War.Person[wid].def_buff+value;
 end
 --布阵类
 local bz_flag=true;

--[[
 --八阵
 if bz_flag then
 if War.Person[wid].enemy then
 if CheckSkill(War.Leader2,38) then
 bz_flag=false;
 War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[38]["参数1"];
 War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[38]["参数1"];
 end
 else
 if CheckSkill(War.Leader1,38) then
 bz_flag=false;
 War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[38]["参数1"];
 War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[38]["参数1"];
 end
 end
 end
 if bz_flag then
 if WarCheckSkill(wid,38) then
 bz_flag=false;
 War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[38]["参数1"];
 War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[38]["参数1"];
 end
 end


 --魏武
 if bz_flag then
 if War.Person[wid].enemy then
 if CheckSkill(War.Leader2,37) then
 bz_flag=false;
 War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[37]["参数1"];
 War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[37]["参数1"];
 end
 else
 if CheckSkill(War.Leader1,37) then
 bz_flag=false;
 War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[37]["参数1"];
 War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[37]["参数1"];
 end
 end
 end
 if bz_flag then
 if WarCheckSkill(wid,37) then
 bz_flag=false;
 War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[37]["参数1"];
 War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[37]["参数1"];
 end
 end
]]--

 --布阵
 if bz_flag then
 if War.Person[wid].enemy then
 if CheckSkill(War.Leader2,36) then
 bz_flag=false;
 War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[36]["参数1"];
 end
 else
 if CheckSkill(War.Leader1,36) then
 bz_flag=false;
 War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[36]["参数1"];
 end
 end
 end
 if bz_flag then
 if CC.Enhancement and WarCheckSkill(wid,36) then
 bz_flag=false;
 War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[36]["参数1"];
 end
 end
 
 War.Person[wid].atk_buff=limitX(War.Person[wid].atk_buff,-50,95);
 War.Person[wid].def_buff=limitX(War.Person[wid].def_buff,-50,95);
 end
end

--行动顺序的判定以自动补给后的数据为准．
--最优先行动的是处于恢复性地形（村庄、兵营、鹿砦）中的部队，若有数只部队处于恢复性地形上，则以其在屏幕右上方的敌军列表中的顺序排列．
--第二优先行动的是兵力小于最大兵力的40％或士气低于40的部队，若右数只部门处于该情形下，则以其在屏幕右上方的敌军列表中的顺序进行排列．
--最后余下的部队按屏幕右上方的敌军列表中的顺序进行排列．
function AI()

 War.ControlEnableOld=War.ControlEnable;
 War.ControlEnable=false;
 --友军
 local flag=true;
 --最优先行动的
 for i,v in pairs(War.Person) do
 if JY.Status~=GAME_WMAP then
 return;
 end
 local dx=GetWarMap(v.x,v.y,1);
 if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and v.friend and v.active and (dx==8 or dx==13 or dx==14) then
 War.ControlEnable=false;
 War.InMap=false;
 if flag then
 --友军状况
 WarDrawStrBoxDelay('友军状况',C_WHITE);
 flag=false;
 end
 AI_Sub(i);
 --挪到AI_Sub里面
 --v.active=false;
 --v.action=0;
 --WarResetStatus(i);
 --WarCheckStatus();
 --WarDelay(CC.WarDelay);
 
 end
 end
 --第二优先行动的
 for i,v in pairs(War.Person) do
 if JY.Status~=GAME_WMAP then
 return;
 end
 if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and v.friend and v.active and (JY.Person[v.id]["兵力"]/JY.Person[v.id]["最大兵力"]<=0.4 or JY.Person[v.id]["士气"]<=40) then
 War.ControlEnable=false;
 War.InMap=false;
 if flag then
 --友军状况
 WarDrawStrBoxDelay('友军状况',C_WHITE);
 flag=false;
 end
 AI_Sub(i);
 --挪到AI_Sub里面
 --v.active=false;
 --v.action=0;
 --WarResetStatus(i);
 --WarCheckStatus();
 --WarDelay(CC.WarDelay);
 
 end
 end
 --余下的部队
 for i,v in pairs(War.Person) do
 if JY.Status~=GAME_WMAP then
 return;
 end
 if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and v.friend and v.active then
 War.ControlEnable=false;
 War.InMap=false;
 if flag then
 --友军状况
 WarDrawStrBoxDelay('友军状况',C_WHITE);
 flag=false;
 end
 AI_Sub(i);
 --挪到AI_Sub里面
 --v.active=false;
 --v.action=0;
 --WarResetStatus(i);
 --WarCheckStatus();
 --WarDelay(CC.WarDelay);
 
 end
 end
 
 
 --敌军
 WarGetAramyAtkFW();
 flag=true;
 --最优先行动的
 for i,v in pairs(War.Person) do
 if JY.Status~=GAME_WMAP then
 return;
 end
 local dx=GetWarMap(v.x,v.y,1);
 if v.live and (not v.hide) and (not v.troubled) and v.enemy and v.active and (v.bz==13 or v.bz==19) then
 War.ControlEnable=false;
 War.InMap=false;
 if flag then
 --敌军状况
 WarDrawStrBoxDelay('敌军状况',C_WHITE);
 flag=false;
 end
 AI_Sub(i);
 --挪到AI_Sub里面
 --v.active=false;
 --v.action=0;
 --WarResetStatus(i);
 --WarCheckStatus();
 --WarDelay(CC.WarDelay);
 end
 end
 for i,v in pairs(War.Person) do
 if JY.Status~=GAME_WMAP then
 return;
 end
 local dx=GetWarMap(v.x,v.y,1);
 if v.live and (not v.hide) and (not v.troubled) and v.enemy and v.active and (dx==8 or dx==13 or dx==14) then
 War.ControlEnable=false;
 War.InMap=false;
 if flag then
 --敌军状况
 WarDrawStrBoxDelay('敌军状况',C_WHITE);
 flag=false;
 end
 AI_Sub(i);
 --挪到AI_Sub里面
 --v.active=false;
 --v.action=0;
 --WarResetStatus(i);
 --WarCheckStatus();
 --WarDelay(CC.WarDelay);
 end
 end
 --第二优先行动的
 for i,v in pairs(War.Person) do
 if JY.Status~=GAME_WMAP then
 return;
 end
 if v.live and (not v.hide) and (not v.troubled) and v.enemy and v.active and (JY.Person[v.id]["兵力"]/JY.Person[v.id]["最大兵力"]<=0.4 or JY.Person[v.id]["士气"]<=40) then
 War.ControlEnable=false;
 War.InMap=false;
 if flag then
 --敌军状况
 WarDrawStrBoxDelay('敌军状况',C_WHITE);
 flag=false;
 end
 AI_Sub(i);
 --挪到AI_Sub里面
 --v.active=false;
 --v.action=0;
 --WarResetStatus(i);
 --WarCheckStatus();
 --WarDelay(CC.WarDelay);
 end
 end
 --余下的部队
 for i,v in pairs(War.Person) do
 if JY.Status~=GAME_WMAP then
 return;
 end
 if v.live and (not v.hide) and (not v.troubled) and v.enemy and v.active then
 War.ControlEnable=false;
 War.InMap=false;
 if flag then
 --敌军状况
 WarDrawStrBoxDelay('敌军状况',C_WHITE);
 flag=false;
 end
 AI_Sub(i);
 --挪到AI_Sub里面
 --v.active=false;
 --v.action=0;
 --WarResetStatus(i);
 --WarCheckStatus();
 --WarDelay(CC.WarDelay);
 end
 end
 
 War.ControlEnable=War.ControlEnableOld;
end

function WarGetAramyAtkFW()
 CleanWarMap(8,0);
 for i,v in pairs(War.Person) do
 if not v.enemy then
 if not v.hide then
 if v.live then
 local len=1;
 if v.atkfw==2 or v.atkfw==3 then
 len=2;
 elseif v.atkfw==4 then
 len=3;
 elseif v.atkfw==5 then
 len=4;
 end
 CleanWarMap(5,-1);
 local steparray=War_CalMoveStep(i,v.movestep+len);
 for j=0,v.movestep+len do
 for k=1,steparray[j].num do
 local mx,my=steparray[j].x[k],steparray[j].y[k];
 SetWarMap(mx,my,8,GetWarMap(mx,my,8)+1)
 end
 end
 end
 end
 end
 end
 CleanWarMap(5,-1);
end
function WarGetAramyAtkFW()
 CleanWarMap(8,0);
 for i,v in pairs(War.Person) do
 if not v.enemy then
 if not v.hide then
 if v.live then
 local array=WarGetAtkFW(v.x,v.y,2);
 for j=1,array.num do
 local mx,my=array[j][1],array[j][2];
 if between(mx,1,War.Width) and between(my,1,War.Depth) then
 local n=2;
 if j>4 then
 n=1;
 end
 local ov=GetWarMap(mx,my,8);
 if n>ov then
 SetWarMap(mx,my,8,n);
 end
 end
 end
 end
 end
 end
 end
end
function AI_Sub(id,flag)
 --AI类型＝00 被动出击型，部队在原地不移动，但如果有敌人进入其移动后还能攻击到的地方，部队将移动并进行攻击．
 --AI类型＝01 主动出击型，部队会主动移动并攻击
 --AI类型＝02 坚守原地型，部队在原地不移动，即使受到攻击也是如此，但如果有人进入其攻击范围，部队将发起攻击．
 --AI类型＝03 追击指定目标
 --AI类型＝04 移动到目的，攻击
 --AI类型＝05 向目标无攻击移动
 --AI类型＝06 移动到某点不攻击
--[[
00=(X,Y) 移动/n 移动：
 若移动范围+攻击范围内有我军就选择行动价值最高的动作，否则：
1、当仇人代码为n=FF时，朝着(X,Y)坐标移动。
2、当仇人代码为n=FF时，且到达了(X,Y)坐标，则AI变为03=(X,Y) 待命。
3、当仇人代码为n=00~2C且仇人还在场时，朝着战场n号人物移动。
4、若仇人代码为n=00~2C且仇人消失，则AI变为01=攻击最近敌。

01=攻击最近敌：
 若移动范围+攻击范围内有我军就选择行动价值最高的动作，否则向最近的我军移动。

02=(X,Y) 不动/n 不动：
 无论攻击范围内是否有我军都会选择行动价值最高的动作，但是不会移动。
X,Y,n都无意义。（不确定）

03=(X,Y) 待命/n 待命：
 若移动范围+攻击范围内有我军就选择行动价值最高的动作，否则不会移动。
X,Y,n都无意义。（不确定）

04=(X,Y) 无攻击移动/n 无攻击移动：
 只会朝着目标坐标(X,Y)移动（若仇人代码为FF）或战场n号人物移动，不会攻击或使用策略。
1、当仇人代码为n=FF时，且到达了(X,Y)坐标，则AI变为03=(X,Y) 待命。
2、若仇人代码为n=00~2C且仇人消失，则AI变为01=攻击最近敌。

07=键入
 若我方AI≠07，则为友军。


]]-- 


WarPersonCenter(id)

 --优先 搜寻移动范围内，有攻击就移动到附近．没有可攻击的，就考虑移动
local did=0
 War.SelID=id;
 local wp=War.Person[id];
 local id1=wp.id;
 --XXX的移动
 CleanWarMap(5,-1);
 CleanWarMap(6,-1);
 CleanWarMap(7,-1);
 local dx,dy=wp.x,wp.y;
 local dv=0;

if JY.Base["敌军追击"] == 1 then
 if wp.ai==0 or wp.ai==2 then
 if not wp.friend then
 wp.ai=1
 end
 end
end

local ccai=0
if flag~=nil then
ccai=wp.ai
wp.ai=2
end

 --AI根据实际情况自动调整
 --AI类型＝03 追击指定目标 当追击目标消失时 --〉主动出击
 if wp.ai==3 then
 local eid=GetWarID(wp.aitarget);
 if not (eid>0 and War.Person[eid].live) then
 wp.ai=1;
 end
 end
 --
 if wp.ai~=2 then --除了 坚守原地型 以外，其他的ai类型都需要考虑移动
 local steparray=War_CalMoveStep(id,wp.movestep);
 for i=0,wp.movestep do
 for j=1,steparray[i].num do
 local mx,my=steparray[i].x[j],steparray[i].y[j];
 if GetWarMap(mx,my,2)==0 or (mx==wp.x and my==wp.y) then
 local v=WarGetMoveValue(id,mx,my);
 if v>dv then
 dv=v;
 dx,dy=mx,my;
 end
 end
 end
 end
 --如果部队的兵力不足（即兵力小于最大兵力的40％或士气小于40，下同）．
 if dv<50 then
 if JY.Person[id1]["兵力"]/JY.Person[id1]["最大兵力"]<=0.4 then
 local eid=WarSearchBZ(id,19);
 if eid>0 then
did=eid
 dv=0;
 WarSearchMove(id,War.Person[eid].x,War.Person[eid].y);
 for i=0,wp.movestep do
 for j=1,steparray[i].num do
 local mx,my=steparray[i].x[j],steparray[i].y[j];
 local v=GetWarMap(mx,my,4);
 if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
 dv=v;
 dx,dy=mx,my;
 end
 end
 end
 end
 elseif JY.Person[id1]["士气"]<=40 then
 local eid=WarSearchBZ(id,13);
 if eid>0 then
did=eid
 dv=0;
 WarSearchMove(id,War.Person[eid].x,War.Person[eid].y);
 for i=0,wp.movestep do
 for j=1,steparray[i].num do
 local mx,my=steparray[i].x[j],steparray[i].y[j];
 local v=GetWarMap(mx,my,4);
 if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
 dv=v;
 dx,dy=mx,my;
 end
 end
 end
 end
 end
 end
 if dv>0 then --移动范围有目标
 if dx~=wp.x or dy~=wp.y then --需要移动
 War_CalMoveStep(id,wp.movestep);
 BoxBack();
 --WarDelay(CC.WarDelay);
 --WarDrawStrBoxDelay2(JY.Person[id1]["姓名"]..'的移动',C_WHITE,-310,48);
 War_MovePerson(dx,dy);
 War.ControlEnable=false;
 War.InMap=false;
 end
 else --一次移动范围内无目标
 if wp.ai==1 then --考虑移动到最近敌人
 local eid=WarSearchEnemy(id);
 if eid>0 then
did=eid
 WarSearchMove(id,War.Person[eid].x,War.Person[eid].y);
 for i=0,wp.movestep do
 for j=1,steparray[i].num do
 local mx,my=steparray[i].x[j],steparray[i].y[j];
 local v=GetWarMap(mx,my,4);
 v=v+1-math.max(math.abs(mx-War.Person[eid].x),math.abs(my-War.Person[eid].y))/100;
 if wp.enemy then
 local ddv=GetWarMap(mx,my,8);
 --if wp.bz==13 or wp.bz==19 or wp.bz==19 then
 v=v-ddv;
 --end
 end
 
 if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
 dv=v;
 dx,dy=mx,my;
 end
 end
 end
 end
 elseif wp.ai==3 or wp.ai==5 then
 local eid=GetWarID(wp.aitarget);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
did=eid
 WarSearchMove(id,War.Person[eid].x,War.Person[eid].y);
 if GetWarMap(wp.x,wp.y,4)==0 then
 WarSearchMove(id,War.Person[eid].x,War.Person[eid].y,true); --如果找不到路径，则无视敌人拦路，再找一次
 end
 if GetWarMap(wp.x,wp.y,4)==0 then
 eid=WarSearchEnemy(id);
 if eid>0 then
did=eid
 WarSearchMove(id,War.Person[eid].x,War.Person[eid].y); --如果找不到路径，则移动到最近敌人
 end
 end
 for i=0,wp.movestep do
 for j=1,steparray[i].num do
 local mx,my=steparray[i].x[j],steparray[i].y[j];
 local v=GetWarMap(mx,my,4);
 v=v+1-math.max(math.abs(mx-War.Person[eid].x),math.abs(my-War.Person[eid].y))/100;
 if wp.enemy then
 local ddv=GetWarMap(mx,my,8);
 if wp.bz==13 or wp.bz==16 or wp.bz==19 then
 v=v-ddv;
 end
 end
 
 if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
 dv=v;
 dx,dy=mx,my;
 end
 end
 end
 end
 elseif wp.ai==4 or wp.ai==6 then
 WarSearchMove(id,wp.ai_dx,wp.ai_dy);
 if GetWarMap(wp.x,wp.y,4)==0 then
 WarSearchMove(id,wp.ai_dx,wp.ai_dy,true); --如果找不到路径，则无视敌人拦路，再找一次
 end
 for i=0,wp.movestep do
 for j=1,steparray[i].num do
 local mx,my=steparray[i].x[j],steparray[i].y[j];
 local v=GetWarMap(mx,my,4);
 v=v+1-math.max(math.abs(mx-wp.ai_dx),math.abs(my-wp.ai_dy))/100;
 if wp.enemy then
 local ddv=GetWarMap(mx,my,8);
 if wp.bz==13 or wp.bz==16 or wp.bz==19 then
 v=v-ddv;
 end
 end
 
 if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
 dv=v;
 dx,dy=mx,my;
 end
 end
 end
 end
 if dx~=wp.x or dy~=wp.y then
 War_CalMoveStep(id,wp.movestep);
 BoxBack();
 --WarDelay(CC.WarDelay);
 --WarDrawStrBoxDelay2(JY.Person[id1]["姓名"]..'的移动',C_WHITE,-310,48);
 War_MovePerson(dx,dy);
 War.ControlEnable=false;
 War.InMap=false;
 end
 end
 end
 CleanWarMap(4,1);
 --XXX的攻击
 local eid=0;
 dv=0;
 if wp.ai==5 or wp.ai==6 then
 
 else
 local atkarray=WarGetAtkFW(dx,dy,War.Person[id].atkfw);
 for i=1,atkarray.num do
 if atkarray[i][1]>0 and atkarray[i][1]<=War.Width and atkarray[i][2]>0 and atkarray[i][2]<=War.Depth then
 local v=WarGetAtkValue(id,atkarray[i][1],atkarray[i][2]);
 if v>dv then
 dv=v;
 eid=GetWarMap(atkarray[i][1],atkarray[i][2],2);
 end
 end
 end
 local mv,magicx,magicy=WarGetMagicValue(id,dx,dy);
 if mv>0 then
 --策略系部队，如果物理攻击价值低于100，则为0（new）
 if wp.bz==13 or wp.bz==16 or wp.bz==19 then
 if dv<100 then
 dv=0;
 end
 end
 end
 if mv>dv and flag==nil then
 local mid=GetWarMap(magicx,magicy,7);
 eid=GetWarMap(magicx,magicy,2);
did=eid
 BoxBack();
 --WarDelay(CC.WarDelay);
 WarDrawStrBoxDelay(string.format("%s使用%s计．",JY.Person[id1]["姓名"],JY.Magic[mid]["名称"]),C_WHITE);
 WarMagic(id,eid,mid);

if CC.Enhancement and WarCheckSkill(id,119) then
if (JY.Magic[mid]["类型"]==1 or JY.Magic[mid]["类型"]==2 or JY.Magic[mid]["类型"]==3) and JY.Magic[mid]["效果范围"]==11 then
WarMagic(id,eid,mid);
end
end

if CC.Enhancement and WarCheckSkill(id,112) then --七星剑 策略值消耗减半
 JY.Person[id1]["策略"]=JY.Person[id1]["策略"]-math.modf(JY.Magic[mid]["消耗"]/2);
else
JY.Person[id1]["策略"]=JY.Person[id1]["策略"]-JY.Magic[mid]["消耗"];
end

 JY.Person[id1]["策略"]=limitX(JY.Person[id1]["策略"],0,JY.Person[id1]["最大策略"]);
 else
 if eid>0 then
did=eid
 BoxBack();
 --WarDelay(CC.WarDelay);
 --WarDrawStrBoxDelay2(JY.Person[id1]["姓名"]..'的攻击',C_WHITE,-310,48);

local xsgj=false
if CC.Enhancement and WarCheckSkill(eid,117) then
if JY.Person[War.Person[eid].id]["兵力"]>0 and (not War.Person[eid].troubled) then
if JY.Bingzhong[War.Person[eid].bz]["可反击"]==1 and JY.Bingzhong[War.Person[id].bz]["被反击"]==1 then
xsgj=true
 elseif CC.Enhancement then
if WarCheckSkill(eid,42) then --反击(特技)
xsgj=true
 end
 end
end
end

 if xsgj then
 --检查是否在攻击范围内
 xsgj=false;
 local xs_arrary=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,War.Person[eid].atkfw);
 for n=1,xs_arrary.num do
 if between(xs_arrary[n][1],1,War.Width) and between(xs_arrary[n][2],1,War.Depth) then
 if GetWarMap(xs_arrary[n][1],xs_arrary[n][2],2)==id then
 xsgj=true
 break;
 end
 end
 end
 end

 if xsgj then
 --反击概率＝我军武将武力÷150
if CC.Enhancement and WarCheckSkill(eid,102) then --刘备装备雌雄双剑 被攻击时必定反击
WarAtk(eid,id,1)
WarResetStatus(id)
 elseif CC.Enhancement and WarCheckSkill(eid,19) then --报复

 if math.random(100)<=JY.Person[War.Person[eid].id]["武力2"] then

--丈八蛇矛
local smfj=0
local smsh=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
if CC.Enhancement and WarCheckSkill(eid,107) then
smsh=1
end

if smsh==1 and smfj==1 then
 WarAtk(eid,id);
 WarResetStatus(id);
if JY.Person[War.Person[id].id]["兵力"]>0 then
 WarAtk(eid,id);
 WarResetStatus(id);
end
elseif smfj==1 then
 WarAtk(eid,id,1);
 WarResetStatus(id);
if JY.Person[War.Person[id].id]["兵力"]>0 then
 WarAtk(eid,id,1);
 WarResetStatus(id);
end
elseif smsh==1 then
 WarAtk(eid,id);
 WarResetStatus(id);
else
 WarAtk(eid,id,1);
 WarResetStatus(id);
end

if CC.Enhancement and WarCheckSkill(id,103) then
 WarAtk(id,eid,1);
 WarResetStatus(eid);
end
 end
 else
 if math.random(150)<=JY.Person[War.Person[eid].id]["武力2"] then

--丈八蛇矛
local smfj=0
local smsh=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
if CC.Enhancement and WarCheckSkill(eid,107) then
smsh=1
end

if smsh==1 and smfj==1 then
 WarAtk(eid,id);
 WarResetStatus(id);
if JY.Person[War.Person[id].id]["兵力"]>0 then
 WarAtk(eid,id);
 WarResetStatus(id);
end
elseif smfj==1 then
 WarAtk(eid,id,1);
 WarResetStatus(id);
if JY.Person[War.Person[id].id]["兵力"]>0 then
 WarAtk(eid,id,1);
 WarResetStatus(id);
end
elseif smsh==1 then
 WarAtk(eid,id);
 WarResetStatus(id);
else
 WarAtk(eid,id,1);
 WarResetStatus(id);
end

if CC.Enhancement and WarCheckSkill(id,103) then
 WarAtk(id,eid,1);
 WarResetStatus(eid);
end
 end
 end
 end

if JY.Person[War.Person[id].id]["兵力"]>0 then
 WarAtk(id,eid);
 WarResetStatus(eid);
end

--混乱攻击
if CC.Enhancement and WarCheckSkill(id,116) then
if JY.Person[War.Person[eid].id]["兵力"]>0 then
 War.Person[eid].troubled=true
 War.Person[eid].action=7
 WarDelay(2);
 WarDrawStrBoxDelay(JY.Person[War.Person[eid].id]["姓名"].."混乱了！",C_WHITE);
end
end

--引导攻击
local ydgj=0
if CC.Enhancement and WarCheckSkill(id,109) then
ydgj=2
elseif CC.Enhancement and WarCheckSkill(id,108) then
ydgj=1
end

if ydgj==1 and War.YD==0 then
if JY.Person[War.Person[eid].id]["兵力"]<=0 then
War.YD=1
AI_Sub(id,1)
end

elseif ydgj==2 then
local yd=eid
while yd~=0 do
if JY.Person[War.Person[yd].id]["兵力"]<=0 then
yd=AI_Sub(id,1)
did=yd
else
break
end
end
end

if CC.Enhancement and WarCheckSkill(id,114) then --英雄之剑 穿刺攻击

local mx=War.Person[id].x;
local my=War.Person[id].y;
local xx=War.Person[eid].x
local yy=War.Person[eid].y
local dx=mx-xx
local dy=my-yy
local eid2=0

if dx>0 and dy==0 then --先确定被攻击者在攻击者左边方向
if GetWarMap(xx-1,yy,2)>0 then --然后确认是被攻击者左边那一格的对象
eid2=GetWarMap(xx-1,yy,2) --获取这一格的人物id编号
if War.Person[eid].enemy==War.Person[eid2].enemy then --最后确定与被攻击者同阵营
WarAtk(id,eid2) --攻击
WarResetStatus(eid2)
end
end
end

if dx<0 and dy==0 and GetWarMap(xx+1,yy,2)>0 then --右
eid2=GetWarMap(xx+1,yy,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end

if dx==0 and dy>0 and GetWarMap(xx,yy-1,2)>0 then --上
eid2=GetWarMap(xx,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end

if dx==0 and dy<0 and GetWarMap(xx,yy+1,2)>0 then --下
eid2=GetWarMap(xx,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end

if dx>0 and dy>0 and GetWarMap(xx-1,yy-1,2)>0 and dx==dy then --左上
eid2=GetWarMap(xx-1,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end

if dx<0 and dy>0 and GetWarMap(xx+1,yy-1,2)>0 and dx==-(dy) then --右上
eid2=GetWarMap(xx+1,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end

if dx>0 and dy<0 and GetWarMap(xx-1,yy+1,2)>0 and -(dx)==dy then --左下
eid2=GetWarMap(xx-1,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end

if dx<0 and dy<0 and GetWarMap(xx+1,yy+1,2)>0 and dx==dy then --右下
eid2=GetWarMap(xx+1,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end

end

 --反击
local fsfj=false --装备青龙偃月刀的人不是关羽时封杀反击
if CC.Enhancement and WarCheckSkill(id,105) then
fsfj=true
end

 if JY.Person[War.Person[eid].id]["兵力"]>0 and (not War.Person[eid].troubled) and fsfj==false and xsgj==false then
 --只有贼兵（山贼、恶贼、义贼）和武术家能反击敌军的物理攻击。
 --攻击方兵种为骑兵、贼兵、猛兽兵团、武术家、异民族时，才可能产生反击。
--攻击方兵种为步兵、弓兵、军乐队、妖术师、运输队时，不可能发生反击。
--攻击方为新增兵种时，都可以产生反击

 local fj_flag=false;
if JY.Bingzhong[War.Person[eid].bz]["可反击"]==1 and JY.Bingzhong[War.Person[id].bz]["被反击"]==1 then
 fj_flag=true;

elseif CC.Enhancement and WarCheckSkill(eid,102) then --刘备装备雌雄双剑 被攻击时必定反击
fj_flag=true

 elseif CC.Enhancement and WarCheckSkill(eid,42) then --反击(特技)
 fj_flag=true;
 end

 if fj_flag then
 --检查是否在攻击范围内
 fj_flag=false;
 local fj_arrary=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,War.Person[eid].atkfw);
 for n=1,fj_arrary.num do
 if between(fj_arrary[n][1],1,War.Width) and between(fj_arrary[n][2],1,War.Depth) then
 if GetWarMap(fj_arrary[n][1],fj_arrary[n][2],2)==id then
 fj_flag=true;
 break;
 end
 end
 end
 end
 
 if fj_flag then
 --反击概率＝我军武将武力÷150
if CC.Enhancement and WarCheckSkill(eid,102) then --刘备装备雌雄双剑 被攻击时必定反击
WarAtk(eid,id,1)
WarResetStatus(id)

 elseif CC.Enhancement and WarCheckSkill(eid,19) then --报复
 if math.random(100)<=JY.Person[War.Person[eid].id]["武力2"] then

--丈八蛇矛
local smfj=0
local smsh=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
if CC.Enhancement and WarCheckSkill(eid,107) then
smsh=1
end

if smsh==1 and smfj==1 then
 WarAtk(eid,id);
 WarResetStatus(id);
if JY.Person[War.Person[id].id]["兵力"]>0 then
 WarAtk(eid,id);
 WarResetStatus(id);
end
elseif smfj==1 then
 WarAtk(eid,id,1);
 WarResetStatus(id);
if JY.Person[War.Person[id].id]["兵力"]>0 then
 WarAtk(eid,id,1);
 WarResetStatus(id);
end
elseif smsh==1 then
 WarAtk(eid,id);
 WarResetStatus(id);
else
 WarAtk(eid,id,1);
 WarResetStatus(id);
end

if CC.Enhancement and WarCheckSkill(id,103) then
 WarAtk(id,eid,1);
 WarResetStatus(eid);
end

 end
 else
 if math.random(150)<=JY.Person[War.Person[eid].id]["武力2"] then

--丈八蛇矛
local smfj=0
local smsh=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
if CC.Enhancement and WarCheckSkill(eid,107) then
smsh=1
end

if smsh==1 and smfj==1 then
 WarAtk(eid,id);
 WarResetStatus(id);
if JY.Person[War.Person[id].id]["兵力"]>0 then
 WarAtk(eid,id);
 WarResetStatus(id);
end
elseif smfj==1 then
 WarAtk(eid,id,1);
 WarResetStatus(id);
if JY.Person[War.Person[id].id]["兵力"]>0 then
 WarAtk(eid,id,1);
 WarResetStatus(id);
end
elseif smsh==1 then
 WarAtk(eid,id);
 WarResetStatus(id);
else
 WarAtk(eid,id,1);
 WarResetStatus(id);
end

if CC.Enhancement and WarCheckSkill(id,103) then
 WarAtk(id,eid,1);
 WarResetStatus(eid);
end

 end
 end
 end
 end
end
end
 --
 War.ControlEnable=false;
 War.InMap=false;
 end
 
 wp.active=false;
 wp.action=0;
 WarResetStatus(id);
 WarCheckStatus();
 War.LastID=War.SelID;
 War.SelID=0;
 WarDelay(CC.WarDelay);
War.YD=0

if flag~=nil then
wp.ai=ccai
end

return did

end

--如果部队的兵力不足（即兵力小于最大兵力的40％或士气小于40，下同），则战场上存在可恢复地形的坐标，行动价值加50．
--基本值＝基本物理攻击杀伤＋攻击方当前兵力÷6
--物理攻击的行动价值＝基本值÷16．
--如果攻击的是仇人，基本值＝基本值＋30
--当部队处于有防御加成的地形时，行动价值＝行动价值＋防御加成÷5
function WarGetMoveValue(pid,x,y)
 local id1=War.Person[pid].id;
 local wp=War.Person[pid];
 local atkarray=WarGetAtkFW(x,y,War.Person[pid].atkfw);
 local dv=0;
 if wp.ai==5 or wp.ai==6 then
 dv=0;
 else
 for i=1,atkarray.num do
 if atkarray[i][1]>0 and atkarray[i][1]<=War.Width and atkarray[i][2]>0 and atkarray[i][2]<=War.Depth then
 local v=WarGetAtkValue(pid,atkarray[i][1],atkarray[i][2]);
 if v>0 then --远距攻击额外附加
 if i<=4 then
 --v=v+0;
 elseif i<=8 then
 v=v+2;
 elseif i<=16 then
 v=v+3;
 elseif i<=24 then
 v=v+4;
 end
 end
 if v>dv then
 dv=v;
 end
 end
 end
 local mv=WarGetMagicValue(pid,x,y);
 --if mv>0 then
 --策略系部队，如果物理攻击价值低于100，则为0（new）
 if wp.bz==13 or wp.bz==16 or wp.bz==19 then
 if dv<100 then
 dv=0;
 end
 end
 --end
 if mv>dv then
 dv=mv;
 end
 end
 local dx=GetWarMap(x,y,1);
 if dv>0 then
 --当部队处于有防御加成的地形时，行动价值＝行动价值＋防御加成÷5 --2.5
 if dx==1 then --可恢复地形 额外+5（自己新增的）
 dv=dv+8;
 elseif dx==2 then
 dv=dv+10;
 elseif dx==7 then
 dv=dv+2;
 elseif dx==8 then
 dv=dv+2+5;
 elseif dx==13 then
 dv=dv+12+5;
 elseif dx==14 then
 dv=dv+4+5;
 end
 --根据AI再附加
 if wp.ai==3 or wp.ai==5 then
 local eid=GetWarID(wp.aitarget);
 if eid>0 then
 local tx,ty=War.Person[eid].x,War.Person[eid].y;
 dv=dv+5*(wp.movestep-math.abs(tx-x)-math.abs(ty-y));
 end
 elseif wp.ai==4 or wp.ai==6 then
 local tx,ty=wp.ai_dx,wp.ai_dy;
 dv=dv+5*(wp.movestep-math.abs(tx-x)-math.abs(ty-y));
 end
 end
 --如果部队的兵力不足（即兵力小于最大兵力的40％或士气小于40，下同），则战场上存在可恢复地形的坐标，行动价值加50．
 if JY.Person[id1]["兵力"]/JY.Person[id1]["最大兵力"]<=0.4 or JY.Person[id1]["士气"]<=40 then
 if dx==8 or dx==13 or dx==14 then
 dv=dv+50;
 end
 end
 --新增的，mp不足时，靠近军乐队
 for d=1,4 do
 local sid=0;
 local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
 if between(nx,1,War.Width) and between(ny,1,War.Depth) then
 sid=GetWarMap(nx,ny,2);
 if sid>0 and sid~=pid then
 if War.Person[sid].enemy==wp.enemy and War.Person[sid].bz==13 then
 if JY.Person[id1]["策略"]/JY.Person[id1]["最大策略"]<=0.4 then
 dv=dv+10;
 break;
 end
 end
 end
 end
 end
 if wp.enemy then
 local ddv=GetWarMap(x,y,8);
 if wp.bz==13 or wp.bz==16 or wp.bz==19 then
 dv=dv-ddv;
 end
 end
 
 return dv;
end

function HaveMagic(pid,mid)
 local bz=JY.Person[pid]["兵种"];
 local lv=JY.Person[pid]["等级"];

if JY.Status~=GAME_WMAP then

 if between(mid,1,36) then
 if between(JY.Bingzhong[bz]["策略"..mid],1,lv) then
 return true;
 end
 end

else

local eid=0
local eid2=0
local eid3=0
local eid4=0
 local id=War.SelID
 local mx=War.Person[id].x;
 local my=War.Person[id].y;
if CC.Enhancement and WarCheckSkill(id,101) then --策略模仿
if GetWarMap(mx-1,my,2)>0 then --左
eid=GetWarMap(mx-1,my,2)
end
if GetWarMap(mx+1,my,2)>0 then --右
eid2=GetWarMap(mx+1,my,2)
end
if GetWarMap(mx,my-1,2)>0 then --上
eid3=GetWarMap(mx,my-1,2)
end
if GetWarMap(mx,my+1,2)>0 then --下
eid4=GetWarMap(mx,my+1,2)
end
end

 if between(mid,1,36) then
 if between(JY.Bingzhong[bz]["策略"..mid],1,lv) then
 return true;
 end

if eid>0 and between(JY.Bingzhong[JY.Person[eid]["兵种"]]["策略"..mid],1,lv) then
return true;
elseif eid2>0 and between(JY.Bingzhong[JY.Person[eid2]["兵种"]]["策略"..mid],1,lv) then
return true;
elseif eid3>0 and between(JY.Bingzhong[JY.Person[eid3]["兵种"]]["策略"..mid],1,lv) then
return true;
elseif eid4>0 and between(JY.Bingzhong[JY.Person[eid4]["兵种"]]["策略"..mid],1,lv) then
return true;
end
 end

end

 if CC.Enhancement then
 if mid==37 then
 if CheckSkill(pid,1) then
 if lv>=JY.Skill[1]["参数1"] then
 return true;
 end
 end
 elseif mid==38 then
 if CheckSkill(pid,1) then
 if lv>=JY.Skill[1]["参数2"] then
 return true;
 end
 end
 elseif mid==39 then
 if CheckSkill(pid,4) then
 if lv>=JY.Skill[4]["参数1"] then
 return true;
 end
 end
 elseif mid==40 then
 if CheckSkill(pid,3) then
 if lv>=JY.Skill[3]["参数1"] then
 return true;
 end
 end
 elseif mid==41 then
 if CheckSkill(pid,39) then
 if lv>=JY.Skill[39]["参数2"] then
 return true;
 end
 end
 elseif mid==42 then
 if CheckSkill(pid,39) then
 if lv>=JY.Skill[39]["参数3"] then
 return true;
 end
 end
 elseif mid==43 then
 if CheckSkill(pid,40) or CheckSkill(pid,5) then
 if lv>=JY.Skill[40]["参数1"] then
 return true;
 end
 end
 elseif mid==44 then
 if CheckSkill(pid,40) or CheckSkill(pid,5) then
 if lv>=JY.Skill[40]["参数2"] then
 return true;
 end
 end
 elseif mid==46 then
 if CheckSkill(pid,38) then
 if lv>=JY.Skill[38]["参数2"] then
 return true;
 end
 end
 end
 end
 return false;
end

function WarHaveMagic(wid,mid)
 local pid=War.Person[wid].id;
 return HaveMagic(pid,mid);
end

function WarGetMagicValue(pid,x,y)
 local dv=0;
 local dx,dy;
 local bz=War.Person[pid].bz;
 local id1=War.Person[pid].id;
 local lv=JY.Person[id1]["等级"];
 local ox,oy=War.Person[pid].x,War.Person[pid].y;
 War.Person[pid].x,War.Person[pid].y=x,y;
 SetWarMap(ox,oy,2,0);
 SetWarMap(x,y,2,pid);
 for mid=1,JY.MagicNum-1 do
 --if between(JY.Bingzhong[bz]["策略"..mid],1,lv) then
 if WarHaveMagic(pid,mid) then
 if JY.Person[id1]["策略"]>=JY.Magic[mid]["消耗"] then --mp enough?
 if true then --dx?
 local kind=JY.Magic[mid]["类型"];
 local fw=JY.Magic[mid]["施展范围"];
 local array=WarGetAtkFW(x,y,fw);
 for j=1,array.num do
 local mx,my=array[j][1],array[j][2];
 if between(mx,1,War.Width) and between(my,1,War.Depth) then
 local eid=GetWarMap(mx,my,2);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 if WarMagicCheck(pid,eid,mid) then --check dx
 if ((between(kind,1,5) or between(kind,9,10)) and War.Person[pid].enemy~=War.Person[eid].enemy) or
 (between(kind,6,8) and War.Person[pid].enemy==War.Person[eid].enemy) then
 local v,select_magic=WarGetMagicValue_sub(pid,mx,my);
 if v>dv and mid==select_magic then
 dv=v;
 dx,dy=mx,my;
 end
 end
 end
 end
 end
 end
 end
 end
 end
 end
 War.Person[pid].x,War.Person[pid].y=ox,oy;
 SetWarMap(x,y,2,0);
 SetWarMap(ox,oy,2,pid);
 return dv,dx,dy;
end

function WarGetMagicValue_sub(pid,x,y)
 local id1,id2;
 id1=War.Person[pid].id;
 local bz=War.Person[pid].bz;
 local lv=JY.Person[id1]["等级"];
 local oid=GetWarMap(x,y,2);
 local dv=GetWarMap(x,y,6);
 local select_magic=GetWarMap(x,y,7);
 local hp={600,1200,1800};
 local sp={30,40,50};
 if dv==-1 then
 dv=0;
 local v=0;
 for mid=1,JY.MagicNum-1 do
 --if between(JY.Bingzhong[bz]["策略"..mid],1,lv) then
 if WarHaveMagic(pid,mid) then
 if JY.Person[id1]["策略"]>=JY.Magic[mid]["消耗"] then --mp enough?
 if oid>0 and War.Person[oid].live and (not War.Person[oid].hide) then
 if WarMagicCheck(pid,oid,mid) then --地形，天气
 local kind=JY.Magic[mid]["类型"];
 local power=JY.Magic[mid]["效果"];
 local fw=JY.Magic[mid]["效果范围"];
 if between(kind,1,3) or between(kind,9,10) then --火水石/毒雷
 v=0;
 if War.Person[pid].enemy~=War.Person[oid].enemy then
 local array=WarGetAtkFW(x,y,fw);
 for j=1,array.num do
 local dx,dy=array[j][1],array[j][2];
 if between(dx,1,War.Width) and between(dy,1,War.Depth) then
 local eid=GetWarMap(dx,dy,2);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 if War.Person[pid].enemy~=War.Person[eid].enemy and WarMagicCheck(pid,eid,mid) then
 local hurt=WarMagicHurt(pid,eid,mid);
 if hurt>=JY.Person[War.Person[eid].id]["兵力"] then
 hurt=hurt*10;
 end
 if math.random()<WarMagicHitRatio(pid,eid,mid)+0.2 then
 v=v+hurt;
 else
 v=v+hurt/4;
 end

 end
 end
 end
 end
 end
 elseif kind==4 then --假情报
 v=0;
 --如果敌人已混乱，加权值＝0
 --随机值＝（0～299）的随机数
 --根据假情报系策略全分析中的算法计算策略是否成功，如果计算结果是策略成功，加权值＝随机数＋300。
 local eid=GetWarMap(x,y,2);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) and (not War.Person[eid].troubled) then
 if War.Person[pid].enemy~=War.Person[eid].enemy then
 v=math.random(300)-1;
 if math.random()<WarMagicHitRatio(pid,eid,mid) then
 v=v+300;
 end
 end
 end
 elseif kind==5 then --牵制
 v=0;
 local eid=GetWarMap(x,y,2);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 if War.Person[pid].enemy~=War.Person[eid].enemy then
 if math.random()<WarMagicHitRatio(pid,eid,mid)+0.2 then
 id2=War.Person[eid].id;
 --基本值＝策略基本威力＋使用者等级÷10－被牵制者等级÷10
 --随机值＝1～10的随机数
 --加权值＝基本值×随机数
 v=power+lv/10-JY.Person[id2]["等级"]/10;
 v=limitX(v,0,JY.Person[id2]["士气"])
 local add=math.random(10);
 v=math.modf(v*add);
 end
 end
 end
 elseif kind==6 then --激励
 v=0;
 if War.Person[pid].enemy==War.Person[oid].enemy then
 local array=WarGetAtkFW(x,y,fw);
 for j=1,array.num do
 local dx,dy=array[j][1],array[j][2];
 if between(dx,1,War.Width) and between(dy,1,War.Depth) then
 local eid=GetWarMap(dx,dy,2);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 if War.Person[pid].enemy==War.Person[eid].enemy then
 id2=War.Person[eid].id;
 --基本值＝策略基本威力＋使用者等级÷10
 --随机值＝0～（基本值÷10－1）之间的随机数
 --激励值＝基本值＋随机值
 local sv=power+lv/10;
 sv=math.modf(sv*(1+math.random()/10));
 sv=limitX(sv,0,War.Person[oid].sq_limited-JY.Person[id2]["士气"]);
 if sv<10 then
 sv=0;
 end
 if JY.Person[id2]["士气"]<40 then
 sv=sv*20;
 end
 v=v+sv;
 end
 end
 end
 end
 end
 elseif kind==7 then --援助
 v=0;
 if War.Person[pid].enemy==War.Person[oid].enemy then
 local array=WarGetAtkFW(x,y,fw);
 for j=1,array.num do
 local dx,dy=array[j][1],array[j][2];
 if between(dx,1,War.Width) and between(dy,1,War.Depth) then
 local eid=GetWarMap(dx,dy,2);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 if War.Person[pid].enemy==War.Person[eid].enemy then
 id2=War.Person[eid].id;
 --策略基本威力＋使用者智力×使用者等级÷20
 --随机值＝0～（基本值÷10－1）之间的随机数
 --补给值＝基本值＋随机值
 local sv=power+JY.Person[id1]["智力2"]*lv/20;
 sv=math.modf(sv*(1+math.random()/10));
 sv=limitX(sv,0,JY.Person[id2]["最大兵力"]-JY.Person[id2]["兵力"]);
 if sv<JY.Person[id2]["最大兵力"]/10 then
 sv=0;
 end
 v=v+sv;
 end
 end
 end
 end
 end
 if v/JY.Magic[mid]["消耗"]<50 then
 v=0;
 end
 elseif kind==8 then --看护
 v=0;
 if War.Person[pid].enemy==War.Person[oid].enemy then
 local array=WarGetAtkFW(x,y,fw);
 for j=1,array.num do
 local dx,dy=array[j][1],array[j][2];
 local eid=GetWarMap(dx,dy,2);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 if War.Person[pid].enemy==War.Person[eid].enemy then
 id2=War.Person[eid].id;
 local sv=hp[power]+JY.Person[id1]["智力2"]*lv/20;
 sv=math.modf(sv*(1+math.random()/10));
 sv=limitX(sv,0,JY.Person[id2]["最大兵力"]-JY.Person[id2]["兵力"]);
 if sv<JY.Person[id2]["最大兵力"]/10 then
 sv=0;
 end
 v=v+sv;
 
 sv=sp[power]+lv/10;
 sv=math.modf(sv*(1+math.random()/10));
 sv=limitX(sv,0,War.Person[oid].sq_limited-JY.Person[id2]["士气"]);
 if sv<10 then
 sv=0;
 end
 if JY.Person[id2]["士气"]<40 then
 sv=sv*20;
 end
 v=v+sv;
 if v<400 then
 v=0;
 end
 end
 end
 end
 end
 end
 end
 v=math.modf(v/(JY.Magic[mid]["消耗"]+12));
 if v>dv then
 dv=v;
 select_magic=mid;
 end
 end
 end
 end
 end
 SetWarMap(x,y,6,dv);
 SetWarMap(x,y,7,select_magic);
 end
 return dv,select_magic;
end

function WarGetAtkValue(pid,x,y)
 local id1,id2;
 id1=War.Person[pid].id;
 local bz=War.Person[pid].bz;
 local v=GetWarMap(x,y,5);
 if v==-1 then
 v=0;
 local eid=GetWarMap(x,y,2);
 if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
 if War.Person[pid].enemy~=War.Person[eid].enemy then
 id2=War.Person[eid].id;
 v=WarAtkHurt(pid,eid,0);
 if v>=JY.Person[id2]["兵力"] then --一击必杀额外附加
 v=v+1600;
 elseif JY.Person[id2]["兵力"]<JY.Person[id2]["最大兵力"]/2 then --敌军军力低时按兵力附加
 v=v+math.modf((JY.Person[id2]["最大兵力"]-JY.Person[id2]["兵力"])/6)
 end
 --v=v+math.modf(JY.Person[id1]["兵力"]/6);
 --行动价值＝基本值÷16．
 v=math.modf(v/16);
 --如果攻击的是仇人，行动价值＝行动价值＋30
 if id2==War.Person[pid].aitarget then
 v=v+30;
 end
 --如果攻击的是主将，行动价值=行动价值+?
 if War.Person[eid].leader then
 v=v+16;
 end
 end
 end
 SetWarMap(x,y,5,v);
 end
 return v;
end

function WarGetAtkFW(x,y,fw)
 local atkarray={};
 if fw==1 then --短兵
 --1
 table.insert(atkarray,{x,y+1});
 table.insert(atkarray,{x,y-1});
 table.insert(atkarray,{x+1,y});
 table.insert(atkarray,{x-1,y});
 
 atkarray.num=4;
 elseif fw==2 then --长兵
 --1
 table.insert(atkarray,{x,y+1});
 table.insert(atkarray,{x,y-1});
 table.insert(atkarray,{x+1,y});
 table.insert(atkarray,{x-1,y});
 --2
 table.insert(atkarray,{x+1,y+1});
 table.insert(atkarray,{x+1,y-1});
 table.insert(atkarray,{x-1,y+1});
 table.insert(atkarray,{x-1,y-1});
 
 atkarray.num=8;
 elseif fw==3 then --弓兵
 --1
 table.insert(atkarray,{x+1,y+1});
 table.insert(atkarray,{x+1,y-1});
 table.insert(atkarray,{x-1,y+1});
 table.insert(atkarray,{x-1,y-1});
 --2
 table.insert(atkarray,{x,y+2});
 table.insert(atkarray,{x,y-2});
 table.insert(atkarray,{x+2,y});
 table.insert(atkarray,{x-2,y});
 
 atkarray.num=8;
 elseif fw==4 then --弩兵
 --1
 table.insert(atkarray,{x+1,y+1});
 table.insert(atkarray,{x+1,y-1});
 table.insert(atkarray,{x-1,y+1});
 table.insert(atkarray,{x-1,y-1});
 --2
 table.insert(atkarray,{x,y+2});
 table.insert(atkarray,{x,y-2});
 table.insert(atkarray,{x+2,y});
 table.insert(atkarray,{x-2,y});
 --3
 table.insert(atkarray,{x-1,y+2});
 table.insert(atkarray,{x-1,y-2});
 table.insert(atkarray,{x+2,y-1});
 table.insert(atkarray,{x-2,y-1});
 
 table.insert(atkarray,{x+1,y+2});
 table.insert(atkarray,{x+1,y-2});
 table.insert(atkarray,{x+2,y+1});
 table.insert(atkarray,{x-2,y+1});
 
 atkarray.num=16;
 elseif fw==5 then --连弩兵
 --1
 table.insert(atkarray,{x+1,y+1});
 table.insert(atkarray,{x+1,y-1});
 table.insert(atkarray,{x-1,y+1});
 table.insert(atkarray,{x-1,y-1});
 --2
 table.insert(atkarray,{x,y+2});
 table.insert(atkarray,{x,y-2});
 table.insert(atkarray,{x+2,y});
 table.insert(atkarray,{x-2,y});
 --3
 table.insert(atkarray,{x-1,y+2});
 table.insert(atkarray,{x-1,y-2});
 table.insert(atkarray,{x+2,y-1});
 table.insert(atkarray,{x-2,y-1});
 
 table.insert(atkarray,{x+1,y+2});
 table.insert(atkarray,{x+1,y-2});
 table.insert(atkarray,{x+2,y+1});
 table.insert(atkarray,{x-2,y+1});
 --4
 table.insert(atkarray,{x+2,y+2});
 table.insert(atkarray,{x+2,y-2});
 table.insert(atkarray,{x-2,y+2});
 table.insert(atkarray,{x-2,y-2});
 
 table.insert(atkarray,{x,y+3});
 table.insert(atkarray,{x,y-3});
 table.insert(atkarray,{x+3,y});
 table.insert(atkarray,{x-3,y});
 
 atkarray.num=24;
 elseif fw==6 then --投石车
 --2
 table.insert(atkarray,{x+1,y+1});
 table.insert(atkarray,{x+1,y-1});
 table.insert(atkarray,{x-1,y+1});
 table.insert(atkarray,{x-1,y-1});
 table.insert(atkarray,{x,y+2});
 table.insert(atkarray,{x+2,y});
 table.insert(atkarray,{x,y-2});
 table.insert(atkarray,{x-2,y});
 --3
 table.insert(atkarray,{x,y+3});
 table.insert(atkarray,{x+1,y+2});
 table.insert(atkarray,{x+2,y+1});
 
 table.insert(atkarray,{x+3,y});
 table.insert(atkarray,{x+2,y-1});
 table.insert(atkarray,{x+1,y-2});
 
 table.insert(atkarray,{x,y-3});
 table.insert(atkarray,{x-1,y+2});
 table.insert(atkarray,{x-2,y-1});
 
 table.insert(atkarray,{x-3,y});
 table.insert(atkarray,{x-2,y+1});
 table.insert(atkarray,{x-1,y-2});
 --4
 table.insert(atkarray,{x,y+4});
 table.insert(atkarray,{x+1,y+3});
 table.insert(atkarray,{x+2,y+2});
 table.insert(atkarray,{x+3,y+1});
 
 table.insert(atkarray,{x+4,y});
 table.insert(atkarray,{x+3,y-1});
 table.insert(atkarray,{x+2,y-2});
 table.insert(atkarray,{x+1,y-3});
 
 table.insert(atkarray,{x,y-4});
 table.insert(atkarray,{x-1,y-3});
 table.insert(atkarray,{x-2,y-2});
 table.insert(atkarray,{x-3,y-1});
 
 table.insert(atkarray,{x-4,y});
 table.insert(atkarray,{x-3,y+1});
 table.insert(atkarray,{x-2,y+2});
 table.insert(atkarray,{x-1,y+3});
 
 atkarray.num=36;
 elseif fw==7 then --突骑兵
 --1
 table.insert(atkarray,{x,y+1});
 table.insert(atkarray,{x,y-1});
 table.insert(atkarray,{x+1,y});
 table.insert(atkarray,{x-1,y});
 --2
 table.insert(atkarray,{x+1,y+1});
 table.insert(atkarray,{x+1,y-1});
 table.insert(atkarray,{x-1,y+1});
 table.insert(atkarray,{x-1,y-1});
 --2
 table.insert(atkarray,{x,y+2});
 table.insert(atkarray,{x,y-2});
 table.insert(atkarray,{x+2,y});
 table.insert(atkarray,{x-2,y});
 atkarray.num=12;
 elseif fw==8 then --米字
for i=1,2 do
table.insert(atkarray,{x-i,y});
table.insert(atkarray,{x+i,y});
table.insert(atkarray,{x,y-i});
table.insert(atkarray,{x,y+i});
table.insert(atkarray,{x-i,y-i});
table.insert(atkarray,{x+i,y-i});
table.insert(atkarray,{x-i,y+i});
table.insert(atkarray,{x+i,y+i});
end
 atkarray.num=16
 elseif fw==11 then --原地 -- 11~20 策略专用
 table.insert(atkarray,{x,y});
 atkarray.num=1;
 elseif fw==12 then --五格
 table.insert(atkarray,{x,y});
 --1
 table.insert(atkarray,{x,y+1});
 table.insert(atkarray,{x,y-1});
 table.insert(atkarray,{x+1,y});
 table.insert(atkarray,{x-1,y});
 
 atkarray.num=5;
 elseif fw==13 then --八格
 --1
 table.insert(atkarray,{x,y+1});
 table.insert(atkarray,{x,y-1});
 table.insert(atkarray,{x+1,y});
 table.insert(atkarray,{x-1,y});
 --2
 table.insert(atkarray,{x+1,y+1});
 table.insert(atkarray,{x+1,y-1});
 table.insert(atkarray,{x-1,y+1});
 table.insert(atkarray,{x-1,y-1});
 
 atkarray.num=8;
 elseif fw==14 then --九格
 table.insert(atkarray,{x,y});
 --1
 table.insert(atkarray,{x,y+1});
 table.insert(atkarray,{x,y-1});
 table.insert(atkarray,{x+1,y});
 table.insert(atkarray,{x-1,y});
 --2
 table.insert(atkarray,{x+1,y+1});
 table.insert(atkarray,{x+1,y-1});
 table.insert(atkarray,{x-1,y+1});
 table.insert(atkarray,{x-1,y-1});
 
 atkarray.num=9;
 elseif fw==15 then --十二格
 --1
 table.insert(atkarray,{x,y+1});
 table.insert(atkarray,{x,y-1});
 table.insert(atkarray,{x+1,y});
 table.insert(atkarray,{x-1,y});
 --2
 table.insert(atkarray,{x+1,y+1});
 table.insert(atkarray,{x+1,y-1});
 table.insert(atkarray,{x-1,y+1});
 table.insert(atkarray,{x-1,y-1});
 --2
 table.insert(atkarray,{x,y+2});
 table.insert(atkarray,{x,y-2});
 table.insert(atkarray,{x+2,y});
 table.insert(atkarray,{x-2,y});
 
 atkarray.num=12;
 elseif fw==16 then --十三格
 table.insert(atkarray,{x,y});
 --1
 table.insert(atkarray,{x,y+1});
 table.insert(atkarray,{x,y-1});
 table.insert(atkarray,{x+1,y});
 table.insert(atkarray,{x-1,y});
 --2
 table.insert(atkarray,{x+1,y+1});
 table.insert(atkarray,{x+1,y-1});
 table.insert(atkarray,{x-1,y+1});
 table.insert(atkarray,{x-1,y-1});
 --2
 table.insert(atkarray,{x,y+2});
 table.insert(atkarray,{x,y-2});
 table.insert(atkarray,{x+2,y});
 table.insert(atkarray,{x-2,y});
 
 atkarray.num=13;
 elseif fw==17 then --二十格
 --1
 table.insert(atkarray,{x,y+1});
 table.insert(atkarray,{x,y-1});
 table.insert(atkarray,{x+1,y});
 table.insert(atkarray,{x-1,y});
 --1
 table.insert(atkarray,{x+1,y+1});
 table.insert(atkarray,{x+1,y-1});
 table.insert(atkarray,{x-1,y+1});
 table.insert(atkarray,{x-1,y-1});
 --2
 table.insert(atkarray,{x,y+2});
 table.insert(atkarray,{x,y-2});
 table.insert(atkarray,{x+2,y});
 table.insert(atkarray,{x-2,y});
 --3
 table.insert(atkarray,{x-1,y+2});
 table.insert(atkarray,{x-1,y-2});
 table.insert(atkarray,{x+2,y-1});
 table.insert(atkarray,{x-2,y-1});
 
 table.insert(atkarray,{x+1,y+2});
 table.insert(atkarray,{x+1,y-2});
 table.insert(atkarray,{x+2,y+1});
 table.insert(atkarray,{x-2,y+1});
 
 atkarray.num=20;
 elseif fw==18 then --二十一格
 table.insert(atkarray,{x,y});
 --1
 table.insert(atkarray,{x,y+1});
 table.insert(atkarray,{x,y-1});
 table.insert(atkarray,{x+1,y});
 table.insert(atkarray,{x-1,y});
 --1
 table.insert(atkarray,{x+1,y+1});
 table.insert(atkarray,{x+1,y-1});
 table.insert(atkarray,{x-1,y+1});
 table.insert(atkarray,{x-1,y-1});
 --2
 table.insert(atkarray,{x,y+2});
 table.insert(atkarray,{x,y-2});
 table.insert(atkarray,{x+2,y});
 table.insert(atkarray,{x-2,y});
 --3
 table.insert(atkarray,{x-1,y+2});
 table.insert(atkarray,{x-1,y-2});
 table.insert(atkarray,{x+2,y-1});
 table.insert(atkarray,{x-2,y-1});
 
 table.insert(atkarray,{x+1,y+2});
 table.insert(atkarray,{x+1,y-2});
 table.insert(atkarray,{x+2,y+1});
 table.insert(atkarray,{x-2,y+1});
 
 atkarray.num=21;
 elseif fw==19 then
 atkarray.num=0;
 elseif fw==20 then
 atkarray.num=0;
 elseif fw==21 then --选择我方，附近8格
 --1
 table.insert(atkarray,{x,y+1});
 table.insert(atkarray,{x,y-1});
 table.insert(atkarray,{x+1,y});
 table.insert(atkarray,{x-1,y});
 --2
 table.insert(atkarray,{x+1,y+1});
 table.insert(atkarray,{x+1,y-1});
 table.insert(atkarray,{x-1,y+1});
 table.insert(atkarray,{x-1,y-1});
 
 atkarray.num=8;
 elseif fw==22 then --选择我方，附近9格
 table.insert(atkarray,{x,y});
 --1
 table.insert(atkarray,{x,y+1});
 table.insert(atkarray,{x,y-1});
 table.insert(atkarray,{x+1,y});
 table.insert(atkarray,{x-1,y});
 --2
 table.insert(atkarray,{x+1,y+1});
 table.insert(atkarray,{x+1,y-1});
 table.insert(atkarray,{x-1,y+1});
 table.insert(atkarray,{x-1,y-1});
 
 atkarray.num=9;
 else
 atkarray.num=0;
 end
 return atkarray;
end

function WarSetAtkFW(id,fw)
 local mx=War.Person[id].x;
 local my=War.Person[id].y;
 local atkarray=WarGetAtkFW(mx,my,fw);
 CleanWarMap(4,0);
 for i=1,atkarray.num do
 if between(atkarray[i][1],1,War.Width) and between(atkarray[i][2],1,War.Depth) then
 SetWarMap(atkarray[i][1],atkarray[i][2],4,1);
 end
 end
end

function CheckActive()
 --我方全部行动完毕?
 if JY.Status~=GAME_WMAP then --当游戏状态改变时，直接结束我方操作
 return true;
 end
 for i,v in pairs(War.Person) do
 if v.live and (not v.hide) and (not v.enemy) and (not v.friend) and v.active and (not v.troubled) then --任意一人可行动，则返回
 return false;
 end
 end
 War.ControlStatus='DrawStrBoxYesorNo';
 if WarDrawStrBoxYesNo("结束所有部队的命令吗？",C_WHITE) then
 return true;
 else
 return false;
 end
 
end
function WarCheckStatus()
 
 if JY.Status==GAME_WMAP then
 --敌方失败？
 local enum=0;
 for i,v in pairs(War.Person) do
 if v.enemy then
 if v.live then--and (not v.hide) then
 enum=enum+1
 end
 end
 if v.leader and (not v.live) then
 if v.enemy then
 JY.Status=GAME_WARWIN;
 break;
 else
 JY.Status=GAME_WARLOSE;
 break;
 end
 end
 end
 if enum==0 and JY.Status==GAME_WMAP then
 JY.Status=GAME_WARWIN;
 end
 War.ControlEnableOld=War.ControlEnable;
 War.ControlEnable=false;
 War.InMap=false;
 if DoEvent(JY.EventID) then
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN then
 DoEvent(JY.EventID);
 end
 end
 War.ControlEnable=War.ControlEnableOld;
 end
end
----------------------------------------------------------------
-- WarDelay(n)
-- 延时，并刷新战场
-- n默认为1
----------------------------------------------------------------
function WarDelay(n)
 n=n or 1;
 for i=1,n do
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap(War.CX,War.CY);
 lib.GetKey();
 ReFresh();
 end
end
function WarPersonCenter(id)
 if id<1 or id>War.PersonNum then
 return false;
 end
 if War.Person[id].live==false then
 return false;
 end
 War.SelID=id;
 BoxBack();
 --WarDelay(CC.WarDelay);
 War.LastID=War.SelID;
 War.SelID=0;
 return true;
end
function WarRest()
--人物处于恢复性地形或持有恢复性宝物，可以触发自动恢复．
--村庄、鹿砦可以恢复士气和兵力．兵营可以恢复兵力，但不能恢复士气．
--玉玺可以恢复兵力和士气，援军报告可以恢复兵力，赦命书可以恢复士气．
--地形和宝物的恢复能力不能叠加
 for i,v in pairs(War.Person) do
 if v.live and (not v.hide) then
 local hp,sp=0,0;
 local hp_times=0;
 local sp_times=0;
 local hp_item_flag=false;
 local sp_item_flag=false;
 local hp_skill_flag=false;
 local sp_skill_flag=false;
 for index=1,8 do
 local tid=JY.Person[v.id]["道具"..index];
 if JY.Item[tid]["类型"]==7 then
 if JY.Item[tid]["效果"]==1 then
 hp_item_flag=true;
 elseif JY.Item[tid]["效果"]==2 then
 sp_item_flag=true;
 elseif JY.Item[tid]["效果"]==3 then
 hp_item_flag=true;
 sp_item_flag=true;
 end
 end
 end
 if CC.Enhancement then
 if WarCheckSkill(i,22) then --治疗
 hp_skill_flag=true;
 end
 end
 local dx=GetWarMap(v.x,v.y,1);
 --08 村庄 0D 鹿砦 0E 兵营
 if dx==8 or dx==13 then
 hp_times=hp_times+1;
 sp_times=sp_times+1;
 elseif dx==14 then
 hp_times=hp_times+1;
 end
 if hp_item_flag then
 hp_times=hp_times+1;
 end
 if sp_item_flag then
 sp_times=sp_times+1;
 end
 if hp_skill_flag then
 hp_times=hp_times+1;
 end
 if sp_skill_flag then
 sp_times=sp_times+1;
 end
 if hp_times>0 then
 --兵力的自动恢复量＝150＋（0～10之间的随机数）×10
 hp=150+(math.random(11)-1)*10;

 --修改为自身兵力的10%-20%
if CC.Enhancement then
 hp=math.max(150+(math.random(11)-1)*10,math.modf(JY.Person[v.id]["最大兵力"]/1000*(math.modf(JY.Person[v.id]["统率2"]/10)+1+math.random(10)))*10);
end

 --当兵力恢复后离最大兵力的差距不足10时，系统将自动补满该差距
 hp=hp*hp_times;
 if JY.Person[v.id]["最大兵力"]-JY.Person[v.id]["兵力"]-hp<9 then
 hp=JY.Person[v.id]["最大兵力"]-JY.Person[v.id]["兵力"];
 end
 end
 if sp_times>0 then
 --士气的自动恢复量＝统御力÷10＋（1～5之间的随机数）
 sp=math.modf(JY.Person[v.id]["统率2"]/10)+math.random(5);
 --与兵力恢复相仿，士气恢复后超过90时，系统将自动不满士气
 sp=sp*sp_times;
 if v.sq_limited-JY.Person[v.id]["士气"]-sp<9 then
 sp=v.sq_limited-JY.Person[v.id]["士气"];
 end
 end
 if hp>0 or sp>0 then
 --
 War.MX=v.x;
 War.MY=v.y;
 War.CX=War.MX-math.modf(War.MW/2);
 War.CY=War.MY-math.modf(War.MD/2);
 War.CX=limitX(War.CX,1,War.Width-War.MW+1);
 War.CY=limitX(War.CY,1,War.Depth-War.MD+1);
 WarDelay(16);
 --
 local tmax=16;
 tmax=math.min(16,(math.modf(math.max(2,math.abs(hp)/50,math.abs(sp)))));
 local oldbl=JY.Person[v.id]["兵力"];
 local oldsq=JY.Person[v.id]["士气"];
 for t=0,tmax do
 JY.ReFreshTime=lib.GetTime();
 JY.Person[v.id]["兵力"]=oldbl+hp*t/tmax;
 JY.Person[v.id]["士气"]=oldsq+sp*t/tmax;
 DrawWarMap();
 DrawStatusMini(i);
 lib.GetKey();
 ReFresh();
 end
 JY.ReFreshTime=lib.GetTime();
 ReFresh(CC.OpearteSpeed*4);
 WarDelay(4);
 end
 --策略值的自动恢复．
 --部队位于军乐队旁边可以自动恢复策略值，恢复量＝每军乐队（等级÷10）点．
 if v.bz==13 then
 for d=1,4 do
 local x,y=v.x+CC.DirectX[d],v.y+CC.DirectY[d];
 if between(x,1,War.Width) and between(y,1,War.Depth) then
 local eid=GetWarMap(x,y,2);
 if eid>0 then
 if (not War.Person[eid].hide) and War.Person[eid].live then
 local pid=War.Person[eid].id;
 JY.Person[pid]["策略"]=limitX(JY.Person[pid]["策略"]+math.modf(1+JY.Person[v.id]["等级"]/10),0,JY.Person[pid]["最大策略"]);
 end
 end
 end
 end
 end
 if CC.Enhancement then
 if WarCheckSkill(i,35) then --百出
 JY.Person[v.id]["策略"]=limitX(JY.Person[v.id]["策略"]+math.modf(1+JY.Person[v.id]["等级"]*JY.Skill[35]["参数1"]/100),0,JY.Person[v.id]["最大策略"]);
 end
 end
 --自动唤醒．
 --每回合系统将试图唤醒混乱中的部队，混乱中部队恢复正常状态的算法如下：
 --恢复因子＝0～99的随机数，如果恢复因子小于（统御力＋士气）÷3，那么部队被唤醒．由此看出，统御越高，士气越高，越容易从混乱中苏醒．
 --注意：自动唤醒的判定是再自动恢复后进行的，因此是以恢复后的士气为准．
 WarTroubleShooting(i);
 WarResetStatus(i);
 end
 end
end

function ESCMenu()
 PlayWavE(0);
 --lib.PicLoadCache(4,58*2,)
 --回合结束 全军撤退 胜利条件 部队战斗 背景音乐 音效 游戏结束
 local menu={
 {"回合结束",nil,1},
 {"全军委任",nil,1},
 {"胜利条件",nil,1},
 {"功能设定",nil,1},
 {"策略动画",nil,0},
 {"移动速度",nil,0},
 {"　载入",nil,1},
 {"　储存",nil,1},
 {"游戏结束",nil,1},
 {"　Debug ",nil,0},
 }

local file = io.open(CONFIG.CurrentPath .. "Menu.debug");
if(file) then
 menu[10][3]=1;
end

 local r=WarShowMenu(menu,10,0,64,64,0,0,1,1,16,C_WHITE,C_WHITE);
 WarDelay(CC.WarDelay);
 if r==1 then
 return WarDrawStrBoxYesNo("结束所有部队的命令吗？",C_WHITE);
 elseif r==2 then
 if WarDrawStrBoxYesNo("委任剩余部队本回合的命令吗？",C_WHITE) then
 for i,v in pairs(War.Person) do
 if JY.Status~=GAME_WMAP then
 return;
 end
 local dx=GetWarMap(v.x,v.y,1);
 if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and (not v.friend) and v.active then
 War.ControlEnable=false;
 War.InMap=false;
 AI_Sub(i);
 end
 end
 return true;
 end
 elseif r==3 then
 WarShowTarget();
 elseif r==4 then
 if CONFIG.PC then
 SettingMenu2();
 else
 SettingMenu();
 end 
 elseif r==5 then
 if WarDrawStrBoxYesNo('观看策略动画吗？',C_WHITE) then
 CC.cldh=1
 else
 CC.cldh=0
 end
 elseif r==6 then
 if WarDrawStrBoxYesNo('加速部队移动吗？',C_WHITE) then
 CC.MoveSpeed=1;
 else
 CC.MoveSpeed=0;
 end
 elseif r==7 then --载入
 local menu2={
 {" 1. ",nil,1},
 {" 2. ",nil,1},
 {" 3. ",nil,1},
 {" 4. ",nil,1},
 {" 5. ",nil,1},
 }
 for id=1,5 do
 if not fileexist(CC.R_GRPFilename[id]) then
 menu2[id][1]=menu2[id][1].."未使用档案";
 else
 menu2[id][1]=menu2[id][1]..GetRecordInfo(id);
 end
 end
 DrawYJZBox2(-1,136,"请选择将载入的档案",C_WHITE);
 local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,C_WHITE,C_WHITE);
 if between(s2,1,5) then
 if string.sub(menu2[s2][1],5)~="未使用档案" then
 if WarDrawStrBoxYesNo(string.format("载入在硬碟的第%d进度，可以吗？",s2),C_WHITE) then
 LoadRecord(s2);

 if JY.Base["游戏模式"]==1 then
CC.Enhancement=true
 else
CC.Enhancement=false
 end

 end
 else
 WarDrawStrBoxConfirm("没有数据",C_WHITE,true);
 end
 end
 elseif r==8 then --储存
 local menu2={
 {" 1. ",nil,1},
 {" 2. ",nil,1},
 {" 3. ",nil,1},
 {" 4. ",nil,1},
 {" 5. ",nil,1},
 }
 for id=1,5 do
 if not fileexist(CC.R_GRPFilename[id]) then
 menu2[id][1]=menu2[id][1].."未使用档案";
 else
 menu2[id][1]=menu2[id][1]..GetRecordInfo(id);
 end
 end
 DrawYJZBox2(-1,136,"将档案储存在哪里？",C_WHITE);
 local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,C_WHITE,C_WHITE);
 if between(s2,1,5) then
 if WarDrawStrBoxYesNo(string.format("储存在硬碟的第%d号，可以吗？",s2),C_WHITE) then
 WarSave(s2);
 end
 end
 elseif r==9 then
 if WarDrawStrBoxYesNo('结束游戏吗？',C_WHITE) then
 WarDelay(CC.WarDelay);
 if WarDrawStrBoxYesNo('再玩一次吗？',C_WHITE) then
 WarDelay(CC.WarDelay);
 JY.Status=GAME_START;
 else
 WarDelay(CC.WarDelay);
 JY.Status=GAME_END;
 end
 end
 elseif r==10 then

 local menu2={
 {" AI查看",nil,1},
 {"坐标查看",nil,1},
 {"人物调试",nil,1},
 {"重置回合",nil,1},
 {"控制全体",nil,1},
 {"无限行动",nil,1},
 {"改变天气",nil,1},
 }
local s=WarShowMenu(menu2,#menu2,0,300,128,0,0,1,1,16,C_WHITE,C_WHITE);
 WarDelay(CC.WarDelay);

if s==1 then --AI查看
if CC.AIXS==false then
CC.AIXS=true
WarDrawStrBoxWaitKey('开启AI行动方针显示．',C_WHITE)
elseif CC.AIXS==true then
CC.AIXS=false
WarDrawStrBoxWaitKey('关闭AI行动方针显示．',C_WHITE)
end

elseif s==2 then --坐标查看
if CC.XYXS==false then
CC.XYXS=true
WarDrawStrBoxWaitKey('开启坐标显示．',C_WHITE)
elseif CC.XYXS==true then
CC.XYXS=false
WarDrawStrBoxWaitKey('关闭坐标显示．',C_WHITE)
end

elseif s==3 then --人物调试
if CC.RWTS==false then
CC.RWTS=true
WarDrawStrBoxWaitKey('开启人物调试．',C_WHITE)
elseif CC.RWTS then
CC.RWTS=false
WarDrawStrBoxWaitKey('关闭人物调试．',C_WHITE)
end

elseif s==4 then --回合重置

local hhs={}

for hhxh=1,War.MaxTurn do
hhs[hhxh]={fillblank("第"..hhxh.."回合",11),nil,1}
end

local hh=ShowMenu(hhs,#hhs,8,0,0,0,0,6,1,16,C_WHITE,C_WHITE);
 if hh>0 then
War.Turn=hh
WarDrawStrBoxWaitKey('回合数已设置为'..hh,C_WHITE)
end

elseif s==5 then --控制全体
if CC.KZAI==false then
CC.KZAI=true
WarDrawStrBoxWaitKey('可操控友军和敌军．',C_WHITE)
elseif CC.KZAI==true then
CC.KZAI=false
WarDrawStrBoxWaitKey('关闭操控友军和敌军功能．',C_WHITE)
end

elseif s==6 then --无限行动
if CC.WXXD==false then
CC.WXXD=true
WarDrawStrBoxWaitKey('开启无限行动功能．',C_WHITE)
elseif CC.WXXD==true then
CC.WXXD=false
WarDrawStrBoxWaitKey('关闭无限行动功能．',C_WHITE)
end

elseif s==7 then
local tqmenu={
 {"　 晴",nil,1},
 {"　 雲",nil,1},
 {"　 雨",nil,1},
 };
local tq=ShowMenu(tqmenu,#tqmenu,0,0,0,0,0,1,1,16,C_WHITE,C_WHITE);
 if tq==1 then
 War.Weather=math.random(3)-1
WarDrawStrBoxWaitKey('现在是晴天．',C_WHITE)
 elseif tq==2 then
 War.Weather=3
WarDrawStrBoxWaitKey('现在是阴天．',C_WHITE)
 elseif tq==3 then
 War.Weather=math.random(2)+3
WarDrawStrBoxWaitKey('现在是雨天．',C_WHITE)
 end




end

 end
 
 return false;
end

function SettingMenu()
 local x,y,w,h;
 local size=16;
 w=320;
 h=128+64;
 local notWar=true;
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 x=16+(576-0)/2;
 y=32+(432-0)/2;
 notWar=false;
 elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 x=16+(640-0)/2;
 y=16+(400-0)/2;
 notWar=true;
 else
 x=(CC.ScreenW-0)/2;
 y=(CC.ScreenH-0)/2;
 notWar=true;
 end
 x=x-w/2;
 y=y-h/2;
 local x1=x+254
 local x2=x1+52
 local y1=y+92+64;
 local y2=y1+24;
 
 local function button(bx,by,str,flag)
 local box_w=36;
 local box_h=18;
 local cx=bx;
 local cy=by-1;
 if flag then --selected
 lib.Background(cx+1,cy+1,cx+box_w,cy+box_h,128,C_BLACK);
 lib.DrawRect(cx,cy,cx+box_w,cy,C_BLACK);
 lib.DrawRect(cx,cy,cx,cy+box_h,C_BLACK);
 lib.DrawRect(cx,cy+box_h,cx+box_w,cy+box_h,M_Gray);
 lib.DrawRect(cx+box_w,cy,cx+box_w,cy+box_h,M_Gray);
 DrawString(cx+box_w/2-size*#str/4,cy+1,str,C_WHITE,size);
 else
 lib.Background(cx+1,cy+1,cx+box_w,cy+box_h,192,C_BLACK);
 lib.DrawRect(cx,cy,cx+box_w,cy,M_Gray);
 lib.DrawRect(cx,cy,cx,cy+box_h,M_Gray);
 lib.DrawRect(cx,cy+box_h,cx+box_w,cy+box_h,C_BLACK);
 lib.DrawRect(cx+box_w,cy,cx+box_w,cy+box_h,C_BLACK);
 DrawString(cx+box_w/2-size*#str/4,cy+1,str,M_Silver,size);
 end
 end
 local function redraw(flag)
 local T={[0]="关闭","１","２","３","４","５"}
 JY.ReFreshTime=lib.GetTime();
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 DrawWarMap();
 elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 DrawSMap();
 else
 
 end
 lib.PicLoadCache(4,80*2,x,y,1);
 lib.SetClip(x,y+72,x+w,y+72+128-8);
 lib.PicLoadCache(4,80*2,x,y+72-8,1);
 lib.SetClip();
 DrawString(x+16,y+16,"功能设定",C_Name,size);
 DrawStr(x+16,y+40,"音乐",C_WHITE,size);
 for i,v in pairs(T) do
 if math.modf(CC.MusicVolume/20)==i then
 button(x+80+i*38,y+40,v,true);
 else
 button(x+80+i*38,y+40,v,false);
 end
 end
 DrawStr(x+16,y+60,"音效",C_WHITE,size);
 for i,v in pairs(T) do
 if math.modf(CC.SoundVolume/10)==i then
 button(x+80+i*38,y+60,v,true);
 else
 button(x+80+i*38,y+60,v,false);
 end
 end
 DrawStr(x+16,y+80,"字形",C_WHITE,size);
 if CC.FontType==0 then
 button(x+80+1*38,y+80,"１",true);
 button(x+80+2*38,y+80,"２",false);
 else
 button(x+80+1*38,y+80,"１",false);
 button(x+80+2*38,y+80,"２",true);
 end

if notWar then
 DrawStr(x+16,y+100,"繁简",C_WHITE,size);
 --if CC.OSCharSet==0 then
if CC.font==0 then
 button(x+80+1*38,y+100,"简体",true);
 button(x+80+2*38,y+100,"繁体",false);
 else
 button(x+80+1*38,y+100,"简体",false);
 button(x+80+2*38,y+100,"繁体",true);
 end

 DrawStr(x+16,y+120,"敌军追击",C_WHITE,size);
 if JY.Base["敌军追击"]>0 then
 button(x+80+1*38,y+120,"开启",true);
 button(x+80+2*38,y+120,"关闭",false);
 else
 button(x+80+1*38,y+120,"开启",false);
 button(x+80+2*38,y+120,"关闭",true);
 end

 else

 DrawStr(x+16,y+100,"移动加速",C_WHITE,size);
if CC.MoveSpeed==1 then
 button(x+80+1*38,y+100,"开启",true);
 button(x+80+2*38,y+100,"关闭",false);
 else
 button(x+80+1*38,y+100,"开启",false);
 button(x+80+2*38,y+100,"关闭",true);
 end

 DrawStr(x+16,y+120,"策略动画",C_WHITE,size);
 if CC.cldh==1 then
 button(x+80+1*38,y+120,"开启",true);
 button(x+80+2*38,y+120,"关闭",false);
 else
 button(x+80+1*38,y+120,"开启",false);
 button(x+80+2*38,y+120,"关闭",true);
 end

 DrawStr(x+16,y+140,"战斗不语",C_WHITE,size);
 if CC.zdsh==0 then
 button(x+80+1*38,y+140,"开启",false);
 button(x+80+2*38,y+140,"关闭",true);
 else
 button(x+80+1*38,y+140,"开启",true);
 button(x+80+2*38,y+140,"关闭",false);
 end

 end
 if flag==1 then
 lib.PicLoadCache(4,56*2,x1,y1,1);
 end
 if notWar then
 ShowScreen();
 else
 ReFresh();
 end
 end
 
 local current=0;
 --PlayWavE(0);
 while true do
 redraw(current);
 getkey();
 if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
 current=1;
 elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
 current=0;
 PlayWavE(0);
 redraw(current);
 if notWar then
 lib.Delay(100);
 else
 WarDelay(4);
 end
 return;
 else
 current=0;
 for i=0,5 do
 if MOUSE.CLICK(x+80+i*38,y+40,x+80+i*38+36,y+40+16) then
 CC.MusicVolume=20*i;
Config();
PicCatchIni();
 --lib.LoadSoundConfig(CC.MusicVolume,CC.SoundVolume);
 PlayWavE(0);
 break;
 elseif MOUSE.CLICK(x+80+i*38,y+60,x+80+i*38+36,y+60+16) then
 CC.SoundVolume=10*i;
Config();
PicCatchIni();
 --lib.LoadSoundConfig(CC.MusicVolume,CC.SoundVolume);
 PlayWavE(0);
 break;
 end
 end
 if MOUSE.CLICK(x+80+1*38,y+80,x+80+1*38+36,y+80+16) then
 CC.FontType=0;
 PlayWavE(0);
 elseif MOUSE.CLICK(x+80+2*38,y+80,x+80+2*38+36,y+80+16) then
 CC.FontType=1;
 PlayWavE(0);
 elseif MOUSE.CLICK(x+80+1*38,y+100,x+80+1*38+36,y+100+16) then
 --CC.OSCharSet=0;

 if notWar then
CC.FontName=CONFIG.FontName
CC.font=0
else
CC.MoveSpeed=1
end

 PlayWavE(0);
 elseif MOUSE.CLICK(x+80+2*38,y+100,x+80+2*38+36,y+100+16) then
 --CC.OSCharSet=1;

 if notWar then
CC.FontName=CONFIG.CurrentPath.."font/font.ttf"
CC.font=1
else
CC.MoveSpeed=0
end

 PlayWavE(0);
 elseif MOUSE.CLICK(x+80+1*38,y+120,x+80+1*38+36,y+120+16) then
 if notWar then
 JY.Base["敌军追击"]=1;
 else
 CC.cldh=1
 end
 PlayWavE(0);
 elseif MOUSE.CLICK(x+80+2*38,y+120,x+80+2*38+36,y+120+16) then
 if notWar then
 JY.Base["敌军追击"]=0;
 else
 CC.cldh=0
 end
 PlayWavE(0);


 elseif MOUSE.CLICK(x+80+1*38,y+140,x+80+1*38+36,y+140+16) then
 if notWar then

else
 CC.zdsh=1
 end
 PlayWavE(0);
 elseif MOUSE.CLICK(x+80+2*38,y+140,x+80+2*38+36,y+140+16) then
 if notWar then

else
 CC.zdsh=0
 end
 PlayWavE(0);

 end
 end
 end
end

function SettingMenu2()
 local x,y,w,h;
 local size=16;
 w=320;
 h=128+64;
 local notWar=true;
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 x=16+(576-0)/2;
 y=32+(432-0)/2;
 notWar=false;
 elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 x=16+(640-0)/2;
 y=16+(400-0)/2;
 notWar=true;
 else
 x=(CC.ScreenW-0)/2;
 y=(CC.ScreenH-0)/2;
 notWar=true;
 end
 x=x-w/2;
 y=y-h/2;
 local x1=x+254
 local x2=x1+52
 local y1=y+92+64;
 local y2=y1+24;
 
 local function button(bx,by,str,flag)
 local box_w=36;
 local box_h=18;
 local cx=bx;
 local cy=by-1;
 if flag then --selected
 lib.Background(cx+1,cy+1,cx+box_w,cy+box_h,128,C_BLACK);
 lib.DrawRect(cx,cy,cx+box_w,cy,C_BLACK);
 lib.DrawRect(cx,cy,cx,cy+box_h,C_BLACK);
 lib.DrawRect(cx,cy+box_h,cx+box_w,cy+box_h,M_Gray);
 lib.DrawRect(cx+box_w,cy,cx+box_w,cy+box_h,M_Gray);
 DrawString(cx+box_w/2-size*#str/4,cy+1,str,C_WHITE,size);
 else
 lib.Background(cx+1,cy+1,cx+box_w,cy+box_h,192,C_BLACK);
 lib.DrawRect(cx,cy,cx+box_w,cy,M_Gray);
 lib.DrawRect(cx,cy,cx,cy+box_h,M_Gray);
 lib.DrawRect(cx,cy+box_h,cx+box_w,cy+box_h,C_BLACK);
 lib.DrawRect(cx+box_w,cy,cx+box_w,cy+box_h,C_BLACK);
 DrawString(cx+box_w/2-size*#str/4,cy+1,str,M_Silver,size);
 end
 end
 local function redraw(flag)
 local T={[0]="关闭","１","２","３","４","５"}
 JY.ReFreshTime=lib.GetTime();
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 DrawWarMap();
 elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 DrawSMap();
 else
 
 end
 lib.PicLoadCache(4,80*2,x,y,1);
 lib.SetClip(x,y+72,x+w,y+72+128-8);
 lib.PicLoadCache(4,80*2,x,y+72-8,1);
 lib.SetClip();
 DrawString(x+16,y+16,"功能设定",C_Name,size);
 DrawStr(x+16,y+40,"音乐",C_WHITE,size);
 for i,v in pairs(T) do
 if math.modf(CC.MusicVolume/20)==i then
 button(x+80+i*38,y+40,v,true);
 else
 button(x+80+i*38,y+40,v,false);
 end
 end
 DrawStr(x+16,y+60,"音效",C_WHITE,size);
 for i,v in pairs(T) do
 if math.modf(CC.SoundVolume/10)==i then
 button(x+80+i*38,y+60,v,true);
 else
 button(x+80+i*38,y+60,v,false);
 end
 end
 DrawStr(x+16,y+80,"字形",C_WHITE,size);
 if CC.FontType==0 then
 button(x+80+1*38,y+80,"１",true);
 button(x+80+2*38,y+80,"２",false);
 else
 button(x+80+1*38,y+80,"１",false);
 button(x+80+2*38,y+80,"２",true);
 end

 if notWar then

 DrawStr(x+16,y+100,"繁简",C_WHITE,size);
 --if CC.OSCharSet==0 then
if CC.font==0 then
 button(x+80+1*38,y+100,"简体",true);
 button(x+80+2*38,y+100,"繁体",false);
 else
 button(x+80+1*38,y+100,"简体",false);
 button(x+80+2*38,y+100,"繁体",true);
 end


 DrawStr(x+16,y+120,"敌军追击",C_WHITE,size);
 if JY.Base["敌军追击"]>0 then
 button(x+80+1*38,y+120,"开启",true);
 button(x+80+2*38,y+120,"关闭",false);
 else
 button(x+80+1*38,y+120,"开启",false);
 button(x+80+2*38,y+120,"关闭",true);
 end

 else

 DrawStr(x+16,y+100,"移动加速",C_WHITE,size);
if CC.MoveSpeed==1 then
 button(x+80+1*38,y+100,"开启",true);
 button(x+80+2*38,y+100,"关闭",false);
 else
 button(x+80+1*38,y+100,"开启",false);
 button(x+80+2*38,y+100,"关闭",true);
 end

 DrawStr(x+16,y+120,"策略动画",C_WHITE,size);
 if CC.cldh==1 then
 button(x+80+1*38,y+120,"开启",true);
 button(x+80+2*38,y+120,"关闭",false);
 else
 button(x+80+1*38,y+120,"开启",false);
 button(x+80+2*38,y+120,"关闭",true);
 end

 DrawStr(x+16,y+140,"暴击不语",C_WHITE,size);
 if CC.zdsh==1 then
 button(x+80+1*38,y+140,"开启",false);
 button(x+80+2*38,y+140,"关闭",true);
 else
 button(x+80+1*38,y+140,"开启",true);
 button(x+80+2*38,y+140,"关闭",false);
 end

 end
 if flag==1 then
 lib.PicLoadCache(4,56*2,x1,y1,1);
 end
 if notWar then
 ShowScreen();
 else
 ReFresh();
 end
 end
 
 local current=0;
 --PlayWavE(0);
 while true do
 redraw(current);
 getkey();
 if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
 current=1;
 elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
 current=0;
 PlayWavE(0);
 redraw(current);
 if notWar then
 lib.Delay(100);
 else
 WarDelay(4);
 end
 return;
 else
 current=0;
 for i=0,5 do
 if MOUSE.CLICK(x+80+i*38,y+40,x+80+i*38+36,y+40+16) then
 CC.MusicVolume=20*i;
Config();
PicCatchIni();
 --lib.LoadSoundConfig(CC.MusicVolume,CC.SoundVolume);
 PlayWavE(0);
 break;
 elseif MOUSE.CLICK(x+80+i*38,y+60,x+80+i*38+36,y+60+16) then
 CC.SoundVolume=10*i;
Config();
PicCatchIni();
 --lib.LoadSoundConfig(CC.MusicVolume,CC.SoundVolume);
 PlayWavE(0);
 break;
 end
 end
 if MOUSE.CLICK(x+80+1*38,y+80,x+80+1*38+36,y+80+16) then
 CC.FontType=0;
 PlayWavE(0);
 elseif MOUSE.CLICK(x+80+2*38,y+80,x+80+2*38+36,y+80+16) then
 CC.FontType=1;
 PlayWavE(0);
 elseif MOUSE.CLICK(x+80+1*38,y+100,x+80+1*38+36,y+100+16) then
 --CC.OSCharSet=0;

 if notWar then
CC.FontName=CONFIG.FontName
CC.font=0
else
CC.MoveSpeed=1
end


 PlayWavE(0);
 elseif MOUSE.CLICK(x+80+2*38,y+100,x+80+2*38+36,y+100+16) then
 --CC.OSCharSet=1;

 if notWar then
CC.FontName=".\\font\\font.ttf"
CC.font=1
else
CC.MoveSpeed=0
end

 PlayWavE(0);
 elseif MOUSE.CLICK(x+80+1*38,y+120,x+80+1*38+36,y+120+16) then
 if notWar then
 JY.Base["敌军追击"]=1;
 else
 CC.cldh=1
 end
 PlayWavE(0);
 elseif MOUSE.CLICK(x+80+2*38,y+120,x+80+2*38+36,y+120+16) then
 if notWar then
 JY.Base["敌军追击"]=0;
 else
 CC.cldh=0
 end
 PlayWavE(0);


 elseif MOUSE.CLICK(x+80+1*38,y+140,x+80+1*38+36,y+140+16) then
 if notWar then

else
 CC.zdsh=0
 end
 PlayWavE(0);
 elseif MOUSE.CLICK(x+80+2*38,y+140,x+80+2*38+36,y+140+16) then
 if notWar then

else
 CC.zdsh=1
 end
 PlayWavE(0);

 end
 end
 end
end


function WarGetPic(id)
--[[
0 短兵
1 短兵
2 长兵
3 战车
4 弓兵
5 弩兵
6 投石车
7 轻骑兵
8 重骑兵
9 近卫队
10 山贼
11 恶贼
12 义贼
13 军乐队
14 猛兽兵团
15 武术家
16 妖术师
17 异民族
18 民众
19 运输队
5020 5070 5120 曹操(原版)
5170 5220 5270 夏侯惇(原版)
5320 5370 5420 张辽(原版)
5470 5520 5570 貂蝉(原版)
5620 5670 5720 司马懿(原版)
5770 刘备(原版，进阶)
5820 诸葛(诸葛巾)
5870 周瑜(原版)
5920 陆逊(原版)
5970 6020 6070 典韦(原版)
6120 6170 6220 许褚(原版)
6270 祝融(原版)
6320 刘备(原版)
6370 6420 关羽(原版)
6470 6520 张飞(原版)
6570 赵云(原版)
6620 献帝(原版)
6670 吕布(原版)
6720 姜维 骑马
6770 6820 赵云 骑马
6870 廖化 步行
6920 7420 刘备 步行
6970 庞统(无双)
7020 靖仇
7070 周瑜(三国志)
7120 关羽 骑马
7170 张飞 骑马
7220 武松(水浒)
7270 吕布 骑马
7320 张辽? 步行
7370 剑客
7470 司马懿 步行
7520 女剑客
7570 剑仙
7620 吕布 步行
7670 鲁智深(水浒)
7720 陆逊(三国志)
7770 孙坚 骑马
7820 徐晃 骑马
7870 双刀·女
7920 周仓 步行
7970 男·枪·双戟·白·骑马
8020 典韦 骑马
8070 8120 纪灵 骑马
8170 8220 颜良 文丑 骑马
8270 李明 猛兽
8320 许褚 骑马
8370 8420 太史慈 骑马
8470 赵云(街机) 骑马
8520 双扇·女 步行
8570 魏延 骑马
8620 曹仁 步行
8670 董卓 步行
8720 段誉
8770 黄盖
8820 黄忠 弓
8870 黄忠 骑马
8920 马超
8970 马岱 步行
9020 张任 弓
9070 周泰 步行
9120 子龙 步行
9170 高顺 训虎
9220 沙摩柯 藤甲
9270 诸葛 纶巾
9320 诸葛 帽子
9820 曹操san10风格 骑马
9870 单刀男 步行 蓝
9920 邓艾 骑马
9970 10020 10070 10120 关平骑马1-4
10170 10220 马谡 步行
10270 双鞭男
10320 备娘，步行
10370 步将，剑，白
10420 步将，剑盾，蓝
10470 步将，枪，蓝
10520 公孙瓒，白马
10570 姑娘，单刀
10620 关兴，步
10670 关兴，骑马
10720 剑客，黄
10770 李典，骑马
10820 李典，步行
10870 马谡，妖术师
10920 - 11320 枪兵
11370 沙摩柯，步行
11420 沙摩柯，骑马
11470 张苞，骑马
11520 - 11670 张辽s10，骑马 lv3,move和lv2一样，原本导出的游戏里就有问题
11670 赵云，老年
11720 孙权，孙策，孙坚，原版
11770 袁绍，原版
]]--
 local pid=War.Person[id].id;
 return GetPic(pid,War.Person[id].enemy,War.Person[id].friend);
end
function GetBZPic(pid,enemy,friend)
 local pic=20;
 local bz=JY.Person[pid]["兵种"];
 local lv=1;
 if JY.Person[pid]["等级"]<20 then
 lv=1;
 elseif JY.Person[pid]["等级"]<40 then
 lv=2;
 else
 lv=3;
 end
 pic=JY.Bingzhong[bz]["贴图"..lv];
 if enemy then
 return pic+JY.Bingzhong[bz]["敌军偏移"];
 elseif friend then
 return pic+JY.Bingzhong[bz]["友军偏移"];
 else
 return pic+JY.Bingzhong[bz]["我军偏移"];
 end 
end
function GetPic(pid,enemy,friend)
 --[[
 if bz>12 then
 bz=12+(bz-13)*3+lv;
 end
 -- 1 4 7 10 13 16 19 22 25 28 31 34 37 40
 -- 步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 local T1={[0]=20,20,170,320, 920,1070,1220, 470,620,770, 1370,1520,1670, 3620,3620,3620, 3170,3170,3170, 1820,1970,2120, 2720,2870,3020, 3320,3320,3320, 3570,3570,3570, 3770,3770,3770, 3920,4070,4220, 4370,4520,4670, 9370,9520,9670,}; --敌军 红
 local T2={[0]=70,70,220,370, 970,1120,1270, 520,670,820, 1420,1570,1720, 3670,3670,3670, 3220,3220,3220, 1870,2020,2170, 2770,2920,3070, 3370,3370,3370, 3570,3570,3570, 3820,3820,3820, 3970,4120,4270, 4420,4570,4720, 9420,9570,9720,}; --友军 黄
 local T3={[0]=120,120,270,420, 1020,1170,1320, 570,720,870, 1470,1620,1770, 3720,3720,3720, 3270,3270,3270, 1920,2070,2220, 2820,2970,3120, 3420,3420,3420, 3570,3570,3570, 3870,3870,3870, 4020,4170,4320, 4470,4620,4770, 9470,9620,9770,}; --我军 蓝
 
 if enemy then
 JY.Person[pid]["战斗动作"]=T1[bz] or 20;
 elseif friend then
 JY.Person[pid]["战斗动作"]=T2[bz] or 70;
 else
 JY.Person[pid]["战斗动作"]=T3[bz] or 120;
 end 
 ]]--
 local bz=JY.Person[pid]["兵种"];
 local lv=1;
 if bz==3 or bz==6 or bz==9 or bz==12 then
 lv=3;
 elseif bz==2 or bz==5 or bz==8 or bz==11 then
 lv=2;
 elseif bz==1 or bz==4 or bz==7 or bz==10 then
 lv=1;
 elseif JY.Person[pid]["等级"]<20 then
 lv=1;
 elseif JY.Person[pid]["等级"]<40 then
 lv=2;
 else
 lv=3;
 end
 JY.Person[pid]["战斗动作"]=GetBZPic(pid,enemy,friend);
 local id=JY.Person[pid]["代号"];
 if id==1 then --刘备
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 if lv==1 then
 JY.Person[pid]["战斗动作"]=6320;
 elseif lv==2 then
 JY.Person[pid]["战斗动作"]=12120;
 else
 JY.Person[pid]["战斗动作"]=12170;
 end
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 elseif bz==27 then
 JY.Person[pid]["战斗动作"]=10320;
 else --步行
 if lv<3 then
 JY.Person[pid]["战斗动作"]=6920;
 else
 JY.Person[pid]["战斗动作"]=7420;
 end
 end
 elseif id==2 or id==373 then --关羽
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 if lv==1 then
 JY.Person[pid]["战斗动作"]=6370;
 elseif lv==2 then
 JY.Person[pid]["战斗动作"]=6420;
 elseif lv==3 then
 JY.Person[pid]["战斗动作"]=7120;
 else
 
 end
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=11870;
 end
 elseif id==3 or id==374 then --张飞
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 if lv==1 then
 JY.Person[pid]["战斗动作"]=6470;
 elseif lv==2 then
 JY.Person[pid]["战斗动作"]=6520;
 elseif lv==3 then
 JY.Person[pid]["战斗动作"]=7170;
 else
 
 end
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=12570;
 end
 elseif id==4 then --董卓
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 JY.Person[pid]["战斗动作"]=8670;
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==5 then --吕布
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 if lv==1 then
 JY.Person[pid]["战斗动作"]=6670;
 elseif lv==2 or lv==3 then
 --JY.Person[pid]["战斗动作"]=7270;
 JY.Person[pid]["战斗动作"]=12220;
 else
 
 end
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=7620;
 end
 elseif id==6 then --华雄
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 JY.Person[pid]["战斗动作"]=11970;
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==9 then --曹操
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 if lv==1 then
 JY.Person[pid]["战斗动作"]=5020;
 elseif lv==2 then
 JY.Person[pid]["战斗动作"]=5070;
 elseif lv==3 then
 JY.Person[pid]["战斗动作"]=5120;
 else
 
 end
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==10 then --袁绍
 JY.Person[pid]["战斗动作"]=11770;
 elseif id==11 then --孙坚
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 JY.Person[pid]["战斗动作"]=7770;
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==13 then --公孙瓒
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 JY.Person[pid]["战斗动作"]=10520;
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==15 then --黄盖
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=8770;
 end
 elseif id==17 then --夏侯惇
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 if lv==1 then
 JY.Person[pid]["战斗动作"]=5170;
 elseif lv==2 then
 JY.Person[pid]["战斗动作"]=5220;
 elseif lv==3 then
 JY.Person[pid]["战斗动作"]=5270;
 else
 
 end
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==18 then --夏侯渊
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 if true or bz==22 then
 if lv==1 then
 JY.Person[pid]["战斗动作"]=12320;
 elseif lv==2 then
 JY.Person[pid]["战斗动作"]=12370;
 elseif lv==3 then
 JY.Person[pid]["战斗动作"]=12420;
 else
 
 end
 end
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==19 then --曹仁
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=8620;
 end
 elseif id==30 then --关兴
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 if lv==3 and JY.Person[pid]["等级"]>=60 then
 JY.Person[pid]["战斗动作"]=10670;
 end
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=10620;
 end
 elseif id==31 then --马谡
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==16 then --妖术师
 JY.Person[pid]["战斗动作"]=10870;
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 if lv==1 then
 JY.Person[pid]["战斗动作"]=10170;
 elseif lv==2 then
 JY.Person[pid]["战斗动作"]=10170;
 elseif lv==3 then
 JY.Person[pid]["战斗动作"]=10220;
 end
 end
 elseif id==34 then --廖化
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=6870;
 end
 elseif id==35 then --沙摩柯
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 JY.Person[pid]["战斗动作"]=11420;
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=11370;--9220;
 end
 elseif id==44 then --张苞
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 if lv==3 and JY.Person[pid]["等级"]>=60 then
 JY.Person[pid]["战斗动作"]=11470;
 end
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==52 then --颜良
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 JY.Person[pid]["战斗动作"]=8170;
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==53 then --文丑
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 JY.Person[pid]["战斗动作"]=8220;
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==54 then --赵云
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 if lv==1 then
 JY.Person[pid]["战斗动作"]=6570;
 elseif lv==2 then
 JY.Person[pid]["战斗动作"]=6770;
 elseif lv==3 then
 JY.Person[pid]["战斗动作"]=6820;
 else
 
 end
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=9120;
 end
 elseif id==68 then --许褚
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 JY.Person[pid]["战斗动作"]=8320;
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 if lv==1 then
 JY.Person[pid]["战斗动作"]=6120;
 elseif lv==2 then
 JY.Person[pid]["战斗动作"]=6170;
 elseif lv==3 then
 JY.Person[pid]["战斗动作"]=6220;
 else
 
 end
 end
 elseif id==70 then --纪灵
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 if lv==1 then
 JY.Person[pid]["战斗动作"]=8070;
 elseif lv==2 then
 JY.Person[pid]["战斗动作"]=8120;
 elseif lv==3 then
 JY.Person[pid]["战斗动作"]=8120;
 else
 
 end
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==73 then --高顺
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==14 then --训虎一般无特殊形象
 JY.Person[pid]["战斗动作"]=9170;
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==79 then --徐晃
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 JY.Person[pid]["战斗动作"]=7820;
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==80 then --张辽
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 if lv==1 then
 JY.Person[pid]["战斗动作"]=5320;
 elseif lv==2 then
 JY.Person[pid]["战斗动作"]=5370;
 elseif lv==3 then
 JY.Person[pid]["战斗动作"]=5420;
 else
 
 end
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=7320;
 end
 elseif id==83 then --简雍
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵
 if lv>1 then
 JY.Person[pid]["战斗动作"]=12070;
 end

 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==103 then --张郃
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 if true or bz==22 then
 JY.Person[pid]["战斗动作"]=12520;
 end
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象

 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==116 then --李典
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 --JY.Person[pid]["战斗动作"]=10770;
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=10820;
 end
 elseif id==126 then --诸葛亮
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 if between(JY.Person[pid]["等级"],1,39) then
 JY.Person[pid]["战斗动作"]=9270;
 elseif between(JY.Person[pid]["等级"],40,59) then
 JY.Person[pid]["战斗动作"]=5820;
 elseif between(JY.Person[pid]["等级"],60,9999) then
 JY.Person[pid]["战斗动作"]=9320;
 else
 
 end
 end
 elseif id==127 then --魏延
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 JY.Person[pid]["战斗动作"]=8570;
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==128 then --关平
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 if lv==1 then
 JY.Person[pid]["战斗动作"]=9970;
 elseif lv==2 then
 JY.Person[pid]["战斗动作"]=10070;
 elseif lv==3 then
 JY.Person[pid]["战斗动作"]=10120;
 else
 
 end
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==129 then --夏侯兰
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=9870;
 end
 elseif id==133 then --庞统
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=6970;
 end
 elseif id==142 then --孙权
 JY.Person[pid]["战斗动作"]=11720;
 elseif id==143 then --周瑜
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=7070;
 end
 elseif id==150 then --太史慈
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 if lv==1 then
 JY.Person[pid]["战斗动作"]=8370;
 elseif lv==2 then
 JY.Person[pid]["战斗动作"]=8420;
 elseif lv==3 then
 JY.Person[pid]["战斗动作"]=8420;
 else
 
 end
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==151 then --陆逊
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=7720;
 end
 elseif id==155 then --周仓
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=7920;
 end
 elseif id==163 then --周泰
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=9070;
 end
 elseif id==170 then --黄忠
 if between(bz,7,9) then --骑马
 JY.Person[pid]["战斗动作"]=8870;
 elseif bz==22 then --弓骑
 JY.Person[pid]["战斗动作"]=12020;
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 JY.Person[pid]["战斗动作"]=8820;
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==190 then --马超
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 JY.Person[pid]["战斗动作"]=8920;
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==196 then --张任
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 JY.Person[pid]["战斗动作"]=9020;
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==204 then --马岱
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=8970;
 end
 elseif id==214 then --司马懿
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 if lv==1 then
 JY.Person[pid]["战斗动作"]=5620;
 elseif lv==2 then
 JY.Person[pid]["战斗动作"]=5670;
 elseif lv==3 then
 JY.Person[pid]["战斗动作"]=5720;
 else
 
 end
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=7470;
 end
 elseif id==216 then --庞德
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 JY.Person[pid]["战斗动作"]=10770;
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==244 then --姜维
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 JY.Person[pid]["战斗动作"]=6720;
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 
 end
 elseif id==376 then --李明
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 
 elseif bz==14 then --训虎一般无特殊形象
 JY.Person[pid]["战斗动作"]=8270;

 
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=10570;
 end
 elseif id==377 then --祝融
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=6270;
 end
 elseif id==383 then --献帝
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=6620;
 end
 elseif id==385 then --鲁智深
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=7670;
 end
 elseif id==386 then --武松
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=7220;
 end
 elseif id==387 then --典韦
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 JY.Person[pid]["战斗动作"]=8020;
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 if lv==1 then
 JY.Person[pid]["战斗动作"]=5970;
 elseif lv==2 then
 JY.Person[pid]["战斗动作"]=5970;
 elseif lv==3 then
 JY.Person[pid]["战斗动作"]=6020;
 else
 
 end
 end
 elseif id==388 then --靖仇
 JY.Person[pid]["战斗动作"]=7020;
 elseif id==389 then --仙子
 JY.Person[pid]["战斗动作"]=7520;
 elseif id==390 then --剑仙
 JY.Person[pid]["战斗动作"]=7570;
 elseif id==391 then
 JY.Person[pid]["战斗动作"]=7620;
 elseif id==392 then
 JY.Person[pid]["战斗动作"]=7120;
 elseif id==393 then
 JY.Person[pid]["战斗动作"]=7170;
 elseif id==394 then
 JY.Person[pid]["战斗动作"]=8470;
 elseif id==395 then
 JY.Person[pid]["战斗动作"]=8570;
 elseif id==396 then
 JY.Person[pid]["战斗动作"]=8020;
 elseif id==397 then
 JY.Person[pid]["战斗动作"]=5420;
 elseif id==398 then
 JY.Person[pid]["战斗动作"]=6220;
 elseif id==404 then --貂蝉
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 if lv==1 then
 JY.Person[pid]["战斗动作"]=5470;
 elseif lv==2 then
 JY.Person[pid]["战斗动作"]=5520;
 elseif lv==3 then
 JY.Person[pid]["战斗动作"]=5570;
 else
 
 end
 end
 elseif id==405 then --胡笛
 if between(bz,7,9) or bz==20 or bz==22 then --骑马
 
 elseif bz>=4 and bz<=6 then --弓兵一般无特殊形象
 elseif bz==21 then --投石车一般无特殊形象
 
 else --步行
 JY.Person[pid]["战斗动作"]=8720;
 end
 elseif id==406 then --bttt
 JY.Person[pid]["战斗动作"]=12270;
 end
 return JY.Person[pid]["战斗动作"];
end
function FightMenu()
 local T={ 5,3,387,2,54,68,
 190,385,17,170,98,
 391,392,393,394,395,396,397,398,
 150,216,386,390,44,127,389,35,
 53,79,148,6,11,
 18,80,103,244,4,
 30,201,52,163,196,388,
 15,142,202,155,122,
 149,204,171,377,167,
 212,19,128,151,109,
 34,178,236,1,9,104,
 143,165,174,254,20,
 102,218,61,106,191,
 129,141,166,205,252,
 116,13,200,46,70,88,113,
 210,376,14,168,211,
 213,217,243,81,162,
 208,209,248,241,31,
 91,105,240,47,82,
 117,221,48,144,45,
 51,63,87,136,378,
 10,73,146,76,380,
 38,188,133,214,50,
 57,112,126,83,65,
 77,94,64,69,62,
 145,84,251,7,379,
 253,114,239,402,403,
 404,405,382,406,
 }
 local id1=FightSelectMenu(T);
 if id1==0 then
 return;
 end
 for i,v in pairs(T) do
 if id1==v then
 table.remove(T,i);
 break;
 end
 end
 local id2=FightSelectMenu(T);
 if id2==0 then
 return;
 end
 local s={0,1,2,4,6};
 --dofile(CONFIG.ScriptPath .. "war.lua");
 --war(id1,id2,s[math.random(5)]);
 fight(id1,id2,s[math.random(5)]);
end
function FightSelectMenu(T)
 local num_perpage=12;
 local page=1;
 local total_num=#T;
 local maxpage=math.modf(total_num/(num_perpage-2));
 if total_num>(num_perpage-2)*maxpage then
 maxpage=maxpage+1;
 end
 local t={};
 
 while true do
 for i=2,num_perpage-1 do
 t[i]=0;
 end
 t[1]=-1;
 t[num_perpage]=-2;
 for i=2,num_perpage-1 do
 local idx=(num_perpage-2)*(page-1)+(i-1);
 if idx<=total_num then
 t[i]=T[idx];
 end
 end
 local m={};
 m[1]={" 上一页",nil,1};
 m[num_perpage]={" 下一页",nil,1};
 for i=2,num_perpage-1 do
 if t[i]>0 then
 local str=JY.Person[t[i]]["姓名"];
 if #str==6 then
 str=" "..str;
 elseif #str==4 then
 str="　"..str;
elseif #str==3 then
 str="　 "..str;
 elseif #str==2 then
 str="　 "..str;
 end
 m[i]={str,nil,1};
 else
 m[i]={"",nil,0};
 end
 end
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 DrawWarMap();
 elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 DrawSMap();
 else
 lib.FillColor(0,0,0,0);
 end
 local r=ShowMenu(m,num_perpage,0,0,0,0,0,1,1,16,C_WHITE,C_WHITE);
 if r==1 then
 if page>1 then
 page=page-1;
 end
 elseif r==num_perpage then
 if page<maxpage then
 page=page+1;
 end
 elseif r==0 then
 return 0;
 else
 local id=t[r];
 local bz=JY.Person[id]["兵种"];
 if WarDrawStrBoxYesNo(string.format('%s %d级%s 武力 %d*确认吗？',JY.Person[id]["姓名"],JY.Person[id]["等级"],JY.Bingzhong[bz]["名称"],JY.Person[id]["武力"]),C_WHITE,true) then
 return t[r];
 end
 end
 end
end

function LvMenu(T)
 local num_perpage=12;
 local page=1;
 local total_num=#T;
 local maxpage=math.modf(total_num/(num_perpage-2));
 if total_num>(num_perpage-2)*maxpage then
 maxpage=maxpage+1;
 end
 local t={};
 
 while true do
 for i=2,num_perpage-1 do
 t[i]=0;
 end
 t[1]=-1;
 t[num_perpage]=-2;
 for i=2,num_perpage-1 do
 local idx=(num_perpage-2)*(page-1)+(i-1);
 if idx<=total_num then
 t[i]=T[idx];
 end
 end
 local m={};
 m[1]={" 上一页",nil,1};
 m[num_perpage]={" 下一页",nil,1};
 for i=2,num_perpage-1 do
 if t[i]>0 then
 local str=t[i]
 m[i]={"　 "..str,nil,1};
 else
 m[i]={"",nil,0};
 end
 end

 local r=ShowMenu(m,num_perpage,0,0,0,0,0,1,1,16,C_WHITE,C_WHITE);
 if r==1 then
 if page>1 then
 page=page-1;
 end
 elseif r==num_perpage then
 if page<maxpage then
 page=page+1;
 end
 elseif r==0 then
 return 0;
 else
 return t[r];
 end
 end
end


--原S.lua
function Config()

if CONFIG.PC then
lib.LoadConfig(CC.MusicVolume,CC.SoundVolume,CONFIG.EnableSound,CC.ScreenW,CC.ScreenH,CONFIG.FullScreen);
else
lib.LoadConfig(CC.ScreenW,CC.ScreenH);
end

end
function SystemMenu()
 PlayWavE(0);
 --lib.PicLoadCache(4,58*2,)
 local menu={
 {" 结束游戏",nil,1},
 {"　 载入",nil,1},
 {"　 储存",nil,1},
 {" 功能设定",nil,1},
 {"　 音效 ",nil,0},
 }
 DrawYJZBox(32,32,"功能",C_WHITE,true)
 local r=ShowMenu(menu,5,0,0,0,0,0,3,1,16,C_WHITE,C_WHITE);
 lib.Delay(100);
 if r==1 then
 if WarDrawStrBoxYesNo('结束游戏吗？',C_WHITE,true) then
 lib.Delay(100);
 if WarDrawStrBoxYesNo('再玩一次吗？',C_WHITE,true) then
 lib.Delay(100);
 JY.Status=GAME_START;
 else
 lib.Delay(100);
 JY.Status=GAME_END;
 end
 end
 elseif r==2 then
 local menu2={
 {" 1. ",nil,1},
 {" 2. ",nil,1},
 {" 3. ",nil,1},
 {" 4. ",nil,1},
 {" 5. ",nil,1},
 }
 for id=1,5 do
 if not fileexist(CC.R_GRPFilename[id]) then
 menu2[id][1]=menu2[id][1].."未使用档案";
 else
 menu2[id][1]=menu2[id][1]..GetRecordInfo(id);
 end
 end
 DrawYJZBox2(-1,104,"请选择将载入的档案",C_WHITE);
 local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,C_WHITE,C_WHITE);
 if between(s2,1,5) then
 if string.sub(menu2[s2][1],5)~="未使用档案" then
 if WarDrawStrBoxYesNo(string.format("载入在硬碟的第%d进度，可以吗？",s2),C_WHITE,true) then
 LoadRecord(s2);
 end
 else
 WarDrawStrBoxConfirm("没有数据",C_WHITE,true);
 end
 end
 elseif r==3 then
 local menu2={
 {" 1. ",nil,1},
 {" 2. ",nil,1},
 {" 3. ",nil,1},
 {" 4. ",nil,1},
 {" 5. ",nil,1},
 }
 for id=1,5 do
 if not fileexist(CC.R_GRPFilename[id]) then
 menu2[id][1]=menu2[id][1].."未使用档案";
 else
 menu2[id][1]=menu2[id][1]..GetRecordInfo(id);
 end
 end
 DrawYJZBox2(-1,104,"将档案储存在哪里？",C_WHITE);
 local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,C_WHITE,C_WHITE);
 if between(s2,1,5) then
 if WarDrawStrBoxYesNo(string.format("储存在硬碟的第%d号，可以吗？",s2),C_WHITE,true) then
 SaveRecord(s2);
 end
 end
 elseif r==4 then
 if CONFIG.PC then
 SettingMenu2();
 else
 SettingMenu();
 end 
 elseif r==5 then
 end
 
 return false;
end
function GetRecordInfo(id)
 local offset=CC.Base_S["章节名"][1]+100;
 local len=CC.Base_S["章节名"][3]+CC.Base_S["时间"][3];
 local data=Byte.create(8*len);
 Byte.loadfile(data,CC.R_GRPFilename[id],offset,len);
 local SectionName,SaveTime;
 SectionName=Byte.getstr(data,0,28);
 SaveTime=Byte.getstr(data,28,14);
 
 offset=CC.Base_S["战场存档"][1]+100;
 Byte.loadfile(data,CC.R_GRPFilename[id],offset,len);
 if Byte.get16(data,0)==1 then
 offset=CC.Base_S["战场名称"][1]+100;
 Byte.loadfile(data,CC.R_GRPFilename[id],offset,len);
 SectionName=Byte.getstr(data,0,28);
 
 offset=100+136;
 Byte.loadfile(data,CC.R_GRPFilename[id],offset,len);
 local turn=Byte.get8(data,0);
 local maxturn=Byte.get8(data,1);
 --SectionName=SectionName..string.format(" 第%02d回合",turn);
 --SectionName=SectionName..string.format("(%02d/%02d)",turn,maxturn);
 SectionName=string.gsub(SectionName,"　 ","　");
 if string.len(SectionName)<22 then
 SectionName=string.format(string.format("%%s%%%ds",22-string.len(SectionName)),SectionName,"")..string.format("第%02d回合",turn,maxturn);
 end
 end
 
 if CC.SrcCharSet==1 then
 SectionName=lib.CharSet(SectionName,0);
 end
 if string.len(SectionName)<31 then
 SectionName=string.format(string.format("%%s%%%ds",31-string.len(SectionName)),SectionName,"")
 end
 
 return SectionName..SaveTime;
end
function SetSceneID(id,BGMID)
 JY.SubScene=id;
 Dark();
 if BGMID~=nil then
 PlayBGM(BGMID);
 end
 DrawSMap();
 Light();
end
function SMapEvent()
 JY.ReFreshTime=lib.GetTime();
 DrawSMap();
 JY.Tid=0;
 local eventtype,keypress,x,y=getkey();
 if MOUSE.HOLD(673,321,710,366) then
 lib.PicLoadCache(4,220*2,673,321,1);
 elseif MOUSE.HOLD(713,321,750,366) then
 lib.PicLoadCache(4,221*2,713,321,1);
 elseif MOUSE.HOLD(673,369,710,414) then
 lib.PicLoadCache(4,222*2,673,369,1);
 elseif MOUSE.HOLD(713,369,750,414) then
 lib.PicLoadCache(4,223*2,713,369,1);
 end
 if MOUSE.CLICK(673,321,710,366) then
 PlayWavE(0);
 HirePerson();
 elseif MOUSE.CLICK(713,321,750,366) then
 PlayWavE(0);
 Person_Menu();
 elseif MOUSE.CLICK(673,369,710,414) then
 Shop();
 elseif MOUSE.CLICK(713,369,750,414) then
 SystemMenu();
 elseif MOUSE.CLICK(680,24,742,102) then
 JY.LLK_N=JY.LLK_N+1;
 if JY.LLK_N>49 then
 PlayWavE(0);
 if WarDrawStrBoxYesNo("禁止的隐含命令模式*对执行结果不负任何责任．*而且对此的询问也不解答．可以吗？",C_WHITE,true) then--可以进入命令键入野ｉ状态吗？

local mj=0
if CC.Enhancement==false then
mj=1
end

if mj==1 then
JY.Base["黄金"]=9999
JY.Person[1]["等级"]=99
JY.LLK_N=0
elseif mj==0 then
 Game_Cycle();
end

 else
 JY.LLK_N=50;
 end
 end
 end
 if MOUSE.IN(16,16,16+640,16+400) then
 for i,v in pairs(JY.Smap) do
 local px,py=27+18*v[2],19+18*v[3]-32;
 --if math.abs(x-px)<20 and math.abs(y-py)<28 then
 if MOUSE.CLICK(px-20,py-28,px+20,py+28) then
 JY.Tid=v[1];
 DoEvent(JY.EventID);
 if JY.Tid==-1 then
 JY.Tid=0;
 return;
 end
 JY.Tid=0;
 break;
 elseif MOUSE.IN(px-20,py-28,px+20,py+28) then
 JY.Tid=v[1];
 end
 end
 end
 if eventtype==3 and keypress==3 then
 SystemMenu();
 end
 if JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 ReFresh();
 end
end
function DrawSMap()
 lib.FillColor(0,0,0,0,0);
 if JY.SubScene>=0 then
 lib.PicLoadCache(5,JY.SubScene*2,16,16,1); --21,21
 local len=18;
 local dx,dy=27,19;
 if CC.Debug==1 then
 for i=1,20 do
 lib.Background(0,dy+len*i,CC.ScreenW,dy+len*i+1,128,C_WHITE);
 DrawString(42,dy+len*i,i,C_WHITE,16)
 DrawString(dx+len*i*2,24,i*2+1,C_WHITE,16)
 lib.Background(dx+len*i*2,0,dx+len*i*2+1,CC.ScreenH,128,C_WHITE);
 end
 end
 for i,v in pairs(JY.Smap) do
 local x,y=dx+len*v[2]-24,dy+len*v[3]-64;
 lib.SetClip(x,y,x+48,y+64);
 --lib.PicLoadCache(5,(200+JY.Person[v[1]]["形象"]*4+v[4])*2,x,y-math.modf(v[5])*64,1);
 --[[
 if v[5]>=1 then
 v[5]=v[5]+0.5;
 if v[5]==3 then
 v[5]=1;
 end
 end]]--
 if v[5]==0 then
 lib.PicLoadCache(5,(200+JY.Person[v[1]]["形象"]*4+v[4])*2,x,y-0*64,1);
 elseif v[5]==1 then
 lib.PicLoadCache(5,(200+JY.Person[v[1]]["形象"]*4+v[4])*2,x,y-1*64,1);
 elseif v[5]==2 then
 lib.PicLoadCache(5,(200+JY.Person[v[1]]["形象"]*4+v[4])*2,x,y-0*64,1);
 elseif v[5]==3 then
 lib.PicLoadCache(5,(200+JY.Person[v[1]]["形象"]*4+v[4])*2,x,y-2*64,1);
 elseif v[5]==4 then
 lib.PicLoadCache(5,(200+JY.Person[v[1]]["形象"]*4+v[4])*2,x,y-0*64,1);
 end
 if v[5]>=1 then
 v[5]=v[5]+1;
 if v[5]==5 then
 v[5]=1;
 end
 end
 lib.SetClip(0,0,0,0);
 end
 for i,v in pairs(JY.Smap) do
 if v[5]==0 then
 if JY.Tid==v[1] then
 local x,y=dx+len*v[2]-24,dy+len*v[3]-64;
 if v[4]==1 or v[4]==2 then
 lib.PicLoadCache(4,232*2,x-8,y-8,1);
 else
 lib.PicLoadCache(4,231*2,x+32,y-8,1);
 end
 end
 end
 end
 end
 lib.PicLoadCache(4,201*2,0,0,1);
 DrawGameStatus();
end
function DrawGameStatus()
 DrawString(680,142,"金",M_Navy,16);
 DrawString(680,182,"等级",M_Navy,16);
 DrawString(680,222,"武将",M_Navy,16);
 DrawString(680,262,"现在地",M_Navy,16);
 DrawString(740-#(""..JY.Base["黄金"])*16/2, 160,JY.Base["黄金"],C_WHITE,16);
 DrawString(740-#(""..JY.Person[1]["等级"])*16/2,200,JY.Person[1]["等级"],C_WHITE,16);
 DrawString(740-#(""..JY.Base["武将数量"])*16/2, 240,JY.Base["武将数量"],C_WHITE,16);
 DrawString(740-#JY.Base["现在地"]*16/2, 280,JY.Base["现在地"],C_WHITE,16);
 
 DrawString(18+6,434+6,JY.Base["章节名"],C_WHITE,16);
 if JY.Tid>0 then
 DrawString(338+6,434+6,JY.Person[JY.Tid]["姓名"],C_WHITE,16);
 end
end
function MovePerson(...)
 local arg={};
 for i,v in pairs({...}) do
 arg[i]=v;
 end
 --id,step,direction
 local n=math.modf(#arg/3);
 for i=0,n-1 do
 local id=arg[i*3+1];
 for ii,v in pairs(JY.Smap) do
 if v[1]==id then
 arg[i*3+1]=ii;
 v[5]=1;
 end
 end
 end
 while true do
 local flag=true;
 for i=0,n-1 do
 local id=arg[i*3+1];
 local d=arg[i*3+3];
 JY.Smap[id][4]=d;
 if arg[i*3+2]>0 then
 flag=false;
 JY.Smap[id][2]=JY.Smap[id][2]+CC.DX[d]*0.2;
 JY.Smap[id][3]=JY.Smap[id][3]+CC.DY[d]*0.2;
 arg[i*3+2]=arg[i*3+2]-0.2;
 else
 JY.Smap[id][5]=0;
 end
 end
 JY.ReFreshTime=lib.GetTime();
 DrawSMap();
 lib.GetKey();
 ReFresh(1.25);
 if flag then
 break;
 end
 end
 for i,v in pairs(JY.Smap) do
 v[5]=0;
 end
 DrawSMap();
 lib.GetKey();
 ShowScreen();
 lib.Delay(50);
 SortPerson();
end
function SortPerson()
 local n=#JY.Smap;
 for i=1,n-1 do
 for j=i+1,n do
 if JY.Smap[i][3]>JY.Smap[j][3] then
 JY.Smap[i],JY.Smap[j]=JY.Smap[j],JY.Smap[i];
 end
 end
 end
end
function DoEvent(id)
 if type(Event[id])=='function' then
 Event[id]();
 else
 lib.Debug("Error!! eid="..id.."　type="..type(Event[id]));
 JY.Status=GAME_START;
 end
 if id>9999 then
 os.exit();
 end
 if id~=JY.EventID then
 return true;
 else
 return false;
 end
end
function NextEvent(id)
 if id==nil then
 JY.EventID=JY.EventID+1;
 else
 JY.EventID=id;
 end
end
function PicCatchIni()
 lib.PicInit(CC.PaletteFile)
 lib.PicLoadFile(CC.MMAPPicFile[1],CC.MMAPPicFile[2],0);
 lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],1);
 lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],2);
 --3不能使用
 lib.PicLoadFile(CC.UIPicFile[1],CC.UIPicFile[2],4);
 lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],5);
 --lib.PicLoadFile(CC.MMAPPicFile[1],CC.MMAPPicFile[2],10,8.333333333333);
 lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],11,200);
 --lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],12,125);
end
function Password()
 local f=0;
 local T3={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"};
 local str="";
 if filelength( CONFIG.PicturePath..
 CC.PASCODE[29]..CC.PASCODE[8]..CC.PASCODE[5]..CC.PASCODE[14]..CC.PASCODE[50]..CC.PASCODE[53]..
 CC.PASCODE[4]..CC.PASCODE[5]..CC.PASCODE[2]..CC.PASCODE[21]..CC.PASCODE[7])==13 then--".\\ChenX.debug")==13 then
 CC.Debug=0
 return;
 end
 while true do
 JY.ReFreshTime=lib.GetTime();
 lib.PicLoadCache(4,83*2,0,0,1);
 if f==0 then
 lib.FillColor(40,14,49,16);
 end
 f=1-f;
 ReFresh();
 local key=lib.GetMouse();
 if key==1 or key==3 then
 break;
 end
 --[[
 local key=lib.GetKey();
 if key==VK_ESCAPE then
 str="";
 elseif key==VK_RETURN then
 if str=='txdxmc' then
 CC.Debug=1;
 elseif str=='fps' then
 CC.FPS=true;
 elseif str=='exit' then
 os.exit();
 elseif str=='824826abab' then--↑↓←↑↓→ＡＢＡＢ
 Game_Cycle();
 os.exit();
 elseif str=="fight" then
 --
 LoadRecord(0);
 for i=1,JY.PersonNum-1 do
 GetPic(i);
 end
 fight(3,5,1);
 --
 end
 break;
 elseif between(key,97,122) then
 str=str..T3[key-96];
 elseif key==SDLK_UP then
 str=str..'8';
 elseif key==SDLK_DOWN then
 str=str..'2';
 elseif key==SDLK_LEFT then
 str=str..'4';
 elseif key==SDLK_RIGHT then
 str=str..'6';
 end]]--
 end
 Dark();
end
function ScreenTest()
 while true do
 local e,k,x,y=lib.GetMouse(1)
 lib.FillColor(0,0,0,0,C_WHITE)
 if e==2 or e==3 then
 lib.DrawRect(x-64,y,x+64,y,0)
 lib.DrawRect(x,y-64,x,y+64,0)
 end
 DrawString(64,64,x..','..y,C_ORANGE,24);
 ShowScreen();
 lib.Delay(25)
 end
end
function YJZMain()
 local saveflag=false; --战后提示保存标记
 JY.Status=GAME_START; --游戏当前状态
 PicCatchIni();
 
 --
 --LoadRecord(0);
 --for i=1,JY.PersonNum-1 do
 -- GetPic(i);
 --end
 --fight(3,5,1);
 --
 
 Password();
 LoadRecord(0);
 for i=1,JY.PersonNum-1 do
 GetPic(i);
 end
 while true do
 if JY.Status==GAME_START then
 StopBGM();
 YJZMain_sub();
 elseif JY.Status==GAME_SMAP_AUTO then
 if saveflag then
 Dark();
 saveflag=false;
 lib.FillColor(0,0,0,0,0);
 RemindSave(2);
 end
 DoEvent(JY.EventID);
 elseif JY.Status==GAME_SMAP_MANUAL then
 SMapEvent();
 elseif JY.Status==GAME_MMAP then
 
 elseif JY.Status==GAME_WMAP then
 Dark();
 saveflag=true;
 WarStart();
 --if JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 -- saveflag=true;
 --end
 elseif JY.Status==GAME_WMAP2 then --连续战斗
 JY.Status=GAME_WMAP;
 DoEvent(JY.EventID);
 elseif JY.Status==GAME_WARWIN then
 JY.Status=GAME_SMAP_AUTO;
 elseif JY.Status==GAME_WARLOSE then
 JY.Status=GAME_START;
 elseif JY.Status==GAME_DEAD then
 
 elseif JY.Status==GAME_END then
 Dark();
 lib.Delay(1000)
 os.exit();
 end
 end
end
function YJZMain_sub()
 local menu={
 {"　 开始新游戏",nil,1},
 {"　　读取存档",nil,1},
 {"　　功能设定",nil,1},
 {"　　战场重现",nil,0},
 {"　　比武大会",nil,1},
 {"　观看剧情简介",nil,1},
 {"　　退出游戏",nil,1},
 }
 if CC.Debug==1 then
 menu[4][3]=1;
 end
 lib.FillColor(0,0,0,0);
 lib.Delay(200);
 local s=ShowMenu(menu,7,0,0,0,0,0,2,0,16,C_WHITE,C_WHITE);
 if s==1 then

 LoadRecord(0);
 JY.Person[1]["等级"]=3
 JY.Person[2]["等级"]=3
 JY.Person[3]["等级"]=3

local menux={
{"　　经典模式",nil,1},
{"　　纵横模式",nil,1},
}
local ss=ShowMenu(menux,2,0,0,0,0,0,2,0,16,C_WHITE,C_WHITE);
if ss==1 then
JY.Base["游戏模式"]=0
CC.Enhancement=false
elseif ss==2 then
JY.Base["游戏模式"]=1
CC.Enhancement=true
end

 for i=1,JY.PersonNum-1 do
 GetPic(i);
 end
 JY.Status=GAME_SMAP_AUTO; --游戏当前状态
 JY.EventID=1;
 elseif s==2 then
 local menu2={
 {" 1. ",nil,1},
 {" 2. ",nil,1},
 {" 3. ",nil,1},
 {" 4. ",nil,1},
 {" 5. ",nil,1},
 }
 for id=1,5 do
 if not fileexist(CC.R_GRPFilename[id]) then
 menu2[id][1]=menu2[id][1].."未使用档案";
 else
 menu2[id][1]=menu2[id][1]..GetRecordInfo(id);
 end
 end
 DrawYJZBox2(-1,128,"请选择将载入的档案",C_WHITE);
 local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,C_WHITE,C_WHITE);
 if between(s2,1,5) then
 if string.sub(menu2[s2][1],5)~="未使用档案" then
 if WarDrawStrBoxYesNo(string.format("载入在硬碟的第%d进度，可以吗？",s2),C_WHITE,true) then
 LoadRecord(s2);

 if JY.Base["游戏模式"]==1 then
CC.Enhancement=true
 else
CC.Enhancement=false
 end

 end
 else
 WarDrawStrBoxConfirm("没有数据",C_WHITE,true);
 end
 end
 elseif s==3 then
 if CONFIG.PC then
 SettingMenu2();
 else
 SettingMenu();
 end 
 elseif s==4 then
 LoadRecord(0);
 for i=1,JY.PersonNum-1 do
 GetPic(i);
 end
 JY.Status=GAME_SMAP_AUTO; --游戏当前状态

--调试
JY.Base["游戏模式"]=1
CC.Enhancement=true
 JY.EventID=633
JY.Base["事件333"]=30

-- SetFlag(97,1);
-- SetFlag(8,1);
-- SetFlag(9,1);

 GetItem(1,66);
 GetItem(1,67);
 GetItem(1,68)

 JY.Person[1]["等级"]=99
 JY.Person[2]["等级"]=99
 JY.Person[3]["等级"]=99
 JY.Base["黄金"]=10000
 JY.Base["章节名"]="测试事件"

 elseif s==5 then
 PlayBGM(18);
 FightMenu();
 elseif s==6 then

 lib.PicLoadFile(CC.EFT[1],CC.EFT[2],6);
 PlayBGM(2);
 local cx,cy=(CC.ScreenW-640)/2,(CC.ScreenH-480)/2;
 for picid=0,1236 do
 JY.ReFreshTime=lib.GetTime();
 lib.PicLoadCache(6,picid*2,cx,cy,1);
 ReFresh(8);
 local eventtype=lib.GetMouse(1);
 if eventtype==1 or eventtype==3 then
 Dark();
 lib.Delay(1000);
 break;
 end
 end
 PicCatchIni();
 elseif s==7 then
 if WarDrawStrBoxYesNo('结束游戏吗？',C_WHITE,true) then
 lib.Delay(100);
 if WarDrawStrBoxYesNo('再玩一次吗？',C_WHITE,true) then
 lib.Delay(100);
 JY.Status=GAME_START;
 else
 lib.Delay(100);
 JY.Status=GAME_END;
 end
 end
 end
 --while true do
 --DoEvent(JY.EventID);
 --end
end

function DrawStrBoxCenter(str,color,size,bjcolor) --显示带框的字符串
 --DrawSMap();
 
 local x,y;
 local cx,cy=340,220;
 color=color or C_WHITE;
 size=size or 16;
 local strarray={}
 local num,maxlen;
 maxlen=0
 num,strarray=Split(str,'*')
 for i=1,num do
 local len=#strarray[i];
 if len>maxlen then
 maxlen=len
 end
 end
 if maxlen==0 then
 return;
 end
 local w=size*maxlen/2+2*CC.MenuBorderPixel;
 local h=2*CC.MenuBorderPixel+size*num;
 x=cx-(size/2*maxlen+2*CC.MenuBorderPixel)/2;
 y=cy-(size*num+2*CC.MenuBorderPixel)/2;
 DrawYJZBox(x,y,str,C_WHITE);
--[[ DrawBox(x,y,x+w-1,y+h-1,C_WHITE,bjcolor);
 for i=1,num do
 DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel+size*(i-1),strarray[i],color,size);
 end]]--
 JY.ReFreshTime=lib.GetTime();
 ReFresh();
 WaitKey();
 JY.ReFreshTime=lib.GetTime();
 DrawSMap();
 ReFresh();
end
function DrawStrBoxCenter(str,color)
 color=color or C_WHITE;
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 WarDrawStrBoxWaitKey(str,color,-1,-1);
 else
 DrawStrBoxWaitKey(str,color);
 end
end
function GenTalkString(str,n) --产生对话显示需要的字符串
 local tmpstr=str;
 local num=0;

 local newstr="";
 while #tmpstr>0 do
 num=num+1;
 local w=0;
 while w<#tmpstr do
 local v=string.byte(tmpstr,w+1); --当前字符的值
 if v==42 then
 break;
 elseif v>=128 then
 w=w+2;
 else
 w=w+1;
 end
 if w >= 2*n-1 then --为了避免跨段中文字符
 break;
 end
 end

 if w<#tmpstr then
 if string.byte(tmpstr,w+1)==42 then
 newstr=newstr .. string.sub(tmpstr,1,w+1);
 tmpstr=string.sub(tmpstr,w+2,-1);
 elseif w==2*n-1 and string.byte(tmpstr,w+1)<128 then
 newstr=newstr .. string.sub(tmpstr,1,w+1) .. "*";
 tmpstr=string.sub(tmpstr,w+2,-1);
 else
 newstr=newstr .. string.sub(tmpstr,1,w) .. "*";
 tmpstr=string.sub(tmpstr,w+1,-1);
 end
 else
 newstr=newstr .. tmpstr;
 break;
 end
 end
 return newstr,num;
end
function DrawMulitStrBox(str,color,size) --显示多行剧情
 local x,y=145,250;
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 x,y=113,298;
 end
 local sid=lib.SaveSur(x,y,x+382,y+126);
 color=color or C_WHITE;
 size=size or 16;
 local strarray={}
 local num,maxlen;
 maxlen=0
 str=GenTalkString(str,21);
 num,strarray=Split(str,'*')
 for i=1,num do
 local len=#strarray[i];
 if len>maxlen then
 maxlen=len
 end
 end
 if maxlen==0 then
 return;
 end
 lib.PicLoadCache(4,50*2,x,y,1);
 for i=1,num do
 DrawString(x+CC.MenuBorderPixel*3,y+CC.MenuBorderPixel*3+(size+4)*(i-1),strarray[i],color,size);
 end
 ShowScreen();
 WaitKey();
 lib.LoadSur(sid,x,y);
 lib.FreeSur(sid);
 ShowScreen();
end
----------------------------------------------------------------
-- SetFlag(eid,flag)
-- 设置事件
-- eid 事件id
-- flag 事件状态
----------------------------------------------------------------
function SetFlag(eid,flag)
 JY.Base["事件"..eid]=flag;
end
----------------------------------------------------------------
-- GetFlag(eid)
-- 检查事件
-- eid 事件id
-- >0返回真，否则返回假
----------------------------------------------------------------
function GetFlag(eid)
 if JY.Base["事件"..eid]>0 then
 return true;
 else
 return false;
 end
end
----------------------------------------------------------------
-- WarModifyAI(pid,ai)
-- 修改武将AI
-- pid 武将id
-- ai 
----------------------------------------------------------------
function WarModifyAI(pid,ai,p1,p2)
 pid=pid+1; --修正
 local wid=GetWarID(pid);
 if wid>0 then
 War.Person[wid].ai=ai;
 if ai==3 or ai==5 then
 War.Person[wid].aitarget=p1+1;
 elseif ai==4 or ai==6 then
 War.Person[wid].ai_dx=p1+1;
 War.Person[wid].ai_dy=p2+1;
 end
 end
end
----------------------------------------------------------------
-- ModifyForce(pid,fid)
-- 修改武将阵营
-- pid 武将id
-- fid 阵营id，默认为1
----------------------------------------------------------------
function ModifyForce(pid,fid)
 if pid==nil then
 return;
 end
 fid=fid or 1;
 --修改武将数量统计
 if JY.Person[pid]["君主"]==1 and fid~=1 then
 JY.Base["武将数量"]=JY.Base["武将数量"]-1;
 end
 if JY.Person[pid]["君主"]~=1 and fid==1 then
 JY.Base["武将数量"]=JY.Base["武将数量"]+1;
 end
 --如果加入我方，额外确认等级
 if fid==1 then

JY.Person[pid]["等级"]=limitX(JY.Person[pid]["等级"],3,99);

if CC.Enhancement then
if JY.Status~=GAME_WMAP then
local dtlv=pjlv()
if JY.Person[pid]["等级"]<dtlv then
--JY.Person[pid]["等级"]=dtlv
end
end
end

 end
 
 JY.Person[pid]["君主"]=fid;
 local picid=GetPic(pid);
 if fid==1 and type(War.Person)=="table" then--战斗时如果君主改为刘备，还需要额外修改战斗部分属性
 for i,v in pairs(War.Person) do
 if v.id==pid then
 v.enemy=false;
 v.friend=false;
 v.pic=WarGetPic(i);
v.ai=1
 break;
 end
 end
 end
end
----------------------------------------------------------------
-- ModifyBZ(pid,bzid)
-- 修改武将兵种
-- pid 武将id
-- bzid 兵种id，默认为1
----------------------------------------------------------------
function ModifyBZ(pid,bzid)
 if pid==nil then
 return;
 end
 bzid=bzid or 1;
 JY.Person[pid]["兵种"]=bzid;
end
----------------------------------------------------------------
-- LoadPic(id,flag)
-- 显示过场图片（带边框），带淡入淡出效果
-- flag 0.无效果 1.淡入 2.淡出
----------------------------------------------------------------
function LoadPic(id,flag)
 local w,h=238,158;
 local x=16+640/2-w/2;
 local y=16+64;
 flag=flag or 0;
 if between(id,3,33) then
 DrawSMap();
 local sid=lib.SaveSur(x,y,x+w,y+h);
 if flag==0 then
 lib.PicLoadCache(4,id*2,x,y,1);
 elseif flag==1 then --淡入
 for i=0,256,4 do
 JY.ReFreshTime=lib.GetTime();
 lib.LoadSur(sid,x,y);
 lib.PicLoadCache(4,id*2,x,y,1+2,i);
 lib.GetKey();
 ReFresh();
 end
 elseif flag==2 then --淡出
 for i=0,256,4 do
 JY.ReFreshTime=lib.GetTime();
 lib.LoadSur(sid,x,y);
 lib.PicLoadCache(4,id*2,x,y,1+2,256-i);
 lib.GetKey();
 ReFresh();
 end
 end
 lib.FreeSur(sid);
 end
 for i=1,CC.OpearteSpeed*2 do
 JY.ReFreshTime=lib.GetTime();
 lib.GetKey();
 ReFresh();
 end
end
function talk(...)
 local arg={};
 for i,v in pairs({...}) do
 arg[i]=v;
 end
 local n=math.modf(#arg/2);
 local f=0;
 for i=0,n-1 do
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 WarPersonCenter(GetWarID(arg[i*2+1]));
 f=2;
 end
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 DrawWarMap();
 else
 JY.Tid=arg[i*2+1];
 DrawSMap();
 end
 talk_sub(arg[i*2+1],arg[i*2+2],true,i%2+f);
 --if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 -- DrawWarMap();
 --else
 -- DrawSMap();
 --end
 JY.ReFreshTime=lib.GetTime();
 ReFresh();
 end
 JY.Tid=0;
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 DrawWarMap();
 else
 DrawSMap();
 end
end
function talkYesNo(id,s)
 local x4=512;
 local x3=x4-52;
 local x2=x4-56
 local x1=x3-56
 local y2=140;
 local y1=y2-24;
 JY.Tid=id;
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 --DrawWarMap();
 else
 --DrawSMap();
 end
 talk_sub(id,s);
 JY.Tid=0;
 local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH);
 local function redraw(flag)
 JY.ReFreshTime=lib.GetTime();
 lib.LoadSur(sid,0,0);
 if flag==1 then
 lib.PicLoadCache(4,52*2,x1,y1,1);
 else
 lib.PicLoadCache(4,51*2,x1,y1,1);
 end
 if flag==2 then
 lib.PicLoadCache(4,54*2,x3,y1,1);
 else
 lib.PicLoadCache(4,53*2,x3,y1,1);
 end
 ReFresh();
 end
 local current=0;
 while true do
 redraw(current);
 getkey();
 if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
 current=1;
 elseif MOUSE.HOLD(x3+1,y1+1,x4-1,y2-1) then
 current=2;
 elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
 current=0;
 PlayWavE(0);
 redraw(current);
 lib.Delay(100);
 lib.FreeSur(sid);
 return true;
 elseif MOUSE.CLICK(x3+1,y1+1,x4-1,y2-1) then
 current=0;
 PlayWavE(0);
 redraw(current);
 lib.Delay(100);
 lib.FreeSur(sid);
 return false;
 else
 current=0;
 end
 end
end
function talk_sub(id,s,pause,flag)
 local talkxnum=19; --对话一行字数
 local talkynum=3; --对话行数
 pause=pause or false;
 flag=flag or 0;
 --显示头像和对话的坐标
 local mx,my=140,100;
 local xy={ [0]={headx=144,heady=60,
 talkx=224,talky=80,
 mx=144,my=60},
 {headx=144,heady=292,
 talkx=224,talky=312,
 mx=144,my=292},
 {headx=112,heady=76,
 talkx=192,talky=96,
 mx=112,my=76},
 {headx=112,heady=340,
 talkx=192,talky=360,
 mx=112,my=340}, }

 if string.find(s,"*") ==nil then
 s=GenTalkString(s,talkxnum);
 end

 if CONFIG.KeyRepeat==0 then
 lib.EnableKeyRepeat(0,CONFIG.KeyRepeatInterval);
 end
 local size=16;
 local headid=JY.Person[id]["头像代号"];
 local startp=1
 local endp;
 local dy=0;
 local sid;
 while true do
 if dy==0 then
 JY.ReFreshTime=lib.GetTime();
 DrawYJZBox_sub(xy[flag].mx,xy[flag].my,384,80);
 lib.PicLoadCache(2,headid*2,xy[flag].headx,xy[flag].heady,1);
 DrawString(xy[flag].talkx,xy[flag].heady,JY.Person[id]["姓名"],C_Name,size);
 end
 endp=string.find(s,"*",startp);
 if endp==nil then
 DrawString(xy[flag].talkx, xy[flag].talky + dy * (size+4),string.sub(s,startp),C_WHITE,size);
 ReFresh();
 if pause then
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 sid=lib.SaveSur(xy[flag].mx-15,xy[flag].my-15,xy[flag].mx+414-15,xy[flag].my+110-15);
 end
 while true do
 local eventtype=lib.GetMouse(1);
 if eventtype==1 or eventtype==3 then
 lib.Delay(100);
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 lib.FreeSur(sid);
 end
 break;
 end
 JY.ReFreshTime=lib.GetTime();
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 DrawWarMap();
 lib.LoadSur(sid,xy[flag].mx-15,xy[flag].my-15);
 end
 ReFresh();
 end
 end
 break;
 else
 DrawString(xy[flag].talkx, xy[flag].talky + dy * (size+4),string.sub(s,startp,endp-1),C_WHITE,size);
 end
 dy=dy+1;
 startp=endp+1;
 if dy>=talkynum then
 ReFresh();
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 sid=lib.SaveSur(xy[flag].mx-15,xy[flag].my-15,xy[flag].mx+414-15,xy[flag].my+110-15);
 end
 while true do
 local eventtype=lib.GetMouse(1);
 if eventtype==1 or eventtype==3 then
 lib.Delay(100);
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 lib.FreeSur(sid);
 end
 break;
 end
 JY.ReFreshTime=lib.GetTime();
 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 DrawWarMap();
 lib.LoadSur(sid,xy[flag].mx-15,xy[flag].my-15);
 end
 ReFresh();
 end
 dy=0;
 end
 end
 if CONFIG.KeyRepeat==0 then
 lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRepeatInterval);
 end

end
function AddPerson(id,x,y,d)
 table.insert(JY.Smap,{id,x,y,d,0});
end

function DecPerson(id)
 for i,v in pairs(JY.Smap) do
 if v[1]==id then
 table.remove(JY.Smap,i);
 break;
 end
 end
end
function Person_Menu()
 local menu={
 {" 武将情报",nil,1},
 {" 交换道具",nil,1},
 {"　 修炼",nil,1},
 }
 DrawYJZBox(32,32,"武将",C_WHITE,true)
local ccs=2

if CC.Enhancement then
ccs=3
end 
 
 local r=ShowMenu(menu,ccs,0,546,264,0,0,3,1,16,C_WHITE,C_WHITE);
 if r==1 then
 PersonStatus_Menu(1);
 elseif r==2 then
 ExchangeItem(1);
 elseif r==3 then
 Maidan(1);
 end
end
function PersonStatus_Menu(fid)
 local menu={};
 local n=0;
 for i=1,JY.PersonNum-1 do
 if JY.Person[i]["君主"]==fid then
 menu[i]={fillblank(JY.Person[i]["姓名"],11),PersonStatus,1};
 n=n+1;
 else
 menu[i]={"",nil,0};
 end
 end
 DrawYJZBox(32,32,"武将情报",C_WHITE,true)
 if n<=8 then
 ShowMenu(menu,JY.PersonNum-1,8,546,224,0,0,5,1,16,C_WHITE,C_WHITE);
 else
 ShowMenu(menu,JY.PersonNum-1,8,530,224,0,0,6,1,16,C_WHITE,C_WHITE);
 end
end

function PersonStatus(pid,x,y,flag)
 flag=flag or 0;

 if type(x)=='number' and type(y)=='number' then
 
 else

 if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
 x=16+(576-456)/2;
 y=32+(432-276)/2;
 elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
 x=16+(640-456)/2;
 y=16+(400-276)/2;
 else
 x=(CC.ScreenW-456)/2;
 y=(CC.ScreenH-276)/2;
 end

 end

 local p=JY.Person[pid];
 local close=false;

 if flag==0 then
 DrawSMap();
 DrawYJZBox(32,32,"武将情报",C_WHITE,true)
 end

 local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH);

 local function redraw()
 JY.ReFreshTime=lib.GetTime();
 lib.LoadSur(sid,0,0);
 PersonStatus_sub(pid,x,y);
 if close then
 lib.PicLoadCache(4,56*2,x+384,y+16,1);
 else
 lib.PicLoadCache(4,55*2,x+384,y+16,1);
 end
 ReFresh();
 end

 while true do
 redraw();
 local eventtype,keypress,mx,my=getkey();

 if eventtype==3 and keypress==3 then
 PlayWavE(1);
 lib.Delay(20);
 break;
 end

 if MOUSE.HOLD(x+384+1,y+16+1,x+384+52-1,y+16+24-1) then
 close=true;
 elseif MOUSE.CLICK(x+384+1,y+16+1,x+384+52-1,y+16+24-1) then
 PlayWavE(0);
 close=false;
 redraw();
 lib.Delay(20);
 break;
 else
 close=false;
 end

 for i=1,8 do
 local iid=JY.Person[pid]["道具"..i];
 if iid>0 then
 if MOUSE.CLICK(x+340,y+112+i*16,x+340+#JY.Item[iid]["名称"]*16/2,y+112+(i+1)*16) then
 PlayWavE(0);
 DrawItemStatus(iid,pid);
 end
 end
 end

 for i,v in pairs({"武器","防具","辅助"}) do
 local iid=JY.Person[pid][v];
 if iid>0 then
 if MOUSE.CLICK(x+184+16*4,y+183+i*21,x+184+16*4+#JY.Item[iid]["名称"]*16/2,y+183+i*21+16) then
 PlayWavE(0);
 DrawItemStatus(iid,pid);
 end
 end
 end

 if MOUSE.CLICK(x+24,y+24,x+24+64,y+24+80) then
 local name=p["姓名"];
 if type(CC.LieZhuan[name])=='string' then
 DrawLieZhuan(name);
 end
 end

if MOUSE.CLICK(x+111,y+55,x+111+48,y+55+48) then

local bzkz="*克制："
for i=1,9 do
if JY.Bingzhong[p["兵种"]]["克制"..i]>0 then
bzkz=bzkz..JY.Bingzhong[JY.Bingzhong[p["兵种"]]["克制"..i]]["名称"].." "
end
if i==9 and bzkz=="*克制：" then
bzkz=""
end
end

DrawStrStatus("三国英杰兵种 - "..JY.Bingzhong[p["兵种"]]["名称"],JY.Bingzhong[p["兵种"]]["说明"]..bzkz)
 end


 if CC.Enhancement then
 local box_w=36;
 local box_h=20;
 for i=1,6 do
 local cx=x+56+box_w*((i-1)%3);
 local cy=y+220+box_h*math.modf((i-1)/3);
 if MOUSE.CLICK(cx+1,cy+1,cx+box_w,cy+box_h) then
 if p["等级"]>=CC.SkillExp[p["成长"]][i] then
 DrawSkillStatus(JY.Person[pid]["特技"..i])
 end
 end
 end
 end

 if CC.Debug==1 then
 if MOUSE.HOLD(x+44,y+96+1*32,x+44+120,y+96+1*32+10) then
 JY.Person[pid]["武力"]=limitX((MOUSE.x-x-44)*100/120,1,100);
 end
 if MOUSE.HOLD(x+44,y+96+2*32,x+44+120,y+96+2*32+10) then
 JY.Person[pid]["智力"]=limitX((MOUSE.x-x-44)*100/120,1,100);
 end
 if MOUSE.HOLD(x+44,y+96+3*32,x+44+120,y+96+3*32+10) then
 JY.Person[pid]["统率"]=limitX((MOUSE.x-x-44)*100/120,1,100);
 end
 end

 end

 lib.FreeSur(sid);
end

function PersonStatus_sub(pid,x,y)
 x=x or 208;
 y=y or 72;
 ReSetAttrib(pid,false);
 JY.Person[pid]["战斗动作"]=GetPic(pid,false,false);
 lib.PicLoadCache(4,85*2,x,y,1);
 local p=JY.Person[pid];
 local b=JY.Bingzhong[p["兵种"]];
 DrawString(x+135-#p["姓名"]*16/4,y+20,p["姓名"],C_WHITE,16);
 DrawString(x+184,y+20,p["等级"].."级".."（"..p["经验"].."％） "..b["名称"],C_WHITE,16);
 lib.Background(x+184-4,y+48,x+184+16*16+4,y+112,192);
 --DrawStr(x+184,y+48+8,GenTalkString(b["说明"],16),C_WHITE,16);


if CC.Enhancement then
DrawStr(x+184,y+48+8,GenTalkString("天赋："..JY.Skill[p["天赋"]]["名称"].."*"..JY.Skill[p["天赋"]]["说明"],16),C_WHITE,16);
else
DrawStr(x+184,y+48+8,GenTalkString(b["说明"],16),C_WHITE,16);
end

 lib.PicLoadCache(2,p["头像代号"]*2,x+24,y+24,1);
 lib.PicLoadCache(1,(p["战斗动作"]+19)*2,x+111,y+55,1);

 DrawString(x+184,y+120,"兵 力　　"..p["最大兵力"],C_WHITE,16);
 DrawString(x+184,y+141,"攻击力　 "..p["攻击"],C_WHITE,16);
 DrawString(x+184,y+162,"防御力　 "..p["防御"],C_WHITE,16);
 DrawString(x+184,y+183,"移动力",C_WHITE,16);
 if b["移动"]==p["移动"] then
 DrawString(x+184+16*4,y+183,"　"..b["移动"],C_WHITE,16);
 else
 DrawString(x+184+16*4,y+183,string.format("%d(%+d)",p["移动"],p["移动"]-b["移动"]),C_WHITE,16);
 end
 --DrawString(x+184,y+200,"策略值 "..p["最大策略"],C_WHITE,16);
 --DrawString(x+184,y+220,"经验值 "..p["经验"],C_WHITE,16);
 DrawString(x+184,y+204,"武 器",C_WHITE,16);
 DrawString(x+184,y+225,"防 具",C_WHITE,16);
 DrawString(x+184,y+246,"辅 助",C_WHITE,16);
 if p["武器"]>0 then
 DrawString(x+184+16*4,y+204,JY.Item[p["武器"]]["名称"],C_WHITE,16);
 end
 if p["防具"]>0 then
 DrawString(x+184+16*4,y+225,JY.Item[p["防具"]]["名称"],C_WHITE,16);
 end
 if p["辅助"]>0 then
 DrawString(x+184+16*4,y+246,JY.Item[p["辅助"]]["名称"],C_WHITE,16);
 end
 local len=100;
 for i,v in pairs({"武力","智力","统率"}) do
 local v1=p[v..'2'];
 local v2=p[v];
 local color;
 if v1<30 then
 color=210;
 elseif v1<70 then
 color=211;
 else
 color=212;
 end

 lib.FillColor(x+44,y+87+i*32,x+44+len,y+87+10+i*32,C_BLACK);
 lib.SetClip(x+44,y+87+i*32,x+44+len*v1/100,y+87+10+i*32);
 lib.PicLoadCache(4,color*2,x+44,y+87+i*32,1);
 lib.SetClip(0,0,0,0);

 local str;
 str=string.format("%d",v1);
 DrawString2(x+44+60-16*#str/4,y+87-3+i*32,str,C_WHITE,16);
 if v1~=v2 then
 str=string.format("(%+d)",v1-v2);
 DrawString2(x+48+104,y+89-3+i*32,str,C_WHITE,12);
 end
 end


 for i,v in pairs({"武力经验","智力经验","统率经验"}) do
 local v1=p[v];

local swjy=v1
if v=="武力经验" and p["武力"]==100 then
swjy=200
elseif v=="智力经验" and p["智力"]==100 then
swjy=200
elseif v=="统率经验" and p["统率"]==100 then
swjy=200
end

 local color;
 if swjy<30 then
 color=210;
 elseif swjy<70 then
 color=211;
 else
 color=212;
 end

 lib.FillColor(x+44,y+103+i*32,x+44+len,y+103+10+i*32,C_BLACK);
 lib.SetClip(x+44,y+103+i*32,x+44+len*swjy/200,y+103+10+i*32);
 lib.PicLoadCache(4,color*2,x+44,y+103+i*32,1);
 lib.SetClip(0,0,0,0);

 local str;
 str=string.format("%d",math.modf(swjy/2)).."％"--string.format("%d",swjy);
if swjy==200 then str="MAX" end DrawString2(x+44+60-16*#str/4,y+103-3+i*32,str,C_WHITE,16);

 end

if CC.Enhancement then
 DrawString(x+16,y+220,"技能",C_WHITE,16);
 DrawSkillTable(pid,x+56,y+220);
end

 --道具
 for i=1,8 do
 local tid=p["道具"..i];
 if tid>0 then
 DrawString(x+340,y+112+i*16,JY.Item[tid]["名称"],C_WHITE,16);
 else
 if i==1 then
 DrawString(x+340,y+112+i*16,"无携带品",C_WHITE,16);
 end
 break;
 end
 end

end


----------------------------------------------------------------
-- ExchangeItem(fid)
-- 交换道具
-- fid,君主id 一般应该是1，刘备
-- flag, 标记，，默认为false，如果为true，会有额外提示“交换道具吗？”
----------------------------------------------------------------
function ExchangeItem(fid,flag)
 fid=fid or 1;
 flag=flag or false;
 local num=0;
 local page=1;
 local maxpage=1;
 local num_per_page=6;
 local personnum=1;
 local current=1;
 local status=1; --1选择第一个人 2选择道具 3 选择第二个人
 local iid=0; --选中的item位置
 TeamSelect={id={},status={}};
 for i=1,JY.PersonNum-1 do
 if JY.Person[i]["君主"]==fid then
 ReSetAttrib(i,true);
 JY.Person[i]["战斗动作"]=GetPic(i,false,false);
 num=num+1;
 TeamSelect.id[num]=i;
 TeamSelect.status[num]=0; --0未选择 1选择(可取消) 2选择(不可取消)
 end
 end
 maxpage=math.modf((num-1)/6)+1;
 --------------------------------
 -- 定义坐标信息
 --------------------------------
 local xy= {
 x1={}, --左上角(边框内，实际部队图标显示位置)
 y1={},
 x2={}, --兵力
 y2={},
 x3={}, --姓名
 y3={},
 x4={}, --右下角
 y4={},
 }
 xy.x1={56,232,56,232,56,232};
 xy.y1={64,64,154,154,244,244};
 for i=1,6 do
 xy.x1[i]=xy.x1[i]+16;
 xy.y1[i]=xy.y1[i]+16;
 end
 for i=1,6 do
 xy.x2[i]=xy.x1[i]+104;
 xy.y2[i]=xy.y1[i]+17;
 xy.x3[i]=xy.x1[i]+104;
 xy.y3[i]=xy.y1[i]+41;
 xy.x4[i]=xy.x1[i]+143;
 xy.y4[i]=xy.y1[i]+63;
 end
 local bottom=0; --当前按钮
 --------------------------------
 -- redraw()
 -- 内部函数，重绘
 -- frame 用于控制动画显示
 --------------------------------
 local cid=0;
 local subframe,frame=0,0;
 local kind={[0]="无","攻击用","恢复用","变换用","宝物","兵书","名马","恢复用","种子","种子","种子","武器","防具","马车","无",}
 local titlestr="交换哪名武将的道具？请选择．";
 local function redraw()
 JY.ReFreshTime=lib.GetTime();
 lib.FillColor(0,0,0,0,0);
 lib.PicLoadCache(4,201*2,0,0,1);
 DrawGameStatus();
 lib.PicLoadCache(4,203*2,16,16,1);
 DrawString(26,31,titlestr,C_WHITE,16);
 for i=1,6 do
 local idx=num_per_page*(page-1)+i;
 if idx>num then
 break;
 end
 local pid=TeamSelect.id[idx];
 local name=JY.Person[pid]["姓名"];
 local hp=string.format("% 5d",JY.Person[pid]["最大兵力"]);
 local lv=string.format("% 5d",JY.Person[pid]["等级"]);
 local picid;
 if TeamSelect.status[idx]==0 then --未选择时，为+19
 picid=JY.Person[pid]["战斗动作"]+19;
 DrawString(xy.x3[i]-4*#name,xy.y3[i],name,C_WHITE,16);
 lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1);
 lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128);
 else
 picid=JY.Person[pid]["战斗动作"]+12+frame;
 DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_DarkOrange,16);
 lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128);
 lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1);
 end
 DrawString(xy.x2[i],xy.y2[i],hp,C_WHITE,16);
 DrawString(xy.x1[i]+4,xy.y1[i]+48,lv,C_WHITE,16);
 end
 DrawString(110,359,string.format("% 4d",page),C_WHITE,16);
 DrawString(142,359,string.format("% 4d",maxpage),C_WHITE,16);
 --DrawString(252,359,string.format("% 4d",personnum),C_WHITE,16);
 --选中人物
 cid=TeamSelect.id[current];
 lib.PicLoadCache(2,JY.Person[cid]["头像代号"]*2,464,32,1);
 DrawString(489-3*#JY.Person[cid]["姓名"],136,JY.Person[cid]["姓名"],C_WHITE,16);
DrawString(584-4*#JY.Bingzhong[JY.Person[cid]["兵种"]]["名称"],24,JY.Bingzhong[JY.Person[cid]["兵种"]]["名称"],C_WHITE,16);
 DrawString(585,48,string.format("% 5d",JY.Person[cid]["等级"]),C_WHITE,16);
 DrawString(585,80,string.format("% 5d",JY.Person[cid]["统率"]),C_WHITE,16);
 DrawString(585,112,string.format("% 5d",JY.Person[cid]["武力"]),C_WHITE,16);
 DrawString(585,144,string.format("% 5d",JY.Person[cid]["智力"]),C_WHITE,16);
 if bottom==1 then
 lib.PicLoadCache(4,224*2,173,351,1);
 elseif bottom==2 then
 lib.PicLoadCache(4,225*2,173,367,1);
 elseif bottom==3 then
 lib.PicLoadCache(4,226*2,317,351,1);
 end
 --道具
 for i=1,8 do
 local tid=JY.Person[cid]["道具"..i];
 local color=C_WHITE;
 if TeamSelect.status[current]==1 and i==iid then
 color=M_DarkOrange;
 end
 if tid>0 then
 DrawString(466,176+i*18,JY.Item[tid]["名称"],color,16);
 DrawString(562,176+i*18,"／"..kind[JY.Item[tid]["类型"]],color,16);
 else
 if i==1 then
 DrawString(466,176+i*18,"无携带品．",C_WHITE,16);
 end
 break;
 end
 end
 ReFresh();
 subframe=subframe+1;
 if subframe==8 then
 frame=1-frame;
 subframe=0;
 end
 end
 Dark();
 redraw();
 Light();
 if flag then
 if not WarDrawStrBoxYesNo('交换道具吗？',C_WHITE,true) then
 redraw();
 return;
 end
 end
 while JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL do
 redraw();
 local eventtype,keypress=getkey();
 bottom=0;
 if MOUSE.EXIT() then
 PlayWavE(0);
 if WarDrawStrBoxYesNo('结束游戏吗？',C_WHITE,true) then
 lib.Delay(100);
 if WarDrawStrBoxYesNo('再玩一次吗？',C_WHITE,true) then
 lib.Delay(100);
 JY.Status=GAME_START;
 else
 lib.Delay(100);
 JY.Status=GAME_END;
 end
 end
 elseif MOUSE.HOLD(174,352,204,366) then --page up
 bottom=1;
 elseif MOUSE.HOLD(174,368,204,382) then --page down
 bottom=2;
 elseif MOUSE.HOLD(319,353,362,380) then --close
 bottom=3;
 elseif MOUSE.CLICK(174,352,204,366) then --page up
 PlayWavE(0);
 page=limitX(page-1,1,maxpage);
 elseif MOUSE.CLICK(174,368,204,382) then --page down
 PlayWavE(0);
 page=limitX(page+1,1,maxpage);
 elseif MOUSE.CLICK(319,353,362,380) and status==1 then --close
 PlayWavE(0);
 for i=1,CC.OpearteSpeed do
 redraw();
 end
 if WarDrawStrBoxYesNo("　可以吗？　",C_WHITE,true) then
 redraw();
 if not flag then
 Dark();
 DrawSMap();
 Light();
 end
 return;
 end
 elseif MOUSE.CLICK(464,32,464+64,32+80) then --head
 PlayWavE(0);
 PersonStatus(cid,"","",1);
 elseif eventtype==4 and keypress==3 then
 if status==2 then
 PlayWavE(1);
 TeamSelect.status[current]=0;
 titlestr="交换哪名武将的道具？请选择．";
 iid=0;
 status=1;
 elseif status==3 then
 PlayWavE(1);
 titlestr="请选择要交换的道具．";
 iid=0;
 status=2;
 end
 else
 for i=1,6 do
 if MOUSE.CLICK(xy.x1[i],xy.y1[i],xy.x4[i],xy.y4[i]) then
 local idx=num_per_page*(page-1)+i;
 if idx<=num then
 if status==1 then
 current=idx;
 cid=TeamSelect.id[idx];
 if JY.Person[cid]["道具1"]==0 then
 PlayWavE(2);
 titlestr=JY.Person[cid]["姓名"].."什么也没有．";
 for n=1,20 do
 redraw();
 lib.GetKey();
 end
 titlestr="交换哪名武将的道具？请选择．";
 else
 PlayWavE(0);
 TeamSelect.status[idx]=1;
 titlestr="请选择要交换的道具．";
 status=2;
 end
 elseif status==2 then
 if TeamSelect.status[idx]==1 then
 PlayWavE(1);
 TeamSelect.status[idx]=0;
 titlestr="交换哪名武将的道具？请选择．";
 status=1;
 else
 PlayWavE(2);
 end
 elseif status==3 then
 local odx=current;
 current=idx;
 cid=TeamSelect.id[idx];
 local oid=TeamSelect.id[odx];
 local item=JY.Person[oid]["道具"..iid];
 if idx==odx then
 --什么都不做
 PlayWavE(2);
 elseif JY.Person[cid]["道具8"]>0 then
 PlayWavE(2);
 titlestr=JY.Person[cid]["姓名"].."已不能再持有道具．";
 --titlestr="已不能再持有道具．";
 for n=1,20 do
 redraw();
 lib.GetKey();
 end
 current=odx;
 titlestr=JY.Item[item]["名称"].."交给谁？";
 else
 PlayWavE(0);
 redraw();
 if WarDrawStrBoxYesNo("交给"..JY.Person[cid]["姓名"].."可以吗？",C_WHITE,true) then
 --
 for n=iid,7 do
 JY.Person[oid]["道具"..n]=JY.Person[oid]["道具"..(n+1)];
 end
 JY.Person[oid]["道具8"]=0;
 for n=1,8 do
 if JY.Person[cid]["道具"..n]==0 then
 JY.Person[cid]["道具"..n]=item;
 break;
 end
 end
 --
 titlestr="交换哪名武将的道具？请选择．";
 TeamSelect.status[odx]=0;
 iid=0;
 status=1;
 else
 titlestr=JY.Item[item]["名称"].."交给谁？";
 current=odx;
 --titlestr="请选择要交换的道具．";
 --current=odx;
 --iid=0;
 --status=2;
 end
 end
 end
 end
 break;
 end
 end
 for i=1,8 do
 if MOUSE.CLICK(466,176+i*18,626,176+16+i*18) then
 cid=TeamSelect.id[current];
 local item=JY.Person[cid]["道具"..i];
 if item>0 then
 if status==1 then
 PlayWavE(0);
 DrawItemStatus(item,cid);
 elseif status==2 then
 PlayWavE(0);
 iid=i;
 titlestr=JY.Item[item]["名称"].."交给谁？";
 status=3;
 elseif status==3 then
 if iid==i then
 PlayWavE(1);
 titlestr="请选择要交换的道具．";
 iid=0;
 status=2;
 else
 PlayWavE(2);
 end
 end
 end
 break;
 end
 end
 
 end
 end
end

----------------------------------------------------------------
-- HirePerson()
-- 招揽武将
----------------------------------------------------------------
function HirePerson()

if CC.Enhancement==false then
WarDrawStrBoxConfirm("暂无可招揽的武将．",C_WHITE,true);
return
end

 local num=0;
 local page=1;
 local maxpage=1;
 local num_per_page=6;
 local personnum=1;
 local current=1;
 TeamSelect={id={},status={}};
 --
 --设置新武将属性
 local db={ "李肃","李儒","华雄","董卓",
 "程普","韩当","黄盖","孙坚",
 "麴义","公孙瓒",
 "徐荣","李傕","郭汜",
 "管亥","太史慈",
 "许汜","王楷","郝萌","曹性","高顺","陈宫","吕布",
 "淳于琼","颜良","文丑","陈琳","许攸","逢纪","审配","郭图","田丰","沮授",
 "陈登","纪灵",
 "马腾",
 "王威","蒯越","刘琦","刘琮",
 "阚泽","张昭","诸葛瑾","鲁肃","周瑜",
 "潘璋","吕蒙",
 "蒋钦","周泰","陆逊",
 "张松",
 "张任",
 "杨修",
 "郝昭"};
 local db2={ 23,66,23,66,
 382,382,382,9999,
 226,226,
 144,144,144,
 103,103,
 176,176,176,176,176,226,9999,
 513,348,348,324,324,324,324,324,348,348,
 279,279,
 568,
 424,424,461,461,
 513,513,592,592,9999,
 630,630,
 630,630,655,
 513,
 568,
 568,
 655};
 local db3={
 [4]=385,
 [8]=386,
 [12]=403,
 [16]=404,
 [20]=405,
 [24]=388,
 }
 if JY.Base["事件333"]>=9 then
 db2[8]=382; --孙坚
 end
 if JY.Base["事件333"]>=11 then
 db2[22]=226; --吕布
 end
 if JY.Base["事件333"]>=15 then
 db2[44]=513; --周瑜
 end
 for i,v in pairs(db) do
 local p1=JY.Person[420+i];
 if p1["君主"]==0 then
 local p2=JY.Person[420];
 for idx=1,JY.PersonNum-1 do
 if JY.Person[idx]["姓名"]==v then
 p2=JY.Person[idx];
 break;
 end
 end
 for idx,par in pairs({"代号","姓名","外号","性别","武力","智力","统率","天赋","兵种","特技1","特技2","特技3","特技4","特技5","特技6"}) do
 p1[par]=p2[par];
 end
 --lvbu
 --if v=="吕布" then
 --p1["特技4"]=34;
 --end
 --
 p1["成长"]=10;
p1["等级"]=math.modf((JY.Person[1]["等级"]+JY.Person[2]["等级"]+JY.Person[3]["等级"]+JY.Person[54]["等级"]+JY.Person[126]["等级"])/6)-5;
p1["等级"]=limitX(p1["等级"],3,99);

if CC.Enhancement then
local dtlv=pjlv()
if p1["等级"]<dtlv then
p1["等级"]=dtlv
end
end

 if p2["新头像代号"]>0 then
 p1["头像代号"]=p2["新头像代号"];
 else
 p1["头像代号"]=p2["头像代号"];
 end
 p1["新头像代号"]=db2[i]; --用这个来卡 多少多少关之后才能加入
 end
 end
 --
 for i=421,JY.PersonNum-1 do
 if JY.Person[i]["头像代号"]>0 and JY.Person[i]["新头像代号"]<JY.EventID then
 ReSetAttrib(i,true);
 JY.Person[i]["战斗动作"]=GetPic(i,false,false);
 num=num+1;
 TeamSelect.id[num]=i;
 if JY.Person[i]["君主"]==1 then
 TeamSelect.status[num]=1; --0未选择 1选择
 else
 TeamSelect.status[num]=0;
 end
 end
 end
 for i,v in pairs(db3) do
 if JY.Base["事件333"]>=i then
 ReSetAttrib(v,true);
 JY.Person[v]["战斗动作"]=GetPic(v,false,false);
 num=num+1;
 TeamSelect.id[num]=v;
 if JY.Person[v]["君主"]==1 then
 TeamSelect.status[num]=1; --0未选择 1选择
 else
 JY.Person[v]["成长"]=10;

 JY.Person[v]["等级"]=math.modf((JY.Person[1]["等级"]+JY.Person[2]["等级"]+JY.Person[3]["等级"]+JY.Person[54]["等级"]+JY.Person[126]["等级"])/6)-5;
 JY.Person[v]["等级"]=limitX(JY.Person[v]["等级"],3,99);


if CC.Enhancement then
local dtlv=pjlv()
if JY.Person[v]["等级"]<dtlv then
JY.Person[v]["等级"]=dtlv
end
end

 TeamSelect.status[num]=0;
 end
 end
 end
 if num==0 then
 WarDrawStrBoxConfirm("暂无可招揽的武将．",C_WHITE,true);
 return;
 end
 
 maxpage=math.modf((num-1)/6)+1;
 --------------------------------
 -- 定义坐标信息
 --------------------------------
 local xy= {
 x1={}, --左上角(边框内，实际部队图标显示位置)
 y1={},
 x2={}, --兵力
 y2={},
 x3={}, --姓名
 y3={},
 x4={}, --右下角
 y4={},
 }
 xy.x1={56,232,56,232,56,232};
 xy.y1={64,64,154,154,244,244};
 for i=1,6 do
 xy.x1[i]=xy.x1[i]+16;
 xy.y1[i]=xy.y1[i]+16;
 end
 for i=1,6 do
 xy.x2[i]=xy.x1[i]+104;
 xy.y2[i]=xy.y1[i]+17;
 xy.x3[i]=xy.x1[i]+104;
 xy.y3[i]=xy.y1[i]+41;
 xy.x4[i]=xy.x1[i]+143;
 xy.y4[i]=xy.y1[i]+63;
 end
 local bottom=0; --当前按钮
 local function GetPersonValue(pid)
 --计算招揽价格
 local p=JY.Person[pid];
 --local v=20*(p["等级"]);
local v=40000/(120-p["武力"])+40000/(120-p["智力"])+40000/(120-p["统率"]);
 if p["兵种"]==14 then
 v=v+200;
 elseif p["兵种"]==15 then
 v=v+300;
 elseif p["兵种"]==16 then
 v=v+1000;
 elseif p["兵种"]==17 then
 v=v+400;
 elseif p["兵种"]>=20 then
 v=v+800;
 end

if p["姓名"]=="武松" then
v=v+1000
end

if p["姓名"]=="太史慈" then
v=v+1000
end

if p["姓名"]=="鲁智深" then
v=v+2000
end

if p["姓名"]=="貂蝉" then
v=v+1500
end

if p["姓名"]=="陈平" then
v=v+2500
end

if p["姓名"]=="胡笛" then
v=v+3000
end

if p["姓名"]=="hnc" then
v=v+3000
end

if p["姓名"]=="吕布" then
v=v+4000
end

if p["姓名"]=="周瑜" then
v=v+2500
end

 v=100*math.modf(v/100);
 v=limitX(v,500,10000);
v=math.modf(v/2) --降低招揽价格
 if CC.Debug==1 then
 v=500;
 end
 return v;
 end
 --------------------------------
 -- redraw()
 -- 内部函数，重绘
 -- frame 用于控制动画显示
 --------------------------------
 local cid=0;
 local subframe,frame=0,0;
 local kind={[0]="无","攻击用","恢复用","变换用","宝物","兵书","名马","恢复用","种子","种子","种子","武器","防具","马车","无",}
 local titlestr="招揽哪名武将？请选择．";
 local function redraw()
 JY.ReFreshTime=lib.GetTime();
 lib.FillColor(0,0,0,0,0);
 lib.PicLoadCache(4,201*2,0,0,1);
 DrawGameStatus();
 lib.PicLoadCache(4,203*2,16,16,1);
 DrawString(26,31,titlestr,C_WHITE,16);
 for i=1,6 do
 local idx=num_per_page*(page-1)+i;
 if idx>num then
 break;
 end
 local pid=TeamSelect.id[idx];
 local name=JY.Person[pid]["姓名"];
 local hp=string.format("% 5d",JY.Person[pid]["最大兵力"]);
 local lv=string.format("% 5d",JY.Person[pid]["等级"]);
 local picid;
 if TeamSelect.status[idx]==0 then --未选择时，为+19
 picid=JY.Person[pid]["战斗动作"]+19;
 DrawString(xy.x3[i]-4*#name,xy.y3[i],name,C_WHITE,16);
 lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1);
 lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128);
 else
 picid=JY.Person[pid]["战斗动作"]+12+frame;
 DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_DarkOrange,16);
 lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128);
 lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1);
 end
 DrawString(xy.x2[i],xy.y2[i],hp,C_WHITE,16);
 DrawString(xy.x1[i]+4,xy.y1[i]+48,lv,C_WHITE,16);
 end
 DrawString(110,359,string.format("% 4d",page),C_WHITE,16);
 DrawString(142,359,string.format("% 4d",maxpage),C_WHITE,16);
 --DrawString(252,359,string.format("% 4d",personnum),C_WHITE,16);
 --选中人物
 cid=TeamSelect.id[current];
 lib.PicLoadCache(2,JY.Person[cid]["头像代号"]*2,464,32,1);
 DrawString(489-3*#JY.Person[cid]["姓名"],136,JY.Person[cid]["姓名"],C_WHITE,16);
 DrawString(584-4*#JY.Bingzhong[JY.Person[cid]["兵种"]]["名称"],24,JY.Bingzhong[JY.Person[cid]["兵种"]]["名称"],C_WHITE,16);
 DrawString(585,48,string.format("% 5d",JY.Person[cid]["等级"]),C_WHITE,16);
 DrawString(585,80,string.format("% 5d",JY.Person[cid]["统率"]),C_WHITE,16);
 DrawString(585,112,string.format("% 5d",JY.Person[cid]["武力"]),C_WHITE,16);
 DrawString(585,144,string.format("% 5d",JY.Person[cid]["智力"]),C_WHITE,16);
 if bottom==1 then
 lib.PicLoadCache(4,224*2,173,351,1);
 elseif bottom==2 then
 lib.PicLoadCache(4,225*2,173,367,1);
 elseif bottom==3 then
 lib.PicLoadCache(4,226*2,317,351,1);
 end
 --道具
 for i=1,8 do
 local tid=JY.Person[cid]["道具"..i];
 local color=C_WHITE;
 if tid>0 then
 DrawString(466,176+i*18,JY.Item[tid]["名称"],color,16);
 DrawString(562,176+i*18,"／"..kind[JY.Item[tid]["类型"]],color,16);
 else
 if i==1 then
 DrawString(466,176+i*18,"无携带品．",C_WHITE,16);
 end
 break;
 end
 end
 ReFresh();
 subframe=subframe+1;
 if subframe==8 then
 frame=1-frame;
 subframe=0;
 end
 end
 Dark();
 redraw();
 Light();
 while JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL do
 redraw();
 local eventtype,keypress=getkey();
 bottom=0;
 if MOUSE.EXIT() then
 PlayWavE(0);
 if WarDrawStrBoxYesNo('结束游戏吗？',C_WHITE,true) then
 lib.Delay(100);
 if WarDrawStrBoxYesNo('再玩一次吗？',C_WHITE,true) then
 lib.Delay(100);
 JY.Status=GAME_START;
 else
 lib.Delay(100);
 JY.Status=GAME_END;
 end
 end
 elseif MOUSE.HOLD(174,352,204,366) then --page up
 bottom=1;
 elseif MOUSE.HOLD(174,368,204,382) then --page down
 bottom=2;
 elseif MOUSE.HOLD(319,353,362,380) then --close
 bottom=3;
 elseif MOUSE.CLICK(174,352,204,366) then --page up
 PlayWavE(0);
 page=limitX(page-1,1,maxpage);
 elseif MOUSE.CLICK(174,368,204,382) then --page down
 PlayWavE(0);
 page=limitX(page+1,1,maxpage);
 elseif MOUSE.CLICK(319,353,362,380) then --close
 PlayWavE(0);
 for i=1,CC.OpearteSpeed do
 redraw();
 end
 if WarDrawStrBoxYesNo("　可以吗？　",C_WHITE,true) then
 redraw();
 Dark();
 DrawSMap();
 Light();
 return;
 end
 elseif MOUSE.CLICK(464,32,464+64,32+80) then --head
 PlayWavE(0);
 PersonStatus(cid,"","",1);
 else
 for i=1,6 do
 if MOUSE.CLICK(xy.x1[i],xy.y1[i],xy.x4[i],xy.y4[i]) then
 local idx=num_per_page*(page-1)+i;
 if idx<=num then
 current=idx;
 cid=TeamSelect.id[idx];
 if TeamSelect.status[idx]==0 then
 PlayWavE(0);
 TeamSelect.status[idx]=1;
 titlestr="招揽"..JY.Person[cid]["姓名"].."．";
 redraw();
 PersonStatus(cid,"","",1);
 redraw();
 local v=GetPersonValue(cid)
 if WarDrawStrBoxYesNo("花"..v.."金，招揽"..JY.Person[cid]["姓名"].."可以吗？",C_WHITE,true) then
 redraw();
 if v>JY.Base["黄金"] then
 PlayWavE(2);
 TeamSelect.status[idx]=0;
 titlestr="黄金不够．";
 for n=1,20 do
 redraw();
 lib.GetKey();
 end
 titlestr="招揽哪名武将？请选择．";
 else
 GetMoney(-v);
 TeamSelect.status[idx]=1;
 ModifyForce(cid,1);
 PlayWavE(11);
 DrawStrBoxCenter(JY.Person[cid]["姓名"].."成为部下．");
 end
 else
 TeamSelect.status[idx]=0;
 titlestr="招揽哪名武将？请选择．";
 end
 else
 PlayWavE(2);
 titlestr=JY.Person[cid]["姓名"].."已经成为部下．";
 for n=1,20 do
 redraw();
 lib.GetKey();
 end
 titlestr="招揽哪名武将？请选择．";
 end
 
 end
 break;
 end
 end
 for i=1,8 do
 if MOUSE.CLICK(466,176+i*18,626,176+16+i*18) then
 cid=TeamSelect.id[current];
 local item=JY.Person[cid]["道具"..i];
 if item>0 then
 PlayWavE(0);
 DrawItemStatus(item,cid);
 end
 break;
 end
 end
 
 end
 end
end

----------------------------------------------------------------
-- Maidan(fid)
-- 练武场
----------------------------------------------------------------
function Maidan(fid)
if CC.Enhancement==false then
WarDrawStrBoxConfirm("练武场已关闭．",C_WHITE,true);
return
end
 fid=fid or 1;
 local lvup_flag=false;
 local m_pid={};
 local m_eid={};
 local num_pid,num_eid=0,0;
 local lv_max=math.modf((JY.Person[1]["等级"]+JY.Person[2]["等级"]+JY.Person[3]["等级"]+JY.Person[54]["等级"]+JY.Person[126]["等级"])/6)-5;
 lv_max=limitX(lv_max,3,99);

if CC.Enhancement then
--lv_max=pjlv()
end

 for i=1,JY.PersonNum-1 do
 if JY.Person[i]["特技1"]>0 then
 if JY.Person[i]["君主"]==fid then
 if JY.Person[i]["等级"]<lv_max then
 num_pid=num_pid+1;
 m_pid[num_pid]=i;
 end
 else
 num_eid=num_eid+1;
 m_eid[num_eid]=i;
 end
 end
 end
 if num_pid>0 and num_eid>10 then
 talk(369,"请问谁要练武？");
 local pid=FightSelectMenu(m_pid);
 if pid<=0 then
 talk(369,"那么，下次再说吧．");
 return;
 end
 local eid=m_eid[math.random(num_eid)];
 talk(369,"那么，开始吧．");
 local magic={};
 for mid=1,JY.MagicNum-1 do
 magic[mid]=false;
 if HaveMagic(pid,mid) then
 magic[mid]=true;
 end
 end
 local s={0,1,2,4,6};
 if fight(pid,eid,s[math.random(5)])==1 then
 talk(369,"真精彩！");
 PlayWavE(11);
 LvUp(pid);
 JY.Person[pid]["经验"]=0;
 DrawStrBoxCenter(JY.Person[pid]["姓名"].."的等级上升了！");
 lvup_flag=true;
 else
 talk(369,"太可惜了．");
 DrawStrBoxCenter(JY.Person[pid]["姓名"].."得到了大量经验．");
 JY.Person[pid]["经验"]=JY.Person[pid]["经验"]+50
 if JY.Person[pid]["经验"]>=100 then
 PlayWavE(11);
 LvUp(pid);
 JY.Person[pid]["经验"]=0;
 DrawStrBoxCenter(JY.Person[pid]["姓名"].."的等级上升了！");
 lvup_flag=true;
 end
 end
 if lvup_flag then
 --提示技能策略习得
 for i=1,6 do
 if JY.Person[pid]["等级"]==CC.SkillExp[JY.Person[pid]["成长"]][i] then
 PlayWavE(11);
 DrawStrBoxCenter(JY.Person[pid]["姓名"].."习得技能"..JY.Skill[JY.Person[pid]["特技"..i]]["名称"].."！");
 break;
 end
 end
 local str="";
 for mid=1,JY.MagicNum-1 do
 if not magic[mid] then
 if HaveMagic(pid,mid) then
 if str=="" then
 str=JY.Magic[mid]["名称"];
 else
 str=str.."、"..JY.Magic[mid]["名称"];
 end
 end
 end
 end
 if #str>0 then
 PlayWavE(11);
 DrawStrBoxCenter(JY.Person[pid]["姓名"].."习得策略"..str.."！");
 end
 end
 else
 talk(369,"没有人需要练武了．");
 end
end

function Shop()
 local sid=JY.Base["道具屋"];
 if sid<=0 then
 PlayWavE(2);
 WarDrawStrBoxConfirm("此地没有道具屋．",C_WHITE,true);
 return
 end
 local shopitem= {
 [1]={41,28,31}, --汜水关之战前,陈留
 [2]={28,31,44}, --虎牢关之战后,北平
 [3]={28,31,53,41,38,35},--信都城之战后,信都
 [4]={28,31,53}, --广川之战后,广川
 --北海之战前,北平/信都
 [5]={28,31,53,41,38,35,34}, --北海之战后,北平/信都/北海,这里只列了北海的
 [6]={28,31,53,50,47}, --徐州I之战后,北平/信都/北海/徐州/下邳，这里只列的徐州的
 --下邳的 31,32,50,47,34
 [7]={20,22,24,26,41,38,35}, --小沛
 [8]={20,22,24,26,28,29,31,53}, --许昌I
 [9]={31,32,50,47,34}, --下邳
 [10]={20,22,24,26,29,31,32,53}, --邺
 [11]={41,38,39,35,44}, --白马
 [12]={41,42,38,39,35,36}, --汝南
 [13]={20,22,24,26,29,32,53,34}, --襄阳I
 [14]={42,39,36,44,45}, --江夏I
 --[15]={29,32,54,50,51,47}, --江陵I
 [15]={21,23,25,27,29,32,54,50,51,47}, --江陵I,考虑到游戏实际,主要在江陵,而不再襄阳II,将襄阳II的部分道具也加进来
 [16]={42,39,36,44,45,20,22,24}, --江夏II
 [17]={50,51,47,48,38,39}, --长沙
 [18]={21,23,25,27,29,42,39,36,34}, --襄阳II
 [19]={21,23,25,27,29,30,32,54}, --成都I
 [20]={29,32,54,42,20,22,24,34}, --涪
 [21]={21,23,25,27,29,30,32,33}, --成都II
 [22]={42,39,36,29,32,54,48,51}, --西陵
 [23]={42,39,40,36,37,48,51,52}, --江陵II
 [24]={21,23,25,27,43,30,33,55}, --襄阳III
 [25]={30,33,55,43,40,37,45,46}, --宛
 [26]={30,33,55,49,20,22,24,26}, --许昌II
--[[
各地所能购买道具：
陈留：焦热书，酒，豆。
北平：酒，豆，浓雾书。
信都：酒，豆，伤药，焦热书，漩涡书，落石书。
广川：酒，豆，伤药。
北海：酒，豆，伤药，焦热书，漩涡书，落石书，炸弹。
徐州：酒，豆，伤药，平气书，援队书。
下邳：豆，麦，平气书，援队书，炸弹。
小沛：长枪，连弩，马铠，无赖精神，焦热书，漩涡书，落石书。
许昌I：长枪，连弩，马铠，无赖精神，酒，特级酒，豆，伤药。
许昌II：老酒，米，茶，援军书，长枪，连弩，马铠，无赖精神。 第四十八关，许昌II之战后
邺：长枪，连弩，马铠，无赖精神，特级酒，豆，麦，伤药。
白马：焦热书，漩涡书，浊流书，落石书，浓雾书。
汝南：焦热书，火龙书，漩涡书，浊流书，落石书，山崩书。
襄阳I：长枪，连弩，马铠，无赖精神，特级酒，麦，伤药，炸弹。
襄阳II：步兵车，发石车，近卫铠，侠义精神，火龙书，浊流书，山崩书，炸弹。 第二十六关，江陵之战后
襄阳III：步兵车，发石车，近卫铠，侠义精神，猛火书，老酒，米，茶。 第四十二关，襄阳II之战后
江夏I：火龙书，浊流书，山崩书，浓雾书，雷阵雨书。
江夏II：火龙书，浊流书，山崩书，浓雾书，雷阵雨书，长枪，连弩，马铠。 第二十五关，长阪坡之战后
江陵I：特级酒，麦，中药，平气书，活气书，援队书。
江陵II：火龙书，浊流书，海啸书，山崩书，山洪书，援部书，活气书，勇气书。 第三十九关，麦之战后
长沙：平气书，活气书，援队书，援部书，漩涡书，浊流书。
涪：特级酒，麦，中药，火龙书，长枪，连弩，马铠，炸弹。
成都I：步兵车，发石车，近卫铠，侠义精神，特级酒，老酒，麦，中药。
成都II：步兵车，发石车，近卫铠，侠义精神，特级酒，老酒，麦，米。 第三十九关，麦之战后
西陵：火龙书，浊流书，山崩书，特级酒，麦，中药，援部书，活气书。
宛：老酒，米，茶，猛火书，海啸书，山洪书，雷阵雨书，豪雨书。
]]--
 }
 local shopitem2={ --武器店
 [1]={74,80,89,140,147}, --汜水关之战前,陈留
 [2]={74,75,80,89,99,140,141,147}, --虎牢关之战后,北平
 [3]={80,81,85,89,95,117,120,141,148},--信都城之战后,信都
 [4]={75,90,141,148}, --广川之战后,广川
 --北海之战前,北平/信都
 [5]={80,81,85,89,95,117,120,141,148}, --北海之战后,北平/信都/北海,这里只列了信都的
 [6]={90,96,120,125,126,131,142,148}, --徐州I之战后,北平/信都/北海/徐州/下邳，这里只列的徐州的
 --下邳的 31,32,50,47,34
 [7]={81,85,100,117,135,142,152}, --小沛
 [8]={86,90,101,104,105,117,135,142,152,148}, --许昌I
 [9]={86,90,101,105,142,152,148}, --下邳,其实没有，随便编几个
 [10]={76,82,91,102,106,118,136,131,130}, --邺
 [11]={140,141,142,147,148}, --白马,其实没有，随便编几个
 [12]={76,82,91,102,106,142}, --汝南,其实没有，随便编几个
 [13]={91,97,127,131,141,143,152,149,150}, --襄阳I
 [14]={76,82,86,106,109,110,118,121,123}, --江夏I
 [15]={103,107,111,114,132,133,142,144,153}, --江陵I
 [16]={76,82,86,106,109,110,118,121,123}, --江夏II
 [17]={76,82,86,103,107,110}, --长沙,其实没有，随便编几个
 [18]={77,90,92,96,97,128}, --襄阳II
 [19]={78,83,87,111,115,128,145,153,150}, --成都I
 [20]={92,97,102,106,139}, --涪,其实没有，随便编几个
 [21]={78,83,87,111,115,128,145,153,150}, --成都II
 [22]={78,83,87,92,97,102,106,111,115,139}, --西陵,其实没有，随便编几个
 [23]={93,97,103,108,112,137,119,122,129}, --江陵II
 [24]={84,88,98,116,124,138,134,146,151}, --襄阳III
 [25]={84,88,98,103,108}, --宛
 [26]={79,94,113,139,132,154}, --许昌II
 }
 local shopid=1; --1道具 2武器
 local buysellmenu={
 {"　买道具 ",nil,1},
 {"　买武器 ",nil,1},
 {"　　卖 ",nil,1},
 };
 local itemmenu={};
 local itemnum=0;
 local personmenu={};
 local personnum=0;
 for i=1,JY.PersonNum-1 do
 if JY.Person[i]["君主"]==1 then
 personmenu[i]={fillblank(JY.Person[i]["姓名"],11),nil,1};
 personnum=personnum+1;
 else
 personmenu[i]={"",nil,0};
 end
 end
 PlayWavE(0);
 
 local status="SelectBuySell";
 local iid,pid;
 local function showbuysellmenu()
 talk_sub(375,"有什么事情？");
 local r=ShowMenu(buysellmenu,3,0,0,156,0,0,3,1,16,C_WHITE,C_WHITE);
 if r==1 then
 status="SelectItem";
 shopid=1;
 itemmenu={};
 itemnum=0;
 for i,v in pairs(shopitem[sid]) do
 itemnum=itemnum+1;
 itemmenu[itemnum]={fillblank(JY.Item[v]["名称"],11),nil,1};
 end
 elseif r==2 then
 status="SelectItem";
 shopid=2;
 itemmenu={};
 itemnum=0;
 for i,v in pairs(shopitem2[sid]) do
 itemnum=itemnum+1;
 itemmenu[itemnum]={fillblank(JY.Item[v]["名称"],11),nil,1};
 end
 elseif r==3 then
 status="SelectPersonSell";
 else
 status="Exit";
 PlayWavE(1);
 end
 end
 local function showitemmenu()
 talk_sub(375,"买什么？");
 local r=ShowMenu(itemmenu,itemnum,0,0,156,0,0,3,1,16,C_WHITE,C_WHITE);
 if r>0 then
 if shopid==1 then
 iid=shopitem[sid][r];
 elseif shopid==2 then
 iid=shopitem2[sid][r];
 else
 iid=1;
 end
 --showitem
 local x=145;
 local y=CC.ScreenH/2;
 local size=16;
 lib.PicLoadCache(4,50*2,x,y,1);
 DrawString(x+16,y+16,JY.Item[iid]["名称"],C_Name,size);
 DrawStr(x+16,y+36,GenTalkString(JY.Item[iid]["说明"],18),C_WHITE,size);
 
 if talkYesNo(375,JY.Item[iid]["名称"].."黄金"..JY.Item[iid]["价值"].."0，*可以吗？") then
 --如果黄金不够
 if JY.Item[iid]["价值"]*10>JY.Base["黄金"] then
 DrawSMap();
 PlayWavE(2);
 talk(375,"看来黄金不够了．");
 status="SelectItem";
 else
 status="SelectPerson";
 end
 end
 else
 status="SelectBuySell";
 PlayWavE(1);
 end
 end
 local function showpersonnum()
 talk_sub(375,JY.Item[iid]["名称"].."哪位要？");
 local r;
 if personnum<=10 then
 r=ShowMenu(personmenu,JY.PersonNum-1,10,0,156,0,0,5,1,16,C_WHITE,C_WHITE);
 else
 r=ShowMenu(personmenu,JY.PersonNum-1,8,0,156,0,0,6,1,16,C_WHITE,C_WHITE);
 end
 if r>0 then
 pid=r;
 if JY.Person[pid]["道具8"]>0 then
 PlayWavE(2);
 if talkYesNo(375,"那位不能再*带东西了，别人吧？") then
 status="SelectPerson";
 else
 status="SelectItem";
 end
 else
 PersonStatus_sub(pid,108,156);
 if talkYesNo(375,"可以交给"..JY.Person[pid]["姓名"].."吗？") then
 GetMoney(-10*JY.Item[iid]["价值"]);
 for i=1,8 do
 if JY.Person[pid]["道具"..i]==0 then
 JY.Person[pid]["道具"..i]=iid;
 break;
 end
 end
 DrawSMap();
 DrawYJZBox(32,32,"道具买卖",C_WHITE,true);
 if talkYesNo(375,"多谢了，还要……再买点吗？") then
 status="SelectItem";
 else
 status="SelectBuySell";
 end
 else
 status="SelectPerson";
 end
 end
 else
 status="SelectItem"
 PlayWavE(1);
 end
 end
 local function showpersonnumsell()
 talk_sub(375,"想卖哪位的东西？");
 local r;
 if personnum<=10 then
 r=ShowMenu(personmenu,JY.PersonNum-1,10,0,156,0,0,5,1,16,C_WHITE,C_WHITE);
 else
 r=ShowMenu(personmenu,JY.PersonNum-1,8,0,156,0,0,6,1,16,C_WHITE,C_WHITE);
 end
 if r>0 then
 pid=r;
 status="SelectItemSell";
 else
 status="SelectBuySell";
 PlayWavE(1);
 end
 end
 local function showitemmenusell()
 if JY.Person[pid]["道具1"]==0 then
 PlayWavE(2);
 talk(375,"您没有什么东西可卖。");
 status="SelectPersonSell";
 else
 local sellmenu={};
 for i=1,8 do
 iid=JY.Person[pid]["道具"..i];
 if iid>0 then
 sellmenu[i]={fillblank(JY.Item[iid]["名称"],11),nil,1};
 else
 sellmenu[i]={"",nil,0};
 end
 end
 talk_sub(375,"卖什么？");
 local rr=ShowMenu(sellmenu,8,0,0,156,0,0,3,1,16,C_WHITE,C_WHITE);
 if rr>0 then
 iid=JY.Person[pid]["道具"..rr];
 if talkYesNo(375,"用"..(10*math.modf(JY.Item[iid]["价值"]*0.75)).."黄金收购"..JY.Item[iid]["名称"].."，可以吗？") then
 for i=rr,7 do
 JY.Person[pid]["道具"..i]=JY.Person[pid]["道具"..(i+1)]
 end
 JY.Person[pid]["道具8"]=0;
 GetMoney(10*math.modf(JY.Item[iid]["价值"]*0.75));
 DrawSMap();
 DrawYJZBox(32,32,"道具买卖",C_WHITE,true);
 if talkYesNo(375,"多谢了，还要……想卖点什么吗？") then
 status="SelectPersonSell";--?
 status="SelectItemSell";--?
 else
 status="SelectBuySell";
 end
 else
 status="SelectItemSell";
 end
 else
 status="SelectPersonSell";
 PlayWavE(1);
 end
 end
 end
 talk(375,"我是商人．");
 while true do
 JY.Tid=375;
 DrawSMap();
 DrawYJZBox(32,32,"道具买卖",C_WHITE,true);
 if status=="SelectBuySell" then
 showbuysellmenu();
 elseif status=="SelectItem" then
 showitemmenu();
 elseif status=="SelectPerson" then
 showpersonnum();
 elseif status=="SelectPersonSell" then
 showpersonnumsell();
 elseif status=="SelectItemSell" then
 showitemmenusell();
 else
 talk(375,"欢迎再来．");
 break;
 end
 end
 
end

function WarIni()
 War={};
 SetWarConst();
 War.Person={};
 War.PersonNum=0;
 Drama={};
end

--用于连战，其实就是把敌军删掉
function WarIni2()
 for i=War.PersonNum,1,-1 do
 if War.Person[i].enemy then
 table.remove(War.Person,i);
 War.PersonNum=War.PersonNum-1
 end
 end
end
----------------------------------------------------------------
-- SelectTerm(fid,team)
-- 选择我军
-- fid,君主id 一般应该是1，刘备
-- team,我军参战人员配置数据,id为-1时可选择,否则为强制出战
----------------------------------------------------------------
function SelectTerm(fid,team)
 local num=0;
 local page=1;
 local maxpage=1;
 local num_per_page=6;
 local personnum=0;
 local maxpersonnum=0;
 local current=1;
 for j=1,20 do
 local idx=(j-1)*7;
 if team[idx+1]==-1 then
 personnum=personnum+1;
 end
 if team[idx+7]==nil then
 break;
 end
 maxpersonnum=j;
 end
 if personnum==0 then
 SelectTerm_sub(fid,team);
 return;
 else
 ExchangeItem(fid,true);
 end
 TeamSelect={id={},status={}};
 for i=1,JY.PersonNum-1 do
 if JY.Person[i]["君主"]==fid then
 ReSetAttrib(i,true);
 JY.Person[i]["战斗动作"]=GetPic(i,false,false);
 num=num+1;
 TeamSelect.id[num]=i;
 TeamSelect.status[num]=0; --0未选择 1选择(可取消) 2选择(不可取消)
 for j=1,maxpersonnum do
 local idx=(j-1)*7;
 if team[idx+1]+1==i then
 TeamSelect.status[num]=2;
 break;
 end
 end
 end
 end
 maxpage=math.modf((num-1)/6)+1;
 --------------------------------
 -- 定义坐标信息
 --------------------------------
 local xy= {
 x1={}, --左上角(边框内，实际部队图标显示位置)
 y1={},
 x2={}, --兵力
 y2={},
 x3={}, --姓名
 y3={},
 x4={}, --右下角
 y4={},
 }
 xy.x1={56,232,56,232,56,232};
 xy.y1={64,64,154,154,244,244};
 for i=1,6 do
 xy.x1[i]=xy.x1[i]+16;
 xy.y1[i]=xy.y1[i]+16;
 end
 for i=1,6 do
 xy.x2[i]=xy.x1[i]+104;
 xy.y2[i]=xy.y1[i]+17;
 xy.x3[i]=xy.x1[i]+104;
 xy.y3[i]=xy.y1[i]+41;
 xy.x4[i]=xy.x1[i]+143;
 xy.y4[i]=xy.y1[i]+63;
 end
 local bottom=0; --当前按钮
 --------------------------------
 -- redraw()
 -- 内部函数，重绘
 -- frame 用于控制动画显示
 --------------------------------
 local cid=0;
 local subframe,frame=0,0;
 local kind={[0]="无","攻击用","恢复用","变换用","宝物","兵书","名马","恢复用","种子","种子","种子","武器","防具","马车","无",}
 local titlestr="让哪名武将参加战斗？";
 local function redraw()
 JY.ReFreshTime=lib.GetTime();
 lib.FillColor(0,0,0,0,0);
 lib.PicLoadCache(4,201*2,0,0,1);
 DrawGameStatus();
 lib.PicLoadCache(4,203*2,16,16,1);
 DrawString(26,31,titlestr,C_WHITE,16);
 for i=1,6 do
 local idx=num_per_page*(page-1)+i;
 if idx>num then
 break;
 end
 local pid=TeamSelect.id[idx];
 local name=JY.Person[pid]["姓名"];
 local hp=string.format("% 5d",JY.Person[pid]["最大兵力"]);
 local lv=string.format("% 5d",JY.Person[pid]["等级"]);
 local picid;
 if TeamSelect.status[idx]==0 then --未选择时，为+19
 picid=JY.Person[pid]["战斗动作"]+19;
 DrawString(xy.x3[i]-4*#name,xy.y3[i],name,C_WHITE,16);
 lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1);
 lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128);
 else
 picid=JY.Person[pid]["战斗动作"]+12+frame;
 DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_DarkOrange,16);
 lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128);
 lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1);
 end
 DrawString(xy.x2[i],xy.y2[i],hp,C_WHITE,16);
 DrawString(xy.x1[i]+4,xy.y1[i]+48,lv,C_WHITE,16);
 end
 DrawString(110,359,string.format("% 4d",page),C_WHITE,16);
 DrawString(142,359,string.format("% 4d",maxpage),C_WHITE,16);
 DrawString(252,359,string.format("% 4d",personnum),C_WHITE,16);
 --选中人物
 cid=TeamSelect.id[current];
 lib.PicLoadCache(2,JY.Person[cid]["头像代号"]*2,464,32,1);
 DrawString(489-3*#JY.Person[cid]["姓名"],136,JY.Person[cid]["姓名"],C_WHITE,16);
 DrawString(584-4*#JY.Bingzhong[JY.Person[cid]["兵种"]]["名称"],24,JY.Bingzhong[JY.Person[cid]["兵种"]]["名称"],C_WHITE,16);
 DrawString(585,48,string.format("% 5d",JY.Person[cid]["等级"]),C_WHITE,16);
 DrawString(585,80,string.format("% 5d",JY.Person[cid]["统率"]),C_WHITE,16);
 DrawString(585,112,string.format("% 5d",JY.Person[cid]["武力"]),C_WHITE,16);
 DrawString(585,144,string.format("% 5d",JY.Person[cid]["智力"]),C_WHITE,16);
 if bottom==1 then
 lib.PicLoadCache(4,224*2,173,351,1);
 elseif bottom==2 then
 lib.PicLoadCache(4,225*2,173,367,1);
 elseif bottom==3 then
 lib.PicLoadCache(4,226*2,317,351,1);
 end
 --道具
 for i=1,8 do
 local tid=JY.Person[cid]["道具"..i];
 if tid>0 then
 DrawString(466,176+i*18,JY.Item[tid]["名称"],C_WHITE,16);
 DrawString(562,176+i*18,"／"..kind[JY.Item[tid]["类型"]],C_WHITE,16);
 else
 if i==1 then
 DrawString(466,176+i*18,"无携带品．",C_WHITE,16);
 end
 break;
 end
 end
 ReFresh();
 subframe=subframe+1;
 if subframe==8 then
 frame=1-frame;
 subframe=0;
 end
 end
 --Dark();
 redraw();
 --Light();
 while JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL do
 redraw();
 getkey();
 bottom=0;
 if MOUSE.EXIT() then
 PlayWavE(0);
 if WarDrawStrBoxYesNo('结束游戏吗？',C_WHITE,true) then
 lib.Delay(100);
 if WarDrawStrBoxYesNo('再玩一次吗？',C_WHITE,true) then
 lib.Delay(100);
 JY.Status=GAME_START;
 else
 lib.Delay(100);
 JY.Status=GAME_END;
 end
 end
 elseif MOUSE.HOLD(174,352,204,366) then --page up
 bottom=1;
 elseif MOUSE.HOLD(174,368,204,382) then --page down
 bottom=2;
 elseif MOUSE.HOLD(319,353,362,380) then --close
 bottom=3;
 elseif MOUSE.CLICK(174,352,204,366) then --page up
 PlayWavE(0);
 page=limitX(page-1,1,maxpage);
 elseif MOUSE.CLICK(174,368,204,382) then --page down
 PlayWavE(0);
 page=limitX(page+1,1,maxpage);
 elseif MOUSE.CLICK(319,353,362,380) then --close
 PlayWavE(0);
 for i=1,CC.OpearteSpeed do
 redraw();
 end
 if WarDrawStrBoxYesNo("组编完毕，可以吗？",C_WHITE,true) then
 local m,n=1,1;
 for i=1,20 do
 local idx=(i-1)*7;
 if team[idx+1]==-1 then
 m=i;
 break;
 end
 end
 for n=1,num do
 if TeamSelect.status[n]==1 then
 team[(m-1)*7+1]=TeamSelect.id[n]-1;
 m=m+1;
 end
 end
 SelectTerm_sub(fid,team);
 Dark();
 return;
 end
 elseif MOUSE.CLICK(464,32,464+64,32+80) then --head
 PlayWavE(0);
 PersonStatus(cid,"","",1);
 else
 for i=1,6 do
 if MOUSE.CLICK(xy.x1[i],xy.y1[i],xy.x4[i],xy.y4[i]) then
 local idx=num_per_page*(page-1)+i;
 if idx<=num then
 current=idx;
 if TeamSelect.status[idx]==0 then
 if personnum<=0 then
 PlayWavE(2);
 titlestr="不能再参战了．";
 for n=1,20 do
 redraw();
 lib.GetKey();
 end
 titlestr="让哪名武将参加战斗？";
 else
 PlayWavE(0);
 TeamSelect.status[idx]=1;
 personnum=personnum-1;
 end
 elseif TeamSelect.status[idx]==1 then
 PlayWavE(1);
 TeamSelect.status[idx]=0;
 personnum=personnum+1;
 else
 PlayWavE(2);
 titlestr="不能解除那名武将．";
 for n=1,20 do
 redraw();
 lib.GetKey();
 end
 titlestr="让哪名武将参加战斗？";
 end
 end
 break;
 end
 end
 for i=1,8 do
 if MOUSE.CLICK(466,176+i*18,626,176+16+i*18) then
 cid=TeamSelect.id[current];
 local item=JY.Person[cid]["道具"..i];
 if item>0 then
 PlayWavE(0);
 DrawItemStatus(item,cid);
 end
 break;
 end
 end
 end
 end
 --[[
 if eventtype==0 then --SDL_Quit
 PlayWavE(0);
 if WarDrawStrBoxYesNo('结束游戏吗？',C_WHITE,true) then
 lib.Delay(100);
 if WarDrawStrBoxYesNo('再玩一次吗？',C_WHITE,true) then
 lib.Delay(100);
 JY.Status=GAME_START;
 else
 lib.Delay(100);
 JY.Status=GAME_END;
 end
 end
 ]]--
end

----------------------------------------------------------------
-- SelectTerm2(fid,team)
-- 选择我军，连续出战时使用
-- fid,君主id 一般应该是1，刘备
-- team,我军参战人员配置数据,id为-1时可选择,否则为强制出战
----------------------------------------------------------------
function SelectTerm2(fid,team)
 local num=0;
 local m,n=1,1;
 
 for i=1,JY.PersonNum-1 do
 if JY.Person[i]["君主"]==fid then
 num=num+1;
 end
 end
 for i=1,20 do
 local idx=(i-1)*7;
 if team[idx+1]==-1 then
 m=i;
 break;
 end
 end
 for n=1,num do
 if TeamSelect.status[n]==1 then
 team[(m-1)*7+1]=TeamSelect.id[n]-1;
 m=m+1;
 end
 end
 for i=1,20 do
 local idx=(i-1)*7;
 if team[idx+7]==nil then
 break;
 end
 if team[idx+1]>=0 and (team[idx+6]==-1 or GetFlag(team[idx+6])) then
 --额外+1用于修复yjz数据和复刻数据的不一致
 team[idx+1]=team[idx+1]+1;
 team[idx+2]=team[idx+2]+1;
 team[idx+3]=team[idx+3]+1;
 local wid=GetWarID(team[idx+1]);
 War.Person[wid].x=team[idx+2];
 War.Person[wid].y=team[idx+3];
 War.Person[wid].ai=1;
 War.Person[wid].frame=-1;
 War.Person[wid].d=team[idx+4];
 War.Person[wid].active=true;
 --War.Person[wid].troubled=false;
 if not War.Person[wid].troubled then
 War.Person[wid].action=1;
 end
 if team[idx+7]>0 then
 War.Person[War.PersonNum].hide=true;
 elseif War.Person[wid].live then
 SetWarMap(team[idx+2],team[idx+3],2,wid);
 end
 War.Person[wid].pic=WarGetPic(wid);
 end
 end
end
----------------------------------------------------------------
-- SelectTerm2(fid,team)
-- 选择我军，连续出战时使用
-- fid,君主id 一般应该是1，刘备
-- team,我军参战人员配置数据,修改后的版本
----------------------------------------------------------------
function SelectTerm2(fid,team)
 for wid=1,War.PersonNum do
 local idx=(wid-1)*7;
 if team[idx+7]==nil then
 break;
 end
 War.Person[wid].x=team[idx+2]+1;
 War.Person[wid].y=team[idx+3]+1;
 War.Person[wid].ai=1;
 War.Person[wid].frame=-1;
 War.Person[wid].d=team[idx+4];
 War.Person[wid].active=true;
 --War.Person[wid].troubled=false;
 if not War.Person[wid].troubled then
 War.Person[wid].action=1;
 end
 if War.Person[wid].live then
 SetWarMap(team[idx+2]+1,team[idx+3]+1,2,wid);
 end
 War.Person[wid].pic=WarGetPic(wid);
 end
end



----------------------------------------------------------------
-- SelectTerm_sub(fid,T)
-- 选择我军
-- T,我军参战人员配置数据
----------------------------------------------------------------
function SelectTerm_sub(fid,T)
 for i=1,20 do
 local idx=(i-1)*7;
 if T[idx+7]==nil then
 break;
 end
 if T[idx+1]>=0 and (T[idx+6]==-1 or GetFlag(T[idx+6])) then
 --额外+1用于修复yjz数据和复刻数据的不一致
 T[idx+1]=T[idx+1]+1;
 T[idx+2]=T[idx+2]+1;
 T[idx+3]=T[idx+3]+1;
 War.PersonNum=War.PersonNum+1;
 table.insert(War.Person, {
 id=T[idx+1], --人物ID
 x=T[idx+2], --坐标X
 y=T[idx+3], --坐标Y
 --pic=JY.Person[T[idx+1]]["战斗动作"], --形象ID
 action=1, --动作 0静止，1走路...
 effect=0, --高亮显示
 hurt=-1, --显示伤害数值
 bz=JY.Person[T[idx+1]]["兵种"],
 movewav=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["音效"], --移动音效
 atkwav=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["攻击音效"], --攻击音效
 movestep=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["移动"], --移动范围
 movespeed=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["移动速度"], --移动速度
 atkfw=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["攻击范围"], --攻击范围
 sq_limited=100,
 atk_buff=0,
 def_buff=0,
 frame=-1, --显示帧数
 d=T[idx+4], --方向
 active=true, --可否行动
 enemy=false, --敌军我军
 friend=false, --友军？
 ai=1, --AI类型
 live=true, --存活
 hide=false, --伏兵
 was_hide=false, --伏兵
 troubled=false, --混乱
 leader=false,
 })

 if War.Leader1==T[idx+1] then
 War.Person[War.PersonNum].leader=true;
 end
 if JY.Person[T[idx+1]]["君主"]~=fid then
 War.Person[War.PersonNum].friend=true;
 end

 if T[idx+7]>0 then
 War.Person[War.PersonNum].hide=true;
 War.Person[War.PersonNum].was_hide=true;
 else
 SetWarMap(T[idx+2],T[idx+3],2,War.PersonNum);
 end
 ReSetAttrib(T[idx+1],true);
 War.Person[War.PersonNum].pic=WarGetPic(War.PersonNum);
 end
 end

if CC.Enhancement then
local lv_t={}
local cz=0
for i=1,War.PersonNum do
if JY.Person[War.Person[i].id]["君主"]==1 then
table.insert(lv_t,JY.Person[War.Person[i].id]["等级"]);
cz=cz+1
end
end

table.sort(lv_t,function(a,b) return b<a end)

for ii=1,cz do
table.insert(lv_t,1)
--lib.Debug("lv="..lv_t[ii])
end


local lv=0
for ii=1,cz do
lv=lv+lv_t[ii]
end

lv=math.modf(lv/cz)  --得到我军平均等级
--lib.Debug("pjlv="..lv)

if lv>=0 then
else
lv=pjlv()
end

CC.lv=lv
JY.Base["我军等级"]=CC.lv

--设置游戏模式下的友军等级以及兵种自动升级
for i=1,War.PersonNum do
if JY.Person[War.Person[i].id]["君主"]~=fid then
if CC.lv>JY.Person[War.Person[i].id]["等级"] then
JY.Person[War.Person[i].id]["等级"]=CC.lv

--[[
if JY.Person[War.Person[i].id]["等级"]>=15 then
if JY.Person[War.Person[i].id]["兵种"]==1 then
JY.Person[War.Person[i].id]["兵种"]=2
elseif JY.Person[War.Person[i].id]["兵种"]==4 then
JY.Person[War.Person[i].id]["兵种"]=5
elseif JY.Person[War.Person[i].id]["兵种"]==7 then
JY.Person[War.Person[i].id]["兵种"]=8
elseif JY.Person[War.Person[i].id]["兵种"]==10 then
JY.Person[War.Person[i].id]["兵种"]=11
elseif JY.Person[War.Person[i].id]["兵种"]==23 then
JY.Person[War.Person[i].id]["兵种"]=24
end
end

if JY.Person[War.Person[i].id]["等级"]>=30 then
if JY.Person[War.Person[i].id]["兵种"]==2 then
JY.Person[War.Person[i].id]["兵种"]=3
elseif JY.Person[War.Person[i].id]["兵种"]==5 then
JY.Person[War.Person[i].id]["兵种"]=6
elseif JY.Person[War.Person[i].id]["兵种"]==8 then
JY.Person[War.Person[i].id]["兵种"]=9
elseif JY.Person[War.Person[i].id]["兵种"]==11 then
JY.Person[War.Person[i].id]["兵种"]=12
elseif JY.Person[War.Person[i].id]["兵种"]==24 then
JY.Person[War.Person[i].id]["兵种"]=25
end
end
]]--


local id=i
local bzid=JY.Person[War.Person[id].id]["兵种"]
War.Person[id].bz=bzid
 War.Person[id].movewav=JY.Bingzhong[bzid]["音效"]; --移动音效
 War.Person[id].atkwav=JY.Bingzhong[bzid]["攻击音效"]; --攻击音效
 War.Person[id].movestep=JY.Bingzhong[bzid]["移动"]; --移动范围
 War.Person[id].movespeed=JY.Bingzhong[bzid]["移动速度"]; --移动速度
 War.Person[id].atkfw=JY.Bingzhong[bzid]["攻击范围"]; --攻击范围
 War.Person[id].pic=WarGetPic(id)
ReSetAttrib(War.Person[i].id,true) --重新计算战场属性？
end
end
end

end


end

function SelectEnemy(T)
 local lvoffset=0;
if CC.Enhancement then
 local elv_sum=1;
 local num=0;
 for i=1,99 do
 local idx=(i-1)*11;
 if T[idx+11]==nil then
 break;
 end
 if T[idx+1]>=0 and (T[idx+10]==-1 or GetFlag(T[idx+10])) then
 elv_sum=elv_sum+T[idx+6];
 num=num+1;
 end
 end
 local elv=math.modf(elv_sum/num); --实际敌军平均等级

if CC.lv==nil then
CC.lv=JY.Base["我军等级"]
end

lvoffset=math.modf(limitX(CC.lv-elv+elv/10,0,99)) --得到我军平均等级和敌军平均等级的差值
--lib.Debug("lv+"..lvoffset)
end

--[[
 if JY.Base["游戏模式"]>0 then
 local lv_t={}
 for i,v in pairs(JY.Person) do
 if v["君主"]==1 then
 table.insert(lv_t,v["等级"]);
 end
 end
 table.sort(lv_t,function(a,b) return b<a end)
 table.remove(lv_t,1);
 table.insert(lv_t,1);
 table.insert(lv_t,1);
 table.insert(lv_t,1);
 table.insert(lv_t,1);
 table.insert(lv_t,1);
 lib.Debug("Top5="..lv_t[1]..' '..lv_t[2]..' '..lv_t[3]..' '..lv_t[4]..' '..lv_t[5])
 local lv1=math.modf((lv_t[1]+lv_t[2]+lv_t[3]+lv_t[4]+lv_t[5])/5);
 local lv2=JY.Person[1]["等级"];
 local lv=math.max(lv1-2,lv2-5,1); --目标敌军平均等级
 local elv_sum=1;
 local num=0;
 for i=1,99 do
 local idx=(i-1)*11;
 if T[idx+11]==nil then
 break;
 end
 if T[idx+1]>=0 and (T[idx+10]==-1 or GetFlag(T[idx+10])) then
 elv_sum=elv_sum+T[idx+6];
 num=num+1;
 end
 end
 local elv=math.modf(elv_sum/num); --实际敌军平均等级
 --lvoffset=math.modf(elv/10)+limitX(lv-elv,0,1+math.modf(elv*0.5));
lvoffset=math.modf(elv/10)+limitX(lv-elv,0,99)
 end
]]--

 for i=1,99 do
 local idx=(i-1)*11;
 if T[idx+11]==nil then
 break;
 end
 if T[idx+1]>=0 and (T[idx+10]==-1 or GetFlag(T[idx+10])) then
 --额外+1用于修复yjz数据和复刻数据的不一致
 T[idx+1]=T[idx+1]+1;
 T[idx+2]=T[idx+2]+1;
 T[idx+3]=T[idx+3]+1;
 JY.Person[T[idx+1]]["等级"]=T[idx+6]+lvoffset;
 JY.Person[T[idx+1]]["兵种"]=T[idx+7]
 War.PersonNum=War.PersonNum+1;
 War.EnemyNum=War.EnemyNum+1;
 table.insert(War.Person, {
 id=T[idx+1], --人物ID
 x=T[idx+2], --坐标X
 y=T[idx+3], --坐标Y
 action=1, --动作 0静止，1走路...
 effect=0, --高亮显示
 hurt=-1, --显示伤害数值
 bz=JY.Person[T[idx+1]]["兵种"],
 movewav=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["音效"], --移动音效
 atkwav=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["攻击音效"], --攻击音效
 movestep=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["移动"], --移动范围
 movespeed=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["移动速度"], --移动速度
 atkfw=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["攻击范围"], --攻击范围
 sq_limited=100,
 atk_buff=0,
 def_buff=0,
 frame=-1, --显示帧数
 d=T[idx+4], --方向
 active=true, --可否行动
 enemy=true, --敌军我军
 friend=false, --友军？
 ai=T[idx+5], --AI类型
 aitarget=T[idx+8]+1,
 ai_dx=T[idx+8]+1,
 ai_dy=T[idx+9]+1,
 live=true, --存活
 hide=false, --伏兵
 was_hide=false, --伏兵
 troubled=false, --混乱
 leader=false,
 })
 if War.Leader2==T[idx+1] then
 War.Person[War.PersonNum].leader=true;
 end

 if T[idx+11]>0 then
 War.Person[War.PersonNum].hide=true;
 War.Person[War.PersonNum].was_hide=true;
 else
 SetWarMap(T[idx+2],T[idx+3],2,War.PersonNum);
 end

 ReSetAttrib(T[idx+1],true);
 War.Person[War.PersonNum].pic=WarGetPic(War.PersonNum);
 end
 end
 
 
 War.CX=limitX(War.Person[1].x-math.modf(War.MW/2),1,War.Width-War.MW+1);
 War.CY=limitX(War.Person[1].y-math.modf(War.MD/2),1,War.Depth-War.MD+1);

--设置游戏模式下的敌军兵种自动升级
if CC.Enhancement then
for i=1,War.PersonNum do
if JY.Person[War.Person[i].id]["等级"]>=15 then
if JY.Person[War.Person[i].id]["兵种"]==1 then
JY.Person[War.Person[i].id]["兵种"]=2
elseif JY.Person[War.Person[i].id]["兵种"]==4 then
JY.Person[War.Person[i].id]["兵种"]=5
elseif JY.Person[War.Person[i].id]["兵种"]==7 then
JY.Person[War.Person[i].id]["兵种"]=8
elseif JY.Person[War.Person[i].id]["兵种"]==10 then
JY.Person[War.Person[i].id]["兵种"]=11
elseif JY.Person[War.Person[i].id]["兵种"]==23 then
JY.Person[War.Person[i].id]["兵种"]=24
end
end

if JY.Person[War.Person[i].id]["等级"]>=30 then

if JY.Person[War.Person[i].id]["兵种"]==2 then
JY.Person[War.Person[i].id]["兵种"]=3
elseif JY.Person[War.Person[i].id]["兵种"]==5 then
JY.Person[War.Person[i].id]["兵种"]=6
elseif JY.Person[War.Person[i].id]["兵种"]==8 then
JY.Person[War.Person[i].id]["兵种"]=9
elseif JY.Person[War.Person[i].id]["兵种"]==11 then
JY.Person[War.Person[i].id]["兵种"]=12
elseif JY.Person[War.Person[i].id]["兵种"]==24 then
JY.Person[War.Person[i].id]["兵种"]=25
end

end

local id=i
local bzid=JY.Person[War.Person[id].id]["兵种"]
War.Person[id].bz=bzid
 War.Person[id].movewav=JY.Bingzhong[bzid]["音效"]; --移动音效
 War.Person[id].atkwav=JY.Bingzhong[bzid]["攻击音效"]; --攻击音效
 War.Person[id].movestep=JY.Bingzhong[bzid]["移动"]; --移动范围
 War.Person[id].movespeed=JY.Bingzhong[bzid]["移动速度"]; --移动速度
 War.Person[id].atkfw=JY.Bingzhong[bzid]["攻击范围"]; --攻击范围
 War.Person[id].pic=WarGetPic(id)
ReSetAttrib(War.Person[i].id,true) --重新计算战场属性？
end
end

end

function DefineWarMap(id,warname,wartarget,maxturn,leader1,leader2)
 War.MapID=id;
 War.WarName=warname;
 War.WarTarget=wartarget;
 War.MaxTurn=maxturn;
 War.Leader1=leader1+1;
 War.Leader2=leader2+1;
 LoadWarMap(War.MapID);
end
function WarStart()
 JY.SubScene=-1;
 SRPG();
end
----------------------------------------------------------------
-- WarSave()
-- 保存战场
----------------------------------------------------------------
function WarSave(id)
 
 --War basic informaction
 Byte.set8(JY.Data_Base,128,War.MapID);
 Byte.set8(JY.Data_Base,129,War.Width);
 Byte.set8(JY.Data_Base,130,War.Depth);
 Byte.set8(JY.Data_Base,131,War.CX);
 Byte.set8(JY.Data_Base,132,War.CY);
 Byte.set16(JY.Data_Base,133,War.PersonNum);
 Byte.set8(JY.Data_Base,135,War.Weather);
 Byte.set8(JY.Data_Base,136,War.Turn);
 Byte.set8(JY.Data_Base,137,War.MaxTurn);
 Byte.set16(JY.Data_Base,138,War.Leader1);
 Byte.set16(JY.Data_Base,140,War.Leader2);
 Byte.set8(JY.Data_Base,142,War.EnemyNum);
 JY.Base["战场名称"]=War.WarName;
 JY.Base["战场目标"]=War.WarTarget;
 --[[
 if CC.SrcCharSet==1 then
 Byte.setstr(JY.Data_Base,150,50,lib.CharSet(War.WarName,1));
 Byte.setstr(JY.Data_Base,200,100,lib.CharSet(War.WarTarget,1));
 else
 Byte.setstr(JY.Data_Base,150,50,War.WarName);
 Byte.setstr(JY.Data_Base,200,100,War.WarTarget);
 end
 ]]--
 --War.Person
 local offset=300;
 for i=1,War.PersonNum do
 Byte.set16(JY.Data_Base,offset,War.Person[i].id);
 Byte.set8(JY.Data_Base,offset+2,War.Person[i].x);
 Byte.set8(JY.Data_Base,offset+3,War.Person[i].y);
 Byte.set8(JY.Data_Base,offset+4,War.Person[i].d);
 Byte.set8(JY.Data_Base,offset+5,War.Person[i].ai);
 Byte.set16(JY.Data_Base,offset+6,War.Person[i].aitarget);
 Byte.set8(JY.Data_Base,offset+8,War.Person[i].ai_dx);
 Byte.set8(JY.Data_Base,offset+9,War.Person[i].ai_dy);
 local v=0;
 if War.Person[i].enemy then
 v=v+1;
 end
 if War.Person[i].friend then
 v=v+2;
 end
 if War.Person[i].active then
 v=v+4;
 end
 if War.Person[i].live then
 v=v+8;
 end
 if War.Person[i].hide then
 v=v+16;
 end
 if War.Person[i].was_hide then
 v=v+32;
 end
 if War.Person[i].troubled then
 v=v+64;
 end
 Byte.set8(JY.Data_Base,offset+10,v);
 offset=offset+11;
 end
 --Map
 offset=4400;
 for i=1,War.Width*War.Depth do
 local v=War.Map[i]+32*War.Map[War.Width*War.Depth*(9-1)+i];
 Byte.set8(JY.Data_Base,offset+i,v);
 end
 --Save
 SaveRecord(id);
end
----------------------------------------------------------------
-- WarLoad()
-- 读取战场
----------------------------------------------------------------
function WarLoad(id)
 --Load
 --LoadRecord(id);
 WarIni();
 --War basic informaction
 War.MapID=Byte.get8(JY.Data_Base,128);
 War.Width=Byte.get8(JY.Data_Base,129);
 War.Depth=Byte.get8(JY.Data_Base,130);
 War.CX=Byte.get8(JY.Data_Base,131);
 War.CY=Byte.get8(JY.Data_Base,132);
 War.PersonNum=Byte.get16(JY.Data_Base,133);
 War.Weather=Byte.get8(JY.Data_Base,135);
 War.Turn=Byte.get8(JY.Data_Base,136);
 War.MaxTurn=Byte.get8(JY.Data_Base,137);
 War.Leader1=Byte.get16(JY.Data_Base,138);
 War.Leader2=Byte.get16(JY.Data_Base,140);
 War.EnemyNum=Byte.get8(JY.Data_Base,142);
 War.WarName=JY.Base["战场名称"];
 War.WarTarget=JY.Base["战场目标"];
 --[[
 if CC.SrcCharSet==1 then
 War.WarName=lib.CharSet(Byte.getstr(JY.Data_Base,150,50),0);
 War.WarTarget=lib.CharSet(Byte.getstr(JY.Data_Base,200,100),0);
 else
 War.WarName=Byte.getstr(JY.Data_Base,150,50);
 War.WarTarget=Byte.getstr(JY.Data_Base,200,100);
 end
 ]]--
 --Map
 War.MiniMapCX=680-War.Width*2;
 War.MiniMapCY=411-War.Depth*2;
 War.Map={};
 CleanWarMap(1,0); --地形
 CleanWarMap(2,0); --wid
 CleanWarMap(3,0); --
 CleanWarMap(4,1); --选择范围
 CleanWarMap(5,-1); --攻击价值
 CleanWarMap(6,-1); --策略价值
 CleanWarMap(7,0); --选择的策略
 CleanWarMap(8,0); --AI强化用，我军的攻击范围
 CleanWarMap(9,0); --水火控制
 CleanWarMap(10,0); --攻击范围，显示用
 local offset=4400;
 for i=1,War.Width*War.Depth do
 local v=Byte.get8(JY.Data_Base,offset+i);
 local v1=v%32;
 local v2=math.modf(v/32);
 War.Map[i]=v1;
 War.Map[War.Width*War.Depth*(9-1)+i]=v2;
 end
 --War.Person
 offset=300;
 for i=1,War.PersonNum do
 War.Person[i]={};
 War.Person[i].id=Byte.get16(JY.Data_Base,offset);
 War.Person[i].x=Byte.get8(JY.Data_Base,offset+2);
 War.Person[i].y=Byte.get8(JY.Data_Base,offset+3);
 War.Person[i].d=Byte.get8(JY.Data_Base,offset+4);
 War.Person[i].ai=Byte.get8(JY.Data_Base,offset+5);
 War.Person[i].aitarget=Byte.get16(JY.Data_Base,offset+6);
 War.Person[i].ai_dx=Byte.get8(JY.Data_Base,offset+8);
 War.Person[i].ai_dy=Byte.get8(JY.Data_Base,offset+9);
 local v=Byte.get8(JY.Data_Base,offset+10);
 if v%2==1 then
 War.Person[i].enemy=true;
 else
 War.Person[i].enemy=false;
 end
 if (math.modf(v/2))%2==1 then
 War.Person[i].friend=true;
 else
 War.Person[i].friend=false;
 end
 if (math.modf(v/4))%2==1 then
 War.Person[i].active=true;
 else
 War.Person[i].active=false;
 end
 if (math.modf(v/8))%2==1 then
 War.Person[i].live=true;
 else
 War.Person[i].live=false;
 end
 if (math.modf(v/16))%2==1 then
 War.Person[i].hide=true;
 else
 War.Person[i].hide=false;
 end
 if (math.modf(v/32))%2==1 then
 War.Person[i].was_hide=true;
 else
 War.Person[i].was_hide=false;
 end
 if (math.modf(v/64))%2==1 then
 War.Person[i].troubled=true;
 else
 War.Person[i].troubled=false;
 end
 local pid=War.Person[i].id;
 War.Person[i].action=1; --动作 0静止，1走路...
 War.Person[i].effect=0; --高亮显示
 War.Person[i].hurt=-1; --显示伤害数值
 War.Person[i].bz=JY.Person[pid]["兵种"];
 War.Person[i].movewav=JY.Bingzhong[JY.Person[pid]["兵种"]]["音效"]; --移动音效
 War.Person[i].atkwav=JY.Bingzhong[JY.Person[pid]["兵种"]]["攻击音效"]; --攻击音效
 War.Person[i].movestep=JY.Bingzhong[JY.Person[pid]["兵种"]]["移动"]; --移动范围
 War.Person[i].movespeed=JY.Bingzhong[JY.Person[pid]["兵种"]]["移动速度"]; --移动速度
 War.Person[i].atkfw=JY.Bingzhong[JY.Person[pid]["兵种"]]["攻击范围"]; --攻击范围
 War.Person[i].sq_limited=100;
 War.Person[i].atk_buff=0;
 War.Person[i].def_buff=0;
 War.Person[i].frame=-1; --显示帧数
 if pid==War.Leader1 or pid==War.Leader2 then
 War.Person[i].leader=true;
 else
 War.Person[i].leader=false;
 end
 if War.Person[i].live and (not War.Person[i].hide) then
 SetWarMap(War.Person[i].x,War.Person[i].y,2,i);
 end
 ReSetAttrib(pid,false);
 War.Person[i].pic=WarGetPic(i);
 WarResetStatus(i);
 offset=offset+11;
 end
end
----------------------------------------------------------------
-- RemindSave()
-- 提示是否保存
-- flag, 默认为1 1战前提示 2战后提示
----------------------------------------------------------------
function RemindSave(flag)
 flag=flag or 1;
 if flag==1 then
 DrawSMap();
 elseif flag==2 then
 JY.Status=GAME_START; --仅仅是为了方便自动计算坐标
 end
 if WarDrawStrBoxYesNo("现在储存吗？",C_WHITE,true) then
 local menu2={
 {" 1. ",nil,1},
 {" 2. ",nil,1},
 {" 3. ",nil,1},
 {" 4. ",nil,1},
 {" 5. ",nil,1},
 }
 for id=1,5 do
 if not fileexist(CC.R_GRPFilename[id]) then
 menu2[id][1]=menu2[id][1].."未使用档案";
 else
 menu2[id][1]=menu2[id][1]..GetRecordInfo(id);
 end
 end
 DrawYJZBox2(-1,104,"将档案储存在哪里？",C_WHITE);
 local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,C_WHITE,C_WHITE);
 if between(s2,1,5) then
 if WarDrawStrBoxYesNo(string.format("储存在硬碟的第%d号，可以吗？",s2),C_WHITE,true) then
 if flag==2 then
 JY.Status=GAME_SMAP_AUTO; --与前面对应，改回来
 end
 SaveRecord(s2);
 end
 end
 end
 if flag==1 then
 DrawSMap();
 elseif flag==2 then
 JY.Status=GAME_SMAP_AUTO; --与前面对应，改回来
 end
end
----------------------------------------------------------------
-- LvUp(pid,n)
-- 等级上升
-- pid 人物id, n 默认为1
----------------------------------------------------------------
function LvUp(pid,n)
 pid=pid or 0;
 n=n or 1;
 if pid>0 then
 JY.Person[pid]["等级"]=limitX(JY.Person[pid]["等级"]+n,1,99);
 end
end
----------------------------------------------------------------
-- WarCheckLocation(pid,x,y)
-- 测试到达战场坐标
-- pid 人物id, -1时为任意我方武将
----------------------------------------------------------------
function WarCheckLocation(pid,y,x)
 --pid=-1代表任意我方我将
 pid=pid+1; --修正
 x=x+1;
 y=y+1;
 if War.SelID==0 then
 return false;
 end
 local v=War.Person[War.SelID];
 --for i,v in pairs(War.Person) do
 if v.live and (not v.hide) and ((pid==0 and (not v.enemy) and (not v.friend)) or pid==v.id) and x==v.x and y==v.y then
 return true;
 end
 --end
 return false;
end
----------------------------------------------------------------
-- WarLocationItem(x,y,item,event)
-- 测试到达战场坐标得到物品
-- x,y 坐标, item 物品id, event 检查事件id
----------------------------------------------------------------
function WarLocationItem(y,x,item,event)
 if War.SelID==0 then
 return false;
 end

if JY.Person[War.Person[War.SelID].id]["道具8"]>0 then
return false
end

 x=x+1;
 y=y+1;
 if (not GetFlag(event)) then
 local v=War.Person[War.SelID];
 --for i,v in pairs(War.Person) do
 if v.live and (not v.hide) and (not v.enemy) and (not v.friend) and x==v.x and y==v.y then
 WarGetItem(War.SelID,item);
 SetFlag(event,1);
 --break;
 end
 --end
 end
end
----------------------------------------------------------------
-- WarCheckArea(pid,x1,y1,x2,y2)
-- 测试到达战场坐标
-- pid 人物id, -1时为任意我方武将
----------------------------------------------------------------
function WarCheckArea(pid,y1,x1,y2,x2)
 --pid=-1代表任意我方我将
 pid=pid+1; --修正
 x1=x1+1;
 y1=y1+1;
 x2=x2+1;
 y2=y2+1;
 if War.SelID==0 then
 return false;
 end
 local v=War.Person[War.SelID];
 --for i,v in pairs(War.Person) do
 if v.live and (not v.hide) and ((pid==0 and (not v.enemy)) or pid==v.id) and between(v.x,x1,x2) and between(v.y,y1,y2) then
 return true;
 end
 --end
 return false;
end
function GetWarID(pid)
 for i,v in pairs(War.Person) do
 if pid==v.id then
 return i;
 end
 end
 return 0;
end
function WarMeet(pid1,pid2)
 local id1,id2=0,0;
 if War.SelID==0 then
 return false;
 end
 if pid1==-1 then --不限定特点人物
 if War.Person[War.SelID].enemy then --必须不为敌军
 return false;
 else
 id1=War.SelID;
 pid1=War.Person[War.SelID].id;
 end
 elseif War.Person[War.SelID].id==pid1 then --指定人物 必须为当前行动人物
 id1=War.SelID;
 else
 return false;
 end
 id2=GetWarID(pid2);
 if id1>0 and id2>0 and
 War.Person[id1].live and War.Person[id2].live and 
 (not War.Person[id1].hide) and (not War.Person[id2].hide) and 
 JY.Person[pid1]["兵力"]>0 and JY.Person[pid2]["兵力"]>0 then
 if math.abs(War.Person[id1].x-War.Person[id2].x)+math.abs(War.Person[id1].y-War.Person[id2].y)==1 then
 return true;
 end
 end
 return false;
end
----------------------------------------------------------------
-- WarMoveTo(pid,x,y)
-- 人物移动到指定坐标
-- pid 人物id
----------------------------------------------------------------
function WarMoveTo(pid,x,y)
 x=x+1;
 y=y+1;
 local wid=GetWarID(pid);
 if wid>0 then
 War.SelID=wid;
 War_CalMoveStep(wid,256,true);
 x,y=WarGetExistXY(x,y,wid);
 War_MovePerson(x,y);
 CleanWarMap(4,1);
 War.LastID=War.SelID;
 War.SelID=0;
 end
end
----------------------------------------------------------------
-- WarShowArmy(pid)
-- 伏兵出现
-- pid 人物id
----------------------------------------------------------------
function WarShowArmy(pid)
 pid=pid+1; --修正id
 local wid=GetWarID(pid);
 if wid>0 then
 if (not War.Person[wid].hide) or (not War.Person[wid].live) then
 return;
 end
 local x,y=War.Person[wid].x,War.Person[wid].y;
 if WarCanExistXY(x,y,wid) then
 War.Person[wid].hide=false;
 WarPersonCenter(wid);
 SetWarMap(x,y,2,wid);
 PlayWavE(15);
 WarDelay(4);
 return;
 end
 local DX={0,0,-1,1};
 local DY={1,-1,0,0}
 local dx={1,-1,1,-1,};
 local dy={-1,1,1,-1}
 for n=1,8 do
 for d=1,4 do
 for i=1,n do
 local nx=x+DX[d]*n+dx[d]*i;
 local ny=y+DY[d]*n+dy[d]*i;
 if between(nx,1,War.Width) and between(ny,1,War.Depth) then
 if WarCanExistXY(nx,ny,wid) then
 War.Person[wid].x=nx;
 War.Person[wid].y=ny;
 War.Person[wid].hide=false;
 WarPersonCenter(wid);
 SetWarMap(nx,ny,2,wid);
 PlayWavE(15);
 WarDelay(4);
 return;
 end
 end
 end
 end
 end
 end
end
----------------------------------------------------------------
-- WarGetExistXY(x,y,wid)
-- 寻找最近的可以出现的地点
-- x,y目标地点
-- wid战场人物id
----------------------------------------------------------------
function WarGetExistXY(x,y,wid)
 local DX={0,0,-1,1};
 local DY={1,-1,0,0}
 local dx={1,-1,1,-1,};
 local dy={-1,1,1,-1}
 if WarCanExistXY(x,y,wid) then
 return x,y;
 end
 for n=1,8 do
 for d=1,4 do
 for i=1,n do
 local nx=x+DX[d]*n+dx[d]*i;
 local ny=y+DY[d]*n+dy[d]*i;
 if between(nx,1,War.Width) and between(ny,1,War.Depth) then
 if WarCanExistXY(nx,ny,wid) then
 return nx,ny;
 end
 end
 end
 end
 end
 return War.Person[wid].x,War.Person[wid].y;
end
----------------------------------------------------------------
-- GetMoney(money)
-- 获得黄金
-- money 黄金数量,为负数时失去黄金，无提示
----------------------------------------------------------------
function GetMoney(money)
 JY.Base["黄金"]=limitX(JY.Base["黄金"]+money,0,50000);
end
----------------------------------------------------------------
-- GetItem(pid,item)
-- 获得道具
-- pid 人物id
----------------------------------------------------------------
function GetItem(pid,item)
 for i=1,8 do
 if JY.Person[pid]["道具"..i]==0 then
 JY.Person[pid]["道具"..i]=item;
 PlayWavE(11);
 DrawStrBoxWaitKey("获得"..JY.Item[item]["名称"].."．",C_WHITE);
 return true;
 end
 end
 return false;
end
----------------------------------------------------------------
-- WarGetItem(wid,item)
-- 获得道具
-- wid 人物wid
----------------------------------------------------------------
function WarGetItem(wid,item)
 local pid=War.Person[wid].id;
 for i=1,8 do
 if JY.Person[pid]["道具"..i]==0 then
 JY.Person[pid]["道具"..i]=item;
 PlayWavE(11);
 WarDrawStrBoxWaitKey("获得"..JY.Item[item]["名称"].."．",C_WHITE);
 ReSetAttrib(pid,false);
 return true;
 end
 end
 return false;
end
----------------------------------------------------------------
-- LoseItem(wid,item)
-- 失去道具
-- wid 人物wid
----------------------------------------------------------------
function WarLoseItem(wid,item)
 local pid=War.Person[wid].id;
 for i=1,8 do
 if JY.Person[pid]["道具"..i]==0 then
 JY.Person[pid]["道具"..i]=item;
 PlayWavE(11);
 WarDrawStrBoxWaitKey("获得"..JY.Item[item]["名称"].."．",C_WHITE);
 ReSetAttrib(pid,false);
 return true;
 end
 end
 return false;
end
----------------------------------------------------------------
-- WarGetExp(Exp)
-- 残存部队得到50点经验值．
-- Exp 经验值,无用
----------------------------------------------------------------
function WarGetExp(Exp)
 Exp=50;
 PlayWavE(0);
 lib.GetKey();
 local x,y;
 local w=288;
 local h=80;
 x=16+576/2-w/2;
 y=32+432/2-h/2;
 local x1=x+205;
 local y1=y+36;
 local x2=x1+52;
 local y2=y1+24
 local function redraw(flag)
 JY.ReFreshTime=lib.GetTime();
 DrawWarMap();
 lib.PicLoadCache(4,84*2,x,y,1);
 if flag==2 then
 lib.PicLoadCache(4,56*2,x1,y1,1);
 else
 lib.PicLoadCache(4,55*2,x1,y1,1);
 end
 ReFresh();
 end
 local current=0;
 while true do
 redraw(current);
 getkey();
 if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
 current=2;
 elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
 current=0;
 PlayWavE(0);
 redraw(current);
 WarDelay(4);
 break;
 else
 current=0;
 end
 end
 for i,v in pairs(War.Person) do
 if v.live and (not v.hide) then
 if (not v.enemy) and (not v.friend) then
 local pid=v.id;
if JY.Person[pid]["等级"]<99 then
 JY.Person[pid]["经验"]=JY.Person[pid]["经验"]+Exp;
 if JY.Person[pid]["经验"]>=100 then
 JY.Person[pid]["经验"]=JY.Person[pid]["经验"]-100;
 WarLvUp(i);
end
 end
 end
 end
 end
end
----------------------------------------------------------------
-- WarGetTrouble(wid)
-- 判断是否进入混乱状态
-- wid war_id
--4.防御方是否会陷入混乱
--如果牵制后，防御方的士气下降到30以下，则按以下算法判断是否会陷入混乱。
--计算出一个0－4之间的随机数，如果随机数小于3，则防御方部队陷入混乱。
--『说明』防御方有60％的可能性陷入混乱。
----------------------------------------------------------------
function WarGetTrouble(wid)
 local pid=War.Person[wid].id;
 if JY.Person[pid]["士气"]<30 and JY.Person[pid]["兵力"]>0 then
 if math.random(5)-1<3 then
 if War.Person[wid].troubled then
 WarDrawStrBoxDelay(JY.Person[pid]["姓名"].."更加混乱了！",C_WHITE);
 else
 War.Person[wid].troubled=true
 War.Person[wid].action=7;
 WarDelay(2);
 WarDrawStrBoxDelay(JY.Person[pid]["姓名"].."混乱了！",C_WHITE);
 end
 end
 end
end
----------------------------------------------------------------
-- WarTroubleShooting(wid)
-- 唤醒混乱中的部队
-- wid war_id
-- 恢复因子＝0～99的随机数，如果恢复因子小于（统御力＋士气）÷3，那么部队被唤醒．由此看出，统御越高，士气越高，越容易从混乱中苏醒．
----------------------------------------------------------------
function WarTroubleShooting(wid)
 local pid=War.Person[wid].id;
 if War.Person[wid].troubled then
 local flag=false;
 if math.random(100)-1<(JY.Person[pid]["统率"]+JY.Person[pid]["士气"])/3 then
 flag=true;
 end
 if CC.Enhancement then
 if WarCheckSkill(wid,20) then --沉着
 flag=true;
 end
 end
 if flag then
 WarPersonCenter(wid);
 War.Person[wid].troubled=false;
 WarDrawStrBoxDelay(JY.Person[pid]["姓名"].."从混乱中恢复！",C_WHITE);
 end
 end
end
----------------------------------------------------------------
-- WarEnemyWeak(id,kind)
-- 兵力士气减半
-- id 1我军 2敌军
-- kind 1兵力 2士气
----------------------------------------------------------------
function WarEnemyWeak(id,kind)
 for i,v in pairs(War.Person) do
 if v.live and (not v.hide) then
 if (id==1 and (not v.enemy)) or (id==2 and v.enemy) then
 local pid=v.id;
 if kind==1 then
 JY.Person[pid]["兵力"]=limitX(JY.Person[pid]["兵力"]/2,1,JY.Person[pid]["最大兵力"]);
 elseif kind==2 then
 JY.Person[pid]["士气"]=limitX(JY.Person[pid]["士气"]/2,1,v.sq_limited);
 ReSetAttrib(pid,false);
 WarGetTrouble(i);
 end
 end
 end
 end
end
----------------------------------------------------------------
-- WarFireWater(x,y,kind)
-- 水火控制
-- x,y坐标,输入为dos版坐标，实际需要+1修正
-- kind 1放火 2放水 3取消放水
----------------------------------------------------------------
function WarFireWater(x,y,kind)
 x=x+1;
 y=y+1;
 if kind==3 then
 SetWarMap(x,y,9,0)
 else
 if GetWarMap(x,y,2)==0 then
 SetWarMap(x,y,9,kind);
 end
 if kind==1 then
 --PlayWavE(51);
 elseif kind==2 then
 --PlayWavE(53);
 end
 end
 War.CX=limitX(x-math.modf(War.MW/2),1,War.Width-War.MW+1);
 War.CY=limitX(y-math.modf(War.MD/2),1,War.Depth-War.MD+1);
 WarDelay(CC.WarDelay);
end

----------------------------------------------------------------
-- WarCheckSkill(wid,skillid)
-- 检查是否具有某项技能
-- wid 人物战斗编号
-- skillid 技能编号
----------------------------------------------------------------
function WarCheckSkill(wid,skillid)
 local pid=War.Person[wid].id;
if JY.Person[pid]["天赋"]==skillid then
return true;
end

if JY.Person[pid]["姓名"]==JY.Item[JY.Person[pid]["武器"]]["专属特技人"] and JY.Item[JY.Person[pid]["武器"]]["专属特技"]==skillid then
return true;
end

if JY.Item[JY.Person[pid]["武器"]]["特技"]==skillid then
return true;
end

 for i=1,6 do
 if JY.Person[pid]["特技"..i]==skillid then
 if JY.Person[pid]["等级"]>=CC.SkillExp[JY.Person[pid]["成长"]][i] then
 return true;
 end
 end
 end

 return false;
end

function CheckSkill(pid,skillid)
 if pid<=0 then
 return false;
 end
if JY.Person[pid]["天赋"]==skillid then
return true;
end
 for i=1,6 do
 if JY.Person[pid]["特技"..i]==skillid then
 if JY.Person[pid]["等级"]>=CC.SkillExp[JY.Person[pid]["成长"]][i] then
 return true;
 end
 end
 end
 return false;
end

--原fight.lua
function fight(id1,id2,sid)
 if JY.Status==GAME_START or JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL or JY.Status==GAME_MMAP then
 Dark();
 if CC.ScreenW~=CONFIG.Width2 or CC.ScreenH~=CONFIG.Height2 then
 CC.ScreenW=CONFIG.Width2;
 CC.ScreenH=CONFIG.Height2;
 Config();
 PicCatchIni();
 end
 elseif JY.Status==GAME_WMAP or JY.Status==GAME_DEAD or JY.Status==GAME_END then
 Dark();
 end
 if sid==nil then
 if JY.Status==GAME_WMAP then
 local wid=GetWarID(id2);
 sid=GetWarMap(War.Person[wid].x,War.Person[wid].y,1);
 else
 local s={0,1,2,4,6};
 sid=s[math.random(5)];
 end
 end
 local r=fight_sub(id1,id2,sid);
 Dark();
 if JY.Status==GAME_START then
 
 elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL or JY.Status==GAME_MMAP then
 if CC.ScreenW~=CONFIG.Width or CC.ScreenH~=CONFIG.Height then
 CC.ScreenW=CONFIG.Width;
 CC.ScreenH=CONFIG.Height;
 Config();
 PicCatchIni();
 end
 DrawSMap();
 Light();
 elseif JY.Status==GAME_WMAP then
 DrawWarMap();
 Light();
 elseif JY.Status==GAME_DEAD then
 elseif JY.Status==GAME_END then
 end
 return r;
end
function fight_sub(id1,id2,sid)
 local n=2;
 local ID={id1,id2};
 local p1,p2=JY.Person[id1],JY.Person[id2];
 local fightname=fillblank(p1["姓名"],12).."战"..fillblank(p2["姓名"],12)
 local card={[1]={},[2]={}};
 local card_num={};
 local str={
 [1]={ "%s在此，*来将速速通名受死！", "我乃%s是也！*全力一战吧！",
 "我乃%s也！*来将通名再战！", "%s在此，*放马过来吧！",
 "%s来了！*对面战将，可留姓名？", "%s在此，*拿命来吧！",
 "我乃%s，*本将刀下不斩无名之鬼！", "%s在此，*让我看你到底有多厉害",
 "我乃%s也！*谁敢一战！", "好极了！*%s接受你的挑战。",
 "居然有人敢挑战我%s？", "多说无益！*接招吧！",
 "%s在此，*有不要命的敢上来吗？", "我%s不会手软的。*来吧，看招！",
 "我乃%s也，*今日必定斩将立功！", "%s在此，*看我一招结果你！",
 "%s在此，*活动活动一下吧！", "%s在此，*看我一招结果你！",
 "我%s来了！*看我来大闹一番！", "有意思，*我%s来斗斗你！",
 "我乃%s，*敌将，我来取你项上人头了！", "哼、无名小辈！*滚开！",
 "我乃%s。*你这个不知天高地厚的混蛋，*快报名上来！", "说什么蠢话，*看我%s的厉害吧！",
 "%s在此，*跟我一决胜负吧！", "哈哈哈！*好，放马过来！",
 "领教领教我%s的武艺吧！", "来吧！*%s来会会你！",
 "遇到了我%s算你倒霉，*哈哈哈，今天就是你的死期！", "这个玩笑真有意思，*看我怎么砍下你的脑袋！",},
 [2]={"呀~呀~呀~呀~呀！！！","看这招！","你躲得过去吗！","小心了！","杀！！！",
 "这招对付你，足够了！","看我取你狗命！","不能再让你了！","觉悟吧！","去死！",},
 [3]={"这一招，仔细看清楚吧！","来吧！*如果你跟得上我的速度！","你惹火我了！*来试试这招吧！","只有这点能耐吗？*那可不行哦！","来吧！*你值得我使出这一招！",
 "还没完呢！再来！","哈哈哈哈！*一切的准备都是为了这一招！","......*死！","来尝尝我的家传绝技吧！","这一招，*虽然还不够熟练，*但是击败你绰绰有余！",
 "真勇猛！*不过接得住我这一招吗，看招！","唔喔喔喔喔！*我生气了！*我真的生气了！","你已经完蛋了！*让你见识我真正的绝招，*就当送你下黄泉的礼物吧！","哈哈哈，*太慢了，太慢了！","哈哈，你上当了！*吃我这招！",},
 [4]={"哼！","啊！","果然有一手","真厉害！","好大的力气！",
 "好快的速度！","这家伙，*是怪物吗？","真没想到......","还不能认输...","居然没防住？",
 "可、可恶...","哇啊啊啊啊......！","怎、怎么可能...","哇呀！*糟、糟了！","唔唔！",},
 [5]={"不过如此！","好险！","华而不实！","看来你技穷了","这也叫招式吗？",
 "你还能再慢点吗？","就像饶痒痒一样","换我反击了！","你这招根本就没有练熟！","再来再来！*一点感觉都没有！",
 "怎么啦，*你就只有这两下子？","就凭这等武艺，*还想胜我？","怎么啦？*根本不管用嘛！","这种雕虫小技在我面前，*根本就是班门弄斧！","真有意思，*可以对我完全没用。",},
 [6]={"居然输了...","我不能死在这里...","怎么会这样！","不该和他打的...","这家伙太恐怖了！",
 "想不到我会败在这里...","天要亡我吗！","耻辱！","奇怪？*力气...怎么没力气了?","再不能临阵讨贼了！",
 "败在你手上，*我无话可说。","唔、果然厉害！","这就是我和你之间的差距吗......","...*......","天下之大，*居然还有如此强劲的对手！",},
 [7]={"敌将被我击败了！","哈哈哈哈！*还有人敢上吗！","不堪一击！","真痛快！","欢呼吧！",
 "知道厉害了吧!","这就赢了？*还没过瘾呢！","赢了","这就是反贼的下场！","太弱了！",},
 }
 card_num[1]=5+p1["威风"];
 card_num[2]=5+p2["威风"];
 --[[
 if p1["等级"]>=30 then
 card_num[1]=6;
 elseif p1["等级"]>=15 then
 card_num[1]=5;
 else
 card_num[1]=4;
 end
 if p2["等级"]>=30 then
 card_num[2]=6;
 elseif p2["等级"]>=15 then
 card_num[2]=5;
 else
 card_num[2]=4;
 end
 ]]--
 local hpmax={150+p1["等级"],150+p2["等级"]};
 local hp={150+p1["等级"],150+p2["等级"]};
 local mp={20,20};
 if p1["武力"]>p2["武力"] then
 mp[1]=35;
 elseif p1["武力"]<p2["武力"] then
 mp[2]=35;
 end
 local atk={math.max(math.modf(p1["武力"]/10)-1,2),math.max(math.modf(p2["武力"]/10)-1,2)};
 if atk[1]-atk[2]>5 then
 atk[2]=atk[1]-5;
 elseif atk[2]-atk[1]>5 then
 atk[1]=atk[2]-5;
 end
 --[[local atk_offset=math.max(0,8-math.max(atk[1],atk[2]))
 atk[1]=atk[1]+atk_offset;
 atk[2]=atk[2]+atk_offset;]]--
 local atk_offset=8/math.max(atk[1],atk[2]);
 atk[1]=math.modf(atk[1]*atk_offset);
 atk[2]=math.modf(atk[2]*atk_offset);
 atk[1]=atk[1]+math.modf(p1["奋战"]/8)-p2["奋战"]%8;
 atk[2]=atk[2]+math.modf(p2["奋战"]/8)-p1["奋战"]%8;
 if p1["士气"]<80 then
 atk[1]=atk[1]-1;
 end
 if p1["士气"]<30 then
 atk[1]=atk[1]-1;
 end
 if p2["士气"]<80 then
 atk[2]=atk[2]-1;
 end
 if p2["士气"]<30 then
 atk[2]=atk[2]-1;
 end
 if atk[1]<2 then
 atk[1]=2
 end
 if atk[2]<2 then
 atk[2]=2
 end
 if JY.Status==GAME_WMAP then
 --atk[1]=atk[1]+1;
 end
 local s={};
 s[1]={
 d=0, --0123 下上左右
 x=96,
 pic=p1["战斗动作"],
 action=9, --0静止 1移动 2攻击 3防御 4被攻击 5喘气 9不存在
 frame=0,
 effect=0,
 mpadd=6+4*p1["怒发"]+p1["勇猛"]/2+math.max(0,p1["士气"]/10-8),
 luck=math.min(30,p1["勇猛"]+p1["冷静"]*3+10*p1["强运"])+10*p1["强运"],
 movewav=JY.Bingzhong[p1["兵种"]]["音效"],
 atkbuff=JY.Bingzhong[p1["兵种"]]["攻击"]/2,
 defbuff=JY.Bingzhong[p1["兵种"]]["防御"]/2,
 ym=p1["勇猛"],
 lj=p1["冷静"],
 lv=p1["等级"],
 loser=false,
 dl=p1["底力"], --底力可否使用
 jj=p1["急救"], --急救可否使用
 bq=p1["不屈"], --不屈，最低伤害下限，否则不受伤害
 txt="",
 };
 s[2]={
 d=0,
 x=576,
 pic=p2["战斗动作"],
 action=9, --0静止 1移动 2攻击 3防御 4被攻击 5喘气 6举手 9不存在
 frame=0,
 effect=0,
 mpadd=6+4*p2["怒发"]+p2["勇猛"]/2+math.max(0,p2["士气"]/10-8),
 luck=math.min(30,p2["勇猛"]+p2["冷静"]*3+10*p2["强运"])+10*p2["强运"],
 movewav=JY.Bingzhong[p2["兵种"]]["音效"],
 atkbuff=JY.Bingzhong[p2["兵种"]]["攻击"]/2,
 defbuff=JY.Bingzhong[p2["兵种"]]["防御"]/2,
 ym=p2["勇猛"],
 lj=p2["冷静"],
 lv=p2["等级"],
 dz=math.random(math.modf(p2["士气"]/2+1),p2["士气"]+3),
 loser=false,
 dl=p2["底力"],
 jj=p2["急救"], --急救可否使用
 bq=p2["不屈"], --不屈，最低伤害下限，否则不受伤害
 txt="",
 };
 s[1].ym=limitX(s[1].ym,0,math.modf(p1["士气"]/14));
 s[1].lj=limitX(s[1].lj,0,math.modf(p1["士气"]/14));
 s[2].ym=limitX(s[2].ym,0,math.modf(p2["士气"]/14));
 s[2].lj=limitX(s[2].lj,0,math.modf(p2["士气"]/14));
 local size=48*2;
 local size2=64*2;
 local sy=256;
 local pic1=0;
 local pic2=10;
 -- 00 平原 01 森林 02 山地 03 河流 04 桥梁 05 城墙 06 城池 07 草原
 -- 08 村庄 09 悬崖 0A 城门 0B 荒地 0C 栅栏 0D 鹿砦 0E 兵营 0F 粮仓
 -- 10 宝物库 11 房舍 12 火焰 13 浊流
 if sid==0 or sid==7 then
 pic1=4;
 pic2=12;
 elseif sid==2 or sid==11 then
 pic1=0;
 pic2=13;
 elseif sid==1 then
 pic1=3;
 pic2=12;
 elseif sid==4 then
 pic1=1;
 pic2=11;
 elseif sid==6 or sid==8 or sid==13 or sid==14 or sid==15 or sid==16 then
 pic1=2;
 pic2=10;
 end
 local function admp(i,v)
 v=math.modf(v);
 mp[i]=limitX(mp[i]+v,0,100);
 end
 local function dechp(i,v,flag) --flag 格挡成功
 flag=flag or false;
 if math.random(100)<s[3-i].atkbuff then
 v=v+1;
 end
 if math.random(100)<s[i].defbuff then
 v=v-1;
 end
 v=math.modf(v);
 if v<1 then
 v=1;
 end
 if flag and s[i].bq>0 then
 v=0;
 end
 --[[
 if s[i].bq<1 or v==0 then
 hp[i]=hp[i]-v;
 elseif hp[i]<=s[i].bq then
 hp[i]=hp[i]-1;
 elseif hp[i]-v<s[i].bq then
 hp[i]=s[i].bq;
 else
 hp[i]=hp[i]-v;
 end]]--
 hp[i]=hp[i]-v;
 
 if hp[i]<0 then
 hp[i]=0;
 end
 --被攻击时mp增加
 admp(i,1+v/2);
 end
 local function show()
 getkey();
 --center=496(from 412,add 84)
 lib.FillColor(0,0,0,0,0);
 lib.PicLoadCache(1,pic2*2,-408,212,1);
 lib.PicLoadCache(1,pic1*2,-168,92,1);
 
 DrawBox(84,101,152,185,C_WHITE);
 lib.PicLoadCache(2,p1["头像代号"]*2,86,103,1);
 if s[1].losser then
 lib.Background(86,103,86+64,103+80,106);
 end
 DrawBox(154,163,222,185,C_WHITE);
 DrawBox(224,163,292,185,C_WHITE);
 DrawString(188-#p1["姓名"]*4,166,p1["姓名"],C_WHITE,16);
 DrawString(226,166,string.format("武力 %3d",p1["武力"]),C_WHITE,16);
 DrawStrBox(166,101,s[1].txt,C_WHITE,16);
 --[[
 DrawString(332,146," Hp|HpM| Mp|MpA|Atk|Card_N",C_WHITE,12);
 DrawString(332,166,string.format("%3d,%3d,%2d,%2d,%3d,%3d",hp[1],hpmax[1],mp[1],s[1].mpadd,atk[1],card_num[1]),C_WHITE,12);
 ]]--
 
 
 DrawBox(616,101,684,185,C_WHITE);
 lib.PicLoadCache(2,p2["头像代号"]*2,618,103,1);
 if s[2].losser then
 lib.Background(618,103,618+64,103+80,106);
 end
 DrawBox(546,163,614,185,C_WHITE);
 DrawBox(476,163,544,185,C_WHITE);
 DrawString(580-#p2["姓名"]*4,166,p2["姓名"],C_WHITE,16);
 DrawString(478,166,string.format("武力 %3d",p2["武力"]),C_WHITE,16);
 DrawStrBox(-162,101,s[2].txt,C_WHITE,16);
 --[[
 DrawString(500,146," Hp|HpM| Mp|MpA|Atk|Card_N",C_WHITE,12);
 DrawString(500,166,string.format("%3d,%3d,%2d,%2d,%3d,%3d",hp[2],hpmax[2],mp[2],s[2].mpadd,atk[2],card_num[2]),C_WHITE,12);
 ]]--
 
 lib.FillColor(384-math.modf(300*hp[1]/hpmax[1]),192,384,204,M_Red);
 lib.FillColor(384,192,384+math.modf(300*hp[2]/hpmax[2]),204,M_Blue);
 --[[
 lib.FillColor(496-mp[1]*3,212,496,224,M_Red);
 lib.FillColor(496,212,496+mp[2]*3,224,M_Blue);
 DrawString(344,166,atk[1],C_WHITE,16);
 DrawString(634,166,atk[2],C_WHITE,16);
 ]]--
 DrawBox(81,192,687,204,C_WHITE);
 for i=1,2 do
 if s[i].action==0 then
 lib.PicLoadCache(11,(s[i].pic+16+s[i].d)*2,s[i].x,sy,1);
 if s[i].effect>0 then
 lib.PicLoadCache(11,(s[i].pic+16+s[i].d)*2,s[i].x,sy,1+2+8,s[i].effect);
 end
 elseif s[i].action==1 then
 lib.PicLoadCache(11,(s[i].pic+s[i].frame+s[i].d*4)*2,s[i].x,sy,1);
 if s[i].effect>0 then
 lib.PicLoadCache(11,(s[i].pic+s[i].frame+s[i].d*4)*2,s[i].x,sy,1+2+8,s[i].effect);
 end
 elseif s[i].action==2 then
 lib.PicLoadCache(11,(s[i].pic+30+s[i].frame+s[i].d*4)*2,s[i].x+(size-size2)/2,sy+(size-size2)/2,1);
 if s[i].effect>0 then
 lib.PicLoadCache(11,(s[i].pic+30+s[i].frame+s[i].d*4)*2,s[i].x+(size-size2)/2,sy+(size-size2)/2,1+2+8,s[i].effect); 
 end
 elseif s[i].action==3 then
 lib.PicLoadCache(11,(s[i].pic+22+s[i].d)*2,s[i].x,sy,1);
 if s[i].effect>0 then 
 lib.PicLoadCache(11,(s[i].pic+22+s[i].d)*2,s[i].x,sy,1+2+8,s[i].effect); 
 end
 elseif s[i].action==4 then
 lib.PicLoadCache(11,(s[i].pic+26+s[i].d%2)*2,s[i].x,sy,1);
 if s[i].effect>0 then
 lib.PicLoadCache(11,(s[i].pic+26+s[i].d%2)*2,s[i].x,sy,1+2+8,s[i].effect);
 end
 elseif s[i].action==5 then
 lib.PicLoadCache(11,(s[i].pic+20+s[i].frame)*2,s[i].x,sy,1);
 if s[i].effect>0 then
 lib.PicLoadCache(11,(s[i].pic+20+s[i].frame)*2,s[i].x,sy,1+2+8,s[i].effect);
 end
 elseif s[i].action==6 then
 lib.PicLoadCache(11,(s[i].pic+28)*2,s[i].x,sy,1);
 if s[i].effect>0 then
 lib.PicLoadCache(11,(s[i].pic+28)*2,s[i].x,sy,1+2+8,s[i].effect);
 end
 end
 end
 lib.PicLoadCache(4,206*2,0,0,1);
 DrawString(384-#fightname*16/2/2,8,fightname,C_WHITE,16);
 end
 local function turn(id,d)
 if s[id].d==d then
 return;
 end
 s[id].action=0;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(2);
 --ReFresh();
 if s[id].d~=0 then
 s[id].d=0;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(2);
 --ReFresh();
 end
 s[id].d=d;
 JY.ReFreshTime=lib.GetTime();
 show();
 PlayWavE(6);
 ReFresh(2);
 --ReFresh();
 end
 local function move(id,dx)
 local flag=1;
 s[id].action=1;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 local step=12;
 if dx<s[id].x then
 step=-12;
 end
 for i=s[id].x,dx,step do
 s[id].x=i;
 s[id].frame=s[id].frame+1;
 if s[id].frame>=2 then
 s[id].frame=0;
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 if flag==1 then
 PlayWavE(s[id].movewav);
 flag=4;
 else
 flag=flag-1;
 end
 ReFresh(3);
 --ReFresh();
 --ReFresh();
 lib.GetKey();
 end
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 JY.ReFreshTime=lib.GetTime();
 show();
 PlayWavE(s[id].movewav);
 ReFresh(2);
 --ReFresh();
 end
 local function move2(dx1,dx2)
 local count=1;
 local step1,step2=12,12;
 if dx1<s[1].x then
 step1=-12;
 turn(1,2);
 else
 turn(1,3)
 end
 if dx2<s[2].x then
 step2=-12;
 turn(2,2);
 else
 turn(2,3)
 end
 s[1].action=1;
 s[2].action=1;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 local mt=0;
 while true do
 local flag=true;
 if s[1].x~=dx1 then
 flag=false;
 s[1].x=s[1].x+step1;
 s[1].frame=s[1].frame+1;
 if s[1].frame>=2 then
 s[1].frame=0;
 end
 else
 s[1].action=0;
 end
 if s[2].x~=dx2 then
 flag=false;
 s[2].x=s[2].x+step2;
 s[2].frame=s[2].frame+1;
 if s[2].frame>=2 then
 s[2].frame=0;
 end
 else
 s[2].action=0;
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 if count==1 then
 if s[1].action==1 then
 PlayWavE(s[1].movewav);
 end
 if s[2].action==1 then
 PlayWavE(s[2].movewav);
 end
 count=4;
 else
 count=count-1;
 end
 ReFresh(4);
 --ReFresh();
 --ReFresh();
 --ReFresh();
 lib.GetKey();
 if flag then
 break;
 end
 end
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 local function atk_p(id,gd)--普通攻击 平手 gd 暴击概率
 local n=3;
 local flag=false;
 s[id].action=2;
 s[3-id].action=2;
 if math.random(gd)>50 then
 flag=true;
 PlayWavE(6);
 s[1].txt=str[2][math.random(10)];
 s[2].txt=str[2][math.random(10)];
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(4);
 end
 for i=0,3 do
 s[id].frame=i;
 s[3-id].frame=i;
 if flag and i==0 then
 PlayWavE(33);
 for t=8,192,8 do
 s[id].effect=t;
 s[3-id].effect=t;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 s[1].effect=0;
 s[2].effect=0;
 end
 if i==3 then
 if flag then
 PlayWavE(31);
 s[1].txt=str[5][math.random(15)];
 s[2].txt=str[5][math.random(15)];
 else
 PlayWavE(30);
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n);
 end
 if flag then
 if s[3-id].x>s[id].x then
 s[3-id].x=s[3-id].x+24;
 s[id].x=s[id].x-24
 else
 s[3-id].x=s[3-id].x-24;
 s[id].x=s[id].x+24
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n*3);
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 s[1].effect=0;
 s[2].effect=0;
 end
 local function atk_ms(id,gd)--秒杀 gd 暴击概率
 local n=3;
 s[id].action=2;
 local flag=false;
 s[id].txt=str[3][math.random(15)];
 if ID[id]==2 then
 s[id].txt=str[3][math.random(15)].."*鬼胡斩！";
 end
 PlayWavE(6);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(4);
 for i=0,3 do
 s[id].frame=i;
 if i==0 then
 PlayWavE(33);
 for t=24,240,6 do
 s[id].effect=t;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 end
 if i==3 then
 if s[3-id].x>s[id].x then
 s[id].x=s[3-id].x-size;
 else
 s[id].x=s[3-id].x+size;
 end
 if math.random(100)<gd then
 s[3-id].txt=str[5][math.random(15)];
 flag=true;
 s[3-id].action=3;
 PlayWavE(31);
 dechp(3-id,20+atk[id],true);
 s[3-id].effect=208;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 else
 s[3-id].txt=str[4][math.random(15)];
 s[3-id].action=4;
 PlayWavE(36);
 dechp(3-id,300+atk[id]);
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n);
 end
 if s[3-id].x>s[id].x then
 if flag then
 s[id].x=s[3-id].x-size;
 s[3-id].x=s[3-id].x+size;
 else
 s[id].x=s[3-id].x;
 JY.ReFreshTime=lib.GetTime();
 show();
 PlayWavE(s[id].movewav);
 ReFresh();
 s[id].x=s[id].x+size;
 end
 else
 if flag then
 s[id].x=s[3-id].x+size;
 s[3-id].x=s[3-id].x-size;
 else
 s[id].x=s[3-id].x;
 JY.ReFreshTime=lib.GetTime();
 show();
 PlayWavE(s[id].movewav);
 ReFresh();
 s[id].x=s[id].x-size;
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n);
 s[3-id].effect=0;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n*3);
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 s[1].effect=0;
 s[2].effect=0;
 end
 local function atk_aq(id,gd)--暗器偷袭 gd表示格挡几率
 local n=3;
 s[id].action=2;
 local flag1,flag2=0,false;
 if math.random(5)==1 then
 flag1=1;
 end
 if ID[id]==170 then --黄忠
 if flag1==0 then
 if math.random(4)==1 then
 flag1=1;
 end
 end
 gd=gd/2;
 end
 for i=0,3 do
 s[id].frame=i;
 if i==0 then
 PlayWavE(6);
 s[id].txt="嘿嘿嘿*你躲得过这一箭吗！";
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(4);
 if flag1==1 then
 PlayWavE(33);
 for t=8,192,8 do
 s[id].effect=t;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 lib.GetKey();
 end
 end
 s[id].effect=0;
 PlayWavE(37);
 end
 if i==3 then
 if math.random(100)<gd then
 flag2=true;
 s[3-id].action=3;
 PlayWavE(30+flag1);
 dechp(3-id,atk[id]*(1+flag1),true);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 else
 flag2=false
 s[3-id].action=4;
 PlayWavE(35+flag1);
 dechp(3-id,(atk[id]+10)*(1+flag1));
 atk[3-id]=atk[3-id]-1;
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n);
 end
 if flag2 then
 s[3-id].txt="雕虫小技！";
 else
 s[3-id].txt="卑鄙！";
 card_num[3-id]=card_num[3-id]-1;
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n*2);
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 s[1].effect=0;
 s[2].effect=0;
 end
 local function atk_dz(id)--普通攻击 仅动作
 local n=3;
 s[id].action=2;
 for i=0,3 do
 s[id].frame=i;
 if i==3 then
 PlayWavE(7);
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n);
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 s[1].effect=0;
 s[2].effect=0;
 end
 local function atk_dl(id)--底力 仅动作
 s[id].txt="可恶啊！！*我要宰了你！！！";
 atk_dz(id);
 JY.ReFreshTime=lib.GetTime();
 ReFresh(4);
 s[id].action=2;
 for t=1,3 do
 for i=0,3 do
 s[id].frame=i;
 if i==3 then
 PlayWavE(7);
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 lib.GetKey();
 end
 end
 end
 local function atk_jj(id) --急救
 --loser
 s[id].txt="呼~好厉害~";
 PlayWavE(8);
 s[id].action=5;
 for i=1,10 do
 s[id].frame=i%2;
 if i==5 then
 PlayWavE(8);
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(8);
 end
 s[id].txt="还好我还有豆*赶紧吃一颗吧．";
 PlayWavE(41);
 for t=8,255,8 do
 s[id].effect=t;
 hp[id]=hp[id]+1;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 lib.GetKey();
 end
 s[id].action=0;
 s[id].frame=0;
 s[id].effect=0;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(6);
 
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 s[1].effect=0;
 s[2].effect=0;
 end
 local function atk_s0(id,gd)--普通攻击 gd表示格挡几率
 local n=3;
 s[id].action=2;
 for i=0,3 do
 s[id].frame=i;
 if i==3 then
 if math.random(100)<gd then
 s[3-id].action=3;
 PlayWavE(30);
 dechp(3-id,atk[id]/2,true);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 else
 s[3-id].action=4;
 PlayWavE(35);
 dechp(3-id,atk[id]);
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n);
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n*2);
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 s[1].effect=0;
 s[2].effect=0;
 end
 local function atk_s1(id,gd)--小暴击 gd表示格挡几率
 local n=3;
 s[id].action=2;
 local m=24;
 s[id].txt=str[2][math.random(10)];
 PlayWavE(6);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(4);
 for i=0,3 do
 s[id].frame=i;
 if i==0 then
 PlayWavE(33);
 for t=8,192,8 do
 s[id].effect=t;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 s[id].effect=0;
 end
 if i==3 then
 if math.random(100)<gd then
 s[3-id].txt=str[5][math.random(15)];
 m=12;
 s[3-id].action=3;
 PlayWavE(31);
 s[3-id].effect=192;
 dechp(3-id,1+atk[id]/2,true);
 else
 s[3-id].txt=str[4][math.random(15)];
 s[3-id].action=4;
 PlayWavE(36);
 dechp(3-id,5+atk[id]*1.5);
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n);
 end
 if s[3-id].x>s[id].x then
 s[3-id].x=s[3-id].x+m;
 else
 s[3-id].x=s[3-id].x-m;
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n);
 s[3-id].effect=0;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n*2);
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 s[1].effect=0;
 s[2].effect=0;
 end
 local function atk_s2(id,gd)--三连击 gd表示格挡几率
 local n=3;
 local flag=true;
 s[id].txt=str[2][math.random(10)];
 PlayWavE(6);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(4);
 PlayWavE(39);
 for t=8,96,8 do
 s[id].effect=t;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 s[id].effect=0;
 s[id].action=2;
 for t=1,3 do
 for i=0,3 do
 s[id].frame=i;
 if i==3 then
 if flag and math.random(100)<gd+t*7 then
 s[3-id].action=3;
 PlayWavE(30);
 dechp(3-id,1,true);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 else
 flag=false;
 s[3-id].action=4;
 PlayWavE(35);
 dechp(3-id,1+atk[id]/2);
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(2);
 end
 if t==1 then
 JY.ReFreshTime=lib.GetTime();
 ReFresh(4);
 end
 end
 if flag then
 s[3-id].txt=str[5][math.random(15)];
 else
 s[3-id].txt=str[4][math.random(15)];
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n*2);
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 s[1].effect=0;
 s[2].effect=0;
 end
 local function atk_s3(id,gd)--大暴击 gd表示格挡几率
 local n=3;
 s[id].action=2;
 local flag=false;
 s[id].txt=str[3][math.random(15)];
 PlayWavE(6);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(4);
 for i=0,3 do
 s[id].frame=i;
 if i==0 then
 PlayWavE(33);
 for t=24,240,6 do
 s[id].effect=t;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 end
 if i==3 then
 if math.random(100)<gd then
 s[3-id].txt=str[5][math.random(15)];
 flag=true;
 s[3-id].action=3;
 PlayWavE(31);
 dechp(3-id,2+atk[id],true);
 s[3-id].effect=208;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 else
 s[3-id].txt=str[4][math.random(15)];
 s[3-id].action=4;
 PlayWavE(36);
 dechp(3-id,15+atk[id]*2.5);
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n);
 end
 if s[3-id].x>s[id].x then
 if flag or s[3-id].x>672-size*2 then
 s[3-id].x=s[3-id].x+size/2;
 else
 s[id].x=s[3-id].x;
 JY.ReFreshTime=lib.GetTime();
 show();
 PlayWavE(s[id].movewav);
 ReFresh();
 s[id].x=s[id].x+size;
 end
 else
 if flag or s[3-id].x<size*2 then
 s[3-id].x=s[3-id].x-size/2;
 else
 s[id].x=s[3-id].x;
 JY.ReFreshTime=lib.GetTime();
 show();
 PlayWavE(s[id].movewav);
 ReFresh();
 s[id].x=s[id].x-size;
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n);
 s[3-id].effect=0;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n*3);
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 s[1].effect=0;
 s[2].effect=0;
 end
 local function atk_s4(id,gd)--五连击 gd表示格挡几率
 local n=3;
 local flag=true;
 s[id].txt=str[3][math.random(15)];
 PlayWavE(6);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(4);
 PlayWavE(39);
 for t=8,128,8 do
 s[id].effect=t;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 s[id].action=2;
 for t=1,5 do
 for i=0,3 do
 s[id].frame=i;
 if i==3 then
 if flag and math.random(100)<gd+t*7 then
 s[3-id].action=3;
 PlayWavE(30);
 dechp(3-id,1,true);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 else
 flag=false;
 s[3-id].action=4;
 PlayWavE(35);
 dechp(3-id,2+atk[id]/2);
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(1);
 if t%2==0 then
 JY.ReFreshTime=lib.GetTime();
 ReFresh(1);
 end
 end
 end
 if flag then
 s[3-id].txt=str[5][math.random(15)];
 else
 s[3-id].txt=str[4][math.random(15)];
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n*3);
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 s[1].effect=0;
 s[2].effect=0;
 end
 local function atk_s5(id,gd)--回马枪 gd表示格挡几率
 local n=3;
 local m=size/2;
 s[id].action=2;
 local flag=false;
 s[id].txt=str[3][math.random(15)];
 PlayWavE(6);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(4);
 for i=0,3 do
 s[id].frame=i;
 if i==3 then
 if math.random(100)<gd then
 flag=true;
 s[3-id].action=3;
 PlayWavE(30);
 dechp(3-id,2,true);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 else
 s[3-id].action=4;
 PlayWavE(35);
 dechp(3-id,2+atk[id]);
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(2);
 end
 if s[id].x<s[3-id].x then
 s[id].x=s[3-id].x;
 JY.ReFreshTime=lib.GetTime();
 show();
 PlayWavE(s[id].movewav);
 ReFresh();
 s[id].x=s[id].x+size;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 turn(id,2);
 else
 s[id].x=s[3-id].x;
 JY.ReFreshTime=lib.GetTime();
 show();
 PlayWavE(s[id].movewav);
 ReFresh();
 s[id].x=s[id].x-size;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 turn(id,3);
 end
 s[id].action=2;
 for i=0,3 do
 s[id].frame=i;
 if i==0 then
 PlayWavE(33);
 for t=8,240,8 do
 s[id].effect=t;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 s[id].effect=0;
 end
 if i==3 then
 if s[id].x>s[3-id].x then
 s[3-id].d=3;
 else
 s[3-id].d=2;
 end
 if flag and math.random(100)<gd+10 then
 s[3-id].txt=str[5][math.random(15)];
 m=size/4;
 s[3-id].action=3;
 PlayWavE(31);
 s[3-id].effect=192;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 dechp(3-id,2+atk[id]/2,true);
 else
 s[3-id].txt=str[4][math.random(15)];
 s[3-id].action=4;
 PlayWavE(36);
 dechp(3-id,15+atk[id]*1.5);
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n);
 end
 if s[3-id].x>s[id].x then
 if s[id].x<size then
 m=size;
 end
 s[3-id].x=s[3-id].x+m;
 else
 if s[id].x>672-size then
 m=size;
 end
 s[3-id].x=s[3-id].x-m;
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n);
 s[3-id].effect=0;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n*3);
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 s[1].effect=0;
 s[2].effect=0;
 end
 local function atk_s6(id,gd)--暴击极 gd表示格挡几率
 local n=3;
 local m=36;
 s[id].action=2;
 local flag=false;
 s[id].txt=str[3][math.random(15)];
 PlayWavE(6);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(4);
 for i=0,3 do
 s[id].frame=i;
 if i==0 then
 PlayWavE(33);
 for t=8,240,8 do
 s[id].effect=t;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 end
 if i==3 then
 if math.random(100)<gd then
 flag=true;
 m=24;
 s[3-id].action=3;
 PlayWavE(31);
 dechp(3-id,atk[id]-2,true);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 else
 s[3-id].action=4;
 PlayWavE(36);
 dechp(3-id,5+atk[id]*1.5);
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(2);
 end
 if s[3-id].x>s[id].x then
 if s[id].x<672-size*2 then
 s[3-id].x=s[3-id].x+m;
 end
 else
 if s[id].x>size*2 then
 s[3-id].x=s[3-id].x-m;
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n);
 s[3-id].effect=0;
 s[id].action=2;
 for i=0,3 do
 s[id].frame=i;
 if i==3 then
 if s[3-id].x>s[id].x then
 s[id].x=s[3-id].x-size;
 else
 s[id].x=s[3-id].x+size;
 end
 PlayWavE(s[id].movewav);
 if flag and math.random(100)<gd-10 then
 s[3-id].txt=str[5][math.random(15)];
 s[3-id].action=3;
 if s[id].x>s[3-id].x then
 s[3-id].d=3;
 else
 s[3-id].d=2;
 end
 PlayWavE(31);
 s[3-id].effect=192;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 dechp(3-id,atk[id],true);
 else
 s[3-id].txt=str[4][math.random(15)];
 s[3-id].action=4;
 PlayWavE(36);
 dechp(3-id,20+atk[id]*2);
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(2);
 end
 s[3-id].effect=0;
 if s[id].x<s[3-id].x then
 if s[3-id].x>672-size*2 then
 s[3-id].x=s[3-id].x+size/2;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 s[3-id].x=s[3-id].x+size/4;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 else
 s[id].x=s[3-id].x;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 s[id].x=s[id].x+size/2;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 s[id].x=s[id].x+size/2;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 else
 if s[3-id].x<size*2 then
 s[3-id].x=s[3-id].x-size/2;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 s[3-id].x=s[3-id].x-size/4;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 else
 s[id].x=s[3-id].x;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 s[id].x=s[id].x-size/2;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 s[id].x=s[id].x-size/2;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n);
 s[3-id].effect=0;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n*3);
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 s[1].effect=0;
 s[2].effect=0;
 end
 local function atk_s7(id,gd)--连击极 gd表示格挡几率
 local n=3;
 local m=24;
 local lianji=6;
 local flag=true;
 
 if s[id].x<s[3-id].x then
 if s[id].x<size*2 then
 lianji=7;
 end
 else
 if s[id].x>672-size*2 then
 lianji=7;
 end
 end
 
 s[id].action=2;
 s[id].txt=str[3][math.random(15)];
 PlayWavE(6);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(4);
 PlayWavE(39);
 for t=8,192,8 do
 s[id].effect=t;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 for count=1,lianji do--7 do
 for i=0,3 do
 s[id].frame=i;
 if i==3 then
 if s[id].x>s[3-id].x then
 s[3-id].d=3;
 else
 s[3-id].d=2;
 end
 if flag and math.random(100)<gd+count*7 then
 s[3-id].action=3;
 PlayWavE(30);
 dechp(3-id,2,true);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 else
 flag=false;
 s[3-id].action=4;
 PlayWavE(35);
 dechp(3-id,3+atk[id]/2);
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(1);
 end
 if s[id].x<s[3-id].x then
 s[id].x=s[3-id].x;
 JY.ReFreshTime=lib.GetTime();
 show();
 PlayWavE(s[id].movewav);
 ReFresh();
 s[id].x=s[id].x+size;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 s[id].d=2;
 else
 s[id].x=s[3-id].x;
 JY.ReFreshTime=lib.GetTime();
 show();
 PlayWavE(s[id].movewav);
 ReFresh();
 s[id].x=s[id].x-size;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 s[id].d=3;
 end
 end
 if flag then
 s[3-id].txt=str[5][math.random(15)];
 else
 s[3-id].txt=str[4][math.random(15)];
 end
 s[3-id].effect=0;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n*3);
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 s[1].effect=0;
 s[2].effect=0;
 end 
 local function atk_s8(id,gd)--秘技 gd表示格挡几率
 local n=3;
 local flag=true;
 s[id].txt=str[3][math.random(15)];
 PlayWavE(6);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(4);
 PlayWavE(39);
 for t=8,128,8 do
 s[id].effect=t;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 s[id].action=2;
 for t=1,7 do
 for i=0,3 do
 s[id].frame=i;
 if i==3 then
 if math.random(100)<gd then
 s[3-id].action=3;
 PlayWavE(30);
 dechp(3-id,2,true);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 else
 flag=false;
 s[3-id].action=4;
 PlayWavE(35);
 dechp(3-id,4);
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(1);
 end
 end
 
 for i=0,3 do
 s[id].frame=i;
 if i==0 then
 PlayWavE(33);
 for t=128,248,8 do
 s[id].effect=t;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 end
 if i==3 then
 if flag and math.random(100)<gd then
 s[3-id].txt=str[5][math.random(15)];
 flag=true;
 s[3-id].action=3;
 PlayWavE(31);
 dechp(3-id,atk[id],true);
 s[3-id].effect=208;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 else
 s[3-id].txt=str[4][math.random(15)];
 s[3-id].action=4;
 PlayWavE(36);
 dechp(3-id,40+atk[id]);
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n);
 end
 if s[3-id].x>s[id].x then
 if flag or s[3-id].x>672-size*2 then
 s[3-id].x=s[3-id].x+size/2;
 else
 s[id].x=s[3-id].x;
 JY.ReFreshTime=lib.GetTime();
 show();
 PlayWavE(s[id].movewav);
 ReFresh();
 s[id].x=s[id].x+size/2;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 s[id].x=s[id].x+size/2;
 end
 else
 if flag or s[3-id].x<size*2 then
 s[3-id].x=s[3-id].x+-size/2;
 else
 s[id].x=s[3-id].x;
 JY.ReFreshTime=lib.GetTime();
 show();
 PlayWavE(s[id].movewav);
 ReFresh();
 s[id].x=s[id].x-size/2;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 s[id].x=s[id].x-size/2;
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n);
 s[3-id].effect=0;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(n*3);
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 s[1].effect=0;
 s[2].effect=0;
 end 
 local function win(id)
 --loser
 local eid=3-id;
 s[eid].txt=str[6][math.random(15)];
 PlayWavE(38);
 s[eid].action=5;
 for i=1,4 do
 if s[eid].action==9 then
 s[eid].action=5;
 else
 s[eid].action=9;
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(3);
 end
 for i=16,128,16 do
 s[eid].effect=i
 if s[eid].action==9 then
 s[eid].action=5;
 else
 s[eid].action=9;
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(4);
 end
 PlayWavE(22);
 s[eid].losser=true;
 s[eid].action=5;
 for i=128,256,16 do
 s[eid].effect=i
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(2);
 end
 JY.ReFreshTime=lib.GetTime();
 ReFresh(4);
 s[eid].action=9;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(20);
 --winer
 s[id].action=0;
 s[id].d=0;
 s[id].txt=str[7][math.random(10)];
 PlayWavE(6);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(25);
 s[id].action=6;
 JY.ReFreshTime=lib.GetTime();
 show();
 PlayWavE(8);
 ReFresh(12);
 PlayWavE(5);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(25);
 if hp[id]==hpmax[id] then
 DrawString(288,210,JY.Person[ID[id]]["姓名"].." 完胜",C_WHITE,48)
 else
 DrawString(288,210,JY.Person[ID[id]]["姓名"].." 胜",C_WHITE,48)
 end
 for t=1,10 do
 JY.ReFreshTime=lib.GetTime();
 ReFresh();
 lib.GetKey();
 end
 end
 local function card_ini(idx)
 card[idx]={};
 for i=1,card_num[idx] do
 card[idx][i]=math.random(9);
 end
 end
 local function card_sort(idx)
 for i=1,card_num[idx]-1 do
 for j=i+1,card_num[idx] do
 if card[idx][i]>card[idx][j] then
 card[idx][i],card[idx][j]=card[idx][j],card[idx][i];
 end
 end
 end
 end
 local function card_value(id,n1,n2,n3)
 local pid=ID[id];
 local wl=JY.Person[pid]["武力"];
 local offset=0--math.max(math.modf(wl/2)-41,0);
 offset=math.max(wl/2-41,0);
 local v=0;
 local k=0; --0普通攻击 1小暴击 2三连击 3大暴击 4五连击
 --关羽:鬼胡斩,金刚罗煞斩 ==>关平,关索,关兴也会 
 --张飞:烈袭旋风击牙,蛟天舞 ==>张苞也会 
 --赵云:暴龙,飞鹰 ==>赵统,赵广也会 
 --马超:马家之奥义 
 --甘宁:大海之蛟龙
 --specil 444
 --mp[id]=100--无限mp
 if wl>=100 and mp[id]>=99 and n1==4 and n2==4 and n3==4 then
 return 65,9;
 end
 --奥义1 七连击，接暴击穿人 1 111
 if JY.Person[pid]["秘技1"]>0 and mp[id]>=60 and n1==1 and n2==1 and n3==1 then
 return 60+offset,8;
 end
 --连击·极 左右来回连击 1 378
 if (JY.Person[pid]["连击"]==4 or JY.Person[pid]["连击"]==5 or JY.Person[pid]["连击"]==6 or JY.Person[pid]["连击"]==7) and mp[id]>=55 and n1==3 and n2==7 and n3==8 then
 return 55+offset,7;
 end
 --暴击·极 先回退，然后暴击穿人 1 159
 if (JY.Person[pid]["暴击"]==4 or JY.Person[pid]["暴击"]==5 or JY.Person[pid]["暴击"]==6 or JY.Person[pid]["暴击"]==7) and mp[id]>=55 and n1==1 and n2==5 and n3==9 then
 return 55+offset,6;
 end
 --回马枪 普通穿人，接暴击 3 557/567/577
 if JY.Person[pid]["回马"]>0 and mp[id]>=50 and n1==5 and n3==7 then
 return 50+offset,5;
 end
 --个人强化 258
 if mp[id]>=40 and n1==2 and n2==5 and (n3==8 or n3==9) then
 if pid==54 then --赵云
 return 45+offset,7; --连击极
 elseif pid==190 then --马超
 return 45+offset,5; --回马
 elseif pid==2 then --关羽
 return 45+offset,99; --一击
 elseif pid==3 then --张飞
 return 45+offset,6; --暴击极
 elseif pid==5 then --吕布
 return 45+offset,8; --奥义1
 end
 end
 --五连击 3 334/345/356
 if (JY.Person[pid]["连击"]==2 or JY.Person[pid]["连击"]==3 or JY.Person[pid]["连击"]==6 or JY.Person[pid]["连击"]==7) and mp[id]>=45 and n1==3 and n3<7 and n2+1==n3 then
 return 40+offset,4;
 end
 --大暴击 暴击穿人 4 266/277/288/299
 if (JY.Person[pid]["暴击"]==2 or JY.Person[pid]["暴击"]==3 or JY.Person[pid]["暴击"]==6 or JY.Person[pid]["暴击"]==7) and mp[id]>=45 and n1==2 and n2>5 and n2==n3 then
 return 40+offset,3;
 end
 --三连 三连击 7-1 123/234/345/456/567/678/789
 if (JY.Person[pid]["连击"]==1 or JY.Person[pid]["连击"]==3 or JY.Person[pid]["连击"]==5 or JY.Person[pid]["连击"]==7) and mp[id]>=40 and n1+1==n2 and n2+1==n3 then
 return 30+offset,2;
 end
 --三条 小暴击 9-1-1 111/222/333/444/555/666/777/888/999
 if (JY.Person[pid]["暴击"]==1 or JY.Person[pid]["暴击"]==3 or JY.Person[pid]["暴击"]==5 or JY.Person[pid]["暴击"]==7) and mp[id]>=40 and n1==n2 and n2==n3 then
 return 30+offset,1;
 end
 --other
 return n1+n2+n3,0;
 end
 local function card_remove(id,t1,t2,t3)
 for i=1,card_num[id] do
 if card[id][i]==t1 then
 table.remove(card[id],i);
 break;
 end
 end
 for i=1,card_num[id]-1 do
 if card[id][i]==t2 then
 table.remove(card[id],i);
 break;
 end
 end
 for i=1,card_num[id]-2 do
 if card[id][i]==t3 then
 table.remove(card[id],i);
 break;
 end
 end
 table.remove(card[id],1);
 for i=card_num[id]-3,card_num[id] do
 card[id][i]=math.random(9);
 end
 end
 local function card_ai(id)
 local t1,t2,t3;
 local vmax=0;
 local kind;
 --local s="card: "
 --card_ini(id);
 card_sort(id);
 --for i=1,card_num[id] do
 -- s=s..card[id][i]..',';
 --end
 --lib.Debug(s);
 
 for i=1,card_num[id]-2 do
 for j=i+1,card_num[id]-1 do
 for k=j+1,card_num[id] do
 local v1,v2=card_value(id,card[id][i],card[id][j],card[id][k]);
 if v1>vmax then
 vmax=v1;
 kind=v2;
 t1,t2,t3=card[id][i],card[id][j],card[id][k];
 end
 end
 end
 end
 card_remove(id,t1,t2,t3);
 return vmax,kind--,t1,t2,t3;
 end
 --
 card_ini(1);
 card_ini(2);
 --card_sort(1);
 --card_sort(2);
 local action_v={};
 local action_k={};
 local function automove() --人物接近，自动向屏幕中心移动
 local cx=348;
 local cur=1;
 if math.abs(s[1].x-cx)<math.abs(s[2].x-cx) then
 cur=2;
 end
 if math.abs(s[cur].x-s[3-cur].x)>size then
 if s[cur].x>s[3-cur].x then
 move(cur,s[3-cur].x+size);
 else
 move(cur,s[3-cur].x-size);
 end
 end
 end
 local function arrive(id)
 s[id].action=0;
 PlayWavE(5);
 for i=256,0,-4 do
 s[id].effect=i;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 end
 end
 show();
 Light();
 PlayWavE(4);
 arrive(1);
 local talkid=math.random(15);
 s[1].txt=string.format(str[1][talkid*2-1],p1["外号"]);
 s[1].d=3;
 PlayWavE(6);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(25);
 arrive(2);
 s[2].txt=string.format(str[1][talkid*2],p2["外号"]);
 s[2].d=2;
 PlayWavE(6);
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(25);
 --atk_ms(1,100)
 local msflag=false;
 for i=1,2 do
 local pid=ID[i];
 local eid=ID[3-i];
 if JY.Person[pid]["一击"]>0 and JY.Person[pid]["武力"]-JY.Person[eid]["武力"]>=5 and math.random(100)<=25 then
 atk_ms(i,JY.Person[eid]["武力"]-65);
 mp[i]=0;
 msflag=true;
 if hp[1]==0 then
 win(2);
 return 2;
 elseif hp[2]==0 then
 win(1);
 return 1;
 end
 break;
 end
 end
 if not msflag then
 for i=1,2 do
 local pid=ID[i];
 local eid=ID[3-i];
 if JY.Person[pid]["暗器"]>0 and math.random(10)<=5 then
 atk_aq(i,JY.Person[eid]["武力"]-30);
 break;
 end
 end
 move2(288,384);
 else
 automove();
 end
 while true do
 local cur=1;
 for i=1,2 do
 --admp(i,s[i].mpadd);
 action_v[i],action_k[i]=card_ai(i);
 end
 automove();
 if math.abs(action_v[1]-action_v[2])<=1 then
 atk_p(1,action_v[1]+action_v[2])
 else
 if action_v[1]>action_v[2] then
 cur=1;
 else
 cur=2;
 end
 automove();
 --[[if math.abs(s[cur].x-s[3-cur].x)>size then
 if s[cur].x>s[3-cur].x then
 move(cur,s[3-cur].x+size);
 else
 move(cur,s[3-cur].x-size);
 end
 end]]--
 local gd=s[3-cur].luck+20*action_v[3-cur]/action_v[cur];
 if action_k[cur]==0 then
 atk_s0(cur,gd);
 elseif action_k[cur]==1 then
 atk_s1(cur,gd);
 elseif action_k[cur]==2 then
 atk_s2(cur,gd);
 elseif action_k[cur]==3 then
 atk_s3(cur,gd);
 elseif action_k[cur]==4 then
 atk_s4(cur,gd);
 elseif action_k[cur]==5 then
 atk_s5(cur,gd);
 elseif action_k[cur]==6 then
 atk_s6(cur,gd);
 elseif action_k[cur]==7 then
 atk_s7(cur,gd);
 elseif action_k[cur]==8 then
 atk_s8(cur,gd);
 elseif action_k[cur]==9 then
 atk_s8(cur,5);
 elseif action_k[cur]==99 then
 atk_ms(cur,JY.Person[ID[3-cur]]["武力"]-60);
 else
 atk_s0(cur,gd);
 end
 if action_k[cur]~=0 then
 admp(cur,-math.modf(action_v[cur]/10)*8); --攻击者消耗mp
 end
 if action_k[3-cur]~=0 then
 --admp(3-cur,-math.modf(action_v[3-cur]/10)*5); --防御者不消耗mp
 end
 end
 if hp[1]==0 then
 win(2);
 return 2;
 elseif hp[2]==0 then
 win(1);
 return 1;
 end
 if s[1].x>s[2].x then
 turn(1,2);
 turn(2,3);
 else
 turn(1,3);
 turn(2,2);
 end
 --急救
 if hp[3-cur]<hpmax[3-cur]/2 and s[3-cur].jj>0 and math.random(100)<=20 then
 s[3-cur].jj=0;
 atk_jj(3-cur);
 end
 --底力
 if hp[3-cur]<hpmax[3-cur]/3 and s[3-cur].dl>0 and math.random(100)<=30 then
 s[3-cur].dl=0;
 atk_dl(3-cur);
 card_num[3-cur]=card_num[3-cur]+1;
 card[3-cur][card_num[3-cur]]=math.random(9);
 admp(3-cur,100);
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 for i=1,2 do
 admp(i,s[i].mpadd);
 --action_v[i],action_k[i]=card_ai(i);
 end
 ReFresh(4);
 end
end

--原war.lua
function war(id1,id2,sid)
 local n=2;
 local ID={id1,id2};
 local p1,p2=JY.Person[id1],JY.Person[id2];
 local bzpic1,bzpic2;
 local s={};
 --enemy,friend
 bzpic1=GetBZPic(id1,false,false)
 bzpic2=GetBZPic(id2,true,false)
 for i=0,100 do
 s[i]={
 d=3, --0123 下上左右
 x=142+32*math.modf(i/9),
 y=300+18*(i%9),
 pic=bzpic1,
 action=0, --0静止 1移动 2攻击 3防御 4被攻击 5喘气 9不存在
 frame=0,
 effect=0,
 movewav=JY.Bingzhong[p1["兵种"]]["音效"],
 txt="",
 leader=false,
 };
 end
 --local size=48;
 --local size2=64;
 local sy=270;
 local pic1=0;
 local pic2=10;
 -- 00 平原 01 森林 02 山地 03 河流 04 桥梁 05 城墙 06 城池 07 草原
 -- 08 村庄 09 悬崖 0A 城门 0B 荒地 0C 栅栏 0D 鹿砦 0E 兵营 0F 粮仓
 -- 10 宝物库 11 房舍 12 火焰 13 浊流
 if sid==0 or sid==7 then
 pic1=4;
 pic2=12;
 elseif sid==2 or sid==11 then
 pic1=0;
 pic2=13;
 elseif sid==1 then
 pic1=3;
 pic2=12;
 elseif sid==4 then
 pic1=1;
 pic2=11;
 elseif sid==6 or sid==8 or sid==13 or sid==14 or sid==15 or sid==16 then
 pic1=2;
 pic2=10;
 end
 local test_n=88;
 local array=WarFormation(1,test_n);
 for i=1,test_n do
 s[i].x=200+array.x[i];
 s[i].y=350+array.y[i];
 s[i].pic=bzpic1;
 s[i].leader=false;
 end
 s[array.leader].leader=true;
 s[array.leader].pic=p1["战斗动作"];
 s[array.leader].y=s[array.leader].y-16;
 local function show()
 local piccacheid=12;
 local size=60;
 local size2=80;
 lib.FillColor(0,0,0,0,0);
 lib.PicLoadCache(1,pic2*2,0,310,1);
 lib.PicLoadCache(1,pic1*2,-68,190,1);
 for i=1,test_n do
 if s[i].leader then
 piccacheid=12
 size=60;
 size2=80;
 else
 piccacheid=1
 size=48;
 size2=64;
 end
 if s[i].action==0 then
 --DrawBox(s[i].x,s[i].y,s[i].x+size,s[i].y+size,C_WHITE);
 lib.PicLoadCache(piccacheid,(s[i].pic+16+s[i].d)*2,s[i].x,s[i].y,1);
 elseif s[i].action==1 then
 --DrawBox(s[i].x,s[i].y,s[i].x+size,s[i].y+size,C_WHITE);
 lib.PicLoadCache(piccacheid,(s[i].pic+s[i].frame+s[i].d*4)*2,s[i].x,s[i].y,1);
 elseif s[i].action==2 then
 --DrawBox(s[i].x+(size-size2)/2,s[i].y+size-size2,s[i].x+(size+size2)/2,s[i].y+size,C_WHITE);
 lib.PicLoadCache(piccacheid,(s[i].pic+30+s[i].frame+s[i].d*4)*2,s[i].x+(size-size2)/2,s[i].y+(size-size2)/2,1);
 elseif s[i].action==3 then
 --DrawBox(s[i].x,s[i].y,s[i].x+size,s[i].y+size,C_WHITE);
 lib.PicLoadCache(piccacheid,(s[i].pic+22+s[i].d)*2,s[i].x,s[i].y,1);
 elseif s[i].action==4 then
 --DrawBox(s[i].x,s[i].y,s[i].x+size,s[i].y+size,C_WHITE);
 lib.PicLoadCache(piccacheid,(s[i].pic+26+s[i].d%2)*2,s[i].x,s[i].y,1);
 elseif s[i].action==5 then
 --DrawBox(s[i].x,s[i].y,s[i].x+size,s[i].y+size,C_WHITE);
 lib.PicLoadCache(piccacheid,(s[i].pic+20+s[i].frame)*2,s[i].x,s[i].y,1);
 elseif s[i].action==6 then
 --DrawBox(s[i].x,s[i].y,s[i].x+size,s[i].y+size,C_WHITE);
 lib.PicLoadCache(piccacheid,(s[i].pic+28)*2,s[i].x,s[i].y,1);
 end
 end
 lib.PicLoadCache(2,230*2,0,0,1);
 end
 local function move(dx)
 local flag=1;
 for id=0,100 do
 s[id].action=1;
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh();
 local step=18;
 if dx<s[0].x then
 step=-step;
 end
 for i=s[0].x,dx,step do
 for id=0,100 do
 s[id].x=s[id].x+step;
 s[id].frame=s[id].frame+1;
 if s[id].frame>=2 then
 s[id].frame=0;
 end
 end
 JY.ReFreshTime=lib.GetTime();
 show();
 if flag==1 then
 PlayWavE(s[0].movewav);
 flag=4;
 else
 flag=flag-1;
 end
 ReFresh(2);
 lib.GetKey();
 end
 s[1].action=0;
 s[2].action=0;
 s[1].frame=0;
 s[2].frame=0;
 JY.ReFreshTime=lib.GetTime();
 show();
 ReFresh(2);
 end
 move(600)
 JY.ReFreshTime=lib.GetTime();
 ReFresh();
 lib.GetKey();
 
 WaitKey();
end
function WarFormation(kind,n)
 local array={};
 array.x={};
 array.y={};
 array.leader=1;
 if kind==1 then
 --圆阵
 --1 8 16 24 32
 local T={1,8,16,24,32,40,48};
 local T2={1,9,25,49,81,121,169};
 local lv=1;
 local len=0;
 if n>49 then
 lv=5;
 len=40;
 elseif n>25 then
 lv=4;
 len=40;
 elseif n>9 then
 lv=3;
 len=48;
 elseif n>1 then
 lv=2;
 len=54;
 end
 T[2]=math.modf(T[2]*n/T2[lv]);
 T[3]=math.modf(T[3]*n/T2[lv]);
 T[4]=math.modf(T[4]*n/T2[lv]);
 T[5]=math.modf(T[5]*n/T2[lv]);
 if lv==2 then
 T[2]=n-T[1];
 elseif lv==3 then
 T[3]=n-T[2]-T[1];
 elseif lv==4 then
 T[4]=n-T[3]-T[2]-T[1];
 elseif lv==5 then
 T[5]=n-T[4]-T[3]-T[2]-T[1];
 end
 local num=1;
 array.x[1]=0;
 array.y[1]=0;
 array.leader=1;
 num=2;
 for i=2,lv do
 for t=1,T[i] do
 array.x[num]=math.modf(len*(i-1)*math.cos(2*math.pi*t/T[i]));
 array.y[num]=math.modf(len*0.6*(i-1)*math.sin(2*math.pi*t/T[i]));
 num=num+1;
 end
 end
 
 elseif kind==2 then
 --方阵
 local lv=1;
 local len=0;
 array.leader=1;
 if n>81 then
 lv=10;
 len=32;
 array.leader=5;
 elseif n>64 then
 lv=9;
 len=36;
 array.leader=5;
 elseif n>49 then
 lv=8;
 len=40;
 array.leader=4;
 elseif n>36 then
 lv=7;
 len=44;
 array.leader=4;
 elseif n>25 then
 lv=6;
 len=48;
 array.leader=3;
 elseif n>16 then
 lv=5;
 len=52;
 array.leader=3;
 elseif n>9 then
 lv=4;
 len=56;
 array.leader=2;
 elseif n>4 then
 lv=3;
 len=60;
 array.leader=2;
 elseif n>1 then
 lv=2;
 len=64;
 end
 for num=1,n do
 local x=math.modf((num-1)/lv);
 local y=(num-1)%lv;
 array.x[num]=math.modf(len*((lv-1)/2-x));
 array.y[num]=math.modf(len*0.6*(y-(lv-1)/2));
 end
 end
 
 
 --锋矢
 
 --雁行
 
 --锥形
 
 --鱼丽
 
 --长蛇
 
 
 
 
 
 
 
 
 
 --theat
 local theat=math.pi/24;
 for i=1,n do
 --if array.y[i]>0 then
 array.x[i]=array.x[i]*(1+array.y[i]/100*math.tan(theat))
 --elseif array.y[i]<0 then
 -- array.x[i]=
 --end
 end
 --Sort
 
 for i=1,n-1 do
 for j=i+1,n do
 if array.y[i]>array.y[j] or (array.y[i]==array.y[j] and array.x[i]>array.x[j]) then
 array.x[i],array.x[j]=array.x[j],array.x[i];
 array.y[i],array.y[j]=array.y[j],array.y[i];
 if i==array.leader then
 array.leader=j;
 elseif j==array.leader then
 array.leader=i;
 end
 end
 end
 end
 return array;
end

--原mouse.lua
MOUSE= {
 x=0,
 y=0,
 hx=0,
 hy=0,
 rx=0,
 ry=0,
 status='IDLE',
 enableclick=true;
 EXIT= function()
 if MOUSE.status=='EXIT' then
 MOUSE.status='IDLE';
 return true;
 end
 return false;
 end,
 IN= function(x1,y1,x2,y2)
 if MOUSE.status=='IDLE' or MOUSE.status=='CLICK' or MOUSE.status=='HOLD' then
 if between(MOUSE.x,x1,x2) and
 between(MOUSE.y,y1,y2) then
 return true;
 end
 end
 return false;
 end,
 HOLD= function(x1,y1,x2,y2)
 if MOUSE.status=='HOLD' then
 if between(MOUSE.x,x1,x2) and
 between(MOUSE.y,y1,y2) and
 between(MOUSE.hx,x1,x2) and
 between(MOUSE.hy,y1,y2) then
 return true;
 end
 end
 return false;
 end,
 CLICK= function(x1,y1,x2,y2)
 if MOUSE.status=='CLICK' then
 --[[if (CC.MouseClickType==1 or (between(MOUSE.rx,x1,x2) and
 between(MOUSE.ry,y1,y2))) and
 (CC.MouseClickType==2 or (between(MOUSE.hx,x1,x2) and
 between(MOUSE.hy,y1,y2))) then
 MOUSE.status='IDLE';
 return true;
 end]]--
 if x1==nil then
 MOUSE.status='IDLE';
 return true;
 end
 if between(MOUSE.rx,x1,x2) and
 between(MOUSE.ry,y1,y2) and
 between(MOUSE.hx,x1,x2) and
 between(MOUSE.hy,y1,y2) then
 MOUSE.status='IDLE';
 return true;
 end
 end
 return false;
 end,
 }

function getkey()
if CONFIG.PC then
 local eventtype,keypress,x,y=lib.GetKey(1);
 if eventtype==0 then
 MOUSE.status='EXIT';
 elseif eventtype==3 then
 if keypress==1 then
 MOUSE.status='HOLD';
 MOUSE.x,MOUSE.y=x,y;
 MOUSE.hx,MOUSE.hy=x,y;
 end
 else
 local mask;
 mask,x,y=lib.GetMouse();
 MOUSE.x,MOUSE.y=x,y;
 if mask==0 then
 if MOUSE.status=='HOLD' then
 if MOUSE.enableclick then
 MOUSE.status='CLICK';
 MOUSE.rx,MOUSE.ry=x,y;
 else
 MOUSE.enableclick=true;
 MOUSE.status='IDLE';
 end
 end
 end
 end
 return eventtype,keypress,x,y;
else
 local eventtype,keypress,x,y=lib.GetMouse(1);
 if eventtype==0 then
 MOUSE.status='EXIT';
 elseif eventtype==2 then
 MOUSE.x,MOUSE.y=x,y;
 elseif eventtype==3 then
 if keypress==1 then
 MOUSE.status='HOLD';
 MOUSE.x,MOUSE.y=x,y;
 MOUSE.hx,MOUSE.hy=x,y;
 elseif keypress==3 then
 MOUSE.status='IDLE';
 end
 elseif eventtype==4 then
 if keypress==1 then
 if MOUSE.status=='HOLD' then
 if MOUSE.enableclick then
 MOUSE.status='CLICK';
 MOUSE.x,MOUSE.y=x,y;
 MOUSE.rx,MOUSE.ry=x,y;
 else
 MOUSE.enableclick=true;
 MOUSE.status='IDLE';
 MOUSE.x,MOUSE.y=x,y;
 end
 end
 else
 MOUSE.status='IDLE';
 MOUSE.x,MOUSE.y=x,y;
 end
 end
 return eventtype,keypress,x,y;
end
end

--原kdef.lua
--[[
SceneID
-1 黑屏
0 大地图
43 许昌曹操官邸
45 徐州陶谦官邸
48 北平议事厅
54 平原议事厅/北海/小沛/下邳/白马/古城
63 曹操军营帐
66 许昌 曹操花园
77 许昌刘备官邸
83 邺城议事厅
84 许昌宫殿
85 洛阳宫殿/许昌议事厅
86 陈留议事厅/徐州
87 信度议事厅
89 洛阳宫殿（献帝）
85 洛阳宫殿（董卓）乱用
92 淮南议事厅
97 广川营帐/刘备
95 陈留营帐/虎牢/袁绍
]]--

Event= {
 --序章开始
 --序章　群雄起兵讨伐董卓
 [1]=function()
 SetSceneID(-1,2);
 JY.Base["章节名"]="序章　群雄起兵讨伐董卓";

DrawMulitStrBox("滚滚长江东逝水，浪花淘尽英雄。*是非成败转头空。青山依旧在，几度夕阳红。*白发渔樵江渚上，惯看秋月春风。*一壶浊酒喜相逢。古今多少事，都付笑谈中。*——调寄《临江仙》")

 DrawStrBoxCenter("序章　群雄起兵讨伐董卓");
 LoadPic(3,1);
 DrawMulitStrBox("　时值东汉末年．*　东汉末年，反叛和暴乱接连不断，汉室衰微已显而易见．*　造成社会动乱的人是董卓．")
 DrawMulitStrBox("　董卓控制朝廷，漠视皇帝，为所欲为，原来反对董卓的人，也因惧怕他手中的兵权而对他阿谀奉承．皇帝的权威已不复存在．")

 LoadPic(3,2);
 --修改任务目标:<在汜水关与董卓的华雄军交战>
 
 NextEvent();
 end,
 [2]=function()
 -- 0 上 1 下 2 左 3 右
 -- 
 JY.Smap={};
 JY.Base["现在地"]="洛阳";
 JY.Base["道具屋"]=0;
 AddPerson(383,27,8,1);
 AddPerson(4,19,12,0);
 AddPerson(372,17,12,0);
 AddPerson(371,19,13,0);
 AddPerson(384,14,9,3);
 AddPerson(7,25,15,2);
 AddPerson(22,12,10,3);
 AddPerson(21,23,16,2);
 AddPerson(47,10,11,3);
 AddPerson(48,21,17,2);
 SetSceneID(89);
 DrawStrBoxCenter("洛阳宫殿");
 talk( 4,"陛下，不要担心，把所有朝政都交给臣．",
 383,"……",
 4,"那么，臣告辞了．");
 MovePerson( 4,1,1);
 MovePerson( 4,7,1,
 372,7,1,
 371,7,1);
 talk(4,"哼！皇帝现在只是个装饰品，我才是一国之主，哈哈！");
 DecPerson(4);
 DecPerson(372);
 DecPerson(371);
 DrawSMap();
 ShowScreen();
 MovePerson( 7,1,0);
 MovePerson( 7,2,2);
 MovePerson( 7,0,0);
 talk(7,"陛下，为了您着想，请不要顶撞董卓．");
 MovePerson( 7,9,1);
 DecPerson(7);
 DrawSMap();
 ShowScreen();
 MovePerson( 21,7,1,
 22,7,1,
 47,7,1,
 48,7,1);
 DecPerson(21);
 DecPerson(22);
 DecPerson(47);
 DecPerson(48);
 DrawSMap();
 ShowScreen();
 talk(383,"……嗯，朕绝不饶恕董卓．可是他大军在握，朕无力抗拒他，难道国家就没人能讨伐董卓，重振汉室声威？");
 MovePerson( 384,4,0);
 MovePerson( 384,1,3);
 talk(384,"陛下，臣体谅陛下的心情，只是臣等力量不够．");
 NextEvent();
 end,
 [3]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="陈留";
 JY.Base["道具屋"]=0;
 AddPerson(9,25,9,1);
 SetSceneID(95,12);
 DrawStrBoxCenter("陈留营帐");
 DrawMulitStrBox("　宣誓忠于汉室的诸侯们对董卓的为所欲为深为不满．*　因年轻有为而知名的曹操也不例外．");
 DrawMulitStrBox("　曹操策划谋杀董卓，但失败了．他又向各地传发讨伐董卓的檄文，得到了热烈的响应，不久，诸侯率兵从各地向陈留集结．");
 AddPerson(10,4,20,0);
 AddPerson(12,6,21,0);
 MovePerson( 10,8,0,
 12,8,0);
 talk( 9,"袁绍，袁术，谢谢二位将军响应檄文．",
 10,"我早看不惯董卓的专横，这次一定要讨伐反贼董卓，重振汉室声威．",
 12,"对，既然我们袁氏一家来了，就不会让董卓好受，岂能容忍那老家伙的专横，让他看看我们的厉害．"
 );
 MovePerson( 10,2,2,
 12,2,2);
 MovePerson( 10,0,3,
 12,2,1);
 MovePerson( 12,1,2);
 MovePerson( 12,0,3);
 
 AddPerson(16,4,20,0);
 AddPerson(8,6,21,0);
 MovePerson( 16,8,0,
 8,8,0);
 talk( 9,"噢，陶谦，孔融，欢迎你们．",
 16,"身为汉臣，岂能容忍董卓，我从徐州急速赶来，请让我加入联军．",
 8,"我从北海率军赶来，也加入联军．"
 );
 MovePerson( 16,2,3,
 8,2,3);
 MovePerson( 16,2,1,
 8,0,2);
 MovePerson( 16,1,3);
 MovePerson( 16,0,2);
 AddPerson(13,4,20,0);
 MovePerson( 13,8,0);
 talk( 9,"公孙瓒也来了，远道而来，辛苦了．",
 13,"哪里哪里，我要给你介绍一个人．",
 9,"噢，是谁呀？",
 13,"是刘备，请进来．"
 );
 AddPerson(1,6,21,0);
 MovePerson( 1,8,0);
 talk( 1,"我是刘备，字玄德，听说要讨伐董卓，便和公孙瓒一起赶到这里．");
 DrawMulitStrBox("　现在出现的这个人物，是这个故事的主角，姓刘名备字玄德，他编卖过草蓆，是个在穷苦环境中长大的年轻人，可是，自从母亲告诉他祖先是皇帝后，刘备的人生发生了变化．");
 DrawMulitStrBox("　发生黄巾之乱时，刘备欲拯救乱世，率义勇军讨伐黄巾贼．*　刘备有两个兄弟，一个是关羽字云长，一个是张飞字翼德，两人都是出类拔萃的豪杰．");
 DrawMulitStrBox("　刘备，关羽，张飞，此三人虽是偶然相遇，但相互被对方的志向所感动，结拜为兄弟，虽然彼此不是亲兄弟．但关羽，张飞都称刘备为大哥．");
 talk( 9,"噢，是刘备吗？我们以前见过．",
 1,"那是讨黄巾贼时．",
 9,"那时我被你的勇敢作战所震惊，有你在，就更有把握了，拜托了．",
 1,"请多关照．",
 12,"（刘备？我没听说过此人．）"
 );
 DrawMulitStrBox("　从汇集的诸侯中，袁绍被推为盟主，组成了讨伐董卓的联军．");
 NextEvent(); 
 end,
 [4]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="洛阳";
 JY.Base["道具屋"]=0;
 AddPerson(4,26,8,1);
 AddPerson(5,23,7,1);
 AddPerson(6,19,12,0);
 AddPerson(7,14,9,3);
 AddPerson(47,10,11,3);
 AddPerson(48,4,14,3);
 AddPerson(21,25,15,2);
 AddPerson(22,21,17,2);
 AddPerson(28,15,20,2);
 SetSceneID(85,11);
 DrawStrBoxCenter("洛阳宫殿");
 DrawMulitStrBox("　董卓对曹操等的行动马上采取了对策，命令部下华雄和义子吕布准备迎战．");
 talk( 4,"华雄，把守汜水关的任务交给你了．",
 6,"是．");
 MovePerson( 6,9,1);
 DecPerson(6);
 MovePerson( 5,0,3);
 talk( 5,"父亲，为何只命令华雄出征，难道忘了吕布？");
 MovePerson( 4,0,2);
 talk( 4,"哪里？吕布，我最信任的人就是你，你去守虎牢关．",
 5,"是，谢谢父亲，我去了");
 MovePerson( 4,0,1);
 MovePerson( 5,2,1);
 MovePerson( 5,1,3);
 MovePerson( 5,10,1);
 DecPerson(5);
 NextEvent();
 end,
 [5]=function()
 JY.Smap={};
 SetSceneID(0);
 talk( 6,"哼！谁说我就比不过吕布？最厉害的是我！",
 5,"他们能打败华雄来到这里吗？打不过来吧．哈哈哈！！");
 NextEvent();
 end,
 [6]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="陈留";
 JY.Base["道具屋"]=1;
 AddPerson(10,25,9,1);
 AddPerson(9,20,9,1);
 AddPerson(12,11,10,3);
 AddPerson(13,7,12,3);
 AddPerson(16,24,17,2);
 AddPerson(8,20,19,2);
 AddPerson(3,1,14,3);
 AddPerson(2,3,13,3);
 AddPerson(1,3,14,3);
 SetSceneID(95);
 DrawStrBoxCenter("陈留营帐");
 DrawMulitStrBox("　讨伐董卓的联军先锋被华雄率领的董卓军打败了．*　讨伐董卓的联军陷入了困境．");
 AddPerson(369,4,21,0);
 MovePerson( 369,8,0);
 talk( 369,"禀告主帅，华雄率领的董卓军攻过来了．",
 10,"知道了，我马上派援军．退下．",
 369,"是．"
 );
 MovePerson( 369,10,1);
 DecPerson(369);
 talk( 10,"话是这么说，可是派谁去好呢？",
 9,"诸侯中有谁敢去迎战华雄？",
 8,"惭愧，我军力量难以迎战华雄．",
 12,"本来我可引兵前往，怎奈现在身体欠佳．",
 9,"难道没有人了？"
 );
 NextEvent();
 end,
 [7]=function()
 MovePerson( 1,4,3,
 2,4,3,
 3,5,3
 );
 MovePerson( 1,1,0,
 2,0,0,
 3,1,0
 );
 MovePerson( 1,2,0,
 2,1,0,
 3,1,0
 );
 talk( 1,"我们兄弟愿往．",
 10,"刘备，你身后的人是谁？",
 13,"他们是刘备的结义兄弟，关羽和张飞．",
 12,"哦？刘备的官职是…刘备这个名字，我没听说过．当大将的话，还是要有适当身份才行．",
 13,"现在还只是平原县令．",
 12,"什么？只是个小官吏，怎能当此大任？退下．",
 9,"袁术，稍等，虽是小吏，但敢如此说，或许有一定把握．",
 12,"哼，随你便．",
 9,"好，就让你们去，快去准备，你们可以充份调用军需．喂，叫道具屋老板来．",
 13,"刘备，他是道具屋老板，可提供军需．",
 13,"还有，出征前最好和别人打声招呼，也可能得到点消息．"
 );
 GetMoney(500);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [8]=function()
 if JY.Tid==10 then--袁绍
 talk( 10,"华雄乃勇猛之人，要小心．");
 end
 if JY.Tid==9 then--曹操
 talk( 9,"希望你们勇猛作战．");
 end
 if JY.Tid==12 then--袁术
 talk( 12,"哼，小兵如何拼命也注定要失败，想不去还来得及．");
 end
 if JY.Tid==8 then--孔融
 talk( 8,"你们是步兵，华雄是骑兵，彼此的兵种不同，所以交战时要注意这个区别，否则你们要吃亏．");
 end
 if JY.Tid==13 then--公孙瓒
 talk( 13,"我也参加这次作战，也许能帮上忙．");
 SetFlag(0,1);
 end
 if JY.Tid==16 then--陶谦
 talk( 16,"我的部队也参加，一起讨伐敌军．");
 SetFlag(1,1);
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，快出征吧，准备好的话，跟关羽说一声．");
 end
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"准备好了吗？") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 PlayBGM(12);
 talk( 2,"出征！");
 NextEvent();
 JY.Tid=-1;
 end
 end 
 end,
 [9]=function()
 JY.Smap={};
 SetSceneID(0,3);
 talk( 2,"敌人在汜水关，火速进军．");
 NextEvent(); 
 end,
 [10]=function() --test进入战斗
 WarIni();
 DefineWarMap(0,"序章 汜水关之战","一、歼灭华雄．",30,0,5);
 -- id,x,y, d,ai
 SelectTerm(1,{
 0,22,9, 3,0,-1,0,
 1,20,10, 3,0,-1,0,
 2,20,9, 3,0,-1,0,
 12,16,7, 3,0,0,0,
 15,16,6, 3,0,1,0,
 });
 SelectEnemy({
 5,3,9, 4,2,5,7, 0,0,-1,0,
 20,5,10, 4,0,2,4, 0,0,-1,0,
 21,4,9, 4,0,2,1, 0,0,-1,0,
 27,6,9, 4,0,2,1, 0,0,-1,0,
 256,11,8, 4,0,1,1, 0,0,-1,0,
 257,11,10, 4,0,1,1, 0,0,-1,0,
 258,11,12, 4,0,1,1, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [11]=function() --test战斗事件
 PlayBGM(11);
 talk( 6,"吃一次亏也不长一智，联军还来自找麻烦，是谁的部队？",
 21,"主将好像是个叫刘备的人．",
 6,"刘备？这个名字没听说过，为何叫这种无名鼠辈来．看不起我吗？",
 21,"大概是联军没人了．",
 6,"管他是谁，杀了他祭旗，众将士，出征迎敌．",
 3,"大哥，我先活动一下身体吧．",
 2,"大哥，这个交给我吧，我一定取华雄首级来见你．");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [12]=function(kind)
 if (not GetFlag(177)) and WarCheckLocation(-1,7,6) then
 GetMoney(100);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金１００！");
 SetFlag(177,1);
 end
 WarLocationItem(6,12,31,178); --获得道具:获得道具：豆
 --WarLocationItem(8,11,74,500); --获得道具:直刀
 if WarMeet(2,6) then
 WarAction(1,2,6);
 talk( 2,"对面的可是华雄，我要与你单挑！",
 6,"向我挑战？好大的胆，通名受死．",
 2,"我乃关羽关云长，华雄，我关羽决不容你们这些董卓军胡作非为．",
 6,"哼，还逞威风，不过一看就是无名小卒．还能胜我吗？",
 2,"敢把我看成无名小卒，送你上西天．");
 if fight(2,6)==1 then
 talk( 2,"接我一刀！",
 6,"好厉害！",
 2,"华雄！要你的命！");
 WarAction(8,2,6);
 WarAction(18,6);
 talk( 2,"先割下华雄首级．");
 WarLvUp(GetWarID(2));
 talk( 3,"大哥，关羽好像斩了华雄．",
 1,"嗯，我军胜利了．");
 PlayBGM(7);
 DrawMulitStrBox("　刘备军打败华雄军，占领汜水关．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 else
 talk( 6,"接我一刀！",
 2,"好厉害！",
 6,"关羽！要你的命！");
 WarAction(4,6,2);
 WarAction(18,2);
 talk( 6,"先割下关羽首级．");
 WarLvUp(GetWarID(6));
 DrawMulitStrBox("　刘备军败给了华雄军．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(999);
 end
 end
 if JY.Status==GAME_WARWIN then
 talk( 1,"我军胜利了．");
 PlayBGM(7);
 DrawMulitStrBox("　刘备军打败华雄军，占领汜水关．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [13]=function()
 SetSceneID(0,3);
 talk( 2,"敌人好像逃到了前面的虎牢关．大哥，该怎么办？",
 1,"暂且收兵吧．",
 3,"说什么呀？现在当然是乘胜追击了，我去！",
 2,"喂！张飞！不要轻举妄动！",
 3,"追击！继续追击！"
 );
 talk( 2,"唉！追上去了，还是那么鲁莽．");
 if GetFlag(0) then
 talk( 13,"话不要这么说，我军士气也鼓舞起来了嘛．");
 end
 if GetFlag(1) then
 talk( 16,"现在应该乘势攻下虎牢关．");
 end
 talk( 1,"没办法，好！跟上张飞！进军虎牢关！");
 NextEvent();
 end,
 [14]=function()
 --61 储存进度:战场存盘
 --46 切换场景:切换场景到<4>
 NextEvent();
 end,
 [15]=function()
 WarIni();
 DefineWarMap(1,"序章 虎牢关之战","一、吕布败退．",30,0,4);
 -- id,x,y, d,ai
 SelectTerm(1,{
 0,15,21, 2,0,-1,0,
 1,13,21, 2,0,-1,0,
 2,12,20, 2,0,-1,0,
 12,14,18, 2,0,0,0,
 15,13,18, 2,0,1,0,
 });
 SelectEnemy({
 4,6,5, 1,2,6,7, 0,0,-1,0,
 79,3,7, 1,0,3,23, 0,0,-1,0,
 80,6,8, 1,0,3,7, 0,0,-1,0,
 74,10,8, 1,0,3,4, 0,0,-1,0,
 73,10,11, 1,1,2,1, 0,0,-1,0,
 274,8,8, 1,0,1,4, 0,0,-1,0,
 275,5,11, 1,1,1,4, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [16]=function()
 PlayBGM(11);
 talk( 5,"什么？联军攻来了，还杀了华雄？好厉害，不过，他们的好运也就到此为止了．",
 81,"吕布将军，现在让他们知道一下我军的厉害．",
 5,"好，全军出击！联军，好好看看我的厉害．",
 3,"主将何在？不能只让关羽逞雄风，我也要出风头．",
 2,"这里好像是吕布把守．",
 1,"是吕布，恐怕没有比他更可怕的敌人了．",
 2,"吕布座下赤兔马，据说日行千里．",
 3,"吕布算什么？让他看看我的厉害．");
 WarShowTarget(true);
 PlayBGM(16);
 NextEvent();
 end,
 [17]=function()
 if WarMeet(3,5) then
 WarAction(1,3,5);
 talk( 3,"对面可是吕布，来与我一决胜负！",
 5,"还有人敢向我挑战！报上名来！",
 3,"我乃刘备义弟，张飞张翼德是也！吕布！我要取你项上人头！",
 5,"哈哈！无名小卒，好大胆，我吕布来战一战你．来吧！",
 3,"别小看我，你会后悔的．");
 if fight(3,5)==1 then
 talk( 5,"还真有两下子．",
 3,"不愧勇夫，不过，躲得过我这一枪吗？");
 WarAction(9,3,5);
 talk( 5,"休得猖狂！",
 1,"张飞，我们来帮你．",
 2,"吕布，你的克星来了．",
 5,"帮手来了，没办法，撤退．赤兔，全靠你了．");
 WarMoveTo(5,6,0);
 talk( 3,"别跑！吕布！站住！",
 2,"不愧是赤兔马，我们根本追不上．");
 talk( 5,"全军撤退．");
 WarAction(16,5);
 WarLvUp(GetWarID(3));
 NextEvent();
 else
 talk( 5,"还真有两下子，不过，躲得过我这一戟吗？");
 WarAction(8,5,3);
 --WarAction(17,3);
 --WarLvUp(GetWarID(5));
 --talk( 1,"三弟！",
 -- 2,"可恶！",
 -- 5,"哈哈哈！一起上吧！");
 talk( 5,"休得猖狂！",
 1,"张飞，我们来帮你．",
 2,"吕布，你的克星来了．",
 5,"帮手来了，没办法，撤退．赤兔，全靠你了．");
 WarMoveTo(5,6,0);
 talk( 3,"别跑！吕布！站住！",
 2,"不愧是赤兔马，我们根本追不上．");
 talk( 5,"全军撤退．");
 WarAction(16,5);
 --WarLvUp(GetWarID(3));
 NextEvent();
 end
 
 end
 if (not GetFlag(1001)) and War.Turn==18 then
 talk( 5,"哼！七拼八凑的部队还挺厉害，不过我可不会败给这些鼠辈，要让他们知道我的厉害．");
 WarModifyAI(4,1);
 SetFlag(1001,1);
 end
 if JY.Status==GAME_WARWIN then
 talk( 5,"可恶！没办法，全军撤退．",
 1,"太好了！我们打败了吕布．");
 NextEvent();
 end
 WarLocationItem(10,13,41,59); --获得道具:获得道具：焦热书
 WarLocationItem(11,14,31,179); --获得道具:获得道具：豆
 --WarLocationItem(17,12,147,501); --获得道具:手牌
 end,
 [18]=function()
 PlayBGM(7);
 DrawMulitStrBox("　吕布军败退，刘备军占领了虎牢关．");
 GetMoney(100);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金１００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [19]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="洛阳";
 JY.Base["道具屋"]=0;
 AddPerson(383,27,8,1);
 AddPerson(4,19,12,0);
 AddPerson(7,17,13,0);
 AddPerson(21,25,15,2);
 AddPerson(22,23,16,2);
 AddPerson(28,21,17,2);
 AddPerson(384,14,9,3);
 AddPerson(47,12,10,3);
 AddPerson(48,10,11,3);
 
 SetSceneID(89,11);
 DrawStrBoxCenter("洛阳宫殿");
 DrawMulitStrBox("　对董卓来说，汜水关和虎牢关的陷落事关重大．*　董卓决定挟持献帝逃离洛阳．");
 talk( 4,"要杀陛下的人已逼近洛阳，事已至此，离开洛阳吧．",
 383,"什么？洛阳是以前就作为帝都才得以繁荣的．你是说要舍弃它？",
 4,"你好像没听懂我刚才说的话吧，我还要重复一遍吗？",
 383,"这，朕知道了，就照你说的办吧！",
 4,"谢谢皇帝采纳臣的建议，那么就请快些走吧！");
 MovePerson( 4,2,1);
 MovePerson( 4,7,1,
 7,7,1);
 talk( 4,"对啦，李儒，不能轻易把洛阳留给贼军，火烧洛阳，没收城里全部金银财宝．",
 7,"是！");
 DecPerson(4);
 DecPerson(7);
 MovePerson( 21,9,1,
 22,9,1,
 28,9,1,
 47,9,1,
 48,9,1);
 DecPerson(21);
 DecPerson(22);
 DecPerson(28);
 DecPerson(47);
 DecPerson(48);
 PlayBGM(2);
 talk( 383,"先帝呀！宽恕我的无能吧！我没能守住先祖传下来的这块土地，难道汉室基业要毁在我手里？",
 384,"陛下…");
 LoadPic(28,1);
 DrawMulitStrBox("　就这样，董卓把汉都从洛阳迁到长安，汉王朝就要因董卓的专横而告终了．");
 LoadPic(28,2);
 NextEvent();
 end,
 [20]=function()
 JY.Smap={};
 JY.Base["现在地"]="虎牢关";
 JY.Base["道具屋"]=0;
 AddPerson(10,25,9,1);
 AddPerson(9,20,9,1);
 AddPerson(12,11,10,3);
 AddPerson(13,7,12,3);
 AddPerson(16,24,17,2);
 AddPerson(8,20,19,2);
 AddPerson(3,1,14,3);
 AddPerson(2,3,13,3);
 AddPerson(1,3,14,3);
 SetSceneID(95);
 DrawStrBoxCenter("虎牢关营帐");
 DrawMulitStrBox("　攻克了汜水关和虎牢关，曹操等讨伐董卓的联军正陶醉在胜利中，这时得到了董卓挟持献帝逃走的消息．");
 talk( 9,"据说董卓逃往洛阳西面的长安，现在就应追击．",
 10,"不，接连作战，士兵太累了，现在应该在这里休息．",
 9,"可是要抓住战机，错失此良机，我们就没有胜利机会．");
 talk( 12,"既然想要追击，随你去好了．",
 13,"士兵也的确太累了．",
 9,"我等为讨伐国贼才起兵的，可是，现在连追击董卓都不肯，要让天下百姓失望的．",
 9,"这里已没有与我同心之人，我要回领地去，告辞了．");
 MovePerson( 9,11,1);
 DecPerson(9);
 NextEvent();
 end,
 [21]=function()
 talk( 12,"说什么与你同心，他又不是名门望族，太嚣张了．",
 10,"可是没有曹操这个中心人物，这个联军就没有意义了．");
 talk( 8,"刘备，有机会我们还会再见的．");
 MovePerson( 8,9,1);
 DecPerson(8);
 talk( 16,"刘备将来会成就大事的，哈哈哈！我这老头开玩笑，请别介意．那我告辞了．");
 MovePerson( 16,9,1);
 DecPerson(16);
 talk( 13,"那么我们也撤吧．",
 2,"是啊．");
 NextEvent();
 end,
 [22]=function()
 JY.Smap={};
 SetSceneID(0);
 talk( 13,"那么，刘备，再见了，如果有什么事情，随时可以跟我讲．",
 1,"那我也告辞了．",
 13,"是啊．"
 );
 DrawMulitStrBox("　就这样，讨伐董卓的联军解散了．庞大的汉王朝由于董卓的出现，开始走向灭亡．*　在这个乱世上，图谋天下的还不止董卓一个，有曹操，还有袁绍……");
 DrawMulitStrBox("　处在这个乱世上，刘备等人该如何面对呢？还有，刘备兄弟们重振汉室的梦想能实现吗？");
 NextEvent();
 end,
 --序章结束
 --第一章　界桥之战
 [23]=function()
 --Dark();
 --PlayBGM(0);
 --DrawSMap();
 --Light();
 SetSceneID(-1,0);
 JY.Base["章节名"]="第一章　界桥之战";
 DrawStrBoxCenter("第一章　界桥之战");
 LoadPic(4,1);
 DrawMulitStrBox("为讨伐董卓而聚集的群雄，随着联军解散，各自回到了自己的领地．联军主帅袁绍，用计夺取了韩馥的冀州，形成了以邺城为据点的一大势力．");
 DrawMulitStrBox("袁绍夺得冀州后，又开始盯上公孙瓒的领地．袁绍在位于与公孙瓒领地交界的界桥集结了大量兵力．");
 LoadPic(4,2);
 --PlayBGM(11);
 SetSceneID(0,11);
 talk( 10,"好，打垮公孙瓒！拿下北平的话，北面的半壁江山就成了我的了．分兵两路进攻北平，张郃经巨鹿进攻，麴义经清河进攻．",
 103,"是！我马上进攻巨鹿！",
 61,"那么我发兵清河．");
 Dark();
 PlayBGM(3);
 DrawSMap();
 Light();
 talk( 13,"袁绍攻过来了！",
 60,"是的．从边境的界桥出发，兵分清河、巨鹿两路攻过来了．",
 13,"唉……．那么严纲，你率军去清河，我进军巨鹿．最终的目标是界桥．杀死袁绍．",
 60,"是！");
 PlayBGM(0);
 DrawMulitStrBox("两军在清河和巨鹿对峙，互相窥视对方的动态，两军隔着边境对峙的状态持续了好几个月．");
 NextEvent();
 end,
 [24]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="平原";
 JY.Base["道具屋"]=2; --用的是北平的商店，实际平原没有商店
 AddPerson(1,25,17,2);
 AddPerson(2,20,9,1);
 AddPerson(3,11,16,0);
 SetSceneID(54,5);
 DrawStrBoxCenter("平原议事厅");
 talk( 2,"兄长，公孙瓒军和袁绍军已经对峙了很长时间了．",
 3,"就要这样一直对峙下去？",
 2,"不会的，现在双方都在展开情报战，不久就会打起来的．",
 3,"哼，我不懂．",
 2,"蠢货！作为大将光靠武力不行．智勇双全的人才是真正的大将，是吧．兄长．",
 1,"当然是．",
 3,"哎，那么大哥也总是搞那种什么情报战？",
 1,"当然．现在我就想去巡视城内，从居民那里打探些情报．",
 2,"不愧是兄长．好事要快办．我和张飞看家，有事的话会去叫你．"
 );
 --48 显示任务目标:<搜集情报>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [25]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"有什么事的话会去叫你．");
 end
 if JY.Tid==2 then--关羽
 talk( 2,"城里有酒馆等居民聚集的地方，想从居民那里得到情报，还是去人多的地方好．");
 --
 talk( 2,"兄长，来了个叫简雍的人，说是来见兄长．");
 AddPerson(83,2,4,0);
 MovePerson( 83,8,3);
 NextEvent();
 JY.Tid=-1;
 end
 end,
 [26]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"请兄长讲话．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"我不太清楚，大哥想个办法吧．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"刘备，我叫简雍．久仰您的大名，此次特地前来投靠，请您收下我．");
 ModifyForce(83,1);
 PlayWavE(11);
 DrawStrBoxCenter("简雍成为刘备部下！");
 AddPerson(365,-1,4,0);
 MovePerson( 365,6,3);
 PlayBGM(11);
 talk( 365,"刘备，突然拜访．我是公孙瓒派来的使者，请求您派兵支援．");
 NextEvent();
 JY.Tid=-1;
 end
 end,
 [27]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"请听使者讲话．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"请听使者讲话．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"公孙瓒出了什么事了吗？");
 end
 if JY.Tid==365 then--使者
 talk( 1,"使者啊！听说袁绍军从界桥正不断向东进军……",
 365,"是的．袁绍军已经攻占我们很多领土，现还在向纵深发展．我们主公已从北平出兵了．",
 1,"那么战况如何？",
 365,"主公率领的主力部队在界桥作战，公孙越军和严纲军分别在巨鹿和清河作战，但形势都不太好．刘备，请你支援我们．",
 3,"公孙瓒有危险了，大哥，快去支援吧．",
 1,"唉，使者你回去对公孙瓒说我们马上就去支援．",
 365,"噢，谢谢．",
 83,"主公，去界桥的话，从平原走有两条路，一条经过广川，一条经过信都城．",
 1,"唉，广川和信都城啊，应该走哪条呢？",
 83,"走信都城的话，到界桥有些绕远路，不过有道具屋，补充足一些好．",
 3,"还在说啊，再不快点去支援的话，公孙瓒岂不危险了．大哥快去支援吧．",
 2,"准备好的话叫我一声，我现在去道具屋买些兵器．",
 83,"我觉得公孙瓒的据点北平有卖兵器的，北平在平原的北面．");
 --48 显示任务目标:<去支援公孙瓒>
 NextEvent();
 JY.Tid=-1;
 end;
 end,
 [28]=function()
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"准备好了吗？") then
 RemindSave();
 talk( 2,"那么出发吧．");
 PlayBGM(12);
 NextEvent();
 JY.Status=GAME_SMAP_AUTO;
 end
 end
 if JY.Tid==3 then--张飞
 talk( 3,"快出发吧．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"从这里去界桥，要路过广川或信都城中的一个．");
 end
 if JY.Tid==365 then--使者
 talk( 365,"刘备，请你尽快去支援吧．");
 end;
 end,
 [29]=function()
 JY.Smap={};
 SetSceneID(0);
 talk( 2,"兄长，你要走广川这条路，还是走信都城这条路？");
 NextEvent();
 end,
 [30]=function()
 local menu={
 {" 走信都城",nil,1},
 {"　走广川",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 NextEvent(); --goto 31
 elseif r==2 then
 NextEvent(40); --goto 40
 end
 end,
 [31]=function()
 talk( 2,"走信都城吧，列队！");
 WarIni();
 DefineWarMap(3,"第一章 信都城之战","一、淳于琼败退．*二、刘备到达城门．",30,0,105);
 SelectTerm(1,{
 0,21,7, 3,0,-1,0,
 -1,20,6, 3,0,-1,0,
 -1,20,8, 3,0,-1,0,
 -1,21,5, 3,0,-1,0,
 220,1,0, 1,0,-1,0,
 245,3,0, 3,0,-1,0,
 244,0,0, 4,0,-1,0,
 });
 SetSceneID(0,11);
 talk( 10,"淳于琼，你去信都城，搅乱公孙瓒的背后．",
 106,"是．",
 106,"将士们！我们绕到公孙瓒的背后去攻打信都城！跟上！");
 SetSceneID(0);
 talk( 13,"什么！袁绍军要袭击我们的背后？坏了！如果这样的话，我们就进攻袁绍的大本营！进攻界桥！");
 SetSceneID(0,3);
 talk( 2,"向信都城进军吧！");
 NextEvent();
 end,
 [32]=function()
 SelectEnemy({
 105,1,4, 2,4,8,7, 7,3,-1,0,
 256,8,3, 3,4,4,1, 9,4,-1,0,
 257,4,6, 2,4,4,1, 9,9,-1,0,
 258,7,1, 3,0,4,1, 0,0,-1,0,
 292,7,4, 3,1,1,7, 0,0,-1,0,
 293,5,4, 3,4,1,7, 8,3,-1,0,
 274,0,4, 2,4,3,4, 2,4,-1,0,
 310,4,7, 2,4,2,10, 9,9,-1,0,
 311,6,3, 3,1,2,10, 0,0,-1,0,
 328,3,3, 3,4,3,13, 8,2,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [33]=function()
 PlayBGM(11);
 DrawStrBoxCenter("信都城");
 talk( 221,"就要守不住了……袁绍军怎么会在这儿出现．",
 106,"好．信都城快攻下来了，大家再加把劲．",
 2,"兄长，好像是袁绍军．信都城遭到袁绍军的袭击．",
 83,"袁绍军怎么会打到这里来呢？公孙瓒怎么样了呢？",
 106,"唉，那是哪儿的部队？像是平原刘备的部队，刘备部队怎么来到这里？不管他，在此杀掉刘备！全军！向刘备军出击．",
 3,"大哥，袁绍军杀过来了．",
 2,"兄长，救信都城吧．只要能守住信都城，袁绍军就得撤退．向城门打吧！");
 WarShowTarget(true);
 
 WarModifyAI(245,2);
 WarModifyAI(220,2);
 WarModifyAI(244,2);
 PlayBGM(9);
 NextEvent();
 end,
 [34]=function()
 if (not GetFlag(1002)) and War.Turn==3 then
 WarModifyAI(105,2);
 WarModifyAI(257,1);
 WarModifyAI(310,1);
 SetFlag(1002,1);
 end
 if (not GetFlag(1003)) and War.Turn==14 then
 WarModifyAI(105,1);
 SetFlag(1003,1);
 end
 if WarMeet(3,106) then
 WarAction(1,3,106);
 talk( 3,"哪个是主将？喂，我是张飞，哪个与我单挑较量！",
 106,"好，正中下怀．");
 if fight(3,106)==1 then
 WarAction(4,3,106);
 talk( 106,"这……！这么厉害……",
 3,"就这点儿能耐，赢不了我！");
 talk( 106,"打不过他．妈的，没办法，走为上．");
 WarAction(16,106);
 WarLvUp(GetWarID(3));
 NextEvent();
 else
 talk( 106,"张飞！杀！");
 WarAction(8,106,3);
 WarAction(17,3);
 WarLvUp(GetWarID(106));
 end
 end
 if JY.Status==GAME_WARWIN then
 NextEvent();
 end
 if (not GetFlag(61)) and WarCheckLocation(-1,5,6) then
 GetMoney(100);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金１００！")
 SetFlag(61,1);
 end
 WarLocationItem(7,9,28,181); --获得道具:获得道具：酒
 --WarLocationItem(5,11,140,502); --获得道具:皮甲
 if WarCheckLocation(0,3,1) then
 talk( 106,"他妈的，再加把劲就能攻下来，可是只好全军撤退！");
 PlayBGM(7);
 DrawMulitStrBox("淳于琼败退了．刘备军打败了袁绍军．");
 GetMoney(200);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金２００！")
 WarGetExp();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(36);
 end 
 end,
 [35]=function()
 talk( 106,"他妈的，再加把劲就能攻下来，可是只好全军撤退！");
 PlayBGM(7);
 DrawMulitStrBox("淳于琼败退了．刘备军打败了袁绍军．");
 GetMoney(200);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金２００！")
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [36]=function()
 SetSceneID(0,3);
 talk( 2,"兄长，袁绍军好像退兵了．",
 1,"唉，可是袁绍军竟能派一只军队到这里，战况好像不妙啊．",
 83,"好像不妙，先进信都城吧．");
 --48 显示任务目标:<进信都城>
 NextEvent();
 end,
 [37]=function()
 JY.Smap={};
 JY.Base["现在地"]="信都";
 JY.Base["道具屋"]=3;
 AddPerson(1,10,17,0);
 AddPerson(2,11,9,3);
 AddPerson(3,25,17,2);
 AddPerson(83,27,16,2);
 AddPerson(221,19,12,1);
 SetSceneID(87,5);
 DrawStrBoxCenter("信都议事厅");
 talk( 221,"刘备，您救了信都，太谢谢你了．",
 1,"不用谢．还好，我们正好经过信都．",
 221,"……",
 1,"我们这是去支援公孙瓒，刚才要从信都过去，发现你这里受到攻击．",
 221,"哦，……刘备，请让我也加入援军以报答您救信都之恩．");
 ModifyForce(221,1);
 PlayWavE(11);
 DrawStrBoxCenter("藩宫加入了刘备军！");
 talk( 2,"那么，兄长，我们快去支援吧．准备好的话请说一声．");
 --48 显示任务目标:<去支援公孙瓒>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [38]=function()
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"准备好了吗？") then
 RemindSave();
 PlayBGM(12);
 NextEvent();
 JY.Status=GAME_SMAP_AUTO;
 end
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，再不出发也许就来不及了．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"主公，出发前要不要去打制兵器的道具屋看一看？");
 end
 if JY.Tid==221 then--藩宫
 talk( 221,"我也参加你们的援军．");
 end;
 end,
 [39]=function()
 JY.Smap={};
 SetSceneID(0,12);
 talk( 2,"兄长，快去支援吧．",
 1,"简雍，这里到界桥很近了吧？",
 83,"还不近．这里到界桥有两条路，一条经过清河，另一条经过巨鹿．",
 1,"清河和巨鹿啊．走哪条路都通过界桥吗？",
 83,"是的．",
 2,"可是，袁绍军既然派兵到了这里，那里也会有敌人吧．",
 3,"有就有吧．我来解决他们．大哥，清河和巨鹿，你选择哪条路？快决定吧．");
 NextEvent(49); --goto 49
 end,
 [40]=function()
 talk( 2,"那么走广川吧，列队．");
 WarIni();
 DefineWarMap(2,"第一章 广川之战","一、逢纪的溃败．",30,0,54);
 SelectTerm(1,{
 0,18,0, 3,0,-1,0,
 -1,17,0, 3,0,-1,0,
 -1,19,0, 3,0,-1,0,
 -1,19,1, 3,0,-1,0,
 });
 SetSceneID(0,11);
 talk( 10,"逢纪，你去广川．扰乱公孙瓒的背后．",
 55,"是．",
 55,"将士们，我们绕道公孙瓒背后去，进军广川！");
 SetSceneID(0);
 talk( 13,"什么！袁绍军要袭击我们的背后？坏了！如果这样的话，我们就进攻袁绍的大本营！进攻界桥！");
 SetSceneID(0,3);
 talk( 2,"向广川进军吧！");
 NextEvent();
 end,
 [41]=function()
 SelectEnemy({
 54,0,2, 4,0,6,1, 0,0,-1,0,
 256,4,6, 4,4,4,1, 7,6,-1,0,
 257,7,7, 4,1,4,1, 0,0,-1,0,
 274,1,3, 4,0,3,4, 0,0,-1,0,
 292,9,8, 4,1,1,7, 0,0,-1,0,
 293,10,8, 4,1,1,7, 0,0,-1,0,
 310,1,4, 4,0,3,10, 0,0,-1,0,
 311,6,5, 4,1,2,10, 0,0,-1,0,
 312,4,4, 4,1,2,10, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [42]=function()
 PlayBGM(11);
 DrawStrBoxCenter("广川战场");
 talk( 2,"那是？兄长，像是袁绍军．",
 83,"什么，袁绍军！袁绍军正与公孙瓒军打仗呢，为什么出现在这里？",
 3,"既然袁绍军到达这里，恐怕公孙瓒军已被打败了．",
 55,"什么，有军队？谁的军队？噢，原来是平原的刘备军，是去支援公孙瓒的．本来是在这里布阵，打公孙瓒的背后．也好就打刘备．将士们，迎击刘备军．",
 3,"大哥，袁绍军打过来了．",
 2,"既然打过来了，就教训教训他．");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [43]=function()
 if WarMeet(2,55) then
 WarAction(1,2,55);
 talk( 2,"对面的主将听着，关羽要与你们决一胜负！",
 55,"好，放马过来！");
 WarAction(6,2,55);
 talk( 55,"你叫什么名字？",
 2,"我叫关羽关云长．",
 55,"关羽……？什么！是关羽？是那个大名远扬的关羽？",
 2,"噢，知道我的名字啊，那么某种程度上也知道我的厉害吧．",
 55,"放屁！杀啊！");
 if fight(2,55)==1 then
 talk( 55,"不愧是击败吕布军的英雄……实在打不过．",
 2,"看刀！");
 WarAction(4,2,55);
 talk( 55,"噢！再也坚持不了啦，既然是关羽，我还是快逃吧．");
 WarLvUp(GetWarID(2));
 talk( 55,"这广川也只好放弃了．全军撤退！");
 WarAction(16,55);
 NextEvent();
 else
 talk( 55,"击败吕布军的英雄，也不过如此．",
 55,"关羽！要你的命！");
 WarAction(4,55,2);
 WarAction(17,2);
 WarLvUp(GetWarID(55));
 end
 end
 WarLocationItem(6,15,31,60); --获得道具:获得道具：豆
 --WarLocationItem(6,7,80,503); --获得道具:斧
 if (not GetFlag(180)) and WarCheckLocation(-1,9,5) then
 GetMoney(100);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金１００！")
 SetFlag(180,1);
 end 
 if JY.Status==GAME_WARWIN then
 talk( 55,"唉，刘备军相当厉害！广川也只好放弃了，全军撤退！");
 NextEvent();
 end
 end,
 [44]=function()
 PlayBGM(7)
 DrawMulitStrBox("逢纪败退了，刘备军打败了袁绍军．");
 GetMoney(200);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金２００！")
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [45]=function()
 JY.Smap={};
 JY.Base["现在地"]="广川";
 JY.Base["道具屋"]=4;
 AddPerson(1,8,18,0);
 AddPerson(2,11,11,3);
 AddPerson(3,21,17,2);
 AddPerson(83,23,16,2);
 SetSceneID(97,5);
 DrawStrBoxCenter("广川营帐");
 talk( 2,"兄长，袁绍军好像败退了．",
 1,"唉，可是袁绍军都来到这里了，我看好像不妙啊．",
 83,"像是不妙，嗯？主公，好像有人来．");
 AddPerson(245,30,6,0);
 AddPerson(246,32,7,0);
 MovePerson( 245,7,1,
 246,7,1);
 talk( 245,"刘备，请原谅冒昧来访．我们是信都城的武将，我叫韩英．",
 246,"我叫郭适，初次与你见面．",
 1,"你们为什么还要到这里来？",
 245,"信都城被袁绍占领了，我们俩是奉命守城的．因袁绍军攻势猛烈……",
 246,"是被袁绍手下淳于琼攻陷了．",
 2,"什么！袁绍都攻到信都城来了？",
 246,"是的，之后我们听说刘备军前来支援，所以投奔你们来了．",
 245,"如此让袁绍为所欲为，也太令人心灰意冷了．刘备，请让我们加入吧．",
 246,"我一定要报此仇，请让我们加入吧．",
 3,"大哥就让他们加入吧．也怪可怜的．",
 1,"你们俩个加入我军，我们的阵营又强大了．好好干吧！",
 245,"谢谢．",
 246,"请看我们的表现吧．");
 ModifyForce(245,1);
 ModifyForce(246,1);
 PlayWavE(11);
 DrawStrBoxCenter("韩英、郭适加入刘备军！");
 NextEvent();
 end,
 [46]=function()
 talk( 83,"阵容也强大了，快去救援吧．",
 1,"简雍，这里离界桥很近了吧？",
 83,"还不近，从这里去界桥有两条路，一条经过清河，另一条经过巨鹿．",
 1,"清河和巨鹿，走哪条路都通往界桥吗？",
 83,"是的．",
 2,"可是，袁绍军既然已来到了这里，那里也会有敌人吧．",
 3,"有就有吧，我来解决他们．",
 2,"快准备出征吧．我叫来了刀匠，你们选用吧．");
 talk( 375,"谢谢关照，需要什么刀枪，请说吧．");
 --48 显示任务目标:<去支援公孙瓒>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [47]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，快走吧，我已经憋不住了．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"出征前有两件事要准备，一是买些武器，二是做好记录．");
 end
 if JY.Tid==245 then--韩英
 talk( 245,"我要努力杀敌，下命令吧．");
 end;
 if JY.Tid==246 then--郭适
 talk( 246,"我要努力杀敌，下命令吧．");
 end;
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"准备好了吗？") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [48]=function()
 talk( 2,"出发吧！");
 JY.Smap={};
 SetSceneID(0,12);
 talk( 2,"大哥，清河和巨鹿去哪里？快决定．");
 NextEvent(); --goto 49
 end,
 [49]=function()
 local menu={
 {" 通过巨鹿",nil,1},
 {" 通过清河",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 NextEvent(56); --goto 56
 elseif r==2 then
 NextEvent(); --goto 50
 end
 end,
 [50]=function()
 talk( 2,"明白了，那么去清河吧．");
 PlayBGM(3);
 NextEvent();
 end,
 [51]=function()
 SetSceneID(0);
 talk( 2,"好像是敌人，列队．");
 WarIni();
 DefineWarMap(5,"第一章 清河之战","一、歼灭麴义．",30,0,60);
 SelectTerm(1,{
 0,24,11, 3,0,-1,0,
 -1,23,11, 3,0,-1,0,
 -1,22,10, 3,0,-1,0,
 -1,22,12, 3,0,-1,0,
 -1,23,12, 3,0,-1,0,
 59,3,10, 3,0,-1,0,
 });
 SelectEnemy({
 60,2,10, 4,2,9,7, 0,0,-1,0,
 256,4,9, 4,0,5,1, 0,0,-1,0,
 257,10,7, 4,4,5,1, 12,7,-1,0,
 258,9,9, 4,4,4,1, 12,8,-1,0,
 328,8,8, 4,4,4,13, 11,8,-1,0,
 292,3,8, 4,0,2,7, 0,0,-1,0,
 274,2,9, 4,0,4,4, 0,0,-1,0,
 275,10,10, 4,4,4,4, 11,9,-1,0,
 310,14,0, 4,1,3,10, 0,0,-1,1,
 311,13,1, 4,1,3,10, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [52]=function()
 talk( 60,"麴义！我严纲要和你单挑较量！",
 61,"有胆量，但你要倒霉啦！你还觉得能打赢我麴义？杀啊！");
 if fight(61,60)==1 then
 talk( 61,"严纲，看刀！");
 WarAction(8,61,60);
 talk( 60,"哎呀！");
 WarAction(18,60);
 talk( 61,"公孙瓒的大将严纲被斩了！",
 2,"大哥，好像晚了一步，严纲被斩，清河北平军溃败了．",
 1,"晚了一步啊，好！血债要用血来还！",
 61,"嗯？那不是刘备军吗？噢，想去支援公孙瓒．我麴义不让你们去！");
 else
 talk( 60,"麴义，看刀！");
 WarAction(5,60,61);
 talk( 61,"哼！");
 WarAction(6,60,61);
 WarAction(6,60,61);
 WarAction(10,60,61);
 talk( 60,"可恶啊！",
 2,"大哥，好像晚了一步，清河北平军溃败了．",
 1,"晚了一步啊，好！速速救援严纲！",
 61,"嗯？那不是刘备军吗？噢，想去支援公孙瓒．我麴义不让你们去！");
 end
 WarShowTarget(true);
 PlayBGM(14);
 NextEvent();
 end,
 [53]=function()
 if WarMeet(2,61) then
 WarAction(1,2,61);
 talk( 2,"这里的大将听着！我要和你单挑较量！",
 61,"什么？竟还有人敢向我挑战！好吧，就与你斗一斗！");
 WarAction(6,2,61);
 if fight(2,61)==1 then
 talk( 61,"好家伙！好厉害……",
 2,"强中自有强中手，算你倒霉，砍下你的首级．");
 WarAction(8,2,61);
 WarAction(18,61);
 talk( 2,"我的武艺也不够娴熟，这么个小对手竟感到有点难对付……");
 WarLvUp(GetWarID(2));
 PlayBGM(7);
 DrawMulitStrBox("　关羽杀了麴义，*　刘备军突破了清河．");
 NextEvent();
 else
 talk( 61,"让你也和刚才的严纲落个同样下场！");
 WarAction(4,61,2);
 talk( 2,"我的武艺也不够娴熟，这么个小对手竟感到有点难对付……");
 WarAction(17,2);
 WarLvUp(GetWarID(61));
 end
 end
 if (not GetFlag(1004)) and War.Turn==7 then
 talk( 1,"嗯！那是！？");
 WarShowArmy(310);
 WarShowArmy(311);
 DrawStrBoxCenter("出现了敌人援军！");
 SetFlag(1004,1);
 end
 if JY.Status==GAME_WARWIN then
 talk( 61,"喂，刘备！休想从这里过去．");
 PlayBGM(7);
 DrawMulitStrBox("刘备军突破了清河．！");
 NextEvent();
 end
 WarLocationItem(9,1,28,62); --获得道具:获得道具：酒
 --WarLocationItem(7,19,85,504); --获得道具:钩
 --WarLocationItem(9,11,89,505); --获得道具:枪
 if (not GetFlag(182)) and WarCheckLocation(-1,12,12) then
 GetMoney(100);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金１００！")
 SetFlag(182,1);
 end
 end,
 [54]=function()
 GetMoney(200);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金２００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [55]=function()
 JY.Smap={};
 SetSceneID(0,3);
 talk( 103,"什么！清河的麴义被公孙瓒军突破了，没办法．撤回主公坐镇的界桥！",
 26,"妈的，我的兵力再强大一点，就能捉住张颌．");
 SetSceneID(0);
 talk( 2,"前面就是袁绍主力所在的界桥！",
 3,"大哥快去界桥吧！");
 --48 显示任务目标:<去界桥支援公孙瓒>
 --61 储存进度:战场存盘
 --15 读入段指令:读入第<15>段指令
 NextEvent(61); --goto 61
 end,
 [56]=function()
 talk( 2,"明白了，那么去巨鹿吧．");
 PlayBGM(3);
 SetFlag(133,1);
 NextEvent();
 end,
 [57]=function()
 SetSceneID(0);
 talk( 2,"好像是敌人，列队．");
 WarIni();
 DefineWarMap(4,"第一章 巨鹿之战","一﹑张颌败退．*二﹑刘备到达西面鹿砦．",30,0,102);
 SelectTerm(1,{
 0,2,2, 4,0,-1,0,
 -1,4,3, 4,0,-1,0,
 -1,3,1, 4,0,-1,0,
 -1,1,2, 4,0,-1,0,
 -1,3,3, 4,0,-1,0,
 25,10,4, 4,0,-1,0,
 221,9,5, 4,0,-1,0,
 58,17,13, 3,0,-1,1,
 57,17,12, 3,0,-1,1,
 });
 SelectEnemy({
 102,5,17, 4,0,10,22, 0,0,-1,0,
 51,6,15, 4,0,7,7, 0,0,-1,0,
 103,4,14, 4,0,7,4, 0,0,-1,0,
 91,12,6, 3,1,6,1, 0,0,-1,0,
 54,11,14, 4,1,7,1, 0,0,-1,0,
 256,10,6, 3,1,5,1, 0,0,-1,0,
 257,7,16, 4,0,5,1, 0,0,-1,0,
 274,9,17, 4,0,4,4, 0,0,-1,0,
 292,10,14, 4,1,3,7, 0,0,-1,0,
 336,13,5, 3,1,4,15, 0,0,-1,0,
 348,4,16, 4,0,4,19, 0,0,-1,0,
 310,2,0, 4,1,3,10, 0,0,-1,1,
 311,1,1, 4,1,3,10, 0,0,-1,1,
 312,0,2, 4,1,3,10, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [58]=function()
 PlayBGM(11);
 talk( 52,"张颌，快些收拾掉北平军，赶快和界桥的主力会合吧．",
 103,"唉，可是我听说公孙瓒的盟友刘备军打败了我军的一支劲旅，正向巨鹿赶来，一定得设法不让公孙瓒和刘备汇合．");
 talk( 1,"公孙越，平原刘备前来助战．",
 26,"哦，是刘备，我们有救了．诸位，援军来了．",
 103,"来了，啊．刘备！我张颌在此挡路，你去不了界桥．",
 52,"关羽！张飞！你们敢与我颜良交战吗？",
 2,"大哥，敌人好像比想像的要厉害．现在我们不应该在这里与敌人厮杀，而要冲开敌人阵地突出去．庆幸的是山下西面有一个鹿砦，如果我们摸到那里，敌人也就束手无策了．");
 WarShowTarget(true);
 PlayBGM(14);
 NextEvent();
 end,
 [59]=function()
 if WarMeet(3,52) then
 WarAction(1,3,52);
 talk( 3,"噢，看样子是个很厉害的对手嘛．我去对付他．",
 52,"你是何人？朝这边来是要和我交战吗？好哇，杀！");
 WarAction(6,3,52);
 if fight(3,52)==1 then
 talk( 3,"好像还有两下子，碰上我算你倒霉．",
 52,"让你嚐嚐这一刀．");
 WarAction(9,52,3);
 talk( 3,"你玩的什么武艺？这样还能赢我？",
 52,"唉，连我这一刀也躲过去了，好厉害的家伙．",
 3,"你就这点本事啊．");
 WarAction(8,3,52);
 talk( 52,"噢噢！打不过他，逃吧！");
 WarAction(16,52);
 WarLvUp(GetWarID(3));
 else
 talk( 3,"好像还有两下子，碰上我算你倒霉．",
 52,"让你嚐嚐这一刀．");
 WarAction(8,52,3);
 WarAction(17,3);
 WarLvUp(GetWarID(52));
 end
 end
 if (not GetFlag(1005)) and War.Turn==3 then
 talk( 1,"唉！那是！？");
 WarShowArmy(310);
 WarShowArmy(311);
 WarShowArmy(312);
 DrawStrBoxCenter("敌人的援军来了！");
 talk( 1,"什么？从前面也来了吗！？");
 WarShowArmy(57);
 WarShowArmy(58);
 PlayBGM(12);
 talk( 59,"我是关纯，原是韩馥的部下．此番前来加入刘备军．",
 58,"我们的主公韩馥被袁绍诈占了冀州，此仇难忘，我耿武也前来加入刘备军．",
 1,"那是哪儿的军队？",
 83,"那的确是关纯和耿武，他们是被袁绍诈占了冀州的韩馥的部下．",
 1,"噢，是要报仇吧．",
 83,"大概是吧．",
 3,"总之不是敌人吧？那么就是我们的援军了．");
 DrawStrBoxCenter("耿武、关纯来支援！");
 PlayBGM(14);
 SetFlag(1005,1);
 end
 if JY.Status==GAME_WARWIN then
 talk( 103,"妈的！败给了刘备！撤退！",
 1,"好，我军胜利了！");
 PlayBGM(7);
 DrawMulitStrBox("　张颌败退了，刘备军打败了袁绍军．");
 GetMoney(200);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金２００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if (not GetFlag(162)) and WarCheckArea(0,8,4,13,10) then
 talk( 103,"不能让刘备突破巨鹿，全军阻挡刘备！",
 2,"大哥，鹿砦就在眼前，想办法冲过去吧．");
 WarModifyAI(102,3,0);
 WarModifyAI(51,3,0);
 WarModifyAI(103,3,0);
 WarModifyAI(257,3,0);
 WarModifyAI(274,3,0);
 WarModifyAI(348,3,0);
 SetFlag(162,1);
 end
 if WarCheckLocation(0,10,0) then
 talk( 103,"妈的！不能让刘备过去！",
 1,"好，突破巨鹿了．");
 PlayBGM(7);
 DrawMulitStrBox("　刘备军突破巨鹿了．");
 WarGetExp();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 WarLocationItem(8,5,32,183); --获得道具:获得道具：麦
 --WarLocationItem(7,11,95,506); --获得道具:戟
 --WarLocationItem(13,7,99,507); --获得道具:半弓
 end,
 [60]=function()
 SetSceneID(0,11);
 talk( 61,"什么？巨鹿的张颌被公孙瓒军突破了？没办法，只好返回主公坐镇的界桥．",
 60,"妈的，要是我武力再强点的话，就能捉住麴义了．");
 PlayBGM(3);
 talk( 59,"刘备，我原是韩馥的下属，叫关纯．",
 58,"我叫耿武．",
 1,"唉．",
 59,"我们的主公韩馥，被袁绍夺去了冀州，现在乡下默默的生活．我们还没向袁绍报仇雪恨，刘备，请带我们一起走．",
 1,"明白了，那就跟我走吧．",
 58,"是，谢谢刘备．");
 ModifyForce(59,1);
 ModifyForce(58,1);
 PlayWavE(11);
 DrawStrBoxCenter("关纯、耿武成为刘备下属！");
 talk( 2,"前面就是袁绍主力所在的界桥！",
 3,"大哥，快去界桥吧．");
 --48 显示任务目标:<去界桥支援公孙瓒>
 NextEvent(); --goto 61
 end,
 [61]=function()
 talk( 2,"大哥，到界桥了，请列队．");
 LvUp(13,4);
 WarIni();
 DefineWarMap(6,"第一章 界桥之战","一、袁绍撤退．*二、刘备夺取兵粮库．",40,0,9);
 SelectTerm(1,{
 0,0,14, 4,0,-1,0,
 -1,2,14, 4,0,-1,0,
 -1,3,13, 4,0,-1,0,
 -1,1,13, 4,0,-1,0,
 -1,1,15, 4,0,-1,0,
 12,3,15, 4,0,-1,0,
 222,6,14, 4,0,-1,0,
 227,4,15, 4,0,-1,0,
 53,0,17, 4,0,-1,1,
 });
 if GetFlag(133) then
 SelectEnemy({
 9,25,15, 3,0,13,1, 0,0,-1,0,
 49,26,16, 3,0,8,4, 0,0,-1,0,
 52,4,16, 3,0,10,7, 0,0,-1,0,
 98,15,23, 3,0,8,19, 0,0,-1,0,
 50,7,20, 3,0,8,4, 0,0,-1,0,
 138,14,22, 3,0,7,4, 0,0,-1,0,
 60,25,19, 3,0,10,7, 0,0,-1,0,
 139,9,18, 3,0,7,4, 0,0,-1,0,
 56,24,16, 3,0,7,1, 0,0,-1,0,
 55,25,16, 3,0,7,13, 0,0,-1,0,
 92,27,3, 3,0,7,1, 0,0,-1,0,
 256,29,6, 3,0,5,1, 0,0,-1,0,
 257,28,6, 3,0,5,1, 0,0,-1,0,
 292,15,21, 3,0,3,7, 0,0,-1,0,
 293,23,19, 3,0,3,7, 0,0,-1,0,
 310,8,19, 3,1,6,10, 0,0,-1,0,
 328,10,17, 3,1,5,13, 0,0,-1,0,
 });
 else
 SelectEnemy({
 9,25,15, 3,0,13,1, 0,0,-1,0,
 49,26,16, 3,0,8,4, 0,0,-1,0,
 52,4,16, 3,0,10,7, 0,0,-1,0,
 98,15,23, 3,0,8,19, 0,0,-1,0,
 50,7,17, 3,0,8,4, 0,0,-1,0,
 138,25,16, 3,0,7,4, 0,0,-1,0,
 102,23,19, 3,0,10,22, 0,0,-1,0,
 51,25,19, 3,0,10,7, 0,0,-1,0,
 92,27,3, 3,0,7,1, 0,0,-1,0,
 91,24,16, 3,0,7,1, 0,0,-1,0,
 54,6,18, 3,0,8,1, 0,0,-1,0,
 103,9,18, 3,1,7,4, 0,0,-1,0,
 256,28,6, 3,0,5,1, 0,0,-1,0,
 257,29,6, 3,0,5,1, 0,0,-1,0,
 292,15,21, 3,0,3,7, 0,0,-1,0,
 293,5,19, 3,0,3,7, 0,0,-1,0,
 274,8,19, 3,1,3,4, 0,0,-1,0,
 328,7,20, 3,1,5,13, 0,0,-1,0,
 329,16,22, 3,0,5,13, 0,0,-1,0,
 });
 end
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [62]=function()
 PlayBGM(11);
 talk( 10,"敌军已经不堪一击．文丑！去取公孙瓒的首级！",
 53,"我乃文丑，公孙瓒，明年的今天就是你的忌日．",
 13,"怎么搞的！援军还没有到啊．",
 228,"主公，这交给我吧．文丑来受死吧！",
 53,"嘘，无名小卒，快滚回去吧．");
 WarAction(1,53,228);
 fight(53,228);
 talk( 53,"杀……");
 WarAction(4,53,228);
 talk( 228,"啊……");
 --WarAction(19,228);
 talk( 228,"太、太厉害了．",
 53,"哈哈哈，怎么样！凭你这点儿本事想赢我！");
 WarAction(17,228);
 talk( 53,"公孙瓒，哪里走！纳命来！",
 13,"看来我命到此休矣！");
 WarShowArmy(53);
 PlayBGM(12);
 talk( 54,"等一下，这次我来战你．",
 53,"你是何人？");
 WarMoveTo(54,3,16);
 WarAction(1,54,53);
 WarAction(5,54,53);
 talk( 53,"不知死活的家伙，和公孙瓒一起作我枪下之鬼吧．");
 if fight(54,53)==1 then
 talk( 54,"呸！！");
 WarAction(4,54,53);
 talk( 53,"哦！杀啊！妈的，好厉害，先撤吧．");
 WarAction(19,53);
 WarMoveTo(53,15,22);
 WarAction(0,53,3);
 WarLvUp(GetWarID(54));
 else
 WarAction(6,54,53);
 talk( 53,"哈哈哈，今天先放公孙瓒你一马．");
 WarMoveTo(53,15,22);
 WarAction(0,53,3);
 end
 talk( 13,"哦，刚才差一点没了命，真是太感谢你了，让我说声谢谢吧，请问大名．",
 54,"我叫赵云．",
 54,"以前跟随袁绍，我看透了他既不忠君也不爱惜百姓，就要离开他，返回故乡．",
 13,"袁绍干了件蠢事啊，怎么样，你能不能帮助我．");
 talk( 54,"好！",
 54,"嗯？公孙瓒，那支军队是？",
 13,"噢，那是平原刘备的军队啊！诸位，刘备的援军到了！",
 3,"大哥，好像赶上了．",
 1,"听说公孙瓒正在打仗，我特地从平原赶来助战．",
 2,"大哥，敌军强大，我们去袭击敌人的粮仓吧．",
 51,"主公，刘备军来了．",
 10,"哎呀，是那个刘备军吗？",
 50,"主公，怕什么，不能放过这次机会．",
 10,"……对了，好，一起杀死他们祭旗！");
 WarModifyAI(54,1)
 WarShowTarget(true);
 PlayBGM(13);
 NextEvent();
 end,
 [63]=function()
 if WarMeet(3,53) then
 WarAction(1,3,53);
 talk( 53,"刚才因大意受挫，这次不会了，要让你们看看我的厉害．",
 3,"喂，还有没有稍微有点骨气的？唉，我跟你玩玩吧．");
 WarAction(6,3,53);
 if fight(3,53)==1 then
 talk( 3,"怎么如此不中用啊．没意思．",
 53,"不，不应该这么不争气．",
 3,"你回去好啦，懒得和你交手．",
 53,"你这个家伙！不要侮辱人！");
 WarAction(9,53,3);
 talk( 53,"哈哈，怎、怎么样……",
 3,"……你惹恼了我，别走！");
 WarAction(8,3,53);
 talk( 53,"噢噢！刚才败了，这次也败了．");
 WarAction(16,53);
 WarLvUp(GetWarID(3));
 else
 talk( 53,"哈哈，怎、怎么样……");
 WarAction(8,53,3);
 WarAction(17,3);
 WarLvUp(GetWarID(53));
 end
 end
 if JY.Status==GAME_WARWIN then
 NextEvent();
 end
 if (not GetFlag(213)) and (not GetFlag(148)) and WarCheckArea(-1,17,10,23,15) then
 PlayBGM(11);
 talk( 50,"主公，敌人那点儿兵力还真顽强啊，好像接近了我们．",
 10,"哎，他们也不是脓包．好，全军开始进攻！！");
 if GetFlag(133) then
 WarModifyAI(49,4,15,21);
 WarModifyAI(9,4,16,22);
 WarModifyAI(293,4,16,21);
 WarModifyAI(56,4,15,23);
 WarModifyAI(55,4,14,22);
 WarModifyAI(60,4,13,23);
 WarModifyAI(98,1);
 WarModifyAI(138,1);
 WarModifyAI(292,1);
 else
 WarModifyAI(9,4,16,22);
 WarModifyAI(91,4,15,23);
 WarModifyAI(49,4,15,21);
 WarModifyAI(51,4,14,22);
 WarModifyAI(102,4,13,23);
 WarModifyAI(293,4,16,21);
 WarModifyAI(98,1);
 WarModifyAI(138,1);
 WarModifyAI(292,1);
 WarModifyAI(329,1);
 end
 SetFlag(213,1);
 PlayBGM(13);
 end
 if (not GetFlag(148)) and WarCheckArea(0,6,23,9,29) then
 PlayBGM(11);
 talk( 93,"主公，刘备想要夺取粮仓向我们营地出发了．",
 10,"什么！！刘备，你这招真狠啊！急速返回营地！");
 if GetFlag(133) then
 WarModifyAI(9,3,0);
 WarModifyAI(49,3,0);
 WarModifyAI(60,3,0);
 WarModifyAI(293,3,0);
 WarModifyAI(56,3,0);
 WarModifyAI(55,3,0);
 else
 WarModifyAI(9,3,0);
 WarModifyAI(91,3,0);
 WarModifyAI(49,3,0);
 WarModifyAI(138,3,0);
 WarModifyAI(51,3,0);
 WarModifyAI(102,3,0);
 end
 SetFlag(148,1);
 PlayBGM(13);
 end
 if WarCheckLocation(0,1,27) then
 talk( 1,"好！我们夺取了袁绍的粮仓．",
 2,"噢，兄长．太棒了．",
 3,"这样袁绍军就没有粮食了．",
 83,"这仗我们赢定了．");
 SetFlag(1100,1);
 NextEvent();
 end
 WarLocationItem(21,8,66,64); --获得道具:获得道具：火龙书 改为 武道指南书
 WarLocationItem(23,14,20,184); --获得道具:获得道具：长枪
 WarLocationItem(1,29,22,185); --获得道具:获得道具：弩
 WarLocationItem(3,22,32,186); --获得道具:获得道具：麦
 --WarLocationItem(17,2,104,508); --获得道具:弩
 --WarLocationItem(19,24,109,509); --获得道具:手炮
 end,
 [64]=function()
 talk( 10,"唉，刘备这个混帐，你再晚来一步我就可以杀死公孙瓒了……妈的，我不会善罢干休！公孙瓒啊，败军之恨，总有一天要报的．全军撤退！");
 PlayBGM(7);
 DrawMulitStrBox("界桥之战，公孙瓒取得了胜利．");
 GetMoney(200);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金２００！");
 if GetFlag(1100) then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [65]=function()
 JY.Smap={};
 SetSceneID(0,3);
 talk( 10,"公孙瓒，我不会认输的！");
 SetSceneID(0);
 talk( 13,"刘备，你来的正好，这次多亏你来帮我们．",
 1,"哪里，因为及时赶到了，才能转败为胜．",
 13,"哦，对了．刘备，给你介绍一下，这位是赵云，在我危难之际救了我．赵云，这位是刘备．",
 1,"我叫刘备字玄德．",
 54,"你就是刘备啊，大名如雷贯耳．我叫赵云字子龙．",
 13,"诸位，总之我们打了胜仗．为胜利，乾杯．");
 NextEvent();
 end,
 --第一章　支援北海徐州
 [66]=function()
 JY.Smap={};
 SetSceneID(-1,0);
 JY.Base["章节名"]="第一章　支援北海徐州";
 DrawStrBoxCenter("第一章　支援北海徐州");
 LoadPic(5,1);
 DrawMulitStrBox("　公孙瓒和袁绍的界桥之战，由于刘备军和赵云的英勇善战，公孙瓒高奏凯歌．");
 DrawMulitStrBox("　可是由于连续几个月的作战，士兵非常疲惫．得知此事的董卓，想卖个人情，就以皇帝的名义劝两人和好．正中两人下怀，界桥之战就这样结束了．");
 LoadPic(5,2);
 LoadPic(29,1);
 DrawMulitStrBox("　之后，在帝都发生了一件大事．吕布刺死了董卓．*　吕布中了王允和貂蝉两人的连环计，刺死了董卓．随后吕布在董卓旧部面前吃了败仗，逃离了帝都．");
 LoadPic(29,2);
 AddPerson(9,25,9,1);
 AddPerson(17,14,9,3);
 AddPerson(18,12,10,3);
 AddPerson(20,10,11,3);
 AddPerson(69,25,15,2);
 AddPerson(19,23,16,2);
 AddPerson(63,21,17,2);
 JY.Base["现在地"]="陈留";
 JY.Base["道具屋"]=0;
 SetSceneID(86,11);
 DrawStrBoxCenter("陈留议事厅");
 AddPerson(367,3,20,0);
 MovePerson(367,7,0);
 talk( 367,"主公，大事不好！",
 9,"吵闹什么？还会有比董卓死了更大的事吗？急什么．",
 367,"可是……",
 9,"平心静气讲．",
 367,"是，主公的父亲曹嵩被陶谦部下杀害了．",
 9,"什么！？是真的吗？");
 MovePerson(9,1,2);
 MovePerson(9,1,1);
 MovePerson(9,1,3);
 MovePerson(9,2,1);
 talk( 9,"陶谦为什么要杀我父亲！为什么！",
 367,"根据报告说，令尊在来陈留途中，陶谦招待了他，还派护卫护送他．可是令尊惨遭那护卫杀害．",
 9,"唉……陶谦，我绝不饶你．于禁！",
 63,"是．");
 MovePerson(63,1,1);
 MovePerson(63,3,2);
 MovePerson(63,0,0);
 talk( 9,"你马上率一军直奔徐州，杀他们以祭父亲在天之灵．我将随后率兵到小沛．你打先锋．",
 63,"是，倍感荣幸．我马上奔徐州，取陶谦首级来见你．");
 MovePerson(63,7,1);
 DecPerson(63);
 NextEvent();
 end,
 [67]=function()
 JY.Smap={};
 SetSceneID(0);
 talk( 63,"我马上杀往徐州，为令尊大人报仇．");
 SetSceneID(0);
 talk( 9,"陶谦老朽，我绝不饶你！进军小沛！");
 NextEvent();
 end,
 [68]=function()
 JY.Smap={};
 JY.Base["现在地"]="平原";
 JY.Base["道具屋"]=2;
 AddPerson(1,25,17,2);
 AddPerson(2,20,9,1);
 AddPerson(3,11,16,0);
 AddPerson(65,17,13,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("平原议事厅");
 talk( 2,"大哥，徐州陶谦的家臣糜竺前来求见．说有话要对大哥讲．");
 --48 显示任务目标:<与糜竺谈话>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [69]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"他好像有什么重要事要讲．大哥快听他讲话吧．");
 end
 if JY.Tid==2 then--关羽
 talk( 2,"兄长先去和糜竺谈话吧．");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"刘备，初次见面，请多关照．我是陶谦的家臣，叫糜竺．",
 1,"我和陶谦在讨伐董卓的联军时也见过面，你这次来有什么事情？",
 65,"其实此次前来是有求于刘备．",
 1,"是什么事？");
 talk( 65,"就在前两天，曹操的父亲经过徐州．我主公在徐州设宴招待了曹操父亲，还派人护送．",
 3,"这不是很好吗？",
 65,"可是，那个护卫起了反心，杀死了曹操父亲，掠去了财宝．曹操知道后惊怒异常，率领大军攻打徐州．",
 2,"怎么搞的嘛？原想欢迎，反倒成仇．");
 talk( 65,"所说的有求于刘备就是这件事．可否发兵支援徐州？请您救我们，不，是救徐州．这样下去的话，我们姑且不说连老百姓都卷进了战争．",
 1,"……．明白了．你看我行的话就帮助你们．",
 65,"哦，谢谢，此恩终生难忘．",
 1,"不客气．你也长途奔波劳累了，去客房休息吧．",
 65,"谢谢，那失陪了．");
 MovePerson(65,8,2);
 DecPerson(65);
 --48 显示任务目标:<研究下一步问题．>
 NextEvent();
 end;
 end,
 [70]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，要发兵支援的话，打曹操，我们兵力可不够啊，怎么办？");
 end
 if JY.Tid==2 then--关羽
 talk( 2,"若发兵支援，抗拒曹操，我们现在没有那么多兵力啊．",
 1,"嗯，向公孙瓒借些兵吧．",
 2,"这是个好主意．那么我们快去公孙瓒所在地的北平城吧．");
 --48 显示任务目标:<为求得公孙瓒支援去北平．>
 NextEvent();
 end
 end,
 [71]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，快去北平吧．");
 end
 if JY.Tid==2 then--关羽
 talk( 2,"快去北平吧，北平位于平原的北面．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [72]=function()
 JY.Smap={};
 JY.Base["现在地"]="北平";
 JY.Base["道具屋"]=2;
 AddPerson(13,27,8,1);
 AddPerson(1,21,11,0);
 AddPerson(2,15,12,0);
 AddPerson(3,19,14,0);
 SetSceneID(48,5);
 DrawStrBoxCenter("北平议事厅");
 talk( 13,"哦，刘备，什么风把你吹来了？");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [73]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"大哥，先跟公孙瓒打个招呼吧．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"我们没事，但跟公孙瓒还是说一下好．");
 end
 if JY.Tid==13 then--公孙瓒
 talk( 13,"刘备，怎么了．",
 1,"徐州陶谦派来使者，请求我支援．我想发兵前去支援，但是我这一点兵力恐怕不行．您看能不能借我一些兵？",
 13,"刘备在界桥对我有相助之恩，我很高兴借兵给你．",
 1,"谢谢．",
 13,"那就带他去吧．");
 AddPerson(54,3,20,0);
 MovePerson(54,7,0);
 talk( 54,"您叫我吗？",
 13,"赵云，你和刘备去支援徐州．",
 54,"去徐州？",
 13,"嗯，他们请求刘备支援．赵云，我想派你同去．",
 54,"能和刘备一起作战，我非常高兴，我愿意去．");
 ModifyForce(54,1);
 PlayWavE(11);
 DrawStrBoxCenter("赵云加入刘备军！");
 talk( 13,"那么，赵云让你辛苦一趟，刘备，祝你成功．",
 1,"谢谢．");
 MovePerson( 54,7,1,
 2,7,1,
 3,7,1);
 DecPerson(2);
 DecPerson(3);
 DecPerson(54);
 --<返回平原作出兵准备>
 NextEvent();
 end
 end,
 [74]=function()
 if JY.Tid==13 then--公孙瓒
 talk( 13,"祝你胜利．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [75]=function()
 JY.Smap={};
 JY.Base["现在地"]="平原";
 JY.Base["道具屋"]=2;
 AddPerson(1,25,17,2);
 AddPerson(2,20,9,1);
 AddPerson(3,11,16,0);
 AddPerson(54,9,15,0);
 AddPerson(65,17,13,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("平原议事厅");
 talk( 65,"刘备，我一直在等你．请你准备出兵．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [76]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，糜竺在等我们．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，糜竺等得着急了．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"主公，听你吩咐．");
 end
 if JY.Tid==65 then--糜竺
 if talkYesNo( 65,"准备好了吗？") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [77]=function()
 PlayBGM(12);
 talk( 65,"那么快往徐州吧．");
 WarIni();
 DefineWarMap(7,"第一章 北海之战","一、管亥的溃败．",30,0,216);
 SelectTerm(1,{
 0,22,3, 1,0,-1,0,
 -1,21,4, 1,0,-1,0,
 -1,20,5, 1,0,-1,0,
 -1,22,5, 1,0,-1,0,
 -1,21,3, 1,0,-1,0,
 53,21,2, 1,0,-1,0,
 7,3,0, 1,0,-1,0,
 149,2,0, 1,0,-1,0,
 233,1,0, 1,0,-1,0,
 });
 JY.Smap={};
 SetSceneID(0,3);
 talk( 65,"徐州在这个平原的南面，快速行军吧．");
 SetSceneID(0);
 talk( 3,"嗯？好像情况不对啊，怎么回事？");
 SetSceneID(0);
 talk( 217,"哈哈哈，进攻进攻！再攻一会儿城池就归我了．",
 150,"再这样的话，北海就要被攻陷了，孔融，请你出城逃走吧．",
 8,"不，这不行！我虽不愿意看到城池陷落，但我更不愿意弃城逃走．",
 150,"……",
 217,"冲啊！冲啊！金银财宝就在那里！");
 SetSceneID(0);
 talk( 2,"看来好像是草寇作乱．",
 65,"这里是北海，是孔融治理的地方．",
 1,"是孔融啊，孔融也参加了反董卓的联军啊．",
 83,"主公，怎么办？就这样置之不理吗？",
 1,"不，不能这样置之不理．糜竺，对不起，要绕些路了．",
 65,"没办法，没有你刘备这样好的人．",
 54,"不愧是刘备，他才是我佩服的人．");
 NextEvent();
 end,
 [78]=function()
 ModifyForce(150,8);
 ModifyForce(234,8);
 SelectEnemy({
 216,6,7, 3,6,10,10, 7,10,-1,0,
 310,2,9, 2,6,6,10, 9,15,-1,0,
 311,3,8, 2,6,6,10, 9,16,-1,0,
 312,7,6, 3,6,5,10, 8,10,-1,0,
 313,10,10, 3,0,5,10, 0,0,-1,0,
 314,10,12, 3,0,6,10, 0,0,-1,0,
 315,8,14, 3,0,6,10, 0,0,-1,0,
 316,18,11, 3,0,5,10, 0,0,-1,0,
 317,18,12, 3,0,5,10, 0,0,-1,0,
 274,1,7, 2,6,6,4, 5,11,-1,0,
 275,9,7, 3,6,6,4, 14,11,-1,0,
 332,13,8, 3,6,4,14, 17,11,-1,0,
 333,6,12, 3,6,4,14, 7,13,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [79]=function()
 PlayBGM(11);
 WarModifyAI(7,2);
 WarModifyAI(149,2);
 WarModifyAI(233,2);
 talk( 217,"哈哈哈．这个城就等于到手了．混蛋们，把城里的金银财宝统统给我拿来．",
 8,"难道我就这样完了．",
 150,"只因我们军力不足．嗯，我们有救了．",
 2,"大哥，再不快点，这个城就落到山贼手里啦．",
 3,"山贼竟敢袭击城镇，胆子好大啊，碰上我们算他运气不好．",
 1,"好，刻不容缓，消灭山贼．",
 217,"嗯？你们是干什么的？想和我们作对吗？哈哈哈，有意思．笨蛋们，调过头来打，给他们点苦头．");
 WarShowTarget(true);
 PlayBGM(14);
 NextEvent();
 end,
 [80]=function()
 if WarMeet(54,217) then
 WarAction(1,54,217);
 talk( 54,"那是山贼的大将，在刘备面前也显示一下我的本领．",
 217,"哎呀，哈哈哈，真是蠢货，好像他还觉得能打赢我，没办法，我就陪你玩玩吧．");
 WarAction(6,54,217);
 if fight(54,217)==1 then
 talk( 217,"我是管亥，让你去阴曹地府……",
 54,"有破绽．");
 WarAction(4,54,217);
 talk( 217,"啊！");
 WarAction(18,217);
 talk( 54,"岂能宽容你这坑害百姓的草寇．");
 WarLvUp(GetWarID(54));
 PlayBGM(7);
 DrawMulitStrBox("赵云杀了管亥，刘备军打败了草寇．");
 GetMoney(300);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金３００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 else
 talk( 217,"我是管亥，让你去阴曹地府……",
 54,"啊！");
 WarAction(4,217,54);
 WarAction(17,54);
 WarLvUp(GetWarID(217));
 end
 end
 if JY.Status==GAME_WARWIN then
 talk( 217,"倒霉！你们再晚一点来，这个城就成我的了．");
 PlayBGM(7);
 DrawMulitStrBox("刘备军打败了草寇．");
 GetMoney(300);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金３００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if (not GetFlag(163)) and WarCheckArea(-1,7,9,19,14) then
 PlayBGM(11);
 talk( 150,"主公，不知道来的是什么人，但我们现在应该杀出去配合他们．",
 8,"唉，好．打开城门！我们也杀出去．",
 234,"是．");
 --38 改变地形:将坐标<2,2>的地形修改为：0
 SetWarMap(3,3,1,0);
 PlayWavE(18);
 WarDelay(48);
 War.MapID=60;
 WarDelay(12);
 DrawStrBoxCenter("城门打开，孔融军杀了出去！");
 WarModifyAI(7,1);
 WarModifyAI(149,1);
 WarModifyAI(233,1);
 SetFlag(163,1);
 end
 WarLocationItem(5,11,85,68); --获得道具:获得道具：特级酒 改为 钩
 WarLocationItem(17,13,47,187); --获得道具:获得道具：平气书
 --WarLocationItem(11,18,125,510); --获得道具:铁笛
 end,
 [81]=function()
 SetSceneID(0,3)
 talk( 150,"虽素不相识，但深感大德，能否请教尊姓大名．",
 1,"我叫刘备．",
 150,"噢，您就是平原的刘备啊．救我于危难之际，非常感谢，请您一定要进城，也请您见一下孔融．");
 --48 显示任务目标:<在北海城见孔融．>
 NextEvent();
 end,
 [82]=function()
 JY.Smap={};
 JY.Base["现在地"]="北海";
 JY.Base["道具屋"]=5;
 AddPerson(8,25,17,2);
 AddPerson(150,22,10,1);
 AddPerson(1,17,13,3);
 AddPerson(2,14,13,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("北海议事厅");
 talk( 150,"主公，我把刘备请出来了．",
 8,"噢，刘备．你救了北海，太感谢了．");
 talk( 8,"孔融感激不尽．",
 1,"不用多礼．我们这是因糜竺请求，正在赶往徐州．",
 8,"去徐州？去支援吗？我也听说曹操在攻打徐州．",
 1,"是的．我们路过这里时发现太史慈正受到攻击，所以助他一臂之力．",
 8,"是吗？那样的话，我拨给你一些粮草，也表示一下对这次帮助的感谢．");
 talk( 2,"大哥，再不赶路就要误事啦．",
 1,"是啊．那么，孔融，我们还急着赶路，告辞了．",
 8,"祝你马到成功．",
 150,"非常感谢．",
 2,"准备出征．");
 --48 显示任务目标:<去徐州支援陶谦．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [83]=function()
 if JY.Tid==8 then--孔融
 talk( 8,"努力啊．");
 end
 if JY.Tid==150 then--太史慈
 talk( 150,"谢谢你，有刘备支援，徐州就万无一失了．");
 end
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"准备好了吗？") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [84]=function()
 PlayBGM(12);
 LvUp(150,4);
 LvUp(16,6);
 WarIni();
 DefineWarMap(8,"第一章 徐州I之战","一、全数歼灭敌人．*二、刘备进入徐州城．",30,0,-1);
 SelectTerm(1,{
 0,3,16, 4,0,-1,0,
 -1,1,15, 4,0,-1,0,
 -1,2,15, 4,0,-1,0,
 -1,2,16, 4,0,-1,0,
 -1,4,17, 4,0,-1,0,
 -1,3,17, 4,0,-1,0,
 53,2,17, 4,0,-1,0,
 15,29,12, 3,0,-1,0,
 81,29,11, 3,0,-1,0,
 63,29,13, 3,0,-1,0,
 149,6,17, 4,0,-1,1,
 });
 DrawSMap();
 talk( 65,"快去徐州吧．");
 JY.Smap={};
 SetSceneID(0,3);
 talk( 65,"刘备，徐州在北海的南面，快去吧．");
 NextEvent();
 end,
 [85]=function()
 SelectEnemy({
 62,25,12, 4,6,14,1, 22,13,-1,0,
 217,15,1, 4,3,11,7, 0,0,-1,0,
 115,26,9, 4,6,11,1, 22,12,-1,0,
 61,24,14, 4,6,10,4, 21,15,-1,0,
 19,8,1, 4,1,11,23, 0,0,-1,0,
 17,4,1, 4,4,11,22, 27,12,-1,0,
 256,5,0, 4,4,7,1, 27,11,-1,0,
 257,5,2, 4,3,7,1, 0,0,-1,0,
 336,25,14, 4,6,7,15, 20,12,-1,0,
 292,15,0, 4,3,7,7, 0,0,-1,0,
 293,15,2, 4,3,7,7, 0,0,-1,0,
 294,3,0, 4,1,7,7, 0,0,-1,0,
 295,3,2, 4,1,6,7, 0,0,-1,0,
 274,7,0, 4,3,7,4, 0,0,-1,0,
 348,6,1, 4,4,6,19, 27,10,-1,0,
 310,26,10, 4,6,7,10, 20,14,-1,0,
 328,25,16, 4,6,7,13, 22,14,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [86]=function()
 PlayBGM(11);
 WarModifyAI(15,2);
 WarModifyAI(63,2);
 WarModifyAI(81,2);
 talk( 63,"说什么？刘备攻过来了？有多少兵？……不好．一定设法等夏侯渊的到来．",
 18,"大家快走，去支援于禁！",
 54,"敌人的援军已来到附近．我们不要恋战，快进徐州城吧．");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [87]=function()
 if (not GetFlag(1006)) and War.Turn==5 then
 PlayBGM(12);
 WarShowArmy(149);
 WarModifyAI(149,4,27,12);
 talk( 150,"刘备，遵孔融之命，太史慈前来助你．");
 DrawStrBoxCenter("太史慈前来支援！");
 PlayBGM(9);
 SetFlag(1006,1);
 end
 if WarCheckArea(0,10,28,14,29) then
 PlayBGM(7);
 talk( 1,"好，放他进徐州城．大家不要打硬仗，退进城去．");
 DrawStrBoxCenter("刘备军后退了．");
 WarGetExp();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 talk( 3,"太棒了，大哥．",
 2,"趁敌人援军没到之前，我们快进城吧．");
 PlayBGM(7);
 DrawMulitStrBox("　刘备军打败了曹操军，进了徐州城．");
 GetMoney(300);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金３００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if WarMeet(2,63) then
 WarAction(1,2,63);
 talk( 2,"我就是关羽关云长，有武将的话就出来．",
 63,"无名小卒休得猖狂，我来了．");
 WarAction(6,2,63);
 if fight(2,63)==1 then
 talk( 2,"不愧是曹操的手下大将．只是凭你的武艺胜不了我．",
 63,"情况不妙！关羽，我记住你了．");
 WarAction(16,63);
 WarLvUp(GetWarID(2));
 else
 talk( 2,"不愧是曹操的手下大将．");
 WarAction(17,2);
 WarLvUp(GetWarID(63));
 end
 end
 --WarLocationItem(16,1,117,511); --获得道具:圈
 --WarLocationItem(5,19,131,512); --获得道具:扁厢车
 end,
 [88]=function()
 JY.Smap={};
 JY.Base["现在地"]="徐州";
 JY.Base["道具屋"]=0;
 AddPerson(9,25,9,1);
 AddPerson(69,11,10,3);
 AddPerson(62,7,12,3);
 AddPerson(17,24,17,2);
 AddPerson(18,20,19,2);
 SetSceneID(63,11);
 DrawStrBoxCenter("曹操军营帐");
 AddPerson(63,3,21,0);
 MovePerson(63,7,0);
 talk( 63,"对不起．虽然让我当先锋，可是没打好……",
 9,"我不想听你道歉．为什么没捉到陶谦？我军不应该败给陶谦．",
 63,"由于平原的刘备来支援徐州，所以没捉到陶谦．",
 9,"什么！那个刘备吗？唉，可是刘备为什么支援陶谦呢？",
 63,"这个我一点也不知道．",
 9,"嗯，既然帮助陶谦，那么刘备也是敌人！我绝不宽恕！这次我亲自出征．");
 NextEvent();
 end,
 [89]=function()
 JY.Smap={};
 JY.Base["现在地"]="徐州";
 JY.Base["道具屋"]=6;
 AddPerson(16,25,9,1);
 AddPerson(64,14,9,3);
 AddPerson(65,10,11,3);
 AddPerson(66,25,15,2);
 --AddPerson(18,20,19,2);
 AddPerson(1,5,19,0);
 AddPerson(2,3,18,0);
 AddPerson(3,7,20,0);
 SetSceneID(86,5);
 DrawStrBoxCenter("徐州议事厅");
 talk( 65,"我回来了．",
 16,"哦，糜竺，这次你劝说刘备劝得好．刘备，久违了．",
 1,"我们能来得及支援，太好了．",
 16,"非常感谢．");
 --显示任务目标:<与陶谦讨论今后的事．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [90]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"我们能来得及支援，太好了．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"呀，大哥，时间好紧啊，再晚一点就危险了．");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"刘备，太谢谢你了．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"如果刘备不来，我们都要遭杀身之祸．");
 end
 if JY.Tid==66 then--陈登
 talk( 66,"可是，虽然初战告捷，但敌人很强大，他们不会就此罢休的．");
 end
 if JY.Tid==16 then--陶谦
 talk( 16,"曹操军肯定还会打来，怎么办？",
 1,"曹操是个头脑清醒、明白事理的人，我们请求他停战吧．",
 64,"可是事情能否那么顺利呢？",
 3,"试一试看，不行再说．这交给我好啦．",
 2,"我认为应出兵作战，只有作战才能称为武将．");
 talk( 3,"哎，关羽，少见呀．竟比我还想打仗．",
 2,"只有和强敌交锋才能称为武将．敌人是曹操军的话，岂不正合我意．兄长，是派张飞去求和，还是作战，你想选择哪个？请兄长决定！你想好的话，跟张飞或我说一下．");
 --显示任务目标:<决定是和曹操作战还是派张飞求和？>
 NextEvent();
 end
 end,
 [91]=function()
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"哦，兄长，决定出征了吗？") then
 RemindSave();
 SetFlag(219,1);
 PlayBGM(12)
 talk( 2,"快做出征准备吧．");
 JY.Status=GAME_SMAP_AUTO;
 WarIni();
 DefineWarMap(9,"第一章 小沛之战","一、曹操退兵",30,0,8);
 SelectTerm(1,{
 0,21,4, 3,0,-1,0,
 -1,19,6, 3,0,-1,0,
 -1,19,7, 3,0,-1,0,
 -1,21,6, 3,0,-1,0,
 -1,22,5, 3,0,-1,0,
 -1,23,4, 3,0,-1,0,
 53,20,7, 3,0,-1,0,
 15,23,2, 3,0,-1,0,
 63,20,3, 3,0,-1,0,
 81,20,5, 3,0,-1,0,
 --149,6,17, 3,0,-1,1,
 });
 DrawSMap();
 talk( 2,"快出征吧．",
 16,"既然你们决定了，我们也出征．听说敌人现在在小沛．");
 JY.Smap={};
 SetSceneID(0,3);
 talk( 16,"从这里向西南，有个地方叫小沛．曹操军就在那里扎营．",
 2,"曹操军有什么了不起？兄长，快进军小沛吧．");
 NextEvent();
 end
 end
 if JY.Tid==3 then--张飞
 if talkYesNo( 3,"大哥，派我去向曹操军求和吗？") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 talk( 3,"这样决定了的话就简单了．好，我马上就去．");
 --15 读入段指令:读入第<8>段指令
 NextEvent(96); --goto 96
 end
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"曹操军非常强大，以正面与他交锋是下策．还是派张飞去求和吧．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"我选择交战．尽管对方强大，但我方在士气上没有输．");
 end
 if JY.Tid==66 then--陈登
 talk( 66,"敌军强大，他们是不会善罢甘休的．还是派张飞去求和吧．");
 end
 if JY.Tid==16 then--陶谦
 talk( 16,"莫非要我投降才是上策？");
 end
 end,
 [92]=function()
 LvUp(16,1);
 LvUp(64,1);
 LvUp(82,1);
 SelectEnemy({
 8,1,13, 4,0,23,8, 0,0,-1,0,
 386,0,13, 4,3,18,15, 8,0,-1,0, --典韦S
 68,0,14, 4,0,14,13, 0,0,-1,0,
 61,4,8, 4,0,13,16, 0,0,-1,0,
 16,2,13, 4,0,14,7, 0,0,-1,0,
 17,0,12, 4,0,14,22, 0,0,-1,0,
 115,3,12, 4,0,14,1, 0,0,-1,0,
 217,7,10, 4,1,13,7, 0,0,-1,0,
 62,8,14, 4,1,14,1, 0,0,-1,0,
 19,5,13, 4,0,14,23, 0,0,-1,0,
 256,10,14, 4,1,10,1, 0,0,-1,0,
 257,6,9, 4,1,10,1, 0,0,-1,0,
 258,6,14, 4,0,10,1, 0,0,-1,0,
 274,6,11, 4,1,10,4, 0,0,-1,0,
 275,9,13, 4,1,9,4, 0,0,-1,0,
 276,2,11, 4,0,9,4, 0,0,-1,0,
 292,7,15, 4,1,10,7, 0,0,-1,0,
 293,3,15, 4,0,10,7, 0,0,-1,0,
 294,1,14, 4,0,9,7, 0,0,-1,0,
 328,7,12, 4,1,10,13, 0,0,-1,0,
 329,0,10, 4,0,10,13, 0,0,-1,0,
 348,1,10, 4,0,10,19, 0,0,-1,0,
 349,1,15, 4,0,9,19, 0,0,-1,0,
 --
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [93]=function()
 PlayBGM(11);
 talk( 9,"刘备小儿，与我仇敌为友，我绝不宽恕你．杀尽刘备军．",
 2,"曹操军确实是大军啊．但是以我们的士气也不会输给他们．大哥，现在拼死应战吧．");
 WarModifyAI(15,1);
 WarModifyAI(63,1);
 WarModifyAI(81,1);
 WarShowTarget(true);
 PlayBGM(10);
 NextEvent();
 end,
 [94]=function()
 if WarMeet(3,18) then
 WarAction(1,3,18);
 talk( 3,"出来一战吧！废话少说！有胆子的出来．",
 18,"相当威风啊，我去战他吧．",
 3,"走！");
 WarAction(6,3,18);
 if fight(3,18)==1 then
 talk( 3,"看枪！");
 WarAction(5,3,18);
 talk( 18,"你也吃我一刀．");
 WarAction(5,18,3);
 talk( 3,"再来一刺，接着．");
 WarAction(4,3,18);
 talk( 18,"嗳，好厉害．胜不了他．");
 WarAction(16,18);
 talk( 3,"要逃吗，太狡猾了．乾脆认输吧．");
 WarLvUp(GetWarID(3));
 else
 talk( 3,"嗳，好厉害．胜不了他．");
 WarAction(17,3);
 WarLvUp(GetWarID(18));
 end
 end
 if (not GetFlag(1007)) and War.Turn==4 then
 PlayBGM(11);
 talk( 9,"哼，这种战斗力还能打仗吗？再狠狠地给我杀．");
 WarModifyAI(61,1);
 WarModifyAI(115,1);
 WarModifyAI(19,1);
 WarModifyAI(258,1);
 WarModifyAI(276,1);
 WarModifyAI(293,1);
 SetFlag(1007,1);
 PlayBGM(10);
 end
 if (not GetFlag(1008)) and War.Turn==8 then
 PlayBGM(11);
 talk( 9,"不陪你们玩了，众将士，全面出击！",
 1,"嗳，不愧是曹操军……");
 WarModifyAI(8,1);
 WarModifyAI(68,1);
 WarModifyAI(16,1);
 WarModifyAI(17,1);
 WarModifyAI(294,1);
 WarModifyAI(329,1);
 WarModifyAI(348,1);
 WarModifyAI(349,1);
 SetFlag(1008,1);
 PlayBGM(10);
 end
 if (not GetFlag(1009)) and War.Turn==10 then
 PlayBGM(11);
 talk( 9,"什么！陈留遭吕布偷袭！坏了，忘了吕布的事．嗳，没办法．全军撤退！陶谦、刘备暂且留着你们的命！");
 WarAction(16,9);
 SetFlag(1009,1);
 PlayBGM(7);
 DrawMulitStrBox("　曹操军撤退了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 talk( 9,"混蛋！再组织进攻！什么！陈留遭吕布偷袭！坏了！看来使陈留防守空虚是下策．嗳……没办法．全军撤退！陶谦、刘备暂且留着你们的命！");
 PlayBGM(7);
 DrawMulitStrBox("　曹操军撤退了．");
 GetMoney(300);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金３００．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 --WarLocationItem(4,20,135,513); --获得道具:鞭
 --WarLocationItem(9,15,123,514); --获得道具:流星锤
 end,
 [95]=function()
 JY.Smap={};
 SetSceneID(0,11);
 talk( 9,"全军马上折回，保住陈留！快！");
 SetSceneID(0);
 talk( 3,"嗳？曹操怎么突然逃跑了？",
 1,"不知道．不过，徐州得救可是真的．先回徐州吧．");
 --读入第<10>段指令
 NextEvent(98); --goto 98
 end,
 [96]=function()
 JY.Smap={};
 JY.Base["现在地"]="徐州";
 JY.Base["道具屋"]=0;
 AddPerson(9,25,9,1);
 AddPerson(69,11,10,3);
 AddPerson(62,7,12,3);
 AddPerson(17,24,17,2);
 AddPerson(18,20,19,2);
 SetSceneID(63,11);
 DrawStrBoxCenter("曹操军营帐");
 AddPerson(369,2,20,0);
 MovePerson(369,7,0);
 talk( 369,"主公，不得了啦．吕布进攻陈留了．",
 9,"什么？怎么会这样．坏了，太大意了．吕布这个畜生，乘我不在来偷袭．");
 AddPerson(367,4,21,0);
 MovePerson(367,7,0);
 talk( 367,"一个叫张飞的人前来请求停战，怎么办？",
 9,"张飞？刘备的那个盟弟呀．刘备请求停战？嗳，真是天助我也．告诉张飞，我接受停战．好，快速返回陈留，把吕布从陈留赶出去．");
 NextEvent();
 end,
 [97]=function()
 JY.Smap={};
 SetSceneID(0,11);
 talk( 9,"不能让吕布把陈留夺去．快速返回！");
 SetSceneID(0);
 talk( 3,"不过，曹操为什么撤退了？要是我的话就绝对进攻啦．",
 1,"不知道，可是徐州得救是实实在在的．还是回城吧．");
 SetFlag(97,1);
 NextEvent(98);
 end,
 [98]=function()
 JY.Smap={};
 JY.Base["现在地"]="徐州";
 JY.Base["道具屋"]=6;
 AddPerson(16,25,9,1);
 AddPerson(64,14,9,3);
 AddPerson(65,10,11,3);
 AddPerson(66,25,15,2);
 AddPerson(1,5,19,0);
 AddPerson(2,3,18,0);
 AddPerson(3,7,20,0);
 SetSceneID(86,5);
 DrawStrBoxCenter("徐州议事厅");
 MovePerson(1,7,0);
 talk( 16,"刘备，这次你实在帮了大忙．");
 if GetFlag(97) then
 talk( 1,"不，我们什么忙也没帮，只是曹操折回去了．",
 16,"不不，来支援我们的只有你，我现在心情非常高兴．");
 end
 --显示任务目标:<与陶谦等谈话．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [99]=function()
 if JY.Tid==65 then--糜竺
 talk( 65,"谢谢，这样徐州得救了．");
 end
 if JY.Tid==66 then--陈登
 talk( 66,"刘备，谢谢．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"能有今天多亏了刘备．");
 end
 if JY.Tid==2 then--关羽
 talk( 2,"徐州得救太好了．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"还是帮助别人心里舒服．");
 end
 if JY.Tid==16 then--陶谦
 if GetFlag(97) then
 talk( 16,"刘备，这是我的一点心意，请你收下．");
 talk( 1,"这是？",
 16,"这是我们徐州自古传下来的兵器，叫雌雄双剑．",
 1,"您是说把这样贵重的东西给我？",
 16,"我们拿着他也没有意义，因为不能熟练使用，我希望把剑送给真正有用的人使用，请您一定收下．");
 GetItem(1,58);
 end
 talk( 16,"刘备，其实我有事相托．",
 1,"只要我能办到的就一定全力以赴，请您吩咐．",
 16,"谢谢，我想把小沛托给你治理．",
 1,"什么？我这样的人实在担不起如此大任．",
 16,"不，这是要臣们商量的结果，希望你能帮助徐州的百姓，请接受吧．",
 1,"我明白，那就恭敬不如从命了．",
 16,"您接受了，好，你带孙乾去，孙乾很有才干，你可以用他．");
 NextEvent();
 end
 end,
 [100]=function()
 if JY.Tid==65 then--糜竺
 talk( 65,"小沛就拜托你们了．");
 end
 if JY.Tid==66 then--陈登
 talk( 66,"刘备，谢谢．");
 end
 if JY.Tid==16 then--陶谦
 talk( 16,"带孙乾去小沛好啦．");
 end
 if JY.Tid==2 then--关羽
 talk( 2,"大哥，那就去小沛吧．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，那就去小沛吧．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"刘备，不，主公，今后请多关照．");
 ModifyForce(64,1);
 PlayWavE(11);
 DrawStrBoxCenter("孙乾成为刘备部下！");
 talk( 64,"马上去小沛吧，小沛是徐州西南的一个小镇．");
 JY.Smap={};
 SetSceneID(0);
 talk( 64,"我带你们去小沛．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [101]=function()
 JY.Smap={};
 JY.Base["现在地"]="小沛";
 JY.Base["道具屋"]=7;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(64,11,16,0);
 AddPerson(54,17,13,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("小沛议事厅");
 --显示任务目标:<与赵云等探讨今后之事．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [102]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，城主说我们接受此城太好了，这样我们也有城了．");
 end
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，我们都很高兴，终于有了一个自己的城．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"主公，今后请多关照．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"刘备，徐州之围好像已解，我想回公孙瓒那里．",
 1,"是吗？赵云，这次你帮了大忙，我相信我们还能在一起为朝廷出力．");
 ModifyForce(54,0);
 talk( 2,"赵云，希望再见到你．",
 3,"你虽不像我这样厉害，但也相当了不起，希望还能见到你．",
 54,"不胜感谢，我也还想和大家在一起建功立业，请多珍重．",
 3,"今晚是赵云的欢送会，喝！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 --第一章　饿虎吕布来访
 [103]=function()
 SetSceneID(-1,0);
 JY.Base["章节名"]="第一章　饿虎吕布来访";
 DrawStrBoxCenter("第一章　饿虎吕布来访");
 LoadPic(6,1);
 DrawMulitStrBox("　刘备在小沛落脚时，吕布和曹操正在陈留打仗，吕布想拿下陈留，作为自己的落脚之处．可是，最初的形势虽然对吕布有利，但在曹操的计谋下，吕布又吃了败仗，吕布军又成了流浪军．");
 LoadPic(6,2);
 JY.Smap={};
 JY.Base["现在地"]="小沛";
 JY.Base["道具屋"]=7;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(64,11,16,0);
 SetSceneID(54,5);
 DrawStrBoxCenter("小沛议事厅");
 talk( 2,"大哥，曹操打败了吕布，吕布好像四处流浪．",
 3,"他活该，这是对他以前在汉都花天酒地的报应．",
 64,"可是，吕布今后怎么办呢？他又没有自己的领地．",
 1,"……");
 AddPerson(83,1,5,3);
 MovePerson(83,7,3);
 talk( 83,"主公，我视察完城内回来了．");
 --显示任务目标:<听简雍汇报．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [104]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，请听简雍汇报．");
 end
 if JY.Tid==2 then--关羽
 talk( 2,"大哥，请听简雍汇报．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"主公，请听简雍汇报．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"据城内百姓说，小沛这个地方经常有山贼出没．",
 64,"是这样没错，我们也几次想扫平这群山贼．",
 83,"我们来此地时间尚短，要想得到民心，其中之一就是扫平附近的山贼．",
 1,"正是，那么草寇躲在哪里？孙乾，你知道些什么？",
 64,"山贼躲在泰山﹑夏丘﹑彭城三个地方．",
 1,"是泰山﹑夏丘﹑彭城，好，出兵去扫平山贼．",
 2,"大哥，作出征准备吧．");
 --显示任务目标:<扫平山贼．>
 NextEvent();
 end
 end,
 [105]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，快出征吧，几个毛贼要是遇到我，不费吹灰之力就可以收拾他们．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"尽管是山贼草寇，也不可大意，败给他们可难堪了．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"不能让山贼草寇如此猖獗，平贼刻不容缓．");
 end
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"准备好了吗？") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [106]=function()
 JY.Smap={};
 SetSceneID(0,3);
 talk( 2,"大哥，去哪里？");
 NextEvent();
 end,
 [107]=function()
 local menu={
 {" 回小沛城",nil,1},
 {"　去泰山",nil,1},
 {"　去彭城",nil,1},
 {"　去夏丘",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 local n=0;
 if GetFlag(8) then
 n=n+1;
 end
 if GetFlag(9) then
 n=n+1;
 end
 if GetFlag(10) then
 n=n+1;
 end
 if r==1 then
 if n==0 then
 talk( 2,"大哥，一个草寇都没消灭，我们快扫平草寇吧．");
 elseif n<3 then
 if talkYesNo( 2,"大哥，草寇没消灭乾净，行吗？") then
 NextEvent(121); --goto 121
 else
 talk( 2,"请再一次选定进军目标．");
 end
 else
 NextEvent(121); --goto 121
 end
 elseif r==2 then
 if GetFlag(8) then
 talk( 2,"泰山草寇已被扫平了，我们去打别的地方吧．");
 else
 talk( 2,"明白了，去泰山．");
 SetSceneID(0);
 NextEvent(108); --goto 108
 end
 elseif r==3 then
 if GetFlag(9) then
 talk( 2,"彭城草寇已被扫平了，我们去打别的地方吧．");
 else
 talk( 2,"明白了，去彭城．");
 SetSceneID(0);
 NextEvent(112); --goto 112
 end
 elseif r==4 then
 if GetFlag(10) then
 talk( 2,"夏丘草寇已被扫平了，我们去打别的地方吧．");
 else
 talk( 2,"明白了，去夏丘．");
 SetSceneID(0);
 NextEvent(116); --goto 116
 end
 end
 end,
 [108]=function()
 talk( 2,"请列队．");
 PlayBGM(12);
 WarIni();
 DefineWarMap(10,"第一章 泰山之战","一、全数歼灭敌人．*二、敌军投降．",40,0,-1);
 SelectTerm(1,{
 0,23,11, 3,0,-1,0,
 -1,22,11, 3,0,-1,0,
 -1,22,12, 3,0,-1,0,
 -1,24,10, 3,0,-1,0,
 -1,25,10, 3,0,-1,0,
 -1,25,11, 3,0,-1,0,
 -1,21,10, 3,0,-1,0,
 });
 SelectEnemy({
 375,4,2, 4,2,12,14, 0,0,-1,0,
 310,26,1, 4,4,10,10, 29,6,-1,0,
 311,14,5, 4,1,10,10, 0,0,-1,0,
 312,15,5, 4,1,8,10, 0,0,-1,0,
 313,9,2, 4,0,10,10, 0,0,-1,0,
 314,7,1, 4,0,8,10, 0,0,-1,0,
 315,4,1, 4,0,7,10, 0,0,-1,0,
 316,5,2, 4,0,7,10, 0,0,-1,0,
 332,25,2, 4,4,8,14, 29,6,-1,0,
 333,5,1, 4,0,8,14, 0,0,-1,0,
 336,24,3, 4,4,10,15, 29,6,-1,0,
 337,8,3, 4,0,9,15, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [109]=function()
 talk( 376,"怎么要和刘备打仗？这将酿成我的终身错事，还是投降吧．",
 3,"贼将们，快出来让我消遣一下，最近我身体都有些不灵活了．");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [110]=function()
 if (not GetFlag(1010)) and War.Turn==3 then
 talk( 64,"主公，据说此地贼兵是由一女将率领．",
 3,"什么？是女人？",
 1,"你是说女贼首？真勇敢．",
 3,"大哥你去劝降，设法交个朋友，嘿嘿！",
 1,"你在想什么？",
 376,"即使来人是鼎鼎大名的刘备，我也要摆出首领的架子，给我打．");
 WarModifyAI(310,1);
 WarModifyAI(313,1);
 WarModifyAI(314,1);
 WarModifyAI(332,1);
 WarModifyAI(333,1);
 WarModifyAI(336,1);
 WarModifyAI(337,1);
 SetFlag(1010,1);
 end
 if WarMeet(1,376) then
 PlayBGM(11);
 WarAction(1,1,376);
 talk( 376,"刘备，你得能打赢我吗？");
 WarAction(5,376,1);
 if fight(1,376)==1 then
 talk( 376,"哦，不行，我还是不能向刘备动手，我想归顺你们，刘备，刚才我错了．");
 ModifyForce(376,1);
 PlayWavE(11);
 DrawStrBoxCenter("李明加入刘备军！");
 SetFlag(11,1);
 WarLvUp(GetWarID(1));
 NextEvent();
 else
 JY.Status=GAME_WARLOSE;
 PlayBGM(4);
 WarDelay(4);
 WarLastWords(GetWarID(1));
 WarAction(18,GetWarID(1));
 end
 end
 if JY.Status==GAME_WARWIN then
 NextEvent();
 end
 WarLocationItem(0,10,35,12); --获得道具:获得道具：落石书
 WarLocationItem(8,8,34,188); --获得道具:获得道具：炸弹
 --WarLocationItem(11,13,140,515); --获得道具:皮甲
 --WarLocationItem(3,17,147,516); --获得道具:手牌
 end,
 [111]=function()
 PlayBGM(7);
 DrawMulitStrBox("　刘备军扫平泰山草寇．");
 GetMoney(400);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金４００．");
 SetFlag(8,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(120); --goto 120
 end,
 [112]=function()
 talk( 2,"请列队．");
 PlayBGM(12);
 WarIni();
 DefineWarMap(12,"第一章 彭城之战","一、全数歼灭敌人．*二、敌军投降．",30,0,-1);
 SelectTerm(1,{
 0,7,15, 4,0,-1,0,
 -1,6,14, 4,0,-1,0,
 -1,5,14, 4,0,-1,0,
 -1,5,15, 4,0,-1,0,
 -1,8,14, 4,0,-1,0,
 -1,8,15, 4,0,-1,0,
 -1,9,15, 4,0,-1,0,
 });
 SelectEnemy({
 223,19,2, 3,2,12,10, 0,0,-1,0,
 310,17,4, 3,0,10,10, 0,0,-1,0,
 311,18,4, 3,0,10,10, 0,0,-1,0,
 312,4,2, 4,4,6,10, 16,5,-1,0,
 313,5,3, 4,4,6,10, 17,5,-1,0,
 314,6,3, 4,1,8,10, 0,0,-1,0,
 315,6,4, 4,1,7,10, 0,0,-1,0,
 332,18,2, 3,0,8,14, 0,0,-1,0,
 292,16,5, 3,1,6,7, 0,0,-1,0,
 293,18,5, 3,1,5,7, 0,0,-1,0,
 294,2,1, 4,1,6,7, 0,0,-1,0,
 295,3,2, 4,1,6,7, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [113]=function()
 talk( 224,"刘备是从平定黄巾之乱时开始强大的，现在还是乖乖地投降他好．",
 3,"大哥，贼也是人，如果对他们晓之以理或许会改邪归正．",
 1,"知道了，试试看吧．");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [114]=function()
 if WarMeet(1,224) then
 PlayBGM(11);
 WarAction(1,1,224);
 talk( 224,"刘备，你得能打赢我吗？");
 WarAction(5,224,1);
 if fight(1,224)==1 then
 talk( 224,"刘备，以兵刃相见，对不起了，今后我想改过自新，追随您．");
 ModifyForce(224,1);
 PlayWavE(11);
 DrawStrBoxCenter("赵何加入刘备军！");
 SetFlag(13,1);
 WarLvUp(GetWarID(1));
 NextEvent();
 else
 JY.Status=GAME_WARLOSE;
 PlayBGM(4);
 WarDelay(4);
 WarLastWords(GetWarID(1));
 WarAction(18,GetWarID(1));
 end
 end
 if JY.Status==GAME_WARWIN then
 NextEvent();
 end
 WarLocationItem(12,16,19,14); --获得道具:获得道具：剑术指南书
 --WarLocationItem(8,4,75,517); --获得道具:钢刀
 --WarLocationItem(6,16,81,518); --获得道具:板斧
 end,
 [115]=function()
 PlayBGM(7);
 DrawMulitStrBox("　刘备军讨伐彭城之贼．");
 GetMoney(400);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金４００．");
 SetFlag(9,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(120); --goto 120
 end,
 [116]=function()
 talk( 2,"请点派军队．");
 PlayBGM(12);
 WarIni();
 DefineWarMap(11,"第一章 夏丘之战","一、全数歼灭敌人．*二、敌军投降．",30,0,-1);
 SelectTerm(1,{
 0,23,15, 3,0,-1,0,
 -1,23,16, 3,0,-1,0,
 -1,24,15, 3,0,-1,0,
 -1,22,15, 3,0,-1,0,
 -1,23,14, 3,0,-1,0,
 -1,24,17, 3,0,-1,0,
 -1,25,16, 3,0,-1,0,
 });
 SelectEnemy({
 228,3,3, 4,4,12,10, 5,9,-1,0,
 310,4,2, 4,4,10,10, 6,8,-1,0,
 311,4,4, 4,4,10,10, 6,10,-1,0,
 312,5,3, 4,4,9,10, 8,8,-1,0,
 313,6,3, 4,4,9,10, 8,9,-1,0,
 314,6,4, 4,4,8,10, 8,10,-1,0,
 315,15,5, 4,1,8,10, 0,0,-1,0,
 316,17,5, 4,1,7,10, 0,0,-1,0,
 317,16,6, 4,1,7,10, 0,0,-1,0,
 336,9,7, 4,1,11,15, 0,0,-1,0,
 337,7,9, 4,1,11,15, 0,0,-1,0,
 274,8,8, 4,1,10,4, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [117]=function()
 talk( 229,"不妙，如果是陶谦的军队还可以打赢．可是刘备的军队不好对付，别打了，还是投降吧．",
 83,"主公，讨贼吧，只有这样才能消灭这些害人精．");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [118]=function()
 if WarMeet(1,229) then
 PlayBGM(11);
 WarAction(1,1,229);
 talk( 229,"刘备，你得能打赢我吗？");
 WarAction(5,229,1);
 if fight(1,229)==1 then
 talk( 229,"坏了，怎么会是令人闻风丧胆的刘备？我实在是打不了，刘备，我投降．");
 ModifyForce(229,1);
 PlayWavE(11);
 DrawStrBoxCenter("董梁加入刘备军！");
 SetFlag(15,1);
 WarLvUp(GetWarID(1));
 NextEvent();
 else
 JY.Status=GAME_WARLOSE;
 PlayBGM(4);
 WarDelay(4);
 WarLastWords(GetWarID(1));
 WarAction(18,GetWarID(1));
 end
 end
 if JY.Status==GAME_WARWIN then
 NextEvent();
 end
 WarLocationItem(0,7,38,16); --获得道具:获得道具：漩涡书
 --WarLocationItem(11,20,130,519); --获得道具:铜锣
 --WarLocationItem(9,8,126,520); --获得道具:鼓角
 end,
 [119]=function()
 PlayBGM(7);
 DrawMulitStrBox("　刘备部队扫平夏丘草寇．");
 GetMoney(400);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金４００．");
 SetFlag(10,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(120); --goto 120
 end,
 [120]=function()
 JY.Smap={};
 SetSceneID(0,3);
 if GetFlag(8) and GetFlag(9) and GetFlag(10) then
 talk( 2,"大哥，贼兵已全部消灭，我们回小沛吧．");
 NextEvent(121); --goto 121
 else
 talk( 2,"大哥，去哪里呢");
 NextEvent(107); --goto 107
 end
 end,
 [121]=function()
 JY.Smap={};
 JY.Base["现在地"]="小沛";
 JY.Base["道具屋"]=7;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(64,11,16,0);
 AddPerson(83,9,15,0);
 SetSceneID(54,5);
 DrawStrBoxCenter("小沛议事厅");
 talk( 2,"小沛的百姓说要谢谢大哥．");
 AddPerson(355,1,5,3);
 MovePerson(355,7,3);
 talk( 355,"刘备，您为我们消灭了山贼，谢谢，现在我们可以放心地外出走动了．这是我们本地百姓的一点意思，请笑纳．");
 if GetFlag(8) then
 GetMoney(500);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金５００．");
 end
 if GetFlag(9) then
 GetItem(1,17);
 end
 if GetFlag(10) then
 GetItem(1,152); --从39浊流书 改为 152连环铠
 end
 --额外再赠送武道指南书
 if GetFlag(8) and GetFlag(9) and GetFlag(10) then
 GetItem(1,66);
 end
 talk( 355,"刘备，请您以后继续保护小沛，那我告辞了．");
 MovePerson(355,9,2);
 DecPerson(355);
 --显示任务目标:<与关羽等谈话．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [122]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"我们讨完贼，这样小沛总算安定了．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"终究那些小毛贼不是我张飞的对手．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"不可大意，说不定还会有什么变故．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"主公，好像是快使．");
 AddPerson(367,1,5,3);
 MovePerson(367,7,3);
 talk( 367,"刘备，陶谦病情恶化，请马上去徐州．",
 3,"什么？陶谦病重了．",
 64,"知道了，我们马上就去．",
 367,"是，陶谦在徐州官邸，请快些．",
 2,"大哥，快去吧．",
 367,"刘备，请马上去徐州官邸，分秒必争，陶谦快不行了．");
 --显示任务目标:<去徐州陶谦官邸看望陶谦．>
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [123]=function()
 JY.Smap={};
 JY.Base["现在地"]="徐州";
 JY.Base["道具屋"]=6;
 AddPerson(2,7,10,3);
 AddPerson(3,5,11,3);
 AddPerson(1,7,11,3);
 AddPerson(65,19,13,1);
 AddPerson(82,24,16,1);
 SetSceneID(45,2);
 DrawStrBoxCenter("徐州陶谦官邸");
 talk( 65,"哦，刘备，你来得正好，快去见我们主公．");
 MovePerson(1,5,3);
 MovePerson(1,1,0);
 talk( 1,"陶谦，请多保重．");
 talk( 16,"哦，你来得正是时候，刘备，我有话对你讲，我快不行了，所以有件事想求你．",
 1,"什么事？",
 16,"你能不能担任徐州太守呢？",
 1,"这是什么话．");
 talk( 65,"你觉得很突然吧，然而这是要臣们商量决定的．",
 82,"刘备，您是当我们主公最合适的人选，请您保护徐州．");
 MovePerson( 2,4,3,
 3,4,3);
 talk( 2,"兄长，有什么可犹豫的，你就要拥有自己的领地了．",
 3,"陶谦一直在劝你，大哥，快决定吧．");
 talk( 65,"徐州是四面受攻之地，我们觉得与其被敌人夺走，还不如把徐州托付给刘备．",
 82,"刘备，我们求您了．");
 talk( 16,"如能接受我的请求，我也就没什么可牵挂的了，刘备，请你一定要接受．",
 1,"明白了，刘备不才，愿接受．",
 16,"您接受了，谢谢，这样我也没有牵挂了．糜竺，告别了．",
 65,"主公！");
 DrawMulitStrBox("　陶谦去世了．");
 talk( 65,"刘备，您就是我们的主公了．",
 82,"请多关照．");
 LvUp(65,3);
 ModifyForce(65,1);
 if GetFlag(219) then
 LvUp(82,3);
 else
 LvUp(82,4);
 end
 ModifyForce(82,1);
 PlayWavE(11);
 DrawStrBoxCenter("糜竺和糜芳加入．");
 talk( 65,"不能悲痛得无法自拔，刘备，我们先去议事厅，请您也要来．",
 82,"主公，我先走了．");
 MovePerson( 65,2,2,
 82,4,2);
 MovePerson( 65,1,1,
 82,1,1);
 MovePerson( 65,4,2,
 82,4,2);
 DecPerson(65);
 DecPerson(82);
 DrawSMap();
 talk( 2,"我们也去议事厅吧，张飞，走．",
 3,"好．");
 MovePerson( 2,4,2,
 3,4,2);
 DecPerson(2);
 DecPerson(3);
 DrawSMap();
 NextEvent();
 end,
 [124]=function()
 JY.Smap={};
 SetSceneID(-1);
 LoadPic(7,1);
 DrawMulitStrBox("　此时曹操肃清董卓余党，救出献帝，从洛阳迁都许昌，献帝除曹操外别无所依，默默地听从曹操的意见，曹操把持皇帝于手中．");
 DrawMulitStrBox("　对正处于旭日东昇之势的曹操来说，也有令其担心的人，那就是吕布和刘备．");
 LoadPic(7,2);
 JY.Smap={};
 JY.Base["现在地"]="徐州";
 JY.Base["道具屋"]=6;
 AddPerson(1,25,9,1);
 AddPerson(2,14,9,3);
 AddPerson(3,10,11,3);
 AddPerson(65,25,15,2);
 AddPerson(82,21,17,2);
 SetSceneID(86,5);
 DrawStrBoxCenter("徐州议事厅");
 --显示任务目标:<去议事厅研究今后的对策．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [125]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"失去一个很可惜的人．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"为了陶谦一定要守住徐州，是吧，大哥．");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"徐州四面被敌人包围，是个难守的地方．");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"主公，吕布来了．");
 PlayBGM(11);
 AddPerson(5,-5,24,0);
 DrawSMap();
 MovePerson(5,5,0);
 talk( 5,"呀，刘备，久违了，我有点事想要求您．");
 MovePerson(5,5,0);
 AddPerson(76,3,18,0);
 AddPerson(80,7,20,0);
 MovePerson( 76,3,0,
 80,3,0);
 NextEvent();
 end
 end,
 [126]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"是吕布吗？我反对收留吕布．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，对方是那个吕布吗？考虑都不要考虑，吕布之流，见面都没必要．");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"主公，吕布想说的话大概你也知道，我觉得不理他对徐州有利．");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"虽然我也同情吕布现在的状况，但此人毫无信义．");
 end
 if JY.Tid==76 then--陈宫
 talk( 76,"刘备，请你一定要帮助我们．");
 end
 if JY.Tid==80 then--张辽
 talk( 80,"刘备，我们正等着你的好回音．");
 end
 if JY.Tid==5 then--吕布
 talk( 5,"自从我们败给曹操以来，长时间到处流浪，当时听说你在徐州，就来了，请收留我们吧，求求你．");
 NextEvent();
 end
 end,
 [127]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"吕布吗？虽然我不想违背大哥的意愿，但我还是反对．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，对方是那个吕布吗？考虑都不要考虑，吕布之流，见面都没必要．");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"主公，吕布想说的话大概你也知道，我觉得不理他对徐州有利．");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"虽然我也同情吕布现在的状况，但此人毫无信义．");
 end
 if JY.Tid==76 then--陈宫
 talk( 76,"刘备，请您帮助我们．");
 end
 if JY.Tid==80 then--张辽
 talk( 80,"刘备，请给我们一个好的答覆．");
 end
 if JY.Tid==5 then--吕布
 talk( 5,"刘备，请给我们一个好的答覆．",
 1,"我知道了，现在允许你在小沛落脚．",
 5,"啊，谢谢，没想到会得到如此好的答覆，徐州被曹操攻打时，也正因为我们攻打陈留，才能使你稳坐徐州，如此说来，这也是缘份，哈哈！",
 3,"胡说什么？");
 MovePerson(3,1,1);
 MovePerson(3,2,3);
 MovePerson(3,0,0);
 talk( 5,"张飞！",
 3,"你说我大哥和你有缘，胡说八道，我们有这徐州，难道还多亏你，吕布，我们马上决出胜负．");
 MovePerson(2,1,0);
 MovePerson(2,2,3);
 MovePerson(2,2,1);
 talk( 2,"张飞，住手．",
 3,"不要拦我，关羽，我要除掉此害．",
 2,"张飞，你先出去．");
 MovePerson(3,6,1);
 DecPerson(3);
 MovePerson(2,2,0);
 MovePerson(2,2,2);
 MovePerson(2,1,1);
 MovePerson(2,0,3);
 talk( 1,"对不起，我弟弟现在情绪很激动，没事的，请去小沛吧．",
 5,"那我们马上按您的话去小沛．",
 76,"谢谢．");
 MovePerson(5,7,1);
 DecPerson(5);
 MovePerson( 76,4,1,
 80,4,1);
 DecPerson(76);
 DrawSMap();
 talk( 2,"你不是张辽吗？")
 MovePerson(2,1,0);
 MovePerson(2,2,3);
 MovePerson(2,9,1);
 MovePerson(2,0,3);
 MovePerson(80,0,2);
 talk( 80,"关羽，有什么事？",
 2,"我还记得你在虎牢关作战时的英姿，尽管你我是敌人，但你的作战风格让我佩服，可是如此了不起的你怎么会追随吕布呢．",
 80,"事态的变化造成的，可是一旦决定了主人就不能轻易改变，想必这你也知道吧．",
 2,"但是，如果主人有颗正直的心那还行，你觉得吕布有此心吗？",
 80,"我没办法影响吕布，现在也只能做到这样．",
 2,"这样我也无话可说．");
 MovePerson(80,3,1);
 DecPerson(80);
 DrawSMap();
 DrawMulitStrBox("　于是吕布驻紮在小沛，可是这种选择果真正确吗？");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [128]=function()
 JY.Smap={};
 JY.Base["现在地"]="徐州";
 JY.Base["道具屋"]=6;
 AddPerson(1,25,9,1);
 AddPerson(2,14,9,3);
 AddPerson(3,10,11,3);
 AddPerson(65,25,15,2);
 AddPerson(82,21,17,2);
 SetSceneID(86,5);
 DrawStrBoxCenter("徐州议事厅");
 --<研究今后的对策．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [129]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，我不相信吕布．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"绝对不同意，你为什么把这种人留在徐州？");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"吕布连自己的义父都杀，没有信义．");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"哦，主公，孙乾来了．");
 AddPerson(64,5,19,0);
 DrawSMap();
 MovePerson(64,4,0);
 NextEvent();
 end
 end,
 [130]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"孙乾来会有什么事情？");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"绝对不同意，大哥，你为什么把那种人安置在徐州．");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"孙乾来了，听听他的意见吧．");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"先听听孙乾的意见吧．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"主公，有钦差来了，怎么办？",
 2,"钦差，会有什么事呢？大哥，先让到里面吧．",
 1,"里面请．",
 64,"是．");
 MovePerson(64,3,3);
 MovePerson(64,2,1);
 MovePerson(64,0,2);
 AddPerson(365,5,19,0);
 DrawSMap();
 MovePerson(365,5,0);
 NextEvent();
 end
 end,
 [131]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"大哥，请听钦差讲．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"绝对不能同意．");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"主公，请听钦差讲．");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"主公，先听钦差讲吧．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"我没事，先听钦差讲吧．");
 end
 if JY.Tid==365 then--使者
 talk( 365,"你是刘备吗？我是朝廷派来的钦差．",
 1,"是．",
 365,"皇帝有旨，命讨伐淮南袁术，可以吗？",
 1,"是，遵旨．",
 365,"那么，我还有其他事，就此告辞了．");
 MovePerson(365,6,1);
 DecPerson(365);
 NextEvent();
 end
 end,
 [132]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"按大哥的意思办．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"袁术不足挂齿，大哥，决定了就快出兵吧．");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"我们都是首次参战，让我们奋力杀敌吧．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"可是，皇帝为什么现在要下旨讨伐袁术呢？");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"主公，这道圣旨里面会不会有问题？",
 1,"大概这是曹操的主意，现在皇帝在曹操的庇护下，所以可以理解为这是曹操的命令．但圣旨难违呀．",
 65,"是啊，着手准备出兵吧．");
 --显示任务目标:<进军淮南，讨伐袁术．>
 NextEvent();
 end
 end,
 [133]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"袁术不足挂齿，大哥，决定了就快出兵吧．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"既然决定出兵，也只好服从了．");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"准备出兵了．");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"我们都是首次参战，让我们奋力杀敌吧．");
 end
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"准备好了吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 2,"请点兵派将．");
 WarIni();
 DefineWarMap(13,"第一章 淮南之战","一、全数歼灭敌人．",30,0,-1);
 SelectTerm(1,{
 0,14,5, 1,0,-1,0,
 -1,15,4, 1,0,-1,0,
 -1,15,6, 1,0,-1,0,
 -1,13,6, 1,0,-1,0,
 -1,13,4, 1,0,-1,0,
 -1,16,5, 1,0,-1,0,
 -1,12,5, 1,0,-1,0,
 -1,12,3, 1,0,-1,0,
 -1,14,3, 1,0,-1,0,
 });
 DrawSMap();
 talk( 2,"出兵．");
 JY.Smap={};
 SetSceneID(0,3);
 talk( 3,"好，进军袁术所在的淮南，我的胳膊都痒了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [134]=function()
 JY.Smap={};
 JY.Base["现在地"]="淮南";
 JY.Base["道具屋"]=0;
 AddPerson(12,29,7,1);
 AddPerson(43,14,9,3);
 AddPerson(27,12,10,3);
 AddPerson(71,10,11,3);
 AddPerson(70,25,15,2);
 AddPerson(102,23,16,2);
 AddPerson(72,21,17,2);
 SetSceneID(92,11);
 DrawStrBoxCenter("淮南议事厅");
 DrawMulitStrBox("　皇帝宣旨讨伐袁术是有其原因的，因为袁术自封皇帝．袁术拿到了皇帝的玉玺，自封为皇帝，在淮南过着奢侈糜烂的生活．");
 talk( 70,"刘备军已经打过来了，主公，怎么办？",
 12,"刘备小儿也想夺我的领土，也太狂妄自大了吧，袁胤，有何良策？");
 talk( 43,"有．",
 12,"哦，是什么？快说．",
 43,"是，现在吕布受刘备保护，驻紮在小沛，所以让吕布袭击刘备的背后．",
 12,"什么？你说挑动吕布？可是吕布会像你说的那样做吗？他不是正受刘备的照顾吗？",
 43,"可是，如我们说服得好，吕布肯定会动手的．");
 talk( 70,"对，因为董卓那么照顾他，他都背叛了．",
 12,"好，快安排吧，马上派使者送信去．",
 43,"是．");
 NextEvent();
 end,
 [135]=function()
 JY.Smap={};
 JY.Base["现在地"]="小沛";
 JY.Base["道具屋"]=7;
 AddPerson(5,25,17,2);
 AddPerson(76,22,10,1);
 AddPerson(75,20,9,1);
 AddPerson(73,18,8,1);
 AddPerson(80,11,16,0);
 AddPerson(81,9,15,0);
 AddPerson(74,7,14,0);
 SetSceneID(54,11);
 DrawStrBoxCenter("小沛议事厅");
 talk( 74,"袁术来信是怎么讲的？",
 5,"唉．");
 DrawMulitStrBox("『原只是个农民的刘备，鬼迷心窍想占领我的领地，您不会允许吧，您应该从此贼手中夺回徐州，让这个狂妄自大的家伙知道自己的愚蠢．定当以厚礼相赠．*　　　　　　　　　　　　　　袁术』");
 talk( 75,"送一封这样的信来，袁术好像很慌乱．",
 80,"这封信口气好像很专横，看来事到如此境地，还摆什么臭架子．",
 76,"可是，主公，此事应仔细考虑呀．",
 5,"什么？怎么回事？");
 talk( 76,"现在徐州空虚，我们应乘此间隙夺取徐州，在那里组建精锐部队．",
 5,"可是，刘备收留了我们，那样会……",
 76,"时为战乱之秋，主公，要得到天下，这可是不会再有的机会了．",
 5,"明白了．集合部队，去徐州．");
 talk( 80,"可是，刘备于我们有恩，这不是背叛吗？");
 talk( 76,"那你是说让主公作为刘备的客人渡过一生．");
 talk( 75,"对呀，和主公一起打天下吧．",
 80,"……",
 5,"不必再说，全军马上向徐州进发．");
 talk( 81,"……张辽，你的心情我知道，然而这是战乱之秋，没办法．");
 talk( 80,"战乱之秋……");
 NextEvent();
 end,
 [136]=function()
 SelectEnemy({
 69,2,20, 4,0,18,8, 0,0,-1,0,
 66,17,20, 4,0,15,2, 0,0,-1,0,
 71,4,19, 4,0,14,1, 0,0,-1,0,
 256,15,20, 4,0,11,1, 0,0,-1,0,
 257,6,21, 4,0,11,1, 0,0,-1,0,
 292,9,20, 4,0,11,7, 0,0,-1,0,
 293,4,21, 4,0,11,7, 0,0,-1,0,
 274,18,19, 4,0,11,4, 0,0,-1,0,
 275,16,19, 4,0,10,4, 0,0,-1,0,
 276,3,18, 4,0,11,4, 0,0,-1,0,
 328,1,21, 4,0,11,13, 0,0,-1,0,
 336,7,19, 4,0,11,15, 0,0,-1,0,
 
 75,11,1, 1,1,18,5, 0,0,-1,1,
 79,11,2, 1,1,17,24, 0,0,-1,1,
 72,11,3, 1,1,14,14, 0,0,-1,1,
 73,12,1, 1,1,14,1, 0,0,-1,1,
 74,10,2, 1,1,14,4, 0,0,-1,1,
 294,9,0, 1,1,11,7, 0,0,-1,1,
 295,11,0, 1,1,10,7, 0,0,-1,1,
 296,13,0, 1,1,11,7, 0,0,-1,1,
 337,13,2, 1,1,11,15, 0,0,-1,1,
 258,9,1, 1,1,10,1, 0,0,-1,1,
 310,14,1, 1,1,11,10, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [137]=function()
 PlayBGM(11);
 talk( 70,"哼，我家主公岂能被刘备这贩履小儿轻视，让他看看我的厉害．",
 2,"袁术好像没有亲征，小心他耍什么花招．");
 WarShowTarget(true);
 PlayBGM(10);
 NextEvent();
 end,
 [138]=function()
 if (not GetFlag(1011)) and War.Turn==6 then
 PlayBGM(11);
 talk( 65,"主公，刚才徐州来人急报，说徐州已被吕布占领．",
 3,"什么？畜生，吕布你这个混蛋，竟然恩将仇报，我决不饶你．大哥，让我去战吕布，我一定杀了这个混蛋．",
 2,"兄长，吕布军来了．");
 WarShowArmy(75);
 WarShowArmy(79);
 WarShowArmy(72);
 WarShowArmy(73);
 WarShowArmy(74);
 WarShowArmy(294);
 WarShowArmy(295);
 WarShowArmy(296);
 WarShowArmy(337);
 WarShowArmy(258);
 WarShowArmy(310);
 WarModifyAI(69,4,8,19);
 WarModifyAI(71,4,13,19);
 WarModifyAI(257,4,12,20);
 WarModifyAI(292,4,10,18);
 WarModifyAI(293,4,10,20);
 WarModifyAI(328,4,10,19);
 WarModifyAI(336,4,14,17);
 WarModifyAI(276,4,12,18);
 DrawStrBoxCenter("出现了吕布军．");
 talk( 76,"这场战争，将影响到主公的一生，众将，向刘备发动总攻．",
 80,"……",
 70,"好，此战必胜．",
 2,"大哥，寡不敌众，没法打，现在只好撤退．",
 64,"先去许昌投靠曹操吧．",
 83,"如果逃往许昌的路上，敌人就不会追过来了，去西北的鹿砦吧．");
 War.WarTarget="一、全数歼灭敌人．*二、刘备到达西北鹿砦．";
 WarShowTarget(false);
 PlayBGM(10);
 SetFlag(1011,1);
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("　刘备打破纪灵率领的袁术军．");
 GetMoney(400);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金４００．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if (not GetFlag(151)) and WarCheckArea(0,10,3,13,9) then
 talk( 1,"简雍说的鹿砦就是这个吧，马上就到了，总算逃出去了．");
 WarModifyAI(69,3,0);
 WarModifyAI(66,3,0);
 WarModifyAI(71,3,0);
 WarModifyAI(256,3,0);
 WarModifyAI(257,3,0);
 WarModifyAI(292,3,0);
 WarModifyAI(293,3,0);
 WarModifyAI(274,3,0);
 WarModifyAI(275,3,0);
 WarModifyAI(276,3,0);
 WarModifyAI(328,3,0);
 WarModifyAI(336,3,0);
 WarModifyAI(75,3,0);
 WarModifyAI(79,3,0);
 WarModifyAI(72,3,0);
 WarModifyAI(73,3,0);
 WarModifyAI(74,3,0);
 WarModifyAI(294,3,0);
 WarModifyAI(295,3,0);
 WarModifyAI(296,3,0);
 WarModifyAI(337,3,0);
 WarModifyAI(258,3,0);
 WarModifyAI(310,3,0);
 SetFlag(151,1);
 end
 if WarCheckLocation(0,2,0) then
 PlayBGM(4);
 DrawMulitStrBox("　刘备军逃离的战场．");
 WarGetExp();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 WarLocationItem(22,2,68,70); --获得道具:获得道具：猛火书 改为 操兽指南书 --SFC此处获得 弯弓？
 if WarMeet(2,80) then
 WarAction(1,2,80);
 talk( 2,"张辽，吕布作出如此下流之事，难道你还想追随他？",
 80,"不必多言，关羽，来吧！",
 2,"没办法，此人虽然杀之可惜……");
 talk( 2,"我来了，张辽．",
 80,"啊！");
 WarAction(6,2,80);
 if fight(2,80)==1 then
 talk( 2,"不愧是张辽，但此招躲得过吗？");
 WarAction(8,2,80);
 talk( 80,"噢，不愧是关羽，今天我算败给你了．",
 2,"张辽，想逃跑吗？站住！");
 talk( 80,"撤退，我不想和关羽交战．");
 WarAction(16,80);
 WarLvUp(GetWarID(2));
 else
 talk( 2,"不愧是张辽，为什么偏偏要跟着刘备．");
 WarAction(16,2);
 WarLvUp(GetWarID(80));
 talk( 80,"撤退，我不想和刘备军交战．");
 WarAction(16,80);
 end
 end
 end,
 [139]=function()
 JY.Smap={};
 SetSceneID(0,3);
 talk( 3,"吕布，这个畜生，大哥，关羽，我马上返回徐州，去杀吕布．",
 2,"不可，现在返回徐州就得打仗，敌人的精兵强将，我们打不过．兄长，现今还是去许昌投靠曹操吧．",
 1,"也只好这样了，去许昌．");
 NextEvent();
 end,
 [140]=function()
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(9,25,9,1);
 AddPerson(69,14,9,3);
 AddPerson(78,12,10,3);
 AddPerson(19,10,11,3);
 AddPerson(62,25,15,2);
 AddPerson(17,23,16,2);
 AddPerson(1,3,20,0);
 SetSceneID(85,5);
 DrawStrBoxCenter("许昌议事厅");
 talk( 9,"哦，刘备，这次落难了．");
 MovePerson(1,7,0);
 --显示任务目标:<与曹操就今后问题进行研究．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [141]=function()
 if JY.Tid==69 then--荀彧
 talk( 69,"这次落难了．");
 end
 if JY.Tid==62 then--郭嘉
 talk( 62,"我很体谅你失去徐州的心情．");
 end
 if JY.Tid==78 then--程昱
 talk( 78,"那是一场很艰苦的作战吧．");
 end
 if JY.Tid==17 then--夏侯惇
 talk( 17,"被吕布出卖了吧，吕布简直是个毫无信义的人．");
 end
 if JY.Tid==19 then--曹仁
 talk( 19,"吕布和袁术不敢打到这里来．");
 end
 if JY.Tid==9 then--曹操
 talk( 9,"听起来，你是被吕布出卖了，徐州也丢了，我很同情你的处境，关羽怎么样了？",
 1,"关羽和张飞都在城外候着，我们现在连住处都没有，是含羞前来投靠，请您关照．",
 9,"唉，你们放心地住在许昌吧，大家长途跋涉很累了吧，快去官邸休息吧．");
 --显示任务目标:<在官邸休息．>
 NextEvent();
 end
 end,
 [142]=function()
 if JY.Tid==69 then--荀彧
 talk( 69,"这次落难了．");
 end
 if JY.Tid==62 then--郭嘉
 talk( 62,"我很体谅你失去徐州的心情．");
 end
 if JY.Tid==78 then--程昱
 talk( 78,"官邸在城内．");
 end
 if JY.Tid==17 then--夏侯惇
 talk( 17,"被吕布出卖了吧，吕布简直是个毫无信义的人．");
 end
 if JY.Tid==19 then--曹仁
 talk( 19,"吕布和袁术不敢打到这里来．");
 end
 if JY.Tid==9 then--曹操
 talk( 9,"不要客气，快去官邸休息吧．",
 1,"谢谢．");
 MovePerson(1,12,1);
 DecPerson(1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [143]=function()
 SetSceneID(85,11);
 talk( 78,"主公，刘备可是个有雄才大略的英雄．",
 69,"我想还是趁此机会除掉刘备．",
 19,"关羽和张飞都不在吕布之下，他们也许会成为后患．",
 9,"……",
 62,"不行，我反对这一想法，今若杀掉刘备，世人会如何说主公呢？",
 17,"对呀，杀前来投奔之人，会影响主公的威望．",
 9,"说得好，莫如对处于逆境的刘备施以恩德．",
 69,"不过，主公，刘备毫无疑问是个危险人物，一但有机会，最好除掉他．",
 9,"我知道，刘备最怕的是我．");
 NextEvent();
 end,
 --第一章　讨伐吕布之战
 [144]=function()
 SetSceneID(-1,0);
 JY.Base["章节名"]="第一章　讨伐吕布之战";
 DrawStrBoxCenter("第一章　讨伐吕布之战");
 LoadPic(8,1);
 DrawMulitStrBox("　刘备寄身于曹操之下，图谋再起，可是刘备的这种处境，只是曹操害怕刘备和吕布联手所策划的一个计谋．");
 LoadPic(8,2);
 JY.Smap={};
 SetSceneID(0);
 DrawMulitStrBox("　敌人只剩下吕布一个了，曹操非常高兴，便马上动身讨伐吕布，曹操和刘备联军攻克了小沛，在小沛又开始研究下一步作战．");
 NextEvent();
 end,
 [145]=function()
 JY.Smap={};
 JY.Base["现在地"]="徐州";
 JY.Base["道具屋"]=6;
 AddPerson(5,25,9,1);
 AddPerson(76,14,9,3);
 AddPerson(75,10,11,3);
 AddPerson(73,4,14,3);
 AddPerson(80,25,15,2);
 AddPerson(81,21,17,2);
 AddPerson(74,15,20,2);
 SetSceneID(86,11);
 DrawStrBoxCenter("徐州议事厅");
 DrawMulitStrBox("　丢掉小沛的吕布，在徐州研究今后的对策．");
 talk( 5,"唉，不只曹操，还有刘备也攻过来了，陈宫，如何是好？");
 MovePerson(76,1,0);
 MovePerson(76,2,3);
 MovePerson(76,0,0);
 talk( 76,"现在整顿兵马，首先在通往徐州的路上布置兵马．",
 5,"嗯，布署在夏丘和彭城，是吗？",
 76,"对，在那里布署兵马，我们要争取时间．另外，徐州不适合防守，所以要把大本营移至位于徐州南面的下邳．",
 5,"下邳？",
 76,"是的，下邳非常坚固，四周有很深的护城河，我们在那里对抗曹操军．",
 5,"知道了，我们就移往下邳，还有，张辽！高顺！",
 80,"在！",
 73,"在！");
 MovePerson( 80,3,1,
 73,2,0);
 MovePerson( 80,2,2,
 73,2,3);
 MovePerson( 80,2,0,
 73,2,0);
 talk( 5,"张辽，你去夏丘，按陈宫的吩咐阻止曹操军前进．",
 80,"遵令！",
 5,"高顺去彭城，好，去吧．",
 73,"遵令！");
 MovePerson( 80,10,1,
 73,10,1);
 DecPerson(80);
 DecPerson(73);
 talk( 76,"主公，快去下邳吧．",
 5,"这虽然很好，但怎么派援军给他们呢？",
 76,"援军，他们不需要援军．",
 5,"什么？那不行，只靠他们的部队阻挡不了曹操军．",
 76,"完全正确，所以他们是被扔掉的棋子，在他们为我们赢得的时间里，我们要转移到下邳，否则无法瓦解曹操军的追击．",
 5,"可，可是？",
 76,"主公，要成为人上人就不能有私情，他们的本意也是能为主公效劳吗？",
 5,"哦？唉！",
 81,"……（怎么搞的？我怎么会跟着他到现在？）");
 NextEvent();
 end,
 [146]=function()
 JY.Smap={};
 SetSceneID(0,11);
 talk( 80,"那么，我们在夏丘阻止曹操军．",
 73,"我们在彭城保护主公，放心吧，肯定有援军的．",
 5,"那么，我们去下邳吧．");
 NextEvent();
 end,
 [147]=function()
 JY.Smap={};
 JY.Base["现在地"]="小沛";
 JY.Base["道具屋"]=7;
 AddPerson(9,25,17,2);
 AddPerson(69,22,10,1);
 AddPerson(62,11,16,0);
 AddPerson(1,17,13,3);
 AddPerson(2,14,11,3);
 AddPerson(3,12,12,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("小沛议事厅");
 talk( 9,"哦，刘备，能夺回小沛，首先要祝贺你．",
 1,"谢谢．");
 --显示任务目标:<与曹操等就下一步作战研究．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [148]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"请对曹操讲．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"太想念这里了，觉得好像终于回到了家．");
 end
 if JY.Tid==69 then--荀彧
 talk( 69,"这仗打得真漂亮啊，终于夺回了小沛．");
 end
 if JY.Tid==62 then--郭嘉
 talk( 62,"乾脆乘势进攻，消灭吕布．");
 end
 if JY.Tid==9 then--曹操
 talk( 9,"刘备，此次进攻徐州，我想与你分路进军．",
 1,"分成夏丘和彭城两路．",
 9,"对，敌人好像已在夏丘和彭城准备好等着我们，刘备，我分一支援军给你，如果你攻夏丘就带荀彧，攻彭城就带郭嘉，我跟他俩讲好了．");
 NextEvent();
 end
 end,
 [149]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"选择哪条路由大哥定，可是，守夏丘的是张辽，张辽可非寻常之辈．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"哪条路都行，大哥，快夺回徐州吧．");
 end
 if JY.Tid==9 then--曹操
 talk( 9,"如果往夏丘进军就带荀彧，往彭城就带郭嘉．");
 end
 if JY.Tid==69 then--荀彧
 if talkYesNo( 69,"要进攻夏丘吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 69,"请编组部队．");
 WarIni();
 DefineWarMap(11,"第一章 夏丘II之战","一、张辽撤退．",30,0,79);
 SelectTerm(1,{
 0,2,9, 4,0,-1,0,
 -1,3,9, 4,0,-1,0,
 -1,1,10, 4,0,-1,0,
 -1,3,10, 4,0,-1,0,
 -1,1,9, 4,0,-1,0,
 -1,4,9, 4,0,-1,0,
 -1,4,10, 4,0,-1,0,
 68,25,17, 3,0,-1,0,
 18,24,17, 3,0,-1,0,
 19,25,16, 3,0,-1,0,
 });
 DrawSMap();
 JY.Smap={};
 SetSceneID(0,3);
 talk( 69,"出兵．",
 9,"那么我们就向彭城进军吧，刘备，夏丘方面就交给你了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(150); --goto 150
 end
 end
 if JY.Tid==62 then--郭嘉
 if talkYesNo( 62,"要进攻彭城吗？") then
 RemindSave();
 talk( 62,"请编组部队．");
 WarIni();
 DefineWarMap(12,"第一章 彭城II之战","一、高顺撤退．",30,0,72);
 SelectTerm(1,{
 0,1,3, 4,0,-1,0,
 -1,1,1, 4,0,-1,0,
 -1,2,0, 4,0,-1,0,
 -1,2,2, 4,0,-1,0,
 -1,0,2, 4,0,-1,0,
 -1,0,3, 4,0,-1,0,
 -1,0,4, 4,0,-1,0,
 61,6,15, 4,0,-1,0,
 16,6,14, 4,0,-1,0,
 17,7,15, 4,0,-1,0,
 });
 DrawSMap();
 JY.Smap={};
 SetSceneID(0,3);
 talk( 62,"出兵．",
 9,"那么我们就向夏丘进军，刘备，彭城方面就交给你了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(154); --goto 154
 end
 end
 end,
 [150]=function()
 SelectEnemy({
 79,16,10, 3,2,17,24, 0,0,-1,0,
 256,16,12, 4,4,14,1, 24,16,-1,0,
 257,13,10, 3,4,12,1, 7,9,-1,0,
 258,15,10, 3,2,10,1, 0,0,-1,0,
 274,17,11, 4,4,14,4, 24,16,-1,0,
 275,13,9, 3,4,12,4, 7,9,-1,0,
 276,15,9, 3,2,10,4, 0,0,-1,0,
 292,15,12, 4,4,10,7, 24,16,-1,0,
 293,14,10, 3,4,10,7, 7,9,-1,0,
 328,15,11, 3,2,12,13, 0,0,-1,0,
 259,0,8, 4,1,14,1, 0,0,-1,1,
 277,0,9, 4,1,10,4, 0,0,-1,1,
 294,0,10, 4,1,10,7, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [151]=function()
 PlayBGM(11);
 talk( 69,"好，两面夹击敌人．",
 1,"只等着开打了．",
 2,"敌军大将好像是张辽，张辽是有忠义之心的一员武将．",
 80,"追随吕布看来是错了．");
 WarShowTarget(true);
 PlayBGM(14);
 NextEvent();
 end,
 [152]=function()
 if (not GetFlag(1012)) and War.Turn==2 then
 WarModifyAI(256,1);
 WarModifyAI(257,1);
 WarModifyAI(274,1);
 WarModifyAI(275,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 SetFlag(1012,1);
 end
 if (not GetFlag(1013)) and War.Turn==5 then
 talk( 2,"大哥，注意后面．");
 WarShowArmy(259);
 WarShowArmy(277);
 WarShowArmy(294);
 DrawStrBoxCenter("敌人的奇袭队出现了．");
 talk( 1,"张辽派奇袭队抄我后路．",
 2,"真知用兵之妙．",
 80,"好，全军总攻．");
 WarModifyAI(328,1);
 WarModifyAI(276,1);
 WarModifyAI(258,1);
 WarModifyAI(79,1);
 SetFlag(1013,1);
 end
 if WarMeet(2,80) then
 WarAction(1,2,80);
 talk( 2,"对面的可是张辽，你追随吕布，难道不后悔吗？",
 80,"唉！",
 2,"吕布是个视背叛如同儿戏的恶棍，决不是什么英雄，这点你不会不知吧．",
 80,"唉！");
 talk( 80,"全军撤退！");
 WarAction(16,80);
 WarGetExp();
 PlayBGM(7);
 DrawMulitStrBox("　张辽撤退，刘备和曹操联军打败了吕布军．");
 GetMoney(500);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金５００．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("　张辽撤退，刘备和曹操联军打败了吕布军．");
 GetMoney(500);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金５００．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if (not GetFlag(72)) and WarCheckLocation(-1,0,7) then
 GetMoney(400);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金４００．");
 SetFlag(72,1);
 end
 end,
 [153]=function()
 JY.Smap={};
 SetSceneID(0,3);
 talk( 69,"刘备，主公刚派使者来，说他的部队已占领徐州，我们去徐州吧．");
 NextEvent(158); --goto 158
 end,
 [154]=function()
 SelectEnemy({
 72,17,15, 3,0,17,14, 0,0,-1,0,
 256,13,12, 3,4,14,1, 8,11,-1,0,
 257,16,13, 3,4,13,1, 15,9,-1,0,
 258,17,13, 3,0,12,1, 0,0,-1,0,
 274,16,8, 3,4,14,4, 14,4,-1,0,
 275,15,14, 3,4,12,4, 16,9,-1,0,
 292,15,9, 3,4,10,7, 14,4,-1,0,
 293,15,10, 3,4,10,7, 14,4,-1,0,
 294,14,13, 3,4,9,7, 8,11,-1,0,
 295,14,14, 3,4,10,7, 12,12,-1,0,
 296,16,14, 3,0,9,7, 0,0,-1,0,
 310,15,8, 3,4,14,10, 14,4,-1,0,
 311,13,13, 3,4,12,10, 8,11,-1,0,
 328,15,15, 3,0,12,13, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [155]=function()
 PlayBGM(11);
 talk( 73,"可恶，这样打下去赢不了，吕布将军还没有回话吗？吕布是叫我去送死．",
 2,"据说彭城由高顺把守，我们不能落在曹操军的后面．");
 WarShowTarget(true);
 PlayBGM(13);
 NextEvent();
 end,
 [156]=function()
 if WarMeet(3,73) then
 WarAction(1,3,73);
 talk( 3,"城中大将，出来，我要一雪徐州之耻．",
 73,"张飞，我来与你单挑较量．");
 WarAction(6,3,73);
 talk( 73,"下马受死．",
 3,"与吕布狼狈为奸，不管是谁，我都要一枪刺死他．");
 WarAction(5,3,73);
 if fight(3,73)==1 then
 talk( 73,"不行，实在打不过他．");
 WarLvUp(GetWarID(3));
 talk( 73,"妈的！撤退！");
 WarAction(16,73);
 PlayBGM(7);
 DrawMulitStrBox("　高顺撤退了，刘备和曹操联军打败了．");
 GetMoney(500);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金５００．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 else
 talk( 3,"不行，实在打不过他．");
 WarAction(17,3);
 WarLvUp(GetWarID(73));
 end
 end
 if (not GetFlag(1014)) and War.Turn==2 then
 WarModifyAI(256,1);
 WarModifyAI(294,1);
 WarModifyAI(311,1);
 WarModifyAI(274,4,8,4);
 WarModifyAI(292,4,8,4);
 WarModifyAI(293,4,8,4);
 WarModifyAI(310,4,8,4);
 SetFlag(1014,1);
 end
 if (not GetFlag(1015)) and War.Turn==3 then
 WarModifyAI(274,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(310,1);
 SetFlag(1015,1);
 end
 WarLocationItem(12,16,96,73); --获得道具:获得道具：马铠 改为长戟
 if JY.Status==GAME_WARWIN then
 talk( 73,"可恶！撤退！");
 PlayBGM(7);
 DrawMulitStrBox("　高顺撤退了，刘备和曹操联军打败了．");
 GetMoney(500);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金５００．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [157]=function()
 JY.Smap={};
 SetSceneID(0,3);
 talk( 62,"刘备，主公派来使者，说他的部队已经占领了徐州，我们去徐州吧．");
 NextEvent(158); --goto 158
 end,
 [158]=function()
 JY.Smap={};
 JY.Base["现在地"]="徐州";
 JY.Base["道具屋"]=6;
 AddPerson(9,25,9,1);
 AddPerson(69,14,9,3);
 AddPerson(17,10,11,3);
 AddPerson(18,4,14,3);
 AddPerson(62,25,15,2);
 AddPerson(19,21,17,2);
 AddPerson(20,15,20,2);
 SetSceneID(86,11);
 DrawStrBoxCenter("徐州议事厅");
 AddPerson(1,5,19,0);
 AddPerson(2,3,18,0);
 AddPerson(3,7,20,0);
 MovePerson( 1,5,0,
 2,3,0,
 3,3,0);
 talk( 9,"刘备，果然名不虚传啊，你辛苦了．吕布好像逃到了下邳．",
 1,"下邳？",
 9,"你大概也知道吧，此城坚固，现苦无攻城良策．");
 --显示任务目标:<与曹操就下一步研究．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [159]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"大哥，先向曹操报告一下吧．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，还是徐州好呀，好像回到家似的．");
 end
 if JY.Tid==69 then--荀彧
 talk( 69,"下邳城特别难攻，假如吕布又逃到那里，破城就难上加难了．");
 end
 if JY.Tid==62 then--郭嘉
 talk( 62,"吕布逃进了下邳，我们差一点就抓到这条猛虎．");
 end
 if JY.Tid==17 then--夏侯惇
 talk( 17,"剩下的只是下邳了，吕布也该完蛋了．");
 end
 if JY.Tid==18 then--夏侯渊
 talk( 18,"吕布很快就会完蛋，这样社会也能安宁些．");
 end
 if JY.Tid==19 then--曹仁
 talk( 19,"吕布在下邳城，这样会难攻些．");
 end
 if JY.Tid==20 then--曹洪
 talk( 20,"即使攻破下邳，吕布一个人也很难对付，必须小心．");
 end
 if JY.Tid==9 then--曹操
 talk( 9,"刘备，该怎么打呀？噢，来人是谁？");
 AddPerson(66,5,19,0);
 MovePerson( 66,7,0)
 talk( 66,"刘备大人，我是陈登，是徐州的豪门之士．",
 1,"以前在徐州议事厅见过面．",
 66,"吕布占领徐州后，屈从吕布，现在想将吕布军的事情禀报大人．",
 9,"对了，陈登有话跟你说．你去听他怎么说．");
 NextEvent();
 end
 end,
 [160]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"大哥，你听陈登讲．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"呀，大哥，还是徐州好呀，像回到家乡．");
 end
 if JY.Tid==69 then--荀彧
 talk( 69,"刘备，请听陈登讲．");
 end
 if JY.Tid==62 then--郭嘉
 talk( 62,"吕布逃进了下邳城，我们差一点就抓住了这条猛虎．");
 end
 if JY.Tid==17 then--夏侯惇
 talk( 17,"只剩下邳了，吕布快完蛋了．");
 end
 if JY.Tid==18 then--夏侯渊
 talk( 18,"吕布马上就完了，这样也好安宁些．");
 end
 if JY.Tid==19 then--曹仁
 talk( 19,"吕布在下邳，这样也许难攻些．");
 end
 if JY.Tid==20 then--曹洪
 talk( 20,"即使攻破下邳，但吕布一人也很难对付．");
 end
 if JY.Tid==9 then--曹操
 talk( 9,"刘备，听陈登讲．");
 end
 if JY.Tid==66 then--陈登
 talk( 66,"其实我原是吕布的下属，如果有人劝降顺利，侯成﹑魏续﹑宋宪三人也许会倒戈献城．");
 talk( 66,"大概此三人都在下邳城外把守，如能与他们化敌为友，下邳城则很容易攻破．");
 NextEvent();
 end
 end,
 [161]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"大哥，一定要劝降此三人．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"游说劝降不在行，劝降就由大哥来吧．");
 end
 if JY.Tid==69 then--荀彧
 talk( 69,"言之有理，陈登之言非常重要．");
 end
 if JY.Tid==62 then--郭嘉
 talk( 62,"吕布逃进了下邳，差一点我们就捉到这头猛虎．");
 end
 if JY.Tid==66 then--陈登
 talk( 66,"刘备，一定要让侯成﹑魏续﹑宋宪倒戈，如果成功，这场仗必胜无疑．");
 end
 if JY.Tid==17 then--夏侯惇
 talk( 17,"只剩下下邳了，吕布也快完蛋了．");
 end
 if JY.Tid==18 then--夏侯渊
 talk( 18,"吕布马上就会完蛋，这样这个社会也能安宁些．");
 end
 if JY.Tid==19 then--曹仁
 talk( 19,"吕布在下邳，这也许会使攻城变得难一点．");
 end
 if JY.Tid==20 then--曹洪
 talk( 20,"即使攻破了下邳，只吕布也很难对付啊．");
 end
 if JY.Tid==9 then--曹操
 talk( 9,"刘备，依计而行吧，现在我们就去攻下邳，届时刘备劝降侯成﹑魏续﹑宋宪三人，如能成功，下邳则很快得以攻克，刘备，看你的了．");
 NextEvent();
 -- 显示任务目标:<出征吕布驻守的下邳．>
 end
 end,
 [162]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"游说不在行，有劳大哥办了．");
 end
 if JY.Tid==69 then--荀彧
 talk( 69,"陈登说的非常重要．");
 end
 if JY.Tid==62 then--郭嘉
 talk( 62,"下邳城四周有护城河，所以易守难攻，只要攻下城门吊桥，就好办了．");
 end
 if JY.Tid==66 then--陈登
 talk( 66,"刘备，请你一定要劝降侯成﹑魏续﹑宋宪，如能成功，则这场仗必胜无疑．");
 end
 if JY.Tid==17 then--夏侯惇
 talk( 17,"只剩下下邳了，吕布也快完蛋了．");
 end
 if JY.Tid==18 then--夏侯渊
 talk( 18,"吕布马上就会完蛋，这样这个社会也能安宁些．");
 end
 if JY.Tid==19 then--曹仁
 talk( 19,"吕布在下邳，这也许会使攻城困难一点．");
 end
 if JY.Tid==20 then--曹洪
 talk( 20,"即使攻破了下邳，只吕布也很难对付啊．");
 end
 if JY.Tid==9 then--曹操
 talk( 9,"刘备，就看你的了．");
 end
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"出兵吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 2,"列队！");
 WarIni();
 DefineWarMap(14,"第一章 下邳之战","一、放吊桥．",45,0,4);
 SelectTerm(1,{
 0,30,22, 3,0,-1,0,
 -1,29,23, 3,0,-1,0,
 -1,31,21, 3,0,-1,0,
 -1,28,22, 3,0,-1,0,
 -1,29,21, 3,0,-1,0,
 -1,30,20, 3,0,-1,0,
 -1,31,19, 3,0,-1,0,
 8,0,16, 4,0,-1,1,
 61,5,14, 4,0,-1,1,
 68,3,13, 4,0,-1,1,
 18,3,16, 4,0,-1,1,
 19,4,15, 4,0,-1,1,
 16,1,15, 4,0,-1,1,
 17,2,14, 4,0,-1,1,
 });
 DrawSMap();
 talk( 2,"出兵！",
 9,"好，时机来了，除掉吕布．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [163]=function()
 JY.Smap={};
 SetSceneID(0,3);
 talk( 9,"刘备看你的了，我们把部队埋伏好，如果你劝降成功的话，那我们就一起攻进下邳．");
 NextEvent();
 end,
 [164]=function()
 ModifyForce(5,5);
 SelectEnemy({
 4,11,0, 1,2,21,8, 0,0,-1,0,
 75,12,1, 4,2,18,5, 0,0,-1,0,
 80,9,14, 4,2,18,8, 0,0,-1,0,
 73,17,15, 4,2,17,2, 0,0,-1,0,
 74,15,20, 4,2,17,5, 0,0,-1,0,
 79,15,2, 4,0,18,24, 0,0,-1,0,
 72,14,0, 3,0,18,14, 0,0,-1,0,
 84,5,6, 4,0,17,15, 0,0,-1,0,
 85,10,1, 4,2,16,19, 0,0,-1,0,
 256,19,14, 4,0,14,1, 0,0,-1,0,
 257,6,5, 4,0,14,1, 0,0,-1,0,
 258,12,3, 3,0,14,1, 0,0,-1,0,
 259,15,3, 3,0,13,1, 0,0,-1,0,
 260,14,3, 3,0,13,1, 0,0,-1,0,
 292,17,14, 4,0,14,7, 0,0,-1,0,
 293,10,14, 4,0,14,7, 0,0,-1,0,
 294,18,5, 3,0,14,7, 0,0,-1,0,
 274,20,13, 4,0,14,4, 0,0,-1,0,
 275,18,16, 4,0,14,4, 0,0,-1,0,
 276,11,1, 4,0,13,4, 0,0,-1,0,
 277,19,6, 3,0,13,4, 0,0,-1,0,
 310,18,15, 4,0,14,10, 0,0,-1,0,
 311,18,20, 4,0,14,10, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [165]=function()
 PlayBGM(11);
 talk( 5,"哼，不管曹操和刘备如何进攻，这座城依然固若金汤．",
 2,"大哥，你看这样行吗？如陈登所说，说服侯成﹑魏续﹑宋宪背叛吕布，让他们放下吊桥．",
 81,"原来吕布让我们在城外厮杀，自己待在城里，这样，士兵也不听话了，怎么办呢？",
 74,"在这里打败仗的话，我们会被吕布砍头的，这也好，可……",
 75,"吕布将军对自己的女人和孩子挺好，却不把我们当人看，他不值得我们追随．");
 WarShowTarget(true);
 PlayBGM(16);
 NextEvent();
 end,
 [166]=function()
 if (not GetFlag(1016)) and War.Turn==30 then
 PlayBGM(9);
 SetWarMap(13,12,1,4);
 PlayWavE(18);
 WarDelay(48);
 War.MapID=61;
 WarDelay(12);
 DrawStrBoxCenter("吊桥放下来了．");
 talk( 1,"怎么啦？是吊桥降下来了吗？");
 WarShowArmy(8);
 WarShowArmy(61);
 WarShowArmy(68);
 WarShowArmy(16);
 WarShowArmy(17);
 WarShowArmy(18);
 WarShowArmy(19);
 DrawStrBoxCenter("曹操军援兵出现．");
 talk( 69,"主公，吊桥好像放下来了．",
 9,"唉，可能刘备也成不了气候，这点离间计也不会用，预先让陈登潜入城内是正确的，好，必能活擒吕布．");
 WarModifyAI(84,1);
 WarModifyAI(257,1);
 WarModifyAI(294,1);
 WarModifyAI(277,1);
 WarModifyAI(79,4,19,4);
 WarModifyAI(258,4,9,5);
 WarModifyAI(259,4,18,4);
 WarModifyAI(260,4,8,4);
 War.WarTarget="一、击溃吕布．";
 WarShowTarget(false);
 PlayBGM(16);
 SetFlag(1016,1)
 NextEvent();
 end
 if WarMeet(1,81) then
 WarAction(1,1,81);
 talk( 81,"是刘备吗？好哇，我跟你打．",
 1,"侯成，听我说．");
 talk( 1,"侯成，现在吕布已经孤立，军心离散，就像你一样．",
 81,"胡说，我不会有二心的．",
 1,"不要对自己撒谎，难道你甘心白白送死．",
 81,"唉……",
 1,"如果你看不透这点的话，就在这里葬送自己好了．",
 81,"我还没在这个世上留名，还不能死．",
 1,"那么，能否帮我们放下下邳的吊桥？",
 81,"明白了，那么，你到吊桥前时我们就放下去，现在我回去着手准备．");
 WarAction(16,81);
 WarLvUp(GetWarID(1));
 SetFlag(17,1)
 end
 if WarMeet(1,74) then
 WarAction(1,1,74);
 talk( 1,"魏续，吕布气数已尽，不要再打无谓的仗了．",
 74,"我等自以前就追随吕布将军，可是吕布只想着自己的家眷，对我等下属毫无恩赐，现在我投靠你，这就去放吊桥．");
 WarAction(16,74);
 WarLvUp(GetWarID(1));
 SetFlag(18,1)
 end
 if WarMeet(1,75) then
 WarAction(1,1,75);
 talk( 75,"……刘备，我们以前怎么一直跟着，这样一个人啊．",
 1,"宋宪，现在觉醒也不迟．",
 75,"唉，好吧，我现在就投靠你们，刘备，我现在马上回城去放吊桥．");
 WarAction(16,75);
 WarLvUp(GetWarID(1));
 SetFlag(19,1)
 end
 if (not GetFlag(1017)) and War.Turn==3 then
 talk( 5,"城外士兵为何慢吞吞的，让他们加强进攻．",
 81,"哪里慢了？",
 74,"是啊，让前线部队进攻敌人．",
 75,"敌人很强，曹操军还整装待发，这些吕布将军是应该知道的呀，他怎么这么说，让我们去送命呀．");
 WarModifyAI(256,1);
 WarModifyAI(292,1);
 WarModifyAI(274,1);
 WarModifyAI(275,1);
 WarModifyAI(310,1);
 SetFlag(1017,1)
 end
 if WarCheckLocation(0,12,12) then
 if GetFlag(17) and GetFlag(18) and GetFlag(19) then
 PlayBGM(9);
 SetWarMap(13,12,1,4);
 PlayWavE(18);
 WarDelay(48);
 War.MapID=61;
 WarDelay(12);
 DrawStrBoxCenter("吊桥放下来了．");
 talk( 81,"刘备，快请入城．",
 1,"这是侯成的声音，是他帮我们放吊桥．",
 5,"什么？侯成﹑魏续﹑宋宪三人背叛了我，放了吊桥，这几个无义之徒，我决不饶恕他们．");
 WarShowArmy(8);
 WarShowArmy(61);
 WarShowArmy(68);
 WarShowArmy(16);
 WarShowArmy(17);
 WarShowArmy(18);
 WarShowArmy(19);
 DrawStrBoxCenter("出现了曹操军援军．");
 talk( 69,"主公，吊桥好像放下来了．",
 9,"看来刘备的离间计奏效了，好，全军突击，一定要活捉吕布．");
 WarModifyAI(84,1);
 WarModifyAI(257,1);
 WarModifyAI(294,1);
 WarModifyAI(277,1);
 WarModifyAI(79,4,19,4);
 WarModifyAI(258,4,9,5);
 WarModifyAI(259,4,18,4);
 WarModifyAI(260,4,8,4);
 War.WarTarget="一、击溃吕布．";
 WarShowTarget(false);
 PlayBGM(16);
 NextEvent();
 else
 --talk( 81,"是吗？真的不放吊桥就没办法进城吗？要想办法放下吊桥．");
 end
 end
 if JY.Status==GAME_WARWIN then
 DrawMulitStrBox("　此次战斗的胜利是除错用的，程序有此断点，游戏玩到这里就是有错．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(168);
 end
 end,
 [167]=function()
 if WarMeet(2,80) then
 WarAction(1,2,80);
 talk( 2,"张辽，快投降，吕布气数已尽，你已为他尽力了．",
 80,"……现在不必多言，举起刀来．");
 WarAction(6,2,80);
 talk( 2,"杀呀！",
 80,"杀呀！");
 if fight(2,80)==1 then
 talk( 80,"呼哧，不愧是关羽，好厉害，啊！");
 WarAction(8,2,80);
 talk( 2,"还不是致死命的伤，杀死这个汉子有点可惜．");
 WarAction(17,80);
 WarLvUp(GetWarID(2));
 else
 talk( 2,"呼哧，不愧是张辽，好厉害，啊！");
 WarAction(17,2);
 WarLvUp(GetWarID(80));
 end
 end
 WarLocationItem(0,6,8,74); --获得道具:获得道具：赤兔马
 WarLocationItem(0,20,15,164); --获得道具:获得道具：方天画戟
 if JY.Status==GAME_WARWIN then
 talk( 5,"唉，完了，");
 PlayBGM(7);
 DrawMulitStrBox("　吕布被捉，刘备和曹操联军击破了吕布军．");
 GetMoney(500);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金５００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [168]=function()
 SetSceneID(0,3);
 talk( 2,"我们进入下邳吧．");
 --显示任务目标:<去下邳的议事厅．>
 NextEvent();
 end,
 [169]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="下邳";
 JY.Base["道具屋"]=9;
 AddPerson(9,25,17,2);
 AddPerson(69,11,16,0);
 AddPerson(62,9,15,0);
 AddPerson(1,22,10,1);
 AddPerson(2,20,9,1);
 AddPerson(3,18,8,1);
 AddPerson(5,14,12,3);
 --AddPerson(1,4,7,3);
 --AddPerson(1,29,11,1);
 SetSceneID(54,5);
 DrawStrBoxCenter("下邳议事厅");
 talk( 9,"刘备，现在正要决定对吕布如何处置．");
 --显示任务目标:<决定对吕布的处置．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [170]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"毫无同情的余地，应马上处死他．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"快点把他砍头吧，要不然我来行刑．");
 end
 if JY.Tid==69 then--荀彧
 talk( 69,"留下吕布的命将留下后患．");
 end
 if JY.Tid==62 then--郭嘉
 talk( 62,"可是，吕布此人相当了得，只他一人就让我们吃了这么多苦头．");
 end
 if JY.Tid==5 then--吕布
 talk( 5,"刘备，在战场上我还不会输的，作为武将，辅助主公，天下可定也．");
 end
 if JY.Tid==9 then--曹操
 talk( 9,"刘备，你想一想，对他如何处置好？");
 NextEvent();
 end
 end,
 [171]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"毫无同情的余地，应马上处死他．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"快点砍下他的脑袋．");
 end
 if JY.Tid==69 then--荀彧
 talk( 69,"留下吕布的命将留下后患．");
 end
 if JY.Tid==62 then--郭嘉
 talk( 62,"吕布确实很英勇，但考虑到对主公好，还是……");
 end
 if JY.Tid==9 then--曹操
 talk( 9,"刘备，怎么办好呢？");
 end
 if JY.Tid==5 then--吕布
 JY.Status=GAME_SMAP_AUTO;
 talk( 5,"刘备，你忘了我们在徐州曾一起相处过吗？请你无论如何保住我的命啊！",
 9,"刘备，你看怎么办？把你的看法讲给我听．");
 local menu={
 {" 宽恕吕布",nil,1},
 {"不宽恕吕布",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 NextEvent(); --goto 172
 elseif r==2 then
 NextEvent(173); --goto 173
 end
 end
 end,
 [172]=function()
 talk( 1,"吕布确实反叛无常，但其所处境遇也有令人同情之处，而且，杀掉此人很可惜呀．",
 5,"啊！对！是这样没错！刘备！谢谢你！曹操，饶我一命吧！",
 9,"唉，刘备，你那么认为吗？我却不那么认为，此人不可救药，先杀义父投奔董卓，接着又背叛了董卓，还杀了他，我不想步其后尘，吕布，你死定了．",
 5,"等一下，我不想死！",
 3,"大哥，这次我也赞成曹操的意见，吕布，我来给你行刑．");
 NextEvent(174); --goto 174
 end,
 [173]=function()
 talk( 1,"吕布是个容易背叛之徒，也背叛了董卓，即便现在曹操你想留住他，不久他也将背叛你．",
 9,"唉，决定了，吕布处以死刑，拉下去砍啦．",
 5,"等一下，我不想死．",
 3,"死到临头了还这副样子，我来行刑．");
 NextEvent(174); --goto 174
 end,
 [174]=function()
 MovePerson( 3,1,2);
 MovePerson( 3,3,1);
 MovePerson( 3,3,3);
 MovePerson( 3,0,2);
 talk( 3,"喂，张飞，住手！");
 MovePerson( 3,9,2,
 5,9,2);
 DecPerson(3);
 DecPerson(5);
 talk( 9,"好！带下一个．");
 AddPerson(80,-4,3,3);
 MovePerson( 80,9,3);
 talk( 9,"张辽，如果不追随吕布小儿的话，可以留住你的命，怎么样？今后跟随我，来补偿你以前的过错．",
 80,"哼，我以前的过错就是没亲手杀死你，现在既然已不能实现，活着也没意思，快杀我吧．",
 9,"谁听你胡言乱语．");
 MovePerson( 2,2,2);
 MovePerson( 2,3,1);
 MovePerson( 2,3,3);
 talk( 2,"刀下留人！",
 80,"关羽……",
 2,"此人忠义，虽有愚鲁之处，但实为难得人才，愿以关羽自身性命相保．",
 9,"我是开玩笑，难道我看不出？张辽，你自由了，随你便，去哪里都行．",
 80,"您说什么？您宽恕我了吗？真有气度！吕布却……，我过去错了，曹操，不，曹操仁公，你宽大为怀，我感激不尽，请让我在你麾下效劳．",
 9,"你是说要跟随我，张辽，我能得到你这样的下属，也是我的福气．",
 80,"多谢！");
 ModifyForce(80,9);
 talk( 9,"那么，刘备，战场也打扫完了，回许昌吧．",
 1,"好吧．");
 NextEvent();
 end,
 [175]=function()
 JY.Smap={};
 SetSceneID(0);
 talk( 2,"大哥，那就回许昌吧．");
 NextEvent();
 end,
 --第一章　徐州攻防战
 [176]=function()
 SetSceneID(-1,0);
 JY.Base["章节名"]="第一章　徐州攻防战";
 DrawStrBoxCenter("第一章　徐州攻防战");
 LoadPic(10,1);
 DrawMulitStrBox("　吕布被杀，曹操顾忌的强大敌人没有了，曹操开始随心所欲地操纵朝廷．一天，曹操劝献帝去打猎，在猎场，曹操冷不防夺过献帝手中的弓箭，并射中了猎物．");
 DrawMulitStrBox("　百官以为猎物是献帝射中的，曹操为显示是自己射的，从献帝手中夺去了猎物，这一举动使皇帝丢尽了面子，曹操这一蔑视献帝的举动，招致了忠臣们的反感．");
 LoadPic(10,2);
 NextEvent();
 end,
 [177]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(1,21,10,1);
 AddPerson(2,16,10,3);
 AddPerson(3,14,11,3);
 SetSceneID(77,5);
 DrawStrBoxCenter("许昌刘备官邸");
 --显示任务目标:<与关羽等讨论今后之事．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [178]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"我还以为吕布一死，害圣上的人就没有了，我岂能容忍曹操这样对圣上．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"啊，大哥，你们起来得真早呀，嗯，大哥，好像有人来了．");
 AddPerson(365,3,20,0);
 MovePerson(365,7,0);
 talk( 365,"刘备，对不起．");
 NextEvent();
 end
 end,
 [179]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"你是曹操派来的使者吗？有什么事吗？");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"不行，我还没睡醒呢，大哥，什么都别听．");
 end
 if JY.Tid==365 then--使者
 talk( 365,"刘备，曹操在议事厅，请你马上去议事厅．");
 JY.Status=GAME_SMAP_AUTO;
 --显示任务目标:<去议事厅见曹操．>
 NextEvent();
 end
 end,
 [180]=function()
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(9,25,9,1);
 AddPerson(69,14,9,3);
 AddPerson(17,12,10,3);
 AddPerson(18,10,11,3);
 AddPerson(62,25,15,2);
 AddPerson(19,23,16,2);
 AddPerson(20,21,17,2);
 AddPerson(1,3,20,0);
 SetSceneID(85);
 DrawStrBoxCenter("许昌议事厅");
 talk( 9,"噢，刘备，我一直在等你．");
 MovePerson(1,7,0);
 --显示任务目标:<与曹操谈话．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [181]=function()
 if JY.Tid==69 then--荀彧
 talk( 69,"刘备，早好，休息得好吗？");
 end
 if JY.Tid==62 then--郭嘉
 talk( 62,"我去对他说．");
 end
 if JY.Tid==17 then--夏侯惇
 talk( 17,"我去对他说吧．");
 end
 if JY.Tid==18 then--夏侯渊
 talk( 18,"我去对他说吧．");
 end
 if JY.Tid==19 then--曹仁
 talk( 19,"我去对他说吧．");
 end
 if JY.Tid==20 then--曹洪
 talk( 20,"我去对他说吧．");
 end
 --[[
 if JY.Tid==69 then--荀彧
 talk( 69,"请早点回来．");
 end
 if JY.Tid==62 then--郭嘉
 talk( 62,"在圣上面前要注意礼节．");
 end
 if JY.Tid==17 then--夏侯惇
 talk( 17,"晋见圣上是头一次吧，要注意礼节．");
 end
 if JY.Tid==18 then--夏侯渊
 talk( 18,"快进宫殿吧．");
 end
 if JY.Tid==19 then--曹仁
 talk( 19,"快进宫殿吧．");
 end
 if JY.Tid==20 then--曹洪
 talk( 20,"快进宫殿吧．");
 end
 ]]--
 if JY.Tid==9 then--曹操
 talk( 9,"刘备，一大早就叫你来，对不起，其实今天我想晋见圣上，在与吕布作战中你表现得很英勇，我想把你引荐给圣上，你去不去？",
 1,"那当然要去．",
 9,"那就马上走吧，去圣上起居的宫殿，我先进去请奏圣上．");
 --显示任务目标:<去宫殿见献帝．>
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [182]=function()
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(383,7,8,3);
 AddPerson(9,14,9,3);
 AddPerson(384,19,8,1);
 AddPerson(353,9,14,0);
 AddPerson(1,37,23,2);
 SetSceneID(84,8);
 DrawStrBoxCenter("许昌宫殿");
 MovePerson(1,10,2);
 talk( 9,"陛下，他就是刘备．",
 383,"噢，刘备，平身．");
 talk( 384,"刘备，我是皇帝内臣，叫董承，初次见面，请多关照．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [183]=function()
 if JY.Tid==9 then--曹操
 talk( 9,"刘备，快拜见陛下．");
 end
 if JY.Tid==384 then--董承
 talk( 384,"刘备，我心里一直盼望着能见到你．");
 end
 if JY.Tid==353 then--官吏
 talk( 353,"陛下座前，请行大礼．");
 end
 if JY.Tid==383 then--献帝
 talk( 383,"噢，你就是刘备吧，听说你和曹操一起讨伐了吕布，谢谢了，……对了，你也姓刘？",
 1,"是．",
 383,"朕姓刘，名刘协，你与朕有什么关系吗？你的祖先是谁？",
 1,"臣听家母讲，臣的祖先是皇帝．",
 383,"你说什么？是真的吗？来人，取家谱查查．");
 MovePerson(353,11,3);
 DecPerson(353);
 NextEvent();
 end
 end,
 [184]=function()
 if JY.Tid==9 then--曹操
 talk( 9,"没想到刘备是汉室宗族．");
 end
 if JY.Tid==384 then--董承
 talk( 384,"刘备若是汉室宗族，对皇帝也是一件喜事，我也很高兴．");
 end
 if JY.Tid==383 then--献帝
 talk( 383,"如果刘备与朕是同宗的话，那可太好了．");
 AddPerson(353,37,23,2);
 MovePerson(353,6,2);
 talk( 353,"刚查过，刘备是陛下的叔叔辈．",
 383,"是这样啊，那么，刘备，你是朕的叔叔了，既然如此，朕叫你皇叔，可以吗？皇叔．",
 1,"这对我来说实在是无上殊荣．");
 --显示任务目标:<在官邸休息．>
 NextEvent();
 end
 end,
 [185]=function()
 if JY.Tid==9 then--曹操
 talk( 9,"刘备，恭喜你，这样你以后谒见陛下就容易了．");
 end
 if JY.Tid==384 then--董承
 talk( 384,"刘备，不，刘皇叔，以后就靠你了．");
 end
 if JY.Tid==353 then--官吏
 talk( 353,"刘皇叔，好响亮啊．");
 end
 if JY.Tid==383 then--献帝
 talk( 383,"你可以退下了，刚打完仗，在家里好好休息吧．");
 MovePerson(1,10,3);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [186]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(1,3,20,0);
 AddPerson(2,16,10,3);
 AddPerson(3,14,11,3);
 SetSceneID(77,5);
 talk( 2,"大哥，你回来了．");
 MovePerson(1,6,0);
 talk( 1,"刚才我晋见了圣上．",
 3,"噢，大哥，恭喜你，都说了些什么？",
 1,"……",
 2,"嗯，大哥，好像是侍从．");
 MovePerson(1,0,1);
 AddPerson(353,3,20,1);
 MovePerson(353,4,0);
 talk( 353,"刘皇叔，我是从皇宫来的．");
 --显示任务目标:<去皇宫见献帝．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [187]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"大哥，皇宫使者又来了．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"又来了，大哥，我接他嫌麻烦．");
 end
 if JY.Tid==353 then--官吏
 talk( 353,"皇叔，圣上有旨，请您再进皇宫一趟．");
 MovePerson(1,8,1);
 DecPerson(1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [188]=function()
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(383,7,8,3);
 AddPerson(353,9,14,0);
 AddPerson(354,19,8,1);
 AddPerson(1,37,23,2);
 SetSceneID(84,8);
 MovePerson(1,2,2);
 talk( 383,"噢，皇叔，朕一直等你．");
 MovePerson(1,8,2);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [189]=function()
 if JY.Tid==353 then--官吏
 talk( 353,"皇叔，请您来好多次，实在辛苦了．");
 end
 if JY.Tid==354 then--官吏
 talk( 354,"近来圣上非常疲惫，好像有什么不顺心的事．");
 end
 if JY.Tid==383 then--献帝
 talk( 383,"噢，皇叔，经常叫你来，对不起．",
 1,"哪里？只要陛下叫我来我就来，有什么事吗？",
 383,"嗯，这个嘛，其他人退下．");
 MovePerson( 353,11,3,
 354,11,3);
 DecPerson(353);
 DecPerson(354);
 talk( 1,"是什么事？",
 383,"……皇叔，我很相信你，所以赐给你这条玉带，你拿回家后仔细看一下，就这件事情．",
 1,"……谢陛下，臣小心收好，那么臣告辞了．");
 --显示任务目标:<在官邸休息．>
 MovePerson(1,10,3);
 DecPerson(1);
 talk( 383,"皇叔，现在你已经是我最大的依靠，拜托你了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [190]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(1,3,20,0);
 AddPerson(2,16,10,3);
 AddPerson(3,14,11,3);
 SetSceneID(77,5);
 talk( 2,"大哥，你回来了．");
 MovePerson(1,6,0);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [191]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"大哥，圣上有什么事？",
 1,"没什么？只是赐给我这条玉带．",
 2,"奇怪，专程叫去只为一条玉带．");
 --显示任务目标:<在许昌城内散步．>
 NextEvent();
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，圣上有什么事？",
 1,"没什么？只是赐给我这条玉带．",
 3,"怎么搞得嘛，要是没有别的事情，赐条玉带可以叫刚才的使者带来．");
 end
 end,
 [192]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"大哥，不要想那么多，不如到外面转转，散散心．",
 1,"也好．");
 MovePerson(1,3,1);
 AddPerson(68,3,20,0);
 MovePerson(68,2,0);
 talk( 68,"刘备，您在这里呀，我乃曹操的属下许褚，主公想见您，请您去主公的官邸，就在您官邸的旁边．");
 MovePerson(68,5,1);
 DecPerson(68);
 MovePerson(1,6,1);
 DecPerson(1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，可以系上那条玉带，难得的御赐玉带呀．");
 end
 end,
 [193]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(9,17,13,1);
 AddPerson(1,3,20,0);
 SetSceneID(43,5);
 MovePerson(9,6,1);
 talk( 9,"我叫你来是因为听了些传言．",
 1,"传言？",
 9,"好像你从圣上那里得到了一条玉带，是不是你身上系的这条？果真有这回事吗？",
 1,"对，确有此事．",
 9,"能否让我看一下？",
 1,"请看．",
 9,"嗯，刘备，怎么样啊？这条玉带可否给我？");
 local menu={
 {"　　让",nil,1},
 {"　 不让",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 1,"好，玉带就送给你吧．",
 9,"不不，开玩笑，这可是御赐的东西．不过我还是想要，刘备，此话当真？真要把玉带让给我吗？");
 elseif r==2 then
 talk( 1,"啊，这个，因为这是御赐的东西……",
 9,"刘备，别这么说，是不是肯把这条玉带让给我？");
 end
 r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 1,"既然你如此想要，就送你了．",
 9,"真的吗？那我就不客气了．");
 SetFlag(20,1);
 elseif r==2 then
 talk( 1,"对不起，尽管你想要，可是……",
 9,"呀，不要介意，我是开玩笑，我想看看你为难的表情．");
 end
 talk( 9,"那么，既然好不容易请你来一趟，一起喝点酒吧．");
 NextEvent();
 end,
 [194]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(9,11,20,0);
 AddPerson(1,13,21,0);
 SetSceneID(66,5);
 DrawStrBoxCenter("庭院");
 talk( 9,"刘备，这边请．",
 1,"好，谢谢．");
 --
 MovePerson( 9,5,0,
 1,5,0)
 MovePerson( 9,0,3,
 1,0,2)
 DrawMulitStrBox("　刘备尽管感到与曹操说话很危险，但还是决定与曹操一起饮酒，喝了一会以后……");
 talk( 9,"刘备，说起当世英雄，该推谁呢？",
 1,"这个问题有些突然．",
 9,"偌大的世界不会连一个英雄都没有，你见识过各种各样的人，难道其中就没有具备英雄素质的人？或者是……",
 1,"……",
 9,"回答我，刘备，你觉得谁是英雄？");
 local menu={
 {"　 自己",nil,1},
 {"　 曹操",nil,1},
 {"　 袁绍",nil,1},
 {"　 袁术",nil,1},
 {"　公孙瓒",nil,1},
 {"　不知道",nil,1}
 }
 while true do
 local r=ShowMenu(menu,6,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 9,"哼哼哼！对，刘备有英雄的素质，正因为如此，对他不能掉以轻心，否则后患无穷．");
 SetFlag(21,1);
 break;
 elseif r==2 then
 talk( 9,"哼哼哼！哈哈哈！你那么认为，我也那么认为，是这样啊，你是这么想的啊，其实，我还觉得你刘备同样是英雄，对，和我一样是英雄．",
 1,"你说什么呀，我可不是什么英雄．",
 9,"你觉得自己是凡夫俗子，我能和你交往吗？刘备，我可怕你呀．");
 SetFlag(21,1);
 break;
 elseif r==3 then
 talk( 9,"袁绍嘛，的确名门出身，部下又出类拔萃，但袁绍自己优柔寡断，这种人又没什么威信，谈不上是英雄．");
 elseif r==4 then
 talk( 9,"袁术嘛，他只考虑自己的利益，不过是蠢猪，我不久就要消灭他，你说袁术是英雄？不要撒谎．");
 elseif r==5 then
 talk( 9,"公孙瓒嘛，刘备你以前和他交情很好，这样可能对你不太好，但这个家伙对形势过于疏忽，不是能驾御这个乱世的人．");
 elseif r==6 then
 talk( 9,"你是说当世没有英雄吧，我认为不对，当世之英雄是你我，至少我这样认为．",
 1,"这？不要开玩笑．",
 9,"哈哈！这是玩笑吗？是这样没错．");
 break;
 end
 end
 talk( 1,"……");
 if GetFlag(20) then
 if GetFlag(21) then
 talk( 9,"啊，今天很高兴，这条玉带我就收起来了．",
 1,"那么我告辞了．");
 else
 talk( 9,"今天很高兴，这条玉带我就收起来了．",
 1,"那么我告辞了．");
 SetFlag(20,0);
 end
 else
 talk( 9,"今天很高兴，什么时候我二人再喝个通宵．",
 1,"那么我告辞了．");
 end
 PlayBGM(5);
 --显示任务目标:<回到自己的官邸．>
 MovePerson(1,10,1);
 NextEvent();
 end,
 [195]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(1,3,20,0);
 AddPerson(2,16,10,3);
 AddPerson(3,14,11,3);
 SetSceneID(77,5);
 talk( 2,"大哥，你回来了，听说你去了曹操那里，没事吧．");
 --显示任务目标:<与关羽等谈关于今后的事．>
 MovePerson(1,7,0);
 if GetFlag(20) then
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(); --Goto 196
 else
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent(197); --Goto 197
 end
 end,
 [196]=function()
 PlayBGM(11);
 AddPerson(68,3,20,0);
 AddPerson(17,1,19,0);
 AddPerson(19,5,21,0);
 MovePerson( 1,0,1,
 68,5,0,
 17,6,0,
 19,6,0);
 MovePerson( 17,0,3,
 19,0,2);
 talk( 17,"刘备，你要死在我刀下．",
 2,"大哥，危险．",
 3,"啊！大哥！");
 talk( 1,"哇！");
 DecPerson(1);
 PlayBGM(4);
 talk( 68,"在玉带发现了密书，上面写着杀死曹操．．",
 17,"所以我们才先发制人的．",
 19,"这叫自作自受，主公早已把他视作危险人物，他却不知道，还口吐狂言，以致有这样的下场．");
 DrawMulitStrBox("　刘备被杀了，刘备重振汉室声威的梦想也同时破灭了．");
 --游戏失败:
 NextEvent(999); --Goto 999
 end,
 [197]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，在曹操那里都说了些什么？我担心曹操耍什么阴谋．");
 end
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，你要小心些，曹操那里可不能去．好像有人来了．");
 AddPerson(384,3,20,0);
 MovePerson(1,0,1);
 MovePerson(384,5,0);
 talk( 384,"刘皇叔，失礼了，您忘了吗？我是刚才与圣上在一起的董承．");
 NextEvent();
 end
 end,
 [198]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"原来是董承大人，有什么事？");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，去陪客人了．");
 end
 if JY.Tid==384 then--董承
 talk( 384,"突然造访，对不起，皇叔是否得到一条陛下御赐的玉带，可否让我看一下？");
 local menu={
 {"　让他看",nil,1},
 {" 不让他看",nil,1},
 }
 while true do
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 384,"噢，确实是玉带，其实我也同样得到一条玉带，而且这条玉带实际上是……");
 DrawMulitStrBox("　董承用剑割开玉带，里面掉出了一张纸片．");
 talk( 1,"啊呀！里面有纸片！这是什么？写的是血书，上面写着杀死曹操．．",
 384,"对，这是圣上用血写的．真可叹呀！",
 1,"如此说来，圣上好像下了决心了．",
 384,"是的，曹操最初还装成忠臣的样子，可是最近其言行好像自己是皇帝似的．",
 384,"他经常不把圣上当回事，圣上是流着眼泪赐我这条玉带的，我为报答陛下以前对我的恩典，策划讨伐曹操．",
 384,"皇叔，请你也参加吧．如果你参加，我们就更有信心了．我求你．",
 1,"董承，我也是圣上的臣子，我参加．",
 384,"噢，多谢了，那我去联系别的志士．");
 MovePerson(384,8,1);
 DecPerson(384);
 break;
 else
 talk( 384,"皇叔，不要隐瞒了，玉带的事我听说了，来，交给我．");
 end
 end
 NextEvent();
 end
 end,
 [199]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，我和张飞都很高兴，看来不管在什么时候都有忠臣呀！但我们待在这里总被曹操盯着，实在难以倒戈，现在最好研究一下离开这里，去徐州商量一下举兵起事的计划．",
 1,"好啊，那我马上去徐州，可是得有曹操的准许，好，我去见曹操．");
 --显示任务目标:<请求曹操准许离开．>
 MovePerson(1,12,1);
 DecPerson(1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==3 then--张飞
 talk( 3,"好哇，我听到你们刚才说的话了，这才是我的大哥，太好了！");
 end
 --[[
 if JY.Tid==2 then--关羽
 talk( 2,"注意千万别被他们发现，曹操可是个狡滑的家伙．",
 1,"好啊，那我马上去徐州，可是得有曹操的准许，好，我去见曹操．");
 --显示任务目标:<请求曹操准许离开．>
 NextEvent();
 end
 if JY.Tid==3 then--张飞
 talk( 3,"如果那样决定了的话，我们就马上返回徐州吧．");
 end
 ]]--
 end,
 [200]=function()
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(9,25,9,1);
 AddPerson(17,14,9,3);
 AddPerson(18,12,10,3);
 AddPerson(19,25,15,2);
 AddPerson(20,23,16,2);
 AddPerson(84,21,17,2);
 AddPerson(1,3,20,0);
 SetSceneID(85);
 MovePerson(1,7,0);
 talk( 9,"刘备，你来得正好，我有话要对你说．",
 1,"对我说？",
 1,"（什么事呢？不会是那个计划吧，怎么会呢？）",
 9,"听满宠说吧．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [201]=function()
 if JY.Tid==9 then--曹操
 talk( 9,"刘备，详细情况你问满宠吧．");
 end
 if JY.Tid==17 then--夏侯惇
 talk( 17,"听满宠讲．");
 end
 if JY.Tid==18 then--夏侯渊
 talk( 18,"听满宠讲．");
 end
 if JY.Tid==19 then--曹仁
 talk( 19,"听满宠讲．");
 end
 if JY.Tid==20 then--曹洪
 talk( 20,"听满宠讲．");
 end
 if JY.Tid==84 then--满宠
 talk( 1,"满宠，你想说什么？",
 84,"对您可能是个悲伤的消息．",
 1,"……（该不是那个计划吧？）",
 84,"公孙瓒被袁绍消灭了．",
 1,"什么？公孙瓒？",
 84,"是的，袁绍消灭了公孙瓒，建立一个强大的领地．",
 1,"是吗？",
 84,"还有，据说袁术听到这个消息后，为保住自己，正赶向袁绍所在的邺城，如果袁绍和袁术携手起来，就谁也不能战胜他们．",
 1,"……（对，利用这句话好摆脱曹操．）");
 talk( 1,"曹操，我有一个请求……",
 9,"什么请求？");
 local menu={
 {" 为讨伐袁绍出征",nil,1},
 {" 为讨伐袁术出征",nil,1},
 {" 拜谒公孙瓒之墓",nil,1},
 }
 while true do
 local r=ShowMenu(menu,3,0,0,0,0,0,2,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 1,"不能任袁绍这样骄横跋扈，我想出征讨伐袁绍，请求您批准我讨伐袁绍．",
 9,"是啊…………不过，现在袁绍的实力大增，以你手里的兵力不能取胜，因此不能让你出征．最近我要和袁绍有个了断，刘备，到那时你再出力吧",
 1,"……");
 elseif r==2 then
 talk( 1,"刚才满宠说袁术已经动身了，请允许我讨伐袁术．",
 9,"刘备，你要出征吗？",
 1,"这样既可阻止袁绍与袁术会合，又可为公孙瓒报仇．",
 9,"好．……嗯，准战．",
 1,"那我马上去作出征准备．");
 talk( 84,"刘备，听说袁术正在广陵驻紮．",
 1,"在广陵，我知道了，那我告辞了．",
 9,"祝你凯旋回来．");
 --显示任务目标:<为讨伐袁术进军广陵．>
 break;
 elseif r==3 then
 talk( 1,"以前公孙瓒十分照顾我，真遗憾，现在已没机会报答他的恩情了，我想至少该去北平拜谒一下他的陵墓．",
 9,"这是你的真心话，北平现在已是袁绍的领地了，去那里太危险，打消这个念头吧．",
 1,"……");
 end
 end
 NextEvent();
 end
 end,
 [202]=function()
 if JY.Tid==9 then--曹操
 talk( 9,"要彻底打垮袁术！",
 1,"那我马上去作出征准备．");
 MovePerson(1,9,1);
 DecPerson(1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==17 then--夏侯惇
 talk( 17,"刘备，你是为什么投奔到这里来的？");
 end
 if JY.Tid==18 then--夏侯渊
 talk( 18,"区区袁术小儿，根本用不着我出征．");
 end
 if JY.Tid==19 then--曹仁
 talk( 19,"不可大意，因为不知道会出现什么事情的．");
 end
 if JY.Tid==20 then--曹洪
 talk( 20,"袁术是个自封为皇帝的假皇帝，刘备，该杀死这个假皇帝．");
 end
 if JY.Tid==84 then--满宠
 talk( 84,"听说袁术在广陵，祝你胜利．");
 end
 end,
 [203]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(1,3,20,0);
 AddPerson(2,16,10,3);
 AddPerson(3,14,11,3);
 SetSceneID(77,5);
 MovePerson(1,6,0);
 talk( 1,"关羽，张飞，出征！",
 3,"这么突然，搞什么名堂？",
 1,"我找到摆脱曹操的藉口了，听说袁术现在广陵，我们去打他．",
 2,"对啦，是不是讨伐袁术后就不回许昌了，去徐州，曹操没怀疑吧？",
 1,"没有怀疑．",
 3,"好哇，呀，我还一直担心就得这样在许昌待下去了，太好了，要打仗了，我手都痒了．那么，我去告诉简雍他们．");
 MovePerson(3,8,1);
 DecPerson(3);
 talk( 2,"兄长，出兵广陵前你是不是该去见一下圣上．",
 1,"是的，那我去一下皇宫就回来．",
 2,"我们趁这个时间里作出征准备．");
 --显示任务目标:<去皇宫见献帝．>
 MovePerson(1,8,1);
 DecPerson(1);
 NextEvent();
 end,
 [204]=function()
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(383,7,8,3);
 AddPerson(384,19,8,1);
 AddPerson(1,37,23,2);
 SetSceneID(84,8);
 MovePerson(1,8,2);
 talk( 383,"噢，皇叔，刚才董承上奏朕了．朕很高兴．",
 384,"陛下，您声音太大，小心些，皇叔此来有什么事？",
 1,"其实这次是因为讨伐袁术，要离开许昌．",
 383,"什么？那样的话，不是长时间见不到皇叔了吗？这……");
 talk( 384,"刘备，现在你不在了，我们的誓约？",
 1,"我正是为了誓约而来．",
 384,"嗯．",
 1,"誓约我没有忘，可是在许昌总是被曹操盯着，与其这样，我还不如利用这次出征机会离开许昌，摆脱曹操．",
 384,"确实如此，而且我们见面太多，也会加重曹操的疑心．好吧，我对圣上说，你放心吧．");
 talk( 384,"噢，皇叔，刚才董承上奏朕了．朕很高兴．",
 383,"什么？嗯嗯，确实如此，是啊，不愧是皇叔，我知道了，那么，皇叔就慢慢地扩充实力展翅高飞吧．",
 1,"明白了，臣告辞了．");
 --显示任务目标:<为讨伐袁术出兵广陵．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [205]=function()
 if JY.Tid==384 then--董承
 talk( 384,"刘备，我们期待着你．");
 end
 if JY.Tid==383 then--献帝
 talk( 383,"皇叔，你慢慢扩充实力吧．",
 1,"明白了，臣告辞了．");
 MovePerson(1,9,3);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [206]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(1,3,20,0);
 AddPerson(2,16,10,3);
 SetSceneID(77,5);
 MovePerson(1,6,0);
 talk( 2,"兄长，我们在等你，已准备好了，赶快出发吧．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [207]=function()
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"出发吗？") then
 RemindSave();
 PlayBGM(12);
 WarIni();
 DefineWarMap(15,"第一章 广陵之战","一、袁术的溃败．",30,0,11);
 -- id,x,y, d,ai --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,4,2, 4,0,-1,0,
 -1,6,2, 4,0,-1,0,
 -1,5,3, 4,0,-1,0,
 -1,5,5, 4,0,-1,0,
 -1,4,4, 4,0,-1,0,
 -1,3,1, 4,0,-1,0,
 -1,3,3, 4,0,-1,0,
 });
 DrawSMap();
 talk( 2,"那就出发吧，如果让曹操知道了我们的真实意图就惨了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [208]=function()
 JY.Smap={};
 SetSceneID(0,11);
 DrawMulitStrBox("　且说袁术这里，袁术自封为皇帝后，过着极其奢侈的生活，他终于被民众抛弃了．");
 DrawMulitStrBox("　袁术支撑不下去了，他现在去投奔哥哥袁绍，奔冀州而来．");
 DrawMulitStrBox("　袁术的队伍可以说是他过去搜刮的集大成，金银财宝列成长蛇阵，百姓哀声不绝于耳．");
 talk( 12,"喂！快走！想让刘备抓住我吗？快！",
 355,"唉，饶命．",
 12,"谁再慢吞吞就杀了他，挡我前进之路的就杀了他．");
 SetSceneID(0,3);
 talk( 2,"兄长，快向广陵进军吧．",
 83,"广陵在许昌的东面，主公，我们进军吧．");
 NextEvent();
 end,
 [209]=function()
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 11,17,15, 2,1,20,2, 0,0,-1,0,
 42,16,14, 2,1,16,5, 0,0,-1,0,
 69,17,11, 2,1,17,8, 0,0,-1,0,
 66,18,12, 2,1,17,2, 0,0,-1,0,
 71,18,14, 2,1,16,2, 0,0,-1,0,
 31,15,15, 2,1,16,5, 0,0,-1,0,
 256,18,13, 2,1,14,1, 0,0,-1,0,
 257,18,10, 2,1,13,1, 0,0,-1,0,
 274,16,12, 2,1,14,4, 0,0,-1,0,
 275,15,12, 2,1,13,4, 0,0,-1,0,
 328,17,13, 2,1,13,13, 0,0,-1,0,
 329,19,12, 2,1,13,13, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [210]=function()
 PlayBGM(11);
 talk( 12,"说什么？刘备来了，嗯，可恶的卖蓆小儿，可恶，全军攻击刘备．",
 1,"好哇，要杀死那个坏蛋，进攻袁术．");
 WarShowTarget(true);
 PlayBGM(13);
 NextEvent();
 end,
 [211]=function()
 if WarMeet(3,70) then
 WarAction(1,3,70);
 talk( 3,"你们这些国贼，胆敢随意自封皇帝，为所欲为，我来杀你！",
 70,"谁听你的胡言乱语！张飞！看我杀你！");
 if fight(3,70)==1 then
 talk( 70,"看我一刀！");
 WarAction(9,70,3);
 talk( 3,"啊呀呀，好险呀！这次轮到我给你一枪！");
 WarAction(8,3,70);
 talk( 70,"妈呀！",
 3,"中枪了！");
 WarAction(18,70);
 WarLvUp(GetWarID(3));
 talk( 3,"这还痛快些，噢，纪灵这家伙的武器还不错，作为战利品拿回去．");
 WarGetItem(3,14);
 else
 talk( 70,"看我一刀！");
 WarAction(8,70,3);
 talk( 3,"妈呀！中枪了！");
 WarAction(17,3);
 WarLvUp(GetWarID(70));
 end
 
 end
 if JY.Status==GAME_WARWIN then
 talk( 12,"唉，我怎么会败给刘备小儿？");
 PlayBGM(7);
 DrawMulitStrBox("　杀了袁术，刘备军大破袁术军．");
 GetMoney(600);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金６００．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 WarLocationItem(7,18,12,189); --获得道具:获得道具：七星剑
 --[[ --改为获取道具
 if (not GetFlag(190)) and WarCheckLocation(-1,3,13) then
 --33 检查事件:03 00 01 BE
 GetMoney(400);
 DrawStrBoxCenter("缴获黄金４００！")
 SetFlag(190,1);
 end 
 ]]--
 WarLocationItem(3,13,106,190);
 end,
 [212]=function()
 SetSceneID(0,3);
 talk( 3,"没想到袁术也太不中用了．",
 2,"我们进下邳吧，进了下邳，就是曹操来，也能守住．",
 64,"是啊，听说曹操的心腹车胄在徐州，徐州是个隐患．",
 1,"知道了，那么就进驻下邳吧．在那里研究一下对付曹操的策略．");
 --显示任务目标:<在下邳研究今后的对策．>
 NextEvent();
 end,
 [213]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="下邳";
 JY.Base["道具屋"]=9;
 AddPerson(1,25,17,2);
 AddPerson(2,11,16,0);
 AddPerson(3,9,15,0);
 AddPerson(64,7,14,0);
 AddPerson(83,22,10,1);
 AddPerson(65,20,9,1);
 SetSceneID(54,5);
 DrawStrBoxCenter("下邳议事厅");
 PlayBGM(11);
 AddPerson(82,1,5,3);
 MovePerson(82,7,3);
 talk( 82,"主公，不好啦！");
 --显示任务目标:<研究今后对策．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [214]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"糜芳有话说，请听他讲．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"刚打了胜仗，还能有什么事．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"请听糜芳说．");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"请听听我弟弟说什么．");
 end
 if JY.Tid==82 then--糜芳
 JY.Status=GAME_SMAP_AUTO;
 talk( 82,"主公，刚刚听到消息，董承等人被曹操杀害了．",
 1,"什么？被杀了，怎么被杀的？");
 NextEvent();
 end
 if JY.Tid==83 then--简雍
 talk( 83,"先听糜芳说吧．");
 end
 end,
 [215]=function()
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(383,7,8,3);
 AddPerson(9,13,11,2);
 AddPerson(69,19,8,2);--1
 AddPerson(17,21,9,2);
 AddPerson(18,23,10,2);
 AddPerson(62,9,14,2);--0
 AddPerson(19,11,15,2);
 AddPerson(20,13,16,2);
 SetSceneID(84,8);
 LoadPic(11,1);
 DrawMulitStrBox("　董承等人策划暗杀曹操的计划，在付诸实施的前一刻，走漏了消息，曹操得到消息后大怒，残杀了董承等首谋并诛连九族，被杀者达７００余人．");
 LoadPic(11,2);
 DrawStrBoxCenter("许昌宫殿");
 talk( 9,"圣上大概不至于知道这个暗杀计划吧．",
 383,"这个，朕不知道．",
 9,"那就好，呀，请圣上宽恕臣的失礼．",
 383,"……（董承，朕对不起你．）");
 MovePerson(9,0,3);
 talk( 9,"可是，我决不能饶恕刘备，以前他从淮南遇难逃出来时，我保护他，他却忘恩负义．全军，准备出征，我亲自出马．",
 17,"遵命！",
 9,"还有，传令徐州的车胄，讨伐下邳的刘备．");
 
 NextEvent();
 end,
 [216]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="下邳";
 JY.Base["道具屋"]=9;
 AddPerson(1,25,17,2);
 AddPerson(2,11,16,0);
 AddPerson(3,9,15,0);
 AddPerson(64,7,14,0);
 AddPerson(83,22,10,1);
 AddPerson(65,20,9,1);
 AddPerson(82,15,12,3);
 SetSceneID(54);
 talk( 82,"这样一来，主公参与谋杀曹操的事情也暴露了．听说曹操已命令徐州的车胄，讨伐我们．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [217]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"怎么会呢？这么快就暴露了．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"不过，大哥，只要坚守这里就没问题．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"主公，怎么办？");
 end
 if JY.Tid==65 then--糜竺
 JY.Status=GAME_SMAP_AUTO;
 talk( 65,"以我军的力量，实在打不过曹操军．",
 1,"嗯．");
 AddPerson(369,1,5,3);
 MovePerson(369,3,3);
 talk( 369,"报告，徐州的车胄正着手准备进攻这里．",
 2,"什么？车胄也要进攻这里．",
 64,"主公，我们与其在这里等死，还不如去攻占徐州，然后在小沛、徐州、下邳三城迎击曹操军，这样还可以分散曹操军的兵力．",
 1,"好主意，小沛我来守．我这就去．");
 MovePerson(3,2,2);
 MovePerson(3,2,0);
 MovePerson(3,8,2);
 DecPerson(3);
 talk( 2,"张飞，这个急性子，也不商量就走．");
 MovePerson(2,2,3);
 MovePerson(2,2,0);
 MovePerson(2,0,3);
 talk( 2,"兄长，剩下的两座城由谁来把守？");
 talk( 1,"嗯，是啊，关羽，你守这座城．",
 2,"是．",
 1,"其余的人就奇袭徐州的车胄，快做准备吧．");
 MovePerson( 64,10,2,
 65,10,2,
 82,10,2,
 83,10,2,
 369,10,2);
 DecPerson(64);
 DecPerson(65);
 DecPerson(82);
 DecPerson(83);
 DecPerson(369);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"据说曹操已率大军杀往徐州．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"遭了，如果曹操亲统大军前来，我们打不过的．");
 end
 end,
 [218]=function()
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"出征吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 2,"编成部队．");
 ModifyForce(2,0);
 ModifyForce(3,0);
 WarIni();
 DefineWarMap(8,"第一章 徐州II之战","一、车胄的毁灭．",50,0,8);
 -- id,x,y, d,ai --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,4,1, 4,0,-1,0,
 -1,4,2, 4,0,-1,0,
 -1,5,0, 4,0,-1,0,
 -1,5,3, 4,0,-1,0,
 -1,7,0, 4,0,-1,0,
 -1,3,1, 4,0,-1,0,
 -1,3,2, 4,0,-1,0,
 -1,6,1, 4,0,-1,0,
 -1,6,2, 4,0,-1,0,
 });
 DrawSMap();
 talk( 2,"兄长，多保重．",
 1,"你也要牢牢守住这座城．",
 2,"我死守此城．");
 JY.Smap={};
 SetSceneID(0,3)
 talk( 64,"向徐州进军．");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 89,29,12, 3,2,21,2, 0,0,-1,0,
 256,17,2, 3,6,17,2, 19,5,-1,0,
 257,24,6, 3,0,17,2, 0,0,-1,0,
 258,13,14, 3,6,16,1, 24,13,-1,0,
 274,17,0, 3,6,17,5, 19,4,-1,0,
 275,26,6, 3,0,17,4, 0,0,-1,0,
 276,18,13, 3,6,16,4, 26,11,-1,0,
 292,18,6, 3,0,17,8, 0,0,-1,0,
 293,25,2, 3,6,16,7, 26,13,-1,0,
 8,3,1, 4,1,30,9, 0,0,-1,1,
 61,12,1, 4,1,21,16, 0,0,-1,1,
 16,5,3, 4,1,21,8, 0,0,-1,1,
 17,8,0, 4,1,21,22, 0,0,-1,1,
 18,5,0, 4,1,21,2, 0,0,-1,1,
 ---
 19,15,1, 4,1,21,24, 0,0,-1,1,
 62,26,3, 4,1,20,2, 0,0,-1,1,
 115,27,0, 4,1,20,2, 0,0,-1,1,
 67,2,2, 4,1,21,8, 0,0,-1,1,
 76,13,0, 4,1,21,13, 0,0,-1,1,
 77,26,1, 4,1,21,5, 0,0,-1,1,
 68,9,1, 4,1,21,13, 0,0,-1,1,
 310,18,3, 4,1,17,11, 0,0,-1,1,
 311,7,2, 4,1,17,11, 0,0,-1,1,
 348,11,2, 4,1,17,19, 0,0,-1,1,
 277,23,0, 4,1,16,5, 0,0,-1,1,
 278,10,1, 4,1,17,4, 0,0,-1,1,
 279,17,2, 4,1,16,4, 0,0,-1,1,
 332,22,1, 4,1,17,14, 0,0,-1,1,
 ---
 386,4,1, 4,3,24,15, 8,0,-1,1, --典韦S
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [219]=function()
 PlayBGM(11);
 talk( 90,"各位，我们虽然人少，但曹操一定会派援兵的，援兵来之前，我们要守住．",
 64,"主公，我们在这里一磨蹭，曹操就会到的，我们尽快消灭车胄吧．");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [220]=function()
 if JY.Death==90 then
 PlayBGM(7);
 talk( 90,"喂，刘备，你忘了主公的恩情了．全军撤退．");
 WarAction(16,90);
 WarAction(16,257);
 WarAction(16,258);
 WarAction(16,259);
 WarAction(16,275);
 WarAction(16,276);
 WarAction(16,277);
 WarAction(16,293);
 WarAction(16,294);
 DrawStrBoxCenter("车胄军全军撤退．");
 talk( 82,"好像已经没有敌人了，主公，我们进城吧．");
 PlayBGM(9);
 War.WarTarget="一、刘备进入徐州．";
 WarShowTarget(false);
 NextEvent();
 end
 end,
 [221]=function()
 if WarCheckArea(0,10,29,14,29) then
 talk( 1,"嗯？怎么回事？这些马蹄声？怎么会呢？");
 PlayBGM(11);
 WarShowArmy(8);
 WarShowArmy(386);
 WarShowArmy(61);
 WarShowArmy(16);
 WarShowArmy(17);
 WarShowArmy(18);
 WarShowArmy(19);
 WarShowArmy(62);
 WarShowArmy(115);
 WarShowArmy(67);
 WarShowArmy(76);
 WarShowArmy(77);
 WarShowArmy(68);
 WarShowArmy(310);
 WarShowArmy(311);
 WarShowArmy(348);
 WarShowArmy(277);
 WarShowArmy(278);
 WarShowArmy(279);
 WarShowArmy(332);
 DrawStrBoxCenter("曹操出现．");
 talk( 9,"哼！刘备！你想跑也跑不掉了！你最好知道想杀我的人有什么下场！",
 64,"主公，我们完全被包围了．",
 83,"主公，小沛被攻克了．",
 65,"主公，下邳被曹操进攻，我们被包围了．",
 1,"嗯，曹操果然厉害，真是兵贵神速．",
 64,"主公，现在无计可施了，去邺城投袁绍吧，在那里谋求东山再起，先逃到西南的村落再想办法．总之，现在要离开这里．");
 PlayBGM(10);
 War.WarTarget="一、曹操撤退．*二、刘备到达西南村．";
 WarShowTarget(false);
 NextEvent();
 end
 end,
 [222]=function()
 if JY.Status==GAME_WARWIN then
 talk( 9,"噢，刘备这个家伙，还算厉害，暂且退兵，重新编组全军．",
 1,"好像是暂时退兵，不过看样子很快还会进攻，为了脱身，去邺城吧．");
 PlayBGM(7);
 DrawMulitStrBox("　曹操退兵了，刘备冲出曹操军的包围．");
 GetMoney(600);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金６００．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if WarCheckLocation(0,16,1) then
 WarGetExp(50);
 PlayBGM(4);
 talk( 1,"别人怎么样了？");
 DrawMulitStrBox("　刘备逃离了战场．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end 
 end,
 [223]=function()
 SetSceneID(0,5);
 talk( 64,"主公！",
 1,"噢！孙乾，没事吧．其他人怎么样？",
 64,"不知道，我也是九死一生，没有简雍等人的消息．",
 1,"是吗？关羽和张飞怎么样了？也不知道是死是活？",
 64,"凭他们的二人的英勇，不会有事的，暂且去邺城吧．");
 SetSceneID(0);
 talk( 1,"关羽，张飞，也不知道是死是活？那是谁？",
 65,"啊呀！");
 SetSceneID(0);
 talk( 1,"噢，糜竺，你没事吧？糜竺，看见其他人了吗？",
 65,"没有，我只能顾自己跑了．",
 1,"是这样．好吧，投奔袁绍去．现在也只有这条路了．",
 65,"是．");
 --显示任务目标:<去邺城见袁绍．>
 NextEvent();
 end,
 [224]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="邺";
 JY.Base["道具屋"]=10;
 AddPerson(10,10,17,0);
 AddPerson(50,10,9,3);
 AddPerson(93,12,8,3);
 AddPerson(51,24,17,2);
 AddPerson(92,26,16,2);
 AddPerson(1,33,5,1);
 SetSceneID(83);
 DrawStrBoxCenter("邺城议事厅");
 MovePerson(1,8,1)
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [225]=function()
 if JY.Tid==50 then--田丰
 talk( 50,"先请我们主公讲话．");
 end
 if JY.Tid==51 then--沮授
 talk( 51,"听说是被曹操追赶来的，想必这次很落魄吧．");
 end
 if JY.Tid==92 then--审配
 talk( 92,"虽然战败，曹操也追不到这里，现在这块领地毕竟势力还很强大．");
 end
 if JY.Tid==93 then--郭图
 talk( 93,"哼，这个丧家犬，杀了主公的弟弟，却敢跑到这里来．");
 end
 if JY.Tid==10 then--袁绍
 JY.Status=GAME_SMAP_AUTO;
 talk( 10,"刘备，欢迎你来，听说你被曹操打得很惨．你到我这里可以放心了，我也很担心曹操最近的态度，你在这里养精蓄锐，我们一起讨伐曹操吧．");
 NextEvent();
 end
 end,
 --第二章开始
 --第二章　官渡之战
 [226]=function()
 SetSceneID(-1,0);
 JY.Base["章节名"]="第二章　官渡之战";
 DrawStrBoxCenter("第二章　官渡之战");
 LoadPic(12,1);
 DrawMulitStrBox("　刘备从曹操那里逃到了冀州的邺城．*　治理冀州的袁绍，拥有比曹操更强大的兵力，倚仗着这个兵力，他决心和曹操进行决战．曹操虽然实力不如袁绍，但也不屈服，两人在官渡展开了一场大战．")
 LoadPic(12,2);
 
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="邺";
 JY.Base["道具屋"]=10;
 AddPerson(1,3,20,0);
 AddPerson(64,16,10,3);
 AddPerson(65,14,11,3);
 SetSceneID(77,5);
 DrawStrBoxCenter("邺城刘备公馆");
 DrawMulitStrBox("　刘备和孙乾、糜竺一起在邺城向袁绍借官邸度日．时间过了一天又一天，关羽和张飞的下落至今还没有消息，每天都过得很不开心．");
 talk( 64,"主公，我一直在等你．");
 MovePerson(1,6,0);
 --显示任务目标:<与孙乾谈论今后之事．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [227]=function()
 if JY.Tid==64 then--孙乾
 JY.Status=GAME_SMAP_AUTO;
 talk( 64,"主公，袁绍派来一名快使，请你马上去白马城．",
 1,"可是现在关羽和张飞还都没有找到，我担心得不得了，那里还有心思去白马城．",
 64,"我了解您的心情．可是……");
 talk( 65,"主公，既然如此担心的话，我去找关羽和张飞吧．",
 1,"噢，那就快点去吧．",
 65,"我马上就去．");
 MovePerson(65,8,1);
 JY.Status=GAME_SMAP_MANUAL;
 --显示任务目标:<去白马城见袁绍．>
 NextEvent();
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"主公，不用那么担心，关羽和张飞一定还在什么地方活着．");
 end
 end,
 [228]=function()
 if JY.Tid==64 then--孙乾
 JY.Status=GAME_SMAP_AUTO;
 talk( 64,"可是袁绍也请你马上就去，是什么事呢？主公，马上去白马城吧．",
 1,"好吧．");
 MovePerson(1,9,1);
 NextEvent();
 end
 end,
 [229]=function()
 JY.Smap={};
 JY.Base["现在地"]="白马";
 JY.Base["道具屋"]=11;
 AddPerson(10,25,17,2);
 AddPerson(51,22,10,1);
 AddPerson(53,20,9,1);
 AddPerson(55,18,8,1);
 AddPerson(93,11,16,0);
 AddPerson(103,9,15,0);
 AddPerson(92,7,14,0);
 AddPerson(1,1,5,3);
 SetSceneID(54,11);
 DrawStrBoxCenter("白马议事厅");
 talk( 10,"是刘备吗，哼，你来得正好．");
 MovePerson(1,7,3);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [230]=function()
 if JY.Tid==51 then--沮授
 talk( 51,"颜良被关羽杀了．颜良是我军屈指可数的一员大将，对这一损失，你怎么说？");
 end
 if JY.Tid==93 then--郭图
 talk( 93,"你这个忘恩负义之徒，我主公对你有恩，你却勾结曹操．");
 end
 if JY.Tid==53 then--文丑
 talk( 53,"他妈的，竟敢杀我兄长！");
 end
 if JY.Tid==55 then--逢纪
 talk( 55,"你这个背信忘义之徒！");
 end
 if JY.Tid==103 then--张郃
 talk( 103,"你这个背信忘义之徒！");
 end
 if JY.Tid==92 then--审配
 talk( 92,"你这个背信忘义之徒！");
 end
 if JY.Tid==10 then--袁绍
 JY.Status=GAME_SMAP_AUTO;
 talk( 10,"哼！你还有脸来吗？",
 1,"到底是怎么回事呢？",
 10,"别装傻了，杀颜良的是不是你的部下关羽？",
 1,"那真是关羽吗？",
 10,"我的部下说，敌将是一个长髯的家伙．这不正是关羽吗？你在勾结曹操啊！快承认勾结的事吧！杀颜良的是关羽吧？");
 local menu={
 {" 是，那人是关羽",nil,1},
 {" 不，那不是关羽",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,C_WHITE,C_WHITE);
 if r==2 then
 talk( 10,"什么，你说不是关羽？",
 1,"是的，第一，我不知道关羽现在是否还活着．第二，只说有长髯，那不见得就是关羽啊！",
 10,"你说的也是．也许是个貌似关羽的武将．啊，刘备，不该对你发脾气．对不起．",
 1,"哪里，我不介意．",
 10,"让你大老远来一趟，对不起，你回邺城好好地休息一下吧．");
 PlayBGM(5);
 --显示任务目标:<回到邺城官邸．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 else
 talk( 10,"哼！招认倒是很老实啊，但你是个傻瓜，来人，把这个背信忘义的小人给我拉出去斩啦．");
 PlayBGM(4);
 DrawMulitStrBox("　刘备被杀了，*　刘备重振汉室声威的梦想也同时破灭了．");
 --游戏失败:
 NextEvent(999); --Goto 999
 end
 end
 end,
 [231]=function()
 if JY.Tid==51 then--沮授
 talk( 51,"主公……");
 end
 if JY.Tid==93 then--郭图
 talk( 93,"你骗不了我，颜良哪是那么简单就被无名武将杀死之人？");
 end
 if JY.Tid==53 then--文丑
 talk( 53,"呀，刘备，刚才怀疑你对不起．");
 end
 if JY.Tid==55 then--逢纪
 talk( 55,"主公……");
 end
 if JY.Tid==103 then--张郃
 talk( 103,"好像有些不自然呀，是不是因为心情的关系？请不要介意．");
 end
 if JY.Tid==92 then--审配
 talk( 92,"主公……");
 end
 if JY.Tid==10 then--袁绍
 JY.Status=GAME_SMAP_AUTO;
 talk( 10,"你回邺城好好休息吧．");
 MovePerson(1,9,2);
 NextEvent();
 end
 end,
 [232]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="邺";
 JY.Base["道具屋"]=10;
 AddPerson(1,3,20,0);
 AddPerson(64,16,10,3);
 AddPerson(83,14,11,3);
 AddPerson(82,12,12,3);
 SetSceneID(77);
 talk( 64,"主公，大喜事，就在刚才，一直没有消息的糜竺和糜芳来了．");
 MovePerson(1,6,0);
 --显示任务目标:<与孙乾等谈论今后之事．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [233]=function()
 if JY.Tid==64 then--孙乾
 talk( 64,"主公，大喜事，就在刚才，一直没有消息的糜竺和糜芳来了．");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"我们也在那次交战中得以侥幸逃生，听说主公在这里，我们就来了．");
 end
 if JY.Tid==83 then--简雍
 JY.Status=GAME_SMAP_AUTO;
 talk( 83,"主公，终于见到您了．可是，关羽不在吗？",
 1,"不在，从那之后一直没有他的消息．",
 83,"是吗……唉，我们在来的半途中，看见曹操营中好像有个人像关羽．当时还觉得怎么可能是呢，这样的话，那人极有可能就是关羽．",
 1,"那么，刚才袁绍说的也许是真的．",
 83,"是什么事？",
 1,"其实刚才袁绍要杀我，他说颜良被一个长得很像关羽的武将给杀了．",
 83,"这就对了，可是袁绍没有仔细盘问吗？",
 1,"我设法给搪塞过去了，可是这是怎么回事呢？");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [234]=function()
 if JY.Tid==64 then--孙乾
 talk( 64,"颜良被人杀了的事，我在想，就是关羽杀的．");
 end
 if JY.Tid==82 then--糜芳
 JY.Status=GAME_SMAP_AUTO;
 talk( 82,"嗯？主公，好像是使者．");
 AddPerson(365,3,20,0);
 MovePerson(1,0,1);
 MovePerson(365,5,0);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 if JY.Tid==83 then--简雍
 talk( 83,"因为我没有看清楚，所以也不敢说是关羽杀的．");
 end
 end,
 [235]=function()
 if JY.Tid==64 then--孙乾
 talk( 64,"又是袁绍派来的吧？这次有什么事呢？");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"主公，听使者讲吧．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"主公，先听使者讲吧．");
 end
 if JY.Tid==365 then--使者
 JY.Status=GAME_SMAP_AUTO;
 talk( 365,"我是主公袁绍派来的使者．在白马一战，文丑被敌人杀死．主公现在回到了邺城，有事请刘备，请马上去邺城的议事厅．那么我告辞了．");
 MovePerson(365,8,1);
 DecPerson(365);
 talk( 64,"步颜良后尘，这次文丑也被杀了．听说文丑比颜良还要厉害．能杀死这样武将的恐怕……",
 1,"只有关羽啊．",
 64,"主公，恐怕袁绍这次找你同上次一样．又是那员武将像关羽的事．而且，那员武将恐怕就是关羽．",
 1,"我也这样想．",
 64,"可是一承认是关羽的话，罪责就要由主公承担了．现在不如说是曹操的阴谋，关羽也可能是因为有什么事才帮曹操的．",
 1,"知道了，那我就在去一趟袁绍那里吧．");
 --显示任务目标:<去议事厅见袁绍．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [236]=function()
 if JY.Tid==64 then--孙乾
 JY.Status=GAME_SMAP_AUTO;
 talk( 64,"主公，请您一定要多加小心．");
 MovePerson(1,9,1);
 NextEvent();
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"我们在这里等着主公回来．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"可是关羽为什么要帮助曹操呢？");
 end
 end,
 [237]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="邺";
 JY.Base["道具屋"]=10;
 AddPerson(10,10,17,0);
 AddPerson(93,10,9,3);
 AddPerson(103,12,8,3);
 AddPerson(106,14,7,3);
 AddPerson(51,24,17,2);
 AddPerson(55,26,16,2);
 AddPerson(92,28,15,2);
 AddPerson(1,33,5,1);
 SetSceneID(83,11);
 DrawStrBoxCenter("邺城议事厅");
 talk( 10,"来了啊，你这个骗子！我这次可不会再让你骗了．");
 MovePerson(1,8,1)
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [238]=function()
 if JY.Tid==51 then--沮授
 talk( 51,"这回不要狡辩了，因为我也亲眼看见了．");
 end
 if JY.Tid==93 then--郭图
 talk( 93,"这次文丑被杀，你怎样补偿这一损失？这场戏有的看了．");
 end
 if JY.Tid==55 then--逢纪
 talk( 55,"你这个骗子！还挺会装啊！");
 end
 if JY.Tid==92 then--审配
 talk( 92,"你这个骗子！还挺会装啊！");
 end
 if JY.Tid==103 then--张郃
 talk( 103,"你这个骗子！还挺会装啊！");
 end
 if JY.Tid==106 then--淳于琼
 talk( 106,"你这个骗子！还挺会装啊！");
 end
 if JY.Tid==10 then--袁绍
 JY.Status=GAME_SMAP_AUTO;
 talk( 10,"刘备，你到底还是私通曹操啊！连文丑也给杀了，招认吧，那员武将是不是关羽．");
 local menu={
 {" 这不妙，快逃吧",nil,1},
 {" 这是曹操的计谋",nil,1},
 {" 　不是关羽",nil,1},
 }
 local r=ShowMenu(menu,3,0,0,0,0,0,2,0,16,C_WHITE,C_WHITE);
 if r==1 then
 MovePerson(1,2,0)
 talk( 10,"刘备，想逃！谁去替我杀掉这个叛逆！",
 103,"我去！");
 MovePerson(103,2,0);
 MovePerson(103,4,3);
 MovePerson(103,0,1);
 talk( 103,"叛逆！你死定了．",
 1,"啊……！");
 DecPerson(1);
 PlayBGM(4);
 DrawMulitStrBox("刘备被杀了．刘备重振汉室声威的梦想也在此破灭了．");
 --游戏失败:
 NextEvent(999);
 elseif r==2 then
 talk( 10,"什么？这是曹操的计谋？",
 1,"是的．曹操知道我在你的营中，所以故意让关羽杀了颜良和文丑．这是曹操想借你的手杀我．请你消除对我的疑虑．",
 10,"唉……曹操的确很狡诈．刘备，对不起，我刚才险些中了曹操的计．",
 51,"主公！不要听信刘备的花言巧语．",
 93,"对，不能相信这种人的话．",
 10,"别罗唆了！你们是想让我杀死刘备！混蛋！你们俩都给我退下！",
 51,"主公……");
 MovePerson( 51,9,0,
 93,9,0);
 DecPerson(51);
 DecPerson(93);
 PlayBGM(5);
 --显示任务目标:<在官邸与孙乾等谈论今后之事．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 else
 talk( 10,"胡说！这次是沮授在近处亲眼看到的．把这个大骗子给我拉下去砍了．");
 PlayBGM(4);
 DrawMulitStrBox("然后刘备就被杀害了．刘备重振汉室声威的梦想也破灭了．");
 --游戏失败:
 NextEvent(999); --Goto 999
 end
 end
 end,
 [239]=function()
 if JY.Tid==10 then--袁绍
 JY.Status=GAME_SMAP_AUTO;
 talk( 10,"刘备，接连怀疑你两次，真是对不起．快回官邸去休息吧．");
 MovePerson(1,10,0);
 NextEvent();
 end
 if JY.Tid==55 then--逢纪
 talk( 55,"虽然有点不通，但也就算了吧．");
 end
 if JY.Tid==92 then--审配
 talk( 92,"唉，是曹操的计谋？是真的吗？");
 end
 if JY.Tid==103 then--张郃
 talk( 103,"虽然有点说不通，唉，但也就算了吧．");
 end
 if JY.Tid==106 then--淳于琼
 talk( 106,"虽然有点说不通，唉，但也就算了吧．");
 end
 end,
 [240]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="邺";
 JY.Base["道具屋"]=10;
 AddPerson(1,3,20,0);
 AddPerson(64,16,10,3);
 AddPerson(65,14,11,3);
 AddPerson(83,12,12,3);
 AddPerson(82,10,13,3);
 SetSceneID(77);
 talk( 64,"噢，主公，你没事吧，啊．糜竺回来了．");
 MovePerson(1,6,0);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [241]=function()
 if JY.Tid==64 then--孙乾
 talk( 64,"主公，糜竺回来了，听他汇报情况吧．");
 end
 if JY.Tid==65 then--糜竺
 JY.Status=GAME_SMAP_AUTO;
 talk( 65,"主公，我回来了．关羽是在曹营．我设法和他联系上了．他现在正离开许昌，向这里赶来．",
 1,"噢，是吗．",
 65,"另外，张飞在离此不太远的南面古城，据说是和一伙山贼在一起，我和他没联系上．",
 1,"是吗？张飞也没出事啊．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"主公，我哥哥回来了，听他汇报情况吧．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"主公，糜竺回来了，听他汇报情况吧．");
 end
 end,
 [242]=function()
 if JY.Tid==64 then--孙乾
 JY.Status=GAME_SMAP_AUTO;
 talk( 64,"主公，我们既然已经知道了关羽和张飞的消息，就不要再在这里住下去了．可以向袁绍假称说是去也是他的地盘的汝南，然后我们去张飞落脚的古城．快去求袁绍吧．",
 1,"好吧．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"关羽正朝这里赶来，但曹操一定会阻挠他．我们最好前去迎接他．");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"我们不能在这种地方长住．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"关羽、张飞都还活着啊．太好了！");
 end
 end,
 [243]=function()
 if JY.Tid==64 then--孙乾
 JY.Status=GAME_SMAP_AUTO;
 talk( 64,"我们就在这里等着你．");
 MovePerson(1,9,1);
 NextEvent();
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"我们现在做出发准备．");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"我们不能在这种地方长住．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"关羽、张飞都还活着啊．太好了！");
 end
 end,
 [244]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="邺";
 JY.Base["道具屋"]=10;
 AddPerson(10,10,17,0);
 AddPerson(93,10,9,3);
 AddPerson(92,12,8,3);
 AddPerson(106,14,7,3);
 AddPerson(51,24,17,2);
 AddPerson(55,26,16,2);
 AddPerson(103,28,15,2);
 AddPerson(1,33,5,1);
 SetSceneID(83);
 talk( 10,"啊，刘备，有什么事？");
 MovePerson(1,8,1)
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [245]=function()
 if JY.Tid==51 then--沮授
 talk( 51,"刘备，这次是什么事啊？");
 end
 if JY.Tid==93 then--郭图
 talk( 93,"刘备，这次是什么事啊？");
 end
 if JY.Tid==55 then--逢纪
 talk( 55,"刘备，怎么啦？");
 end
 if JY.Tid==92 then--审配
 talk( 92,"刘备，怎么啦？");
 end
 if JY.Tid==103 then--张郃
 talk( 103,"刘备，怎么啦？");
 end
 if JY.Tid==106 then--淳于琼
 talk( 106,"刘备，怎么啦？");
 end
 if JY.Tid==10 then--袁绍
 JY.Status=GAME_SMAP_AUTO;
 talk( 10,"刘备，怎么啦？",
 1,"我想出一个有利于对曹操作战的方法．",
 10,"什么，是什么方法？",
 1,"如果从正面厮杀，我们也会受到很大伤亡，所以最好调一部分兵去汝南，从曹操军的背后突击．",
 10,"好啊！这样一来，岂不形成对曹操两面夹击之势了？",
 1,"是的，请把这个任务交给我吧．",
 10,"刘备，你为什么要争着做这份苦差使呢？",
 1,"因为听说在曹营里有一员武将长得像关羽，所以我想趁此机会弄个明白．",
 10,"好啊，我虽然相信你，可是我的部下还有人不信任你．我知道了，就这么办吧．",
 1,"谢谢．");
 --显示任务目标:<准备去古城．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [246]=function()
 if JY.Tid==51 then--沮授
 talk( 51,"可疑……");
 end
 if JY.Tid==93 then--郭图
 talk( 93,"可疑……");
 end
 if JY.Tid==55 then--逢纪
 talk( 55,"刘备，努力吧！");
 end
 if JY.Tid==92 then--审配
 talk( 92,"刘备，努力啊！");
 end
 if JY.Tid==103 then--张郃
 talk( 103,"刘备，努力啊！");
 end
 if JY.Tid==106 then--淳于琼
 talk( 106,"刘备，努力啊！");
 end
 if JY.Tid==10 then--袁绍
 JY.Status=GAME_SMAP_AUTO;
 talk( 10,"那就拜托了．");
 MovePerson(1,10,0)
 NextEvent();
 end
 end,
 [247]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="邺";
 JY.Base["道具屋"]=10;
 AddPerson(1,3,20,0);
 AddPerson(64,16,10,3);
 AddPerson(65,14,11,3);
 AddPerson(83,12,12,3);
 AddPerson(82,10,13,3);
 SetSceneID(77);
 talk( 64,"主公，你回来啦．");
 MovePerson(1,6,0);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [248]=function()
 if JY.Tid==64 then--孙乾
 if talkYesNo( 64,"出发吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 64,"说不定会遭到敌军侵袭．列好队伍．");
 ModifyBZ(54,8);
 LvUp(54,7);
 WarIni();
 DefineWarMap(16,"第二章 兖州之战","一﹑郭图的败退．*二﹑刘备到达西南的鹿砦．",45,0,92);
 -- id,x,y, d,ai --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,10,5, 4,0,-1,0,
 -1,11,5, 4,0,-1,0,
 -1,10,4, 4,0,-1,0,
 -1,10,6, 4,0,-1,0,
 -1,9,3, 4,0,-1,0,
 -1,9,5, 4,0,-1,0,
 -1,9,6, 4,0,-1,0,
 -1,12,3, 4,0,-1,0,
 -1,12,4, 4,0,-1,0,
 53,29,7, 3,0,-1,1,
 });
 ModifyForce(54,1);
 DrawSMap();
 talk( 64,"出发吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"赶快去和关羽、张飞会合吧．");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"那么，向古城进发吧．可是，主公，军械等都买好了吗？");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"随时可以出发．请主公也准备好．");
 end
 end,
 [249]=function()
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="邺";
 JY.Base["道具屋"]=10;
 AddPerson(93,10,9,3);
 AddPerson(92,12,8,3);
 AddPerson(51,24,17,2);
 AddPerson(55,26,16,2);
 SetSceneID(83,11);
 talk( 93,"对刘备不加监视，让他随便去汝南吗？",
 55,"是啊！主公为什么会相信这种人？",
 51,"可是，有曹操在，即使刘备背叛了主公，跟曹操比也是无足轻重的．不用担心，他想逃就逃好了，倒省去了麻烦．",
 92,"先打败曹操，之后刘备如果背叛的话，再杀他不迟．",
 93,"……那么，即使我一个人也要追杀刘备，我不相信刘备．",
 55,"啊，随你的便吧．",
 93,"哼！");
 --人物行动:[郭图]移动到坐标<3,17>朝向<下>
 NextEvent();
 end,
 [250]=function()
 JY.Smap={};
 SetSceneID(0,3);
 talk( 65,"我们去张飞落脚的古城吧．古城从这里向南走．",
 1,"唉，真想见到张飞呀．");
 SetSceneID(0,11);
 talk( 93,"追刘备，决不能让他跑掉．");
 PlayWavE(11);
 DrawStrBoxCenter("被郭图率军追上！");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 92,0,7, 4,3,26,2, 0,0,-1,0,
 256,7,19, 4,4,19,2, 11,13,-1,0,
 257,2,4, 4,3,19,2, 0,0,-1,0,
 258,1,6, 4,3,19,2, 0,0,-1,0,
 292,1,9, 4,1,19,8, 0,0,-1,0,
 293,3,5, 4,3,19,8, 0,0,-1,0,
 328,0,8, 4,1,19,13, 0,0,-1,0,
 274,3,6, 4,3,19,5, 0,0,-1,0,
 275,2,5, 4,3,18,7, 0,0,-1,0,
 310,2,8, 4,3,19,11, 0,0,-1,0,
 336,8,19, 4,4,19,15, 11,14,-1,0,
 337,2,7, 4,3,18,15, 0,0,-1,0,
 102,1,7, 4,3,23,22, 0,0,-1,1,
 50,7,19, 4,3,23,5, 0,0,-1,1,
 ---
 294,7,18, 4,1,19,8, 0,0,-1,1,
 295,8,0, 4,3,18,8, 0,0,-1,1,
 296,2,6, 4,3,19,7, 0,0,-1,1,
 259,6,19, 4,1,19,2, 0,0,-1,1,
 260,9,0, 4,3,18,2, 0,0,-1,1,
 276,7,1, 4,3,19,5, 0,0,-1,1,
 277,6,2, 4,3,18,4, 0,0,-1,1,
 278,2,5, 4,1,19,5, 0,0,-1,1,
 311,8,19, 4,3,19,11, 0,0,-1,1,
 312,0,7, 4,1,18,10, 0,0,-1,1,
 329,0,8, 4,1,19,13, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [251]=function()
 PlayBGM(11);
 talk( 93,"哼，我已看透了刘备是怎么想的了．刘备，你休想逃掉．",
 64,"主公，那是郭图的部队，好像我们被发现了．",
 65,"跑到这里，不能被他们抓住．主公先逃到西南的那个鹿砦去吧．到了那里，郭图就没有办法了．");
 WarShowArmy(54-1);
 talk( 54,"那不是刘皇叔吗？真是苍天有眼，没想到会在这种地方相见……好像是被人追赶，好，我马上去帮助刘皇叔．");
 WarShowTarget(true);
 PlayBGM(13);
 NextEvent();
 end,
 [252]=function()
 if WarMeet(54,103) then
 WarAction(1,54,103);
 talk( 54,"这不是张颌吗？",
 103,"你是赵云．公孙瓒已经死了，你也最好投降袁绍．",
 54,"谁还会去跟一个被我抛弃的人呢？袁绍是什么样的人，你到时候就会知道的……",
 103,"什么？你这个丧家之犬，听你胡说，我送你去见公孙瓒吧！");
 if fight(54,103)==1 then
 talk( 103,"不愧确有其名呀！",
 54,"你也不简单呀．",
 103,"……这次我就让你了，以后还会相遇的，赵云！");
 WarAction(16,103);
 talk( 54,"这样的人跟着袁绍，真是可惜！");
 WarLvUp(GetWarID(54));
 else
 talk( 103,"看招！");
 WarAction(8,103,54);
 WarAction(17,54);
 WarLvUp(GetWarID(103));
 end
 
 end
 if (not GetFlag(1018)) and War.Turn==5 then
 talk( 1,"啊？那是敌人的援军！？又来了．");
 WarShowArmy(102);
 WarShowArmy(50);
 WarShowArmy(294);
 WarShowArmy(295);
 WarShowArmy(296);
 WarShowArmy(259);
 WarShowArmy(260);
 WarShowArmy(276);
 WarShowArmy(277);
 WarShowArmy(278);
 WarShowArmy(311);
 WarShowArmy(312);
 WarShowArmy(329);
 DrawStrBoxCenter("敌人援军出现．");
 talk( 103,"郭图，让你等急了吧．",
 93,"噢，张颌，你来得太好了，我们无论如何也要捉住刘备．");
 SetFlag(1018,1)
 end
 if WarCheckLocation(0,19,3) then
 talk( 93,"唉，让刘备在这里溜掉了，主公让刘备给算计了，大败仗呀！");
 WarGetExp(50);
 PlayBGM(7);
 DrawMulitStrBox("刘备军躲过郭图军的追击．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end 
 if JY.Status==GAME_WARWIN then
 talk( 93,"唉，让刘备在这里溜掉了，主公让刘备给算计了．");
 PlayBGM(7);
 DrawMulitStrBox("刘备军胜利了．");
 GetMoney(700);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金７００．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 WarLocationItem(11,18,55,191); --获得道具:获得道具：茶
 WarLocationItem(7,20,65,192); --获得道具:获得道具：炸弹(34) 改为 贼兵誓言
 end,
 [253]=function()
 JY.Smap={};
 JY.Base["现在地"]="兖州";
 JY.Base["道具屋"]=0;
 AddPerson(1,8,18,0);
 AddPerson(64,11,11,3);
 AddPerson(83,13,10,3);
 AddPerson(65,21,17,2);
 AddPerson(82,23,16,2);
 AddPerson(54,31,6,1);
 SetSceneID(97,5);
 DrawStrBoxCenter("兖州幕舍");
 MovePerson(54,6,1);
 talk( 54,"刘皇叔，久违了．",
 1,"能见到你我也很高兴，可是，你是怎么来的？",
 54,"公孙瓒失败后，我一直过着流浪的生活．最近我听到古城张飞的消息，觉得去那里可能会见到皇叔．",
 1,"是吗？",
 54,"可是关羽不是和你们在一起吗？",
 1,"是这样……",
 54,"是这样啊……",
 1,"即使不能马上，早晚也一定会见到关羽的．那么我们先去张飞那里吧．",
 54,"今后我也就成为您的部下了．刘皇叔，请多指教．");
 PlayWavE(11);
 DrawStrBoxCenter("赵云成为刘备的部下．");
 --显示任务目标:<去古城．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [254]=function()
 if JY.Tid==54 then--赵云
 talk( 54,"刘皇叔，请多指教．");
 end
 if JY.Tid==64 then--孙乾
 if talkYesNo( 64,"快去古城吧．") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==65 then--糜竺
 if talkYesNo( 65,"我们又多了个赵云，就快去古城吧．") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==82 then--糜芳
 if talkYesNo( 82,"主公，去古城吧．") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==83 then--简雍
 if talkYesNo( 83,"主公，说不定还会有追兵来，快走吧！") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [255]=function()
 JY.Smap={};
 SetSceneID(0,3);
 talk( 1,"那么去见张飞吧．",
 65,"是，古城从这里向南走不远就是，快走吧．");
 SetSceneID(0);
 talk( 1,"什，什么？",
 83,"什么！有毛贼！",
 64,"这个时候偏又出现了毛贼．主公，迎战吧．",
 1,"列队．");
 WarIni();
 DefineWarMap(17,"第二章 古城之战","一、交战？？？．",40,0,373);
 -- id,x,y, d,ai --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,12,11, 4,0,-1,0,
 -1,11,12, 4,0,-1,0,
 -1,13,12, 4,0,-1,0,
 -1,12,13, 4,0,-1,0,
 -1,13,13, 4,0,-1,0,
 -1,11,10, 4,0,-1,0,
 -1,12,10, 4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 373,10,23, 2,2,23,8, 0,0,-1,0,
 310,9,21, 2,0,19,11, 0,0,-1,0,
 311,17,9, 3,1,18,11, 0,0,-1,0,
 312,18,10, 3,1,18,11, 0,0,-1,0,
 313,16,16, 3,1,16,11, 0,0,-1,0,
 314,15,17, 3,1,15,10, 0,0,-1,0,
 315,3,8, 4,1,15,10, 0,0,-1,0,
 316,3,15, 4,1,16,11, 0,0,-1,0,
 332,13,3, 1,1,20,14, 0,0,-1,0,
 333,3,14, 4,1,19,14, 0,0,-1,0,
 336,9,22, 2,0,18,15, 0,0,-1,0,
 337,14,3, 1,1,18,15, 0,0,-1,0,
 338,4,7, 4,1,17,15, 0,0,-1,0,
 });
 ModifyForce(374,0);
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [256]=function()

JY.Person[374]["兵种"]=JY.Person[3]["兵种"]
local bzid=JY.Person[3]["兵种"]
for id=1,War.PersonNum do
if War.Person[id].id==374 then
 War.Person[id].bz=bzid;
 War.Person[id].movewav=JY.Bingzhong[bzid]["音效"]; --移动音效
 War.Person[id].atkwav=JY.Bingzhong[bzid]["攻击音效"]; --攻击音效
 War.Person[id].movestep=JY.Bingzhong[bzid]["移动"]; --移动范围
 War.Person[id].movespeed=JY.Bingzhong[bzid]["移动速度"]; --移动速度
 War.Person[id].atkfw=JY.Bingzhong[bzid]["攻击范围"]; --攻击范围
 War.Person[id].pic=WarGetPic(id);
end
end
JY.Person[374]["兵力"]=JY.Person[3]["最大兵力"]
JY.Person[374]["策略"]=JY.Person[3]["最大策略"]
for i=1,8 do
JY.Person[374]["道具"..i]=JY.Person[3]["道具"..i]
end

 PlayBGM(11);
 talk( 83,"主公，我们好像被包围了．",
 1,"嗯？！",
 374,"这一带，曹操军又出现了．把曹操军给我杀个片甲不留！",
 64,"那是……！可是为什么这样欢迎我们呢？",
 1,"可能弄错，一定把我们当成敌人了．见了面也就知道了．",
 83,"还没见到，就会被杀死的．",
 1,"……也有可能．但不管怎么样一定要见到张飞．");
 WarShowTarget(true);
 PlayBGM(17);
 NextEvent();
 end,
 [257]=function()
 if WarMeet(-1,374) then
 PlayBGM(15);
 talk( 374,"怎么看那些人很眼熟呢？……啊！",
 3,"喂，喽罗们，这支部队是我们自己人．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(15);
 talk( 374,"畜生，好厉害的家伙！那员大将是谁？嗯？怎么很眼熟呢？……啊！！",
 1,"张飞，我很想念你啊．可是长时间不见怎么这样迎接我们呢？",
 3,"对，对不起．如果知道是你们我早就出来迎接了．喂，喽罗们，这支部队是我们自己人，快住手．");
 PlayBGM(7);
 GetMoney(700);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金７００．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 WarLocationItem(22,15,19,193); --获得道具:获得道具：剑术指南书
 WarLocationItem(19,4,67,194); --获得道具:获得道具：山崩书(36) 改为异文化印
 WarLocationItem(23,8,29,195); --获得道具:获得道具：特级酒
 end,
 [258]=function()
 JY.Smap={};
 SetSceneID(0,5);
 talk( 3,"对不起，又糊里糊涂地干了一件蠢事．",
 1,"事情过去了也就算了．那你这段时间是怎么过的．",
 3,"我占领了这座城，想率领毛贼们抗击曹操军，没想到大哥来了．大哥，对不起．",
 1,"不要那么难过了，张飞，这不像你．",
 3,"好啊，总之我们又在一起了，今后也要跟随大哥上刀山下火海在所不辞．");
 LvUp(3,3);
 ModifyForce(3,1);
 PlayWavE(11);
 DrawStrBoxCenter("张飞又回到刘备身边．");
 talk( 3,"大哥，进我们这个小破城看看吧．");
 --显示任务目标:<在古城谈论今后之事．>
 NextEvent();
 end,
 [259]=function()
 JY.Smap={};
 JY.Base["现在地"]="古城";
 JY.Base["道具屋"]=0;
 AddPerson(1,25,17,2);
 AddPerson(3,22,10,1);
 AddPerson(54,20,9,1);
 AddPerson(83,18,8,1);
 AddPerson(64,11,16,0);
 AddPerson(82,9,15,0);
 SetSceneID(54,5);
 DrawStrBoxCenter("古城议事厅");
 DrawMulitStrBox("在这里叙述关羽的动向．关羽的确如糜竺所说的那样在曹营．刘备等败给曹操的时候，关羽在下邳正被曹军围困．由于张辽的力劝，关羽有条件地投降了曹操．");
 DrawMulitStrBox("当时的条件是，关羽只要知道刘备的下落，可以马上回到刘备身边．曹操接受了这个条件．");
 DrawMulitStrBox("后来，糜竺传话给关羽，告知了刘备的下落．关羽为见刘备马上离开曹营，在路上，遇上了关平和周仓．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [260]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，关羽怎么样啦？噢，……是这样啊．那么快出发吧．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"我恨不得马上见到关羽．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"关羽现在怎么样啦？");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"来到这里就不用担心袁绍的追兵啦．");
 end
 if JY.Tid==64 then--孙乾
 JY.Status=GAME_SMAP_AUTO;
 talk( 64,"我们先在这里整顿一下队伍，然后去迎接关羽……唉？是糜竺，怎么啦？");
 AddPerson(65,1,5,3);
 MovePerson(65,7,3);
 talk( 65,"主公，大事不好．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [261]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"糜竺这家伙，怎么这么慌张？");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"突然发生了什么事？");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"听糜竺讲吧．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"听糜竺讲吧．");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"主公，听我哥哥讲吧．");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"主公，不好啦！曹操军正直奔这里而来．现在已到达颖川．",
 1,"……现在去颖川迎击．众将士准备出发．");
 --显示任务目标:<准备迎击曹操军．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [262]=function()
 if JY.Tid==54 then--赵云
 talk( 54,"终于又能为主公打仗了．没有比这更叫我高兴的了．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"曹操军来到这里真是意外呀．去迎击吧．");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"关羽还没到，可是也没办法．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"主公，迎战吧！");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"主公，迎战吧！");
 end
 if JY.Tid==3 then--张飞
 if talkYesNo( 3,"大哥，出发吧！") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [263]=function()
 PlayBGM(12);
 talk( 3,"大哥，请快列好队．");
 LvUp(2,3);
 WarIni();
 DefineWarMap(18,"第二章 颖川之战","一、歼灭蔡阳．",30,0,152);
 -- id,x,y, d,ai --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,30,2, 3,0,-1,0,
 -1,30,1, 3,0,-1,0,
 -1,30,3, 3,0,-1,0,
 -1,29,2, 3,0,-1,0,
 -1,29,3, 3,0,-1,0,
 -1,31,0, 3,0,-1,0,
 -1,31,2, 3,0,-1,0,
 -1,31,1, 3,0,-1,0,
 
 1,1,1, 1,0,-1,1,
 127,0,2, 1,0,-1,1,
 154,2,0, 1,0,-1,1,
 });
 DrawSMap();
 ShowScreen();
 talk( 3,"那么，迎战吧．又见到了大哥，绝不会败的．");
 ModifyForce(2,1);
 ModifyForce(128,1);
 ModifyForce(155,1);
 JY.Smap={};
 SetSceneID(0,3);
 talk( 65,"颖川在这古城的南面．那么去颖川吧．");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 152,2,13, 4,0,25,2, 0,0,-1,0,
 95,14,7, 4,4,22,2, 16,6,-1,0,
 96,3,13, 4,0,21,2, 0,0,-1,0,
 256,13,9, 4,4,20,2, 16,7,-1,0,
 274,3,12, 4,0,20,5, 0,0,-1,0,
 275,15,8, 4,4,19,5, 17,7,-1,0,
 276,9,10, 4,0,18,5, 0,0,-1,0,
 292,11,10, 4,4,18,8, 15,6,-1,0,
 293,7,11, 4,0,17,8, 0,0,-1,0,
 294,8,11, 4,0,17,8, 0,0,-1,0,
 310,12,8, 4,4,20,11, 18,7,-1,0,
 311,6,10, 4,0,19,11, 0,0,-1,0,
 328,9,12, 4,0,19,13, 0,0,-1,0,
 336,13,6, 4,4,20,15, 16,5,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [264]=function()
 PlayBGM(11);
 talk( 153,"那是刘备军呀．我蔡阳要让他们知道，与曹丞相为敌有多愚蠢．",
 3,"大哥，曹操好像没来．",
 1,"可是，张飞，不可大意呀．",
 3,"是，我知道了．");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [265]=function()
 if WarMeet(2,153) then
 WarAction(1,2,153);
 talk( 153,"是关羽呀．关羽，你忘记了曹丞相的恩情，又跑回到刘备的身边，你是什么重义之人．",
 2,"我与曹操有约在先，只要知道我兄长活着，随时都可以离开曹操．你难道是说曹操不讲信用？",
 153,"什么！你敢侮辱曹丞相？杀！关羽我定要取你首级．");
 WarAction(5,153,2);
 if fight(2,153)==1 then
 talk( 153,"招！",
 2,"纳命来！");
 WarAction(8,2,153);
 talk( 153,"啊！");
 WarAction(18,153);
 talk( 2,"……虽说有约在先，但我却杀了他的部下．这次是我欠了曹操的．");
 WarLvUp(GetWarID(2));
 PlayBGM(7);
 DrawMulitStrBox("关羽杀了蔡阳，刘备军胜利了．");
 GetMoney(700);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金７００．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 else
 talk( 153,"招！");
 WarAction(8,153,2);
 WarAction(17,2);
 WarLvUp(GetWarID(153));
 end
 end
 if (not GetFlag(1019)) and War.Turn==8 then
 PlayBGM(12);
 talk( 153,"你们是什么人？");
 WarShowArmy(2-1);
 WarShowArmy(128-1);
 WarShowArmy(155-1);
 talk( 128,"父亲，那里好像在进行一场交战．",
 155,"是哪里的部队？",
 2,"嗯？那是……啊，那是兄长！还有张飞．呜……现在不是感情用事的时候，关羽来参战了．关平周仓跟我来．",
 128,"遵命！",
 155,"是！");
 DrawStrBoxCenter("关羽出现．");
 PlayBGM(9);
 SetFlag(1019,1)
 end
 if JY.Status==GAME_WARWIN then
 talk( 153,"你，你们……我的仇，曹丞相一定会替我报的．唉．");
 PlayBGM(7);
 DrawMulitStrBox("刘备军取得胜利．");
 GetMoney(700);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金７００．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 --WarLocationItem(13,7,37,78); --获得道具:获得道具：山洪书/改为孟德新书
 WarLocationItem(13,7,5,78);
 end,
 [266]=function()
 JY.Smap={};
 JY.Base["现在地"]="颖川";
 JY.Base["道具屋"]=0;
 AddPerson(1,8,18,0);
 AddPerson(2,16,14,1);
 AddPerson(128,30,6,1);
 AddPerson(155,32,7,1);
 AddPerson(3,11,11,3);
 AddPerson(64,13,10,3);
 AddPerson(83,15,9,3);
 AddPerson(54,21,17,2);
 AddPerson(65,23,16,2);
 AddPerson(82,25,15,2);
 SetSceneID(97,5);
 DrawStrBoxCenter("颖川营帐");
 talk( 2,"……兄长，终于找到你了．我关羽以前虽身在曹营可是心一直在这里呀．太高兴了，还能相见，真像做梦一样．",
 1,"……关羽，没事最好．太好了，能平安回来．呜呜呜！",
 3,"……关羽，那两个人是谁？",
 2,"噢，刚才一急忘了说了．兄长，给你介绍一下他们二人．这个年轻人叫关平，这次有缘成为我的义子．");
 MovePerson(128,6,1);
 talk( 128,"我叫关平，是关羽将军的义子，请多指教．",
 2,"他叫周仓，这次也有缘成了我的部下，他原是占山的草寇，我在半路上把他收下．");
 MovePerson(155,6,1);
 talk( 155,"皇叔幸会，我叫周仓，我虽曾占山为寇，但内心却是光明磊落的．");
 PlayWavE(11);
 DrawStrBoxCenter("关羽回到刘备身边！");
 PlayWavE(11);
 DrawStrBoxCenter("关平与周仓成为刘备部下．");
 talk( 54,"大家都回来了，可喜可贺，可是我们去哪里呢？",
 64,"从此向南走，有一个地方叫荆州．那是刘表的领地．",
 1,"刘表？我知道他．他与我应算是同宗呢．",
 64,"我们请求刘表让我们到荆州落脚怎么样？",
 1,"……",
 64,"荆州首府是襄阳．主公，我们到襄阳投靠刘表吧．",
 3,"这不太好，大哥，去找曹操报仇吧！汝南的刘辟好像与曹操为敌，我们去汝南跟曹操作战吧．",
 1,"……该去哪里呢？");
 --显示任务目标:<决定今后安身之地．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [267]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，去找曹操报仇吧！汝南的刘辟好像与曹操为敌，我们去汝南跟曹操作战吧．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"主公，该去哪里呢？");
 end
 if JY.Tid==128 then--关平
 talk( 128,"主公，请多指教．");
 end
 if JY.Tid==155 then--周仓
 talk( 155,"我愿意跟随主公，请随意调遣．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"主公，去哪里呢？");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"主公，去哪里呢？");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"主公，去哪里呢？");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"主公，去哪里呢？");
 end
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"您想好了吗？") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 DrawSMap();
 local menu={
 {"　　逃到襄阳",nil,1},
 {"　在汝南战曹操",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 64,"去襄阳吗？那我作为使者先去，主公随后再来．");
 JY.Smap={};
 SetSceneID(0);
 talk( 64,"主公，刘表非常欢迎我们，还给我们这些辎重粮草，说让我们整顿军马用．");
 GetMoney(2000);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金２０００．");
 talk( 2,"对我们真是关心得无微不至呀．去见刘表吧．");
 NextEvent(278); --goto 278
 elseif r==2 then
 talk( 3,"去汝南吧．大哥，我带你们去．");
 JY.Smap={};
 SetSceneID(0);
 NextEvent(268); --goto 268
 end
 end
 end
 end,
 [268]=function()
 JY.Smap={};
 JY.Base["现在地"]="汝南";
 JY.Base["道具屋"]=12;
 AddPerson(248,27,8,1);
 AddPerson(1,21,11,0);
 SetSceneID(48);
 DrawStrBoxCenter("汝南议事厅");
 talk( 248,"噢，刘皇叔，欢迎光临敝处．我是刘辟．");
 --显示任务目标:<与汝南刘辟商量今后之事．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [269]=function()
 if JY.Tid==248 then--刘辟
 talk( 1,"冒昧前来，对不起．",
 248,"哪里，请不要介意．听说刘备军来了．我军的士气也高涨了．在这里请不要有顾虑．");
 AddPerson(64,-1,22,0);
 MovePerson(64,8,0);
 MovePerson(1,0,1);
 talk( 64,"对不起，主公，我有点事要说．");
 NextEvent();
 end
 end,
 [270]=function()
 if JY.Tid==248 then--刘辟
 talk( 248,"请不要介意，你们讲吧．");
 end
 if JY.Tid==64 then--孙乾
 JY.Status=GAME_SMAP_AUTO;
 talk( 64,"主公，我想去襄阳刘表那里，跟他商量我们在危难时投靠他行不行．",
 1,"好，快去吧．见到刘表，和他好好讲讲．",
 64,"是．");
 MovePerson(64,8,1);
 DecPerson(64);
 ModifyForce(64,0);
 --显示任务目标:<城内散步．>
 talk( 248,"请先看一看城里吧．");
 NextEvent();
 end
 end,
 [271]=function()
 JY.Smap={};
 JY.Base["现在地"]="汝南";
 JY.Base["道具屋"]=12;
 AddPerson(1,27,8,1);
 AddPerson(54,21,11,0);
 AddPerson(2,25,15,2);
 AddPerson(128,23,16,2);
 AddPerson(83,21,17,2);
 AddPerson(3,15,8,3);
 AddPerson(65,13,9,3);
 AddPerson(82,11,10,3);
 SetSceneID(48);
 DrawStrBoxCenter("数日后");
 DrawStrBoxCenter("汝南议事厅");
 talk( 54,"主公，刚才间谍报告说曹操打败了袁绍．",
 1,"什么？袁绍败了？兵力悬殊那么大却败了．唉，到底是曹操呀！",
 54,"袁绍虽然侥幸逃脱得以保全性命，但这样一来曹操的势力更加强大了．");
 PlayBGM(11);
 AddPerson(248,-1,22,0);
 MovePerson(248,8,0);
 talk( 248,"噢，皇叔，大事不好．");
 JY.Status=GAME_SMAP_MANUAL;
 --显示任务目标:<去议事厅，商量今后之事．>
 NextEvent();
 end,
 [272]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"噢，大哥，不好了，你听刘辟细说吧．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"噢，大哥，不好了，你听刘辟细说吧．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"主公，不好了，详细情况请听刘辟讲吧．");
 end
 if JY.Tid==128 then--关平
 talk( 128,"主公，不好了，详细情况请听刘辟讲吧．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"主公，不好了，详细情况请听刘辟讲吧．");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"主公，不好了，详细情况请听刘辟讲吧．");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"主公，不好了，详细情况请听刘辟讲吧．");
 end
 if JY.Tid==248 then--刘辟
 talk( 248,"皇叔，曹操打败了袁绍之后又乘势朝这里杀来了．",
 1,"什么？曹操朝这里杀来？",
 248,"据间谍报告，好像曹操自己没来，主将是曹仁．",
 1,"快做出征准备．");
 --显示任务目标:<做迎战曹操军的准备．>
 NextEvent();
 end
 end,
 [273]=function()
 if JY.Tid==248 then--刘辟
 talk( 248,"我也做出征准备．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"怎么会呢？袁绍就这么轻易地败了．");
 end
 if JY.Tid==128 then--关平
 talk( 128,"快做出征准备．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"曹操军势力难以估量，光靠我们能抵挡得住吗？");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"主公，做迎战准备吧．");
 end
 if JY.Tid==82 then--糜芳
 talk( 82,"主公，做迎战准备吧．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"曹操军来的真是快．");
 end
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"出征吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 2,"请列队！");
 WarIni();
 DefineWarMap(19,"第二章 汝南之战","一、曹仁败退．",40,0,18);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,20,1, 1,0,-1,0,
 -1,19,2, 1,0,-1,0,
 -1,21,2, 1,0,-1,0,
 -1,18,0, 1,0,-1,0,
 -1,20,0, 1,0,-1,0,
 -1,21,0, 1,0,-1,0,
 -1,22,1, 1,0,-1,0,
 -1,21,3, 1,0,-1,0,
 -1,19,1, 1,0,-1,0,
 247,20,3, 1,0,-1,0,
 230,18,1, 1,0,-1,0,
 231,18,2, 1,0,-1,0,
 63,17,0, 1,0,-1,1,
 });
 ModifyForce(64,1);
 DrawSMap();
 talk( 2,"出征！");
 JY.Smap={};
 SetSceneID(0,11);
 talk( 19,"刘备，逃也没用！为了我主公将来着想，一定要杀死刘备！众将士！进军汝南！跟上！");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 18,2,16, 4,4,28,2, 7,2,-1,0,
 93,3,17, 4,4,25,19, 7,2,-1,0,
 78,33,16, 2,1,25,8, 0,0,-1,0,
 67,32,17, 2,1,25,8, 0,0,-1,0,
 77,4,16, 4,4,25,5, 20,11,-1,0,
 103,6,10, 4,4,24,5, 7,2,-1,0,
 17,4,12, 4,4,25,22, 7,2,-1,0,
 62,33,11, 2,1,24,2, 0,0,-1,0,
 172,4,15, 4,4,24,5, 20,11,-1,0,
 170,3,15, 4,4,24,8, 7,2,-1,0,
 274,33,15, 2,1,21,5, 0,0,-1,0,
 275,32,12, 2,1,21,5, 0,0,-1,0,
 276,3,10, 4,4,21,5, 7,2,-1,0,
 292,4,13, 4,4,21,8, 7,2,-1,0,
 293,4,11, 4,4,20,8, 7,2,-1,0,
 294,34,13, 2,1,20,8, 0,0,-1,0,
 295,33,12, 2,1,21,8, 0,0,-1,0,
 310,33,14, 2,1,20,10, 0,0,-1,0,
 311,5,16, 4,4,21,11, 20,11,-1,0,
 328,4,14, 4,4,20,13, 7,2,-1,0,
 336,5,15, 4,4,21,15, 20,11,-1,0,
 337,5,11, 4,4,20,15, 7,2,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [274]=function()
 PlayBGM(11);
 talk( 19,"刘备，还想逃吗？我岂能让你逃掉？我曹仁定要杀你．",
 1,"左右都是敌人吗？",
 248,"皇叔，敌人是曹操的精锐，现在战况已很危急，请你马上逃走吧．",
 1,"你说什么，我也要战斗到最后．",
 248,"不要了，刘皇叔，你不能在这时死，我要留到最后，请你快离开这里．");
 WarShowTarget(true);
 PlayBGM(10);
 NextEvent();
 end,
 [275]=function()
 if (not GetFlag(76)) and WarMeet(54,68) then
 WarAction(1,54,68);
 talk( 54,"那人不是泛泛之辈．那员大将，我赵云要与你单挑较量．",
 68,"赵云？噢，听过他的大名．正中我的下怀．杀呀！");
 WarAction(6,54,68);
 if fight(54,68)==1 then
 WarAction(19,68);
 talk( 54,"真能打！",
 68,"赵云，今天难分胜负，我不跟你打了，我们改天再决胜负．");
 WarLvUp(GetWarID(54));
 else
 WarAction(19,54);
 talk( 54,"真能打！",
 68,"赵云，今天难分胜负，我不跟你打了，我们改天再决胜负．");
 WarLvUp(GetWarID(68));
 end
 SetFlag(76,1)
 end
 if (not GetFlag(1020)) and War.Turn==3 then
 PlayBGM(12);
 WarShowArmy(64-1);
 DrawStrBoxCenter("孙乾出现！");
 talk( 64,"主公，我来晚了，对不起．我跟刘表谈了，他说我们危难时可以去，现在请逃到西南的那个鹿砦．那个鹿砦是曹操和刘表的边界，逃到那里，敌军就不会再追来了．");
 War.WarTarget="一、曹仁败退．*二、刘备到达西南鹿砦．";
 WarShowTarget(false);
 PlayBGM(10);
 SetFlag(1020,1)
 end
 if (not GetFlag(1021)) and War.Turn==4 then
 WarModifyAI(18,1);
 WarModifyAI(93,1);
 WarModifyAI(77,1);
 WarModifyAI(103,1);
 WarModifyAI(17,1);
 WarModifyAI(172,1);
 WarModifyAI(170,1);
 WarModifyAI(276,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(311,1);
 WarModifyAI(328,1);
 WarModifyAI(336,1);
 WarModifyAI(337,1);
 SetFlag(1021,1)
 end
 if WarCheckLocation(0,16,1) then
 WarGetExp();
 PlayBGM(7);
 talk( 1,"好！撤离战场，去襄阳．",
 19,"什么？刘备逃到了刘表的领地！？妈的……看来只好撤退了．");
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 talk( 19,"没办法，早晚要撤军的．");
 talk( 1,"好，趁敌人还没增援，去襄阳吧．");
 PlayBGM(7);
 NextEvent();
 end
 WarLocationItem(13,15,3,196); --获得道具:获得道具：鼓吹具
 end,
 [276]=function()
 GetMoney(700);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金７００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [277]=function()
 JY.Smap={};
 SetSceneID(0,5);
 talk( 64,"去襄阳吧．去襄阳从这里向南走．",
 1,"好啊．嗯？那是谁？",
 248,"刘皇叔！",
 1,"噢，刘辟，你还活着呀！",
 248,"是．皇叔，我已不能回汝南了．可以的话，请带我一起走．",
 1,"什么？",
 248,"以前我一直听从袁绍的摆布，但现在不了．请带我走吧．");
 local menu={
 {" 带上刘辟",nil,1},
 {"不带刘辟去",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 1,"当然行，那么一起去襄阳吧．",
 248,"噢，谢谢．");
 ModifyForce(248,1);
 PlayWavE(11);
 DrawStrBoxCenter("刘辟成了刘备部下！");
 elseif r==2 then
 talk( 1,"不能带你走，你是个不喜欢受军队规矩约束的人．以后你还是自由自在地愿意做什么就做什么吧．那样你也幸福．",
 248,"……我知道了．既然是皇叔的愿望，就这么办吧．那么我以后就自由自在了．",
 1,"刘辟，谢谢你．");
 end
 talk( 64,"去襄阳吧．");
 NextEvent();
 end,
 [278]=function()
 DrawStrBoxCenter("刘备向刘表所在的襄阳逃去．");
 NextEvent();
 end,
 --第二章开始
 --第二章　隐伏新野
 [279]=function()
 SetSceneID(-1,0);
 JY.Base["章节名"]="第二章　隐伏新野";
 DrawStrBoxCenter("第二章　隐伏新野");
 LoadPic(13,1);
 DrawMulitStrBox("袁绍在官渡被曹操打败．尽管他拥有比曹操更强大的兵力，但是由于心胸狭窄，不能相信有才能的部下，故在官渡之战中败北．袁绍军是因为从内部崩溃而败的．曹操招降了袁绍军的武将，形成了更强大的势力．")
 LoadPic(13,2);
 
 -- 0 上 1 下 2 左 3 右
 JY.Smap={};
 JY.Base["现在地"]="襄阳";
 JY.Base["道具屋"]=13;
 AddPerson(95,25,9,1);
 AddPerson(113,25,15,2);
 AddPerson(120,14,9,3);
 AddPerson(1,5,19,0);
 SetSceneID(86,5);
 DrawStrBoxCenter("襄阳议事厅");
 talk( 95,"刘备，欢迎来到荆州．");
 MovePerson(1,5,0);
 --显示任务目标:<拜见刘表．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [280]=function()
 if JY.Tid==113 then--蔡瑁
 talk( 113,"首先应拜见我们的主公，希望你懂得礼仪．");
 end
 if JY.Tid==120 then--蒯越
 talk( 120,"刘皇叔，幸会．我叫蒯越，以后我们就认识了．");
 end
 if JY.Tid==95 then--刘表
 JY.Status=GAME_SMAP_AUTO;
 talk( 95,"你来到了这里，曹操再也不敢轻易对你轻举妄动啦．你放心来这里吧．……噢，我把儿子介绍给你．蒯越，去把刘琦和刘琮叫来．",
 120,"是．");
 MovePerson(120,3,1);
 MovePerson(120,2,3);
 MovePerson(120,9,1);
 DecPerson(120);
 AddPerson(115,-4,23,0);
 AddPerson(121,-2,24,0);
 MovePerson( 115,7,0,
 121,7,0);
 talk( 95,"刘备弟，他俩是我的儿子，这是刘琦，那是刘琮．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [281]=function()
 if JY.Tid==113 then--蔡瑁
 talk( 113,"刘琦是前任夫人所生，刘琮是现任夫人，也就是我的妹妹所生．");
 end
 if JY.Tid==115 then--刘琦
 talk( 115,"初次见面，请多关照．听说您也姓刘，和我父亲是兄弟关系，那么您就是我的叔父啦．叔父请多关照．");
 end
 if JY.Tid==121 then--刘琮
 talk( 121,"初次见面，我叫刘琮．请多关照．");
 end
 if JY.Tid==95 then--刘表
 talk( 95,"刘备弟，请多关照我这两个儿子．对啦，刘备弟，你能否为我把守新野城．",
 1,"是新野城吗？",
 95,"城虽不大，是在荆州的最北面．希望刘备弟能在那里监视曹操的动向．",
 1,"好吧，您真是关怀得无微不至，谢谢．");
 --显示任务目标:<去新野城．>
 NextEvent();
 end
 end,
 [282]=function()
 if JY.Tid==113 then--蔡瑁
 talk( 113,"请你好好守住新野．不过听说你是刚刚从曹操那里逃出来的，我有些担心呀．");
 end
 if JY.Tid==115 then--刘琦
 talk( 115,"今后也请多加关照．");
 end
 if JY.Tid==121 then--刘琮
 talk( 121,"请多关照．");
 end
 if JY.Tid==95 then--刘表
 talk( 95,"新野在襄阳的最北面，那就托付给你啦．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [283]=function()
 JY.Smap={};
 JY.Base["现在地"]="新野";
 JY.Base["道具屋"]=13; --其实新野没有道具店，这里用的是襄阳的
 AddPerson(1,25,9,1);
 AddPerson(2,25,11,2);
 AddPerson(3,23,12,2);
 AddPerson(54,22,9,3);
 AddPerson(64,20,10,3);
 SetSceneID(71);
 DrawStrBoxCenter("新野");
 talk( 2,"这就是我们的新城了，终于有落脚之地了．");
 --显示任务目标:<视察城内．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [284]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"这就是我们的新城啊，还是有了自己的城心里踏实些．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，这回终于踏实下来了．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"在这里我们要开始新的生活了．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"主公，我们刚来到此地，还是先视察一下城里，了解一下情况吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [285]=function()
 JY.Smap={};
 JY.Base["现在地"]="新野";
 JY.Base["道具屋"]=13; --其实新野没有道具店，这里用的是襄阳的
 AddPerson(1,25,9,1);
 
 AddPerson(114,7,14,0);
 AddPerson(117,27,18,2);
 AddPerson(355,20,5,3);
 AddPerson(359,13,8,3);
 AddPerson(357,14,20,2);
 SetSceneID(71,5);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [286]=function()
 if JY.Tid==114 then--伊籍
 talk( 114,"……嗯？那不是刘备吗？");
 MovePerson(114,2,3);
 MovePerson(114,5,0);
 talk( 114,"您是刘皇叔吗？听说您在城里我就找来了．我叫伊籍．我主刘表让我来帮助你．请多关照．",
 1,"你来了，太好了，我才要请你多关照呢．");
 ModifyForce(114,1);
 PlayWavE(11);
 DrawStrBoxCenter("伊籍成了刘备下属．");
 talk( 114,"有一件事想告诉您，荆州有一位称为水镜先生的雅士，请您务必见一见他．",
 1,"水镜先生？为什么要见他呢？",
 114,"水镜先生和许多名士有来往，他也许对皇叔会有所帮助．",
 1,"我明白了．伊籍，谢谢你．",
 114,"只是我不知道他住在哪里．",
 1,"好吧，我有时间去寻访一下他．");
 talk( 114,"那么，我现在去议事厅了．我还有话要对您讲．在议事厅见吧．");
 MovePerson(114,12,1);
 DecPerson(114);
 SetFlag(1022,1);
 end
 if JY.Tid==117 then--刘封
 MovePerson(117,5,2);
 MovePerson(117,2,0);
 talk( 117,"您是刘皇叔吗？我叫刘封，听说皇叔来到新野，特地前来投靠，请收容我吧．",
 1,"好！好好干吧！",
 117,"啊，谢谢！");
 ModifyForce(117,1);
 PlayWavE(11);
 DrawStrBoxCenter("刘封成了刘备部下．");
 talk( 117,"那么，我去议事厅了．");
 MovePerson(117,12,1);
 DecPerson(117);
 SetFlag(1023,1);
 end
 if JY.Tid==355 then--农民
 talk( 355,"水镜先生？水镜先生住在襄阳城．只是经常不在家呀．");
 SetFlag(1024,1);
 if GetFlag(1022) and GetFlag(1023) and GetFlag(1024) and GetFlag(1025) and GetFlag(1026) then
 talk( 1,"那么，去议事厅吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==359 then--旅客
 talk( 359,"听说袁绍好像死了，他的势力那么强大，都败给曹操了啊．");
 SetFlag(1025,1);
 if GetFlag(1022) and GetFlag(1023) and GetFlag(1024) and GetFlag(1025) and GetFlag(1026) then
 talk( 1,"那么，去议事厅吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==357 then--商人
 talk( 357,"刘表现在的夫人好像想立自己的亲生儿子刘琮为继承人，不过长子是刘琦呀．");
 SetFlag(1026,1);
 if GetFlag(1022) and GetFlag(1023) and GetFlag(1024) and GetFlag(1025) and GetFlag(1026) then
 talk( 1,"那么，去议事厅吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [287]=function()
 JY.Smap={};
 JY.Base["现在地"]="新野";
 JY.Base["道具屋"]=13;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(54,20,9,1);
 AddPerson(3,11,16,0);
 AddPerson(64,9,15,0);
 AddPerson(114,14,11,3);
 AddPerson(117,12,12,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("新野议事厅");
 --显示任务目标:<与关羽等谈论今后之事．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [288]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"听说这几个人是才来投靠兄长的．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，好像突然间多了些武将啊！");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"即使多了武将，不经练兵也不管用．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"我觉得人才多了是好事！");
 end
 if JY.Tid==117 then--刘封
 talk( 117,"刘皇叔，请多关照．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"我主刘表好像最近有些烦恼．大概是由于江夏叛乱的事情．",
 1,"江夏叛乱？",
 114,"对，江夏城在荆州的最东面，由于最近出现了毛贼，搞得兵荒马乱．");
 NextEvent();
 end
 end,
 [289]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"镇压叛乱啊，尽管我觉得用不着我出马就可以讨平，但我还是去吧！");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"即使多了武将，不经练兵也不管用．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"我觉得人才多了是好事！");
 end
 if JY.Tid==117 then--刘封
 talk( 117,"江夏在荆州的最东面．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"据说最近江夏出现了毛贼．");
 end
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，既然刘表是为此事烦恼，那我们就为他去掉这块心患吧．",
 1,"他这么照顾我们，我们至少得对他有些报答．",
 3,"好啊！决定了就快出征吧．",
 54,"张飞，别太自负了．",
 114,"谢谢你们为我主刘表解忧．");
 --显示任务目标:<准备消灭江夏毛贼．>
 NextEvent();
 end
 end,
 [290]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"山贼啊？不是我的对手．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"敌人是毛贼．这些恶棍，我绝不饶恕他们！");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"主公，做出征准备！");
 end
 if JY.Tid==117 then--刘封
 talk( 117,"我绝不辜负您的期望，请看我的吧．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"谢谢你为我主刘表解忧．");
 end
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"兄长，准备好了吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 2,"请列队！");
 WarIni();
 DefineWarMap(20,"第二章 江夏之战","一、歼灭张武．",40,0,117);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,1,3, 4,0,-1,0,
 -1,2,3, 4,0,-1,0,
 -1,1,4, 4,0,-1,0,
 -1,2,5, 4,0,-1,0,
 -1,3,5, 4,0,-1,0,
 -1,3,3, 4,0,-1,0,
 -1,2,2, 4,0,-1,0,
 -1,1,1, 4,0,-1,0,
 -1,0,2, 4,0,-1,0,
 -1,0,6, 4,0,-1,0,
 });
 DrawSMap();
 talk( 2,"出征．");
 JY.Smap={};
 SetSceneID(0,3);
 talk( 114,"刘皇叔是第一次去江夏吧，我替你们当响导．");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 117,30,18, 3,2,27,11, 0,0,-1,0,
 118,29,19, 3,0,24,11, 0,0,-1,0,
 310,29,17, 3,0,22,11, 0,0,-1,0,
 311,26,10, 2,4,21,11, 11,4,-1,0,
 312,27,14, 2,4,21,11, 11,4,-1,0,
 313,21,17, 3,4,20,11, 9,13,-1,0,
 314,23,16, 3,4,20,11, 9,13,-1,0,
 274,30,16, 3,0,23,5, 0,0,-1,0,
 275,28,11, 2,4,23,5, 11,4,-1,0,
 292,27,12, 2,4,21,8, 11,4,-1,0,
 293,23,17, 3,4,21,8, 9,13,-1,0,
 332,22,16, 3,4,23,14, 9,13,-1,0,
 333,27,11, 2,4,23,14, 11,4,-1,0,
 336,27,9, 2,4,23,15, 11,4,-1,0,
 337,20,18, 3,4,23,15, 9,13,-1,0,
 340,24,16, 3,4,22,17, 9,13,-1,0,
 341,25,17, 3,4,20,17, 9,13,-1,0,
 342,26,13, 2,4,21,17, 11,4,-1,0,
 141,29,2, 3,2,30,3, 0,0,-1,1,
 142,28,1, 3,2,30,16, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [291]=function()
 PlayBGM(11);
 talk( 118,"刘表军又来了？这些混蛋．喽罗们！杀死他们．");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [292]=function()
 if WarMeet(3,119) then
 WarAction(1,3,119);
 talk( 3,"毛贼，休得猖狂，拿命来！",
 119,"啊？那家伙要和我决一死战？有意思，虽然不知来人是谁，就陪他打打吧．");
 WarAction(6,3,119);
 if fight(3,119)==1 then
 WarAction(8,3,119);
 talk( 119,"啊……！");
 WarAction(18,119);
 talk( 3,"嗤，什么对手！怎么一枪就死了？筋骨都还没松开．");
 WarLvUp(GetWarID(3));
 DrawStrBoxCenter("张飞占了上风！");
 else
 WarAction(4,119,3);
 talk( 3,"……");
 WarAction(17,3);
 WarLvUp(GetWarID(119));
 DrawStrBoxCenter("陈孙占了上风！");
 end
 end
 if WarMeet(54,118) then
 WarAction(1,54,118);
 talk( 118,"嗤，你们这些乌合之众，看看我的厉害吧！待我把那员大将斩落马下！",
 54,"嗯，朝这边来的那个是……，好像是毛贼首领，好！我来杀他！");
 WarAction(6,54,118);
 if fight(54,118)==1 then
 WarAction(8,54,118);
 talk( 118,"太厉害了……啊！");
 WarAction(18,118);
 talk( 54,"这匹马挺好的呀，牵回去吧．");
 WarGetItem(GetWarID(54),7);
 --WarLvUp(GetWarID(54));
 DrawMulitStrBox("刘备军歼灭了江夏毛贼．");
 NextEvent();
 else
 WarAction(4,118,54);
 talk( 54,"太厉害了！");
 WarAction(17,54);
 WarLvUp(GetWarID(118));
 DrawStrBoxCenter("张武占了上风！");
 end
 end
 if (not GetFlag(1027)) and War.Turn==4 then
 WarModifyAI(311,1);
 WarModifyAI(312,1);
 WarModifyAI(313,1);
 WarModifyAI(314,1);
 WarModifyAI(275,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(332,1);
 WarModifyAI(333,1);
 WarModifyAI(336,1);
 WarModifyAI(337,1);
 WarModifyAI(340,1);
 WarModifyAI(341,1);
 WarModifyAI(342,1);
 SetFlag(1027,1)
 end
 WarLocationItem(18,24,21,79); --获得道具:获得道具：近卫铠
 WarLocationItem(7,28,27,197); --获得道具:获得道具：侠义精神
 if (not GetFlag(198)) and WarCheckLocation(-1,15,30) then
 GetMoney(400);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金４００．");
 SetFlag(198,1);
 end
 if JY.Status==GAME_WARWIN then
 talk( 118,"真的是刘备军吗？太厉害了……啊！");
 DrawMulitStrBox("刘备军歼灭了江夏毛贼．");
 NextEvent();
 end
 end,
 [293]=function()
 PlayBGM(11);
 WarShowArmy(142-1);
 WarShowArmy(143-1);
 talk( 142,"周瑜，那支部队是哪里的？我没听说过，刘表军里有这么厉害的人呀．",
 143,"看那人的样子好像是刘备．",
 142,"刘备？刘备不是有一段时间和曹操打得不相上下吗？那些毛贼打不过他们也在情理之中．",
 143,"我原想控制那些毛贼，使江夏归我东吴，可是有了这些人，江夏恐怕难以到手了．",
 142,"为了夺取荆州，我们还是回去重新研究一下对敌之策吧．",
 143,"遵命！");
 WarAction(16,142);
 WarAction(16,143);
 talk( 1,"那支部队是哪里的？好像不是毛贼呀．军旗上的字是什么？是”孙”？");
 PlayBGM(7);
 GetMoney(800);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金８００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [294]=function()
 SetSceneID(0,5);
 talk( 2,"兄长，要去通报刘表吧．我们先回新野等候兄长．",
 1,"好！那我去襄阳啦．");
 --显示任务目标:<去襄阳向刘表汇报战果．>
 NextEvent();
 end,
 [295]=function()
 JY.Smap={};
 JY.Base["现在地"]="襄阳";
 JY.Base["道具屋"]=13;
 AddPerson(95,25,9,1);
 AddPerson(113,25,15,2);
 AddPerson(120,23,16,2);
 AddPerson(122,14,9,3);
 AddPerson(123,12,10,3);
 AddPerson(1,5,19,0);
 SetSceneID(86,5);
 talk( 95,"刘备有什么事吗？");
 MovePerson(1,5,0);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [296]=function()
 if JY.Tid==113 then--蔡瑁
 talk( 113,"该不是出了什么事才来的吧？");
 end
 if JY.Tid==120 then--蒯越
 talk( 120,"刘备，怎么啦？");
 end
 if JY.Tid==122 then--文聘
 talk( 122,"刘备，怎么啦？");
 end
 if JY.Tid==123 then--王威
 talk( 123,"刘备，怎么啦？");
 end
 if JY.Tid==95 then--刘表
 talk( 95,"什么？你已经把江夏毛贼讨平啦！太辛苦了！山贼也很厉害呀！我的部队都感到棘手，真不愧是刘备呀！",
 1,"哪里，承蒙刘表兄关照，把新野城借给我用，我做这点小事也不足以报答您的恩情．",
 1,"另外有一件事请教一下．",
 95,"什么事？",
 1,"就在我们撤出江夏前，看见一支和毛贼无关的部队．大旗上写着”孙”字．",
 95,"什么？写着”孙”？噢……对了……",
 1,"是谁的部队？",
 95,"刘备弟，你来荆州时日尚浅，我来给你解释一下那个部队吧．");
 PlayBGM(11);
 DrawMulitStrBox("荆州处于三大势力的中间，北面是曹操，西面是益州，另一个就是东面的东吴．吴历代由孙氏一族治理，吴主是孙权．荆州多年来一直和吴有领土纠纷，孙权的父亲孙坚就死在刘表部下的手里．");
 talk( 95,"……情况就是这样．",
 1,"是这样啊．如此说来，那些毛贼作乱原来是孙权指使的．",
 95,"我这里有很长时间没发生事情了．……，刘备弟，我的领地对曹操也要留心些．你回新野好好休息一下吧．");
 PlayBGM(5);
 --显示任务目标:<回新野．>
 NextEvent();
 end
 end,
 [297]=function()
 if JY.Tid==113 then--蔡瑁
 talk( 113,"啊！干得不是很漂亮嘛，不过，这种讨伐我也做得了．");
 end
 if JY.Tid==120 then--蒯越
 talk( 120,"谢谢你们镇压了江夏叛乱．");
 end
 if JY.Tid==122 then--文聘
 talk( 122,"谢谢你们镇压了江夏叛乱．");
 end
 if JY.Tid==123 then--王威
 talk( 123,"谢谢你们镇压了江夏叛乱．");
 end
 if JY.Tid==95 then--刘表
 talk( 95,"回新野吧，在那里好好休养．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [298]=function()
 JY.Smap={};
 JY.Base["现在地"]="新野";
 JY.Base["道具屋"]=13;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(64,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(114,9,15,0);
 AddPerson(83,7,14,0);
 SetSceneID(54,5);
 talk( 2,"兄长，刚才间谍报告说，曹操已并吞了袁绍．",
 1,"什么？曹操把袁绍也兼并了啊！");
 --显示任务目标:<与关羽商量．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [299]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"大哥，刚才间谍报告说，曹操已并吞了袁绍．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"果然小小山贼不是我的对手呀．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"让刘表那么棘手的江夏反贼被刘备消灭了，刘备好厉害啊！");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"连袁绍也没能阻挡住曹操啊！");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"现在能跟曹操对抗的也就只有刘表啦．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"啊，主公，好像有客人来．");
 AddPerson(115,0,5,3);
 MovePerson(115,7,3);
 NextEvent();
 end
 end,
 [300]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"大哥，刘琦公子好像有话要说．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"刘琦公子专程来访，可能有什么事吧．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"主公，先见刘琦吧．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"是刘琦公子呀，有什么事吧．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"主公，先见刘琦吧．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"主公，先见刘琦吧．");
 end
 if JY.Tid==115 then--刘琦
 talk( 115,"叔叔，我要去江夏．我们暂时要分开了．我这次是特意来和你们告别的．",
 1,"谢谢你专程来一趟．",
 115,"以后有什么事的话，也请跟我商量一下．那么我告辞了．");
 MovePerson(115,8,2);
 DecPerson(115);
 NextEvent();
 end
 end,
 [301]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"听说刘琦公子在自己和刘琮公子谁是继承人的问题上很苦恼，是不是也因为这个才去江夏呢？");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"江夏是我替他们平定的啊．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"刘琦公子好像有些笑逐颜开了啊，好像已没有苦恼了．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"刘皇叔，我刚才在城里见到了水镜先生．请你去见见水镜先生吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"伊籍以前就一直提水镜先生，到底是谁呢？");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"主公，到外面去散散心如何？");
 end
 end,
 [302]=function()
 JY.Smap={};
 JY.Base["现在地"]="新野";
 JY.Base["道具屋"]=13;
 AddPerson(1,25,9,1);
 AddPerson(382,7,14,0);
 AddPerson(372,27,18,2);
 AddPerson(355,20,5,3);
 AddPerson(359,13,8,3);
 AddPerson(357,14,20,2);
 SetSceneID(71,5);
 
 MovePerson(382,2,3);
 MovePerson(382,5,0);
 talk( 382,"呕，你是刘皇叔吗？",
 1,"我是，那么你是？",
 382,"果然是，听说你的大名，特来拜见．我叫司马徽．人称水镜先生．",
 1,"你就是水镜先生呀．可是你怎么知道我？",
 382,"这里的百姓广为称赞你呀．不过江夏之战你们打得很漂亮呀．",
 1,"这都多亏有这么多勇将呀！",
 382,"的确，这里有关羽，张飞和赵云，不过，依我看来，人才还不够．",
 1,"不，不是这样吧．",
 382,"那你为什么要守在这么个小城？难道你没有更大的雄心？",
 1,"……",
 382,"是吧……如果能得到伏龙凤雏之一，你的雄心壮志就不会落空了．",
 1,"伏龙？凤雏？他们是谁？",
 382,"伏龙姓诸葛，名亮，字孔明．凤雏姓庞名统，字士元．",
 1,"诸葛亮……孔明……庞统……伏龙凤雏就是他们呀？",
 382,"孔明住在襄阳以西的隆中乡下，如果有意你可以去拜会一下．",
 1,"隆中，我知道了，我尽快去那里．",
 382,"那么，我也算见到你了．告辞了．");
 MovePerson(382,12,1);
 DecPerson(382);
 --显示任务目标:<在议事厅与关羽、张飞说诸葛亮的事．>
 NextEvent();
 end,
 [303]=function()
 JY.Smap={};
 JY.Base["现在地"]="新野";
 JY.Base["道具屋"]=13;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(64,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(114,9,15,0);
 AddPerson(83,7,14,0);
 SetSceneID(54,5);
 talk( 1,"关羽，张飞，现在去隆中．",
 3,"怎么了？这么急急忙忙的？",
 2,"去隆中有什么事？",
 1,"我刚才在酒馆见到了伊籍，提到水镜先生．",
 114,"噢，您见到了水镜先生．",
 1,"水镜先生说，一个叫诸葛亮，字孔明的人住在隆中．",
 3,"那个叫诸葛亮的家伙有什么了不起的地方吗？",
 1,"听水镜先生的口气，这是个了不起的人．",
 2,"那么兄长要去一趟呀．",
 1,"关羽好像有些不服？",
 3,"我也觉得没什么意思．",
 1,"不要这么说，我们走吧．",
 2,"是！");
 MovePerson( 2,2,2,
 3,2,2);
 MovePerson( 2,1,2,
 3,1,1);
 MovePerson( 2,2,1,
 3,2,1);
 MovePerson( 2,7,2,
 3,7,2);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [304]=function()
 if JY.Tid==54 then--赵云
 talk( 54,"你们早点回来，我来留守．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"你们早点回来，既然是水镜先生推荐的，一定是相当了不起的人，是隆中？就是襄阳西南的一个村子．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"早点回来．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"早点回来．");
 end
 end,
 [305]=function()
 JY.Smap={};
 JY.Base["现在地"]="隆中";
 JY.Base["道具屋"]=0;
 AddPerson(1,9,12,3);
 AddPerson(2,5,11,3);
 AddPerson(3,7,10,3);
 AddPerson(381,11,13,2);
 SetSceneID(44,8);
 DrawStrBoxCenter("孔明草庐");
 talk( 2,"这就是那个孔明住的房子？",
 3,"那么了不起的人，住在这种地方？",
 2,"兄长，先问问那个童子吧．")
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [306]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"问问童子吧．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"问问童子吧．");
 end
 if JY.Tid==381 then--童子
 talk( 381,"你们是谁？",
 1,"汉左将军宜城亭侯领豫州牧皇叔刘备特来拜见先生，请帮我们通报一下吧．",
 381,"稍等一下，我记不住这么长的名字．",
 3,"那么就说新野的刘备来了．",
 381,"先生出去了．",
 2,"汉左将军宜城亭侯领豫州牧皇叔刘备特来拜见先生，请帮我们通报一下吧．",
 381,"不在吗？去哪里了？什么时候回来？",
 381,"不清楚，有时很快就回来，有时好久也不回来．");
 NextEvent();
 end
 end,
 [307]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，我们回新野吧．");
 MovePerson( 2,0,2,
 3,0,2);
 DecPerson(2);
 DecPerson(3);
 NextEvent();
 end
 if JY.Tid==3 then--张飞
 talk( 3,"好不容易才来这里一趟，他却不在，大哥，孔明不会有什么了不起的．算了吧．");
 end
 if JY.Tid==381 then--童子
 talk( 381,"我一定转告先生说新野的刘备来过了．");
 end
 end,
 [308]=function()
 if JY.Tid==381 then--童子
 talk( 381,"先生还没有回来呀．");
 talk( 381,"我一定转告先生说新野的刘备来过了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [309]=function()
 JY.Smap={};
 JY.Base["现在地"]="新野";
 JY.Base["道具屋"]=13;
 AddPerson(2,25,7,1);
 AddPerson(3,29,9,1);
 AddPerson(1,25,9,1);
 AddPerson(112,6,14,3);
 AddPerson(372,27,18,2);
 AddPerson(355,20,5,3);
 AddPerson(359,13,8,3);
 AddPerson(357,14,20,2);
 SetSceneID(71,5);
 PlayBGM(6);
 MovePerson(112,4,3);
 talk( 112,"当今之～社会");
 MovePerson(112,4,0);
 talk( 112,"乱之～又乱");
 MovePerson(112,4,2);
 talk( 112,"我在等～待～拯救社会～之人．");
 MovePerson(112,4,1);
 talk( 112,"我～虽～有才～．");
 MovePerson(112,2,3);
 talk( 112,"却无～人～用我．");
 talk( 3,"大哥，那家伙怎么回事？是否有些奇怪？",
 1,"不，唱这歌是有意吸引人．莫非他就是水镜先生说的伏龙或凤雏？",
 3,"说什么呢？不可能是．",
 1,"不对，肯定是．好，跟他说说看．");
 MovePerson(1,3,1);
 talk( 1,"那位先生．");
 MovePerson(112,3,0);
 talk( 112,"哎，有什么事？",
 1,"对不起，能否冒昧请教一下您的尊姓大名？",
 112,"我叫徐庶．",
 1,"啊，弄错人了，失礼了．",
 112,"那么你是谁呢？",
 1,"我叫刘备．",
 112,"啊！对不起，不知刘皇叔驾到，请原谅我的失礼．是这样，我听水镜先生说起过皇叔，所以在这里唱歌以引起您的注意，觉得这样也许能见到您．",
 1,"你是水镜先生的朋友？怎么样，能否请你辅佐我？",
 112,"当然可以，我就是这么想的．请多关照．",
 1,"那么，我们一起进城吧．");
 ModifyForce(112,1);
 PlayWavE(11);
 DrawStrBoxCenter("徐庶成为部下．");
 MovePerson( 1,1,1,
 112,1,3);
 MovePerson( 1,11,1,
 112,11,1);
 DecPerson(1);
 DecPerson(112);
 talk( 3,"啊！他们走了．喂，二哥，最近大哥是不是有些奇怪？",
 2,"唉，求才若渴．大哥有大哥的想法．",
 3,"如果这样的话，大哥岂不是会越来越怪．",
 2,"与其这样嘟嘟囔囔地说话，还不如我们也进城．",
 3,"好吧！");
 NextEvent();
 end,
 [310]=function()
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(9,25,9,1);
 AddPerson(17,14,9,3);
 AddPerson(18,12,10,3);
 AddPerson(20,10,11,3);
 AddPerson(69,25,15,2);
 AddPerson(77,23,16,2);
 AddPerson(78,21,17,2);
 AddPerson(19,17,13,0);
 SetSceneID(85,11);
 DrawStrBoxCenter("许昌议事厅");
 LoadPic(30,1);
 DrawMulitStrBox("　此时曹操军消灭了袁绍军的残余部队，得到了袁绍的全部地盘．如此，曹操就得到了中国北方的全部领土．*　曹操的下一个目标是刘备等所在的荆州，另外还有东吴．");
 ModifyForce(103,9);
 LoadPic(30,2);
 talk( 9,"袁绍已被歼灭了，这次该攻打荆州了吧．曹仁，你先率兵试探刘备的实力，然后决定我们是否出征．",
 19,"明白了．可是，以刘备的实力，能和我军相比吗？",
 9,"尽管我也是这么想，可是不知为什么总有些担心刘备这个人，不可大意哟．",
 19,"是，我马上率兵出发．");
 MovePerson(19,9,1);
 DecPerson(19);
 NextEvent();
 end,
 [311]=function()
 JY.Smap={};
 JY.Base["现在地"]="新野";
 JY.Base["道具屋"]=13;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(64,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(114,9,15,0);
 AddPerson(83,7,14,0);
 AddPerson(112,10,10,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("新野议事厅");
 talk( 54,"主公，这个人是孔明吗？",
 1,"不是，他叫徐庶．据说与水镜先生是好友．");
 MovePerson(112,3,3);
 talk( 112,"主公，您知道孔明吗？",
 1,"啊，只听水镜先生说过．他说我如果能得到孔明，梦想也就能实现．",
 112,"是吗，我和孔明是旧识．",
 1,"什么！这太好了．徐庶，把孔明介绍给我好吗？",
 112,"这个，他可不是我说情就能打动的人物．主公最好还是亲自去一趟．",
 1,"是吗……？",
 112,"但是，得到孔明，可不是一件简单的事．",
 54,"你和他比怎么样？",
 112,"我比他差远了．",
 3,"真那么神吗？这个人肯定有些奇怪．",
 112,"我觉得自己还有一点自信，可是跟孔明比，他志向比我远大多了．",
 1,"是吗．好，关羽、张飞，我们再去一趟．",
 3,"哎呀，还要去呀？",
 1,"他也许已经回来了．而且听了徐庶的话，我觉得无论如何也得见到他．",
 2,"去吧，张飞，做好准备．",
 3,"好．");
 MovePerson( 2,2,2,
 3,2,2);
 MovePerson( 2,1,2,
 3,1,1);
 MovePerson( 2,2,1,
 3,2,1);
 MovePerson( 2,7,2,
 3,7,2);
 --显示任务目标:<再访隆中诸葛亮．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [312]=function()
 if JY.Tid==54 then--赵云
 talk( 54,"请早回来．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"如果水镜先生推荐的话，那绝对不会有错．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"请早点回来．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"请早点回来．");
 end
 if JY.Tid==112 then--徐庶
 talk( 112,"请一定要把孔明带回来．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [313]=function()
 JY.Smap={};
 JY.Base["现在地"]="隆中";
 JY.Base["道具屋"]=0;
 AddPerson(1,9,12,3);
 AddPerson(2,5,11,3);
 AddPerson(3,7,10,3);
 AddPerson(380,27,12,0);
 AddPerson(381,11,13,2);
 SetSceneID(44,8);
 DrawStrBoxCenter("孔明草庐");
 talk( 2,"这就是那个孔明住的房子？",
 3,"那么了不起的人，住在这种地方？",
 2,"兄长，先问问那个童子吧．")
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [314]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"这次会不会在呢？");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"啊，我这次不来就好了．……啊，大哥，脸色别那么吓人哪．");
 end
 if JY.Tid==380 then--诸葛均
 talk( 1,"……读书如此聚精会神，好像一点都没注意到我们，此人一定是孔明．");
 end
 if JY.Tid==381 then--童子
 talk( 381,"啊，是新野的刘皇叔啊，请稍等一下，先生今天在．");
 MovePerson(381,4,3);
 MovePerson(381,4,0);
 talk( 381,"先生，新野的刘皇叔来了．",
 380,"嗯……？哦，刘皇叔．");
 MovePerson(380,1,1);
 MovePerson( 380,3,1,
 381,3,1);
 MovePerson( 380,3,2,
 381,3,2);
 talk( 380,"刘皇叔，欢迎光临．");
 NextEvent();
 end
 end,
 [315]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"这就是孔明吗？怎么看上去像是个农民啊．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"什么？这是孔明？他是孔明的话，徐庶肯定比他聪明多了．");
 end
 if JY.Tid==380 then--诸葛均
 talk( 380,"您是来找家兄的吧．",
 1,"嗯？那先生不是卧龙先生了？",
 380,"是的，我是他的弟弟诸葛均．我们共兄弟三人，长兄诸葛瑾在东吴为官，我是最小的弟弟，孔明是我二哥．",
 1,"卧龙先生不在这里？",
 380,"啊，他还没回来．哥哥一旦出门，我们都不知道他什么时候回来．对不起．",
 1,"是吗，又没能见到面．");
 NextEvent();
 end
 if JY.Tid==381 then--童子
 talk( 381,"唉，好像不是先生．");
 end
 end,
 [316]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"又白跑一趟，没办法，回去吧．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，快回去．累死了．");
 end
 if JY.Tid==380 then--诸葛均
 talk( 1,"能否请您把这封信交给卧龙先生．",
 380,"可以，一定转交给他．日后叫他去拜访您．",
 1,"不用，还是我来吧．请您一定把信交给他．我告辞了．");
 MovePerson( 2,0,2,
 3,0,2);
 DecPerson(2);
 DecPerson(3);
 PlayBGM(5);
 --显示任务目标:<回新野．>
 NextEvent();
 end
 if JY.Tid==381 then--童子
 talk( 381,"请慢走．");
 end
 end,
 [317]=function()
 if JY.Tid==380 then--诸葛均
 talk( 380,"哥哥还没回来，对不起．",
 1,"请您一定把信交给他．我告辞了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==381 then--童子
 talk( 381,"先生还没回来，他去哪了呢．");
 end
 end,
 [318]=function()
 JY.Smap={};
 JY.Base["现在地"]="新野";
 JY.Base["道具屋"]=13;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(64,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(114,9,15,0);
 AddPerson(83,7,14,0);
 AddPerson(112,10,10,3);
 SetSceneID(54,11);
 talk( 112,"主公，刚得到消息，曹操军正奔这里来．",
 1,"什么！曹操军！",
 2,"听说敌将是曹仁．",
 3,"曹操奸贼！得到袁绍的地盘还觉不够吗？真是个贪婪的家伙．",
 54,"主公，准备出征吧．");
 --显示任务目标:<做出征曹操军的准备．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [319]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"曹操命曹仁为主将，据说现在率大军已到南阳．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"这次我们也兵多将广啦，不能像以前那样让他们占便宜．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"消灭袁绍后的目标就是荆州吧，曹操的慾望没有止境．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"我们坚守新野吧．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"应该快做出征准备．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"因为我们面对的是曹操军，所以必须做好充份的准备．");
 end
 if JY.Tid==112 then--徐庶
 talk( 112,"此次作战，是我表现谋略的好机会，请您一定带我同去．",
 1,"好，就让你一显谋略．看你啦．",
 112,"谢谢．");
 NextEvent();
 end
 end,
 [320]=function()
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"出发吧？") then
 RemindSave();
 PlayBGM(12);
 talk( 2,"请列好部队．");
 WarIni();
 DefineWarMap(21,"第二章 南阳之战","一、曹仁败退",40,0,18);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,2,0, 4,0,-1,0,
 111,2,2, 4,0,-1,0,
 -1,3,3, 4,0,-1,0,
 -1,1,3, 4,0,-1,0,
 -1,4,2, 4,0,-1,0,
 -1,0,2, 4,0,-1,0,
 -1,3,1, 4,0,-1,0,
 -1,1,1, 4,0,-1,0,
 -1,1,0, 4,0,-1,0,
 -1,0,0, 4,0,-1,0,
 });
 DrawSMap();
 talk( 2,"好，向南阳进发．");
 JY.Smap={};
 SetSceneID(0,3);
 talk( 112,"主公，去南阳吧．");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 18,21,9, 3,2,30,3, 0,0,-1,0,
 19,19,8, 3,2,27,24, 0,0,-1,0,
 172,19,10, 3,2,27,5, 0,0,-1,0,
 123,12,6, 3,1,26,11, 0,0,-1,0,
 124,12,11, 3,1,26,11, 0,0,-1,0,
 115,18,9, 3,2,27,2, 0,0,-1,0,
 256,14,7, 3,2,25,2, 0,0,-1,0,
 257,14,11, 3,2,25,2, 0,0,-1,0,
 258,14,4, 3,2,24,2, 0,0,-1,0,
 259,14,14, 3,2,24,2, 0,0,-1,0,
 260,17,4, 2,2,23,2, 0,0,-1,0,
 261,17,14, 1,2,23,2, 0,0,-1,0,
 262,20,4, 2,2,23,2, 0,0,-1,0,
 263,20,14, 1,2,23,2, 0,0,-1,0,
 274,12,7, 3,1,25,5, 0,0,-1,0,
 275,12,10, 3,1,25,5, 0,0,-1,0,
 276,16,8, 3,2,24,5, 0,0,-1,0,
 277,16,10, 3,2,22,5, 0,0,-1,0,
 278,17,7, 3,2,22,5, 0,0,-1,0,
 279,17,11, 3,2,23,5, 0,0,-1,0,
 292,16,6, 3,2,23,8, 0,0,-1,0,
 293,16,12, 3,2,22,8, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 if JY.Tid==3 then--张飞
 talk( 3,"这次我们也兵多将广啦，不能像以前那样让他们占便宜．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"消灭袁绍后的目标就是荆州吧，曹操的慾望没有止境．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"我们坚守新野吧．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"应该快做出征准备．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"因为我们面对的是曹操军，所以必须做好充份的准备．");
 end
 if JY.Tid==112 then--徐庶
 talk( 112,"这次请看我的．");
 end
 end,
 [321]=function()
 PlayBGM(11);
 talk( 19,"嚄，来了啊．我们恭候多时了．吕旷，先去试试敌人的实力．",
 124,"遵命！",
 19,"其余部队不要动！耐心引诱敌人，等敌人一汇集到面前，就狠狠地打！明白了吗！");
 talk( 1,"好，全面出击！！",
 112,"主公，请等一下．看敌人的阵形，曹仁好像是在引诱我们，这样突击的话很危险．因此，从最里边的栅栏处进行攻击，可以打乱敌人的阵形．",
 1,"从最里边？",
 112,"是的，这种阵形从正面进攻的话很坚实，如若从侧面进攻就比较脆弱易攻．",
 1,"噢，这种阵形你看一眼就能了解到破阵法……",
 112,"总之，要打乱敌人的阵形，就必须从里边攻击．打吧！");
 WarShowTarget(true);
 PlayBGM(10);
 NextEvent();
 end,
 [322]=function()
 if WarMeet(3,125) then
 WarAction(1,3,125);
 talk( 3,"曹操军狗贼！我这次可不让你们好过！我来杀你！",
 125,"那是张飞啊，传说他很厉害，我去试试看！");
 WarAction(6,3,125);
 if fight(3,125)==1 then
 talk( 125,"……！不好，这样下去会输的！没想到会这样厉害．",
 3,"现在知道已经晚了！送你上西天！");
 WarAction(8,3,125);
 talk( 125,"啊……！");
 WarAction(18,125);
 WarLvUp(GetWarID(3));
 else
 WarAction(4,125,3);
 talk( 3,"……");
 WarAction(17,3);
 WarLvUp(GetWarID(125));
 end
 end
 if WarMeet(54,124) then
 WarAction(1,54,124);
 talk( 54,"那位大将！我来战你！",
 124,"那不是赵云吗？……在这里如能一展雄风，我的大名岂不远扬啦．好！赵云，我吕旷战你．");
 WarAction(6,54,124);
 if fight(54,124)==1 then
 talk( 54,"看枪！！");
 WarAction(8,54,124);
 talk( 124,"啊……！");
 WarAction(18,124);
 WarLvUp(GetWarID(54));
 else
 WarAction(4,124,54);
 talk( 54,"太厉害了！");
 WarAction(17,54);
 WarLvUp(GetWarID(124));
 end
 end
 if GetFlag(138) then
 
 elseif between(JY.Death,257,262) then
 SetFlag(138,2);
 PlayBGM(11);
 talk( 19,"嚄，来吧！刘备！好，全军总攻击！消灭刘备军！");
 WarModifyAI(18,1);
 WarModifyAI(19,1);
 WarModifyAI(172,1);
 WarModifyAI(115,1);
 WarModifyAI(256,1);
 WarModifyAI(257,1);
 WarModifyAI(258,1);
 WarModifyAI(259,1);
 WarModifyAI(260,1);
 WarModifyAI(261,1);
 WarModifyAI(262,1);
 WarModifyAI(263,1);
 WarModifyAI(276,1);
 WarModifyAI(277,1);
 WarModifyAI(278,1);
 WarModifyAI(279,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 DrawStrBoxCenter("敌人开始攻击！");
 elseif between(JY.Death,263,264) then
 SetFlag(138,1);
 PlayBGM(11);
 talk( 19,"什么！刘备军怎么会知道破阵法！？不好！如果他们突破了那里，我们就不能进行有力反击！！",
 112,"主公，这样一来敌人首尾不能相顾．一鼓作气消灭敌人吧．");
 WarModifyAI(19,6,16,13);
 WarModifyAI(172,6,14,6);
 WarModifyAI(292,6,14,9);
 WarModifyAI(277,6,18,8);
 WarModifyAI(278,6,20,11);
 WarModifyAI(279,6,21,6);
 WarEnemyWeak(2,2);
 DrawStrBoxCenter("敌人指挥失灵！");
 PlayBGM(10);
 end
 if JY.Status==GAME_WARWIN then
 --DrawMulitStrBox("在这里，事件数据的构造上不能使用ＨＥＸ胜利．还有，一般游戏玩到这里时应该是出错了．");
 talk( 19,"他妈的……！没料到会是这样！全军，撤退！！");
 PlayBGM(7);
 DrawMulitStrBox("　曹仁败退了，刘备军打败了曹仁军．");
 GetMoney(800);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金８００！");
 if JY.Base["事件"..138]==1 then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [323]=function()
 SetSceneID(0,3);
 talk( 2,"呀，我算折服徐庶了，这仗打得太漂亮了．",
 3,"我实在是想不透……",
 112,"哈哈哈，打仗仅靠武力是不能取胜的．那么，主公，我们回新野吧．");
 NextEvent();
 end,
 [324]=function()
 SetSceneID(-1,0);
 JY.Base["章节名"]="第二章　诸葛孔明下山";
 DrawStrBoxCenter("第二章　诸葛孔明下山");
 LoadPic(14,1);
 DrawMulitStrBox("　刘备打败曹仁军的消息马上传到了曹操的耳朵里，根据曹仁的报告，显然是刘备得到徐庶后力量加强了．*　对此，曹操与属下程昱研究让徐庶离开刘备的策略．");
 LoadPic(14,2);
 --显示任务目标:<与关羽谈讨下一步之事．>
 NextEvent();
 end,
 [325]=function()
 JY.Smap={};
 JY.Base["现在地"]="新野";
 JY.Base["道具屋"]=13;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(64,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(114,9,15,0);
 AddPerson(83,7,14,0);
 AddPerson(112,10,10,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("新野议事厅");
 talk( 2,"兄长，你在吗？正好，徐庶好像有话要对兄长讲．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [326]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"徐庶好像有话要对兄长讲．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"徐庶，把你刚才的话也讲给我大哥听吧．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"徐庶好像有话要对主公讲．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"徐庶好像有话要对主公讲．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"徐庶好像有话要对主公讲．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"徐庶好像有话要对主公讲．");
 end
 if JY.Tid==112 then--徐庶
 talk( 112,"其实，我收到了母亲的一封信，信上说，她老人家被曹操掳走了．",
 1,"什么！",
 112,"母亲很寂寞，我想马上就去见她．虽然很难启齿，但请准许我离开．",
 1,"徐庶，没有什么能比过母子感情了，你马上去看望令堂吧，我们也许还能见面．",
 112,"主公，呜呜……谢谢了！");
 NextEvent();
 end
 end,
 [327]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"徐庶，再见了！");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"徐庶对母亲尽孝吧！");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"虽然相处时间很短，但很快乐．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"好不容易水镜先生介绍他来同辅刘备，太可惜了．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"徐庶是个俊杰，太可惜了．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"唉，是个大损失呀．");
 end
 if JY.Tid==112 then--徐庶
 talk( 112,"主公，谢谢了．我将在帝都祝大家一帆风顺．呜呜……再见．");
 MovePerson(112,7,2);
 NextEvent();
 end
 end,
 [328]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，你舍不得徐庶离去，我很理解．可是这是命啊，你想开点．");
 end
 if JY.Tid==3 then--张飞
 DrawMulitStrBox("主公！！");
 talk( 3,"嗯？这不是徐庶的声音吗？");
 MovePerson(112,10,3);
 NextEvent();
 end
 if JY.Tid==54 then--赵云
 talk( 54,"失去了一个人才，我很体谅主公的心情．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"好不容易水镜先生介绍他来同辅刘备，太可惜了．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"徐庶是个人才，是很可惜呀．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"唉，是个大损失呀．");
 end
 if JY.Tid==112 then--徐庶
 talk( 112,"主公，谢谢了．我将在帝都祝大家一帆风顺．呜呜……再见．");
 end
 end,
 [329]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"徐庶为什么又回来了？");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"徐庶，到底是怎么回事？");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"徐庶，怎么啦？");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"徐庶，怎么啦？");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"徐庶，怎么啦？");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"徐庶，怎么啦？");
 end
 if JY.Tid==112 then--徐庶
 talk( 112,"我，我刚才一惊慌，有一件事忘了跟主公讲了．",
 1,"是什么事？",
 112,"请您一定要请孔明来．如果孔明能为主公效力，起的作用要远比我大．",
 1,"明白了．即使是为回报你惦记我们的这片心意，我也一定要说服孔明．",
 112,"好，那么主公请多保重．");
 MovePerson(112,10,2);
 DecPerson(112);
 ModifyForce(112,0);
 talk( 1,"好，徐庶既然如此推荐，肯定不会有错的．关羽、张飞去隆中．",
 3,"哎，还要去呀！",
 1,"唉？张飞，你好像不服气啊．",
 3,"当然了，这已经是第三次了．");
 NextEvent();
 end
 end,
 [330]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长已经去了两次，是不是有些过份了，孔明该不是在躲避兄长吧．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"像孔明这样的乡巴佬不可能是人才，大哥就不要去了，我去把他给你带来．",
 1,"太没礼貌了，不许这样！张飞，你不要跟去了，我和关羽两个人去．",
 3,"……两位哥哥去，我却不去，这太不合情理了，我也去吧．",
 1,"那么在先生面前不得无礼．",
 3,"好好，我知道了．");
 MovePerson( 2,2,2,
 3,2,2);
 MovePerson( 2,1,2,
 3,1,1);
 MovePerson( 2,2,1,
 3,2,1);
 MovePerson( 2,7,2,
 3,7,2);
 --显示任务目标:<三访隆中诸葛亮>
 NextEvent();
 end
 if JY.Tid==54 then--赵云
 talk( 54,"我只是听从主公的吩咐，如果主公觉得需要孔明，就按主公想的那样办好了．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"是水镜先生，还有徐庶极力推荐的，我想不会有错．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"如果比徐庶都强，那么，应该是个了不起的人才，可是究竟是不是真的呢？");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"唉，的确需要有一个接替徐庶的人才呀．");
 end
 end,
 [331]=function()
 if JY.Tid==54 then--赵云
 talk( 54,"这已是第三次去隆中了．",
 1,"哪怕十次百次也要请到孔明．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"请一定要见到卧龙先生．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"等着听好消息．");
 end
 if JY.Tid==83 then--简雍
 talk( 83,"请早点回来．");
 end
 end,
 [332]=function()
 JY.Smap={};
 JY.Base["现在地"]="隆中";
 JY.Base["道具屋"]=0;
 AddPerson(1,9,12,3);
 AddPerson(2,5,11,3);
 AddPerson(3,7,10,3);
 AddPerson(381,11,13,2);
 SetSceneID(44,8);
 DrawStrBoxCenter("孔明的茅庐");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [333]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"今天好像在家啊．呀，孔明是个什么样的人物呢？看看再说吧．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"哼，孔明太可恶了．我今天可要剥掉他的皮．");
 end
 if JY.Tid==381 then--童子
 talk( 381,"呀，刘皇叔，欢迎欢迎．",
 1,"孔明先生在家吗？",
 381,"唉，现在正在午睡．我去叫醒他吧．",
 1,"不要，让他继续睡吧，我在这里等着．");
 NextEvent();
 end
 end,
 [334]=function()
 if JY.Tid==2 then--关羽
 talk( 1,"你们去外面等着，我在这里等．",
 2,"知道了．喂，张飞，去外面．",
 3,"是是．");
 MovePerson( 2,0,2,
 3,0,2);
 DecPerson(2);
 DecPerson(3);
 NextEvent();
 end
 if JY.Tid==3 then--张飞
 talk( 3,"孔明这个家伙，在睡觉吗？也太没礼貌了，我去叫醒他．",
 1,"张飞，站住！不得无礼．",
 3,"嘿，知道了，我不说了．");
 end
 if JY.Tid==381 then--童子
 talk( 381,"真的可以不用叫醒吗？",
 1,"唉，你不要介意．",
 381,"嗯……．");
 end
 end,
 [335]=function()
 if JY.Tid==381 then--童子
 talk( 381,"哎呀，刘皇叔，我还没打扫呢．我可以去清扫吗？",
 1,"啊，当然可以．你去打扫吧，不要介意．",
 381,"那么失陪了．");
 MovePerson(381,6,3);
 NextEvent();
 end
 end,
 [336]=function()
 if JY.Tid==381 then--童子
 talk( 381,"哎呀，刘皇叔，我还没打扫完呢．");
 MovePerson(381,3,0);
 NextEvent();
 end
 end,
 [337]=function()
 if JY.Tid==381 then--童子
 talk( 381,"哎呀，刘皇叔，我还没打扫完呢．");
 MovePerson(381,6,1);
 NextEvent();
 end
 end,
 [338]=function()
 if JY.Tid==381 then--童子
 MovePerson(1,5,3);
 talk( 1,"唉，好像还没醒啊．就凭这大大方方睡觉的样子，此人一定是个了不起的人物．");
 AddPerson(3,7,10,3);
 MovePerson(3,3,3);
 talk( 3,"这家伙还装睡？我没法忍了．我去给他房子点一把火，看他还睡不睡！");
 AddPerson(2,5,11,3);
 talk( 2,"张飞，不许乱来！");
 MovePerson(2,3,3);
 talk( 2,"你太性急了，老实待着．张飞，还是听兄长的吧．",
 3,"我，我知道了．我不说话行了吧，这个畜生．");
 MovePerson( 2,3,2,
 3,3,2);
 DecPerson(2);
 DecPerson(3);
 NextEvent();
 end
 end,
 [339]=function()
 if JY.Tid==381 then--童子
 talk( 381,"哎呀，刘皇叔，我还没打扫完呢．");
 MovePerson(381,6,2);
 NextEvent();
 end
 end,
 [340]=function()
 if JY.Tid==381 then--童子
 talk( 381,"哎呀，刘皇叔，我还没打扫完呢．");
 MovePerson(381,6,3);
 NextEvent();
 end
 end,
 [341]=function()
 --talk( 381,"唉，刘备去哪呢？");
 if JY.Tid==381 then--童子
 talk( 381,"啊，刘皇叔，我打扫完了．");
 talk( 126,"来人？",
 381,"啊，先生在叫我，请您稍等一下．");
 MovePerson(381,6,3);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [342]=function()
 JY.Smap={};
 JY.Base["现在地"]="隆中";
 JY.Base["道具屋"]=0;
 AddPerson(1,4,8,3);
 AddPerson(381,19,15,0);
 AddPerson(126,21,14,1);
 SetSceneID(45);
 talk( 126,"是谁在那里？是什么俗人来了吧．",
 381,"那是刘皇叔．",
 126,"什么？为什么不早叫醒我？",
 381,"可刘皇叔不让我叫醒您．",
 126,"我知道了．");
 MovePerson(126,2,1);
 MovePerson(126,2,2);
 talk( 126,"啊，刘皇叔，虽说是不知大驾光临．但刚才午睡实在失礼，对不起．啊，请进！");
 MovePerson( 126,2,0,
 1,2,3);
 MovePerson( 126,1,0,
 1,1,0);
 MovePerson( 126,1,2,
 1,1,0);
 MovePerson( 1,0,3);
 NextEvent();
 end,
 [343]=function()
 local menu={
 {"　 发问",nil,1},
 {"　 听说",nil,1},
 {"　 说服",nil,1},
 {"　 哭泣",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 126,"唉，对您说些什么呢？");
 elseif r==2 then
 talk( 126,"您几次降尊屈驾到我这里来，我觉得应该对你有所回报．");
 elseif r==3 then
 talk( 126,"昨天我看过您的信，深深为刘皇叔救国忧民的志向所感动，可是我年少无知，恐怕无助于您．",
 1,"哪里．水镜先生和徐庶都极力向我推荐你，他们不会错的．",
 126,"他们都是优秀的人物，而我不过是一介书生，谈论天下大事实在无能为力．",
 1,"大丈夫抱经世奇才，却把青春空守山野．这实在太可惜了，请你一定下山帮助我．",
 126,"刘皇叔，我就告诉你用自己的力量对抗曹操的办法吧．");
 NextEvent();
 elseif r==4 then
 talk( 126,"刘皇叔，为何突然哭了．无论如何请你抬起头来．");
 end
 end,
 [344]=function()
 local menu={
 {"　 发问",nil,1},
 {"　 听说",nil,1},
 {"　 说服",nil,1},
 {"　 哭泣",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 1,"对抗曹操的办法，你是说我也能对抗曹操？",
 126,"是的，这是我回报您三顾茅庐的礼物．");
 NextEvent();
 elseif r==2 then
 talk( 126,"好吗？请您听好．");
 elseif r==3 then
 talk( 126,"……．");
 elseif r==4 then
 talk( 126,"刘皇叔，为何突然哭了．无论如何请你抬起头来．");
 end
 end,
 [345]=function()
 local menu={
 {"　 发问",nil,1},
 {"　 听说",nil,1},
 {"　 说服",nil,1},
 {"　 哭泣",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 126,"我只是报答您的诚意，没有其它的想法．");
 elseif r==2 then
 talk( 126,"曹操占有天时与人和，拥有百万大军，你现在不能与他对抗．另外，东吴传孙氏三代，也很富强，你也不能马上与他抗衡．",
 126,"这荆州土地肥沃，交通便利，可以认为是上天赐与刘皇叔的．另外荆州西面的益州可以说成是自然的要塞，民富国强．",
 126,"你如取荆州和益州并加以巩固，就可以北抗曹操东拒孙权．",
 1,"你是说要三分天下？",
 126,"是的．要三分天下，需让曹操和孙权对抗．这就是三分天下之计谋．");
 NextEvent();
 elseif r==3 then
 talk( 126,"……．");
 elseif r==4 then
 talk( 126,"刘皇叔，为何突然哭了．无论如何请你抬起头来．");
 end
 end,
 [346]=function()
 local menu={
 {"　 发问",nil,1},
 {"　 听说",nil,1},
 {"　 说服",nil,1},
 {"　 哭泣",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 1,"可是荆州刘表与益州刘璋都与我同宗，我不忍心夺他们的土地．",
 126,"哪里，刘表体弱多病，将不久于人世，刘皇叔继承其主位应不会有问题．另外，刘璋以暴君闻名，讨伐刘璋挽救百姓，理当受到感谢．");
 NextEvent();
 elseif r==2 then
 talk( 126,"要三分天下，需让曹操和孙权对抗．这就是三分天下之计谋．");
 elseif r==3 then
 talk( 1,"卧龙先生，能否请你辅佐我？",
 126,"我久耕农田矣，喜欢这样的生活．虽然您多次屈尊至此，但我还是不能与您同去．");
 elseif r==4 then
 talk( 126,"刘皇叔，为何突然哭了．无论如何请你抬起头来．");
 end
 end,
 [347]=function()
 local menu={
 {"　 发问",nil,1},
 {"　 听说",nil,1},
 {"　 说服",nil,1},
 {"　 哭泣",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 126,"在这里晴耕雨读适合我的心性．");
 elseif r==2 then
 talk( 126,"我的话已经说完了．");
 elseif r==3 then
 talk( 126,"……．");
 elseif r==4 then
 talk( 1,"以我个人的才能，您刚才的话犹如一场梦．如果先生在隆中陡然过一辈子，那么万民将会怎样呢？我一想到这就……，呜呜……．",
 126,"明白了，只要刘皇叔矢志不移，我会全力辅佐的．");
 PlayBGM(7);
 talk( 1,"噢！你肯帮助我了．谢谢．");
 ModifyForce(126,1);
 AddPerson(380,2,9,3);
 MovePerson(380,4,3);
 MovePerson(380,1,0);
 talk( 380,"兄长，我回来了．");
 MovePerson(126,1,1);
 talk( 126,"均，我将辅佐刘皇叔一段时间，你要好好守着这里的田地．我功成名就之日就回来．",
 380,"明白了．");
 AddPerson(2,6,9,3);
 AddPerson(3,4,10,3);
 DrawSMap();
 talk( 3,"孔明能来，太好了．");
 talk( 2,"那么我们回新野吧．");
 DrawMulitStrBox("就这样，诸葛亮成了刘备的军师，此后，这个国家的历史就按诸葛亮的想法得以发展．");
 NextEvent();
 end
 end,
 [348]=function()
 SetSceneID(-1,0);
 JY.Base["章节名"]="第二章　曹操南征";
 DrawStrBoxCenter("第二章　曹操南征");
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(383,7,8,3);
 AddPerson(9,14,9,3);
 AddPerson(17,19,8,1);
 AddPerson(19,21,9,1);
 AddPerson(20,23,10,1);
 AddPerson(69,9,14,0);
 AddPerson(77,11,15,0);
 AddPerson(78,13,16,0);
 AddPerson(112,27,18,2);
 SetSceneID(84,11);
 DrawStrBoxCenter("许昌宫殿");
 talk( 9,"徐庶，听说此次刘备得到了孔明，孔明是个怎么样的人呢？",
 112,"孔明比我强一万倍，不，恐怕还要多．",
 9,"你是个能把曹仁当小孩戏弄的人，既然你这么说，那孔明大概是个了不起的人物啊．");
 MovePerson(17,4,3);
 MovePerson(17,2,1);
 MovePerson(17,3,2);
 talk( 17,"主公，您说什么呀．我愿南征取孔明首级献给您．",
 9,"哦，……好！趁此机会消灭刘备．",
 383,"这不可！");
 MovePerson(9,1,1);
 MovePerson(9,0,2);
 talk( 9,"陛下，你说什么？刘备是叛乱的逆贼，你反对讨伐他？",
 383,"……．",
 9,"陛下，讨伐刘备，是为了国家的和平着想．那么就请陛下降旨让我们讨伐吧．",
 383,"……．",
 9,"陛下好像身体欠佳，放心去休息吧．我代帝行令．",
 383,"……．");
 MovePerson(383,1,1);
 MovePerson(383,2,3);
 MovePerson(383,1,0);
 MovePerson(383,12,3);
 DecPerson(383);
 MovePerson(9,0,3);
 talk( 9,"夏侯惇，我代帝行令．你马上率兵消灭刘备．",
 17,"是！遵令！请您等着捷报吧！");
 MovePerson(17,13,3);
 DecPerson(17);
 talk( 112,"……．");
 JY.Smap={};
 SetSceneID(0);
 talk( 17,"刘备，我送你上西天啦！全军跟我前进！");
 LoadPic(15,1);
 DrawMulitStrBox("于是发动了以夏侯惇打头阵的曹操南征之战．");
 LoadPic(15,2);
 NextEvent();
 end,
 [349]=function()
 JY.Smap={};
 JY.Base["现在地"]="新野";
 JY.Base["道具屋"]=13;
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(126,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(128,9,15,0);
 AddPerson(117,7,14,0);
 AddPerson(369,10,10,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("新野议事厅");
 DrawMulitStrBox("曹操开始南征的消息传到了刘备这里．");
 talk( 2,"兄长，前去探听曹操军情的探子回来了．听听他怎么说吧．");
 --示任务目标:<与诸葛亮等探讨下一步怎么办．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [350]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"前去探听曹操军情的探子回来了．听听他怎么说吧．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"最近曹操频频打过来，是不是又要攻过来了？");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"先听听探子的报告吧．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"士兵已训练好了，随时可以出征迎敌．");
 end
 if JY.Tid==128 then--关平
 talk( 128,"曹操是不是以前打了败仗就不敢来了？");
 end
 if JY.Tid==117 then--刘封
 talk( 117,"不打得曹仁屁滚尿流，也要打个曹操落花流水．");
 end
 if JY.Tid==369 then--武官
 talk( 369,"主公，有军情禀报．曹操军已出动，主将是夏侯惇，另外还有于禁、李典．");
 NextEvent();
 end
 end,
 [351]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"形势可不好啊，怎么办？");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"啊，形势危急．现在请孔明先生献点计谋啦．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"曹操军此次前来没有什么可怕的，只是……．",
 1,"只是？只是什么？",
 126,"只是恐怕关羽、张飞不服从我的命令，所以主公，我想求你一件事，把主公的令剑借我一用．");
 --显示任务目标:<准备出征迎击曹操军>
 NextEvent();
 end
 if JY.Tid==54 then--赵云
 talk( 54,"主公，应马上研究出对策来．");
 end
 if JY.Tid==128 then--关平
 talk( 128,"主公，怎么办？");
 end
 if JY.Tid==117 then--刘封
 talk( 117,"曹操派大军出动，怎么办？");
 end
 if JY.Tid==369 then--武官
 talk( 369,"曹操军的主将是夏侯惇，另外还有于禁、李典．");
 end
 end,
 [352]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"这次我也赞成张飞的意见．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"孔明能靠得住吗？曹操军派大军进攻，应该是坚守城池．");
 if talkYesNo( 3,"大哥，坚守城池，怎么样？") then
 RemindSave();
 PlayBGM(12);
 talk( 3,"既然敌人来势凶猛，那我们就快编好部队吧．");
 WarIni();
 DefineWarMap(23,"第二章 新野I之战","一、夏侯惇败退．*二、诸葛亮夺取粮仓．",40,0,16);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,7,5, 4,0,-1,0,
 125,10,6, 4,0,-1,0,
 2,8,7, 4,0,-1,0,
 -1,6,7, 4,0,-1,0,
 -1,5,7, 4,0,-1,0,
 -1,6,4, 4,0,-1,0,
 -1,4,6, 4,0,-1,0,
 -1,10,3, 4,0,-1,0,
 -1,10,5, 4,0,-1,0,
 -1,9,10, 4,0,-1,0,
 -1,7,10, 4,0,-1,0,
 });
 DrawSMap();
 talk( 3,"那就在新野迎击敌人吧．");
 JY.Smap={};
 SetSceneID(0,11);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 16,27,5, 3,4,32,9, 7,10,-1,0,
 129,24,6, 3,4,29,2, 7,10,-1,0,
 62,24,9, 3,4,28,2, 7,10,-1,0,
 115,25,1, 3,2,28,2, 0,0,-1,0,
 128,23,9, 3,4,29,15, 7,10,-1,0,
 79,25,8, 3,4,29,24, 7,10,-1,0,
 102,28,5, 3,4,29,22, 7,10,-1,0,
 348,28,4, 3,4,25,19, 7,10,-1,0,
 256,23,3, 3,2,24,2, 0,0,-1,0,
 257,26,6, 3,4,25,2, 7,10,-1,0,
 292,27,9, 3,4,24,8, 7,10,-1,0,
 293,25,5, 3,4,25,8, 7,10,-1,0,
 294,28,7, 3,2,25,8, 0,0,-1,0,
 
 274,25,3, 3,2,24,5, 0,0,-1,0,
 275,26,10, 3,4,25,5, 7,10,-1,0,
 276,28,8, 3,4,25,5, 7,10,-1,0,
 277,27,7, 3,2,25,5, 0,0,-1,0,
 278,23,4, 3,4,24,5, 7,10,-1,0,
 279,24,10, 3,4,25,5, 7,10,-1,0,
 328,29,6, 3,4,25,13, 7,10,-1,0,
 329,25,9, 3,4,24,13, 7,10,-1,0,
 78,1,5, 4,1,29,8, 0,0,-1,1,
 280,0,4, 4,1,25,5, 0,0,-1,1,
 281,0,5, 4,1,25,5, 0,0,-1,1,
 282,0,6, 4,1,25,5, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent(356); --goto 356
 end
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"能否把令剑借我一用？") then
 RemindSave();
 talk( 126,"谢谢．");
 MovePerson(126,1,2);
 MovePerson(126,2,1);
 MovePerson(126,5,3);
 MovePerson(126,0,2);
 talk( 126,"在博望坡迎击敌人，诸将听令．");
 MovePerson(3,2,2);
 MovePerson(3,2,1);
 MovePerson(3,4,3);
 talk( 3,"我不想听你这黄毛小子的命令．",
 126,"住口，主公令剑在此．违令者斩！",
 3,"你这种家伙能斩得了我吗？");
 MovePerson(2,3,2);
 MovePerson(2,2,1);
 MovePerson(2,3,3);
 talk( 2,"张飞，这是兄长的宝剑．你现在违背命令，就等于违背了大哥．现在先打一打看看吧，打完后再说也不迟．",
 3,"好吧．哼，我先走了．");
 MovePerson( 2,12,2,
 3,12,2);
 PlayBGM(12);
 talk( 126,"关平，刘封．",
 128,"是．",
 117,"是．");
 MovePerson( 128,1,2,
 117,1,2);
 MovePerson( 128,1,2,
 117,1,0);
 MovePerson( 128,2,0,
 117,2,0);
 MovePerson( 128,2,3,
 117,2,3);
 talk( 126,"你们两人需如此如此……．",
 128,"是．",
 117,"明白了．");
 MovePerson( 128,9,2,
 117,9,2);
 talk( 126,"主公，已对各位将军下达了作战命令．");
 WarIni();
 DefineWarMap(22,"第二章 博望坡之战","一、夏侯惇败退．",40,0,16);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,0,14, 4,0,-1,0,
 125,0,13, 4,0,-1,0,
 53,19,9, 4,0,-1,0,
 -1,2,9, 4,0,-1,0,
 -1,1,10, 4,0,-1,0,
 -1,1,11, 4,0,-1,0,
 -1,2,11, 4,0,-1,0,
 -1,1,12, 4,0,-1,0,
 2,11,3, 1,0,-1,1,
 1,11,14, 2,0,-1,1,
 154,12,15, 2,0,-1,1,
 82,10,3, 1,0,-1,1,
 116,12,5, 1,0,-1,1,
 127,13,13, 2,0,-1,1,
 });
 DrawSMap();
 talk( 126,"出兵！");
 JY.Smap={};
 SetSceneID(0,3);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 16,36,13, 3,0,33,8, 0,0,-1,0,
 129,32,13, 3,0,29,2, 0,0,-1,0,
 62,35,14, 3,0,28,2, 0,0,-1,0,
 115,36,11, 3,0,28,2, 0,0,-1,0,
 128,37,10, 3,0,29,15, 0,0,-1,0,
 274,35,11, 3,0,26,5, 0,0,-1,0,
 275,39,13, 3,0,26,5, 0,0,-1,0,
 276,33,10, 3,0,27,5, 0,0,-1,0,
 277,33,14, 3,0,27,5, 0,0,-1,0,
 278,34,10, 3,0,28,5, 0,0,-1,0,
 279,36,10, 3,0,28,5, 0,0,-1,0,
 292,37,14, 3,0,27,8, 0,0,-1,0,
 293,34,13, 3,0,27,8, 0,0,-1,0,
 294,33,12, 3,0,28,8, 0,0,-1,0,
 295,37,12, 3,0,28,8, 0,0,-1,0,
 296,38,13, 3,0,29,8, 0,0,-1,0,
 256,32,12, 3,0,27,2, 0,0,-1,0,
 257,34,11, 3,0,27,2, 0,0,-1,0,
 336,35,12, 3,0,27,15, 0,0,-1,0,
 328,38,11, 3,0,29,13, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent(); --goto 353
 end
 end
 if JY.Tid==54 then--赵云
 talk( 54,"不管怎么说，现在必须马上准备迎击敌人．");
 end
 if JY.Tid==128 then--关平
 talk( 128,"我看最好是坚守新野．");
 end
 if JY.Tid==117 then--刘封
 talk( 117,"准备好了吗？");
 end
 if JY.Tid==369 then--武官
 talk( 369,"曹操军的主将是夏侯惇，另外还有于禁、李典．");
 end
 end,
 [353]=function()
 PlayBGM(11);
 talk( 126,"那么，赵云把夏侯惇引到这里．据说夏侯惇虽然勇猛，但有些轻视敌人．所以他会冲过来的，你利用这点把他引到中心来．不可暴露我们的意图．",
 54,"明白了．",
 126,"主公，在夏侯惇完全中计之前，请不要出征，把其他士兵埋伏好．关羽和周仓埋伏在村南的山里，张飞和简雍埋伏在村北的山里．",
 1,"明白了．",
 126,"现在如果赵云能顺利行事的话，就成功了．");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [354]=function()
 if WarMeet(2,116) then
 WarAction(1,2,116);
 talk( 2,"那位大将不像是等闲之辈，敢与我关羽单挑较量！",
 116,"啊，关羽！好，来吧．");
 WarAction(6,2,116);
 if fight(2,116)==1 then
 talk( 2,"你不是我的对手，给我滚开！",
 116,"我滚，我滚．");
 WarAction(16,116);
 WarLvUp(GetWarID(2));
 else
 WarAction(4,116,2);
 talk( 2,"……");
 WarAction(17,2);
 WarLvUp(GetWarID(116));
 end
 end
 if WarMeet(54,129) then
 WarAction(1,54,129);
 talk( 54,"夏侯兰！你怎么会在这！",
 129,"子龙，不用多说，来吧．");
 WarAction(6,129,54);
 if fight(54,129)==1 then
 talk( 54,"再打下去，你也没有获胜的希望．怎么样，投降吧！",
 129,"……明白了，我愿为刘备效力．");
 ModifyForce(129,1);
 PlayWavE(11);
 DrawStrBoxCenter("夏侯兰加入我方！");
 talk( 129,"不过，我现在不想打了．",
 54,"好吧，你先撤退．");
 JY.Person[129]["道具1"]=0;
 JY.Person[129]["道具2"]=0;
 WarAction(16,129);
 WarLvUp(GetWarID(54));
 else
 talk( 54,"……");
 WarAction(16,54);
 WarLvUp(GetWarID(129));
 end
 end
 if (not GetFlag(1028)) and (not GetFlag(139)) and War.Turn==10 then
 PlayBGM(11);
 talk( 130,"夏侯惇将军，刚才先头部队禀报，敌人准备用火攻．",
 17,"什么？",
 130,"但是我先锋部队进行突击，驱散敌人的放火部队，我们应马上进攻．",
 17,"干得好，好，马上进攻！");
 WarModifyAI(16,1);
 WarModifyAI(129,1);
 WarModifyAI(62,1);
 WarModifyAI(115,1);
 WarModifyAI(128,1);
 WarModifyAI(274,1);
 WarModifyAI(275,1);
 WarModifyAI(276,1);
 WarModifyAI(277,1);
 WarModifyAI(278,1);
 WarModifyAI(279,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(294,1);
 WarModifyAI(295,1);
 WarModifyAI(296,1);
 WarModifyAI(256,1);
 WarModifyAI(257,1);
 WarModifyAI(336,1);
 WarModifyAI(328,1);
 talk( 126,"什么，火计被识破了！？唉，再早一点诱敌过来就好了……．",
 1,"怎么回事．",
 126,"这样就没办法了．战局虽然不利也只好从正面击退敌军了．");
 WarShowArmy(2-1);
 WarShowArmy(155-1);
 WarShowArmy(83-1);
 WarShowArmy(3-1);
 talk( 2,"这场战争可能很艰难……．",
 3,"我早就说不能相信孔明，你还不让我说．");
 PlayBGM(9);
 SetFlag(1028,1)
 end
 if (not GetFlag(140)) and (not GetFlag(1028)) and WarCheckArea(-1,9,26,12,31) then
 talk( 17,"唉，看见敌人了！就逗一逗你们，好，全军出击！",
 130,"夏侯惇将军，敌人可能有什么计谋，莽撞冲过去会有危险！",
 17,"胡说什么！如此畏缩不前，能赢的仗也打不赢，不要怕！前进！");
 WarModifyAI(16,1);
 WarModifyAI(129,1);
 WarModifyAI(62,1);
 WarModifyAI(115,1);
 WarModifyAI(128,1);
 WarModifyAI(274,1);
 WarModifyAI(275,1);
 WarModifyAI(276,1);
 WarModifyAI(277,1);
 WarModifyAI(278,1);
 WarModifyAI(279,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(294,1);
 WarModifyAI(295,1);
 WarModifyAI(296,1);
 WarModifyAI(256,1);
 WarModifyAI(257,1);
 WarModifyAI(336,1);
 WarModifyAI(328,1);
 SetFlag(140,1);
 end
 if (not GetFlag(139)) and (not GetFlag(1028)) and WarCheckArea(16,8,17,10,21) then
 PlayBGM(12);
 talk( 126,"好！刘封、关平，放火！");
 WarShowArmy(128-1);
 WarShowArmy(117-1);
 PlayWavE(51);
 WarFireWater(11,8,1);
 WarFireWater(11,10,1);
 WarFireWater(12,10,1);
 WarFireWater(12,11,1);
 WarFireWater(13,7,1);
 WarFireWater(14,7,1);
 WarFireWater(15,7,1);
 WarFireWater(16,7,1);
 WarFireWater(17,8,1);
 WarFireWater(18,8,1);
 WarFireWater(19,8,1);
 WarFireWater(15,11,1);
 WarFireWater(16,11,1);
 WarFireWater(17,11,1);
 WarFireWater(18,11,1);
 WarFireWater(19,11,1);
 WarFireWater(20,11,1);
 WarFireWater(21,11,1);
 talk( 17,"噢噢！怎么回事，敌人要用火攻！不好！");
 WarModifyAI(16,2);
 WarModifyAI(129,2);
 WarModifyAI(62,2);
 WarModifyAI(115,2);
 WarModifyAI(128,2);
 WarModifyAI(274,2);
 WarModifyAI(275,2);
 WarModifyAI(276,2);
 WarModifyAI(277,2);
 WarModifyAI(278,2);
 WarModifyAI(279,2);
 WarModifyAI(292,2);
 WarModifyAI(293,2);
 WarModifyAI(294,2);
 WarModifyAI(295,2);
 WarModifyAI(296,2);
 WarModifyAI(256,2);
 WarModifyAI(257,2);
 WarModifyAI(336,2);
 WarModifyAI(328,2);
 WarEnemyWeak(2,1);
 WarEnemyWeak(2,1);
 WarEnemyWeak(2,2);
 WarEnemyWeak(2,2);
 WarEnemyWeak(2,2);
 DrawStrBoxCenter("敌人开始混乱！");
 WarShowArmy(155-1);
 WarShowArmy(2-1);
 talk( 2,"好！一鼓作气消灭敌人！");
 WarShowArmy(83-1);
 WarShowArmy(3-1);
 talk( 3,"孔明，成功了！好！全军，杀向曹操军！",
 1,"噢，孔明果然名不虚传啊！",
 126,"哪里，雕虫小技而已．现在趁敌人混乱之际，彻底打垮它．");
 PlayBGM(9)
 SetFlag(139,1);
 end
 if (not GetFlag(1029)) and GetFlag(139) and War.Turn==15 then
 talk( 17,"妈的，这样下去岂不是一直被动挨打．大家马上行动！各部队分别就近向敌人进攻！");
 WarModifyAI(16,0);
 WarModifyAI(129,0);
 WarModifyAI(62,0);
 WarModifyAI(115,0);
 WarModifyAI(128,0);
 WarModifyAI(274,0);
 WarModifyAI(275,0);
 WarModifyAI(276,0);
 WarModifyAI(277,0);
 WarModifyAI(278,0);
 WarModifyAI(279,0);
 WarModifyAI(292,0);
 WarModifyAI(293,0);
 WarModifyAI(294,0);
 WarModifyAI(295,0);
 WarModifyAI(296,0);
 WarModifyAI(256,0);
 WarModifyAI(257,0);
 WarModifyAI(336,0);
 WarModifyAI(328,0);
 SetFlag(1029,1);
 end
 if JY.Status==GAME_WARWIN then
 talk( 17,"唉，竟败给刘备小儿．撤退！");
 PlayBGM(7);
 DrawMulitStrBox("　刘备军击退了夏侯惇．");
 GetMoney(900);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金９００！");
 if GetFlag(139) then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [355]=function()
 SetSceneID(0,3);
 if GetFlag(139) then
 talk( 3,"太好了，曹操军来吧！",
 2,"唉，不过孔明真了不起！",
 3,"……是啊．没办法，服他了．",
 126,"张飞，你说什么？",
 3,"嗯，没、没有．我什么也没说过．",
 126,"是吗．夏侯惇虽然败退，但曹操必定前来，我们不能不注意．");
 elseif GetFlag(1028) then
 talk( 3,"太好了，曹操军他们来吧！",
 2,"唉，尽管这次火攻不顺利，但孔明仍不失为神机妙算之人啊．",
 3,"是啊，火攻失败好像也不是他的责任．",
 54,"实在惭愧……．",
 3,"哈哈哈！好了好了！我就算服孔明了．",
 126,"张飞，你说什么？",
 3,"嗯，没、没有．我什么也没说过．",
 126,"是吗．夏侯惇虽然败退，但曹操必定前来，我们不能不注意．");
 else
 talk( 3,"喂，大哥，我都没仗可打了．",
 2,"唉，没用我就能大获全胜，倒不如说孔明太厉害了．",
 3,"是啊，没办法，只好服他了．",
 126,"张飞，你说什么？",
 3,"嗯，没、没有．我什么也没说过．",
 126,"是吗．夏侯惇虽然败退，但曹操必定前来，我们不能不注意．");
 end
 NextEvent(360); --goto 360
 end,
 [356]=function()
 PlayBGM(11);
 talk( 17,"哼，即使固若金汤也没有什么！进军新野！",
 116,"夏侯惇将军，我军现在粮草供给困难，还是留些兵马好．",
 17,"哈哈哈！李典，你是害怕啦．不要怕，这种城瞬间就能攻下．你在这里等着吧！",
 3,"孔明呀，我怎么也不会信服你，你能拿出些真本事吗？如果能夺得曹操军的粮草，我就服你．");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [357]=function()
 if WarMeet(3,63) then
 WarAction(1,3,63);
 talk( 3,"好，我要给大哥看看这时侯没有孔明一样打胜仗．那位大将！我和你决一死战！",
 63,"哎，你是何人？好，就杀你立功！");
 WarAction(6,3,63);
 if fight(3,63)==1 then
 talk( 3,"哇啊！");
 WarAction(8,3,63);
 talk( 63,"这、这是……！",
 3,"知道我张飞长矛的厉害了吧！",
 63,"什么！你是张飞啊！我打不过你！逃吧！");
 WarAction(16,63);
 talk( 3,"啊，被他逃掉了．");
 WarLvUp(GetWarID(3));
 else
 WarAction(4,63,3);
 talk( 3,"……");
 WarAction(17,3);
 WarLvUp(GetWarID(63));
 end
 end
 if WarMeet(54,129) then
 WarAction(1,54,129);
 talk( 54,"夏侯兰！你怎么会在这！",
 129,"子龙，不用多说，来吧．");
 WarAction(6,129,54);
 if fight(54,129)==1 then
 talk( 54,"再打下去，你也没有获胜的希望．怎么样，投降吧！",
 129,"……明白了，我愿为刘备效力．");
 ModifyForce(129,1);
 PlayWavE(11);
 DrawStrBoxCenter("夏侯兰加入我方！");
 talk( 129,"不过，我现在不想打了．",
 54,"好吧，你先撤退．");
 JY.Person[129]["道具1"]=0;
 JY.Person[129]["道具2"]=0;
 WarAction(16,129);
 WarLvUp(GetWarID(54));
 else
 talk( 54,"……");
 WarAction(16,54);
 WarLvUp(GetWarID(129));
 end
 end
 if (not GetFlag(1030)) and War.Turn==5 then
 WarModifyAI(16,3,0);
 WarModifyAI(129,3,0);
 WarModifyAI(62,3,0);
 WarModifyAI(128,3,0);
 WarModifyAI(79,3,0);
 WarModifyAI(102,3,0);
 WarModifyAI(257,3,0);
 WarModifyAI(275,3,0);
 WarModifyAI(276,3,0);
 WarModifyAI(278,3,0);
 WarModifyAI(279,3,0);
 WarModifyAI(292,3,0);
 WarModifyAI(293,3,0);
 WarModifyAI(348,3,0);
 WarModifyAI(328,3,0);
 WarModifyAI(329,3,0);
 SetFlag(1030,1)
 end
 if (not GetFlag(1031)) and War.Turn==8 then
 talk( 1,"唉，敌人出现了．"); --DOS版为17夏侯惇，但是感觉怪怪的，改为1刘备
 WarShowArmy(79-1);
 WarShowArmy(281-1);
 WarShowArmy(282-1);
 WarShowArmy(283-1);
 DrawStrBoxCenter("敌人援军来了！");
 talk( 79,"哦，夏侯惇将军，敌人不好对付呀！",
 17,"哼，怎么会呢！你过来干什么？");
 SetFlag(1031,1);
 end
 if (not GetFlag(1032)) and War.Turn==30 then
 talk( 17,"什么！粮草已尽？唉，仗拖得太长了……．唉，没办法，撤退！");
 WarAction(16,17);
 SetFlag(1032,1);
 NextEvent();
 end
 if (not GetFlag(75)) and WarCheckArea(125,0,22,6,31) then
 talk( 17,"什么？一部分敌人去夺我们的粮草了！唉，现在岂能撤兵！全军进行总攻击，在敌人夺我粮草前拿下新野城！");
 WarModifyAI(274,1);
 WarModifyAI(277,1);
 WarModifyAI(294,1);
 WarModifyAI(256,1);
 WarModifyAI(115,1);
 SetFlag(75,1);
 end
 if (not GetFlag(65)) and WarCheckLocation(125,0,29) then
 talk( 126,"禀报主公，敌人粮草已被我们全部夺得．",
 17,"粮草被夺了？妈的，到底被谁夺的？让孔明夺走的？唉，没办法，撤退！");
 WarAction(16,17);
 SetFlag(65,1);
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 NextEvent();
 end
 end,
 [358]=function()
 PlayBGM(7);
 DrawMulitStrBox("刘备打退了夏侯惇．");
 GetMoney(900);
 PlayWavE(11);
 DrawStrBoxCenter("夺得黄金９００！");
 if GetFlag(65) then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [359]=function()
 SetSceneID(0,3);
 if GetFlag(65) then
 talk( 3,"喂，孔明这家伙，真的夺了敌人的粮草呀．",
 2,"唉，孔明真了不起啊．",
 3,"是啊，没办法，服他啦．",
 126,"张飞，你说什么了？",
 3,"嗯，我说过什么吗？没、没有我什么也没说过．",
 126,"是吗．不过，主公，这次夏侯惇败退了，可是曹操一定会来的．我们不能轻敌啊．");
 else
 talk( 3,"太好啦，曹操军他们来吧！",
 2,"唉，不过孔明指挥作战真是了不起呀．",
 3,"……是啊，他指挥作战竟会这样厉害呀，没办法服他了．",
 126,"张飞，你说什么？",
 3,"嗯，我说过什么吗？没、没有我什么也没说过．",
 126,"是吗．不过，主公，这次夏侯惇败退了，可是曹操一定会来的．我们不能轻敌啊．");
 end
 NextEvent(); --goto 360
 end,
 [360]=function()
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=8;
 AddPerson(9,7,8,3);
 AddPerson(17,15,12,2);
 AddPerson(19,21,9,1);
 AddPerson(20,23,10,1);
 AddPerson(69,9,14,0);
 AddPerson(77,11,15,0);
 AddPerson(78,13,16,0);
 SetSceneID(84,11);
 DrawStrBoxCenter("许昌宫殿");
 talk( 17,"我口出狂言出征败战而回，请处罚我吧．",
 9,"胜败乃兵家常事，赦你无罪．但是，让刘备这样下去的话对我们今后不利，好，全军出征！先消灭刘备，然后再讨伐孙权．");
 MovePerson(17,3,3);
 MovePerson(17,3,0);
 MovePerson(17,4,2);
 MovePerson(17,0,1);
 AddPerson(367,35,22,2);
 MovePerson(367,8,2);
 talk( 367,"丞相，一个自称是荆州使者的人前来求见．",
 9,"什么？是荆州的使者？叫他进来．",
 367,"是．");
 MovePerson(367,10,3);
 DecPerson(367);
 AddPerson(135,35,22,2);
 MovePerson(135,8,2);
 talk( 135,"拜见丞相，不胜荣幸．我是荆州使者宋忠……",
 19,"废话少说，有话快讲！",
 135,"是、是．我们荆州无意与丞相作对．",
 69,"什么？",
 135,"我们荆州向丞相投降，襄阳城拱手相送．",
 9,"唉，是吗．呀，使者辛苦了．回去告诉他们，送给我曹操的东西，我当然要收下了．",
 135,"是，是．那么我告辞了．");
 MovePerson(135,10,3);
 DecPerson(135);
 talk( 77,"主公，荆州比预想的还要容易就得到啦．",
 78,"剩下的就是歼灭现在还在反抗丞相的刘备，一歼灭刘备，就只有东吴了．",
 9,"唉，出征前听到了一个好消息．好，全军出征！");
 NextEvent();
 end,
 [361]=function()
 JY.Smap={};
 JY.Base["现在地"]="新野";
 JY.Base["道具屋"]=13;
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(3,20,9,1);
 AddPerson(64,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(114,9,15,0);
 AddPerson(128,7,14,0);
 AddPerson(365,-4,3,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("新野议事厅");
 MovePerson(365,7,3);
 talk( 365,"向您禀报一件事．就在刚才，刘表去世了．",
 114,"什么？刘表去世了！",
 126,"那么，刘表的遗嘱是什么？",
 365,"刘表在遗嘱中指定刘琮是继承人，不是长子刘琦．",
 1,"什么？怎么如此糊涂！为什么不是刘琦？",
 365,"这个我就……．那么，我告辞了．");
 MovePerson(365,7,2);
 DecPerson(365);
 AddPerson(2,-4,3,3);
 AddPerson(135,-2,4,3);
 MovePerson( 2,3,3,
 135,3,3);
 talk( 2,"快走！",
 135,"是，请饶我一命吧．");
 MovePerson( 2,4,3,
 135,4,3);
 talk( 2,"兄长，从军师那儿听说曹操马上要攻过来，我就出去巡视，发现这个家伙有些可疑．审问一下吧．");
 MovePerson( 2,3,0);
 MovePerson( 2,3,3);
 MovePerson( 2,0,1);
 --示任务目标:<与诸葛亮等讨论今后怎么办>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [362]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"我出去巡视时，发现这个家伙有些可疑．审问一下吧．说什么他是荆州的使者．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"是荆州的使者？去哪里？是什么事？");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"这个叫宋忠的家伙是关羽捉来的．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"是荆州的使者吗？你的事情我大概猜到了．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"审问这个家伙吧．");
 end
 if JY.Tid==128 then--关平
 talk( 128,"审问这个家伙吧．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"审问这个家伙吧．");
 end
 if JY.Tid==135 then--宋忠
 talk( 135,"请、请饶命．",
 1,"你是荆州那边的？",
 135,"是、是．",
 2,"你作为使者去了哪里？",
 135,"去、去了曹操那里．",
 3,"曹操那里？荆州跟曹操有什么事情？",
 135,"其、其实刘表已经去世了，刘琮继承了父业．",
 1,"这刚才我已经知道了．可是为什么不是刘琦？一般都是长子是继承人．",
 135,"遗嘱是这样写的，所以蔡瑁就这样办了．",
 2,"蔡瑁？真奇怪啊！接着呢？",
 135,"接着就得到情报说曹操攻来了，群臣商量的结果……．",
 54,"结果怎么样？怎么会……．",
 135,"向曹操投降．");
 NextEvent();
 end
 end,
 [363]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"现在刻不容缓，最坏的情况是我们会受到曹操和蔡瑁的两面夹击．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，去拿下襄阳吧．刘表也死了，也没有什么可介意的事了．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"这是一件大事，再不采取紧急措施，就无可挽回了．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公，此时不能再讲体统了，要马上夺取襄阳，在襄阳抗拒曹操这才是上策．",
 1,"可是……，刘表那么关照我们，现在去打他的儿子……．孔明现在我们放弃新野，逃到刘琦管辖的江夏去，你看怎么样？",
 126,"那样还会受到曹操追赶．还不如夺取襄阳．嗯？主公，有快使来了．");
 AddPerson(365,-4,3,3);
 MovePerson( 365,10,3);
 talk( 365,"主公，有急事禀报！");
 NextEvent();
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"主公，怎么办？");
 end
 if JY.Tid==128 then--关平
 talk( 128,"主公，怎么办？");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"为什么是刘琮继位而不是刘琦？对啦，是蔡瑁搞的鬼！");
 end
 if JY.Tid==135 then--宋忠
 talk( 135,"我、我只是被迫的．");
 end
 end,
 [364]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，请听使者禀报．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，听使者讲吧．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"主公，请听使者禀报．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"先听使者禀报．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"主公，请听使者禀报．");
 end
 if JY.Tid==128 then--关平
 talk( 128,"主公，请听使者禀报．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"刘皇叔，这一定是蔡瑁搞的鬼，蔡瑁必遭天诛地灭．");
 end
 if JY.Tid==135 then--宋忠
 talk( 135,"我、我只是被迫的．");
 end
 if JY.Tid==365 then--使者
 PlayBGM(11);
 talk( 365,"禀报主公，曹操军已到博望坡．",
 54,"什么？已来到了那里？",
 126,"不管去哪里，大家都得准备啦．");
 talk( 126,"关羽和伊籍先去江夏一步，请求刘琦支援．",
 2,"明白了，我们马上就去江夏．",
 114,"关将军，我们马上走吧．");
 MovePerson( 2,3,2,
 114,2,2);
 MovePerson( 2,2,1,
 114,2,0);
 MovePerson( 2,10,2,
 114,10,2);
 DecPerson(2);
 DecPerson(114);
 ModifyForce(2,0);
 ModifyForce(114,0);
 talk( 126,"其他人快做出发准备．");
 MovePerson(365,10,2);
 DecPerson(365);
 MovePerson( 64,1,2,
 128,1,2,
 3,1,2,
 54,2,2);
 MovePerson( 64,1,1,
 128,1,0,
 3,1,2,
 54,1,2);
 MovePerson( 64,1,1,
 128,1,0,
 3,1,1,
 54,1,0);
 MovePerson( 64,1,2,
 128,1,2,
 3,1,1,
 54,1,0);
 MovePerson( 64,10,2,
 128,10,2,
 3,10,2,
 54,10,2);
 DecPerson(64);
 DecPerson(128);
 DecPerson(3);
 DecPerson(54);
 talk( 126,"那么主公也做出发准备吧．准备好的话告诉我一声．");
 --显示任务目标:<做迎战曹操的准备>
 NextEvent();
 end
 end,
 [365]=function()
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 126,"被曹操追赶上就不好办了，快出发……嗯？");
 JY.Smap={};
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(359,5,5,3);
 AddPerson(371,3,6,3);
 AddPerson(353,1,7,3);
 AddPerson(357,7,6,3);
 AddPerson(355,5,7,3);
 AddPerson(363,3,8,3);
 SetSceneID(54);
 talk( 355,"刘皇叔，也带我们一起走吧．",
 1,"什么？今后我们也许要和曹操打仗啊．",
 355,"我们知道．可是与其被曹操凌辱，还不如跟随刘皇叔，皇叔求您了．",
 1,"……好吧，跟着去吧．你告诉其他人，我带你们一起走．",
 126,"……！",
 355,"啊，谢谢．那么我马上去告诉大家！");
 MovePerson( 357,6,2,
 355,6,2,
 363,6,2,
 359,6,2,
 371,6,2,
 353,6,2);
 talk( 126,"主公，今后我们必须摆脱曹操军的追击，若带着百姓，那样会妨碍我们行军打仗的．",
 1,"孔明，他们都仰慕我．我不能对他们弃而不管．",
 126,"好吧，那就带百姓们一起走吧．");
 JY.Smap={};
 SetSceneID(0,3);
 talk( 126,"我们进军襄阳还是江夏，请主公决定．");
 local menu={
 {"　去襄阳",nil,1},
 {"　去江夏",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 SetSceneID(0);
 talk( 126,"请列队．");
 WarIni();
 DefineWarMap(24,"第二章 襄阳I之战","一、蔡瑁被杀．",20,0,112);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,9,22, 2,0,-1,0,
 -1,8,22, 2,0,-1,0,
 -1,10,22, 2,0,-1,0,
 -1,8,21, 2,0,-1,0,
 -1,10,21, 2,0,-1,0,
 -1,7,22, 2,0,-1,0,
 -1,12,22, 2,0,-1,0,
 -1,11,21, 2,0,-1,0,
 -1,7,20, 2,0,-1,0,
 -1,7,23, 2,0,-1,0,
 -1,9,20, 2,0,-1,0,
 -1,10,20, 2,0,-1,0,
 344,6,23, 2,0,-1,0,
 345,9,23, 2,0,-1,0,
 346,11,23, 2,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 112,18,4, 1,2,31,2, 0,0,-1,0,
 121,14,9, 3,2,28,8, 0,0,-1,0,
 122,17,5, 1,0,27,8, 0,0,-1,0,
 119,17,6, 3,0,28,5, 0,0,-1,0,
 130,12,14, 1,2,28,2, 0,0,-1,0,
 133,15,8, 3,0,27,13, 0,0,-1,0,
 256,11,4, 1,4,24,2, 9,8,-1,0,
 257,10,14, 1,2,24,2, 0,0,-1,0,
 258,11,14, 1,2,23,2, 0,0,-1,0,
 274,15,10, 3,0,24,5, 0,0,-1,0,
 275,10,4, 1,4,24,5, 8,8,-1,0,
 276,9,14, 1,2,24,5, 0,0,-1,0,
 126,3,17, 4,2,27,8, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent(); --goto 366
 elseif r==2 then
 SetSceneID(0,11);
 talk( 9,"不要让刘备逃走！一定捉住他！");
 SetSceneID(0);
 talk( 1,"孔明，我们好像被曹操追上了．",
 126,"没办法．那就在这里抵抗曹操吧，请列队．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(370); --goto 370
 end
 end
 end
 if JY.Tid==135 then--宋忠
 talk( 135,"我要一直留在这里吗？");
 end
 end,
 [366]=function()
 PlayBGM(11);
 talk( 113,"好吧，不要出城，赢得时间．反正刘备不能在这儿长待的．",
 126,"主公，此战必须尽快结束，如果来不及，就迅速退往江夏吧．");
 WarShowTarget(true);
 PlayBGM(17);
 NextEvent();
 end,
 [367]=function()
 if WarMeet(54,131) then
 WarAction(1,54,131);
 talk( 54,"你们为什么投降曹操？",
 131,"与你们无关．与曹操对抗就不能活，所以我们投降．",
 54,"这话不对．",
 131,"少罗嗦！你们这些混蛋！想夺荆州，找死！");
 WarAction(6,54,131);
 if fight(54,131)==1 then
 talk( 131,"厉、厉害……．",
 54,"拿命来！");
 WarAction(8,54,131);
 talk( 131,"唉呦……！");
 WarAction(17,131);
 WarLvUp(GetWarID(54));
 else
 WarAction(4,131,54);
 talk( 54,"厉害……．");
 WarAction(17,54);
 WarLvUp(GetWarID(131));
 end
 end
 if (not GetFlag(1033)) and War.Turn==15 then
 PlayBGM(11);
 talk( 126,"主公，刚才探子来急报，说曹操军已到新野．我们在这里再打下去的话，有受到前后夹击的危险．现在应马上撤往江夏．",
 1,"好吧，去江夏！");
 SetFlag(1033,1);
 NextEvent();
 end
 if (not GetFlag(1034)) and War.Turn==3 then
 local wid=GetWarID(127);
 War.Person[wid].enemy=false;
 War.Person[wid].friend=true;
 War.Person[wid].pic=WarGetPic(wid);
 WarShowArmy(127-1);
 DrawStrBoxCenter("魏延出现．")
 talk( 127,"蔡瑁卖国之贼！刘使君救民而来，何得相拒！",
 127,"皇叔快快领兵入城，共杀卖国之贼！",
 3,"大哥！杀进去吧！");
 talk( 122,"大胆魏延，安敢造乱！认得我大将文聘么！");
 WarModifyAI(127-1,3,122-1);
 SetFlag(1034,1);
 end
 WarLocationItem(3,10,55,152); --获得道具:获得道具：茶
 WarLocationItem(8,5,153,153); --获得道具:获得道具：猛火书 改为 153筒袖铠
 WarLocationItem(3,16,10,154); --获得道具:获得道具：倚天剑
 if JY.Status==GAME_WARWIN then
 talk( 113,"刘备，荆州是不会交给你们的……．");
 PlayBGM(7);
 DrawMulitStrBox("杀死了蔡瑁，刘备军打败了蔡瑁军．");
 GetMoney(900);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金９００！");
 WarGetExp();
 talk( 126,"主公，虽杀了蔡瑁，但襄阳城已被烧得面目全非，如果曹操军杀到此城是守不住的我们去江夏吧．",
 1,"好吧，全军，去江夏！");
 NextEvent();
 end
 end,
 [368]=function()
 PlayBGM(11);
 DrawMulitStrBox("刘备撤往江夏．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [369]=function()
 SetSceneID(0);
 talk( 1,"去江夏吧．");
 --储存进度:战场存盘
 SetSceneID(0);
 talk( 9,"不要让刘备逃掉！");
 talk( 1,"孔明，我们好像快被曹操追上了．",
 126,"没办法，那么我们抵挡曹操吧．请列好队．");
 NextEvent();
 end,
 [370]=function()
 WarIni();
 DefineWarMap(25,"第二章 长阪坡I之战","一、曹操的退兵．*二、民众逃至东南村．",70,0,8);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,21,13, 4,0,-1,0,
 125,21,12, 4,0,-1,0,
 -1,15,12, 4,0,-1,0,
 -1,15,14, 4,0,-1,0,
 -1,16,11, 4,0,-1,0,
 -1,17,11, 4,0,-1,0,
 -1,16,15, 4,0,-1,0,
 -1,16,16, 4,0,-1,0,
 -1,19,11, 4,0,-1,0,
 -1,20,11, 4,0,-1,0,
 -1,19,15, 4,0,-1,0,
 -1,20,15, 4,0,-1,0,
 344,20,12, 4,0,-1,0,
 345,17,15, 4,0,-1,0,
 346,18,16, 4,0,-1,0,
 });
 ModifyForce(138,9);
 ModifyForce(139,9);
 ModifyForce(106,9);
 ModifyForce(122,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 8,3,3, 1,0,42,9, 0,0,-1,0,
 18,3,5, 1,3,32,2, 0,0,-1,0,
 115,8,12, 4,3,31,2, 344,0,-1,0,
 16,6,11, 4,1,32,9, 0,0,-1,0,
 17,7,12, 4,1,32,22, 0,0,-1,0,
 217,5,3, 1,3,32,8, 0,0,-1,0,
 79,5,8, 4,3,32,24, 0,0,-1,0,
 67,1,1, 1,1,32,8, 0,0,-1,0,
 140,2,2, 1,3,31,15, 345,0,-1,0,
 105,5,5, 1,3,31,8, 346,0,-1,0,
 135,4,2, 1,0,31,12, 0,0,-1,0,
 102,9,10, 4,3,31,22, 0,0,-1,0,
 137,6,6, 1,3,31,11, 345,0,-1,0,
 138,5,10, 4,3,31,5, 346,0,-1,0,
 
 19,7,10, 4,3,31,24, 344,0,-1,0,
 121,8,6, 1,1,31,8, 0,0,-1,0,
 292,6,9, 4,3,28,8, 0,0,-1,0,
 293,2,4, 1,0,28,8, 0,0,-1,0,
 294,8,8, 4,3,27,8, 0,0,-1,1,
 295,4,9, 4,1,28,8, 0,0,-1,1,
 296,6,7, 4,1,28,8, 0,0,-1,1,
 297,4,6, 1,1,27,8, 0,0,-1,1,
 310,18,4, 1,3,27,11, 344,0,-1,0,
 311,18,5, 1,3,26,11, 345,0,-1,0,
 312,17,6, 1,3,25,11, 346,0,-1,1,
 274,7,7, 4,3,28,5, 0,0,-1,1,
 275,5,4, 1,3,28,5, 345,0,-1,1,
 276,4,8, 4,1,27,5, 0,0,-1,1,
 
 386,3,4, 1,3,36,15, 8,0,-1,0, --典韦S
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [371]=function()
 PlayBGM(11);
 talk( 9,"哼，刘备，你已经走投无路了．全军向刘备军发动全面攻击．",
 126,"唉，百姓的脚力终究不如曹操军的精锐部队啊．",
 1,"可是这些百姓慕我而来，决不能弃而不顾．",
 126,"那么，让百姓逃生吧．桥对面有一村庄，让百姓去那里吧．");
 WarShowTarget(true);
 WarModifyAI(344,6,32,22);
 WarModifyAI(345,6,32,22);
 WarModifyAI(346,6,32,22);
 PlayBGM(10);
 NextEvent();
 end,
 [372]=function()
 if (not GetFlag(1035)) and War.Turn==3 then
 talk( 136,"可是，带老百姓一起走，刘备在想什么呢？",
 9,"正因为如此，这个家伙很受百姓的仰慕，不愧是雄才大略的人．但是，带百姓一起逃跑……，太愚蠢了．好！我们前进．");
 WarModifyAI(8,3,0);
 WarModifyAI(135,3,344);
 WarModifyAI(293,3,0);
 SetFlag(1035,1);
 end
 if WarCheckLocation(344,22,32) then
 PlayBGM(7);
 talk( 1,"哦，先把百姓带到村里去，曹操不会追来了吧？",
 126,"马上就要追来了，这只是我们摆脱曹操的一计，我们快去江夏吧．");
 WarGetExp();
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 if WarCheckLocation(345,22,32) then
 PlayBGM(7);
 talk( 1,"哦，先把百姓带到村里去，曹操不会追来了吧？",
 126,"马上就要追来了，这只是我们摆脱曹操的一计，我们快去江夏吧．");
 WarGetExp();
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 if WarCheckLocation(346,22,32) then
 PlayBGM(7);
 talk( 1,"哦，先把百姓带到村里去，曹操不会追来了吧？",
 126,"马上就要追来了，这只是我们摆脱曹操的一计，我们快去江夏吧．");
 WarGetExp();
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 talk( 9,"唉……，还追不上，不能让刘备逃掉！继续追！",
 1,"曹操退兵了吗？",
 126,"没有．还会马上追来的，这只是摆脱曹操的一个办法．我们快去江夏吧．");
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 end,
 [373]=function()
 WarIni2();
 DefineWarMap(26,"第二章 长阪坡II之战","一、曹操的退兵．*二、民众逃至西北桥上．",99,0,8);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm2(1,{
 0,25,17, 3,0,-1,0,
 125,26,15, 3,0,-1,0,
 -1,25,14, 3,0,-1,0,
 -1,27,16, 3,0,-1,0,
 -1,24,20, 3,0,-1,0,
 -1,24,15, 3,0,-1,0,
 -1,25,19, 3,0,-1,0,
 -1,26,13, 3,0,-1,0,
 -1,26,18, 3,0,-1,0,
 -1,25,18, 3,0,-1,0,
 -1,26,14, 3,0,-1,0,
 -1,27,14, 3,0,-1,0,
 344,25,16, 3,0,-1,0,
 345,24,16, 3,0,-1,0,
 346,24,18, 3,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 8,27,1, 1,0,42,9, 0,0,-1,0,
 18,24,1, 1,3,32,2, 0,0,-1,0,
 115,26,2, 1,0,31,2, 0,0,-1,0,
 16,29,1, 1,1,32,9, 0,0,-1,0,
 17,29,0, 1,1,32,22, 0,0,-1,0,
 217,33,2, 1,3,32,8, 0,0,-1,0,
 79,32,0, 1,3,32,24, 0,0,-1,0,
 67,31,1, 1,1,32,8, 0,0,-1,0,
 140,26,0, 1,0,31,15, 0,0,-1,0,
 105,32,3, 1,3,31,8, 346,0,-1,0,
 135,23,0, 1,3,31,12, 344,0,-1,0,
 102,24,0, 1,3,31,22, 0,0,-1,0,
 137,27,3, 1,3,31,11, 345,0,-1,0,
 138,25,3, 1,3,31,5, 346,0,-1,0,
 
 19,30,3, 1,3,31,24, 344,0,-1,0,
 121,28,1, 1,0,31,8, 0,0,-1,0,
 292,34,0, 1,3,30,8, 0,0,-1,0,
 293,33,0, 1,3,29,8, 0,0,-1,0,
 294,32,1, 1,3,28,8, 0,0,-1,1,
 295,31,2, 1,3,30,8, 344,0,-1,1,
 296,30,2, 1,3,29,8, 345,0,-1,1,
 297,28,0, 1,3,28,8, 346,0,-1,1,
 298,28,2, 1,1,30,7, 0,0,-1,0,
 299,25,1, 1,1,29,7, 0,0,-1,0,
 300,22,0, 1,1,28,7, 0,0,-1,1,
 274,29,3, 1,3,30,5, 0,0,-1,1,
 275,30,0, 1,3,29,5, 345,0,-1,1,
 276,29,2, 1,1,28,5, 0,0,-1,1,
 
 386,27,2, 1,3,36,15, 8,0,-1,0, --典韦S
 });
 NextEvent();
 end,
 [374]=function()
 PlayBGM(11);
 talk( 1,"再向前走一会就看到长江了，无论如何要把百姓带到渡口，到了那里就会有船的．");
 WarShowTarget(true);
 WarModifyAI(344,6,0,10);
 WarModifyAI(345,6,0,10);
 WarModifyAI(346,6,0,10);
 PlayBGM(16);
 NextEvent();
 end,
 [375]=function()
 if WarMeet(54,136) then
 WarAction(1,54,136);
 talk( 54,"那可是有名的武将，我赵云与你较量！",
 136,"妈的……！");
 WarAction(6,54,136);
 if fight(54,136)==1 then
 talk( 54,"杀！");
 WarAction(8,54,136);
 talk( 136,"啊！");
 WarAction(18,136);
 talk( 54,"唉，敌人拿的剑是……？寒光四射呀，我借用一下吧．");
 WarGetItem(GetWarID(54),11);
 --WarLvUp(GetWarID(54));
 else
 WarAction(4,136,54);
 talk( 54,"太厉害了！");
 WarAction(17,54);
 WarLvUp(GetWarID(136));
 end
 end
 if WarMeet(1,122) then
 WarAction(1,1,122);
 talk( 122,"刘备！你跑不了了！",
 1,"背主之贼，尚有何面目见人！",
 122,"…………");
 WarAction(16,122);
 end
 if (not GetFlag(155)) and WarCheckArea(-1,17,17,22,19) then
 talk( 116,"听说是百姓和他们搅合在一起……．真不愧是刘备军啊，相当能打啊．",
 9,"现在不是从容不迫品论人物的时候，只有一条路，追，快追．");
 WarModifyAI(8,3,0);
 WarModifyAI(115,3,344);
 WarModifyAI(140,3,345);
 WarModifyAI(121,1);
 SetFlag(155,1);
 end
 if WarCheckLocation(344,10,0) then
 PlayBGM(7);
 talk( 1,"好啦！终于逃出来了，到了这里曹操军没船就没法子追了．我们快乘船去江夏吧．");
 DrawMulitStrBox("刘备军摆脱了曹操军的追击．");
 GetMoney(900);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金９００！");
 WarGetExp();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if WarCheckLocation(345,10,0) then
 PlayBGM(7);
 talk( 1,"好啦！终于逃出来了，到了这里曹操军没船就没法子追了．我们快乘船去江夏吧．");
 DrawMulitStrBox("刘备军摆脱了曹操军的追击．");
 GetMoney(900);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金９００！");
 WarGetExp();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if WarCheckLocation(346,10,0) then
 PlayBGM(7);
 talk( 1,"好啦！终于逃出来了，到了这里曹操军没船就没法子追了．我们快乘船去江夏吧．");
 DrawMulitStrBox("刘备军摆脱了曹操军的追击．");
 GetMoney(900);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金９００！");
 WarGetExp();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 talk( 9,"唉，竟还会有这么强的力量啊，没办法．停止追击吧．");
 DrawMulitStrBox("刘备军摆脱了曹操军的追击．");
 GetMoney(900);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金９００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [376]=function()
 SetSceneID(0,3);
 NextEvent();
 --PlayBGM(5);
 --显示任务目标:<在议事厅讨论今后如何办．>
 end,
 [377]=function()
 JY.Smap={};
 JY.Base["现在地"]="江夏";
 JY.Base["道具屋"]=14;
 AddPerson(115,8,8,3);
 AddPerson(2,15,10,3);
 AddPerson(114,11,12,3);
 AddPerson(1,37,23,2);
 AddPerson(126,39,24,2);
 SetSceneID(53);
 DrawStrBoxCenter("江夏议事厅");
 MovePerson( 1,10,2,
 126,10,2);
 talk( 115,"你好！叔叔，恭喜你平安到达．");
 ModifyForce(2,1);
 ModifyForce(114,1);
 LvUp(2,2);
 LvUp(114,2); --剧本原本只有关羽lv+2，伊籍是没有的
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [378]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，恭喜你平安到达．没能派出援军，很抱歉．和刘琦公子，在这里迎接兄长的到来．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"请先见刘琦公子谈一谈．");
 end
 if JY.Tid==115 then--刘琦
 talk( 115,"长途跋涉到这里，一定很辛苦吧．暂时在这里谋求东山再起吧．",
 1,"刘琦，谢谢啦．",
 115,"哪里，想想你们以前对我的帮助，这点事算得了什么？嗯？是谁？");
 MovePerson(126,1,0);
 MovePerson(126,1,2);
 MovePerson( 126,0,3,
 1,0,3);
 AddPerson(367,39,24,2);
 MovePerson( 367,8,2);
 talk( 367,"打扰了，现在东吴派使者来吊唁，怎么办？",
 115,"什么，东吴派使者来吊唁？东吴与我一向不和，怎么会……，先叫使者进来吧．",
 367,"是！");
 MovePerson( 367,8,3);
 DecPerson(367);
 AddPerson(144,39,24,2);
 MovePerson( 144,8,2);
 talk( 144,"初次得见公子，我叫鲁肃．");
 NextEvent();
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"刘备啊，我在这里迎接你，到这里就安全了．");
 end
 end,
 [379]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"东吴使者此时来有什么事？");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公不用担心，这是东吴向主公探听曹操军情来了，我有一计．");
 end
 if JY.Tid==115 then--刘琦
 talk( 115,"现在说来吊唁有些奇怪，如果是吊丧，应该更早一点来．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"我们与东吴一向不和，现在为什么……．");
 end
 if JY.Tid==144 then--鲁肃
 talk( 1,"我是刘备．",
 144,"久闻皇叔大名，今有幸相见，实为欣慰．不过听说皇叔最近正与曹操会战，能否告诉我一些曹操军情？曹操实际上有多少兵力？");
 MovePerson( 126,1,3);
 talk( 126,"这个由我来回答吧．",
 144,"你是？",
 1,"这位是孔明．",
 144,"噢，你就是孔明啊．久仰先生大名，此次相见深感荣幸．对啦，这是个好机会，先生的哥哥又在东吴，你能不能去一次东吴？",
 126,"这也正是我所希望的．我将很快去东吴．",
 144,"谢谢．请你能尽快去．我告辞了．");
 MovePerson( 144,8,3);
 DecPerson(144);
 MovePerson(126,0,2);
 NextEvent();
 end
 end,
 [380]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"曹操发兵前来，吴国大概也很恐慌吧．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 1,"孔明你对鲁肃说了那样的话，难道你真的要去吗？",
 126,"请放心．从目前情况来看，能抗拒曹操的只有孙权．我去东吴，定叫孙权和曹操相争．",
 2,"可是我听说东吴有很多谋臣，万一军师有什么不测……．",
 126,"关羽，不必担心．主公，我一定说服孙权．那么告辞了．");
 MovePerson(126,10,3);
 DecPerson(126);
 MovePerson(1,0,2);
 talk( 115,"孔明先生真的不会有事吗？",
 1,"不知道．不过，孙权真被说服的话，我们才得以喘息，现在我们的未来大业也只有寄望孔明一试了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==115 then--刘琦
 talk( 115,"孔明可能有什么想法．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"孔明要去东吴，为他的性命担忧．");
 end
 end,
 [381]=function()
 JY.Smap={};
 SetSceneID(-1,8);
 LoadPic(16,1);
 DrawMulitStrBox("诸葛亮东渡吴国，来说服孙权．在吴国，主和派占了上风．但诸葛亮说服了吴国军师周瑜．吴国掌握军权的周瑜成了主战派，如此吴国的是战是和的态度便确定下来．");
 LoadPic(16,2);
 SetSceneID(0);
 LoadPic(31,1);
 --DrawMulitStrBox("曹操军和孙权军在赤壁对峙，曹操派周瑜的旧友蒋乾去算计周瑜，但被周瑜识破了．周瑜反过来给曹操设下圈套，利用苦肉计，成功地瞒过了曹操，于是设苦肉计挨打的黄盖火烧曹操军，曹操水军遭到了毁灭性的打击．另外使用火计，还留下了诸葛亮借东风的佳话．");
 DrawMulitStrBox("曹操军和孙权军在赤壁对峙，曹操派周瑜的旧友蒋乾去算计周瑜，但被周瑜识破了．");
 DrawMulitStrBox("周瑜反过来给曹操设下圈套，利用苦肉计，成功地瞒过了曹操，于是设苦肉计挨打的黄盖火烧曹操军，曹操水军遭到了毁灭性的打击．另外使用火计，还留下了诸葛亮借东风的佳话．");
 LoadPic(31,2);
 SetSceneID(0);
 LoadPic(17,1);
 DrawMulitStrBox("曹操受到了吴军顽强的追击，刘备军按诸葛亮的命令，在退路的要害处布兵穷追曹操．可是把守退路最后要害之处的关羽放走了曹操，曹操九死一生才脱身逃往荆州．曹操此战一败涂地，这就是所谓的赤壁之战．");
 LoadPic(17,2);
 NextEvent();
 end,
 [382]=function()
 JY.Smap={};
 SetSceneID(-1,0);
 JY.Base["章节名"]="第三章　荆州南部征服战";
 DrawStrBoxCenter("第三章　荆州南部征服战");
 JY.Base["现在地"]="襄阳";
 JY.Base["道具屋"]=13;
 AddPerson(9,25,9,1);
 AddPerson(69,25,15,2);
 AddPerson(19,23,16,2);
 AddPerson(17,21,17,2);
 AddPerson(78,14,9,3);
 AddPerson(77,12,10,3);
 AddPerson(20,10,11,3);
 SetSceneID(86,5);
 DrawStrBoxCenter("襄阳议事厅");
 talk( 9,"哎！可恨的刘备，可恨的孙权．这个耻辱一定要加倍奉还，一定要加倍奉还．",
 19,"主公，下一步怎么办！",
 9,"我先返回许昌．曹仁，任命你镇守江陵．你一定要死守江陵，明白了吗？",
 19,"遵命！",
 9,"夏侯惇，你去守襄阳城．",
 17,"遵命！");
 JY.Smap={};
 SetSceneID(0);
 LoadPic(18,1);
 DrawMulitStrBox("　曹操为了重振军队返回许昌．已经成为曹操领地的荆州，由曹仁，夏侯惇镇守．*　曹操离开后的荆州，成为刘备和孙权争夺的目标．");
 LoadPic(18,2);
 NextEvent();
 end,
 [383]=function()
 JY.Smap={};
 JY.Base["现在地"]="吴";
 JY.Base["道具屋"]=0;
 AddPerson(142,28,7,1);
 AddPerson(143,20,12,0);
 AddPerson(148,14,9,3);
 AddPerson(149,10,11,3);
 AddPerson(163,6,13,3);
 AddPerson(14,25,15,2);
 AddPerson(144,21,17,2);
 AddPerson(185,17,19,2);
 SetSceneID(92,11);
 DrawStrBoxCenter("吴宫殿");
 talk( 143,"曹操军在赤壁之战打了败仗，已经很疲惫了．而我军打了胜仗，士气高涨．",
 142,"是的．现在正好收取荆州．周瑜！命令你担任主帅进攻江陵！",
 143,"遵命！一定完成任务．");
 MovePerson(143,12,1);
 DrawMulitStrBox("　孙权命令周瑜攻克荆州，孙权夺取荆州的长年愿望即将实现．*　这以后，周瑜和曹仁在江陵展开了激烈的战斗．");
 NextEvent();
 end,
 [384]=function()
 JY.Smap={};
 JY.Base["现在地"]="江夏";
 JY.Base["道具屋"]=14;
 AddPerson(1,8,8,3);
 AddPerson(115,15,10,3);
 AddPerson(126,11,12,3);
 AddPerson(3,10,16,0);
 AddPerson(114,12,17,0);
 AddPerson(64,14,18,0);
 AddPerson(2,21,9,1);
 AddPerson(54,23,10,1);
 AddPerson(128,25,11,1);
 SetSceneID(53);
 DrawStrBoxCenter("江夏议事厅");
 DrawMulitStrBox("　这里是江夏的议事厅．得到情报，东吴周瑜正攻打曹仁镇守的江陵．*　江陵地处荆州中心，位于江夏的西南．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [385]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，听到了吗？周瑜正攻打江陵，而且曹操现在不在江陵．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"但是，曹操这种人不吃点苦不知天高地厚，给他点颜色，他就老实了．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"赤壁之战，我军与孙权军曾联手抗曹，以后也保持这种关系吧．");
 end
 if JY.Tid==115 then--刘琦
 talk( 115,"叔父，实在对不起．最近我身体有点不太好．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"刘琦最近身体不太好，不要紧吧．");
 end
 if JY.Tid==128 then--关平
 talk( 128,"赤壁之战，曹操的兵力也削弱了些吧．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"曹操不在，在下认为正是夺取荆州的良机．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公，周瑜乘赤壁大胜之势，正要把荆州夺到自己手里．",
 1,"嗯……",
 126,"荆州已经不是刘表的地盘了，是曹操所有．夺取荆州作根本，是与曹操、孙权抗衡的唯一途径．",
 1,"……",
 126,"单凭此一城，无论曹操和孙权，都能把我们消灭乾净，主公，请下决心吧！",
 1,"既然如此，夺取荆州！",
 126,"好，主公英明果决，那么，火速进攻江陵．请准备出征．");
 MovePerson(115,1,1);
 MovePerson(115,0,2);
 talk( 115,"叔父，我身体有点不舒服，这次请让我送您出征吧．",
 1,"好吧，贤侄，好生休养吧．",
 115,"是．如此，您多费心了．");
 MovePerson(115,12,3);
 DecPerson(115);
 talk( 126,"最近刘琦好像身体不行呀．",
 1,"嗯，但愿没什么事……",
 126,"真让人担心．主公，还是请做出征准备吧．");
 --显示任务目标:<进行攻打江陵的准备工作．>
 NextEvent();
 end
 end,
 [386]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，准备好了请告诉军师，不是告诉我．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，再这么愣着，周瑜就拿下江陵了．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"听说现在周瑜正与曹仁出城大战，江陵城正空虚，的确是好机会．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"刘琦最近身体不太好，不要紧吧．");
 end
 if JY.Tid==128 then--关平
 talk( 128,"赤壁之战，曹操的兵力也削弱了些吧．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"曹操不在，在下认为正是夺取荆州的良机．");
 end
 if JY.Tid==126 then--诸葛亮
 --原剧本此处有修改关羽阵营及等级，我挪到前面去了
 if talkYesNo( 126,"出发吧？") then
 RemindSave();
 PlayBGM(12);
 talk( 126,"请编组队伍．");
 WarIni();
 DefineWarMap(27,"第三章 江陵之战","一、陈矫的失败",30,0,142);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,1,6, 4,0,-1,0,
 -1,2,7, 4,0,-1,0,
 -1,2,5, 4,0,-1,0,
 -1,2,4, 4,0,-1,0,
 -1,3,6, 4,0,-1,0,
 -1,4,5, 4,0,-1,0,
 -1,0,5, 4,0,-1,0,
 -1,0,6, 4,0,-1,0,
 -1,0,8, 4,0,-1,0,
 });
 DrawSMap();
 talk( 126,"好吧，兵贵神速，马上出征．");
 JY.Smap={};
 SetSceneID(0,3);
 talk( 126,"好吧，向江陵进发，江陵在江夏的西南方向．");
 ModifyForce(256+1,9);
 ModifyForce(257+1,9);
 ModifyForce(274+1,9);
 ModifyForce(275+1,9);
 ModifyForce(276+1,9);
 ModifyForce(277+1,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 171,18,9, 3,2,33,3, 0,0,-1,0,
 170,14,9, 3,2,31,8, 0,0,-1,0,
 256,17,9, 3,0,27,2, 0,0,-1,0,
 257,16,11, 3,0,26,2, 0,0,-1,0,
 274,14,10, 3,0,27,5, 0,0,-1,0,
 275,18,7, 3,0,27,5, 0,0,-1,0,
 276,16,7, 3,0,26,5, 0,0,-1,0,
 277,19,8, 3,0,27,5, 0,0,-1,0,
 142,35,17, 3,0,37,16, 0,0,-1,1,
 161,33,15, 3,4,31,3, 24,9,-1,1,
 165,34,18, 3,4,31,3, 18,14,-1,1,
 164,31,17, 3,4,30,3, 18,14,-1,1,
 147,32,18, 3,4,34,14, 18,14,-1,1,
 162,30,18, 3,4,34,9, 12,9,-1,1,
 148,29,16, 3,4,34,20, 24,9,-1,1,
 166,28,19, 3,4,34,9, 24,9,-1,1,
 258,31,18, 3,4,27,2, 18,14,-1,1,
 259,33,17, 3,4,27,2, 14,9,-1,1,
 292,26,18, 3,4,29,8, 18,14,-1,1,
 293,28,18, 3,4,29,8, 12,9,-1,1,
 294,31,15, 3,4,28,8, 24,9,-1,1,
 295,32,16, 3,4,28,8, 24,9,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [387]=function()
 PlayBGM(11);
 talk( 172,"什么？刘备军来了，可是曹仁正和周瑜交战，要坚守等到曹仁回来．",
 126,"主公，曹仁正与周瑜交战，江陵就是一个空城．他们之间的战斗结束后，曹仁或周瑜，无论谁取胜都会来江陵．那样的话，就麻烦了．早点攻下城吧．");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [388]=function()
 if WarMeet(54,148) then
 WarAction(1,54,148);
 talk( 54,"这里已经归我们所有了，你们现在最好赶快回东吴．",
 148,"吵什么！忘记赤壁之恩了吗，看我宰了你！");
 WarAction(6,54,148);
 if fight(54,148)==1 then
 talk( 148,"大胆！来吧！",
 54,"你不是对手！");
 WarAction(5,54,148);
 talk( 148,"嘿嘿！",
 54,"有两下子！");
 WarAction(8,54,148);
 talk( 148,"没办法，打不过！");
 WarAction(16,148);
 WarLvUp(GetWarID(54));
 else
 talk( 148,"大胆！来吧！",
 54,"你不是对手！");
 WarAction(5,54,148);
 talk( 148,"嘿嘿！",
 54,"有两下子！");
 WarAction(9,54,148);
 talk( 54,"没办法，打不过！");
 WarAction(16,54);
 WarLvUp(GetWarID(148));
 end
 end
 if (not GetFlag(1036)) and War.Turn==3 then
 talk( 126,"主公，周瑜打败曹仁，正赶往这里，在周瑜到达这里之前，赶快攻下江陵．");
 SetFlag(1036,1);
 end
 if (not GetFlag(1037)) and War.Turn==6 then
 talk( 126,"主公，也许周瑜马上就会到达这里．如果在我军攻下江陵之前来到，就不好办了，赶快！");
 SetFlag(1037,1);
 end
 if (not GetFlag(1038)) and War.Turn==8 then
 PlayBGM(11);
 WarShowArmy(142);
 WarShowArmy(161);
 WarShowArmy(165);
 WarShowArmy(164);
 WarShowArmy(147);
 WarShowArmy(162);
 WarShowArmy(148);
 WarShowArmy(166);
 WarShowArmy(258);
 WarShowArmy(259);
 WarShowArmy(292);
 WarShowArmy(293);
 WarShowArmy(294);
 WarShowArmy(295);
 DrawStrBoxCenter("周瑜军出现！");
 talk( 1,"来不及了吧……",
 143,"何事？",
 148,"周瑜都督，刘备军正在攻打江陵．",
 143,"什么！想乘我们大战曹仁之机窃取空城，办不到！马上全军攻打刘备，不能把江陵交给刘备！！");
 PlayBGM(14);
 War.WarTarget="一、周瑜退却";
 WarShowTarget(false);
 SetFlag(1038,1);
 end
 if (not GetFlag(1039)) and War.Turn==10 then
 talk( 143,"刘备、孔明！尝尝我的厉害！前进！");
 WarModifyAI(142,1);
 WarModifyAI(161,1);
 WarModifyAI(165,1);
 WarModifyAI(164,1);
 WarModifyAI(147,1);
 WarModifyAI(148,1);
 WarModifyAI(166,1);
 WarModifyAI(258,1);
 WarModifyAI(259,1);
 WarModifyAI(294,1);
 WarModifyAI(292,1);
 WarModifyAI(295,1);
 SetFlag(1039,1);
 end
 if (not GetFlag(1040)) and War.Turn==12 then
 WarModifyAI(162,1);
 WarModifyAI(293,1);
 SetFlag(1040,1);
 end
 if (not GetFlag(1041)) and War.Turn==16 then
 talk( 143,"什么事？现在正忙着！说什么……兵粮……哦，只准备了和曹仁作战所需兵粮，嗯，知道了．撤退！但刘备、孔明，此事还没完！！");
 WarAction(16,143);
 talk( 1,"怎么了？周瑜撤退了．",
 126,"兵粮没有了吧？也许是与曹仁作战，兵粮已耗尽了吧．",
 1,"肯定是……那我们胜利了．",
 126,"正是，主公，恭喜您．");
 SetFlag(1041,1);
 NextEvent();
 end
 if JY.Death==172 then
 if not GetFlag(1038) then
 talk( 172,"哇！");
 DrawStrBoxCenter("　打败陈矫，刘备军占领江陵．");
 PlayBGM(11);
 WarShowArmy(142);
 WarShowArmy(161);
 WarShowArmy(165);
 WarShowArmy(164);
 WarShowArmy(147);
 WarShowArmy(162);
 WarShowArmy(148);
 WarShowArmy(166);
 WarShowArmy(258);
 WarShowArmy(259);
 WarShowArmy(292);
 WarShowArmy(293);
 WarShowArmy(294);
 WarShowArmy(295);
 DrawStrBoxCenter("周瑜出现！");
 talk( 143,"何事？",
 148,"周瑜都督，江陵已被刘备军占领了．",
 143,"什么！我们与曹仁交战时，他乘机窃取空城，太卑鄙了！我绝不放过他．",
 149,"都督，我军与曹仁交战，消耗甚大，不该再战了．我们回去再想对策吧．",
 143,"啊，真是后悔莫及．就照你所说，撤退！但是，刘备、孔明，你们等着瞧！");
 NextEvent();
 else
 talk( 172,"可恶！撤退……");
 SetFlag(214,1);
 end
 end
 WarLocationItem(17,19,17,199); --获得道具:获得道具：弓术指南书
 if JY.Status==GAME_WARWIN then
 talk( 143,"可恶！此仇必报！刘备、孔明小心了！");
 NextEvent();
 end
 end,
 [389]=function()
 PlayBGM(7);
 if GetFlag(1038) then
 if not GetFlag(214) then
 talk( 172,"连周瑜军都……刘备军……唉，撤退！");
 WarAction(16,172);
 end
 DrawStrBoxCenter("　周瑜军撤退了，刘备占领了江陵．");
 end
 GetMoney(1000);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１０００！");
 if not GetFlag(1038) then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [390]=function()
 SetSceneID(0,3);
 if GetFlag(1038) then
 talk( 126,"好吧，入城！");
 else
 talk( 126,"进入江陵吧．");
 end
 ModifyForce(256+1,0);
 ModifyForce(257+1,0);
 ModifyForce(274+1,0);
 ModifyForce(275+1,0);
 ModifyForce(276+1,0);
 ModifyForce(277+1,0);
 NextEvent();
 --显示任务目标:<在江陵谈论今后之事．>
 end,
 [391]=function()
 JY.Smap={};
 JY.Base["现在地"]="吴";
 JY.Base["道具屋"]=0;
 AddPerson(142,28,7,1);
 AddPerson(143,20,12,0);
 AddPerson(148,14,9,3);
 AddPerson(149,10,11,3);
 AddPerson(163,6,13,3);
 AddPerson(14,25,15,2);
 AddPerson(144,21,17,2);
 AddPerson(146,17,19,2);
 SetSceneID(92,11);
 DrawStrBoxCenter("东吴宫殿");
 talk( 143,"实在对不起，被刘备窃取了空城似的江陵，我们也曾冒死争斗……",
 142,"哼，刘备这家伙，我们在赤壁替他打败曹操军，他连这大恩都忘了！",
 143,"此仇莫齿难忘，有朝一日，必将刘备宰了！！",
 142,"周瑜！",
 149,"都督！");
 MovePerson(149,3,3);
 MovePerson(149,1,0);
 talk( 149,"都督，伤势不要紧吧．现在还是养伤要紧．",
 142,"是啊，周瑜，无论如何得休养．",
 143,"让您挂心，真是……",
 149,"都督，这边请．");
 MovePerson( 149,12,1,
 143,12,1);
 talk( 142,"刘备这个家伙，把周瑜弄得如此狼狈，光想自己占便宜，办不到！这次我要亲率全军，进攻江陵，全体将士，准备出发！");
 MovePerson(144,3,2);
 MovePerson(144,1,0);
 talk( 144,"主公，且慢．",
 142,"有何事？鲁肃．",
 144,"周瑜都督新败，我军正士气低沉，起兵绝非上策．",
 142,"你说怎么办？",
 144,"我再去见一趟刘备，他对我东吴行无理之事，如果我说明此事，刘备或许会明白，无论如何，等我回来再采取行动．",
 142,"知道了，那，你赶快去见刘备．",
 144,"是！");
 MovePerson( 144,12,1);
 NextEvent();
 end,
 [392]=function()
 JY.Smap={};
 JY.Base["现在地"]="江陵";
 JY.Base["道具屋"]=15;
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(128,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(114,9,15,0);
 AddPerson(64,7,14,0);
 SetSceneID(54,5);
 DrawStrBoxCenter("江陵议事厅");
 DrawMulitStrBox("　刘备占领江陵后，也攻下了夏侯惇镇守的襄阳．自此，荆州北部尽归刘备所有．*　不久之后，东吴鲁肃来到江陵．");
 talk( 2,"兄长，东吴鲁肃前来拜见．");
 AddPerson(144,1,5,3);
 MovePerson(144,7,3);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [393]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"东吴鲁肃前来拜见．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"东吴的使者吗？哼，肯定是说客．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"江陵是我们的地方，好不容易才夺来的，再还回去，没有道理．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"为什么要把荆州给东吴，有必要吗？刘表有灵也会生气的．");
 end
 if JY.Tid==128 then--关平
 talk( 128,"东吴若想要这块地方，凭兵马来取呀！");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"听说东吴谋士极多，一定是他们出主意，要我们还荆州吧．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公，请放心．我有妙计．");
 end
 if JY.Tid==144 then--鲁肃
 talk( 144,"刘备公，这次的事，我们东吴无法理解．",
 1,"您说是……",
 144,"当然了，赤壁一战，是我军赶走了曹兵，付出了巨大代价，因此应该得到整个荆州．",
 126,"鲁肃大人，这样想可大错特错了．");
 MovePerson(126,1,2);
 MovePerson(144,1,1);
 MovePerson(144,1,3);
 talk( 144,"原来是孔明公，您认为我说的不对吗？",
 126,"这里既不是我们的土地，更不是你们东吴的，这里是刘琦的．",
 144,"啊？……",
 126,"这里原来归刘表所有，只是从曹操手里，替刘琦将它夺回来．",
 144,"可、可是，赤壁一战，我军就白费力了……",
 126,"好了好了．刘琦总是卧病，说不定会发生什么万一的情况，到那时，再将这里交给东吴．目前，就算我们向东吴借这里暂住吧．",
 144,"好吧，我向我主转达此意，先告退了．");
 MovePerson(144,10,2);
 DecPerson(144);
 MovePerson(126,0,3);
 NextEvent();
 end
 end,
 [394]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"不愧为军师，三言两语把鲁肃打发走了．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"哼，凭什么将这里交给吴狗．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"江陵是我们的地方，好不容易才夺来的，再还回去，没有道理．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"为什么要把荆州给东吴，有必要吗？刘表有灵也会生气的．");
 end
 if JY.Tid==128 then--关平
 talk( 128,"东吴若想要这块地方，凭兵马来取呀！");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"听说东吴谋士极多，一定是他们出主意，要逼还荆州吧．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公，荆州这里有个人才，把他请来吧．",
 1,"孔明，你说的是谁？",
 126,"此人名叫马良，听说一家人住在江夏，马家个个都非等闲．",
 1,"马良？现居江夏……",
 126,"是的，以主公之声望，他一定会来，主公，请去邀请马良吧．");
 --显示任务目标:<会见江夏马良．>
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [395]=function()
 JY.Smap={};
 JY.Base["现在地"]="江夏";
 JY.Base["道具屋"]=16;
 AddPerson(1,25,9,1);
 AddPerson(175,7,14,0);
 AddPerson(31,5,13,0);
 AddPerson(357,27,18,2);
 SetSceneID(71,5);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [396]=function()
 if JY.Tid==357 then--商人
 talk( 357,"马良？啊，是那个白眉人吧，他现在肯定在集会所．");
 end
 if JY.Tid==31 then--马谡
 talk( 31,"啊，我不是马良，而是他弟弟马谡．在我身边的才是马良．");
 end
 if JY.Tid==175 then--马良
 MovePerson(1,2,2);
 MovePerson(1,5,1);
 talk( 1,"对不起，请教尊姓大名？",
 175,"我吗？在下马良．",
 1,"噢，幸会幸会．多有冒犯，在下刘备．",
 175,"啊，您就是刘备？方才不知，多有得罪．",
 1,"哪里哪里．久闻大名，特来相会．望一定助我一臂之力．",
 175,"刘备大人相请，安敢拒绝，一定尽力．",
 1,"多谢．");
 ModifyForce(175,1);
 PlayWavE(11);
 DrawStrBoxCenter("马良成为部下．");
 talk( 175,"还有，没来得及介绍，旁边这人乃是马谡，我的弟弟，是个非常出色的年轻人．",
 31,"初次相见，在下马谡．",
 175,"马谡也想为您效力，不知尊意如何？");
 local menu={
 {" 带马谡走",nil,1},
 {"不带马谡走",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 1,"嗯，真是年轻有为．以后请你们二位多多出力了．",
 31,"您言重了．");
 ModifyForce(31,1);
 PlayWavE(11);
 DrawStrBoxCenter("马谡成为部下．");
 elseif r==2 then
 talk( 1,"呀，看来年纪尚轻，等长大些再用吧．",
 175,"如此……那，刘备大人……没什么，主公，走吧．",
 1,"嗯．");
 end
 MovePerson(175,0,2);
 talk( 175,"以后全靠你了，我就先往江陵去了．",
 31,"很遗憾．");
 MovePerson( 175,8,1,
 31,8,1);
 --显示任务目标:<返回江陵．>
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [397]=function()
 JY.Smap={};
 JY.Base["现在地"]="江陵";
 JY.Base["道具屋"]=15;
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(175,15,12,3);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(128,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(114,9,15,0);
 AddPerson(117,7,14,0);
 SetSceneID(54);
 talk( 2,"兄长，你回来了．");
 --显示任务目标:<商量今后．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [398]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，你回来了．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"这个叫马良的家伙，眉毛真白啊．年纪并不那么大，真有白眉毛的人啊？");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"文臣武将增多了，是件大好事．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"马良在这个地方是有名人物．兄弟都有才名，马良最佳．因马良眉毛是白的，所以人说马氏五常，白眉最良．其弟马谡也有才干．");
 end
 if JY.Tid==128 then--关平
 talk( 128,"据说马良熟悉本地情况，一定能提出好建议．");
 end
 if JY.Tid==117 then--刘封
 talk( 117,"主公，怎么办呢？");
 end
 if JY.Tid==175 then--马良
 talk( 175,"今后，请多关照．主公，荆州不光是江陵这块地方．",
 1,"怎么说？",
 175,"江陵南面的四郡是指零陵、武陵、桂阳、长沙．把它们变成自己的领土不好吗？",
 1,"嗯，从哪里进攻好呢？",
 175,"长沙有个叫黄忠的武将很难对付．先攻打零陵、武陵、桂阳，长沙放在最后再打为好．");
 MovePerson(126,0,3)
 talk( 126,"按马良所说，先攻打长沙以外的三个郡，最后攻打长沙．",
 1,"三个郡同时进攻吗？",
 126,"这好办！主公先率领一军，向零陵、武陵、桂阳的其中任何一个出征．张飞和赵云各自打一个郡，而江陵由关羽留守．",
 1,"那么，关羽、张飞、赵云和我分别行事．",
 126,"零陵、武陵、桂阳之中，请您挑选所要进攻的一个郡．");
 --显示任务目标:<做出征荆州南部的准备．>
 NextEvent();
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公，马良加入我们阵营了，太好了．");
 end
 end,
 [399]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，请让我守卫江陵．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，快决定下来．我想去打仗．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"主公，请从三个郡之中任选一个郡攻打．余下的郡由张飞和我分担．");
 end
 if JY.Tid==114 then--伊籍
 talk( 114,"马良在这个地方是有名人物．兄弟都有才名，马良最佳．因马良眉毛是白的，所以人说马氏五常，白眉最良．其弟马谡也有才干．");
 end
 if JY.Tid==128 then--关平
 talk( 128,"下次的战斗请一定派我去．");
 end
 if JY.Tid==117 then--刘封
 talk( 117,"下次的战斗请一定派我去．");
 end
 if JY.Tid==175 then--马良
 talk( 175,"如果依仗主公的威势，攻克四个郡是很容易的．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 126,"出发了．",
 3,"大哥，快决定攻打哪个郡．",
 54,"我们在主公之后出征．");
 ModifyForce(2,0);
 ModifyForce(3,0);
 ModifyForce(54,0);
 JY.Smap={};
 SetSceneID(0);
 PlayBGM(11);
 talk( 176,"据说刘备军要攻打零陵？嗯，怎么办……",
 181,"哼！刘备军是对抗曹操的一班愚蠢之徒．武陵不能交出！",
 179,"哈……我不能背叛曹操．可是，桂阳军也不能取胜．",
 183,"哼！长沙有黄忠在！只要有黄忠，就没有必要害怕刘备军．");
 PlayBGM(3);
 talk( 1,"这是荆州南部的四郡吗？",
 126,"是，马良已说过，长沙有个叫黄忠的豪杰．长沙放在最后再打．主公，攻打哪个？");
 local menu={
 {" 攻打武陵",nil,1},
 {" 攻打零陵",nil,1},
 {" 攻打桂阳",nil,1},
 }
 local r=ShowMenu(menu,3,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 126,"明白了，前往武陵．");
 SetSceneID(0);
 talk( 126,"请编组队伍．");
 PlayBGM(12);
 WarIni();
 DefineWarMap(30,"第三章 武陵之战","一、金旋的毁灭．*二、敌军投降．",35,0,180);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,7,18, 4,0,-1,0,
 -1,6,17, 4,0,-1,0,
 -1,5,17, 4,0,-1,0,
 -1,4,17, 4,0,-1,0,
 -1,4,16, 4,0,-1,0,
 -1,5,16, 4,0,-1,0,
 -1,6,16, 4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 180,28,4, 3,0,36,3, 0,0,-1,0,
 181,28,9, 3,2,31,6, 0,0,-1,0,
 232,15,13, 3,2,33,12, 0,0,-1,0,
 224,13,7, 3,2,32,6, 0,0,-1,0,
 274,9,11, 3,4,27,5, 14,13,-1,0,
 275,23,11, 3,0,27,5, 0,0,-1,0,
 276,27,7, 3,0,26,5, 0,0,-1,0,
 292,14,7, 3,0,29,8, 0,0,-1,0,
 293,16,14, 3,0,29,8, 0,0,-1,0,
 256,8,10, 3,4,27,2, 12,7,-1,0,
 257,23,7, 3,0,26,2, 0,0,-1,0,
 310,13,6, 3,0,27,11, 0,0,-1,0,
 311,16,13, 3,0,27,11, 0,0,-1,0,
 332,23,9, 3,0,27,14, 0,0,-1,0,
 333,28,7, 3,0,26,14, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent(400); --goto 400
 elseif r==2 then
 talk( 126,"明白了，前往零陵．");
 SetSceneID(0);
 talk( 126,"请编组队伍．");
 PlayBGM(12);
 WarIni();
 DefineWarMap(31,"第三章 零陵之战","一、刘度的毁灭．*二、敌军投降．",35,0,175);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,2,18, 4,0,-1,0,
 -1,1,17, 4,0,-1,0,
 -1,2,19, 4,0,-1,0,
 -1,1,18, 4,0,-1,0,
 -1,4,18, 4,0,-1,0,
 -1,3,17, 4,0,-1,0,
 -1,2,16, 4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 175,7,0, 1,2,35,3, 0,0,-1,0,
 176,5,0, 4,4,33,8, 8,1,-1,0,
 336,6,1, 4,4,26,15, 0,4,-1,0,
 292,9,3, 1,1,26,8, 0,0,-1,0,
 293,7,2, 1,4,26,8, 0,4,-1,0,
 294,10,1, 3,4,25,8, 8,0,-1,0,
 295,9,0, 3,1,25,8, 0,0,-1,0,
 274,8,2, 1,1,26,5, 0,0,-1,0,
 275,7,3, 1,4,26,5, 0,4,-1,0,
 276,9,1, 3,1,26,5, 0,0,-1,0,
 277,4,1, 4,4,26,5, 7,1,-1,0,
 177,15,15, 3,1,33,12, 0,0,-1,1,
 332,14,14, 3,1,30,14, 0,0,-1,1,
 333,14,13, 3,1,29,14, 0,0,-1,1,
 340,13,14, 3,1,28,17, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent(404); --goto 404
 elseif r==3 then
 talk( 126,"明白了，前往桂阳．");
 SetSceneID(0);
 talk( 126,"请编组队伍．");
 PlayBGM(12);
 WarIni();
 DefineWarMap(29,"第三章 桂阳之战","一、赵范的毁灭．*二、敌军投降．",35,0,178);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,12,22, 4,0,-1,0,
 -1,12,21, 4,0,-1,0,
 -1,13,23, 4,0,-1,0,
 -1,11,22, 4,0,-1,0,
 -1,11,20, 4,0,-1,0,
 -1,14,21, 4,0,-1,0,
 -1,13,20, 4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 178,11,1, 1,2,36,3, 0,0,-1,0,
 179,11,3, 1,0,33,8, 0,0,-1,0,
 151,16,9, 4,3,33,3, 0,0,-1,0,
 256,10,4, 1,0,27,2, 0,0,-1,0,
 257,8,5, 4,0,26,2, 0,0,-1,0,
 274,12,3, 1,0,27,5, 0,0,-1,0,
 275,8,7, 4,0,26,5, 0,0,-1,0,
 292,16,7, 4,1,29,8, 0,0,-1,0,
 293,14,9, 4,1,29,8, 0,0,-1,0,
 332,15,10, 4,1,27,14, 0,0,-1,0,
 333,8,9, 4,0,27,14, 0,0,-1,0,
 336,17,8, 4,1,27,15, 0,0,-1,0,
 337,10,3, 1,0,26,15, 0,0,-1,0,
 
 340,21,7, 3,1,30,17, 0,0,-1,1,
 341,22,8, 3,1,30,17, 0,0,-1,1,
 342,22,9, 3,1,29,17, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent(408); --goto 408
 end
 end
 end
 end,
 [400]=function()
 PlayBGM(11);
 talk( 182,"主公，听说刘备很得民心，为谋求领土安泰，我想应该投降了．",
 181,"你说什么！你这家伙和刘备勾结啊！",
 182,"不是．绝不是这样的．",
 181,"够了！我要战斗到底！！",
 126,"主公，敌人中有看见我军就丧失斗志的人．也可以巧妙地进行说服．");
 WarShowTarget(true);
 PlayBGM(17);
 NextEvent();
 end,
 [401]=function()
 if WarMeet(155,181) then
 WarAction(1,155,181);
 talk( 155,"那是敌人的头目吗？好，我要杀死他立功．",
 181,"那是什么？像是土匪．你以为像土匪那样的人能胜得了我吗？好，看看我的厉害！");
 WarAction(6,155,181);
 if fight(155,181)==1 then
 WarAction(8,155,181);
 talk( 181,"哎呀！",
 155,"打到了！杀死敌人的头目了！");
 WarAction(18,181);
 WarLvUp(GetWarID(155));
 DrawMulitStrBox("　周仓杀死了金旋．*　刘备军占领了武陵．");
 NextEvent();
 else
 WarAction(4,181,155);
 talk( 155,"哎呀！");
 WarAction(17,155);
 WarLvUp(GetWarID(181));
 end
 end
 if WarMeet(1,182) then
 WarAction(1,1,182);
 PlayBGM(11);
 talk( 182,"刘备，我以前是遵照金旋的命令行事的……这好像是我做错事．这个武陵应归刘备所有．请暂时等待一下．我去除掉这个害虫．");
 WarAction(16,182);
 talk( 181,"这、这个巩志！要干什么！喔！！");
 WarAction(18,181);
 talk( 182,"我杀死了金旋！我投降刘备！！");
 DrawStrBoxCenter("金旋被杀．刘备军占领了武陵．");
 NextEvent();
 SetFlag(137,1);
 end
 if WarMeet(-1,225) and (not GetFlag(141)) then
 talk( 225,"嗯……这是刘备军的实力……真厉害．吴祖！求你帮我！",
 233,"真没本事．好！全体，冲锋！！");
 WarModifyAI(232,1);
 WarModifyAI(224,1);
 WarModifyAI(274,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(256,1);
 WarModifyAI(310,1);
 WarModifyAI(311,1);
 SetFlag(141,1);
 end
 if WarMeet(-1,233) and (not GetFlag(141)) then
 talk( 233,"像你们这样的还想打我吗？哼！让你们后悔莫及！！",
 225,"必须援助吴祖．好！全体，冲锋！！");
 WarModifyAI(232,1);
 WarModifyAI(224,1);
 WarModifyAI(274,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(256,1);
 WarModifyAI(310,1);
 WarModifyAI(311,1);
 SetFlag(141,1);
 end
 if JY.Death==225 and (not GetFlag(141)) then
 talk( 225,"嗯……这是刘备军的实力吗？吴祖，以后的事靠你了！！",
 233,"简直是个无能的家伙．溜走了．全体，冲锋！！");
 WarModifyAI(232,1);
 WarModifyAI(224,1);
 WarModifyAI(274,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(256,1);
 WarModifyAI(310,1);
 WarModifyAI(311,1);
 SetFlag(141,1);
 end
 if JY.Death==233 and (not GetFlag(141)) then
 talk( 233,"我，我也打不过……走为上策，哎呀，不好！！",
 225,"吴祖被打死了！？他妈的！全体，冲锋！！");
 WarModifyAI(232,1);
 WarModifyAI(224,1);
 WarModifyAI(274,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(256,1);
 WarModifyAI(310,1);
 WarModifyAI(311,1);
 SetFlag(141,1);
 end
 if (not GetFlag(80)) and WarCheckLocation(-1,6,29) then
 GetMoney(500);
 PlayWavE(11);
 DrawStrBoxCenter("获得黄金５００！");
 SetFlag(80,1);
 end
 if JY.Status==GAME_WARWIN then
 DrawMulitStrBox("刘备军占领了武陵．");
 NextEvent();
 end
 WarLocationItem(3,20,70,81); --获得道具:获得道具：发石车(23)
 end,
 [402]=function()
 PlayBGM(7);
 GetMoney(1000);
 PlayWavE(11);
 DrawStrBoxCenter("获得黄金１０００！");
 if GetFlag(137) then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [403]=function()
 if GetFlag(137) then
 SetSceneID(0,3);
 talk( 182,"刘备，今后我跟随您．请多关照．");
 ModifyForce(182,1);
 PlayWavE(11);
 DrawStrBoxCenter("巩志成为部下．");
 end
 SetSceneID(0,3);
 talk( 3,"打进去了！攻陷了零陵！！",
 54,"攻克了桂阳！");
 SetSceneID(0,3);
 talk( 126,"主公，张飞攻下了零陵、赵云攻下了桂阳．*请一同回江陵，研究攻打长沙的计划．");
 NextEvent(412); --goto 412
 end,
 [404]=function()
 PlayBGM(11);
 talk( 176,"好像敌不过刘备．还是乘这个机会，乾脆投降刘备军算了……",
 177,"父亲，说什么呀！刘备之流，我去杀死他们给你看．",
 176,"嗯，但是……",
 126,"主公，敌人看见我军或许就丧失了战斗意志．也可以巧妙地去说服．");
 WarShowTarget(true);
 PlayBGM(17);
 NextEvent();
 end,
 [405]=function()
 if WarMeet(128,178) then
 WarAction(1,128,178);
 talk( 128,"曹操从荆州走了．如果立即投降，可留条性命．",
 178,"哈哈哈！想要零陵，就用你的实力夺取．还是害怕吧？！",
 128,"说什么！说的话别忘了！");
 WarAction(6,128,178);
 if fight(128,178)==1 then
 talk( 178,"什、什么！这么样可……",
 128,"看我最后一刀！");
 WarAction(8,128,178);
 talk( 178,"哎呀，我不行了．");
 WarAction(17,178);
 talk( 128,"哼，口出狂言的家伙．");
 WarLvUp(GetWarID(128));
 else
 WarAction(4,178,128);
 talk( 128,"哎呀，我不行了．");
 WarAction(17,128);
 WarLvUp(GetWarID(178));
 end
 end
 if (not GetFlag(1042)) and War.Turn==2 then
 WarModifyAI(293,1);
 WarModifyAI(275,1);
 WarModifyAI(336,1);
 SetFlag(1042,1);
 end
 if (not GetFlag(77)) and WarCheckArea(-1,5,0,10,12) then
 talk( 177,"邢道荣，该出征了．",
 1,"嗯？");
 WarShowArmy(177);
 WarShowArmy(332);
 WarShowArmy(333);
 WarShowArmy(340);
 DrawStrBoxCenter("敌人的另一路军出现了！");
 talk( 178,"好汉们！打死刘备这家伙．",
 177,"父亲！怎么样？我的战术如何？",
 176,"嗯……好极了……");
 SetFlag(77,1);
 end
 if WarMeet(1,176) then
 WarAction(1,1,176);
 talk( 1,"刘度，再打下去也不会有胜利的希望．怎么样，投降吧！",
 176,"是，知道了．这块领土奉送给你．");
 DrawMulitStrBox("刘度投降了．刘备军占领了零陵．");
 SetFlag(1043,1);
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 DrawMulitStrBox("刘备军占领了零陵．");
 NextEvent();
 end
 WarLocationItem(6,0,65,165); --获得道具:获得道具：援队书 改为 贼兵誓言
 end,
 [406]=function()
 PlayBGM(7);
 GetMoney(1000);
 PlayWavE(11);
 DrawStrBoxCenter("获得黄金１０００！");
 if GetFlag(1043) then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [407]=function()
 SetSceneID(0,3);
 talk( 3,"打进去了！武陵攻破了！",
 54,"攻克了桂阳！");
 SetSceneID(0,3);
 talk( 126,"主公，张飞攻下武陵、赵云拿下桂阳．*请一同回江陵，研究攻打长沙的计划．");
 NextEvent(412); --goto 412
 end,
 [408]=function()
 PlayBGM(11);
 talk( 179,"无论如何也敌不过刘备军，乾脆投降算了……",
 180,"主公，说什么！",
 152,"是的！刘备之流，我杀给你看！",
 179,"嗯……但是……",
 126,"主公，或许敌人看见了我军就丧失了斗志．也许经说服，可不战而胜．");
 WarShowTarget(true);
 PlayBGM(17);
 NextEvent();
 end,
 [409]=function()
 if WarMeet(117,152) then
 WarAction(1,117,152);
 talk( 117,"敌将在哪！刘封来挑战！",
 152,"混蛋．刘备军别自鸣得意！我来对付！");
 WarAction(6,117,152);
 if fight(117,152)==1 then
 talk( 152,"有空档！");
 WarAction(5,152,117);
 WarAction(8,117,152);
 talk( 152,"完了，完了……我完了……");
 WarAction(18,152);
 talk( 117,"好，杀死了敌将！");
 WarLvUp(GetWarID(117));
 else
 talk( 152,"有空档！");
 WarAction(4,152,117);
 talk( 117,"太厉害了！");
 WarAction(17,117);
 WarLvUp(GetWarID(152));
 end
 end
 if WarMeet(1,179) then
 WarAction(1,1,179);
 talk( 1,"赵范，再打下去，你也没有获胜的希望．怎么样，投降吧！",
 179,"是，明白了．这片领土奉送给你．");
 PlayBGM(7);
 DrawMulitStrBox("赵范投降了．刘备军占领了桂阳．");
 SetFlag(1043,1);
 NextEvent();
 end
 if (not GetFlag(142)) and WarCheckArea(-1,4,8,9,16) then
 PlayBGM(11);
 talk( 179,"嗯？那是？");
 WarShowArmy(340);
 WarShowArmy(341);
 WarShowArmy(342);
 WarModifyAI(333,1);
 WarModifyAI(275,1);
 WarModifyAI(256,1);
 WarModifyAI(257,1);
 DrawStrBoxCenter("异民族出现了！");
 talk( 180,"那是？主公！请求的援军来了．和他们通力合作，击退刘备！",
 179,"嗯．是啊……");
 PlayBGM(17);
 SetFlag(142,1);
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("刘备军占领了桂阳．");
 NextEvent();
 end
 WarLocationItem(7,4,67,166); --获得道具:获得道具：浊流书 改为 异文化印
 end,
 [410]=function()
 GetMoney(1000);
 PlayWavE(11);
 DrawStrBoxCenter("获得黄金１０００！");
 if GetFlag(1043) then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [411]=function()
 SetSceneID(0,3);
 talk( 3,"打进去了！攻破了武陵！",
 54,"攻陷了零陵！");
 SetSceneID(0,3);
 talk( 126,"主公，张飞攻下了武陵，赵云攻下了零陵，两个城都打下来了．那么，一同回江陵，研究攻打长沙的计划．");
 NextEvent(412) --goto 412
 end,
 [412]=function()
 JY.Smap={};
 JY.Base["现在地"]="江陵";
 JY.Base["道具屋"]=15;
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(128,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(175,9,15,0);
 AddPerson(117,7,14,0);
 ModifyForce(2,1);
 ModifyForce(3,1);
 ModifyForce(54,1);
 SetSceneID(54,5);
 talk( 175,"主公，占领了三个郡，真是可喜可贺．");
 --显示任务目标:<商量所剩长沙之事．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [413]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"主公，你回来了．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"我来打的话，攻下一个或两个城，如囊中取物．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"在新的领地，人民都敬仰主公的声望．");
 end
 if JY.Tid==128 then--关平
 talk( 128,"已经占领了三郡，可喜可贺．");
 end
 if JY.Tid==117 then--刘封
 talk( 117,"还剩下一个，一旦攻破长沙，荆州全境就成为我们的啦．");
 end
 if JY.Tid==175 then--马良
 talk( 175,"主公，占领了三郡，可喜可贺．",
 1,"嗯，后面只剩下长沙，此地如何攻打为好．",
 175,"是呀，把它放在最后，就是因为以前听说有个叫黄忠的武将，有百步穿杨之能，万夫不挡之勇．",
 1,"叫黄忠的吗？",
 175,"黄忠虽已年过六旬，但年轻人却都抵挡不过．",
 1,"嗯，真是这样吗？",
 126,"但是，攻克了此地，荆州全境将归主公所有．为今后着想，长沙不可不攻．",
 1,"嗯，是呀．出征！",
 126,"那么，请主公做出征准备．");
 --显示任务目标:<做出征长沙的准备．>
 NextEvent();
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"四个郡中，已占领了三郡，就只剩下长沙．");
 end
 end,
 [414]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，这次请交给我办．一定把黄忠活捉回来给你们看．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"关羽这家伙，让他留守好像委屈了他．有个请求，我也跟着去打．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"赶快出征吧！");
 end
 if JY.Tid==128 then--关平
 talk( 128,"主公，快出征吧！");
 end
 if JY.Tid==117 then--刘封
 talk( 117,"攻克长沙，荆州全境就是我们的．");
 end
 if JY.Tid==175 then--马良
 talk( 175,"你可千万要留神黄忠．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 126,"请编组队伍．");
 WarIni();
 DefineWarMap(32,"第三章 长沙之战","一、韩玄的毁灭．*二、敌军投降．",40,0,182);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,2,3, 4,0,-1,0,
 -1,3,3, 4,0,-1,0,
 -1,2,4, 4,0,-1,0,
 -1,3,2, 4,0,-1,0,
 -1,1,4, 4,0,-1,0,
 -1,1,2, 4,0,-1,0,
 -1,4,3, 4,0,-1,0,
 -1,3,4, 4,0,-1,0,
 -1,2,5, 4,0,-1,0,
 -1,5,3, 4,0,-1,0,
 -1,2,6, 4,0,-1,0,
 });
 DrawSMap();
 talk( 126,"出征长沙．");
 JY.Smap={};
 SetSceneID(0,11);
 talk( 183,"什么？三个郡陷落了？这些家伙太软弱了．我这里有黄忠．喂，黄忠！",
 170,"交给我办，一定不辜负你的期望．");
 SetSceneID(0,3);
 talk( 1,"好！再攻克了长沙，荆州全境将归我们所有！向长沙进发！");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 182,33,19, 2,2,38,2, 0,0,-1,0,
 183,18,9, 3,2,32,8, 0,0,-1,0,
 169,33,14, 3,0,33,22, 0,0,-1,0,
 126,33,17, 2,2,33,15, 0,0,-1,0,
 256,18,7, 3,2,32,3, 0,0,-1,0,
 257,34,13, 3,0,30,3, 0,0,-1,0,
 274,17,8, 3,2,32,6, 0,0,-1,0,
 275,27,7, 3,0,30,6, 0,0,-1,0,
 276,23,15, 3,0,30,6, 0,0,-1,0,
 277,24,14, 3,0,30,6, 0,0,-1,0,
 278,31,15, 3,0,32,21, 0,0,-1,0,
 292,27,9, 3,0,32,9, 0,0,-1,0,
 293,24,16, 3,0,32,9, 0,0,-1,0,
 294,22,16, 3,0,31,9, 0,0,-1,0,
 295,32,16, 3,0,31,9, 0,0,-1,0,
 336,28,8, 3,0,30,15, 0,0,-1,0,
 332,16,9, 3,2,30,14, 0,0,-1,0,
 310,28,6, 3,0,30,12, 0,0,-1,0,
 296,34,15, 3,0,30,9, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [415]=function()
 PlayBGM(11);
 talk( 183,"黄忠，刘备军究竟怎么样，你去打一仗看看．我在这里观察战况．",
 170,"是，交给我吧．我一定不辜负主公的期望．",
 127,"因为受过韩玄的照顾，所以不得不出征．可是……我不想与刘备战斗．黄忠为什么那么忠诚于韩玄呢？韩玄是个昏君，却……");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [416]=function()
 WarLocationItem(4,28,59,167); --获得道具:获得道具：英雄之剑
 WarLocationItem(17,20,19,168); --获得道具:获得道具：剑术指南书
 if (not GetFlag(143)) and WarCheckArea(-1,5,12,9,18) then
 talk( 1,"嗯？那个声音是什么？",
 184,"什么？河水溢出了……是水计？该死！为什么不对我说？");
 PlayWavE(53);
 WarFireWater(10,4,2);
 WarFireWater(12,4,2);
 WarFireWater(8,5,2);
 WarFireWater(10,5,2);
 WarFireWater(9,6,2);
 WarFireWater(9,7,2);
 WarFireWater(6,8,2);
 WarFireWater(8,8,2);
 WarFireWater(7,9,2);
 WarFireWater(8,9,2);
 WarFireWater(6,10,2);
 WarFireWater(5,11,2);
 WarFireWater(5,12,2);
 WarFireWater(10,7,2);
 WarFireWater(11,7,2);
 WarFireWater(12,7,2);
 WarFireWater(13,7,2);
 WarFireWater(14,7,2);
 WarFireWater(15,7,2);
 WarFireWater(16,7,2);
 WarFireWater(15,6,2);
 WarFireWater(17,6,2);
 WarFireWater(16,5,2);
 WarFireWater(17,5,2);
 WarFireWater(18,4,2);
 WarFireWater(15,8,2);
 WarFireWater(18,8,2);
 WarFireWater(17,9,2);
 WarFireWater(16,10,2);
 WarFireWater(15,11,2);
 WarFireWater(16,12,2);
 DrawStrBoxCenter("中了敌人的水计！");
 WarEnemyWeak(1,1);
 talk( 184,"我，我……韩玄，你这个……");
 WarAction(17,184);
 WarAction(17,257);
 WarAction(17,275);
 WarAction(17,333);
 talk( 1,"连自己部队的生死都不顾就……",
 183,"哈哈哈……刘备，你尝到苦头了吧！",
 127,"韩玄，这是怎么回事！连自己人都不管了吗？",
 183,"什么？我达到目的就行了，死几个人有什么？哈哈哈！");
 WarEnemyWeak(2,2);
 WarFireWater(10,4,3);
 WarFireWater(12,4,3);
 WarFireWater(8,5,3);
 WarFireWater(10,5,3);
 WarFireWater(9,6,3);
 WarFireWater(9,7,3);
 WarFireWater(6,8,3);
 WarFireWater(8,8,3);
 WarFireWater(7,9,3);
 WarFireWater(8,9,3);
 WarFireWater(6,10,3);
 WarFireWater(5,11,3);
 WarFireWater(5,12,3);
 WarFireWater(10,7,3);
 WarFireWater(11,7,3);
 WarFireWater(12,7,3);
 WarFireWater(13,7,3);
 WarFireWater(14,7,3);
 WarFireWater(15,7,3);
 WarFireWater(16,7,3);
 WarFireWater(15,6,3);
 WarFireWater(17,6,3);
 WarFireWater(16,5,3);
 WarFireWater(17,5,3);
 WarFireWater(18,4,3);
 WarFireWater(15,8,3);
 WarFireWater(18,8,3);
 WarFireWater(17,9,3);
 WarFireWater(16,10,3);
 WarFireWater(15,11,3);
 WarFireWater(16,12,3);
 SetFlag(143,1);
 end
 if (not GetFlag(144)) and WarCheckArea(-1,9,24,15,32) then
 talk( 127,"到底还是刘备军，真厉害……",
 183,"哎呀！敌军已经兵临城下了．我军在干什么？给我进攻！");
 WarModifyAI(336,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(294,1);
 WarModifyAI(275,1);
 WarModifyAI(276,1);
 WarModifyAI(277,1);
 WarModifyAI(310,1);
 SetFlag(144,1);
 end
 if WarMeet(1,127) then
 WarAction(1,1,127);
 talk( 127,"嗯？那是……太好了，刘备大人？",
 1,"呀？是谁？",
 127,"刘备大人，我原是刘表的部下，名叫魏延．我的事情以后再谈，现在我要去除掉藏在长沙的害人虫．再见！");
 WarMoveTo(127,33,18);
 WarAction(1,127,183);
 talk( 183,"什，什么？魏延，你这个叛徒！",
 127,"这不是背叛．这是愤怒的民众对你的所作所为的回报．去死吧！");
 WarAction(8,127,183);
 talk( 183,"啊！！");
 WarAction(18,183);
 talk( 126,"主公，敌人好像投降了．");
 PlayBGM(7);
 DrawMulitStrBox("　韩玄被杀．刘备军占领了长沙．");
 SetFlag(1044,1);
 NextEvent();
 end
 if WarMeet(2,170) then
 WarAction(1,2,170);
 talk( 2,"嗯，这个老头……不像等闲之辈．老头，报上名来！",
 170,"匹夫！你休得无礼！我乃黄忠是也！",
 2,"你就是黄忠？我关羽要与你单挑．",
 170,"嗯，你大概以为我老了就好欺负．年轻人，你打错算盘了．去死吧！");
 WarAction(6,2,170);
 if fight(2,170)==1 then
 talk( 2,"打！");
 WarAction(5,2,170);
 talk( 170,"哎呀！",
 2,"怎么？……战马失蹄了……",
 170,"真倒楣．这也是命吗？快杀了我吧！");
 WarAction(15,2);
 talk( 2,"……我且饶你性命．快去换马继续厮杀．",
 170,"什么？太感谢你了，那我去换马了．");
 WarAction(16,170);
 WarLvUp(GetWarID(2));
 talk( 183,"黄忠！你竟敢通敌！",
 170,"不要错怪我．我绝不是那种人．",
 183,"住口！我看见你与关羽单挑，关羽不杀你反而把你放了回来，这不是通敌的证据是什么？",
 170,"不．这……",
 183,"不听你辩解！快把这家伙的头砍下来！");
 WarMoveTo(127,33,18);
 WarAction(1,127,183);
 talk( 127,"韩玄！全然不记以前的功绩，要杀黄忠，这不是君子所为．我要替天行道惩罚你！",
 183,"啊，魏延！把魏延杀了！快来人呀！");
 WarAction(8,127,183);
 talk( 183,"啊……");
 WarAction(18,183);
 talk( 126,"主公，敌人好像投降了．");
 PlayBGM(7);
 DrawMulitStrBox("　韩玄被杀．刘备军占领了长沙．");
 NextEvent();
 else
 WarAction(4,170,2);
 talk( 170,"关羽休得猖狂，看我黄忠一箭！",
 2,"哎呀！");
 WarAction(17,2);
 WarLvUp(GetWarID(170));
 end
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("　刘备军占领了长沙．");
 NextEvent();
 end
 end,
 [417]=function()
 GetMoney(1000);
 PlayWavE(11);
 DrawStrBoxCenter("获得黄金１０００！");
 if GetFlag(1044) then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [418]=function()
 SetSceneID(0,3);
 talk( 126,"那就进长沙城吧．");
 NextEvent();
 end,
 [419]=function()
 JY.Smap={};
 JY.Base["现在地"]="长沙";
 JY.Base["道具屋"]=17;
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,11,16,0);
 AddPerson(127,15,12,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("长沙议事厅");
 talk( 127,"刘备主公，我叫魏延．");
 --显示任务目标:<和魏延谈话>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [420]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"黄忠尽管年老，但仍然武艺高强．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"没能和黄忠交手，真是件憾事．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公，怎么处置这个人？");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"残余的长沙军，向刘备大人投降了．从今以后，我也要为刘备效劳．",
 126,"主公，请等一下．");
 MovePerson(126,0,3);
 talk( 1,"孔明，怎么了？",
 126,"我不赞成收这个人为部下．",
 1,"为什么？",
 126,"这个人以前曾为刘表效力过．",
 127,"……是这样的．",
 126,"刘表一死投向韩玄，现在看见韩玄出现危机，就马上背叛旧主，改投主公，这样的人，不知什么时候就又会投靠别人？",
 1,"可是，孔明，如果拒绝了想投降我的人，今后就没有人向我投降了．不能这样做．",
 126,"……我明白了，那么您看着办吧．");
 MovePerson(126,0,2);
 talk( 1,"魏延，别放在心上，我会好好对待你，今后要好好工作．",
 127,"……是！是！");
 ModifyForce(127,1);
 PlayWavE(11);
 DrawStrBoxCenter("魏延成为部下！");
 talk( 1,"嗯……怎么，一直没见到黄忠？",
 127,"黄忠听说韩玄死讯后，一直待在家中，不出门见客．");
 --显示任务目标:<去官邸会见黄忠>
 NextEvent();
 end
 end,
 [421]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，去拜访黄忠吧．这样的人才可不多见．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==3 then--张飞
 talk( 3,"没能和黄忠交手，真是件憾事．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公既然有录用魏延的意思，我没有意见．");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"黄忠听说韩玄死讯后，一直待在家中，不出门见客．");
 end
 end,
 [422]=function()
 JY.Smap={};
 JY.Base["现在地"]="长沙";
 JY.Base["道具屋"]=17;
 AddPerson(1,5,10,3);
 AddPerson(170,21,12,1);
 SetSceneID(46,2);
 DrawStrBoxCenter("长沙黄忠家");
 talk( 170,"我不是说了吗，我谁也不见．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [423]=function()
 if JY.Tid==170 then--黄忠
 MovePerson(1,5,3);
 MovePerson(1,2,0);
 talk( 170,"我说过了，什么人都不想见．……啊，不像个佣人．",
 1,"突然拜访，我叫刘备．",
 170,"什么？是刘备大人吗？未曾远迎，失礼．",
 1,"黄忠，我很需要像你这样的豪杰．怎么样？加入我们军队吧．",
 170,"……我被处死也是应该的，您亲自来说……知道了，我黄忠愿意为您效劳．");
 ModifyForce(170,1);
 PlayWavE(11);
 DrawStrBoxCenter("黄忠成为部下！");
 talk( 1,"太好了．那就一起去江陵吧．",
 170,"是．");
 PlayBGM(8);
 DrawMulitStrBox("　如此南部四郡就被刘备调兵遣将全部平定了．荆州经过一番迂回曲折，终于成为刘备的领地．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [424]=function()
 SetSceneID(-1,0);
 JY.Base["章节名"]="第三章　荆州所有权的纠纷";
 DrawStrBoxCenter("第三章　荆州所有权的纠纷");
 LoadPic(19,1);
 DrawMulitStrBox("　刘备刚占领南部四郡不久，刘琦就病死了．刘琦的死是荆州的出借期限．*　当然，吴将要刘备归还荆州．但是，孔明说服吴的使者鲁肃接受荆州已从刘琦转由刘备继承的事实．");
 --DrawMulitStrBox("　这样下去荆州将弄不到手了．于是周瑜设下美人计，以孙权的妹妹诱骗刘备来吴假结婚，扣住刘备，索要荆州．可是，在孔明和赵云的策动下，这个计策以大失败而告终，刘备娶到了孙权之妹为妻．*　可是，吴和周瑜对荆州的野心还没有破灭．");
 DrawMulitStrBox("　这样下去荆州将弄不到手了．于是周瑜设下美人计，以孙权的妹妹诱骗刘备来吴假结婚，扣住刘备，索要荆州．可是，在孔明和赵云的策动下，这个计策以大失败而告终，刘备娶到了孙权之妹为妻．");
 DrawMulitStrBox("　可是，吴和周瑜对荆州的野心还没有破灭．");
 LoadPic(19,2);
 
 JY.Smap={};
 JY.Base["现在地"]="江陵";
 JY.Base["道具屋"]=15;
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(54,11,16,0);
 AddPerson(175,9,15,0);
 AddPerson(367,15,12,3);
 SetSceneID(54,5);
 DrawStrBoxCenter("江陵议事厅");
 talk( 126,"主公，你来得正好．有个部下前来报告情况．");
 --显示任务目标:<在议事厅商讨今后>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [425]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"听说鲁肃又来了．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"但是，吴也太纠缠不休了．好像还没有受够教训．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"真是．周瑜想荆州想得入迷了．");
 end
 if JY.Tid==175 then--马良
 talk( 175,"荆州的土地肥沃，人民众多．吴当然想得到了．");
 end
 if JY.Tid==367 then--文官
 talk( 367,"鲁肃从吴来了．怎么办？");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公，听说鲁肃来了．",
 1,"又是为荆州的事吧．这次的来意是什么？",
 126,"我有办法．鲁肃一提到荆州的事，主公您就哭．",
 1,"哭？光哭行吗？",
 126,"没问题．主公哭一会，到了不可收拾的时候，我有良策．");
 NextEvent();
 end
 end,
 [426]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"军师有什么良策吗？");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"让吴断了得到荆州的念头．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"请鲁肃来吧．");
 end
 if JY.Tid==175 then--马良
 talk( 175,"荆州的土地肥沃，人民众多．吴当然想得到了．");
 end
 if JY.Tid==367 then--文官
 talk( 1,"请鲁肃进来．",
 367,"是．");
 MovePerson(367,10,2);
 DecPerson(367);
 AddPerson(144,-5,2,3);
 MovePerson(144,10,3);
 talk( 144,"刘备大人，好久不见了．");
 NextEvent();
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"您只管哭就行了．那么请鲁肃进来．");
 end
 end,
 [427]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，请与鲁肃谈话．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，鲁肃等着您呢．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"主公，请与鲁肃谈谈吧．");
 end
 if JY.Tid==175 then--马良
 talk( 175,"主公，请与鲁肃谈谈吧．");
 end
 if JY.Tid==144 then--鲁肃
 talk( 1,"您这次来有何贵干？",
 144,"噢，这次来是受我主孙权的吩咐，专为荆州之事．出借荆州已经这么长时间了，该还给我们了吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"与鲁肃谈谈吧．");
 end
 end,
 [428]=function()
 local menu={
 {"　 忽视",nil,1},
 {" 假装不知",nil,1},
 {"　　哭",nil,1},
 }
 local r=ShowMenu(menu,3,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 1,"……",
 144,"刘备大人，事到如今，沈默也没用．");
 elseif r==2 then
 talk( 1,"您想说什么？",
 144,"事到如今，沈默也没用．刘备大人，请回答．");
 elseif r==3 then
 talk( 1,"呜呜呜……",
 144,"刘备大人，你怎么了？");
 NextEvent();
 end
 end,
 [429]=function()
 local menu={
 {"　 忽视",nil,1},
 {" 假装不知",nil,1},
 {"　　哭",nil,1},
 }
 local r=ShowMenu(menu,3,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 1,"……",
 144,"刘备大人，事到如今，沈默也没用．");
 NextEvent(428);
 elseif r==2 then
 talk( 1,"您想说什么？",
 144,"事到如今，沈默也没用．刘备大人，请回答．");
 NextEvent(428);
 elseif r==3 then
 talk( 1,"呜呜呜……",
 144,"刘，刘备大人？是哭了吗？刘备大人？");
 NextEvent();
 end
 end,
 [430]=function()
 local menu={
 {"　 忽视",nil,1},
 {" 假装不知",nil,1},
 {"　　哭",nil,1},
 }
 local r=ShowMenu(menu,3,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 1,"……",
 144,"……？什么呀，是装哭啊？你是说谎的骗子．");
 NextEvent(428);
 elseif r==2 then
 talk( 1,"嗯……今天的饭不错．",
 144,"刘备大人，你严肃些．");
 NextEvent(428);
 elseif r==3 then
 talk( 1,"呜呜呜……",
 144,"没办法．这可怎么办？");
 NextEvent();
 end
 end,
 [431]=function()
 local menu={
 {"　 忽视",nil,1},
 {" 假装不知",nil,1},
 {"　　哭",nil,1},
 }
 local r=ShowMenu(menu,3,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 1,"……",
 144,"……？什么呀，是装哭啊？你是说谎的骗子．");
 NextEvent(428);
 elseif r==2 then
 talk( 1,"嗯……．今天的饭不错．",
 144,"刘备大人，你严肃些．");
 NextEvent(428);
 elseif r==3 then
 talk( 1,"呜呜呜……",
 144,"刘备大人，您怎么了？为什么要哭？",
 126,"我来解释主公哭的原因．");
 MovePerson(126,1,2);
 MovePerson(126,1,0);
 MovePerson(126,1,2);
 talk( 144,"他为什么哭？",
 126,"主公本打算一得到益州，就把荆州还给你们．可是益州的刘璋是主公的同宗．进攻同宗对主公而言是痛苦的，因此就哭泣了．");
 talk( 1,"呜呜呜……",
 144,"……说得也是．刘备大人的心情我非常理解．那么，这个方案怎么样？",
 126,"什么方案？",
 144,"刘备大人不方便进攻刘璋，那我们去替你们拿下益州．只是……",
 126,"什么？",
 144,"要进攻益州必须通过江陵．因此希望你们同意我们吴军通过江陵．",
 126,"我明白了．如果你们替我们打益州，那当然可以通过江陵．我们随时欢迎．",
 144,"谢谢．我回去与主公商量一下．刘备大人，告辞了．");
 MovePerson(144,10,2);
 DecPerson(144);
 MovePerson(126,0,3);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [432]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"军师认为怎样？");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"我每回都想，军师怎么能猜中别人的心思呢？");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"军师神机妙算．");
 end
 if JY.Tid==175 then--马良
 talk( 175,"吴军替我们攻打益州，可信吗？");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 1,"军师，这件事你看怎样？",
 126,"这是周瑜的计策．",
 1,"周瑜的？",
 126,"是的．周瑜是想得到通过江陵的许可后，假装借道，一举攻占江陵．这是假道灭虢之计．",
 1,"要是这样该怎么办？",
 126,"这是个除掉周瑜的好机会．否则当我们攻打益州时，周瑜是个危险人物．主公，要做好出征准备．得到鲁肃的报告后，周瑜会很快出动的．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [433]=function()
 JY.Smap={};
 JY.Base["现在地"]="吴";
 JY.Base["道具屋"]=0;
 AddPerson(142,28,7,1);
 AddPerson(143,29,10,1);
 AddPerson(148,14,9,3);
 AddPerson(149,10,11,3);
 AddPerson(163,6,13,3);
 AddPerson(14,25,15,2);
 AddPerson(145,21,17,2);
 AddPerson(185,17,19,2);
 AddPerson(144,-4,24,0);
 SetSceneID(92,11);
 DrawStrBoxCenter("吴宫殿");
 MovePerson(144,11,0);
 talk( 144,"我鲁肃回来了．",
 142,"嗯．那结果呢？",
 144,"刘备说在没取得益州之前，不返还荆州．",
 142,"什么！刘备这小子，刘琦已经死了，怎么不遵守诺言？",
 144,"您生气是当然的．因此我对刘备说，周瑜都督愿通过江陵，替他取益州．",
 143,"嗯．那孔明怎么说的？",
 144,"孔明说，当然可以通过江陵．",
 143,"什么！孔明是这么说的！")
 MovePerson(143,1,1);
 MovePerson(143,1,2);
 MovePerson(143,2,1);
 talk( 143,"鲁肃，孔明真的允许咱们通过江陵吗？",
 144,"是，他确实是这么说的．",
 143,"太好了．这回骗过了孔明．",
 142,"怎么回事？我都糊涂了．")
 MovePerson(143,1,3);
 MovePerson(143,4,0);
 MovePerson(143,0,2);
 talk( 143,"噢，我还没对主公讲呢．是这样，……");
 DrawMulitStrBox("　周瑜的假道灭虢之计已经被诸葛亮识破．周瑜是想假称通过江陵取益州，趁刘备未防备之机，一举攻克江陵．");
 talk( 142,"原来如此．刘备、诸葛亮已经中计了，还是周瑜足智多谋啊．",
 143,"那在孔明察觉前，赶紧行动吧．",
 142,"那就全靠你了，周瑜．",
 143,"是．");
 
 JY.Smap={};
 SetSceneID(0);
 talk( 143,"快！不要给孔明思考的时间！");
 NextEvent();
 end,
 [434]=function()
 JY.Smap={};
 JY.Base["现在地"]="江陵";
 JY.Base["道具屋"]=15;
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(170,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(127,9,15,0);
 SetSceneID(54,12);
 DrawStrBoxCenter("江陵议事厅");
 DrawMulitStrBox("　然而，诸葛亮已经识破了周瑜的计谋，已经开始准备了．");
 MovePerson(126,0,3);
 talk( 126,"主公，准备好了．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [435]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"真要和周瑜决战了吗？我们一定要战胜他．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"和吴军战斗是一种乐趣．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"荆州不能让给周瑜．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"我虽然岁数大了，也绝不会输给年轻人．");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"这次战役请一定带我一起上阵．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公，周瑜理应已经出征了．已经派出了糜竺当使者，我们也准备吧．");
 AddPerson(65,-5,2,3);
 MovePerson(65,10,3);
 talk( 65,"主公，周瑜已经到达了公安．要求咱们去迎接．",
 3,"真没办法．去出迎．",
 126,"好吧．请作出征准备．");
 NextEvent();
 end
 end,
 [436]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"真要和周瑜决战了吗？我们一定要战胜他．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"和吴军战斗是一种乐趣．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"荆州不能让给周瑜．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"我虽然岁数大了，也绝不会输给年轻人．");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"这次战役请一定带我一起上阵．");
 end
 if JY.Tid==65 then--糜竺
 talk( 65,"主公，周瑜已经到达了公安．要求咱们去迎接．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"出征吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 126,"请编组部队．");
 WarIni();
 DefineWarMap(28,"第三章 公安之战","一、周瑜撤退．*二、占领四个鹿砦．",40,0,142);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,10,21, 4,0,-1,0,
 125,12,20, 4,0,-1,0,
 -1,12,21, 4,0,-1,0,
 -1,11,19, 4,0,-1,0,
 -1,11,22, 4,0,-1,0,
 -1,10,18, 4,0,-1,0,
 -1,10,20, 4,0,-1,0,
 -1,9,19, 4,0,-1,0,
 -1,9,21, 4,0,-1,0,
 -1,8,20, 4,0,-1,0,
 -1,10,23, 4,0,-1,0,
 -1,8,22, 4,0,-1,0,
 });
 DrawSMap();
 talk( 126,"主公，那么去公安迎接周瑜吧．");
 JY.Smap={};
 SetSceneID(0,3);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 142,36,10, 3,2,44,16, 0,0,-1,0,
 161,24,12, 3,2,38,3, 0,0,-1,0,
 165,26,14, 3,2,39,3, 0,0,-1,0,
 164,34,12, 3,2,38,3, 0,0,-1,0,
 147,32,13, 3,2,40,14, 0,0,-1,0,
 162,30,11, 3,2,40,9, 0,0,-1,0,
 148,25,13, 3,2,41,20, 0,0,-1,0,
 173,26,12, 3,2,40,25, 0,0,-1,0,
 292,28,11, 3,2,34,9, 0,0,-1,0,
 293,28,12, 3,2,35,9, 0,0,-1,0,
 294,33,12, 3,2,35,9, 0,0,-1,0,
 274,31,12, 3,2,34,6, 0,0,-1,0,
 
 275,25,11, 3,2,33,6, 0,0,-1,0,
 276,27,13, 3,2,33,6, 0,0,-1,0,
 277,33,10, 3,2,34,6, 0,0,-1,0,
 297,35,11, 3,2,35,9, 0,0,-1,0,
 332,32,11, 3,2,33,14, 0,0,-1,0,
 184,38,11, 3,1,40,6, 0,0,-1,1,
 166,37,11, 3,1,40,9, 0,0,-1,1,
 150,38,12, 3,1,41,16, 0,0,-1,1,
 295,37,9, 3,1,36,9, 0,0,-1,1,
 296,37,13, 3,1,36,9, 0,0,-1,1,
 278,36,12, 3,1,34,21, 0,0,-1,1,
 336,35,9, 3,1,34,15, 0,0,-1,1,
 340,39,11, 3,1,36,17, 0,0,-1,1,
 341,38,10, 3,1,36,17, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [437]=function()
 PlayBGM(11);
 talk( 143,"哼．你们看，刘备这个傻瓜来欢迎了．好不容易才骗过孔明．在刘备靠近之前，不许轻举妄动．但是一旦靠近就发动总攻击．明白了吗？",
 126,"主公，周瑜不会从正面进攻的．趁此机会，占领四周的鹿砦．正好前面有森林，以此为屏障，悄悄转移到鹿砦里．",
 1,"这么办好是好，可是为什么呢？",
 126,"周瑜自以为计谋得逞，以为咱们没有戒备．当他知道他的计谋早已被咱们识破时，他受到的震撼足以使他丧失斗志．",
 1,"我明白了，要占领四周的鹿砦．",
 126,"是的．但是我军的行动必须要做到不被发觉，否则如果被吴军发觉，行动就无意义了．所以到森林深处就不要前进了．");
 WarShowTarget(true);
 PlayBGM(14);
 NextEvent();
 end,
 [438]=function()
 WarLocationItem(7,21,3,200); --获得道具:获得道具：鼓吹具
 WarLocationItem(1,14,115,201); --获得道具:获得道具：海啸书 改为 115独脚旋风炮
 if WarMeet(2,149) then
 WarAction(1,2,149);
 talk( 2,"我是关羽关云长！谁能与我做对手？",
 149,"关羽！我吕蒙来也！",
 2,"你的胆子倒不小！看刀！");
 WarAction(6,2,149);
 if fight(2,149)==1 then
 talk( 2,"这家伙不容易对付……",
 149,"……看你以后还敢……",
 2,"看这刀！别发呆．");
 WarAction(4,2,149);
 talk( 149,"……打不过，不愧是关羽．关羽，以后再见分晓．");
 WarAction(16,149);
 talk( 2,"只有些小破绽，这家伙不太好对付．以后再见吧．");
 WarLvUp(GetWarID(2));
 else
 WarAction(4,149,2);
 talk( 2,"这家伙不容易对付……以后再见吧．");
 WarAction(16,2);
 WarLvUp(GetWarID(149));
 end
 end
 if not GetFlag(1045) then
 if WarCheckArea(-1,8,21,17,39) then
 PlayBGM(11);
 talk( 143,"哼！刘备军发动进攻了吗？孔明，到底让你识破了，咱们战场上见输赢！全军，向刘备军进攻！");
 WarShowArmy(184);
 WarShowArmy(166);
 WarShowArmy(150);
 WarShowArmy(295);
 WarShowArmy(296);
 WarShowArmy(278);
 WarShowArmy(336);
 WarShowArmy(340);
 WarShowArmy(341);
 DrawStrBoxCenter("敌人援军出现了！");
 talk( 185,"周瑜都督，我们来迟了．",
 143,"这不是孙瑜吗？来增援我吗？谢谢．",
 185,"我带援军赶来了，一同来打垮刘备，夺回荆州！");
 DrawStrBoxCenter("周瑜军转入攻势！");
 PlayBGM(14);
 WarModifyAI(142,3,125);
 WarModifyAI(161,3,0);
 WarModifyAI(165,3,0);
 WarModifyAI(164,3,125);
 WarModifyAI(147,3,125);
 WarModifyAI(162,3,125);
 WarModifyAI(148,1);
 WarModifyAI(173,1);
 WarModifyAI(292,3,0);
 WarModifyAI(293,1);
 WarModifyAI(294,3,125);
 WarModifyAI(297,1);
 WarModifyAI(274,3,125);
 WarModifyAI(275,3,0);
 WarModifyAI(276,1);
 WarModifyAI(277,3,125);
 WarModifyAI(332,1);
 War.WarTarget="一、周瑜撤退．";
 WarShowTarget(false);
 SetFlag(1045,1);
 end
 if (not GetFlag(1046)) and War.Turn==3 then
 talk( 126,"主公，据说以孙瑜为大将的敌方援军正向这里推进．这支援军一到，周瑜就准备进攻．形势对我军很不利，赶紧占领鹿砦！");
 SetFlag(1046,1);
 end
 if (not GetFlag(1047)) and War.Turn==8 then
 talk( 126,"敌人的行动相当的快．孙瑜很快就要赶到了，要赶紧行动！");
 SetFlag(1047,1);
 end
 if (not GetFlag(1048)) and War.Turn==12 then
 talk( 126,"孙瑜马上就要到了，主公，行动要快！");
 SetFlag(1048,1);
 end
 if (not GetFlag(1049)) and War.Turn==15 then
 PlayBGM(11);
 WarShowArmy(184);
 WarShowArmy(166);
 WarShowArmy(150);
 WarShowArmy(295);
 WarShowArmy(296);
 WarShowArmy(278);
 WarShowArmy(336);
 WarShowArmy(340);
 WarShowArmy(341);
 DrawStrBoxCenter("敌方援军出现了！");
 talk( 185,"周瑜都督，我们来迟了．",
 143,"这不是孙瑜吗？来增援我吗？谢谢．",
 185,"我带援军赶来了，一同来打垮刘备，夺回荆州！");
 DrawStrBoxCenter("周瑜军转入攻势！");
 PlayBGM(14);
 WarModifyAI(142,3,125);
 WarModifyAI(161,3,0);
 WarModifyAI(165,3,0);
 WarModifyAI(164,3,125);
 WarModifyAI(147,3,125);
 WarModifyAI(162,3,125);
 WarModifyAI(148,1);
 WarModifyAI(173,1);
 WarModifyAI(292,3,0);
 WarModifyAI(293,1);
 WarModifyAI(294,3,125);
 WarModifyAI(297,1);
 WarModifyAI(274,3,125);
 WarModifyAI(275,3,0);
 WarModifyAI(276,1);
 WarModifyAI(277,3,125);
 WarModifyAI(332,1);
 War.WarTarget="一、周瑜撤退．";
 WarShowTarget(false);
 SetFlag(1045,1);
 SetFlag(1049,1);
 end
 if (not GetFlag(34)) and WarCheckLocation(-1,1,25) then
 DrawStrBoxCenter("刘备军占领了西北鹿砦！");
 SetFlag(34,1);
 end
 if (not GetFlag(35)) and WarCheckLocation(-1,2,37) then
 DrawStrBoxCenter("刘备占领了东北鹿砦！");
 SetFlag(35,1);
 end
 if (not GetFlag(36)) and WarCheckLocation(-1,21,17) then
 DrawStrBoxCenter("刘备占领了西南鹿砦！");
 SetFlag(36,1);
 end
 if (not GetFlag(37)) and WarCheckLocation(-1,21,37) then
 DrawStrBoxCenter("刘备占领了东南鹿砦！");
 SetFlag(37,1);
 end
 if GetFlag(34) and GetFlag(35) and GetFlag(36) and GetFlag(37) then
 PlayBGM(12);
 talk( 126,"嗯．占领了全部鹿砦．那么，向各砦武将下命令，让他们大声叫喊．");
 talk( 143,"嗯？这是什么声音？",
 148,"周瑜都督，我们好像被包围了，四面都是喊声．怎么办？",
 143,"什么？！又是孔明识破了我的计策！哇……",
 148,"都督，你怎么啦？怎么，流血了……*都督，上次的伤口因激动而绽开了．",
 143,"不要管它，就这么点……",
 148,"都督，你这身体可不能再指挥了．撤退吧，君子报仇十年不晚．",
 143,"嗯……那么，甘宁，撤退的事就交给你了．哇……",
 148,"全军撤退！");
 WarAction(16,143);
 DrawMulitStrBox("　周瑜军撤退了．");
 NextEvent();
 end
 end
 if JY.Status==GAME_WARWIN then
 talk( 143,"孔明，刘备……你们……哇……",
 148,"都督！不要紧吧！",
 143,"可恨……撤……撤退……",
 148,"是！全军立即撤退！");
 DrawMulitStrBox("　周瑜军撤退了．");
 NextEvent();
 end
 end,
 [439]=function()
 PlayBGM(7);
 GetMoney(1100);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１１００！");
 if (not GetFlag(1045)) then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [440]=function()
 SetSceneID(0,3);
 talk( 126,"这下周瑜再也不敢挑衅了，那就回江陵吧．");
 NextEvent();
 end,
 [441]=function()
 JY.Smap={};
 JY.Base["现在地"]="江陵";
 JY.Base["道具屋"]=15;
 AddPerson(1,25,17,2);
 AddPerson(126,21,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(54,11,16,0);
 AddPerson(175,9,15,0);
 SetSceneID(54,5);
 talk( 126,"主公，周瑜死了．可喜可贺．");
 --显示任务目标:<商讨今后．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [442]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，这样荆州就完全是兄长的了．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"吴也会记取教训，暂时不敢来攻打吧．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"荆州就可放心了．");
 end
 if JY.Tid==175 then--马良
 talk( 175,"荆州就可放心了．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公，为了给周瑜最后一击，我已经给周瑜送信，这就会有结果的……来人了．");
 AddPerson(367,-5,2,3);
 MovePerson(367,10,3);
 talk( 367,"禀报主公．");
 NextEvent();
 end
 end,
 [443]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，请听一下报告．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"虽说把信送去了，可是结果会怎么样呢？我老想着这件事．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"周瑜在与曹仁交战时，肩部中箭受伤．据说箭伤还没痊癒．");
 end
 if JY.Tid==175 then--马良
 talk( 175,"暂且听一下报告．");
 end
 if JY.Tid==367 then--文官
 talk( 367,"刚才接到探子报告，说周瑜死了．");
 NextEvent();
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"请听一下结果如何．");
 end
 end,
 [444]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"周瑜虽是强敌，也不能战胜疾病．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"周瑜死了？要是这样，吴国暂时不会攻打来了．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"周瑜在与曹仁交战时，肩部中箭受伤．据说箭伤还没痊癒．");
 end
 if JY.Tid==175 then--马良
 talk( 175,"作为敌人，是个可怕的对手．和吴的关系将会怎样？");
 end
 if JY.Tid==367 then--文官
 talk( 367,"据说周瑜是大量出血死的．");
 end
 if JY.Tid==126 then--诸葛亮
 MovePerson(126,0,3);
 talk( 126,"这是预料之中的事．主公，我想去吴吊唁周瑜．",
 1,"啊．可是孔明，由于你的那封信，周瑜才死的．此行太危险了．吴国的武将都恨死你了．",
 126,"不会有事的．周瑜活着我都不怕，更何况他已经死了．只要赵云跟我去就行了．",
 1,"但是……",
 126,"这件事必须要办．现在还不能与吴争斗．周瑜虽对我们怀有恶意，可是他的继承人，我想是鲁肃，对我们没有恶意．应该利用这一点，保持与吴的关系，为此要赴吴国．",
 1,"是这样……",
 126,"另外我想利用这个机会，在吴国找寻人才．",
 1,"找寻人才？",
 126,"是的．现在世上肯定有人才．我想去寻找．",
 1,"……明白了．那孔明你要多保重．",
 126,"是．请主公在我回来前，也去寻访人才．赵云，咱们走．",
 54,"是．");
 MovePerson(126,2,2);
 MovePerson( 126,3,2,
 54,3,2);
 MovePerson( 126,2,2,
 54,2,0);
 MovePerson( 126,7,2,
 54,7,2);
 DecPerson(126);
 DecPerson(54);
 MovePerson(367,10,2);
 DecPerson(367);
 talk( 2,"兄长，那就按军师所说，我也去寻访人才．",
 175,"我也去．",
 1,"那就辛苦你们了．");
 MovePerson( 2,3,2,
 175,2,2);
 MovePerson( 2,2,1,
 175,2,0);
 MovePerson( 2,8,2,
 175,8,2);
 DecPerson(2);
 DecPerson(175);
 --显示任务目标:<在荆州寻找人才>
 NextEvent();
 end
 end,
 [445]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"找人才吧．不过大哥，人才在哪里？有目标吗？",
 1,"去寻访人才吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==1 then--刘备
 talk( 1,"去寻访人才吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [446]=function()
 local t=0;
 t=JY.Base["事件149"];
 JY.Smap={};
 SetSceneID(0);
 if t<4 then
 talk( 1,"去哪里寻访人才呢？");
 local menu={
 {" 寻访江陵",nil,1},
 {" 寻访襄阳",nil,1},
 {" 寻访江夏",nil,1},
 {" 寻访长沙",nil,1},
 {" 回议事厅",nil,1},
 }
 local r=ShowMenu(menu,5,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==5 then
 talk( 1,"时间不早了，回议事厅吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(449);
 else
 SetFlag(149,t+1);
 local T1={"江陵","襄阳","江夏","长沙"};
 local T2={15,18,16,17};
 local T3={377,380,402,400};
 local pid=0;
 local rnd=math.random(10);
 if rnd==10 then
 pid=T3[r];
 elseif rnd==3 or rnd==7 then
 pid=378;
 elseif rnd==1 or rnd==5 then
 pid=379;
 elseif rnd==2 then
 pid=399;
 elseif rnd==6 then
 pid=401;
 end
 SetFlag(150,pid);
 JY.Smap={};
 JY.Base["现在地"]=T1[r];
 JY.Base["道具屋"]=T2[r];
 AddPerson(1,25,9,1);
 if pid>0 then
 AddPerson(pid,9,17,0);
 end
 SetSceneID(71,5);
 DrawStrBoxCenter(T1[r]);
 JY.Status=GAME_SMAP_MANUAL;
 if pid==0 then
 talk( 1,"好像没有什么人才啊．");
 end
 NextEvent();
 end
 else
 talk( 1,"时间不早了，回议事厅吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(449);
 end
 end,
 [447]=function()
 local pid=JY.Base["事件150"];
 if pid>0 and JY.Tid==pid then--pid
 MovePerson(1,7,1);
 if JY.Person[pid]["君主"]==1 then
 talk( pid,"今后请多关照．过几天我要去江陵．");
 else
 talk( 1,"请问您尊姓大名？",
 pid,"您是问我吗？我叫"..JY.Person[pid]["姓名"].."．您是那位？",
 1,"我叫刘备．",
 pid,"哦，您就是刘备啊．真没想到是您，对不起．嗯，刘备大人，冒昧问一句，我能当您的部下吗？我多少是有用之人．");
 end
 NextEvent();
 end
 if JY.Tid==1 then--刘备
 if talkYesNo( 1,"离开"..JY.Base["现在地"].."吧？") then
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(446);
 end
 end
 end,
 [448]=function()
 local pid=JY.Base["事件150"];
 if pid>0 and JY.Tid==pid then--pid
 if JY.Person[pid]["君主"]==1 then
 talk( pid,"今后请多关照．过几天我要去江陵．");
 else
 talk( pid,"我能做您的部下吗？");
 if WarDrawStrBoxYesNo("要收留"..JY.Person[pid]["姓名"].."做部下吗？",C_WHITE,true) then
 talk( pid,"喔，那就谢谢了．今后请多关照．");
 ModifyForce(pid,1);
 PlayWavE(11);
 DrawStrBoxCenter(JY.Person[pid]["姓名"].."成为部下！");
 else
 talk( pid,"是吗？……");
 end
 end
 end
 if JY.Tid==1 then--刘备
 if talkYesNo( 1,"离开"..JY.Base["现在地"].."吧？") then
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(446);
 end
 end
 end,
 [449]=function()
 JY.Smap={};
 JY.Base["现在地"]="江陵";
 JY.Base["道具屋"]=15;
 AddPerson(1,25,17,2);
 AddPerson(3,22,10,1);
 AddPerson(64,11,16,0);
 SetSceneID(54,1);
 talk( 3,"大哥，有个叫庞统的来了．");
 AddPerson(133,-5,2,3);
 MovePerson(133,10,3);
 --显示任务目标:<让庞统成为部下>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [450]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"怎么，是个其貌不扬的家伙．他究竟来干什么？");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"主公，暂且和来客谈谈吧．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"初次见面，我叫庞统．",
 1,"您专程来到这里，辛苦了．今天有什么事吗？",
 133,"没什么事．我是来这里谋职的．",
 1,"（要说庞统应该是水镜先生所说的伏龙、凤雏两个人之一的凤雏……）",
 1,"（外貌可不像个奇才，是他吗？真是个能与孔明相提并论的经纶济世之才吗？）");
 NextEvent();
 end
 end,
 [451]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"怎么是个连话都不想回答的人，这家伙是真的了不起吗？");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"我想起来了，耒阳县的县令有个空缺．");
 NextEvent();
 end
 if JY.Tid==133 then--庞统
 talk( 133,"要是没什么职位我就先告辞了．",
 1,"请您等一下．");
 end
 end,
 [452]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"怎么是个连话都不想回答的人，这家伙是真的了不起吗？");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"耒阳县是个小村子，居民很少．");
 end
 if JY.Tid==133 then--庞统
 talk( 1,"耒阳县缺少一个县令，您愿意去那里吗？",
 133,"啊，是吗？知道了，那我就上任去了．");
 MovePerson(133,10,2);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [453]=function()
 JY.Smap={};
 JY.Base["现在地"]="江陵";
 JY.Base["道具屋"]=15;
 AddPerson(1,25,17,2);
 AddPerson(3,22,10,1);
 AddPerson(64,11,16,0);
 SetSceneID(54);
 DrawMulitStrBox("　这以后又过了些日子……");
 AddPerson(367,-5,2,3);
 MovePerson(367,10,3);
 talk( 367,"禀报主公，有百姓报告说，耒阳县县令不做事．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [454]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，这家伙果然是个腐儒，我去教训教训他．",
 1,"三弟，你性子太急，还是跟我一起去吧．",
 3,"那我先去耒阳县吧．");
 MovePerson(3,3,2);
 MovePerson(3,2,1);
 MovePerson(3,8,2);
 talk( 64,"那就视察去吧．");
 JY.Smap={};
 SetSceneID(0);
 talk( 64,"耒阳县位于这里的东北部．");
 --显示任务目标:<去耒阳县视察情况>
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"主公，我觉得最好调查一下这件事．");
 end
 if JY.Tid==367 then--文官
 talk( 367,"报告主公，有百姓报告说，耒阳县县令不做事．");
 end
 end,
 [455]=function()
 JY.Smap={};
 JY.Base["现在地"]="耒阳县";
 JY.Base["道具屋"]=0;
 AddPerson(3,25,7,1);
 AddPerson(64,29,9,1);
 AddPerson(1,25,9,1);
 AddPerson(363,19,11,0);
 SetSceneID(71,1);
 DrawStrBoxCenter("耒阳县");
 talk( 363,"刘备大人，欢迎您来耒阳县．听张飞吩咐，特在这里等候．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [456]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"官差不愿意对我说庞统的事．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"主公，咱们先找到庞统，再听听他的解释．");
 end
 if JY.Tid==363 then--官差
 talk( 1,"喂．庞统在那里？是在办公地点吗？",
 363,"这……这个……",
 1,"这……这个……你想说什么？",
 363,"那个，这事很难启齿．县令上任以来，没有处理过任何公务．",
 3,"什么？！",
 363,"哎呀！这不关我的事，再说这也是实情啊……");
 AddPerson(133,-5,24,0);
 talk( 133,"这里喧闹什么？怎么了？");
 MovePerson(133,13,0);
 talk( 3,"这个家伙！大哥，不管怎样得教训教训他．");
 NextEvent();
 end
 end,
 [457]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"到这里这么长时间一件公务也未处理？这可不是闹着玩．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"到这里一看，才知道官差所说的事是真的．");
 end
 if JY.Tid==363 then--官差
 talk( 363,"对，对不起！我没有做到．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"这不是刘备大人吗？什么风把您给吹来了？",
 1,"我听说你自从上任以来，就不曾处理过公务，因此特来这里查看．",
 133,"哦，是为这事呀．没错，是这样，来这里后没有处理过公务．");
 MovePerson(3,2,1);
 talk( 3,"你说什么！大哥信任你才让你作县令，你怎么能这样怠忽职守呢？",
 133,"怠忽职守？像这种乡村的事务我马上就可以处理完．现在就让你们看看．");
 MovePerson(133,2,1);
 talk( 363,"县令，请等一下．");
 MovePerson( 133,11,1,
 363,11,1);
 DecPerson(133);
 DecPerson(363);
 --显示任务目标:<到议事厅看审理情况>
 NextEvent();
 end
 end,
 [458]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，咱们进去看看这个家伙到底是个什么货色．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"等看完结果再决定如何处罚他也不迟．");
 end
 if JY.Tid==1 then--刘备
 talk( 1,"去议事厅看看情况吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [459]=function()
 JY.Smap={};
 JY.Base["现在地"]="耒阳县";
 JY.Base["道具屋"]=0;
 AddPerson(133,25,17,2);
 AddPerson(363,12,16,0);
 AddPerson(355,19,12,3);
 AddPerson(357,15,14,3);
 
 AddPerson(3,31,12,1);
 AddPerson(64,33,13,1);
 AddPerson(1,30,14,1);
 SetSceneID(54,1);
 DrawStrBoxCenter("耒阳县议事厅");
 
 talk( 133,"这位商人，你骗了这位农民，以贵３倍的价钱把锄头卖给了他．",
 357,"那有这么回事．不是您听错了，就是有人在造谣．");
 MovePerson(355,1,1);
 talk( 355,"你说什么！是你的邻居告诉我的，要不然我带证人来．");
 MovePerson(357,0,0);
 talk( 357,"什么！你别找碴儿！",
 133,"肃静！你们两人都给我安静！");
 MovePerson( 355,1,0);
 MovePerson( 355,0,3,
 357,0,3);
 talk( 133,"农民，你过来．本官问你，这个锄头你用过了吗？",
 355,"没，我还没用过．",
 133,"那就好办了．把这个锄头当作没卖过，因为它还没被使用过．农民把锄头还给商人，商人把农民付的钱还给他，就这样．",
 357,"那，那……",
 133,"还有什么要申辩的吗？",
 357,"没，没有……",
 133,"那么这个案子就到此结束．你们两个要服从判决，否则的话，要打一百个大板．你们下去吧．",
 355,"太谢谢了．",
 357,"……");
 MovePerson( 355,12,2,
 357,12,2);
 DecPerson(355);
 DecPerson(357);
 talk( 3,"这个判决很通情达理嘛．",
 64,"而且也合乎道理．这样谁也不会有意见．");
 DrawMulitStrBox("　就这样审判一个接一个地进行．*　到了晚上，就已经把以前积压的所有案件了结了．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [460]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"我以前从没见过这样乾脆利索的审判．");
 end
 if JY.Tid==64 then--孙乾
 talk( 64,"真是让人惊讶．看来人不可貌相啊．");
 end
 if JY.Tid==363 then--官差
 talk( 363,"有这么能干的人，就没什么可担心的了．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"刘备大人，怎么样？",
 1,"您真是天下少见的奇才，我多有冒犯，失礼失礼．",
 133,"没有关系．噢，这里有封信．",
 1,"……？");
 DrawMulitStrBox("信上写道：*『主公，庞统是能成大事之人，其才十倍于我．主公不可以貌取人，否则将失大贤．请务必收庞统为部下．*　　　　　　　　　　　　　诸葛亮』");
 talk( 1,"这不是孔明的信吗？",
 133,"不错．孔明来吴时，我碰巧见到了他．*那时他说，一定要把此信交给刘备大人．",
 1,"误会误会，为什么当初你不把信给我呢？否则……");
 AddPerson(126,-3,3,3);
 MovePerson(126,10,3);
 talk( 126,"主公，你怎么在这里？咦，这不是庞统吗？你怎么也会在这里？",
 133,"刘备大人任命我为这里的县令．",
 126,"这里的县令？你要是当了这里的县令，你就有很多时间玩了．主公，您怎么会只让庞统当个小小的县令呢？我信里不是对您说清楚了吗？",
 1,"我刚收到这封信．如果早收到，就不会有这种事了．",
 126,"我明白了．可是，把庞统任命为县令是对人才的浪费．",
 1,"是呀．那么庞统，从今天起，你就是我的副军师了．",
 133,"真不敢当．那咱们回江陵吧．");
 ModifyForce(133,1);
 PlayWavE(11);
 DrawStrBoxCenter("庞统成为部下！");
 PlayBGM(8);
 DrawMulitStrBox("　如此刘备军的阵容更强大了．以前水镜先生司马徽曾对刘备说起过的伏龙（诸葛亮）和凤雏*（庞统）都已经成了刘备的部下．*　刘备大展鸿图的时机终于到了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [461]=function()
 SetSceneID(-1,0);
 JY.Base["章节名"]="第三章　益州攻略战";
 DrawStrBoxCenter("第三章　益州攻略战");
 LoadPic(20,1);
 --DrawMulitStrBox("　就在庞统成为刘备部下的时候，曹操为了扩张领土，决定占领西北的被称为西凉的地方．为此，他暗杀了统治这块领土的马腾．*　可是，马腾的长子马超十分强悍．*　马超为了替父亲报仇，大举进攻曹操，两人在渭水进行了决战．起初，曹操处于劣势，可是后来他利用反间计，从内部分裂了马超军．*　马超终于被曹操击败，全军覆没．");
 DrawMulitStrBox("　就在庞统成为刘备部下的时候，曹操为了扩张领土，决定占领西北的被称为西凉的地方．为此，他暗杀了统治这块领土的马腾．*　可是，马腾的长子马超十分强悍．*");
 DrawMulitStrBox("　马超为了替父亲报仇，大举进攻曹操，两人在渭水进行了决战．起初，曹操处于劣势，可是后来他利用反间计，从内部分裂了马超军．*　马超终于被曹操击败，全军覆没．");
 DrawMulitStrBox("　马超后来被迫逃奔汉中．*　于是，曹操统一了中国北方．");
 LoadPic(20,2);
 LoadPic(21,1);
 DrawMulitStrBox("　由于西凉发生的突变，统治着西凉南面的汉中张鲁，为了能与曹操对抗，企图占领位于本国南部的益州．*　益州位于荆州的西部．诸葛亮曾进言刘备，夺取这块土地．");
 DrawMulitStrBox("　另一方面，益州的刘璋为了能抵御汉中张鲁的进攻，派遣张松为使者，请求曹操的援助．但是张松招致曹操的愤怒，而被驱逐出境．*　于是张松来到了刘备的荆州．");
 LoadPic(21,2);
 NextEvent();
 end,
 [462]=function()
 JY.Smap={};
 JY.Base["现在地"]="江陵";
 JY.Base["道具屋"]=15;
 AddPerson(126,19,17,2);
 AddPerson(133,25,14,2);
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(54,11,16,0);
 AddPerson(175,9,15,0);
 SetSceneID(54,5);
 DrawStrBoxCenter("江陵议事厅");
 MovePerson(126,0,3);
 talk( 126,"主公，张松从益州来了．",
 1,"从益州来？",
 126,"是的．和张松谈谈吧．");
 MovePerson(126,0,2);
 AddPerson(187,-5,2,3);
 MovePerson(187,10,3);
 talk( 187,"这位就是刘备大人吗？我是益州来的张松．");
 --显示任务目标:<会见张松>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [463]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，和张松谈谈吧．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，要先招呼客人．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"先与张松谈谈吧．");
 end
 if JY.Tid==187 then--张松
 talk( 1,"欢迎欢迎，我是刘备．",
 187,"刘备大人，我今天来特有一事相求．",
 1,"有什么我可以帮忙的吗？",
 187,"我们益州又被称为蜀．益州现在被外敌所扰，那就是我国北方的汉中张鲁．可是我家主公刘璋没有治理益州的能力．",
 187,"我以使者为名前往曹操处，假称乞求他的援助，实则欲把蜀国献给他．可是到那里后看清了他的本质，于是放弃了把国家交给他的打算．如果曹操统治益州，则百姓会永无宁日．",
 1,"嗯……",
 187,"在回国的路上，我忽然想到了您，刘备大人．于是顺道来到这里．刘备大人，我愿把益州献给您，请不要辜负我的好意．",
 1,"咦……怎么突然说出这种话？",
 187,"是的，这就是我的来意．回国后，我马上推荐您来对付汉中张鲁．为此，您必须亲赴益州，趁机夺取这个国家．",
 1,"可是……，夺取同宗刘璋的基业……",
 187,"不要顾虑这些了，成大事者不拘小节．我先回去准备了．");
 MovePerson(187,10,2);
 DecPerson(187);
 --显示任务目标:<商讨今后>
 NextEvent();
 end
 if JY.Tid==175 then--马良
 talk( 175,"先接见张松吧．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"和张松谈谈吧．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"主公，要先招呼客人呀．");
 end
 end,
 [464]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"为了能与曹操抗衡，一定要得到益州．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，这样的好事错过太可惜了．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"如果我们不仅得到了荆州，而且得到了益州，就足以与曹操对抗了．");
 end
 if JY.Tid==175 then--马良
 talk( 175,"荆州确实是兵家用武之地，然而也容易被外敌窥伺．如果只有荆州……");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公，为什么不马上答应呢？",
 1,"即使要夺益州，难道没别的办法了吗？",
 126,"刘璋的部下愿意帮助，哪里还有这样好的机会？",
 1,"可……",
 126,"张松说要推荐主公，咱们就等着益州的使者吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==133 then--庞统
 talk( 133,"主公，这不是很好的事吗？这样的好事一定要接受．");
 end
 end,
 [465]=function()
 JY.Smap={};
 JY.Base["现在地"]="成都";
 JY.Base["道具屋"]=19;
 AddPerson(189,6,7,3);
 AddPerson(24,19,9,1);
 AddPerson(196,23,11,1);
 AddPerson(200,27,13,1);
 AddPerson(188,9,14,0);
 AddPerson(191,13,16,0);
 AddPerson(192,17,18,0);
 AddPerson(187,37,23,2);
 SetSceneID(56,8);
 DrawStrBoxCenter("成都宫殿");
 DrawMulitStrBox("　这里是益州的州都－成都．益州常被称做蜀．*　曹操的魏、孙权的吴、以及蜀，这三国鼎立之势是诸葛亮的战略－天下三分之计．*　现在这个战略正在步向实施．");
 MovePerson(187,10,2);
 talk( 187,"我张松回来了．",
 189,"嗯，曹操怎么回答的？他愿不愿意帮助我们抵御汉中的张鲁？",
 187,"曹操不会帮助我们的．我推荐近邻荆州的刘备．",
 189,"是刘备吗？听说他有善战的部下．好，向刘备请求援军．",
 187,"使者由法正担任最合适．",
 189,"那么法正，你去刘备处请求援军吧．",
 188,"是．");
 MovePerson(24,1,1);
 MovePerson(24,0,2);
 talk( 24,"主公，等等！",
 189,"怎么啦？黄权．",
 24,"不能让刘备到益州来．如果他来的话，这个国家早晚会被他夺走的．",
 187,"不会发生这样的事的．刘备与主公是同宗．再说，没有援军怎么保卫国家？",
 189,"是这样没错，黄权．此时只能恳求刘备．法正你去吧．我在雒城等候．",
 188,"是．",
 24,"主公……");
 MovePerson(188,1,0);
 MovePerson(188,12,3);
 NextEvent();
 end,
 [466]=function()
 JY.Smap={};
 JY.Base["现在地"]="江陵";
 JY.Base["道具屋"]=15;
 AddPerson(1,25,17,2);
 AddPerson(126,22,10,1);
 AddPerson(133,11,16,0);
 SetSceneID(54,5);
 DrawStrBoxCenter("江陵议事厅");
 AddPerson(188,-5,2,3);
 MovePerson(188,10,3);
 talk( 188,"刘备大人，初次见面．我叫法正，是张松的好友．");
 --显示任务目标:<会见法正>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [467]=function()
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公，和法正谈谈吧．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"既然是张松的好友，那么就是与张松有同样想法的人吧．");
 end
 if JY.Tid==188 then--法正
 talk( 188,"我想张松已经对您说了，刘璋黯弱，不能抵御外敌．因此我们想把益州献给刘备大人．",
 1,"可是，刘璋与我是同宗，我不忍心夺刘璋的基业．",
 188,"刘璋的蜀国早晚会让别人夺走．与其这样，还不如献给英主．而这个英主，我们认为就是您刘备．请您不要推辞．",
 1,"……明白了．我想再与孔明和庞统商量一下．今天已经很晚了，您先去驿馆休息吧．",
 188,"谢谢．");
 MovePerson(126,3,2);
 MovePerson(126,3,1);
 MovePerson(126,1,3);
 talk( 126,"我来带路吧．")
 MovePerson( 126,10,2,
 188,10,2);
 DecPerson(126);
 DecPerson(188);
 --显示任务目标:<商讨今后>
 NextEvent();
 end
 end,
 [468]=function()
 if JY.Tid==133 then--庞统
 talk( 133,"主公，有这等好事，为何不行动呢？张松和法正已经把话说明了，您不认为这是天赐之物吗？",
 1,"嗯……",
 133,"荆州经常被外敌窥伺，而益州四面环山，正是与曹操、孙权争雄的好地方．",
 1,"我平生最恨曹操．如果我讨伐同宗的刘璋，不就与曹操一样了吗？",
 133,"如今乱世，只拘泥于同宗就无法生存下去．您的想法只在太平时代行得通．主公，您应该有复兴汉室的大志，如果忘了这一点而拘泥于小节，部下会离您而去的．",
 1,"……你说得有道理，我明白了．我会把这些话牢记于心的．谢谢．",
 133,"喔，既然已经下了决心，就集合部下吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [469]=function()
 JY.Smap={};
 JY.Base["现在地"]="江陵";
 JY.Base["道具屋"]=15;
 AddPerson(126,19,17,2);
 AddPerson(133,25,14,2);
 AddPerson(1,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(175,18,8,1);
 AddPerson(54,11,16,0);
 AddPerson(170,9,15,0);
 AddPerson(127,7,14,0);
 SetSceneID(54,12);
 talk( 133,"人都到齐了吗？开会了．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [470]=function()
 if JY.Tid==2 then--关羽
 talk( 2,"益州是险要之地．要想攻取，必须先做好充分的准备．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，带我去打益州吧．");
 end
 if JY.Tid==175 then--马良
 talk( 175,"听从主公的调遣．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"益州虽重要，但荆州也同样重要，必须要留能征惯战的武将把守．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"主公，我虽然上了年纪，但武艺丝毫未减退．请一定要带我去益州．");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"请务必让我当先锋．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公，我来守荆州吧．为此，请把关羽、张飞和赵云留下．",
 1,"好吧．那么关羽等人留在荆州，伊籍和简雍也留下．其余的人跟我去益州．",
 126,"是．守卫荆州的任务交给我吧，我等候着好消息．");
 ModifyForce(2,0);
 ModifyForce(3,0);
 ModifyForce(54,0);
 ModifyForce(126,0);
 ModifyForce(114,0);
 ModifyForce(83,0);
 AddPerson(188,-5,2,3);
 MovePerson(188,10,3);
 talk( 188,"下决心了吗？那么就去雒城吧．刘璋正等着我们呢．今后，我也要为刘备大人效力，还要请您多关照．");
 ModifyForce(188,1);
 PlayWavE(11);
 DrawStrBoxCenter("法正成为部下！");
 JY.Smap={};
 SetSceneID(0,3);
 talk( 188,"那么我带路去雒城．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==133 then--庞统
 talk( 133,"我要和主公去一趟益州．");
 end
 end,
 [471]=function()
 JY.Smap={};
 JY.Base["现在地"]="雒";
 JY.Base["道具屋"]=0;
 AddPerson(189,9,9,3);
 AddPerson(24,20,8,1);
 AddPerson(195,22,9,1);
 AddPerson(194,9,15,0);
 AddPerson(196,11,16,0);
 AddPerson(197,13,17,0);
 AddPerson(1,17,13,2);
 AddPerson(188,21,15,2);
 SetSceneID(49,8);
 DrawStrBoxCenter("雒议事厅");
 talk( 188,"我带刘备来了．",
 189,"啊，刘备，我等你多时了．");
 MovePerson(188,3,0);
 MovePerson(188,1,2);
 MovePerson(188,0,1);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [472]=function()
 if JY.Tid==189 then--刘璋
 talk( 189,"刘备大人，虽然我的部下七嘴八舌，然而我还是相信你的．",
 1,"我来了，您就放心吧．张鲁那边，由我去对付．",
 189,"那太感谢了．那么，请您去北面的涪城整顿兵马．");
 --显示任务目标:<去涪城>
 NextEvent();
 end
 if JY.Tid==24 then--黄权
 talk( 24,"我叫黄权，我不想见到你．");
 end
 if JY.Tid==194 then--刘贵
 talk( 194,"你最好不要在这惹事生非．蜀民可不好惹．");
 end
 if JY.Tid==195 then--冷苞
 talk( 195,"张鲁来攻，我们并不怕．总之一句话，我国不需要外来者．");
 end
 if JY.Tid==196 then--张任
 talk( 196,"远道而来辛苦了．可是，你为什么来此呢？");
 end
 if JY.Tid==197 then--邓贤
 talk( 197,"哼！你不就是为了益州而来的吗？");
 end
 if JY.Tid==188 then--法正
 talk( 188,"刘备大人，请先问候我家主公．");
 end
 end,
 [473]=function()
 if JY.Tid==189 then--刘璋
 talk( 189,"那么，请您去北面的涪城整顿兵马．",
 1,"那我就去涪城了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==24 then--黄权
 talk( 24,"我们的敌人太多了．有外患，有内奸……");
 end
 if JY.Tid==194 then--刘贵
 talk( 194,"你最好不要在这惹事生非．蜀民可不好惹．");
 end
 if JY.Tid==195 then--冷苞
 talk( 195,"张鲁来攻，我们并不怕．总之一句话，我国不需要外来者．");
 end
 if JY.Tid==196 then--张任
 talk( 196,"那就去打张鲁吧．");
 end
 if JY.Tid==197 then--邓贤
 talk( 197,"哼！你不就是为了益州而来的吗？");
 end
 if JY.Tid==188 then--法正
 talk( 188,"在这里行动不自在．快去涪城吧．",
 1,"那我就去涪城了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==1 then--刘备
 talk( 1,"那我就去涪城了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [474]=function()
 JY.Smap={};
 JY.Base["现在地"]="成都";
 JY.Base["道具屋"]=19;
 AddPerson(189,6,7,3);
 AddPerson(24,19,9,1);
 AddPerson(194,23,11,1);
 AddPerson(249,27,13,1);
 AddPerson(195,9,14,0);
 AddPerson(196,13,16,0);
 AddPerson(197,17,18,0);
 AddPerson(187,18,14,2);
 SetSceneID(56,11);
 DrawStrBoxCenter("成都宫殿");
 DrawMulitStrBox("　刘备刚到达涪城，他们的密谋就被在成都的刘璋发觉了．");
 talk( 189,"张松，临死前你想说什么？",
 187,"您为什么要杀我？",
 189,"你还在装傻！你酒后对你哥哥说，你已经把国家献给了刘备，你哥哥已经将你告发了．你还说不知道！",
 187,"……！哥哥……你难道看不出我这样做的理由吗？",
 189,"来人！把这个叛徒斩首！",
 196,"是！");
 MovePerson( 196,1,0,
 194,1,1);
 talk( 194,"你这个叛徒该死！",
 187,"啊……！");
 ModifyForce(187,0);
 DecPerson(187);
 DrawSMap();
 NextEvent();
 end,
 [475]=function()
 JY.Smap={};
 JY.Base["现在地"]="涪";
 JY.Base["道具屋"]=20;
 AddPerson(1,10,17,0);
 AddPerson(133,9,14,0);
 AddPerson(170,10,9,3);
 AddPerson(128,12,8,3);
 AddPerson(127,24,17,2);
 AddPerson(117,26,16,2);
 AddPerson(188,19,12,1);
 SetSceneID(83);
 DrawStrBoxCenter("涪城议事厅");
 DrawMulitStrBox("　法正得知张松被杀的消息后，立刻向刘备报告．");
 talk( 188,"刘备大人，张松被刘璋杀了．",
 1,"什么？这是真的吗？",
 188,"总之，我们的计划已经暴露了，怎么办？");
 talk( 133,"主公，快下决定吧．");
 --显示任务目标:<商讨今后>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [476]=function()
 if JY.Tid==170 then--黄忠
 talk( 170,"为了主公，我们百死不辞！");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"主公，使者来了．");
 AddPerson(365,43,0,1);
 MovePerson(365,10,1);
 talk( 365,"主公，我从荆州来，带来了诸葛军师的话，");
 NextEvent();
 end
 if JY.Tid==128 then--关平
 talk( 128,"主公，一定要把益州拿下！");
 end
 if JY.Tid==117 then--刘封
 talk( 117,"主公，如果能夺取益州，就有了与曹操抗衡的力量了．");
 end
 if JY.Tid==188 then--法正
 talk( 188,"刘备大人，请一定为张松报仇．不能让张松死的没有代价！");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"主公，到了这个地步，请下决断！攻打益州吧．");
 end
 end,
 [477]=function()
 if JY.Tid==170 then--黄忠
 talk( 170,"军师不知有什么事．");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"先听听使者说什么．");
 end
 if JY.Tid==365 then--使者
 talk( 365,"孔明捎来的口信说，从星象看，主公不宜出行．出征的事要谨慎．");
 NextEvent();
 end
 if JY.Tid==128 then--关平
 talk( 128,"是军师派来的使者吗？怎么回事？");
 end
 if JY.Tid==117 then--刘封
 talk( 117,"是军师派来的使者吗？怎么回事？");
 end
 if JY.Tid==188 then--法正
 talk( 188,"刘备大人，请一定要为张松报仇．不能让张松死的无价值！");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"孔明想说什么？主公，听听使者的话吧．");
 end
 end,
 [478]=function()
 if JY.Tid==170 then--黄忠
 talk( 170,"星象？我真不能理解．");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"既然军师这么说，就不要出征了．");
 end
 if JY.Tid==365 then--使者
 talk( 365,"军师是说，出征作战最好等一下．");
 end
 if JY.Tid==128 then--关平
 talk( 128,"难道星象真那么重要吗？");
 end
 if JY.Tid==117 then--刘封
 talk( 117,"我听人说过，军师会看星象．");
 end
 if JY.Tid==188 then--法正
 talk( 188,"刘备大人，请一定要为张松报仇．不能让张松死的没有价值！");
 end
 if JY.Tid==133 then--庞统
 talk( 1,"孔明这么说，庞统你说该怎么办？",
 133,"……我卜星象的结果并非不祥，反而是大吉之兆，不必理会这些．现在事已至此，逃回荆州是下策，进攻方为上策．",
 1,"可是……",
 133,"主公，咱们到这里来干什么？不是来夺取益州的吗？",
 1,"嗯，明白了，出征！",
 133,"您终于下了决心．听说刘璋军正在雒城集结．要想攻打下雒城，请主公作好准备．");
 --显示任务目标:<做出征刘璋军的准备>
 NextEvent();
 end
 end,
 [479]=function()
 if JY.Tid==170 then--黄忠
 talk( 170,"既然决定出征，我听从就是了．");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"出征吧．");
 end
 if JY.Tid==365 then--使者
 talk( 365,"那我告辞了．");
 MovePerson(365,10,0);
 DecPerson(365);
 end
 if JY.Tid==128 then--关平
 talk( 128,"主公，出征吧．");
 end
 if JY.Tid==117 then--刘封
 talk( 117,"我也要加入战斗．");
 end
 if JY.Tid==188 then--法正
 talk( 188,"刘备大人，请一定要为张松报仇．不能让张松死的没有价值！");
 end
 if JY.Tid==133 then--庞统
 if talkYesNo( 133,"做好准备了吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 133,"请编组队伍．");
 WarIni();
 DefineWarMap(33,"第三章 雒I之战","一、刘贵的退却",30,0,193);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,5,17, 4,0,-1,0,
 132,23,17, 4,0,-1,0,
 -1,22,16, 4,0,-1,0,
 -1,7,17, 4,0,-1,0,
 -1,6,16, 4,0,-1,0,
 -1,22,18, 4,0,-1,0,
 -1,23,18, 4,0,-1,0,
 -1,6,18, 4,0,-1,0,
 -1,5,16, 4,0,-1,0,
 -1,4,18, 4,0,-1,0,
 -1,4,19, 4,0,-1,0,
 });
 DrawSMap();
 JY.Smap={};
 SetSceneID(0,3);
 talk( 133,"那么向雒城进发．");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 193,23,3, 1,0,40,9, 0,0,-1,0,
 194,22,5, 1,0,36,3, 0,0,-1,0,
 196,20,19, 4,1,36,3, 0,0,-1,1,
 248,26,17, 3,1,37,20, 0,0,-1,1,
 199,14,4, 3,0,37,6, 0,0,-1,0,
 200,7,6, 3,1,37,9, 0,0,-1,0,
 201,8,7, 3,1,37,9, 0,0,-1,0,
 
 256,5,7, 3,1,33,3, 0,0,-1,0,
 257,16,4, 3,0,33,3, 0,0,-1,0,
 292,19,17, 4,1,35,9, 0,0,-1,1,
 293,20,17, 4,1,35,9, 0,0,-1,1,
 274,19,18, 4,1,32,6, 0,0,-1,1,
 275,26,4, 1,0,33,6, 0,0,-1,0,
 294,6,8, 3,1,34,9, 0,0,-1,0,
 277,24,5, 1,0,33,6, 0,0,-1,0,
 310,22,14, 1,1,33,12, 0,0,-1,1,
 332,21,15, 1,1,33,14, 0,0,-1,1,
 333,15,5, 3,0,32,14, 0,0,-1,0,
 295,15,3, 3,0,34,9, 0,0,-1,0,
 340,25,3, 1,0,33,17, 0,0,-1,0,
 195,24,14, 1,1,37,6, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [480]=function()
 PlayBGM(11);
 talk( 194,"刘备终于暴露了本性．原来，他还是想夺益州．",
 200,"是的．看张任的了．",
 133,"主公，若攻下雒城，离成都就不远了．请您引军北上，吸引敌人主力．我趁虚而入，偷袭敌城．嗯……");
 WarShowTarget(true);
 WarShowArmy(195);
 WarShowArmy(196);
 WarShowArmy(248);
 WarShowArmy(292);
 WarShowArmy(293);
 WarShowArmy(274);
 WarShowArmy(310);
 WarShowArmy(332);
 DrawStrBoxCenter("出现敌人伏兵！");
 talk( 196,"果不出我所料．有敌军企图偷越山道．",
 133,"啊……我的计策被识破了．",
 170,"副军师！",
 1,"如果没有庞统，就不能夺得益州．全军去营救副军师！");
 PlayBGM(9);
 NextEvent();
 end,
 [481]=function()
 if JY.Death==133 then
 PlayBGM(2);
 talk( 133,"我……我要死在这里了吗？……事业未成……我死不瞑目……");
 WarAction(18,133);
 --DrawStrBoxCenter("庞统战死！");
 SetFlag(38,1);
 talk( 170,"……主公，副军师已经撤退了，我们也退回涪城吧．",
 1,"嗯……那就撤退吧．……庞统，你怎么样了？……");
 DrawMulitStrBox("　刘备放弃攻打雒城．");
 WarGetExp();
 ModifyForce(133,0);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if War.Turn==8 then
 talk( 196,"……快出来！",
 1,"什么！？敌人偷袭我军军粮．",
 170,"主公，这样会使我军陷入困境．我们先撤回涪城吧．",
 1,"唉．也只好如此了．",
 195,"刘贵，敌人好像要撤退．",
 194,"喔．张任的第二个计谋好像成功了．张任这小子，真行！");
 DrawMulitStrBox("　刘备军军粮已尽，撤退了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(11);
 talk( 194,"没办法，只有固守城池了．",
 1,"嗯……敌人固守城池了．",
 170,"那就不好攻打了．我军军粮所剩无几，先撤回涪城吧．",
 1,"好吧．撤回涪城．");
 DrawMulitStrBox("　刘备军暂停进攻雒城．");
 GetMoney(1200);
 PlayWavE(11);
 DrawStrBoxCenter("获得黄金１２００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [482]=function()
 SetSceneID(0);
 talk( 170,"那么回涪城吧．");
 --显示任务目标:<返回涪城>
 NextEvent();
 end,
 [483]=function()
 JY.Smap={};
 JY.Base["现在地"]="涪";
 JY.Base["道具屋"]=20;
 AddPerson(1,10,17,0);
 AddPerson(170,10,9,3);
 AddPerson(128,12,8,3);
 AddPerson(127,24,17,2);
 AddPerson(117,26,16,2);
 SetSceneID(83,5);
 if GetFlag(38) then
 PlayBGM(2);
 talk( 1,"庞统怎么样了？平安无事吧．",
 117,"……遭到张任伏击，全身中箭身亡……",
 1,"什，什么？刘封，消息确实吗？",
 117,"是……",
 1,"怎么会这样！庞统……");
 else
 talk( 170,"主公，副军师因去阵地视察，因此不能到这里来了．特向您致歉．",
 1,"是吗？刚才我吓了一跳．万一庞统有个闪失……");
 end
 --显示任务目标:<商讨今后>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [484]=function()
 if JY.Tid==170 then--黄忠
 talk( 170,"主公，重整队伍，进攻雒城吧，");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"话虽如此，可是益州兵比想像得厉害．");
 end
 if JY.Tid==128 then--关平
 talk( 128,"主公，这事最好与孔明商量一下．",
 1,"嗯．你说得不错．那么关平，你就辛苦一趟吧．",
 128,"好的．我马上动身．",
 1,"嗯……把周仓也带去吧．");
 AddPerson(155,44,0,1);
 MovePerson(155,10,1);
 talk( 155,"是您叫我吗？",
 1,"嗯．周仓，你和关平一起去趟江陵，请求孔明派遣援军．",
 155,"是．我们马上出发．",
 128,"那我们告辞了．");
 MovePerson(128,2,0);
 MovePerson(128,3,3);
 MovePerson( 155,10,0,
 128,10,0);
 DecPerson(155);
 DecPerson(128);
 ModifyForce(128,0);
 ModifyForce(155,0);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==117 then--刘封
 talk( 117,"雒城是很难攻下的．");
 end
 end,
 [485]=function()
 JY.Smap={};
 JY.Base["现在地"]="江陵";
 JY.Base["道具屋"]=15;
 AddPerson(126,25,17,2);
 AddPerson(2,22,10,1);
 AddPerson(3,20,9,1);
 AddPerson(54,11,16,0);
 AddPerson(128,17,12,3);
 AddPerson(155,15,13,3);
 SetSceneID(54,12);
 DrawStrBoxCenter("江陵议事厅");
 talk( 128,"……就是如此这般．军师，有什么好主意吗？",
 126,"我立刻派援军．嗯，关羽．还有关平、周仓留下，守卫荆州．",
 2,"知道了．荆州就交给我吧．",
 126,"关羽，他们是你的部下，听从你的调遣．");
 AddPerson(34,3,4,3);
 AddPerson(38,1,5,3);
 AddPerson(39,-1,6,3);
 MovePerson( 38,5,3,
 34,5,3,
 39,5,3)
 talk( 38,"我是王甫．听从关羽将军的吩咐．",
 34,"我是廖化．很高兴在关羽手下工作．",
 39,"我叫赵累．请多关照．",
 2,"今后请你们多帮助．");
 talk( 126,"那么，张飞、赵云，你们二人兵分两路，入川支援主公．",
 3,"知道了．",
 54,"明白了．",
 126,"那就尽快做好出征准备，赶快去支援．");
 ModifyForce(3,1);
 NextEvent();
 end,
 [486]=function()
 JY.Smap={};
 JY.Base["现在地"]="涪";
 JY.Base["道具屋"]=20;
 AddPerson(1,10,17,0);
 if not GetFlag(38) then
 AddPerson(133,9,14,0);
 end
 AddPerson(170,10,9,3);
 AddPerson(127,24,17,2);
 SetSceneID(83);
 DrawStrBoxCenter("涪城议事厅");
 AddPerson(369,43,0,1);
 MovePerson(369,10,1);
 talk( 369,"报告大人，张飞的援军到了．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [487]=function()
 if JY.Tid==170 then--黄忠
 talk( 170,"好像是军师很快采取措施了．");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"能这么快地长驱直入，不愧是猛张飞呀．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"因为我没有做好准备，就冒然进攻，竟落到如此结果．");
 end
 if JY.Tid==369 then--武官
 talk( 1,"快叫张飞来．",
 369,"是！");
 MovePerson(369,10,0);
 DecPerson(369);
 talk( 1,"来得真快呀！从荆州到蜀的这一路上都有蜀军把守吧．",
 170,"是呀……哎，主公，张飞到了．");
 AddPerson(3,43,0,1);
 AddPerson(203,45,-1,1);
 MovePerson( 3,12,1,
 203,12,1);
 talk( 3,"大哥，我来了．",
 1,"嗯，张飞，你可来了！你后面的人是谁？",
 3,"这位是严颜，一路上多亏有他给我们带路．");
 NextEvent();
 end
 end,
 [488]=function()
 if JY.Tid==170 then--黄忠
 talk( 170,"是严颜吗？看上去也是员老将．");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"黄忠和严颜真可谓老当益壮．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"张飞不但有勇，而且有谋，不愧是主公义弟呀！");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"按照军师的命令，军师、赵云和我分三路入川．在途中，我说服了守城的老将军严颜．后来，严颜为我军做向导，所以很快就到达了．");
 JY.Person[3]["智力"]=limitX(JY.Person[3]["智力"]+10,1,100); --张飞智力+10
 NextEvent();
 end
 if JY.Tid==203 then--严颜
 talk( 203,"您好．我叫严颜．");
 end
 end,
 [489]=function()
 if JY.Tid==170 then--黄忠
 talk( 170,"是严颜吗？看上去也是员老将．");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"黄忠和严颜真可谓老当益壮．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"张飞不但有勇，而且有谋，不愧是主公义弟呀！能说服敌人武将，不是只凭武力所能做到的．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，向严颜道谢吧．");
 end
 if JY.Tid==203 then--严颜
 talk( 1,"蒙您给张飞带路，我刘备特向您道谢．",
 203,"不，不敢当．您太客气了．",
 1,"今后，请全力支持．",
 203,"那是当然，谢谢您让我加入．");
 ModifyForce(203,1);
 PlayWavE(11);
 DrawStrBoxCenter("严颜成为部下！");
 talk( 203,"刘备主公，益州的武将，也就是我的同仁，也有为益州的前途担忧的．如果向他们说清楚，我想会有向您投诚的．",
 1,"太好了．还要请严颜多多协助．",
 203,"是．我虽然岁数大了，但一定会尽全力的．");
 --显示任务目标:<作出征雒城的准备>
 NextEvent();
 end
 end,
 [490]=function()
 if JY.Tid==170 then--黄忠
 if talkYesNo( 170,"那么出征吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 170,"重编队伍吧．");
 WarIni();
 DefineWarMap(33,"第三章 雒II之战","一、刘贵的毁灭",40,0,193);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,18,22, 3,0,-1,0,
 -1,16,22, 3,0,-1,0,
 -1,17,22, 3,0,-1,0,
 -1,19,22, 3,0,-1,0,
 -1,18,21, 3,0,-1,0,
 -1,20,21, 3,0,-1,0,
 -1,19,20, 3,0,-1,0,
 -1,17,23, 3,0,-1,0,
 -1,19,23, 3,0,-1,0,
 53,3,19, 4,0,-1,1,
 125,1,20, 4,0,-1,1,
 113,2,19, 4,0,-1,1,
 82,0,20, 4,0,-1,1,
 });
 DrawSMap();
 talk( 170,"这次一定要攻克雒城，");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==127 then--魏延
 talk( 127,"援军到了，该出征了．");
 end
 if JY.Tid==133 then--庞统
 if talkYesNo( 133,"那么出征吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 133,"重编队伍吧．");
 WarIni();
 DefineWarMap(33,"第三章 雒II之战","一、刘贵的毁灭",40,0,193);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,18,22, 3,0,-1,0,
 -1,16,22, 3,0,-1,0,
 -1,17,22, 3,0,-1,0,
 -1,19,22, 3,0,-1,0,
 -1,18,21, 3,0,-1,0,
 -1,20,21, 3,0,-1,0,
 -1,19,20, 3,0,-1,0,
 -1,17,23, 3,0,-1,0,
 -1,19,23, 3,0,-1,0,
 53,3,19, 4,0,-1,1,
 125,1,20, 4,0,-1,1,
 113,2,19, 4,0,-1,1,
 82,0,20, 4,0,-1,1,
 });
 DrawSMap();
 talk( 133,"这次一定要攻克雒城，");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，我来了．您就放心吧．");
 end
 if JY.Tid==203 then--严颜
 talk( 203,"我虽然岁数大了，但一定会尽力的．");
 end
 end,
 [491]=function()
 JY.Smap={};
 SetSceneID(0,3);
 talk( 3,"雒城就在前面吧．大哥，快走！");
 ModifyForce(126,1);
 ModifyForce(54,1);
 ModifyForce(114,1);
 ModifyForce(83,1);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 193,23,3, 1,0,44,9, 0,0,-1,0,
 194,22,4, 1,0,39,3, 0,0,-1,0,
 196,12,16, 4,1,39,3, 0,0,-1,0,
 195,24,4, 1,0,39,6, 0,0,-1,0,
 199,6,6, 1,0,37,6, 0,0,-1,0,
 200,5,8, 1,0,37,9, 0,0,-1,0,
 201,7,16, 4,1,37,9, 0,0,-1,0,
 248,10,18, 4,1,41,20, 0,0,-1,0,
 274,7,7, 1,0,33,6, 0,0,-1,0,
 275,12,18, 4,1,32,6, 0,0,-1,0,
 256,21,3, 3,0,33,3, 0,0,-1,0,
 257,11,19, 4,1,33,3, 0,0,-1,0,
 292,25,3, 1,0,36,9, 0,0,-1,0,
 293,5,14, 4,1,35,9, 0,0,-1,0,
 332,13,17, 4,1,35,14, 0,0,-1,0,
 333,6,15, 4,1,34,14, 0,0,-1,0,
 294,11,17, 4,1,35,9, 0,0,-1,0,
 340,5,6, 1,0,35,17, 0,0,-1,0,
 341,4,7, 1,0,34,17, 0,0,-1,0,
 197,14,1, 3,1,40,3, 0,0,-1,1,
 198,15,2, 3,1,40,9, 0,0,-1,1,
 253,15,0, 3,1,36,6, 0,0,-1,1,
 254,16,1, 3,1,36,3, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [492]=function()
 PlayBGM(11);
 talk( 194,"刘备不顾打了败仗，又打来了．各位，为了刘璋主公好好打！",
 201,"……",
 202,"为了刘璋，唉……");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [493]=function()
 if WarMeet(3,196) then
 WarAction(1,3,196);
 talk( 3,"谁敢与我张飞交手？出来吧．",
 196,"什么？是张飞？如果我能打败张飞，会大大提高我军士气．好吧，张飞．我张任来与你交手．",
 3,"张任？谁都行．过来吧．");
 WarAction(6,3,196);
 if fight(3,196)==1 then
 talk( 196,"好家伙，真打不过他．",
 3,"别在那里发呆！");
 WarAction(4,3,196);
 talk( 3,"你不是我的对手．",
 196,"……你在干什么？快过来交手？",
 3,"杀死你真是易如反掌．我说，刘璋大势已去，你不如投降我们，胜于白白送死．",
 196,"……你在说什么？想要我投降？不！我宁死不降．",
 3,"你真是个忠臣，我了解你．那么，我只有杀死你了！",
 196,"哎呀！",
 3,"……哼！");
 WarAction(8,3,196);
 talk( 196,"杀死我吧……谢谢……");
 WarAction(18,196);
 talk( 3,"……真可惜．这小子是个武将！");
 WarLvUp(GetWarID(3));
 else
 WarAction(4,196,3);
 talk( 3,"哎呀！好家伙，真打不过他．");
 WarAction(17,3);
 WarLvUp(GetWarID(196));
 end
 end
 if (not GetFlag(39)) and WarMeet(1,200) then
 WarAction(1,1,200);
 PlayBGM(11);
 talk( 1,"吴懿，连严颜都投降我们了，你又为什么要白白流血呢？怎么样，投降我们吧？",
 200,"……明白了，我愿为刘备效力．");
 ModifyForce(200,1);
 PlayWavE(11);
 DrawStrBoxCenter("吴懿成为部下！");
 talk( 200,"不过，我不想跟以前的同伴交战，我先撤退了．");
 WarAction(16,200);
 SetFlag(39,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if (not GetFlag(40)) and WarMeet(1,201) then
 WarAction(1,1,201);
 PlayBGM(11);
 talk( 1,"吴兰，不想建设新益州吗？与我们一起努力吧．",
 201,"……有道理．听说严颜也加入了……好吧，我愿意加入你们．");
 ModifyForce(201,1);
 PlayWavE(11);
 DrawStrBoxCenter("吴兰成为部下！");
 SetFlag(40,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if (not GetFlag(41)) and WarMeet(1,202) then
 WarAction(1,1,202);
 PlayBGM(11);
 talk( 1,"雷铜，我不是来这里抢掠的．而是因为刘璋黯弱，不能抵御曹操．怎么样，与我一起抵御曹操好吗？",
 202,"嗯，确实是这样．刘璋不知何时就会被打垮，不如……好吧，我雷铜从今天起就是刘备的部下了．");
 ModifyForce(202,1);
 PlayWavE(11);
 DrawStrBoxCenter("雷铜成为部下！");
 talk( 202,"不过，我不忍与过去的朋友交手，我先走了．");
 WarAction(16,202);
 SetFlag(41,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if (not GetFlag(42)) and WarMeet(1,254) then
 WarAction(1,1,254);
 PlayBGM(11);
 talk( 1,"李严，益州的归属已定，不如老老实实的投降，胜于白白送死．",
 254,"嗯……",
 1,"怎么样？李严，协助我建设蜀国吧．",
 254,"建设蜀国？太好了，我愿意投降．");
 ModifyForce(254,1);
 PlayWavE(11);
 DrawStrBoxCenter("李严成为部下！");
 SetFlag(42,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if (not GetFlag(43)) and WarMeet(1,255) then
 WarAction(1,1,255);
 PlayBGM(11);
 talk( 1,"费观，同严颜一样，其他的武将都投降了．你投不投降？",
 255,"说的不错．连严颜都加入了你们，他是不会看错人的．好吧，我投降．");
 ModifyForce(255,1);
 PlayWavE(11);
 DrawStrBoxCenter("费观成为部下！");
 talk( 255,"那么，打完仗再见．");
 WarAction(16,255);
 SetFlag(43,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if (not GetFlag(1050)) and War.Turn==2 then
 talk( 1,"不好……这次又要苦战了．",
 1,"哎！那是谁？");
 PlayBGM(12);
 WarShowArmy(54-1);
 WarShowArmy(114-1);
 WarShowArmy(83-1);
 WarShowArmy(126-1);
 talk( 54,"我是赵云，支援您来了！诸位，跟我来！",
 126,"主公，我来迟了一步．我马上来助战！",
 1,"噢！赵云、孔明、伊籍、简雍，你们都来了！");
 PlayBGM(9);
 SetFlag(1050,1);
 end
 if (not GetFlag(1051)) and War.Turn==8 then
 SetFlag(161,1);
 SetFlag(1051,1);
 end
 if (not GetFlag(1052)) and (not GetFlag(158)) and War.Turn==13 then
 PlayBGM(11);
 talk( 54,"那是……敌人援军吗？");
 WarShowArmy(197);
 WarShowArmy(198);
 WarShowArmy(253);
 WarShowArmy(254);
 talk( 198,"刘备军终于来了．诸位，为了蜀国，勇敢地战斗啊！",
 199,"努力啊，我们赶到了！",
 254,"……这一战有什么意义呢？",
 255,"……");
 DrawStrBoxCenter("敌人援军出现！");
 WarModifyAI(194,1);
 WarModifyAI(195,1);
 WarModifyAI(199,1);
 WarModifyAI(200,1);
 WarModifyAI(292,1);
 WarModifyAI(256,1);
 WarModifyAI(340,1);
 WarModifyAI(341,1);
 WarModifyAI(274,1);
 PlayBGM(9);
 SetFlag(158,1);
 SetFlag(1052,1);
 end
 if (not GetFlag(158)) and WarCheckArea(-1,3,12,8,19) then
 PlayBGM(11);
 talk( 54,"那是……敌人援军吗？");
 WarShowArmy(197);
 WarShowArmy(198);
 WarShowArmy(253);
 WarShowArmy(254);
 talk( 198,"刘备军终于来了．诸位，为了蜀国，勇敢地战斗啊！",
 199,"努力啊，我们赶到了！",
 254,"……这一战有什么意义呢？",
 255,"……");
 DrawStrBoxCenter("敌人援军出现！");
 WarModifyAI(194,1);
 WarModifyAI(195,1);
 WarModifyAI(292,1);
 WarModifyAI(256,1);
 PlayBGM(9);
 SetFlag(158,1);
 end
 if (not GetFlag(158)) and (not GetFlag(161)) and WarCheckArea(-1,6,20,10,28) then
 talk( 194,"什么？部分敌人越过山道，逼近城池了？",
 196,"刘备这小子怎么又来了……嗯！？");
 WarShowArmy(197);
 WarShowArmy(198);
 WarShowArmy(253);
 WarShowArmy(254);
 talk( 198,"刘备军终于来了．诸位，为了蜀国，勇敢地战斗啊！",
 199,"努力啊，我们赶到了！",
 254,"……这一战有什么意义呢？",
 255,"……");
 DrawStrBoxCenter("敌人援军出现！");
 WarModifyAI(194,1);
 WarModifyAI(195,1);
 WarModifyAI(292,1);
 WarModifyAI(256,1);
 WarModifyAI(199,4,22,4);
 WarModifyAI(253,4,24,6);
 WarModifyAI(254,4,22,6);
 WarModifyAI(197,4,23,7);
 WarModifyAI(198,4,25,7);
 WarModifyAI(274,4,24,4);
 WarModifyAI(340,4,23,4);
 PlayBGM(9);
 SetFlag(158,1);
 end
 if JY.Status==GAME_WARWIN then
 talk( 1,"好，城内几乎没有敌人了．各位，一鼓作气攻陷雒城！");
 PlayBGM(7);
 DrawMulitStrBox("　刘备军占领了雒城．");
 GetMoney(1200);
 PlayWavE(11);
 DrawStrBoxCenter("获得黄金１２００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [494]=function()
 SetSceneID(0,3);
 talk( 126,"主公，该进雒城了．");
 --显示任务目标:<在雒城商讨今后>
 NextEvent();
 end,
 [495]=function()
 JY.Smap={};
 JY.Base["现在地"]="成都";
 JY.Base["道具屋"]=19;
 AddPerson(189,6,7,3);
 AddPerson(24,19,9,1);
 AddPerson(191,9,14,0);
 AddPerson(369,42,26,2);
 SetSceneID(56,11);
 DrawStrBoxCenter("成都宫殿");
 MovePerson(369,12,2);
 talk( 369,"报告！我军在雒城吃了大败仗，主要将领全部阵亡！",
 189,"什么！我没有将军了，怎么办才好呢？",
 24,"当初，我苦劝您不要让刘备入川，您不听．现在……",
 189,"唉……该怎么办呢……",
 24,"现在只有求助于张鲁，请他派兵，进攻刘备的后方．",
 189,"可是我与张鲁有世仇，他会答应吗？",
 24,"所以只有提出，如果张鲁把刘备打败，把蜀的一半割让给他．这样的话，张鲁不会不派兵吧．",
 189,"唉，也只有如此了．快派人去！喂，你快去吧！",
 369,"是．");
 MovePerson(369,12,3);
 DecPerson(369);
 NextEvent();
 end,
 [496]=function()
 JY.Smap={};
 JY.Base["现在地"]="汉中";
 JY.Base["道具屋"]=0;
 AddPerson(205,9,16,0);
 AddPerson(206,10,9,3);
 AddPerson(207,12,8,3);
 AddPerson(250,24,16,2);
 AddPerson(25,26,15,2);
 AddPerson(369,19,11,1);
 SetSceneID(52,5);
 DrawStrBoxCenter("汉中议事厅");
 talk( 369,"……就是这样，请张鲁大人一定要同意．",
 205,"我明白了．我要考虑一下，你先去休息吧．",
 369,"好的．");
 MovePerson(369,12,0);
 DecPerson(369);
 talk( 205,"怎么办？对刘璋采取什么态度？",
 206,"以前与我们打仗的事，您难道忘了吗？",
 250,"嗯．如果让刘璋和刘备互相争斗，那就再好不过了．",
 205,"是啊……");
 AddPerson(190,43,-1,1);
 MovePerson(190,12,1);
 talk( 190,"张鲁大人，听说刘璋派人请求援军是吗？",
 205,"不错．我们正在考虑如何答覆．",
 190,"如果出兵的话，请一定带我一起上阵．",
 190,"遭曹操所败投奔到此的我，受到这么周到的照顾，因此我要报恩．",
 205,"嗯……有马超就放心了．好吧，我决定出兵！马超，看你的了！",
 190,"噢，太谢谢了．");
 JY.Smap={};
 SetSceneID(0);
 talk( 205,"好！那么，向蜀国边境上的葭萌关进发！");
 NextEvent();
 end,
 [497]=function()
 JY.Smap={};
 JY.Base["现在地"]="雒";
 JY.Base["道具屋"]=20;
 AddPerson(1,9,9,3);
 if not GetFlag(38) then
 AddPerson(133,9,12,3);
 end
 AddPerson(126,15,9,3);
 AddPerson(3,20,9,1);
 AddPerson(170,22,10,1);
 AddPerson(54,9,15,0);
 AddPerson(127,11,16,0);
 SetSceneID(49);
 DrawStrBoxCenter("雒议事厅");
 talk( 126,"主公，祝贺您攻取雒城．使者来了．");
 AddPerson(365,41,25,2);
 MovePerson(365,12,2);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [498]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"怎么回事？这时候会有什么事？");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"猜不出来发生了什么事．还是先听听报告吧．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"发生了什么事？");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"主公，听听使者的汇报吧．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公，先听听使者说什么．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"主公，先听听使者说什么．");
 end
 if JY.Tid==365 then--使者
 talk( 365,"主公，大事不好！益州北边的汉中张鲁，发兵攻打我们．",
 1,"什么！",
 365,"在张鲁军中，还有曾败于曹操的西凉马超．敌人已经开始攻打雒城北面的葭萌关！",
 1,"听说马超在与曹操作战时势均力敌，是员勇将．",
 365,"是的．主公，怎么办？");
 --显示任务目标:<做出征张鲁的准备．>
 NextEvent();
 end
 end,
 [499]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"听说马超很厉害．大哥，务必带我去．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"徵求一下军师的意见．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"赶快制定对策．");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"马上就要进攻蜀都了，又遇见了麻烦．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"这是刘璋的策略．刘璋想让张鲁插入我背后，形成对我军的夹击．而且，有马超在，对我军是个威胁．因此必须迎击张鲁．",
 1,"孔明，马超真的这么厉害吗？",
 126,"是的．听说曹操曾被马超杀得割须弃袍，咱们不能小看他．",
 1,"嗯……那就派援军吧．可是，让谁在这里抗拒刘璋呢？",
 126,"那么我留守在这里吧．请主公亲自率兵，对付张鲁．请做好出征的准备．");
 ModifyForce(126,0);
 NextEvent();
 end
 if JY.Tid==133 then--庞统
 talk( 133,"果然来了．这大概是刘璋策划的．");
 end
 if JY.Tid==365 then--使者
 talk( 365,"张鲁军人数不少．");
 end
 end,
 [500]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"听说马超很厉害．大哥，一定要带我去．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"主公，请做好出征的准备．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"听说马超是个武艺出众的人．可是主公，没人能打败我．");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"马上就要进攻蜀都了，又遇见了麻烦．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"主公，准备好了吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 126,"请列好部队．");
 WarIni();
 DefineWarMap(37,"第三章 葭萌关I之战","一、张鲁撤退",30,0,204);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,1,8, 4,0,-1,0,
 2,1,9, 4,0,-1,0,
 -1,2,7, 4,0,-1,0,
 -1,2,9, 4,0,-1,0,
 -1,2,10, 4,0,-1,0,
 -1,4,7, 4,0,-1,0,
 -1,4,8, 4,0,-1,0,
 -1,3,8, 4,0,-1,0,
 -1,3,9, 4,0,-1,0,
 -1,0,7, 4,0,-1,0,
 });
 DrawSMap();
 talk( 126,"那么，早点出发吧．");
 JY.Smap={};
 SetSceneID(0,3);
 talk( 1,"据说敌人在葭萌关．那么赶快出发吧．");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 204,18,9, 3,2,45,12, 0,0,-1,0,
 205,18,10, 3,0,40,6, 0,0,-1,0,
 249,17,9, 3,0,40,21, 0,0,-1,0,
 24,17,6, 3,4,39,12, 11,3,-1,0,
 22,16,12, 3,4,39,6, 11,15,-1,0,
 256,17,10, 3,0,34,3, 0,0,-1,0,
 257,15,7, 3,4,34,3, 11,3,-1,0,
 258,15,11, 3,4,35,3, 11,15,-1,0,
 259,16,7, 3,4,35,3, 11,3,-1,0,
 
 274,17,8, 3,4,36,6, 11,3,-1,0,
 275,16,11, 3,0,35,6, 0,0,-1,0,
 276,16,8, 3,0,36,6, 0,0,-1,0,
 292,16,10, 3,4,38,9, 11,15,-1,0,
 293,15,9, 3,4,39,9, 11,15,-1,0,
 189,8,16, 2,3,41,9, 2,0,-1,1,
 203,8,18, 2,1,40,9, 0,0,-1,1,
 294,8,15, 2,1,39,9, 0,0,-1,1,
 295,7,16, 2,1,39,9, 0,0,-1,1,
 296,9,17, 2,1,39,9, 0,0,-1,1,
 297,8,19, 2,1,39,9, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 if JY.Tid==133 then--庞统
 talk( 133,"主公，请做好准备．");
 end
 if JY.Tid==365 then--使者
 talk( 365,"张鲁军人数不少．");
 end
 end,
 [501]=function()
 PlayBGM(11);
 talk( 205,"那是刘备军吗？如果能打败他，益州的一半就归我了．各位，冲啊！",
 1,"张鲁后方被曹操牵制着，如果在此地击退他，他就暂时不敢动了．好了，把张鲁从葭萌关赶出去！");
 WarShowTarget(true);
 PlayBGM(13);
 NextEvent();
 end,
 [502]=function()
 WarLocationItem(0,14,57,169); --获得道具:获得道具：援军报告
 if (not GetFlag(1053)) and War.Turn==3 then
 WarModifyAI(22,1);
 WarModifyAI(24,1);
 WarModifyAI(257,1);
 WarModifyAI(258,1);
 WarModifyAI(259,1);
 WarModifyAI(274,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 SetFlag(1053,1);
 end
 if (not GetFlag(170)) and WarCheckArea(-1,1,14,17,17) then
 talk( 205,"马超怎么还不来？嗯，终于来了．");
 PlayBGM(11);
 WarShowArmy(189);
 WarShowArmy(203);
 WarShowArmy(294);
 WarShowArmy(295);
 WarShowArmy(296);
 WarShowArmy(297);
 DrawStrBoxCenter("马超军出现了！");
 talk( 190,"张鲁好像陷入了苦战．我要让刘备知道知道我马超的厉害！走，跟我来！",
 1,"嗯？那就是马超吗？早就听说他是员勇将，但究竟是何等人物啊……");
 SetFlag(170,1);
 end
 if WarMeet(3,190) then
 WarAction(1,3,190);
 talk( 190,"在那里的看样子是有名的武将，我是马超，敌将通名！",
 3,"我乃张飞是也！你就是马超吗？",
 190,"张飞？没听说过．山野村夫我可没听过．",
 3,"什么？！你敢如此无礼！我要杀了你！");
 WarAction(6,3,190);
 if fight(3,190)==1 then
 talk( 3,"这，挺厉害．这小子还有两下子．",
 190,"他还挺能打．不过越是勇将，能杀死他越过瘾．");
 WarAction(6,3,190);
 WarAction(6,3,190);
 WarAction(10,3,190);
 talk( 190,"……好了，今天就打到这里，收兵！",
 3,"什么？你想逃跑吗？",
 190,"日后再分胜负吧！");
 WarLvUp(GetWarID(3));
 WarAction(16,190);
 WarAction(16,203+1);
 WarAction(16,294+1);
 WarAction(16,295+1);
 WarAction(16,296+1);
 WarAction(16,297+1);
 else
 talk( 3,"这，挺厉害．这小子还有两下子．",
 190,"他还挺能打．不过越是勇将，能杀死他越过瘾．");
 WarAction(6,3,190);
 WarAction(6,3,190);
 WarAction(10,3,190);
 talk( 3,"日后再分胜负吧！");
 WarAction(16,3);
 WarLvUp(GetWarID(190));
 end
 end
 if JY.Status==GAME_WARWIN then
 talk( 205,"没打赢，收兵吧！");
 PlayBGM(7);
 DrawMulitStrBox("　张鲁军退却．");
 GetMoney(1200);
 PlayWavE(11);
 DrawStrBoxCenter("得到了１２００黄金．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [503]=function()
 JY.Smap={};
 JY.Base["现在地"]="葭萌关";
 JY.Base["道具屋"]=0;
 AddPerson(1,8,18,0);
 if not GetFlag(38) then
 AddPerson(133,14,18,0);
 end
 AddPerson(3,11,11,3);
 AddPerson(170,13,10,3);
 AddPerson(54,21,17,2);
 AddPerson(127,23,16,2);
 SetSceneID(97,5);
 DrawStrBoxCenter("葭萌关营帐");
 AddPerson(126,32,6,1);
 MovePerson(126,8,1);
 talk( 126,"主公，您辛苦了．",
 1,"嗯？这不是孔明吗？你怎么来了？",
 126,"我不放心战况，因此赶到这里，想商量一下马超的事．");
 ModifyForce(126,1);
 --显示任务目标:<商讨今后>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [504]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，军师来了．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"军师来了，与他谈谈吧．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"军师驾到．");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"军师驾到．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"孔明来了．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"听说马超是一员虎将．",
 1,"是呀．成为敌手真可惜．",
 126,"那么，我去说服他投降．",
 1,"真的！行得通吗？",
 126,"我想可以．马超虽被张鲁收留，但是得不到信任，如果我们利用这一点……",
 1,"我明白了．孔明，祝你成功！");
 MovePerson(126,8,0);
 DecPerson(126);
 DrawSMap();
 DrawMulitStrBox("　诸葛亮看清了马超只是被作为工具来使用的事实，着手说服马超．*　起初马超不愿投降，可是，当说到真正的敌人是曹操时，他心动了．马超决定跟随刘备．");
 SetSceneID(97);
 AddPerson(126,32,6,1);
 MovePerson(126,8,1);
 talk( 126,"主公，马超来投降了．马超，请进．");
 AddPerson(190,33,7,1);
 AddPerson(204,31,6,1);
 MovePerson( 190,6,1,
 204,6,1);
 talk( 190,"我是马超．我马超和旁边的马岱，愿意一起投效您，刘备．");
 NextEvent();
 end
 end,
 [505]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"是个勇将，可以大增战斗力．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"能这样增强战斗力是一件大好事．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"看上去，他还是个年轻人，我应该比他强．");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"我虽然也算强者，可是在刘备军中，确实有不少勇将．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"马超可以成为我军中少有的勇猛之将，从而大大增强我军战斗力．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公，马超投降来了．");
 end
 if JY.Tid==190 then--马超
 talk( 1,"欢迎你，马超．",
 190,"您能原谅曾与您交战的我，真是太感谢了．",
 1,"没什么，都是过去的事了．不过今后你可要立功．",
 190,"今后请多关照我和马岱．");
 ModifyForce(190,1);
 ModifyForce(204,1);
 JY.Person[190]["道具1"]=0;
 JY.Person[190]["道具2"]=0;
 JY.Person[204]["道具1"]=0;
 JY.Person[204]["道具2"]=0;
 PlayWavE(11);
 DrawStrBoxCenter("马超和马岱成为部下！");
 talk( 190,"刘备主公，我愿意去说服刘璋，作为归顺的见面礼．",
 1,"劝说刘璋？",
 190,"是的，就交给我吧．张鲁也已经撤回汉中，刘璋已失去得力部下，我想一定能说服他．",
 1,"孔明，你怎么看？",
 126,"马超说的不错，现在可以使刘璋不战而降．不过，你要是想用武力征服他，也是可行的．",
 1,"嗯……那怎么办呢？");
 NextEvent();
 end
 if JY.Tid==204 then--马岱
 talk( 204,"我是马超的亲戚，名叫马岱．");
 end
 end,
 [506]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"我宁愿选择战争．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"到底选择那个，您看着办吧．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"我想战．军人就应该战争．");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"听从主公的意愿．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"刘璋已无战斗力．不论降伏还是打败他，都不是件困难事．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"马超说的不错，现在可以使刘璋不战而降．不过，你要是想用武力征服他，也是可行的．");
 end
 if JY.Tid==190 then--马超
 if talkYesNo( 190,"下决心了吗？") then
 RemindSave();
 DrawSMap();
 local menu={
 {"　 交给马超办",nil,1},
 {"　不交给马超办",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 190,"啊！能得到批准，太感谢了．那我们就去成都了．马岱，走吧．",
 204,"是．");
 MovePerson( 190,6,0,
 204,6,0);
 DecPerson(190);
 DecPerson(204);
 DrawSMap();
 JY.Smap={};
 SetSceneID(0);
 talk( 126,"那么主公，我们回雒城吧．");
 JY.Base["现在地"]="雒";
 DrawMulitStrBox("　马超去说服刘璋．*　刘璋已经既无战斗力，也无得力部下．*　刘璋为了避免流血，接受了马超的劝降．");
 SetSceneID(0);
 talk( 190,"刘备主公，恭喜你！刘璋同意投降．",
 1,"啊！太好了．",
 190,"这是刘璋归降的证据，我带了过来，请收下吧．");
 GetItem(1,6);
 talk( 190,"刘璋现在正在成都等候您，请速去成都．",
 126,"马超，谢谢你．那么主公，快去成都吧．");
 SetSceneID(0,3);
 talk( 190,"刘璋在成都等候，快点走吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(512); --goto 512
 elseif r==2 then
 talk( 190,"是吗……那我愿意为您在沙场上建立功勳．",
 126,"据说刘璋据守成都．做好出征准备．",
 3,"好．那么大哥，我们先去做准备了．",
 126,"不必在这里做准备，去涪城吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end
 if JY.Tid==204 then--马岱
 talk( 204,"我们西凉人是马上民族，与叫做羌族的异族有血缘关系．");
 end
 end,
 [507]=function()
 JY.Smap={};
 JY.Base["现在地"]="涪";
 JY.Base["道具屋"]=20;
 AddPerson(1,10,17,0);
 AddPerson(126,9,14,0);
 if not GetFlag(38) then
 AddPerson(133,15,17,0);
 end
 AddPerson(190,10,9,3);
 AddPerson(204,24,17,2);
 SetSceneID(83,12);
 DrawStrBoxCenter("涪城议事厅");
 talk( 126,"主公，其他武将已经整装待发，请您也做好准备．");
 --显示任务目标:<做出征成都的准备>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [508]=function()
 if JY.Tid==190 then--马超
 talk( 190,"驰骋疆场，建立功勳．");
 end
 if JY.Tid==204 then--马岱
 talk( 204,"请多关照我和马超．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"刘璋已无战斗力．打败他不是件困难事．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 PlayBGM(12);
 WarIni();
 DefineWarMap(34,"第三章 成都之战","一、刘璋投降．",40,0,188);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,26,1, 3,0,-1,0,
 -1,24,1, 3,0,-1,0,
 -1,25,0, 3,0,-1,0,
 -1,25,2, 3,0,-1,0,
 -1,25,3, 3,0,-1,0,
 -1,26,3, 3,0,-1,0,
 -1,27,0, 3,0,-1,0,
 -1,27,2, 3,0,-1,0,
 -1,27,4, 3,0,-1,0,
 });
 DrawSMap();
 talk( 126,"出征．");
 JY.Smap={};
 SetSceneID(0,3);
 talk( 126,"成都是在南方的大城市．向成都进发吧．");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 188,1,10, 4,2,44,3, 0,0,-1,0,
 23,11,5, 4,2,38,20, 0,0,-1,0,
 208,8,16, 4,2,36,15, 0,0,-1,0,
 34,16,13, 4,2,37,17, 0,0,-1,0,
 90,18,5, 4,2,36,6, 0,0,-1,0,
 207,8,15, 4,2,37,14, 0,0,-1,0,
 190,11,6, 4,2,37,3, 0,0,-1,0,
 274,2,10, 4,0,36,6, 0,0,-1,0,
 275,10,4, 4,4,36,6, 11,4,-1,0,
 276,16,12, 4,0,36,6, 0,0,-1,0,
 
 292,10,6, 4,4,37,9, 10,5,-1,0,
 293,15,13, 4,0,37,9, 0,0,-1,0,
 294,7,14, 4,4,37,9, 8,14,-1,0,
 295,9,5, 4,0,36,9, 0,0,-1,0,
 296,7,16, 4,0,36,9, 0,0,-1,0,
 332,3,9, 4,0,34,14, 0,0,-1,0,
 333,19,9, 4,4,34,14, 19,7,-1,0,
 277,6,13, 4,4,35,6, 7,15,-1,0,
 340,3,11, 4,0,36,17, 0,0,-1,0,
 341,17,4, 4,0,35,17, 0,0,-1,0,
 342,21,9, 4,0,35,17, 0,0,-1,0,
 343,16,14, 4,0,36,17, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [509]=function()
 PlayBGM(11);
 talk( 189,"刘备打过来了！各位，你们要好好保护我．",
 191,"唉！刘璋还是不能护卫国家呀！",
 188,"刘备，在敌军里的孟达是我和张松的至友，请一定设法救出他．",
 126,"主公，敌人已经丧失了斗志，如果能够说明道理，敌将也许会归降．");
 WarShowTarget(true);
 PlayBGM(14);
 NextEvent();
 end,
 [510]=function()
 if (not GetFlag(44)) and WarMeet(1,191) then
 WarAction(1,1,191);
 PlayBGM(11);
 talk( 191,"您就是刘备吗？我是张松和法正的至友，名叫孟达．我也想像他们那样，做您的部下．");
 ModifyForce(191,1);
 PlayWavE(11);
 DrawStrBoxCenter("孟达成为部下！");
 SetFlag(44,1);
 WarLvUp(GetWarID(1));
 PlayBGM(14);
 end
 if (not GetFlag(45)) and WarMeet(1,24) then
 WarAction(1,1,24);
 PlayBGM(11);
 talk( 24,"刘璋不听我的忠言，才落到今天这个境地．刘备大人，我相信你能挽救益州．");
 ModifyForce(24,1);
 PlayWavE(11);
 DrawStrBoxCenter("黄权成为部下！");
 SetFlag(45,1);
 WarLvUp(GetWarID(1));
 PlayBGM(14);
 end
 if (not GetFlag(46)) and WarMeet(1,208) then
 WarAction(1,1,208);
 PlayBGM(11);
 talk( 208,"刘备大人，请收我做部下．");
 ModifyForce(208,1);
 PlayWavE(11);
 DrawStrBoxCenter("霍峻成为部下！");
 SetFlag(46,1);
 WarLvUp(GetWarID(1));
 PlayBGM(14);
 end
 if (not GetFlag(47)) and WarMeet(1,91) then
 WarAction(1,1,91);
 PlayBGM(11);
 talk( 91,"刘备大人，我愿做您的部下．");
 ModifyForce(91,1);
 PlayWavE(11);
 DrawStrBoxCenter("吴班成为部下！");
 SetFlag(47,1);
 WarLvUp(GetWarID(1));
 PlayBGM(14);
 end
 if (not GetFlag(48)) and WarMeet(1,209) then
 WarAction(1,1,209);
 PlayBGM(11);
 talk( 209,"我已经对刘璋失去了信心．刘备大人，请收下我做部下吧．");
 ModifyForce(209,1);
 PlayWavE(11);
 DrawStrBoxCenter("陈式成为部下！");
 SetFlag(48,1);
 WarLvUp(GetWarID(1));
 PlayBGM(14);
 end
 if (not GetFlag(49)) and WarMeet(1,35) then
 WarAction(1,1,35);
 PlayBGM(11);
 talk( 35,"我是刘璋用钱雇用来的．但是，刘璋已经不能再付我钱了．那样的话，我与其战死还不如归降您．");
 ModifyForce(35,1);
 PlayWavE(11);
 DrawStrBoxCenter("沙摩可成为部下！");
 SetFlag(49,1);
 WarLvUp(GetWarID(1));
 PlayBGM(14);
 end
 if WarMeet(1,189) then
 WarAction(1,1,189);
 talk( 189,"唉……益州的武将和民众都已经离开我了吗？没办法，投降吧……");
 PlayBGM(7);
 DrawMulitStrBox("　刘璋投降了，刘备军占领了成都．");
 GetMoney(1200);
 PlayWavE(11);
 DrawStrBoxCenter("得到了１２００黄金！");
 WarGetExp();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 talk( 189,"唉……益州的武将和民众都已经离开我了吗？没办法，投降吧……");
 PlayBGM(7);
 DrawMulitStrBox("　刘璋投降了，刘备军占领了成都．");
 GetMoney(1200);
 PlayWavE(11);
 DrawStrBoxCenter("得到了１２００黄金！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 WarLocationItem(4,8,70,202); --获得道具:获得道具：发石车
 WarLocationItem(17,6,69,203); --获得道具:获得道具：步兵车
 end,
 [511]=function()
 SetSceneID(0,3);
 talk( 126,"那么，就进成都吧．");
 NextEvent();
 end,
 [512]=function()
 JY.Smap={};
 JY.Base["现在地"]="成都";
 JY.Base["道具屋"]=19;
 AddPerson(1,6,7,3);
 AddPerson(126,12,8,3);
 if not GetFlag(38) then
 AddPerson(133,6,11,3);
 end
 AddPerson(3,19,9,1);
 AddPerson(190,23,11,1);
 AddPerson(127,27,13,1);
 AddPerson(54,9,14,0);
 AddPerson(170,13,16,0);
 AddPerson(188,17,18,0);
 AddPerson(189,37,23,2);
 SetSceneID(56,5);
 DrawStrBoxCenter("成都宫殿");
 MovePerson(189,11,2);
 talk( 189,"那么，这是统治益州的证物印绶，请收下它吧．",
 1,"嗯……，刘璋，我这样做是为了与曹操斗争到底，恢复汉朝威严，我希望你能了解我．",
 189,"我很了解．",
 126,"那么，刘璋，我已经在荆州为你准备了住处，请到那里去住吧．",
 189,"好的．");
 MovePerson(189,12,3);
 talk( 1,"那么今后益州由我刘备治理．诸位，你们要更加努力把国家建设好！");
 PlayBGM(8);
 DrawMulitStrBox("　于是，刘备占领了益州．*　刘备占领益州和荆州后，进而图谋中原，再展鸿图．");
 NextEvent();
 end,
 [513]=function()
 SetSceneID(-1,0);
 JY.Base["章节名"]="第三章　汉中攻防战";
 DrawStrBoxCenter("第三章　汉中攻防战");
 LoadPic(22,1);
 DrawMulitStrBox("　曹操为了能对抗取得益州的刘备，决定先进攻汉中．曹操希望能先于刘备夺取汉中，并以此地为根据地，进攻刘备．*　于是，开始实施进攻刘备的计划．");
 LoadPic(22,2);
 NextEvent();
 end,
 [514]=function()
 JY.Smap={};
 JY.Base["现在地"]="邺";
 JY.Base["道具屋"]=0;
 AddPerson(383,28,7,1);
 AddPerson(9,29,10,1);
 AddPerson(20,14,9,3);
 AddPerson(103,10,11,3);
 AddPerson(18,25,15,2);
 AddPerson(79,21,17,2);
 SetSceneID(92,11);
 DrawStrBoxCenter("邺城宫殿");
 talk( 9,"陛下，请给我们下达出击的命令．",
 383,"……朕对这次战争不能……",
 9,"啊？你说什么？",
 383,"……",
 9,"刘备窥伺许昌，企图推翻我－陛下的忠臣，不是逆贼是什么？现在我要兴兵讨逆，你为什么不同意？",
 383,"刘备不会与朕作对！刘备也绝不是逆贼！真正的逆贼是……",
 9,"陛下，你还有利用价值．我可以用你来给所有反对我的人戴上逆贼的臭名，就是这样．可是假如是一个孩子已经玩腻了的玩具，他会怎样对待它呢？你猜得出来吗？",
 383,"……",
 9,"陛下，你可不要做让我不喜欢你的事呀．",
 383,"……那你看着办吧．",
 9,"哈哈哈！");
 MovePerson(9,1,1);
 talk( 9,"那么，我替陛下向全军下达出击的命令．曹洪听令！",
 20,"曹洪在！");
 MovePerson(20,3,3);
 MovePerson(20,0,0);
 talk( 9,"命你为汉中主将，指挥全军，夏侯渊为副将，一定要把逆贼刘备杀死！",
 20,"是！遵命！");
 MovePerson( 20,12,1,
 103,12,1,
 18,12,1,
 79,12,1);
 talk( 383,"皇叔……对不起……");
 
 JY.Smap={};
 SetSceneID(0);
 talk( 20,"好．在汉中召开军事会议！");
 
 JY.Smap={};
 JY.Base["现在地"]="汉中";
 JY.Base["道具屋"]=0;
 AddPerson(20,9,16,0);
 AddPerson(18,10,9,3);
 AddPerson(211,12,8,3);
 AddPerson(210,14,7,3);
 AddPerson(79,24,16,2);
 AddPerson(103,26,15,2);
 AddPerson(252,28,14,2);
 SetSceneID(52);
 DrawStrBoxCenter("汉中议事厅");
 talk( 20,"诸位将军，我要分派任务了．夏侯渊听令！",
 18,"在！");
 MovePerson(18,3,0);
 MovePerson(18,3,3);
 MovePerson(18,3,1);
 talk( 20,"夏侯渊，命你镇守定军山．此山位于蜀国边境，是很重要的军事阵地．",
 18,"明白了．那么我走了．",
 20,"嗯．");
 MovePerson(18,14,0);
 talk( 20,"夏侯德听令！",
 211,"在！");
 MovePerson(211,2,0);
 MovePerson(211,3,3);
 MovePerson(211,3,1);
 talk( 20,"命你镇守天荡山，此处与定军山一样，都是边境重地．",
 211,"明白了！");
 MovePerson(211,14,0);
 talk( 20,"其余的人作为预备队留守这里．要注意观察刘备的动向，随时准备投入战斗．");
 MovePerson(103,2,0);
 MovePerson(103,3,2);
 MovePerson(103,3,1);
 talk( 103,"将军，咱们就在这里静观战局吗？",
 20,"是的．",
 103,"那岂不是太消极了吗？",
 20,"不，不能小看了刘备．是在这里注意刘备军的动向．",
 103,"……那么，请拨给我一支部队，我当先锋，进攻刘备．",
 20,"不！这样可不行．要紧的是，这样会脱离统率，不能冒昧行事．",
 103,"将军，你这样说，是不是害怕刘备？",
 20,"什么！张颌，在我面前，你不得无礼！……好吧，你既然这么说，我答应你，给你一支部队．不过，若是失败，以军法处置！",
 103,"哈哈……那你就在此等着刘备的首级吧．再见．");
 MovePerson(103,14,0);
 
 JY.Smap={};
 SetSceneID(0);
 talk( 18,"好啦，向定军山进发！",
 211,"咱们去天荡山！前进！");
 SetSceneID(0);
 talk( 103,"哼！刘备的情况，我以前在袁绍手下时就知道，刘备没什么可怕的！我们向瓦口关出击，在瓦口关消灭他们！");
 NextEvent();
 end,
 [515]=function()
 JY.Smap={};
 JY.Base["现在地"]="成都";
 JY.Base["道具屋"]=19;
 AddPerson(1,6,7,3);
 AddPerson(126,12,8,3);
 if not GetFlag(38) then
 AddPerson(133,6,11,3);
 end
 AddPerson(3,19,9,1);
 AddPerson(190,23,11,1);
 AddPerson(54,9,14,0);
 AddPerson(170,13,16,0);
 SetSceneID(56,5);
 DrawStrBoxCenter("成都宫殿");
 talk( 126,"主公，你听说了吗？曹操已经占领了汉中．",
 1,"嗯．曹操占领汉中是想最终占领蜀．",
 126,"是呀，确实是这样，而且曹操已经行动了……主公，好像来了使者．");
 AddPerson(369,37,23,2);
 MovePerson(369,11,2);
 talk( 369,"禀报主公．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [516]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"怎么啦？曹操要进攻我们吗？");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"主公，先听听报告吧．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"说实话，我是第一次与曹军交战，很想打一仗．");
 end
 if JY.Tid==190 then--马超
 talk( 190,"以前，我曾败于曹军．要在这一战中报此仇，雪先父之恨．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"夺取益州后，我军士气高昂．现在正是与曹操交手的时候．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"先听听报告吧．");
 end
 if JY.Tid==369 then--武官
 talk( 369,"报告，曹操部下武将张颌，率军入侵瓦口关．",
 54,"怎么？说来就来了？",
 3,"是张颌？大哥，我跟你一起去，把他打得落花流水．",
 369,"我先走了．");
 MovePerson(369,12,3);
 DecPerson(369);
 --显示任务目标:<做出征瓦口关的准备．>
 NextEvent();
 end
 end,
 [517]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，交给我吧．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"不能只让张飞立功，我也要去．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"说实话，我是第一次与曹军交战，很想打一仗．");
 end
 if JY.Tid==190 then--马超
 talk( 190,"以前，我曾败于曹军．要在这一战中报此仇，雪先父之恨．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"夺取益州后，我军士气高昂．现在正是与曹操交手的时候．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"出征吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 126,"请点兵派将．");
 WarIni();
 DefineWarMap(35,"第三章 瓦口关I之战","一、张颌的败退",40,0,102);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,17,13, 3,0,-1,0,
 -1,16,12, 3,0,-1,0,
 -1,18,13, 3,0,-1,0,
 -1,15,11, 3,0,-1,0,
 -1,15,13, 3,0,-1,0,
 -1,19,12, 3,0,-1,0,
 -1,19,14, 3,0,-1,0,
 -1,14,12, 3,0,-1,0,
 -1,13,11, 3,0,-1,0,
 -1,13,12, 3,0,-1,0,
 -1,20,13, 3,0,-1,0,
 -1,20,14, 3,0,-1,0,
 });
 DrawSMap();
 talk( 126,"那么，向瓦口关进发．");
 JY.Smap={};
 SetSceneID(0,3);
 talk( 126,"瓦口关位于葭萌关东面．快点出发吧．");
 ModifyForce(103,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 102,16,1, 3,0,46,22, 0,0,-1,0,
 256,23,17, 3,1,40,3, 0,0,-1,1,
 257,27,17, 3,1,39,3, 0,0,-1,1,
 258,15,1, 3,0,39,3, 0,0,-1,0,
 259,13,1, 3,1,40,3, 0,0,-1,0,
 260,11,3, 3,1,40,3, 0,0,-1,0,
 274,20,18, 3,1,37,6, 0,0,-1,1,
 275,15,16, 2,1,36,6, 0,0,-1,1,
 276,14,2, 3,0,37,6, 0,0,-1,0,
 292,7,7, 4,1,42,9, 0,0,-1,0,
 293,8,6, 4,1,42,9, 0,0,-1,0,
 294,12,2, 3,1,41,9, 0,0,-1,0,
 295,25,18, 3,1,40,9, 0,0,-1,1,
 296,6,8, 4,1,41,9, 0,0,-1,0,
 332,22,18, 3,1,41,14, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [518]=function()
 PlayBGM(11);
 talk( 103,"到底打来了，刘备啊！我知道你虎视眈眈．会打进汉中来．我先来一步打你们．将士们，刘备在哪里，全体进攻！",
 126,"其余部队不要动！耐心引诱敌人，等敌人一汇集到面前，就狠狠地打！明白了吗！");
 WarShowTarget(true);
 WarShowArmy(256);
 WarShowArmy(257);
 WarShowArmy(274);
 WarShowArmy(275);
 WarShowArmy(295);
 WarShowArmy(332);
 DrawStrBoxCenter("出现敌军伏兵！");
 PlayBGM(19);
 NextEvent();
 end,
 [519]=function()
 if WarMeet(202,103) then
 WarAction(1,202,103);
 talk( 202,"魏军，还想得陇望蜀．我雷铜把你们打垮了．",
 103,"好大胆，你胆敢和我张颌较量！有意思，我来逗逗你．过来！");
 WarAction(6,202,103);
 if fight(202,103)==1 then
 talk( 103,"一招，两招……怎么样？",
 202,"还杀不了你，再砍过一刀．");
 WarAction(4,202,103);
 talk( 103,"啊……！",
 103,"好家伙！刘备的兵不好打．退兵，回瓦口关防守敌人．");
 WarLvUp(GetWarID(202));
 WarAction(16,103);
 NextEvent();
 else
 talk( 103,"一招，两招……怎么样？",
 202,"还杀不了你，再砍过一刀．");
 WarAction(4,103,202);
 talk( 202,"不行！杀不过他！",
 103,"这么点本事，还想杀我．看我一刺．");
 WarAction(8,103,202);
 talk( 202,"哎呀！",
 202,"好厉害，打不过他．……逃吧．");
 WarAction(17,202);
 talk( 103,"嘿嘿！蜀军都不经一打．");
 WarLvUp(GetWarID(103));
 end
 end
 if (not GetFlag(1054)) and War.Turn==3 then
 talk( 103,"刘备，你已被四面包围，束手待毙．我来取你首级！好！全军前进！");
 WarModifyAI(102,1);
 WarModifyAI(258,1);
 WarModifyAI(276,1);
 SetFlag(1054,1);
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(11);
 talk( 103,"好家伙！刘备的兵不好打．退兵，回瓦口关防守敌人．");
 NextEvent();
 end
 end,
 [520]=function()
 PlayBGM(7);
 talk( 126,"主公，敌军退回瓦口关了．我们追击敌军吧！");
 JY.Status=GAME_WMAP2;
 NextEvent();
 end,
 [521]=function()
 WarIni2();
 DefineWarMap(36,"第三章 瓦口关II之战","一、张颌的撤退",40,0,102);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm2(1,{
 0,23,17, 3,0,-1,0,
 -1,23,16, 3,0,-1,0,
 -1,21,16, 3,0,-1,0,
 -1,21,18, 3,0,-1,0,
 -1,24,17, 3,0,-1,0,
 -1,24,18, 3,0,-1,0,
 -1,20,17, 3,0,-1,0,
 -1,20,19, 3,0,-1,0,
 -1,22,17, 3,0,-1,0,
 -1,25,15, 3,0,-1,0,
 -1,25,17, 3,0,-1,0,
 -1,26,16, 3,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 102,10,2, 1,2,48,22, 0,0,-1,0,
 129,8,4, 1,4,42,3, 5,8,-1,0,
 209,12,4, 1,4,42,21, 12,11,-1,0,
 256,9,2, 1,0,41,3, 0,0,-1,0,
 257,11,2, 1,0,41,3, 0,0,-1,0,
 258,8,5, 1,4,40,3, 4,9,-1,0,
 259,8,3, 1,4,38,3, 3,10,-1,0,
 260,9,4, 1,4,40,3, 2,10,-1,0,
 261,12,5, 1,4,38,3, 11,12,-1,0,
 262,11,4, 1,4,39,3, 12,12,-1,0,
 263,12,3, 1,4,39,3, 13,12,-1,0,
 336,10,3, 1,0,41,15, 0,0,-1,0,
 337,7,4, 1,4,40,15, 5,10,-1,0,
 338,13,4, 1,4,41,15, 12,13,-1,0,
 });
 War.Turn=1;
 NextEvent();
 end,
 [522]=function()
 PlayBGM(11);
 talk( 103,"刚才没有打好仗，这次能好好打了．而且已给汉中的曹洪去信，要求派兵支援．刘备，来攻打吧！",
 126,"主公，往上看那是瓦口关．我们要把张颌赶出瓦口关．");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [523]=function()
 if WarMeet(202,103) then
 WarAction(1,202,103);
 talk( 202,"魏军，还想得陇望蜀．我雷铜把你们打垮了．",
 103,"好大胆，你胆敢和我张颌较量！有意思，我来逗逗你．过来！");
 WarAction(6,202,103);
 if fight(202,103)==1 then
 talk( 103,"一招，两招……怎么样？",
 202,"还杀不了你，再砍过一刀．");
 WarAction(4,202,103);
 talk( 103,"啊……！",
 103,"可！可没有想到刘备军这么凶，撤……，撤退！");
 WarLvUp(GetWarID(202));
 WarAction(16,103);
 DrawMulitStrBox("　张颌军撤退了．");
 NextEvent();
 else
 talk( 103,"一招，两招……怎么样？",
 202,"还杀不了你，再砍过一刀．");
 WarAction(4,103,202);
 talk( 202,"不行！杀不过他！",
 103,"这么点本事，还想杀我．看我一刺．");
 WarAction(8,103,202);
 talk( 202,"哎呀！",
 202,"好厉害，打不过他．……逃吧．");
 WarAction(17,202);
 talk( 103,"嘿嘿！蜀军都不经一打．");
 WarLvUp(GetWarID(103));
 end
 end
 if (not GetFlag(1055)) and War.Turn==7 then
 PlayBGM(11);
 talk( 103,"来了，援兵？什么，不派援兵来了．为什么？原来主帅对上次的争吵抱有成见．还记仇啊！这就不好打了．");
 PlayBGM(19);
 SetFlag(1055,1);
 end
 if JY.Status==GAME_WARWIN then
 talk( 103,"可！可没有想到刘备军这么凶，撤……，撤退！");
 PlayBGM(7);
 DrawMulitStrBox("　张颌军撤退了．");
 NextEvent();
 end
 WarLocationItem(11,15,56,171); --获得道具:获得道具：赦命书
 WarLocationItem(6,3,171,204); --获得道具:获得道具：猛火书 改为 枪术指南书
 end,
 [524]=function()
 GetMoney(1300);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１３００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [525]=function()
 SetSceneID(0,3);
 talk( 126,"虽然击退了张颌，可是曹操是不会善罢干休的，他一定还会采取什么军事行动．");
 SetSceneID(0,11);
 talk( 20,"什么？！张颌被刘备打败了，我立即报告曹操大人．徐晃，你速去天荡山，命令夏侯德立即进攻葭萌关，天荡山就转由你来镇守．",
 79,"遵命．我马上去天荡山．");
 SetSceneID(0);
 talk( 79,"夏侯德将军，曹洪有令，命你立即进攻葭萌关．",
 211,"遵命．全军向葭萌关进发．");
 NextEvent();
 end,
 [526]=function()
 JY.Smap={};
 JY.Base["现在地"]="瓦口关";
 JY.Base["道具屋"]=0;
 AddPerson(1,8,18,0);
 AddPerson(126,8,15,0);
 if not GetFlag(38) then
 AddPerson(133,14,18,0);
 end
 AddPerson(3,11,11,3);
 AddPerson(190,13,10,3);
 AddPerson(54,21,17,2);
 AddPerson(170,23,16,2);
 SetSceneID(97,12);
 DrawStrBoxCenter("瓦口关营帐");
 AddPerson(369,32,6,1);
 MovePerson(369,8,1);
 talk( 369,"刘备大人，刚刚收到葭萌关的报告，说曹军进攻，要求速派援军．",
 54,"说到曹操，曹操就来了．",
 3,"又来了，败仗还没吃够吗？",
 170,"主公，那就作出征准备吧．");
 talk( 126,"主公，我们有两个对策，一个是派援军；另一个是乾脆进攻定军山．葭萌关的曹军是由夏侯德指挥，定军山是由夏侯渊镇守．");
 --显示任务目标:<请选择是向葭萌关派援军，还是进攻定军山．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [527]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，究竟向那里派兵，快决定吧．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"定军山，顾名思义，一定山势险要，是兵家必争之地．要攻克定军山，需要选派适合山地战的部队．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"主公，快决定吧．管他是夏侯德还是夏侯渊，我去提来首级献给主公．");
 end
 if JY.Tid==190 then--马超
 talk( 190,"以前我进攻过葭萌关，我觉得那是个易守难攻的关隘．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"葭萌关有夏侯德，定军山有夏侯渊．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"决定了吗？") then
 RemindSave();
 DrawSMap();
 local menu={
 {"增援葭萌关",nil,1},
 {"进攻定军山",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 126,"明白了．那就增援葭萌关．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(); --goto 528
 elseif r==2 then
 talk( 126,"好．那就攻打定军山．");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
 talk( 79,"什么，刘备军去攻打定军山了？我立即去援救夏侯渊．");
 SetSceneID(0);
 talk( 211,"怎么回事？刘备不来救援葭萌关，反而去进攻定军山．如果被他得逞，那汉中就危险了．全军停止进攻，速返回天荡山，加强那里的防守．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(534); --goto 534
 end
 end
 end
 if JY.Tid==369 then--武官
 talk( 369,"夏侯德在葭萌关前布下了几道复杂的阵势．据侦察其中有许多宝物库．");
 end
 end,
 [528]=function()
 JY.Smap={};
 SetSceneID(0,3);
 talk( 126,"请编排部队．");
 WarIni();
 DefineWarMap(38,"第三章 葭萌关II之战","一、夏侯德的溃灭",35,0,210);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,7,9, 4,0,-1,0,
 -1,7,8, 4,0,-1,0,
 -1,7,10, 4,0,-1,0,
 -1,6,7, 4,0,-1,0,
 -1,6,9, 4,0,-1,0,
 -1,6,11, 4,0,-1,0,
 -1,8,6, 4,0,-1,0,
 -1,8,8, 4,0,-1,0,
 -1,8,10, 4,0,-1,0,
 -1,8,12, 4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 210,33,13, 3,2,48,20, 0,0,-1,0,
 256,33,12, 3,0,43,3, 0,0,-1,0,
 257,28,6, 3,4,39,3, 26,8,-1,0,
 274,32,13, 3,0,39,6, 0,0,-1,0,
 275,28,5, 3,0,43,6, 0,0,-1,0,
 276,30,7, 3,0,43,6, 0,0,-1,0,
 277,29,7, 3,4,39,21, 27,8,-1,0,
 278,28,12, 3,4,41,21, 26,12,-1,0,
 279,18,8, 3,0,41,6, 0,0,-1,0,
 292,32,12, 3,0,45,9, 0,0,-1,0,
 293,29,6, 3,0,45,9, 0,0,-1,0,
 294,25,11, 3,0,44,9, 0,0,-1,0,
 295,21,13, 3,4,44,9, 19,10,-1,0,
 
 310,27,13, 3,4,43,12, 25,13,-1,0,
 311,18,9, 3,0,42,12, 0,0,-1,0,
 280,28,10, 3,4,43,21, 24,10,-1,0,
 340,21,1, 1,1,45,17, 0,0,-1,1,
 341,20,18, 2,1,44,17, 0,0,-1,1,
 336,21,18, 2,1,39,15, 0,0,-1,1,
 342,24,1, 1,1,45,17, 0,0,-1,1,
 343,23,18, 2,1,44,17, 0,0,-1,1,
 337,24,18, 2,1,39,15, 0,0,-1,1,
 332,27,1, 1,1,45,14, 0,0,-1,1,
 333,26,18, 2,1,44,14, 0,0,-1,1,
 338,27,18, 2,1,39,15, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [529]=function()
 PlayBGM(11);
 talk( 211,"又派了援兵？没什么，我把他们打垮．",
 126,"主公，请注意进攻路上左右的树林，夏侯德可能在那里埋下了伏兵．");
 WarShowTarget(true);
 SetFlag(902,1); --夏侯德存活，默认
 PlayBGM(9);
 NextEvent();
 end,
 [530]=function()
 if (not GetFlag(1056)) and War.Turn==5 then
 WarShowArmy(340);
 WarShowArmy(341);
 WarShowArmy(336);
 DrawStrBoxCenter("出现敌人伏兵．");
 talk( 1,"果然如孔明所料．大家要镇静，不要惊慌，敌人出现一批就打垮他一批．");
 SetFlag(1056,1);
 end
 if (not GetFlag(1057)) and War.Turn==10 then
 WarShowArmy(342);
 WarShowArmy(343);
 WarShowArmy(337);
 DrawStrBoxCenter("出现敌人伏兵．");
 talk( 1,"还有埋伏的敌兵．夏侯德真会用兵．");
 SetFlag(1057,1);
 end
 if (not GetFlag(1058)) and War.Turn==15 then
 WarShowArmy(332);
 WarShowArmy(333);
 WarShowArmy(338);
 DrawStrBoxCenter("出现敌人伏兵．");
 talk( 1,"怎么还有伏兵？究竟埋伏了多少伏兵？");
 SetFlag(1058,1);
 end
 if WarMeet(203,211) then
 WarAction(1,203,211);
 talk( 203,"来将是夏侯德吗？我严颜要与你单挑．",
 211,"你这个老家伙，胆敢侵略我国，我绝不饶你！");
 WarAction(6,203,211);
 if fight(203,211)==1 then
 talk( 203,"看招！");
 WarAction(4,203,211);
 talk( 211,"噢，不好．招架不住了．",
 203,"敌人露出了破绽．");
 WarAction(8,203,211);
 talk( 211,"啊……");
 WarAction(18,211);
 talk( 203,"我杀死了敌将夏侯德．");
 WarLvUp(GetWarID(203));
 PlayBGM(7);
 DrawMulitStrBox("　严颜杀死了夏侯德，曹操军败退了．");
 SetFlag(902,0); --夏侯德死亡
 NextEvent();
 else
 WarAction(4,211,203);
 talk( 203,"噢，不好．招架不住了．");
 WarAction(17,203);
 WarLvUp(GetWarID(211));
 end
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("　刘备军打败了夏侯德率领的曹操军．");
 NextEvent();
 end
 WarLocationItem(5,15,40,53); --获得道具:获得道具：海啸书
 WarLocationItem(13,20,33,54); --获得道具:获得道具：米
 WarLocationItem(5,29,30,55); --获得道具:获得道具：老酒
 WarLocationItem(13,28,25,56); --获得道具:获得道具：近卫铠
 end,
 [531]=function()
 SetFlag(57,1);
 GetMoney(1300);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金１３００．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [532]=function()
 JY.Smap={};
 JY.Base["现在地"]="葭萌关";
 JY.Base["道具屋"]=0;
 AddPerson(1,8,18,0);
 AddPerson(126,8,15,0);
 if not GetFlag(38) then
 AddPerson(133,14,18,0);
 end
 AddPerson(3,11,11,3);
 AddPerson(190,13,10,3);
 AddPerson(54,21,17,2);
 AddPerson(170,23,16,2);
 SetSceneID(97,12);
 DrawStrBoxCenter("葭萌关营帐");
 talk( 126,"主公，打败了敌军，士气正旺．乘此时机一举攻下汉中．汉中的路上还有定军山、天荡山和汉水，都有敌将把守．",
 126,"那么，我们是进攻定军山还是进攻天荡山，请主公选择．定军山由夏侯渊把守，天荡山由徐晃把守．");
 --显示任务目标:<请选择是进攻定军山还是进攻天荡山．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [533]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，究竟进攻那里，请赶快决定吧．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"定军山、天荡山都是险山峻岭，要进攻需要注意选择适合山地作战的部队．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"主公，快下决心吧．管他是徐晃还是夏侯渊，我都能把他们砍落马下．");
 end
 if JY.Tid==190 then--马超
 talk( 190,"我曾与徐晃交过手，他是个厉害的对手．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"天荡山有徐晃，定军山有夏侯渊．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"究竟进攻那一个，决定了吗？") then
 RemindSave();
 DrawSMap();
 local menu={
 {"进攻定军山",nil,1},
 {"进攻天荡山",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 126,"遵命．那就进攻定军山．");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
 talk( 79,"蜀军进攻定军山了，快去支援夏侯渊．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(); --goto 534
 elseif r==2 then
 talk( 126,"遵命．那就进攻天荡山．");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
 talk( 18,"蜀军进攻天荡山了，快去支援徐晃．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(547); --goto 547
 end
 end
 end
 end,
 [534]=function()
 SetSceneID(0);
 talk( 126,"请编排部队．");
 WarIni();
 DefineWarMap(39,"第三章 定军山之战","一、夏侯渊的溃灭",35,0,17);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,6,16, 2,0,-1,0,
 -1,5,15, 2,0,-1,0,
 -1,7,15, 2,0,-1,0,
 -1,7,17, 2,0,-1,0,
 -1,6,17, 2,0,-1,0,
 -1,5,17, 2,0,-1,0,
 -1,5,16, 2,0,-1,0,
 -1,9,15, 2,0,-1,0,
 -1,8,16, 2,0,-1,0,
 -1,9,17, 2,0,-1,0,
 -1,4,14, 2,0,-1,0,
 -1,4,15, 2,0,-1,0,
 -1,4,17, 2,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 17,30,0, 1,4,50,22, 33,12,-1,0,
 102,34,1, 1,4,49,22, 27,14,-1,0,
 209,33,3, 1,4,48,21, 25,12,-1,0,
 36,14,7, 3,0,42,12, 0,0,-1,0,
 256,15,6, 3,0,41,3, 0,0,-1,0,
 257,35,4, 1,4,41,3, 25,14,-1,0,
 292,16,7, 3,0,45,9, 0,0,-1,0,
 293,33,1, 1,4,45,9, 30,8,-1,0,
 294,37,0, 1,4,44,9, 29,7,-1,0,
 295,32,0, 1,4,44,9, 31,13,-1,0,
 274,15,8, 3,0,39,6, 0,0,-1,0,
 340,35,2, 1,4,40,17, 28,8,-1,0,
 341,34,2, 1,4,40,17, 29,9,-1,0,
 342,36,1, 1,4,40,17, 26,13,-1,0,
 
 336,36,3, 1,4,43,15, 30,15,-1,0,
 299,34,0, 1,4,44,9, 32,9,-1,0,
 300,31,1, 1,4,44,9, 29,14,-1,0,
 301,32,3, 1,4,45,9, 24,14,-1,0,
 78,1,6, 4,3,49,9, 0,0,-1,1,
 251,4,7, 4,1,42,3, 0,0,-1,1,
 296,4,5, 4,1,45,9, 0,0,-1,1,
 297,2,7, 4,1,44,9, 0,0,-1,1,
 298,0,7, 4,1,44,9, 0,0,-1,1,
 258,2,5, 4,1,39,3, 0,0,-1,1,
 275,3,6, 4,1,39,6, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [535]=function()
 PlayBGM(11);
 talk( 18,"不能让刘备夺取汉中．竭尽全力制止刘备的进攻．");
 WarShowTarget(true);
 SetFlag(901,1); --夏侯渊存活，默认
 PlayBGM(9);
 NextEvent();
 end,
 [536]=function()
 if WarMeet(170,18) then
 WarAction(1,170,18);
 talk( 170,"来将像是夏侯渊．我黄忠来单挑结果你！",
 18,"你这帮蜀国乡巴佬，胆敢犯我疆土，看我大刀！",
 170,"我黄忠宝刀未老，你就做我的刀下鬼吧．");
 WarAction(6,170,18);
 if fight(170,18)==1 then
 talk( 170,"吃这一刀！");
 WarAction(8,170,18);
 talk( 18,"不好！哎哟……");
 WarAction(18,18);
 talk( 170,"我杀死了敌将夏侯渊．");
 WarLvUp(GetWarID(170));
 PlayBGM(7);
 DrawMulitStrBox("　黄忠杀死了夏侯渊，*　刘备军占领了定军山．");
 SetFlag(901,0); --夏侯渊死亡
 NextEvent();
 else
 WarAction(4,18,170);
 talk( 170,"不好！哎哟……");
 WarAction(17,170);
 WarLvUp(GetWarID(18));
 end
 end
 if (not GetFlag(1059)) and War.Turn==8 then
 talk( 1,"嗯，这些兵是……？");
 PlayBGM(11);
 WarModifyAI(17,3,0);
 WarModifyAI(102,3,0);
 WarModifyAI(209,3,0);
 WarModifyAI(36,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(294,1);
 WarModifyAI(295,1);
 WarModifyAI(274,1);
 WarModifyAI(340,1);
 WarModifyAI(341,1);
 WarModifyAI(342,1);
 WarModifyAI(256,1);
 WarModifyAI(257,1);
 WarModifyAI(336,1);
 WarModifyAI(299,1);
 WarModifyAI(300,1);
 WarModifyAI(301,1);
 WarShowArmy(78);
 WarShowArmy(251);
 WarShowArmy(296);
 WarShowArmy(297);
 WarShowArmy(298);
 WarShowArmy(258);
 WarShowArmy(275);
 DrawStrBoxCenter("敌人援军出现了．");
 talk( 79,"夏侯渊将军，我来帮你把刘备赶出定军山．",
 252,"……",
 18,"噢，徐晃你来了．好，全军向刘备军冲锋！我军要夹击刘备军．");
 PlayBGM(9);
 SetFlag(1059,1);
 end
 if (not GetFlag(134)) and WarMeet(1,252) then
 WarAction(1,1,252);
 PlayBGM(11);
 talk( 252,"刘备大人，我想向刘备军投降，请收容我．");
 ModifyForce(252,1);
 PlayWavE(11);
 DrawStrBoxCenter("王平倒戈了．");
 SetFlag(134,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("　刘备军占领了定军山．");
 NextEvent();
 end
 if (not GetFlag(206)) and WarCheckLocation(-1,12,14) then
 GetMoney(800);
 PlayWavE(11);
 DrawStrBoxCenter("获得黄金８００．");
 SetFlag(206,1);
 end
 WarLocationItem(3,21,2,205); --获得道具:获得道具：青囊书
 WarLocationItem(4,23,151,207); --获得道具:获得道具：山洪书 改为 151无敌神牌
 end,
 [537]=function()
 GetMoney(1300);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金１３００．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [538]=function()
 JY.Smap={};
 SetSceneID(0,3);
 talk( 126,"这样，只要渡过汉水就可以占领汉中了，可是……");
 SetSceneID(0,11);
 talk( 9,"刘备小儿，趁我不在偷袭汉中，我绝不饶你！",
 212,"父亲，我来帮你．",
 9,"噢，曹彰，如果有敌人进攻汉水，你就去支援那里．我在阳平关观察敌人的动静．",
 212,"是．");
 NextEvent();
 end,
 [539]=function()
 JY.Smap={};
 JY.Base["现在地"]="定军山";
 JY.Base["道具屋"]=0;
 AddPerson(1,8,18,0);
 AddPerson(126,8,15,0);
 if not GetFlag(38) then
 AddPerson(133,14,18,0);
 end
 AddPerson(3,11,11,3);
 AddPerson(190,13,10,3);
 AddPerson(54,21,17,2);
 AddPerson(170,23,16,2);
 SetSceneID(97,12);
 DrawStrBoxCenter("定军山营帐");
 if GetFlag(57) then
 talk( 126,"那就进攻汉水吧．请做好进攻汉水的准备．");
 --显示任务目标:<做进攻汉水的准备．>
 else
 talk( 126,"那么，是进攻天荡山还是进攻汉水，请主公定夺．汉水是由曹洪把守，天荡山是由夏侯德把守．");
 --显示任务目标:<请决定是进攻天荡山，还是进攻汉水．>
 end
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [540]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，快出征吧．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"听说汉水是有条大河的平原，可以集结快速部队．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"主公，快出发吧．");
 end
 if JY.Tid==190 then--马超
 talk( 190,"我与曹洪交过几次手，这个家伙脾气暴躁．");
 end
 if JY.Tid==133 then--庞统
 if GetFlag(57) then
 talk( 133,"汉水是由曹洪把守．");
 else
 talk( 133,"汉水有曹洪，天荡山有夏侯德把守．");
 end
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 DrawSMap();
 local menu={
 {"进攻天荡山",nil,1},
 {" 进攻汉水",nil,1}
 }
 if GetFlag(57) then
 talk( 126,"那就进攻汉水．");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
 talk( 212,"什么，刘备进攻汉水？我们快去支援那里．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(554); --goto 554
 else
 talk( 126,"究竟进攻那里，请选择．");
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 126,"明白了．那么向天荡山进发．");
 JY.Smap={};
 SetSceneID(0,3);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(); --goto 541
 elseif r==2 then
 talk( 126,"是，进攻汉水．");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
 talk( 212,"什么，刘备进攻汉水？我们快去支援那里．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(554); --goto 554
 end
 end
 end
 end
 end,
 [541]=function()
 SetSceneID(0);
 talk( 126,"请列队．");
 WarIni();
 DefineWarMap(40,"第三章 天荡山I之战","一、歼灭夏侯德",40,0,210);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,4,5, 4,0,-1,0,
 -1,5,4, 4,0,-1,0,
 -1,5,6, 4,0,-1,0,
 -1,5,8, 4,0,-1,0,
 -1,3,4, 4,0,-1,0,
 -1,3,5, 4,0,-1,0,
 -1,3,6, 4,0,-1,0,
 -1,3,8, 4,0,-1,0,
 -1,6,5, 4,0,-1,0,
 -1,6,7, 4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 210,33,7, 3,1,52,20, 0,0,-1,0,
 256,33,6, 3,1,48,3, 0,0,-1,0,
 257,20,13, 3,1,44,3, 0,0,-1,0,
 274,31,5, 3,1,48,6, 0,0,-1,0,
 275,23,7, 3,1,45,6, 0,0,-1,0,
 296,21,5, 3,1,48,9, 0,0,-1,0,
 297,19,12, 3,1,46,9, 0,0,-1,0,
 298,20,11, 3,1,46,9, 0,0,-1,0,
 299,21,14, 3,1,45,9, 0,0,-1,0,
 292,21,12, 3,1,45,9, 0,0,-1,0,
 293,22,6, 3,1,45,6, 0,0,-1,0,
 294,30,6, 3,1,48,9, 0,0,-1,0,
 295,32,7, 3,1,45,9, 0,0,-1,0,
 310,31,7, 3,1,40,12, 0,0,-1,0,
 311,23,5, 3,1,43,12, 0,0,-1,0,
 300,22,13, 3,1,45,9, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [542]=function()
 PlayBGM(11);
 talk( 211,"让敌人占领天荡山，我军的粮草就没了！无论如何我们也要守住天荡山！",
 1,"敌人的兵力不多！一鼓作气攻下它！");
 WarShowTarget(true);
 SetFlag(902,1); --夏侯德存活，默认
 PlayBGM(9);
 NextEvent();
 end,
 [543]=function()
 if WarMeet(203,211) then
 WarAction(1,203,211);
 talk( 203,"夏侯德，我严颜要和你单挑！",
 211,"你这个老朽，胆敢侵占我们领土！杀呀！！");
 WarAction(6,203,211);
 if fight(203,211)==1 then
 talk( 203,"杀！");
 WarAction(4,203,211);
 talk( 211,"嗯、嗯……！不……好了！",
 203,"纳命来！");
 WarAction(8,203,211);
 talk( 211,"啊……！");
 WarAction(18,211);
 talk( 203,"敌将夏侯德，被我严颜杀了！！");
 WarLvUp(GetWarID(203));
 PlayBGM(7);
 DrawMulitStrBox("　严颜杀了夏侯德，曹操军败退了．");
 SetFlag(902,0); --夏侯德死亡
 NextEvent();
 else
 WarAction(4,211,203);
 talk( 203,"嗯、嗯……！不……好了！");
 WarAction(17,203);
 WarLvUp(GetWarID(211));
 end
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("　刘备军打败了夏侯德率领的曹操军．");
 NextEvent();
 end
 WarLocationItem(8,31,54,174); --获得道具:获得道具：中药
 end,
 [544]=function()
 GetMoney(1300);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１３００！");
 SetFlag(57,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [545]=function()
 JY.Smap={};
 JY.Base["现在地"]="天荡山";
 JY.Base["道具屋"]=0;
 AddPerson(1,8,18,0);
 AddPerson(126,8,15,0);
 if not GetFlag(38) then
 AddPerson(133,14,18,0);
 end
 AddPerson(3,11,11,3);
 AddPerson(190,13,10,3);
 AddPerson(54,21,17,2);
 AddPerson(170,23,16,2);
 SetSceneID(97,12);
 DrawStrBoxCenter("天荡山营帐");
 talk( 126,"再过了汉水就是汉中了．进军汉水．");
 --显示任务目标:<准备进军汉水．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [546]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，快出兵吧．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"听说汉水是个有一条大河的平原，可以集结快速部队．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"主公，快些出兵吧．");
 end
 if JY.Tid==190 then--马超
 talk( 190,"我和曹洪交过几次手，这个家伙脾气暴躁．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"汉水是曹洪把守．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 DrawSMap();
 talk( 126,"出发吧．");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
 talk( 212,"什么，刘备军到了汉水？我们马上去汉水．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(554); --goto 554
 end
 end
 end,
 [547]=function()
 SetSceneID(0);
 talk( 126,"请列好队．");
 WarIni();
 DefineWarMap(40,"第三章 天荡山II之战","一、徐晃败退",40,0,78);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,4,5, 4,0,-1,0,
 -1,5,4, 4,0,-1,0,
 -1,5,6, 4,0,-1,0,
 -1,5,8, 4,0,-1,0,
 -1,3,4, 4,0,-1,0,
 -1,3,5, 4,0,-1,0,
 -1,3,6, 4,0,-1,0,
 -1,3,8, 4,0,-1,0,
 -1,6,5, 4,0,-1,0,
 -1,6,7, 4,0,-1,0,
 -1,2,5, 4,0,-1,0,
 -1,4,3, 4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 78,33,7, 3,2,52,9, 0,0,-1,0,
 251,21,12, 3,4,45,3, 19,12,-1,0,
 295,19,12, 3,1,46,9, 0,0,-1,0,
 296,20,11, 3,1,46,9, 0,0,-1,0,
 297,29,5, 3,4,45,9, 23,6,-1,0,
 298,30,6, 3,0,45,9, 0,0,-1,0,
 292,23,7, 3,4,46,9, 20,11,-1,0,
 293,22,13, 3,4,46,9, 20,14,-1,0,
 294,20,13, 3,1,46,9, 0,0,-1,0,
 256,21,14, 3,1,43,3, 0,0,-1,0,
 257,32,7, 3,0,42,3, 0,0,-1,0,
 310,21,5, 3,4,41,12, 19,11,-1,0,
 311,22,6, 3,4,40,12, 19,13,-1,0,
 336,31,7, 3,0,41,15, 0,0,-1,0,
 337,29,7, 3,4,40,15, 23,7,-1,0,
 
 332,23,5, 3,0,46,14, 0,0,-1,0,
 274,31,5, 3,0,45,6, 0,0,-1,0,
 275,33,6, 3,0,44,6, 0,0,-1,0,
 17,29,18, 3,1,50,22, 0,0,-1,1,
 102,28,19, 3,1,48,22, 0,0,-1,1,
 209,27,17, 3,1,48,21, 0,0,-1,1,
 36,16,1, 1,1,42,12, 0,0,-1,1,
 258,17,0, 1,1,43,3, 0,0,-1,1,
 259,28,17, 3,1,42,3, 0,0,-1,1,
 299,30,19, 3,1,46,9, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [548]=function()
 PlayBGM(11);
 talk( 79,"守不住这里，汉中也就丢了！将士们，无论如何得守住这个天荡山！");
 WarShowTarget(true);
 SetFlag(901,1); --夏侯渊存活,默认
 PlayBGM(9);
 NextEvent();
 end,
 [549]=function()
 WarLocationItem(8,31,54,175); --获得道具:获得道具：中药
 if (not GetFlag(134)) and WarMeet(1,252) then
 WarAction(1,1,252);
 PlayBGM(11);
 talk( 252,"刘皇叔，我遭徐晃忌恨，所以我想投降刘皇叔．今后请您多关照．");
 ModifyForce(252,1);
 PlayWavE(11);
 DrawStrBoxCenter("王平倒戈到这里！");
 SetFlag(134,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if (not GetFlag(1060)) and War.Turn==8 then
 talk( 1,"嗯！那莫非是？");
 PlayBGM(11);
 WarShowArmy(17);
 WarShowArmy(102);
 WarShowArmy(209);
 WarShowArmy(36);
 WarShowArmy(258);
 WarShowArmy(259);
 WarShowArmy(299);
 DrawStrBoxCenter("敌人援军出现了！");
 talk( 18,"救出徐晃！把刘备军赶出天荡山！",
 103,"刚才由于天意让你们占了便意，这次不会啦！刘备军，你们准备受死吧！",
 79,"呕！是夏侯渊！好，出击的时候到了！！全军，向刘备军突击！！");
 WarModifyAI(78,3,0);
 WarModifyAI(251,1,0);
 WarModifyAI(292,3,0);
 WarModifyAI(293,1);
 WarModifyAI(295,1);
 WarModifyAI(296,1);
 WarModifyAI(310,1);
 WarModifyAI(311,1);
 WarModifyAI(336,1);
 WarModifyAI(337,1);
 WarModifyAI(332,1);
 WarModifyAI(274,1);
 WarModifyAI(275,1);
 WarModifyAI(257,1);
 PlayBGM(9);
 SetFlag(1060,1);
 end
 if WarMeet(170,18) then
 WarAction(1,170,18);
 talk( 170,"喂，夏侯渊！我黄忠与你单挑！！",
 18,"你们这些乡巴佬，竟敢来抢占我们领土！我岂能饶你！",
 170,"哈哈，我黄忠虽已年迈，但还不至于败给你这鼠辈．");
 WarAction(6,170,18);
 if fight(170,18)==1 then
 talk( 170,"看刀！");
 WarAction(8,170,18);
 talk( 18,"啊……！！");
 WarAction(18,18);
 talk( 170,"我杀死了敌将夏侯渊！");
 WarLvUp(GetWarID(170));
 SetFlag(901,0); --夏侯渊死亡
 else
 WarAction(4,18,170);
 talk( 170,"不好！哎哟……");
 WarAction(17,170);
 WarLvUp(GetWarID(18));
 end
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("　刘备军占领了天荡山．");
 NextEvent();
 end
 end,
 [550]=function()
 GetMoney(1300);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１３００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [551]=function()
 JY.Smap={};
 SetSceneID(0,3);
 talk( 126,"这样，只要渡过汉水就可以占领汉中了，可是……");
 SetSceneID(0,11);
 talk( 9,"刘备小儿，趁我不在偷袭汉中，我绝不饶你！",
 212,"父亲，我来帮你．",
 9,"噢，曹彰，如果有敌人进攻汉水，你就去支援那里．我在阳平关观察敌人的动静．",
 212,"是．");
 NextEvent();
 end,
 [552]=function()
 JY.Smap={};
 JY.Base["现在地"]="天荡山";
 JY.Base["道具屋"]=0;
 AddPerson(1,8,18,0);
 AddPerson(126,8,15,0);
 if not GetFlag(38) then
 AddPerson(133,14,18,0);
 end
 AddPerson(3,11,11,3);
 AddPerson(190,13,10,3);
 AddPerson(54,21,17,2);
 AddPerson(170,23,16,2);
 SetSceneID(97,12);
 DrawStrBoxCenter("天荡山营帐");
 talk( 126,"曹操终于出来了．那么主公，我军进攻汉水吧．汉水是由曹洪把守．");
 --显示任务目标:<准备进军汉水．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [553]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，快出征吧．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"听说汉水是有条大河的平原，可以集结快速部队．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"主公，快出发吧．");
 end
 if JY.Tid==190 then--马超
 talk( 190,"我与曹洪交过几次手，这个家伙脾气暴躁．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"汉水是由曹洪把守．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 DrawSMap();
 talk( 126,"出发吧．");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
 talk( 212,"什么，刘备进攻汉水？我们快去支援那里．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [554]=function()
 SetSceneID(0);
 talk( 126,"请列好队．");
 WarIni();
 DefineWarMap(41,"第三章 汉水之战","一、曹洪的败退．",40,0,19);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,14,22, 4,0,-1,0,
 -1,2,16, 4,0,-1,0,
 -1,16,19, 4,0,-1,0,
 -1,2,13, 4,0,-1,0,
 -1,14,20, 4,0,-1,0,
 -1,3,14, 4,0,-1,0,
 -1,13,21, 4,0,-1,0,
 -1,2,15, 4,0,-1,0,
 -1,15,21, 4,0,-1,0,
 -1,1,16, 4,0,-1,0,
 -1,16,21, 4,0,-1,0,
 -1,3,17, 4,0,-1,0,
 -1,13,23, 4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 19,28,1, 3,0,54,25, 0,0,-1,0,
 17,27,3, 3,0,52,22, 0,0,901,0, --夏侯渊
 210,30,3, 3,0,52,20, 0,0,902,0, --夏侯德
 256,10,9, 3,4,47,3, 8,8,-1,0,
 257,23,13, 3,4,43,3, 21,15,-1,0,
 258,21,11, 3,4,43,3, 21,14,-1,0,
 259,26,10, 3,0,46,3, 0,0,-1,0,
 260,28,4, 3,0,42,3, 0,0,-1,0,
 292,11,9, 3,4,50,9, 9,9,-1,0,
 293,23,12, 3,4,47,9, 22,14,-1,0,
 294,25,9, 3,0,47,9, 0,0,-1,0,
 295,16,1, 3,0,50,9, 0,0,-1,0,
 274,9,8, 3,4,47,6, 8,9,-1,0,
 275,24,14, 3,4,43,6, 20,15,-1,0,
 276,21,12, 3,4,43,6, 20,14,-1,0,
 277,24,9, 3,0,46,6, 0,0,-1,0,
 
 301,15,0, 3,0,46,9, 0,0,-1,0,
 302,23,1, 3,0,46,9, 0,0,-1,0,
 278,12,11, 3,4,50,6, 9,10,-1,0,
 279,17,13, 4,4,50,6, 19,13,-1,0,
 348,13,10, 3,4,43,19, 10,9,-1,0,
 349,16,14, 4,4,42,19, 19,14,-1,0,
 211,29,1, 3,0,53,22, 0,0,-1,1,
 261,26,2, 3,0,46,3, 0,0,-1,1,
 280,27,4, 3,0,45,6, 0,0,-1,1,
 296,29,4, 3,0,50,9, 0,0,-1,1,
 297,29,3, 3,0,47,9, 0,0,-1,1,
 298,28,2, 3,0,50,9, 0,0,-1,1,
 299,27,1, 3,0,47,9, 0,0,-1,1,
 300,24,2, 3,0,47,9, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [555]=function()
 PlayBGM(11);
 talk( 20,"在这里阻住刘备军．万一这里失守，则汉中危矣！各位将军，一定要死守这里！");
 WarShowTarget(true);
 PlayBGM(16);
 NextEvent();
 end,
 [556]=function()
 if WarMeet(201,212) then
 WarAction(1,201,212);
 talk( 201,"我是蜀将吴兰！谁敢与我单挑？",
 201,"你能赢我吗？我来了．");
 WarAction(6,201,212);
 if fight(201,212)==1 then
 talk( 201,"这是……",
 212,"怎么了，不想打了？如果这样我曹彰就不杀你了．",
 201,"你是曹彰？那么你是曹操的儿子？",
 212,"正是．",
 201,"……好，我要取你首级立功！曹彰，接招！");
 WarAction(8,201,212);
 talk( 212,"噢……");
 WarAction(17,212);
 talk( 201,"哼，胜得太容易了．还有没有人敢与我交手？");
 WarLvUp(GetWarID(201));
 else
 talk( 201,"这是……",
 212,"怎么了，不想打了？如果这样我曹彰就不杀你了．",
 201,"你是曹彰？那么你是曹操的儿子？",
 212,"正是．",
 201,"……好，我要取你首级立功！曹彰，接招！");
 WarAction(5,201,212);
 WarAction(5,201,212);
 talk( 212,"哈哈哈．你这点本事还能赢我？该我了，接招！");
 WarAction(8,212,201);
 talk( 201,"噢……",
 212,"吓傻了吧．我的本事还没完全使出来呢．",
 201,"……看来是胜不了他了……真不该轻敌．没办法，撤吧．");
 WarAction(17,201);
 talk( 212,"哼，胜得太容易了．还有没有人敢与我交手？");
 WarLvUp(GetWarID(212));
 end
 end
 if (not GetFlag(1061)) and War.Turn==10 then
 talk( 20,"刘备小儿，的确厉害……嗯？！");
 PlayBGM(11);
 WarShowArmy(211);
 WarShowArmy(261);
 WarShowArmy(280);
 WarShowArmy(296);
 WarShowArmy(297);
 WarShowArmy(298);
 WarShowArmy(299);
 WarShowArmy(300);
 DrawStrBoxCenter("敌人援军出现了！");
 talk( 212,"不能让蜀军再猖狂了．我来让你们知道我的厉害！",
 20,"噢，曹彰公子来了．哼，刘备小儿，我要报仇了．");
 PlayBGM(9);
 SetFlag(1061,1);
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 DrawMulitStrBox("　刘备军打败了曹洪率领的曹操军．");
 NextEvent();
 end
 WarLocationItem(0,14,55,85); --获得道具:获得道具：茶
 if (not GetFlag(86)) and WarCheckLocation(-1,14,23) then
 GetMoney(1000);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１０００！");
 SetFlag(86,1);
 end
 end,
 [557]=function()
 GetMoney(1300);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金１３００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [558]=function()
 SetSceneID(0,11);
 talk( 9,"唉……既然如此，在阳平关迎击敌人！");
 NextEvent();
 end,
 [559]=function()
 JY.Smap={};
 JY.Base["现在地"]="汉水";
 JY.Base["道具屋"]=0;
 AddPerson(1,8,18,0);
 AddPerson(126,8,15,0);
 if not GetFlag(38) then
 AddPerson(133,14,18,0);
 end
 AddPerson(3,11,11,3);
 AddPerson(190,13,10,3);
 AddPerson(54,21,17,2);
 AddPerson(170,23,16,2);
 SetSceneID(97,12);
 DrawStrBoxCenter("汉水营帐");
 talk( 126,"主公，曹操到阳平关以后好像就不前进了．咱们进军阳平关吧．");
 --显示任务目标:<准备进军阳平关．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [560]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，只要拿下阳平关，汉中就是我们的了．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"曹操军此次前来，其阵容之强大前所未见，咱们要当心．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"主公，我还是很有用的，到时候看我的吧．");
 end
 if JY.Tid==190 then--马超
 talk( 190,"我要亲手取曹操的首级，主公，请派我出征吧．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"阳平关是天险，易守难攻，我们派精锐去那里吧．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 DrawSMap();
 talk( 126,"请编队．");
 WarIni();
 DefineWarMap(42,"第三章 阳平关之战","一、曹操的败退",45,0,8);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,33,8, 3,0,-1,0,
 -1,32,7, 3,0,-1,0,
 -1,33,7, 3,0,-1,0,
 -1,34,10, 3,0,-1,0,
 -1,34,8, 3,0,-1,0,
 -1,33,9, 3,0,-1,0,
 -1,32,6, 3,0,-1,0,
 -1,33,5, 3,0,-1,0,
 -1,35,7, 3,0,-1,0,
 -1,34,13, 3,0,-1,0,
 -1,35,12, 3,0,-1,0,
 -1,33,11, 3,0,-1,0,
 -1,34,11, 3,0,-1,0,
 -1,35,9, 3,0,-1,0,
 });
 DrawSMap();
 talk( 126,"在阳平关击溃曹操！");
 JY.Smap={};
 SetSceneID(0,3);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 8,2,3, 1,2,58,9, 0,0,-1,0,
 386,1,3, 1,3,57,15, 8,0,-1,0, --典韦S
 17,6,8, 4,0,55,22, 0,0,901,0, --夏侯渊
 210,2,4, 1,0,55,20, 0,0,902,0, --夏侯德
 209,1,4, 1,0,54,21, 0,0,-1,0, --夏侯尚
 78,5,4, 1,0,55,9, 0,0,-1,0,
 67,3,4, 1,0,54,9, 0,0,-1,0,
 102,17,13, 4,0,55,22, 0,0,-1,0,
 16,7,9, 4,0,55,9, 0,0,-1,0,
 19,4,6, 1,0,54,25, 0,0,-1,0,
 211,13,13, 4,0,54,22, 0,0,-1,0,
 250,8,12, 4,0,53,19, 0,0,-1,0,
 215,18,14, 4,0,53,9, 0,0,-1,0,
 213,1,5, 1,0,53,16, 0,0,-1,0,
 274,5,5, 1,0,45,6, 0,0,-1,0,
 275,2,6, 1,0,45,6, 0,0,-1,0,
 276,4,4, 1,0,48,6, 0,0,-1,0,
 277,6,9, 4,0,48,6, 0,0,-1,0,
 
 278,9,13, 4,0,47,6, 0,0,-1,0,
 279,18,12, 4,0,47,6, 0,0,-1,0,
 280,19,13, 4,0,47,6, 0,0,-1,0,
 293,12,12, 4,0,49,9, 0,0,-1,0,
 256,3,7, 1,0,45,3, 0,0,-1,0,
 257,5,3, 1,0,45,3, 0,0,-1,0,
 258,7,8, 4,0,47,3, 0,0,-1,0,
 259,20,12, 4,0,47,3, 0,0,-1,0,
 260,12,14, 4,0,47,3, 0,0,-1,0,
 292,9,11, 4,0,49,9, 0,0,-1,0,
 336,3,6, 1,0,45,15, 0,0,-1,0,
 294,3,3, 1,0,48,9, 0,0,-1,0,
 281,11,13, 4,0,45,6, 0,0,-1,0,
 348,2,5, 1,0,44,19, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [561]=function()
 PlayBGM(11);
 talk( 9,"大胆的刘备！你竟敢背叛汉朝！我曹操要把你千刀万剐！",
 1,"住口！你欺辱皇帝，侮辱汉朝，是想取而代之吧．你才是叛逆，你才该千刀万剐．");
 WarShowTarget(true);
 PlayBGM(10);
 NextEvent();
 end,
 [562]=function()
 if WarMeet(190,216) then
 if GetFlag(176) then
 talk( 190,"庞德！再好好想一下．",
 216,"……不要再说了．战斗吧．");
 else
 WarAction(1,190,216);
 talk( 190,"庞德，你不是庞德吗？你还活着．",
 216,"……马超将军……",
 190,"为什么你在曹操军中？",
 216,"你离开张鲁投奔刘备后，曹……曹丞相进攻汉中……",
 190,"曹丞相？你怎么会……",
 216,"是的．我投降了曹丞相，现在是曹军中的一员．",
 190,"什么！你怎么如此糊涂？你不知道曹操的恶行吗？",
 216,"……我被张鲁疑忌．在走投无路之时，曹丞相热情欢迎我，还委我以重任．……此恩不报，我义气又何在呢？",
 190,"你胡说什么？现在你要重新开始．怎么样，与我一起去见刘皇叔吧．",
 216,"……马超将军，过去我虽是您的部下，但现在却是敌人，你怎么说都没用，还是与我战斗吧．",
 190,"你这个糊涂虫！");
 WarAction(6,190,216);
 if fight(190,216)==1 then
 talk( 190,"庞德，你再想一下．",
 216,"不要再说了．……马超将军，再见．",
 190,"庞德，等一下！");
 --WarAction(16,216);
 talk( 190,"庞德……");
 WarLvUp(GetWarID(190));
 SetFlag(176,1);
 else
 WarAction(4,216,190);
 talk( 190,"庞德……");
 WarAction(17,190);
 WarLvUp(GetWarID(216));
 end
 end
 end
 if (not GetFlag(145)) and WarCheckArea(-1,6,20,15,25) then
 talk( 103,"好，让我当先锋，我一定不辜负曹丞相的厚望，冲啊！",
 216,"是．",
 212,"不要落在张颌后面．我们也往前冲！",
 17,"快要开战了，我们再向前一些，以便及早投入战斗．");
 WarModifyAI(78,4,6,8);
 WarModifyAI(16,4,10,12);
 WarModifyAI(17,4,9,11); --夏侯渊
 WarModifyAI(19,4,6,9);
 WarModifyAI(250,4,13,12);
 WarModifyAI(292,4,13,14);
 WarModifyAI(256,4,7,8);
 WarModifyAI(258,4,9,13);
 WarModifyAI(277,4,11,11);
 WarModifyAI(278,4,13,13);
 WarModifyAI(102,1);
 WarModifyAI(211,1);
 WarModifyAI(215,1);
 WarModifyAI(259,1);
 WarModifyAI(260,1);
 WarModifyAI(279,1);
 WarModifyAI(280,1);
 WarModifyAI(293,1);
 WarModifyAI(281,1);
 SetFlag(145,1);
 end
 if (not GetFlag(146)) and WarCheckArea(-1,6,3,11,8) then
 talk( 214,"妈的，刘备．不能让他们再靠近阳平关．大家跟我来！",
 126,"主公，这夥敌人中有个叫司马懿的，据说相当有才干，对他要当心．");
 WarModifyAI(67,1);
 WarModifyAI(210,1); --夏侯德
 WarModifyAI(209,1); --夏侯尚
 WarModifyAI(213,1);
 WarModifyAI(257,1);
 WarModifyAI(276,1);
 WarModifyAI(274,4,3,4);
 WarModifyAI(275,4,2,4);
 WarModifyAI(294,1);
 WarModifyAI(348,1);
 WarModifyAI(336,1);
 SetFlag(146,1);
 end
 WarLocationItem(10,14,18,208); --获得道具:获得道具：马术指南书
 if JY.Status==GAME_WARWIN then
 talk( 9,"唉……没办法，撤回长安．");
 PlayBGM(7);
 DrawMulitStrBox("　曹操放弃了汉中，刘备占领了汉中．");
 NextEvent();
 end
 end,
 [563]=function()
 GetMoney(1300);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金１３００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [564]=function()
 SetSceneID(0,11);
 talk( 9,"撤回长安．刘备，我会再找你算这次和赤壁那笔帐的！");
 SetSceneID(0,3);
 talk( 126,"主公，终于占领了汉中，恭喜．那么，进汉中城吧．");
 NextEvent();
 end,
 [565]=function()
 JY.Smap={};
 JY.Base["现在地"]="汉中";
 JY.Base["道具屋"]=0;
 AddPerson(1,9,16,0);
 AddPerson(126,9,13,0);
 if not GetFlag(38) then
 AddPerson(133,15,16,0);
 end
 AddPerson(3,10,9,3);
 AddPerson(190,12,8,3);
 AddPerson(54,24,16,2);
 AddPerson(170,26,15,2);
 --AddPerson(369,19,11,1);
 SetSceneID(52,5);
 DrawStrBoxCenter("汉中议事厅");
 talk( 126,"主公，您终于得到了汉中，这样我三分天下的战略就实现了．这也是您实力的表现．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [566]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，恭喜你．我高兴得……");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"我从很久以前就跟随主公，可是这么高兴还是第一次．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"主公，您给我这个老朽留下了如此辉煌的回忆，太谢谢了．");
 end
 if JY.Tid==190 then--马超
 talk( 190,"主公，恭喜您把曹操赶出了汉中，也雪了家父之恨．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"这样，魏、蜀、吴三足鼎立之势就形成了．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公，请进位汉中王．",
 1,"什么？汉中王？……不行，这可不行．",
 126,"……主公介意的是名分吧．可是您如果不称王，我们这些文臣武将可绝不答应．",
 1,"这……",
 126,"我们这些部下都跟随您多年，都希望您能够有强大的实力，就像现在这样．如果您不想称王，就等于说您不想再强大了，那我们跟随您还有什么意义呢？",
 1,"……",
 126,"而且，听说曹操已经自立为魏王，为了能与曹操对抗，以示天下，也要请主公同意进位汉中王．",
 1,"……",
 126,"您决定后，请告诉我．");
 NextEvent();
 end
 end,
 [567]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥在汉中称王，二哥在荆州也会高兴了．大哥你就同意称汉中王吧．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"大家都同意您称王，我更是不例外．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"主公，您就同意称汉中王吧，就别让老臣空等了．");
 end
 if JY.Tid==190 then--马超
 talk( 190,"不能默认曹操称魏王，主公称汉中王也是为了对抗曹操．");
 end
 if JY.Tid==133 then--庞统
 talk( 133,"主公，即使您称了汉中王，也不是什么大不了的事．您就不要推辞了．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"您决定称汉中王了吗？") then
 talk( 126,"噢，您同意了！",
 1,"唉……我当汉中王．诸位，这样行吗？",
 3,"谁会反对呢？啊，大家都赞成．",
 54,"大家当然都赞成．请汉中王今后多关照我们．",
 170,"汉中王万岁！",
 190,"恭喜您．家父在九泉之下，也会高兴的．");
 if not GetFlag(38) then
 talk( 133,"我们会更忠心地跟随您．");
 end
 PlayBGM(8);
 DrawMulitStrBox("　刘备从曹操手里夺取了汉中．这样，刘备据有了荆州、益州和汉中，成为强大的蜀之主．孔明在隆中为刘备设计的魏、蜀、吴三分天下之计成功了．从此，刘备做了汉中王．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 else
 talk( 126,"主公，请下决心吧．这不光为您自己，也是为大家．");
 end
 end
 end,
 [568]=function()
 SetSceneID(-1,11);
 JY.Base["章节名"]="第三章　蜀汉建国";
 DrawStrBoxCenter("第三章　蜀汉建国");
 ModifyForce(2,1);
 ModifyForce(128,1);
 ModifyForce(155,1);
 ModifyForce(38,1);
 ModifyForce(34,1);
 ModifyForce(39,1);
 LoadPic(23,1);
 DrawMulitStrBox("　曹操在听说刘备自立为汉中王后，马上派使者拜见吴主孙权，想与东吴共同出兵夺取关羽守卫的荆州．*　孙权接受了曹操的建议．这就是魏吴同盟．");
 LoadPic(23,2);
 LoadPic(24,1);
 DrawMulitStrBox("　曹操的动向很快被孔明知道了．根据孔明的策画，关羽去攻打曹仁把守的樊城．*　然而就在关羽即将拿下樊城时，东吴的吕蒙和陆逊趁虚占领了荆州和江陵．");
 DrawMulitStrBox("　关羽想夺回江陵，但在遭到吕蒙和曹仁的两面夹击后，连襄阳也被曹仁夺走了．*　无立身之地的关羽在襄阳附近的麦城处于极端危险的境地．");
 LoadPic(24,2);
 LvUp(2,10);
 LvUp(128,9);
 LvUp(155,9);
 WarIni();
 DefineWarMap(45,"第三章 麦之战","一、全歼敌人．*二、关羽到达西面鹿砦．",50,1,-1);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 1,20,8, 3,0,-1,0,
 127,19,8, 3,0,-1,0,
 154,20,9, 3,0,-1,0,
 33,21,7, 3,0,-1,0,
 37,20,7, 3,0,-1,0,
 38,22,8, 3,0,-1,0,
 });
 ModifyForce(256+1,9);
 ModifyForce(274+1,9);
 ModifyForce(292+1,9);
 ModifyForce(293+1,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 148,3,3, 4,0,52,20, 0,0,-1,0,
 161,16,13, 4,0,48,3, 0,0,-1,0,
 162,7,16, 4,0,48,9, 0,0,-1,0,
 44,7,4, 4,0,47,3, 0,0,-1,0,
 173,15,12, 4,0,47,25, 0,0,-1,0,
 150,8,5, 4,0,47,16, 0,0,-1,0,
 45,6,15, 4,0,47,3, 0,0,-1,0,
 18,30,7, 3,1,52,3, 0,0,-1,1,
 83,31,7, 3,1,48,21, 0,0,-1,1,
 28,27,6, 3,1,47,6, 0,0,-1,1,
 32,26,7, 3,1,47,6, 0,0,-1,1,
 78,29,6, 3,1,48,9, 0,0,-1,1,
 256,30,8, 3,1,44,3, 0,0,-1,1,
 274,25,5, 3,1,45,6, 0,0,-1,1,
 292,24,6, 3,1,45,9, 0,0,-1,1,
 293,28,7, 3,1,44,9, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [569]=function()
 PlayBGM(11);
 talk( 39,"关羽将军，现在没别的办法，只有退回成都以求东山再起．到那时再让他们交还荆州．",
 38,"即使我们都死了，关羽将军也要逃出去．只要能逃到西面的鹿砦就没事了．",
 128,"曹操军马上就要追来了．父亲，快离开这片树林吧．",
 155,"我一定拼死护卫您！",
 2,"唉……，大家都不能死，要活着离开这里！",
 149,"不能让他们活着逃离树林．否则我们就动不了手了．一定要在他们离开树林前消灭他们！");
 WarShowTarget(true);
 PlayBGM(16);
 NextEvent();
 end,
 [570]=function()
 if (not GetFlag(1062)) and War.Turn==2 then
 talk( 2,"嗯！追兵来了！");
 WarShowArmy(18);
 WarShowArmy(83);
 WarShowArmy(28);
 WarShowArmy(32);
 WarShowArmy(78);
 WarShowArmy(256);
 WarShowArmy(274);
 WarShowArmy(292);
 WarShowArmy(293);
 DrawStrBoxCenter("曹操军出现了！");
 talk( 19,"不能让吴把功劳抢走了，关羽的首级就由我们来取吧！",
 149,"那可不行．关羽的首级要由吴来取！");
 SetFlag(1062,1);
 end
 WarLocationItem(14,16,49,209); --获得道具:获得道具：援军书
 WarLocationItem(17,9,55,210); --获得道具:获得道具：茶
 WarLocationItem(8,7,49,211); --获得道具:获得道具：援军书
 if JY.Status==GAME_WARLOSE then
 PlayBGM(4);
 talk( 2,"兄长，自从桃园结义以来，我一直跟随着你．可是今天我命将休矣．请你替我实现没能完成的梦想．……兄长，三弟，永别了！");
 DrawMulitStrBox("　关羽被活捉后斩首．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if WarCheckLocation(1,3,0) then
 talk( 149,"完了！被关羽逃走了，这样将后患无穷．决不能让关羽跑掉！");
 PlayBGM(2);
 DrawMulitStrBox("　关羽逃离了战场．");
 SetFlag(58,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 talk( 2,"趁敌人援军还没赶到之前，快走．");
 PlayBGM(7);
 DrawMulitStrBox("　关羽逃离了战场．");
 SetFlag(58,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [571]=function()
 ModifyForce(2,0);
 ModifyForce(128,0);
 ModifyForce(155,0);
 ModifyForce(38,0);
 ModifyForce(34,0);
 ModifyForce(39,0);
 ModifyForce(256+1,0);
 ModifyForce(274+1,0);
 ModifyForce(292+1,0);
 ModifyForce(293+1,0);
 NextEvent();
 end,
 [572]=function()
 JY.Smap={};
 JY.Base["现在地"]="邺";
 JY.Base["道具屋"]=0;
 AddPerson(20,21,13,2);
 AddPerson(94,19,14,2);
 AddPerson(213,17,15,2);
 AddPerson(214,15,16,2);
 AddPerson(387,23,14,2);
 AddPerson(239,21,15,2);
 AddPerson(212,19,16,2);
 AddPerson(242,17,17,2);
 SetSceneID(82,11);
 DrawMulitStrBox("　后来，曹操生病的消息传得到处都知道了．……这里是邺城曹操的官邸．");
 DrawStrBoxCenter("邺城曹操官邸");
 talk( 9,"……要统一天下谈何容易啊．我拥有如此强大的实力……也没有做到．",
 20,"您说什么，不要气馁啊．",
 9,"我快不行了．我死以后，……曹丕继承我的位子．曹丕，到这里来．",
 213,"是．");
 MovePerson(213,2,2);
 talk( 9,"你来继承我的位子．我死以后，吴蜀必然要发生冲突，这时你千万不要轻举妄动．等他们分出胜负后，再慢慢收拾那个胜利的国家．你一定要记住，千万不要做错！否则灭亡的是我们．",
 213,"我记住了．我一定不辜负父亲厚望．",
 9,"……如果你做错了，我不会放过你．我会从阴曹地府中回来找你的．",
 213,"是！是！",
 9,"唉，……那我就放心地去了．各位，多保重……");
 talk( 94,"主公！呜呜……",
 214,"……");
 MovePerson(213,1,3);
 talk( 213,"那么从今天起，国家就由我来执掌．你们要像对我父亲那样向我尽忠．",
 20,"是．");
 LoadPic(25,1);
 DrawMulitStrBox("　随后，继承父亲曹操之位的曹丕实现了他的篡位野心．*　献帝被废除后流放了．汉朝到此就灭亡了，从而结束了其长达四个世纪的历史．");
 LoadPic(25,2);
 NextEvent();
 end,
 [573]=function()
 JY.Smap={};
 JY.Base["现在地"]="成都";
 JY.Base["道具屋"]=21;
 AddPerson(1,6,7,3);
 AddPerson(126,12,8,3);
 AddPerson(3,19,9,1);
 AddPerson(54,9,14,0);
 SetSceneID(56,5);
 DrawStrBoxCenter("成都宫殿");--成都议事厅
 DrawMulitStrBox("　关羽情况危急的消息已经传到了蜀的首府成都．由于刘备得到消息后举棋不定，以致造成了关羽败走麦城的恶果．");
 AddPerson(365,37,23,2);
 MovePerson(365,11,2);
 PlayBGM(2);
 talk( 365,"禀报主公，大势不好！关羽被吕蒙打败，关将军据说已被害．",
 1,"什么！……",
 3,"你这个混蛋，不许胡说，二哥不会死．",
 365,"可，可是这是千真万确的事实……");
 MovePerson(3,2,1);
 talk( 3,"关羽绝不会死！那不可能，那不可能……");
 MovePerson(3,2,2);
 talk( 3,"大哥，你也这么认为吧．",
 1,"……",
 3,"大哥，你就说是这么想的吧……东吴狗贼，竟敢对二哥……",
 1,"张飞……我与你一样，但是现在需要冷静．",
 3,"东吴狗贼，我要让你们付出代价！",
 1,"什么……关羽……这不是真的……",
 365,"那我先退下去了．");
 MovePerson(3,2,3);
 MovePerson(3,2,0);
 MovePerson(3,0,1);
 MovePerson(365,12,3);
 DecPerson(365);
 talk( 1,"关羽……你怎么能这样就……我们不是对天起过誓吗？你怎么这么快就去了？……");
 AddPerson(369,37,23,2);
 MovePerson(369,11,2);
 PlayBGM(11);
 talk( 369,"主公，我刚从许昌回来，有大事禀报．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [574]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"畜生！东吴狗贼！孙权混蛋！大哥，什么时候出师伐吴？我一定要去！");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"虽然我们丢失了荆州，但现在需要冷静，不要太激动了．");
 end
 if JY.Tid==369 then--武官
 talk( 1,"不要着急．发生了什么事？",
 369,"首先是曹操死了，他的长子曹丕继位．",
 1,"什么？曹操死了？！……还有什么事？",
 369,"曹丕继位后，废掉了献帝，自己当上皇帝，改国号为“魏”．",
 1,"什么！那献帝怎么样了？",
 369,"……据说被赶出了许昌，放逐到荒郊，寂寞度日．",
 1,"岂有此理……难道我毕生的奋斗目标重振汉室就这样毁于曹丕之手吗？只因我力量不够啊……",
 369,"那我先退了．");
 MovePerson(369,12,3);
 DecPerson(369);
 talk( 1,"我，还有关羽终生追求的重振汉室的理想难道实现不了了吗？怎么会这样？");
 AddPerson(367,37,23,2);
 MovePerson(367,11,2);
 talk( 367,"主公，诸葛瑾来了．",
 1,"谁？好吧，叫他进来．",
 367,"是．");
 MovePerson(367,12,3);
 DecPerson(367);
 talk( 3,"是东吴的使者？偷袭了关羽，现在还到这里来干什么？大哥，杀了他吧．",
 1,"……不能这样．先问问他想说什么，再杀他也不迟．",
 3,"妈的！还敢厚着脸皮来啊！");
 AddPerson(146,37,23,2);
 MovePerson(146,11,2);
 talk( 146,"诸葛瑾作为吴国特使前来求见．");
 DrawMulitStrBox("　现在出现的诸葛瑾，是诸葛亮的哥哥．年龄比诸葛亮大很多．在孔明很小的时候就开始为吴国效力．*　孙权非常信任他．这次派他来蜀国，就证明了这点．");
 talk( 3,"嗤！吴国狗贼，派我们军师的哥哥来当使者，太卑鄙了．这样我可不好下手了．",
 126,"……先听听我哥哥说什么吧．");
 NextEvent();
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"许昌发生了什么事，听听使者报告吧．");
 end
 end,
 [575]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"畜生，孙权狗贼！派使者来干什么？*如果不是军师的哥哥，我早就把他杀了．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"主公，现在请控制情绪，不要感情用事．");
 end
 if JY.Tid==146 then--诸葛瑾
 talk( 1,"诸葛瑾，你来有何贵干？",
 146,"曹丕称帝的消息想必皇叔已经知道了．这种事我们也难以容忍．我此次来，就是想与魏废除盟约，而与蜀国结盟．如果缔结了盟约，我们打算奉还荆州．请您能给我一个满意的答覆．");
 --显示任务目标:<回答诸葛瑾的结盟提案>
 NextEvent();
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"主公，我很了解你的心情，可是请看在我的面子上不要杀了我哥哥．");
 end
 end,
 [576]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"不要听他胡说．二哥如此惨遭杀害，这岂能忘掉．大哥，决不能结盟．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"我觉得应该与吴结盟．伐吴是主公的私事，不会得到天下人的响应．");
 end
 if JY.Tid==146 then--诸葛瑾
 if talkYesNo( 146,"您作出决定了吗？") then
 RemindSave();
 talk( 146,"那就请您答覆．");
 local menu={
 {"　 结盟",nil,1},
 {"　不结盟",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 146,"噢，谢谢．我马上去向吴侯报喜讯．这是吴国的一点心意，请您笑纳．");
 GetItem(1,4);
 talk( 146,"那我马上回去报告我家主公．");
 MovePerson(146,12,3);
 DecPerson(146);
 talk( 126,"主公，您作出了正确的决断．但您内心一定很痛苦吧．",
 1,"……吴国确实可恨，但现在不能与吴争斗．应先讨伐曹丕，重兴汉室．张飞，请你谅解我．",
 3,"……以前我信任大哥，……今后也会．",
 1,"张飞，谢谢．");
 SetFlag(132,1);
 SetFlag(135,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(592); --goto 592
 elseif r==2 then
 PlayBGM(12);
 talk( 1,"你回去对孙权说，我忘不了夺去荆州和杀害关羽的仇恨．想结盟，做梦！",
 146,"这……，刘备大人，请您三思……",
 126,"是的．现在与吴作战，只会让曹丕高兴．请……",
 1,"住口，孔明！你能体会到手足被害的心情吗？",
 126,"……",
 1,"你马上回去传话吧，蜀选择战争．如果你不是诸葛军师的哥哥，我不会让你活着回去．");
 MovePerson(146,12,3);
 DecPerson(146);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"我认为不应与吴作战．如果我们与吴国交战，得利的是魏国．现在应忘记荆州和关羽，与吴结盟．");
 end
 end,
 [577]=function()
 if GetFlag(58) then
 talk( 3,"大哥，下令出征吧．");
 SetFlag(135,1);
 else
 talk( 3,"到底是我的大哥！我马上就去准备．",
 1,"张飞，不要太着急．",
 3,"已经等了这么长时间，不能再慢吞吞了．大哥也快点准备吧．");
 MovePerson(3,2,1);
 MovePerson(3,12,3);
 DecPerson(3);
 end
 talk( 126,"……",
 1,"孔明，对不起．刚才我过分了．",
 126,"没有关系．我也有错．",
 1,"孔明，应该怎样伐吴？",
 126,"先攻下西陵城，再以那里为据点，然后再进军．",
 1,"嗯，孔明，你留下抵御曹丕，赵云、马超辅佐你．");
 ModifyForce(54,0);
 ModifyForce(126,0);
 ModifyForce(190,0);
 ModifyForce(204,0);
 talk( 1,"出征．");
 NextEvent();
 end,
 [578]=function()
 JY.Smap={};
 SetSceneID(0,3);
 talk( 175,"西陵在去江陵的路上，快出发吧．");
 SetSceneID(0);
 if GetFlag(58) then
 talk( 1,"要为关羽报仇．噢，张飞来了啊．",
 3,"大哥，对不起，我来晚了．我回去做了些准备，时间就过了．",
 1,"好，现在人到齐了．进军西陵！");
 else
 talk( 1,"要为关羽报仇……嗯，那不是吴班吗？",
 91,"主公……",
 1,"怎么啦？神色慌张，出什么事了？");
 PlayBGM(4);
 talk( 91,"禀报主公，……张飞被部下范疆、张达杀害了．",
 1,"什么！这次出师，最高兴的就是张飞．那抓到范疆、张达了吗？",
 91,"他们都逃到东吴去了．",
 1,"关羽、张飞，你们都离我而去了．可是……，关羽、张飞，我不会失败，一定会为你们报仇．");
 ModifyForce(3,0);
 end
 RemindSave();
 talk( 175,"主公，请编队．");
 WarIni();
 DefineWarMap(43,"第三章 西陵之战","一、孙桓败退．",40,0,41);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,11,4, 4,0,-1,0,
 -1,12,3, 4,0,-1,0,
 -1,10,5, 4,0,-1,0,
 -1,11,5, 4,0,-1,0,
 -1,12,5, 4,0,-1,0,
 -1,9,4, 4,0,-1,0,
 -1,13,4, 4,0,-1,0,
 -1,14,4, 4,0,-1,0,
 -1,9,6, 4,0,-1,0,
 252,5,4, 4,0,-1,1,
 29,6,3, 4,0,-1,1,
 43,7,2, 4,0,-1,1,
 });
 ModifyForce(252+1,1);
 ModifyForce(29+1,1);
 ModifyForce(43+1,1);
 SetSceneID(0,3);
 talk( 1,"向西陵进军．");
 
 JY.Smap={};
 JY.Base["现在地"]="江陵";
 JY.Base["道具屋"]=0;
 AddPerson(151,25,17,2);
 AddPerson(45,22,10,1);
 AddPerson(163,20,9,1);
 AddPerson(166,18,8,1);
 AddPerson(148,11,16,0);
 AddPerson(167,9,15,0);
 AddPerson(165,7,14,0);
 SetSceneID(54,11);
 DrawStrBoxCenter("江陵议事厅");
 DrawMulitStrBox("　此时，已经担任东吴都督的陆逊正在江陵向武将们讲解自己的策略．*　东吴历任都督是周瑜、鲁肃、吕蒙，现在是陆逊．陆逊以前从未指挥过战役，这次任命是破格提拔．");
 DrawMulitStrBox("　使关羽失去荆州的主要原因不是吕蒙，而是陆逊．陆逊向吕蒙讲授了如何使关羽疏忽大意，并趁机夺取荆州的计谋．吕蒙对陆逊的睿智深为惊异，并举荐他为自己的后任．");
 MovePerson(45,3,2);
 MovePerson(45,2,1);
 MovePerson(45,3,3);
 talk( 45,"嗯，都督，您不打算增援西陵了？",
 151,"西陵并不重要，我想那里的守将孙桓应该知道这一点．放弃西陵并不是失败．",
 45,"什么！我不同意！",
 151,"我是吴侯亲自任命的都督，你要听我的命令，决不能出征．",
 45,"妈的……怕死的胆小鬼……",
 151,"你说什么？",
 45,"没有，我什么也没说．",
 151,"是吗？那样最好．诸位将军也要服从我的命令，我的话完了．");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 41,18,19, 3,0,54,20, 0,0,-1,0,
 45,14,11, 4,4,50,3, 21,9,-1,0,
 108,22,7, 2,4,49,6, 22,4,-1,0,
 109,18,17, 3,0,49,6, 0,0,-1,0,
 159,17,19, 3,0,49,6, 0,0,-1,0,
 160,14,17, 3,0,50,3, 0,0,-1,0,
 173,12,16, 3,4,49,25, 14,11,-1,0,
 256,18,10, 4,4,45,3, 22,9,-1,0,
 274,21,9, 4,4,45,6, 23,2,-1,0,
 292,20,10, 4,4,48,9, 24,4,-1,0,
 293,19,9, 4,4,48,9, 24,3,-1,0,
 294,15,12, 4,4,48,9, 21,10,-1,0,
 295,13,17, 3,0,47,9, 0,0,-1,0,
 296,16,18, 3,0,47,9, 0,0,-1,0,
 
 310,13,10, 4,0,45,12, 0,0,-1,0,
 311,12,11, 4,0,44,12, 0,0,-1,0,
 336,22,10, 4,4,45,15, 23,4,-1,0,
 332,19,18, 3,0,46,14, 0,0,-1,0,
 297,14,12, 4,0,47,9, 0,0,-1,0,
 348,14,18, 3,0,43,19, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [579]=function()
 PlayBGM(11);
 talk( 1,"众将官，要为关羽报仇，向孙权军雪恨！",
 42,"哎呀呀……大家一定要守住，等待援军的到来．");
 WarShowTarget(true);
 PlayBGM(12);
 WarShowArmy(29);
 --talk( 30,"主公，我来迟了，对不起．我是关羽的儿子关兴．*我此次来是为了报父仇，请让我加入战斗．");
 talk( 30,"主公，我来迟了，对不起．我是关羽的儿子关兴．我此次来是为了报父仇，请让我加入战斗．");
 WarShowArmy(43);
 talk( 44,"我岂能落在关兴后面？主公，我是张飞之子张苞，此次作战我也要参加．");
 WarShowArmy(252);
 talk( 253,"父亲，请带我去．不过，刀箭很可怕呀．");
 PlayWavE(11);
 DrawStrBoxCenter("刘禅、张苞、关兴成为部下！");
 PlayBGM(14);
 NextEvent();
 end,
 [580]=function()
 if WarMeet(44,110) then
 WarAction(1,44,110);
 talk( 44,"敌将何在！我是张飞之子张苞！",
 110,"喔，你就是张飞的儿子．我来教训你！");
 WarAction(6,44,110);
 if fight(44,110)==1 then
 talk( 44,"杀！");
 WarAction(8,44,110);
 talk( 110,"哎呀！");
 WarAction(18,110);
 talk( 44,"杀死了敌将！");
 WarLvUp(GetWarID(44));
 else
 WarAction(4,110,44);
 talk( 44,"哎呀！");
 WarAction(17,44);
 WarLvUp(GetWarID(110));
 end
 end
 if WarMeet(30,109) then
 WarAction(1,30,109);
 talk( 30,"我是关羽的儿子关兴，谁敢与我单挑！",
 109,"黄毛小儿，休得猖狂！我来了！");
 WarAction(6,30,109);
 if fight(30,109)==1 then
 talk( 109,"你就是关兴？还在想爸爸吧．",
 30,"住口！你给我过来！",
 109,"过去又怎样．");
 WarAction(15,30);
 talk( 109,"一刀结果你……");
 WarAction(5,109,30);
 WarAction(8,30,109);
 WarAction(18,109);
 talk( 30,"这种对手也敢口出狂言？");
 WarLvUp(GetWarID(30));
 else
 talk( 109,"你就是关兴？还在想爸爸吧．",
 30,"住口！你给我过来！",
 109,"过去又怎样．");
 WarAction(15,30);
 talk( 109,"一刀结果你……");
 WarAction(4,109,30);
 talk( 30,"太厉害了！");
 WarAction(17,30);
 WarLvUp(GetWarID(109));
 end
 end
 if JY.Status==GAME_WARWIN then
 talk( 42,"混蛋！……撤退！");
 PlayBGM(7);
 DrawMulitStrBox("　刘备军大败孙桓军．");
 GetMoney(1400);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金１４００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [581]=function()
 JY.Smap={};
 SetSceneID(0,3);
 talk( 175,"那么进西陵城吧．");
 --显示任务目标:<进西陵城>
 NextEvent();
 end,
 [582]=function()
 JY.Smap={};
 JY.Base["现在地"]="江陵";
 JY.Base["道具屋"]=0;
 AddPerson(151,25,17,2);
 AddPerson(45,22,10,1);
 AddPerson(163,20,9,1);
 AddPerson(166,18,8,1);
 AddPerson(148,11,16,0);
 AddPerson(167,9,15,0);
 AddPerson(165,7,14,0);
 SetSceneID(54,11);
 AddPerson(369,-5,2,3);
 MovePerson(369,10,3);
 talk( 369,"孙桓军被刘备击败，正往这里退却．",
 151,"孙桓怎么样？",
 369,"他没什么事．",
 151,"是吗？那太好了．你辛苦了．",
 369,"我退下去了．");
 MovePerson(369,12,2);
 DecPerson(369);
 MovePerson(45,3,2);
 MovePerson(45,2,1);
 MovePerson(45,3,3);
 talk( 45,"有什么好的，是我们吃败仗啊！",
 151,"这次失败在我预料之中．第一，刘备军进攻士气正旺，势不可挡．硬要抗拒他们，我军会有很大伤亡．",
 45,"……",
 151,"与其与他们正面对抗，不如静观其动向，他们不久就会疲惫的．那时我们再进攻，必能打败他们．",
 45,"那会是什么时候？",
 151,"不知道．可能两年，也可能三年．",
 45,"都督阁下！",
 151,"哈哈哈．我开玩笑．不久刘备军就会等得不耐烦，而前来进攻江陵，那时候就是我们进攻的时候．",
 45,"……");
 NextEvent();
 end,
 [583]=function()
 JY.Smap={};
 JY.Base["现在地"]="西陵";
 JY.Base["道具屋"]=22;
 AddPerson(1,9,9,3);
 if GetFlag(135) then
 AddPerson(3,9,12,3);
 end
 AddPerson(253,15,9,3);
 AddPerson(175,20,9,1);
 AddPerson(30,22,10,1);
 AddPerson(170,9,15,0);
 AddPerson(44,11,16,0);
 SetSceneID(49,5);
 DrawStrBoxCenter("西陵议事厅");
 talk( 175,"主公，诸葛瑾来求见．",
 1,"他又来了．让他进来．",
 175,"是．");
 AddPerson(146,41,25,2);
 MovePerson(146,12,2);
 talk( 146,"刘备大人，我诸葛瑾又来了．");
 --显示任务目标:<回答诸葛瑾的结盟提案>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [584]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，答覆其实早有了．");
 end
 if JY.Tid==175 then--马良
 talk( 175,"主公，请与诸葛瑾交谈．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"最近年轻人生龙活虎，屡立战功，难道我老了，不中用了……");
 end
 if JY.Tid==253 then--刘禅
 talk( 253,"父亲，这个地方不舒服．");
 end
 if JY.Tid==30 then--关兴
 talk( 30,"杀父之仇，不共戴天．主公，请允许我杀了这个家伙．",
 1,"不可，他毕竟是孔明的哥哥，你要忍忍．");
 end
 if JY.Tid==44 then--张苞
 if GetFlag(135) then
 talk( 44,"关兴的父亲被东吴杀了，不能就此罢休．");
 else
 talk( 44,"父亲是死于东吴之手，决不能放过他们．");
 end
 end
 if JY.Tid==146 then--诸葛瑾
 talk( 1,"又是为结盟而来的吧．");
 if GetFlag(135) then
 talk( 146,"我家主公非常后悔与魏国结盟，所以想与魏国绝交，改与蜀国结盟修好，今后不断加深两国的友谊，刘备大人，你意下如何？",
 1,"……");
 else
 talk( 146,"是的，我家主公愿意把谋害张飞的凶手交还给蜀国，并且愿意归还荆州．希望与蜀国结盟修好，今后不断加深两国的友谊，刘备大人，你意下如何？",
 1,"……");
 end
 NextEvent();
 end
 end,
 [585]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，答覆其实早有了．");
 end
 if JY.Tid==175 then--马良
 talk( 175,"主公，我们大败孙桓率领的孙权军，应该说，在某种程度上已经雪恨了，如果再处死那些叛逆，就再也没有仇恨了．所以，我觉得应该与吴结盟．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"最近年轻人生龙活虎，屡立战功，难道我老了，不中用了……");
 end
 if JY.Tid==253 then--刘禅
 talk( 253,"父亲，这个地方不舒服．");
 end
 if JY.Tid==30 then--关兴
 talk( 30,"杀父之仇，不共戴天．主公，请允许我杀了这个家伙．",
 1,"不可，他毕竟是孔明的哥哥，你要忍忍．");
 end
 if JY.Tid==44 then--张苞
 if GetFlag(135) then
 talk( 44,"关兴的父亲被东吴杀了，不能就此罢休．");
 else
 talk( 44,"父亲是死于东吴之手，决不能放过他们．");
 end
 end
 if JY.Tid==146 then--诸葛瑾
 if talkYesNo( 146,"刘备大人，您决定了吗？") then
 RemindSave();
 talk( 146,"刘备大人，您将做何答覆？");
 local menu={
 {"　 结盟",nil,1},
 {"　不结盟",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 146,"噢，谢谢．我马上去向吴侯报喜讯．这是吴国的一点心意，请您笑纳．");
 GetItem(1,63);
 talk( 146,"那我马上回去报告我家主公．");
 MovePerson(146,14,3);
 DecPerson(146);
 talk( 175,"主公，您作出了正确的决断．但您内心一定很痛苦吧．",
 1,"……吴国确实可恨，但现在没时间为关羽悲伤．现在应该讨伐曹丕，重兴汉室．");
 SetFlag(136,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(592); --goto 592
 elseif r==2 then
 PlayBGM(12);
 talk( 1,"诸葛瑾，我的答覆没有变，你还是回去吧．",
 146,"刘备大人，请您慎重考虑一下．",
 1,"这不能说服我，你回去吧．");
 MovePerson(146,14,3);
 DecPerson(146);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end
 end,
 [586]=function()
 talk( 175,"主公，现在应该与他们修好．",
 1,"不要再说了，我意已决．",
 175,"……我知道了．那就考虑进攻吧．听说吴国都督是陆逊．",
 1,"陆逊？没听说过呀．",
 175,"虽然他名声不大，但我听说此人深有谋略，主公不可小看他．");
 talk( 175,"请列队．");
 WarIni();
 DefineWarMap(44,"第三章 夷陵之战","一、陆逊败退．",50,0,150);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,4,11, 4,0,-1,0,
 -1,5,12, 4,0,-1,0,
 -1,6,11, 4,0,-1,0,
 -1,6,18, 4,0,-1,0,
 -1,7,19, 4,0,-1,0,
 -1,6,12, 4,0,-1,0,
 -1,8,12, 4,0,-1,0,
 -1,9,11, 4,0,-1,0,
 -1,5,17, 4,0,-1,0,
 -1,5,19, 4,0,-1,0,
 -1,2,10, 4,0,-1,0,
 -1,3,10, 4,0,-1,0,
 -1,2,11, 4,0,-1,0,
 -1,3,12, 4,0,-1,0,
 -1,3,16, 4,0,-1,0,
 53,1,15, 4,0,-1,1, --赵云
 });
 talk( 1,"出征．");
 JY.Smap={};
 SetSceneID(0,3);
 talk( 1,"敌人在江陵，快跟上！");
 SetSceneID(0,11);
 talk( 151,"什么！刘备出动了．我等候他多时了．现在正是击溃刘备的最好时机，全军，进军彝陵！");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 150,29,16, 3,0,56,16, 0,0,-1,0,
 44,27,17, 3,0,52,3, 0,0,-1,0,
 162,20,18, 3,1,53,9, 0,0,-1,0,
 147,29,10, 3,0,53,14, 0,0,-1,0,
 166,27,10, 3,0,53,9, 0,0,-1,0,
 165,26,10, 3,1,53,3, 0,0,-1,0,
 164,26,16, 3,0,52,3, 0,0,-1,0,
 173,22,10, 3,3,52,25, 0,0,-1,0,
 107,29,12, 3,0,51,3, 0,0,-1,0,
 45,29,15, 3,0,52,3, 0,0,-1,0,
 155,30,17, 3,0,51,3, 0,0,-1,0,
 156,24,18, 3,0,51,3, 0,0,-1,0,
 157,18,19, 3,1,51,6, 0,0,-1,0,
 158,23,9, 3,1,51,6, 0,0,-1,0,
 
 274,18,11, 3,1,45,6, 0,0,-1,0,
 275,17,18, 3,1,45,6, 0,0,-1,0,
 276,22,19, 3,1,44,6, 0,0,-1,0,
 292,20,7, 3,1,50,9, 0,0,-1,0,
 293,21,16, 3,1,50,9, 0,0,-1,0,
 294,29,13, 3,0,50,9, 0,0,-1,0,
 310,19,17, 3,1,45,12, 0,0,-1,0,
 311,26,18, 3,0,45,12, 0,0,-1,0,
 340,21,9, 3,1,44,17, 0,0,-1,0,
 341,28,8, 3,0,45,17, 0,0,-1,0,
 
 295,17,10, 3,1,49,9, 0,0,-1,0,
 296,17,12, 3,1,49,9, 0,0,-1,0,
 297,17,16, 3,1,49,9, 0,0,-1,0,
 298,24,17, 3,1,48,9, 0,0,-1,0,
 299,24,8, 3,1,48,9, 0,0,-1,0,
 300,22,12, 3,1,48,9, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [587]=function()
 PlayBGM(11);
 talk( 151,"呵呵呵．孔明不在这里真乃天助我也，只有他才能识破我的战略．刘备真是个糊涂虫，竟敢率军冒然突进．看来刘备的气数已尽．",
 45,"都督，起风了．",
 151,"好啊．这里是通风之处，而且地势狭窄，我就在这里等候刘备．",
 45,"都督所言极是．……都督，你有如此妙计，我却对您无礼，实在对不起．",
 151,"行了，等打完这一仗再说这事也不迟．好，放火！烧尽刘备军！");
 WarShowTarget(true);
 PlayWavE(51);
 WarFireWater(0,8,1);
 WarFireWater(1,8,1);
 WarFireWater(2,8,1);
 WarFireWater(3,8,1);
 WarFireWater(4,8,1);
 WarFireWater(5,10,1);
 WarFireWater(6,10,1);
 WarFireWater(7,10,1);
 WarFireWater(10,10,1);
 WarFireWater(11,10,1);
 WarFireWater(12,10,1);
 WarFireWater(6,13,1);
 WarFireWater(7,13,1);
 WarFireWater(8,13,1);
 WarFireWater(9,13,1);
 WarFireWater(10,13,1);
 WarFireWater(0,16,1);
 WarFireWater(2,17,1);
 WarFireWater(3,17,1);
 WarFireWater(4,18,1);
 WarFireWater(6,17,1);
 WarFireWater(7,17,1);
 WarFireWater(8,20,1);
 WarFireWater(9,20,1);
 talk( 175,"主，主公．大事不好！敌人用火攻了．",
 1,"唉……现在我军众多倒成为累赘了．前方道路越来越窄了．");
 WarEnemyWeak(1,1);
 WarEnemyWeak(1,1);
 WarEnemyWeak(1,2);
 talk( 151,"取胜的时机到了！不要放走了刘备！吴国的命运在此一战！");
 PlayBGM(10);
 NextEvent();
 end,
 [588]=function()
 if WarMeet(163,35) then
 WarAction(1,163,35);
 talk( 163,"怎么？这支部队是？主将是谁？",
 35,"我就是主将．",
 163,"吓，是蛮族啊，一看你就知道是蛮族，我还是第一次见到蛮族．好，与我单挑吧．",
 35,"好，来吧！");
 WarAction(6,163,35);
 if fight(163,35)==1 then
 talk( 163,"招！怎么只有招架之功．");
 WarAction(5,163,35);
 WarAction(19,35);
 talk( 35,"唉呀……太累了……",
 163,"你怎么了，动作这么慢？");
 WarAction(9,163,35);
 talk( 35,"嘿！这几下怎么样？");
 WarAction(4,35,163);
 WarAction(4,35,163);
 talk( 35,"哈哈……",
 163,"你好像累了，我送你去歇歇．");
 WarAction(8,163,35);
 talk( 35,"啊……！");
 talk( 35,"我命休矣……");
 WarAction(18,35);
 ModifyForce(35,0);
 WarLvUp(GetWarID(163));
 else
 talk( 35,"嘿！这几下怎么样？");
 WarAction(4,35,163);
 talk( 163,"啊……！");
 WarAction(17,163);
 WarLvUp(GetWarID(35));
 end
 end
 if (not GetFlag(1063)) and War.Turn==5 then
 talk( 151,"哈哈哈．机不可失！全军总攻！刘备，这次你休想逃脱．");
 WarModifyAI(150,3,0);
 WarModifyAI(44,1);
 WarModifyAI(162,3,34);
 WarModifyAI(147,1);
 WarModifyAI(166,3,0);
 WarModifyAI(164,1);
 WarModifyAI(107,1);
 WarModifyAI(45,1);
 WarModifyAI(155,1);
 WarModifyAI(156,1);
 WarModifyAI(294,1);
 WarModifyAI(311,1);
 WarModifyAI(341,1);
 SetFlag(1063,1);
 end
 if (not GetFlag(1064)) and War.Turn==3 then
 WarShowArmy(53);
 WarModifyAI(53,3,0);
 talk( 54,"主公勿慌，赵云来了！");
 SetFlag(1064,1);
 end
 if JY.Status==GAME_WARWIN then
 talk( 151,"真倒霉！好不容易有此良机……全军撤退！");
 PlayBGM(7);
 DrawMulitStrBox("　陆逊败退了，刘备军战胜了陆逊军．");
 GetMoney(1400);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金１４００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(591); --goto 591
 end
 if JY.Status==GAME_WARLOSE then
 PlayBGM(4);
 talk( 1,"唉，难道我要死在这里吗……",
 30,"主公，不要气馁！我们撤到白帝城吧．",
 44,"我们来殿后．主公，快撤！",
 1,"喔，关兴，张苞．好吧，撤退回白帝城．",
 151,"刘备怎么了？看见他了吗？什么！被他跑掉了……算了，刘备再也没有实力了，现在我最担心的是魏国．好，全军马上去防备魏军．");
 DrawMulitStrBox("　刘备退到了白帝城．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [589]=function()
 JY.Smap={};
 SetSceneID(0);
 if GetFlag(135) then
 talk( 3,"大哥，你没事吧．",
 1,"是你呀，张飞．对不起……我没能给关羽报仇．",
 3,"大哥，不要害怕！关羽还活着！",
 1,"唉……唉……哇！",
 3,"啊，大哥，振作些！");
 else
 talk( 1,"关羽，张飞，对不起．没能杀死你们的仇人，请原谅你们的大哥……");
 end
 NextEvent();
 end,
 [590]=function()
 JY.Smap={};
 JY.Base["现在地"]="白帝城";
 JY.Base["道具屋"]=0;
 if GetFlag(135) then
 AddPerson(3,19,14,2);
 end
 AddPerson(126,17,15,2);
 AddPerson(54,15,16,2);
 AddPerson(190,21,15,2);
 AddPerson(170,19,16,2);
 AddPerson(127,17,17,2);
 SetSceneID(82,2);
 RemindSave();
 if GetFlag(135) then
 talk( 1,"张飞，对不起．关羽的仇没能报……",
 3,"说什么呀！大哥，求求你！不要让我一个人留下．",
 1,"哈哈哈……到什么时候你都还是急脾气……张飞，我的天寿也到尽头了．",
 3,"大哥，振作些！");
 end
 talk( 1,"孔明，多亏了你，我才能夺得汉中，才有今天这样的局面．",
 1,"这次，我没听你的劝告而去讨伐东吴，以致遭到如此惨败，这是报应啊．");
 if GetFlag(135) then
 MovePerson( 3,2,2,
 126,2,2);
 else
 MovePerson( 126,2,2);
 end
 talk( 126,"主公，不要再想这些了．我心里连一次都没报怨过你．",
 1,"唉．……孔明，我有一事相求．",
 126,"什么事啊？",
 1,"老天已经在召唤我啦．我是想让刘禅继位．可是刘禅不成器，必要的时候请你取而代之．孔明，只有你才能消灭曹丕．",
 126,"主公，不要那么想，我孔明誓死效忠蜀国．呜呜……",
 1,"谢谢．……赵云，我们同甘共苦到今天，我在这里与你告别很伤感啊．",
 54,"主，主公……");
 if GetFlag(58) then
 talk( 1,"希望大家尽力辅佐刘禅．",
 126,"主公！主公……！",
 54,"呜……，呜……！");
 end
 if GetFlag(135) then
 talk( 3,"大哥！为什么把我扔在一边都不理我！");
 end
 if not (GetFlag(58) or GetFlag(135)) then
 talk( 1,"……对不起，让我一个人静一静，我有些累了……",
 126,"……是，臣告退……");
 MovePerson( 126,2,3);
 MovePerson( 126,15,3,
 54,15,3,
 190,15,3,
 170,15,3,
 127,15,3);
 talk( 1,"呼呼……．…………嗯？是谁？");
 AddPerson(2,15,16,2);
 DrawSMap();
 talk( 2,"兄长，我来接你了．",
 1,"噢，关羽！你还活着啊！",
 2,"不，我已经死了．张飞也……");
 AddPerson(3,19,14,2);
 DrawSMap();
 talk( 3,"大哥，我和关羽已先来到这里．大哥也累了吧．怎么样？来不来这里？",
 1,"是啊……．好吧……．");
 MovePerson( 126,7,2)
 talk( 126,"噢，怎么回事！怎么会是……关羽？还有张飞！");
 MovePerson( 126,4,2)
 talk( 2,"兄长，走吧……",
 126,"等一等！关羽求求你，先别把主公从这个世界上带走！");
 DecPerson(2);
 DrawSMap();
 MovePerson( 126,3,2)
 talk( 3,"大哥，我们在等着你呢……．",
 126,"主公！！");
 DecPerson(3);
 MovePerson( 126,3,2)
 talk( 126,"主公！你要好好考虑！",
 1,"关羽、张飞，现在走吧……．",
 126,"……！主公！！主公……！！");
 DrawSMap();
 end
 DrawMulitStrBox("　公元２２３年，刘备没有完成恢复汉室的大业便驾崩了．");
 RemindSave();
 NextEvent(999); --goto ???
 end,
 [591]=function()
 JY.Smap={};
 SetSceneID(0,11);
 talk( 151,"什么，曹丕打过来了？不好！我们还没消灭蜀国．看来这次也得派使者与蜀国结盟了．快返回吴！");
 SetSceneID(0,3);
 talk( 1,"很危险啊．陆逊这个人不可小看啊．",
 175,"主公，陆逊也撤走了，我们回成都吧．然后再按丞相的意思与吴国结盟如何？",
 1,"由于我这一怒之下犯了大错，以致失去了那么多爱将．……与吴结盟吧．");
 NextEvent();
 end,
 [592]=function()
 ModifyForce(126,1);
 ModifyForce(54,1);
 ModifyForce(190,1);
 ModifyForce(204,1);
 SetSceneID(-1,0);
 JY.Base["章节名"]="第四章　夺回荆州";
 DrawStrBoxCenter("第四章　夺回荆州");
 LoadPic(26,1);
 --DrawMulitStrBox("　刘备为消灭魏国曹丕，已与东吴结为同盟．*　一心想复兴汉室的蜀国，与妄想扩张领土的吴国，各怀鬼胎的两国终于联手．*　蜀国重臣，集中到成都会议厅，共谋打败曹魏的大计．");
 DrawMulitStrBox("　刘备为消灭魏国曹丕，已与东吴结为同盟．*　一心想复兴汉室的蜀国，与妄想扩张领土的吴国，各怀鬼胎的两国终于联手．*　蜀国重臣，集中到成都宫殿，共谋打败曹魏的大计．");
 LoadPic(26,2);
 NextEvent();
 end,
 [593]=function()
 JY.Smap={};
 JY.Base["现在地"]="成都";
 JY.Base["道具屋"]=21;
 AddPerson(1,6,7,3);
 AddPerson(126,12,8,3);
 if GetFlag(135) then
 AddPerson(3,19,9,1);
 end
 AddPerson(170,23,11,1);
 AddPerson(175,9,14,0);
 AddPerson(203,13,16,0);
 SetSceneID(56,5);
 DrawStrBoxCenter("成都宫殿");--成都会议厅
 if GetFlag(132) then
 talk( 126,"主公，关羽之子关兴，张飞之子张苞来见．",
 1,"哦，快让进来．",
 126,"是．张苞、关兴进来．");
 AddPerson(44,37,22,2);
 AddPerson(30,35,23,2);
 MovePerson( 44,11,2,
 30,11,2);
 talk( 44,"我是张飞之子张苞，今后想和父亲一样，为主公效命．",
 30,"我是关羽之子关兴，和张苞一样，也请主公多关照．",
 1,"你二人，都有乃父之风，以后好好干吧．",
 44,"是．臣先告退．");
 ModifyForce(30,1);
 ModifyForce(44,1);
 PlayWavE(11);
 DrawStrBoxCenter("张苞、关兴加入我方！");
 MovePerson( 44,12,3,
 30,12,3);
 AddPerson(253,37,23,2);
 MovePerson(253,11,2);
 talk( 253,"嗯，父亲，我已长大成人，也要去打仗吗？",
 1,"我如果把你编排在部队里，当然要去打仗．你不愿意吗？",
 253,"不，不是！没那么想……好吧，我先退下了……真烦人……");
 ModifyForce(253,1);
 PlayWavE(11);
 DrawStrBoxCenter("刘禅加入臣下！");
 MovePerson( 253,12,3);
 talk( 1,"孔明，如此安排行吗？",
 126,"以后如不好生培养，恐不能成大器．他好像还不懂得战争的严酷，主公，我还有要事与您商量……");
 end
 MovePerson(126,0,2);
 talk( 126,"已与东吴结盟，这样就只有魏国是敌人了．",
 1,"嗯，必须伐魏，复兴汉室．");
 --显示任务目标:<商议今后行动．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [594]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"二哥的仇不能忘，但复兴汉室是头等大事，二哥一定也是这么想的．");
 end
 if JY.Tid==175 then--马良
 talk( 175,"尽快伐魏吧．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"决战的时刻终于到了，请看我一展身手吧．");
 end
 if JY.Tid==203 then--严颜
 talk( 203,"决战的时刻终于到了，请看我一展身手吧．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"到魏国洛阳，有两条路可走，一条是从荆州的襄阳走，另一条是从汉中取道关中长安．");
 DrawMulitStrBox("　诸葛亮在此所言”关中”，不是指刘备已夺取的汉中，是指汉中再往北．*　有长安和陈仓二处险要．");
 talk( 126,"荆州和关中都有魏国精锐把守．",
 1,"当然．孔明，你认为如何攻击为上？",
 126,"既然已与东吴结盟，从襄阳一路与东吴共同进攻为上．但汉中也会因此而薄弱，得向关中派遣奇袭队，在那里绊住魏军．",
 1,"军师所言极是．但是，我军兵力比魏军少，又如此分兵两路，岂不危险？",
 126,"我也考虑过．奇袭队的主帅一定得派精明强悍的人．至于派不派奇袭队，请主公定夺，宜深思熟虑之．");
 --显示任务目标:<考虑是否派奇袭队去关中．>
 NextEvent();
 end
 end,
 [595]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"向关中派兵是可以，但如果那样……就得分兵，可是我们哪里有那么多人马可分呀？");
 end
 if JY.Tid==175 then--马良
 talk( 175,"是呀……诚如军师所言，我也认为有必要分兵．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"我想跟随主公一齐作战．");
 end
 if JY.Tid==203 then--严颜
 talk( 203,"关中吗？关中是汉中以北一带的总称，陈仓和长安等处也属关中．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"主公，下决定了吗？") then
 RemindSave();
 DrawSMap();
 local menu={
 {"　 派遣奇袭队",nil,1},
 {"　不派遣奇袭队",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,C_WHITE,C_WHITE);
 if r==1 then
 if not GetFlag(38) then
 talk( 126,"奇袭队的主帅，派庞统是合适人选．",
 1,"嗯，快唤庞统来．");
 AddPerson(133,37,23,2);
 MovePerson(133,3,2);
 talk( 133,"主公，找我何事？");
 MovePerson(133,8,2);
 talk( 1,"庞统，你来指挥关中奇袭队．",
 133,"决定向关中出兵了吧．",
 1,"不错，你所料极是．",
 133,"得令．我马上去阳平关．",
 1,"嗯，带赵云等人同去吧．",
 133,"是，我先去了．");
 MovePerson( 133,12,3);
 else
 talk( 126,"奇袭队的主帅，赵云是合适人选．",
 1,"嗯，快唤赵云来．");
 AddPerson(54,37,23,2);
 MovePerson(54,3,2);
 talk( 54,"主公，找我何事？");
 MovePerson(54,8,2);
 talk( 1,"赵云，你来指挥关中奇袭队．",
 54,"决定向关中出兵了吧．",
 1,"不错，你所料极是．",
 54,"得令．我马上去阳平关．",
 1,"嗯，带马超等人同去吧．",
 54,"是，我先去了．");
 MovePerson( 54,12,3);
 end
 SetFlag(89,1);
 ModifyForce(133,0);
 ModifyForce(54,0);
 ModifyForce(190,0);
 ModifyForce(127,0);
 ModifyForce(83,0);
 ModifyForce(65,0);
 ModifyForce(82,0);
 ModifyForce(114,0);
 ModifyForce(117,0);
 ModifyForce(188,0);
 elseif r==2 then
 talk( 126,"是，全军进发荆州吧．");
 end
 talk( 175,"那，去东吴邀请共同发兵吧．",
 1,"嗯，全靠你了．",
 175,"是．");
 MovePerson(175,2,0);
 MovePerson(175,13,3);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [596]=function()
 JY.Smap={};
 JY.Base["现在地"]="邺";
 JY.Base["道具屋"]=0;
 AddPerson(213,28,7,1);
 AddPerson(214,13,9,3);
 AddPerson(20,9,11,3);
 AddPerson(17,25,15,2);
 AddPerson(94,21,17,2);
 SetSceneID(92,11);
 DrawStrBoxCenter("邺城宫殿");
 DrawMulitStrBox("　另一方面，在魏国的大本营邺城，正在商议对付蜀吴同盟．");
 MovePerson(214,2,3);
 MovePerson(214,1,0);
 talk( 214,"陛下，蜀吴已结成同盟，很明显要共同进攻我们，我们如何应付？",
 213,"嗯，派援军去襄阳．那，夏侯惇．",
 17,"在！");
 MovePerson(17,2,2);
 MovePerson(17,0,0);
 talk( 213,"马上率军增援襄阳，与襄阳守将曹仁协力，顶住蜀军．",
 17,"遵命，我马上去！");
 MovePerson(17,14,1);
 talk( 213,"还有，曹洪、贾诩．",
 20,"在．",
 94,"有何吩咐．");
 MovePerson( 20,2,3,
 94,2,2);
 MovePerson( 20,1,0,
 94,1,0);
 talk( 213,"曹洪，你去关中向曹真传命，敌人若攻来就迎击，否则就增援襄阳．",
 20,"是．",
 213,"贾诩去合淝，向张辽也照此传令．",
 94,"遵命．");
 MovePerson( 20,14,1,
 94,14,1);
 NextEvent();
 end,
 [597]=function()
 JY.Smap={};
 JY.Base["现在地"]="襄阳";
 JY.Base["道具屋"]=13;
 AddPerson(19,25,9,1);
 AddPerson(79,25,15,2);
 AddPerson(63,14,9,3);
 AddPerson(17,5,19,0);
 SetSceneID(86,5);
 DrawStrBoxCenter("襄阳议事厅");
 DrawMulitStrBox("　夏侯惇遵曹丕之命，已到达曹仁镇守的襄阳．");
 MovePerson(17,6,0);
 talk( 17,"奉圣上之命，前来增援．",
 19,"来得太好了，光我们这些兵，根本守不住．",
 79,"提早御敌吧．",
 63,"是呀，敌人随时都可能杀来．",
 19,"那好，夏侯惇去守宛城．",
 17,"我守最后的关口，好的．",
 19,"徐晃守南郡，于禁守新野，都要用心防守．",
 79,"遵命．",
 63,"是．");
 MovePerson( 17,12,1,
 79,12,1,
 63,12,1)
 NextEvent();
 end,
 [598]=function()
 JY.Smap={};
 JY.Base["现在地"]="成都";
 JY.Base["道具屋"]=21;
 AddPerson(1,6,7,3);
 AddPerson(126,12,8,3);
 if GetFlag(135) then
 AddPerson(3,19,9,1);
 end
 AddPerson(170,23,11,1);
 AddPerson(203,13,16,0);
 SetSceneID(56,5);
 DrawStrBoxCenter("成都宫殿");--成都议事厅
 AddPerson(175,37,23,2);
 MovePerson(175,11,2);
 talk( 175,"主公，我刚从东吴回来．");
 --显示任务目标:<商议今后行动>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [599]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，听听报告吧．");
 end
 if JY.Tid==175 then--马良
 talk( 1,"马良，联合起兵的事如何了？",
 175,"已大功告成，孙权答应联合起兵了．",
 1,"哦，真是好消息．",
 175,"孙权要去江陵．",
 1,"好，那我们也去江陵．",
 126,"出发吧．");
 --MovePerson
 --显示任务目标:<去江陵．>
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"主公，有没有东吴参加无所谓，有我在就够了．");
 end
 if JY.Tid==203 then--严颜
 talk( 203,"与东吴交涉很顺利吧．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"先请听听马良的报告吧．");
 end
 end,
 [600]=function()
 JY.Smap={};
 JY.Base["现在地"]="江陵";
 JY.Base["道具屋"]=23;
 AddPerson(126,19,17,2);
 AddPerson(1,25,17,2);
 if GetFlag(135) then
 AddPerson(3,22,10,1);
 end
 AddPerson(170,20,9,1);
 AddPerson(203,9,15,0);
 SetSceneID(54);
 DrawStrBoxCenter("江陵议事厅");
 AddPerson(175,-5,2,3);
 MovePerson(175,10,3);
 talk( 175,"主公，孙权到达江陵了．",
 1,"是吗，请到这里来．",
 175,"是．");
 MovePerson(175,12,2);
 talk( 1,"东吴……．关羽遭东吴毒手时，哪里想到今日会与孙权联合攻曹魏．",
 126,"主公的英明决断，才造成今日的有利局势．主公，孙权好像已经到了．");
 AddPerson(142,-5,2,3);
 MovePerson(142,10,3);
 talk( 142,"刘备公，幸会幸会．");
 --显示任务目标:<与孙权等人商议今后的事．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [601]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，先问客人吧．");
 end
 if JY.Tid==142 then--孙权
 talk( 142,"我率部来此，只为伐魏．我先介绍一下我军统帅陆逊．陆逊，有请．");
 AddPerson(151,-5,1,3)
 MovePerson(151,9,3);
 talk( 151,"在下陆逊，大家一回生，二回熟．",
 1,"孙权公，陆逊公，我们一起伐魏，共诛国贼吧．",
 142,"好吧．消灭了曹丕，天下也就太平了．");
 NextEvent();
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"主公，先听孙权公妙策吧．");
 end
 if JY.Tid==203 then--严颜
 talk( 203,"主公，先听孙权公妙策吧．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"先听孙权公妙策吧．");
 end
 end,
 [602]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"要与东吴一起作战？在此之前，想都不敢想．");
 end
 if JY.Tid==142 then--孙权
 talk( 142,"我们也会尽力伐魏．");
 end
 if JY.Tid==151 then--陆逊
 talk( 151,"一同伐魏吧．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"一同伐魏吧．");
 end
 if JY.Tid==203 then--严颜
 talk( 203,"一同伐魏吧．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"请孙权派奇袭队，分散敌军兵力为好．",
 1,"让奇袭队进攻何处呢？",
 126,"东吴之北是合淝，由张辽镇守．如果进攻合淝，张辽就不能抽身增援他处．请主公熟思决断．");
 --显示任务目标:<考虑是否请孙权派奇袭队．>
 NextEvent();
 end
 end,
 [603]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"要与东吴一起作战？在此之前，想都不敢想．");
 end
 if JY.Tid==142 then--孙权
 talk( 142,"我们也会尽力伐魏．");
 end
 if JY.Tid==151 then--陆逊
 talk( 151,"一同伐魏吧．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"一同伐魏吧．");
 end
 if JY.Tid==203 then--严颜
 talk( 203,"一同伐魏吧．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"主公，考虑得如何了？") then
 RemindSave();
 DrawSMap();
 local menu={
 {"　请孙权攻合淝",nil,1},
 {"　　 不邀请",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,C_WHITE,C_WHITE);
 if r==1 then
 talk( 1,"孙权公，派奇袭队如何？",
 142,"奇袭队？",
 1,"想请您进攻东吴北面的合淝．",
 142,"让我牵制敌军．好，我发兵合淝．");
 SetFlag(90,1);
 talk( 142,"那好，我马上回去，做发兵合淝的准备．");
 elseif r==2 then
 talk( 142,"我军想资助些军需，请笑纳．");
 GetMoney(2000);
 PlayWavE(11);
 DrawStrBoxCenter("接受了东吴２０００黄金的援助！");
 talk( 142,"以后有什么事，请吩咐陆逊．那我先告退．");
 end
 MovePerson(142,12,2)
 talk( 126,"那我们也准备出征吧．");
 --显示任务目标:<进行出征准备．>
 NextEvent();
 end
 end
 end,
 [604]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"要与东吴一起作战？在此之前，想都不敢想．");
 end
 if JY.Tid==151 then--陆逊
 talk( 151,"一同伐魏吧．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"一同伐魏吧．");
 end
 if JY.Tid==203 then--严颜
 talk( 203,"一同伐魏吧．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"出征吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 126,"请编组部队．");
 if GetFlag(136) or GetFlag(132)then --原本是只有打了西陵才升级，改为打或不打都升级，打了夷陵就不升
 LvUp(151,6);
 LvUp(148,11);
 LvUp(167,11);
 LvUp(166,11);
 LvUp(165,11);
 end
--(如果没打西陵之战)40级近卫队凌统，40级猛兽兵团甘宁，38级战车丁奉，39级战车徐盛，47级妖术师陆逊。
--(如果只打西陵之战)51级近卫队凌统，51级猛兽兵团甘宁，49级战车丁奉，50级战车徐盛，53级妖术师陆逊。
--(如果打了彝陵之战)53级近卫队凌统，53级猛兽兵团甘宁，52级战车丁奉，53级战车徐盛，56级妖术师陆逊。
 WarIni();
 DefineWarMap(24,"第四章 襄阳II之战","一、曹仁的结局",40,0,18);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,8,20, 2,0,-1,0,
 125,8,21, 2,0,-1,0,
 -1,7,19, 2,0,-1,0,
 -1,9,19, 2,0,-1,0,
 -1,8,18, 2,0,-1,0,
 -1,10,20, 2,0,-1,0,
 -1,9,21, 2,0,-1,0,
 -1,7,22, 2,0,-1,0,
 150,12,22, 2,0,-1,0,
 147,11,21, 2,0,-1,0,
 166,11,19, 2,0,-1,0,
 165,12,20, 2,0,-1,0,
 164,13,21, 2,0,-1,0,
 372,1,16, 4,0,-1,1,
 });
 DrawSMap();
 talk( 126,"首先进攻离此最近的襄阳吧．");
 JY.Smap={};
 SetSceneID(0,3);
 ModifyForce(121+1,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 18,18,4, 1,2,55,3, 0,0,-1,0,
 168,14,9, 1,2,52,3, 0,0,-1,0,
 121,16,6, 1,0,52,9, 0,0,-1,0, --文聘
 256,17,5, 1,2,48,3, 0,0,-1,0,
 257,17,6, 1,2,48,3, 0,0,-1,0,
 258,11,15, 1,2,47,3, 0,0,-1,0,
 259,10,15, 1,2,47,3, 0,0,-1,0,
 260,9,8, 1,2,48,3, 0,0,-1,0,
 261,11,9, 1,1,47,3, 0,0,-1,0,
 292,8,11, 1,1,51,9, 0,0,-1,0,
 293,13,11, 1,1,51,9, 0,0,-1,0,
 274,18,5, 1,1,48,6, 0,0,-1,0,
 275,7,8, 1,0,48,6, 0,0,-1,0,
 276,11,14, 1,2,48,6, 0,0,-1,0,
 277,10,14, 1,2,48,6, 0,0,-1,0,
 
 83,21,18, 3,3,51,21, 0,0,-1,1,
 170,18,18, 3,3,50,9, 0,0,-1,1,
 294,17,18, 3,3,45,9, 0,0,-1,1,
 295,19,17, 3,3,45,9, 0,0,-1,1,
 296,22,17, 3,3,44,9, 0,0,-1,1,
 297,23,18, 3,3,44,9, 0,0,-1,1,
 298,22,19, 3,3,45,9, 0,0,-1,1,
 262,14,3, 3,0,47,3, 0,0,-1,0,
 263,14,4, 3,0,48,3, 0,0,-1,0,
 264,4,8, 1,2,48,3, 0,0,-1,0,
 278,9,10, 1,2,46,6, 0,0,-1,0,
 279,10,10, 1,2,46,6, 0,0,-1,0,
 280,15,8, 1,2,47,6, 0,0,-1,0,
 281,15,11, 1,2,47,6, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [605]=function()
 PlayBGM(11);
 talk( 19,"蜀军就要攻来了！一定要挡住他们！",
 126,"听说敌军主将是曹仁．攻下襄阳，再夺回荆州．",
 151,"大家不要落在蜀军后面！向天下显示吴军的实力！");
 WarShowTarget(true);
 SetFlag(903,1); --曹仁存活，默认
 PlayBGM(9);
 NextEvent();
 end,
 [606]=function()
 WarLocationItem(3,10,172,98); --获得道具:获得道具：茶 改为 弓骑指南书
 WarLocationItem(8,5,18,99); --获得道具:获得道具：马术指南书
 WarLocationItem(3,16,2,100); --获得道具:获得道具：青囊书
 if (not GetFlag(1065)) and WarCheckArea(-1,7,4,12,14) then
 PlayBGM(11);
 WarShowArmy(83);
 WarShowArmy(170);
 WarShowArmy(294);
 WarShowArmy(295);
 WarShowArmy(296);
 WarShowArmy(297);
 WarShowArmy(298);
 DrawStrBoxCenter("敌人的援军到达！");
 talk( 19,"哦，援军来了吗？大家加把劲！援军已到，一鼓作气杀回去！",
 1,"没想到……敌人的援军到了．");
 if GetFlag(58) then
 PlayBGM(12);

JY.Person[372+1]["兵种"]=JY.Person[2]["兵种"]
local bzid=JY.Person[2]["兵种"]
for id=1,War.PersonNum do
if War.Person[id].id==372+1 then
 War.Person[id].bz=bzid;
 War.Person[id].movewav=JY.Bingzhong[bzid]["音效"]; --移动音效
 War.Person[id].atkwav=JY.Bingzhong[bzid]["攻击音效"]; --攻击音效
 War.Person[id].movestep=JY.Bingzhong[bzid]["移动"]; --移动范围
 War.Person[id].movespeed=JY.Bingzhong[bzid]["移动速度"]; --移动速度
 War.Person[id].atkfw=JY.Bingzhong[bzid]["攻击范围"]; --攻击范围
 War.Person[id].pic=WarGetPic(id);
end
end
JY.Person[372+1]["兵力"]=JY.Person[2]["最大兵力"]
JY.Person[372+1]["策略"]=JY.Person[2]["最大策略"]
for i=1,8 do
JY.Person[372+1]["道具"..i]=JY.Person[2]["道具"..i]
end

 WarShowArmy(372);
 WarModifyAI(372,5,18);
 talk( 372+1,"不能让魏国长期霸占荆州．");
 end
 PlayBGM(9);
 SetFlag(1065,1);
 end
 if WarMeet(373,19) then
 WarAction(1,373,19);
 talk( 373,"曹仁，久违了．",
 19,"哦，何人？你……，是你！还活着！？",
 373,"我怎会这么容易就死，现在我要雪荆州之恨！",
 19,"哼！来吧！");
 WarAction(6,373,19);
 if fight(373,19)==1 then
 talk( 19,"我来也！",
 373,"好小子！你哪里是我的对手！");
 WarAction(5,19,373);
 talk( 373,"不陪你玩了！先宰了再说！！");
 WarAction(8,373,19);
 talk( 19,"哇！");
 WarAction(18,19);
 DrawStrBoxCenter("神秘武将杀了曹仁！");
 SetFlag(903,0); --曹仁死亡
 talk( 1,"怎么？发生了什么事？",
 126,"敌人内哄了？一定要抓住这个时机！",
 1,"好，猛劲杀过去！");
 NextEvent();
 else
 WarAction(4,19,373);
 talk( 373,"………………");
 WarAction(17,373);
 WarLvUp(GetWarID(19));
 end
 end
 if JY.Status==GAME_WARWIN then
 talk( 19,"可、可恶……刘备小儿！哇！！",
 --1,"好，杀了曹仁！",
 1,"好，打败了曹仁！");
 NextEvent();
 end
 end,
 [607]=function()
 PlayBGM(7);
 if GetFlag(903) then
 DrawMulitStrBox("　打败了曹仁，刘备军占领了襄阳．");
 else
 DrawMulitStrBox("　杀了曹仁，刘备军占领了襄阳．");
 end
 if GetFlag(58) then
 PlayBGM(2);
 talk( 373,"……我哪有面目去见兄长……");
 WarAction(16,373);
 DrawStrBoxCenter("神秘武将走了．");
 talk( 1,"嗯！那是……？莫非……",
 3,"大哥，怎么了？",
 1,"奇怪……没什么……",
 3,"大哥，不舒服吗？高兴点．",
 1,"是呀．（肯定是看花眼了，莫非……）好，进襄阳吧！");
 PlayBGM(7);
 end
 GetMoney(1500);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１５００！");
 if not GetFlag(903) then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [608]=function()
 SetSceneID(0,3);
 talk( 126,"那就进襄阳城吧．");
 --显示任务目标:<在襄阳商议下一步行动>
 NextEvent();
 end,
 [609]=function()
 JY.Smap={};
 JY.Base["现在地"]="襄阳";
 JY.Base["道具屋"]=24;
 AddPerson(1,25,9,1);
 AddPerson(126,20,9,1);
 if GetFlag(135) then
 AddPerson(3,25,15,2);
 end
 AddPerson(170,23,16,2);
 AddPerson(151,14,9,3);
 AddPerson(148,12,10,3);
 SetSceneID(86,5);
 DrawStrBoxCenter("襄阳议事厅");
 talk( 126,"恭喜主公，终于又夺回了襄阳．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [610]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，二哥虽已过世，但总觉得他还活着．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"贺喜主公，能重夺襄阳．");
 end
 if JY.Tid==151 then--陆逊
 talk( 151,"虽然打败了曹仁，但若要打到洛阳，还得先攻下宛城，于路上，敌人也会严阵以待．");
 end
 if JY.Tid==148 then--甘宁
 talk( 148,"初次相见，我乃东吴之臣甘宁．以后，我们会相处的很好的．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"要去洛阳，必须先通过新野或南郡，然后过宛城．",
 1,"嗯，若不攻下新野和南郡，有在宛城被夹击的危险．",
 126,"正是，应该请陆逊支援，同时进攻新野和南郡．");
 NextEvent();
 end
 end,
 [611]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，二哥虽已过世，但总觉得他还活着．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"贺喜主公，能重夺襄阳．");
 end
 if JY.Tid==151 then--陆逊
 talk( 151,"你们的话，我都听到了．我是去打新野还是南郡？决定后告诉我．");
 NextEvent();
 end
 if JY.Tid==148 then--甘宁
 talk( 148,"我们东吴之臣也愿与蜀军合力对付魏国．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"正是，应该请陆逊支援，同时进攻新野和南郡．");
 end
 end,
 [612]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，二哥虽已过世，但总觉得他还活着．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"贺喜主公，能重夺襄阳．");
 end
 if JY.Tid==151 then--陆逊
 if talkYesNo( 151,"考虑的如何了？") then
 RemindSave();
 DrawSMap();
 local menu={
 {"请陆逊去攻打南郡",nil,1},
 {"请陆逊去攻打新野",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,C_WHITE,C_WHITE);
 if r==1 then
 SetFlag(92,1);
 talk( 151,"好吧，那我就去打南郡．");
 elseif r==2 then
 talk( 151,"好吧，那我就去打新野．");
 end
 MovePerson( 151,12,1,
 148,12,1);
 DecPerson(151);
 DecPerson(148);
 talk( 126,"我们也出发吧，准备好了，请告诉我．",
 170,"那我们先准备去．");
 if GetFlag(135) then
 MovePerson( 3,12,1,
 170,12,1);
 DecPerson(3);
 DecPerson(170);
 else
 MovePerson( 170,12,1);
 DecPerson(170);
 end
 --显示任务目标:<进行出征准备．>
 NextEvent();
 end
 end
 if JY.Tid==148 then--甘宁
 talk( 148,"如果拿下新野和南郡，后面就只剩下宛城了．");
 end
 if JY.Tid==126 then--诸葛亮
 talk( 126,"听说于禁镇守新野，徐晃镇守南郡．");
 end
 end,
 [613]=function()
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 126,"请编组部队．");
 WarIni();
 if GetFlag(92) then
 DefineWarMap(47,"第四章 新野II之战","一、于禁的撤退．*二、自军部队夺取粮仓．",40,0,62);
 SelectTerm(1,{
 0,3,6, 4,0,-1,0,
 125,4,7, 4,0,-1,0,
 -1,2,6, 4,0,-1,0,
 -1,2,7, 4,0,-1,0,
 -1,5,8, 4,0,-1,0,
 -1,7,4, 4,0,-1,0,
 -1,7,5, 4,0,-1,0,
 -1,8,3, 4,0,-1,0,
 -1,9,5, 4,0,-1,0,
 -1,3,9, 4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 62,22,12, 3,2,55,25, 0,0,-1,0,
 256,24,14, 3,2,45,3, 0,0,-1,0,
 101,20,13, 3,0,52,9, 0,0,-1,0, --张绣
 115,21,15, 3,0,52,3, 0,0,-1,0, --李典
 299,13,13, 3,0,52,9, 0,0,-1,0,
 300,13,15, 3,0,49,9, 0,0,-1,0,
 301,15,11, 3,0,50,9, 0,0,-1,0,
 260,17,13, 3,2,51,3, 0,0,-1,0,
 261,21,17, 3,2,51,3, 0,0,-1,0,
 274,14,7, 3,2,48,6, 0,0,-1,0,
 275,16,7, 3,2,48,6, 0,0,-1,0,
 276,18,13, 3,2,46,6, 0,0,-1,0,
 277,21,16, 3,2,46,6, 0,0,-1,0,
 292,8,14, 3,0,49,9, 0,0,-1,0,
 293,19,13, 3,0,52,9, 0,0,-1,0,
 294,22,13, 3,0,51,9, 0,0,-1,0,
 
 332,15,13, 3,0,45,14, 0,0,-1,0,
 278,21,11, 3,2,44,6, 0,0,-1,0,
 257,15,6, 3,2,43,3, 0,0,-1,0,
 67,0,18, 4,1,55,9, 0,0,-1,1,
 295,1,19, 4,1,52,9, 0,0,-1,1,
 296,17,0, 3,1,49,9, 0,0,-1,1,
 297,18,0, 3,1,49,9, 0,0,-1,1,
 298,19,1, 3,1,50,9, 0,0,-1,1,
 });
 else
 DefineWarMap(46,"第四章 南郡之战","一、徐晃的撤退．*二、占领两个鹿砦．",40,0,78);
 SelectTerm(1,{
 0,3,18, 4,0,-1,0,
 125,2,18, 4,0,-1,0,
 -1,1,15, 4,0,-1,0,
 -1,1,17, 4,0,-1,0,
 -1,1,19, 4,0,-1,0,
 -1,2,16, 4,0,-1,0,
 -1,3,17, 4,0,-1,0,
 -1,4,16, 4,0,-1,0,
 -1,5,18, 4,0,-1,0,
 -1,6,17, 4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 78,22,6, 3,2,56,9, 0,0,-1,0,
 209,16,14, 3,2,53,21, 0,0,-1,0,
 101,22,7, 3,0,52,9, 0,0,-1,0, --张绣
 115,22,8, 3,0,52,3, 0,0,-1,0, --李典
 274,17,17, 3,2,49,6, 0,0,-1,0,
 256,10,3, 3,4,47,3, 3,11,-1,0,
 257,13,5, 3,4,47,3, 3,11,-1,0,
 258,16,18, 3,2,47,3, 0,0,-1,0,
 292,5,5, 3,0,48,9, 0,0,-1,0,
 293,3,5, 3,0,48,9, 0,0,-1,0,
 294,4,5, 3,0,52,9, 0,0,-1,0,
 295,13,6, 3,0,48,9, 0,0,-1,0,
 296,19,6, 3,0,52,9, 0,0,-1,0,
 275,4,4, 3,0,49,6, 0,0,-1,0,
 276,14,8, 3,0,46,6, 0,0,-1,0,
 277,21,7, 3,0,46,6, 0,0,-1,0,
 
 310,12,10, 3,0,48,12, 0,0,-1,0,
 311,12,12, 3,0,47,12, 0,0,-1,0,
 297,8,0, 3,1,52,9, 0,0,-1,1,
 298,9,1, 3,1,52,9, 0,0,-1,1,
 299,11,1, 3,1,48,9, 0,0,-1,1,
 300,7,1, 3,1,48,9, 0,0,-1,1,
 });
 end
 JY.Smap={};
 SetSceneID(0,3);
 if GetFlag(92) then
 talk( 151,"那好刘备公，我们去打南郡．",
 1,"嗯，拜托了．",
 126,"我们也向新野出发吧．");
 NextEvent(614); --goto 614
 else
 talk( 151,"那好刘备公，我们去打新野．",
 1,"嗯，拜托了．",
 126,"我们也向南郡出发吧．");
 NextEvent(617); --goto 617
 end
 JY.Status=GAME_WMAP;
 end
 end
 end,
 [614]=function()
 PlayBGM(11);
 talk( 63,"别放刘备军过去，一个兵也不行．",
 126,"新野的敌方守将是于禁．攻下这里，就能以此为根据进攻宛城．");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [615]=function()
 WarLocationItem(19,3,52,101); --获得道具:获得道具：勇气书
 if (not GetFlag(1066)) and War.Turn==8 then
 PlayBGM(11);
 WarShowArmy(67);
 WarShowArmy(295);
 WarShowArmy(296);
 WarShowArmy(297);
 WarShowArmy(298);
 DrawStrBoxCenter("敌人援军到达！");
 talk( 68,"别放刘备军过去，将其赶回江陵！",
 63,"啊，援军！兄弟们，援军来了！大家坚守住！");
 PlayBGM(9);
 SetFlag(1066,1);
 end
 if (not GetFlag(1067)) and WarCheckLocation(-1,14,24) then
 talk( 63,"什么？粮仓丢了！如此，怎么守城！可恶，撤到宛城！");
 WarAction(16,63);
 SetFlag(1067,1);
 NextEvent();
 end
 if WarMeet(3,63) then
 WarAction(1,3,63);
 talk( 3,"对面可是于禁！敢与我张飞一战！",
 63,"坏了！张飞！！哇！",
 3,"为我二哥关羽报仇！你等死吧！我来也！");
 WarAction(6,3,63);
 if fight(3,63)==1 then
 WarAction(8,3,63);
 talk( 3,"如何！你不是我对手！",
 63,"可恶！活命要紧！张飞，后会有期！！",
 3,"呸！别跑！这岂是大将所为！");
 talk( 63,"撤退！快回宛城！");
 WarAction(16,63);
 WarLvUp(GetWarID(3));
 NextEvent();
 else
 WarAction(4,63,3);
 talk( 3,"可恶！");
 WarAction(17,3);
 WarLvUp(GetWarID(63));
 end
 end
 if JY.Status==GAME_WARWIN then
 talk( 63,"可、可恶！撤退！回宛城！");
 NextEvent();
 end
 end,
 [616]=function()
 PlayBGM(7);
 DrawMulitStrBox("　于禁撤退了，刘备军占领新野．");
 talk( 1,"干得好！如此，再攻下宛城，就直逼洛阳了！");
 GetMoney(1500);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１５００！");
 if GetFlag(1067) then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(620); --goto 620
 end,
 [617]=function()
 PlayBGM(11);
 talk( 79,"刘备虽来了！但是绝不让他们过去，我们用水攻．",
 126,"此……！主公！此处危险！",
 1,"何出此言？",
 126,"此处想必原是旧河床！敌军肯定在上流建堤拦住水流！一旦放水而下，我军将完全被激流吞没！",
 1,"可是，陆逊正在新野作战，我们如果撤退，陆逊将孤立无援．",
 126,"那就夺取敌军城堡吧，除此别无他法．",
 1,"好吧，全军迅速攻取敌军城堡！");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [618]=function()
 if WarMeet(44,210) then
 WarAction(1,44,210);
 talk( 44,"我乃张飞之子张苞是也！来将可敢与我单打独斗！",
 210,"原来是张飞之子．我夏侯尚不以为怪，来得好，先打再说吧！");
 WarAction(6,44,210);
 if fight(44,210)==1 then
 talk( 210,"打就打吧……",
 44,"哼！刚才不知天高地厚，现在后悔了吧！");
 WarAction(8,44,210);
 talk( 210,"啊！不、不愧为张飞之……子……");
 WarAction(17,210);
 talk( 44,"夏侯尚，俺张苞送你见阎王！");
 WarLvUp(GetWarID(44));
 else
 WarAction(4,210,44);
 talk( 44,"啊！不……不……");
 WarAction(17,44);
 WarLvUp(GetWarID(210));
 end
 end
 WarLocationItem(3,3,40,102); --获得道具:获得道具：海啸书
 WarLocationItem(0,10,47,103); --获得道具:获得道具：援队书
 if (not GetFlag(104)) and WarCheckLocation(-1,7,19) then
 GetMoney(2000);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金２０００！");
 SetFlag(104,1);
 end
 if (not GetFlag(105)) and WarCheckLocation(-1,14,16) then
 DrawStrBoxCenter("占领北面城堡！");
 SetFlag(105,1);
 if (not GetFlag(110)) and GetFlag(105) and GetFlag(106) then
 PlayBGM(7);
 talk( 1,"干得漂亮！占领了城堡，无须担心敌人水攻了．一口气击垮徐晃！",
 79,"什么！城堡被占领了！哼，我的妙计不成，没办法，回军宛城！");
 WarAction(16,79);
 NextEvent();
 end
 end
 if (not GetFlag(106)) and WarCheckLocation(-1,17,17) then
 DrawStrBoxCenter("占领南面城堡！");
 SetFlag(106,1);
 if (not GetFlag(110)) and GetFlag(105) and GetFlag(106) then
 PlayBGM(7);
 talk( 1,"干得漂亮！占领了城堡，无须担心敌人水攻了．一口气击垮徐晃！",
 79,"什么！城堡被占领了！哼，我的妙计不成，没办法，回军宛城！");
 WarAction(16,79);
 NextEvent();
 end
 end
 if (not GetFlag(1068)) and War.Turn==10 then
 talk( 79,"太好了，现在马上决堤，放水淹刘备军．");
 PlayWavE(53);
 WarFireWater(14,15,2);
 WarFireWater(13,14,2);
 WarFireWater(12,14,2);
 WarFireWater(11,14,2);
 WarFireWater(6,13,2);
 WarFireWater(5,12,2);
 WarFireWater(4,12,2);
 WarFireWater(3,12,2);
 WarFireWater(2,11,2);
 WarFireWater(1,11,2);
 WarFireWater(0,11,2);
 WarFireWater(12,12,2);
 WarFireWater(5,10,2);
 WarFireWater(4,10,2);
 WarFireWater(3,9,2);
 WarFireWater(2,9,2);
 WarFireWater(1,9,2);
 WarFireWater(0,8,2);
 WarFireWater(6,7,2);
 WarFireWater(5,7,2);
 WarFireWater(4,6,2);
 WarFireWater(3,6,2);
 WarFireWater(12,11,2);
 WarFireWater(17,13,2);
 WarFireWater(17,12,2);
 WarFireWater(15,10,2);
 WarFireWater(14,9,2);
 WarFireWater(14,8,2);
 WarFireWater(14,6,2);
 WarFireWater(13,5,2);
 WarFireWater(10,8,2);
 WarFireWater(10,7,2);
 WarFireWater(12,3,2);
 WarFireWater(11,5,2);
 WarFireWater(11,4,2);
 WarFireWater(10,4,2);
 WarFireWater(9,3,2);
 WarFireWater(7,4,2);
 WarFireWater(6,4,2);
 WarEnemyWeak(1,1);
 WarEnemyWeak(1,2);
 talk( 126,"来不及了……",
 79,"哈哈哈！刘备小儿，活该！全军进攻刘备军．");
 WarShowArmy(297);
 WarShowArmy(298);
 WarShowArmy(299);
 WarShowArmy(300);
 WarModifyAI(101,1); --张绣
 WarModifyAI(115,1); --李典
 WarModifyAI(256,1);
 WarModifyAI(257,1);
 WarModifyAI(258,1);
 WarModifyAI(292,1);
 WarModifyAI(293,1);
 WarModifyAI(294,1);
 WarModifyAI(295,1);
 WarModifyAI(296,1);
 WarModifyAI(275,1);
 WarModifyAI(276,1);
 WarModifyAI(310,1);
 WarModifyAI(311,1);
 War.WarTarget="一、徐晃的撤退．";
 WarShowTarget(false);
 SetFlag(1068,1);
 SetFlag(105,1);
 SetFlag(106,1);
 SetFlag(110,1);
 PlayBGM(9);
 end
 if (not GetFlag(1069)) and War.Turn==11 then
 WarFireWater(3,6,3);
 WarFireWater(5,7,3);
 WarFireWater(6,7,3);
 WarFireWater(1,9,3);
 WarFireWater(4,10,3);
 WarFireWater(5,10,3);
 WarFireWater(12,12,3);
 WarFireWater(3,12,3);
 WarFireWater(0,11,3);
 WarFireWater(12,11,3);
 WarFireWater(14,8,3);
 WarFireWater(10,8,3);
 WarFireWater(10,7,3);
 WarFireWater(9,3,3);
 WarFireWater(6,4,3);
 SetFlag(1069,1);
 end
 if (not GetFlag(1070)) and War.Turn==12 then
 WarFireWater(4,6,3);
 WarFireWater(0,8,3);
 WarFireWater(3,9,3);
 WarFireWater(11,14,3);
 WarFireWater(13,14,3);
 WarFireWater(1,11,3);
 WarFireWater(4,12,3);
 WarFireWater(17,13,3);
 WarFireWater(13,5,3);
 WarFireWater(11,5,3);
 WarFireWater(10,4,3);
 WarFireWater(7,4,3);
 SetFlag(1070,1);
 end
 if (not GetFlag(1071)) and War.Turn==13 then
 WarFireWater(2,9,3);
 WarFireWater(2,11,3);
 WarFireWater(5,12,3);
 WarFireWater(6,13,3);
 WarFireWater(12,14,3);
 WarFireWater(14,15,3);
 WarFireWater(17,12,3);
 WarFireWater(15,10,3);
 WarFireWater(14,9,3);
 WarFireWater(14,6,3);
 WarFireWater(12,3,3);
 WarFireWater(11,4,3);
 SetFlag(1071,1);
 end
 if JY.Status==GAME_WARWIN then
 talk( 79,"可恶！先撤退再说！回宛城！");
 PlayBGM(7);
 NextEvent();
 end
 end,
 [619]=function()
 DrawMulitStrBox("　徐晃撤退了，刘备军占领了南郡．");
 talk( 1,"干得漂亮！此去陷落宛城，洛阳就在眼前了！");
 GetMoney(1500);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１５００！");
 if (not GetFlag(110)) and (GetFlag(105) or GetFlag(106)) then
 WarGetExp();
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [620]=function()
 JY.Smap={};
 JY.Base["现在地"]="新野";
 JY.Base["道具屋"]=0;
 AddPerson(1,25,9,1);
 AddPerson(126,20,9,1);
 if GetFlag(135) then
 AddPerson(3,26,12,1);
 end
 AddPerson(170,11,10,3);
 AddPerson(203,7,12,3);
 AddPerson(175,24,17,2);
 AddPerson(151,15,14,0);
 SetSceneID(95,5);
 DrawStrBoxCenter("新野营帐");
 DrawMulitStrBox("　这里是刘备军的营帐，刘备军为进攻宛城，陈兵于新野，谋划今后的对策．");
 --AddPerson(369,4,21,0);
 --MovePerson( 369,8,0);
 --MovePerson( 369,10,1);
 --DecPerson(369);
 talk( 1,"陆逊大人，辛苦了．",
 151,"此须小事，何足挂齿．蜀军如此强大，也让人惊奇．刘备公，我主有令，命我返回，实在对不起……",
 1,"好吧，那就请代我向孙权致意．",
 151,"多谢．那我留下他们留在这里帮忙．");
 if GetFlag(132) then
 AddPerson(148,5,22,0);
 MovePerson( 148,6,0);
 talk( 148,"奉陆逊都督之命，我与凌统、徐盛、丁奉留在这里与刘备公并肩作战，听从您的调遣．");
 ModifyForce(148,1);
 ModifyForce(167,1);
 ModifyForce(166,1);
 ModifyForce(165,1);
 JY.Person[148]["道具1"]=0;
 JY.Person[148]["道具2"]=0;
 JY.Person[167]["道具1"]=0;
 JY.Person[167]["道具2"]=0;
 JY.Person[166]["道具1"]=0;
 JY.Person[166]["道具2"]=0;
 JY.Person[165]["道具1"]=0;
 JY.Person[165]["道具2"]=0;
 PlayWavE(11);
 DrawStrBoxCenter("甘宁、凌统、徐盛、丁奉加入！");
 elseif GetFlag(136) then
 AddPerson(167,5,22,0);
 MovePerson( 167,6,0);
 talk( 167,"奉陆逊都督之命，我与徐盛、丁奉留在这里与刘备公并肩作战，听从您的调遣．");
 ModifyForce(167,1);
 ModifyForce(166,1);
 ModifyForce(165,1);
 JY.Person[167]["道具1"]=0;
 JY.Person[167]["道具2"]=0;
 JY.Person[166]["道具1"]=0;
 JY.Person[166]["道具2"]=0;
 JY.Person[165]["道具1"]=0;
 JY.Person[165]["道具2"]=0;
 PlayWavE(11);
 DrawStrBoxCenter("凌统、徐盛、丁奉加入！");
 else
 AddPerson(166,5,22,0);
 MovePerson( 166,6,0);
 talk( 166,"奉陆逊都督之命，我与丁奉留在这里与刘备公并肩作战，听从您的调遣．");
 ModifyForce(166,1);
 ModifyForce(165,1);
 JY.Person[166]["道具1"]=0;
 JY.Person[166]["道具2"]=0;
 JY.Person[165]["道具1"]=0;
 JY.Person[165]["道具2"]=0;
 PlayWavE(11);
 DrawStrBoxCenter("徐盛、丁奉加入！");
 end
 talk( 1,"哦，这下有倚仗了．陆逊都督，多谢了．",
 151,"那我先走一步．");
 MovePerson( 151,7,1);
 talk( 151,"（刘备、还有孔明……与之为敌不会有好下场．如果主公也不了解我的苦心……）");
 MovePerson( 151,2,1);
 DecPerson(151);
 talk( 126,"那就乘势进攻宛城吧，请作出征准备．");
 --显示任务目标:<进行出征准备>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [621]=function()
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，早做准备．");
 end
 if JY.Tid==175 then--马良
 talk( 175,"主公，请作出征准备．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"主公，请让我出征吧．");
 end
 if JY.Tid==203 then--严颜
 talk( 203,"主公，请让我出征吧．");
 end
 if JY.Tid==148 then--甘宁
 talk( 148,"刘备公，以后请多关照．");
 end
 if JY.Tid==167 then--凌统
 talk( 167,"刘备公，以后请多关照．");
 end
 if JY.Tid==166 then--徐盛
 talk( 166,"刘备公，以后请多关照．");
 end
 if JY.Tid==165 then--丁奉
 talk( 165,"刘备公，以后请多关照．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 PlayBGM(12);
 talk( 126,"请编组部队．");
 LvUp(2,6);
 LvUp(128,6);
 LvUp(155,6);
 LvUp(38,6);
 LvUp(39,6);
 LvUp(34,6);
 WarIni();
 if GetFlag(90) then
 DefineWarMap(49,"第四章 宛II之战","一、夏侯惇的撤退",50,0,16);
 SelectTerm(1,{
 0,8,20, 2,0,-1,0,
 125,7,20, 2,0,-1,0,
 -1,4,18, 2,0,-1,0,
 -1,6,17, 2,0,-1,0,
 -1,6,19, 2,0,-1,0,
 -1,7,18, 2,0,-1,0,
 -1,9,18, 2,0,-1,0,
 -1,9,19, 2,0,-1,0,
 -1,9,21, 2,0,-1,0,
 -1,11,19, 2,0,-1,0,
 1,23,5, 3,0,-1,1,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 16,12,3, 1,2,59,9, 0,0,-1,0,
 78,11,8, 1,2,56,9, 0,0,-1,0,
 62,15,14, 1,2,55,25, 0,0,-1,0, --原版居然是发石车
 93,9,4, 1,0,58,16, 0,0,-1,0, --贾诩
 18,15,5, 1,0,58,3, 0,0,903,0, --曹仁
 209,9,9, 1,0,55,21, 0,0,-1,0, --夏侯尚
 256,4,8, 1,2,54,3, 0,0,-1,0,
 257,16,10, 1,2,54,3, 0,0,-1,0,
 258,8,11, 1,2,49,3, 0,0,-1,0,
 259,9,3, 1,0,49,3, 0,0,-1,0,
 260,8,6, 1,0,50,3, 0,0,-1,0,
 261,9,11, 1,2,50,3, 0,0,-1,0,
 262,18,5, 1,0,49,3, 0,0,-1,0,
 292,5,3, 1,0,54,9, 0,0,-1,0,
 293,5,11, 1,2,54,9, 0,0,-1,0,
 294,6,4, 1,0,52,9, 0,0,-1,0,
 295,8,9, 1,0,52,9, 0,0,-1,0,
 296,19,7, 1,0,53,9, 0,0,-1,0,
 297,13,7, 1,0,53,9, 0,0,-1,0,
 298,13,9, 1,0,52,9, 0,0,-1,0,
 299,16,7, 1,0,52,9, 0,0,-1,0,
 300,18,7, 1,0,51,9, 0,0,-1,0,
 274,5,7, 1,2,50,6, 0,0,-1,0,
 275,6,13, 1,2,54,6, 0,0,-1,0,
 276,7,12, 1,2,54,6, 0,0,-1,0,
 277,8,4, 1,0,50,6, 0,0,-1,0,
 278,18,4, 1,0,50,6, 0,0,-1,0,
 279,12,5, 1,0,50,6, 0,0,-1,0,
 --援兵
 67,18,21, 3,3,57,12, 0,0,-1,1, --许褚/贼兵
 310,19,21, 3,3,52,12, 0,0,-1,1,
 311,19,22, 3,3,52,12, 0,0,-1,1,
 312,18,22, 3,3,51,12, 0,0,-1,1,
 313,20,22, 3,3,51,12, 0,0,-1,1,
 --援兵
 79,4,22, 4,1,58,9, 0,0,-1,1, --张辽/骑兵
 115,3,21, 4,1,54,3, 0,0,-1,1, --李典
 217,2,20, 4,1,54,9, 0,0,-1,1, --乐进
 263,0,20, 4,1,51,3, 0,0,-1,1,
 264,1,21, 4,1,51,3, 0,0,-1,1,
 265,2,22, 4,1,50,3, 0,0,-1,1,
 266,3,23, 4,1,49,3, 0,0,-1,1,
 });
 else
 DefineWarMap(48,"第四章 宛I之战","一、张辽的撤退",40,0,79);
 SelectTerm(1,{
 0,2,15, 4,0,-1,0,
 125,2,14, 4,0,-1,0,
 -1,0,13, 4,0,-1,0,
 -1,0,17, 4,0,-1,0,
 -1,1,14, 4,0,-1,0,
 -1,1,16, 4,0,-1,0,
 -1,2,17, 4,0,-1,0,
 -1,3,16, 4,0,-1,0,
 -1,3,19, 4,0,-1,0,
 -1,4,17, 4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 79,15,6, 3,2,58,25, 0,0,-1,0,
 256,12,10, 3,0,52,3, 0,0,-1,0,
 257,12,12, 3,0,50,3, 0,0,-1,0,
 258,10,9, 3,0,50,3, 3,11,-1,0,
 259,13,7, 3,0,49,3, 3,11,-1,0,
 260,14,7, 3,0,50,3, 0,0,-1,0,
 261,13,14, 3,0,49,3, 0,0,-1,0,
 274,13,11, 3,0,52,6, 0,0,-1,0,
 275,13,9, 3,0,50,6, 0,0,-1,0,
 276,15,12, 3,0,49,6, 0,0,-1,0,
 332,12,9, 3,0,50,14, 0,0,-1,0,
 
 217,25,15, 3,1,54,9, 0,0,-1,1,
 292,24,15, 3,1,52,9, 0,0,-1,1,
 293,25,17, 3,1,51,9, 0,0,-1,1,
 294,26,14, 3,1,51,9, 0,0,-1,1,
 295,26,16, 3,1,50,9, 0,0,-1,1,
 296,27,15, 3,1,50,9, 0,0,-1,1,
 115,14,1, 3,1,54,3, 0,0,-1,1,
 297,12,1, 3,1,52,9, 0,0,-1,1,
 298,13,2, 3,1,51,9, 0,0,-1,1,
 299,14,3, 3,1,51,9, 0,0,-1,1,
 300,15,2, 3,1,50,9, 0,0,-1,1,
 301,16,1, 3,1,50,9, 0,0,-1,1,
 });
 end
 DrawSMap();
 talk( 126,"现在进兵宛城吧．")
 JY.Smap={};
 if GetFlag(90) then
 SetSceneID(0,3);
 talk( 142,"我军攻打合淝，绊住张辽，全军！出发！")
 SetSceneID(0);
 talk( 80,"哎呀！不能去增援夏侯惇了，可恶！")
 NextEvent(626); --goto 626
 else
 SetSceneID(0,11);
 talk( 142,"我们先坐山观蜀魏两虎相斗．凭什么帮刘备，对我来说，最好两败俱伤．")
 SetSceneID(0,11);
 talk( 80,"吴军不来进攻合淝，太好了，全军马上行动，袭击刘备军侧翼．")
 NextEvent(622); --goto 622
 end
 JY.Status=GAME_WMAP;
 end
 end
 end,
 [622]=function()
 PlayBGM(11);
 talk( 80,"太好了，好像来得及，全军注意，突击刘备军侧翼．",
 126,"主公，遭到攻击．合淝的张辽军急袭至此．",
 1,"嗯……全军迎击张辽，把他赶回去！");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [623]=function()
 WarLocationItem(13,14,47,107); --获得道具:获得道具：援队书
 WarLocationItem(3,17,146,108); --获得道具:获得道具：猛火书 改为 白银甲
 WarLocationItem(17,27,34,109); --获得道具:获得道具：炸弹
 if (not GetFlag(1072)) and War.Turn==8 then
 PlayBGM(11);
 WarShowArmy(217);
 WarShowArmy(292);
 WarShowArmy(293);
 WarShowArmy(294);
 WarShowArmy(295);
 WarShowArmy(296);
 DrawStrBoxCenter("张辽的援军到达！");
 talk( 218,"张辽！别松劲！乐进来了！",
 80,"哦，乐进来了！好不容易赶来吧！太棒了，援军来了！");
 PlayBGM(9);
 SetFlag(1072,1);
 end
 if (not GetFlag(1073)) and War.Turn==10 then
 PlayBGM(11);
 WarShowArmy(115);
 WarShowArmy(297);
 WarShowArmy(298);
 WarShowArmy(299);
 WarShowArmy(300);
 WarShowArmy(301);
 DrawStrBoxCenter("张辽的援军到达！");
 talk( 116,"张辽，抱歉，来晚了！",
 80,"哦，李典终于来了！好，发动总攻击！");
 PlayBGM(9);
 SetFlag(1073,1);
 end
 if WarMeet(3,80) then
 WarAction(1,3,80);
 talk( 3,"张辽，好久不见了！",
 80,"张飞吗？来得好！单挑！",
 3,"哼，输给你，我就不是张飞！来吧，张辽！");
 WarAction(6,3,80);
 if fight(3,80)==1 then
 talk( 3,"喂，你不行了吧！",
 80,"呀，还是你厉害！",
 3,"看枪！！");
 WarAction(8,3,80);
 talk( 80,"哇！哼，没办法，全军撤退！张飞，后会有期！");
 WarAction(16,80);
 talk( 3,"呸，跑得倒快．哈，吕布一死，我就无敌于天下了！");
 WarLvUp(GetWarID(3));
 NextEvent();
 else
 WarAction(4,80,3);
 talk( 3,"……");
 WarAction(17,3);
 WarLvUp(GetWarID(80));
 end
 end
 if JY.Status==GAME_WARWIN then
 talk( 80,"哼，没办法，撤退！快撤！");
 NextEvent();
 end
 end,
 [624]=function()
 PlayBGM(7);
 DrawMulitStrBox("　张辽军撤退了．");
 GetMoney(1500);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１５００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [625]=function()
 SetSceneID(0,3);
 talk( 1,"终于顶住了，好，全军重新整编，马上进攻宛城．",
 126,"请编组部队．");
 WarIni();
 DefineWarMap(49,"第四章 宛II之战","一、夏侯惇的撤退",50,0,16);
 SelectTerm(1,{
 0,8,20, 2,0,-1,0,
 125,7,20, 2,0,-1,0,
 -1,4,18, 2,0,-1,0,
 -1,6,17, 2,0,-1,0,
 -1,6,19, 2,0,-1,0,
 -1,7,18, 2,0,-1,0,
 -1,9,18, 2,0,-1,0,
 -1,9,19, 2,0,-1,0,
 -1,9,21, 2,0,-1,0,
 -1,11,19, 2,0,-1,0,
 1,23,5, 3,0,-1,1,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 16,12,3, 1,2,59,9, 0,0,-1,0,
 78,11,8, 1,2,56,9, 0,0,-1,0,
 62,15,14, 1,2,55,25, 0,0,-1,0, --原版居然是发石车
 93,9,4, 1,0,58,16, 0,0,-1,0, --贾诩
 18,15,5, 1,0,58,3, 0,0,903,0, --曹仁
 209,9,9, 1,0,55,21, 0,0,-1,0, --夏侯尚
 256,4,8, 1,2,54,3, 0,0,-1,0,
 257,16,10, 1,2,54,3, 0,0,-1,0,
 258,8,11, 1,2,49,3, 0,0,-1,0,
 259,9,3, 1,0,49,3, 0,0,-1,0,
 260,8,6, 1,0,50,3, 0,0,-1,0,
 261,9,11, 1,2,50,3, 0,0,-1,0,
 262,18,5, 1,0,49,3, 0,0,-1,0,
 292,5,3, 1,0,54,9, 0,0,-1,0,
 293,5,11, 1,2,54,9, 0,0,-1,0,
 294,6,4, 1,0,52,9, 0,0,-1,0,
 295,8,9, 1,0,52,9, 0,0,-1,0,
 296,19,7, 1,0,53,9, 0,0,-1,0,
 297,13,7, 1,0,53,9, 0,0,-1,0,
 298,13,9, 1,0,52,9, 0,0,-1,0,
 299,16,7, 1,0,52,9, 0,0,-1,0,
 300,18,7, 1,0,51,9, 0,0,-1,0,
 274,5,7, 1,2,50,6, 0,0,-1,0,
 275,6,13, 1,2,54,6, 0,0,-1,0,
 276,7,12, 1,2,54,6, 0,0,-1,0,
 277,8,4, 1,0,50,6, 0,0,-1,0,
 278,18,4, 1,0,50,6, 0,0,-1,0,
 279,12,5, 1,0,50,6, 0,0,-1,0,
 --援兵
 67,18,21, 3,3,57,12, 0,0,-1,1, --许褚/贼兵
 310,19,21, 3,3,52,12, 0,0,-1,1,
 311,19,22, 3,3,52,12, 0,0,-1,1,
 312,18,22, 3,3,51,12, 0,0,-1,1,
 313,20,22, 3,3,51,12, 0,0,-1,1,
 --援兵
 79,4,22, 4,1,58,9, 0,0,-1,1, --张辽/骑兵
 115,3,21, 4,1,54,3, 0,0,-1,1, --李典
 217,2,20, 4,1,54,9, 0,0,-1,1, --乐进
 263,0,20, 4,1,51,3, 0,0,-1,1,
 264,1,21, 4,1,51,3, 0,0,-1,1,
 265,2,22, 4,1,50,3, 0,0,-1,1,
 266,3,23, 4,1,49,3, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [626]=function()
 PlayBGM(11);
 talk( 17,"刘备，你太得意了！我夏侯惇要让你见识一下魏军的真正实力．",
 126,"主公，如果占领宛城，洛阳就在眼前了．快进攻吧！");
 WarShowTarget(true);
 PlayBGM(10);
 NextEvent();
 end,
 [627]=function()
 WarLocationItem(13,5,1,111); --获得道具:获得道具：遁甲天书
 WarLocationItem(12,19,18,112); --获得道具:获得道具：马术指南书
 WarLocationItem(3,16,19,113); --获得道具:获得道具：剑术指南书
 if (not GetFlag(216)) and WarCheckLocation(-1,15,15) then
 talk( 1,"好！降下吊桥！");
 --
 SetWarMap(16,17,1,4);
 PlayWavE(18);
 WarDelay(48);
 War.MapID=62;
 WarDelay(12);
 --
 DrawStrBoxCenter("吊桥降下来了！");
 talk( 79,"什么，吊桥被降下来了！？哼，于禁这家伙真靠不住！唉！以后再跟你算帐，迎击！");
 WarModifyAI(297,1);
 WarModifyAI(298,1);
 WarModifyAI(299,1);
 SetFlag(216,1);
 end
 if WarMeet(3,79) then
 WarAction(1,3,79);
 talk( 3,"徐晃！明年今日就是你的忌日！碰上我，你算完了！",
 79,"放屁！你也想尝尝关羽一样的下场吗？",
 3,"放肆！不容你猖獗，看枪！");
 WarAction(6,3,79);
 if fight(3,79)==1 then
 talk( 79,"啊！太，太强了！",
 3,"哼，你以为能赢我吗？看枪！死吧！");
 WarAction(8,3,79);
 talk( 79,"呜……",
 79,"后，后悔莫及……");
 WarAction(17,79);
 WarLvUp(GetWarID(3));
 else
 WarAction(4,79,3);
 talk( 3,"呜……");
 WarAction(17,3);
 WarLvUp(GetWarID(79));
 end
 end
 if (not GetFlag(215)) and WarCheckArea(-1,11,4,13,15) then
 talk( 17,"进城里来了吗，哈哈哈，按我的计谋上当了，也不想想，为什么特意留一座桥，那里进退不自如．机会来了！一口气冲垮敌人！！");
 WarModifyAI(258,4,8,14);
 WarModifyAI(261,4,8,14);
 WarModifyAI(293,4,8,14);
 WarModifyAI(275,4,8,14);
 WarModifyAI(276,4,8,14);
 SetFlag(215,1);
 end
 if (not GetFlag(1074)) and War.Turn==5 then
 WarShowArmy(67);
 WarShowArmy(310);
 WarShowArmy(311);
 WarShowArmy(312);
 WarShowArmy(313);
 DrawStrBoxCenter("许褚的援军到达！");
 talk( 68,"终于赶上了，快！");
 SetFlag(1074,1);
 end
 if (not GetFlag(1075)) and GetFlag(90) and War.Turn==10 then
 WarShowArmy(79);
 WarShowArmy(115);
 WarShowArmy(217);
 WarShowArmy(263);
 WarShowArmy(264);
 WarShowArmy(265);
 WarShowArmy(266);
 DrawStrBoxCenter("张辽的援军到达！");
 talk( 80,"夏侯将军，抱歉，来晚了！击退孙权花了不少时间。",
 17,"哦，张辽终于来了！");
 SetFlag(1075,1);
 end
 if GetFlag(58) and WarCheckArea(-1,3,9,5,14) then
 PlayBGM(11);
 talk( 17,"大胆刘备军！竟敢来此！");
 PlayBGM(12);
 WarShowArmy(1);
 talk( 2,"听说兄长处境艰难，关羽特来参见！想要命的，离我远点！",
 1,"噢……！我没认错吧！关羽，是你吧！",
 2,"夏侯惇，俺关羽特来会你！");
 WarMoveTo(2,12,2);
 WarAction(1,2,17);
 talk( 17,"你，你是关羽！你没死！",
 2,"魏国不亡，我还不能死．我从阎王那里又回来了．",
 17,"那好，我再把你送回去！");
 WarAction(5,17,2);
 talk( 17,"你这个死不了的，再宰死你．",
 2,"你这两下子，不足为敌！");
 WarAction(4,2,17);
 talk( 17,"噢！",
 2,"夏侯惇！小心！");
 WarAction(8,2,17);
 talk( 17,"哇！！");
 WarAction(18,17);
 talk( 2,"哼……夏侯惇，再见了……");
 WarLvUp(GetWarID(2));
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 --talk( 17,"你，你们……我虽死，魏国也不会亡！嗷！嗷！");
 talk( 17,"你，你们……魏国不会亡！嗷！嗷！");
 SetFlag(904,1); --夏侯惇存活
 NextEvent();
 end
 end,
 [628]=function()
 PlayBGM(7);
 GetMoney(1500);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１５００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [629]=function()
 SetSceneID(0);
 if GetFlag(904) then
 DrawMulitStrBox("　刘备军击毙夏侯惇，占领宛城．*　洛阳就在眼前，刘备兄弟的梦想，汉室再兴也……");
 else
 DrawMulitStrBox("　刘备军击败夏侯惇，占领宛城．*　洛阳就在眼前，刘备兄弟的梦想，汉室再兴也……");
 end
 NextEvent();
 end,
 [630]=function()
 SetSceneID(-1,0);
 JY.Base["章节名"]="第四章　中原决死战";
 DrawStrBoxCenter("第四章　中原决死战");
 LoadPic(33,1);
 DrawMulitStrBox("　对魏国来说，宛城陷落无疑是巨大打击，*　曹丕在许昌集结重兵，以防备蜀军的进攻．");
 LoadPic(33,2);
 SetSceneID(0,11);
 talk( 213,"去许昌！在许昌迎击敌军！");
 if GetFlag(90) then
 SetSceneID(0,0);
 DrawMulitStrBox("　造成宛城陷落这样的结果的重要原因，是蜀和吴同时对魏作战．*　由于东吴进攻合淝，魏的兵力被分散．在合淝的张辽等人被牵制住，所以在宛城魏国不能集中充份的战斗力．");
 end
 if GetFlag(89) then
 NextEvent(631); --goto 631
 else
 SetSceneID(0,11);
 talk( 242,"曹丕皇上危险！在洛阳顶住刘备军！");
 NextEvent(642); --goto 642
 end
 end,
 [631]=function()
 JY.Smap={};
 JY.Base["现在地"]="宛";
 JY.Base["道具屋"]=25;
 AddPerson(1,25,17,2);
 AddPerson(126,26,10,1);
 AddPerson(175,12,18,0);
 if GetFlag(58) then
 AddPerson(3,24,9,1);
 AddPerson(2,16,13,3);
 ModifyForce(2,1);
 ModifyForce(128,1);
 ModifyForce(155,1);
 ModifyForce(39,1);
 ModifyForce(34,1);
 ModifyForce(38,1);
 end
 SetSceneID(47,5);
 DrawStrBoxCenter("宛议事厅");
 if GetFlag(58) then
 talk( 2,"兄长，失了荆州，本无面目见人，听说兄长在此厮杀，甘冒矢石来与您相见．",
 1,"瞧你说的，我只听到你还活着就足够了，荆州也夺回来了，没什么好惦记的，一起完成伐魏大业吧．",
 2,"啊！多谢兄长．");
 MovePerson(3,2,2);
 MovePerson(3,2,1);
 MovePerson(3,2,3);
 MovePerson( 3,1,1,
 2,0,0);
 talk( 3,"二哥，今日畅饮一番！来，举杯！",
 2,"很久没和你喝酒了，今日不醉不休！",
 3,"这样对喽，好吧，兄长，我等你．");
 MovePerson( 2,10,2,
 3,10,2);
 DecPerson(2);
 DecPerson(3);
 end
 MovePerson(175,4,2);
 MovePerson(175,3,0);
 MovePerson(175,3,3);
 talk( 175,"主公，魏国丢掉这个宛城，肯定会惊惶失措．一口气进攻吧．",
 126,"此言极是，但是，现在还是等关中的奇袭队吧，如果不与他们会合，很难战胜魏军精锐．");
 if GetFlag(38) then
 talk( 1,"赵云他们不会出什么事吧……");
 else
 talk( 1,"庞统他们不会出什么事吧……");
 end
 --显示任务目标:<谈论今后的话．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [632]=function()
 if JY.Tid==126 then--诸葛亮
 talk( 126,"等奇袭队吧．");
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==175 then--马良
 talk( 175,"奇袭队早点到达才好．");
 end
 end,
 [633]=function()
 JY.Smap={};
 JY.Base["现在地"]="阳平关";
 JY.Base["道具屋"]=0;
 if GetFlag(38) then
 AddPerson(54,8,18,0);
 AddPerson(190,11,11,3);
 AddPerson(127,21,17,2);
 else
 AddPerson(133,8,18,0);
 AddPerson(54,11,11,3);
 AddPerson(190,21,17,2);
 end
 SetSceneID(97,12);
 DrawStrBoxCenter("阳平关帅帐");
 DrawMulitStrBox("　话说两头，在汉中的阳平关，刘备军奇袭队已布下阵势．");
 WarIni();
 if GetFlag(38) then
 talk( 54,"大概主力部队正顺利进攻洛阳，如果这样下去，将在许昌决战吧．",
 190,"赵将军，我们也别晚了，赶快去与主力部队会合吧．",
 127,"是啊，已完成虚攻的任务，已没有必要待在这里了？",
 54,"可是，不能放着关中、长安魏军不管，否则，主力部队的背后就会遭到袭击．能打击多少就打击多少吧．",
 190,"出击吧．",
 54,"嗯，但是别太浪费时间，与主力部队会合才是最重要的．",
 127,"知道了．");
 DefineWarMap(52,"第四章 陈仓之战","一、郝昭的结局",30,53,242);
 SelectTerm(1,{
 53,3,13, 4,0,-1,0,
 189,3,12, 4,0,-1,0,
 126,2,10, 4,0,-1,0,
 82,4,11, 4,0,-1,0,
 64,0,13, 4,0,-1,0,
 81,1,12, 4,0,-1,0,
 113,1,11, 4,0,-1,0,
 116,5,13, 4,0,-1,0,
 187,1,9, 4,0,-1,0,
 });
 else
 talk( 133,"大概主力部队正顺利进攻洛阳，如果这样下去，将在许昌决战吧．",
 54,"军师，我们也别晚了，赶快去与主力部队会合吧．",
 190,"是啊，已完成虚攻的任务，已没有必要待在这里了？",
 133,"可是，不能放着关中、长安魏军不管，否则，主力部队的背后就会遭到袭击．能打击多少就打击多少吧．",
 54,"那，赶快出击吧．",
 133,"嗯，但是别太浪费时间，与主力部队会合才是最重要的．",
 190,"是．");
 ModifyForce(133,1);
 ModifyForce(54,1);
 ModifyForce(190,1);
 ModifyForce(127,1);
 ModifyForce(83,1);
 ModifyForce(65,1);
 ModifyForce(82,1);
 ModifyForce(114,1);
 ModifyForce(117,1);
 ModifyForce(188,1);
 DefineWarMap(52,"第四章 陈仓之战","一、郝昭的结局",30,132,242);
 SelectTerm(1,{
 132,2,13, 4,0,-1,0,
 53,3,13, 4,0,-1,0,
 189,3,12, 4,0,-1,0,
 126,2,10, 4,0,-1,0,
 82,4,11, 4,0,-1,0,
 64,0,13, 4,0,-1,0,
 81,1,12, 4,0,-1,0,
 113,1,11, 4,0,-1,0,
 116,5,13, 4,0,-1,0,
 187,1,9, 4,0,-1,0,
 });
 end
 JY.Smap={};
 SetSceneID(0,3);
 ModifyForce(244,9);
 ModifyForce(236,9);
 ModifyForce(235,9);
 ModifyForce(237,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 242,30,9, 3,2,54,20, 0,0,-1,0,
 243,16,10, 3,4,50,9, 20,12,-1,0,
 235,14,10, 3,0,49,17, 0,0,-1,0,
 234,15,9, 3,0,48,17, 0,0,-1,0,
 236,15,12, 3,0,48,17, 0,0,-1,0,
 332,14,11, 3,0,45,14, 0,0,-1,0,
 256,5,3, 3,0,45,3, 0,0,-1,0,
 257,17,4, 3,0,44,3, 0,0,-1,0,
 258,4,1, 3,0,45,3, 0,0,-1,0,
 259,13,5, 3,0,45,3, 0,0,-1,0,
 260,14,3, 3,0,44,3, 0,0,-1,0,
 261,24,9, 3,2,44,3, 0,0,-1,0,
 262,28,9, 3,0,44,3, 0,0,-1,0,
 292,29,10, 3,0,48,9, 0,0,-1,0,
 293,20,10, 3,0,47,9, 0,0,-1,0,
 294,21,9, 3,0,48,9, 0,0,-1,0,
 295,19,5, 3,0,47,9, 0,0,-1,0,
 296,20,8, 3,0,47,9, 0,0,-1,0,
 297,29,8, 3,0,46,9, 0,0,-1,0,
 274,5,1, 3,0,45,6, 0,0,-1,0,
 275,10,3, 3,0,46,6, 0,0,-1,0,
 276,18,4, 3,0,46,6, 0,0,-1,0,
 277,24,6, 3,2,47,21, 0,0,-1,0,
 278,24,12, 3,2,47,21, 0,0,-1,0,
 279,25,9, 3,2,47,21, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [634]=function()
 PlayBGM(11);
 talk( 243,"蜀军终于攻来了，但是别想从陈仓这里过去，有种的过来一战！");
 if GetFlag(38) then
 talk( 54,"陈仓乃咽喉要地，别浪费时间！火速攻下！");
 else
 talk( 133,"陈仓乃咽喉要地，别浪费时间！火速攻下！");
 end
 talk( 244,"魏军乃逆贼．我是不是助纣为虐了．");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [635]=function()
 if WarMeet(127,243) then
 WarAction(1,127,243);
 talk( 127,"来将可是敌方统帅．来得正好，单挑！",
 243,"可恶……！让你们打到这里，只有决一胜负！");
 WarAction(6,127,243);
 if fight(127,243)==1 or true then
 talk( 127,"不愧是统帅！好厉害！",
 243,"嘿……！");
 WarAction(4,127,243);
 talk( 127,"哈、哈……",
 243,"看招！",
 127,"啊！不好！");
 WarAction(8,243,127);
 talk( 127,"哇啊！……，……，……？我还活着吗？",
 243,"啊！心，心脏……在这种……地方……犯老病……．",
 127,"怎么回事？");
 WarAction(19,243);
 talk( 243,"不好……．因病……倒下……．",
 127,"好险啊！");
 WarAction(18,243);
 WarLvUp(GetWarID(127));
 PlayBGM(7);
 DrawMulitStrBox("　刘备军奇袭队击毙郝昭，*　占领陈仓．");
 NextEvent();
 else
 WarAction(4,243,127);
 talk( 127,"太厉害了！");
 WarAction(17,127);
 WarLvUp(GetWarID(243));
 end
 end
 WarLocationItem(0,14,61,115); --获得道具:获得道具：六韬
 WarLocationItem(3,18,17,116); --获得道具:获得道具：弓术指南书
 WarLocationItem(6,26,62,117); --获得道具:获得道具：三略
 if (not GetFlag(94)) and WarMeet(-1,244) then
 PlayBGM(11);
 talk( 244,"不能再待在魏军了！我姜维现在加入蜀军！");
 ModifyForce(244,1);
 PlayWavE(11);
 DrawStrBoxCenter("姜维加入我方！");
 PlayBGM(9);
 SetFlag(94,1);
 end
 if (not GetFlag(114)) and WarMeet(190,236) then
 PlayBGM(11);
 talk( 190,"你们可是羌族人？为何跟着魏军，阻挡我军前进！",
 236,"啊，您是马超将军！听说您被魏军杀害了，看来平安无事呀！",
 190,"当然，哪能那么容易就死了．",
 236,"我们不打算与马超将军作对，现在我们羌族加入您那一方．");
 ModifyForce(236,1);
 ModifyForce(235,1);
 ModifyForce(237,1);
 PlayWavE(11);
 DrawStrBoxCenter("异民族羌族加入我方！");
 WarLvUp(GetWarID(190));
 PlayBGM(9);
 SetFlag(114,1);
 end
 if (not GetFlag(114)) and WarMeet(190,235) then
 PlayBGM(11);
 talk( 190,"你们可是羌族人？为何跟着魏军，阻挡我军前进！",
 235,"啊，您是马超将军！听说您被魏军杀害了，看来平安无事呀！",
 190,"当然，哪能那么容易就死了．",
 235,"我们不打算与马超将军作对，现在我们羌族加入您那一方．");
 ModifyForce(236,1);
 ModifyForce(235,1);
 ModifyForce(237,1);
 PlayWavE(11);
 DrawStrBoxCenter("异民族羌族加入我方！");
 WarLvUp(GetWarID(190));
 PlayBGM(9);
 SetFlag(114,1);
 end
 if (not GetFlag(114)) and WarMeet(190,237) then
 PlayBGM(11);
 talk( 190,"你们可是羌族人？为何跟着魏军，阻挡我军前进！",
 237,"啊，您是马超将军！听说您被魏军杀害了，看来平安无事呀！",
 190,"当然，哪能那么容易就死了．",
 237,"我们不打算与马超将军作对，现在我们羌族加入您那一方．");
 ModifyForce(236,1);
 ModifyForce(235,1);
 ModifyForce(237,1);
 PlayWavE(11);
 DrawStrBoxCenter("异民族羌族加入我方！");
 WarLvUp(GetWarID(190));
 PlayBGM(9);
 SetFlag(114,1);
 end
 if (not GetFlag(1076)) and War.Turn==30 then
 PlayBGM(11);
 if GetFlag(38) then
 talk( 54,"不行，要赶不上决战了！全军，加速前进！");
 else
 talk( 133,"不行，要赶不上决战了！全军，加速前进！");
 end
 SetFlag(93,1);
 SetFlag(1076,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(642); --goto 642
 end
 if JY.Status==GAME_WARLOSE then
 PlayBGM(11);
 if GetFlag(38) then
 talk( 54,"可恶！这样赶不上决战了！");
 else
 talk( 133,"可恶！这样赶不上决战了！");
 end
 SetFlag(93,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(642); --goto 642
 end
 if JY.Status==GAME_WARWIN then
 talk( 243,"可恶．挡不住刘备军，我与阵地共存亡．");
 PlayBGM(7);
 DrawMulitStrBox("　刘备军奇袭队击毙郝昭，*　占领陈仓．");
 NextEvent();
 end
 end,
 [636]=function()
 GetMoney(1600);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１６００！");
 if GetFlag(38) then
 talk( 54,"好，快进攻长安！");
 else
 talk( 133,"好，快进攻长安！");
 end
 JY.Status=GAME_WMAP2;
 NextEvent();
 end,
 [637]=function()
 --JY.Smap={};
 --SetSceneID(0,3);
 WarIni2();
 if GetFlag(38) then
 DefineWarMap(53,"第四章 长安之战","一、曹真的结局",60,53,241);
 else
 DefineWarMap(53,"第四章 长安之战","一、曹真的结局",60,132,241);
 end
 SelectTerm2(1,{
 -1,1,9, 4,0,-1,0,
 -1,2,8, 4,0,-1,0,
 -1,4,8, 4,0,-1,0,
 -1,4,10, 4,0,-1,0,
 -1,2,6, 4,0,-1,0,
 -1,0,7, 4,0,-1,0,
 -1,3,12, 4,0,-1,0,
 -1,0,11, 4,0,-1,0,
 -1,2,10, 4,0,-1,0,
 -1,1,13, 4,0,-1,0,
 -1,3,5, 4,0,-1,0,
 -1,1,5, 4,0,-1,0,
 -1,1,6, 4,0,-1,0,
 -1,0,9, 4,0,-1,0,
 });
 ModifyForce(112,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 241,30,8, 3,2,57,20, 0,0,-1,0,
 102,18,3, 3,2,55,22, 20,12,-1,0,
 111,18,14, 3,2,52,16, 0,0,-1,0,
 100,28,8, 3,2,53,21, 0,0,-1,0,
 19,9,8, 3,2,53,25, 0,0,-1,0,
 214,9,9, 3,2,53,25, 0,0,-1,0, --dos兵种设定为3
 215,18,13, 3,2,54,9, 0,0,-1,0, --庞德
 17,26,8, 3,2,55,22, 0,0,901,0, --夏侯渊
 256,27,6, 3,2,49,3, 0,0,-1,0,
 257,30,11, 3,2,47,3, 0,0,-1,0,
 258,25,8, 3,2,48,3, 0,0,-1,0,
 259,9,7, 3,2,48,3, 0,0,-1,0,
 260,9,10, 3,2,48,3, 0,0,-1,0,
 261,14,4, 3,2,48,3, 0,0,-1,0,
 274,28,9, 3,2,48,6, 0,0,-1,0,
 275,19,3, 3,2,47,6, 0,0,-1,0,
 
 276,19,13, 3,2,49,6, 0,0,-1,0,
 277,15,5, 3,2,48,6, 0,0,-1,0,
 292,11,7, 3,0,50,9, 0,0,-1,0,
 293,20,5, 3,2,50,9, 0,0,-1,0,
 294,20,11, 3,2,49,9, 0,0,-1,0,
 295,12,7, 3,0,50,9, 0,0,-1,0,
 332,16,13, 3,2,50,14, 0,0,-1,0,
 348,11,8, 3,0,49,19, 0,0,-1,0,
 278,12,12, 3,4,47,6, 10,10,-1,0,
 336,23,7, 3,2,48,15, 0,0,-1,0,
 337,23,9, 3,2,47,15, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [638]=function()
 PlayBGM(11);
 talk( 242,"在这里箝制住蜀军！不能让蜀军再为所欲为了．");
 if GetFlag(38) then
 talk( 54,"越过长安，马上就到洛阳了．大家再加把劲！");
 else
 talk( 133,"越过长安，马上就到洛阳了．大家再加把劲！");
 end
 talk( 112,"当初玄德公的实力何其渺小，现在如此壮大……我的眼光果然没错．");
 WarShowTarget(true);
 PlayBGM(17);
 NextEvent();
 end,
 [639]=function()
 WarLocationItem(2,26,49,119); --获得道具:获得道具：援军书
 if (not GetFlag(217)) and WarCheckArea(-1,2,10,13,14) then
 talk( 242,"已经打进城里了！各军要迎击敌军！！不惜一切要阻止敌军去许昌与主力会合！");
 WarModifyAI(275,1);
 WarModifyAI(276,1);
 WarModifyAI(277,1);
 WarModifyAI(261,1);
 WarModifyAI(293,1);
 WarModifyAI(294,1);
 WarModifyAI(332,1);
 SetFlag(217,1);
 end
 if (not GetFlag(95)) and WarMeet(-1,112) then
 PlayBGM(11);
 talk( 112,"且慢，不要打！我乃徐庶，现在回归蜀军．");
 ModifyForce(112,1);
 PlayWavE(11);
 DrawStrBoxCenter("徐庶加入我方！");
 PlayBGM(17);
 SetFlag(95,1);
 end
 if WarMeet(54,103) then
 WarAction(1,54,103);
 talk( 54,"那边可是张颌！",
 103,"赵云吗？久违了，有何事指教？来劝降？别开这种玩笑．",
 54,"张颌，乾脆投降吧！魏国亡定了．",
 103,"别逗了，我自弃袁绍效力曹公，绝不会再投降了．",
 54,"那就打吧！");
 WarAction(6,54,103);
 if fight(54,103)==1 then
 talk( 54,"看招！");
 WarAction(8,54,103);
 talk( 103,"啊！不愧……是……赵云，我不行了！");
 WarAction(17,103);
 talk( 54,"……张颌，真乃义士．");
 WarLvUp(GetWarID(54));
 else
 WarAction(4,103,54);
 talk( 54,"太厉害了！");
 WarAction(17,54);
 WarLvUp(GetWarID(103));
 end
 end
 if (not GetFlag(1077)) and War.Turn==60 then
 PlayBGM(11);
 if GetFlag(38) then
 talk( 54,"不好，赶不上决战了！全军，加速前进！");
 else
 talk( 133,"不好，赶不上决战了！全军，加速前进！");
 end
 SetFlag(93,1);
 SetFlag(1077,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(642); --goto 642
 end
 if JY.Status==GAME_WARLOSE then
 PlayBGM(11);
 if GetFlag(38) then
 talk( 54,"糟了！这样要赶不上决战了．");
 else
 talk( 133,"糟了！这样要赶不上决战了．");
 end
 SetFlag(93,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(642); --goto 642
 end
 if JY.Status==GAME_WARWIN then
 talk( 242,"蜀军太厉害了……！啊！");
 PlayBGM(7);
 DrawMulitStrBox("　刘备军奇袭队击毙曹真，*　占领长安．");
 NextEvent();
 end
 end,
 [640]=function()
 GetMoney(1600);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１６００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [641]=function()
 JY.Smap={};
 SetSceneID(0,3);
 if GetFlag(38) then
 talk( 54,"好，马上进军洛阳！");
 else
 talk( 133,"好，马上进军洛阳！");
 end
 NextEvent();
 end,
 [642]=function()
 JY.Smap={};
 JY.Base["现在地"]="宛";
 JY.Base["道具屋"]=25;
 AddPerson(1,25,17,2);
 AddPerson(126,25,14,2);
 if (not GetFlag(38)) and (not GetFlag(89)) then
 AddPerson(133,19,17,2);
 end
 local x=26;
 local y=10;
 if GetFlag(58) then
 AddPerson(2,x,y,1);
 x=x-2;
 y=y-1;
 end
 if not GetFlag(89) then
 AddPerson(54,x,y,1);
 x=x-2;
 y=y-1;
 end
 AddPerson(170,x,y,1);
 x=12;
 y=18;
 if GetFlag(135) then
 AddPerson(3,x,y,0);
 x=x-2;
 y=y-1;
 end
 if not GetFlag(89) then
 AddPerson(190,x,y,0);
 x=x-2;
 y=y-1;
 AddPerson(127,x,y,0);
 end
 if GetFlag(58) then --关羽回归
 ModifyForce(2,1);
 ModifyForce(128,1);
 ModifyForce(155,1);
 ModifyForce(39,1);
 ModifyForce(34,1);
 ModifyForce(38,1);
 end
 --奇袭队
 if GetFlag(89) then
 ModifyForce(133,0);
 ModifyForce(54,0);
 ModifyForce(190,0);
 ModifyForce(127,0);
 ModifyForce(83,0);
 ModifyForce(65,0);
 ModifyForce(82,0);
 ModifyForce(114,0);
 ModifyForce(117,0);
 ModifyForce(188,0);
 ModifyForce(244,0); --姜维
 ModifyForce(236,0); --羌族
 ModifyForce(235,0); --羌族
 ModifyForce(237,0); --羌族
 ModifyForce(112,0); --徐庶
 end
 
 SetSceneID(47,5);
 DrawStrBoxCenter("宛议事厅");
 AddPerson(175,0,5,3);
 MovePerson(175,8,3);
 if GetFlag(89) then
 if GetFlag(93) then
 talk( 175,"奇袭队还没任何消息，大概被魏军绊住了．",
 126,"如果再等奇袭队来，只会给敌人时间加固设防．",
 1,"正是，很遗憾，但也别无他法．他们不久就会赶到，曹丕在许昌，我们先发兵许昌．");
 else
 talk( 175,"主公，刚接到报告，奇袭队已达到洛阳．",
 126,"好样的，马上与奇袭队合兵一处，一口气直攻许昌．",
 1,"好！全军准备出征，直指许昌！");
 end
 else
 talk( 175,"主公，关中的魏军已移动到洛阳．",
 126,"敌人要在洛阳防守．",
 1,"已经打到这里，没有可犹豫的，进军洛阳！");
 end
 if GetFlag(58) then
 talk( 2,"现在正是雪荆州之耻的时候．",
 3,"抖擞精神准备出征吧！兄长，我们先准备！");
 --[[MovePerson( 2,4,2,
 3,4,2);
 MovePerson( 2,2,1,
 3,2,0);
 MovePerson( 2,8,2,
 3,8,2);
 DecPerson(2);
 DecPerson(3);]]--
 end
 --显示任务目标:<进行出征准备．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [643]=function()
 if JY.Tid==133 then--庞统
 talk( 133,"终于要与魏决战了，请进行出征准备．");
 end
 if JY.Tid==2 then--关羽
 talk( 2,"兄长，终于要与魏决战了．我等兄弟的梦想，就要实现了．");
 end
 if JY.Tid==3 then--张飞
 talk( 3,"大哥，派我吧！没多久，我们的梦想就实现了．");
 end
 if JY.Tid==54 then--赵云
 talk( 54,"完成伐魏大业吧．");
 end
 if JY.Tid==190 then--马超
 talk( 190,"想早日报杀父之仇．");
 end
 if JY.Tid==170 then--黄忠
 talk( 170,"我也想为主公拼了我这把老骨头．");
 end
 if JY.Tid==127 then--魏延
 talk( 127,"快点出征吧！");
 end
 if JY.Tid==175 then--马良
 talk( 175,"终于要与魏国决战了．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 WarIni();
 if GetFlag(89) then
 if GetFlag(93) then
 talk( 126,"请分派部队．");
 DefineWarMap(50,"第四章 许昌I之战","一、司马懿的撤退",40,0,213);
 SelectTerm(1,{
 0,12,21, 3,0,-1,0,
 125,11,21, 3,0,-1,0,
 -1,8,23, 3,0,-1,0,
 -1,10,20, 3,0,-1,0,
 -1,10,23, 3,0,-1,0,
 -1,11,19, 3,0,-1,0,
 -1,11,22, 3,0,-1,0,
 -1,12,23, 3,0,-1,0,
 -1,13,22, 3,0,-1,0,
 -1,14,21, 3,0,-1,0,
 132,1,3, 4,0,-1,1,
 53,2,2, 4,0,-1,1,
 189,2,4, 4,0,-1,1,
 126,0,2, 4,0,-1,1,
 243,0,4, 4,0,-1,1,
 111,0,3, 4,0,-1,1,
 });
 DrawSMap();
 JY.Smap={};
 SetSceneID(0,3);
 talk( 126,"进兵许昌吧！");
 NextEvent(647); --goto 647
 JY.Status=GAME_WMAP;
 else
 talk( 126,"顺路去洛阳与奇袭队会合，在那里重新编排部队吧．");
 JY.Smap={};
 SetSceneID(0,3);
 talk( 1,"奇袭队众将士，辛苦了．想必大家很疲劳，但还得一口气进攻许昌！",
 126,"进兵许昌吧！");
 NextEvent(652); --goto 652
 JY.Status=GAME_SMAP_AUTO;
 end
 else
 talk( 126,"请分派部队．");
 DefineWarMap(54,"第四章 洛阳之战","一、曹真的结局",40,0,241);
 SelectTerm(1,{
 0,29,8, 3,0,-1,0,
 125,29,7, 3,0,-1,0,
 -1,27,7, 3,0,-1,0,
 -1,27,10, 3,0,-1,0,
 -1,28,9, 3,0,-1,0,
 -1,28,11, 3,0,-1,0,
 -1,29,11, 3,0,-1,0,
 -1,30,6, 3,0,-1,0,
 -1,30,10, 3,0,-1,0,
 -1,31,9, 3,0,-1,0,
 });
 ModifyForce(112,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 241,1,3, 4,2,60,20, 0,0,-1,0,
 102,5,7, 1,2,57,22, 20,12,-1,0,
 111,4,16, 4,5,54,16, 0,0,-1,0,
 100,9,5, 4,2,54,21, 0,0,-1,0,
 19,19,19, 4,2,56,25, 0,0,-1,0,
 214,6,7, 1,2,55,25, 0,0,-1,0, --dos兵种设定为3
 215,21,17, 4,1,56,9, 0,0,-1,0, --庞德
 17,16,17, 4,0,58,22, 0,0,901,0, --夏侯渊
 256,2,3, 4,0,56,3, 0,0,-1,0,
 257,1,4, 4,0,55,3, 0,0,-1,0,
 258,11,5, 4,2,53,3, 0,0,-1,0,
 295,16,19, 4,0,53,9, 0,0,-1,0,
 296,14,18, 4,0,52,9, 0,0,-1,0,
 297,15,16, 4,0,54,9, 0,0,-1,0,
 292,20,16, 4,1,54,9, 0,0,-1,0,
 
 293,21,16, 4,1,53,9, 0,0,-1,0,
 294,22,17, 4,1,42,9, 0,0,-1,0,
 274,11,4, 4,2,54,6, 0,0,-1,0,
 336,14,6, 4,0,50,15, 0,0,-1,0,
 337,15,6, 4,0,48,15, 0,0,-1,0,
 338,16,3, 4,0,48,15, 0,0,-1,0,
 339,16,5, 4,0,47,15, 0,0,-1,0,
 275,11,6, 4,0,54,6, 0,0,-1,0,
 276,3,8, 4,0,52,21, 0,0,-1,0,
 277,8,8, 3,2,52,21, 0,0,-1,0,
 278,3,7, 4,2,52,21, 0,0,-1,0,
 298,5,14, 4,0,53,9, 0,0,-1,0,
 299,7,14, 4,0,53,9, 0,0,-1,0,
 });
 DrawSMap();
 JY.Smap={};
 SetSceneID(0,3);
 talk( 126,"去洛阳吧．");
 NextEvent();
 JY.Status=GAME_WMAP;
 end
 end
 end
 end,
 [644]=function()
 PlayBGM(11);
 talk( 242,"此战关系到魏国的命运，决不能输！",
 126,"主公，听说洛阳这里的守将是曹真．",
 1,"嗯，可是以我军实力，拿下这里易如反掌．",
 126,"大意不得呀，小心进攻吧．",
 112,"当初玄德公的实力多么渺小，现在如此壮大……我的眼光果然没错．");
 WarShowTarget(true);
 PlayBGM(17);
 NextEvent();
 end,
 [645]=function()
 WarLocationItem(8,10,49,120); --获得道具:获得道具：援军书
 if (not GetFlag(121)) and WarCheckLocation(-1,10,14) then
 GetMoney(2000);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金２０００！");
 SetFlag(121,1);
 end
 if (not GetFlag(95)) and WarMeet(-1,112) then
 PlayBGM(11);
 talk( 112,"且慢，不要打！我乃徐庶，现在回归蜀军．");
 ModifyForce(112,1);
 PlayWavE(11);
 DrawStrBoxCenter("徐庶加入我方！");
 PlayBGM(17);
 SetFlag(95,1);
 end
 if WarMeet(3,103) then
 WarAction(1,3,103);
 talk( 3,"那边可是张颌！",
 103,"张飞吗，久违了，有何指教？来劝降吗？别开这样的玩笑．",
 3,"张颌，乾脆投降吧，魏国亡定了．",
 103,"别逗了，我自弃袁绍效力曹公，绝不会再投降了．",
 3,"既然如此，只有打了！");
 WarAction(6,3,103);
 if fight(3,103)==1 then
 talk( 3,"看招！");
 WarAction(8,3,103);
 talk( 103,"啊！不愧……是……张飞，我不行了！");
 WarAction(17,103);
 talk( 3,"……真乃义士，令人敬佩．");
 WarLvUp(GetWarID(3));
 else
 WarAction(4,103,3);
 talk( 3,"太厉害了！");
 WarAction(17,3);
 WarLvUp(GetWarID(103));
 end
 end
 if JY.Status==GAME_WARWIN then
 talk( 242,"刘备军如此强大……哎呀！");
 PlayBGM(7);
 DrawMulitStrBox("　刘备军击毙曹真，占领洛阳．");
 GetMoney(1600);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１６００！");
 talk( 126,"主公，乘势一鼓作气进攻许昌吧！",
 1,"好，重新调兵遣将！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [646]=function()
 JY.Smap={};
 SetSceneID(0,3);
 WarIni();
 DefineWarMap(50,"第四章 许昌I之战","一、司马懿的撤退",40,0,213);
 SelectTerm(1,{
 0,12,21, 3,0,-1,0,
 125,11,21, 3,0,-1,0,
 -1,8,23, 3,0,-1,0,
 -1,10,20, 3,0,-1,0,
 -1,10,23, 3,0,-1,0,
 -1,11,19, 3,0,-1,0,
 -1,11,22, 3,0,-1,0,
 -1,12,23, 3,0,-1,0,
 -1,13,22, 3,0,-1,0,
 -1,14,21, 3,0,-1,0,
 });
 DrawSMap();
 talk( 1,"全军，进兵许昌．");
 NextEvent();
 end,
 [647]=function()
 --奇袭队
 if not GetFlag(38) then
 ModifyForce(133,1);
 end
 ModifyForce(54,1);
 ModifyForce(190,1);
 ModifyForce(127,1);
 ModifyForce(83,1);
 ModifyForce(65,1);
 ModifyForce(82,1);
 ModifyForce(114,1);
 ModifyForce(117,1);
 ModifyForce(188,1);
 if GetFlag(94) then
 ModifyForce(244,1); --姜维
 end
 if GetFlag(114) then --dos为118，貌似错了
 ModifyForce(236,1); --羌族
 ModifyForce(235,1); --羌族
 ModifyForce(237,1); --羌族
 end
 if GetFlag(95) then
 ModifyForce(112,1); --徐庶
 end
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 213,21,2, 1,2,61,16, 0,0,-1,0,
 239,20,3, 1,2,58,16, 20,12,-1,0,
 240,22,3, 1,2,58,16, 0,0,-1,0,
 211,20,13, 3,0,57,22, 0,0,-1,0,
 238,20,12, 3,0,56,13, 0,0,-1,0,
 67,15,17, 3,4,58,9, 11,12,-1,0,
 93,16,16, 3,4,57,16, 12,12,-1,0,
 79,4,13, 1,0,58,25, 0,0,-1,0,
 217,3,15, 1,0,57,9, 0,0,-1,0,
 115,2,13, 1,0,53,3, 0,0,-1,0,
 78,21,14, 3,0,57,9, 0,0,-1,0, --徐晃
 170,20,15, 3,0,57,9, 0,0,-1,0, --牛金
 102,21,8, 1,0,57,22, 0,0,-1,0, --张郃
 19,17,11, 3,4,57,25, 11,9,-1,0, --曹洪
 215,23,8, 1,0,57,9, 0,0,-1,0, --庞德
 17,19,6, 1,0,59,22, 0,0,901,0, --夏侯渊
 16,18,7, 1,0,60,9, 0,0,904,0, --夏侯惇
 18,22,7, 1,2,60,25, 0,0,903,0, --曹仁
 256,5,16, 1,2,55,3, 0,0,-1,0,
 257,14,16, 3,4,53,3, 11,11,-1,0,
 258,18,13, 3,4,53,3, 13,10,-1,0,
 297,19,11, 3,0,54,9, 0,0,-1,0,
 298,21,6, 1,0,54,9, 0,0,-1,0,
 292,19,14, 3,0,54,9, 0,0,-1,0,
 293,19,4, 1,0,55,9, 0,0,-1,0,
 294,22,4, 1,0,54,9, 0,0,-1,0,
 274,5,15, 1,2,53,21, 0,0,-1,0,
 275,17,15, 3,4,54,6, 13,11,-1,0,
 295,18,12, 3,0,54,9, 0,0,-1,0,
 296,20,7, 1,0,54,9, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [648]=function()
 PlayBGM(11);
 talk( 214,"蜀军，别那么得意，我司马懿想让你们尝尝魏军的厉害．",
 126,"主公，敌军统帅司马懿是个对手，不能大意．请多留神．");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [649]=function()
 if WarMeet(30,68) then
 WarAction(1,30,68);
 talk( 30,"我乃关羽之子关兴！有谁敢与我单挑？",
 68,"哦，关羽的儿子吗？如此，打起来也带劲．好吧！我许褚与你单挑．",
 30,"成全你了！来吧！");
 WarAction(6,30,68);
 if fight(30,68)==1 then
 talk( 30,"嘿，是许褚！有点真本事！",
 68,"哈哈哈！我许褚还不老，不会轻易败阵！来吧！");
 WarAction(6,30,68);
 WarAction(6,30,68);
 WarAction(6,30,68);
 talk( 30,"嘿嘿嘿……！这刀如何！");
 WarAction(9,30,68);
 talk( 68,"喂，且住！哈哈，还是年轻人体力足……我得撤了．",
 30,"想逃跑！留下首级！",
 68,"关兴，以后再见！");
 WarAction(16,68);
 WarLvUp(GetWarID(30));
 else
 WarAction(6,30,68);
 WarAction(6,30,68);
 WarAction(6,30,68);
 talk( 68,"嘿嘿嘿……！这刀如何！");
 WarAction(8,68,30);
 talk( 30,"太厉害了！");
 WarAction(17,30);
 WarLvUp(GetWarID(68));
 end
 end
 WarLocationItem(12,2,17,122); --获得道具:获得道具：弓术指南书
 WarLocationItem(8,24,19,123); --获得道具:获得道具：剑术指南书
 if (not GetFlag(1078)) and GetFlag(89) and War.Turn==12 then
 PlayBGM(12);
 if not GetFlag(38) then
 WarShowArmy(132);
 end
 WarShowArmy(53);
 WarShowArmy(189);
 WarShowArmy(126);
 if GetFlag(94) then
 WarShowArmy(243);
 end
 if GetFlag(95) then
 WarShowArmy(111);
 end
 talk( 190,"马上赶去！还来得及参战！",
 1,"什么？敌人的援军？",
 126,"主公，奇袭队总算及时赶到了．",
 1,"好，全军总攻击．");
 PlayBGM(9);
 SetFlag(131,1);
 SetFlag(1078,1);
 end
 if WarCheckArea(-1,0,19,4,24) then
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 NextEvent();
 end
 end,
 [650]=function()
 talk( 214,"蜀军好厉害呀！全军先退回城里！在城内消灭敌军！");
 WarAction(16,214);
 PlayBGM(7);
 DrawMulitStrBox("　司马懿率领魏军向城内撤退了．");
 GetMoney(1600);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１６００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [651]=function()
 JY.Smap={};
 SetSceneID(0);
 if GetFlag(89) and GetFlag(93) and (not GetFlag(131)) then
 talk( 126,"大概魏军要据守城池，怎么办？",
 1,"嗯，一口气攻下这？孔明，那边是？",
 126,"哦，主公，好像奇袭队赶到了．",
 1,"如此甚好，全军突击许昌！");
 else
 talk( 126,"大概魏军要据守城池，怎么办？",
 1,"好，全军突击许昌！");
 end
 NextEvent();
 end,
 [652]=function()
 PlayBGM(12);
 --奇袭队
 if not GetFlag(38) then
 ModifyForce(133,1);
 end
 ModifyForce(54,1);
 ModifyForce(190,1);
 ModifyForce(127,1);
 ModifyForce(83,1);
 ModifyForce(65,1);
 ModifyForce(82,1);
 ModifyForce(114,1);
 ModifyForce(117,1);
 ModifyForce(188,1);
 if GetFlag(94) then
 ModifyForce(244,1); --姜维
 end
 if GetFlag(114) then --dos为118，貌似错了
 ModifyForce(236,1); --羌族
 ModifyForce(235,1); --羌族
 ModifyForce(237,1); --羌族
 end
 if GetFlag(95) then
 ModifyForce(112,1); --徐庶
 end
 talk( 170,"主公，请一定带我去．让您看看我这把老骨头，还能上战场厮杀．",
 203,"黄忠将军，我也同去．主公，我俩去建奇功．",
 1,"嗯，如此甚好．",
 126,"主公且慢．",
 1,"怎么了，孔明？",
 126,"他们有点意气太高，万一有个闪失，会伤害全军的锐气．",
 1,"……",
 170,"军师，瞧您说的．黄忠为了主公，万死不辞．",
 203,"一定让我们参战吧．",
 1,"就如军师所说．二位的心情我了解，这回还是多歇歇吧．",
 170,"主公！……知道了，从命．");
 talk( 126,"请调兵遣将．");
 ModifyForce(170,0);
 ModifyForce(203,0);
 WarIni();
 DefineWarMap(51,"第四章 许昌II之战","一、我军部队到达内城城门．",40,0,213);
 SelectTerm(1,{
 0,24,18, 3,0,-1,0,
 125,24,17, 3,0,-1,0,
 -1,2,17, 4,0,-1,0,
 -1,21,19, 3,0,-1,0,
 -1,2,19, 4,0,-1,0,
 -1,22,18, 3,0,-1,0,
 -1,3,18, 4,0,-1,0,
 -1,23,19, 3,0,-1,0,
 -1,4,19, 4,0,-1,0,
 -1,25,17, 3,0,-1,0,
 -1,5,18, 4,0,-1,0,
 -1,26,18, 3,0,-1,0,
 -1,5,19, 4,0,-1,0,
 169,8,0, 4,0,-1,1,
 202,8,1, 4,0,-1,1,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 213,13,2, 1,4,65,16, 13,1,-1,0,
 212,13,1, 1,4,62,9, 8,0,-1,0,
 239,12,2, 1,4,61,16, 12,1,-1,0,
 240,14,2, 1,4,61,16, 14,1,-1,0,
 211,13,13, 1,0,60,22, 0,0,-1,0,
 238,13,14, 1,0,60,13, 0,0,-1,0,
 67,20,7, 1,2,62,9, 0,0,-1,0,
 93,27,7, 1,2,61,16, 0,0,-1,0,
 79,6,7, 1,2,62,25, 0,0,-1,0,
 217,0,4, 1,0,61,9, 0,0,-1,0,
 115,7,11, 1,2,61,3, 0,0,-1,0,
 78,21,6, 4,1,62,9, 0,0,-1,0, --徐晃
 170,20,5, 4,1,61,9, 0,0,-1,0, --牛金
 102,7,7, 3,1,62,22, 0,0,-1,0, --张郃
 215,6,6, 3,1,61,9, 0,0,-1,0, --庞德
 17,14,15, 4,0,62,22, 0,0,901,0, --夏侯渊
 16,12,15, 3,0,63,9, 0,0,904,0, --夏侯惇
 18,26,7, 1,0,63,25, 0,0,903,0, --曹仁
 19,1,4, 1,0,62,25, 0,0,-1,0, --曹洪
 256,1,3, 1,0,57,3, 0,0,-1,0,
 257,20,12, 1,2,57,3, 0,0,-1,0,
 258,26,6, 1,2,56,3, 0,0,-1,0,
 292,11,16, 3,0,59,9, 0,0,-1,0,
 293,15,16, 4,0,59,9, 0,0,-1,0,
 274,4,13, 1,0,57,21, 0,0,-1,0,
 275,6,8, 1,0,57,21, 0,0,-1,0,
 276,9,14, 1,0,56,21, 0,0,-1,0,
 277,9,15, 1,0,56,21, 0,0,-1,0,
 278,17,14, 1,0,55,21, 0,0,-1,0,
 279,17,15, 1,0,55,21, 0,0,-1,0,
 280,20,8, 1,0,55,21, 0,0,-1,0,
 281,22,13, 1,0,57,21, 0,0,-1,0,
 282,24,8, 1,0,56,21, 0,0,-1,0,
 283,12,7, 4,0,55,6, 0,0,-1,1,
 284,13,6, 1,0,55,6, 0,0,-1,1,
 285,14,7, 3,0,52,6, 0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [653]=function()
 PlayBGM(11);
 talk( 213,"刘备之流，与朕作对！朕身为大魏皇帝，这种态度，绝不容许！",
 214,"陛下，这座许昌城，不适合防守，请暂时撤退到邺城吧．",
 213,"司马懿，朕如此狼狈，你要负责！",
 214,"真愧对陛下．可是，现在不是责臣的时候，请……",
 213,"好吧，朕先去邺城．司马懿，你断后，不要让我见到蜀军．",
 214,"哈哈……",
 126,"许昌城很大，易于进攻．一鼓作气拿下城中心！");
 WarShowTarget(true);
 SetFlag(218,1);
 PlayBGM(10);
 NextEvent();
 end,
 [654]=function()
 if GetFlag(173) and WarMeet(2,80) then
 talk( 2,"文远，又见面了．",
 80,"关将军，看来我好像跟错主君了，董卓、吕布、还有……曹丕．曹丕哪像是曹操主公的儿子？竟然抛下臣子，简直就像吕布……",
 2,"既然知错，投降我们如何？",
 80,"什么……？",
 2,"下邳之战，我被曹军围困于土山，正在绝望之际，你来见我，陈说利害．要死很容易，但什么也解决不了．眼光放长远些吧．",
 80,"……",
 2,"当年我被你说的话打动，忍辱投降曹操．这次，我也用那话劝你．",
 80,"……",
 2,"文远，……意下如何？",
 80,"……好吧，投降．");
 ModifyForce(80,1);
 PlayWavE(11);
 DrawStrBoxCenter("张辽加入我方！");
 talk( 80,"可是，让我稍微平静一下心绪．现在不想打了．",
 2,"好吧，你先撤退．",
 80,"抱歉．");
 JY.Person[80]["道具1"]=0;
 JY.Person[80]["道具2"]=0;
 WarAction(16,80);
 SetFlag(218,0);
 WarLvUp(GetWarID(2));
 end
 if (not GetFlag(173)) and WarCheckLocation(212,0,8) then
 PlayBGM(11);
 talk( 213,"刘备，我会报此仇的！");
 WarAction(16,213);
 --
 WarMoveTo(240,12,1);
 WarAction(0,240,1)
 WarMoveTo(241,14,1);
 WarAction(0,241,1)
 WarMoveTo(214,13,1);
 WarAction(0,214,1)
 
 
 --
 SetFlag(173,1);
 PlayBGM(10);
 end
 if (not GetFlag(1079)) and WarCheckLocation(-1,10,13) then
 talk( 1,"什么？城门没开？嗯，如何是好……");
 PlayBGM(12);
 WarShowArmy(169);
 WarShowArmy(202);
 talk( 203,"黄忠老将军，很容易就混进城了．",
 170,"是呀，因为能看见魏军从这里逃走，我想说不定能混进来．可惜没捉到魏军大将．",
 203,"可惜．捉住魏兵了吗？",
 170,"嗯，盘问魏兵，让他招出如何从城门内侧开门．如果打开城门，就是首功．军师也会对我等另眼相看．",
 203,"好，赶快去好吗？",
 170,"走，严老将军！");
 WarMoveTo(203,13,8);
 WarMoveTo(170,13,7);
 --
 SetWarMap(14,10,1,6);
 PlayWavE(18);
 WarDelay(48);
 War.MapID=63;
 WarDelay(12);
 --
 talk( 203,"太好了，城门打开了！",
 170,"主公，快请入城！",
 1,"黄忠！严颜！你们为何在此？",
 170,"见到敌军从城中逃走，从他们逃出的地方进城的．",
 203,"城门已打开，请进来吧！",
 1,"黄忠、严颜，你们干得漂亮！",
 170,"哈哈哈哈！人虽老了，但也不输给年轻后生……！！");
 PlayBGM(11);
 WarShowArmy(283);
 WarShowArmy(284);
 WarShowArmy(285);
 talk( 285,"快射敌将！");
 WarAction(4,284,170);
 WarAction(4,286,170);
 WarAction(8,285,170);
 WarAction(4,284,203);
 WarAction(4,286,203);
 WarAction(8,285,203);
 JY.Person[170]["兵力"]=limitX(JY.Person[170]["兵力"]/5,1,1000);
 JY.Person[203]["兵力"]=limitX(JY.Person[203]["兵力"]/5,1,1000);
 JY.Person[170]["士气"]=30;
 JY.Person[203]["士气"]=30;
 talk( 170,"啊，没想……到！有……伏兵！",
 1,"黄忠！严颜！不要紧吧！",
 203,"不碍事．主公，快……",
 --1,"好吧，别担心！好好养伤！黄忠！严颜！来人，照看好二位老将军！",
 1,"好吧，别担心！全军出击，快点营救二位老将军！");
 WarModifyAI(169,2);
 WarModifyAI(202,2);
 PlayBGM(10);
 War.WarTarget="一、司马懿的撤退";
 WarShowTarget(false);
 SetFlag(1079,1);
 end
 WarLocationItem(17,12,9,212); --获得道具:获得道具：玉玺
 if JY.Death==170 then
 talk( 170,"啊！再……再不能…………领兵讨贼了…………");
 WarAction(18,170);
 SetFlag(1080,1);
 end
 if JY.Death==203 then
 talk( 203,"这点伤……啊！…………");
 WarAction(18,203);
 SetFlag(1080,1);
 end
 if JY.Status==GAME_WARWIN then
 talk( 214,"啊！蜀军如此厉害……向邺城撤退！");
 PlayBGM(7);
 DrawMulitStrBox("　司马懿撤退了，刘备军占领许昌．");
 GetMoney(1600);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１６００！");
 if GetFlag(1080) then
 talk( 126,"主公，我们胜利了！",
 1,"嗯！黄忠！黄忠怎么样了？严颜呢？",
 126,"还活着，不过……",
 1,"什么！黄忠在哪？马上去看黄忠！");
 PlayBGM(4);
 DrawMulitStrBox("　刘备等人，收起了占领许昌的欣喜，立刻赶到黄忠和严颜的身边探视．*　黄忠和严颜，由于遭突袭而受重伤，危在旦夕．*　没有生还的希望了……");
 talk( 1,"黄忠！严颜！许昌攻下来了，多亏你二人之力！",
 203,"哦，主公，恭喜……",
 170,"哦，曹丕……？杀了曹丕吗？",
 1,"嗯……杀了．",
 126,"……",
 170,"哦，太好了……如此，我死也瞑目了．",
 1,"哪里话！复兴汉室的大业还没完，以后还仰仗二位！打起精神！这点箭伤没什么大碍！",
 203,"主公……您能用我这老兵，太感谢您了．我们为主公尽力到最后，心中很宽慰．",
 170,"怎么样……主公．和平的……没有战争……盛世……",
 1,"……！黄忠！严颜！听到我的声音吗？回答我！！");
 DrawMulitStrBox("　刘备军终于攻下许昌，但是为了胜利，也付出了巨大牺牲……*　然而，魏国还没有被消灭．曹丕，还有司马懿，正一步一步准备，欲与蜀国进行最后的决战．");
 else
 talk( 126,"主公，我们胜利了！",
 1,"嗯！黄忠！黄忠怎么样了？严颜呢？",
 126,"虽然伤势比较重，但是还活着……",
 1,"什么！黄忠在哪？马上去看黄忠！");
 PlayBGM(4);
 DrawMulitStrBox("　刘备等人，收起了占领许昌的欣喜，立刻赶到黄忠和严颜的身边探视．*　黄忠和严颜，由于遭突袭而受重伤……");
 talk( 1,"黄忠！严颜！许昌攻下来了，多亏你二人之力！",
 203,"哦，主公，恭喜……",
 170,"哦，曹丕……？杀了曹丕吗？",
 1,"嗯……杀了．",
 126,"……",
 170,"哦，太好了……如此，我就没有遗憾了．",
 1,"哪里话！复兴汉室的大业还没完，以后还仰仗二位！打起精神！这点箭伤没什么大碍！",
 203,"主公……您能用我这老兵，太感谢您了．我们为主公尽力到最后，心中很宽慰．");
 DrawMulitStrBox("　刘备军终于攻下许昌，但是为了胜利，也付出了巨大牺牲……*　然而，魏国还没有被消灭．曹丕，还有司马懿，正一步一步准备，欲与蜀国进行最后的决战．");
 end
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [655]=function()
 if not GetFlag(1080) then
 ModifyForce(170,1);
 ModifyForce(203,1);
 end
 SetSceneID(-1,0);
 JY.Base["章节名"]="第四章　蜀魏最后决战";
 DrawStrBoxCenter("第四章　蜀魏最后决战");
 LoadPic(27,1);
 DrawMulitStrBox("　曹丕丢掉许昌后，在魏国最后的堡垒－邺城集结全部兵马，决心在此与蜀一决雌雄．*　另一方面，刘备在许昌重新派兵点将，蜀魏的最后决战终于展开了．");
 LoadPic(27,2);
 SetSceneID(0,11);
 talk( 213,"在邺城决战！全军向邺城集结！绝不把魏国交给刘备之流！");
 NextEvent();
 end,
 [656]=function()
 JY.Smap={};
 JY.Base["现在地"]="许昌";
 JY.Base["道具屋"]=26;
 AddPerson(1,7,8,3);
 AddPerson(126,13,9,3);
 if not GetFlag(38) then
 AddPerson(133,9,11,3);
 end
 if GetFlag(58) then
 AddPerson(2,19,8,1);
 end
 AddPerson(54,21,9,1);
 AddPerson(127,23,10,1);
 if GetFlag(135) then
 AddPerson(3,7,14,0);
 end
 AddPerson(190,9,15,0);
 AddPerson(175,37,23,2);
 SetSceneID(84,8);
 DrawStrBoxCenter("许昌皇宫");
 MovePerson(175,8,2);
 talk( 175,"主公，向您报告．曹丕在邺城集结了全部兵力，大概要与我军决战．",
 1,"嗯，这一时刻终于来了．");
 MovePerson(127,2,3);
 MovePerson(127,2,1);
 MovePerson(127,2,2);
 talk( 127,"既然这样，已经什么都不想了，只等厮杀！");
 MovePerson(190,3,3);
 MovePerson(190,2,0);
 MovePerson(190,2,2);
 talk( 190,"是的！重振汉王朝的威严．");
 MovePerson(54,3,3);
 MovePerson(54,3,1);
 MovePerson(54,2,2);
 talk( 54,"复兴汉室！平息战乱！");
 if GetFlag(135) then
 MovePerson(3,4,3);
 MovePerson(3,2,0);
 MovePerson(3,3,2);
 talk( 3,"大哥，我们多年来的梦想就要实现了．");
 end
 if GetFlag(58) then
 MovePerson(2,4,3);
 MovePerson(2,2,1);
 MovePerson(2,3,2);
 talk( 2,"正如三弟所说，兄长，我等三人的梦想就要成真了．");
 end
 if not GetFlag(38) then
 MovePerson(133,1,3);
 MovePerson(133,0,2);
 talk( 133,"主公，请快下令出征吧！");
 end
 MovePerson(126,1,3);
 MovePerson(126,0,2);
 talk( 126,"主公，现在众将士气高涨，正是出击的绝好机会．",
 1,"嗯……往事不堪回首，一路苦难．我从平黄巾之乱起拯救乱世，与关、张二弟联手，那时至今已历多年．现在，终于到了结束这乱世的时候了．好不容易实现夙愿．",
 126,"主公，还不能松懈，为复兴汉室，还有最后的大事．",
 1,"嗯……好！全体将士，开始准备出征．");
 DrawMulitStrBox("噢！");
 talk( 175,"主公，再加把劲，讨伐曹丕，复兴汉室．");
 MovePerson(175,10,3);
 DecPerson(175);
 talk( 127,"多谢您能用我这样新来乍到的人，以后也请您多提携．");
 MovePerson(127,12,3);
 DecPerson(127);
 talk( 190,"杀了曹丕，报亡父之仇，也为万民报仇．愿将其首级祭于亡父灵前．下命令吧！");
 MovePerson(190,12,3);
 DecPerson(190);
 talk( 54,"吾与主公患难相随，今后也将荣辱与共．这最后一战，愿冒死当先．");
 MovePerson(54,12,3);
 DecPerson(54);
 if GetFlag(135) then
 talk( 3,"大哥，关键时刻到了．怎么身子有些发颤！",
 1,"怎么了？还怕吗？",
 3,"瞧您说的！我这是精神抖擞，让我出征！");
 MovePerson(3,14,3);
 DecPerson(3);
 end
 if GetFlag(58) then
 talk( 2,"兄长，我等夙愿就要实现了．",
 1,"是啊！说实话，当时听说二弟你败走荆州时，我以为你以不在了……现在真好！",
 2,"兄长说哪儿话，我等不是发誓宁愿同死吗？俺关羽绝不背弃誓言．兄长，我先准备准备．");
 MovePerson(2,14,3);
 DecPerson(2);
 end
 if not GetFlag(38) then
 talk( 133,"主公，我也准备去了．",
 1,"庞统，若没有你，有不会迎来今日，多谢了．",
 133,"哪里哪里，实不敢当．我也蒙受主公知遇之恩，欣喜异常．好吧，我先去准备出征．");
 MovePerson(133,16,3);
 DecPerson(133);
 end
 talk( 1,"太好了．我也该准备……？");
 if GetFlag(1080) then
 AddPerson(170,20,16,2);
 AddPerson(203,22,15,2);
 else
 AddPerson(170,36,24,2);
 AddPerson(203,38,23,2);
 MovePerson( 170,8,2,
 203,8,2);
 end
 talk( 170,"主公，就在此一战了．",
 203,"我们随时接应．",
 1,"黄忠！严颜！");
 if GetFlag(1080) then
 DecPerson(170);
 DecPerson(203);
 talk( 126,"……？主公，怎么了？",
 1,"嗨！……此时此刻，彷佛黄忠和严颜二位老将军还在……",
 126,"……．主公，请进去准备吧．");
 else
 MovePerson( 170,12,3,
 203,12,3);
 DecPerson(170);
 DecPerson(203);
 end
 --显示任务目标:<进行出征准备．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [657]=function()
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [658]=function()
 talk( 126,"请调兵派将．");
 WarIni();
 DefineWarMap(55,"第四章 邺I之战","一、曹丕的结局",40,0,212);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,19,23, 2,0,-1,0,
 125,20,23, 2,0,-1,0,
 -1,14,23, 2,0,-1,0,
 -1,16,23, 2,0,-1,0,
 -1,17,22, 2,0,-1,0,
 -1,18,22, 2,0,-1,0,
 -1,18,23, 2,0,-1,0,
 -1,19,21, 2,0,-1,0,
 -1,20,22, 2,0,-1,0,
 -1,21,21, 2,0,-1,0,
 -1,21,22, 2,0,-1,0,
 -1,22,22, 2,0,-1,0,
 -1,22,23, 2,0,-1,0,
 -1,23,23, 2,0,-1,0,
 -1,25,23, 2,0,-1,0,
 });
 DrawSMap();
 talk( 126,"向邺城进军！");
 JY.Smap={};
 SetSceneID(0,3);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 212,18,0, 1,2,65,9, 0,0,-1,0,
 211,17,1, 1,0,62,22, 0,0,-1,0,
 238,17,0, 1,2,61,16, 0,0,-1,0,
 67,13,6, 3,1,62,9, 0,0,-1,0,
 93,17,7, 1,0,61,16, 0,0,-1,0,
 79,18,7, 1,0,62,25, 0,0,218,0,
 217,22,6, 4,1,61,9, 0,0,-1,0,
 115,31,15, 3,1,61,3, 0,0,-1,0,
 19,17,5, 1,2,61,25, 0,0,-1,0, --曹洪
 214,18,5, 1,2,61,20, 0,0,-1,0,
 78,9,6, 3,1,62,9, 0,0,-1,0, --徐晃
 170,10,7, 3,1,61,9, 0,0,-1,0, --牛金
 102,26,6, 4,1,62,22, 0,0,-1,0, --张郃
 215,25,7, 4,1,61,9, 0,0,-1,0, --庞德
 17,13,4, 4,4,62,22, 14,17,901,0, --夏侯渊
 16,21,4, 3,4,64,9, 24,17,904,0, --夏侯惇
 18,18,2, 1,1,63,25, 0,0,903,0, --曹仁
 278,14,8, 1,0,55,6, 0,0,-1,0,
 256,5,15, 4,1,58,3, 0,0,-1,0,
 257,29,15, 3,1,57,3, 0,0,-1,0,
 258,7,15, 4,1,58,3, 0,0,-1,0,
 
 259,16,8, 1,0,57,3, 0,0,-1,0,
 260,19,8, 1,0,57,3, 0,0,-1,0,
 279,21,8, 1,0,55,6, 0,0,-1,0,
 274,13,3, 1,0,55,21, 0,0,-1,0,
 275,12,4, 1,0,55,21, 0,0,-1,0,
 276,22,4, 1,0,55,21, 0,0,-1,0,
 277,21,3, 1,0,55,21, 0,0,-1,0,
 213,18,0, 1,2,65,16, 0,0,-1,1,
 292,7,6, 3,1,58,9, 0,0,-1,0,
 293,8,7, 3,1,58,9, 0,0,-1,0,
 294,9,8, 3,1,57,9, 0,0,-1,0,
 295,10,9, 3,1,57,9, 0,0,-1,0,
 296,28,6, 4,1,58,9, 0,0,-1,0,
 297,27,7, 4,1,58,9, 0,0,-1,0,
 298,26,8, 4,1,57,9, 0,0,-1,0,
 299,25,9, 4,1,57,9, 0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [659]=function()
 PlayBGM(11);
 talk( 213,"你们这些东西，侵犯朕的领土．这个国家是父亲传给我的，比什么都重要，不能交给任何人．",
 126,"曹丕已来到城外决战了，奋勇进攻吧！");
 WarShowTarget(true);
 PlayBGM(16);
 NextEvent();
 end,
 [660]=function()
 if WarMeet(44,212) then
 WarAction(1,44,212);
 talk( 44,"来将可是曹彰？喂，那个黄毛小子！速来与我决战！",
 212,"呸，少废话，我曹彰可不是吃素的！");
 WarAction(6,44,212);
 if fight(44,212)==1 then
 talk( 212,"真是对手，看我一戟？");
 WarAction(4,212,44);
 talk( 44,"哦，这……",
 212,"招家伙！");
 WarAction(9,212,44);
 talk( 44,"好险！",
 212,"好小子！躲过去了！",
 44,"该我的了．");
 WarAction(8,44,212);
 talk( 212,"哎呀！可惜……");
 WarAction(18,212);
 talk( 44,"刺中了！干掉这小子！");
 WarLvUp(GetWarID(44));
 else
 talk( 212,"真是对手，看我一戟？");
 WarAction(4,212,44);
 talk( 44,"哦，这……",
 212,"招家伙！");
 WarAction(8,212,44);
 talk( 44,"哎呀！可惜……");
 WarAction(17,44);
 WarLvUp(GetWarID(212));
 end
 end
 if WarMeet(30,239) then
 WarAction(1,30,239);
 talk( 30,"曹氏兄弟也亲自出征了，好吧，看我宰了你！曹植，小心了！",
 239,"啊……既然如此，不战也不行了．");
 WarAction(6,30,239);
 if fight(30,239)==1 then
 talk( 30,"我乃关羽之子关兴，曹植，你死定了！",
 239,"打就打吧！");
 WarAction(8,30,239);
 talk( 239,"啊！");
 WarAction(18,239);
 talk( 30,"曹植，宰你的是我关兴！");
 WarLvUp(GetWarID(30));
 else
 WarAction(4,239,30);
 talk( 30,"啊！");
 WarAction(17,30);
 WarLvUp(GetWarID(239));
 end
 end
 WarLocationItem(2,9,49,124); --获得道具:获得道具：援军书
 WarLocationItem(2,26,60,125); --获得道具:获得道具：霸王之剑
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 talk( 213,"哎呀！你们要干什么？朕可是大魏皇帝！",
 1,"杀了你，拯救乱世！准备受死吧！",
 213,"朕知道，可是朕还不想死！我投降！这总可以吧？",
 1,"这也是曹操的儿子吗？可悲，可叹……");
 PlayBGM(11);
 WarShowArmy(213);
 talk( 213,"哦，司马懿！你去哪里了？来，快杀了这群家伙！",
 214,"是，如您所望，杀给你看……",
 213,"嗯？司、司马懿！你疯了吗？敌人在对面！为何以剑指朕？",
 1,"怎么？发生了什么事？",
 214,"你这不成器的家伙，玷污了曹操主公一世盛名！我替他老人家惩罚你！",
 213,"喂！司马懿！住手！哇啊！！");
 WarAction(8,214,213);
 --WarAction(18,213);
 DrawStrBoxCenter("司马懿手刃了曹丕！");
 talk( 214,"刘备！曹丕虽死，但魏国不会灭亡，我将继承曹操主公的意志！我在城内等你！");
 WarAction(16,214);
 PlayBGM(3);
 talk( 1,"究竟怎么回事？",
 126,"不知道．能说的就是，大战还没结束．进攻城内吧！");
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 end,
 [661]=function()
 WarIni2();
 DefineWarMap(56,"第四章 邺II之战","一、司马懿的结局",40,0,213);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm2(1,{
 0,14,19, 2,0,-1,0,
 125,15,19, 2,0,-1,0,
 -1,6,20, 2,0,-1,0,
 -1,22,20, 2,0,-1,0,
 -1,5,19, 2,0,-1,0,
 -1,23,20, 2,0,-1,0,
 -1,13,18, 2,0,-1,0,
 -1,4,18, 2,0,-1,0,
 -1,24,19, 2,0,-1,0,
 -1,16,18, 2,0,-1,0,
 -1,4,20, 2,0,-1,0,
 -1,25,18, 2,0,-1,0,
 -1,17,18, 2,0,-1,0,
 -1,3,18, 2,0,-1,0,
 -1,25,20, 2,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 213,14,5, 1,2,67,16, 0,0,-1,0,
 239,10,6, 1,0,64,16, 0,0,-1,0,
 240,17,6, 1,0,64,16, 0,0,-1,0,
 67,15,5, 1,0,64,9, 0,0,-1,0,
 93,25,13, 1,2,63,16, 0,0,-1,0,
 79,13,11, 1,2,64,25, 0,0,218,0,
 217,13,13, 1,0,63,9, 0,0,-1,0,
 115,14,13, 1,0,63,3, 0,0,-1,0,
 18,14,7, 1,0,65,25, 0,0,903,0, --曹仁
 19,13,7, 1,0,63,25, 0,0,-1,0, --曹洪
 214,15,7, 1,0,63,20, 0,0,-1,0, --曹休
 78,5,6, 3,1,64,9, 0,0,-1,0, --徐晃
 170,6,7, 3,1,63,9, 0,0,-1,0, --牛金
 102,26,12, 1,1,64,22, 0,0,-1,0, --张郃
 215,25,11, 1,1,63,9, 0,0,-1,0, --庞德
 17,14,9, 1,1,65,22, 0,0,901,0, --夏侯渊
 16,15,9, 1,1,66,9, 0,0,904,0, --夏侯惇
 256,12,10, 1,0,60,3, 0,0,-1,0,
 257,14,11, 1,2,59,3, 0,0,-1,0,
 292,6,10, 3,0,62,9, 0,0,-1,0,
 293,4,11, 3,0,62,9, 0,0,-1,0,
 294,4,12, 3,2,60,9, 0,0,-1,0,
 295,25,14, 3,2,60,9, 0,0,-1,0,
 296,19,7, 4,0,59,9, 0,0,-1,0,
 297,23,7, 3,0,60,9, 0,0,-1,0,
 274,12,13, 1,2,58,6, 0,0,-1,0,
 275,14,12, 1,0,58,6, 0,0,-1,0,
 276,18,9, 4,0,58,21, 0,0,-1,0,
 277,5,11, 3,2,58,6, 0,0,-1,0,
 278,5,13, 3,0,58,6, 0,0,-1,0,
 279,13,10, 1,2,58,21, 0,0,-1,0,
 280,14,10, 1,0,58,21, 0,0,-1,0,
 281,22,11, 4,0,58,6, 0,0,-1,0,
 282,7,8, 3,2,58,6, 0,0,-1,0,
 
 8,14,2, 1,2,77,9, 0,0,-1,1,
 
 258,18,5, 4,0,60,3, 0,0,-1,0,
 259,18,6, 4,0,59,3, 0,0,-1,0,
 298,9,5, 3,0,60,9, 0,0,-1,0,
 299,9,6, 3,0,59,9, 0,0,-1,0,
 });
 War.Turn=1;
 NextEvent();
 end,
 [662]=function()
 PlayBGM(11);
 talk( 214,"哈哈！如此魏国不会灭亡了！蜀军，来受死吧！");
 WarShowTarget(true);
 PlayWavE(51);
 WarFireWater(6,11,1); --WarFireWater(6,15,1);
 WarFireWater(6,12,1);
 WarFireWater(6,13,1);
 WarFireWater(6,14,1);
 WarFireWater(6,15,1);
 WarFireWater(7,15,1);
 WarFireWater(7,16,1);
 WarFireWater(7,17,1);
 WarFireWater(7,18,1);
 WarFireWater(8,18,1);
 WarFireWater(9,18,1);
 WarFireWater(10,18,1);
 WarFireWater(11,18,1);
 WarFireWater(12,18,1);
 WarFireWater(18,18,1);
 WarFireWater(19,18,1);
 WarFireWater(20,18,1);
 WarFireWater(21,18,1);
 WarFireWater(22,18,1);
 WarFireWater(22,17,1);
 WarFireWater(22,16,1);
 WarFireWater(22,15,1);
 WarEnemyWeak(2,1);
 WarEnemyWeak(1,1);
 talk( 1,"哦，怎么？在自家城里放火！",
 126,"敌人好像孤注一掷了，要么彻底胜利，要么宁为玉碎．",
 1,"什么？自家军队被火烧，也是预料之中？",
 126,"是的，这座城也保不住了，如果不撤退……啊！城门！");
 --
 SetWarMap(23,24,1,10);
 PlayWavE(18);
 WarDelay(48);
 War.MapID=56;
 WarDelay(12);
 --
 talk( 1,"可恶！怎么连退路都没有！",
 214,"哈哈哈！烧死才好！曹操主公，来世再追随您！",
 126,"主公，只有冲了．司马懿肯定准备好了逃跑的路．",
 1,"好，全体将士，捉住司马懿！");
 PlayBGM(9);
 NextEvent();
 end,
 [663]=function()
 WarLocationItem(11,0,49,126); --获得道具:获得道具：援军书
 WarLocationItem(10,11,49,127); --获得道具:获得道具：援军书
 WarLocationItem(13,23,52,128); --获得道具:获得道具：勇气书
 WarLocationItem(5,6,52,129); --获得道具:获得道具：勇气书
 if (not GetFlag(1081)) and War.Turn==8 then
 PlayBGM(11);
 talk( 126,"主公，危险！请赶快吧！");
 PlayWavE(51);
 WarFireWater(0,11,1);
 PlayBGM(9);
 SetFlag(1081,1)
 end
 if (not GetFlag(1082)) and War.Turn==16 then
 PlayBGM(11);
 talk( 126,"主公，请赶快！");
 PlayWavE(51);
 WarFireWater(23,13,1);
 PlayBGM(9);
 SetFlag(1082,1)
 end
 if (not GetFlag(1083)) and War.Turn==20 then
 PlayBGM(11);
 talk( 126,"主公，赶快！");
 PlayWavE(51);
 WarFireWater(11,10,1);
 WarFireWater(6,5,1);
 PlayBGM(9);
 SetFlag(1083,1)
 end
 if (not GetFlag(1084)) and War.Turn==24 then
 PlayBGM(11);
 talk( 126,"主公，请赶快！城墙已不坚固了，危险！");
 PlayWavE(51);
 WarFireWater(5,9,1);
 WarFireWater(6,9,1);
 WarFireWater(7,9,1);
 WarFireWater(8,9,1);
 WarFireWater(9,9,1);
 WarFireWater(13,10,1);
 WarFireWater(14,10,1);
 WarFireWater(15,10,1);
 WarFireWater(19,7,1);
 WarFireWater(20,7,1);
 WarFireWater(21,7,1);
 WarFireWater(22,7,1);
 WarFireWater(23,7,1);
 PlayBGM(9);
 SetFlag(1084,1)
 end
 if (not GetFlag(1085)) and War.Turn==28 then
 PlayBGM(11);
 talk( 214,"时候到了．刘备，再见了．和邺城一起毁灭吧．",
 126,"主公，城崩塌了．",
 1,"什么！啊！");
 DrawMulitStrBox("　邺城被烧毁．*　刘备军中了司马懿的火计，全军覆没．");
 SetFlag(1085,1)
 JY.Status=GAME_START;
 NextEvent(999); --goto ???
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
 talk( 214,"可恶……即使竭我之力，也无法遏制蜀军……",
 1,"司马懿，等死吧！",
 214,"呀！");
 PlayBGM(11);
 DrawMulitStrBox("　司马懿再坚持一下．");
 talk( 1,"嗯？什么声音？",
 214,"此声……呀，但是，绝不……");
 DrawMulitStrBox("　司马懿还要坚持．只要有我在……");
 PlayBGM(10);
 WarShowArmy(8);
 talk( 9,"司马懿，还没结束！",
 214,"哦，曹操主公！",
 1,"什么！是曹操！为何曹操……",
 9,"刘备，你把魏国折腾得够苦，也就到此为止了．我正在此等着你，你运气还可以．但是，打到我这里……哈哈哈！");
 WarMoveTo(9,10,0);
 WarAction(16,9);
 PlayBGM(3);
 talk( 214,"曹操主公，请稍等！",
 1,"怎么回事？难道曹操没死？",
 126,"我也不知，可是……",
 1,"可是什么？",
 126,"现在看到的，也不是在梦里吧？",
 1,"嗯……说曹操进去了，走，除了到里面瞧瞧．也别无他法．",
 126,"是，那我们进去吧．");
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 end,
 [664]=function()
 WarIni2();
 DefineWarMap(57,"第四章 邺III之战","一、曹操的灭亡",50,0,8);
 -- id,x,y, d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm2(1,{
 0,24,21, 2,0,-1,0,
 125,25,21, 2,0,-1,0,
 -1,13,23, 2,0,-1,0,
 -1,8,23, 2,0,-1,0,
 -1,23,22, 2,0,-1,0,
 -1,9,21, 2,0,-1,0,
 -1,14,23, 2,0,-1,0,
 -1,25,23, 2,0,-1,0,
 -1,10,22, 2,0,-1,0,
 -1,22,21, 2,0,-1,0,
 -1,26,22, 2,0,-1,0,
 -1,12,22, 2,0,-1,0,
 -1,11,22, 2,0,-1,0,
 -1,12,23, 2,0,-1,0,
 -1,15,22, 2,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 8,19,1, 1,2,77,9, 0,0,-1,0,
 213,19,3, 1,2,70,16, 0,0,-1,0,
 239,18,3, 1,2,65,16, 0,0,-1,0,
 240,20,3, 1,2,65,16, 0,0,-1,0,
 68,30,8, 1,0,64,16, 0,0,-1,0,
 76,35,14, 1,0,64,16, 0,0,-1,0,
 67,31,9, 1,2,65,25, 0,0,-1,0,
 93,34,16, 1,2,64,16, 0,0,-1,0,
 79,10,9, 4,2,65,25, 0,0,218,0,
 217,4,8, 1,0,63,9, 0,0,-1,0,
 115,23,16, 3,0,63,3, 0,0,-1,0,
 386,19,2, 1,3,72,25, 8,0,-1,0, --典韦S
 61,18,1, 1,0,67,16, 0,0,-1,0, --郭嘉
 77,20,1, 1,0,65,16, 0,0,-1,0, --程昱
 18,20,12, 1,0,66,25, 0,0,903,0, --曹仁
 19,21,12, 1,0,65,25, 0,0,-1,0, --曹洪
 241,17,5, 3,0,65,20, 0,0,-1,0, --曹真
 214,21,5, 4,0,63,20, 0,0,-1,0, --曹休
 78,6,6, 1,0,65,9, 0,0,-1,0, --徐晃
 215,3,9, 1,0,64,9, 0,0,-1,0, --庞德
 121,3,7, 1,0,64,9, 0,0,-1,0, --文聘
 101,5,7, 1,0,63,9, 0,0,-1,0, --张绣
 170,4,6, 1,0,63,9, 0,0,-1,0, --牛金
 17,18,6, 4,0,66,22, 0,0,901,0, --夏侯渊
 16,19,5, 1,0,67,9, 0,0,904,0, --夏侯惇
 209,28,5, 4,0,63,21, 0,0,-1,0, --夏侯尚
 210,29,6, 4,0,64,20, 0,0,902,0, --夏侯德
 102,20,6, 3,0,65,22, 0,0,-1,0, --张郃
 103,30,5, 4,0,63,6, 0,0,-1,0, --高览
 83,16,2, 1,0,64,21, 0,0,-1,0, --满宠
 100,22,2, 1,0,64,21, 0,0,-1,0, --刘晔
 172,31,8, 1,0,63,21, 0,0,-1,0, --曹纯
 129,3,17, 1,2,63,3, 0,0,-1,0, --韩浩
 62,27,6, 1,2,64,25, 0,0,-1,0, --于禁
 274,2,17, 1,2,61,21, 0,0,-1,0,
 275,11,11, 1,2,61,21, 0,0,-1,0,
 276,18,17, 3,2,60,21, 0,0,-1,0,
 277,32,9, 3,2,60,21, 0,0,-1,0,
 278,35,16, 1,2,59,21, 0,0,-1,0,
 256,6,16, 3,0,61,3, 0,0,-1,0,
 257,8,11, 4,2,61,3, 0,0,-1,0,
 258,23,15, 3,0,60,3, 0,0,-1,0,
 259,32,5, 4,0,60,3, 0,0,-1,0,
 260,30,15, 4,0,59,3, 0,0,-1,0,
 292,6,17, 3,0,62,9, 0,0,-1,0,
 293,16,11, 4,0,62,9, 0,0,-1,0,
 294,16,10, 4,0,62,9, 0,0,-1,0,
 295,35,17, 1,2,61,9, 0,0,-1,0,
 296,34,17, 1,2,61,9, 0,0,-1,0,
 297,32,6, 4,0,61,9, 0,0,-1,0,
 261,17,15, 3,2,61,3, 0,0,-1,0,
 262,17,16, 3,2,60,3, 0,0,-1,0,
 298,3,8, 3,0,61,9, 0,0,-1,0,
 });
 War.Turn=1;
 NextEvent();
 end,
 [665]=function()
 PlayBGM(11);
 talk( 1,"曹操，没想到吧！你不是就要完了吗！",
 9,"连曹丕、司马懿等人都被骗了，你一定不知道，好吧，我为你解释一下．",
 9,"魏、蜀、吴这三国，关系微妙，势均力敌，互相牵制．如果这种状况持续下去，我无法统一天下．所以，我决定诈死．",
 1,"诈死？",
 9,"正是．如果我死了，料想三国的平衡就打破了．接着，我播下了祸种，先杀了关羽，把责任推给东吴，想让吴蜀相争．");
 talk( 126,"什么！如此说，吴、蜀相争竟是曹操的圈套．",
 9,"正是．那时我已不在了，东吴可以安心与蜀作战．就是那么想的，可真没想到蜀吴会结成同盟．刘备，你能容忍东吴，我万没想到．",
 1,"……",
 9,"蜀吴两败俱伤，不论哪家灭亡了，剩下的另一家都已元气大伤．那时再出击，可轻易取胜，于是，魏国就可统一天下．这正是我的如意算盘，……没想到我错了．",
 9,"而且，将国家交给曹丕等人也是大错，这个国家轻易地毁在那家伙手里．这座美丽的城市，也如此狼狈．",
 1,"……",
 9,"但是，还不会就这么结束！打败你，合并魏、蜀两国，再统一天下．刘备，不要妨碍我的梦想的实现．",
 1,"曹操，你那样的想法制造了世上的战乱，是万民涂炭的元凶！董卓、吕布、袁绍、袁术……，这些人，都只顾自己．曹操，你也和他们一样．",
 9,"什么！说我与董卓之流一样！混蛋……！",
 1,"曹操，天下人已容不下你！乱国害君，你不死无以谢天下．");
 WarShowTarget(true);
 PlayBGM(10);
 NextEvent();
 end,
 [666]=function()
 if WarMeet(3,68) then
 WarAction(1,3,68);
 talk( 3,"来将可是许褚．张飞在此，特来送你见阎王，许褚，一决胜负．",
 68,"呸！张飞，过来受死！");
 WarAction(6,3,68);
 if fight(3,68)==1 then
 talk( 68,"哦，果然有两下子！",
 3,"看不出，你还有两手！呀！");
 WarAction(10,3,68);
 talk( 68,"难决胜负．张飞，这刀结束你算了．",
 3,"来呀！",
 68,"看招！");
 WarAction(9,68,3);
 talk( 3,"不过如此！");
 WarAction(4,3,68);
 talk( 3,"真可惜．",
 68,"杀了我吧．",
 3,"死吧！");
 WarAction(8,3,68);
 talk( 68,"啊……！");
 WarAction(18,68);
 talk( 3,"……刚才真惊险．");
 WarLvUp(GetWarID(3));
 else
 talk( 68,"哦，果然有两下子！",
 3,"看不出，你还有两手！呀！");
 WarAction(10,3,68);
 talk( 68,"难决胜负．张飞，这刀结束你算了．",
 3,"来呀！",
 68,"看招！");
 WarAction(8,68,3);
 talk( 3,"啊……！");
 WarAction(17,3);
 WarLvUp(GetWarID(68));
 end
 end

 if JY.Person[80]["君主"]~=1 and GetFlag(218) and WarMeet(2,80) then
 WarAction(1,2,80);
 talk( 2,"张辽……",
 80,"关羽……",
 2,"张辽，我和你势必一战……",
 80,"什么也别说了．来吧，亮武器吧！",
 2,"……");
 WarAction(6,2,80);
 if fight(2,80)==1 then
 talk( 80,"关羽！别愣着！好好打！不然，会被我杀了！来吧！");
 WarAction(4,80,2);
 talk( 80,"哈哈……",
 2,"张辽，死定了！");
 WarAction(8,2,80);
 talk( 80,"哎呀！！不好！");
 WarAction(19,80);
 talk( 2,"张辽……",
 80,"别那么伤心．现在，我感觉很清爽，为了我所效忠的君主……而死．士为知己者死，这是我的梦想……没想到现在实现了．",
 2,"可是，我……发生了这样的结果……",
 80,"关羽，如果当年在下邳没有你，也到不了今日．有……礼了，多……谢了！",
 2,"张辽……为什么？注定要如此悲惨的结局！呜！！");
 WarAction(18,80);
 WarLvUp(GetWarID(2));
 else
 talk( 2,"关羽！别愣着！好好打！不然，会被我杀了！来吧！");
 WarAction(4,80,2);
 talk( 2,"哈哈……");
 WarAction(17,2);
 WarLvUp(GetWarID(80));
 end
 end
 if WarMeet(54,116) then
 WarAction(1,54,116);
 talk( 54,"李典！与我决一死战！",
 116,"既然如此，我也无计可施．赵云，放马过来！");
 WarAction(6,54,116);
 if fight(54,116)==1 then
 talk( 116,"啊！");
 WarAction(8,54,116);
 talk( 116,"啊，魏国也要亡了……");
 WarAction(18,116);
 WarLvUp(GetWarID(54));
 else
 WarAction(4,116,54);
 talk( 54,"啊！");
 WarAction(17,54);
 WarLvUp(GetWarID(116));
 end
 end
 if WarMeet(190,218) then
 WarAction(1,190,218);
 talk( 190,"乐进！在渭水多蒙你”关照”！现在在此，我要报仇雪恨！看招！",
 218,"嘿！");
 WarAction(6,190,218);
 if fight(190,218)==1 then
 talk( 190,"呀！");
 WarAction(4,190,218);
 talk( 218,"哇！",
 190,"嘿！");
 WarAction(8,190,218);
 talk( 218,"啊！");
 WarAction(18,218);
 talk( 190,"哼！渭水之恨，稍稍得雪！");
 WarLvUp(GetWarID(190));
 else
 WarAction(4,218,190);
 talk( 190,"哇！");
 WarAction(17,190);
 WarLvUp(GetWarID(218));
 end
 end
 if (not GetFlag(1086)) and War.Turn==4 then
 PlayBGM(11);
 talk( 9,"我要出征了．");
 PlayWavE(51);
 WarFireWater(0,16,1);
 WarFireWater(0,17,1);
 WarFireWater(0,18,1);
 DrawStrBoxCenter("城内起火了！");
 talk( 9,"太好了，哈哈哈……刘备，没想到我预先在城中做了手脚．啊，火啊，着得好！用火打断刘备军！");
 WarModifyAI(103,4,35,18);
 WarModifyAI(62,4,31,10);
 PlayBGM(10);
 SetFlag(1086,1);
 end
 if (not GetFlag(1087)) and War.Turn==6 then
 PlayWavE(51);
 WarFireWater(1,18,1);
 WarFireWater(2,18,1);
 WarModifyAI(210,4,33,9);
 WarModifyAI(209,4,30,9);
 SetFlag(1087,1);
 end
 if (not GetFlag(1088)) and War.Turn==8 then
 PlayBGM(11);
 PlayWavE(51);
 WarFireWater(2,17,1);
 WarFireWater(3,17,1);
 WarFireWater(4,17,1);
 WarFireWater(3,18,1);
 WarFireWater(3,19,1);
 WarFireWater(2,20,1);
 WarFireWater(3,20,1);
 WarFireWater(4,20,1);
 WarFireWater(4,18,1);
 talk( 126,"哦，主公，前面路上！",
 1,"什么事……",
 9,"哈哈哈！烧吧，烧吧！用火攻，将你们打断！");
 WarModifyAI(129,1);
 WarModifyAI(274,1);
 WarModifyAI(256,1);
 WarModifyAI(292,1);
 WarModifyAI(261,4,20,16);
 WarModifyAI(276,4,21,16);
 PlayBGM(10);
 SetFlag(1088,1);
 end
 if (not GetFlag(1089)) and War.Turn==10 then
 PlayWavE(51);
 WarFireWater(6,18,1);
 WarFireWater(8,18,1);
 SetFlag(1089,1);
 end
 if (not GetFlag(1090)) and War.Turn==12 then
 PlayWavE(51);
 WarFireWater(10,18,1);
 WarFireWater(12,18,1);
 SetFlag(1090,1);
 end
 if (not GetFlag(1091)) and War.Turn==14 then
 PlayWavE(51);
 WarFireWater(14,18,1);
 WarFireWater(16,18,1);
 SetFlag(1091,1);
 end
 if (not GetFlag(1092)) and War.Turn==16 then
 PlayWavE(51);
 WarFireWater(18,18,1);
 WarFireWater(19,17,1);
 WarFireWater(20,18,1);
 SetFlag(1092,1);
 end
 if (not GetFlag(1093)) and War.Turn==18 then
 PlayBGM(11);
 PlayWavE(51);
 WarFireWater(18,15,1);
 WarFireWater(18,16,1);
 WarFireWater(18,17,1);
 WarFireWater(19,16,1);
 WarFireWater(20,15,1);
 WarFireWater(20,16,1);
 WarFireWater(20,17,1);
 WarFireWater(19,15,1);
 WarFireWater(22,18,1);
 WarFireWater(24,18,1);
 talk( 1,"啊！还有火！",
 214,"别管城中之事了！打败你们这些人，天下就尽归曹公了！刘备！孔明！为了曹公，一定消灭你们！",
 9,"正是如此，司马懿，这是最后决战，在这里只许胜不准败．");
 WarModifyAI(261,1);
 WarModifyAI(276,1);
 WarModifyAI(115,1);
 WarModifyAI(258,1);
 WarModifyAI(18,1);
 WarModifyAI(19,1);
 WarModifyAI(293,1);
 WarModifyAI(294,1);
 WarModifyAI(275,1);
 WarModifyAI(79,1);
 WarModifyAI(257,1);
 PlayBGM(10);
 SetFlag(1093,1);
 end
 if (not GetFlag(1094)) and War.Turn==20 then
 PlayWavE(51);
 WarFireWater(19,14,1);
 WarFireWater(19,12,1);
 WarFireWater(25,17,1);
 WarFireWater(25,15,1);
 SetFlag(1094,1);
 end
 if (not GetFlag(1095)) and War.Turn==22 then
 PlayWavE(51);
 WarFireWater(17,12,1);
 WarFireWater(15,12,1);
 WarFireWater(25,13,1);
 WarFireWater(25,11,1);
 SetFlag(1095,1);
 end
 if (not GetFlag(1096)) and War.Turn==24 then
 PlayWavE(51);
 WarFireWater(13,12,1);
 WarFireWater(11,12,1);
 WarFireWater(25,9,1);
 WarFireWater(26,10,1);
 SetFlag(1096,1);
 end
 if (not GetFlag(1097)) and War.Turn==26 then
 PlayWavE(51);
 WarFireWater(9,12,1);
 WarFireWater(7,12,1);
 WarFireWater(25,7,1);
 WarFireWater(28,10,1);
 SetFlag(1097,1);
 end
 if (not GetFlag(1098)) and War.Turn==28 then
 PlayBGM(11);
 PlayWavE(51);
 WarFireWater(6,10,1);
 WarFireWater(6,11,1);
 WarFireWater(7,11,1);
 WarFireWater(8,10,1);
 WarFireWater(8,11,1);
 WarFireWater(7,9,1);
 WarFireWater(28,9,1);
 WarFireWater(28,8,1);
 WarFireWater(29,7,1);
 WarFireWater(30,7,1);
 talk( 9,"刘备，当年，在许昌的花园煮酒论英雄，那时的话还记得吗？当时说到最后，只有两个英雄，就是你我二人……我的眼力还是没有错．",
 9,"如果你不背叛我，与我同舟共济的话，我也许走的是另一条路吧．或者还是……嗨，现在说这些都晚了．",
 9,"刘备，不管怎么说，我二人相争已是天命，现在就是决定命运的时候，你来得正好！");
 PlayBGM(10);
 WarModifyAI(78,1);
 WarModifyAI(215,1);
 WarModifyAI(121,1);
 WarModifyAI(101,1);
 WarModifyAI(170,1);
 WarModifyAI(217,1);
 SetFlag(1098,1);
 end
 if (not GetFlag(1099)) and War.Turn==34 then
 PlayWavE(51);
 WarFireWater(25,6,1);
 WarFireWater(25,5,1);
 WarFireWater(30,6,1);
 WarFireWater(30,5,1);
 WarModifyAI(16,3,0);
 WarModifyAI(17,3,0);
 WarModifyAI(102,3,0);
 WarModifyAI(386,3,0);
 WarModifyAI(61,3,0);
 WarModifyAI(77,3,0);
 SetFlag(1099,1);
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(11);
 talk( 9,"哼！刘、刘备……！你把我的梦想……都搅乱了……！啊！！");
 PlayBGM(7);
 DrawMulitStrBox("　刘备打败了曹操，率军占领了邺城．");
 talk( 1,"成功了，终于打败曹操！",
 126,"主公，大功告成了．");
 if GetFlag(58) then
 talk( 2,"大哥，恭喜您了，实现了多年的愿望，真不容易．",
 3,"啊，等太久了．");
 end
 talk( 54,"去迎接圣上吧！",
 1,"好！高奏凯歌回洛阳！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [667]=function()
 SetSceneID(0,12);
 DrawMulitStrBox("　曹操的梦想破灭了．*　在这里，随着曹操的灭亡……*　结了魏、蜀、吴三国时代．");
 NextEvent();
 end,
 [668]=function()
 JY.Status=GAME_START;
 end,
 [669]=function()
 JY.Status=GAME_START;
 end,
 [670]=function()
 JY.Status=GAME_START;
 end,
 [671]=function()
 JY.Status=GAME_START;
 end,
 [672]=function()
 JY.Status=GAME_START;
 end,
 [673]=function()
 JY.Status=GAME_START;
 end,
 [674]=function()
 JY.Status=GAME_START;
 end,
 [675]=function()
 JY.Status=GAME_START;
 end,
 [676]=function()
 JY.Status=GAME_START;
 end,
 [677]=function()
 JY.Status=GAME_START;
 end,
 [678]=function()
 JY.Status=GAME_START;
 end,
 [679]=function()
 JY.Status=GAME_START;
 end,
 [680]=function()
 JY.Status=GAME_START;
 end,
 [681]=function()
 JY.Status=GAME_START;
 end,
 [682]=function()
 JY.Status=GAME_START;
 end,
 [683]=function()
 JY.Status=GAME_START;
 end,
 [684]=function()
 JY.Status=GAME_START;
 end,
 [685]=function()
 JY.Status=GAME_START;
 end,
 [686]=function()
 JY.Status=GAME_START;
 end,
 [687]=function()
 JY.Status=GAME_START;
 end,
 [688]=function()
 JY.Status=GAME_START;
 end,
 [689]=function()
 JY.Status=GAME_START;
 end,
 [690]=function()
 JY.Status=GAME_START;
 end,
 [691]=function()
 JY.Status=GAME_START;
 end,
 [692]=function()
 JY.Status=GAME_START;
 end,
 [693]=function()
 JY.Status=GAME_START;
 end,
 [694]=function()
 JY.Status=GAME_START;
 end,
 [695]=function()
 JY.Status=GAME_START;
 end,
 [696]=function()
 JY.Status=GAME_START;
 end,
 [697]=function()
 JY.Status=GAME_START;
 end,
 [698]=function()
 JY.Status=GAME_START;
 end,
 [699]=function()
 JY.Status=GAME_START;
 end,
 [700]=function()
 JY.Status=GAME_START;
 end,
 [701]=function()
 JY.Status=GAME_START;
 end,
 [702]=function()
 JY.Status=GAME_START;
 end,
 [703]=function()
 JY.Status=GAME_START;
 end,
 [704]=function()
 JY.Status=GAME_START;
 end,
 [705]=function()
 JY.Status=GAME_START;
 end,
 [706]=function()
 JY.Status=GAME_START;
 end,
 [707]=function()
 JY.Status=GAME_START;
 end,
 [708]=function()
 JY.Status=GAME_START;
 end,
 [709]=function()
 JY.Status=GAME_START;
 end,
 [710]=function()
 JY.Status=GAME_START;
 end,
 [711]=function()
 JY.Status=GAME_START;
 end,
 [712]=function()
 JY.Status=GAME_START;
 end,
 [713]=function()
 JY.Status=GAME_START;
 end,
 [714]=function()
 JY.Status=GAME_START;
 end,
 [715]=function()
 JY.Status=GAME_START;
 end,
 [716]=function()
 JY.Status=GAME_START;
 end,
 [717]=function()
 JY.Status=GAME_START;
 end,
 [718]=function()
 JY.Status=GAME_START;
 end,
 [719]=function()
 JY.Status=GAME_START;
 end,
 [720]=function()
 JY.Status=GAME_START;
 end,
 [721]=function()
 JY.Status=GAME_START;
 end,
 [722]=function()
 JY.Status=GAME_START;
 end,
 [723]=function()
 JY.Status=GAME_START;
 end,
 [724]=function()
 JY.Status=GAME_START;
 end,
 [725]=function()
 JY.Status=GAME_START;
 end,
 [726]=function()
 JY.Status=GAME_START;
 end,
 [727]=function()
 JY.Status=GAME_START;
 end,
 [728]=function()
 JY.Status=GAME_START;
 end,
 [729]=function()
 JY.Status=GAME_START;
 end,
 [730]=function()
 JY.Status=GAME_START;
 end,
 [731]=function()
 JY.Status=GAME_START;
 end,
 [732]=function()
 JY.Status=GAME_START;
 end,
 [733]=function()
 JY.Status=GAME_START;
 end,
 [734]=function()
 JY.Status=GAME_START;
 end,
 [735]=function()
 JY.Status=GAME_START;
 end,
 [736]=function()
 JY.Status=GAME_START;
 end,
 [737]=function()
 JY.Status=GAME_START;
 end,
 [738]=function()
 JY.Status=GAME_START;
 end,
 [739]=function()
 JY.Status=GAME_START;
 end,
 [740]=function()
 JY.Status=GAME_START;
 end,
 [741]=function()
 JY.Status=GAME_START;
 end,
 [742]=function()
 JY.Status=GAME_START;
 end,
 [743]=function()
 JY.Status=GAME_START;
 end,
 [744]=function()
 JY.Status=GAME_START;
 end,
 [745]=function()
 JY.Status=GAME_START;
 end,
 [746]=function()
 JY.Status=GAME_START;
 end,
 [747]=function()
 JY.Status=GAME_START;
 end,
 [748]=function()
 JY.Status=GAME_START;
 end,
 [749]=function()
 JY.Status=GAME_START;
 end,
 [750]=function()
 JY.Status=GAME_START;
 end,
 [751]=function()
 JY.Status=GAME_START;
 end,
 [752]=function()
 JY.Status=GAME_START;
 end,
 [753]=function()
 JY.Status=GAME_START;
 end,
 [754]=function()
 JY.Status=GAME_START;
 end,
 [755]=function()
 JY.Status=GAME_START;
 end,
 [756]=function()
 JY.Status=GAME_START;
 end,
 [757]=function()
 JY.Status=GAME_START;
 end,
 [758]=function()
 JY.Status=GAME_START;
 end,
 [759]=function()
 JY.Status=GAME_START;
 end,
 [760]=function()
 JY.Status=GAME_START;
 end,
 [761]=function()
 JY.Status=GAME_START;
 end,
 [762]=function()
 JY.Status=GAME_START;
 end,
 [763]=function()
 JY.Status=GAME_START;
 end,
 [764]=function()
 JY.Status=GAME_START;
 end,
 [765]=function()
 JY.Status=GAME_START;
 end,
 [766]=function()
 JY.Status=GAME_START;
 end,
 [767]=function()
 JY.Status=GAME_START;
 end,
 [768]=function()
 JY.Status=GAME_START;
 end,
 [769]=function()
 JY.Status=GAME_START;
 end,
 [770]=function()
 JY.Status=GAME_START;
 end,
 [771]=function()
 JY.Status=GAME_START;
 end,
 [772]=function()
 JY.Status=GAME_START;
 end,
 [773]=function()
 JY.Status=GAME_START;
 end,
 [774]=function()
 JY.Status=GAME_START;
 end,
 [775]=function()
 JY.Status=GAME_START;
 end,
 [776]=function()
 JY.Status=GAME_START;
 end,
 [777]=function()
 JY.Status=GAME_START;
 end,
 [778]=function()
 JY.Status=GAME_START;
 end,
 [779]=function()
 JY.Status=GAME_START;
 end,
 [780]=function()
 JY.Status=GAME_START;
 end,
 [781]=function()
 JY.Status=GAME_START;
 end,
 [782]=function()
 JY.Status=GAME_START;
 end,
 [783]=function()
 JY.Status=GAME_START;
 end,
 [784]=function()
 JY.Status=GAME_START;
 end,
 [785]=function()
 JY.Status=GAME_START;
 end,
 [786]=function()
 JY.Status=GAME_START;
 end,
 [787]=function()
 JY.Status=GAME_START;
 end,
 [788]=function()
 JY.Status=GAME_START;
 end,
 [789]=function()
 JY.Status=GAME_START;
 end,
 [790]=function()
 JY.Status=GAME_START;
 end,
 [791]=function()
 JY.Status=GAME_START;
 end,
 [792]=function()
 JY.Status=GAME_START;
 end,
 [793]=function()
 JY.Status=GAME_START;
 end,
 [794]=function()
 JY.Status=GAME_START;
 end,
 [795]=function()
 JY.Status=GAME_START;
 end,
 [796]=function()
 JY.Status=GAME_START;
 end,
 [797]=function()
 JY.Status=GAME_START;
 end,
 [798]=function()
 JY.Status=GAME_START;
 end,
 [799]=function()
 JY.Status=GAME_START;
 end,
 [800]=function()
 JY.Status=GAME_START;
 end,
 [801]=function()
 JY.Status=GAME_START;
 end,
 [802]=function()
 JY.Status=GAME_START;
 end,
 [803]=function()
 JY.Status=GAME_START;
 end,
 [804]=function()
 JY.Status=GAME_START;
 end,
 [805]=function()
 JY.Status=GAME_START;
 end,
 [806]=function()
 JY.Status=GAME_START;
 end,
 [807]=function()
 JY.Status=GAME_START;
 end,
 [808]=function()
 JY.Status=GAME_START;
 end,
 [809]=function()
 JY.Status=GAME_START;
 end,
 [810]=function()
 JY.Status=GAME_START;
 end,
 [811]=function()
 JY.Status=GAME_START;
 end,
 [812]=function()
 JY.Status=GAME_START;
 end,
 [813]=function()
 JY.Status=GAME_START;
 end,
 [814]=function()
 JY.Status=GAME_START;
 end,
 [815]=function()
 JY.Status=GAME_START;
 end,
 [816]=function()
 JY.Status=GAME_START;
 end,
 [817]=function()
 JY.Status=GAME_START;
 end,
 [818]=function()
 JY.Status=GAME_START;
 end,
 [819]=function()
 JY.Status=GAME_START;
 end,
 [820]=function()
 JY.Status=GAME_START;
 end,
 [821]=function()
 JY.Status=GAME_START;
 end,
 [822]=function()
 JY.Status=GAME_START;
 end,
 [823]=function()
 JY.Status=GAME_START;
 end,
 [824]=function()
 JY.Status=GAME_START;
 end,
 [825]=function()
 JY.Status=GAME_START;
 end,
 [826]=function()
 JY.Status=GAME_START;
 end,
 [827]=function()
 JY.Status=GAME_START;
 end,
 [828]=function()
 JY.Status=GAME_START;
 end,
 [829]=function()
 JY.Status=GAME_START;
 end,
 [830]=function()
 JY.Status=GAME_START;
 end,
 [831]=function()
 JY.Status=GAME_START;
 end,
 [832]=function()
 JY.Status=GAME_START;
 end,
 [833]=function()
 JY.Status=GAME_START;
 end,
 [834]=function()
 JY.Status=GAME_START;
 end,
 [835]=function()
 JY.Status=GAME_START;
 end,
 [836]=function()
 JY.Status=GAME_START;
 end,
 [837]=function()
 JY.Status=GAME_START;
 end,
 [838]=function()
 JY.Status=GAME_START;
 end,
 [839]=function()
 JY.Status=GAME_START;
 end,
 [840]=function()
 JY.Status=GAME_START;
 end,
 [841]=function()
 JY.Status=GAME_START;
 end,
 [842]=function()
 JY.Status=GAME_START;
 end,
 [843]=function()
 JY.Status=GAME_START;
 end,
 [844]=function()
 JY.Status=GAME_START;
 end,
 [845]=function()
 JY.Status=GAME_START;
 end,
 [846]=function()
 JY.Status=GAME_START;
 end,
 [847]=function()
 JY.Status=GAME_START;
 end,
 [848]=function()
 JY.Status=GAME_START;
 end,
 [849]=function()
 JY.Status=GAME_START;
 end,
 [850]=function()
 JY.Status=GAME_START;
 end,
 [851]=function()
 JY.Status=GAME_START;
 end,
 [852]=function()
 JY.Status=GAME_START;
 end,
 [853]=function()
 JY.Status=GAME_START;
 end,
 [854]=function()
 JY.Status=GAME_START;
 end,
 [855]=function()
 JY.Status=GAME_START;
 end,
 [856]=function()
 JY.Status=GAME_START;
 end,
 [857]=function()
 JY.Status=GAME_START;
 end,
 [858]=function()
 JY.Status=GAME_START;
 end,
 [859]=function()
 JY.Status=GAME_START;
 end,
 [860]=function()
 JY.Status=GAME_START;
 end,
 [861]=function()
 JY.Status=GAME_START;
 end,
 [862]=function()
 JY.Status=GAME_START;
 end,
 [863]=function()
 JY.Status=GAME_START;
 end,
 [864]=function()
 JY.Status=GAME_START;
 end,
 [865]=function()
 JY.Status=GAME_START;
 end,
 [866]=function()
 JY.Status=GAME_START;
 end,
 [867]=function()
 JY.Status=GAME_START;
 end,
 [868]=function()
 JY.Status=GAME_START;
 end,
 [869]=function()
 JY.Status=GAME_START;
 end,
 [870]=function()
 JY.Status=GAME_START;
 end,
 [871]=function()
 JY.Status=GAME_START;
 end,
 [872]=function()
 JY.Status=GAME_START;
 end,
 [873]=function()
 JY.Status=GAME_START;
 end,
 [874]=function()
 JY.Status=GAME_START;
 end,
 [875]=function()
 JY.Status=GAME_START;
 end,
 [876]=function()
 JY.Status=GAME_START;
 end,
 [877]=function()
 JY.Status=GAME_START;
 end,
 [878]=function()
 JY.Status=GAME_START;
 end,
 [879]=function()
 JY.Status=GAME_START;
 end,
 [880]=function()
 JY.Status=GAME_START;
 end,
 [881]=function()
 JY.Status=GAME_START;
 end,
 [882]=function()
 JY.Status=GAME_START;
 end,
 [883]=function()
 JY.Status=GAME_START;
 end,
 [884]=function()
 JY.Status=GAME_START;
 end,
 [885]=function()
 JY.Status=GAME_START;
 end,
 [886]=function()
 JY.Status=GAME_START;
 end,
 [887]=function()
 JY.Status=GAME_START;
 end,
 [888]=function()
 JY.Status=GAME_START;
 end,
 [889]=function()
 JY.Status=GAME_START;
 end,
 [890]=function()
 JY.Status=GAME_START;
 end,
 [891]=function()
 JY.Status=GAME_START;
 end,
 [892]=function()
 JY.Status=GAME_START;
 end,
 [893]=function()
 JY.Status=GAME_START;
 end,
 [894]=function()
 JY.Status=GAME_START;
 end,
 [895]=function()
 JY.Status=GAME_START;
 end,
 [896]=function()
 JY.Status=GAME_START;
 end,
 [897]=function()
 JY.Status=GAME_START;
 end,
 [898]=function()
 JY.Status=GAME_START;
 end,
 [899]=function()
 JY.Status=GAME_START;
 end,
 [900]=function()
 JY.Status=GAME_START;
 end,
 [901]=function()
 JY.Status=GAME_START;
 end,
 [902]=function()
 JY.Status=GAME_START;
 end,
 [903]=function()
 JY.Status=GAME_START;
 end,
 [904]=function()
 JY.Status=GAME_START;
 end,
 [905]=function()
 JY.Status=GAME_START;
 end,
 [906]=function()
 JY.Status=GAME_START;
 end,
 [907]=function()
 JY.Status=GAME_START;
 end,
 [908]=function()
 JY.Status=GAME_START;
 end,
 [909]=function()
 JY.Status=GAME_START;
 end,
 [910]=function()
 JY.Status=GAME_START;
 end,
 [911]=function()
 JY.Status=GAME_START;
 end,
 [912]=function()
 JY.Status=GAME_START;
 end,
 [913]=function()
 JY.Status=GAME_START;
 end,
 [914]=function()
 JY.Status=GAME_START;
 end,
 [915]=function()
 JY.Status=GAME_START;
 end,
 [916]=function()
 JY.Status=GAME_START;
 end,
 [917]=function()
 JY.Status=GAME_START;
 end,
 [918]=function()
 JY.Status=GAME_START;
 end,
 [919]=function()
 JY.Status=GAME_START;
 end,
 [920]=function()
 JY.Status=GAME_START;
 end,
 [921]=function()
 JY.Status=GAME_START;
 end,
 [922]=function()
 JY.Status=GAME_START;
 end,
 [923]=function()
 JY.Status=GAME_START;
 end,
 [924]=function()
 JY.Status=GAME_START;
 end,
 [925]=function()
 JY.Status=GAME_START;
 end,
 [926]=function()
 JY.Status=GAME_START;
 end,
 [927]=function()
 JY.Status=GAME_START;
 end,
 [928]=function()
 JY.Status=GAME_START;
 end,
 [929]=function()
 JY.Status=GAME_START;
 end,
 [930]=function()
 JY.Status=GAME_START;
 end,
 [931]=function()
 JY.Status=GAME_START;
 end,
 [932]=function()
 JY.Status=GAME_START;
 end,
 [933]=function()
 JY.Status=GAME_START;
 end,
 [934]=function()
 JY.Status=GAME_START;
 end,
 [935]=function()
 JY.Status=GAME_START;
 end,
 [936]=function()
 JY.Status=GAME_START;
 end,
 [937]=function()
 JY.Status=GAME_START;
 end,
 [938]=function()
 JY.Status=GAME_START;
 end,
 [939]=function()
 JY.Status=GAME_START;
 end,
 [940]=function()
 JY.Status=GAME_START;
 end,
 [941]=function()
 JY.Status=GAME_START;
 end,
 [942]=function()
 JY.Status=GAME_START;
 end,
 [943]=function()
 JY.Status=GAME_START;
 end,
 [944]=function()
 JY.Status=GAME_START;
 end,
 [945]=function()
 JY.Status=GAME_START;
 end,
 [946]=function()
 JY.Status=GAME_START;
 end,
 [947]=function()
 JY.Status=GAME_START;
 end,
 [948]=function()
 JY.Status=GAME_START;
 end,
 [949]=function()
 JY.Status=GAME_START;
 end,
 [950]=function()
 JY.Status=GAME_START;
 end,
 [951]=function()
 JY.Status=GAME_START;
 end,
 [952]=function()
 JY.Status=GAME_START;
 end,
 [953]=function()
 JY.Status=GAME_START;
 end,
 [954]=function()
 JY.Status=GAME_START;
 end,
 [955]=function()
 JY.Status=GAME_START;
 end,
 [956]=function()
 JY.Status=GAME_START;
 end,
 [957]=function()
 JY.Status=GAME_START;
 end,
 [958]=function()
 JY.Status=GAME_START;
 end,
 [959]=function()
 JY.Status=GAME_START;
 end,
 [960]=function()
 JY.Status=GAME_START;
 end,
 [961]=function()
 JY.Status=GAME_START;
 end,
 [962]=function()
 JY.Status=GAME_START;
 end,
 [963]=function()
 JY.Status=GAME_START;
 end,
 [964]=function()
 JY.Status=GAME_START;
 end,
 [965]=function()
 JY.Status=GAME_START;
 end,
 [966]=function()
 JY.Status=GAME_START;
 end,
 [967]=function()
 JY.Status=GAME_START;
 end,
 [968]=function()
 JY.Status=GAME_START;
 end,
 [969]=function()
 JY.Status=GAME_START;
 end,
 [970]=function()
 JY.Status=GAME_START;
 end,
 [971]=function()
 JY.Status=GAME_START;
 end,
 [972]=function()
 JY.Status=GAME_START;
 end,
 [973]=function()
 JY.Status=GAME_START;
 end,
 [974]=function()
 JY.Status=GAME_START;
 end,
 [975]=function()
 JY.Status=GAME_START;
 end,
 [976]=function()
 JY.Status=GAME_START;
 end,
 [977]=function()
 JY.Status=GAME_START;
 end,
 [978]=function()
 JY.Status=GAME_START;
 end,
 [979]=function()
 JY.Status=GAME_START;
 end,
 [980]=function()
 JY.Status=GAME_START;
 end,
 [981]=function()
 JY.Status=GAME_START;
 end,
 [982]=function()
 JY.Status=GAME_START;
 end,
 [983]=function()
 JY.Status=GAME_START;
 end,
 [984]=function()
 JY.Status=GAME_START;
 end,
 [985]=function()
 JY.Status=GAME_START;
 end,
 [986]=function()
 JY.Status=GAME_START;
 end,
 [987]=function()
 JY.Status=GAME_START;
 end,
 [988]=function()
 JY.Status=GAME_START;
 end,
 [989]=function()
 JY.Status=GAME_START;
 end,
 [990]=function()
 JY.Status=GAME_START;
 end,
 [991]=function()
 JY.Status=GAME_START;
 end,
 [992]=function()
 JY.Status=GAME_START;
 end,
 [993]=function()
 JY.Status=GAME_START;
 end,
 [994]=function()
 JY.Status=GAME_START;
 end,
 [995]=function()
 JY.Status=GAME_START;
 end,
 [996]=function()
 JY.Status=GAME_START;
 end,
 [997]=function()
 JY.Status=GAME_START;
 end,
 [998]=function()
 JY.Status=GAME_START;
 end,
 [999]=function()
 JY.Status=GAME_START;
 end,
 [1000]=function()
 JY.Status=GAME_START;
 end,
 [1001]=function()
 JY.Status=GAME_START;
 end,
 [1002]=function()
 JY.Status=GAME_START;
 end,
 [1003]=function()
 JY.Status=GAME_START;
 end,
 [1004]=function()
 JY.Status=GAME_START;
 end,
 [1005]=function()
 JY.Status=GAME_START;
 end,
 [1006]=function()
 JY.Status=GAME_START;
 end,
 [1007]=function()
 JY.Status=GAME_START;
 end,
 [1008]=function()
 JY.Status=GAME_START;
 end,
 [1009]=function()
 JY.Status=GAME_START;
 end,
 [1010]=function()
 JY.Status=GAME_START;
 end,
 [1011]=function()
 JY.Status=GAME_START;
 end,
 [1012]=function()
 JY.Status=GAME_START;
 end,
 [1013]=function()
 JY.Status=GAME_START;
 end,
 [1014]=function()
 JY.Status=GAME_START;
 end,
 [1015]=function()
 JY.Status=GAME_START;
 end,
 [1016]=function()
 JY.Status=GAME_START;
 end,
 [1017]=function()
 JY.Status=GAME_START;
 end,
 [1018]=function()
 JY.Status=GAME_START;
 end,
 [1019]=function()
 JY.Status=GAME_START;
 end,
 [1020]=function()
 JY.Status=GAME_START;
 end,
 [1021]=function()
 JY.Status=GAME_START;
 end,
 [1022]=function()
 JY.Status=GAME_START;
 end,
 [1023]=function()
 JY.Status=GAME_START;
 end,
 [1024]=function()
 JY.Status=GAME_START;
 end,
 [1025]=function()
 JY.Status=GAME_START;
 end,
 [1026]=function()
 JY.Status=GAME_START;
 end,
 [1027]=function()
 JY.Status=GAME_START;
 end,
 [1028]=function()
 JY.Status=GAME_START;
 end,
 [1029]=function()
 JY.Status=GAME_START;
 end,
 [1030]=function()
 JY.Status=GAME_START;
 end,
 [1031]=function()
 JY.Status=GAME_START;
 end,
 [1032]=function()
 JY.Status=GAME_START;
 end,
 [1033]=function()
 JY.Status=GAME_START;
 end,
 [1034]=function()
 JY.Status=GAME_START;
 end,
 [1035]=function()
 JY.Status=GAME_START;
 end,
 [1036]=function()
 JY.Status=GAME_START;
 end,
 [1037]=function()
 JY.Status=GAME_START;
 end,
 [1038]=function()
 JY.Status=GAME_START;
 end,
 [1039]=function()
 JY.Status=GAME_START;
 end,
 [1040]=function()
 JY.Status=GAME_START;
 end,
 [1041]=function()
 JY.Status=GAME_START;
 end,
 [1042]=function()
 JY.Status=GAME_START;
 end,
 [1043]=function()
 JY.Status=GAME_START;
 end,
 [1044]=function()
 JY.Status=GAME_START;
 end,
 [1045]=function()
 JY.Status=GAME_START;
 end,
 [1046]=function()
 JY.Status=GAME_START;
 end,
 [1047]=function()
 JY.Status=GAME_START;
 end,
 [1048]=function()
 JY.Status=GAME_START;
 end,
 [1049]=function()
 JY.Status=GAME_START;
 end,
 [1050]=function()
 JY.Status=GAME_START;
 end,
 [1051]=function()
 JY.Status=GAME_START;
 end,
 [1052]=function()
 JY.Status=GAME_START;
 end,
 [1053]=function()
 JY.Status=GAME_START;
 end,
 [1054]=function()
 JY.Status=GAME_START;
 end,
 [1055]=function()
 JY.Status=GAME_START;
 end,
 [1056]=function()
 JY.Status=GAME_START;
 end,
 [1057]=function()
 JY.Status=GAME_START;
 end,
 [1058]=function()
 JY.Status=GAME_START;
 end,
 [1059]=function()
 JY.Status=GAME_START;
 end,
 [1060]=function()
 JY.Status=GAME_START;
 end,
 [1061]=function()
 JY.Status=GAME_START;
 end,
 [1062]=function()
 JY.Status=GAME_START;
 end,
 [1063]=function()
 JY.Status=GAME_START;
 end,
 [1064]=function()
 JY.Status=GAME_START;
 end,
 [1065]=function()
 JY.Status=GAME_START;
 end,
 [1066]=function()
 JY.Status=GAME_START;
 end,
 [1067]=function()
 JY.Status=GAME_START;
 end,
 [1068]=function()
 JY.Status=GAME_START;
 end,
 [1069]=function()
 JY.Status=GAME_START;
 end,
 [1070]=function()
 JY.Status=GAME_START;
 end,
 [1071]=function()
 JY.Status=GAME_START;
 end,
 [1072]=function()
 JY.Status=GAME_START;
 end,
 [1073]=function()
 JY.Status=GAME_START;
 end,
 [1074]=function()
 JY.Status=GAME_START;
 end,
 [1075]=function()
 JY.Status=GAME_START;
 end,
 [1076]=function()
 JY.Status=GAME_START;
 end,
 [1077]=function()
 JY.Status=GAME_START;
 end,
 [1078]=function()
 JY.Status=GAME_START;
 end,
 [1079]=function()
 JY.Status=GAME_START;
 end,
 [1080]=function()
 JY.Status=GAME_START;
 end,
 [1081]=function()
 JY.Status=GAME_START;
 end,
 [1082]=function()
 JY.Status=GAME_START;
 end,
 [1083]=function()
 JY.Status=GAME_START;
 end,
 [1084]=function()
 JY.Status=GAME_START;
 end,
 [1085]=function()
 JY.Status=GAME_START;
 end,
 [1086]=function()
 JY.Status=GAME_START;
 end,
 [1087]=function()
 JY.Status=GAME_START;
 end,
 [1088]=function()
 JY.Status=GAME_START;
 end,
 [1089]=function()
 JY.Status=GAME_START;
 end,
 [1090]=function()
 JY.Status=GAME_START;
 end,
 [1091]=function()
 JY.Status=GAME_START;
 end,
 [1092]=function()
 JY.Status=GAME_START;
 end,
 [1093]=function()
 JY.Status=GAME_START;
 end,
 [1094]=function()
 JY.Status=GAME_START;
 end,
 [1095]=function()
 JY.Status=GAME_START;
 end,
 [1096]=function()
 JY.Status=GAME_START;
 end,
 [1097]=function()
 JY.Status=GAME_START;
 end,
 [1098]=function()
 JY.Status=GAME_START;
 end,
 [1099]=function()
 JY.Status=GAME_START;
 end,
 
 
 
 [9999]=function()
 JY.Status=GAME_START;
 end,
 };
 
