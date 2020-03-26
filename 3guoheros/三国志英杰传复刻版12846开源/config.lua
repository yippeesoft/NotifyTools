

-- 配置文件
--为了简化处理，配置文件也用lua编写
--保存C程序读取的参数和lua程序中需要经常调整的参数。lua的其他参数仍然放在jyconst.lua中

CONFIG={};
CONFIG.Debug=1;         --输出调试和错误信息，=0不输出 =1 输出信息在debug.txt和error.txt到当前目录
CONFIG.Windows=true
local file = io.open(".\\config.lua");
if (file) then
CONFIG.Windows = true
CONFIG.CurrentPath =".\\"
CONFIG.DataPath=CONFIG.CurrentPath .. "data\\";
CONFIG.Save=CONFIG.DataPath .. "save\\";
CONFIG.PicturePath=CONFIG.CurrentPath .. "pic\\";
CONFIG.SoundPath=CONFIG.CurrentPath .. "sound\\";
CONFIG.ScriptPath=CONFIG.CurrentPath .. "script\\";
CONFIG.JYMain_Lua=CONFIG.ScriptPath .. "jymain.lua";   --lua主程序名
CONFIG.FontName=".\\font\\font.ttf";
CONFIG.FontName2=".\\font\\font2.ttf";
CONFIG.MusicVolume=50;            --设置播放音乐的音量(0-128)
CONFIG.SoundVolume=50;            --设置播放音效的音量(0-128)
else
CONFIG.Windows = false
CONFIG.CurrentPath = config.GetPath();
CONFIG.DataPath=CONFIG.CurrentPath.."data/";
CONFIG.Save=CONFIG.DataPath .. "save/";
CONFIG.PicturePath=CONFIG.CurrentPath.."pic/";
CONFIG.SoundPath=CONFIG.CurrentPath.."sound/";
CONFIG.ScriptPath=CONFIG.CurrentPath.."script/";
CONFIG.JYMain_Lua=CONFIG.ScriptPath .. "jymain.lua"; --lua主程序名
CONFIG.FontName=CONFIG.CurrentPath.."font/font.ttf";
CONFIG.FontName2=CONFIG.CurrentPath.."font/font2.ttf";
CONFIG.MusicVolume=60;
CONFIG.SoundVolume=60;
end

CONFIG.Width2  = 768--992--1060;       -- 游戏图形窗口宽
CONFIG.Height2 = 480--576--595;      -- 游戏图形窗口宽
CONFIG.Width  = 768--1060;       -- 游戏图形窗口宽
CONFIG.Height = 480--595;      -- 游戏图形窗口宽

CONFIG.bpp  =16          -- 全屏时像素色深，一般为16或者32。在窗口模式时直接采用当前屏幕色深，此设置无效
                         -- 不支持8位色深。为提高速度，建议使用16位色深。
 -- 24位未经过测试，不保证正确显示
CONFIG.EnableSound=1     -- 是否打开声音    1 打开 0 关闭   关闭了在游戏中无法打开
CONFIG.MP3 = 1
CONFIG.FullScreen=1 -- 启动时是否全屏 1 全屏 0 窗口
CONFIG.KeyRepeat=0       -- 是否激活键盘重复 0 不激活，只在走路菜单时键盘重复，1激活，包括对话的所有时候键盘均重复
CONFIG.KeyRepeatDelay =300;   --第一次键盘重复等待ms数
CONFIG.KeyRePeatInterval=30;  --一秒钟重复次数

CONFIG.OSCharSet=0      -- 显示字符集 0 简体 1 繁体

     --贴图缓存数量，一般500-1000。如果在debug.txt中经常出现"pic cache is full"，可以适当增加
CONFIG.MAXCacheNum=2000;
CONFIG.CleanMemory=0;         --场景切换时是否清理lua内存。0 不清理 1 清理
CONFIG.LoadFullS=1;           --1 整个S*文件载入内存 0 只载入当前场景，由于S*有4M多，这样可以节约很多内存
CONFIG.LoadMMapType=0;        --加载主地图文件(5个002文件)的类型  0 全部载入 1 载入主角附近的行 2 载入主角附近的行和列
                              --类型2占用内存最少，但是在手机等设备上载入时间较长，在主角走动时会卡一下
  --类型1占用内存较多，载入时间比2要少，一般不会有卡的感觉

CONFIG.PreLoadPicGrp=1;       --1 预加载贴图文件*.grp, 0 不预加载。预加载可以避免走路偶尔停顿和战斗出招停顿。但占用内存

CONFIG.Operation = 1
CONFIG.Type= 1
CONFIG.XScale = 18 -- 贴图宽度的一半
CONFIG.YScale = 9 -- 贴图高度的一半
CONFIG.MidSF2 = "";
CONFIG.MMapAddX=2;
CONFIG.MMapAddY=2;
CONFIG.SMapAddX=2;
CONFIG.SMapAddY=16;
CONFIG.WMapAddX=2;
CONFIG.WMapAddY=16;

--按键的位置，-1为默认位置
CONFIG.W=CONFIG.Width
CONFIG.H=CONFIG.Height
CONFIG.Zoom = 100
CONFIG.D1X = math.modf(CONFIG.W/8.5)  --上
CONFIG.D1Y = math.modf(CONFIG.H/2.4)
CONFIG.D2X = math.modf(CONFIG.W/4.2)  --右
CONFIG.D2Y = math.modf(CONFIG.H/1.6)
CONFIG.D3X = math.modf(CONFIG.W/8.5) --下
CONFIG.D3Y = math.modf(CONFIG.H/1.2)
CONFIG.D4X = 0; --左
CONFIG.D4Y = math.modf(CONFIG.H/1.6)
CONFIG.C1X = math.modf(CONFIG.W/1.6) --S
CONFIG.C1Y = 0
CONFIG.C2X = math.modf(CONFIG.W/1.16) --H
CONFIG.C2Y = 0
CONFIG.AX = math.modf(CONFIG.W/1.82) --esc
CONFIG.AY = math.modf(CONFIG.H/1.2)
CONFIG.BX = math.modf(CONFIG.W/1.28) --空格
CONFIG.BY = math.modf(CONFIG.H/1.16)