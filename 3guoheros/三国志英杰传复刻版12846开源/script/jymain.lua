function JY_Main()--主程序入口
os.remove("debug.txt")--清除以前的debug输出
xpcall(JY_Main_sub,myErrFun)--捕获调用错误
end

function JY_Main_sub()--真正的游戏主程序入口
dofile(CONFIG.ScriptPath .. "jyconfig.lua") --加载游戏设置文件
dofile(CONFIG.ScriptPath .. "kdef.lua") --加载游戏事件
SetGlobalConst()
SetGlobal()
--禁止访问全程变量
setmetatable(_G,{ __newindex=function (_,n)
error("attempt read write to undeclared variable " .. n,2)
end,
__index=function (_,n)
error("attempt read read to undeclared variable " .. n,2)
end,
} )
lib.Debug("JY_Main start.")
math.randomseed(tostring(os.time()):reverse():sub(1, 6))--初始化随机数发生器
lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRePeatInterval)--设置键盘重复率
lib.GetKey()
YJZMain()
end

--获得我方所有部队的平均等级
function pjlv()
local lv_t={}
local cz=0
for i=1,JY.PersonNum-1 do
if JY.Person[i]["君主"]==1 then
table.insert(lv_t,JY.Person[i]["等级"])
cz=cz+1
end
end
table.sort(lv_t,function(a,b)return b<a end)
for ii=1,cz do
table.insert(lv_t,1)
end
local lv=0
for ii=1,cz do
lv=lv+lv_t[ii]
end
lv=math.modf(lv/cz)--得到我方所有部队的平均等级
return lv
end

function myErrFun(err)--错误处理，打印错误信息
lib.Debug(err)--输出错误信息
lib.Debug(debug.traceback())--输出调用堆栈信息
end

function SetGlobal()--设置游戏内部使用的全程变量
JY={}
JY.Status=GAME_START--游戏当前状态
--保存R×数据
JY.Base={}--基本数据
JY.PersonNum=0--人物个数
JY.Person={}--人物数据
JY.BingzhongNum=0--人物个数
JY.Bingzhong={}--人物数据
JY.SceneNum=0--场景个数
JY.Scene={}--场景数据
JY.ItemNum=0--道具个数
JY.Item={}--道具数据
JY.MagicNum=0--策略个数
JY.Magic={}--策略数据
JY.SkillNum=0--特技个数
JY.Skill={}--特技数据
JY.SubScene=-1--当前子场景编号
JY.SubSceneX=0--子场景显示位置偏移，场景移动指令使用
JY.SubSceneY=0
JY.Darkness=0--=0 屏幕正常显示，=1 不显示，屏幕全黑
JY.MmapMusic=-1--切换大地图音乐，返回主地图时，如果设置，则播放此音乐
JY.CurrentBGM=-1--当前播放的音乐id，用来在关闭音乐时保存音乐id．
JY.EnableMusic=1--是否播放音乐 1 播放，0 不播放
JY.EnableSound=1--是否播放音效 1 播放，0 不播放
JY.LLK_N=0
JY.Dark=true
JY.Smap={}
JY.Tid=0--SMAP时，当前选择的人物 或 正在说话的人物
JY.EventID=1
JY.LoadedPic=0
JY.MenuPic={
num=0,
pic={},
x={},
y={},
}
JY.Death=0--用于战场事件-"当消灭XX时触发"
JY.ReFreshTime=0
War={}
War.Person={}
TeamSelect={}--用于储存战斗前人物选择
end

function CleanMemory()--清理lua内存
if CONFIG.CleanMemory==1 then
collectgarbage("collect")
end
end

--连连看关卡设置
function Game_Cycle()
for i=JY.Base["事件333"]+1,9999,1 do
PlayBGM(math.random(19))
local llk=lianliankan(i+9)

if llk then
if i>JY.Base["事件333"] and i<=30 then
JY.Base["事件333"]=i
end
else
return
end
end
end

--连连看游戏
function lianliankan(level)
local B={}
local num
local headbox={}
local X_Num,Y_Num
local pic_w,pic_h
local x_off,y_off
local limit,start_time,now_time
local mid_point={
x={},
y={},
}
local select_a={
x=0,
y=0,
}
local select_b={
x=0,
y=0,
}
lib.SetClip(0,0,0,0)
lib.FillColor(0,0,0,0,0)
lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],0)
pic_w,pic_h=lib.PicGetXY(0,0*2)
X_Num=math.modf(CC.ScreenW/pic_w)
Y_Num=math.modf(CC.ScreenH*15/16/pic_h)
if X_Num~=math.modf(X_Num/2)*2 and Y_Num~=math.modf(Y_Num/2)*2 then
if CC.ScreenW-pic_w*X_Num<CC.ScreenH*15/16-pic_h*Y_Num then
X_Num=X_Num-1
else
Y_Num=Y_Num-1
end
end
if X_Num<6 or Y_Num<4 then
WarDrawStrBoxConfirm("屏幕分辨率设置过小！",M_White,true)
return false
end
num=X_Num*Y_Num/2
limit=X_Num*Y_Num*(10+level)*100+5000
local function sample(st,rp)
--随机抽样，rp 是否放回
local n=#st
local r=-1
if n>1 then
n=math.random(n)
end
r=st[n]
if not rp then
table.remove(st,n)
end
return r
end
local t_head={}
for i=1,228 do
--图片池
table.insert(t_head,i)
end
for i=1,math.min(level,50) do
headbox[i]=sample(t_head)--决定本次使用的头像
end
t_head={}
for i=1,Y_Num*X_Num/2 do
local picid=sample(headbox,true)
table.insert(t_head,picid)
table.insert(t_head,picid)
end
X_Num=X_Num+2
Y_Num=Y_Num+2
for i=1,Y_Num do
B[i]={}
for j=1,X_Num do
if between(i,2,Y_Num-1) and between(j,2,X_Num-1) then
B[i][j]=sample(t_head)
else
B[i][j]=-1
end
end
end
x_off=math.modf((CC.ScreenW-pic_w*X_Num)/2)
y_off=math.modf(CC.ScreenH/16+(CC.ScreenH*15/16-pic_h*Y_Num)/2)
local function SHOW()
for y=1,Y_Num do
for x=1,X_Num do
if B[y][x]>-1 then
lib.PicLoadCache(0,B[y][x]*2,pic_w*(x-1)+x_off,pic_h*(y-1)+y_off,1)
end
end
end
if select_a.x~=0 and select_a.y~=0 then
DrawBox(pic_w*(select_a.x-1)+x_off,pic_h*(select_a.y-1)+y_off,pic_w*select_a.x+x_off,pic_h*select_a.y+y_off,M_White)
end
if select_b.x~=0 and select_b.y~=0 then
DrawBox(pic_w*(select_b.x-1)+x_off,pic_h*(select_b.y-1)+y_off,pic_w*select_b.x+x_off,pic_h*select_b.y+y_off,M_White)
end
end
local function DrawTime()
now_time=lib.GetTime()
lib.FillColor(0,0,CC.ScreenW,CC.ScreenH/16,RGB(192,192,192))
DrawString(0,0,string.format("Level:%d",level-9),M_Black,16)
DrawBox(160,3,CC.ScreenW-4,CC.ScreenH/16-5,M_White)
DrawBox(160,3,160+(CC.ScreenW-164)*(start_time+limit-now_time)/limit,CC.ScreenH/16-5,M_White)
end
local function Delay(t)
for i=1,t,10 do
DrawTime()
lib.ShowSurface(0)
lib.Delay(10)
end
end
local function FIND()
local len_min=(X_Num+Y_Num)*2
for x=1,X_Num do
local flag=true
local step
if select_b.y>select_a.y then
step=1
elseif select_b.y==select_a.y then
step=0
else
step=-1
end
if step~=0 then
for y=select_a.y+step,select_b.y-step,step do
if B[y][x]~=-1 then
flag=false
break
end
end
end
if flag then
if select_a.x>x then
step=1
elseif select_a.x==x then
step=0
else
step=-1
end
if step~=0 and x~=select_a.x then
for xx=x,select_a.x-step,step do
if B[select_a.y][xx]~=-1 then
flag=false
break
end
end
end
if flag then
if select_b.x>x then
step=1
elseif select_b.x==x then
step=0
else
step=-1
end
if step~=0 and x~=select_b.x then
for xx=x,select_b.x-step,step do
if B[select_b.y][xx]~=-1 then
flag=false
break
end
end
end
if flag then
local len=math.abs(x-select_a.x)+math.abs(x-select_b.x)+math.abs(select_a.y-select_a.y)
if len<len_min then
len_min=len
mid_point.x[1]=select_a.x
mid_point.y[1]=select_a.y
mid_point.x[2]=x
mid_point.y[2]=select_a.y
mid_point.x[3]=x
mid_point.y[3]=select_b.y
mid_point.x[4]=select_b.x
mid_point.y[4]=select_b.y
end
end
end
end
end
for y=1,Y_Num do
local flag=true
local step
if select_b.x>select_a.x then
step=1
elseif select_b.x==select_a.x then
step=0
else
step=-1
end
if step~=0 then
for x=select_a.x+step,select_b.x-step,step do
if B[y][x]~=-1 then
flag=false
break
end
end
end
if flag then
if select_a.y>y then
step=1
elseif select_a.y==y then
step=0
else
step=-1
end
if step~=0 and y~=select_a.y then
for yy=y,select_a.y-step,step do
if B[yy][select_a.x]~=-1 then
flag=false
break
end
end
end
if flag then
if select_b.y>y then
step=1
elseif select_b.y==y then
step=0
else
step=-1
end
if step~=0 and y~=select_b.y then
for yy=y,select_b.y-step,step do
if B[yy][select_b.x]~=-1 then
flag=false
break
end
end
end
if flag then
local len=math.abs(y-select_a.y)+math.abs(y-select_b.y)+math.abs(select_a.x-select_a.x)
if len<len_min then
len_min=len
mid_point.x[1]=select_a.x
mid_point.y[1]=select_a.y
mid_point.x[2]=select_a.x
mid_point.y[2]=y
mid_point.x[3]=select_b.x
mid_point.y[3]=y
mid_point.x[4]=select_b.x
mid_point.y[4]=select_b.y
end
end
end
end
end
if len_min<(X_Num+Y_Num)*2 then
return true
else
return false
end
end
lib.FillColor(0,0,0,0,0)
start_time=lib.GetTime()
now_time=start_time
SHOW()
lib.ShowSurface(0)
lib.Delay(20)
while num>0 do
if (now_time-start_time)>limit then
WarDrawStrBoxConfirm("失败，游戏即将结束．",M_White,true)
PicCatchIni()
return false
end
local eventtype,keypress,x,y=lib.GetKey(1)
if eventtype==3 and keypress==3 then
PlayWavE(1)
if WarDrawStrBoxYesNo('结束游戏吗？',M_White,true) then
PicCatchIni()
return false
end
end
if eventtype==3 then
local X=1+math.modf((x-x_off)/pic_w)
local Y=1+math.modf((y-y_off)/pic_h)
if x-x_off>=0 and y-y_off>=0 and X>=1 and X<=X_Num and Y>=1 and Y<=Y_Num and B[Y][X]~=-1 then
if (select_a.x==0 or select_a.y==0) then
select_a.x=X
select_a.y=Y
PlayWavE(0)
elseif select_a.x==X and select_a.y==Y then
select_a.x=0
select_a.x=0
PlayWavE(1)
else
if (select_b.x==0 or select_b.y==0) then
select_b.x=X
select_b.y=Y
PlayWavE(0)
elseif select_b.x==X and select_b.y==Y then
select_b.x=0
select_b.x=0
PlayWavE(1)
else
WarDrawStrBoxConfirm("发生异常，游戏即将结束！",M_White,true)
PicCatchIni()
return false
end
end
end
if select_a.x~=0 and select_a.y~=0 and select_b.x~=0 and select_b.y~=0 then
lib.FillColor(0,0,0,0,0)
SHOW()
Delay(50)
if B[select_a.y][select_a.x]==B[select_b.y][select_b.x] and FIND(1,select_a.x,select_a.y,-1) then
B[select_a.y][select_a.x]=-1
B[select_b.y][select_b.x]=-1
num=num-1
for t=1,3 do
if mid_point.x[t]~=mid_point.x[t+1] or mid_point.y[t]~=mid_point.y[t+1] then
DrawBox(pic_w*mid_point.x[t]+x_off-pic_w/2,pic_h*mid_point.y[t]+y_off-pic_h/2,
pic_w*mid_point.x[t+1]+x_off-pic_w/2,pic_h*mid_point.y[t+1]+y_off-pic_h/2,M_White)
end
end
PlayWavE(11)
Delay(250)
else
PlayWavE(3)
Delay(400)
end
select_a.x=0
select_a.y=0
select_b.x=0
select_b.y=0
end
lib.FillColor(0,0,0,0,0)
SHOW()
Delay(10)
end
Delay(10)
end
WarDrawStrBoxConfirm(string.format("恭喜！进入第%d关",level-8),M_White,true)
GetMoney(100)--每过一关 获得100金
lib.ShowSurface(0)
lib.Delay(500)
return true
end

--绘制一个带背景的白色方框，四角凹进
function DrawBox(x1,y1,x2,y2,color)--绘制一个带背景的白色方框
local s=4
lib.Background(x1+4,y1,x2-4,y1+s,128)
lib.Background(x1+1,y1+1,x1+s,y1+s,128)
lib.Background(x2-s,y1+1,x2-1,y1+s,128)
lib.Background(x1,y1+4,x2,y2-4,128)
lib.Background(x1+1,y2-s,x1+s,y2-1,128)
lib.Background(x2-s,y2-s+1,x2-1,y2,128)
lib.Background(x1+4,y2-s,x2-4,y2,128)
local r,g,b=GetRGB(color)
local color2=RGB(math.modf(r/2),math.modf(g/2),math.modf(b/2))
DrawBox_1(x1-1,y1-1,x2-1,y2-1,color2)
DrawBox_1(x1+1,y1-1,x2+1,y2-1,color2)
DrawBox_1(x1-1,y1+1,x2-1,y2+1,color2)
DrawBox_1(x1+1,y1+1,x2+1,y2+1,color2)
DrawBox_1(x1,y1,x2,y2,color)
end

--绘制四角凹进的方框
function DrawBox_1(x1,y1,x2,y2,color)--绘制四角凹进的方框
local s=4
lib.DrawRect(x1+s,y1,x2-s,y1,color)
lib.DrawRect(x1+s,y2,x2-s,y2,color)
lib.DrawRect(x1,y1+s,x1,y2-s,color)
lib.DrawRect(x2,y1+s,x2,y2-s,color)
lib.DrawRect(x1+2,y1+1,x1+s-1,y1+1,color)
lib.DrawRect(x1+1,y1+2,x1+1,y1+s-1,color)
lib.DrawRect(x2-s+1,y1+1,x2-2,y1+1,color)
lib.DrawRect(x2-1,y1+2,x2-1,y1+s-1,color)
lib.DrawRect(x1+2,y2-1,x1+s-1,y2-1,color)
lib.DrawRect(x1+1,y2-s+1,x1+1,y2-2,color)
lib.DrawRect(x2-s+1,y2-1,x2-2,y2-1,color)
lib.DrawRect(x2-1,y2-s+1,x2-1,y2-2,color)
end

--绘制一个带背景的白色方框，四角凹进
function DrawBox(x1,y1,x2,y2,color,bjcolor)--绘制一个带背景的白色方框
local s=4
bjcolor=bjcolor or 0
if bjcolor>=0 then
lib.Background(x1,y1+s,x1+s,y2-s,128,bjcolor)--阴影，四角空出
lib.Background(x1+s,y1,x2-s,y2,128,bjcolor)
lib.Background(x2-s,y1+s,x2,y2-s,128,bjcolor)
end
if color>=0 then
local r,g,b=GetRGB(color)
DrawBox_1(x1+1,y1,x2,y2,RGB(math.modf(r/2),math.modf(g/2),math.modf(b/2)))
DrawBox_1(x1,y1,x2-1,y2-1,color)
end
end

--修改后的drawbox，边框加粗
function DrawGameBox(x1,y1,x2,y2)
lib.PicLoadCache(4,260*2,x1,y1,1)
end

function WarFillColor(x1,y1,x2,y2,clarity,color,size)
color=color or M_Red
clarity=clarity or 128
size=size or 8
local flag1=true
fory=y1,y2-1,size do
local flag2=flag1
forx=x1,x2-1,size do
if flag2 then
lib.Background(x,y,x+size,y+size,clarity,color)
end
flag2=not flag2
end
flag1=not flag1
end
end

--显示阴影字符串
function DrawString(x,y,str,color,size)--显示阴影字符串
if CC.FontType==0 then
lib.DrawStr(x,y,str,color,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1)
elseif CC.FontType==1 then
lib.DrawStr(x,y,str,color,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet)
end
end

function DrawString2(x,y,str,color,size)--显示阴影字符串
lib.DrawStr(x-2,y,str,M_Black,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1)
lib.DrawStr(x+1,y,str,M_Black,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1)
DrawString(x,y,str,color,size)
end

--显示带框的字符串
--(x,y) 坐标，如果都为-1,则在屏幕中间显示
function DrawStrBox(x,y,str,color,size)--显示带框的字符串
local ll=#str
local w=size*ll/2+2*CC.MenuBorderPixel
local h=size+2*CC.MenuBorderPixel
if x==-1 then
x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2
end
if y==-1 then
y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2
end
DrawBox(x,y,x+w-1,y+h-1,M_White)
DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel,str,color,size)
end

function DrawStrBox(x,y,str,color,size,bjcolor)--显示带框的字符串
local strarray={}
local num,maxlen
maxlen=0
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
local w=size*maxlen/2+2*CC.MenuBorderPixel
local h=2*CC.MenuBorderPixel+size*num
if x==-1 then
x=(CC.ScreenW-size/2*maxlen-2*CC.MenuBorderPixel)/2
end
if y==-1 then
y=(CC.ScreenH-size*num-2*CC.MenuBorderPixel)/2
end
if x<0 then
x=CC.ScreenW-size/2*maxlen-2*CC.MenuBorderPixel+x
end
if y<0 then
y=CC.ScreenH-size*num-2*CC.MenuBorderPixel+y
end
DrawBox(x,y,x+w-1,y+h-1,M_White,bjcolor)
for i=1,num do
DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel+size*(i-1),strarray[i],color,size)
end
end

function DrawStr(x,y,str,color,size)--显示字符串,会分行
local strarray={}
local num,maxlen
maxlen=0
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
for i=1,num do
DrawString(x,y+size*(i-1),strarray[i],color,size)
end
end

--分割字符串
function Split(szFullString,szSeparator)
local nFindStartIndex=1
local nSplitIndex=1
local nSplitArray={}
while true do
local nFindLastIndex=string.find(szFullString, szSeparator, nFindStartIndex)
if not nFindLastIndex then
nSplitArray[nSplitIndex]=string.sub(szFullString, nFindStartIndex, string.len(szFullString))
break
end
nSplitArray[nSplitIndex]=string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
nFindStartIndex=nFindLastIndex + string.len(szSeparator)
nSplitIndex=nSplitIndex + 1
end
return nSplitIndex,nSplitArray
end

--显示并询问Y/N，如果点击Y，则返回true, N则返回false
--(x,y) 坐标，如果都为-1,则在屏幕中间显示
--改为用菜单询问是否
function DrawStrBoxYesNo(x,y,str,color,size)--显示字符串并询问Y/N
lib.GetKey()
local ll=#str
local w=size*ll/2+2*CC.MenuBorderPixel
local h=size+2*CC.MenuBorderPixel
if x==-1 then
x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2
end
if y==-1 then
y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2
end
DrawStrBox(x,y,str,color,size)
local menu={{"确定/是",nil,1},
{"取消/否",nil,2}}
local r=ShowMenu(menu,2,0,x+w-4*size-2*CC.MenuBorderPixel,y+h+CC.MenuBorderPixel,0,0,1,0,size*0.8,M_Orange, M_White)
if r==1 then
return true
else
return false
end
end

function WarShowTarget(firstShow)--显示任务目标
-- notWar true notwar, false in war
lib.GetKey()
local x,y
local w,h=320,192
local size=16
x=16+576/2
y=32+432/2
x=x-w/2
y=y-h/2
local x1=x+254
local x2=x1+52
local y1=y+148
local y2=y1+24
local str=""
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
"２００",}
if firstShow then
PlayWavE(0)
str="限制回数"..T[War.MaxTurn]
else
str="现在回数　"..T[War.Turn].."／"..T[War.MaxTurn]
end
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
lib.PicLoadCache(4,81*2,x,y,1)
DrawString(x+16,y+16,War.WarName,M_White,size)
DrawString(x+240,y+16,"胜利条件",M_White,size)
DrawStr(x+32,y+56,War.WarTarget,M_White,size)
DrawStr(x+24,y+152,str,M_White,size)
if flag==1 then
lib.PicLoadCache(4,56*2,x1,y1,1)
end
ReFresh()
end
local current=0
while true do
redraw(current)
getkey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=1
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
WarDelay(4)
return
else
current=0
end
end
end

function DrawItemStatus(id,pid)--显示物品属性
local str=JY.Item[id]["说明"]
if CC.Enhancement then
if id==JY.Person[pid]["武器"] and JY.Person[pid]["姓名"]==JY.Item[id]["专属特技人"] then
str=str.."*特效："..JY.Skill[JY.Item[id]["专属特技"]]["说明"]
elseif id==JY.Person[pid]["武器"] and JY.Item[id]["特技"]>0 then
str=str.."*特效："..JY.Skill[JY.Item[id]["特技"]]["说明"]
end
end
DrawStrStatus(JY.Item[id]["名称"],str)
end

function DrawSkillStatus(id)--显示技能属性
 DrawStrStatus(JY.Skill[id]["名称"],JY.Skill[id]["说明"])
end

function DrawBingZhongStatus(id)--显示兵种属性
 DrawStrStatus(JY.Bingzhong[id]["名称"],JY.Bingzhong[id]["说明"])
end

function DrawLieZhuan(name)--显示列传
 DrawStrStatus("三国英杰列传 - "..name,CC.LieZhuan[name])
end

function DrawStrStatus(str1,str2)--显示属性
lib.GetKey()
local x,y
local w,h=320,128
local size=16
local notWar=true
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=16+(576-0)/2
y=32+(432-0)/2
notWar=false
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-0)/2
y=16+(400-0)/2
notWar=true
else
x=(CC.ScreenW-0)/2
y=(CC.ScreenH-0)/2
notWar=true
end
x=x-w/2
y=y-h/2
local x1=x+254
local x2=x1+52
local y1=y+92
local y2=y1+24
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
if not notWar then
DrawWarMap()
end
lib.PicLoadCache(4,80*2,x,y,1)
DrawString(x+16,y+10,str1,C_Name,size)--oldy=16
DrawStr(x+16,y+28,GenTalkString(str2,18),M_White,size)--oldy=36
if flag==1 then
lib.PicLoadCache(4,56*2,x1,y1,1)
end
if notWar then
ShowScreen()
else
ReFresh()
end
end
local current=0
PlayWavE(0)
while true do
redraw(current)
getkey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=1
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
if notWar then
lib.Delay(100)
else
WarDelay(4)
end
return
else
current=0
end
end
end

function WarDrawStrBoxConfirm(str,color,notWar)--显示字符串并询问Y/N
lib.GetKey()
local x,y
local size=16
local strarray={}
local num,maxlen
maxlen=0
str=str.."* "
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
local w=size*maxlen/2+2*CC.MenuBorderPixel
local h=2*CC.MenuBorderPixel+size*num+6*(num-1)
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=16+(576-0)/2
y=32+(432-0)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-0)/2
y=16+(400-0)/2
else
x=(CC.ScreenW-0)/2
y=(CC.ScreenH-0)/2
end
local x4=x+w/2
local x3=x4-52
local x2=x4-56
local x1=x3-56
local y2=y+h/2
local y1=y2-24
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
if not notWar then
DrawWarMap()
end
if notWar then
DrawYJZBox(-1,-1,str,color,notWar)
else
DrawYJZBox(-1,-1,str,color)
end
if flag==2 then
lib.PicLoadCache(4,56*2,x3,y1,1)
else
lib.PicLoadCache(4,55*2,x3,y1,1)
end
if notWar then
ShowScreen()
else
ReFresh()
end
end
local current=0
while true do
redraw(current)
getkey()
if MOUSE.HOLD(x3+1,y1+1,x4-1,y2-1) then
current=2
elseif MOUSE.CLICK(x3+1,y1+1,x4-1,y2-1) then
 current=0
PlayWavE(0)
redraw(current)
if notWar then
lib.Delay(100)
else
WarDelay(4)
end
return false
else
current=0
end
end
end

function WarDrawStrBoxYesNo(str,color,notWar)--显示字符串并询问Y/N
lib.GetKey()
local x,y
local size=16
local strarray={}
local num,maxlen
maxlen=0
str=str.."* "
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
local w=size*maxlen/2+2*CC.MenuBorderPixel
local h=2*CC.MenuBorderPixel+size*num+6*(num-1)
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=16+(576)/2
y=32+(432)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640)/2
y=16+(400)/2
else
x=(CC.ScreenW)/2
y=(CC.ScreenH)/2
end
local x4=x+w/2
local x3=x4-52
local x2=x4-56
local x1=x3-56
local y2=y+h/2
local y1=y2-24
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
if not notWar then
DrawWarMap()
end
if notWar then
DrawYJZBox(-1,-1,str,color,notWar)
else
DrawYJZBox(-1,-1,str,color)
end
if flag==1 then
lib.PicLoadCache(4,52*2,x1,y1,1)
else
lib.PicLoadCache(4,51*2,x1,y1,1)
end
if flag==2 then
lib.PicLoadCache(4,54*2,x3,y1,1)
else
lib.PicLoadCache(4,53*2,x3,y1,1)
end
if notWar then
ShowScreen()
else
ReFresh()
end
end
local current=0
while true do
redraw(current)
getkey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=1
elseif MOUSE.HOLD(x3+1,y1+1,x4-1,y2-1) then
current=2
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
if notWar then
lib.Delay(100)
else
WarDelay(4)
end
return true
elseif MOUSE.CLICK(x3+1,y1+1,x4-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
if notWar then
lib.Delay(100)
else
WarDelay(4)
end
return false
else
current=0
end
end
end

function DrawStrBoxWaitKey(s,color)--显示字符串并等待击键
lib.GetKey()
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
DrawYJZBox(-1,-1,s,color,true)
ShowScreen()
 WaitKey()
lib.LoadSur(sid,0,0)
lib.FreeSur(sid)
ShowScreen()
end

function WarDrawStrBoxWaitKey(s,color,x,y)--显示字符串并等待击键 适用于战斗，画面保持刷新
x=x or -1
y=y or -1
lib.GetKey()
while true do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox(x,y,s,color)
local eventtype,keypress,x,y=lib.GetMouse(1)
ReFresh()
if eventtype==1 or eventtype==3 then
break
end
end
end

function WarDrawStrBoxDelay(s,color,x,y,n)--显示字符串并等待击键 适用于战斗，画面保持刷新
x=x or -1
y=y or -1
n=n or 36
lib.GetKey()
for i=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox(x,y,s,color)
local eventtype,keypress,x,y=lib.GetMouse(1)
ReFresh()
if eventtype==1 or eventtype==3 then
break
end
end
end

function DrawYJZBox(x,y,str,color,notWar)--显示带框的字符串
notWar=notWar or false
local size=16
local strarray={}
local num,maxlen
maxlen=0
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
local w=size*maxlen/2+2*CC.MenuBorderPixel
local h=2*CC.MenuBorderPixel+size*num+6*(num-1)
if x==-1 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=16+(576-w)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-w)/2
else
x=(CC.ScreenW-w)/2
end
end
if y==-1 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
y=32+(432-h)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
y=16+(400-h)/2
else
y=(CC.ScreenH-h)/2
end
end
if x<0 then
x=CC.ScreenW-size/2*maxlen-2*CC.MenuBorderPixel+x
end
if y<0 then
y=CC.ScreenH-size*num-2*CC.MenuBorderPixel+y
end
local boxw,boxh
boxw=16*math.modf(w/16)+16+14
boxh=16*math.modf(h/16)+16+14
local boxx=x-(boxw-w)/2
local boxy=y-(boxh-h)/2
--382x126
--Left Top
lib.SetClip(boxx,boxy,boxx+boxw/2,boxy+boxh/2)
lib.PicLoadCache(4,50*2,boxx,boxy,1)
lib.SetClip(0,0,0,0)
--Left Bot
lib.SetClip(boxx,boxy+boxh/2,boxx+boxw/2,boxy+boxh)
lib.PicLoadCache(4,50*2,boxx,boxy+boxh-126,1)
lib.SetClip(0,0,0,0)
--Right Top
lib.SetClip(boxx+boxw/2,boxy,boxx+boxw,boxy+boxh/2)
lib.PicLoadCache(4,50*2,boxx+boxw-382,boxy,1)
lib.SetClip(0,0,0,0)
--Right Bot
lib.SetClip(boxx+boxw/2,boxy+boxh/2,boxx+boxw,boxy+boxh)
lib.PicLoadCache(4,50*2,boxx+boxw-382,boxy+boxh-126,1)
lib.SetClip(0,0,0,0)
--Right Top
lib.SetClip(boxx+7,boxy+7,boxx+boxw-7,boxy+boxh-7)
lib.PicLoadCache(4,50*2,boxx,boxy,1)
lib.SetClip(0,0,0,0)
for i=1,num do
DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel+(size+6)*(i-1),strarray[i],color,size)
end
end

function DrawYJZBox_sub(x,y,w,h)
local boxw,boxh
boxw=16*math.modf(w/16)+16+14
boxh=16*math.modf(h/16)+16+14
local boxx=x-(boxw-w)/2
local boxy=y-(boxh-h)/2
--382x126
--Left Top
lib.SetClip(boxx,boxy,boxx+boxw/2,boxy+boxh/2)
lib.PicLoadCache(4,50*2,boxx,boxy,1)
lib.SetClip(0,0,0,0)
--Left Bot
lib.SetClip(boxx,boxy+boxh/2,boxx+boxw/2,boxy+boxh)
lib.PicLoadCache(4,50*2,boxx,boxy+boxh-126,1)
lib.SetClip(0,0,0,0)
--Right Top
lib.SetClip(boxx+boxw/2,boxy,boxx+boxw,boxy+boxh/2)
lib.PicLoadCache(4,50*2,boxx+boxw-382,boxy,1)
lib.SetClip(0,0,0,0)
--Right Bot
lib.SetClip(boxx+boxw/2,boxy+boxh/2,boxx+boxw,boxy+boxh)
lib.PicLoadCache(4,50*2,boxx+boxw-382,boxy+boxh-126,1)
lib.SetClip(0,0,0,0)
end

function WarDrawStrBoxDelay2(s,color,x,y,n)--显示字符串并等待击键 适用于战斗，画面保持刷新
x=x or -1
y=y or -1
n=n or 16
lib.GetKey()
for i=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(x,y,s,color)
lib.GetKey()
ReFresh()
end
end

function DrawYJZBox2(x,y,str,color)--显示带框的字符串
local size=16
local strarray={}
local num,maxlen
maxlen=0
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
local w=size*maxlen/2+2*CC.MenuBorderPixel
local h=2*CC.MenuBorderPixel+size*num+6*(num-1)
 
if x==-1 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=16+(576-w)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-w)/2
else
x=(CC.ScreenW-w)/2
end
end
if y==-1 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
y=32+(432-h)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
y=16+(400-h)/2
else
y=(CC.ScreenH-h)/2
end
end
if x<0 then
x=CC.ScreenW-size/2*maxlen-2*CC.MenuBorderPixel+x
end
if y<0 then
y=CC.ScreenH-size*num-2*CC.MenuBorderPixel+y
end
local boxw,boxh
boxw=16*math.modf(w/16)+16+14
boxh=16*math.modf(h/16)+16+14
local boxx=x-(boxw-w)/2
local boxy=y-(boxh-h)/2
--382x126
--Left Top
lib.SetClip(boxx,boxy,boxx+boxw/2,boxy+boxh/2)
lib.PicLoadCache(4,60*2,boxx,boxy,1)
lib.SetClip(0,0,0,0)
--Left Bot
lib.SetClip(boxx,boxy+boxh/2,boxx+boxw/2,boxy+boxh)
lib.PicLoadCache(4,60*2,boxx,boxy+boxh-110,1)
lib.SetClip(0,0,0,0)
--Right Top
lib.SetClip(boxx+boxw/2,boxy,boxx+boxw,boxy+boxh/2)
lib.PicLoadCache(4,60*2,boxx+boxw-142,boxy,1)
lib.SetClip(0,0,0,0)
--Right Bot
lib.SetClip(boxx+boxw/2,boxy+boxh/2,boxx+boxw,boxy+boxh)
lib.PicLoadCache(4,60*2,boxx+boxw-142,boxy+boxh-110,1)
lib.SetClip(0,0,0,0)
--Right Top
lib.SetClip(boxx+7,boxy+7,boxx+boxw-7,boxy+boxh-7)
lib.PicLoadCache(4,50*2,boxx,boxy,1)
lib.SetClip(0,0,0,0)
for i=1,num do
DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel+(size+6)*(i-1),strarray[i],color,size)
end
end

function ShowScreen()--场景变黑再转为变亮
if JY.Dark then
Light()
else
lib.ShowSurface(0)
end
end

function RGB(r,g,b)--设置颜色RGB
return r*65536+g*256+b
end

function GetRGB(color)--分离颜色的RGB分量
color=color%(65536*256)
local r=math.floor(color/65536)
color=color%65536
local g=math.floor(color/256)
local b=color%256
return r,g,b
end

--等待键盘输入
function WaitKey(flag)--等待键盘输入
local keyPress=-1
while true do
local eventtype,keypress,x,y=lib.GetMouse(1)
if eventtype==1 or eventtype==3 then
MOUSE.status='IDLE'
break
end
lib.Delay(20)
end
lib.Delay(100)
return keyPress
end

function LoadRecord(id)-- 读取游戏进度
Dark()
local t1=lib.GetTime()
local data=Byte.create(4*8)
--读取savedata
Byte.loadfile(data,CC.SavedataFile,0,4*8)
CC.font=Byte.get16(data,0)
CC.MusicVolume=Byte.get16(data,2)
CC.SoundVolume=Byte.get16(data,4)
CC.zdby=Byte.get16(data,6)
CC.cldh=Byte.get16(data,8)
CC.MoveSpeed=Byte.get16(data,10)
Config()
PicCatchIni()
--读取R*.idx文件
Byte.loadfile(data,CC.R_IDXFilename[0],0,4*8)
local idx={}
idx[0]=100
for i=1,8 do
idx[i]=Byte.get32(data,4*(i-1))
end
--读取R*.grp文件
JY.Data_Base=Byte.create(idx[1]-idx[0])--基本数据
Byte.loadfile(JY.Data_Base,CC.R_GRPFilename[id],idx[0],idx[1]-idx[0])
--设置访问基本数据的方法，这样就可以用访问表的方式访问了．而不用把二进制数据转化为表．节约加载时间和空间
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Base,0,CC.Base_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Base,0,CC.Base_S,k,v)
end
}
setmetatable(JY.Base,meta_t)
if JY.Base["游戏模式"]==1 then
CC.Enhancement=true
else
CC.Enhancement=false
end
if CC.Enhancement==false then
CC.Person_S["武力"]={48,0,2,false}
CC.Person_S["智力"]={50,0,2,false}
CC.Person_S["统率"]={52,0,2,false}
CC.Person_S["武力经验"]={54,0,2,false}
CC.Person_S["智力经验"]={56,0,2,false}
CC.Person_S["统率经验"]={58,0,2,false}
else
CC.Person_S["武力"]={48,0,2,true}
CC.Person_S["智力"]={50,0,2,true}
CC.Person_S["统率"]={52,0,2,true}
CC.Person_S["武力经验"]={54,0,2,true}
CC.Person_S["智力经验"]={56,0,2,true}
CC.Person_S["统率经验"]={58,0,2,true}
end
JY.PersonNum=math.floor((idx[2]-idx[1])/CC.PersonSize)--人物 /newgamesave和实际存档 混合读取
JY.Data_Person_Base=Byte.create(CC.PersonSize*JY.PersonNum)
JY.Data_Person=Byte.create(CC.PersonSize*JY.PersonNum)
Byte.loadfile(JY.Data_Person_Base, CC.R_GRPFilename[0],idx[1],CC.PersonSize*JY.PersonNum)
Byte.loadfile(JY.Data_Person, CC.R_GRPFilename[id],idx[1],CC.PersonSize*JY.PersonNum)
for i=0,JY.PersonNum-1 do
JY.Person[i]={}
if i<421 then
local meta_t={
__index=function(t,k)
return GetPersonData(i*CC.PersonSize,CC.Person_S,k)--421以前的人物混合读取，421以后为新武将
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k,v)
end
}
setmetatable(JY.Person[i],meta_t)
else
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k,v)
end
}
setmetatable(JY.Person[i],meta_t)
end
end
JY.BingzhongNum=math.floor((idx[3]-idx[2])/CC.BingzhongSize)--兵种 /读取newgamesave
JY.Data_Bingzhong=Byte.create(CC.BingzhongSize*JY.BingzhongNum)
Byte.loadfile(JY.Data_Bingzhong,CC.R_GRPFilename[0],idx[2],CC.BingzhongSize*JY.BingzhongNum)
for i=0,JY.BingzhongNum-1 do
JY.Bingzhong[i]={}
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Bingzhong,i*CC.BingzhongSize,CC.Bingzhong_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Bingzhong,i*CC.BingzhongSize,CC.Bingzhong_S,k,v)
end
}
setmetatable(JY.Bingzhong[i],meta_t)
end
JY.SceneNum=math.floor((idx[4]-idx[3])/CC.SceneSize)--场景
JY.Data_Scene=Byte.create(CC.SceneSize*JY.SceneNum)
Byte.loadfile(JY.Data_Scene,CC.R_GRPFilename[id],idx[3],CC.SceneSize*JY.SceneNum)
for i=0,JY.SceneNum-1 do
JY.Scene[i]={}
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Scene,i*CC.SceneSize,CC.Scene_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Scene,i*CC.SceneSize,CC.Scene_S,k,v)
end
}
setmetatable(JY.Scene[i],meta_t)
end
JY.ItemNum=math.floor((idx[5]-idx[4])/CC.ItemSize)--道具 /读取newgamesave
JY.Data_Item=Byte.create(CC.ItemSize*JY.ItemNum)
Byte.loadfile(JY.Data_Item,CC.R_GRPFilename[0],idx[4],CC.ItemSize*JY.ItemNum)
for i=0,JY.ItemNum-1 do
JY.Item[i]={}
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Item,i*CC.ItemSize,CC.Item_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Item,i*CC.ItemSize,CC.Item_S,k,v)
end
}
setmetatable(JY.Item[i],meta_t)
end
JY.MagicNum=math.floor((idx[6]-idx[5])/CC.MagicSize)--策略 /读取newgamesave
JY.Data_Magic=Byte.create(CC.MagicSize*JY.MagicNum)
Byte.loadfile(JY.Data_Magic,CC.R_GRPFilename[0],idx[5],CC.MagicSize*JY.MagicNum)
for i=0,JY.MagicNum-1 do
JY.Magic[i]={}
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Magic,i*CC.MagicSize,CC.Magic_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Magic,i*CC.MagicSize,CC.Magic_S,k,v)
end
}
setmetatable(JY.Magic[i],meta_t)
end
JY.SkillNum=math.floor((idx[7]-idx[6])/CC.SkillSize)--特技 /读取newgamesave
JY.Data_Skill=Byte.create(CC.SkillSize*JY.SkillNum)
Byte.loadfile(JY.Data_Skill,CC.R_GRPFilename[0],idx[6],CC.SkillSize*JY.SkillNum)
for i=0,JY.SkillNum-1 do
JY.Skill[i]={}
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Skill,i*CC.SkillSize,CC.Skill_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Skill,i*CC.SkillSize,CC.Skill_S,k,v)
end
}
setmetatable(JY.Skill[i],meta_t)
end
collectgarbage()
lib.Debug(string.format("Loadrecord%d time=%d",id,lib.GetTime()-t1))
JY.Smap={}
for i=1,JY.SceneNum-1 do
if JY.Scene[i]["人物"]>0 then
AddPerson(JY.Scene[i]["人物"],JY.Scene[i]["坐标X"],JY.Scene[i]["坐标Y"],JY.Scene[i]["方向"])
end
end
JY.SubScene=JY.Base["当前场景"]
JY.EventID=JY.Base["当前事件"]
JY.CurrentBGM=JY.Base["当前音乐"]
JY.LLK_N=0
if CC.font==1 then
CC.FontName=CONFIG.FontName2
else
CC.FontName=CONFIG.FontName
end
if id>0 then
if ((JY.Status==GAME_SMAP_MANUAL or JY.Status==GAME_START) and JY.Base["战场存档"]==0) then
DrawSMap()
end
JY.Status=JY.Base["当前状态"]
if JY.Base["战场存档"]==1 then
 WarLoad(id)
end
if JY.CurrentBGM>=0 then
PlayBGM(JY.CurrentBGM)
end
Light()
end
end

function fileexist(filename)--检测文件是否存在
local inp=io.open(filename,"rb")
if inp==nil then
return false
end
inp:close()
return true
end

function copyfile(source,destination)
local sourcefile=io.open(source,"rb")
local destinationfile=io.open(destination,"wb")
destinationfile:write(sourcefile:read("*a"))
sourcefile:close()
destinationfile:close()
end

-- 写游戏进度
-- id=0 新进度，=1/2/3 进度
function SaveRecord(id)-- 写游戏进度
local t1=lib.GetTime()
if JY.Status==GAME_WMAP then
JY.Base["战场存档"]=1
else
JY.Base["战场存档"]=0
end
JY.Base["时间"]=string.sub(os.date("%m/%d/%y %X"),0,14)
JY.Base["当前状态"]=JY.Status
JY.Base["当前事件"]=JY.EventID
JY.Base["当前场景"]=JY.SubScene
JY.Base["当前音乐"]=JY.CurrentBGM
for i=1,JY.SceneNum-1 do
JY.Scene[i]["人物"]=0
JY.Scene[i]["坐标X"]=0
JY.Scene[i]["坐标Y"]=0
JY.Scene[i]["方向"]=0
end
local n=#JY.Smap
for i=1,math.min(n,JY.SceneNum-1) do
JY.Scene[i]["人物"]=JY.Smap[i][1]
JY.Scene[i]["坐标X"]=JY.Smap[i][2]
JY.Scene[i]["坐标Y"]=JY.Smap[i][3]
JY.Scene[i]["方向"]=JY.Smap[i][4]
end
local data=Byte.create(4*8)
--读取savedata
Byte.set16(data,0,CC.font)
Byte.set16(data,2,CC.MusicVolume)
Byte.set16(data,4,CC.SoundVolume)
Byte.set16(data,6,CC.zdby)
Byte.set16(data,8,CC.cldh)
Byte.set16(data,10,CC.MoveSpeed)
Byte.savefile(data,CC.SavedataFile,0,4*8)
--读取R*.idx文件
Byte.loadfile(data,CC.R_IDXFilename[0],0,4*8)
local idx={}
idx[0]=100
for i=1,8 do
idx[i]=Byte.get32(data,4*(i-1))
end
--写R*.grp文件
if true then
copyfile(CC.R_GRPFilename[0],CC.R_GRPFilename[id])
end
Byte.savefile(JY.Data_Base,CC.R_GRPFilename[id],idx[0],idx[1]-idx[0])
Byte.savefile(JY.Data_Person,CC.R_GRPFilename[id],idx[1],CC.PersonSize*JY.PersonNum)
Byte.savefile(JY.Data_Scene,CC.R_GRPFilename[id],idx[3],CC.SceneSize*JY.SceneNum)
lib.Debug(string.format("SaveRecord time=%d",lib.GetTime()-t1))
end

function GetDataFromStruct(data,offset,t_struct,key)--从数据的结构中翻译数据，用来取数据
local t=t_struct[key]
local r
if t[2]==0 then
if t[3]==1 then
r=Byte.get8(data,t[1]+offset)
else
r=Byte.get16(data,t[1]+offset)
end
elseif t[2]==1 then
r=Byte.getu16(data,t[1]+offset)
elseif t[2]==2 then
if CC.SrcCharSet==1 then
r=lib.CharSet(Byte.getstr(data,t[1]+offset,t[3]),0)
else
r=Byte.getstr(data,t[1]+offset,t[3])
end
end
return r
end

function SetDataFromStruct(data,offset,t_struct,key,v)--从数据的结构中翻译数据，保存数据
local t=t_struct[key]
if t[2]==0 then
if t[3]==1 then
Byte.set8(data,t[1]+offset,v)
else
Byte.set16(data,t[1]+offset,v)
end
elseif t[2]==1 then
Byte.setu16(data,t[1]+offset,v)
elseif t[2]==2 then
local s
if CC.SrcCharSet==1 then
s=lib.CharSet(v,1)
else
s=v
end
Byte.setstr(data,t[1]+offset,t[3],s)
end
end

function GetPersonData(offset,t_struct,key)
if t_struct[key][4] then
return GetDataFromStruct(JY.Data_Person,offset,t_struct,key)
else
return GetDataFromStruct(JY.Data_Person_Base,offset,t_struct,key)
end
end

function between(v,Min,Max)
if Min>Max then
Min,Max=Max,Min
end
if v>=Min and v<=Max then
return true
end
return false
end

function Light()--场景变亮
if JY.Dark then
JY.Dark=false
lib.ShowSlow(CC.FrameNum,0)
lib.GetKey()
end
end

function Dark()--场景变黑
if not JY.Dark then
JY.Dark=true
lib.ShowSlow(CC.FrameNum,1)
lib.GetKey()
end
end

--播放MP3
function PlayBGM(id)
id=id or 0
JY.CurrentBGM=id
if JY.EnableMusic==0 then
return 
end
if id>=0 and id<=19 then
lib.PlayMIDI(string.format(CC.BGMFile,id))
end
end

function StopBGM()
JY.CurrentBGM=-1
lib.PlayMIDI("")
end

--播放音效e**
function PlayWavE(id)--播放音效e**
if JY.EnableSound==0 then
return 
end
if id>=0 then
lib.PlayWAV(string.format(CC.EFile,id))
end
end

--产生对话显示需要的字符串，即每隔n个中文字符加一个星号
function GenTalkString(str,n)--产生对话显示需要的字符串
local tmpstr=""
local num=0
for s in string.gmatch(str .. "*","(.-)%*") do--去掉对话中的所有*. 字符串尾部加一个星号，避免无法匹配
tmpstr=tmpstr .. s
end
local newstr=""
while #tmpstr>0 do
num=num+1
local w=0
while w<#tmpstr do
local v=string.byte(tmpstr,w+1)--当前字符的值
if v>=128 then
w=w+2
else
w=w+1
end
if w >=2*n-1 then--为了避免跨段中文字符
break
end
end
if w<#tmpstr then
if w==2*n-1 and string.byte(tmpstr,w+1)<128 then
newstr=newstr .. string.sub(tmpstr,1,w+1) .. "*"
tmpstr=string.sub(tmpstr,w+2,-1)
else
newstr=newstr .. string.sub(tmpstr,1,w) .. "*"
tmpstr=string.sub(tmpstr,w+1,-1)
end
else
newstr=newstr .. tmpstr
break
end
end
return newstr,num
end

function ShowMenu(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor)--通用菜单函数
if JY.Status==GAME_START then
local mstr="三国志英杰传复刻版"
local msize=50
DrawString(160,30,mstr,M_Orange,msize)
mstr="v"..JY.Base["档案版本"]
DrawString(310,400,mstr,M_Orange,msize)
end
local w=0
local h=0--边框的宽高
local i=0
local num=0--实际的显示菜单项
local newNumItem=0--能够显示的总菜单项数
size=size or CC.Fontbig
size=16
color=color or M_Orange
selectColor=selectColor or M_White
lib.GetKey()
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
local newMenu={}-- 定义新的数组，以保存所有能显示的菜单项
--计算能够显示的总菜单项数
for i=1,numItem do
if menuItem[i][3]>0 then
newNumItem=newNumItem+1
newMenu[newNumItem]={menuItem[i][1],menuItem[i][2],menuItem[i][3],i,1}--新数组多了[4],保存和原数组的对应
--新数组多了[5], 代表对齐 123 左中右
if string.sub(menuItem[i][1],1,1)=="@" then
newMenu[newNumItem][1]=string.sub(menuItem[i][1],2)
newMenu[newNumItem][5]=2
end
end
end
--计算实际显示的菜单项数
if numShow==0 or numShow > newNumItem then
num=newNumItem
else
num=numShow
end
--计算边框实际宽高
local maxlength=0
if x2==0 and y2==0 then
for i=1,newNumItem do
if string.len(newMenu[i][1])>maxlength then
maxlength=string.len(newMenu[i][1])
end
end
w=size*maxlength/2+2*CC.MenuBorderPixel--按照半个汉字计算宽度，一边留4个象素
h=(size+CC.RowPixel)*num+CC.MenuBorderPixel--字之间留4个象素，上面再留4个象素
else
w=x2-x1
h=y2-y1
num=math.min(num,(math.modf(h/(size+CC.RowPixel))))
end
local start=1--显示的第一项
local current=0--当前选择项
for i=1,newNumItem do
if newMenu[i][3]==2 then
current=i
break
end
end
if current > num then
start=1+current-num
end

if JY.Menu_keep then
start=JY.Menu_start
current=JY.Menu_current
end
local keyPress=-1
local returnValue=0
local x_off,y_off,row_off,h_off=0,0,0,0
if isBox==1 then
x_off=3
y_off=7
row_off=4
h_off=8
w=80
h=16+24*num
elseif isBox==2 then --开始菜单用
x_off=4
y_off=6
row_off=4
h_off=8
w=144
h=16+24*num
elseif isBox==20 then--2的加宽版本，存档读档用
x_off=4
y_off=6
row_off=4
h_off=8
w=420
h=16+24*num
elseif isBox==3 then--baseon 2，调整宽度
x_off=4
y_off=6
row_off=4
h_off=8
w=96
h=16+24*num
elseif isBox==4 then
x_off=11
y_off=9
row_off=0
h_off=12
w=112
h=16+8+20*num
elseif isBox==5 then--策略<=8用
x_off=4
y_off=9
row_off=0
h_off=12
w=104
h=16+8+20*num
elseif isBox==6 then--策略>8用
x_off=4
y_off=9
row_off=0
h_off=12
w=120-20
h=16+8+20*num
elseif isBox==9 then
DrawBox(x1,y1,x1+w,y1+h,M_White)
end
if x1==-1 or x1==0 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x1=16+(576-w)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x1=16+(640-w)/2
else
x1=(CC.ScreenW-w)/2
end
end
if y1==-1 or y1==0 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
y1=32+(432-h)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
y1=16+(400-h)/2
else
y1=(CC.ScreenH-h)/2
end
end

local function redraw(flag)
if num~=0 then--暂且这样改
if isBox==1 then
lib.SetClip(x1,y1,x1+w,y1+8+24*num)
lib.PicLoadCache(4,0*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+8+24*math.max(0,(num-8)),x1+w,y1+8+24*num+8)
lib.PicLoadCache(4,0*2,x1,y1+16+24*num-256,1)
lib.SetClip(0,0,0,0)
elseif isBox==2 then
lib.SetClip(x1,y1,x1+w,y1+7+24*num)
lib.PicLoadCache(4,60*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8)
lib.PicLoadCache(4,60*2,x1,y1+14+24*num-110,1)
lib.SetClip(0,0,0,0)
elseif isBox==20 then
lib.SetClip(x1,y1,x1+w,y1+7+24*num)
lib.PicLoadCache(4,70*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8)
lib.PicLoadCache(4,70*2,x1,y1+14+24*num-110,1)
lib.SetClip(0,0,0,0)
elseif isBox==3 then
lib.SetClip(x1,y1,x1+w,y1+7+24*num)
lib.PicLoadCache(4,63*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8)
lib.PicLoadCache(4,63*2,x1,y1+14+24*num-182,1)
lib.SetClip(0,0,0,0)
elseif isBox==4 then
lib.SetClip(x1,y1,x1+w,y1+h)
lib.PicLoadCache(4,59*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-8,x1+w,y1+h)
lib.PicLoadCache(4,59*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
elseif isBox==5 then
lib.SetClip(x1,y1,x1+w,y1+h)
lib.PicLoadCache(4,66*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-8,x1+w,y1+h)
lib.PicLoadCache(4,66*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
elseif isBox==6 then
lib.SetClip(x1,y1,x1+w+20,y1+h)
lib.PicLoadCache(4,67*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-32,x1+w+20,y1+h)
lib.PicLoadCache(4,67*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
local nn=newNumItem-num
local nn_row=120
lib.PicLoadCache(4,68*2,x1+98,y1+24+nn_row*(start-1)/nn,1)
elseif isBox==9 then
DrawBox(x1,y1,x1+w,y1+h,M_White)
end
end
for i=start,start+num-1 do
local drawColor=color--设置不同的绘制颜色
local menustr=newMenu[i][1]
local dx=0
if newMenu[i][5]==2 then
dx=size*(maxlength-string.len(menustr))/2/2
end
if i==current then
drawColor=selectColor
end
if isBox==1 then
if i==current then
lib.PicLoadCache(4,2*2,x1+6,y1+9+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
lib.PicLoadCache(4,1*2,x1+6,y1+9+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==2 then
if i==current then
lib.PicLoadCache(4,62*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
lib.PicLoadCache(4,61*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==20 then
if i==current then
lib.PicLoadCache(4,72*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
lib.PicLoadCache(4,71*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==3 then
if i==current then
lib.PicLoadCache(4,65*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
lib.PicLoadCache(4,64*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==4 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-1),x1+99,y1+12+20*(i),M_White)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==5 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-1),x1+91,y1+12+20*(i),M_White)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==6 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-start),x1+91,y1+12+20*(i-start+1),M_White)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
else
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
end
if flag then
lib.Background(x1,y1,x1+w,y1+h,128)
end
end
local wait=true
while wait do
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid)
redraw()
ReFresh()
local eventtype,keyPress,mx,my=getkey()
mx,my=MOUSE.x,MOUSE.y
if eventtype==3 and keyPress==3 then
if isEsc==1 then
wait=false
end
end
if mx>x1+6 and mx<x1+w-6 and my>y1+h_off and my<y1+h-h_off then
current=math.modf((my-y1-h_off)/(size+CC.RowPixel+row_off))
if MOUSE.HOLD(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
current=limitX(start+current,1,newNumItem)
elseif MOUSE.CLICK(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
local sel=limitX(start+current,1,newNumItem)
current=0
PlayWavE(0)
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid)
redraw()
ReFresh(CC.OpearteSpeed/2)
if newMenu[sel][2]==nil then
returnValue=newMenu[sel][4]
wait=false
else
redraw()
JY.MenuPic.num=JY.MenuPic.num+1
JY.MenuPic.pic[JY.MenuPic.num]=lib.SaveSur(x1,y1,x1+w,y1+h)
JY.MenuPic.x[JY.MenuPic.num]=x1
JY.MenuPic.y[JY.MenuPic.num]=y1
local r=newMenu[sel][2](newMenu[sel][4])--调用菜单函数
lib.FreeSur(JY.MenuPic.pic[JY.MenuPic.num])
JY.MenuPic.num=JY.MenuPic.num-1
if r==1 then
returnValue=newMenu[sel][4]
wait=false
end
end
elseif between(isBox,4,6) and MOUSE.IN(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
current=limitX(start+current,1,newNumItem)
else
current=0
end
elseif isBox==6 then
local nn=newNumItem-num
local nn_row=120
local nn_x=x1+99
local nn_y=y1+24+nn_row*start/nn
if MOUSE.HOLD(nn_x,y1+24,nn_x+12,y1+24+136) then
nn_y=MOUSE.y-8
start=1+math.modf((nn_y-y1-24)*nn/nn_row)
start=limitX(start,1,nn+1)
elseif MOUSE.CLICK(nn_x,y1+9,nn_x+16,y1+24) then
start=limitX(start-1,1,nn+1)
elseif MOUSE.CLICK(nn_x,y1+161,nn_x+16,y1+176) then
start=limitX(start+1,1,nn+1)
end
current=0
else
current=0
end
end
if returnValue==0 then
PlayWavE(1)
end
lib.LoadSur(sid)
lib.FreeSur(sid)
return returnValue
end

function WarShowMenu(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor)--通用菜单函数
local w=0
local h=0--边框的宽高
local i=0
local num=0--实际的显示菜单项
local newNumItem=0--能够显示的总菜单项数
size=size or CC.Fontbig
size=16
color=color or M_Orange
selectColor=selectColor or M_White
lib.GetKey()
local newMenu={}-- 定义新的数组，以保存所有能显示的菜单项
--计算能够显示的总菜单项数
for i=1,numItem do
if menuItem[i][3]>0 then
newNumItem=newNumItem+1
newMenu[newNumItem]={menuItem[i][1],menuItem[i][2],menuItem[i][3],i}--新数组多了[4],保存和原数组的对应
end
end
--计算实际显示的菜单项数
if numShow==0 or numShow > newNumItem then
num=newNumItem
else
num=numShow
end
--计算边框实际宽高
local maxlength=0
if x2==0 and y2==0 then
for i=1,newNumItem do
if string.len(newMenu[i][1])>maxlength then
maxlength=string.len(newMenu[i][1])
end
end
w=size*maxlength/2+2*CC.MenuBorderPixel--按照半个汉字计算宽度，一边留4个象素
h=(size+CC.RowPixel)*num+CC.MenuBorderPixel--字之间留4个象素，上面再留4个象素
else
w=x2-x1
h=y2-y1
num=math.min(num,(math.modf(h/(size+CC.RowPixel))))
end
local start=1--显示的第一项
local current=0--当前选择项
for i=1,newNumItem do
if newMenu[i][3]==2 then
current=i
break
end
end
if current > num then
start=1+current-num
end
if JY.Menu_keep then
start=JY.Menu_start
current=JY.Menu_current
end
local keyPress=-1
local returnValue=0
local x_off,y_off,row_off,h_off=0,0,0,0
if isBox==1 then
x_off=3
y_off=7
row_off=4
h_off=8
w=80
h=16+24*num
elseif isBox==2 then
x_off=4
y_off=6
row_off=4
h_off=8
w=144
h=16+24*num
elseif isBox==3 then--baseon 2，调整宽度
x_off=4
y_off=6
row_off=4
h_off=8
w=96
h=16+24*num
elseif isBox==4 then
x_off=11
y_off=9
row_off=0
h_off=12
w=112
h=16+8+20*num
elseif isBox==5 then--策略<=8用
x_off=4
y_off=9
row_off=0
h_off=12
w=104
h=16+8+20*num
elseif isBox==6 then--策略>8用
x_off=4
y_off=9
row_off=0
h_off=12
w=120-20
h=16+8+20*num
elseif isBox==9 then
DrawBox(x1,y1,x1+w,y1+h,M_White)
end
if x1==-1 then
x1=(CC.ScreenW-w)/2
end
if y1==-1 then
y1=(CC.ScreenH-h)/2
end
local function redraw(flag)
if num~=0 then--暂且这样改
if isBox==1 then
lib.SetClip(x1,y1,x1+w,y1+8+24*num)
lib.PicLoadCache(4,0*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+8+24*math.max(0,(num-8)),x1+w,y1+8+24*num+8)
lib.PicLoadCache(4,0*2,x1,y1+16+24*num-256,1)
lib.SetClip(0,0,0,0)
elseif isBox==2 then
lib.SetClip(x1,y1,x1+w,y1+7+24*num)
lib.PicLoadCache(4,60*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8)
lib.PicLoadCache(4,60*2,x1,y1+14+24*num-110,1)
lib.SetClip(0,0,0,0)
elseif isBox==3 then
lib.SetClip(x1,y1,x1+w,y1+7+24*num)
lib.PicLoadCache(4,63*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8)
lib.PicLoadCache(4,63*2,x1,y1+14+24*num-110,1)
lib.SetClip(0,0,0,0)
elseif isBox==4 then
lib.SetClip(x1,y1,x1+w,y1+h)
lib.PicLoadCache(4,59*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-8,x1+w,y1+h)
lib.PicLoadCache(4,59*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
elseif isBox==5 then
lib.SetClip(x1,y1,x1+w,y1+h)
lib.PicLoadCache(4,66*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-8,x1+w,y1+h)
lib.PicLoadCache(4,66*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
elseif isBox==6 then
lib.SetClip(x1,y1,x1+w+20,y1+h)
lib.PicLoadCache(4,67*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-32,x1+w+20,y1+h)
lib.PicLoadCache(4,67*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
local nn=newNumItem-num
local nn_row=120
lib.PicLoadCache(4,68*2,x1+98,y1+24+nn_row*(start-1)/nn,1)
elseif isBox==9 then
DrawBox(x1,y1,x1+w,y1+h,M_White)
end
end
for i=start,start+num-1 do
local drawColor=color--设置不同的绘制颜色
local menustr=newMenu[i][1]
if i==current then
drawColor=selectColor
end
if isBox==1 then
if i==current then
lib.PicLoadCache(4,2*2,x1+6,y1+9+24*(i-1),1)
DrawString(x1+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
lib.PicLoadCache(4,1*2,x1+6,y1+9+24*(i-1),1)
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
elseif isBox==2 then
if i==current then
lib.PicLoadCache(4,62*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
lib.PicLoadCache(4,61*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
elseif isBox==3 then
if i==current then
lib.PicLoadCache(4,65*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
lib.PicLoadCache(4,64*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
elseif isBox==4 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-1),x1+99,y1+12+20*(i),M_White)
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
elseif isBox==5 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-1),x1+91,y1+12+20*(i),M_White)
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
elseif isBox==6 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-start),x1+91,y1+12+20*(i-start+1),M_White)
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
else
DrawString(x1+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
end
if flag then
lib.Background(x1,y1,x1+w,y1+h,128)
end
end
local wait=true
while wait do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
redraw()
ReFresh()
local eventtype,keyPress,mx,my=getkey()
mx,my=MOUSE.x,MOUSE.y
if eventtype==3 and keyPress==3 then
if isEsc==1 then
wait=false
end
end
if mx>x1+6 and mx<x1+w-6 and my>y1+h_off and my<y1+h-h_off then
current=math.modf((my-y1-h_off)/(size+CC.RowPixel+row_off))
if MOUSE.HOLD(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
current=limitX(start+current,1,newNumItem)
elseif MOUSE.CLICK(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
local sel=limitX(start+current,1,newNumItem)
current=0
PlayWavE(0)
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
redraw()
ReFresh(CC.OpearteSpeed)
if newMenu[sel][2]==nil then
returnValue=newMenu[sel][4]
wait=false
else
redraw()
JY.MenuPic.num=JY.MenuPic.num+1
JY.MenuPic.pic[JY.MenuPic.num]=lib.SaveSur(x1,y1,x1+w,y1+h)
JY.MenuPic.x[JY.MenuPic.num]=x1
JY.MenuPic.y[JY.MenuPic.num]=y1
local r=newMenu[sel][2](newMenu[sel][4])--调用菜单函数
lib.FreeSur(JY.MenuPic.pic[JY.MenuPic.num])
JY.MenuPic.num=JY.MenuPic.num-1
if r==1 then
returnValue=newMenu[sel][4]
wait=false
end
end
elseif between(isBox,4,6) and MOUSE.IN(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
current=limitX(start+current,1,newNumItem)
else
current=0
end
elseif isBox==6 then
local nn=newNumItem-num
local nn_row=120
local nn_x=x1+99
local nn_y=y1+24+nn_row*start/nn
if MOUSE.HOLD(nn_x,y1+24,nn_x+12,y1+24+136) then
nn_y=MOUSE.y-8
start=1+math.modf((nn_y-y1-24)*nn/nn_row)
start=limitX(start,1,nn+1)
elseif MOUSE.CLICK(nn_x,y1+9,nn_x+16,y1+24) then
start=limitX(start-1,1,nn+1)
elseif MOUSE.CLICK(nn_x,y1+161,nn_x+16,y1+176) then
start=limitX(start+1,1,nn+1)
end
current=0
else
current=0
end
end
if returnValue==0 then
PlayWavE(1)
end
return returnValue
end

function SRPG()
if CC.Enhancement then
for i=1,JY.PersonNum-1 do
if JY.Person[i]["修炼"]==1 then
JY.Person[i]["修炼"]=0
end
end
end
local step=4
JY.ReFreshTime=lib.GetTime()
DrawWarMap(War.CX,War.CY)
Light()
ReFresh()
WarCheckStatus()
local WEA={[0]="晴","晴","晴","雲","雨","雨","？"}
while JY.Status==GAME_WMAP and War.Turn<=War.MaxTurn do
--第X回合 X
WarDrawStrBoxDelay(string.format('第%d回合 %s',War.Turn,WEA[War.Weather]),M_White)
WarCheckStatus()
--我军操作
if JY.Status==GAME_WMAP then
WarDrawStrBoxDelay('玩家军队状况',M_White)
War.ControlStatus='select'
War.ControlEnable=true
end
while JY.Status==GAME_WMAP do
JY.ReFreshTime=lib.GetTime()
DrawWarMap(War.CX,War.CY)
if CC.XYXS then
DrawString(8,CC.ScreenH-24,string.format("%d,%d",War.MX,War.MY),M_White,16)
end
ReFresh()
if opn() then
break
end
end
--AI行动
if JY.Status==GAME_WMAP then
War.ControlStatus='AI'
AI()
end
War.Turn=War.Turn+1--回合+1
if JY.Status==GAME_WMAP and War.Turn<=War.MaxTurn then
--Weather
local wea=math.random(6)-1
if War.Weather<wea then
War.Weather=War.Weather+1
elseif War.Weather>wea then
War.Weather=War.Weather-1
end
if War.Weather==0 then
War.Weather=5
elseif War.Weather==5 then
War.Weather=0
end
--全军可操作
for i,v in pairs(War.Person) do
if v.live then
v.active=true
WarResetStatus(i)
end
end
--恢复
WarRest()
end
end
if JY.Status==GAME_WMAP and War.Turn>War.MaxTurn then
if War.Leader1==1 then
WarLastWords(GetWarID(1))
WarAction(18,GetWarID(1))
end
JY.Status=GAME_WARLOSE
if DoEvent(JY.EventID) then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN then
DoEvent(JY.EventID)
end
end
end
Dark()
end

function ReFresh(n)
n=n or 1
local frame_t=CC.FrameNum*n
local t1,t2
t1=JY.ReFreshTime
t2=lib.GetTime()
if CC.FPS or CC.Debug==1 then
lib.FillColor(4,4,72,20,0)
if t2-t1<frame_t then
lib.DrawStr(4,4,string.format("FPS=%d",30),M_White,16,CC.FontName,CC.SrcCharSet,CC.OSCharSet)
else
lib.DrawStr(4,4,string.format("FPS=%d",1050/(t2-t1)),M_White,16,CC.FontName,CC.SrcCharSet,CC.OSCharSet)
end
end
ShowScreen()--场景变黑再转为变亮
if t2-t1<frame_t then
lib.Delay(frame_t+t1-t2)
end
end

function control()
local eventtype,keypress,x,y=getkey()
x,y=MOUSE.x,MOUSE.y
if eventtype==3 and keypress==3 then
return -1
end
local pid=0
if War.SelID>0 then
pid=War.Person[War.SelID].id
elseif War.CurID>0 then
pid=War.Person[War.CurID].id
elseif War.LastID>0 then
pid=War.Person[War.LastID].id
end
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('结束游戏吗？',M_White) then
WarDelay(CC.WarDelay)
if WarDrawStrBoxYesNo('再玩一次吗？',M_White) then
WarDelay(CC.WarDelay)
JY.Status=GAME_START
else
WarDelay(CC.WarDelay)
JY.Status=GAME_END
end
end
elseif War.CY>1 and MOUSE.HOLD(16+War.BoxWidth*1,32+War.BoxDepth*0,16+War.BoxWidth*(War.MW-1),32+War.BoxDepth*1) then
War.CY=War.CY-1
War.MY=War.MY-1
MOUSE.enableclick=false
elseif War.CY<War.Depth-War.MD+1 and MOUSE.HOLD(16+War.BoxWidth*1,32+War.BoxDepth*(War.MD-1),16+War.BoxWidth*(War.MW-1),32+War.BoxDepth*War.MD) then
War.CY=War.CY+1
War.MY=War.MY+1
MOUSE.enableclick=false
elseif War.CX>1 and MOUSE.HOLD(16+War.BoxWidth*0,32+War.BoxDepth*1,16+War.BoxWidth*1,32+War.BoxDepth*(War.MD-1)) then
War.CX=War.CX-1
War.MX=War.MX-1
MOUSE.enableclick=false
elseif War.CX<War.Width-War.MW+1 and MOUSE.HOLD(16+War.BoxWidth*(War.MW-1),32+War.BoxDepth*1,16+War.BoxWidth*War.MW,32+War.BoxDepth*(War.MD-1)) then
War.CX=War.CX+1
War.MX=War.MX+1
MOUSE.enableclick=false
elseif MOUSE.HOLD(War.MiniMapCX,War.MiniMapCY,War.MiniMapCX+War.Width*4,War.MiniMapCY+War.Depth*4) then
War.CX=limitX(math.modf((x-War.MiniMapCX)/4-War.MW/2)+1,1,War.Width-War.MW+1)
War.CY=limitX(math.modf((y-War.MiniMapCY)/4-War.MD/2)+1,1,War.Depth-War.MD+1)
elseif MOUSE.CLICK(616,81,680,161) then
PersonStatus(pid,"","",1)
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(644,294,678,313) then
if JY.Person[pid]["等级"]>=CC.SkillExp[JY.Person[pid]["成长"]][1] then
DrawSkillStatus(JY.Person[pid]["特技1"])--显示技能属性
end
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(680,294,714,313) then
if JY.Person[pid]["等级"]>=CC.SkillExp[JY.Person[pid]["成长"]][2] then
DrawSkillStatus(JY.Person[pid]["特技2"])--显示技能属性
end
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(716,294,740,313) then
if JY.Person[pid]["等级"]>=CC.SkillExp[JY.Person[pid]["成长"]][3] then
DrawSkillStatus(JY.Person[pid]["特技3"])--显示技能属性
end
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(644,314,678,333) then
if JY.Person[pid]["等级"]>=CC.SkillExp[JY.Person[pid]["成长"]][4] then
DrawSkillStatus(JY.Person[pid]["特技4"])--显示技能属性
end
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(680,314,714,333) then
if JY.Person[pid]["等级"]>=CC.SkillExp[JY.Person[pid]["成长"]][5] then
DrawSkillStatus(JY.Person[pid]["特技5"])--显示技能属性
end
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(716,314,740,333) then
if JY.Person[pid]["等级"]>=CC.SkillExp[JY.Person[pid]["成长"]][6] then
DrawSkillStatus(JY.Person[pid]["特技6"])--显示技能属性
end
elseif MOUSE.IN(16,32,16+War.BoxWidth*War.MW,32+War.BoxDepth*War.MD) and War.ControlStatus~="checkDX" then
local mx,my=math.modf((x-16)/War.BoxWidth),math.modf((y-32)/War.BoxDepth)
War.InMap=true
War.MX=mx+War.CX
War.MY=my+War.CY
War.CurID=GetWarMap(War.MX,War.MY,2)
if War.CurID>0 then
War.LastID=War.CurID
end
if MOUSE.CLICK(16+War.BoxWidth*mx+1,32+War.BoxDepth*my+1,16+War.BoxWidth*(mx+1)-1,32+War.BoxDepth*(my+1)-1) then
return 2,x,y
else
return 1,x,y
end
else
War.InMap=false
end
return 0
end

function BoxBack()
if War.SelID>0 then
War.MX=War.Person[War.SelID].x
War.MY=War.Person[War.SelID].y
local x,y
x=War.MX-math.modf(War.MW/2)
y=War.MY-math.modf(War.MD/2)
x=limitX(x,1,War.Width-War.MW+1)
y=limitX(y,1,War.Depth-War.MD+1)
if War.CX<x and War.MX>War.CX+War.MW-4 then
for i=War.CX,x do
War.CX=i
WarDelay()
end
elseif War.CX>x and War.MX<War.CX+3 then
for i=War.CX,x,-1 do
War.CX=i
WarDelay()
end
end
if War.CY<y and War.MY>War.CY+War.MD-4 then
for i=War.CY,y do
War.CY=i
WarDelay()
end
elseif War.CY>y and War.MY<War.CY+3 then
for i=War.CY,y,-1 do
War.CY=i
WarDelay()
end
end
War.InMap=true
War.CurID=War.SelID
--War.CurID=0
WarDelay(CC.WarDelay)
end
end

function opn()
local event,x,y=control()
if War.ControlStatus=="select" then
if event>0 then
if between(x,16,79) and between(y,8,23) then
War.FunButtom=1
else
War.FunButtom=0
end
end
if event==-1 then
return ESCMenu()
elseif event==2 then
if War.CurID>0 then--选择人
if not War.Person[War.CurID].active and CC.WXXD==false then
PlayWavE(2)
JY.ReFreshTime=lib.GetTime()
War.SelID=War.CurID
CleanWarMap(4,0)
CleanWarMap(10,0)
War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep)
War_CalAtkFW(War.CurID)
DrawWarMap()
ReFresh()
WarDrawStrBoxWaitKey('命令已执行完毕．',M_White)
CleanWarMap(4,1)
CleanWarMap(10,0)
War.SelID=0
elseif War.Person[War.CurID].enemy and CC.KZAI==false then
PlayWavE(2)
JY.ReFreshTime=lib.GetTime()
War.SelID=War.CurID
CleanWarMap(4,0)
CleanWarMap(10,0)
War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep)
War_CalAtkFW(War.CurID)
DrawWarMap()
ReFresh()
WarDrawStrBoxWaitKey('不是我军部队．',M_White)
CleanWarMap(4,1)
CleanWarMap(10,0)
War.SelID=0
elseif War.Person[War.CurID].friend and CC.KZAI==false then
PlayWavE(2)
JY.ReFreshTime=lib.GetTime()
War.SelID=War.CurID
CleanWarMap(4,0)
CleanWarMap(10,0)
War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep)
War_CalAtkFW(War.CurID)
DrawWarMap()
ReFresh()
WarDrawStrBoxWaitKey('不能操作的部队．',M_White)
CleanWarMap(4,1)
CleanWarMap(10,0)
War.SelID=0
elseif War.Person[War.CurID].troubled and CC.KZAI==false then
PlayWavE(2)
JY.ReFreshTime=lib.GetTime()
War.SelID=War.CurID
CleanWarMap(4,0)
CleanWarMap(10,0)
War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep)
War_CalAtkFW(War.CurID)
DrawWarMap()
ReFresh()
WarDrawStrBoxWaitKey('混乱中不听指挥．',M_White)
CleanWarMap(4,1)
CleanWarMap(10,0)
War.SelID=0
else
PlayWavE(0)
War.SelID=War.CurID
CleanWarMap(4,0)
CleanWarMap(10,0)
War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep)
War_CalAtkFW(War.CurID)
War.ControlStatus="move"
end
elseif War.InMap then--非人，但是在地图范围内
PlayWavE(0)
War.DXpic=lib.SaveSur(16+War.BoxWidth*(War.MX-War.CX),32+War.BoxDepth*(War.MY-War.CY),16+War.BoxWidth*(War.MX-War.CX+1),32+War.BoxDepth*(War.MY-War.CY+1))
while true do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
WarCheckDX()
ReFresh()
local eventtype,keypress=getkey()
if (eventtype==3 and keypress==3) or MOUSE.CLICK(16,32,16+War.BoxWidth*War.MW,32+War.BoxDepth*War.MD) then
break
end
end
PlayWavE(1)
lib.FreeSur(War.DXpic)
end
end
elseif War.ControlStatus=="checkDX" then
if event==2 or event==-1 then
PlayWavE(1)
lib.FreeSur(War.DXpic)
War.ControlStatus="select"
end
elseif War.ControlStatus=="move" then
if event==2 then
if not War.InMap then--不在地图范围内
elseif War.Person[War.SelID].enemy and CC.KZAI==false then
--不是我军部队．
PlayWavE(2)
WarDrawStrBoxWaitKey('不是我军部队．',M_White)
War.SelID=0
War.ControlStatus="select"
CleanWarMap(4,1)
CleanWarMap(10,0)
elseif War.Person[War.SelID].friend and CC.KZAI==false then
--不能操作的部队．
PlayWavE(2)
WarDrawStrBoxWaitKey('不能操作的部队．',M_White)
War.SelID=0
War.ControlStatus="select"
CleanWarMap(4,1)
CleanWarMap(10,0)
elseif GetWarMap(War.MX,War.MY,4)==0 or (GetWarMap(War.MX,War.MY,2)>0 and GetWarMap(War.MX,War.MY,2)~=War.SelID) then
--不是在移动范围里．
PlayWavE(2)
WarDrawStrBoxWaitKey('不是在移动范围里．',M_White)
else
CleanWarMap(10,0)
PlayWavE(0)
War.OldX=War.Person[War.SelID].x
War.OldY=War.Person[War.SelID].y
War_MovePerson(War.MX,War.MY)
War.ControlStatus="actionMenu"
CleanWarMap(4,1)
end
elseif event==-1 then
PlayWavE(1)
War.SelID=0
War.ControlStatus="select"
CleanWarMap(4,1)
CleanWarMap(10,0)
end
elseif War.ControlStatus=="actionMenu" then
local scl=War.SelID
local pid=War.Person[scl].id
BoxBack()
local menux,menuy=0,0
local mx=War.Person[War.SelID].x
local my=War.Person[War.SelID].y
if mx-War.CX>math.modf(War.MW/2) then
menux=16+War.BoxWidth*(mx-War.CX)-80
else
menux=16+War.BoxWidth*(mx-War.CX+1)
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
local menu_num=4
if CC.RWTS then
m[7][3]=1
m[8][3]=1
m[9][3]=1
m[10][3]=1
menu_num=menu_num+3
end
if (between(War.Person[scl].bz,4,6) or War.Person[scl].bz==22) and CC.Enhancement and WarCheckSkill(scl,44) then--乱射
m[2][1]="　"..JY.Skill[44]["名称"]
m[2][3]=1
menu_num=menu_num+1
end
if not (between(War.Person[scl].bz,4,6) or between(War.Person[scl].bz,21,22)) and CC.Enhancement and WarCheckSkill(scl,48) then--乱舞
m[2][1]="　"..JY.Skill[48]["名称"]
if m[2][3]==0 then
menu_num=menu_num+1
end
m[2][3]=1
end
if CC.Enhancement and WarCheckSkill(scl,5) then--天变
m[3][3]=1
menu_num=menu_num+1
end
menuy=math.min(32+War.BoxDepth*(my-War.CY),CC.ScreenH-32-24*menu_num)
local r=WarShowMenu(m,#m,0,menux,menuy,0,0,1,1,16,M_White,M_White)
WarDelay(CC.WarDelay)
if r==1 then
WarSetAtkFW(War.SelID,War.Person[War.SelID].atkfw)
local eid=WarSelectAtk(false,11)
if eid>0 then
local xsgj=false
if CC.Enhancement and WarCheckSkill(eid,117) then
if JY.Person[War.Person[eid].id]["兵力"]>0 and (not War.Person[eid].troubled) then
if JY.Bingzhong[War.Person[eid].bz]["可反击"]==1 and JY.Bingzhong[War.Person[scl].bz]["被反击"]==1 then
xsgj=true
elseif CC.Enhancement then
if WarCheckSkill(eid,102) then--刘备装备雌雄双剑 被攻击时必定反击
xsgj=true
elseif WarCheckSkill(eid,42) then--反击(特技)
xsgj=true
end
end
end
end
if xsgj then
--检查是否在攻击范围内
xsgj=false
local xs_arrary=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,War.Person[eid].atkfw)
for n=1,xs_arrary.num do
if between(xs_arrary[n][1],1,War.Width) and between(xs_arrary[n][2],1,War.Depth) then
if GetWarMap(xs_arrary[n][1],xs_arrary[n][2],2)==scl then
xsgj=true
break
end
end
end
end
if xsgj then
--反击概率＝我军武将武力÷150
if CC.Enhancement and WarCheckSkill(eid,102) then--刘备装备雌雄双剑 被攻击时必定反击
WarAtk(eid,scl,1)
WarResetStatus(scl)
elseif CC.Enhancement and WarCheckSkill(eid,19) then--报复
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
WarAtk(eid,scl)
WarResetStatus(scl)
if JY.Person[War.Person[scl].id]["兵力"]>0 then
WarAtk(eid,scl)
WarResetStatus(scl)
end
elseif smfj==1 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
if JY.Person[War.Person[scl].id]["兵力"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
elseif smsh==1 then
WarAtk(eid,scl)
WarResetStatus(scl)
else
WarAtk(eid,scl,1)
WarResetStatus(scl)
end

if CC.Enhancement and WarCheckSkill(scl,103) and JY.Person[War.Person[scl].id]["兵力"]>0 then
WarAtk(scl,eid,1)
WarResetStatus(eid)
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
WarAtk(eid,scl)
WarResetStatus(scl)
if JY.Person[War.Person[scl].id]["兵力"]>0 then
WarAtk(eid,scl)
WarResetStatus(scl)
end
elseif smfj==1 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
if JY.Person[War.Person[scl].id]["兵力"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
elseif smsh==1 then
WarAtk(eid,scl)
WarResetStatus(scl)
else
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
if CC.Enhancement and WarCheckSkill(scl,103) and JY.Person[War.Person[scl].id]["兵力"]>0 then
WarAtk(scl,eid,1)
WarResetStatus(eid)
end
end
end
end
if JY.Person[War.Person[scl].id]["兵力"]>0 then
WarAtk(scl,eid)
WarResetStatus(eid)
end
--混乱攻击
if CC.Enhancement and WarCheckSkill(scl,116) then
if JY.Person[War.Person[eid].id]["兵力"]>0 then
War.Person[eid].troubled=true
War.Person[eid].action=7
WarDelay(2)
WarDrawStrBoxDelay(JY.Person[War.Person[eid].id]["姓名"].."混乱了！",M_White)
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
if CC.Enhancement and (JY.Person[pid]["武器"]==59 or WarCheckSkill(scl,114)) then--英雄之剑 穿刺攻击
local xx=War.Person[eid].x
local yy=War.Person[eid].y
local dx=mx-xx
local dy=my-yy
local eid2=0
if dx>0 and dy==0 then--先确定被攻击者在攻击者左边方向
if GetWarMap(xx-1,yy,2)>0 then--然后确认是被攻击者左边那一格的对象
eid2=GetWarMap(xx-1,yy,2)--获取这一格的人物id编号
if War.Person[eid].enemy==War.Person[eid2].enemy then--最后确定该人物与被攻击者同阵营
WarAtk(scl,eid2)--攻击
WarResetStatus(eid2)
end
end
end
if dx<0 and dy==0 and GetWarMap(xx+1,yy,2)>0 then--右
eid2=GetWarMap(xx+1,yy,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx==0 and dy>0 and GetWarMap(xx,yy-1,2)>0 then--上
eid2=GetWarMap(xx,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx==0 and dy<0 and GetWarMap(xx,yy+1,2)>0 then--下
eid2=GetWarMap(xx,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx>0 and dy>0 and GetWarMap(xx-1,yy-1,2)>0 and dx==dy then--左上
eid2=GetWarMap(xx-1,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx<0 and dy>0 and GetWarMap(xx+1,yy-1,2)>0 and dx==-(dy) then--右上
eid2=GetWarMap(xx+1,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx>0 and dy<0 and GetWarMap(xx-1,yy+1,2)>0 and -(dx)==dy then--左下
eid2=GetWarMap(xx-1,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx<0 and dy<0 and GetWarMap(xx+1,yy+1,2)>0 and dx==dy then--右下
eid2=GetWarMap(xx+1,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
end
--反击
local fsfj=false--装备青龙偃月刀的人不是关羽时封杀反击
if CC.Enhancement and WarCheckSkill(scl,105) then
fsfj=true
end
if JY.Person[War.Person[eid].id]["兵力"]>0 and (not War.Person[eid].troubled) and fsfj==false and xsgj==false then
--只有贼兵（山贼、恶贼、义贼）和武术家能反击敌军的物理攻击。
--攻击方兵种为骑兵、贼兵、猛兽兵团、武术家、异民族时，才可能产生反击。
--攻击方兵种为步兵、弓兵、军乐队、妖术师、运输队时，不可能发生反击。
--攻击方为新增兵种时，都可以产生反击
local fj_flag=false
if JY.Bingzhong[War.Person[eid].bz]["可反击"]==1 and JY.Bingzhong[War.Person[scl].bz]["被反击"]==1 then
fj_flag=true
elseif CC.Enhancement and WarCheckSkill(eid,102) then--刘备装备雌雄双剑 被攻击时必定反击
fj_flag=true
elseif CC.Enhancement and WarCheckSkill(eid,42) then--反击(特技)
fj_flag=true
end
if fj_flag then
--检查是否在攻击范围内
fj_flag=false
local fj_arrary=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,War.Person[eid].atkfw)
for n=1,fj_arrary.num do
if between(fj_arrary[n][1],1,War.Width) and between(fj_arrary[n][2],1,War.Depth) then
if GetWarMap(fj_arrary[n][1],fj_arrary[n][2],2)==scl then
fj_flag=true
break
end
end
end
end
if fj_flag then
--反击概率＝我军武将武力÷150
if CC.Enhancement and WarCheckSkill(eid,102) then--刘备装备雌雄双剑 被攻击时必定反击
WarAtk(eid,scl,1)
WarResetStatus(scl)
elseif CC.Enhancement and WarCheckSkill(eid,19) then--报复
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
WarAtk(eid,scl)
WarResetStatus(scl)
if JY.Person[War.Person[scl].id]["兵力"]>0 then
WarAtk(eid,scl)
WarResetStatus(scl)
end
elseif smfj==1 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
if JY.Person[War.Person[scl].id]["兵力"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
elseif smsh==1 then
WarAtk(eid,scl)
WarResetStatus(scl)
else
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
if CC.Enhancement and WarCheckSkill(scl,103) and JY.Person[War.Person[scl].id]["兵力"]>0 then
WarAtk(scl,eid,1)
WarResetStatus(eid)
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
WarAtk(eid,scl)
WarResetStatus(scl)
if JY.Person[War.Person[scl].id]["兵力"]>0 then
WarAtk(eid,scl)
WarResetStatus(scl)
end
elseif smfj==1 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
if JY.Person[War.Person[scl].id]["兵力"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
elseif smsh==1 then
WarAtk(eid,scl)
WarResetStatus(scl)
else
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
if CC.Enhancement and WarCheckSkill(scl,103) and JY.Person[War.Person[scl].id]["兵力"]>0 then
WarAtk(scl,eid,1)
WarResetStatus(eid)
end
end
end
end
end
if War.Person[scl].live then
War.Person[scl].active=false
War.Person[scl].action=0
end
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
return CheckActive()
end
elseif r==2 then
local skillid=44
if m[2][1]=="　"..JY.Skill[48]["名称"] then
skillid=48
end
WarSetAtkFW(scl,War.Person[scl].atkfw)
WarDelay(CC.WarDelay)
if WarDrawStrBoxYesNo(string.format("%s将使用技能『%s』，可以吗？",JY.Person[pid]["姓名"],JY.Skill[skillid]["名称"]),M_White) then
CleanWarMap(4,1)
local atkarray=WarGetAtkFW(War.Person[scl].x,War.Person[scl].y,War.Person[scl].atkfw)
local eidarray={}
local eidnum=0
for i=1,atkarray.num do
local ex=atkarray[i][1]
local ey=atkarray[i][2]
if between(ex,1,War.Width) and between(ey,1,War.Depth) then
local eid=GetWarMap(ex,ey,2)
if eid>0 then
if War.Person[scl].enemy~=War.Person[eid].enemy then
if (not War.Person[eid].hide) and War.Person[eid].live then
eidnum=eidnum+1
eidarray[eidnum]=eid
end
end
end
end
end
if eidnum==0 then
PlayWavE(2)
WarDrawStrBoxWaitKey('攻击范围内没有敌军．',M_White)
else
local n=math.random(2)
if skillid==44 then--乱射
n=n+math.modf(eidnum/2)+math.random(3)-math.random(4)
elseif skillid==48 then--乱舞
n=n+eidnum-1+math.random(3)-math.random(4)
end
n=limitX(n,2,JY.Skill[skillid]["参数1"])
for t=1,n do
local eid,index
if eidnum==0 then
break
elseif eidnum==1 then
index=1
else
index=math.random(eidnum)
end
eid=eidarray[index]
if War.Person[eid].live and War.Person[scl].live and (not War.Person[scl].troubled) then
if skillid==44 then--乱射
WarAtk(scl,eid,2)
elseif skillid==48 then--乱舞
WarAtk(scl,eid,3)
end
WarResetStatus(eid)
end
if not War.Person[eid].live then
table.remove(eidarray,index)
eidnum=eidnum-1
end
end
if War.Person[scl].live then
War.Person[scl].active=false
War.Person[scl].action=0
end
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
return CheckActive()
end
else
CleanWarMap(4,1)
end
elseif r==3 then
WarDelay(CC.WarDelay)
if WarDrawStrBoxYesNo(JY.Person[pid]["姓名"].."将使用技能『天变』，可以吗？",M_White) then
local wzmenu={
{"　 晴",nil,1},
{"　 雲",nil,1},
{"　 雨",nil,1},
}
if between(War.Weather,0,2) then
wzmenu[1][3]=0
elseif between(War.Weather,4,5) then
wzmenu[3][3]=0
else
wzmenu[2][3]=0
end
local r=ShowMenu(wzmenu,3,0,0,0,0,0,1,1,16,M_White,M_White)
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
talk(pid,str1[math.random(5)])
else
talk(pid,str1[math.random(3)])
end
if math.random(100)<JY.Person[pid]["智力2"] then
if r==1 then
War.Weather=math.random(3)-1
elseif r==2 then
War.Weather=3
else
War.Weather=math.random(2)+3
end
PlayWavE(11)
WarDrawStrBoxWaitKey('成功了．',M_White)
if r==3 then
talk(pid,str2[math.random(5)])
else
talk(pid,str2[math.random(3)])
end
else
PlayWavE(2)
WarDrawStrBoxWaitKey('失败了．',M_White)
end
WarAddExp(scl,8)
War.Person[scl].active=false
War.Person[scl].action=0
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
return CheckActive()
end
end
elseif r==4 then
War.Person[scl].active=false
War.Person[scl].action=0
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
WarDelay(CC.WarDelay)
return CheckActive()
elseif r==5 then
War.Person[scl].active=false
War.Person[scl].action=0
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
WarDelay(CC.WarDelay)
return CheckActive()
elseif r==6 then
War.Person[scl].active=false
War.Person[scl].action=0
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
WarDelay(CC.WarDelay)
return CheckActive()
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
local bz=War.Person[scl].bz
local bzmenu={}
for index=1,JY.BingzhongNum-1 do
 bzmenu[index]={fillblank(JY.Bingzhong[index]["名称"],11),nil,0}
if JY.Bingzhong[index]["有效"]==1 then
 bzmenu[index][3]=1
end
end
local r=ShowMenu(bzmenu,JY.BingzhongNum-1,8,0,0,0,0,6,1,16,M_White,M_White)
if r>0 then
bz=r
local x=145
local y=CC.ScreenH/2
local size=16
lib.PicLoadCache(4,50*2,x,y,1)
DrawString(x+16,y+16,JY.Bingzhong[bz]["名称"],C_Name,size)
DrawStr(x+16,y+36,GenTalkString(JY.Bingzhong[bz]["说明"],18),M_White,size)
if talkYesNo(War.Person[War.SelID].id,"转职为"..JY.Bingzhong[bz]["名称"].."，*可以吗？") then
WarBingZhongUp(War.SelID,bz)
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
local rr=ShowMenu(wp,#wp,8,0,0,0,0,6,1,16,M_White,M_White)
if rr>0 then
local x=145
local y=CC.ScreenH/2
local size=16
lib.PicLoadCache(4,50*2,x,y,1)
DrawString(x+16,y+16,JY.Item[rr]["名称"],C_Name,size)
DrawStr(x+16,y+36,GenTalkString(JY.Item[rr]["说明"],18),M_White,size)
if talkYesNo(War.Person[War.SelID].id,"得到"..JY.Item[rr]["名称"].."，*可以吗？") then
for i=1,8 do
if JY.Person[War.Person[War.SelID].id]["道具"..i]==0 then
JY.Person[War.Person[War.SelID].id]["道具"..i]=rr
break
end
if i==8 and JY.Person[War.Person[War.SelID].id]["道具"..i]>0 then
WarDrawStrBoxWaitKey('道具已满',M_White)
end
end
end
end
elseif r==0 then
CleanWarMap(4,1)
CleanWarMap(10,0)
SetWarMap(War.Person[scl].x,War.Person[scl].y,2,0)
SetWarMap(War.OldX,War.OldY,2,War.SelID)
War.Person[scl].x=War.OldX
War.Person[scl].y=War.OldY
BoxBack()
ReSetAttrib(pid,false)
War.SelID=0
War.ControlStatus="select"
end
else--异常控制状态回复
War.ControlStatus="select"
end
return false
end

function WarSelectAtk(flag,fw)
--flag true: select us or friend
--flag fasle: select enemy
flag=flag or false
fw=fw or 0
War.ControlStatus="selectAtk"
local tmp=JY.MenuPic.num
JY.MenuPic.num=0
while true do
JY.ReFreshTime=lib.GetTime()
DrawWarMap(War.CX,War.CY)
ReFresh()
local event,x,y=control()
if event==1 then
CleanWarMap(10,0)
if GetWarMap(War.MX,War.MY,4)>0 and fw>0 then
local array=WarGetAtkFW(War.MX,War.MY,fw)
for i=1,array.num do
local mx,my=array[i][1],array[i][2]
if between(mx,1,War.Width) and between(my,1,War.Depth) then
if flag then
SetWarMap(mx,my,10,2)
else
SetWarMap(mx,my,10,1)
end
end
end
end
elseif event==2 then
--if not War.InMap then--地图范围外
if GetWarMap(War.MX,War.MY,4)>0 then
local eid=GetWarMap(War.MX,War.MY,2)
if eid>0 then--and eid~=War.SelID then
if flag then--select us or friend
if War.Person[eid].enemy==War.Person[War.SelID].enemy then
PlayWavE(0)
CleanWarMap(4,1)
CleanWarMap(10,0)
BoxBack()
JY.MenuPic.num=tmp
return eid
else
PlayWavE(2)
WarDrawStrBoxWaitKey('是敌方部队．',M_White)
end
else--select enemy
if War.Person[eid].enemy~=War.Person[War.SelID].enemy then
PlayWavE(0)
CleanWarMap(4,1)
CleanWarMap(10,0)
BoxBack()
JY.MenuPic.num=tmp
return eid
else
PlayWavE(2)
WarDrawStrBoxWaitKey('不能攻击我方．',M_White)
end
end
else
PlayWavE(2)
--WarDrawStrBoxWaitKey('没有敌人．',M_White)
end
else
PlayWavE(2)
if flag then
WarDrawStrBoxWaitKey('不在范围内．',M_White)
else
WarDrawStrBoxWaitKey('不在攻击范围内．',M_White)
end
end
elseif event==-1 then
PlayWavE(1)
CleanWarMap(4,1)
CleanWarMap(10,0)
BoxBack()
JY.MenuPic.num=tmp
War.ControlStatus="actionMenu"
return 0
end
end
JY.MenuPic.num=tmp
end

function WarCheckDX()
local menux,menuy
local dx=GetWarMap(War.MX,War.MY,1)
if War.MX-War.CX>math.modf(War.MW/2) then
menux=16+War.BoxWidth*(War.MX-War.CX)-136
else
menux=16+War.BoxWidth*(War.MX-War.CX+1)
end
if War.MY-War.CY>math.modf(War.MD/2) then
menuy=32+War.BoxWidth*(War.MY-War.CY)-40
else
menuy=32+War.BoxWidth*(War.MY-War.CY)
end
lib.Background(menux,menuy,menux+136,menuy+86,160)
menux=menux+8
menuy=menuy+8
lib.LoadSur(War.DXpic,menux,menuy)
DrawGameBox(menux,menuy,menux+War.BoxWidth,menuy+War.BoxDepth,M_White,-1)
DrawString(menux+56,menuy+8,"防御效果",M_White,16)
local T={[0]="０％","２０％","３０％","－％","０％","－％","０％","５％",
"５％","－％","－％","０％","－％","３０％","１０％","０％",
"０％","－％","－％","－％",}
DrawString(menux+88-#T[dx]*4,menuy+32,T[dx],M_White,16)
--森林 20 山地 30 村庄 5
--草原 5 鹿寨 30 兵营 10
-- 00 平原 01 森林 02 山地 03 河流 04 桥梁 05 城墙 06 城池 07 草原
-- 08 村庄 09 悬崖 0A 城门 0B 荒地 0C 栅栏 0D 鹿砦 0E 兵营 0F 粮仓
-- 10 宝物库 11 房舍 12 火焰 13 浊流
DrawString(menux,menuy+56,War.DX[dx],M_White,16)
if dx==8 or dx==13 or dx==14 then
DrawString(menux+56,menuy+56,"有恢复",M_White,16)
end
--村庄、鹿砦可以恢复士气和兵力．兵营可以恢复兵力，但不能恢复士气．
--玉玺可以恢复兵力和士气，援军报告可以恢复兵力，赦命书可以恢复士气．
--地形和宝物的恢复能力不能叠加，也就是说，处于村庄地形上再持有恢复性宝物，与没有持有恢复性宝物效果相同．但如果地形只能恢复兵力（如兵营），但宝物可以恢复兵力，这种情况下，兵力士气都能得到自动恢复．
end

function fillblank(s,num)
local len=num-string.len(s)
if len<=0 then
return string.sub(s,1,num)
else
local left,right
left=math.modf(len/2)
right=len-left
return string.format(string.format("%%%ds%%s%%%ds",left,right),"",s,"")
end
end

--使用策略
function WarMagicMenu()
local id=War.SelID
local pid=War.Person[id].id
local bz=JY.Person[pid]["兵种"]
local lv=JY.Person[pid]["等级"]
local menux,menuy=0,0
local menu_off=16
local mx=War.Person[id].x
local my=War.Person[id].y
if mx-War.CX>math.modf(War.MW/2) then
menux=16+War.BoxWidth*(mx-War.CX)-104-menu_off
else
menux=16+War.BoxWidth*(mx-War.CX+1)+menu_off
end
local m={}
local n=0
local eid=0
local eid2=0
local eid3=0
local eid4=0
for i=1,JY.MagicNum-1 do
if CC.Enhancement and WarCheckSkill(id,101) then--策略模仿
if GetWarMap(mx-1,my,2)>0 then--左
eid=GetWarMap(mx-1,my,2)
end
if GetWarMap(mx+1,my,2)>0 then--右
eid2=GetWarMap(mx+1,my,2)
end
if GetWarMap(mx,my-1,2)>0 then--上
eid3=GetWarMap(mx,my-1,2)
end
if GetWarMap(mx,my+1,2)>0 then--下
eid4=GetWarMap(mx,my+1,2)
end
end
if WarHaveMagic(id,i) or eid>0 and WarHaveMagic(eid,i) or eid2>0 and WarHaveMagic(eid2,i) or eid3>0 and WarHaveMagic(eid3,i) or eid4>0 and WarHaveMagic(eid4,i) then
n=n+1
if CC.Enhancement and (JY.Person[pid]["武器"]==12 or WarCheckSkill(id,112)) then--七星剑 策略值消耗减半
m[i]={fillblank(JY.Magic[i]["名称"],8)..string.format("% 2d",math.modf(JY.Magic[i]["消耗"]/2)),nil,1}
else
m[i]={fillblank(JY.Magic[i]["名称"],8)..string.format("% 2d",JY.Magic[i]["消耗"]),nil,1}
end
else
m[i]={"",nil,0}
end
end
menuy=math.min(32+War.BoxDepth*(my-War.CY)+menu_off,CC.ScreenH-16-(16+8+20*math.min(n,8))-menu_off)
local r
if n==0 then
PlayWavE(2)
WarDrawStrBoxWaitKey("没有可用策略．",M_White)
return 0
elseif n<=8 then
r=WarShowMenu(m,JY.MagicNum-1,0,menux,menuy,0,0,5,1,16,M_White,M_White)
else
r=WarShowMenu(m,JY.MagicNum-1,8,menux,menuy,0,0,6,1,16,M_White,M_White)
end
if r>0 then
local clxh=JY.Magic[r]["消耗"]
if CC.Enhancement and (JY.Person[pid]["武器"]==12 or WarCheckSkill(id,112)) then--七星剑 策略值消耗减半
clxh=math.modf(clxh/2)
end
if JY.Person[pid]["策略"]<clxh then
PlayWavE(2)
WarDrawStrBoxWaitKey("策略值不足．",M_White)
else
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
if WarMagicMenu_sub(id,r,false) then
if CC.Enhancement and (JY.Person[pid]["武器"]==12 or WarCheckSkill(id,112)) then--七星剑 策略值消耗减半
JY.Person[pid]["策略"]=JY.Person[pid]["策略"]-math.modf(JY.Magic[r]["消耗"]/2)
else
JY.Person[pid]["策略"]=JY.Person[pid]["策略"]-JY.Magic[r]["消耗"]
end
JY.MenuPic.num=MenuPicNum
return 1
end
JY.MenuPic.num=MenuPicNum
end
end
return 0
end

function WarMagicMenu_sub(id,r,ItemFlag)
local kind=JY.Magic[r]["类型"]
if kind==1 then--火系
if between(War.Weather,4,5) then
WarDrawStrBoxConfirm("雨天不能使用火攻．",M_White)
else
WarDrawStrBoxDelay("用火攻攻击敌人．",M_White)
WarSetAtkFW(id,JY.Magic[r]["施展范围"])
local eid=WarSelectAtk(false,JY.Magic[r]["效果范围"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["名称"].."之计",M_White)
WarMagic(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["效果范围"]==11 then
if JY.Person[War.Person[eid].id]["兵力"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("敌人在森林、草原、平原、城池，*存在的场合才能使用．",M_White)
end
end
end
elseif kind==2 then--水系
WarDrawStrBoxDelay("用水攻攻击敌人．",M_White)
WarSetAtkFW(id,JY.Magic[r]["施展范围"])
local eid=WarSelectAtk(false,JY.Magic[r]["效果范围"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["名称"].."之计",M_White)
WarMagic(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["效果范围"]==11 then
if JY.Person[War.Person[eid].id]["兵力"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("敌人在桥梁、平原，*存在的场合才能使用．",M_White)
end
end
elseif kind==3 then--落石系
WarDrawStrBoxDelay("用落石攻击敌人．",M_White)
WarSetAtkFW(id,JY.Magic[r]["施展范围"])
local eid=WarSelectAtk(false,JY.Magic[r]["效果范围"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["名称"].."之计",M_White)
WarMagic(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["效果范围"]==11 then
if JY.Person[War.Person[eid].id]["兵力"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("敌人在山地、荒地，*存在的场合才能使用．",M_White)
end
end
elseif kind==4 then--假情报系
WarDrawStrBoxDelay("使敌人混乱．",M_White)
WarSetAtkFW(id,JY.Magic[r]["施展范围"])
local eid=WarSelectAtk(false,JY.Magic[r]["效果范围"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
WarMagic(id,eid,r,ItemFlag)
return true
end
elseif kind==5 then--牵制系
WarDrawStrBoxDelay("重挫敌人士气．",M_White)
WarSetAtkFW(id,JY.Magic[r]["施展范围"])
local eid=WarSelectAtk(false,JY.Magic[r]["效果范围"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
WarMagic(id,eid,r,ItemFlag)
return true
end
elseif kind==6 then--激励系
WarDrawStrBoxDelay("恢复士气值．",M_White)
--恢复范围内的士气值部队．
WarSetAtkFW(id,JY.Magic[r]["施展范围"])
local eid=WarSelectAtk(true,JY.Magic[r]["效果范围"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
WarMagic(id,eid,r,ItemFlag)
return true
end
elseif kind==7 then--援助系
WarDrawStrBoxDelay("恢复兵力．",M_White)
--恢复范围内的兵力部队
WarSetAtkFW(id,JY.Magic[r]["施展范围"])
local eid=WarSelectAtk(true,JY.Magic[r]["效果范围"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
WarMagic(id,eid,r,ItemFlag)
return true
end
elseif kind==8 then--看护系
WarDrawStrBoxDelay("恢复兵力和士气值．",M_White)
WarSetAtkFW(id,JY.Magic[r]["施展范围"])
local eid=WarSelectAtk(true,JY.Magic[r]["效果范围"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
WarMagic(id,eid,r,ItemFlag)
return true
end
elseif kind==9 then--毒系
WarDrawStrBoxDelay("用毒攻击敌人．",M_White)
WarSetAtkFW(id,JY.Magic[r]["施展范围"])
local eid=WarSelectAtk(false,JY.Magic[r]["效果范围"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["名称"].."之计",M_White)
WarMagic(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["效果范围"]==11 then
if JY.Person[War.Person[eid].id]["兵力"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("未知错误引起的无法使用．",M_White)
end
end
elseif kind==10 then--落雷系
if between(War.Weather,3,5) then
WarDrawStrBoxDelay("用落雷攻击敌人．",M_White)
WarSetAtkFW(id,JY.Magic[r]["施展范围"])
local eid=WarSelectAtk(false,JY.Magic[r]["效果范围"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["名称"].."之计",M_White)
WarMagic(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["效果范围"]==11 then
if JY.Person[War.Person[eid].id]["兵力"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("晴天不能使用落雷．",M_White)
end
end
else
WarDrawStrBoxConfirm("晴天不能使用落雷．",M_White)
end
elseif kind==11 then--炸弹
WarDrawStrBoxDelay("用炸弹攻击敌人．",M_White)
WarSetAtkFW(id,JY.Magic[r]["施展范围"])
local eid=WarSelectAtk(false,JY.Magic[r]["效果范围"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay("投掷炸弹．",M_White)
WarMagic(id,eid,r,ItemFlag)
return true
else
WarDrawStrBoxConfirm("未知错误引起的无法使用．",M_White)
end
end
end
return false
end

function WarMagicHitRatio(wid,eid,mid)
if between(JY.Magic[mid]["类型"],6,8) then
return 1
end
local p1=JY.Person[War.Person[wid].id]
local p2=JY.Person[War.Person[eid].id]
local a=p1["智力2"]*p1["等级"]/100+p1["智力2"]
local b=(p2["智力2"]*p2["等级"]/100+p2["智力2"])/4
if CC.Enhancement then
if JY.Magic[mid]["类型"]==2 and (WarCheckSkill(eid,3) or WarCheckSkill(eid,23)) then--水神/藤甲
a=1
b=2
end
if JY.Magic[mid]["类型"]==1 and WarCheckSkill(eid,4) then--火神
a=1
b=2
end
if JY.Magic[mid]["类型"]==4 and WarCheckSkill(eid,20) then--沉着
a=1
b=2
end
if WarCheckSkill(wid,17) then--神算
a=a*2
end
if WarCheckSkill(eid,18) then--识破
b=b*2
end
end
if JY.Magic[mid]["类型"]==4 then
b=b*2
end
if p2["兵种"]==13 or p2["兵种"]==16 or p2["兵种"]==19 then
b=b*1.5
end
local v=1-b/a
v=limitX(v,0,1)
return v
end

--策略使用效果
function WarMagic(wid,eid,mid,ItemFlag)
War.ControlStatus="actionMenu"
ItemFlag=ItemFlag or false
local mx=War.Person[eid].x
local my=War.Person[eid].y
local d1,d2=WarAutoD(wid,eid)
local atkarray=WarGetAtkFW(mx,my,JY.Magic[mid]["效果范围"])
War.Person[wid].action=2
War.Person[wid].frame=0
War.Person[wid].d=d1
WarDelay(4)
PlayWavE(8)
WarDelay(8)
PlayWavE(39)
WarDelay(12)
War.Person[wid].action=0
for i=atkarray.num,1,-1 do
local x,y=atkarray[i][1],atkarray[i][2]
local id=GetWarMap(x,y,2)
if id>0 and War.Person[id].live and (not War.Person[id].hide) then
if War.Person[id].enemy==War.Person[eid].enemy then
else
table.remove(atkarray,i)
atkarray.num=atkarray.num-1
end
else
table.remove(atkarray,i)
atkarray.num=atkarray.num-1
end
end
for i=1,atkarray.num do
local x,y=atkarray[i][1],atkarray[i][2]
local id=GetWarMap(x,y,2)
if id>0 and War.Person[id].live and (not War.Person[id].hide) then--table.remove后必然为true
if War.Person[id].enemy==War.Person[eid].enemy then--table.remove后必然为true
local id1=War.Person[wid].id
local id2=War.Person[id].id
local hitratio=WarMagicHitRatio(wid,id,mid)
if ItemFlag then
hitratio=1
end
local hurt,sq_hurt,jy,jy2=WarMagicHurt(wid,id,mid,ItemFlag)
d1,d2=WarAutoD(wid,id)
if between(JY.Magic[mid]["类型"],6,8) then
if JY.Magic[mid]["类型"]==6 then
--基本士气恢复值＝策略基本威力＋补给方等级÷10
--士气恢复随机修正值是一个随机整数，在0到（基本士气恢复值÷10－1）之间。
--补给效果＝基本士气恢复值＋士气恢复随机修正值
if ItemFlag then
sq_hurt=JY.Magic[mid]["效果"]
else
sq_hurt=JY.Magic[mid]["效果"]+JY.Person[id1]["等级"]/10
end
sq_hurt=math.modf(sq_hurt*(1+math.random()/10))
sq_hurt=limitX(sq_hurt,0,War.Person[id].sq_limited-JY.Person[id2]["士气"])
hurt=-1
if atkarray.num==1 then
WarDrawStrBoxDelay(JY.Person[id2]["姓名"].."的士气值上升．",M_White)
end
elseif JY.Magic[mid]["类型"]==7 then
--基本兵力恢复值＝策略基本威力＋补给方智力×补给方等级÷20
--兵力恢复随机修正值是一个随机整数，在0到（基本兵力恢复值÷10－1）之间。
--补给效果＝基本兵力恢复值＋兵力恢复随机修正值
if ItemFlag then
hurt=JY.Magic[mid]["效果"]
else
hurt=JY.Magic[mid]["效果"]+JY.Person[id1]["智力2"]*JY.Person[id1]["等级"]/20
if CC.Enhancement then
if WarCheckSkill(eid,41) then--补给
hurt=math.modf(hurt*(100+JY.Skill[41]["参数1"])/100)
end
end
end
hurt=math.modf(hurt*(1+math.random()/10))
hurt=limitX(hurt,0,JY.Person[id2]["最大兵力"]-JY.Person[id2]["兵力"])
sq_hurt=-1
if atkarray.num==1 then
WarDrawStrBoxDelay(JY.Person[id2]["姓名"].."的兵力上升．",M_White)
end
elseif JY.Magic[mid]["类型"]==8 then
local hp={600,1200,1800}
local sp={30,40,50}
if ItemFlag then
hurt=hp[JY.Magic[mid]["效果"]]
sq_hurt=sp[JY.Magic[mid]["效果"]]
else
hurt=hp[JY.Magic[mid]["效果"]]+JY.Person[id1]["智力2"]*JY.Person[id1]["等级"]/20
sq_hurt=sp[JY.Magic[mid]["效果"]]+JY.Person[id1]["等级"]/10
if CC.Enhancement then
if WarCheckSkill(eid,41) then--补给
hurt=math.modf(hurt*(100+JY.Skill[41]["参数1"])/100)
end
end
end
hurt=math.modf(hurt*(1+math.random()/10))
hurt=limitX(hurt,0,JY.Person[id2]["最大兵力"]-JY.Person[id2]["兵力"])
sq_hurt=math.modf(sq_hurt*(1+math.random()/10))
sq_hurt=limitX(sq_hurt,0,War.Person[id].sq_limited-JY.Person[id2]["士气"])
if atkarray.num==1 then
WarDrawStrBoxDelay(JY.Person[id2]["姓名"].."的兵力和士气值上升．",M_White)
end
end
PlayMagic(mid,x,y,id1)
if hurt>=0 then
War.Person[id].hurt=hurt
WarDelay(8)
War.Person[id].hurt=-1
end
if sq_hurt>=0 then
War.Person[id].hurt=sq_hurt
WarDelay(8)
War.Person[id].hurt=-1
end
local t=16
t=math.min(16,(math.modf(math.max( 2,math.abs(hurt)/50,math.abs(sq_hurt)))))
local oldbl=JY.Person[id2]["兵力"]
local oldsq=JY.Person[id2]["士气"]
for ii=0,t do
if hurt>0 then
JY.Person[id2]["兵力"]=oldbl+hurt*ii/t
end
if sq_hurt>0 then
JY.Person[id2]["士气"]=oldsq+sq_hurt*ii/t
end
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawStatusMini(id)
lib.GetKey()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*4)
WarDelay(4)
if JY.Magic[mid]["类型"]==6 or JY.Magic[mid]["类型"]==8 then
WarTroubleShooting(id)
end
if i==atkarray.num then
if atkarray.num>1 then
if JY.Magic[mid]["类型"]==6 then
if War.Person[id].enemy then
WarDrawStrBoxDelay("敌军的士气值恢复了．",M_White)
else
WarDrawStrBoxDelay("我军的士气值恢复了．",M_White)
end
elseif JY.Magic[mid]["类型"]==7 then
if War.Person[id].enemy then
WarDrawStrBoxDelay("敌军的兵力恢复了．",M_White)
else
WarDrawStrBoxDelay("我军的兵力恢复了．",M_White)
end
elseif JY.Magic[mid]["类型"]==8 then
if War.Person[id].enemy then
WarDrawStrBoxDelay("敌军的兵力和士气值恢复了．",M_White)
else
WarDrawStrBoxDelay("我军的兵力和士气值恢复了．",M_White)
end
end
end
jy=8
if CC.Enhancement then
jy=JY.Magic[mid]["消耗"]
end
if (JY.Person[id1]["兵种"]==13 or JY.Person[id1]["兵种"]==19) then
jy=math.modf(jy*2)
end
if not (War.Person[wid].enemy or ItemFlag) then
WarAddExp(wid,jy)
end
end
ReSetAttrib(id1,false)
ReSetAttrib(id2,false)
WarResetStatus(id)
elseif JY.Magic[mid]["类型"]==4 then--假情报系
jy=8
if CC.Enhancement then
jy=JY.Magic[mid]["消耗"]
end
if math.random()<hitratio then
War.Person[id].action=4
War.Person[id].frame=0
War.Person[id].d=d2
PlayMagic(mid,x,y,id1)
War.Person[id].hurt=-1
if War.Person[id].troubled then
WarDelay(2)
WarDrawStrBoxDelay(JY.Person[id2]["姓名"].."更加混乱了！",M_White)
else
War.Person[id].troubled=true
War.Person[id].action=7
WarDelay(2)
WarDrawStrBoxDelay(JY.Person[id2]["姓名"].."混乱了！",M_White)
end
else
War.Person[id].action=3
War.Person[id].frame=0
War.Person[id].d=d2
PlayMagic(mid,x,y,id1)
PlayWavE(81)
WarDelay(8)
War.Person[id].hurt=-1
WarDrawStrBoxDelay(JY.Person[id1]["姓名"].."的计谋失败了！",M_White)
end
if i==atkarray.num then
if not (War.Person[wid].enemy or ItemFlag) then
WarAddExp(wid,jy)
end
end
ReSetAttrib(id1,false)
ReSetAttrib(id2,false)
WarResetStatus(id)
elseif JY.Magic[mid]["类型"]==5 then--牵制系
jy=8
if CC.Enhancement then
jy=JY.Magic[mid]["消耗"]
end
if math.random()<hitratio then
hurt=0
--士气损伤＝策略基本士气损伤＋攻击方等级÷10－防御方等级÷10
if ItemFlag then
sq_hurt=math.modf(JY.Magic[mid]["效果"]-JY.Person[id2]["等级"]/10)
else
sq_hurt=math.modf(JY.Magic[mid]["效果"]+JY.Person[id1]["等级"]/10-JY.Person[id2]["等级"]/10)
end
sq_hurt=limitX(sq_hurt,0,JY.Person[id2]["士气"])
War.Person[id].action=4
War.Person[id].frame=0
War.Person[id].d=d2
WarDrawStrBoxDelay(JY.Person[id2]["姓名"].."的士气值下降．",M_White)
PlayMagic(mid,x,y,id1)
War.Person[id].hurt=sq_hurt
WarDelay(8)
War.Person[id].hurt=-1
local t=16
t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/50,math.abs(sq_hurt)))))
local oldbl=JY.Person[id2]["兵力"]
local oldsq=JY.Person[id2]["士气"]
for i=1,t do
JY.Person[id2]["兵力"]=oldbl-hurt*i/t
JY.Person[id2]["士气"]=oldsq-sq_hurt*i/t
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawStatusMini(eid)
lib.GetKey()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*4)
WarDelay(4)
WarGetTrouble(id)
else
War.Person[id].action=3
War.Person[id].frame=0
War.Person[id].d=d2
PlayMagic(mid,x,y,id1)
War.Person[id].hurt=0
PlayWavE(81)
WarDelay(8)
War.Person[id].hurt=-1
WarDrawStrBoxDelay(JY.Person[id1]["姓名"].."的计谋失败了！",M_White)
end
if i==atkarray.num then
if not (War.Person[wid].enemy or ItemFlag) then
WarAddExp(wid,jy)
end
end
ReSetAttrib(id1,false)
ReSetAttrib(id2,false)
WarResetStatus(id)
elseif WarMagicCheck(wid,id,mid) then
if math.random()<hitratio then
War.Person[id].action=4
War.Person[id].frame=0
War.Person[id].d=d2
PlayMagic(mid,x,y,id1)
War.Person[id].hurt=hurt
WarDelay(8)
War.Person[id].hurt=-1
local t=16
t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/50,math.abs(sq_hurt)))))
local oldbl=JY.Person[id2]["兵力"]
local oldsq=JY.Person[id2]["士气"]
for i=1,t do
JY.Person[id2]["兵力"]=oldbl-hurt*i/t
JY.Person[id2]["士气"]=oldsq-sq_hurt*i/t
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawStatusMini(id)
lib.GetKey()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*4)
WarDelay(4)
WarGetTrouble(id)
if CC.Enhancement then
if JY.Magic[mid]["类型"]==3 then--落石系
if WarCheckSkill(wid,15) then--落沙
if math.random(100)<=JY.Skill[15]["参数1"] then
if JY.Person[id2]["兵力"]>0 then
if not War.Person[id].troubled then
War.Person[id].troubled=true
War.Person[id].action=7
WarDelay(2)
WarDrawStrBoxDelay(JY.Person[id2]["姓名"].."混乱了！",M_White)
end
end
end
end
end
end
if not (War.Person[wid].enemy) then
WarAddExp(wid,jy)
if CC.Enhancement then
local id1=War.Person[wid].id
if JY.Person[id1]["智力"]<100 and (not War.Person[wid].enemy) then
JY.Person[id1]["智力经验"]=JY.Person[id1]["智力经验"]+2
if JY.Person[id1]["智力经验"]>=200 then
JY.Person[id1]["智力经验"]=JY.Person[id1]["智力经验"]-200
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[wid].action
--转圈，升级动作
War.Person[wid].action=0
for t=1,2 do
War.Person[wid].d=3
WarDelay(3)
War.Person[wid].d=2
WarDelay(3)
War.Person[wid].d=4
WarDelay(3)
War.Person[wid].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[wid].action=6
for i=0,256,8 do
War.Person[wid].effect=i
WarDelay(1)
end
for i=240,0,-8 do
War.Person[wid].effect=i
WarDelay(1)
end
WarDrawStrBoxWaitKey(JY.Person[id1]["姓名"].."成功凝练出一枚智力种",M_White)
ReSetAttrib(id1,false)
War.Person[wid].action=oldaction
JY.MenuPic.num=MenuPicNum
for n=1,8 do
if JY.Person[id1]["道具"..n]==0 then
JY.Person[id1]["道具"..n]=72
break
end
end
end
end
end
end
ReSetAttrib(id1,false)
ReSetAttrib(id2,false)
WarResetStatus(id)
else
War.Person[id].action=3
War.Person[id].frame=0
War.Person[id].d=d2
PlayMagic(mid,x,y,id1)
War.Person[id].hurt=0
PlayWavE(81)
WarDelay(8)
War.Person[id].hurt=-1
if not (War.Person[wid].enemy) then
WarAddExp(wid,jy2)
local id1=War.Person[wid].id
if CC.Enhancement and JY.Person[id1]["智力"]<100 and (not War.Person[wid].enemy) then
JY.Person[id1]["智力经验"]=JY.Person[id1]["智力经验"]+1
if JY.Person[id1]["智力经验"]>=200 then
JY.Person[id1]["智力经验"]=JY.Person[id1]["智力经验"]-200
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[wid].action
--转圈，升级动作
War.Person[wid].action=0
for t=1,2 do
War.Person[wid].d=3
WarDelay(3)
War.Person[wid].d=2
WarDelay(3)
War.Person[wid].d=4
WarDelay(3)
War.Person[wid].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[wid].action=6
for i=0,256,8 do
War.Person[wid].effect=i
WarDelay(1)
end
for i=240,0,-8 do
War.Person[wid].effect=i
WarDelay(1)
end
WarDrawStrBoxWaitKey(JY.Person[id1]["姓名"].."成功凝练出一枚智力种",M_White)
ReSetAttrib(id1,false)
War.Person[wid].action=oldaction
JY.MenuPic.num=MenuPicNum
for n=1,8 do
if JY.Person[id1]["道具"..n]==0 then
JY.Person[id1]["道具"..n]=72
break
end
end
end
end
end
ReSetAttrib(id1,false)
ReSetAttrib(id2,false)
WarResetStatus(id)
WarDrawStrBoxDelay(JY.Person[id1]["姓名"].."的计策失败了！",M_White)
end
end
end
end
end
WarResetStatus(wid)
end

function PlayMagic(mid,x,y,pid)
if CC.cldh==0 then
return
end
local eft=JY.Magic[mid]["动画"]
local pic_w,pic_h=lib.PicGetXY(0,eft*2)
local frame=pic_h/pic_w
if eft==241 then
frame=7
elseif eft==242 then
frame=13
elseif eft==243 then
frame=13
end
pic_h=pic_h/frame
local str=JY.Person[pid]["姓名"]..'的策略'
local sx,sy
sx=16+War.BoxWidth*(x-War.CX+0.5)-pic_w/2
sy=32+War.BoxDepth*(y-War.CY+1)-pic_h
PlayWavE(JY.Magic[mid]["音效"])
local rpt=2
if between(JY.Magic[mid]["类型"],4,8) then
rpt=1
end
for i=1,frame do
for n=1,rpt do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
lib.SetClip(sx,sy,sx+pic_w,sy+pic_h)
lib.PicLoadCache(0,eft*2,sx,sy-pic_h*(i-1),1)
lib.SetClip(0,0,0,0)
lib.GetKey()
ReFresh()
end
end
end

function WarMagicCheck(wid,eid,mid)
local kind=JY.Magic[mid]["类型"]
local dx=GetWarMap(War.Person[eid].x,War.Person[eid].y,1)
if between(kind,4,8) or kind==9 or kind==11 then
return true
end
if kind==1 and between(War.Weather,4,5) then
return false
end
if kind==10 and between(War.Weather,3,5) then
return true
end
if CC.Enhancement then
if WarCheckSkill(wid,46) then--地理
return true
end
end
if kind==1 and (dx==0 or dx==1 or dx==6 or dx==7) then
return true
end
if kind==2 and (dx==0 or dx==4) then
return true
end
if kind==3 and (dx==2 or dx==11) then
return true
end
return false
end

--策略伤害
function WarMagicHurt(wid,eid,mid,ItemFlag)
ItemFlag=ItemFlag or false
local id1=War.Person[wid].id
local id2=War.Person[eid].id
local p1=JY.Person[id1]
local p2=JY.Person[id2]
local hurt=JY.Magic[mid]["效果"]
if ItemFlag then
hurt=hurt-(p2["智力2"]*p2["等级"]/40+p2["智力2"])
else
hurt=hurt+(p1["智力2"]*p1["等级"]/40+p1["智力2"])*2-(p2["智力2"]*p2["等级"]/40+p2["智力2"])
end
if p2["兵种"]==13 or p2["兵种"]==16 or p2["兵种"]==19 then
hurt=hurt/2
end

--如果被防御方在树林中，且策略是焦热系策略
--策略攻击杀伤＝策略攻击杀伤＋策略攻击杀伤÷4
--如果当前天气是雨天，且策略是漩涡系策略
--策略攻击杀伤＝策略攻击杀伤＋策略攻击杀伤÷4

local dx=GetWarMap(War.Person[eid].x,War.Person[eid].y,1)
if JY.Magic[mid]["类型"]==1 and dx==1 then
hurt=hurt*1.25
end
if JY.Magic[mid]["类型"]==2 and between(War.Weather,4,5) then
hurt=hurt*1.25
end
if JY.Magic[mid]["类型"]==10 and between(War.Weather,4,5) then
hurt=hurt*1.1
end
local item_atk=0
if p1["武器"]>0 then
item_atk=item_atk+JY.Item[p1["武器"]]["策略攻击"]
end
if p1["防具"]>0 then
item_atk=item_atk+JY.Item[p1["防具"]]["策略攻击"]
end
if p1["辅助"]>0 then
item_atk=item_atk+JY.Item[p1["辅助"]]["策略攻击"]
end
if item_atk~=0 then
hurt=hurt*(100+item_atk)/100
end
if CC.Enhancement then
if JY.Magic[mid]["类型"]==1 and WarCheckSkill(wid,12) then--火计
hurt=hurt*(100+JY.Skill[12]["参数1"])/100
end
if JY.Magic[mid]["类型"]==2 and WarCheckSkill(wid,11) then--水计
hurt=hurt*(100+JY.Skill[11]["参数1"])/100
end
if JY.Magic[mid]["类型"]==3 and WarCheckSkill(wid,14) then--落石
hurt=hurt*(100+JY.Skill[14]["参数1"])/100
end
if (between(JY.Magic[mid]["类型"],1,3) or between(JY.Magic[mid]["类型"],9,10)) and WarCheckSkill(wid,39) then--毒计
hurt=hurt*(100+JY.Skill[39]["参数1"])/100
end
if (between(JY.Magic[mid]["类型"],1,3) or between(JY.Magic[mid]["类型"],9,10)) and WarCheckSkill(wid,50) then--深谋
hurt=hurt*(100+JY.Skill[50]["参数1"])/100
end
if JY.Magic[mid]["类型"]==1 and WarCheckSkill(eid,13) then--灭火
hurt=hurt*(100-JY.Skill[13]["参数1"])/100
end
if JY.Magic[mid]["类型"]==1 and WarCheckSkill(eid,4) then--火神
hurt=1
end
if JY.Magic[mid]["类型"]==2 and WarCheckSkill(eid,3) then--水神
hurt=1
end
if (between(JY.Magic[mid]["类型"],1,3) or between(JY.Magic[mid]["类型"],9,10)) then
if WarCheckSkill(eid,16) then--明镜
hurt=hurt*(100-JY.Skill[16]["参数1"])/100
end
if WarCheckSkill(eid,37) then--虎视
hurt=hurt*(100-JY.Skill[37]["参数1"])/100
end
end
if WarCheckSkill(eid,23) then--藤甲
if JY.Magic[mid]["类型"]==1 then
hurt=hurt*(100+JY.Skill[23]["参数2"])/100
end
if JY.Magic[mid]["类型"]==2 then
hurt=1
end
end
end
hurt=math.modf(hurt*(1+math.random()/50))
if hurt<1 then
hurt=1
end
-- 如果攻击伤害大于防御方兵力，则攻击伤害=防御方兵力
if hurt>p2["兵力"] then
hurt=p2["兵力"]
end
--士气降幅＝攻击伤害÷（防御方等级＋5）÷3
local sq_hurt=math.modf(hurt/(p2["等级"]+5)/3)
if sq_hurt==0 then
if hurt>0 then
sq_hurt=1
else
sq_hurt=0
end
end
sq_hurt=limitX(sq_hurt,0,p2["士气"])
--经验值获得
local jy=0
local jy2=0--策略失败时的经验
--敌军部队不能获得经验值．
if p1["等级"]<99 and (not War.Person[wid].enemy) then--and (not War.Person[wid].friend) then
--经验值由两部分构成：基本经验值和奖励经验值．
local part1,part2=0,0
--当攻击方等级低于等于防御方等级时：
if p1["等级"]<=p2["等级"] then
--基本经验值＝（防御方等级－攻击方等级＋3）×2
part1=(p2["等级"]-p1["等级"]+3)*2
--如果基本经验值大于16，则基本经验值＝16．
if part1>16 then
part1=16
end
--提高获取经验
if CC.Enhancement then
part1=(p2["等级"]-p1["等级"]+5)*2
if part1>24 then
part1=24
end
end
--当攻击方等级高于防御方等级时：
else
--基本经验值＝4
part1=4
if CC.Enhancement then
part1=8--提高获取经验
end
end
--如果杀死敌人，可以获得奖励经验值：
if hurt==p2["兵力"] then
--如果杀死敌军主将
if War.Person[eid].leader then
--奖励经验值＝48
part2=48
--如果杀死的不是敌军主将，且敌军等级高于我军
elseif p2["等级"]>p1["等级"] then
--奖励经验值＝32
part2=32
--如果杀死的不是敌军主将，且敌军等级低于等于我军
else
--奖励经验值＝64÷（攻击方等级－防御方等级＋2）
part2=math.modf(64/(p1["等级"]-p2["等级"]+2))
--提高获取经验
if CC.Enhancement then
part2=32-(p1["等级"]-p2["等级"])*4
part2=limitX(part2,8,48)
end
end
end
--最终获得的经验值＝基本经验值＋奖励经验值．
jy=part1+part2
jy2=part1
end
if JY.Magic[mid]["类型"]==11 then
hurt=limitX((math.random(15)+90)*15,0,p2["兵力"])
sq_hurt=limitX(math.random(10)+30,0,p2["士气"])
jy=0
jy2=0
end
return hurt,sq_hurt,jy,jy2
end

function WarItemMenu()
local id=War.SelID
local pid=War.Person[id].id
if JY.Person[pid]["道具1"]==0 then
WarDrawStrBoxWaitKey("没有道具！",M_White)
return
end
local menux,menuy=0,0
local menu_off=16
local mx=War.Person[id].x
local my=War.Person[id].y
if mx-War.CX>math.modf(War.MW/2) then
menux=16+War.BoxWidth*(mx-War.CX)-80-menu_off
else
menux=16+War.BoxWidth*(mx-War.CX+1)+menu_off
end
menuy=math.min(32+War.BoxDepth*(my-War.CY)+menu_off,CC.ScreenH-16-112-menu_off)
local m={
{"　使用",WarItemMenu_sub,1},
{"　交给",WarItemMenu_sub,1},
{"　丢掉",WarItemMenu_sub,1},
{"　观看",WarItemMenu_sub,1},
}
local r=WarShowMenu(m,4,0,menux,menuy,menux+80,menuy+112,1,1,16,M_White,M_White)
if r>0 then
return 1
else
return 0
end
end

function WarItemMenu_sub(kind)
local id=War.SelID
local pid=War.Person[id].id
local menux,menuy=0,0
local menu_off=16
local mx=War.Person[id].x
local my=War.Person[id].y
if mx-War.CX>math.modf(War.MW/2) then
menux=16+War.BoxWidth*(mx-War.CX)-80-menu_off*2
else
menux=16+War.BoxWidth*(mx-War.CX+1)+menu_off*2
end
menuy=math.min(12+War.BoxDepth*(my-War.CY)+menu_off*2,CC.ScreenH-16-132-menu_off*2)
local m={}
for i=1,8 do
local itemid=JY.Person[pid]["道具"..i]
if itemid>0 then
if kind==1 then
m[i]={fillblank(JY.Item[itemid]["名称"],10),Item_Use,1}
elseif kind==2 then
m[i]={fillblank(JY.Item[itemid]["名称"],10),Item_Send,1}
elseif kind==3 then
m[i]={fillblank(JY.Item[itemid]["名称"],10),Item_Scrap,1}
elseif kind==4 then
m[i]={fillblank(JY.Item[itemid]["名称"],10),Item_Check,1}
else
m[i]={fillblank(JY.Item[itemid]["名称"],10),nil,1}
end
else
m[i]={"",nil,0}
end
end
local r=WarShowMenu(m,8,0,menux,menuy,0,0,4,1,16,M_White,M_White)
if r>0 then
return 1
else
return 0
end
end

--使用道具
function Item_Use(i)
local id=War.SelID
local pid=War.Person[id].id
local itemid=JY.Person[pid]["道具"..i]
local kind=JY.Item[itemid]["类型"]
if between(kind,1,2) then
local mid=JY.Item[itemid]["效果"]
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
if WarMagicMenu_sub(id,mid,true) then
JY.MenuPic.num=MenuPicNum
for n=i,7 do
JY.Person[pid]["道具"..n]=JY.Person[pid]["道具"..(n+1)]
end
JY.Person[pid]["道具8"]=0
return 1
end
JY.MenuPic.num=MenuPicNum
elseif kind==3 then
if not WarDrawStrBoxYesNo(string.format('将部队变成%s．',JY.Bingzhong[JY.Item[itemid]["效果"]]["名称"]),M_White) then
return 0
elseif JY.Item[itemid]["需兵种"]>0 and JY.Person[pid]["兵种"]~=JY.Item[itemid]["需兵种"] then
PlayWavE(2)
WarDrawStrBoxDelay("需要"..JY.Bingzhong[JY.Item[itemid]["需兵种"]]["名称"].."．",M_White)
return 0
elseif JY.Person[pid]["等级"]<JY.Item[itemid]["需等级"] then
PlayWavE(2)
WarDrawStrBoxDelay("等级不足．",M_White)
return 0
else
WarBingZhongUp(War.SelID,JY.Item[itemid]["效果"])
for n=i,7 do
JY.Person[pid]["道具"..n]=JY.Person[pid]["道具"..(n+1)]
end
JY.Person[pid]["道具8"]=0
return 1
end
elseif kind==8 then--武力种
if not WarDrawStrBoxYesNo('提升武力值．',M_White) then
return 0
elseif JY.Person[pid]["武力"]>=100 then
PlayWavE(2)
WarDrawStrBoxDelay("无法提升．",M_White)
return 0
else
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[War.SelID].action
--使用物品动作
War.Person[War.SelID].action=0
War.Person[War.SelID].d=1
WarDelay(2)
PlayWavE(41)
War.Person[War.SelID].action=6
WarDelay(16)
--转圈，升级动作
War.Person[War.SelID].action=0
for t=1,2 do
War.Person[War.SelID].d=3
WarDelay(3)
War.Person[War.SelID].d=2
WarDelay(3)
War.Person[War.SelID].d=4
WarDelay(3)
War.Person[War.SelID].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[War.SelID].action=6
for i=0,256,8 do
War.Person[War.SelID].effect=i
WarDelay(1)
end
for i=240,0,-8 do
War.Person[War.SelID].effect=i
WarDelay(1)
end
JY.Person[pid]["武力"]=JY.Person[pid]["武力"]+1
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."的基础武力提升至"..JY.Person[pid]["武力"],M_White)
ReSetAttrib(pid,false)
War.Person[War.SelID].action=oldaction
JY.MenuPic.num=MenuPicNum
JY.Person[pid]["道具"..i]=0
for n=i,7 do
JY.Person[pid]["道具"..n]=JY.Person[pid]["道具"..(n+1)]
end
JY.Person[pid]["道具8"]=0
return 1
end
elseif kind==9 then--智力种
if not WarDrawStrBoxYesNo('提升智力值．',M_White) then
return 0
elseif JY.Person[pid]["智力"]>=100 then
PlayWavE(2)
WarDrawStrBoxDelay("无法提升．",M_White)
return 0
else
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[War.SelID].action
--使用物品动作
War.Person[War.SelID].action=0
War.Person[War.SelID].d=1
WarDelay(2)
PlayWavE(41)
War.Person[War.SelID].action=6
WarDelay(16)
--转圈，升级动作
War.Person[War.SelID].action=0
for t=1,2 do
War.Person[War.SelID].d=3
WarDelay(3)
War.Person[War.SelID].d=2
WarDelay(3)
War.Person[War.SelID].d=4
WarDelay(3)
War.Person[War.SelID].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[War.SelID].action=6
for i=0,256,8 do
War.Person[War.SelID].effect=i
WarDelay(1)
end
for i=240,0,-8 do
War.Person[War.SelID].effect=i
WarDelay(1)
end
JY.Person[pid]["智力"]=JY.Person[pid]["智力"]+1
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."的基础智力提升至"..JY.Person[pid]["智力"],M_White)
ReSetAttrib(pid,false)
War.Person[War.SelID].action=oldaction
JY.MenuPic.num=MenuPicNum
JY.Person[pid]["道具"..i]=0
for n=i,7 do
JY.Person[pid]["道具"..n]=JY.Person[pid]["道具"..(n+1)]
end
JY.Person[pid]["道具8"]=0
return 1
end
elseif kind==10 then--统率种
if not WarDrawStrBoxYesNo('提升统率值．',M_White) then
return 0
elseif JY.Person[pid]["统率"]>=100 then
PlayWavE(2)
WarDrawStrBoxDelay("无法提升．",M_White)
return 0
else
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[War.SelID].action
--使用物品动作
War.Person[War.SelID].action=0
War.Person[War.SelID].d=1
WarDelay(2)
PlayWavE(41)
War.Person[War.SelID].action=6
WarDelay(16)
--转圈，升级动作
War.Person[War.SelID].action=0
for t=1,2 do
War.Person[War.SelID].d=3
WarDelay(3)
War.Person[War.SelID].d=2
WarDelay(3)
War.Person[War.SelID].d=4
WarDelay(3)
War.Person[War.SelID].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[War.SelID].action=6
for i=0,256,8 do
War.Person[War.SelID].effect=i
WarDelay(1)
end
for i=240,0,-8 do
War.Person[War.SelID].effect=i
WarDelay(1)
end
JY.Person[pid]["统率"]=JY.Person[pid]["统率"]+1
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."的基础统率提升至"..JY.Person[pid]["统率"],M_White)
ReSetAttrib(pid,false)
War.Person[War.SelID].action=oldaction
JY.MenuPic.num=MenuPicNum
JY.Person[pid]["道具"..i]=0
for n=i,7 do
JY.Person[pid]["道具"..n]=JY.Person[pid]["道具"..(n+1)]
end
JY.Person[pid]["道具8"]=0
return 1
end
elseif kind==13 then--经验种
if not WarDrawStrBoxYesNo(JY.Person[pid]["姓名"]..'提升等级．',M_White) then
return 0
elseif JY.Person[pid]["等级"]>=99 then
PlayWavE(2)
WarDrawStrBoxDelay("无法提升．",M_White)
return 0
else
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[War.SelID].action
--使用物品动作
War.Person[War.SelID].action=0
War.Person[War.SelID].d=1
WarDelay(2)
PlayWavE(41)
War.Person[War.SelID].action=6
WarDelay(16)
--转圈，升级动作
War.Person[War.SelID].action=0
for t=1,2 do
War.Person[War.SelID].d=3
WarDelay(3)
War.Person[War.SelID].d=2
WarDelay(3)
War.Person[War.SelID].d=4
WarDelay(3)
War.Person[War.SelID].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[War.SelID].action=6
for i=0,256,8 do
War.Person[War.SelID].effect=i
WarDelay(1)
end
for i=240,0,-8 do
War.Person[War.SelID].effect=i
WarDelay(1)
end
JY.Person[pid]["等级"]=JY.Person[pid]["等级"]+1
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."的等级提升至"..JY.Person[pid]["等级"],M_White)
ReSetAttrib(pid,false)
War.Person[War.SelID].action=oldaction
JY.MenuPic.num=MenuPicNum
JY.Person[pid]["道具"..i]=0
for n=i,7 do
JY.Person[pid]["道具"..n]=JY.Person[pid]["道具"..(n+1)]
end
JY.Person[pid]["道具8"]=0
return 1
end
else
PlayWavE(2)
WarDrawStrBoxDelay("没有能使用的道具．",M_White)
return 0
end
end

--交出了．
function Item_Send(i)
local id=War.SelID
local pid=War.Person[id].id
local itemid=JY.Person[pid]["道具"..i]
WarSetAtkFW(War.SelID,21)
local eid=WarSelectAtk(true,11)
if eid>0 then
local EID=War.Person[eid].id
if JY.Person[EID]["道具8"]>0 then
PlayWavE(2)
WarDrawStrBoxDelay("携带品已经满了，不能再给了．",M_White)
return 0
else
for n=1,8 do
if JY.Person[EID]["道具"..n]==0 then
JY.Person[EID]["道具"..n]=itemid
break
end
end
for n=i,7 do
JY.Person[pid]["道具"..n]=JY.Person[pid]["道具"..(n+1)]
end
JY.Person[pid]["道具8"]=0
WarDrawStrBoxWaitKey("交出了"..JY.Item[itemid]["名称"].."．",M_White)
ReSetAttrib(pid,false)
ReSetAttrib(EID,false)
return 1
end
else
return 0
end
end

function Item_Scrap(i)
local id=War.SelID
local pid=War.Person[id].id
local itemid=JY.Person[pid]["道具"..i]
WarDrawStrBoxWaitKey("丢掉了"..JY.Item[itemid]["名称"].."．",M_White)
for n=i,7 do
JY.Person[pid]["道具"..n]=JY.Person[pid]["道具"..(n+1)]
end
JY.Person[pid]["道具8"]=0
ReSetAttrib(id,false)
return 1
end

function Item_Check(i)
local id=War.SelID
local pid=War.Person[id].id
local itemid=JY.Person[pid]["道具"..i]
 DrawItemStatus(itemid,pid)--显示物品属性
return 0
end

function WarAutoD(id1,id2)
local x1,y1=War.Person[id1].x,War.Person[id1].y
local x2,y2=War.Person[id2].x,War.Person[id2].y
local dx=math.abs(x1-x2)
local dy=math.abs(y1-y2)
if dx==0 and dy==0 then
return War.Person[id1].d,War.Person[id1].d
end
if dy>dx then
if y1>y2 then
return 2,1
else
return 1,2
end
else
if x1>x2 then
return 3,4
else
return 4,3
end
end
end

-- BZSuper(bz1,bz2)
-- 返回兵种克制关系
-- true 克制 false 不被克制
function BZSuper(bz1,bz2)
for i=1,9 do
if JY.Bingzhong[bz1]["克制"..i]==bz2 then
return true--bz1 克制 bz2
end
end
return false--不被克制
end

function WarAtkHurt(pid,eid,flag)
flag=flag or 0
local id1=War.Person[pid].id
local id2=War.Person[eid].id
local p1=JY.Person[id1]
local p2=JY.Person[id2]
--攻击防御
local atk=p1["攻击"]
local def=p2["防御"]
--防御修正，兵种克制
--武器特效和人物特技效果优先于兵种相克
if CC.Enhancement and (p1["武器"]==10 or WarCheckSkill(pid,110)) then--兵种克制 装备倚天剑后必克制
def=def*3/4
elseif CC.Enhancement and (p2["武器"]==11 or WarCheckSkill(eid,111)) then--兵种被克制 装备青釭剑后不被克制
def=def*5/4

elseif BZSuper(p1["兵种"],p2["兵种"]) then--兵种克制
def=def*3/4
elseif BZSuper(p2["兵种"],p1["兵种"]) then--兵种被克制
def=def*5/4
end
--地形杀伤修正
local T={
[0]=0,20,30,0,0,--森林　20　山地　30
0,0,5,5,0,--村庄　 5 草原　 5
0,0,0,30,10,--鹿寨　30　兵营　10
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0
}
local dx=GetWarMap(War.Person[eid].x,War.Person[eid].y,1)
--基本物理杀伤＝（攻击方攻击力－防御力修正值÷2）×（100－地形杀伤修正）÷100
local hurt=(atk-def/2)
if CC.Enhancement then
hurt=hurt*limitX(100+War.Person[pid].atk_buff-War.Person[eid].def_buff,10,200)/100
if WarCheckSkill(eid,23) then--藤甲
hurt=hurt*(100-JY.Skill[23]["参数1"])/100
end
if WarCheckSkill(eid,47) then--倾国
hurt=hurt*(100-JY.Skill[47]["参数1"])/100
end
else
hurt=hurt*(100-T[dx])/100
end
if flag==1 then--反击？
hurt=hurt/2
elseif flag==2 or flag==3 then--乱射/乱舞 伤害统一设置为正常伤害的40%
hurt=hurt*0.4
end
hurt=math.modf(hurt)
if CC.Enhancement then
if WarCheckSkill(eid,43) then--狼顾
if hurt>p2["最大兵力"]/5 then
hurt=p2["最大兵力"]/5
end
end
end
if CC.Enhancement and WarCheckSkill(eid,104) then--关羽 青龙偃月刀 被攻击时必定格挡
if hurt>p2["最大兵力"]/5 then
hurt=p2["最大兵力"]/5
end
end
if CC.Enhancement and (p1["武器"]==60 or WarCheckSkill(pid,115)) then--霸王之剑 攻击时必定暴击
if WarCheckSkill(eid,23) or WarCheckSkill(eid,43) or WarCheckSkill(eid,47) then--拥有 藤甲 狼顾 倾国 特技时免疫特效
WarDrawStrBoxDelay('暴击特效无法触发',M_White)
else
if hurt<p2["兵力"]*0.4 then
hurt=p2["兵力"]*0.4
end
end
end
if hurt<atk/20 then
hurt=math.modf(atk/20)
end
--如果攻击伤害<=0，则攻击伤害=1．
if hurt<1 then
hurt=1
end
local flag2=0
if hurt>=p2["最大兵力"]*0.4 then
flag2=2--暴击
elseif hurt>=p2["兵力"]+p2["最大兵力"]/5 then
flag2=2--暴击
elseif hurt<=p2["最大兵力"]/5 then
flag2=1--格挡
end
-- 如果攻击伤害大于防御方兵力，则攻击伤害=防御方兵力
if hurt>p2["兵力"] then
hurt=p2["兵力"]
end
--士气降幅＝攻击伤害÷（防御方等级＋5）÷3
local sq_hurt=math.modf(hurt/(p2["等级"]+5)/3)
if sq_hurt==0 then
if hurt>0 then
sq_hurt=1
else
sq_hurt=0
end
end
if CC.Enhancement and (p1["武器"]==14 or WarCheckSkill(pid,113)) then--三尖刀 攻击时额外减少敌方士气
sq_hurt=sq_hurt+10
end
sq_hurt=limitX(sq_hurt,0,p2["士气"])
--经验值获得
local jy=0
--敌军部队不能获得经验值．
if p1["等级"]<99 and (not War.Person[pid].enemy) then--and (not War.Person[pid].friend) then
--经验值由两部分构成：基本经验值和奖励经验值．
local part1,part2=0,0
--当攻击方等级低于等于防御方等级时：
if p1["等级"]<=p2["等级"] then
--基本经验值＝（防御方等级－攻击方等级＋3）×2
 part1=(p2["等级"]-p1["等级"]+3)*2
--如果基本经验值大于16，则基本经验值＝16．
if part1>16 then
part1=16
end
--提高获取经验
if CC.Enhancement then
part1=(p2["等级"]-p1["等级"]+5)*2
if part1>24 then
part1=24
end
end
--当攻击方等级高于防御方等级时：
else
--基本经验值＝4
part1=4
if CC.Enhancement then
part1=8--提高获取经验
end
end
--如果杀死敌人，可以获得奖励经验值：
if hurt==p2["兵力"] then
--如果杀死敌军主将
if War.Person[eid].leader then
--奖励经验值＝48
part2=48
--如果杀死的不是敌军主将，且敌军等级高于我军
elseif p2["等级"]>p1["等级"] then
--奖励经验值＝32
part2=32
--如果杀死的不是敌军主将，且敌军等级低于等于我军
else
--奖励经验值＝64÷（攻击方等级－防御方等级＋2）
part2=math.modf(64/(p1["等级"]-p2["等级"]+2))
--提高获取经验
if CC.Enhancement then
part2=32-(p1["等级"]-p2["等级"])*4
part2=limitX(part2,8,48)
end
end
end
--最终获得的经验值＝基本经验值＋奖励经验值．
jy=part1+part2
end
return hurt,sq_hurt,jy,flag2
end

function WarAtk(pid,eid,flag)
flag=flag or 0
War.ControlEnableOld=War.ControlEnable
War.ControlEnable=false
War.InMap=false
local hurt,sq_hurt,jy,flag2=WarAtkHurt(pid,eid,flag)
--flag2 0 普通 1格挡 2暴击
local id1=War.Person[pid].id
local id2=War.Person[eid].id
local str
if flag==1 then
str=JY.Person[id1]["姓名"]..'的反击'
elseif flag==2 then
str=JY.Person[id1]["姓名"]..'的乱射'
elseif flag==3 then
str=JY.Person[id1]["姓名"]..'的连击'
else
str=JY.Person[id1]["姓名"]..'的攻击'
end
local n=CC.OpearteSpeed
local d1,d2=WarAutoD(pid,eid)
War.Person[pid].d=d1
WarDelay()
if flag2==2 then
PlayWavE(6)
WarAtkWords(pid)
end
War.Person[pid].action=2
War.Person[pid].frame=0
WarDelay()
PlayWavE(War.Person[pid].atkwav)
for i=1,n*2 do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
for i=0,3 do
War.Person[pid].frame=i
if i==0 and flag2==2 then
PlayWavE(33)
for t=8,192,8 do
JY.ReFreshTime=lib.GetTime()
War.Person[pid].effect=t
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
War.Person[pid].effect=0
end
if i==3 then
War.Person[eid].hurt=hurt
War.Person[eid].frame=0
War.Person[eid].d=d2
if War.Person[eid].troubled then
PlayWavE(35)
elseif flag2==1 then
War.Person[eid].action=3
PlayWavE(30)
elseif flag2==2 then
War.Person[eid].effect=240
War.Person[eid].action=4
PlayWavE(36)
else
War.Person[eid].effect=240
War.Person[eid].action=4
PlayWavE(35)
end
for t=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
end
for t=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
end
War.Person[eid].effect=0
for i=1,n*2 do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
War.Person[eid].hurt=-1
--敌军兵力减少 显示
local t=16
t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/50,math.abs(sq_hurt)))))
local oldbl=JY.Person[id2]["兵力"]
local oldsq=JY.Person[id2]["士气"]
for i=0,t do
JY.ReFreshTime=lib.GetTime()
JY.Person[id2]["兵力"]=oldbl-hurt*i/t
JY.Person[id2]["士气"]=oldsq-sq_hurt*i/t
DrawWarMap()
DrawStatusMini(eid)
lib.GetKey()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*4)
WarDelay(4)
WarGetTrouble(eid)
--攻心 显示
if CC.Enhancement then
if WarCheckSkill(pid,33) or (pid==3 and JY.EventID>488 and not GetFlag(38)) then--攻心 雒I之战若庞统未死，张飞必触发该特效
if hurt>0 and JY.Person[id1]["兵力"]<JY.Person[id1]["最大兵力"] then
local t=16
hurt=math.modf(hurt*JY.Skill[33]["参数1"]/100)
hurt=limitX(hurt,1,JY.Person[id1]["最大兵力"]-JY.Person[id1]["兵力"])
t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/25))))
local oldbl=JY.Person[id1]["兵力"]
for i=0,t do
JY.ReFreshTime=lib.GetTime()
JY.Person[id1]["兵力"]=oldbl+hurt*i/t
DrawWarMap()
DrawStatusMini(pid)
lib.GetKey()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*4)
WarDelay(4)
end
end
end
local flag3=flag2
if flag2==0 then flag3=2 end
if flag2==1 then flag3=1 end
if flag2==2 then flag3=3 end
if CC.Enhancement then
if JY.Person[id2]["统率"]<100 and (not War.Person[eid].enemy) then
JY.Person[id2]["统率经验"]=JY.Person[id2]["统率经验"]+flag3
if JY.Person[id2]["统率经验"]>=200 then
JY.Person[id2]["统率经验"]=JY.Person[id2]["统率经验"]-200
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[eid].action
--转圈，升级动作
War.Person[eid].action=0
for t=1,2 do
War.Person[eid].d=3
WarDelay(3)
War.Person[eid].d=2
WarDelay(3)
War.Person[eid].d=4
WarDelay(3)
War.Person[eid].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[eid].action=6
for i=0,256,8 do
War.Person[eid].effect=i
WarDelay(1)
end
for i=240,0,-8 do
War.Person[eid].effect=i
WarDelay(1)
end
WarDrawStrBoxWaitKey(JY.Person[id2]["姓名"].."成功凝练出一枚统率种",M_White)
ReSetAttrib(id2,false)
War.Person[eid].action=oldaction
JY.MenuPic.num=MenuPicNum
for n=1,8 do
if JY.Person[id2]["道具"..n]==0 then
JY.Person[id2]["道具"..n]=73
break
end
end
end
end
end
--经验以及升级
WarAddExp(pid,jy)
if CC.Enhancement then
if JY.Person[id1]["武力"]<100 and (not War.Person[pid].enemy) then
JY.Person[id1]["武力经验"]=JY.Person[id1]["武力经验"]+flag3
if JY.Person[id1]["武力经验"]>=200 then
JY.Person[id1]["武力经验"]=JY.Person[id1]["武力经验"]-200
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[pid].action
--转圈，升级动作
War.Person[pid].action=0
for t=1,2 do
War.Person[pid].d=3
WarDelay(3)
War.Person[pid].d=2
WarDelay(3)
War.Person[pid].d=4
WarDelay(3)
War.Person[pid].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[pid].action=6
for i=0,256,8 do
War.Person[pid].effect=i
WarDelay(1)
end
for i=240,0,-8 do
War.Person[pid].effect=i
WarDelay(1)
end
WarDrawStrBoxWaitKey(JY.Person[id1]["姓名"].."成功凝练出一枚武力种",M_White)
ReSetAttrib(id1,false)
War.Person[pid].action=oldaction
JY.MenuPic.num=MenuPicNum
for n=1,8 do
if JY.Person[id1]["道具"..n]==0 then
JY.Person[id1]["道具"..n]=71
break
end
end
end
end
end
if War.Person[pid].active then
War.Person[pid].action=1
else
War.Person[pid].action=0
end
if War.Person[eid].active then
War.Person[eid].action=1
else
War.Person[eid].action=0
end
ReSetAttrib(id1,false)
ReSetAttrib(id2,false)
War.Person[pid].frame=-1
War.Person[eid].frame=-1
War.ControlEnable=War.ControlEnableOld
if CC.Enhancement then
if War.Person[pid].bz==27 and flag==0 then--舞女可连击
if JY.Person[id2]["兵力"]>0 then
WarAtk(pid,eid,3)
end
end
end
end

--WarAction(kind,id1,id2)
-- 战场上显示各种动作 id一般为人物id
-- kind: 0.转向 id1人物id, id2 方向id 1234下上左右
-- 1.自动转向
-- 3.攻击|无 4.攻击|被击中 5.攻击|防御 6.攻击|攻击
-- 7.暴击|无 8.暴击|被击中 9.暴击|防御 10.暴击|暴击
-- 11.双击|无 12.
-- 15.防御 16.撤退(含防御) 17.败退 18.死亡
-- 19.喘气
function WarAction(kind,id1,id2)
if JY.Status~=GAME_WMAP and JY.Status~=GAME_WARWIN and JY.Status~=GAME_WARLOSE then
return
end
local controlstatus=War.ControlEnable
War.ControlEnable=false
War.InMap=false
id1=id1 or 1
id2=id2 or id1
local pid=GetWarID(id1)
local eid=GetWarID(id2)
local n=CC.OpearteSpeed
WarPersonCenter(pid)
if (not War.Person[pid].live) or War.Person[pid].hide then
elseif kind==0 then
if between(id2,1,4) then
War.Person[pid].action=0
War.Person[pid].frame=0
WarDelay(n)
if War.Person[pid].d~=id2 then
War.Person[pid].d=id2
PlayWavE(6)
WarDelay(n*2)
end
end
elseif kind==1 then
local d1,d2=WarAutoD(pid,eid)
WarAction(0,id1,d1)
WarAction(0,id2,d2)
elseif kind==2 then
elseif kind==3 then
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
WarDelay(n)
for i=0,3 do
War.Person[pid].frame=i
if i==3 then
PlayWavE(7)
WarDelay(n)
end
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==4 then
local d1,d2=WarAutoD(pid,eid)
WarAction(0,id1,d1)
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
WarDelay(n)
for i=0,3 do
War.Person[pid].frame=i
if i==3 then
War.Person[eid].frame=0
War.Person[eid].d=d2
War.Person[eid].effect=240
War.Person[eid].action=4
PlayWavE(35)
WarDelay(n)
end
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==5 then
local d1,d2=WarAutoD(pid,eid)
WarAction(0,id1,d1)
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
for t=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
ReFresh()
end
lib.GetKey()
for i=0,3 do
War.Person[pid].frame=i
if i==3 then
War.Person[eid].frame=0
War.Person[eid].d=d2
War.Person[eid].action=3
PlayWavE(30)
WarDelay(n)
end
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==6 then
WarAction(1,id1,id2)
War.Person[pid].action=2
War.Person[eid].action=2
for i=0,3 do
War.Person[pid].frame=i
War.Person[eid].frame=i
if i==3 then
PlayWavE(30)
WarDelay(n)
end
WarDelay(n)
end
WarDelay(n*2)
elseif kind==7 then
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
WarDelay(n)
for i=0,3 do
War.Person[pid].frame=i
if i==0 then
PlayWavE(33)
for t=8,192,8 do
War.Person[pid].effect=t
WarDelay(1)
end
War.Person[pid].effect=0
end
if i==3 then
PlayWavE(7)
WarDelay(n)
end
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==8 then
local d1,d2=WarAutoD(pid,eid)
WarAction(0,id1,d1)
--War.Person[pid].d=d1
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
WarDelay(n)
for i=0,3 do
War.Person[pid].frame=i
if i==0 then
PlayWavE(33)
for t=8,192,8 do
War.Person[pid].effect=t
WarDelay(1)
end
War.Person[pid].effect=0
end
if i==3 then
War.Person[eid].frame=0
War.Person[eid].d=d2
War.Person[eid].effect=240
War.Person[eid].action=4
PlayWavE(36)
WarDelay(n)
end
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==9 then
local d1,d2=WarAutoD(pid,eid)
WarAction(0,id1,d1)
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
WarDelay(n)
lib.GetKey()
for i=0,3 do
War.Person[pid].frame=i
if i==0 then
PlayWavE(33)
for t=8,192,8 do
War.Person[pid].effect=t
WarDelay(1)
end
lib.GetKey()
War.Person[pid].effect=0
end
if i==3 then
War.Person[eid].frame=0
War.Person[eid].d=d2
War.Person[eid].action=3
War.Person[eid].effect=256
PlayWavE(31)
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
lib.GetKey()
elseif kind==10 then
WarAction(1,id1,id2)
War.Person[pid].action=2
War.Person[eid].action=2
for i=0,3 do
War.Person[pid].frame=i
War.Person[eid].frame=i
if i==0 then
PlayWavE(33)
for t=8,192,8 do
War.Person[pid].effect=t
War.Person[eid].effect=t
WarDelay(1)
end
lib.GetKey()
War.Person[pid].effect=0
War.Person[eid].effect=0
end
if i==3 then
War.Person[pid].effect=192
War.Person[eid].effect=192
PlayWavE(31)
WarDelay(n)
end
WarDelay(n)
end
War.Person[pid].effect=0
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==11 then
elseif kind==12 then
elseif kind==13 then
elseif kind==14 then
elseif kind==15 then
War.Person[pid].action=3
War.Person[pid].frame=0
WarDelay(n*2)
elseif kind==16 then
War.Person[pid].action=0
War.Person[pid].frame=0
WarDelay(n)
War.Person[pid].d=1
PlayWavE(6)
WarDelay(n*2)
War.Person[pid].action=3
War.Person[pid].frame=0
WarDelay(n*2)
PlayWavE(17)
for t=0,-256,-8 do
War.Person[pid].effect=t
WarDelay(1)
end
WarDelay(n*2)
War.Person[pid].action=9
War.Person[pid].live=false
SetWarMap(War.Person[pid].x,War.Person[pid].y,2,0)
WarDelay(n*4)
if War.Person[pid].enemy then
War.EnemyNum=War.EnemyNum-1
end
elseif kind==17 then
War.Person[pid].action=5
WarDelay(n)
for i=1,5 do
War.Person[pid].frame=0
if War.Person[pid].action==9 then
War.Person[pid].action=5
PlayWavE(16)
else
War.Person[pid].action=9
end
WarDelay(n)
end
War.Person[pid].frame=-1
War.Person[pid].action=9
War.Person[pid].live=false
SetWarMap(War.Person[pid].x,War.Person[pid].y,2,0)
WarDelay(n*2)
WarDrawStrBoxDelay(JY.Person[War.Person[pid].id]["姓名"].."撤退了！",M_White)
if War.Person[pid].enemy then
War.EnemyNum=War.EnemyNum-1
end
elseif kind==18 then
War.Person[pid].frame=0
War.Person[pid].action=5
for i=1,6 do
if War.Person[pid].action==9 then
War.Person[pid].action=5
else
War.Person[pid].action=9
end
WarDelay(n-1)
lib.GetKey()
end
for i=1,16 do
if War.Person[pid].action==9 then
War.Person[pid].action=5
else
War.Person[pid].action=9
end
WarDelay(n-2)
lib.GetKey()
end
PlayWavE(22)
War.Person[pid].action=5
for i=128,256,12 do
War.Person[pid].effect=i
WarDelay(n)
end
WarDelay(n*2)
War.Person[pid].frame=-1
War.Person[pid].action=9
War.Person[pid].live=false
SetWarMap(War.Person[pid].x,War.Person[pid].y,2,0)
WarDelay(n*4)
WarDrawStrBoxDelay(JY.Person[War.Person[pid].id]["姓名"].."阵亡了！",M_White)
if War.Person[pid].enemy then
War.EnemyNum=War.EnemyNum-1
end
elseif kind==19 then
War.Person[pid].action=5
War.Person[pid].frame=0
for i=0,5 do
War.Person[pid].frame=1-War.Person[pid].frame
WarDelay(n*2)
end
WarDelay(n*2)
end
WarResetStatus(pid)
WarResetStatus(eid)
War.ControlEnable=controlstatus
end

-- WarLastWords(wid)
-- 战场人物遗言
function WarLastWords(wid)
local wp=War.Person[wid]
local name=JY.Person[wp.id]["姓名"]
if true then--not wp.enemy then
if type(CC.LastWords[name])=='string' then
if wp.id==1 then
PlayBGM(4)
end
if CC.zdby==0 or wp.id==1 then
talk( wp.id,CC.LastWords[name])
end
end
end
end

-- 战场人物暴击台词
function WarAtkWords(wid)
local wp=War.Person[wid]
local name=JY.Person[wp.id]["姓名"]
if CC.zdby==0 then--not wp.enemy then
if type(CC.AtkWords[name])=='string' then
talk( wp.id,CC.AtkWords[name])
else
local str={
"喔喔喔……！", "哈啊啊……！", "呀啊啊……！", "喝……！", "唔喔喔……！",
"杀啊啊……！", "看招啊……！", "吃我一记！！", "杀……！", "去死吧！！！",
"唷呵……！", "呀呔……！", "嗯嗯嗯……！", "唔唔唔……！", "呼呼呼……！",
"嗯嗯！？", "哼！！", "嗯嗯嗯！", "讨厌！！", "哎呀！！",
"………………。", "…………！", "准备接招吧！！", "准备受死吧！", "着！！"
}
local n=math.random(40)
if type(str[n])=='string' then
talk( wp.id,str[n])
end
end
end
end

-- 用于各种行动后，使战场人物动作回复默认状态
function WarResetStatus(wid)
if between(wid,1,War.PersonNum) then
local v=War.Person[wid]
v.frame=-1
if v.live then
local id=v.id
if JY.Person[id]["兵力"]<=0 then
if v.action~=9 then
v.action=5
WarDelay(4)
JY.Death=id
DoEvent(JY.EventID)
JY.Death=0
if v.action~=9 then
WarLastWords(wid)
if id==1 then
WarAction(18,id)
else
WarAction(17,id)
end
end
end
elseif v.troubled then
v.action=7
elseif JY.Person[id]["兵力"]/JY.Person[id]["最大兵力"]<=0.30 then
v.action=5
elseif v.active then
v.action=1
else
v.action=0
end
if v.ai==6 then
if v.x==v.ai_dx and v.y==v.ai_dy then
v.ai=4
end
end
if CC.Enhancement then
ReSetAttrib(id,false) 
end
end
end
ReSetAllBuff()
end

--获得经验值
function WarAddExp(id,Exp)
if Exp<=0 then
return
end
local pid=War.Person[id].id
if JY.Person[pid]["等级"]>=99 then
return
end
local oldExp=JY.Person[pid]["经验"]
local lvupflag=false
local Exp2=0
if oldExp+Exp>100 then
Exp2=oldExp+Exp-100
Exp=Exp-Exp2
end
for i=0,Exp do
JY.Person[pid]["经验"]=oldExp+i
for t=1,1 do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawStatusMini(id,true)
lib.GetKey()
ReFresh()
end
if JY.Person[pid]["经验"]==100 then
lvupflag=true
WarLvUp(id)
JY.Person[pid]["经验"]=0
oldExp=0
end
end
if Exp2>0 then
for i=0,Exp2 do
JY.Person[pid]["经验"]=0+i
for t=1,1 do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawStatusMini(id,true)
lib.GetKey()
ReFresh()
end
end
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*3)
WarDelay(4)
if lvupflag then
JY.Person[pid]["经验"]=oldExp+Exp2
else
JY.Person[pid]["经验"]=oldExp+Exp
end
end

function WarAddExp2(id,Exp)--经验以及升级，但是无任何显示
end

function WarLvUp(id)--升级，以及动画
if id==0 then
return
end
War.SelID=id
BoxBack()
local pid=War.Person[id].id
War.Person[id].action=0
for t=1,2 do
War.Person[id].d=3
WarDelay(3)
War.Person[id].d=2
WarDelay(3)
War.Person[id].d=4
WarDelay(3)
War.Person[id].d=1
WarDelay(3)
end
PlayWavE(11)
War.Person[id].action=6
WarDelay(16)
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."的等级上升了！",M_White)
local magic={}
for mid=1,JY.MagicNum-1 do
magic[mid]=false
if WarHaveMagic(id,mid) then
magic[mid]=true
end
end
JY.Person[pid]["等级"]=limitX(JY.Person[pid]["等级"]+1,1,99)
ReSetAttrib(pid,false)
WarResetStatus(id)
WarDelay(4)
--提示技能策略习得
if CC.Enhancement==true then
for i=1,6 do
if JY.Person[pid]["等级"]==CC.SkillExp[JY.Person[pid]["成长"]][i] then
PlayWavE(11)
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."习得技能"..JY.Skill[JY.Person[pid]["特技"..i]]["名称"].."！",M_White)
break
end
end
end
local str=""
for mid=1,JY.MagicNum-1 do
if not magic[mid] then
if WarHaveMagic(id,mid) then
if str=="" then
str=JY.Magic[mid]["名称"]
else
str=str.."、"..JY.Magic[mid]["名称"]
end
end
end
end
if #str>0 then
PlayWavE(11)
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."习得策略"..str.."！",M_White)
end
War.LastID=War.SelID
War.SelID=0
end

function WarBingZhongUp(id,bzid)--兵种变更，动画
if id==0 then
return
end
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local pid=War.Person[id].id
local oldaction=War.Person[id].action
--使用物品动作
War.Person[id].action=0
War.Person[id].d=1
WarDelay(2)
PlayWavE(41)
War.Person[id].action=6
WarDelay(16)
--转圈，升级动作
War.Person[id].action=0
for t=1,2 do
War.Person[id].d=3
WarDelay(3)
War.Person[id].d=2
WarDelay(3)
War.Person[id].d=4
WarDelay(3)
War.Person[id].d=1
WarDelay(3)
end
PlayWavE(12)
War.Person[id].action=6
for i=0,256,8 do
War.Person[id].effect=i
WarDelay(1)
end
JY.Person[pid]["兵种"]=bzid
War.Person[id].bz=bzid
War.Person[id].movewav=JY.Bingzhong[bzid]["音效"]--移动音效
War.Person[id].atkwav=JY.Bingzhong[bzid]["攻击音效"]--攻击音效
War.Person[id].movestep=JY.Bingzhong[bzid]["移动"]--移动范围
War.Person[id].movespeed=JY.Bingzhong[bzid]["移动速度"]--移动速度
War.Person[id].atkfw=JY.Bingzhong[bzid]["攻击范围"]--攻击范围
War.Person[id].pic=WarGetPic(id)
for i=240,0,-8 do
War.Person[id].effect=i
WarDelay(1)
end
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."的兵种成为"..JY.Bingzhong[bzid]["名称"].."了！",M_White)
ReSetAttrib(pid,false)
War.Person[id].action=oldaction
JY.MenuPic.num=MenuPicNum
for n=1,8 do
if JY.Person[pid]["道具"..n]==0 then
JY.Person[pid]["道具"..n]=173
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."得到一枚经验种",M_White)
break
end
end
end

function limitX(x,minv,maxv)--限制x的范围
if x<minv then
x=minv
elseif x>maxv then
x=maxv
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
War.Width=64--地图尺寸
War.Depth=64
War.MW=12--old game 13
War.MD=9--old game 11
War.BoxWidth=48--地图方格尺寸
War.BoxDepth=48
War.CX=1--左上角方格位置
War.CY=1
War.MX=1--方格所在位置
War.MY=1
War.OldX=0--记录人物移动前坐标
War.OldY=0
War.InMap=false--标记鼠标是否在地图范围内
War.OldMX=-1--记录MXMYfor 鼠标操作 移动窗口用
War.OldMY=-1
War.DXpic=0--记录当前地形图片
War.FrameT=0
War.Frame=0
War.MoveScreenFrame=0
War.ControlStatus="select"
War.PersonNum=0
War.Weather=math.random(6)-1
War.Turn=1--当前回合
War.MaxTurn=30--最大回合
War.Leader1=-1
War.Leader2=-1
War.CurID=0
War.SelID=0
War.LastID=0--就是CurID，当移动到非人物时，保持上一个人物ID
War.EnemyNum=0
War.FunButtom=0--当前所处于的按钮
War.ControlEnableOld=true
War.ControlEnable=true
War.YD=0
end

-- 显示战场地图
function DrawWarMap()
local x,y=War.CX,War.CY
lib.FillColor(0,0,0,0,0)
local x0,y0=x,y
local cx,cy=16,32
x0=limitX(x0,0,War.Width)
y0=limitX(y0,0,War.Depth)
local xoff=x-math.modf(x)
local yoff=y-math.modf(y)
lib.SetClip(cx,cy,cx+War.BoxWidth*War.MW,cy+War.BoxDepth*War.MD)
lib.PicLoadCache(0,War.MapID*2,cx-War.BoxWidth*(x-1),cy-War.BoxDepth*(y-1),1)
lib.SetClip(0,0,0,0)
for i=x,x+War.MW-1 do
for j=y,y+War.MD-1 do
local v=GetWarMap(i,j,1)
if v==18 then
lib.PicLoadCache(4,(250+War.Frame%2)*2,cx+War.BoxWidth*(i-x),cy+War.BoxDepth*(j-y),1)
elseif v==19 then
lib.PicLoadCache(4,(252+War.Frame%2)*2,cx+War.BoxWidth*(i-x),cy+War.BoxDepth*(j-y),1)
end
end
end
for x=War.CX,math.min(War.CX+War.MW,War.Width) do
for y=War.CY,math.min(War.CY+War.MD,War.Depth) do
if GetWarMap(x,y,4)==0 then--不可移动
lib.Background(cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),cx+War.BoxWidth*(x-War.CX+1),cy+War.BoxDepth*(y-War.CY+1),128)
end
if GetWarMap(x,y,10)==1 then--攻击范围
lib.PicLoadCache(4,261*2,cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),1)
elseif GetWarMap(x,y,10)==2 then--治疗范围
lib.PicLoadCache(4,262*2,cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),1)
end
end
end
if War.InMap then
DrawGameBox(cx+War.BoxWidth*(War.MX-War.CX),cy+War.BoxDepth*(War.MY-War.CY),cx+War.BoxWidth*(War.MX-War.CX+1),cy+War.BoxDepth*(War.MY-War.CY+1),M_White,-1)
end
local size=48
local size2=64
for i,v in pairs(War.Person) do
if v.live and (not v.hide) then
if between(v.x,x,x+War.MW-1) and between(v.y,y,y+War.MD-1) then--limit XY
local frame
if v.frame>=0 then
frame=v.frame
else
frame=War.Frame
end
local left=cx+War.BoxWidth*(v.x-x)
local top=cy+War.BoxDepth*(v.y-y)
--0静止 1移动 2攻击 3防御 4被攻击 5喘气 7混乱 9不存在
--v.action=7 测试混乱图片用
if v.action==0 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1)
if not v.active then
lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1+2+4,128)
end
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1+2,256+v.effect)
end
elseif v.action==1 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+frame%2+(v.d-1)*4)*2,left,top,1)
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+frame%2+(v.d-1)*4)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+frame%2+(v.d-1)*4)*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+frame%2+(v.d-1)*4)*2,left,top,1+2,256+v.effect)
end
elseif v.action==2 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+30+frame+4*(v.d-1))*2,left+(size-size2)/2,top+(size-size2)/2,1)
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+30+frame+4*(v.d-1))*2,left+(size-size2)/2,top+(size-size2)/2,1)
lib.PicLoadCache(1,(v.pic+30+frame+4*(v.d-1))*2,left+(size-size2)/2,top+(size-size2)/2,1+2+8,v.effect) 
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+30+frame+4*(v.d-1))*2,left+(size-size2)/2,top+(size-size2)/2,1+2,256+v.effect) 
end
elseif v.action==3 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+22+(v.d-1))*2,left,top,1)
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+22+(v.d-1))*2,left,top,1)
lib.PicLoadCache(1,(v.pic+22+(v.d-1))*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+22+(v.d-1))*2,left,top,1+2,256+v.effect)
end
elseif v.action==4 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+26+(v.d-1)%2)*2,left,top,1)
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+26+(v.d-1)%2)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+26+(v.d-1)%2)*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+26+(v.d-1)%2)*2,left,top,1+2,256+v.effect)
end
elseif v.action==5 then
if v.effect==0 then
if v.active then
lib.PicLoadCache(1,(v.pic+20+frame%2)*2,left,top,1)
else
lib.PicLoadCache(1,(v.pic+20)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+20)*2,left,top,1+2+4,128)
end
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+20+frame%2)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+20+frame%2)*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+20+frame%2)*2,left,top,1+2,256+v.effect)
end
elseif v.action==6 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+28)*2,left,top,1)
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+28)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+28)*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+28)*2,left,top,1+2,256+v.effect)
end
elseif v.action==7 then--混乱
local hlpic=5010
if v.enemy then
hlpic=5012
elseif v.friend then
hlpic=5014
else
hlpic=5010
end
lib.PicLoadCache(1,(hlpic+frame%2)*2,left,top,1)
end
if v.hurt>=0 then
DrawString(left+size/2-#(v.hurt.."")*5,top,v.hurt,M_White,20)
end
end
end
end
if War.InMap then
if War.CY>1 and between(War.MX-War.CX,1,War.MW-2) and War.MY==War.CY then
lib.PicLoadCache(4,240*2,16+War.BoxWidth*(War.MX-War.CX)+13,32+War.BoxDepth*(War.MY-War.CY)+12,1)
elseif War.CY<War.Depth-War.MD+1 and between(War.MX-War.CX,1,War.MW-2) and War.MY==War.CY+War.MD-1 then
lib.PicLoadCache(4,244*2,16+War.BoxWidth*(War.MX-War.CX)+13,32+War.BoxDepth*(War.MY-War.CY)+12,1)
elseif War.CX>1 and between(War.MY-War.CY,1,War.MD-2) and War.MX==War.CX then
lib.PicLoadCache(4,246*2,16+War.BoxWidth*(War.MX-War.CX)+12,32+War.BoxDepth*(War.MY-War.CY)+13,1)
elseif War.CX<War.Width-War.MW+1 and between(War.MY-War.CY,1,War.MD-2) and War.MX==War.CX+War.MW-1 then
lib.PicLoadCache(4,242*2,16+War.BoxWidth*(War.MX-War.CX)+12,32+War.BoxDepth*(War.MY-War.CY)+13,1)
end
end
if War.ControlStatus=="select" then
if War.ControlEnable and War.CurID>0 then
DrawStatusMini(War.CurID)
end
elseif War.ControlStatus=="selectAtk" then
if War.ControlEnable then
local eid=GetWarMap(War.MX,War.MY,2)
if eid>0 then
DrawStatusMini(eid)
end
end
elseif War.ControlStatus=="checkDX" then
local menux,menuy
local dx=GetWarMap(War.MX,War.MY,1)
if War.MX-War.CX>math.modf(War.MW/2) then
menux=16+War.BoxWidth*(War.MX-War.CX)-136
else
menux=16+War.BoxWidth*(War.MX-War.CX+1)
end
if War.MY-War.CY>math.modf(War.MD/2) then
menuy=32+War.BoxWidth*(War.MY-War.CY)-40
else
menuy=32+War.BoxWidth*(War.MY-War.CY)
end
lib.Background(menux,menuy,menux+136,menuy+86,160)
menux=menux+8
menuy=menuy+8
lib.LoadSur(War.DXpic,menux,menuy)
DrawString(menux+56,menuy+8,"防御效果",M_White,16)
local T={[0]="０％","２０％","３０％","－％","０％","－％","０％","５％",
"５％","－％","－％","０％","－％","３０％","１０％","０％",
"０％","－％","－％","－％",}
DrawString(menux+88-#T[dx]*4,menuy+32,T[dx],M_White,16)
--森林 20 山地 30 村庄 5
--草原 5 鹿寨 30 兵营 10
-- 00 平原 01 森林 02 山地 03 河流 04 桥梁 05 城墙 06 城池 07 草原
-- 08 村庄 09 悬崖 0A 城门 0B 荒地 0C 栅栏 0D 鹿砦 0E 兵营 0F 粮仓
-- 10 宝物库 11 房舍 12 火焰 13 浊流
DrawString(menux,menuy+56,War.DX[dx],M_White,16)
if dx==8 or dx==13 or dx==14 then
DrawString(menux+56,menuy+56,"有恢复",M_White,16)
end
--村庄、鹿砦可以恢复士气和兵力．兵营可以恢复兵力，但不能恢复士气．
--玉玺可以恢复兵力和士气，援军报告可以恢复兵力，赦命书可以恢复士气．
--地形和宝物的恢复能力不能叠加，也就是说，处于村庄地形上再持有恢复性宝物，与没有持有恢复性宝物效果相同．但如果地形只能恢复兵力（如兵营），但宝物可以恢复兵力，这种情况下，兵力士气都能得到自动恢复．
end
if CC.Enhancement then
lib.PicLoadCache(4,205*2,0,0,1)
else
lib.PicLoadCache(4,205*2,0,0,1)
end
DrawString(381-#War.WarName*16/2/2,8,War.WarName,M_White,16)
if War.Weather<3 then--晴
lib.PicLoadCache(4,190*2,724,35,1)
elseif War.Weather>3 then--雨
lib.PicLoadCache(4,192*2,724,35,1)
else--云
lib.PicLoadCache(4,191*2,724,35,1)
end
if War.ControlStatus=="select" then
if War.FunButtom==1 then
lib.PicLoadCache(4,57*2,15,7,1)
end
end
DrawStatus()
lib.PicLoadCache(0,200+War.MapID*2,War.MiniMapCX,War.MiniMapCY,1)
for i=1,War.Width do
for j=1,War.Depth do
if GetWarMap(i,j,9)~=0 then
local x=War.MiniMapCX+(i-1)*4
local y=War.MiniMapCY+(j-1)*4
lib.FillColor(x,y,x+4,y+4,M_DarkOrchid)
end
end
end
for i,v in pairs(War.Person) do
if v.live and (not v.hide) then
local color=M_Blue
if v.enemy then
color=M_Red
elseif v.friend then
color=M_DarkOrange
end
local x=War.MiniMapCX+(v.x-1)*4
local y=War.MiniMapCY+(v.y-1)*4
lib.FillColor(x,y,x+4,y+4,color)
end
end
lib.DrawRect(War.MiniMapCX+(War.CX-1)*4,War.MiniMapCY+(War.CY-1)*4,War.MiniMapCX+(War.CX+War.MW-1)*4,War.MiniMapCY+(War.CY+War.MD-1)*4,M_Yellow)
for i=1,JY.MenuPic.num do
lib.LoadSur(JY.MenuPic.pic[i],JY.MenuPic.x[i],JY.MenuPic.y[i])
end
War.FrameT=War.FrameT+1
if War.FrameT>=32 then
War.FrameT=0
end
War.Frame=math.modf(War.FrameT/8)
end

function DrawStatusMini(id,flag)
flag=flag or false
local pid=War.Person[id].id
local x,y=War.Person[id].x,War.Person[id].y
local bz=JY.Person[pid]["兵种"]
local menux,menuy
if x-War.CX>math.modf(War.MW/2) then
menux=16+War.BoxWidth*(x-War.CX)-180
else
menux=16+War.BoxWidth*(x-War.CX+1)
end
if y-War.CY>math.modf(War.MD/2) then
menuy=32+War.BoxWidth*(y-War.CY)-32
else
menuy=32+War.BoxWidth*(y-War.CY)
end
lib.Background(menux,menuy,menux+180,menuy+80,160)
menux=menux+2
menuy=menuy+2
local color=M_Cyan
local str="我军"
if War.Person[id].enemy then
color=M_Red
str="敌军"
elseif War.Person[id].friend then
color=M_DarkOrange
str="友军"
end
if War.Person[id].troubled then
end
DrawString(menux,menuy,JY.Person[pid]["姓名"],color,16)
DrawString(menux+64,menuy,JY.Bingzhong[bz]["名称"].."　Lv"..JY.Person[pid]["等级"],M_White,16)
local len=120
local T={
100*JY.Person[pid]["兵力"]/JY.Person[pid]["最大兵力"],
math.min(100*JY.Person[pid]["士气"]/100,100),
100*JY.Person[pid]["经验"]/100,
}
local n=2
if flag then
n=3
end
for i=1,n do
local color
if T[i]<30 then
color=210
elseif T[i]<70 then
color=211
else
color=212
end
lib.FillColor(menux+48,menuy+4+i*20,menux+48+len,menuy+4+10+i*20,M_Black)
local xd=menux+48+len*T[i]/100
if xd>menux+48 then
lib.SetClip(menux+48,menuy+4+i*20,xd,menuy+4+10+i*20)
lib.PicLoadCache(4,color*2,menux+48,menuy+4+i*20,1)
end
lib.SetClip(0,0,0,0)
end
menuy=menuy+20
DrawString(menux,menuy,string.format("兵力　　 %4d/%d",JY.Person[pid]["兵力"],JY.Person[pid]["最大兵力"]),M_White,16)
menuy=menuy+20
DrawString(menux,menuy,string.format("士气　　 %4d/100",JY.Person[pid]["士气"]),M_White,16)
menuy=menuy+20
if flag then
DrawString(menux,menuy,string.format("经验　　 %4d/100",JY.Person[pid]["经验"]),M_White,16)
else
local T={[0]="","＋２０％","＋３０％","","","","","＋５％",
"＋５％","","","","","＋３０％","＋１０％","",
"","","","",}
local dx=GetWarMap(x,y,1)
DrawString(menux,menuy,string.format("%s",str,War),color,16)
DrawString(menux+64,menuy,string.format("%s %s",War.DX[dx],T[dx]),M_White,16)
end
end

--旧风格
function DrawStatus()
local id
if War.SelID>0 then
id=War.SelID
elseif War.CurID>0 then
id=War.CurID
elseif War.LastID>0 then
id=War.LastID
else
return
end
local pid=War.Person[id].id
local p=JY.Person[pid]
local x=805
local y=140
local size=16
local len=100
local T={
{"兵 力","士气值","攻击力","防御力","策略值","经验值"},
{100*p["兵力"]/p["最大兵力"],p["士气"],math.min(p["攻击"]/20,100),math.min(p["防御"]/20,100),100*p["策略"]/p["最大策略"],p["经验"]},
{p["兵力"].."/"..p["最大兵力"],""..p["士气"],""..p["攻击"],""..p["防御"],p["策略"].."/"..p["最大策略"],""..p["经验"]},
}
local x_off=x-785
DrawString(785+x_off,78,p["姓名"].."　"..JY.Bingzhong[p["兵种"]]["名称"],M_White,size)
DrawString(900+x_off,78,"等级"..p["等级"],M_White,size)
DrawString(820+x_off,105,p["武力"],M_White,size)
DrawString(875+x_off,105,p["智力"],M_White,size)
DrawString(930+x_off,105,p["统率"],M_White,size)
for i=1,6 do
DrawString(x,y,T[1][i],M_White,size)
local color
if T[2][i]<30 then
color=210
elseif T[2][i]<70 then
color=211
else
color=212
end
lib.FillColor(x+64,y+3,x+64+len,y+3+10,M_Black)
lib.SetClip(x+64,y+3,x+64+len*T[2][i]/100,y+3+10)
lib.PicLoadCache(4,color*2,x+64,y+3,1)
lib.SetClip(0,0,0,0)
DrawString(x+64+len/2-size*#T[3][i]/4,y,T[3][i],M_White,size)
y=y+size+12
end
end

--新风格
function DrawStatus()
local id
if War.SelID>0 then
id=War.SelID
elseif War.CurID>0 then
id=War.CurID
elseif War.LastID>0 then
id=War.LastID
else
return
end
local wp=War.Person[id]
local pid=War.Person[id].id
local p=JY.Person[pid]
local x=801-48*4
local y=190
local size=16
local len=90
local T={
{"兵 力","士气值","攻击力","防御力","策略值","经验值"},
{math.min(100*p["兵力"]/p["最大兵力"],100),math.min(p["士气"],100),math.min(p["攻击"]/20,100),math.min(p["防御"]/20,100),math.min(100*p["策略"]/math.max(p["最大策略"],1),100),p["经验"]},
{p["兵力"].."/"..p["最大兵力"],""..p["士气"],""..p["攻击"],""..p["防御"],p["策略"].."/"..p["最大策略"],""..p["经验"]},
}
local x_off=x-785
lib.PicLoadCache(4,230*2,800-48*4,73,1)
lib.PicLoadCache(2,p["头像代号"]*2,808-48*4,81,1)
lib.PicLoadCache(4,227*2,884-48*4,79,1)
lib.PicLoadCache(4,228*2,884-48*4,109,1)
lib.PicLoadCache(4,229*2,884-48*4,139,1)
DrawString(x,y-size-3,p["姓名"].."　"..JY.Bingzhong[p["兵种"]]["名称"].."Lv"..p["等级"],M_White,size)
for i,v in pairs({"武力2","智力2","统率2"}) do
local zbdy=54
if not War.Person[id].enemy then
zbdy=46
end
if CC.Enhancement==false then
zbdy=54
end
DrawString2(916-48*4,zbdy+i*30,string.format("%d",p[v]),M_White,size)
end
if CC.Enhancement then
if not War.Person[id].enemy then
local wljy=p["武力经验"]
if p["武力"]==100 then wljy=200 end
local str=string.format("%d",math.modf(wljy/2)).."％"
if wljy==200 then str="MAX"end DrawString2(916-49*4,60+30,str,M_White,16)
local zljy=p["智力经验"]
if p["智力"]==100 then zljy=200 end
str=string.format("%d",math.modf(zljy/2)).."％"
if zljy==200 then str="MAX"end DrawString2(916-49*4,60+60,str,M_White,16)
local tljy=p["统率经验"]
if p["统率"]==100 then tljy=200 end
str=string.format("%d",math.modf(tljy/2)).."％"
if tljy==200 then str="MAX"end DrawString2(916-49*4,60+90,str,M_White,16)
end
end
for i=1,6 do
DrawString(x,y,T[1][i],M_White,size)
local color
if T[2][i]<30 then
color=210
elseif T[2][i]<70 then
color=211
else
color=212
end
lib.FillColor(x+52,y+3,x+52+len,y+3+10,M_Black)
if T[2][i]>1 then
lib.SetClip(x+52,y+3,x+52+len*T[2][i]/100,y+3+10)
lib.PicLoadCache(4,color*2,x+52,y+3,1)
end
lib.SetClip(0,0,0,0)
DrawString2(x+52+len/2-size*#T[3][i]/4,y,T[3][i],M_White,size)
y=y+size+2
end
local leader=0
local forcename=""
leader=p["君主"]--默认就是自己的君主
if leader==0 then--当没有设定时
if wp.enemy then--敌人 就用敌人主帅的君主
leader=JY.Person[War.Leader2]["君主"]
end
end
if leader>0 then
forcename=JY.Person[leader]["姓名"]
else
if wp.enemy then
forcename="敌军"
elseif wp.friend then
forcename="友军"
else
forcename="我军"
end
end
DrawString(632-#forcename*16/2/2,40,forcename,M_White,16)
if CC.Enhancement then
DrawString(x,y,"技能",M_White,size)
DrawSkillTable(pid,x+34,y)
y=y+42
DrawString(x,y,string.format("攻 %+03d％ 防 %+03d％",wp.atk_buff,wp.def_buff),M_White,size)
y=y+20
end
if CC.AIXS then
x=300
y=CC.ScreenH-size
if wp.ai==0 then
DrawString(x,y,"AI: 被动出击",M_White,size)
elseif wp.ai==1 then
DrawString(x,y,"AI: 主动出击",M_White,size)
elseif wp.ai==2 then
DrawString(x,y,"AI: 坚守原地",M_White,size)
elseif wp.ai==3 then
DrawString(x,y,"AI: 攻击 "..JY.Person[wp.aitarget]["姓名"],M_White,size)
elseif wp.ai==4 then
DrawString(x,y,"AI: 攻击 "..wp.ai_dx..","..wp.ai_dy,M_White,size)
elseif wp.ai==5 then
DrawString(x,y,"AI: 跟随 "..JY.Person[wp.aitarget]["姓名"],M_White,size)
elseif wp.ai==6 then
DrawString(x,y,"AI: 移至 "..wp.ai_dx..","..wp.ai_dy,M_White,size)
else
DrawString(x,y,"AI: 其他 "..wp.aitarget.." "..wp.ai_dx..","..wp.ai_dy,M_White,size)
end
end
end

function DrawSkillTable(pid,x,y,flag)
flag=flag or 0
local p=JY.Person[pid]
local cx,cy
local box_w=36
local box_h=20
for i=1,6 do
local cx=x+box_w*((i-1)%3)
local cy=y+box_h*math.modf((i-1)/3)
lib.DrawRect(cx,cy,cx+box_w,cy,M_White)
lib.DrawRect(cx,cy+box_h,cx+box_w,cy+box_h,M_White)
lib.DrawRect(cx,cy,cx,cy+box_h,M_White)
lib.DrawRect(cx+box_w,cy,cx+box_w,cy+box_h,M_White)
lib.Background(cx+1,cy+1,cx+box_w,cy+box_h,240,M_Blue)
if p["等级"]>=CC.SkillExp[p["成长"]][i] or flag==2 then
DrawString(cx+2,cy+2,JY.Skill[p["特技"..i]]["名称"],M_White,16)
else
DrawString(cx+2,cy+2,"？？",M_Gray,16)
end
end
end

function CleanWarMap(lv,v)
for x=1,War.Width do
for y=1,War.Depth do
SetWarMap(x,y,lv,v)
end
end
end

function GetWarMap(x,y,lv)
if x>0 and x<=War.Width and y>0 and y<=War.Depth then
if lv==1 then
if War.Map[War.Width*War.Depth*(9-1)+War.Width*(y-1)+x]==1 then
return 18
elseif War.Map[War.Width*War.Depth*(9-1)+War.Width*(y-1)+x]==2 then
return 19
else
return War.Map[War.Width*War.Depth*(lv-1)+War.Width*(y-1)+x]
end
else
return War.Map[War.Width*War.Depth*(lv-1)+War.Width*(y-1)+x]
end
else
lib.Debug(string.format("error!GetWarMapx=%d,y=%d,width=%d,depth=%d",x,y,War.Width,War.Depth))
return 0
end
end

function SetWarMap(x,y,lv,v)
if x>0 and x<=War.Width and y>0 and y<=War.Depth then
War.Map[War.Width*War.Depth*(lv-1)+War.Width*(y-1)+x]=v
return 1
else
lib.Debug(string.format("error!SetWarMapx=%d,y=%d,v=%d,width=%d,depth=%d",x,y,v,War.Width,War.Depth))
return 0
end
end

function filelength(filename)--得到文件长度
local inp=io.open(filename,"rb")
if inp==nil then
return -1
end
local l=inp:seek("end")
inp:close()
return l
end

function LoadWarMap(id)
local len=filelength(CC.MapFile)
local data=Byte.create(len)
Byte.loadfile(data,CC.MapFile,0,len)
local map_num=58
local idx1,idx2,idx3,idx4=Byte.get8(data,16+256+12*id+8),Byte.get8(data,16+256+12*id+9),Byte.get8(data,16+256+12*id+10),Byte.get8(data,16+256+12*id+11)
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
local idx=idx4+256*idx3+256^2*idx2+256^3*idx1
War.Width=Byte.get8(data,idx)/2
War.Depth=Byte.get8(data,idx+1)/2
War.MiniMapCX=680-War.Width*2
War.MiniMapCY=411-War.Depth*2
War.Map={}
CleanWarMap(1,0)--地形
CleanWarMap(2,0)--wid
CleanWarMap(3,0)--
CleanWarMap(4,1)--选择范围
CleanWarMap(5,-1)--攻击价值
CleanWarMap(6,-1)--策略价值
CleanWarMap(7,0)--选择的策略
CleanWarMap(8,0)--AI强化用，我军的攻击范围
CleanWarMap(9,0)--水火控制
CleanWarMap(10,0)--攻击范围，显示用
 idx=idx+2+4*War.Width*War.Depth
for i=1,War.Width*War.Depth do
local v=Byte.get8(data,idx+(i-1))
if v<0 or v>19 then
lib.Debug(string.format("!!Error, MapID=%d,idx=%d,v=%d",id,i,v))
v=0
end
War.Map[i]=v--Byte.get8(data,idx+(i-1))
end
end

-- WarSearchMove(id,x,y)
-- 寻找移动到x,y的最近路径
-- flag,为true时无视敌人拦路
function WarSearchMove(id,x,y,flag)
flag=flag or false
local stepmax=256
CleanWarMap(4,0)--第4层坐标用来设置移动，先都设为0
local steparray={}--用数组保存第n步的坐标．
for i=0,stepmax do
steparray[i]={}
steparray[i].num=0
steparray[i].x={}
steparray[i].y={}
steparray[i].m={}
end
SetWarMap(x,y,4,stepmax+1)
steparray[0].num=1
steparray[0].x[1]=x
steparray[0].y[1]=y
steparray[0].m[1]=stepmax
for i=0,stepmax-1 do--根据第0步的坐标找出第1步，然后继续找
WarSearchMove_sub(steparray,i,id,flag)
if steparray[i+1].num==0 then
break
end
end
return
end

function WarSearchMove_sub(steparray,step,id,flag)--设置下一步可移动的坐标
local num=0
local step1=step+1
local pid=War.Person[id].id
local bz=JY.Person[pid]["兵种"]
for i=1,steparray[step].num do
if steparray[step].m[i]>0 then
local x=steparray[step].x[i]
local y=steparray[step].y[i]
for d=1,4 do--当前步数的相邻格
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
local v=GetWarMap(nx,ny,4)
local dx=GetWarMap(nx,ny,1)
local elyd=JY.Bingzhong[bz]["地形"..dx]
if CC.Enhancement and WarCheckSkill(id,118) then
elyd=1
end
if v==0 and steparray[step].m[i]>=elyd and War_CanMoveXY(nx,ny,id,flag) then
num=num+1
steparray[step1].x[num]=nx
steparray[step1].y[num]=ny
if CheckZOC(id,nx,ny) then
steparray[step1].m[num]=steparray[step].m[i]-elyd-JY.Bingzhong[bz]["移动"]
else
steparray[step1].m[num]=steparray[step].m[i]-elyd
end
SetWarMap(nx,ny,4,steparray[step1].m[num]+1)
end
end
end
end
end
steparray[step1].num=num
end

-- WarSearchBZ(id)
-- 寻找最近我方指定兵种
function WarSearchBZ(id,bzid)
local stepmax=256
CleanWarMap(4,0)--第4层坐标用来设置移动，先都设为0，
local x=War.Person[id].x
local y=War.Person[id].y
local steparray={}--用数组保存第n步的坐标．
for i=0,stepmax do
steparray[i]={}
steparray[i].num=0
steparray[i].x={}
steparray[i].y={}
steparray[i].m={}
end
SetWarMap(x,y,4,stepmax+1)
steparray[0].num=1
steparray[0].x[1]=x
steparray[0].y[1]=y
steparray[0].m[1]=stepmax
for i=0,stepmax-1 do--根据第0步的坐标找出第1步，然后继续找
local eid=WarSearchBZ_sub(steparray,i,id,bzid,true)
if eid>0 then
return eid
end
if steparray[i+1].num==0 then
break
end
end
return 0
end

function WarSearchBZ_sub(steparray,step,id,bzid,flag)--设置下一步可移动的坐标
local num=0
local step1=step+1
local pid=War.Person[id].id
local bz=JY.Person[pid]["兵种"]
for i=1,steparray[step].num do
if steparray[step].m[i]>0 then
local x=steparray[step].x[i]
local y=steparray[step].y[i]
for d=1,4 do--当前步数的相邻格
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
local v=GetWarMap(nx,ny,4)
local dx=GetWarMap(nx,ny,1)
local elyd=JY.Bingzhong[bz]["地形"..dx]
if CC.Enhancement and WarCheckSkill(id,118) then
elyd=1
end
if v==0 and steparray[step].m[i]>=elyd and War_CanMoveXY(nx,ny,id,flag) then
num=num+1
 steparray[step1].x[num]=nx
 steparray[step1].y[num]=ny
 steparray[step1].m[num]=steparray[step].m[i]-elyd
SetWarMap(nx,ny,4,steparray[step1].m[num]+1)
local eid=GetWarMap(nx,ny,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) and War.Person[id].enemy==War.Person[eid].enemy then
-- 有人 活着 非伏兵 
if bzid==War.Person[eid].bz and JY.Person[War.Person[eid].id]["策略"]>=6 then
return eid
end
end
end
end
end
end
end
steparray[step1].num=num
return 0
end

-- WarSearchEnemy(id)
-- 寻找最近敌人
function WarSearchEnemy(id)
local stepmax=256
CleanWarMap(4,0)--第4层坐标用来设置移动，先都设为0，
local x=War.Person[id].x
local y=War.Person[id].y
local steparray={}--用数组保存第n步的坐标．
for i=0,stepmax do
steparray[i]={}
steparray[i].num=0
steparray[i].x={}
steparray[i].y={}
steparray[i].m={}
end
SetWarMap(x,y,4,stepmax+1)
steparray[0].num=1
steparray[0].x[1]=x
steparray[0].y[1]=y
steparray[0].m[1]=stepmax
local eidbk=0
for i=0,stepmax-1 do--根据第0步的坐标找出第1步，然后继续找
local eid=WarSearchEnemy_sub(steparray,i,id,true)
if eid>0 then
return eid
end
if eidbk==0 and eid<0 then
eidbk=-eid
end
if steparray[i+1].num==0 then
break
end
end
return eidbk
end

function WarSearchEnemy_sub(steparray,step,id,flag)--设置下一步可移动的坐标
local num=0
local step1=step+1
local pid=War.Person[id].id
local bz=JY.Person[pid]["兵种"]
local eidbk=0
for i=1,steparray[step].num do
if steparray[step].m[i]>0 then
local x=steparray[step].x[i]
local y=steparray[step].y[i]
for d=1,4 do--当前步数的相邻格
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
local v=GetWarMap(nx,ny,4)
local dx=GetWarMap(nx,ny,1)
local elyd=JY.Bingzhong[bz]["地形"..dx]
if CC.Enhancement and WarCheckSkill(id,118) then
elyd=1
end
if v==0 and steparray[step].m[i]>=elyd and War_CanMoveXY(nx,ny,id,flag) then
num=num+1
steparray[step1].x[num]=nx
steparray[step1].y[num]=ny
steparray[step1].m[num]=steparray[step].m[i]-elyd
SetWarMap(nx,ny,4,steparray[step1].m[num]+1)
local eid=GetWarMap(nx,ny,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) and War.Person[id].enemy~=War.Person[eid].enemy then
-- 有人 活着 非伏兵 敌人 
--在已经搜寻过的坐标里，存在可以攻击的坐标
local array=WarGetAtkFW(nx,ny,War.Person[id].atkfw)
for n=1,array.num do
if between(array[n][1],1,War.Width) and between(array[n][2],1,War.Depth) then
if GetWarMap(array[n][1],array[n][2],4)>0 and GetWarMap(array[n][1],array[n][2],2)==0 then
return eid
end
end
end
eidbk=-eid
end
end
end
end
end
end
steparray[step1].num=num
return 0
end

-- War_CalAtkFW(wid)
-- 显示wid的攻击范围
function War_CalAtkFW(wid)
local array=WarGetAtkFW(War.Person[wid].x,War.Person[wid].y,War.Person[wid].atkfw)
for i=1,array.num do
local mx,my=array[i][1],array[i][2]
if between(mx,1,War.Width) and between(my,1,War.Depth) then
SetWarMap(mx,my,10,1)
end
end
end

--计算可移动步数
--id 战斗人id，
--stepmax 最大步数，
--flag=0 移动，物品不能绕过，1 武功，用毒医疗等，不考虑挡路．
function War_CalMoveStep(id,stepmax,flag)--计算可移动步数
CleanWarMap(4,0)--第4层坐标用来设置移动，先都设为0，
local x=War.Person[id].x
local y=War.Person[id].y
local steparray={}--用数组保存第n步的坐标．
for i=0,stepmax do
steparray[i]={}
steparray[i].num=0
steparray[i].x={}
steparray[i].y={}
steparray[i].m={}
end

SetWarMap(x,y,4,stepmax+1)
steparray[0].num=1
steparray[0].x[1]=x
steparray[0].y[1]=y
steparray[0].m[1]=stepmax
for i=0,stepmax-1 do--根据第0步的坐标找出第1步，然后继续找
War_FindNextStep(steparray,i,id,flag)
if steparray[i+1].num==0 then
break
end
end
return steparray
end

function War_FindNextStep(steparray,step,id,flag)--设置下一步可移动的坐标
local num=0
local step1=step+1
local pid=War.Person[id].id
local bz=JY.Person[pid]["兵种"]
for i=1,steparray[step].num do
if steparray[step].m[i]>0 then
local x=steparray[step].x[i]
local y=steparray[step].y[i]
for d=1,4 do--当前步数的相邻格
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
local v=GetWarMap(nx,ny,4)
local dx=GetWarMap(nx,ny,1)
local elyd=JY.Bingzhong[bz]["地形"..dx]
if CC.Enhancement and WarCheckSkill(id,118) then
elyd=1
end
if v==0 and steparray[step].m[i]>=elyd and War_CanMoveXY(nx,ny,id,flag) then
num=num+1
steparray[step1].x[num]=nx
steparray[step1].y[num]=ny
if (not flag) and CheckZOC(id,nx,ny) then
steparray[step1].m[num]=0
else
steparray[step1].m[num]=steparray[step].m[i]-elyd
end
SetWarMap(nx,ny,4,steparray[step1].m[num]+1)
end
end
end
end
end
steparray[step1].num=num
end

function CheckZOC(id,x,y)
if CC.Enhancement then
if WarCheckSkill(id,34) then--强行
return false
end
end
for d=1,4 do--当前步数的相邻格
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
local eid=GetWarMap(nx,ny,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) and War.Person[id].enemy~=War.Person[eid].enemy then
return true
end
end
end
return false
end

function War_CanMoveXY(x,y,pid,flag)--坐标是否可以通过，判断移动时使用
local id1=War.Person[pid].id
local bz=JY.Person[id1]["兵种"]
local dx=GetWarMap(x,y,1)
if JY.Bingzhong[bz]["地形"..dx]==0 then
return false
end
local eid=GetWarMap(x,y,2)
if eid>0 and (not flag) and War.Person[eid].live and (not War.Person[eid].hide) and War.Person[pid].enemy~=War.Person[eid].enemy then
return false
end
return true
end

function WarCanExistXY(x,y,pid)--坐标是否可以通过
local id1=War.Person[pid].id
local bz=JY.Person[id1]["兵种"]
local dx=GetWarMap(x,y,1)
if JY.Bingzhong[bz]["地形"..dx]==0 then
return false
end
local eid=GetWarMap(x,y,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
return false
end
return true
end

function War_MovePerson(x,y,flag)--移动人物到位置x,y
War.ControlEnableOld=War.ControlEnable
War.ControlEnable=false
War.InMap=false
flag=flag or 0
local movenum=GetWarMap(x,y,4)
local dx,dy=x,y
local movetable={}-- 记录每步移动
local mx,my=War.Person[War.SelID].x,War.Person[War.SelID].y
local dm=GetWarMap(mx,my,4)
local start=dm
local str=JY.Person[War.Person[War.SelID].id]["姓名"]..'的移动'
for i=1,dm do
if mx==x and my==y then
start=i-1
break
end
movetable[i]={}
movetable[i].x=x
movetable[i].y=y
local fx,fy
for d=1,4 do
local nx,ny=x-CC.DirectX[d],y-CC.DirectY[d]
if between(nx,1,War.Width) and between(ny,1,War.Depth) then
local v=GetWarMap(nx,ny,4)
if v>movenum then
movenum=v
fx,fy=nx,ny
movetable[i].direct=d
end
end
end
x,y=fx,fy
end
--8是标准速度，6偏快，4很快,3极快，12慢,16
local step=War.Person[War.SelID].movespeed
if CC.MoveSpeed==1 then
step=1
end
SetWarMap(War.Person[War.SelID].x,War.Person[War.SelID].y,2,0)
SetWarMap(dx,dy,2,War.SelID)
War.ControlEnable=false
War.InMap=false
War.Person[War.SelID].action=1
local sframe=0
for i=start,1,-1 do
War.Person[War.SelID].d=movetable[i].direct
local cx=War.Person[War.SelID].x+CC.DirectX[movetable[i].direct]
local cy=War.Person[War.SelID].y+CC.DirectY[movetable[i].direct]
if War.SelID>0 then
if not between(War.CX,cx-War.MW+1,cx-1) then
War.CX=limitX(War.CX,cx-War.MW+3,cx-3)
War.CX=limitX(War.CX,1,War.Width-War.MW+1)
end
if not between(War.CY,cy-War.MD+1,cy-1) then
War.CY=limitX(War.CY,cy-War.MD+2,cy-2)
War.CY=limitX(War.CY,1,War.Depth-War.MD+1)
end
end
for t=1,step do
War.Person[War.SelID].x=War.Person[War.SelID].x+CC.DirectX[movetable[i].direct]/step
War.Person[War.SelID].y=War.Person[War.SelID].y+CC.DirectY[movetable[i].direct]/step
lib.GetKey(1)
War.Person[War.SelID].frame=math.modf(sframe/4)%2
if sframe==0 then
PlayWavE(War.Person[War.SelID].movewav)
end
if sframe==7 then
sframe=0
else
sframe=sframe+1
end
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
War.Person[War.SelID].x=cx
War.Person[War.SelID].y=cy
end
if War.Person[War.SelID].active then
War.Person[War.SelID].action=1
else
War.Person[War.SelID].action=0
end
War.Person[War.SelID].frame=-1
War.Person[War.SelID].x=dx
War.Person[War.SelID].y=dy
BoxBack()
local pid=War.Person[War.SelID].id
ReSetAttrib(pid,false)
ReSetAllBuff()
War.CurID=0
War.ControlEnable=War.ControlEnableOld
end

function ReSetAttrib(id,flag)
local p=JY.Person[id]
local wid=GetWarID(id)
if wid>0 then
War.Person[wid].sq_limited=100
else
p["士气"]=100
end
if CC.Enhancement then
if CheckSkill(id,7) then--威风
if wid>0 then
War.Person[wid].sq_limited=JY.Skill[7]["参数1"]
else
p["士气"]=JY.Skill[7]["参数1"]
end
end
end
if wid>0 and flag then
p["士气"]=War.Person[wid].sq_limited
end
if CC.Enhancement and wid>0 then
if CheckSkill(id,31) then--精兵
if p["士气"]<JY.Skill[31]["参数1"] then
p["士气"]=math.min(War.Person[wid].sq_limited,JY.Skill[31]["参数1"])
end
end
end
local bid=p["兵种"]
local b=JY.Bingzhong[bid]
p["最大兵力"]=b["基础兵力"]+b["兵力增长"]*(p["等级"]-1)
if CC.Enhancement then
if CheckSkill(id,6) then--雄师
p["最大兵力"]=b["基础兵力"]+JY.Skill[6]["参数1"]+(b["兵力增长"]+JY.Skill[6]["参数2"])*(p["等级"]-1)
end
end
if wid>0 and CC.Enhancement then
if CheckSkill(id,45) then--霸气
War.Person[wid].atkfw=JY.Skill[45]["参数1"]
end
end
--Get Weapon
local weapon1=0
local weapon2=0
local weapon3=0
for i=1,8 do
local item=p["道具"..i]
if item>0 then
local canuse=false
if JY.Item[item]["需兵种1"]==0 then
canuse=true
else
for n=1,7 do
if JY.Item[item]["需兵种"..n]==p["兵种"] then
canuse=true
break
end
end
end
if p["等级"]<JY.Item[item]["需等级"] then
canuse=false
end
if canuse then
if JY.Item[item]["装备位"]==1 then
if weapon1==0 or JY.Item[item]["优先级"]>JY.Item[weapon1]["优先级"] then
weapon1=item
end
elseif JY.Item[item]["装备位"]==2 then
if weapon2==0 or JY.Item[item]["优先级"]>JY.Item[weapon2]["优先级"] then
weapon2=item
end
elseif JY.Item[item]["装备位"]==3 then
if weapon3==0 or JY.Item[item]["优先级"]>JY.Item[weapon3]["优先级"] then
weapon3=item
end
end
end
end
end
p["武器"]=weapon1
p["防具"]=weapon2
p["辅助"]=weapon3
--计算武器加成后的属性
local p_wuli=p["武力"]
local p_tongshuai=p["统率"]
local p_zhili=p["智力"]
local atk,def,mov=0,0,0
mov=b["移动"]
if weapon1>0 then
p_wuli=p_wuli+JY.Item[weapon1]["武力"]
p_zhili=p_zhili+JY.Item[weapon1]["智力"]
p_tongshuai=p_tongshuai+JY.Item[weapon1]["统率"]
atk=atk+JY.Item[weapon1]["攻击"]
def=def+JY.Item[weapon1]["防御"]
mov=mov+JY.Item[weapon1]["移动"]
end
if weapon2>0 then
p_wuli=p_wuli+JY.Item[weapon2]["武力"]
p_zhili=p_zhili+JY.Item[weapon2]["智力"]
p_tongshuai=p_tongshuai+JY.Item[weapon2]["统率"]
atk=atk+JY.Item[weapon2]["攻击"]
def=def+JY.Item[weapon2]["防御"]
mov=mov+JY.Item[weapon2]["移动"]
end
if weapon3>0 then
p_wuli=p_wuli+JY.Item[weapon3]["武力"]
p_zhili=p_zhili+JY.Item[weapon3]["智力"]
p_tongshuai=p_tongshuai+JY.Item[weapon3]["统率"]
atk=atk+JY.Item[weapon3]["攻击"]
def=def+JY.Item[weapon3]["防御"]
mov=mov+JY.Item[weapon3]["移动"]
end
p["武力2"]=p_wuli
p["智力2"]=p_zhili
p["统率2"]=p_tongshuai
p["最大策略"]=math.modf(p_zhili*(p["等级"]+10)/40)+b["策略成长"]*p["等级"]
p["策略"]=limitX(p["策略"],0,p["最大策略"])
--（（4000÷（140－武力）＋兵种基本攻击力×2＋士气）×（等级＋10）÷10）×（100＋宝物攻击加成）÷100
p["攻击"]=math.modf(((4000/math.max(140-p_wuli,30))*(p["等级"]+10)/10+(b["攻击"]+p["士气"])*(p["等级"]+10)/10)*(100+atk)/100)
p["防御"]=math.modf(((4000/math.max(140-p_tongshuai,30))*(p["等级"]+10)/10+(b["防御"]+p["士气"])*(p["等级"]+10)/10)*(100+def)/100)
if CC.Enhancement then
if CheckSkill(id,30) then--无双
p["攻击"]=p["攻击"]+JY.Skill[30]["参数1"]*p["等级"]
p["防御"]=p["防御"]+JY.Skill[30]["参数1"]*p["等级"]
else--有无双，则不考虑勇武和坚韧
if CheckSkill(id,8) then--勇武
p["攻击"]=p["攻击"]+JY.Skill[8]["参数1"]*p["等级"]
end
if CheckSkill(id,9) then--坚韧
p["防御"]=p["防御"]+JY.Skill[9]["参数1"]*p["等级"]
end
end
if JY.Bingzhong[p["兵种"]]["远程"]>0 and CheckSkill(id,24) then--强弓
p["攻击"]=p["攻击"]+JY.Skill[24]["参数1"]*p["等级"]
p["防御"]=p["防御"]+JY.Skill[24]["参数1"]*p["等级"]
end
if JY.Bingzhong[p["兵种"]]["骑马"]>0 and CheckSkill(id,25) then--强骑
p["攻击"]=p["攻击"]+JY.Skill[25]["参数1"]*p["等级"]
p["防御"]=p["防御"]+JY.Skill[25]["参数1"]*p["等级"]
end
if CheckSkill(id,10) then--速攻
mov=mov+JY.Skill[10]["参数1"]
end
end
p["移动"]=mov
if wid>0 then
War.Person[wid].movestep=mov
end
if flag then
p["兵力"]=p["最大兵力"]
p["策略"]=p["最大策略"]
else
p["兵力"]=limitX(p["兵力"],0,p["最大兵力"])
end
--Buff
if wid>0 then
ReSetBuff(wid)
end
end

function ReSetAllBuff()
for wid,wp in pairs(War.Person) do
if wp.live and (not wp.hide) then
ReSetBuff(wid)
end
end
end

function ReSetBuff(wid)
if wid>0 and CC.Enhancement then
local pid=War.Person[wid].id
local p=JY.Person[pid]
War.Person[wid].atk_buff=0
War.Person[wid].def_buff=0
--地形
local T={[0]=0,20,30,0,0,--森林　20　山地　30
0,0,5,5,0,--村庄　 5 草原　 5
0,0,0,30,10,--鹿寨　30　兵营　10
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0}
local dx=GetWarMap(War.Person[wid].x,War.Person[wid].y,1)
War.Person[wid].def_buff=War.Person[wid].def_buff+T[dx]
--背水
if WarCheckSkill(wid,28) then
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[28]["参数2"]*math.modf(100*(p["最大兵力"]-p["兵力"])/p["最大兵力"]/JY.Skill[28]["参数1"])
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[28]["参数2"]*math.modf(100*(p["最大兵力"]-p["兵力"])/p["最大兵力"]/JY.Skill[28]["参数1"])
else
--猛者
if WarCheckSkill(wid,27) then
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[27]["参数2"]*math.modf(100*(p["最大兵力"]-p["兵力"])/p["最大兵力"]/JY.Skill[27]["参数1"])
end
--不屈
if WarCheckSkill(wid,26) then
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[26]["参数2"]*math.modf(100*(p["最大兵力"]-p["兵力"])/p["最大兵力"]/JY.Skill[26]["参数1"])
end
end
 
--伏兵
if War.Person[wid].was_hide then
if WarCheckSkill(wid,21) then
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[21]["参数1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[21]["参数1"]
end
end
--谨慎
if WarCheckSkill(wid,29) then
War.Person[wid].atk_buff=War.Person[wid].atk_buff-JY.Skill[29]["参数1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[29]["参数2"]
end
--城战
if WarCheckSkill(wid,32) then
-- 00 平原 01 森林 02 山地 03 河流 04 桥梁 05 城墙 06 城池 07 草原
-- 08 村庄 09 悬崖 0A 城门 0B 荒地 0C 栅栏 0D 鹿砦 0E 兵营 0F 粮仓
-- 10 宝物库 11 房舍 12 火焰 13 浊流
if dx==6 or dx==13 or dx==14 then
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[32]["参数1"]
end
end
--龙胆
if WarCheckSkill(wid,49) then
local value=0
local array=WarGetAtkFW(War.Person[wid].x,War.Person[wid].y,2)
for i=1,4 do
local eid=GetWarMap(array[i][1],array[i][2],2)
if eid>0 then
if War.Person[wid].enemy~=War.Person[eid].enemy then
value=value+JY.Skill[49]["参数1"]
end
end
end
for i=5,8 do
local eid=GetWarMap(array[i][1],array[i][2],2)
if eid>0 then
if War.Person[wid].enemy~=War.Person[eid].enemy then
value=value+JY.Skill[49]["参数2"]
end
end
end
War.Person[wid].atk_buff=War.Person[wid].atk_buff+value
War.Person[wid].def_buff=War.Person[wid].def_buff+value
end
--布阵类
local bz_flag=true
--[[
--八阵
if bz_flag then
if War.Person[wid].enemy then
if CheckSkill(War.Leader2,38) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[38]["参数1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[38]["参数1"]
end
else
if CheckSkill(War.Leader1,38) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[38]["参数1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[38]["参数1"]
end
end
end
if bz_flag then
if WarCheckSkill(wid,38) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[38]["参数1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[38]["参数1"]
end
end
--魏武
if bz_flag then
if War.Person[wid].enemy then
if CheckSkill(War.Leader2,37) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[37]["参数1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[37]["参数1"]
end
else
if CheckSkill(War.Leader1,37) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[37]["参数1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[37]["参数1"]
end
end
end
if bz_flag then
if WarCheckSkill(wid,37) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[37]["参数1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[37]["参数1"]
end
end
]]--
--布阵
if bz_flag then
if War.Person[wid].enemy then
if CheckSkill(War.Leader2,36) then
bz_flag=false
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[36]["参数1"]
end
else
if CheckSkill(War.Leader1,36) then
bz_flag=false
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[36]["参数1"]
end
end
end
if bz_flag then
if CC.Enhancement and WarCheckSkill(wid,36) then
bz_flag=false
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[36]["参数1"]
end
end
War.Person[wid].atk_buff=limitX(War.Person[wid].atk_buff,-50,95)
War.Person[wid].def_buff=limitX(War.Person[wid].def_buff,-50,95)
end
end

--行动顺序的判定以自动补给后的数据为准．
--最优先行动的是处于恢复性地形（村庄、兵营、鹿砦）中的部队，若有数只部队处于恢复性地形上，则以其在屏幕右上方的敌军列表中的顺序排列．
--第二优先行动的是兵力小于最大兵力的40％或士气低于40的部队，若右数只部门处于该情形下，则以其在屏幕右上方的敌军列表中的顺序进行排列．
--最后余下的部队按屏幕右上方的敌军列表中的顺序进行排列．
function AI()
War.ControlEnableOld=War.ControlEnable
War.ControlEnable=false
--友军
local flag=true
--最优先行动的
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
local dx=GetWarMap(v.x,v.y,1)
if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and v.friend and v.active and (dx==8 or dx==13 or dx==14) then
War.ControlEnable=false
War.InMap=false
if flag then
--友军状况
WarDrawStrBoxDelay('友军状况',M_White)
flag=false
end
AI_Sub(i)
end
end
--第二优先行动的
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and v.friend and v.active and (JY.Person[v.id]["兵力"]/JY.Person[v.id]["最大兵力"]<=0.4 or JY.Person[v.id]["士气"]<=40) then
War.ControlEnable=false
War.InMap=false
if flag then
--友军状况
WarDrawStrBoxDelay('友军状况',M_White)
flag=false
end
AI_Sub(i)
end
end
--余下的部队
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and v.friend and v.active then
War.ControlEnable=false
War.InMap=false
if flag then
--友军状况
WarDrawStrBoxDelay('友军状况',M_White)
flag=false
end
AI_Sub(i)
end
end
--敌军
WarGetAramyAtkFW()
flag=true
--最优先行动的
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
local dx=GetWarMap(v.x,v.y,1)
if v.live and (not v.hide) and (not v.troubled) and v.enemy and v.active and (v.bz==13 or v.bz==19) then
War.ControlEnable=false
War.InMap=false
if flag then
--敌军状况
WarDrawStrBoxDelay('敌军状况',M_White)
flag=false
end
AI_Sub(i)
end
end
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
local dx=GetWarMap(v.x,v.y,1)
if v.live and (not v.hide) and (not v.troubled) and v.enemy and v.active and (dx==8 or dx==13 or dx==14) then
War.ControlEnable=false
War.InMap=false
if flag then
--敌军状况
WarDrawStrBoxDelay('敌军状况',M_White)
flag=false
end
AI_Sub(i)
end
end
--第二优先行动的
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
if v.live and (not v.hide) and (not v.troubled) and v.enemy and v.active and (JY.Person[v.id]["兵力"]/JY.Person[v.id]["最大兵力"]<=0.4 or JY.Person[v.id]["士气"]<=40) then
War.ControlEnable=false
War.InMap=false
if flag then
--敌军状况
WarDrawStrBoxDelay('敌军状况',M_White)
flag=false
end
AI_Sub(i)
end
end
--余下的部队
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
if v.live and (not v.hide) and (not v.troubled) and v.enemy and v.active then
War.ControlEnable=false
War.InMap=false
if flag then
--敌军状况
WarDrawStrBoxDelay('敌军状况',M_White)
flag=false
end
AI_Sub(i)
end
end
War.ControlEnable=War.ControlEnableOld
end

function WarGetAramyAtkFW()
CleanWarMap(8,0)
for i,v in pairs(War.Person) do
if not v.enemy then
if not v.hide then
if v.live then
local len=1
if v.atkfw==2 or v.atkfw==3 then
len=2
elseif v.atkfw==4 then
len=3
elseif v.atkfw==5 then
len=4
end
CleanWarMap(5,-1)
local steparray=War_CalMoveStep(i,v.movestep+len)
for j=0,v.movestep+len do
for k=1,steparray[j].num do
local mx,my=steparray[j].x[k],steparray[j].y[k]
SetWarMap(mx,my,8,GetWarMap(mx,my,8)+1)
end
end
end
end
end
end
CleanWarMap(5,-1)
end

function WarGetAramyAtkFW()
CleanWarMap(8,0)
for i,v in pairs(War.Person) do
if not v.enemy then
if not v.hide then
if v.live then
local array=WarGetAtkFW(v.x,v.y,2)
for j=1,array.num do
local mx,my=array[j][1],array[j][2]
if between(mx,1,War.Width) and between(my,1,War.Depth) then
local n=2
if j>4 then
n=1
end
local ov=GetWarMap(mx,my,8)
if n>ov then
SetWarMap(mx,my,8,n)
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
War.SelID=id
local wp=War.Person[id]
local id1=wp.id
--XXX的移动
CleanWarMap(5,-1)
CleanWarMap(6,-1)
CleanWarMap(7,-1)
local dx,dy=wp.x,wp.y
local dv=0
if JY.Base["敌军出击"]==1 then
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
--AI类型＝03 追击指定目标 当追击目标消失时--〉主动出击
if wp.ai==3 then
local eid=GetWarID(wp.aitarget)
if not (eid>0 and War.Person[eid].live) then
 wp.ai=1
end
end
if wp.ai~=2 then--除了 坚守原地型 以外，其他的ai类型都需要考虑移动
local steparray=War_CalMoveStep(id,wp.movestep)
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
if GetWarMap(mx,my,2)==0 or (mx==wp.x and my==wp.y) then
local v=WarGetMoveValue(id,mx,my)
if v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
--如果部队的兵力不足（即兵力小于最大兵力的40％或士气小于40，下同）．
if dv<50 then
if JY.Person[id1]["兵力"]/JY.Person[id1]["最大兵力"]<=0.4 then
local eid=WarSearchBZ(id,19)
if eid>0 then
did=eid
 dv=0
 WarSearchMove(id,War.Person[eid].x,War.Person[eid].y)
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
local v=GetWarMap(mx,my,4)
if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
elseif JY.Person[id1]["士气"]<=40 then
local eid=WarSearchBZ(id,13)
if eid>0 then
did=eid
dv=0
WarSearchMove(id,War.Person[eid].x,War.Person[eid].y)
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
local v=GetWarMap(mx,my,4)
if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
end
end
if dv>0 then--移动范围有目标
if dx~=wp.x or dy~=wp.y then--需要移动
War_CalMoveStep(id,wp.movestep)
BoxBack()
War_MovePerson(dx,dy)
War.ControlEnable=false
War.InMap=false
end
else--一次移动范围内无目标
if wp.ai==1 then--考虑移动到最近敌人
local eid=WarSearchEnemy(id)
if eid>0 then
did=eid
WarSearchMove(id,War.Person[eid].x,War.Person[eid].y)
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
local v=GetWarMap(mx,my,4)
v=v+1-math.max(math.abs(mx-War.Person[eid].x),math.abs(my-War.Person[eid].y))/100
if wp.enemy then
local ddv=GetWarMap(mx,my,8)
v=v-ddv
end
if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
elseif wp.ai==3 or wp.ai==5 then
local eid=GetWarID(wp.aitarget)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
did=eid
WarSearchMove(id,War.Person[eid].x,War.Person[eid].y)
if GetWarMap(wp.x,wp.y,4)==0 then
WarSearchMove(id,War.Person[eid].x,War.Person[eid].y,true)--如果找不到路径，则无视敌人拦路，再找一次
end
if GetWarMap(wp.x,wp.y,4)==0 then
eid=WarSearchEnemy(id)
if eid>0 then
did=eid
WarSearchMove(id,War.Person[eid].x,War.Person[eid].y)--如果找不到路径，则移动到最近敌人
end
end
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
local v=GetWarMap(mx,my,4)
v=v+1-math.max(math.abs(mx-War.Person[eid].x),math.abs(my-War.Person[eid].y))/100
if wp.enemy then
local ddv=GetWarMap(mx,my,8)
if wp.bz==13 or wp.bz==16 or wp.bz==19 then
v=v-ddv
end
end
if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
elseif wp.ai==4 or wp.ai==6 then
WarSearchMove(id,wp.ai_dx,wp.ai_dy)
if GetWarMap(wp.x,wp.y,4)==0 then
WarSearchMove(id,wp.ai_dx,wp.ai_dy,true)--如果找不到路径，则无视敌人拦路，再找一次
end
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
local v=GetWarMap(mx,my,4)
v=v+1-math.max(math.abs(mx-wp.ai_dx),math.abs(my-wp.ai_dy))/100
if wp.enemy then
local ddv=GetWarMap(mx,my,8)
if wp.bz==13 or wp.bz==16 or wp.bz==19 then
v=v-ddv
end
end
if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
if dx~=wp.x or dy~=wp.y then
War_CalMoveStep(id,wp.movestep)
BoxBack()
War_MovePerson(dx,dy)
War.ControlEnable=false
War.InMap=false
end
end
end
CleanWarMap(4,1)
--XXX的攻击
local eid=0
dv=0
if wp.ai==5 or wp.ai==6 then
else
local atkarray=WarGetAtkFW(dx,dy,War.Person[id].atkfw)
for i=1,atkarray.num do
if atkarray[i][1]>0 and atkarray[i][1]<=War.Width and atkarray[i][2]>0 and atkarray[i][2]<=War.Depth then
local v=WarGetAtkValue(id,atkarray[i][1],atkarray[i][2])
if v>dv then
dv=v
eid=GetWarMap(atkarray[i][1],atkarray[i][2],2)
end
end
end
local mv,magicx,magicy=WarGetMagicValue(id,dx,dy)
if mv>0 then
--策略系部队，如果物理攻击价值低于100，则为0（new）
if wp.bz==13 or wp.bz==16 or wp.bz==19 then
if dv<100 then
dv=0
end
end
end
if mv>dv and flag==nil then
local mid=GetWarMap(magicx,magicy,7)
eid=GetWarMap(magicx,magicy,2)
did=eid
BoxBack()
WarDrawStrBoxDelay(string.format("%s使用%s计．",JY.Person[id1]["姓名"],JY.Magic[mid]["名称"]),M_White)
WarMagic(id,eid,mid)
if CC.Enhancement and WarCheckSkill(id,119) then
if (JY.Magic[mid]["类型"]==1 or JY.Magic[mid]["类型"]==2 or JY.Magic[mid]["类型"]==3) and JY.Magic[mid]["效果范围"]==11 then
WarMagic(id,eid,mid)
end
end
if CC.Enhancement and WarCheckSkill(id,112) then--七星剑 策略值消耗减半
JY.Person[id1]["策略"]=JY.Person[id1]["策略"]-math.modf(JY.Magic[mid]["消耗"]/2)
else
JY.Person[id1]["策略"]=JY.Person[id1]["策略"]-JY.Magic[mid]["消耗"]
end
JY.Person[id1]["策略"]=limitX(JY.Person[id1]["策略"],0,JY.Person[id1]["最大策略"])
else
if eid>0 then
did=eid
BoxBack()
local xsgj=false
if CC.Enhancement and WarCheckSkill(eid,117) then
if JY.Person[War.Person[eid].id]["兵力"]>0 and (not War.Person[eid].troubled) then
if JY.Bingzhong[War.Person[eid].bz]["可反击"]==1 and JY.Bingzhong[War.Person[id].bz]["被反击"]==1 then
xsgj=true
elseif CC.Enhancement then
if WarCheckSkill(eid,42) then--反击(特技)
xsgj=true
end
end
end
end
if xsgj then
--检查是否在攻击范围内
xsgj=false
local xs_arrary=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,War.Person[eid].atkfw)
for n=1,xs_arrary.num do
if between(xs_arrary[n][1],1,War.Width) and between(xs_arrary[n][2],1,War.Depth) then
if GetWarMap(xs_arrary[n][1],xs_arrary[n][2],2)==id then
xsgj=true
break
end
end
end
end

if xsgj then
--反击概率＝我军武将武力÷150
if CC.Enhancement and WarCheckSkill(eid,102) then--刘备装备雌雄双剑 被攻击时必定反击
WarAtk(eid,id,1)
WarResetStatus(id)
elseif CC.Enhancement and WarCheckSkill(eid,19) then--报复
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
WarAtk(eid,id)
WarResetStatus(id)
if JY.Person[War.Person[id].id]["兵力"]>0 then
WarAtk(eid,id)
WarResetStatus(id)
end
elseif smfj==1 then
WarAtk(eid,id,1)
WarResetStatus(id)
if JY.Person[War.Person[id].id]["兵力"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
elseif smsh==1 then
WarAtk(eid,id)
WarResetStatus(id)
else
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["兵力"]>0 then
WarAtk(id,eid,1)
WarResetStatus(eid)
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
WarAtk(eid,id)
WarResetStatus(id)
if JY.Person[War.Person[id].id]["兵力"]>0 then
WarAtk(eid,id)
WarResetStatus(id)
end
elseif smfj==1 then
WarAtk(eid,id,1)
WarResetStatus(id)
if JY.Person[War.Person[id].id]["兵力"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
elseif smsh==1 then
WarAtk(eid,id)
WarResetStatus(id)
else
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["兵力"]>0 then
WarAtk(id,eid,1)
WarResetStatus(eid)
end
end
end
end
if JY.Person[War.Person[id].id]["兵力"]>0 then
WarAtk(id,eid)
WarResetStatus(eid)
end
--混乱攻击
if CC.Enhancement and WarCheckSkill(id,116) then
if JY.Person[War.Person[eid].id]["兵力"]>0 then
War.Person[eid].troubled=true
War.Person[eid].action=7
WarDelay(2)
WarDrawStrBoxDelay(JY.Person[War.Person[eid].id]["姓名"].."混乱了！",M_White)
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
if CC.Enhancement and WarCheckSkill(id,114) then--英雄之剑 穿刺攻击
local mx=War.Person[id].x
local my=War.Person[id].y
local xx=War.Person[eid].x
local yy=War.Person[eid].y
local dx=mx-xx
local dy=my-yy
local eid2=0
if dx>0 and dy==0 then--先确定被攻击者在攻击者左边方向
if GetWarMap(xx-1,yy,2)>0 then--然后确认是被攻击者左边那一格的对象
eid2=GetWarMap(xx-1,yy,2)--获取这一格的人物id编号
if War.Person[eid].enemy==War.Person[eid2].enemy then--最后确定与被攻击者同阵营
WarAtk(id,eid2)--攻击
WarResetStatus(eid2)
end
end
end
if dx<0 and dy==0 and GetWarMap(xx+1,yy,2)>0 then--右
eid2=GetWarMap(xx+1,yy,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx==0 and dy>0 and GetWarMap(xx,yy-1,2)>0 then--上
eid2=GetWarMap(xx,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx==0 and dy<0 and GetWarMap(xx,yy+1,2)>0 then--下
eid2=GetWarMap(xx,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx>0 and dy>0 and GetWarMap(xx-1,yy-1,2)>0 and dx==dy then--左上
eid2=GetWarMap(xx-1,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx<0 and dy>0 and GetWarMap(xx+1,yy-1,2)>0 and dx==-(dy) then--右上
eid2=GetWarMap(xx+1,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx>0 and dy<0 and GetWarMap(xx-1,yy+1,2)>0 and -(dx)==dy then--左下
eid2=GetWarMap(xx-1,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx<0 and dy<0 and GetWarMap(xx+1,yy+1,2)>0 and dx==dy then--右下
eid2=GetWarMap(xx+1,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
end
--反击
local fsfj=false--装备青龙偃月刀的人不是关羽时封杀反击
if CC.Enhancement and WarCheckSkill(id,105) then
fsfj=true
end
if JY.Person[War.Person[eid].id]["兵力"]>0 and (not War.Person[eid].troubled) and fsfj==false and xsgj==false then
--只有贼兵（山贼、恶贼、义贼）和武术家能反击敌军的物理攻击。
--攻击方兵种为骑兵、贼兵、猛兽兵团、武术家、异民族时，才可能产生反击。
--攻击方兵种为步兵、弓兵、军乐队、妖术师、运输队时，不可能发生反击。
--攻击方为新增兵种时，都可以产生反击
local fj_flag=false
if JY.Bingzhong[War.Person[eid].bz]["可反击"]==1 and JY.Bingzhong[War.Person[id].bz]["被反击"]==1 then
fj_flag=true
elseif CC.Enhancement and WarCheckSkill(eid,102) then--刘备装备雌雄双剑 被攻击时必定反击
fj_flag=true
elseif CC.Enhancement and WarCheckSkill(eid,42) then--反击(特技)
fj_flag=true
end
if fj_flag then
--检查是否在攻击范围内
fj_flag=false
local fj_arrary=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,War.Person[eid].atkfw)
for n=1,fj_arrary.num do
if between(fj_arrary[n][1],1,War.Width) and between(fj_arrary[n][2],1,War.Depth) then
if GetWarMap(fj_arrary[n][1],fj_arrary[n][2],2)==id then
fj_flag=true
break
end
end
end
end
if fj_flag then
--反击概率＝我军武将武力÷150
if CC.Enhancement and WarCheckSkill(eid,102) then--刘备装备雌雄双剑 被攻击时必定反击
WarAtk(eid,id,1)
WarResetStatus(id)
elseif CC.Enhancement and WarCheckSkill(eid,19) then--报复
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
WarAtk(eid,id)
WarResetStatus(id)
if JY.Person[War.Person[id].id]["兵力"]>0 then
WarAtk(eid,id)
WarResetStatus(id)
end
elseif smfj==1 then
WarAtk(eid,id,1)
WarResetStatus(id)
if JY.Person[War.Person[id].id]["兵力"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
elseif smsh==1 then
WarAtk(eid,id)
WarResetStatus(id)
else
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["兵力"]>0 then
WarAtk(id,eid,1)
WarResetStatus(eid)
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
WarAtk(eid,id)
WarResetStatus(id)
if JY.Person[War.Person[id].id]["兵力"]>0 then
WarAtk(eid,id)
WarResetStatus(id)
end
elseif smfj==1 then
WarAtk(eid,id,1)
WarResetStatus(id)
if JY.Person[War.Person[id].id]["兵力"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
elseif smsh==1 then
WarAtk(eid,id)
WarResetStatus(id)
else
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["兵力"]>0 then
WarAtk(id,eid,1)
WarResetStatus(eid)
end
end
end
end
end
end
end
War.ControlEnable=false
War.InMap=false
end
wp.active=false
wp.action=0
WarResetStatus(id)
WarCheckStatus()
War.LastID=War.SelID
War.SelID=0
WarDelay(CC.WarDelay)
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
local id1=War.Person[pid].id
local wp=War.Person[pid]
local atkarray=WarGetAtkFW(x,y,War.Person[pid].atkfw)
local dv=0
if wp.ai==5 or wp.ai==6 then
dv=0
else
for i=1,atkarray.num do
if atkarray[i][1]>0 and atkarray[i][1]<=War.Width and atkarray[i][2]>0 and atkarray[i][2]<=War.Depth then
local v=WarGetAtkValue(pid,atkarray[i][1],atkarray[i][2])
if v>0 then--远距攻击额外附加
if i<=4 then
elseif i<=8 then
v=v+2
elseif i<=16 then
v=v+3
elseif i<=24 then
v=v+4
end
end
if v>dv then
dv=v
end
end
end
local mv=WarGetMagicValue(pid,x,y)
--策略系部队，如果物理攻击价值低于100，则为0（new）
if wp.bz==13 or wp.bz==16 or wp.bz==19 then
if dv<100 then
dv=0
end
end
if mv>dv then
dv=mv
end
end
local dx=GetWarMap(x,y,1)
if dv>0 then
--当部队处于有防御加成的地形时，行动价值＝行动价值＋防御加成÷5--2.5
if dx==1 then--可恢复地形 额外+5（自己新增的）
dv=dv+8
elseif dx==2 then
dv=dv+10
elseif dx==7 then
dv=dv+2
elseif dx==8 then
dv=dv+2+5
elseif dx==13 then
dv=dv+12+5
elseif dx==14 then
dv=dv+4+5
end
--根据AI再附加
if wp.ai==3 or wp.ai==5 then
local eid=GetWarID(wp.aitarget)
if eid>0 then
local tx,ty=War.Person[eid].x,War.Person[eid].y
dv=dv+5*(wp.movestep-math.abs(tx-x)-math.abs(ty-y))
end
elseif wp.ai==4 or wp.ai==6 then
local tx,ty=wp.ai_dx,wp.ai_dy
dv=dv+5*(wp.movestep-math.abs(tx-x)-math.abs(ty-y))
end
end
--如果部队的兵力不足（即兵力小于最大兵力的40％或士气小于40，下同），则战场上存在可恢复地形的坐标，行动价值加50．
if JY.Person[id1]["兵力"]/JY.Person[id1]["最大兵力"]<=0.4 or JY.Person[id1]["士气"]<=40 then
if dx==8 or dx==13 or dx==14 then
dv=dv+50
end
end
--新增的，mp不足时，靠近军乐队
for d=1,4 do
local sid=0
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if between(nx,1,War.Width) and between(ny,1,War.Depth) then
sid=GetWarMap(nx,ny,2)
if sid>0 and sid~=pid then
if War.Person[sid].enemy==wp.enemy and War.Person[sid].bz==13 then
if JY.Person[id1]["策略"]/JY.Person[id1]["最大策略"]<=0.4 then
dv=dv+10
break
end
end
end
end
end
if wp.enemy then
local ddv=GetWarMap(x,y,8)
if wp.bz==13 or wp.bz==16 or wp.bz==19 then
dv=dv-ddv
end
end
return dv
end

function HaveMagic(pid,mid)
local bz=JY.Person[pid]["兵种"]
local lv=JY.Person[pid]["等级"]
if JY.Status~=GAME_WMAP then
if between(mid,1,36) then
if between(JY.Bingzhong[bz]["策略"..mid],1,lv) then
return true
end
end
else
local eid=0
local eid2=0
local eid3=0
local eid4=0
local id=War.SelID
local mx=War.Person[id].x
local my=War.Person[id].y
if CC.Enhancement and WarCheckSkill(id,101) then--策略模仿
if GetWarMap(mx-1,my,2)>0 then--左
eid=GetWarMap(mx-1,my,2)
end
if GetWarMap(mx+1,my,2)>0 then--右
eid2=GetWarMap(mx+1,my,2)
end
if GetWarMap(mx,my-1,2)>0 then--上
eid3=GetWarMap(mx,my-1,2)
end
if GetWarMap(mx,my+1,2)>0 then--下
eid4=GetWarMap(mx,my+1,2)
end
end
if between(mid,1,36) then
if between(JY.Bingzhong[bz]["策略"..mid],1,lv) then
return true
end
if eid>0 and between(JY.Bingzhong[JY.Person[eid]["兵种"]]["策略"..mid],1,lv) then
return true
elseif eid2>0 and between(JY.Bingzhong[JY.Person[eid2]["兵种"]]["策略"..mid],1,lv) then
return true
elseif eid3>0 and between(JY.Bingzhong[JY.Person[eid3]["兵种"]]["策略"..mid],1,lv) then
return true
elseif eid4>0 and between(JY.Bingzhong[JY.Person[eid4]["兵种"]]["策略"..mid],1,lv) then
return true
end
end
end
if CC.Enhancement then
if mid==37 then
if CheckSkill(pid,1) then
if lv>=JY.Skill[1]["参数1"] then
return true
end
end
elseif mid==38 then
if CheckSkill(pid,1) then
if lv>=JY.Skill[1]["参数2"] then
return true
end
end
elseif mid==39 then
if CheckSkill(pid,4) then
if lv>=JY.Skill[4]["参数1"] then
return true
end
end
elseif mid==40 then
if CheckSkill(pid,3) then
if lv>=JY.Skill[3]["参数1"] then
return true
end
end
elseif mid==41 then
if CheckSkill(pid,39) then
if lv>=JY.Skill[39]["参数2"] then
return true
end
end
elseif mid==42 then
if CheckSkill(pid,39) then
if lv>=JY.Skill[39]["参数3"] then
return true
end
end
elseif mid==43 then
if CheckSkill(pid,40) or CheckSkill(pid,5) then
if lv>=JY.Skill[40]["参数1"] then
return true
end
end
elseif mid==44 then
if CheckSkill(pid,40) or CheckSkill(pid,5) then
if lv>=JY.Skill[40]["参数2"] then
return true
end
end
elseif mid==46 then
if CheckSkill(pid,38) then
if lv>=JY.Skill[38]["参数2"] then
return true
end
end
end
end
return false
end

function WarHaveMagic(wid,mid)
local pid=War.Person[wid].id
return HaveMagic(pid,mid)
end

function WarGetMagicValue(pid,x,y)
local dv=0
local dx,dy
local bz=War.Person[pid].bz
local id1=War.Person[pid].id
local lv=JY.Person[id1]["等级"]
local ox,oy=War.Person[pid].x,War.Person[pid].y
War.Person[pid].x,War.Person[pid].y=x,y
SetWarMap(ox,oy,2,0)
SetWarMap(x,y,2,pid)
for mid=1,JY.MagicNum-1 do
if WarHaveMagic(pid,mid) then
if JY.Person[id1]["策略"]>=JY.Magic[mid]["消耗"] then--mp enough?
if true then--dx?
local kind=JY.Magic[mid]["类型"]
local fw=JY.Magic[mid]["施展范围"]
local array=WarGetAtkFW(x,y,fw)
for j=1,array.num do
local mx,my=array[j][1],array[j][2]
if between(mx,1,War.Width) and between(my,1,War.Depth) then
local eid=GetWarMap(mx,my,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(pid,eid,mid) then--check dx
if ((between(kind,1,5) or between(kind,9,10)) and War.Person[pid].enemy~=War.Person[eid].enemy) or (between(kind,6,8) and War.Person[pid].enemy==War.Person[eid].enemy) then
local v,select_magic=WarGetMagicValue_sub(pid,mx,my)
if v>dv and mid==select_magic then
dv=v
dx,dy=mx,my
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
War.Person[pid].x,War.Person[pid].y=ox,oy
SetWarMap(x,y,2,0)
SetWarMap(ox,oy,2,pid)
return dv,dx,dy
end

function WarGetMagicValue_sub(pid,x,y)
local id1,id2
id1=War.Person[pid].id
local bz=War.Person[pid].bz
local lv=JY.Person[id1]["等级"]
local oid=GetWarMap(x,y,2)
local dv=GetWarMap(x,y,6)
local select_magic=GetWarMap(x,y,7)
local hp={600,1200,1800}
local sp={30,40,50}
if dv==-1 then
dv=0
local v=0
for mid=1,JY.MagicNum-1 do
if WarHaveMagic(pid,mid) then
if JY.Person[id1]["策略"]>=JY.Magic[mid]["消耗"] then--mp enough?
if oid>0 and War.Person[oid].live and (not War.Person[oid].hide) then
if WarMagicCheck(pid,oid,mid) then--地形，天气
local kind=JY.Magic[mid]["类型"]
local power=JY.Magic[mid]["效果"]
local fw=JY.Magic[mid]["效果范围"]
if between(kind,1,3) or between(kind,9,10) then--火水石/毒雷
 v=0
if War.Person[pid].enemy~=War.Person[oid].enemy then
local array=WarGetAtkFW(x,y,fw)
for j=1,array.num do
local dx,dy=array[j][1],array[j][2]
if between(dx,1,War.Width) and between(dy,1,War.Depth) then
local eid=GetWarMap(dx,dy,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy~=War.Person[eid].enemy and WarMagicCheck(pid,eid,mid) then
local hurt=WarMagicHurt(pid,eid,mid)
if hurt>=JY.Person[War.Person[eid].id]["兵力"] then
hurt=hurt*10
end
if math.random()<WarMagicHitRatio(pid,eid,mid)+0.2 then
v=v+hurt
else
v=v+hurt/4
end
end
end
end
end
end
elseif kind==4 then--假情报
v=0
--如果敌人已混乱，加权值＝0
--随机值＝（0～299）的随机数
--根据假情报系策略全分析中的算法计算策略是否成功，如果计算结果是策略成功，加权值＝随机数＋300。
local eid=GetWarMap(x,y,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) and (not War.Person[eid].troubled) then
if War.Person[pid].enemy~=War.Person[eid].enemy then
v=math.random(300)-1
if math.random()<WarMagicHitRatio(pid,eid,mid) then
v=v+300
end
end
end
elseif kind==5 then--牵制
v=0
local eid=GetWarMap(x,y,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy~=War.Person[eid].enemy then
if math.random()<WarMagicHitRatio(pid,eid,mid)+0.2 then
id2=War.Person[eid].id
--基本值＝策略基本威力＋使用者等级÷10－被牵制者等级÷10
--随机值＝1～10的随机数
--加权值＝基本值×随机数
v=power+lv/10-JY.Person[id2]["等级"]/10
v=limitX(v,0,JY.Person[id2]["士气"])
local add=math.random(10)
v=math.modf(v*add)
end
end
end
elseif kind==6 then--激励
v=0
if War.Person[pid].enemy==War.Person[oid].enemy then
local array=WarGetAtkFW(x,y,fw)
for j=1,array.num do
local dx,dy=array[j][1],array[j][2]
if between(dx,1,War.Width) and between(dy,1,War.Depth) then
local eid=GetWarMap(dx,dy,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy==War.Person[eid].enemy then
id2=War.Person[eid].id
--基本值＝策略基本威力＋使用者等级÷10
--随机值＝0～（基本值÷10－1）之间的随机数
--激励值＝基本值＋随机值
local sv=power+lv/10
sv=math.modf(sv*(1+math.random()/10))
sv=limitX(sv,0,War.Person[oid].sq_limited-JY.Person[id2]["士气"])
if sv<10 then
sv=0
end
if JY.Person[id2]["士气"]<40 then
sv=sv*20
end
v=v+sv
end
end
end
end
end
elseif kind==7 then--援助
v=0
if War.Person[pid].enemy==War.Person[oid].enemy then
local array=WarGetAtkFW(x,y,fw)
for j=1,array.num do
local dx,dy=array[j][1],array[j][2]
if between(dx,1,War.Width) and between(dy,1,War.Depth) then
local eid=GetWarMap(dx,dy,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy==War.Person[eid].enemy then
id2=War.Person[eid].id
--策略基本威力＋使用者智力×使用者等级÷20
--随机值＝0～（基本值÷10－1）之间的随机数
--补给值＝基本值＋随机值
local sv=power+JY.Person[id1]["智力2"]*lv/20
sv=math.modf(sv*(1+math.random()/10))
sv=limitX(sv,0,JY.Person[id2]["最大兵力"]-JY.Person[id2]["兵力"])
if sv<JY.Person[id2]["最大兵力"]/10 then
sv=0
end
v=v+sv
end
end
end
end
end
if v/JY.Magic[mid]["消耗"]<50 then
v=0
end
elseif kind==8 then--看护
v=0
if War.Person[pid].enemy==War.Person[oid].enemy then
local array=WarGetAtkFW(x,y,fw)
for j=1,array.num do
local dx,dy=array[j][1],array[j][2]
local eid=GetWarMap(dx,dy,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy==War.Person[eid].enemy then
id2=War.Person[eid].id
local sv=hp[power]+JY.Person[id1]["智力2"]*lv/20
sv=math.modf(sv*(1+math.random()/10))
sv=limitX(sv,0,JY.Person[id2]["最大兵力"]-JY.Person[id2]["兵力"])
if sv<JY.Person[id2]["最大兵力"]/10 then
sv=0
end
v=v+sv
sv=sp[power]+lv/10
sv=math.modf(sv*(1+math.random()/10))
sv=limitX(sv,0,War.Person[oid].sq_limited-JY.Person[id2]["士气"])
if sv<10 then
sv=0
end
if JY.Person[id2]["士气"]<40 then
sv=sv*20
end
v=v+sv
if v<400 then
v=0
end
end
end
end
end
end
end
v=math.modf(v/(JY.Magic[mid]["消耗"]+12))
if v>dv then
dv=v
select_magic=mid
end
end
end
end
end
SetWarMap(x,y,6,dv)
SetWarMap(x,y,7,select_magic)
end
return dv,select_magic
end

function WarGetAtkValue(pid,x,y)
local id1,id2
id1=War.Person[pid].id
local bz=War.Person[pid].bz
local v=GetWarMap(x,y,5)
if v==-1 then
v=0
local eid=GetWarMap(x,y,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy~=War.Person[eid].enemy then
id2=War.Person[eid].id
v=WarAtkHurt(pid,eid,0)
if v>=JY.Person[id2]["兵力"] then--一击必杀额外附加
v=v+1600
elseif JY.Person[id2]["兵力"]<JY.Person[id2]["最大兵力"]/2 then--敌军军力低时按兵力附加
v=v+math.modf((JY.Person[id2]["最大兵力"]-JY.Person[id2]["兵力"])/6)
end
--行动价值＝基本值÷16．
v=math.modf(v/16)
--如果攻击的是仇人，行动价值＝行动价值＋30
if id2==War.Person[pid].aitarget then
v=v+30
end
--如果攻击的是主将，行动价值=行动价值+?
if War.Person[eid].leader then
v=v+16
end
end
end
SetWarMap(x,y,5,v)
end
return v
end

function WarGetAtkFW(x,y,fw)
local atkarray={}
if fw==1 then--短兵
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
atkarray.num=4
elseif fw==2 then--长兵
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
atkarray.num=8
elseif fw==3 then--弓兵
--1
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
atkarray.num=8
elseif fw==4 then--弩兵
--1
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
--3
table.insert(atkarray,{x-1,y+2})
table.insert(atkarray,{x-1,y-2})
table.insert(atkarray,{x+2,y-1})
table.insert(atkarray,{x-2,y-1})
table.insert(atkarray,{x+1,y+2})
table.insert(atkarray,{x+1,y-2})
table.insert(atkarray,{x+2,y+1})
table.insert(atkarray,{x-2,y+1})
atkarray.num=16
elseif fw==5 then--连弩兵
--1
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
--3
table.insert(atkarray,{x-1,y+2})
table.insert(atkarray,{x-1,y-2})
table.insert(atkarray,{x+2,y-1})
table.insert(atkarray,{x-2,y-1})
table.insert(atkarray,{x+1,y+2})
table.insert(atkarray,{x+1,y-2})
table.insert(atkarray,{x+2,y+1})
table.insert(atkarray,{x-2,y+1})
--4
table.insert(atkarray,{x+2,y+2})
table.insert(atkarray,{x+2,y-2})
table.insert(atkarray,{x-2,y+2})
table.insert(atkarray,{x-2,y-2})
table.insert(atkarray,{x,y+3})
table.insert(atkarray,{x,y-3})
table.insert(atkarray,{x+3,y})
table.insert(atkarray,{x-3,y})
atkarray.num=24
elseif fw==6 then--投石车
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x-2,y})
--3
table.insert(atkarray,{x,y+3})
table.insert(atkarray,{x+1,y+2})
table.insert(atkarray,{x+2,y+1})
table.insert(atkarray,{x+3,y})
table.insert(atkarray,{x+2,y-1})
table.insert(atkarray,{x+1,y-2})
table.insert(atkarray,{x,y-3})
table.insert(atkarray,{x-1,y+2})
table.insert(atkarray,{x-2,y-1})
table.insert(atkarray,{x-3,y})
table.insert(atkarray,{x-2,y+1})
table.insert(atkarray,{x-1,y-2})
--4
table.insert(atkarray,{x,y+4})
table.insert(atkarray,{x+1,y+3})
table.insert(atkarray,{x+2,y+2})
table.insert(atkarray,{x+3,y+1})
table.insert(atkarray,{x+4,y})
table.insert(atkarray,{x+3,y-1})
table.insert(atkarray,{x+2,y-2})
table.insert(atkarray,{x+1,y-3})
table.insert(atkarray,{x,y-4})
table.insert(atkarray,{x-1,y-3})
table.insert(atkarray,{x-2,y-2})
table.insert(atkarray,{x-3,y-1})
table.insert(atkarray,{x-4,y})
table.insert(atkarray,{x-3,y+1})
table.insert(atkarray,{x-2,y+2})
table.insert(atkarray,{x-1,y+3})
atkarray.num=36
elseif fw==7 then--突骑兵
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
atkarray.num=12
elseif fw==8 then--米字
for i=1,2 do
table.insert(atkarray,{x-i,y})
table.insert(atkarray,{x+i,y})
table.insert(atkarray,{x,y-i})
table.insert(atkarray,{x,y+i})
table.insert(atkarray,{x-i,y-i})
table.insert(atkarray,{x+i,y-i})
table.insert(atkarray,{x-i,y+i})
table.insert(atkarray,{x+i,y+i})
end
atkarray.num=16
elseif fw==11 then--原地-- 11~20 策略专用
table.insert(atkarray,{x,y})
atkarray.num=1
elseif fw==12 then--五格
table.insert(atkarray,{x,y})
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
atkarray.num=5
elseif fw==13 then--八格
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
atkarray.num=8
elseif fw==14 then--九格
table.insert(atkarray,{x,y})
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
atkarray.num=9
elseif fw==15 then--十二格
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
atkarray.num=12
elseif fw==16 then--十三格
table.insert(atkarray,{x,y})
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
atkarray.num=13
elseif fw==17 then--二十格
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--1
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
--3
table.insert(atkarray,{x-1,y+2})
table.insert(atkarray,{x-1,y-2})
table.insert(atkarray,{x+2,y-1})
table.insert(atkarray,{x-2,y-1})
table.insert(atkarray,{x+1,y+2})
table.insert(atkarray,{x+1,y-2})
table.insert(atkarray,{x+2,y+1})
table.insert(atkarray,{x-2,y+1})
atkarray.num=20
elseif fw==18 then--二十一格
table.insert(atkarray,{x,y})
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--1
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
--3
table.insert(atkarray,{x-1,y+2})
table.insert(atkarray,{x-1,y-2})
table.insert(atkarray,{x+2,y-1})
table.insert(atkarray,{x-2,y-1})
table.insert(atkarray,{x+1,y+2})
table.insert(atkarray,{x+1,y-2})
table.insert(atkarray,{x+2,y+1})
table.insert(atkarray,{x-2,y+1})
atkarray.num=21
elseif fw==19 then
atkarray.num=0
elseif fw==20 then
atkarray.num=0
elseif fw==21 then--选择我方，附近8格
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
atkarray.num=8
elseif fw==22 then--选择我方，附近9格
table.insert(atkarray,{x,y})
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
atkarray.num=9
else
atkarray.num=0
end
return atkarray
end

function WarSetAtkFW(id,fw)
local mx=War.Person[id].x
local my=War.Person[id].y
local atkarray=WarGetAtkFW(mx,my,fw)
CleanWarMap(4,0)
for i=1,atkarray.num do
if between(atkarray[i][1],1,War.Width) and between(atkarray[i][2],1,War.Depth) then
SetWarMap(atkarray[i][1],atkarray[i][2],4,1)
end
end
end

function CheckActive()
--我方全部行动完毕?
if JY.Status~=GAME_WMAP then--当游戏状态改变时，直接结束我方操作
return true
end
for i,v in pairs(War.Person) do
if v.live and (not v.hide) and (not v.enemy) and (not v.friend) and v.active and (not v.troubled) then--任意一人可行动，则返回
return false
end
end
War.ControlStatus='DrawStrBoxYesorNo'
if WarDrawStrBoxYesNo("结束所有部队的命令吗？",M_White) then
return true
else
return false
end
end

function WarCheckStatus()
if JY.Status==GAME_WMAP then
--敌方失败？
local enum=0
for i,v in pairs(War.Person) do
if v.enemy then
if v.live then--and (not v.hide) then
 enum=enum+1
end
end
if v.leader and (not v.live) then
if v.enemy then
JY.Status=GAME_WARWIN
break
else
JY.Status=GAME_WARLOSE
break
end
end
end
if enum==0 and JY.Status==GAME_WMAP then
JY.Status=GAME_WARWIN
end
War.ControlEnableOld=War.ControlEnable
War.ControlEnable=false
War.InMap=false
if DoEvent(JY.EventID) then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN then
DoEvent(JY.EventID)
end
end
War.ControlEnable=War.ControlEnableOld
end
end

--WarDelay(n)
-- 延时，并刷新战场
-- n默认为1
function WarDelay(n)
 n=n or 1
for i=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap(War.CX,War.CY)
lib.GetKey()
ReFresh()
end
end

function WarPersonCenter(id)
if id<1 or id>War.PersonNum then
return false
end
if War.Person[id].live==false then
return false
end
War.SelID=id
BoxBack()
--WarDelay(CC.WarDelay)
War.LastID=War.SelID
War.SelID=0
return true
end

function WarRest()
--人物处于恢复性地形或持有恢复性宝物，可以触发自动恢复．
--村庄、鹿砦可以恢复士气和兵力．兵营可以恢复兵力，但不能恢复士气．
--玉玺可以恢复兵力和士气，援军报告可以恢复兵力，赦命书可以恢复士气．
--地形和宝物的恢复能力不能叠加
for i,v in pairs(War.Person) do
if v.live and (not v.hide) then
local hp,sp=0,0
local hp_times=0
local sp_times=0
local hp_item_flag=false
local sp_item_flag=false
local hp_skill_flag=false
local sp_skill_flag=false
for index=1,8 do
local tid=JY.Person[v.id]["道具"..index]
if JY.Item[tid]["类型"]==7 then
if JY.Item[tid]["效果"]==1 then
hp_item_flag=true
elseif JY.Item[tid]["效果"]==2 then
sp_item_flag=true
elseif JY.Item[tid]["效果"]==3 then
hp_item_flag=true
sp_item_flag=true
end
end
end
if CC.Enhancement then
if WarCheckSkill(i,22) then--治疗
hp_skill_flag=true
end
end
local dx=GetWarMap(v.x,v.y,1)
--08 村庄 0D 鹿砦 0E 兵营
if dx==8 or dx==13 then
hp_times=hp_times+1
sp_times=sp_times+1
elseif dx==14 then
hp_times=hp_times+1
end
if hp_item_flag then
hp_times=hp_times+1
end
if sp_item_flag then
sp_times=sp_times+1
end
if hp_skill_flag then
hp_times=hp_times+1
end
if sp_skill_flag then
sp_times=sp_times+1
end
if hp_times>0 then
--兵力的自动恢复量＝150＋（0～10之间的随机数）×10
hp=150+(math.random(11)-1)*10
--修改为自身兵力的10%-20%
if CC.Enhancement then
hp=math.max(150+(math.random(11)-1)*10,math.modf(JY.Person[v.id]["最大兵力"]/1000*(math.modf(JY.Person[v.id]["统率2"]/10)+1+math.random(10)))*10)
end
--当兵力恢复后离最大兵力的差距不足10时，系统将自动补满该差距
hp=hp*hp_times
if JY.Person[v.id]["最大兵力"]-JY.Person[v.id]["兵力"]-hp<9 then
hp=JY.Person[v.id]["最大兵力"]-JY.Person[v.id]["兵力"]
end
end
if sp_times>0 then
--士气的自动恢复量＝统御力÷10＋（1～5之间的随机数）
sp=math.modf(JY.Person[v.id]["统率2"]/10)+math.random(5)
--与兵力恢复相仿，士气恢复后超过90时，系统将自动不满士气
sp=sp*sp_times
if v.sq_limited-JY.Person[v.id]["士气"]-sp<9 then
sp=v.sq_limited-JY.Person[v.id]["士气"]
end
end
if hp>0 or sp>0 then
War.MX=v.x
War.MY=v.y
War.CX=War.MX-math.modf(War.MW/2)
War.CY=War.MY-math.modf(War.MD/2)
War.CX=limitX(War.CX,1,War.Width-War.MW+1)
War.CY=limitX(War.CY,1,War.Depth-War.MD+1)
WarDelay(16)
local tmax=16
tmax=math.min(16,(math.modf(math.max(2,math.abs(hp)/50,math.abs(sp)))))
local oldbl=JY.Person[v.id]["兵力"]
local oldsq=JY.Person[v.id]["士气"]
for t=0,tmax do
JY.ReFreshTime=lib.GetTime()
JY.Person[v.id]["兵力"]=oldbl+hp*t/tmax
JY.Person[v.id]["士气"]=oldsq+sp*t/tmax
DrawWarMap()
DrawStatusMini(i)
lib.GetKey()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*4)
WarDelay(4)
end
--策略值的自动恢复．
--部队位于军乐队旁边可以自动恢复策略值，恢复量＝每军乐队（等级÷10）点．
if v.bz==13 then
for d=1,4 do
local x,y=v.x+CC.DirectX[d],v.y+CC.DirectY[d]
if between(x,1,War.Width) and between(y,1,War.Depth) then
local eid=GetWarMap(x,y,2)
if eid>0 then
if (not War.Person[eid].hide) and War.Person[eid].live then
local pid=War.Person[eid].id
JY.Person[pid]["策略"]=limitX(JY.Person[pid]["策略"]+math.modf(1+JY.Person[v.id]["等级"]/10),0,JY.Person[pid]["最大策略"])
end
end
end
end
end
if CC.Enhancement then
if WarCheckSkill(i,35) then--百出
JY.Person[v.id]["策略"]=limitX(JY.Person[v.id]["策略"]+math.modf(1+JY.Person[v.id]["等级"]*JY.Skill[35]["参数1"]/100),0,JY.Person[v.id]["最大策略"])
end
end
--自动唤醒．
--每回合系统将试图唤醒混乱中的部队，混乱中部队恢复正常状态的算法如下：
--恢复因子＝0～99的随机数，如果恢复因子小于（统御力＋士气）÷3，那么部队被唤醒．由此看出，统御越高，士气越高，越容易从混乱中苏醒．
--注意：自动唤醒的判定是再自动恢复后进行的，因此是以恢复后的士气为准．
WarTroubleShooting(i)
WarResetStatus(i)
end
end
end

function ESCMenu()
PlayWavE(0)
local menu={
{"回合结束",nil,1},
{"全军委任",nil,1},
{"全军撤退",nil,1},
{"胜利条件",nil,1},
{"功能设定",nil,1},
{"　载入",nil,1},
{"　储存",nil,1},
{"游戏结束",nil,1},
{"　Debug ",nil,0},
}
local file=io.open(CONFIG.CurrentPath .. "Menu.debug")
if(file) then
menu[9][3]=1
end
local r=WarShowMenu(menu,#menu,0,64,64,0,0,1,1,16,M_White,M_White)
WarDelay(CC.WarDelay)
if r==1 then
return WarDrawStrBoxYesNo("结束所有部队的命令吗？",M_White)
elseif r==2 then
if WarDrawStrBoxYesNo("委任剩余部队本回合的命令吗？",M_White) then
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
local dx=GetWarMap(v.x,v.y,1)
if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and (not v.friend) and v.active then
War.ControlEnable=false
War.InMap=false
AI_Sub(i)
end
end
return true
end
elseif r==3 then --全军撤退
WarIni2() --清除当前战场上所有敌军
War.SelID=0--清除光标指向的人物id
War.CurID=0--清除当前行动人id
War.LastID=0--清除上一个被光标指向的人物id
NextEvent(JY.Base["全军撤退"])--重新执行本次战场事件
return true
elseif r==4 then
WarShowTarget()--显示任务目标
elseif r==5 then
SettingMenu()--功能设定
elseif r==6 then--载入
local menu2={
{" 1. ",nil,1},
{" 2. ",nil,1},
{" 3. ",nil,1},
{" 4. ",nil,1},
{" 5. ",nil,1},
}
for id=1,5 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."未使用档案"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,136,"请选择将载入的档案",M_White)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,5) then
if string.sub(menu2[s2][1],5)~="未使用档案" then
if WarDrawStrBoxYesNo(string.format("载入在硬碟的第%d进度，可以吗？",s2),M_White) then
LoadRecord(s2)
end
else
WarDrawStrBoxConfirm("没有数据",M_White,true)
end
end
elseif r==7 then--储存
local menu2={
{" 1. ",nil,1},
{" 2. ",nil,1},
{" 3. ",nil,1},
{" 4. ",nil,1},
{" 5. ",nil,1},
}
for id=1,5 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."未使用档案"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,136,"将档案储存在哪里？",M_White)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,5) then
if WarDrawStrBoxYesNo(string.format("储存在硬碟的第%d号，可以吗？",s2),M_White) then
WarSave(s2)
end
end
elseif r==8 then
if WarDrawStrBoxYesNo('结束游戏吗？',M_White) then
WarDelay(CC.WarDelay)
if WarDrawStrBoxYesNo('再玩一次吗？',M_White) then
WarDelay(CC.WarDelay)
JY.Status=GAME_START
else
WarDelay(CC.WarDelay)
JY.Status=GAME_END
end
end
elseif r==9 then
local menu2={
{" AI查看",nil,1},
{"坐标查看",nil,1},
{"人物调试",nil,1},
{"重置回合",nil,1},
{"控制全体",nil,1},
{"无限行动",nil,1},
{"改变天气",nil,1},
}
local s=WarShowMenu(menu2,#menu2,0,300,128,0,0,1,1,16,M_White,M_White)
WarDelay(CC.WarDelay)
if s==1 then--AI查看
if CC.AIXS==false then
CC.AIXS=true
WarDrawStrBoxWaitKey('开启AI行动方针显示．',M_White)
elseif CC.AIXS==true then
CC.AIXS=false
WarDrawStrBoxWaitKey('关闭AI行动方针显示．',M_White)
end
elseif s==2 then--坐标查看
if CC.XYXS==false then
CC.XYXS=true
WarDrawStrBoxWaitKey('开启坐标显示．',M_White)
elseif CC.XYXS==true then
CC.XYXS=false
WarDrawStrBoxWaitKey('关闭坐标显示．',M_White)
end
elseif s==3 then--人物调试
if CC.RWTS==false then
CC.RWTS=true
WarDrawStrBoxWaitKey('开启人物调试．',M_White)
elseif CC.RWTS then
CC.RWTS=false
WarDrawStrBoxWaitKey('关闭人物调试．',M_White)
end
elseif s==4 then--回合重置
local hhs={}
for hhxh=1,War.MaxTurn do
hhs[hhxh]={fillblank("第"..hhxh.."回合",11),nil,1}
end
local hh=ShowMenu(hhs,#hhs,8,0,0,0,0,6,1,16,M_White,M_White)
if hh>0 then
War.Turn=hh
WarDrawStrBoxWaitKey('回合数已设置为'..hh,M_White)
end
elseif s==5 then--控制全体
if CC.KZAI==false then
CC.KZAI=true
WarDrawStrBoxWaitKey('可操控友军和敌军．',M_White)
elseif CC.KZAI==true then
CC.KZAI=false
WarDrawStrBoxWaitKey('关闭操控友军和敌军功能．',M_White)
end
elseif s==6 then--无限行动
if CC.WXXD==false then
CC.WXXD=true
WarDrawStrBoxWaitKey('开启无限行动功能．',M_White)
elseif CC.WXXD==true then
CC.WXXD=false
WarDrawStrBoxWaitKey('关闭无限行动功能．',M_White)
end
elseif s==7 then
local tqmenu={
{"　 晴",nil,1},
{"　 雲",nil,1},
{"　 雨",nil,1},
}
local tq=ShowMenu(tqmenu,#tqmenu,0,0,0,0,0,1,1,16,M_White,M_White)
if tq==1 then
War.Weather=math.random(3)-1
WarDrawStrBoxWaitKey('现在是晴天．',M_White)
elseif tq==2 then
War.Weather=3
WarDrawStrBoxWaitKey('现在是阴天．',M_White)
elseif tq==3 then
War.Weather=math.random(2)+3
WarDrawStrBoxWaitKey('现在是雨天．',M_White)
end
end
end
return false
end

function SettingMenu() --功能设定
local x,y,w,h
local size=16
w=320
h=128+64
local notWar=true
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=16+(576-0)/2
y=32+(432-0)/2
notWar=false
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-0)/2
y=16+(400-0)/2
notWar=true
else
x=(CC.ScreenW-0)/2
y=(CC.ScreenH-0)/2
notWar=true
end
x=x-w/2
y=y-h/2
local x1=x+254
local x2=x1+52
local y1=y+92+64
local y2=y1+24
local function button(bx,by,str,flag)
local box_w=36
local box_h=18
local cx=bx
local cy=by-1
if flag then--selected
lib.Background(cx+1,cy+1,cx+box_w,cy+box_h,128,M_Black)
lib.DrawRect(cx,cy,cx+box_w,cy,M_Black)
lib.DrawRect(cx,cy,cx,cy+box_h,M_Black)
lib.DrawRect(cx,cy+box_h,cx+box_w,cy+box_h,M_Gray)
lib.DrawRect(cx+box_w,cy,cx+box_w,cy+box_h,M_Gray)
DrawString(cx+box_w/2-size*#str/4,cy+1,str,M_White,size)
else
lib.Background(cx+1,cy+1,cx+box_w,cy+box_h,192,M_Black)
lib.DrawRect(cx,cy,cx+box_w,cy,M_Gray)
lib.DrawRect(cx,cy,cx,cy+box_h,M_Gray)
lib.DrawRect(cx,cy+box_h,cx+box_w,cy+box_h,M_Black)
lib.DrawRect(cx+box_w,cy,cx+box_w,cy+box_h,M_Black)
DrawString(cx+box_w/2-size*#str/4,cy+1,str,M_Silver,size)
end
end
local function redraw(flag)
local T={[0]="关闭","１","２","３","４","５"}
JY.ReFreshTime=lib.GetTime()
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
DrawSMap()
else
end
lib.PicLoadCache(4,80*2,x,y,1)
lib.SetClip(x,y+72,x+w,y+72+128-8)
lib.PicLoadCache(4,80*2,x,y+72-8,1)
lib.SetClip()
DrawString(x+16,y+16,"功能设定",C_Name,size)
DrawStr(x+16,y+40,"音乐",M_White,size)
for i,v in pairs(T) do
if math.modf(CC.MusicVolume/20)==i then
button(x+80+i*38,y+40,v,true)
else
button(x+80+i*38,y+40,v,false)
end
end
DrawStr(x+16,y+60,"音效",M_White,size)
for i,v in pairs(T) do
if math.modf(CC.SoundVolume/10)==i then
button(x+80+i*38,y+60,v,true)
else
button(x+80+i*38,y+60,v,false)
end
end
DrawStr(x+16,y+80,"字形",M_White,size)
if CC.FontType==0 then
button(x+80+1*38,y+80,"１",true)
button(x+80+2*38,y+80,"２",false)
else
button(x+80+1*38,y+80,"１",false)
button(x+80+2*38,y+80,"２",true)
end
if notWar then
DrawStr(x+16,y+100,"繁简",M_White,size)
if CC.font==0 then
button(x+80+1*38,y+100,"简体",true)
button(x+80+2*38,y+100,"繁体",false)
else
button(x+80+1*38,y+100,"简体",false)
button(x+80+2*38,y+100,"繁体",true)
end
DrawStr(x+16,y+120,"敌军出击",M_White,size)
if JY.Base["敌军出击"]>0 then
button(x+80+1*38,y+120,"开启",true)
button(x+80+2*38,y+120,"关闭",false)
else
button(x+80+1*38,y+120,"开启",false)
button(x+80+2*38,y+120,"关闭",true)
end
else
DrawStr(x+16,y+100,"移动加速",M_White,size)
if CC.MoveSpeed==1 then
button(x+80+1*38,y+100,"开启",true)
button(x+80+2*38,y+100,"关闭",false)
else
button(x+80+1*38,y+100,"开启",false)
button(x+80+2*38,y+100,"关闭",true)
end
DrawStr(x+16,y+120,"策略动画",M_White,size)
if CC.cldh==1 then
button(x+80+1*38,y+120,"开启",true)
button(x+80+2*38,y+120,"关闭",false)
else
button(x+80+1*38,y+120,"开启",false)
button(x+80+2*38,y+120,"关闭",true)
end
DrawStr(x+16,y+140,"战斗不语",M_White,size)
if CC.zdby==0 then
button(x+80+1*38,y+140,"开启",false)
button(x+80+2*38,y+140,"关闭",true)
else
button(x+80+1*38,y+140,"开启",true)
button(x+80+2*38,y+140,"关闭",false)
end
end
if flag==1 then
lib.PicLoadCache(4,56*2,x1,y1,1)
end
if notWar then
ShowScreen()--场景变黑再转为变亮
else
ReFresh()
end
end
local current=0
while true do
redraw(current)
getkey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=1
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
if notWar then
lib.Delay(100)
else
WarDelay(4)
end
return
else
current=0
for i=0,5 do
if MOUSE.CLICK(x+80+i*38,y+40,x+80+i*38+36,y+40+16) then
CC.MusicVolume=20*i
Config()
PicCatchIni()
PlayWavE(0)
break
elseif MOUSE.CLICK(x+80+i*38,y+60,x+80+i*38+36,y+60+16) then
CC.SoundVolume=10*i
Config()
PicCatchIni()
PlayWavE(0)
break
end
end
if MOUSE.CLICK(x+80+1*38,y+80,x+80+1*38+36,y+80+16) then
CC.FontType=0
PlayWavE(0)
elseif MOUSE.CLICK(x+80+2*38,y+80,x+80+2*38+36,y+80+16) then
CC.FontType=1
PlayWavE(0)
elseif MOUSE.CLICK(x+80+1*38,y+100,x+80+1*38+36,y+100+16) then
if notWar then
CC.FontName=CONFIG.FontName
CC.font=0
else
CC.MoveSpeed=1
end
PlayWavE(0)
elseif MOUSE.CLICK(x+80+2*38,y+100,x+80+2*38+36,y+100+16) then
if notWar then
CC.FontName=CONFIG.FontName2
CC.font=1
else
CC.MoveSpeed=0
end
PlayWavE(0)
elseif MOUSE.CLICK(x+80+1*38,y+120,x+80+1*38+36,y+120+16) then
if notWar then
JY.Base["敌军出击"]=1
else
CC.cldh=1
end
PlayWavE(0)
elseif MOUSE.CLICK(x+80+2*38,y+120,x+80+2*38+36,y+120+16) then
if notWar then
JY.Base["敌军出击"]=0
else
CC.cldh=0
end
PlayWavE(0)
elseif MOUSE.CLICK(x+80+1*38,y+140,x+80+1*38+36,y+140+16) then
if notWar then
else
CC.zdby=1
end
PlayWavE(0)
elseif MOUSE.CLICK(x+80+2*38,y+140,x+80+2*38+36,y+140+16) then
if notWar then
else
CC.zdby=0
end
PlayWavE(0)
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
local pid=War.Person[id].id
return GetPic(pid,War.Person[id].enemy,War.Person[id].friend)
end

function GetBZPic(pid,enemy,friend)
local pic=20
local bz=JY.Person[pid]["兵种"]
local lv=1
if JY.Person[pid]["等级"]<20 then
lv=1
elseif JY.Person[pid]["等级"]<40 then
lv=2
else
lv=3
end
pic=JY.Bingzhong[bz]["贴图"..lv]
if enemy then
return pic+JY.Bingzhong[bz]["敌军偏移"]
elseif friend then
return pic+JY.Bingzhong[bz]["友军偏移"]
else
return pic+JY.Bingzhong[bz]["我军偏移"]
end 
end

function GetPic(pid,enemy,friend)
--[[
if bz>12 then
 bz=12+(bz-13)*3+lv
end
-- 1 4 7 10 13 16 19 22 25 28 31 34 37 40
-- 步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
local T1={[0]=20,20,170,320, 920,1070,1220, 470,620,770, 1370,1520,1670, 3620,3620,3620, 3170,3170,3170, 1820,1970,2120, 2720,2870,3020, 3320,3320,3320, 3570,3570,3570, 3770,3770,3770, 3920,4070,4220, 4370,4520,4670, 9370,9520,9670,}--敌军 红
local T2={[0]=70,70,220,370, 970,1120,1270, 520,670,820, 1420,1570,1720, 3670,3670,3670, 3220,3220,3220, 1870,2020,2170, 2770,2920,3070, 3370,3370,3370, 3570,3570,3570, 3820,3820,3820, 3970,4120,4270, 4420,4570,4720, 9420,9570,9720,}--友军 黄
local T3={[0]=120,120,270,420, 1020,1170,1320, 570,720,870, 1470,1620,1770, 3720,3720,3720, 3270,3270,3270, 1920,2070,2220, 2820,2970,3120, 3420,3420,3420, 3570,3570,3570, 3870,3870,3870, 4020,4170,4320, 4470,4620,4770, 9470,9620,9770,}--我军 蓝
 
if enemy then
JY.Person[pid]["战斗动作"]=T1[bz] or 20
elseif friend then
JY.Person[pid]["战斗动作"]=T2[bz] or 70
else
JY.Person[pid]["战斗动作"]=T3[bz] or 120
end 
 ]]--
local bz=JY.Person[pid]["兵种"]
local lv=1
if bz==3 or bz==6 or bz==9 or bz==12 then
lv=3
elseif bz==2 or bz==5 or bz==8 or bz==11 then
lv=2
elseif bz==1 or bz==4 or bz==7 or bz==10 then
lv=1
elseif JY.Person[pid]["等级"]<20 then
lv=1
elseif JY.Person[pid]["等级"]<40 then
lv=2
else
lv=3
end
JY.Person[pid]["战斗动作"]=GetBZPic(pid,enemy,friend)
local id=JY.Person[pid]["代号"]
if id==1 then--刘备
if between(bz,7,9) or bz==20 or bz==22 then--骑马
if lv==1 then
JY.Person[pid]["战斗动作"]=6320
elseif lv==2 then
JY.Person[pid]["战斗动作"]=12120
else
JY.Person[pid]["战斗动作"]=12170
end
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
elseif bz==27 then
JY.Person[pid]["战斗动作"]=10320
else--步行
if lv<3 then
JY.Person[pid]["战斗动作"]=6920
else
JY.Person[pid]["战斗动作"]=7420
end
end
elseif id==2 or id==373 then--关羽
if between(bz,7,9) or bz==20 or bz==22 then--骑马
if lv==1 then
JY.Person[pid]["战斗动作"]=6370
elseif lv==2 then
JY.Person[pid]["战斗动作"]=6420
elseif lv==3 then
JY.Person[pid]["战斗动作"]=7120
else
end
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=11870
end
elseif id==3 or id==374 then--张飞
if between(bz,7,9) or bz==20 or bz==22 then--骑马
if lv==1 then
JY.Person[pid]["战斗动作"]=6470
elseif lv==2 then
JY.Person[pid]["战斗动作"]=6520
elseif lv==3 then
JY.Person[pid]["战斗动作"]=7170
else
end
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=12570
end
elseif id==4 then--董卓
if between(bz,7,9) or bz==20 or bz==22 then--骑马
JY.Person[pid]["战斗动作"]=8670
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==5 then--吕布
if between(bz,7,9) or bz==20 or bz==22 then--骑马
if lv==1 then
JY.Person[pid]["战斗动作"]=6670
elseif lv==2 or lv==3 then
JY.Person[pid]["战斗动作"]=12220
else
end
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=7620
end
elseif id==6 then--华雄
if between(bz,7,9) or bz==20 or bz==22 then--骑马
JY.Person[pid]["战斗动作"]=11970
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==9 then--曹操
if between(bz,7,9) or bz==20 or bz==22 then--骑马
if lv==1 then
JY.Person[pid]["战斗动作"]=5020
elseif lv==2 then
JY.Person[pid]["战斗动作"]=5070
elseif lv==3 then
JY.Person[pid]["战斗动作"]=5120
else
end
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==10 then--袁绍
JY.Person[pid]["战斗动作"]=11770
elseif id==11 then--孙坚
if between(bz,7,9) or bz==20 or bz==22 then--骑马
JY.Person[pid]["战斗动作"]=7770
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==13 then--公孙瓒
if between(bz,7,9) or bz==20 or bz==22 then--骑马
JY.Person[pid]["战斗动作"]=10520
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==15 then--黄盖
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=8770
end
elseif id==17 then--夏侯惇
if between(bz,7,9) or bz==20 or bz==22 then--骑马
if lv==1 then
JY.Person[pid]["战斗动作"]=5170
elseif lv==2 then
JY.Person[pid]["战斗动作"]=5220
elseif lv==3 then
JY.Person[pid]["战斗动作"]=5270
else
end
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==18 then--夏侯渊
if between(bz,7,9) or bz==20 or bz==22 then--骑马
if true or bz==22 then
if lv==1 then
JY.Person[pid]["战斗动作"]=12320
elseif lv==2 then
JY.Person[pid]["战斗动作"]=12370
elseif lv==3 then
JY.Person[pid]["战斗动作"]=12420
else
end
end
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==19 then--曹仁
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=8620
end
elseif id==30 then--关兴
if between(bz,7,9) or bz==20 or bz==22 then--骑马
if lv==3 and JY.Person[pid]["等级"]>=60 then
JY.Person[pid]["战斗动作"]=10670
end
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=10620
end
elseif id==31 then--马谡
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==16 then--妖术师
JY.Person[pid]["战斗动作"]=10870
elseif bz==21 then--投石车一般无特殊形象
else--步行
if lv==1 then
JY.Person[pid]["战斗动作"]=10170
elseif lv==2 then
JY.Person[pid]["战斗动作"]=10170
elseif lv==3 then
JY.Person[pid]["战斗动作"]=10220
end
end
elseif id==34 then--廖化
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=6870
end
elseif id==35 then--沙摩柯
if between(bz,7,9) or bz==20 or bz==22 then--骑马
JY.Person[pid]["战斗动作"]=11420
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=11370--9220
end
elseif id==44 then--张苞
if between(bz,7,9) or bz==20 or bz==22 then--骑马
if lv==3 and JY.Person[pid]["等级"]>=60 then
JY.Person[pid]["战斗动作"]=11470
end
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==52 then--颜良
if between(bz,7,9) or bz==20 or bz==22 then--骑马
JY.Person[pid]["战斗动作"]=8170
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==53 then--文丑
if between(bz,7,9) or bz==20 or bz==22 then--骑马
JY.Person[pid]["战斗动作"]=8220
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==54 then--赵云
if between(bz,7,9) or bz==20 or bz==22 then--骑马
if lv==1 then
JY.Person[pid]["战斗动作"]=6570
elseif lv==2 then
JY.Person[pid]["战斗动作"]=6770
elseif lv==3 then
JY.Person[pid]["战斗动作"]=6820
else
end
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=9120
end
elseif id==68 then--许褚
if between(bz,7,9) or bz==20 or bz==22 then--骑马
JY.Person[pid]["战斗动作"]=8320
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
if lv==1 then
JY.Person[pid]["战斗动作"]=6120
elseif lv==2 then
JY.Person[pid]["战斗动作"]=6170
elseif lv==3 then
JY.Person[pid]["战斗动作"]=6220
else
end
end
elseif id==70 then--纪灵
if between(bz,7,9) or bz==20 or bz==22 then--骑马
if lv==1 then
JY.Person[pid]["战斗动作"]=8070
elseif lv==2 then
JY.Person[pid]["战斗动作"]=8120
elseif lv==3 then
JY.Person[pid]["战斗动作"]=8120
else
end
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==73 then--高顺
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==14 then--训虎一般无特殊形象
JY.Person[pid]["战斗动作"]=9170
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==79 then--徐晃
if between(bz,7,9) or bz==20 or bz==22 then--骑马
JY.Person[pid]["战斗动作"]=7820
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==80 then--张辽
if between(bz,7,9) or bz==20 or bz==22 then--骑马
if lv==1 then
JY.Person[pid]["战斗动作"]=5320
elseif lv==2 then
JY.Person[pid]["战斗动作"]=5370
elseif lv==3 then
JY.Person[pid]["战斗动作"]=5420
else
end
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=7320
end
elseif id==83 then--简雍
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵
if lv>1 then
JY.Person[pid]["战斗动作"]=12070
end
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==103 then--张郃
if between(bz,7,9) or bz==20 or bz==22 then--骑马
if true or bz==22 then
JY.Person[pid]["战斗动作"]=12520
end
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==116 then--李典
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=10820
end
elseif id==126 then--诸葛亮
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
if between(JY.Person[pid]["等级"],1,39) then
JY.Person[pid]["战斗动作"]=9270
elseif between(JY.Person[pid]["等级"],40,59) then
JY.Person[pid]["战斗动作"]=5820
elseif between(JY.Person[pid]["等级"],60,9999) then
JY.Person[pid]["战斗动作"]=9320
else
end
end
elseif id==127 then--魏延
if between(bz,7,9) or bz==20 or bz==22 then--骑马
JY.Person[pid]["战斗动作"]=8570
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==128 then--关平
if between(bz,7,9) or bz==20 or bz==22 then--骑马
if lv==1 then
JY.Person[pid]["战斗动作"]=9970
elseif lv==2 then
JY.Person[pid]["战斗动作"]=10070
elseif lv==3 then
JY.Person[pid]["战斗动作"]=10120
else
end
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==129 then--夏侯兰
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=9870
end
elseif id==133 then--庞统
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=6970
end
elseif id==142 then--孙权
JY.Person[pid]["战斗动作"]=11720
elseif id==143 then--周瑜
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=7070
end
elseif id==150 then--太史慈
if between(bz,7,9) or bz==20 or bz==22 then--骑马
if lv==1 then
JY.Person[pid]["战斗动作"]=8370
elseif lv==2 then
JY.Person[pid]["战斗动作"]=8420
elseif lv==3 then
JY.Person[pid]["战斗动作"]=8420
else
end
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==151 then--陆逊
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=7720
end
elseif id==155 then--周仓
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=7920
end
elseif id==163 then--周泰
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=9070
end
elseif id==170 then--黄忠
if between(bz,7,9) then--骑马
JY.Person[pid]["战斗动作"]=8870
elseif bz==22 then--弓骑
JY.Person[pid]["战斗动作"]=12020
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
JY.Person[pid]["战斗动作"]=8820
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==190 then--马超
if between(bz,7,9) or bz==20 or bz==22 then--骑马
JY.Person[pid]["战斗动作"]=8920
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==196 then--张任
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
JY.Person[pid]["战斗动作"]=9020
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==204 then--马岱
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=8970
end
elseif id==214 then--司马懿
if between(bz,7,9) or bz==20 or bz==22 then--骑马
if lv==1 then
JY.Person[pid]["战斗动作"]=5620
elseif lv==2 then
JY.Person[pid]["战斗动作"]=5670
elseif lv==3 then
JY.Person[pid]["战斗动作"]=5720
else
end
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=7470
end
elseif id==216 then--庞德
if between(bz,7,9) or bz==20 or bz==22 then--骑马
JY.Person[pid]["战斗动作"]=10770
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==244 then--姜维
if between(bz,7,9) or bz==20 or bz==22 then--骑马
JY.Person[pid]["战斗动作"]=6720
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
end
elseif id==376 then--李明
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==14 then--训虎一般无特殊形象
JY.Person[pid]["战斗动作"]=8270
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=10570
end
elseif id==377 then--祝融
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=6270
end
elseif id==383 then--献帝
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=6620
end
elseif id==385 then--鲁智深
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=7670
end
elseif id==386 then--武松
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=7220
end
elseif id==387 then--典韦
if between(bz,7,9) or bz==20 or bz==22 then--骑马
JY.Person[pid]["战斗动作"]=8020
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
if lv==1 then
JY.Person[pid]["战斗动作"]=5970
elseif lv==2 then
JY.Person[pid]["战斗动作"]=5970
elseif lv==3 then
JY.Person[pid]["战斗动作"]=6020
else
end
end
elseif id==388 then--靖仇
JY.Person[pid]["战斗动作"]=7020
elseif id==389 then--仙子
JY.Person[pid]["战斗动作"]=7520
elseif id==390 then--剑仙
JY.Person[pid]["战斗动作"]=7570
elseif id==391 then
JY.Person[pid]["战斗动作"]=7620
elseif id==392 then
JY.Person[pid]["战斗动作"]=7120
elseif id==393 then
JY.Person[pid]["战斗动作"]=7170
elseif id==394 then
JY.Person[pid]["战斗动作"]=8470
elseif id==395 then
JY.Person[pid]["战斗动作"]=8570
elseif id==396 then
JY.Person[pid]["战斗动作"]=8020
elseif id==397 then
JY.Person[pid]["战斗动作"]=5420
elseif id==398 then
JY.Person[pid]["战斗动作"]=6220
elseif id==404 then--貂蝉
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
if lv==1 then
JY.Person[pid]["战斗动作"]=5470
elseif lv==2 then
JY.Person[pid]["战斗动作"]=5520
elseif lv==3 then
JY.Person[pid]["战斗动作"]=5570
else
end
end
elseif id==405 then--胡笛
if between(bz,7,9) or bz==20 or bz==22 then--骑马
elseif bz>=4 and bz<=6 then--弓兵一般无特殊形象
elseif bz==21 then--投石车一般无特殊形象
else--步行
JY.Person[pid]["战斗动作"]=8720
end
elseif id==406 then--bttt
JY.Person[pid]["战斗动作"]=12270
end
return JY.Person[pid]["战斗动作"]
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
local id1=FightSelectMenu(T)
if id1==0 then
return
end
for i,v in pairs(T) do
if id1==v then
 table.remove(T,i)
break
end
end
local id2=FightSelectMenu(T)
if id2==0 then
return
end
local s={0,1,2,4,6}
fight(id1,id2,s[math.random(5)])
end

function FightSelectMenu(T)
local num_perpage=12
local page=1
local total_num=#T
local maxpage=math.modf(total_num/(num_perpage-2))
if total_num>(num_perpage-2)*maxpage then
maxpage=maxpage+1
end
local t={}
while true do
for i=2,num_perpage-1 do
t[i]=0
end
t[1]=-1
t[num_perpage]=-2
for i=2,num_perpage-1 do
local idx=(num_perpage-2)*(page-1)+(i-1)
if idx<=total_num then
t[i]=T[idx]
end
end
local m={}
m[1]={" 上一页",nil,1}
m[num_perpage]={" 下一页",nil,1}
for i=2,num_perpage-1 do
if t[i]>0 then
local str=JY.Person[t[i]]["姓名"]
if #str==6 then
str=" "..str
elseif #str==4 then
str="　"..str
elseif #str==3 then
str="　 "..str
elseif #str==2 then
str="　 "..str
end
m[i]={str,nil,1}
else
m[i]={"",nil,0}
end
end
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
DrawSMap()
else
lib.FillColor(0,0,0,0)
end
local r=ShowMenu(m,num_perpage,0,0,0,0,0,1,1,16,M_White,M_White)
if r==1 then
if page>1 then
page=page-1
end
elseif r==num_perpage then
if page<maxpage then
page=page+1
end
elseif r==0 then
return 0
else
local id=t[r]
local bz=JY.Person[id]["兵种"]
if WarDrawStrBoxYesNo(string.format('%s %d级%s 武力 %d*确认吗？',JY.Person[id]["姓名"],JY.Person[id]["等级"],JY.Bingzhong[bz]["名称"],JY.Person[id]["武力"]),M_White,true) then
return t[r]
end
end
end
end

function LvMenu(T)
local num_perpage=12
local page=1
local total_num=#T
local maxpage=math.modf(total_num/(num_perpage-2))
if total_num>(num_perpage-2)*maxpage then
maxpage=maxpage+1
end
local t={}
while true do
for i=2,num_perpage-1 do
t[i]=0
end
t[1]=-1
t[num_perpage]=-2
for i=2,num_perpage-1 do
local idx=(num_perpage-2)*(page-1)+(i-1)
if idx<=total_num then
t[i]=T[idx]
end
end
local m={}
m[1]={" 上一页",nil,1}
m[num_perpage]={" 下一页",nil,1}
for i=2,num_perpage-1 do
if t[i]>0 then
local str=t[i]
m[i]={"　 "..str,nil,1}
else
m[i]={"",nil,0}
end
end
local r=ShowMenu(m,num_perpage,0,0,0,0,0,1,1,16,M_White,M_White)
if r==1 then
if page>1 then
page=page-1
end
elseif r==num_perpage then
if page<maxpage then
page=page+1
end
elseif r==0 then
return 0
else
return t[r]
end
end
end

--原S.lua
function Config()
lib.LoadConfig(CC.ScreenW,CC.ScreenH)
end

function SystemMenu()
PlayWavE(0)
local menu={
{" 结束游戏",nil,1},
{"　 载入",nil,1},
{"　 储存",nil,1},
{" 功能设定",nil,1},
{"　 音效 ",nil,0},
}
DrawYJZBox(32,32,"功能",M_White,true)
local r=ShowMenu(menu,5,0,0,0,0,0,3,1,16,M_White,M_White)
lib.Delay(100)
if r==1 then
if WarDrawStrBoxYesNo('结束游戏吗？',M_White,true) then
lib.Delay(100)
if WarDrawStrBoxYesNo('再玩一次吗？',M_White,true) then
lib.Delay(100)
JY.Status=GAME_START
else
lib.Delay(100)
JY.Status=GAME_END
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
menu2[id][1]=menu2[id][1].."未使用档案"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,104,"请选择将载入的档案",M_White)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,5) then
if string.sub(menu2[s2][1],5)~="未使用档案" then
if WarDrawStrBoxYesNo(string.format("载入在硬碟的第%d进度，可以吗？",s2),M_White,true) then
LoadRecord(s2)
end
else
WarDrawStrBoxConfirm("没有数据",M_White,true)
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
menu2[id][1]=menu2[id][1].."未使用档案"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,104,"将档案储存在哪里？",M_White)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,5) then
if WarDrawStrBoxYesNo(string.format("储存在硬碟的第%d号，可以吗？",s2),M_White,true) then
SaveRecord(s2)
end
end
elseif r==4 then
SettingMenu()--功能设定
elseif r==5 then
end
return false
end

function GetRecordInfo(id)
local offset=CC.Base_S["章节名"][1]+100
local len=CC.Base_S["章节名"][3]+CC.Base_S["时间"][3]
local data=Byte.create(8*len)
Byte.loadfile(data,CC.R_GRPFilename[id],offset,len)
local SectionName,SaveTime
SectionName=Byte.getstr(data,0,28)
SaveTime=Byte.getstr(data,28,14)
offset=CC.Base_S["战场存档"][1]+100
Byte.loadfile(data,CC.R_GRPFilename[id],offset,len)
if Byte.get16(data,0)==1 then
offset=CC.Base_S["战场名称"][1]+100
Byte.loadfile(data,CC.R_GRPFilename[id],offset,len)
SectionName=Byte.getstr(data,0,28)
offset=100+136
Byte.loadfile(data,CC.R_GRPFilename[id],offset,len)
local turn=Byte.get8(data,8)
local maxturn=Byte.get8(data,9)
SectionName=string.gsub(SectionName,"　 ","　")
if string.len(SectionName)<22 then
SectionName=string.format(string.format("%%s%%%ds",22-string.len(SectionName)),SectionName,"")..string.format("第%02d回合",turn,maxturn)
end
end
if CC.SrcCharSet==1 then
SectionName=lib.CharSet(SectionName,0)
end
if string.len(SectionName)<31 then
SectionName=string.format(string.format("%%s%%%ds",31-string.len(SectionName)),SectionName,"")
end
return SectionName..SaveTime
end

function SetSceneID(id,BGMID)
JY.SubScene=id
Dark()
if BGMID~=nil then
PlayBGM(BGMID)
end
DrawSMap()
Light()
end

function SMapEvent()
JY.ReFreshTime=lib.GetTime()
DrawSMap()
JY.Tid=0
local eventtype,keypress,x,y=getkey()
if MOUSE.HOLD(673,321,710,366) then
lib.PicLoadCache(4,220*2,673,321,1)
elseif MOUSE.HOLD(713,321,750,366) then
lib.PicLoadCache(4,221*2,713,321,1)
elseif MOUSE.HOLD(673,369,710,414) then
lib.PicLoadCache(4,222*2,673,369,1)
elseif MOUSE.HOLD(713,369,750,414) then
lib.PicLoadCache(4,223*2,713,369,1)
end
if MOUSE.CLICK(673,321,710,366) then
PlayWavE(0)
if CC.Enhancement==false then
WarDrawStrBoxConfirm("暂无可招揽的武将．",M_White,true)
else
HirePerson()
end
elseif MOUSE.CLICK(713,321,750,366) then
PlayWavE(0)
Person_Menu()
elseif MOUSE.CLICK(673,369,710,414) then
Shop()
elseif MOUSE.CLICK(713,369,750,414) then
SystemMenu()
elseif MOUSE.CLICK(680,24,742,102) then
JY.LLK_N=JY.LLK_N+1
if JY.LLK_N>49 then
PlayWavE(0)
if WarDrawStrBoxYesNo("禁止的隐含命令模式*对执行结果不负任何责任．*而且对此的询问也不解答．可以吗？",M_White,true) then--可以进入命令键入野ｉ状态吗？
local mj=0
if CC.Enhancement==false then
mj=1
end
if mj==1 then
JY.Base["黄金"]=9999
JY.Person[1]["等级"]=99
JY.LLK_N=0
elseif mj==0 then
Game_Cycle()
end
else
JY.LLK_N=50
end
end
end
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('结束游戏吗？',M_White,true) then
lib.Delay(100)
if WarDrawStrBoxYesNo('再玩一次吗？',M_White,true) then
lib.Delay(100)
JY.Status=GAME_START
else
lib.Delay(100)
JY.Status=GAME_END
end
end
end
if MOUSE.IN(16,16,16+640,16+400) then
for i,v in pairs(JY.Smap) do
local px,py=27+18*v[2],19+18*v[3]-32
--if math.abs(x-px)<20 and math.abs(y-py)<28 then
if MOUSE.CLICK(px-20,py-28,px+20,py+28) then
JY.Tid=v[1]
 DoEvent(JY.EventID)
if JY.Tid==-1 then
JY.Tid=0
return
end
JY.Tid=0
break
elseif MOUSE.IN(px-20,py-28,px+20,py+28) then
JY.Tid=v[1]
end
end
end
if eventtype==3 and keypress==3 then
SystemMenu()
end
if JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
ReFresh()
end
end

function DrawSMap()
lib.FillColor(0,0,0,0,0)
if JY.SubScene>=0 then
lib.PicLoadCache(5,JY.SubScene*2,16,16,1)--21,21
local len=18
local dx,dy=27,19
if CC.Debug==1 then
for i=1,20 do
lib.Background(0,dy+len*i,CC.ScreenW,dy+len*i+1,128,M_White)
DrawString(42,dy+len*i,i,M_White,16)
DrawString(dx+len*i*2,24,i*2+1,M_White,16)
lib.Background(dx+len*i*2,0,dx+len*i*2+1,CC.ScreenH,128,M_White)
end
end
for i,v in pairs(JY.Smap) do
local x,y=dx+len*v[2]-24,dy+len*v[3]-64
lib.SetClip(x,y,x+48,y+64)
if v[5]==0 then
lib.PicLoadCache(5,(200+JY.Person[v[1]]["形象"]*4+v[4])*2,x,y-0*64,1)
elseif v[5]==1 then
lib.PicLoadCache(5,(200+JY.Person[v[1]]["形象"]*4+v[4])*2,x,y-1*64,1)
elseif v[5]==2 then
lib.PicLoadCache(5,(200+JY.Person[v[1]]["形象"]*4+v[4])*2,x,y-0*64,1)
elseif v[5]==3 then
lib.PicLoadCache(5,(200+JY.Person[v[1]]["形象"]*4+v[4])*2,x,y-2*64,1)
elseif v[5]==4 then
lib.PicLoadCache(5,(200+JY.Person[v[1]]["形象"]*4+v[4])*2,x,y-0*64,1)
end
if v[5]>=1 then
v[5]=v[5]+1
if v[5]==5 then
v[5]=1
end
end
lib.SetClip(0,0,0,0)
end
for i,v in pairs(JY.Smap) do
if v[5]==0 then
if JY.Tid==v[1] then
local x,y=dx+len*v[2]-24,dy+len*v[3]-64
if v[4]==1 or v[4]==2 then
lib.PicLoadCache(4,232*2,x-8,y-8,1)
else
lib.PicLoadCache(4,231*2,x+32,y-8,1)
end
end
end
end
end
lib.PicLoadCache(4,201*2,0,0,1)
DrawGameStatus()
end

function DrawGameStatus()
DrawString(680,142,"金",M_Navy,16)
DrawString(680,182,"等级",M_Navy,16)
DrawString(680,222,"武将",M_Navy,16)
DrawString(680,262,"现在地",M_Navy,16)
DrawString(740-#(""..JY.Base["黄金"])*16/2, 160,JY.Base["黄金"],M_White,16)
DrawString(740-#(""..JY.Person[1]["等级"])*16/2,200,JY.Person[1]["等级"],M_White,16)
DrawString(740-#(""..JY.Base["武将数量"])*16/2, 240,JY.Base["武将数量"],M_White,16)
DrawString(740-#JY.Base["现在地"]*16/2, 280,JY.Base["现在地"],M_White,16)
DrawString(18+6,434+6,JY.Base["章节名"],M_White,16)
if JY.Tid>0 then
DrawString(338+6,434+6,JY.Person[JY.Tid]["姓名"],M_White,16)
end
end

function MovePerson(...)
local arg={}
for i,v in pairs({...}) do
arg[i]=v
end
local n=math.modf(#arg/3)
for i=0,n-1 do
local id=arg[i*3+1]
for ii,v in pairs(JY.Smap) do
if v[1]==id then
arg[i*3+1]=ii
v[5]=1
end
end
end
while true do
local flag=true
for i=0,n-1 do
local id=arg[i*3+1]
local d=arg[i*3+3]
JY.Smap[id][4]=d
if arg[i*3+2]>0 then
flag=false
JY.Smap[id][2]=JY.Smap[id][2]+CC.DX[d]*0.2
JY.Smap[id][3]=JY.Smap[id][3]+CC.DY[d]*0.2
arg[i*3+2]=arg[i*3+2]-0.2
else
JY.Smap[id][5]=0
end
end
JY.ReFreshTime=lib.GetTime()
DrawSMap()
lib.GetKey()
ReFresh(1.25)
if flag then
break
end
end
for i,v in pairs(JY.Smap) do
 v[5]=0
end
DrawSMap()
lib.GetKey()
ShowScreen()--场景变黑再转为变亮
lib.Delay(50)
SortPerson()
end

function SortPerson()
local n=#JY.Smap
for i=1,n-1 do
for j=i+1,n do
if JY.Smap[i][3]>JY.Smap[j][3] then
JY.Smap[i],JY.Smap[j]=JY.Smap[j],JY.Smap[i]
end
end
end
end

function DoEvent(id)
if type(Event[id])=='function' then
Event[id]()
else
lib.Debug("Error!! eid="..id.."　type="..type(Event[id]))
JY.Status=GAME_START
end
if id>9999 then
os.exit()
end
if id~=JY.EventID then
return true
else
return false
end
end

function NextEvent(id)
if id==nil then
JY.EventID=JY.EventID+1
else
JY.EventID=id
end
end

function PicCatchIni()
lib.PicLoadFile(CC.MMAPPicFile[1],CC.MMAPPicFile[2],0)
lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],1)
lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],2)
--3不能使用
lib.PicLoadFile(CC.UIPicFile[1],CC.UIPicFile[2],4)
lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],5)
lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],11,200)
end

function Password()
local f=0
local T3={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}
local str=""
if filelength( CONFIG.PicturePath..
CC.PASCODE[29]..CC.PASCODE[8]..CC.PASCODE[5]..CC.PASCODE[14]..CC.PASCODE[50]..CC.PASCODE[53]..
CC.PASCODE[4]..CC.PASCODE[5]..CC.PASCODE[2]..CC.PASCODE[21]..CC.PASCODE[7])==13 then--".\\ChenX.debug")==13 then
CC.Debug=0
return
end
while true do
JY.ReFreshTime=lib.GetTime()
lib.PicLoadCache(4,83*2,0,0,1)
if f==0 then
lib.FillColor(40,14,49,16)
end
f=1-f
ReFresh()
local key=lib.GetMouse()
if key==1 or key==3 then
break
end
end
Dark()
end

function ScreenTest()
while true do
local e,k,x,y=lib.GetMouse(1)
lib.FillColor(0,0,0,0,M_White)
if e==2 or e==3 then
lib.DrawRect(x-64,y,x+64,y,0)
lib.DrawRect(x,y-64,x,y+64,0)
end
DrawString(64,64,x..','..y,M_Orange,24)
ShowScreen()--场景变黑再转为变亮
lib.Delay(25)
end
end

function YJZMain()
local saveflag=false--战后提示保存标记
JY.Status=GAME_START--游戏当前状态
PicCatchIni()
Password()
LoadRecord(0)
for i=1,JY.PersonNum-1 do
GetPic(i)
end
while true do
if JY.Status==GAME_START then
StopBGM()
YJZMain_sub()
elseif JY.Status==GAME_SMAP_AUTO then
if saveflag then
Dark()
saveflag=false
lib.FillColor(0,0,0,0,0)
RemindSave(2)
end
DoEvent(JY.EventID)
elseif JY.Status==GAME_SMAP_MANUAL then
SMapEvent()
elseif JY.Status==GAME_MMAP then
elseif JY.Status==GAME_WMAP then
Dark()
saveflag=true
WarStart()
elseif JY.Status==GAME_WMAP2 then--连续战斗
JY.Status=GAME_WMAP
DoEvent(JY.EventID)
elseif JY.Status==GAME_WARWIN then
JY.Status=GAME_SMAP_AUTO
elseif JY.Status==GAME_WARLOSE then
JY.Status=GAME_START
elseif JY.Status==GAME_DEAD then
elseif JY.Status==GAME_END then
Dark()
lib.Delay(1000)
os.exit()
end
end
end

function YJZMain_sub()
local menu={
{"　 开始新游戏",nil,1},
{"　　读取存档",nil,1},
{"　　功能设定",nil,1},
{"　　战场重现",nil,1},
{"　　比武大会",nil,1},
{"　观看剧情简介",nil,1},
{"　　退出游戏",nil,1},
}
if CC.Debug==1 then
menu[4][3]=1
end
lib.FillColor(0,0,0,0)
lib.Delay(200)
local s=ShowMenu(menu,7,0,0,0,0,0,2,0,16,M_White,M_White)
if s==1 then
LoadRecord(0)
JY.Base["章节名"]=""
local menux={
{"　　经典模式",nil,1},
{"　　纵横模式",nil,1},
}
local ss=ShowMenu(menux,2,0,0,0,0,0,2,0,16,M_White,M_White)
if ss==1 then
JY.Base["游戏模式"]=0
SaveRecord(6)-- 写游戏进度
LoadRecord(6)-- 读取游戏进度
os.remove(CC.R_GRPFilename[6])--删除临时存档
elseif ss==2 then
JY.Base["游戏模式"]=1
SaveRecord(6)-- 写游戏进度
LoadRecord(6)-- 读取游戏进度
os.remove(CC.R_GRPFilename[6])--删除临时存档
JY.Person[1]["等级"]=3
JY.Person[2]["等级"]=3
JY.Person[3]["等级"]=3
end
for i=1,JY.PersonNum-1 do
GetPic(i)
end
JY.Status=GAME_SMAP_AUTO--游戏当前状态
JY.EventID=1
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
menu2[id][1]=menu2[id][1].."未使用档案"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,128,"请选择将载入的档案",M_White)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,5) then
if string.sub(menu2[s2][1],5)~="未使用档案" then
if WarDrawStrBoxYesNo(string.format("载入在硬碟的第%d进度，可以吗？",s2),M_White,true) then
LoadRecord(s2)
end
else
WarDrawStrBoxConfirm("没有数据",M_White,true)
end
end
elseif s==3 then
SettingMenu()--功能设定
elseif s==4 then
LoadRecord(0)
for i=1,JY.PersonNum-1 do
GetPic(i)
end
JY.Status=GAME_SMAP_AUTO--游戏当前状态

--调试
JY.Base["游戏模式"]=1
CC.Enhancement=true
JY.EventID=700
JY.Base["事件333"]=30
JY.Person[1]["等级"]=99
JY.Person[2]["等级"]=99
JY.Person[3]["等级"]=99
JY.Base["黄金"]=10000
elseif s==5 then
PlayBGM(18)
FightMenu()
elseif s==6 then
lib.PicLoadFile(CC.EFT[1],CC.EFT[2],6)
PlayBGM(2)
local cx,cy=(CC.ScreenW-640)/2,(CC.ScreenH-480)/2
for picid=0,1236 do
JY.ReFreshTime=lib.GetTime()
lib.PicLoadCache(6,picid*2,cx,cy,1)
ReFresh(8)
local eventtype=lib.GetMouse(1)
if eventtype==1 or eventtype==3 then
Dark()
lib.Delay(1000)
break
end
end
PicCatchIni()
elseif s==7 then
if WarDrawStrBoxYesNo('结束游戏吗？',M_White,true) then
lib.Delay(100)
JY.Status=GAME_END
end
end
end

function DrawStrBoxCenter(str,color)--显示带框的字符串
color=color or M_White
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
WarDrawStrBoxWaitKey(str,color,-1,-1)
else
DrawStrBoxWaitKey(str,color)
end
end

function GenTalkString(str,n)--产生对话显示需要的字符串
local tmpstr=str
local num=0
local newstr=""
while #tmpstr>0 do
num=num+1
local w=0
while w<#tmpstr do
local v=string.byte(tmpstr,w+1)--当前字符的值
if v==42 then
break
elseif v>=128 then
w=w+2
else
w=w+1
end
if w >=2*n-1 then--为了避免跨段中文字符
break
end
end
if w<#tmpstr then
if string.byte(tmpstr,w+1)==42 then
newstr=newstr .. string.sub(tmpstr,1,w+1)
tmpstr=string.sub(tmpstr,w+2,-1)
elseif w==2*n-1 and string.byte(tmpstr,w+1)<128 then
newstr=newstr .. string.sub(tmpstr,1,w+1) .. "*"
tmpstr=string.sub(tmpstr,w+2,-1)
else
newstr=newstr .. string.sub(tmpstr,1,w) .. "*"
tmpstr=string.sub(tmpstr,w+1,-1)
end
else
newstr=newstr .. tmpstr
break
end
end
return newstr,num
end

function DrawMulitStrBox(str,color,size)--显示多行剧情
local x,y=145,250
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x,y=113,298
end
local sid=lib.SaveSur(x,y,x+382,y+126)
color=color or M_White
size=size or 16
local strarray={}
local num,maxlen
maxlen=0
str=GenTalkString(str,21)
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
lib.PicLoadCache(4,50*2,x,y,1)
for i=1,num do
DrawString(x+CC.MenuBorderPixel*3,y+CC.MenuBorderPixel*3+(size+4)*(i-1),strarray[i],color,size)
end
ShowScreen()--场景变黑再转为变亮
WaitKey()
lib.LoadSur(sid,x,y)
lib.FreeSur(sid)
ShowScreen()--场景变黑再转为变亮
end

--设置事件
--eid 事件id
--flag 事件状态
function SetFlag(eid,flag)
JY.Base["事件"..eid]=flag
end

--检查事件
--eid 事件id
-->0返回真，否则返回假
function GetFlag(eid)
if JY.Base["事件"..eid]>0 then
return true
else
return false
end
end

--修改武将AI
--pid 武将id
--ai 
function WarModifyAI(pid,ai,p1,p2)
pid=pid+1--修正
local wid=GetWarID(pid)
if wid>0 then
War.Person[wid].ai=ai
if ai==3 or ai==5 then
War.Person[wid].aitarget=p1+1
elseif ai==4 or ai==6 then
War.Person[wid].ai_dx=p1+1
War.Person[wid].ai_dy=p2+1
end
end
end

--修改武将阵营
--pid 武将id
--fid 阵营id，默认为1
function ModifyForce(pid,fid)
if pid==nil then
return
end
fid=fid or 1
--修改武将数量统计
if JY.Person[pid]["君主"]==1 and fid~=1 then
JY.Base["武将数量"]=JY.Base["武将数量"]-1
end
if JY.Person[pid]["君主"]~=1 and fid==1 then
JY.Base["武将数量"]=JY.Base["武将数量"]+1
end
--如果加入我方，额外确认等级
if fid==1 then
JY.Person[pid]["等级"]=limitX(JY.Person[pid]["等级"],1,99)
if CC.Enhancement then
if JY.Status~=GAME_WMAP then
local dtlv=pjlv()
if JY.Person[pid]["等级"]<dtlv then--新加入的武将如果等级低于我方平均等级，则提升到我方平均等级
JY.Person[pid]["等级"]=dtlv
end
end
end
end
JY.Person[pid]["君主"]=fid
local picid=GetPic(pid)
if fid==1 and type(War.Person)=="table" then--战斗时如果君主改为刘备，还需要额外修改战斗部分属性
for i,v in pairs(War.Person) do
if v.id==pid then
v.enemy=false
v.friend=false
v.pic=WarGetPic(i)
v.ai=1
break
end
end
end
end

--修改武将兵种
--pid 武将id
--bzid 兵种id，默认为1
function ModifyBZ(pid,bzid)
if pid==nil then
return
end
bzid=bzid or 1
JY.Person[pid]["兵种"]=bzid
end

--显示过场图片（带边框），带淡入淡出效果
--flag 0.无效果 1.淡入 2.淡出
function LoadPic(id,flag)
local w,h=238,158
local x=16+640/2-w/2
local y=16+64
flag=flag or 0
if between(id,3,33) then
DrawSMap()
local sid=lib.SaveSur(x,y,x+w,y+h)
if flag==0 then
lib.PicLoadCache(4,id*2,x,y,1)
elseif flag==1 then--淡入
for i=0,256,4 do
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid,x,y)
lib.PicLoadCache(4,id*2,x,y,1+2,i)
lib.GetKey()
ReFresh()
end
elseif flag==2 then--淡出
for i=0,256,4 do
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid,x,y)
lib.PicLoadCache(4,id*2,x,y,1+2,256-i)
lib.GetKey()
ReFresh()
end
end
lib.FreeSur(sid)
end
for i=1,CC.OpearteSpeed*2 do
JY.ReFreshTime=lib.GetTime()
lib.GetKey()
ReFresh()
end
end

function talk(...)
local arg={}
for i,v in pairs({...}) do
arg[i]=v
end
local n=math.modf(#arg/2)
local f=0
for i=0,n-1 do
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
WarPersonCenter(GetWarID(arg[i*2+1]))
f=2
end
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
else
JY.Tid=arg[i*2+1]
DrawSMap()
end
talk_sub(arg[i*2+1],arg[i*2+2],true,i%2+f)
JY.ReFreshTime=lib.GetTime()
ReFresh()
end
JY.Tid=0
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
else
DrawSMap()
end
end

function talkYesNo(id,s)
local x4=512
local x3=x4-52
local x2=x4-56
local x1=x3-56
local y2=140
local y1=y2-24
JY.Tid=id
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
else
end
talk_sub(id,s)
JY.Tid=0
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid,0,0)
if flag==1 then
lib.PicLoadCache(4,52*2,x1,y1,1)
else
lib.PicLoadCache(4,51*2,x1,y1,1)
end
if flag==2 then
lib.PicLoadCache(4,54*2,x3,y1,1)
else
lib.PicLoadCache(4,53*2,x3,y1,1)
end
ReFresh()
end
local current=0
while true do
redraw(current)
getkey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=1
elseif MOUSE.HOLD(x3+1,y1+1,x4-1,y2-1) then
current=2
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
lib.Delay(100)
lib.FreeSur(sid)
return true
elseif MOUSE.CLICK(x3+1,y1+1,x4-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
lib.Delay(100)
lib.FreeSur(sid)
return false
else
current=0
end
end
end

function talk_sub(id,s,pause,flag)
local talkxnum=19--对话一行字数
local talkynum=3--对话行数
pause=pause or false
flag=flag or 0
--显示头像和对话的坐标
local mx,my=140,100
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
if string.find(s,"*")==nil then
s=GenTalkString(s,talkxnum)
end
if CONFIG.KeyRepeat==0 then
lib.EnableKeyRepeat(0,CONFIG.KeyRepeatInterval)
end
local size=16
local headid=JY.Person[id]["头像代号"]
local startp=1
local endp
local dy=0
local sid
while true do
if dy==0 then
JY.ReFreshTime=lib.GetTime()
DrawYJZBox_sub(xy[flag].mx,xy[flag].my,384,80)
lib.PicLoadCache(2,headid*2,xy[flag].headx,xy[flag].heady,1)
DrawString(xy[flag].talkx,xy[flag].heady,JY.Person[id]["姓名"],C_Name,size)
end
endp=string.find(s,"*",startp)
if endp==nil then
DrawString(xy[flag].talkx, xy[flag].talky + dy * (size+4),string.sub(s,startp),M_White,size)
ReFresh()
if pause then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
sid=lib.SaveSur(xy[flag].mx-15,xy[flag].my-15,xy[flag].mx+414-15,xy[flag].my+110-15)
end
while true do
local eventtype=lib.GetMouse(1)
if eventtype==1 or eventtype==3 then
lib.Delay(100)
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
lib.FreeSur(sid)
end
break
end
JY.ReFreshTime=lib.GetTime()
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
lib.LoadSur(sid,xy[flag].mx-15,xy[flag].my-15)
end
ReFresh()
end
end
break
else
DrawString(xy[flag].talkx, xy[flag].talky + dy * (size+4),string.sub(s,startp,endp-1),M_White,size)
end
dy=dy+1
startp=endp+1
if dy>=talkynum then
ReFresh()
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
sid=lib.SaveSur(xy[flag].mx-15,xy[flag].my-15,xy[flag].mx+414-15,xy[flag].my+110-15)
end
while true do
local eventtype=lib.GetMouse(1)
if eventtype==1 or eventtype==3 then
lib.Delay(100)
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
lib.FreeSur(sid)
end
break
end
JY.ReFreshTime=lib.GetTime()
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
lib.LoadSur(sid,xy[flag].mx-15,xy[flag].my-15)
end
ReFresh()
end
dy=0
end
end
if CONFIG.KeyRepeat==0 then
lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRepeatInterval)
end
end

function AddPerson(id,x,y,d)
table.insert(JY.Smap,{id,x,y,d,0})
end

function DecPerson(id)
for i,v in pairs(JY.Smap) do
if v[1]==id then
table.remove(JY.Smap,i)
break
end
end
end

function Person_Menu()
local menu={
{" 武将情报",nil,1},
{" 交换道具",nil,1},
{"　 修炼",nil,1},
}
DrawYJZBox(32,32,"武将",M_White,true)
 
local r=ShowMenu(menu,#menu,0,546,264,0,0,3,1,16,M_White,M_White)
if r==1 then
PersonStatus_Menu(1)
elseif r==2 then
ExchangeItem(1)
elseif r==3 then
if CC.Enhancement==false then
Maidan(1)
else
Maidan2(1)
end
end
end

function PersonStatus_Menu(fid)
local menu={}
local n=0
for i=1,JY.PersonNum-1 do
if JY.Person[i]["君主"]==fid then
menu[i]={fillblank(JY.Person[i]["姓名"],11),PersonStatus,1}
n=n+1
else
menu[i]={"",nil,0}
end
end
DrawYJZBox(32,32,"武将情报",M_White,true)
if n<=8 then
ShowMenu(menu,JY.PersonNum-1,8,546,224,0,0,5,1,16,M_White,M_White)
else
ShowMenu(menu,JY.PersonNum-1,8,530,224,0,0,6,1,16,M_White,M_White)
end
end

--武将属性界面
function PersonStatus(pid,x,y,flag)
flag=flag or 0
if type(x)=='number' and type(y)=='number' then
else
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=16+(576-456)/2
y=32+(432-276)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-456)/2
y=16+(400-276)/2
else
x=(CC.ScreenW-456)/2
y=(CC.ScreenH-276)/2
end
end
local p=JY.Person[pid]
local close=false
if flag==0 then
DrawSMap()
DrawYJZBox(32,32,"武将情报",M_White,true)
end
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
local function redraw()
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid,0,0)
PersonStatus_sub(pid,x,y,flag)
if close then
lib.PicLoadCache(4,56*2,x+384,y+16,1)
else
lib.PicLoadCache(4,55*2,x+384,y+16,1)
end
ReFresh()
end
while true do
redraw()
local eventtype,keypress,mx,my=getkey()
if eventtype==3 and keypress==3 then
PlayWavE(1)
lib.Delay(20)
break
end
if MOUSE.HOLD(x+384+1,y+16+1,x+384+52-1,y+16+24-1) then
close=true
elseif MOUSE.CLICK(x+384+1,y+16+1,x+384+52-1,y+16+24-1) then
PlayWavE(0)
close=false
redraw()
lib.Delay(20)
break
else
close=false
end
for i=1,8 do
local iid=JY.Person[pid]["道具"..i]
if iid>0 then
if MOUSE.CLICK(x+340,y+112+i*16,x+340+#JY.Item[iid]["名称"]*16/2,y+112+(i+1)*16) then
PlayWavE(0)
DrawItemStatus(iid,pid)--显示物品属性
end
end
end
for i,v in pairs({"武器","防具","辅助"}) do
local iid=JY.Person[pid][v]
if iid>0 then
if MOUSE.CLICK(x+184+16*4,y+183+i*21,x+184+16*4+#JY.Item[iid]["名称"]*16/2,y+183+i*21+16) then
PlayWavE(0)
DrawItemStatus(iid,pid)--显示物品属性
end
end
end
if MOUSE.CLICK(x+24,y+24,x+24+64,y+24+80) then
local name=p["姓名"]
if type(CC.LieZhuan[name])=='string' then
DrawLieZhuan(name)--显示列传
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
local box_w=36
local box_h=20
for i=1,6 do
local cx=x+56+box_w*((i-1)%3)
local cy=y+220+box_h*math.modf((i-1)/3)
if MOUSE.CLICK(cx+1,cy+1,cx+box_w,cy+box_h) then
if p["等级"]>=CC.SkillExp[p["成长"]][i] or flag==2 then
DrawSkillStatus(JY.Person[pid]["特技"..i])--显示技能属性
end
end
end
end
end
lib.FreeSur(sid)
end

function PersonStatus_sub(pid,x,y,flag)
flag=flag or 0
x=x or 208
y=y or 72
ReSetAttrib(pid,false)
JY.Person[pid]["战斗动作"]=GetPic(pid,false,false)
lib.PicLoadCache(4,85*2,x,y,1)
local p=JY.Person[pid]
local b=JY.Bingzhong[p["兵种"]]
DrawString(x+135-#p["姓名"]*16/4,y+20,p["姓名"],M_White,16)
DrawString(x+184,y+20,p["等级"].."级".."（"..p["经验"].."％） "..b["名称"],M_White,16)
lib.Background(x+184-4,y+48,x+184+16*16+4,y+112,192)
if CC.Enhancement then
DrawStr(x+184,y+48+8,GenTalkString("天赋："..JY.Skill[p["天赋"]]["名称"].."*"..JY.Skill[p["天赋"]]["说明"],16),M_White,16)
else
DrawStr(x+184,y+48+8,GenTalkString(b["说明"],16),M_White,16)
end
lib.PicLoadCache(2,p["头像代号"]*2,x+24,y+24,1)
lib.PicLoadCache(1,(p["战斗动作"]+19)*2,x+111,y+55,1)
DrawString(x+184,y+120,"兵 力　　"..p["最大兵力"],M_White,16)
DrawString(x+184,y+141,"攻击力　 "..p["攻击"],M_White,16)
DrawString(x+184,y+162,"防御力　 "..p["防御"],M_White,16)
DrawString(x+184,y+183,"移动力",M_White,16)
if b["移动"]==p["移动"] then
DrawString(x+184+16*4,y+183,"　"..b["移动"],M_White,16)
else
DrawString(x+184+16*4,y+183,string.format("%d(%+d)",p["移动"],p["移动"]-b["移动"]),M_White,16)
end
DrawString(x+184,y+204,"武 器",M_White,16)
DrawString(x+184,y+225,"防 具",M_White,16)
DrawString(x+184,y+246,"辅 助",M_White,16)
if p["武器"]>0 then
DrawString(x+184+16*4,y+204,JY.Item[p["武器"]]["名称"],M_White,16)
end
if p["防具"]>0 then
DrawString(x+184+16*4,y+225,JY.Item[p["防具"]]["名称"],M_White,16)
end
if p["辅助"]>0 then
DrawString(x+184+16*4,y+246,JY.Item[p["辅助"]]["名称"],M_White,16)
end
local len=100
if CC.Enhancement then
for i,v in pairs({"武力","智力","统率"}) do
local v1=p[v..'2']
local v2=p[v]
local color
if v1<30 then
color=210
elseif v1<70 then
color=211
else
color=212
end
lib.FillColor(x+44,y+87+i*32,x+44+len,y+87+10+i*32,M_Black)
lib.SetClip(x+44,y+87+i*32,x+44+len*v1/100,y+87+10+i*32)
lib.PicLoadCache(4,color*2,x+44,y+87+i*32,1)
lib.SetClip(0,0,0,0)
local str
str=string.format("%d",v1)
DrawString2(x+44+60-16*#str/4,y+87-3+i*32,str,M_White,16)
if v1~=v2 then
str=string.format("(%+d)",v1-v2)
DrawString2(x+48+104,y+89-3+i*32,str,M_White,12)
end
end
else
for i,v in pairs({"武力","智力","统率"}) do
local v1=p[v..'2']
local v2=p[v]
local color
if v1<30 then
color=210
elseif v1<70 then
color=211
else
color=212
end
lib.FillColor(x+44,y+95+i*32,x+44+len,y+95+10+i*32,M_Black)
lib.SetClip(x+44,y+95+i*32,x+44+len*v1/100,y+95+10+i*32)
lib.PicLoadCache(4,color*2,x+44,y+95+i*32,1)
lib.SetClip(0,0,0,0)
local str
str=string.format("%d",v1)
DrawString2(x+44+60-16*#str/4,y+95-3+i*32,str,M_White,16)
if v1~=v2 then
str=string.format("(%+d)",v1-v2)
DrawString2(x+48+104,y+97-3+i*32,str,M_White,12)
end
end
end
if CC.Enhancement then
local wljy=p["武力经验"]
local zljy=p["智力经验"]
local tljy=p["统率经验"]
if p["武力"]==100 then
wljy=200
elseif p["智力"]==100 then
zljy=200
elseif p["统率"]==100 then
tljy=200
end
local color
if wljy<30 then
color=210
elseif wljy<70 then
color=211
else
color=212
end
lib.FillColor(x+44,y+103+32,x+44+len,y+103+10+32,M_Black)
if wljy>1 then
lib.SetClip(x+44,y+103+32,x+44+len*wljy/200,y+103+10+32)
lib.PicLoadCache(4,color*2,x+44,y+103+32,1)
end
lib.SetClip(0,0,0,0)
local str
str=string.format("%d",math.modf(wljy/2)).."％"
if wljy==200 then str="MAX"end DrawString2(x+44+60-16*#str/4,y+103-3+32,str,M_White,16)
if zljy<30 then
color=210
elseif zljy<70 then
color=211
else
color=212
end
lib.FillColor(x+44,y+103+2*32,x+44+len,y+103+10+2*32,M_Black)
if zljy>1 then
lib.SetClip(x+44,y+103+2*32,x+44+len*zljy/200,y+103+10+2*32)
lib.PicLoadCache(4,color*2,x+44,y+103+2*32,1)
end
lib.SetClip(0,0,0,0)
local str
str=string.format("%d",math.modf(zljy/2)).."％"
if zljy==200 then str="MAX"end DrawString2(x+44+60-16*#str/4,y+103-3+2*32,str,M_White,16)
if tljy<30 then
color=210
elseif tljy<70 then
color=211
else
color=212
end
lib.FillColor(x+44,y+103+3*32,x+44+len,y+103+10+3*32,M_Black)
if tljy>1 then
lib.SetClip(x+44,y+103+3*32,x+44+len*tljy/200,y+103+10+3*32)
lib.PicLoadCache(4,color*2,x+44,y+103+3*32,1)
end
lib.SetClip(0,0,0,0)
local str
 str=string.format("%d",math.modf(tljy/2)).."％"
if tljy==200 then str="MAX"end DrawString2(x+44+60-16*#str/4,y+103-3+3*32,str,M_White,16)
end
if CC.Enhancement then
DrawString(x+16,y+220,"技能",M_White,16)
DrawSkillTable(pid,x+56,y+220,flag)
end
--道具
for i=1,8 do
local tid=p["道具"..i]
if tid>0 then
DrawString(x+340,y+112+i*16,JY.Item[tid]["名称"],M_White,16)
else
if i==1 then
DrawString(x+340,y+112+i*16,"无携带品",M_White,16)
end
break
end
end
end

-- ExchangeItem(fid)
-- 交换道具
-- fid,君主id 一般应该是1，刘备
-- flag, 标记，，默认为false，如果为true，会有额外提示“交换道具吗？”
function ExchangeItem(fid,flag)
fid=fid or 1
flag=flag or false
local num=0
local page=1
local maxpage=1
local num_per_page=6
local personnum=1
local current=1
local status=1--1选择第一个人 2选择道具 3 选择第二个人
local iid=0--选中的item位置
TeamSelect={id={},status={}}
for i=1,JY.PersonNum-1 do
if JY.Person[i]["君主"]==fid then
ReSetAttrib(i,true)
JY.Person[i]["战斗动作"]=GetPic(i,false,false)
num=num+1
TeamSelect.id[num]=i
TeamSelect.status[num]=0--0未选择 1选择(可取消) 2选择(不可取消)
end
end
maxpage=math.modf((num-1)/6)+1
--------------------------------
-- 定义坐标信息
--------------------------------
local xy={
x1={},--左上角(边框内，实际部队图标显示位置)
y1={},
x2={},--兵力
y2={},
x3={},--姓名
y3={},
x4={},--右下角
y4={},
}
xy.x1={56,232,56,232,56,232}
xy.y1={64,64,154,154,244,244}
for i=1,6 do
xy.x1[i]=xy.x1[i]+16
xy.y1[i]=xy.y1[i]+16
end
for i=1,6 do
xy.x2[i]=xy.x1[i]+104
xy.y2[i]=xy.y1[i]+17
xy.x3[i]=xy.x1[i]+104
xy.y3[i]=xy.y1[i]+41
xy.x4[i]=xy.x1[i]+143
xy.y4[i]=xy.y1[i]+63
end
local bottom=0--当前按钮
--------------------------------
--redraw()
--内部函数，重绘
--frame 用于控制动画显示
--------------------------------
local cid=0
local subframe,frame=0,0
local kind={[0]="无","攻击用","恢复用","变换用","宝物","兵书","名马","恢复用","种子","种子","种子","武器","防具","马车","无",}
local titlestr="交换哪名武将的道具？请选择．"
local function redraw()
JY.ReFreshTime=lib.GetTime()
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(4,201*2,0,0,1)
DrawGameStatus()
lib.PicLoadCache(4,203*2,16,16,1)
DrawString(26,31,titlestr,M_White,16)
for i=1,6 do
local idx=num_per_page*(page-1)+i
if idx>num then
break
end
local pid=TeamSelect.id[idx]
local name=JY.Person[pid]["姓名"]
local hp=string.format("% 5d",JY.Person[pid]["最大兵力"])
local lv=string.format("% 5d",JY.Person[pid]["等级"])
local picid
if TeamSelect.status[idx]==0 then--未选择时，为+19
picid=JY.Person[pid]["战斗动作"]+19
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_White,16)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
else
picid=JY.Person[pid]["战斗动作"]+12+frame
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_DarkOrange,16)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
end
DrawString(xy.x2[i],xy.y2[i],hp,M_White,16)
DrawString(xy.x1[i]+4,xy.y1[i]+48,lv,M_White,16)
end
DrawString(110,359,string.format("% 4d",page),M_White,16)
DrawString(142,359,string.format("% 4d",maxpage),M_White,16)
--选中人物
cid=TeamSelect.id[current]
lib.PicLoadCache(2,JY.Person[cid]["头像代号"]*2,464,32,1)
DrawString(489-3*#JY.Person[cid]["姓名"],136,JY.Person[cid]["姓名"],M_White,16)
DrawString(584-4*#JY.Bingzhong[JY.Person[cid]["兵种"]]["名称"],24,JY.Bingzhong[JY.Person[cid]["兵种"]]["名称"],M_White,16)
DrawString(585,48,string.format("% 5d",JY.Person[cid]["等级"]),M_White,16)
DrawString(585,80,string.format("% 5d",JY.Person[cid]["统率"]),M_White,16)
DrawString(585,112,string.format("% 5d",JY.Person[cid]["武力"]),M_White,16)
DrawString(585,144,string.format("% 5d",JY.Person[cid]["智力"]),M_White,16)
if bottom==1 then
lib.PicLoadCache(4,224*2,173,351,1)
elseif bottom==2 then
lib.PicLoadCache(4,225*2,173,367,1)
elseif bottom==3 then
lib.PicLoadCache(4,226*2,317,351,1)
end
--道具
for i=1,8 do
local tid=JY.Person[cid]["道具"..i]
local color=M_White
if TeamSelect.status[current]==1 and i==iid then
color=M_DarkOrange
end
if tid>0 then
DrawString(466,176+i*18,JY.Item[tid]["名称"],color,16)
DrawString(562,176+i*18,"／"..kind[JY.Item[tid]["类型"]],color,16)
else
if i==1 then
DrawString(466,176+i*18,"无携带品．",M_White,16)
end
break
end
end
ReFresh()
subframe=subframe+1
if subframe==8 then
frame=1-frame
subframe=0
end
end
Dark()
redraw()
Light()
if flag then
if not WarDrawStrBoxYesNo('交换道具吗？',M_White,true) then
redraw()
return
end
end
while JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL do
redraw()
local eventtype,keypress=getkey()
bottom=0
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('结束游戏吗？',M_White,true) then
lib.Delay(100)
if WarDrawStrBoxYesNo('再玩一次吗？',M_White,true) then
lib.Delay(100)
JY.Status=GAME_START
else
lib.Delay(100)
JY.Status=GAME_END
end
end
elseif MOUSE.HOLD(174,352,204,366) then--page up
bottom=1
elseif MOUSE.HOLD(174,368,204,382) then--page down
bottom=2
elseif MOUSE.HOLD(319,353,362,380) then--close
bottom=3
elseif MOUSE.CLICK(174,352,204,366) then--page up
PlayWavE(0)
page=limitX(page-1,1,maxpage)
elseif MOUSE.CLICK(174,368,204,382) then--page down
PlayWavE(0)
page=limitX(page+1,1,maxpage)
elseif MOUSE.CLICK(319,353,362,380) and status==1 then--close
PlayWavE(0)
for i=1,CC.OpearteSpeed do
redraw()
end
if WarDrawStrBoxYesNo("　可以吗？　",M_White,true) then
redraw()
if not flag then
Dark()
DrawSMap()
Light()
end
return
end
elseif MOUSE.CLICK(464,32,464+64,32+80) then--head
PlayWavE(0)
PersonStatus(cid,"","",1)
elseif eventtype==4 and keypress==3 then
if status==2 then
PlayWavE(1)
TeamSelect.status[current]=0
titlestr="交换哪名武将的道具？请选择．"
iid=0
status=1
elseif status==3 then
PlayWavE(1)
titlestr="请选择要交换的道具．"
iid=0
status=2
end
else
for i=1,6 do
if MOUSE.CLICK(xy.x1[i],xy.y1[i],xy.x4[i],xy.y4[i]) then
local idx=num_per_page*(page-1)+i
if idx<=num then
if status==1 then
current=idx
cid=TeamSelect.id[idx]
if JY.Person[cid]["道具1"]==0 then
PlayWavE(2)
titlestr=JY.Person[cid]["姓名"].."什么也没有．"
for n=1,20 do
redraw()
lib.GetKey()
end
titlestr="交换哪名武将的道具？请选择．"
else
PlayWavE(0)
TeamSelect.status[idx]=1
titlestr="请选择要交换的道具．"
status=2
end
elseif status==2 then
if TeamSelect.status[idx]==1 then
PlayWavE(1)
TeamSelect.status[idx]=0
titlestr="交换哪名武将的道具？请选择．"
status=1
else
PlayWavE(2)
end
elseif status==3 then
local odx=current
current=idx
cid=TeamSelect.id[idx]
local oid=TeamSelect.id[odx]
local item=JY.Person[oid]["道具"..iid]
if idx==odx then
--什么都不做
PlayWavE(2)
elseif JY.Person[cid]["道具8"]>0 then
PlayWavE(2)
titlestr=JY.Person[cid]["姓名"].."已不能再持有道具．"
for n=1,20 do
redraw()
lib.GetKey()
end
current=odx
titlestr=JY.Item[item]["名称"].."交给谁？"
else
PlayWavE(0)
redraw()
if WarDrawStrBoxYesNo("交给"..JY.Person[cid]["姓名"].."可以吗？",M_White,true) then
for n=iid,7 do
JY.Person[oid]["道具"..n]=JY.Person[oid]["道具"..(n+1)]
end
JY.Person[oid]["道具8"]=0
for n=1,8 do
if JY.Person[cid]["道具"..n]==0 then
JY.Person[cid]["道具"..n]=item
break
end
end
titlestr="交换哪名武将的道具？请选择．"
TeamSelect.status[odx]=0
iid=0
status=1
else
titlestr=JY.Item[item]["名称"].."交给谁？"
current=odx
end
end
end
end
break
end
end
for i=1,8 do
if MOUSE.CLICK(466,176+i*18,626,176+16+i*18) then
 cid=TeamSelect.id[current]
local item=JY.Person[cid]["道具"..i]
if item>0 then
if status==1 then
PlayWavE(0)
DrawItemStatus(item,cid)--显示物品属性
elseif status==2 then
PlayWavE(0)
iid=i
titlestr=JY.Item[item]["名称"].."交给谁？"
status=3
elseif status==3 then
if iid==i then
PlayWavE(1)
titlestr="请选择要交换的道具．"
iid=0
status=2
else
PlayWavE(2)
end
end
end
break
end
end
end
end
end

-- 招揽武将
function HirePerson()
local num=0
local page=1
local maxpage=1
local num_per_page=6
local personnum=1
local current=1
TeamSelect={id={},status={}}
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
"郝昭"}
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
655}
local db3={
[4]=385,
[8]=386,
[12]=403,
[16]=404,
--[20]=405,
--[24]=388,
}
if JY.Base["事件333"]>=9 then
db2[8]=382--孙坚
end
if JY.Base["事件333"]>=11 then
db2[22]=226--吕布
end
if JY.Base["事件333"]>=15 then
db2[44]=513--周瑜
end
for i,v in pairs(db) do
local p1=JY.Person[420+i]
if p1["君主"]==0 then
local p2=JY.Person[420]
for idx=1,JY.PersonNum-1 do
if JY.Person[idx]["姓名"]==v then
p2=JY.Person[idx]
break
end
end
for idx,par in pairs({"代号","姓名","外号","性别","武力","智力","统率","天赋","兵种","特技1","特技2","特技3","特技4","特技5","特技6"}) do
p1[par]=p2[par]
end
p1["成长"]=10
p1["等级"]=math.modf((JY.Person[1]["等级"]+JY.Person[2]["等级"]+JY.Person[3]["等级"]+JY.Person[54]["等级"]+JY.Person[126]["等级"])/6)-5
p1["等级"]=limitX(p1["等级"],1,99)
if CC.Enhancement then
local dtlv=pjlv()
if p1["等级"]<dtlv then
p1["等级"]=dtlv
end
end
if p2["新头像代号"]>0 then
p1["头像代号"]=p2["新头像代号"]
else
p1["头像代号"]=p2["头像代号"]
end
p1["新头像代号"]=db2[i]--用这个来卡 多少多少关之后才能加入
end
end
for i=421,JY.PersonNum-1 do
if JY.Person[i]["头像代号"]>0 and JY.Person[i]["新头像代号"]<JY.EventID then
ReSetAttrib(i,true)
JY.Person[i]["战斗动作"]=GetPic(i,false,false)
num=num+1
TeamSelect.id[num]=i
if JY.Person[i]["君主"]==1 then
TeamSelect.status[num]=1--0未选择 1选择
else
TeamSelect.status[num]=0
end
end
end
for i,v in pairs(db3) do
if JY.Base["事件333"]>=i then
ReSetAttrib(v,true)
JY.Person[v]["战斗动作"]=GetPic(v,false,false)
num=num+1
TeamSelect.id[num]=v
if JY.Person[v]["君主"]==1 then
TeamSelect.status[num]=1--0未选择 1选择
else
JY.Person[v]["成长"]=10
JY.Person[v]["等级"]=math.modf((JY.Person[1]["等级"]+JY.Person[2]["等级"]+JY.Person[3]["等级"]+JY.Person[54]["等级"]+JY.Person[126]["等级"])/6)-5
JY.Person[v]["等级"]=limitX(JY.Person[v]["等级"],1,99)
if CC.Enhancement then
local dtlv=pjlv()
if JY.Person[v]["等级"]<dtlv then
JY.Person[v]["等级"]=dtlv
end
end
TeamSelect.status[num]=0
end
end
end
if num==0 then
WarDrawStrBoxConfirm("暂无可招揽的武将．",M_White,true)
return
end
 maxpage=math.modf((num-1)/6)+1
--------------------------------
-- 定义坐标信息
--------------------------------
local xy={
x1={},--左上角(边框内，实际部队图标显示位置)
y1={},
x2={},--兵力
y2={},
x3={},--姓名
y3={},
x4={},--右下角
y4={},
}
xy.x1={56,232,56,232,56,232}
xy.y1={64,64,154,154,244,244}
for i=1,6 do
xy.x1[i]=xy.x1[i]+16
xy.y1[i]=xy.y1[i]+16
end
for i=1,6 do
xy.x2[i]=xy.x1[i]+104
xy.y2[i]=xy.y1[i]+17
xy.x3[i]=xy.x1[i]+104
xy.y3[i]=xy.y1[i]+41
xy.x4[i]=xy.x1[i]+143
xy.y4[i]=xy.y1[i]+63
end
local bottom=0--当前按钮
local function GetPersonValue(pid)
--计算招揽价格
local p=JY.Person[pid]
local v=40000/(120-p["武力"])+40000/(120-p["智力"])+40000/(120-p["统率"])
if p["兵种"]==14 then
v=v+200
elseif p["兵种"]==15 then
v=v+300
elseif p["兵种"]==16 then
v=v+1000
elseif p["兵种"]==17 then
v=v+400
elseif p["兵种"]>=20 then
v=v+800
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
v=100*math.modf(v/100)
v=limitX(v,500,10000)
v=math.modf(v/2)--降低招揽价格
return v
end
--------------------------------
--redraw()
-- 内部函数，重绘
-- frame 用于控制动画显示
--------------------------------
local cid=0
local subframe,frame=0,0
local kind={[0]="无","攻击用","恢复用","变换用","宝物","兵书","名马","恢复用","种子","种子","种子","武器","防具","马车","无",}
local titlestr="招揽哪名武将？请选择．"
local function redraw()
JY.ReFreshTime=lib.GetTime()
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(4,201*2,0,0,1)
DrawGameStatus()
lib.PicLoadCache(4,203*2,16,16,1)
DrawString(26,31,titlestr,M_White,16)
for i=1,6 do
local idx=num_per_page*(page-1)+i
if idx>num then
break
end
local pid=TeamSelect.id[idx]
local name=JY.Person[pid]["姓名"]
local hp=string.format("% 5d",JY.Person[pid]["最大兵力"])
local lv=string.format("% 5d",JY.Person[pid]["等级"])
local picid
if TeamSelect.status[idx]==0 then--未选择时，为+19
picid=JY.Person[pid]["战斗动作"]+19
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_White,16)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
else
picid=JY.Person[pid]["战斗动作"]+12+frame
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_DarkOrange,16)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
end
DrawString(xy.x2[i],xy.y2[i],hp,M_White,16)
DrawString(xy.x1[i]+4,xy.y1[i]+48,lv,M_White,16)
end
DrawString(110,359,string.format("% 4d",page),M_White,16)
DrawString(142,359,string.format("% 4d",maxpage),M_White,16)
--选中人物
cid=TeamSelect.id[current]
lib.PicLoadCache(2,JY.Person[cid]["头像代号"]*2,464,32,1)
DrawString(489-3*#JY.Person[cid]["姓名"],136,JY.Person[cid]["姓名"],M_White,16)
DrawString(584-4*#JY.Bingzhong[JY.Person[cid]["兵种"]]["名称"],24,JY.Bingzhong[JY.Person[cid]["兵种"]]["名称"],M_White,16)
DrawString(585,48,string.format("% 5d",JY.Person[cid]["等级"]),M_White,16)
DrawString(585,80,string.format("% 5d",JY.Person[cid]["统率"]),M_White,16)
DrawString(585,112,string.format("% 5d",JY.Person[cid]["武力"]),M_White,16)
DrawString(585,144,string.format("% 5d",JY.Person[cid]["智力"]),M_White,16)
if bottom==1 then
lib.PicLoadCache(4,224*2,173,351,1)
elseif bottom==2 then
lib.PicLoadCache(4,225*2,173,367,1)
elseif bottom==3 then
lib.PicLoadCache(4,226*2,317,351,1)
end
--道具
for i=1,8 do
local tid=JY.Person[cid]["道具"..i]
local color=M_White
if tid>0 then
DrawString(466,176+i*18,JY.Item[tid]["名称"],color,16)
DrawString(562,176+i*18,"／"..kind[JY.Item[tid]["类型"]],color,16)
else
if i==1 then
DrawString(466,176+i*18,"无携带品．",M_White,16)
end
break
end
end
ReFresh()
subframe=subframe+1
if subframe==8 then
frame=1-frame
subframe=0
end
end
Dark()
redraw()
Light()
while JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL do
redraw()
local eventtype,keypress=getkey()
bottom=0
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('结束游戏吗？',M_White,true) then
lib.Delay(100)
if WarDrawStrBoxYesNo('再玩一次吗？',M_White,true) then
lib.Delay(100)
JY.Status=GAME_START
else
lib.Delay(100)
JY.Status=GAME_END
end
end
elseif MOUSE.HOLD(174,352,204,366) then--page up
bottom=1
elseif MOUSE.HOLD(174,368,204,382) then--page down
bottom=2
elseif MOUSE.HOLD(319,353,362,380) then--close
bottom=3
elseif MOUSE.CLICK(174,352,204,366) then--page up
PlayWavE(0)
page=limitX(page-1,1,maxpage)
elseif MOUSE.CLICK(174,368,204,382) then--page down
PlayWavE(0)
page=limitX(page+1,1,maxpage)
elseif MOUSE.CLICK(319,353,362,380) then--close
PlayWavE(0)
for i=1,CC.OpearteSpeed do
redraw()
end
if WarDrawStrBoxYesNo("　可以吗？　",M_White,true) then
redraw()
Dark()
DrawSMap()
Light()
return
end
elseif MOUSE.CLICK(464,32,464+64,32+80) then--head
PlayWavE(0)
PersonStatus(cid,"","",1)
else
for i=1,6 do
if MOUSE.CLICK(xy.x1[i],xy.y1[i],xy.x4[i],xy.y4[i]) then
local idx=num_per_page*(page-1)+i
if idx<=num then
current=idx
cid=TeamSelect.id[idx]
if TeamSelect.status[idx]==0 then
PlayWavE(0)
TeamSelect.status[idx]=1
titlestr="招揽"..JY.Person[cid]["姓名"].."．"
redraw()
PersonStatus(cid,"","",2)
redraw()
local v=GetPersonValue(cid)
if WarDrawStrBoxYesNo("花"..v.."金，招揽"..JY.Person[cid]["姓名"].."可以吗？",M_White,true) then
redraw()
if v>JY.Base["黄金"] then
PlayWavE(2)
TeamSelect.status[idx]=0
titlestr="黄金不够．"
for n=1,20 do
redraw()
lib.GetKey()
end
titlestr="招揽哪名武将？请选择．"
else
GetMoney(-v)
TeamSelect.status[idx]=1
ModifyForce(cid,1)
PlayWavE(11)
DrawStrBoxCenter(JY.Person[cid]["姓名"].."成为部下．")
end
else
TeamSelect.status[idx]=0
titlestr="招揽哪名武将？请选择．"
end
else
PlayWavE(2)
titlestr=JY.Person[cid]["姓名"].."已经成为部下．"
for n=1,20 do
redraw()
lib.GetKey()
end
titlestr="招揽哪名武将？请选择．"
end
end
break
end
end
for i=1,8 do
if MOUSE.CLICK(466,176+i*18,626,176+16+i*18) then
cid=TeamSelect.id[current]
local item=JY.Person[cid]["道具"..i]
if item>0 then
PlayWavE(0)
DrawItemStatus(item,cid)--显示物品属性
end
break
end
end
end
end
end

-- 经典模式练武场
function Maidan(fid)
fid=fid or 1
local m_pid={}
local m_eid={}
local num_pid,num_eid=0,0
local lv_max=math.modf((JY.Person[1]["等级"]+JY.Person[2]["等级"]+JY.Person[3]["等级"]+JY.Person[54]["等级"]+JY.Person[126]["等级"])/6)-5
lv_max=limitX(lv_max,1,99)
for i=1,JY.PersonNum-1 do
if JY.Person[i]["君主"]==fid then
if JY.Person[i]["等级"]<lv_max then
num_pid=num_pid+1
m_pid[num_pid]=i
end
else
num_eid=num_eid+1
m_eid[num_eid]=i
end
end
if num_pid>0 and num_eid>10 then
talk(369,"请问谁要练武？")
local pid=FightSelectMenu(m_pid)
if pid<=0 then
talk(369,"那么，下次再说吧．")
return
end
local eid=m_eid[math.random(num_eid)]
talk(369,"那么，开始吧．")
local magic={}
for mid=1,JY.MagicNum-1 do
 magic[mid]=false
if HaveMagic(pid,mid) then
magic[mid]=true
end
end
local s={0,1,2,4,6}
if fight(pid,eid,s[math.random(5)])==1 then
talk(369,"真精彩！")
PlayWavE(11)
LvUp(pid)
JY.Person[pid]["经验"]=0
DrawStrBoxCenter(JY.Person[pid]["姓名"].."的等级上升了！")
else
talk(369,"太可惜了．")
DrawStrBoxCenter(JY.Person[pid]["姓名"].."得到了大量经验．")
JY.Person[pid]["经验"]=JY.Person[pid]["经验"]+30
if JY.Person[pid]["经验"]>=100 then
PlayWavE(11)
LvUp(pid)
JY.Person[pid]["经验"]=0
DrawStrBoxCenter(JY.Person[pid]["姓名"].."的等级上升了！")
end
end
else
talk(369,"没有人需要练武了．")
end
end

-- 纵横模式练武场
function Maidan2(fid)
fid=fid or 1
local m_pid={}
local m_eid={}
local num_pid,num_eid=0,0
for i=1,JY.PersonNum-1 do
if JY.Person[i]["修炼"]==0 then
if JY.Person[i]["君主"]==fid then
num_pid=num_pid+1
m_pid[num_pid]=i
else
num_eid=num_eid+1
m_eid[num_eid]=i
end
end
end
if num_pid>0 and num_eid>10 then
talk(369,"请问谁要练武？")
local pid=FightSelectMenu(m_pid)
if pid<=0 then
talk(369,"那么，下次再说吧．")
return
end
local eid=m_eid[math.random(num_eid)]
talk(369,"那么，开始吧．")
local magic={}
for mid=1,JY.MagicNum-1 do
 magic[mid]=false
if HaveMagic(pid,mid) then
magic[mid]=true
end
end
local s={0,1,2,4,6}
if fight(pid,eid,s[math.random(5)])==1 then
talk(369,"真精彩！")
PlayWavE(11)
JY.Person[pid]["修炼"]=1
local exped=math.random(2)
if JY.Person[pid]["兵种"]==13 or JY.Person[pid]["兵种"]==16 or JY.Person[pid]["兵种"]==19 or JY.Person[pid]["兵种"]==26 then
if exped==1 and JY.Person[pid]["智力"]<100 then
JY.Person[pid]["智力经验"]=JY.Person[pid]["智力经验"]+10
DrawStrBoxCenter(JY.Person[pid]["姓名"].."得到了大量智力经验．")
if JY.Person[pid]["智力经验"]>=200 then
JY.Person[pid]["智力经验"]=JY.Person[pid]["智力经验"]-200
PlayWavE(12)
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."智力提升",M_White)
JY.Person[pid]["智力"]=JY.Person[pid]["智力"]+1
end
elseif exped==2 and JY.Person[pid]["统率"]<100 then
JY.Person[pid]["统率经验"]=JY.Person[pid]["统率经验"]+10
DrawStrBoxCenter(JY.Person[pid]["姓名"].."得到了大量统率经验．")
if JY.Person[pid]["统率经验"]>=200 then
JY.Person[pid]["统率经验"]=JY.Person[pid]["统率经验"]-200
PlayWavE(12)
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."统率提升",M_White)
JY.Person[pid]["统率"]=JY.Person[pid]["统率"]+1
end
end
else
if exped==1 and JY.Person[pid]["武力"]<100 then
JY.Person[pid]["武力经验"]=JY.Person[pid]["武力经验"]+10
DrawStrBoxCenter(JY.Person[pid]["姓名"].."得到了大量武力经验．")
if JY.Person[pid]["武力经验"]>=200 then
JY.Person[pid]["武力经验"]=JY.Person[pid]["武力经验"]-200
PlayWavE(12)
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."武力提升",M_White)
JY.Person[pid]["武力"]=JY.Person[pid]["武力"]+1
end
elseif exped==2 and JY.Person[pid]["统率"]<100 then
JY.Person[pid]["统率经验"]=JY.Person[pid]["统率经验"]+10
DrawStrBoxCenter(JY.Person[pid]["姓名"].."得到了大量统率经验．")
if JY.Person[pid]["统率经验"]>=200 then
JY.Person[pid]["统率经验"]=JY.Person[pid]["统率经验"]-200
PlayWavE(12)
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."统率提升",M_White)
JY.Person[pid]["统率"]=JY.Person[pid]["统率"]+1
end
end
end
else
talk(369,"太可惜了．")
JY.Person[pid]["修炼"]=1
local exped=math.random(2)
if JY.Person[pid]["兵种"]==13 or JY.Person[pid]["兵种"]==16 or JY.Person[pid]["兵种"]==19 or JY.Person[pid]["兵种"]==26 then
if exped==1 and JY.Person[pid]["智力"]<100 then
JY.Person[pid]["智力经验"]=JY.Person[pid]["智力经验"]+5
DrawStrBoxCenter(JY.Person[pid]["姓名"].."得到了一些智力经验．")
if JY.Person[pid]["智力经验"]>=200 then
JY.Person[pid]["智力经验"]=JY.Person[pid]["智力经验"]-200
PlayWavE(12)
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."智力提升",M_White)
JY.Person[pid]["智力"]=JY.Person[pid]["智力"]+1
end
elseif exped==2 and JY.Person[pid]["统率"]<100 then
JY.Person[pid]["统率经验"]=JY.Person[pid]["统率经验"]+5
DrawStrBoxCenter(JY.Person[pid]["姓名"].."得到了一些统率经验．")
if JY.Person[pid]["统率经验"]>=200 then
JY.Person[pid]["统率经验"]=JY.Person[pid]["统率经验"]-200
PlayWavE(12)
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."统率提升",M_White)
JY.Person[pid]["统率"]=JY.Person[pid]["统率"]+1
end
end
else
if exped==1 and JY.Person[pid]["武力"]<100 then
JY.Person[pid]["武力经验"]=JY.Person[pid]["武力经验"]+5
DrawStrBoxCenter(JY.Person[pid]["姓名"].."得到了一些武力经验．")
if JY.Person[pid]["武力经验"]>=200 then
JY.Person[pid]["武力经验"]=JY.Person[pid]["武力经验"]-200
PlayWavE(12)
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."武力提升",M_White)
JY.Person[pid]["武力"]=JY.Person[pid]["武力"]+1
end
elseif exped==2 and JY.Person[pid]["统率"]<100 then
JY.Person[pid]["统率经验"]=JY.Person[pid]["统率经验"]+5
DrawStrBoxCenter(JY.Person[pid]["姓名"].."得到了一些统率经验．")
if JY.Person[pid]["统率经验"]>=200 then
JY.Person[pid]["统率经验"]=JY.Person[pid]["统率经验"]-200
PlayWavE(12)
WarDrawStrBoxWaitKey(JY.Person[pid]["姓名"].."统率提升",M_White)
JY.Person[pid]["统率"]=JY.Person[pid]["统率"]+1
end
end
end
end
else
talk(369,"没有人需要练武了．")
end
end

function Shop()
local sid=JY.Base["道具屋"]
if sid<=0 then
PlayWavE(2)
WarDrawStrBoxConfirm("此地没有道具屋．",M_White,true)
return
end
local shopitem={
[1]={41,28,31},--汜水关之战前,陈留
[2]={28,31,44},--虎牢关之战后,北平
[3]={28,31,53,41,38,35},--信都城之战后,信都
[4]={28,31,53},--广川之战后,广川
--北海之战前,北平/信都
[5]={28,31,53,41,38,35,34},--北海之战后,北平/信都/北海,这里只列了北海的
[6]={28,31,53,50,47},--徐州I之战后,北平/信都/北海/徐州/下邳，这里只列的徐州的
--下邳的 31,32,50,47,34
[7]={20,22,24,26,41,38,35},--小沛
[8]={20,22,24,26,28,29,31,53},--许昌I
[9]={31,32,50,47,34},--下邳
[10]={20,22,24,26,29,31,32,53},--邺
[11]={41,38,39,35,44},--白马
[12]={41,42,38,39,35,36},--汝南
[13]={20,22,24,26,29,32,53,34},--襄阳I
[14]={42,39,36,44,45},--江夏I
--[15]={29,32,54,50,51,47},--江陵I
[15]={21,23,25,27,29,32,54,50,51,47},--江陵I,考虑到游戏实际,主要在江陵,而不再襄阳II,将襄阳II的部分道具也加进来
[16]={42,39,36,44,45,20,22,24},--江夏II
[17]={50,51,47,48,38,39},--长沙
[18]={21,23,25,27,29,42,39,36,34},--襄阳II
[19]={21,23,25,27,29,30,32,54},--成都I
[20]={29,32,54,42,20,22,24,34},--涪
[21]={21,23,25,27,29,30,32,33},--成都II
[22]={42,39,36,29,32,54,48,51},--西陵
[23]={42,39,40,36,37,48,51,52},--江陵II
[24]={21,23,25,27,43,30,33,55},--襄阳III
[25]={30,33,55,43,40,37,45,46},--宛
[26]={30,33,55,49,20,22,24,26},--许昌II
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
local shopitem2={--武器店
[1]={74,80,89,140,147},--汜水关之战前,陈留
[2]={74,75,80,89,99,140,141,147},--虎牢关之战后,北平
[3]={80,81,85,89,95,117,120,141,148},--信都城之战后,信都
[4]={75,90,141,148},--广川之战后,广川
--北海之战前,北平/信都
[5]={80,81,85,89,95,117,120,141,148},--北海之战后,北平/信都/北海,这里只列了信都的
[6]={90,96,120,125,126,131,142,148},--徐州I之战后,北平/信都/北海/徐州/下邳，这里只列的徐州的
--下邳的 31,32,50,47,34
[7]={81,85,100,117,135,142,152},--小沛
[8]={86,90,101,104,105,117,135,142,152,148},--许昌I
[9]={86,90,101,105,142,152,148},--下邳,其实没有，随便编几个
[10]={76,82,91,102,106,118,136,131,130},--邺
[11]={140,141,142,147,148},--白马,其实没有，随便编几个
[12]={76,82,91,102,106,142},--汝南,其实没有，随便编几个
[13]={91,97,127,131,141,143,152,149,150},--襄阳I
[14]={76,82,86,106,109,110,118,121,123},--江夏I
[15]={103,107,111,114,132,133,142,144,153},--江陵I
[16]={76,82,86,106,109,110,118,121,123},--江夏II
[17]={76,82,86,103,107,110},--长沙,其实没有，随便编几个
[18]={77,90,92,96,97,128},--襄阳II
[19]={78,83,87,111,115,128,145,153,150},--成都I
[20]={92,97,102,106,139},--涪,其实没有，随便编几个
[21]={78,83,87,111,115,128,145,153,150},--成都II
[22]={78,83,87,92,97,102,106,111,115,139},--西陵,其实没有，随便编几个
[23]={93,97,103,108,112,137,119,122,129},--江陵II
[24]={84,88,98,116,124,138,134,146,151},--襄阳III
[25]={84,88,98,103,108},--宛
[26]={79,94,113,139,132,154},--许昌II
}
local shopid=1--1道具 2武器
local buysellmenu={
{"　买道具 ",nil,1},
{"　买武器 ",nil,1},
{"　　卖 ",nil,1},
}
local itemmenu={}
local itemnum=0
local personmenu={}
local personnum=0
for i=1,JY.PersonNum-1 do
if JY.Person[i]["君主"]==1 then
personmenu[i]={fillblank(JY.Person[i]["姓名"],11),nil,1}
personnum=personnum+1
else
personmenu[i]={"",nil,0}
end
end
PlayWavE(0)
local status="SelectBuySell"
local iid,pid
local function showbuysellmenu()
talk_sub(375,"有什么事情？")
--添加道具屋选择
sid=JY.Base["道具屋"]
if sid>1 then
local dm={"陈留","北平","信都","广川","无","徐州","小沛","许昌I","无","邺","无","无","襄阳I","江夏I","江陵I","江夏II","无","襄阳II","成都I","无","成都II","无","江陵II","襄阳III","宛","许昌II"}
local n={}
for i=1,sid do
if dm[i]=="无" then
n[i]={fillblank(dm[i],11),nil,0}
else
n[i]={fillblank(dm[i],11),nil,1}
end
end
local s=ShowMenu(n,#n,8,0,200,0,0,6,1,16,M_White,M_White)
if s>0 then
sid=s
end
end
local r=ShowMenu(buysellmenu,3,0,0,156,0,0,3,1,16,M_White,M_White)
if r==1 then
status="SelectItem"
shopid=1
itemmenu={}
itemnum=0
for i,v in pairs(shopitem[sid]) do
itemnum=itemnum+1
itemmenu[itemnum]={fillblank(JY.Item[v]["名称"],11),nil,1}
end
elseif r==2 then
status="SelectItem"
shopid=2
itemmenu={}
itemnum=0
for i,v in pairs(shopitem2[sid]) do
itemnum=itemnum+1
itemmenu[itemnum]={fillblank(JY.Item[v]["名称"],11),nil,1}
end
elseif r==3 then
status="SelectPersonSell"
else
status="Exit"
PlayWavE(1)
end
end
local function showitemmenu()
talk_sub(375,"买什么？")
local r=ShowMenu(itemmenu,itemnum,0,0,156,0,0,3,1,16,M_White,M_White)
if r>0 then
if shopid==1 then
iid=shopitem[sid][r]
elseif shopid==2 then
iid=shopitem2[sid][r]
else
iid=1
end
local x=145
local y=CC.ScreenH/2
local size=16
lib.PicLoadCache(4,50*2,x,y,1)
DrawString(x+16,y+16,JY.Item[iid]["名称"],C_Name,size)
DrawStr(x+16,y+36,GenTalkString(JY.Item[iid]["说明"],18),M_White,size)
if talkYesNo(375,JY.Item[iid]["名称"].."黄金"..JY.Item[iid]["价值"].."0，*可以吗？") then
--如果黄金不够
if JY.Item[iid]["价值"]*10>JY.Base["黄金"] then
DrawSMap()
PlayWavE(2)
talk(375,"看来黄金不够了．")
status="SelectItem"
else
status="SelectPerson"
end
end
else
status="SelectBuySell"
PlayWavE(1)
end
end
local function showpersonnum()
talk_sub(375,JY.Item[iid]["名称"].."哪位要？")
local r
if personnum<=10 then
r=ShowMenu(personmenu,JY.PersonNum-1,10,0,156,0,0,5,1,16,M_White,M_White)
else
r=ShowMenu(personmenu,JY.PersonNum-1,8,0,156,0,0,6,1,16,M_White,M_White)
end
if r>0 then
pid=r
if JY.Person[pid]["道具8"]>0 then
PlayWavE(2)
if talkYesNo(375,"那位不能再*带东西了，别人吧？") then
status="SelectPerson"
else
status="SelectItem"
end
else
PersonStatus_sub(pid,108,156)
if talkYesNo(375,"可以交给"..JY.Person[pid]["姓名"].."吗？") then
GetMoney(-10*JY.Item[iid]["价值"])
for i=1,8 do
if JY.Person[pid]["道具"..i]==0 then
JY.Person[pid]["道具"..i]=iid
break
end
end
DrawSMap()
DrawYJZBox(32,32,"道具买卖",M_White,true)
if talkYesNo(375,"多谢了，还要……再买点吗？") then
status="SelectItem"
else
status="SelectBuySell"
end
else
status="SelectPerson"
end
end
else
status="SelectItem"
PlayWavE(1)
end
end
local function showpersonnumsell()
talk_sub(375,"想卖哪位的东西？")
local r
if personnum<=10 then
r=ShowMenu(personmenu,JY.PersonNum-1,10,0,156,0,0,5,1,16,M_White,M_White)
else
r=ShowMenu(personmenu,JY.PersonNum-1,8,0,156,0,0,6,1,16,M_White,M_White)
end
if r>0 then
pid=r
status="SelectItemSell"
else
status="SelectBuySell"
PlayWavE(1)
end
end
local function showitemmenusell()
if JY.Person[pid]["道具1"]==0 then
PlayWavE(2)
talk(375,"您没有什么东西可卖。")
status="SelectPersonSell"
else
local sellmenu={}
for i=1,8 do
iid=JY.Person[pid]["道具"..i]
if iid>0 then
sellmenu[i]={fillblank(JY.Item[iid]["名称"],11),nil,1}
else
sellmenu[i]={"",nil,0}
end
end
talk_sub(375,"卖什么？")
local rr=ShowMenu(sellmenu,8,0,0,156,0,0,3,1,16,M_White,M_White)
if rr>0 then
iid=JY.Person[pid]["道具"..rr]
if talkYesNo(375,"用"..(10*math.modf(JY.Item[iid]["价值"]*0.75)).."黄金收购"..JY.Item[iid]["名称"].."，可以吗？") then
for i=rr,7 do
JY.Person[pid]["道具"..i]=JY.Person[pid]["道具"..(i+1)]
end
JY.Person[pid]["道具8"]=0
GetMoney(10*math.modf(JY.Item[iid]["价值"]*0.75))
DrawSMap()
DrawYJZBox(32,32,"道具买卖",M_White,true)
if talkYesNo(375,"多谢了，还要……想卖点什么吗？") then
status="SelectPersonSell"--?
status="SelectItemSell"--?
else
status="SelectBuySell"
end
else
status="SelectItemSell"
end
else
status="SelectPersonSell"
PlayWavE(1)
end
end
end
talk(375,"我是商人．")
while true do
JY.Tid=375
DrawSMap()
DrawYJZBox(32,32,"道具买卖",M_White,true)
if status=="SelectBuySell" then
showbuysellmenu()
elseif status=="SelectItem" then
showitemmenu()
elseif status=="SelectPerson" then
showpersonnum()
elseif status=="SelectPersonSell" then
showpersonnumsell()
elseif status=="SelectItemSell" then
showitemmenusell()
else
talk(375,"欢迎再来．")
break
end
end
end

function WarIni()
War={}
SetWarConst()
War.Person={}
War.PersonNum=0
Drama={}
end

--用于连战，其实就是把敌军删掉
function WarIni2()
for i=War.PersonNum,1,-1 do
if War.Person[i].enemy then
table.remove(War.Person,i)
War.PersonNum=War.PersonNum-1
end
end
end

--选择我军
--fid,君主id 一般应该是1，刘备
--team,我军参战人员配置数据,id为-1时可选择,否则为强制出战
function SelectTerm(fid,team)
local num=0
local page=1
local maxpage=1
local num_per_page=6
local personnum=0
local maxpersonnum=0
local current=1
for j=1,20 do
local idx=(j-1)*7
if team[idx+1]==-1 then
personnum=personnum+1
end
if team[idx+7]==nil then
break
end
maxpersonnum=j
end
if personnum==0 then
SelectTerm_sub(fid,team)
return
else
ExchangeItem(fid,true)
end
TeamSelect={id={},status={}}
for i=1,JY.PersonNum-1 do
if JY.Person[i]["君主"]==fid then
ReSetAttrib(i,true)
JY.Person[i]["战斗动作"]=GetPic(i,false,false)
num=num+1
TeamSelect.id[num]=i
TeamSelect.status[num]=0--0未选择 1选择(可取消) 2选择(不可取消)
for j=1,maxpersonnum do
local idx=(j-1)*7
if team[idx+1]+1==i then
TeamSelect.status[num]=2
break
end
end
end
end
maxpage=math.modf((num-1)/6)+1
--------------------------------
-- 定义坐标信息
--------------------------------
local xy={
x1={},--左上角(边框内，实际部队图标显示位置)
y1={},
x2={},--兵力
y2={},
x3={},--姓名
y3={},
x4={},--右下角
y4={},
}
xy.x1={56,232,56,232,56,232}
xy.y1={64,64,154,154,244,244}
for i=1,6 do
xy.x1[i]=xy.x1[i]+16
xy.y1[i]=xy.y1[i]+16
end
for i=1,6 do
xy.x2[i]=xy.x1[i]+104
xy.y2[i]=xy.y1[i]+17
xy.x3[i]=xy.x1[i]+104
xy.y3[i]=xy.y1[i]+41
xy.x4[i]=xy.x1[i]+143
xy.y4[i]=xy.y1[i]+63
end
local bottom=0--当前按钮
--------------------------------
--redraw()
-- 内部函数，重绘
-- frame 用于控制动画显示
--------------------------------
local cid=0
local subframe,frame=0,0
local kind={[0]="无","攻击用","恢复用","变换用","宝物","兵书","名马","恢复用","种子","种子","种子","武器","防具","马车","无",}
local titlestr="让哪名武将参加战斗？"
local function redraw()
JY.ReFreshTime=lib.GetTime()
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(4,201*2,0,0,1)
DrawGameStatus()
lib.PicLoadCache(4,203*2,16,16,1)
DrawString(26,31,titlestr,M_White,16)
for i=1,6 do
local idx=num_per_page*(page-1)+i
if idx>num then
break
end
local pid=TeamSelect.id[idx]
local name=JY.Person[pid]["姓名"]
local hp=string.format("% 5d",JY.Person[pid]["最大兵力"])
local lv=string.format("% 5d",JY.Person[pid]["等级"])
local picid
if TeamSelect.status[idx]==0 then--未选择时，为+19
picid=JY.Person[pid]["战斗动作"]+19
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_White,16)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
else
picid=JY.Person[pid]["战斗动作"]+12+frame
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_DarkOrange,16)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
end
DrawString(xy.x2[i],xy.y2[i],hp,M_White,16)
DrawString(xy.x1[i]+4,xy.y1[i]+48,lv,M_White,16)
end
DrawString(110,359,string.format("% 4d",page),M_White,16)
DrawString(142,359,string.format("% 4d",maxpage),M_White,16)
DrawString(252,359,string.format("% 4d",personnum),M_White,16)
--选中人物
cid=TeamSelect.id[current]
lib.PicLoadCache(2,JY.Person[cid]["头像代号"]*2,464,32,1)
DrawString(489-3*#JY.Person[cid]["姓名"],136,JY.Person[cid]["姓名"],M_White,16)
DrawString(584-4*#JY.Bingzhong[JY.Person[cid]["兵种"]]["名称"],24,JY.Bingzhong[JY.Person[cid]["兵种"]]["名称"],M_White,16)
DrawString(585,48,string.format("% 5d",JY.Person[cid]["等级"]),M_White,16)
DrawString(585,80,string.format("% 5d",JY.Person[cid]["统率"]),M_White,16)
DrawString(585,112,string.format("% 5d",JY.Person[cid]["武力"]),M_White,16)
DrawString(585,144,string.format("% 5d",JY.Person[cid]["智力"]),M_White,16)
if bottom==1 then
lib.PicLoadCache(4,224*2,173,351,1)
elseif bottom==2 then
lib.PicLoadCache(4,225*2,173,367,1)
elseif bottom==3 then
lib.PicLoadCache(4,226*2,317,351,1)
end
--道具
for i=1,8 do
local tid=JY.Person[cid]["道具"..i]
if tid>0 then
DrawString(466,176+i*18,JY.Item[tid]["名称"],M_White,16)
DrawString(562,176+i*18,"／"..kind[JY.Item[tid]["类型"]],M_White,16)
else
if i==1 then
DrawString(466,176+i*18,"无携带品．",M_White,16)
end
break
end
end
ReFresh()
subframe=subframe+1
if subframe==8 then
frame=1-frame
subframe=0
end
end
redraw()
while JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL do
redraw()
getkey()
bottom=0
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('结束游戏吗？',M_White,true) then
lib.Delay(100)
if WarDrawStrBoxYesNo('再玩一次吗？',M_White,true) then
lib.Delay(100)
JY.Status=GAME_START
else
lib.Delay(100)
JY.Status=GAME_END
end
end
elseif MOUSE.HOLD(174,352,204,366) then--page up
bottom=1
elseif MOUSE.HOLD(174,368,204,382) then--page down
bottom=2
elseif MOUSE.HOLD(319,353,362,380) then--close
bottom=3
elseif MOUSE.CLICK(174,352,204,366) then--page up
PlayWavE(0)
page=limitX(page-1,1,maxpage)
elseif MOUSE.CLICK(174,368,204,382) then--page down
PlayWavE(0)
page=limitX(page+1,1,maxpage)
elseif MOUSE.CLICK(319,353,362,380) then--close
PlayWavE(0)
for i=1,CC.OpearteSpeed do
redraw()
end
if WarDrawStrBoxYesNo("组编完毕，可以吗？",M_White,true) then
local m,n=1,1
for i=1,20 do
local idx=(i-1)*7
if team[idx+1]==-1 then
m=i
break
end
end
for n=1,num do
if TeamSelect.status[n]==1 then
team[(m-1)*7+1]=TeamSelect.id[n]-1
m=m+1
end
end
SelectTerm_sub(fid,team)
Dark()
return
end
elseif MOUSE.CLICK(464,32,464+64,32+80) then--head
PlayWavE(0)
PersonStatus(cid,"","",1)
else
for i=1,6 do
if MOUSE.CLICK(xy.x1[i],xy.y1[i],xy.x4[i],xy.y4[i]) then
local idx=num_per_page*(page-1)+i
if idx<=num then
 current=idx
if TeamSelect.status[idx]==0 then
if personnum<=0 then
PlayWavE(2)
titlestr="不能再参战了．"
for n=1,20 do
redraw()
lib.GetKey()
end
titlestr="让哪名武将参加战斗？"
else
PlayWavE(0)
TeamSelect.status[idx]=1
personnum=personnum-1
end
elseif TeamSelect.status[idx]==1 then
PlayWavE(1)
TeamSelect.status[idx]=0
personnum=personnum+1
else
PlayWavE(2)
titlestr="不能解除那名武将．"
for n=1,20 do
redraw()
lib.GetKey()
end
titlestr="让哪名武将参加战斗？"
end
end
break
end
end
for i=1,8 do
if MOUSE.CLICK(466,176+i*18,626,176+16+i*18) then
cid=TeamSelect.id[current]
local item=JY.Person[cid]["道具"..i]
if item>0 then
PlayWavE(0)
DrawItemStatus(item,cid)--显示物品属性
end
break
end
end
end
end
end

--选择我军，连续出战时使用
--fid,君主id 一般应该是1，刘备
--team,我军参战人员配置数据,id为-1时可选择,否则为强制出战
function SelectTerm2(fid,team)
local num=0
local m,n=1,1
for i=1,JY.PersonNum-1 do
if JY.Person[i]["君主"]==fid then
num=num+1
end
end
for i=1,20 do
local idx=(i-1)*7
if team[idx+1]==-1 then
m=i
break
end
end
for n=1,num do
if TeamSelect.status[n]==1 then
team[(m-1)*7+1]=TeamSelect.id[n]-1
m=m+1
end
end
for i=1,20 do
local idx=(i-1)*7
if team[idx+7]==nil then
break
end
if team[idx+1]>=0 and (team[idx+6]==-1 or GetFlag(team[idx+6])) then
--额外+1用于修复yjz数据和复刻数据的不一致
team[idx+1]=team[idx+1]+1
team[idx+2]=team[idx+2]+1
team[idx+3]=team[idx+3]+1
local wid=GetWarID(team[idx+1])
War.Person[wid].x=team[idx+2]
War.Person[wid].y=team[idx+3]
War.Person[wid].ai=1
War.Person[wid].frame=-1
War.Person[wid].d=team[idx+4]
War.Person[wid].active=true
if not War.Person[wid].troubled then
War.Person[wid].action=1
end
if team[idx+7]>0 then
War.Person[War.PersonNum].hide=true
elseif War.Person[wid].live then
SetWarMap(team[idx+2],team[idx+3],2,wid)
end
War.Person[wid].pic=WarGetPic(wid)
end
end
end

--选择我军，连续出战时使用
--fid,君主id 一般应该是1，刘备
--team,我军参战人员配置数据,修改后的版本
function SelectTerm2(fid,team)
for wid=1,War.PersonNum do
local idx=(wid-1)*7
if team[idx+7]==nil then
break
end
War.Person[wid].x=team[idx+2]+1
War.Person[wid].y=team[idx+3]+1
War.Person[wid].ai=1
War.Person[wid].frame=-1
War.Person[wid].d=team[idx+4]
War.Person[wid].active=true
if not War.Person[wid].troubled then
War.Person[wid].action=1
end
if War.Person[wid].live then
SetWarMap(team[idx+2]+1,team[idx+3]+1,2,wid)
end
War.Person[wid].pic=WarGetPic(wid)
end
end

--选择我军
--T,我军参战人员配置数据
function SelectTerm_sub(fid,T)
for i=1,20 do
local idx=(i-1)*7
if T[idx+7]==nil then
break
end
if T[idx+1]>=0 and (T[idx+6]==-1 or GetFlag(T[idx+6])) then
--额外+1用于修复yjz数据和复刻数据的不一致
T[idx+1]=T[idx+1]+1
T[idx+2]=T[idx+2]+1
T[idx+3]=T[idx+3]+1
War.PersonNum=War.PersonNum+1
table.insert(War.Person, {
id=T[idx+1],--人物ID
x=T[idx+2],--坐标X
y=T[idx+3],--坐标Y
--pic=JY.Person[T[idx+1]]["战斗动作"],--形象ID
action=1,--动作 0静止，1走路...
effect=0,--高亮显示
hurt=-1,--显示伤害数值
bz=JY.Person[T[idx+1]]["兵种"],
movewav=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["音效"],--移动音效
atkwav=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["攻击音效"],--攻击音效
movestep=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["移动"],--移动范围
movespeed=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["移动速度"],--移动速度
atkfw=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["攻击范围"],--攻击范围
sq_limited=100,
atk_buff=0,
def_buff=0,
frame=-1,--显示帧数
d=T[idx+4],--方向
active=true,--可否行动
enemy=false,--敌军我军
friend=false,--友军？
ai=1,--AI类型
live=true,--存活
hide=false,--伏兵
was_hide=false,--伏兵
troubled=false,--混乱
leader=false,
})
if War.Leader1==T[idx+1] then
War.Person[War.PersonNum].leader=true
end
if JY.Person[T[idx+1]]["君主"]~=fid then
War.Person[War.PersonNum].friend=true
end
if T[idx+7]>0 then
War.Person[War.PersonNum].hide=true
War.Person[War.PersonNum].was_hide=true
else
SetWarMap(T[idx+2],T[idx+3],2,War.PersonNum)
end
ReSetAttrib(T[idx+1],true)
War.Person[War.PersonNum].pic=WarGetPic(War.PersonNum)
end
end
if CC.Enhancement then
local lv_t={}
local cz=0
for i=1,War.PersonNum do
if JY.Person[War.Person[i].id]["君主"]==1 then
table.insert(lv_t,JY.Person[War.Person[i].id]["等级"])
cz=cz+1
end
end
table.sort(lv_t,function(a,b)return b<a end)
for ii=1,cz do
table.insert(lv_t,1)
end
local lv=0
for ii=1,cz do
lv=lv+lv_t[ii]
end
lv=math.modf(lv/cz)--得到我军平均等级
if lv>=0 then
else--如果获取我方出战人员平均等级失败，那就只有一种可能，就是连战
lv=pjlv()--所以这里只能获取我方全军的平均等级
end
CC.lv=lv
JY.Base["我军等级"]=CC.lv --把等级写入r档，以便调用
end



end

--选择敌军
function SelectEnemy(T)
JY.Base["全军撤退"]=JY.EventID
local lvoffset=0
if CC.Enhancement then
local elv_sum=1
local num=0
for i=1,99 do
local idx=(i-1)*11
if T[idx+11]==nil then
break
end
if T[idx+1]>=0 and (T[idx+10]==-1 or GetFlag(T[idx+10])) then
elv_sum=elv_sum+T[idx+6]
num=num+1
end
end
local elv=math.modf(elv_sum/num)--实际敌军平均等级
if CC.lv==nil then
CC.lv=JY.Base["我军等级"]
end
lvoffset=math.modf(limitX(CC.lv-elv+elv/10,0,99))--得到我军平均等级和敌军平均等级的差值
end
for i=1,99 do
local idx=(i-1)*11
if T[idx+11]==nil then
break
end
if T[idx+1]>=0 and (T[idx+10]==-1 or GetFlag(T[idx+10])) then
--额外+1用于修复yjz数据和复刻数据的不一致
T[idx+1]=T[idx+1]+1
T[idx+2]=T[idx+2]+1
T[idx+3]=T[idx+3]+1
JY.Person[T[idx+1]]["等级"]=T[idx+6]+lvoffset
JY.Person[T[idx+1]]["兵种"]=T[idx+7]
War.PersonNum=War.PersonNum+1
War.EnemyNum=War.EnemyNum+1
table.insert(War.Person, {
id=T[idx+1],--人物ID
x=T[idx+2],--坐标X
y=T[idx+3],--坐标Y
action=1,--动作 0静止，1走路...
effect=0,--高亮显示
hurt=-1,--显示伤害数值
bz=JY.Person[T[idx+1]]["兵种"],
movewav=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["音效"],--移动音效
atkwav=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["攻击音效"],--攻击音效
movestep=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["移动"],--移动范围
movespeed=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["移动速度"],--移动速度
atkfw=JY.Bingzhong[JY.Person[T[idx+1]]["兵种"]]["攻击范围"],--攻击范围
sq_limited=100,
atk_buff=0,
def_buff=0,
frame=-1,--显示帧数
d=T[idx+4],--方向
active=true,--可否行动
enemy=true,--敌军我军
friend=false,--友军？
ai=T[idx+5],--AI类型
aitarget=T[idx+8]+1,
ai_dx=T[idx+8]+1,
ai_dy=T[idx+9]+1,
live=true,--存活
hide=false,--伏兵
was_hide=false,--伏兵
troubled=false,--混乱
leader=false,
})
if War.Leader2==T[idx+1] then
War.Person[War.PersonNum].leader=true
end
if T[idx+11]>0 then
War.Person[War.PersonNum].hide=true
War.Person[War.PersonNum].was_hide=true
else
SetWarMap(T[idx+2],T[idx+3],2,War.PersonNum)
end
ReSetAttrib(T[idx+1],true)
War.Person[War.PersonNum].pic=WarGetPic(War.PersonNum)
end
end
War.CX=limitX(War.Person[1].x-math.modf(War.MW/2),1,War.Width-War.MW+1)
War.CY=limitX(War.Person[1].y-math.modf(War.MD/2),1,War.Depth-War.MD+1)
--设置纵横模式下的友军和敌军等级
if CC.Enhancement then
for i=1,War.PersonNum do
if JY.Person[War.Person[i].id]["君主"]~=1 then
if JY.Person[War.Person[i].id]["等级"]<lvoffset-4 then
JY.Person[War.Person[i].id]["等级"]=JY.Person[War.Person[i].id]["等级"]+lvoffset
end
if War.Person[i].enemy then --纵横模式下，敌军按照等级自动升级兵种
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
end
end
local id=i
local bzid=JY.Person[War.Person[id].id]["兵种"]
War.Person[id].bz=bzid
War.Person[id].movewav=JY.Bingzhong[bzid]["音效"]--移动音效
War.Person[id].atkwav=JY.Bingzhong[bzid]["攻击音效"]--攻击音效
War.Person[id].movestep=JY.Bingzhong[bzid]["移动"]--移动范围
War.Person[id].movespeed=JY.Bingzhong[bzid]["移动速度"]--移动速度
War.Person[id].atkfw=JY.Bingzhong[bzid]["攻击范围"]--攻击范围
War.Person[id].pic=WarGetPic(id)
ReSetAttrib(War.Person[i].id,true)--重新计算战场属性？
end
end
end

function DefineWarMap(id,warname,wartarget,maxturn,leader1,leader2)
War.MapID=id
War.WarName=warname
War.WarTarget=wartarget
War.MaxTurn=maxturn
War.Leader1=leader1+1
War.Leader2=leader2+1
LoadWarMap(War.MapID)
end

function WarStart()
JY.SubScene=-1
SRPG()
end

--保存战场
function WarSave(id)
Byte.set8(JY.Data_Base,136,War.MapID)
Byte.set8(JY.Data_Base,137,War.Width)
Byte.set8(JY.Data_Base,138,War.Depth)
Byte.set8(JY.Data_Base,139,War.CX)
Byte.set8(JY.Data_Base,140,War.CY)
Byte.set16(JY.Data_Base,141,War.PersonNum)
Byte.set8(JY.Data_Base,143,War.Weather)
Byte.set8(JY.Data_Base,144,War.Turn)
Byte.set8(JY.Data_Base,145,War.MaxTurn)
Byte.set16(JY.Data_Base,146,War.Leader1)
Byte.set16(JY.Data_Base,148,War.Leader2)
Byte.set8(JY.Data_Base,150,War.EnemyNum)
JY.Base["战场名称"]=War.WarName
JY.Base["战场目标"]=War.WarTarget
local offset=152
for i=1,War.PersonNum do
Byte.set16(JY.Data_Base,offset,War.Person[i].id)
Byte.set8(JY.Data_Base,offset+2,War.Person[i].x)
Byte.set8(JY.Data_Base,offset+3,War.Person[i].y)
Byte.set8(JY.Data_Base,offset+4,War.Person[i].d)
Byte.set8(JY.Data_Base,offset+5,War.Person[i].ai)
Byte.set16(JY.Data_Base,offset+6,War.Person[i].aitarget)
Byte.set8(JY.Data_Base,offset+8,War.Person[i].ai_dx)
Byte.set8(JY.Data_Base,offset+9,War.Person[i].ai_dy)
local v=0
if War.Person[i].enemy then
v=v+1
end
if War.Person[i].friend then
v=v+2
end
if War.Person[i].active then
v=v+4
end
if War.Person[i].live then
v=v+8
end
if War.Person[i].hide then
v=v+16
end
if War.Person[i].was_hide then
v=v+32
end
if War.Person[i].troubled then
v=v+64
end
Byte.set8(JY.Data_Base,offset+10,v)
offset=offset+11
end
--Map
offset=1152
for i=1,War.Width*War.Depth do
local v=War.Map[i]+32*War.Map[War.Width*War.Depth*(9-1)+i]
 Byte.set8(JY.Data_Base,offset+i,v)
end
--Save
SaveRecord(id)
end

--读取战场
function WarLoad(id)
WarIni()
--War basic informaction
War.MapID=Byte.get8(JY.Data_Base,136)
War.Width=Byte.get8(JY.Data_Base,137)
War.Depth=Byte.get8(JY.Data_Base,138)
War.CX=Byte.get8(JY.Data_Base,139)
War.CY=Byte.get8(JY.Data_Base,140)
War.PersonNum=Byte.get16(JY.Data_Base,141)
War.Weather=Byte.get8(JY.Data_Base,143)
War.Turn=Byte.get8(JY.Data_Base,144)
War.MaxTurn=Byte.get8(JY.Data_Base,145)
War.Leader1=Byte.get16(JY.Data_Base,146)
War.Leader2=Byte.get16(JY.Data_Base,148)
War.EnemyNum=Byte.get8(JY.Data_Base,150)
War.WarName=JY.Base["战场名称"]
War.WarTarget=JY.Base["战场目标"]
--Map
War.MiniMapCX=680-War.Width*2
War.MiniMapCY=411-War.Depth*2
War.Map={}
CleanWarMap(1,0)--地形
CleanWarMap(2,0)--wid
CleanWarMap(3,0)--
CleanWarMap(4,1)--选择范围
CleanWarMap(5,-1)--攻击价值
CleanWarMap(6,-1)--策略价值
CleanWarMap(7,0)--选择的策略
CleanWarMap(8,0)--AI强化用，我军的攻击范围
CleanWarMap(9,0)--水火控制
CleanWarMap(10,0)--攻击范围，显示用
local offset=1152
for i=1,War.Width*War.Depth do
local v=Byte.get8(JY.Data_Base,offset+i)
local v1=v%32
local v2=math.modf(v/32)
War.Map[i]=v1
War.Map[War.Width*War.Depth*(9-1)+i]=v2
end
--War.Person
offset=152
for i=1,War.PersonNum do
War.Person[i]={}
War.Person[i].id=Byte.get16(JY.Data_Base,offset)
War.Person[i].x=Byte.get8(JY.Data_Base,offset+2)
War.Person[i].y=Byte.get8(JY.Data_Base,offset+3)
War.Person[i].d=Byte.get8(JY.Data_Base,offset+4)
War.Person[i].ai=Byte.get8(JY.Data_Base,offset+5)
War.Person[i].aitarget=Byte.get16(JY.Data_Base,offset+6)
War.Person[i].ai_dx=Byte.get8(JY.Data_Base,offset+8)
War.Person[i].ai_dy=Byte.get8(JY.Data_Base,offset+9)
local v=Byte.get8(JY.Data_Base,offset+10)
if v%2==1 then
War.Person[i].enemy=true
else
War.Person[i].enemy=false
end
if (math.modf(v/2))%2==1 then
War.Person[i].friend=true
else
War.Person[i].friend=false
end
if (math.modf(v/4))%2==1 then
War.Person[i].active=true
else
War.Person[i].active=false
end
if (math.modf(v/8))%2==1 then
War.Person[i].live=true
else
War.Person[i].live=false
end
if (math.modf(v/16))%2==1 then
War.Person[i].hide=true
else
War.Person[i].hide=false
end
if (math.modf(v/32))%2==1 then
War.Person[i].was_hide=true
else
War.Person[i].was_hide=false
end
if (math.modf(v/64))%2==1 then
War.Person[i].troubled=true
else
War.Person[i].troubled=false
end
local pid=War.Person[i].id
War.Person[i].action=1--动作 0静止，1走路...
War.Person[i].effect=0--高亮显示
War.Person[i].hurt=-1--显示伤害数值
War.Person[i].bz=JY.Person[pid]["兵种"]
War.Person[i].movewav=JY.Bingzhong[JY.Person[pid]["兵种"]]["音效"]--移动音效
War.Person[i].atkwav=JY.Bingzhong[JY.Person[pid]["兵种"]]["攻击音效"]--攻击音效
War.Person[i].movestep=JY.Bingzhong[JY.Person[pid]["兵种"]]["移动"]--移动范围
War.Person[i].movespeed=JY.Bingzhong[JY.Person[pid]["兵种"]]["移动速度"]--移动速度
War.Person[i].atkfw=JY.Bingzhong[JY.Person[pid]["兵种"]]["攻击范围"]--攻击范围
War.Person[i].sq_limited=100
War.Person[i].atk_buff=0
War.Person[i].def_buff=0
War.Person[i].frame=-1--显示帧数
if pid==War.Leader1 or pid==War.Leader2 then
War.Person[i].leader=true
else
War.Person[i].leader=false
end
if War.Person[i].live and (not War.Person[i].hide) then
SetWarMap(War.Person[i].x,War.Person[i].y,2,i)
end
ReSetAttrib(pid,false)
War.Person[i].pic=WarGetPic(i)
WarResetStatus(i)
offset=offset+11
end
end

--提示是否保存
--flag, 默认为1 1战前提示 2战后提示
function RemindSave(flag)
flag=flag or 1
if flag==1 then
DrawSMap()
elseif flag==2 then
JY.Status=GAME_START--仅仅是为了方便自动计算坐标
end
if WarDrawStrBoxYesNo("现在储存吗？",M_White,true) then
local menu2={
{" 1. ",nil,1},
{" 2. ",nil,1},
{" 3. ",nil,1},
{" 4. ",nil,1},
{" 5. ",nil,1},
}
for id=1,5 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."未使用档案"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,104,"将档案储存在哪里？",M_White)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,5) then
if WarDrawStrBoxYesNo(string.format("储存在硬碟的第%d号，可以吗？",s2),M_White,true) then
if flag==2 then
JY.Status=GAME_SMAP_AUTO--与前面对应，改回来
end
SaveRecord(s2)
end
end
end
if flag==1 then
DrawSMap()
elseif flag==2 then
JY.Status=GAME_SMAP_AUTO--与前面对应，改回来
end
end

--等级上升
--pid 人物id, n 默认为1
function LvUp(pid,n)
pid=pid or 0
n=n or 1
if pid>0 then
JY.Person[pid]["等级"]=limitX(JY.Person[pid]["等级"]+n,1,99)
end
end

--测试到达战场坐标
--pid 人物id, -1时为任意我方武将
function WarCheckLocation(pid,y,x)
--pid=-1代表任意我方我将
pid=pid+1--修正
x=x+1
y=y+1
if War.SelID==0 then
return false
end
local v=War.Person[War.SelID]
if v.live and (not v.hide) and ((pid==0 and (not v.enemy) and (not v.friend)) or pid==v.id) and x==v.x and y==v.y then
return true
end
return false
end

--测试到达战场坐标得到物品
--x,y 坐标, item 物品id, event 检查事件id
function WarLocationItem(y,x,item,event)
if War.SelID==0 then
return false
end
if JY.Person[War.Person[War.SelID].id]["道具8"]>0 then
return false
end
x=x+1
y=y+1
if (not GetFlag(event)) then
local v=War.Person[War.SelID]
if v.live and (not v.hide) and (not v.enemy) and (not v.friend) and x==v.x and y==v.y then
WarGetItem(War.SelID,item)
SetFlag(event,1)
end
end
end

--测试到达战场坐标
--pid 人物id, -1时为任意我方武将
function WarCheckArea(pid,y1,x1,y2,x2)
--pid=-1代表任意我方我将
pid=pid+1--修正
x1=x1+1
y1=y1+1
x2=x2+1
y2=y2+1
if War.SelID==0 then
return false
end
local v=War.Person[War.SelID]
if v.live and (not v.hide) and ((pid==0 and (not v.enemy)) or pid==v.id) and between(v.x,x1,x2) and between(v.y,y1,y2) then
return true
end
return false
end

function GetWarID(pid)
for i,v in pairs(War.Person) do
if pid==v.id then
return i
end
end
return 0
end

function WarMeet(pid1,pid2)
local id1,id2=0,0
if War.SelID==0 then
return false
end
if pid1==-1 then--不限定特点人物
if War.Person[War.SelID].enemy then--必须不为敌军
return false
else
id1=War.SelID
pid1=War.Person[War.SelID].id
end
elseif War.Person[War.SelID].id==pid1 then--指定人物 必须为当前行动人物
id1=War.SelID
else
return false
end
id2=GetWarID(pid2)
if id1>0 and id2>0 and
War.Person[id1].live and War.Person[id2].live and 
(not War.Person[id1].hide) and (not War.Person[id2].hide) and 
JY.Person[pid1]["兵力"]>0 and JY.Person[pid2]["兵力"]>0 then
if math.abs(War.Person[id1].x-War.Person[id2].x)+math.abs(War.Person[id1].y-War.Person[id2].y)==1 then
return true
end
end
return false
end

-- 人物移动到指定坐标
-- pid 人物id
function WarMoveTo(pid,x,y)
x=x+1
y=y+1
local wid=GetWarID(pid)
if wid>0 then
War.SelID=wid
War_CalMoveStep(wid,256,true)
x,y=WarGetExistXY(x,y,wid)
War_MovePerson(x,y)
CleanWarMap(4,1)
War.LastID=War.SelID
War.SelID=0
end
end

-- 伏兵出现
-- pid 人物id
function WarShowArmy(pid)
pid=pid+1--修正id
local wid=GetWarID(pid)
if wid>0 then
if (not War.Person[wid].hide) or (not War.Person[wid].live) then
return
end
local x,y=War.Person[wid].x,War.Person[wid].y
if WarCanExistXY(x,y,wid) then
War.Person[wid].hide=false
WarPersonCenter(wid)
SetWarMap(x,y,2,wid)
PlayWavE(15)
WarDelay(4)
return
end
local DX={0,0,-1,1}
local DY={1,-1,0,0}
local dx={1,-1,1,-1,}
local dy={-1,1,1,-1}
for n=1,8 do
for d=1,4 do
for i=1,n do
local nx=x+DX[d]*n+dx[d]*i
local ny=y+DY[d]*n+dy[d]*i
if between(nx,1,War.Width) and between(ny,1,War.Depth) then
if WarCanExistXY(nx,ny,wid) then
War.Person[wid].x=nx
War.Person[wid].y=ny
War.Person[wid].hide=false
WarPersonCenter(wid)
SetWarMap(nx,ny,2,wid)
PlayWavE(15)
WarDelay(4)
return
end
end
end
end
end
end
end

--寻找最近的可以出现的地点
--x,y目标地点
--wid战场人物id
function WarGetExistXY(x,y,wid)
local DX={0,0,-1,1}
local DY={1,-1,0,0}
local dx={1,-1,1,-1,}
local dy={-1,1,1,-1}
if WarCanExistXY(x,y,wid) then
return x,y
end
for n=1,8 do
for d=1,4 do
for i=1,n do
local nx=x+DX[d]*n+dx[d]*i
local ny=y+DY[d]*n+dy[d]*i
if between(nx,1,War.Width) and between(ny,1,War.Depth) then
if WarCanExistXY(nx,ny,wid) then
return nx,ny
end
end
end
end
end
return War.Person[wid].x,War.Person[wid].y
end

--获得黄金
--money 黄金数量,为负数时失去黄金，无提示
function GetMoney(money)
JY.Base["黄金"]=limitX(JY.Base["黄金"]+money,0,50000)
end

--获得道具
--pid 人物id
function GetItem(pid,item)
for i=1,8 do
if JY.Person[pid]["道具"..i]==0 then
JY.Person[pid]["道具"..i]=item
PlayWavE(11)
DrawStrBoxWaitKey("获得"..JY.Item[item]["名称"].."．",M_White)
return true
end
end
return false
end

--获得道具
--wid 人物wid
function WarGetItem(wid,item)
local pid=War.Person[wid].id
for i=1,8 do
if JY.Person[pid]["道具"..i]==0 then
JY.Person[pid]["道具"..i]=item
PlayWavE(11)
WarDrawStrBoxWaitKey("获得"..JY.Item[item]["名称"].."．",M_White)
ReSetAttrib(pid,false)
return true
end
end
return false
end

--失去道具
--wid 人物wid
function WarLoseItem(wid,item)
local pid=War.Person[wid].id
for i=1,8 do
if JY.Person[pid]["道具"..i]==0 then
JY.Person[pid]["道具"..i]=item
PlayWavE(11)
WarDrawStrBoxWaitKey("获得"..JY.Item[item]["名称"].."．",M_White)
ReSetAttrib(pid,false)
return true
end
end
return false
end

--残存部队得到50点经验值．
--Exp 经验值,无用
function WarGetExp(Exp)
Exp=50
PlayWavE(0)
lib.GetKey()
local x,y
local w=288
local h=80
x=16+576/2-w/2
y=32+432/2-h/2
local x1=x+205
local y1=y+36
local x2=x1+52
local y2=y1+24
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
lib.PicLoadCache(4,84*2,x,y,1)
if flag==2 then
lib.PicLoadCache(4,56*2,x1,y1,1)
else
lib.PicLoadCache(4,55*2,x1,y1,1)
end
ReFresh()
end
local current=0
while true do
redraw(current)
getkey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=2
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
WarDelay(4)
break
else
current=0
end
end
for i,v in pairs(War.Person) do
if v.live and (not v.hide) then
if (not v.enemy) and (not v.friend) then
local pid=v.id
if JY.Person[pid]["等级"]<99 then
JY.Person[pid]["经验"]=JY.Person[pid]["经验"]+Exp
if JY.Person[pid]["经验"]>=100 then
JY.Person[pid]["经验"]=JY.Person[pid]["经验"]-100
WarLvUp(i)
end
end
end
end
end
end

--判断是否进入混乱状态
--wid war_id
--4.防御方是否会陷入混乱
--如果牵制后，防御方的士气下降到30以下，则按以下算法判断是否会陷入混乱。
--计算出一个0－4之间的随机数，如果随机数小于3，则防御方部队陷入混乱。
--『说明』防御方有60％的可能性陷入混乱。
function WarGetTrouble(wid)
local pid=War.Person[wid].id
if JY.Person[pid]["士气"]<30 and JY.Person[pid]["兵力"]>0 then
if math.random(5)-1<3 then
if War.Person[wid].troubled then
WarDrawStrBoxDelay(JY.Person[pid]["姓名"].."更加混乱了！",M_White)
else
War.Person[wid].troubled=true
War.Person[wid].action=7
WarDelay(2)
WarDrawStrBoxDelay(JY.Person[pid]["姓名"].."混乱了！",M_White)
end
end
end
end

--唤醒混乱中的部队
--wid war_id
--恢复因子＝0～99的随机数，如果恢复因子小于（统御力＋士气）÷3，那么部队被唤醒．由此看出，统御越高，士气越高，越容易从混乱中苏醒．
function WarTroubleShooting(wid)
local pid=War.Person[wid].id
if War.Person[wid].troubled then
local flag=false
if math.random(100)-1<(JY.Person[pid]["统率"]+JY.Person[pid]["士气"])/3 then
flag=true
end
if CC.Enhancement then
if WarCheckSkill(wid,20) then--沉着
flag=true
end
end
if flag then
WarPersonCenter(wid)
War.Person[wid].troubled=false
WarDrawStrBoxDelay(JY.Person[pid]["姓名"].."从混乱中恢复！",M_White)
end
end
end

--兵力士气减半
--id 1我军 2敌军
--kind 1兵力 2士气
function WarEnemyWeak(id,kind)
for i,v in pairs(War.Person) do
if v.live and (not v.hide) then
if (id==1 and (not v.enemy)) or (id==2 and v.enemy) then
local pid=v.id
if kind==1 then
JY.Person[pid]["兵力"]=limitX(JY.Person[pid]["兵力"]/2,1,JY.Person[pid]["最大兵力"])
elseif kind==2 then
JY.Person[pid]["士气"]=limitX(JY.Person[pid]["士气"]/2,1,v.sq_limited)
ReSetAttrib(pid,false)
WarGetTrouble(i)
end
end
end
end
end

--水火控制
--x,y坐标,输入为dos版坐标，实际需要+1修正
--kind 1放火 2放水 3取消放水
function WarFireWater(x,y,kind)
x=x+1
y=y+1
if kind==3 then
SetWarMap(x,y,9,0)
else
if GetWarMap(x,y,2)==0 then
SetWarMap(x,y,9,kind)
end
if kind==1 then
elseif kind==2 then
end
end
War.CX=limitX(x-math.modf(War.MW/2),1,War.Width-War.MW+1)
War.CY=limitX(y-math.modf(War.MD/2),1,War.Depth-War.MD+1)
WarDelay(CC.WarDelay)
end

--检查是否具有某项技能
--wid 人物战斗编号
--skillid 技能编号
function WarCheckSkill(wid,skillid)
local pid=War.Person[wid].id
if JY.Person[pid]["天赋"]==skillid then
return true
end
if JY.Person[pid]["姓名"]==JY.Item[JY.Person[pid]["武器"]]["专属特技人"] and JY.Item[JY.Person[pid]["武器"]]["专属特技"]==skillid then
return true
end
if JY.Item[JY.Person[pid]["武器"]]["特技"]==skillid then
return true
end
for i=1,6 do
if JY.Person[pid]["特技"..i]==skillid then
if JY.Person[pid]["等级"]>=CC.SkillExp[JY.Person[pid]["成长"]][i] then
return true
end
end
end
return false
end

function CheckSkill(pid,skillid)
if pid<=0 then
return false
end
if JY.Person[pid]["天赋"]==skillid then
return true
end
for i=1,6 do
if JY.Person[pid]["特技"..i]==skillid then
if JY.Person[pid]["等级"]>=CC.SkillExp[JY.Person[pid]["成长"]][i] then
return true
end
end
end
return false
end

--原fight.lua
function fight(id1,id2,sid)
if JY.Status==GAME_START or JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL or JY.Status==GAME_MMAP then
Dark()
if CC.ScreenW~=CONFIG.Width2 or CC.ScreenH~=CONFIG.Height2 then
CC.ScreenW=CONFIG.Width2
CC.ScreenH=CONFIG.Height2
Config()
PicCatchIni()
end
elseif JY.Status==GAME_WMAP or JY.Status==GAME_DEAD or JY.Status==GAME_END then
Dark()
end
if sid==nil then
if JY.Status==GAME_WMAP then
local wid=GetWarID(id2)
sid=GetWarMap(War.Person[wid].x,War.Person[wid].y,1)
else
local s={0,1,2,4,6}
sid=s[math.random(5)]
end
end
local r=fight_sub(id1,id2,sid)
Dark()
if JY.Status==GAME_START then
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL or JY.Status==GAME_MMAP then
if CC.ScreenW~=CONFIG.Width or CC.ScreenH~=CONFIG.Height then
CC.ScreenW=CONFIG.Width
CC.ScreenH=CONFIG.Height
Config()
PicCatchIni()
end
DrawSMap()
Light()
elseif JY.Status==GAME_WMAP then
DrawWarMap()
Light()
elseif JY.Status==GAME_DEAD then
elseif JY.Status==GAME_END then
end
return r
end

function fight_sub(id1,id2,sid)
local n=2
local ID={id1,id2}
local p1,p2=JY.Person[id1],JY.Person[id2]
local fightname=fillblank(p1["姓名"],12).."战"..fillblank(p2["姓名"],12)
local card={[1]={},[2]={}}
local card_num={}
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
card_num[1]=5+p1["威风"]
card_num[2]=5+p2["威风"]
local hpmax={150+p1["等级"],150+p2["等级"]}
local hp={150+p1["等级"],150+p2["等级"]}
local mp={20,20}
if p1["武力"]>p2["武力"] then
mp[1]=35
elseif p1["武力"]<p2["武力"] then
mp[2]=35
end
local atk={math.max(math.modf(p1["武力"]/10)-1,2),math.max(math.modf(p2["武力"]/10)-1,2)}
if atk[1]-atk[2]>5 then
atk[2]=atk[1]-5
elseif atk[2]-atk[1]>5 then
atk[1]=atk[2]-5
end
local atk_offset=8/math.max(atk[1],atk[2])
atk[1]=math.modf(atk[1]*atk_offset)
atk[2]=math.modf(atk[2]*atk_offset)
atk[1]=atk[1]+math.modf(p1["奋战"]/8)-p2["奋战"]%8
atk[2]=atk[2]+math.modf(p2["奋战"]/8)-p1["奋战"]%8
if p1["士气"]<80 then
atk[1]=atk[1]-1
end
if p1["士气"]<30 then
atk[1]=atk[1]-1
end
if p2["士气"]<80 then
atk[2]=atk[2]-1
end
if p2["士气"]<30 then
atk[2]=atk[2]-1
end
if atk[1]<2 then
atk[1]=2
end
if atk[2]<2 then
atk[2]=2
end
if JY.Status==GAME_WMAP then
end
local s={}
s[1]={
d=0,--0123 下上左右
x=96,
pic=p1["战斗动作"],
action=9,--0静止 1移动 2攻击 3防御 4被攻击 5喘气 9不存在
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
dl=p1["底力"],--底力可否使用
jj=p1["急救"],--急救可否使用
bq=p1["不屈"],--不屈，最低伤害下限，否则不受伤害
txt="",
}
s[2]={
d=0,
x=576,
pic=p2["战斗动作"],
action=9,--0静止 1移动 2攻击 3防御 4被攻击 5喘气 6举手 9不存在
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
jj=p2["急救"],--急救可否使用
bq=p2["不屈"],--不屈，最低伤害下限，否则不受伤害
txt="",
}
s[1].ym=limitX(s[1].ym,0,math.modf(p1["士气"]/14))
s[1].lj=limitX(s[1].lj,0,math.modf(p1["士气"]/14))
s[2].ym=limitX(s[2].ym,0,math.modf(p2["士气"]/14))
s[2].lj=limitX(s[2].lj,0,math.modf(p2["士气"]/14))
local size=48*2
local size2=64*2
local sy=256
local pic1=0
local pic2=10
--00 平原 01 森林 02 山地 03 河流 04 桥梁 05 城墙 06 城池 07 草原
--08 村庄 09 悬崖 0A 城门 0B 荒地 0C 栅栏 0D 鹿砦 0E 兵营 0F 粮仓
--10 宝物库 11 房舍 12 火焰 13 浊流
if sid==0 or sid==7 then
pic1=4
pic2=12
elseif sid==2 or sid==11 then
pic1=0
pic2=13
elseif sid==1 then
pic1=3
pic2=12
elseif sid==4 then
pic1=1
pic2=11
elseif sid==6 or sid==8 or sid==13 or sid==14 or sid==15 or sid==16 then
pic1=2
pic2=10
end
local function admp(i,v)
v=math.modf(v)
mp[i]=limitX(mp[i]+v,0,100)
end
local function dechp(i,v,flag)--flag 格挡成功
flag=flag or false
if math.random(100)<s[3-i].atkbuff then
v=v+1
end
if math.random(100)<s[i].defbuff then
v=v-1
end
v=math.modf(v)
if v<1 then
v=1
end
if flag and s[i].bq>0 then
v=0
end
hp[i]=hp[i]-v
if hp[i]<0 then
hp[i]=0
end
--被攻击时mp增加
admp(i,1+v/2)
end
local function show()
getkey()
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(1,pic2*2,-408,212,1)
lib.PicLoadCache(1,pic1*2,-168,92,1)
DrawBox(84,101,152,185,M_White)
lib.PicLoadCache(2,p1["头像代号"]*2,86,103,1)
if s[1].losser then
lib.Background(86,103,86+64,103+80,106)
end
DrawBox(154,163,222,185,M_White)
DrawBox(224,163,292,185,M_White)
DrawString(188-#p1["姓名"]*4,166,p1["姓名"],M_White,16)
DrawString(226,166,string.format("武力 %3d",p1["武力"]),M_White,16)
DrawStrBox(166,101,s[1].txt,M_White,16)
DrawBox(616,101,684,185,M_White)
lib.PicLoadCache(2,p2["头像代号"]*2,618,103,1)
if s[2].losser then
lib.Background(618,103,618+64,103+80,106)
end
DrawBox(546,163,614,185,M_White)
DrawBox(476,163,544,185,M_White)
DrawString(580-#p2["姓名"]*4,166,p2["姓名"],M_White,16)
DrawString(478,166,string.format("武力 %3d",p2["武力"]),M_White,16)
DrawStrBox(-162,101,s[2].txt,M_White,16)
lib.FillColor(384-math.modf(300*hp[1]/hpmax[1]),192,384,204,M_Red)
lib.FillColor(384,192,384+math.modf(300*hp[2]/hpmax[2]),204,M_Blue)
DrawBox(81,192,687,204,M_White)
for i=1,2 do
if s[i].action==0 then
lib.PicLoadCache(11,(s[i].pic+16+s[i].d)*2,s[i].x,sy,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+16+s[i].d)*2,s[i].x,sy,1+2+8,s[i].effect)
end
elseif s[i].action==1 then
lib.PicLoadCache(11,(s[i].pic+s[i].frame+s[i].d*4)*2,s[i].x,sy,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+s[i].frame+s[i].d*4)*2,s[i].x,sy,1+2+8,s[i].effect)
end
elseif s[i].action==2 then
lib.PicLoadCache(11,(s[i].pic+30+s[i].frame+s[i].d*4)*2,s[i].x+(size-size2)/2,sy+(size-size2)/2,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+30+s[i].frame+s[i].d*4)*2,s[i].x+(size-size2)/2,sy+(size-size2)/2,1+2+8,s[i].effect) 
end
elseif s[i].action==3 then
lib.PicLoadCache(11,(s[i].pic+22+s[i].d)*2,s[i].x,sy,1)
if s[i].effect>0 then 
lib.PicLoadCache(11,(s[i].pic+22+s[i].d)*2,s[i].x,sy,1+2+8,s[i].effect) 
end
elseif s[i].action==4 then
lib.PicLoadCache(11,(s[i].pic+26+s[i].d%2)*2,s[i].x,sy,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+26+s[i].d%2)*2,s[i].x,sy,1+2+8,s[i].effect)
end
elseif s[i].action==5 then
lib.PicLoadCache(11,(s[i].pic+20+s[i].frame)*2,s[i].x,sy,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+20+s[i].frame)*2,s[i].x,sy,1+2+8,s[i].effect)
end
elseif s[i].action==6 then
lib.PicLoadCache(11,(s[i].pic+28)*2,s[i].x,sy,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+28)*2,s[i].x,sy,1+2+8,s[i].effect)
end
end
end
lib.PicLoadCache(4,206*2,0,0,1)
DrawString(384-#fightname*16/2/2,8,fightname,M_White,16)
end
local function turn(id,d)
if s[id].d==d then
return
end
s[id].action=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
if s[id].d~=0 then
s[id].d=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
s[id].d=d
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(6)
ReFresh(2)
end
local function move(id,dx)
local flag=1
s[id].action=1
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
local step=12
if dx<s[id].x then
step=-12
end
for i=s[id].x,dx,step do
s[id].x=i
s[id].frame=s[id].frame+1
if s[id].frame>=2 then
s[id].frame=0
end
JY.ReFreshTime=lib.GetTime()
show()
if flag==1 then
PlayWavE(s[id].movewav)
flag=4
else
flag=flag-1
end
ReFresh(3)
lib.GetKey()
end
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh(2)
end
local function move2(dx1,dx2)
local count=1
local step1,step2=12,12
if dx1<s[1].x then
step1=-12
turn(1,2)
else
turn(1,3)
end
if dx2<s[2].x then
step2=-12
turn(2,2)
else
turn(2,3)
end
s[1].action=1
s[2].action=1
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
local mt=0
while true do
local flag=true
if s[1].x~=dx1 then
flag=false
s[1].x=s[1].x+step1
s[1].frame=s[1].frame+1
if s[1].frame>=2 then
s[1].frame=0
end
else
s[1].action=0
end
if s[2].x~=dx2 then
flag=false
s[2].x=s[2].x+step2
s[2].frame=s[2].frame+1
if s[2].frame>=2 then
s[2].frame=0
end
else
s[2].action=0
end
JY.ReFreshTime=lib.GetTime()
show()
if count==1 then
if s[1].action==1 then
PlayWavE(s[1].movewav)
end
if s[2].action==1 then
PlayWavE(s[2].movewav)
end
count=4
else
count=count-1
end
ReFresh(4)
lib.GetKey()
if flag then
break
end
end
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
local function atk_p(id,gd)--普通攻击 平手 gd 暴击概率
local n=3
local flag=false
s[id].action=2
s[3-id].action=2
if math.random(gd)>50 then
flag=true
PlayWavE(6)
s[1].txt=str[2][math.random(10)]
s[2].txt=str[2][math.random(10)]
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
end
for i=0,3 do
s[id].frame=i
s[3-id].frame=i
if flag and i==0 then
PlayWavE(33)
for t=8,192,8 do
s[id].effect=t
s[3-id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[1].effect=0
s[2].effect=0
end
if i==3 then
if flag then
PlayWavE(31)
s[1].txt=str[5][math.random(15)]
s[2].txt=str[5][math.random(15)]
else
PlayWavE(30)
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if flag then
if s[3-id].x>s[id].x then
s[3-id].x=s[3-id].x+24
s[id].x=s[id].x-24
else
s[3-id].x=s[3-id].x-24
s[id].x=s[id].x+24
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_ms(id,gd)--秒杀 gd 暴击概率
local n=3
s[id].action=2
local flag=false
s[id].txt=str[3][math.random(15)]
if ID[id]==2 then
s[id].txt=str[3][math.random(15)].."*鬼胡斩！"
end
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=24,240,6 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
if i==3 then
if s[3-id].x>s[id].x then
s[id].x=s[3-id].x-size
else
s[id].x=s[3-id].x+size
end
if math.random(100)<gd then
s[3-id].txt=str[5][math.random(15)]
flag=true
s[3-id].action=3
PlayWavE(31)
dechp(3-id,20+atk[id],true)
s[3-id].effect=208
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].txt=str[4][math.random(15)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,300+atk[id])
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if s[3-id].x>s[id].x then
if flag then
s[id].x=s[3-id].x-size
s[3-id].x=s[3-id].x+size
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x+size
end
else
if flag then
s[id].x=s[3-id].x+size
s[3-id].x=s[3-id].x-size
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x-size
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_aq(id,gd)--暗器偷袭 gd表示格挡几率
local n=3
s[id].action=2
local flag1,flag2=0,false
if math.random(5)==1 then
flag1=1
end
if ID[id]==170 then--黄忠
if flag1==0 then
if math.random(4)==1 then
flag1=1
end
end
gd=gd/2
end
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(6)
s[id].txt="嘿嘿嘿*你躲得过这一箭吗！"
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
if flag1==1 then
PlayWavE(33)
for t=8,192,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
lib.GetKey()
end
end
s[id].effect=0
PlayWavE(37)
end
if i==3 then
if math.random(100)<gd then
flag2=true
s[3-id].action=3
PlayWavE(30+flag1)
dechp(3-id,atk[id]*(1+flag1),true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
flag2=false
s[3-id].action=4
PlayWavE(35+flag1)
dechp(3-id,(atk[id]+10)*(1+flag1))
atk[3-id]=atk[3-id]-1
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if flag2 then
s[3-id].txt="雕虫小技！"
else
s[3-id].txt="卑鄙！"
card_num[3-id]=card_num[3-id]-1
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*2)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_dz(id)--普通攻击 仅动作
local n=3
s[id].action=2
for i=0,3 do
s[id].frame=i
if i==3 then
PlayWavE(7)
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_dl(id)--底力 仅动作
s[id].txt="可恶啊！！*我要宰了你！！！"
atk_dz(id)
JY.ReFreshTime=lib.GetTime()
ReFresh(4)
s[id].action=2
for t=1,3 do
for i=0,3 do
s[id].frame=i
if i==3 then
PlayWavE(7)
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
lib.GetKey()
end
end
end
local function atk_jj(id)--急救
s[id].txt="呼~好厉害~"
PlayWavE(8)
s[id].action=5
for i=1,10 do
s[id].frame=i%2
if i==5 then
PlayWavE(8)
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(8)
end
s[id].txt="还好我还有豆*赶紧吃一颗吧．"
PlayWavE(41)
for t=8,255,8 do
s[id].effect=t
hp[id]=hp[id]+1
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
lib.GetKey()
end
s[id].action=0
s[id].frame=0
s[id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(6)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_s0(id,gd)--普通攻击 gd表示格挡几率
local n=3
s[id].action=2
for i=0,3 do
s[id].frame=i
if i==3 then
if math.random(100)<gd then
s[3-id].action=3
PlayWavE(30)
dechp(3-id,atk[id]/2,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].action=4
PlayWavE(35)
dechp(3-id,atk[id])
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*2)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_s1(id,gd)--小暴击 gd表示格挡几率
local n=3
s[id].action=2
local m=24
s[id].txt=str[2][math.random(10)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=8,192,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[id].effect=0
end
if i==3 then
if math.random(100)<gd then
s[3-id].txt=str[5][math.random(15)]
m=12
s[3-id].action=3
PlayWavE(31)
s[3-id].effect=192
dechp(3-id,1+atk[id]/2,true)
else
s[3-id].txt=str[4][math.random(15)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,5+atk[id]*1.5)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if s[3-id].x>s[id].x then
s[3-id].x=s[3-id].x+m
else
s[3-id].x=s[3-id].x-m
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*2)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_s2(id,gd)--三连击 gd表示格挡几率
local n=3
local flag=true
s[id].txt=str[2][math.random(10)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
PlayWavE(39)
for t=8,96,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[id].effect=0
s[id].action=2
for t=1,3 do
for i=0,3 do
s[id].frame=i
if i==3 then
if flag and math.random(100)<gd+t*7 then
s[3-id].action=3
PlayWavE(30)
dechp(3-id,1,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
flag=false
s[3-id].action=4
PlayWavE(35)
dechp(3-id,1+atk[id]/2)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
if t==1 then
JY.ReFreshTime=lib.GetTime()
ReFresh(4)
end
end
if flag then
s[3-id].txt=str[5][math.random(15)]
else
s[3-id].txt=str[4][math.random(15)]
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*2)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_s3(id,gd)--大暴击 gd表示格挡几率
local n=3
s[id].action=2
local flag=false
s[id].txt=str[3][math.random(15)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=24,240,6 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
if i==3 then
if math.random(100)<gd then
s[3-id].txt=str[5][math.random(15)]
flag=true
s[3-id].action=3
PlayWavE(31)
dechp(3-id,2+atk[id],true)
s[3-id].effect=208
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].txt=str[4][math.random(15)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,15+atk[id]*2.5)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if s[3-id].x>s[id].x then
if flag or s[3-id].x>672-size*2 then
s[3-id].x=s[3-id].x+size/2
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x+size
end
else
if flag or s[3-id].x<size*2 then
s[3-id].x=s[3-id].x-size/2
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x-size
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_s4(id,gd)--五连击 gd表示格挡几率
local n=3
local flag=true
s[id].txt=str[3][math.random(15)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
PlayWavE(39)
for t=8,128,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[id].action=2
for t=1,5 do
for i=0,3 do
s[id].frame=i
if i==3 then
if flag and math.random(100)<gd+t*7 then
s[3-id].action=3
PlayWavE(30)
dechp(3-id,1,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
flag=false
s[3-id].action=4
PlayWavE(35)
dechp(3-id,2+atk[id]/2)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(1)
if t%2==0 then
JY.ReFreshTime=lib.GetTime()
ReFresh(1)
end
end
end
if flag then
s[3-id].txt=str[5][math.random(15)]
else
s[3-id].txt=str[4][math.random(15)]
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_s5(id,gd)--回马枪 gd表示格挡几率
local n=3
local m=size/2
s[id].action=2
local flag=false
s[id].txt=str[3][math.random(15)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
for i=0,3 do
s[id].frame=i
if i==3 then
if math.random(100)<gd then
flag=true
s[3-id].action=3
PlayWavE(30)
dechp(3-id,2,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].action=4
PlayWavE(35)
dechp(3-id,2+atk[id])
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
if s[id].x<s[3-id].x then
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x+size
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
turn(id,2)
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x-size
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
turn(id,3)
end
s[id].action=2
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=8,240,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[id].effect=0
end
if i==3 then
if s[id].x>s[3-id].x then
s[3-id].d=3
else
s[3-id].d=2
end
if flag and math.random(100)<gd+10 then
s[3-id].txt=str[5][math.random(15)]
m=size/4
s[3-id].action=3
PlayWavE(31)
s[3-id].effect=192
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
dechp(3-id,2+atk[id]/2,true)
else
s[3-id].txt=str[4][math.random(15)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,15+atk[id]*1.5)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if s[3-id].x>s[id].x then
if s[id].x<size then
m=size
end
s[3-id].x=s[3-id].x+m
else
if s[id].x>672-size then
m=size
end
s[3-id].x=s[3-id].x-m
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_s6(id,gd)--暴击极 gd表示格挡几率
local n=3
local m=36
s[id].action=2
local flag=false
s[id].txt=str[3][math.random(15)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=8,240,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
if i==3 then
if math.random(100)<gd then
flag=true
m=24
s[3-id].action=3
PlayWavE(31)
dechp(3-id,atk[id]-2,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].action=4
PlayWavE(36)
dechp(3-id,5+atk[id]*1.5)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
if s[3-id].x>s[id].x then
if s[id].x<672-size*2 then
s[3-id].x=s[3-id].x+m
end
else
if s[id].x>size*2 then
s[3-id].x=s[3-id].x-m
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
s[id].action=2
for i=0,3 do
s[id].frame=i
if i==3 then
if s[3-id].x>s[id].x then
s[id].x=s[3-id].x-size
else
s[id].x=s[3-id].x+size
end
PlayWavE(s[id].movewav)
if flag and math.random(100)<gd-10 then
s[3-id].txt=str[5][math.random(15)]
s[3-id].action=3
if s[id].x>s[3-id].x then
s[3-id].d=3
else
s[3-id].d=2
end
PlayWavE(31)
s[3-id].effect=192
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
dechp(3-id,atk[id],true)
else
s[3-id].txt=str[4][math.random(15)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,20+atk[id]*2)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
s[3-id].effect=0
if s[id].x<s[3-id].x then
if s[3-id].x>672-size*2 then
s[3-id].x=s[3-id].x+size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[3-id].x=s[3-id].x+size/4
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x+size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x+size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
else
if s[3-id].x<size*2 then
s[3-id].x=s[3-id].x-size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[3-id].x=s[3-id].x-size/4
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x-size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x-size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
local function atk_s7(id,gd)--连击极 gd表示格挡几率
local n=3
local m=24
local lianji=6
local flag=true
 
if s[id].x<s[3-id].x then
if s[id].x<size*2 then
lianji=7
end
else
if s[id].x>672-size*2 then
lianji=7
end
end
 
s[id].action=2
s[id].txt=str[3][math.random(15)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
PlayWavE(39)
for t=8,192,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
for count=1,lianji do--7 do
for i=0,3 do
s[id].frame=i
if i==3 then
if s[id].x>s[3-id].x then
s[3-id].d=3
else
s[3-id].d=2
end
if flag and math.random(100)<gd+count*7 then
s[3-id].action=3
PlayWavE(30)
dechp(3-id,2,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
flag=false
s[3-id].action=4
PlayWavE(35)
dechp(3-id,3+atk[id]/2)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(1)
end
if s[id].x<s[3-id].x then
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x+size
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].d=2
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x-size
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].d=3
end
end
if flag then
s[3-id].txt=str[5][math.random(15)]
else
s[3-id].txt=str[4][math.random(15)]
end
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end 
local function atk_s8(id,gd)--秘技 gd表示格挡几率
local n=3
local flag=true
s[id].txt=str[3][math.random(15)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
PlayWavE(39)
for t=8,128,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[id].action=2
for t=1,7 do
for i=0,3 do
s[id].frame=i
if i==3 then
if math.random(100)<gd then
s[3-id].action=3
PlayWavE(30)
dechp(3-id,2,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
flag=false
s[3-id].action=4
PlayWavE(35)
dechp(3-id,4)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(1)
end
end
 
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=128,248,8 do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
if i==3 then
if flag and math.random(100)<gd then
s[3-id].txt=str[5][math.random(15)]
flag=true
s[3-id].action=3
PlayWavE(31)
dechp(3-id,atk[id],true)
s[3-id].effect=208
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].txt=str[4][math.random(15)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,40+atk[id])
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if s[3-id].x>s[id].x then
if flag or s[3-id].x>672-size*2 then
s[3-id].x=s[3-id].x+size/2
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x+size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x+size/2
end
else
if flag or s[3-id].x<size*2 then
s[3-id].x=s[3-id].x+-size/2
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x-size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x-size/2
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end 
local function win(id)
local eid=3-id
s[eid].txt=str[6][math.random(15)]
PlayWavE(38)
s[eid].action=5
for i=1,4 do
if s[eid].action==9 then
s[eid].action=5
else
s[eid].action=9
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(3)
end
for i=16,128,16 do
s[eid].effect=i
if s[eid].action==9 then
s[eid].action=5
else
s[eid].action=9
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
end
PlayWavE(22)
s[eid].losser=true
s[eid].action=5
for i=128,256,16 do
s[eid].effect=i
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
JY.ReFreshTime=lib.GetTime()
ReFresh(4)
s[eid].action=9
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(20)
s[id].action=0
s[id].d=0
s[id].txt=str[7][math.random(10)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(25)
s[id].action=6
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(8)
ReFresh(12)
PlayWavE(5)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(25)
if hp[id]==hpmax[id] then
DrawString(288,210,JY.Person[ID[id]]["姓名"].." 完胜",M_White,48)
else
DrawString(288,210,JY.Person[ID[id]]["姓名"].." 胜",M_White,48)
end
for t=1,10 do
JY.ReFreshTime=lib.GetTime()
ReFresh()
lib.GetKey()
end
end
local function card_ini(idx)
card[idx]={}
for i=1,card_num[idx] do
card[idx][i]=math.random(9)
end
end
local function card_sort(idx)
for i=1,card_num[idx]-1 do
for j=i+1,card_num[idx] do
if card[idx][i]>card[idx][j] then
card[idx][i],card[idx][j]=card[idx][j],card[idx][i]
end
end
end
end
local function card_value(id,n1,n2,n3)
local pid=ID[id]
local wl=JY.Person[pid]["武力"]
local offset=0--math.max(math.modf(wl/2)-41,0)
offset=math.max(wl/2-41,0)
local v=0
local k=0--0普通攻击 1小暴击 2三连击 3大暴击 4五连击
--关羽:鬼胡斩,金刚罗煞斩==>关平,关索,关兴也会 
--张飞:烈袭旋风击牙,蛟天舞==>张苞也会 
--赵云:暴龙,飞鹰==>赵统,赵广也会 
--马超:马家之奥义 
--甘宁:大海之蛟龙
--specil 444
--mp[id]=100--无限mp
if wl>=100 and mp[id]>=99 and n1==4 and n2==4 and n3==4 then
return 65,9
end
--奥义1 七连击，接暴击穿人 1 111
if JY.Person[pid]["秘技1"]>0 and mp[id]>=60 and n1==1 and n2==1 and n3==1 then
return 60+offset,8
end
--连击·极 左右来回连击 1 378
if (JY.Person[pid]["连击"]==4 or JY.Person[pid]["连击"]==5 or JY.Person[pid]["连击"]==6 or JY.Person[pid]["连击"]==7) and mp[id]>=55 and n1==3 and n2==7 and n3==8 then
return 55+offset,7
end
--暴击·极 先回退，然后暴击穿人 1 159
if (JY.Person[pid]["暴击"]==4 or JY.Person[pid]["暴击"]==5 or JY.Person[pid]["暴击"]==6 or JY.Person[pid]["暴击"]==7) and mp[id]>=55 and n1==1 and n2==5 and n3==9 then
return 55+offset,6
end
--回马枪 普通穿人，接暴击 3 557/567/577
if JY.Person[pid]["回马"]>0 and mp[id]>=50 and n1==5 and n3==7 then
return 50+offset,5
end
--个人强化 258
if mp[id]>=40 and n1==2 and n2==5 and (n3==8 or n3==9) then
if pid==54 then--赵云
return 45+offset,7--连击极
elseif pid==190 then--马超
return 45+offset,5--回马
elseif pid==2 then--关羽
return 45+offset,99--一击
elseif pid==3 then--张飞
return 45+offset,6--暴击极
elseif pid==5 then--吕布
return 45+offset,8--奥义1
end
end
--五连击 3 334/345/356
if (JY.Person[pid]["连击"]==2 or JY.Person[pid]["连击"]==3 or JY.Person[pid]["连击"]==6 or JY.Person[pid]["连击"]==7) and mp[id]>=45 and n1==3 and n3<7 and n2+1==n3 then
return 40+offset,4
end
--大暴击 暴击穿人 4 266/277/288/299
if (JY.Person[pid]["暴击"]==2 or JY.Person[pid]["暴击"]==3 or JY.Person[pid]["暴击"]==6 or JY.Person[pid]["暴击"]==7) and mp[id]>=45 and n1==2 and n2>5 and n2==n3 then
return 40+offset,3
end
--三连 三连击 7-1 123/234/345/456/567/678/789
if (JY.Person[pid]["连击"]==1 or JY.Person[pid]["连击"]==3 or JY.Person[pid]["连击"]==5 or JY.Person[pid]["连击"]==7) and mp[id]>=40 and n1+1==n2 and n2+1==n3 then
return 30+offset,2
end
--三条 小暴击 9-1-1 111/222/333/444/555/666/777/888/999
if (JY.Person[pid]["暴击"]==1 or JY.Person[pid]["暴击"]==3 or JY.Person[pid]["暴击"]==5 or JY.Person[pid]["暴击"]==7) and mp[id]>=40 and n1==n2 and n2==n3 then
return 30+offset,1
end
return n1+n2+n3,0
end
local function card_remove(id,t1,t2,t3)
for i=1,card_num[id] do
if card[id][i]==t1 then
table.remove(card[id],i)
break
end
end
for i=1,card_num[id]-1 do
if card[id][i]==t2 then
table.remove(card[id],i)
break
end
end
for i=1,card_num[id]-2 do
if card[id][i]==t3 then
table.remove(card[id],i)
break
end
end
table.remove(card[id],1)
for i=card_num[id]-3,card_num[id] do
card[id][i]=math.random(9)
end
end
local function card_ai(id)
local t1,t2,t3
local vmax=0
local kind
card_sort(id)
for i=1,card_num[id]-2 do
for j=i+1,card_num[id]-1 do
for k=j+1,card_num[id] do
local v1,v2=card_value(id,card[id][i],card[id][j],card[id][k])
if v1>vmax then
vmax=v1
kind=v2
t1,t2,t3=card[id][i],card[id][j],card[id][k]
end
end
end
end
card_remove(id,t1,t2,t3)
return vmax,kind--,t1,t2,t3
end
card_ini(1)
card_ini(2)
local action_v={}
local action_k={}
local function automove()--人物接近，自动向屏幕中心移动
local cx=348
local cur=1
if math.abs(s[1].x-cx)<math.abs(s[2].x-cx) then
cur=2
end
if math.abs(s[cur].x-s[3-cur].x)>size then
if s[cur].x>s[3-cur].x then
move(cur,s[3-cur].x+size)
else
move(cur,s[3-cur].x-size)
end
end
end
local function arrive(id)
s[id].action=0
PlayWavE(5)
for i=256,0,-4 do
s[id].effect=i
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
show()
Light()
PlayWavE(4)
arrive(1)
local talkid=math.random(15)
s[1].txt=string.format(str[1][talkid*2-1],p1["外号"])
s[1].d=3
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(25)
arrive(2)
s[2].txt=string.format(str[1][talkid*2],p2["外号"])
s[2].d=2
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(25)
local msflag=false
for i=1,2 do
local pid=ID[i]
local eid=ID[3-i]
if JY.Person[pid]["一击"]>0 and JY.Person[pid]["武力"]-JY.Person[eid]["武力"]>=5 and math.random(100)<=25 then
atk_ms(i,JY.Person[eid]["武力"]-65)
mp[i]=0
msflag=true
if hp[1]==0 then
win(2)
return 2
elseif hp[2]==0 then
win(1)
return 1
end
break
end
end
if not msflag then
for i=1,2 do
local pid=ID[i]
local eid=ID[3-i]
if JY.Person[pid]["暗器"]>0 and math.random(10)<=5 then
atk_aq(i,JY.Person[eid]["武力"]-30)
break
end
end
move2(288,384)
else
automove()
end
while true do
local cur=1
for i=1,2 do
action_v[i],action_k[i]=card_ai(i)
end
automove()
if math.abs(action_v[1]-action_v[2])<=1 then
atk_p(1,action_v[1]+action_v[2])
else
if action_v[1]>action_v[2] then
cur=1
else
cur=2
end
automove()
local gd=s[3-cur].luck+20*action_v[3-cur]/action_v[cur]
if action_k[cur]==0 then
atk_s0(cur,gd)
elseif action_k[cur]==1 then
atk_s1(cur,gd)
elseif action_k[cur]==2 then
atk_s2(cur,gd)
elseif action_k[cur]==3 then
atk_s3(cur,gd)
elseif action_k[cur]==4 then
atk_s4(cur,gd)
elseif action_k[cur]==5 then
atk_s5(cur,gd)
elseif action_k[cur]==6 then
atk_s6(cur,gd)
elseif action_k[cur]==7 then
atk_s7(cur,gd)
elseif action_k[cur]==8 then
atk_s8(cur,gd)
elseif action_k[cur]==9 then
atk_s8(cur,5)
elseif action_k[cur]==99 then
atk_ms(cur,JY.Person[ID[3-cur]]["武力"]-60)
else
atk_s0(cur,gd)
end
if action_k[cur]~=0 then
admp(cur,-math.modf(action_v[cur]/10)*8)--攻击者消耗mp
end
if action_k[3-cur]~=0 then
--admp(3-cur,-math.modf(action_v[3-cur]/10)*5)--防御者不消耗mp
end
end
if hp[1]==0 then
win(2)
return 2
elseif hp[2]==0 then
win(1)
return 1
end
if s[1].x>s[2].x then
turn(1,2)
turn(2,3)
else
turn(1,3)
turn(2,2)
end
--急救
if hp[3-cur]<hpmax[3-cur]/2 and s[3-cur].jj>0 and math.random(100)<=20 then
s[3-cur].jj=0
atk_jj(3-cur)
end
--底力
if hp[3-cur]<hpmax[3-cur]/3 and s[3-cur].dl>0 and math.random(100)<=30 then
s[3-cur].dl=0
atk_dl(3-cur)
card_num[3-cur]=card_num[3-cur]+1
card[3-cur][card_num[3-cur]]=math.random(9)
admp(3-cur,100)
end
JY.ReFreshTime=lib.GetTime()
show()
for i=1,2 do
admp(i,s[i].mpadd)
--action_v[i],action_k[i]=card_ai(i)
end
ReFresh(4)
end
end

--原war.lua
function war(id1,id2,sid)
local n=2
local ID={id1,id2}
local p1,p2=JY.Person[id1],JY.Person[id2]
local bzpic1,bzpic2
local s={}
bzpic1=GetBZPic(id1,false,false)
bzpic2=GetBZPic(id2,true,false)
for i=0,100 do
s[i]={
d=3,--0123 下上左右
x=142+32*math.modf(i/9),
y=300+18*(i%9),
pic=bzpic1,
action=0,--0静止 1移动 2攻击 3防御 4被攻击 5喘气 9不存在
frame=0,
effect=0,
movewav=JY.Bingzhong[p1["兵种"]]["音效"],
txt="",
leader=false,
}
end
local sy=270
local pic1=0
local pic2=10
-- 00 平原 01 森林 02 山地 03 河流 04 桥梁 05 城墙 06 城池 07 草原
-- 08 村庄 09 悬崖 0A 城门 0B 荒地 0C 栅栏 0D 鹿砦 0E 兵营 0F 粮仓
-- 10 宝物库 11 房舍 12 火焰 13 浊流
if sid==0 or sid==7 then
pic1=4
pic2=12
elseif sid==2 or sid==11 then
pic1=0
pic2=13
elseif sid==1 then
pic1=3
pic2=12
elseif sid==4 then
pic1=1
pic2=11
elseif sid==6 or sid==8 or sid==13 or sid==14 or sid==15 or sid==16 then
pic1=2
pic2=10
end
local test_n=88
local array=WarFormation(1,test_n)
for i=1,test_n do
s[i].x=200+array.x[i]
s[i].y=350+array.y[i]
s[i].pic=bzpic1
s[i].leader=false
end
s[array.leader].leader=true
s[array.leader].pic=p1["战斗动作"]
s[array.leader].y=s[array.leader].y-16
local function show()
local piccacheid=12
local size=60
local size2=80
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(1,pic2*2,0,310,1)
lib.PicLoadCache(1,pic1*2,-68,190,1)
for i=1,test_n do
if s[i].leader then
piccacheid=12
size=60
size2=80
else
piccacheid=1
size=48
size2=64
end
if s[i].action==0 then
lib.PicLoadCache(piccacheid,(s[i].pic+16+s[i].d)*2,s[i].x,s[i].y,1)
elseif s[i].action==1 then
lib.PicLoadCache(piccacheid,(s[i].pic+s[i].frame+s[i].d*4)*2,s[i].x,s[i].y,1)
elseif s[i].action==2 then
lib.PicLoadCache(piccacheid,(s[i].pic+30+s[i].frame+s[i].d*4)*2,s[i].x+(size-size2)/2,s[i].y+(size-size2)/2,1)
elseif s[i].action==3 then
lib.PicLoadCache(piccacheid,(s[i].pic+22+s[i].d)*2,s[i].x,s[i].y,1)
elseif s[i].action==4 then
lib.PicLoadCache(piccacheid,(s[i].pic+26+s[i].d%2)*2,s[i].x,s[i].y,1)
elseif s[i].action==5 then
lib.PicLoadCache(piccacheid,(s[i].pic+20+s[i].frame)*2,s[i].x,s[i].y,1)
elseif s[i].action==6 then
lib.PicLoadCache(piccacheid,(s[i].pic+28)*2,s[i].x,s[i].y,1)
end
end
lib.PicLoadCache(2,230*2,0,0,1)
end
local function move(dx)
local flag=1
for id=0,100 do
s[id].action=1
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
local step=18
if dx<s[0].x then
step=-step
end
for i=s[0].x,dx,step do
for id=0,100 do
s[id].x=s[id].x+step
s[id].frame=s[id].frame+1
if s[id].frame>=2 then
s[id].frame=0
end
end
JY.ReFreshTime=lib.GetTime()
show()
if flag==1 then
PlayWavE(s[0].movewav)
flag=4
else
flag=flag-1
end
ReFresh(2)
lib.GetKey()
end
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
move(600)
JY.ReFreshTime=lib.GetTime()
ReFresh()
lib.GetKey()
WaitKey()
end

function WarFormation(kind,n)
local array={}
array.x={}
array.y={}
array.leader=1
if kind==1 then
--圆阵
--1 8 16 24 32
local T={1,8,16,24,32,40,48}
local T2={1,9,25,49,81,121,169}
local lv=1
local len=0
if n>49 then
lv=5
len=40
elseif n>25 then
lv=4
len=40
elseif n>9 then
lv=3
len=48
elseif n>1 then
lv=2
len=54
end
T[2]=math.modf(T[2]*n/T2[lv])
T[3]=math.modf(T[3]*n/T2[lv])
T[4]=math.modf(T[4]*n/T2[lv])
T[5]=math.modf(T[5]*n/T2[lv])
if lv==2 then
 T[2]=n-T[1]
elseif lv==3 then
T[3]=n-T[2]-T[1]
elseif lv==4 then
T[4]=n-T[3]-T[2]-T[1]
elseif lv==5 then
T[5]=n-T[4]-T[3]-T[2]-T[1]
end
local num=1
array.x[1]=0
array.y[1]=0
array.leader=1
num=2
for i=2,lv do
for t=1,T[i] do
array.x[num]=math.modf(len*(i-1)*math.cos(2*math.pi*t/T[i]))
array.y[num]=math.modf(len*0.6*(i-1)*math.sin(2*math.pi*t/T[i]))
num=num+1
end
end
elseif kind==2 then
--方阵
local lv=1
local len=0
array.leader=1
if n>81 then
lv=10
len=32
array.leader=5
elseif n>64 then
lv=9
len=36
array.leader=5
elseif n>49 then
lv=8
len=40
array.leader=4
elseif n>36 then
lv=7
len=44
array.leader=4
elseif n>25 then
lv=6
len=48
array.leader=3
elseif n>16 then
lv=5
len=52
array.leader=3
elseif n>9 then
lv=4
len=56
array.leader=2
elseif n>4 then
lv=3
len=60
array.leader=2
elseif n>1 then
lv=2
len=64
end
fornum=1,n do
local x=math.modf((num-1)/lv)
local y=(num-1)%lv
array.x[num]=math.modf(len*((lv-1)/2-x))
array.y[num]=math.modf(len*0.6*(y-(lv-1)/2))
end
end
--锋矢
--雁行
--锥形
--鱼丽
--长蛇
local theat=math.pi/24
for i=1,n do
array.x[i]=array.x[i]*(1+array.y[i]/100*math.tan(theat))
end
for i=1,n-1 do
for j=i+1,n do
if array.y[i]>array.y[j] or (array.y[i]==array.y[j] and array.x[i]>array.x[j]) then
array.x[i],array.x[j]=array.x[j],array.x[i]
array.y[i],array.y[j]=array.y[j],array.y[i]
if i==array.leader then
array.leader=j
elseif j==array.leader then
array.leader=i
end
end
end
end
return array
end

--原mouse.lua
MOUSE={
x=0,
y=0,
hx=0,
hy=0,
rx=0,
ry=0,
status='IDLE',
Holdtime=0;--用于计算长按
enableclick=true;
EXIT=function()
if MOUSE.status=='EXIT' then
MOUSE.status='IDLE';
return true;
end
return false;
end,
ESC=function()
if MOUSE.status=='ESC' then
MOUSE.status='IDLE';
return true;
end
return false;
end,
IN=function(x1,y1,x2,y2)
if MOUSE.status=='IDLE' or MOUSE.status=='HOLD' or MOUSE.status=='CLICK' or MOUSE.status=='ESC'then
if between(MOUSE.x,x1,x2) and
between(MOUSE.y,y1,y2) then
return true;
end
end
return false;
end,
HOLD=function(x1,y1,x2,y2,t)
t=t or 0;
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
CLICK=function(x1,y1,x2,y2)
if MOUSE.status=='CLICK' then
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
if CONFIG.Windows then
return getkey_pc();
else
return getkey_sp();
end
end

function getkey_pc()
local eventtype,keypress,x,y=lib.GetKey(1);
if eventtype==0 then
MOUSE.status='EXIT';
elseif eventtype==3 then
if keypress==1 then
MOUSE.status='HOLD';
MOUSE.x,MOUSE.y=x,y;
MOUSE.hx,MOUSE.hy=x,y;
elseif keypress==3 then
MOUSE.status='ESC';
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
end

function getkey_sp()
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
MOUSE.status='ESC';
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
