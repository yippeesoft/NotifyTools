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
talk(4,"陛下，不要担心，把所有朝政都交给臣．",
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
talk(9,"袁绍，袁术，谢谢二位将军响应檄文．",
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
talk(9,"噢，陶谦，孔融，欢迎你们．",
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
talk(9,"公孙瓒也来了，远道而来，辛苦了．",
 13,"哪里哪里，我要给你介绍一个人．",
 9,"噢，是谁呀？",
 13,"是刘备，请进来．"
 );
 AddPerson(1,6,21,0);
 MovePerson( 1,8,0);
talk(1,"我是刘备，字玄德，听说要讨伐董卓，便和公孙瓒一起赶到这里．");
 DrawMulitStrBox("　现在出现的这个人物，是这个故事的主角，姓刘名备字玄德，他编卖过草蓆，是个在穷苦环境中长大的年轻人，可是，自从母亲告诉他祖先是皇帝后，刘备的人生发生了变化．");
 DrawMulitStrBox("　发生黄巾之乱时，刘备欲拯救乱世，率义勇军讨伐黄巾贼．*　刘备有两个兄弟，一个是关羽字云长，一个是张飞字翼德，两人都是出类拔萃的豪杰．");
 DrawMulitStrBox("　刘备，关羽，张飞，此三人虽是偶然相遇，但相互被对方的志向所感动，结拜为兄弟，虽然彼此不是亲兄弟．但关羽，张飞都称刘备为大哥．");
talk(9,"噢，是刘备吗？我们以前见过．",
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
talk(4,"华雄，把守汜水关的任务交给你了．",
 6,"是．");
 MovePerson( 6,9,1);
 DecPerson(6);
 MovePerson( 5,0,3);
talk(5,"父亲，为何只命令华雄出征，难道忘了吕布？");
 MovePerson( 4,0,2);
talk(4,"哪里？吕布，我最信任的人就是你，你去守虎牢关．",
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
talk(6,"哼！谁说我就比不过吕布？最厉害的是我！",
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
talk(369,"禀告主帅，华雄率领的董卓军攻过来了．",
 10,"知道了，我马上派援军．退下．",
 369,"是．"
 );
 MovePerson( 369,10,1);
 DecPerson(369);
talk(10,"话是这么说，可是派谁去好呢？",
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
talk(1,"我们兄弟愿往．",
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
talk(10,"华雄乃勇猛之人，要小心．");
 end
 if JY.Tid==9 then--曹操
talk(9,"希望你们勇猛作战．");
 end
 if JY.Tid==12 then--袁术
talk(12,"哼，小兵如何拼命也注定要失败，想不去还来得及．");
 end
 if JY.Tid==8 then--孔融
talk(8,"你们是步兵，华雄是骑兵，彼此的兵种不同，所以交战时要注意这个区别，否则你们要吃亏．");
 end
 if JY.Tid==13 then--公孙瓒
talk(13,"我也参加这次作战，也许能帮上忙．");
 SetFlag(0,1);
 end
 if JY.Tid==16 then--陶谦
talk(16,"我的部队也参加，一起讨伐敌军．");
 SetFlag(1,1);
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，快出征吧，准备好的话，跟关羽说一声．");
 end
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"准备好了吗？") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 PlayBGM(12);
talk(2,"出征！");
 NextEvent();
 JY.Tid=-1;
 end
 end 
 end,
 [9]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(2,"敌人在汜水关，火速进军．");
 NextEvent(); 
 end,
 [10]=function() --test进入战斗
 WarIni();
 DefineWarMap(0,"序章 汜水关之战","一、歼灭华雄．",30,0,5);
 -- id,x,y,d,ai
 SelectTerm(1,{
 0,22,9,3,0,-1,0,
 1,20,10,3,0,-1,0,
 2,20,9,3,0,-1,0,
 12,16,7,3,0,0,0,
 15,16,6,3,0,1,0,
 });
 SelectEnemy({
 5,3,9,4,2,5,7,0,0,-1,0,
 20,5,10,4,0,2,4,0,0,-1,0,
 21,4,9,4,0,2,1,0,0,-1,0,
 27,6,9,4,0,2,1,0,0,-1,0,
 256,11,8,4,0,1,1,0,0,-1,0,
 257,11,10,4,0,1,1,0,0,-1,0,
 258,11,12,4,0,1,1,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [11]=function() --test战斗事件
 PlayBGM(11);
talk(6,"吃一次亏也不长一智，联军还来自找麻烦，是谁的部队？",
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
talk(2,"对面的可是华雄，我要与你单挑！",
 6,"向我挑战？好大的胆，通名受死．",
 2,"我乃关羽关云长，华雄，我关羽决不容你们这些董卓军胡作非为．",
 6,"哼，还逞威风，不过一看就是无名小卒．还能胜我吗？",
 2,"敢把我看成无名小卒，送你上西天．");
 if fight(2,6)==1 then
talk(2,"接我一刀！");
 WarAction(8,2,6);
 WarAction(19,6,2);
talk( 6,"好厉害！",
 2,"华雄！要你的命！");
 WarAction(8,2,6);
 WarAction(18,6);
talk(2,"先割下华雄首级．");
 WarLvUp(GetWarID(2));
talk(3,"大哥，关羽好像斩了华雄．",
 1,"嗯，我军胜利了．");
 PlayBGM(7);
 DrawMulitStrBox("　刘备军打败华雄军，占领汜水关．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 else
talk(6,"接我一刀！");
 WarAction(4,6,2);
 WarAction(19,2,6);
talk(2,"好厉害！",
 6,"关羽！要你的命！");
 WarAction(4,6,2);
 WarAction(18,2);
talk(6,"先割下关羽首级．");
 WarLvUp(GetWarID(6));
 DrawMulitStrBox("　刘备军败给了华雄军．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(999);
 end
 end
 if JY.Status==GAME_WARWIN then
talk(1,"我军胜利了．");
 PlayBGM(7);
 DrawMulitStrBox("　刘备军打败华雄军，占领汜水关．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [13]=function()
 SetSceneID(0,3);
talk(2,"敌人好像逃到了前面的虎牢关．大哥，该怎么办？",
 1,"暂且收兵吧．",
 3,"说什么呀？现在当然是乘胜追击了，我去！",
 2,"喂！张飞！不要轻举妄动！",
 3,"追击！继续追击！"
 );
talk(2,"唉！追上去了，还是那么鲁莽．");
 if GetFlag(0) then
talk(13,"话不要这么说，我军士气也鼓舞起来了嘛．");
 end
 if GetFlag(1) then
talk(16,"现在应该乘势攻下虎牢关．");
 end
talk(1,"没办法，好！跟上张飞！进军虎牢关！");
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
 -- id,x,y,d,ai
 SelectTerm(1,{
 0,15,21,2,0,-1,0,
 1,13,21,2,0,-1,0,
 2,12,20,2,0,-1,0,
 12,14,18,2,0,0,0,
 15,13,18,2,0,1,0,
 });
 SelectEnemy({
 4,6,5,1,2,6,7,0,0,-1,0,
 79,3,7,1,0,3,23,0,0,-1,0,
 80,6,8,1,0,3,7,0,0,-1,0,
 74,10,8,1,0,3,4,0,0,-1,0,
 73,10,11,1,1,2,1,0,0,-1,0,
 274,8,8,1,0,1,4,0,0,-1,0,
 275,5,11,1,1,1,4,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [16]=function()
 PlayBGM(11);
talk(5,"什么？联军攻来了，还杀了华雄？好厉害，不过，他们的好运也就到此为止了．",
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
talk(3,"对面可是吕布，来与我一决胜负！",
 5,"还有人敢向我挑战！报上名来！",
 3,"我乃刘备义弟，张飞张翼德是也！吕布！我要取你项上人头！",
 5,"哈哈！无名小卒，好大胆，我吕布来战一战你．来吧！",
 3,"别小看我，你会后悔的．");
 if fight(3,5)==1 then
talk(5,"还真有两下子．",
 3,"不愧勇夫，不过，躲得过我这一矛吗？");
 WarAction(9,3,5);
talk(5,"休得猖狂！");

talk(1,"张飞，我们来帮你．",
 2,"吕布，你的克星来了．",
 5,"帮手来了，没办法，撤退．赤兔，全靠你了．");
 WarMoveTo(5,6,0);
talk(3,"别跑！吕布！站住！",
 2,"不愧是赤兔马，我们根本追不上．");
talk(5,"全军撤退．");
 WarAction(16,5);
 WarLvUp(GetWarID(3));
 NextEvent();
 else
talk(5,"还真有两下子，不过，躲得过我这一戟吗？");
 WarAction(8,5,3);
WarAction(19,3,5);
 --WarAction(17,3);
 --WarLvUp(GetWarID(5));
 --talk( 1,"三弟！",
 -- 2,"可恶！",
 -- 5,"哈哈哈！一起上吧！");
talk(3,"休得猖狂！");
talk(1,"张飞，我们来帮你．",
 2,"吕布，你的克星来了．",
 5,"帮手来了，没办法，撤退．赤兔，全靠你了．");
 WarMoveTo(5,6,0);
talk(3,"别跑！吕布！站住！",
 2,"不愧是赤兔马，我们根本追不上．");
talk(5,"全军撤退．");
 WarAction(16,5);
 --WarLvUp(GetWarID(3));
 NextEvent();
 end
 
 end
 if (not GetFlag(1001)) and War.Turn==18 then
talk(5,"哼！七拼八凑的部队还挺厉害，不过我可不会败给这些鼠辈，要让他们知道我的厉害．");
 WarModifyAI(4,1);
 SetFlag(1001,1);
 end
 if JY.Status==GAME_WARWIN then
talk(5,"可恶！没办法，全军撤退．",
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
talk(4,"要杀陛下的人已逼近洛阳，事已至此，离开洛阳吧．",
 383,"什么？洛阳是以前就作为帝都才得以繁荣的．你是说要舍弃它？",
 4,"你好像没听懂我刚才说的话吧，我还要重复一遍吗？",
 383,"这，朕知道了，就照你说的办吧！",
 4,"谢谢皇帝采纳臣的建议，那么就请快些走吧！");
 MovePerson( 4,2,1);
 MovePerson( 4,7,1,
 7,7,1);
talk(4,"对啦，李儒，不能轻易把洛阳留给贼军，火烧洛阳，没收城里全部金银财宝．",
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
talk(383,"先帝呀！宽恕我的无能吧！我没能守住先祖传下来的这块土地，难道汉室基业要毁在我手里？",
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
talk(9,"据说董卓逃往洛阳西面的长安，现在就应追击．",
 10,"不，接连作战，士兵太累了，现在应该在这里休息．",
 9,"可是要抓住战机，错失此良机，我们就没有胜利机会．");
talk(12,"既然想要追击，随你去好了．",
 13,"士兵也的确太累了．",
 9,"我等为讨伐国贼才起兵的，可是，现在连追击董卓都不肯，要让天下百姓失望的．",
 9,"这里已没有与我同心之人，我要回领地去，告辞了．");
 MovePerson( 9,11,1);
 DecPerson(9);
 NextEvent();
 end,
 [21]=function()
talk(12,"说什么与你同心，他又不是名门望族，太嚣张了．",
 10,"可是没有曹操这个中心人物，这个联军就没有意义了．");
talk(8,"刘备，有机会我们还会再见的．");
 MovePerson( 8,9,1);
 DecPerson(8);
talk(16,"刘备将来会成就大事的，哈哈哈！我这老头开玩笑，请别介意．那我告辞了．");
 MovePerson( 16,9,1);
 DecPerson(16);
talk(13,"那么我们也撤吧．",
 2,"是啊．");
 NextEvent();
 end,
 [22]=function()
 JY.Smap={};
 SetSceneID(0);
talk(13,"那么，刘备，再见了，如果有什么事情，随时可以跟我讲．",
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
talk(10,"好，打垮公孙瓒！拿下北平的话，北面的半壁江山就成了我的了．分兵两路进攻北平，张郃经巨鹿进攻，麴义经清河进攻．",
 103,"是！我马上进攻巨鹿！",
 61,"那么我发兵清河．");
 Dark();
 PlayBGM(3);
 DrawSMap();
 Light();
talk(13,"袁绍攻过来了！",
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
talk(2,"兄长，公孙瓒军和袁绍军已经对峙了很长时间了．",
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
talk(3,"有什么事的话会去叫你．");
 end
 if JY.Tid==2 then--关羽
talk(2,"城里有酒馆等居民聚集的地方，想从居民那里得到情报，还是去人多的地方好．");
 --
talk(2,"兄长，来了个叫简雍的人，说是来见兄长．");
 AddPerson(83,2,4,0);
 MovePerson( 83,8,3);
 NextEvent();
 JY.Tid=-1;
 end
 end,
 [26]=function()
 if JY.Tid==2 then--关羽
talk(2,"请兄长讲话．");
 end
 if JY.Tid==3 then--张飞
talk(3,"我不太清楚，大哥想个办法吧．");
 end
 if JY.Tid==83 then--简雍
talk(83,"刘备，我叫简雍．久仰您的大名，此次特地前来投靠，请您收下我．");
 ModifyForce(83,1);
 PlayWavE(11);
 DrawStrBoxCenter("简雍成为刘备部下！");
 AddPerson(365,-1,4,0);
 MovePerson( 365,6,3);
 PlayBGM(11);
talk(365,"刘备，突然拜访．我是公孙瓒派来的使者，请求您派兵支援．");
 NextEvent();
 JY.Tid=-1;
 end
 end,
 [27]=function()
 if JY.Tid==2 then--关羽
talk(2,"请听使者讲话．");
 end
 if JY.Tid==3 then--张飞
talk(3,"请听使者讲话．");
 end
 if JY.Tid==83 then--简雍
talk(83,"公孙瓒出了什么事了吗？");
 end
 if JY.Tid==365 then--使者
talk(1,"使者啊！听说袁绍军从界桥正不断向东进军……",
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
talk(2,"那么出发吧．");
 PlayBGM(12);
 NextEvent();
 JY.Status=GAME_SMAP_AUTO;
 end
 end
 if JY.Tid==3 then--张飞
talk(3,"快出发吧．");
 end
 if JY.Tid==83 then--简雍
talk(83,"从这里去界桥，要路过广川或信都城中的一个．");
 end
 if JY.Tid==365 then--使者
talk(365,"刘备，请你尽快去支援吧．");
 end;
 end,
 [29]=function()
 JY.Smap={};
 SetSceneID(0);
talk(2,"兄长，你要走广川这条路，还是走信都城这条路？");
 NextEvent();
 end,
 [30]=function()
 local menu={
 {" 走信都城",nil,1},
 {"　走广川",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
 NextEvent(); --goto 31
 elseif r==2 then
 NextEvent(40); --goto 40
 end
 end,
 [31]=function()
talk(2,"走信都城吧，列队！");
 WarIni();
 DefineWarMap(3,"第一章 信都城之战","一、淳于琼败退．*二、刘备到达城门．",30,0,105);
 SelectTerm(1,{
 0,21,7,3,0,-1,0,
 -1,20,6,3,0,-1,0,
 -1,20,8,3,0,-1,0,
 -1,21,5,3,0,-1,0,
 220,1,0,1,0,-1,0,
 245,3,0,3,0,-1,0,
 244,0,0,4,0,-1,0,
 });
 SetSceneID(0,11);
talk(10,"淳于琼，你去信都城，搅乱公孙瓒的背后．",
 106,"是．",
 106,"将士们！我们绕到公孙瓒的背后去攻打信都城！跟上！");
 SetSceneID(0);
talk(13,"什么！袁绍军要袭击我们的背后？坏了！如果这样的话，我们就进攻袁绍的大本营！进攻界桥！");
 SetSceneID(0,3);
talk(2,"向信都城进军吧！");
 NextEvent();
 end,
 [32]=function()
 SelectEnemy({
 105,1,4,2,4,8,7,7,3,-1,0,
 256,8,3,3,4,4,1,9,4,-1,0,
 257,4,6,2,4,4,1,9,9,-1,0,
 258,7,1,3,0,4,1,0,0,-1,0,
 292,7,4,3,1,1,7,0,0,-1,0,
 293,5,4,3,4,1,7,8,3,-1,0,
 274,0,4,2,4,3,4,2,4,-1,0,
 310,4,7,2,4,2,10,9,9,-1,0,
 311,6,3,3,1,2,10,0,0,-1,0,
 328,3,3,3,4,3,13,8,2,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [33]=function()
 PlayBGM(11);
 DrawStrBoxCenter("信都城");
talk(221,"就要守不住了……袁绍军怎么会在这儿出现．",
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
talk(3,"哪个是主将？喂，我是张飞，哪个与我单挑较量！",
 106,"好，正中下怀．");
 if fight(3,106)==1 then
 WarAction(4,3,106);
 WarAction(19,106,3);
talk(106,"这……！这么厉害……",
 3,"就这点儿能耐，赢不了我！");
talk(106,"打不过他．妈的，没办法，走为上．");
 WarAction(16,106);
 WarLvUp(GetWarID(3));
 NextEvent();
 else
talk(106,"张飞！杀！");
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
talk(106,"他妈的，再加把劲就能攻下来，可是只好全军撤退！");
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
talk(106,"他妈的，再加把劲就能攻下来，可是只好全军撤退！");
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
talk(2,"兄长，袁绍军好像退兵了．",
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
talk(221,"刘备，您救了信都，太谢谢你了．",
 1,"不用谢．还好，我们正好经过信都．",
 221,"……",
 1,"我们这是去支援公孙瓒，刚才要从信都过去，发现你这里受到攻击．",
 221,"哦，……刘备，请让我也加入援军以报答您救信都之恩．");
 ModifyForce(221,1);
 PlayWavE(11);
 DrawStrBoxCenter("藩宫加入了刘备军！");
talk(2,"那么，兄长，我们快去支援吧．准备好的话请说一声．");
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
talk(3,"大哥，再不出发也许就来不及了．");
 end
 if JY.Tid==83 then--简雍
talk(83,"主公，出发前要不要去打制兵器的道具屋看一看？");
 end
 if JY.Tid==221 then--藩宫
talk(221,"我也参加你们的援军．");
 end;
 end,
 [39]=function()
 JY.Smap={};
 SetSceneID(0,12);
talk(2,"兄长，快去支援吧．",
 1,"简雍，这里到界桥很近了吧？",
 83,"还不近．这里到界桥有两条路，一条经过清河，另一条经过巨鹿．",
 1,"清河和巨鹿啊．走哪条路都通过界桥吗？",
 83,"是的．",
 2,"可是，袁绍军既然派兵到了这里，那里也会有敌人吧．",
 3,"有就有吧．我来解决他们．大哥，清河和巨鹿，你选择哪条路？快决定吧．");
 NextEvent(49); --goto 49
 end,
 [40]=function()
talk(2,"那么走广川吧，列队．");
 WarIni();
 DefineWarMap(2,"第一章 广川之战","一、逢纪的溃败．",30,0,54);
 SelectTerm(1,{
 0,18,0,3,0,-1,0,
 -1,17,0,3,0,-1,0,
 -1,19,0,3,0,-1,0,
 -1,19,1,3,0,-1,0,
 });
 SetSceneID(0,11);
talk(10,"逢纪，你去广川．扰乱公孙瓒的背后．",
 55,"是．",
 55,"将士们，我们绕道公孙瓒背后去，进军广川！");
 SetSceneID(0);
talk(13,"什么！袁绍军要袭击我们的背后？坏了！如果这样的话，我们就进攻袁绍的大本营！进攻界桥！");
 SetSceneID(0,3);
talk(2,"向广川进军吧！");
 NextEvent();
 end,
 [41]=function()
 SelectEnemy({
 54,0,2,4,0,6,1,0,0,-1,0,
 256,4,6,4,4,4,1,7,6,-1,0,
 257,7,7,4,1,4,1,0,0,-1,0,
 274,1,3,4,0,3,4,0,0,-1,0,
 292,9,8,4,1,1,7,0,0,-1,0,
 293,10,8,4,1,1,7,0,0,-1,0,
 310,1,4,4,0,3,10,0,0,-1,0,
 311,6,5,4,1,2,10,0,0,-1,0,
 312,4,4,4,1,2,10,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [42]=function()
 PlayBGM(11);
 DrawStrBoxCenter("广川战场");
talk(2,"那是？兄长，像是袁绍军．",
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
talk(2,"对面的主将听着，关羽要与你们决一胜负！",
 55,"好，放马过来！");
 WarAction(6,2,55);
talk(55,"你叫什么名字？",
 2,"我叫关羽关云长．",
 55,"关羽……？什么！是关羽？是那个大名远扬的关羽？",
 2,"噢，知道我的名字啊，那么某种程度上也知道我的厉害吧．",
 55,"放屁！杀啊！");
 if fight(2,55)==1 then
talk(55,"不愧是击败吕布军的英雄……实在打不过．",
 2,"看刀！");
 WarAction(4,2,55);
talk(55,"噢！再也坚持不了啦，既然是关羽，我还是快逃吧．");
 WarLvUp(GetWarID(2));
talk(55,"这广川也只好放弃了．全军撤退！");
 WarAction(16,55);
 NextEvent();
 else
talk(55,"击败吕布军的英雄，也不过如此．",
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
talk(55,"唉，刘备军相当厉害！广川也只好放弃了，全军撤退！");
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
talk(2,"兄长，袁绍军好像败退了．",
 1,"唉，可是袁绍军都来到这里了，我看好像不妙啊．",
 83,"像是不妙，嗯？主公，好像有人来．");
 AddPerson(245,30,6,0);
 AddPerson(246,32,7,0);
 MovePerson( 245,7,1,
 246,7,1);
talk(245,"刘备，请原谅冒昧来访．我们是信都城的武将，我叫韩英．",
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
talk(83,"阵容也强大了，快去救援吧．",
 1,"简雍，这里离界桥很近了吧？",
 83,"还不近，从这里去界桥有两条路，一条经过清河，另一条经过巨鹿．",
 1,"清河和巨鹿，走哪条路都通往界桥吗？",
 83,"是的．",
 2,"可是，袁绍军既然已来到了这里，那里也会有敌人吧．",
 3,"有就有吧，我来解决他们．",
 2,"快准备出征吧．我叫来了刀匠，你们选用吧．");
talk(375,"谢谢关照，需要什么刀枪，请说吧．");
 --48 显示任务目标:<去支援公孙瓒>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [47]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，快走吧，我已经憋不住了．");
 end
 if JY.Tid==83 then--简雍
talk(83,"出征前有两件事要准备，一是买些武器，二是做好记录．");
 end
 if JY.Tid==245 then--韩英
talk(245,"我要努力杀敌，下命令吧．");
 end;
 if JY.Tid==246 then--郭适
talk(246,"我要努力杀敌，下命令吧．");
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
talk(2,"出发吧！");
 JY.Smap={};
 SetSceneID(0,12);
talk(2,"大哥，清河和巨鹿去哪里？快决定．");
 NextEvent(); --goto 49
 end,
 [49]=function()
 local menu={
 {" 通过巨鹿",nil,1},
 {" 通过清河",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
 NextEvent(56); --goto 56
 elseif r==2 then
 NextEvent(); --goto 50
 end
 end,
 [50]=function()
talk(2,"明白了，那么去清河吧．");
 PlayBGM(3);
 NextEvent();
 end,
 [51]=function()
 SetSceneID(0);
talk(2,"好像是敌人，列队．");
 WarIni();
 DefineWarMap(5,"第一章 清河之战","一、歼灭麴义．",30,0,60);
 SelectTerm(1,{
 0,24,11,3,0,-1,0,
 -1,23,11,3,0,-1,0,
 -1,22,10,3,0,-1,0,
 -1,22,12,3,0,-1,0,
 -1,23,12,3,0,-1,0,
 59,3,10,3,0,-1,0,
 });
 SelectEnemy({
 60,2,10,4,2,9,7,0,0,-1,0,
 256,4,9,4,0,5,1,0,0,-1,0,
 257,10,7,4,4,5,1,12,7,-1,0,
 258,9,9,4,4,4,1,12,8,-1,0,
 328,8,8,4,4,4,13,11,8,-1,0,
 292,3,8,4,0,2,7,0,0,-1,0,
 274,2,9,4,0,4,4,0,0,-1,0,
 275,10,10,4,4,4,4,11,9,-1,0,
 310,14,0,4,1,3,10,0,0,-1,1,
 311,13,1,4,1,3,10,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [52]=function()
talk(60,"麴义！我严纲要和你单挑较量！",
 61,"有胆量，但你要倒霉啦！你还觉得能打赢我麴义？杀啊！");
 if fight(61,60)==1 then
talk(61,"严纲，看刀！");
 WarAction(8,61,60);
talk(60,"哎呀！");
 WarAction(18,60);
talk(61,"公孙瓒的大将严纲被斩了！",
 2,"大哥，好像晚了一步，严纲被斩，清河北平军溃败了．",
 1,"晚了一步啊，好！血债要用血来还！",
 61,"嗯？那不是刘备军吗？噢，想去支援公孙瓒．我麴义不让你们去！");
 else
talk(60,"麴义，看刀！");
 WarAction(5,60,61);
talk(61,"哼！");
 WarAction(6,60,61);
 WarAction(6,60,61);
 WarAction(10,60,61);
talk(60,"可恶啊！",
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
talk(2,"这里的大将听着！我要和你单挑较量！",
 61,"什么？竟还有人敢向我挑战！好吧，就与你斗一斗！");
 WarAction(6,2,61);
 if fight(2,61)==1 then
talk(61,"好家伙！好厉害……",
 2,"强中自有强中手，算你倒霉，砍下你的首级．");
 WarAction(8,2,61);
 WarAction(18,61);
talk(2,"我的武艺也不够娴熟，这么个小对手竟感到有点难对付……");
 WarLvUp(GetWarID(2));
 PlayBGM(7);
 DrawMulitStrBox("　关羽杀了麴义，*　刘备军突破了清河．");
 NextEvent();
 else
talk(61,"让你也和刚才的严纲落个同样下场！");
 WarAction(4,61,2);
talk(2,"我的武艺也不够娴熟，这么个小对手竟感到有点难对付……");
 WarAction(17,2);
 WarLvUp(GetWarID(61));
 end
 end
 if (not GetFlag(1004)) and War.Turn==7 then
talk(1,"嗯！那是！？");
 WarShowArmy(310);
 WarShowArmy(311);
 DrawStrBoxCenter("出现了敌人援军！");
 SetFlag(1004,1);
 end
 if JY.Status==GAME_WARWIN then
talk(61,"喂，刘备！休想从这里过去．");
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
talk(103,"什么！清河的麴义被公孙瓒军突破了，没办法．撤回主公坐镇的界桥！",
 26,"妈的，我的兵力再强大一点，就能捉住张颌．");
 SetSceneID(0);
talk(2,"前面就是袁绍主力所在的界桥！",
 3,"大哥快去界桥吧！");
 --48 显示任务目标:<去界桥支援公孙瓒>
 --61 储存进度:战场存盘
 --15 读入段指令:读入第<15>段指令
 NextEvent(61); --goto 61
 end,
 [56]=function()
talk(2,"明白了，那么去巨鹿吧．");
 PlayBGM(3);
 SetFlag(133,1);
 NextEvent();
 end,
 [57]=function()
 SetSceneID(0);
talk(2,"好像是敌人，列队．");
 WarIni();
 DefineWarMap(4,"第一章 巨鹿之战","一﹑张颌败退．*二﹑刘备到达西面鹿砦．",30,0,102);
 SelectTerm(1,{
 0,2,2,4,0,-1,0,
 -1,4,3,4,0,-1,0,
 -1,3,1,4,0,-1,0,
 -1,1,2,4,0,-1,0,
 -1,3,3,4,0,-1,0,
 25,10,4,4,0,-1,0,
 221,9,5,4,0,-1,0,
 58,17,13,3,0,-1,1,
 57,17,12,3,0,-1,1,
 });
 SelectEnemy({
 102,5,17,4,0,10,22,0,0,-1,0,
 51,6,15,4,0,7,7,0,0,-1,0,
 103,4,14,4,0,7,4,0,0,-1,0,
 91,12,6,3,1,6,1,0,0,-1,0,
 54,11,14,4,1,7,1,0,0,-1,0,
 256,10,6,3,1,5,1,0,0,-1,0,
 257,7,16,4,0,5,1,0,0,-1,0,
 274,9,17,4,0,4,4,0,0,-1,0,
 292,10,14,4,1,3,7,0,0,-1,0,
 336,13,5,3,1,4,15,0,0,-1,0,
 348,4,16,4,0,4,19,0,0,-1,0,
 310,2,0,4,1,3,10,0,0,-1,1,
 311,1,1,4,1,3,10,0,0,-1,1,
 312,0,2,4,1,3,10,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [58]=function()
 PlayBGM(11);
talk(52,"张颌，快些收拾掉北平军，赶快和界桥的主力会合吧．",
 103,"唉，可是我听说公孙瓒的盟友刘备军打败了我军的一支劲旅，正向巨鹿赶来，一定得设法不让公孙瓒和刘备汇合．");
talk(1,"公孙越，平原刘备前来助战．",
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
talk(3,"噢，看样子是个很厉害的对手嘛．我去对付他．",
 52,"你是何人？朝这边来是要和我交战吗？好哇，杀！");
 WarAction(6,3,52);
 if fight(3,52)==1 then
talk(3,"好像还有两下子，碰上我算你倒霉．",
 52,"让你嚐嚐这一刀．");
 WarAction(9,52,3);
talk(3,"你玩的什么武艺？这样还能赢我？",
 52,"唉，连我这一刀也躲过去了，好厉害的家伙．",
 3,"你就这点本事啊．");
 WarAction(8,3,52);
talk(52,"噢噢！打不过他，逃吧！");
 WarAction(16,52);
 WarLvUp(GetWarID(3));
 else
talk(3,"好像还有两下子，碰上我算你倒霉．",
 52,"让你嚐嚐这一刀．");
 WarAction(8,52,3);
 WarAction(17,3);
 WarLvUp(GetWarID(52));
 end
 end
 if (not GetFlag(1005)) and War.Turn==3 then
talk(1,"唉！那是！？");
 WarShowArmy(310);
 WarShowArmy(311);
 WarShowArmy(312);
 DrawStrBoxCenter("敌人的援军来了！");
talk(1,"什么？从前面也来了吗！？");
 WarShowArmy(57);
 WarShowArmy(58);
 PlayBGM(12);
talk(59,"我是关纯，原是韩馥的部下．此番前来加入刘备军．",
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
talk(103,"妈的！败给了刘备！撤退！",
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
talk(103,"不能让刘备突破巨鹿，全军阻挡刘备！",
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
talk(103,"妈的！不能让刘备过去！",
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
talk(61,"什么？巨鹿的张颌被公孙瓒军突破了？没办法，只好返回主公坐镇的界桥．",
 60,"妈的，要是我武力再强点的话，就能捉住麴义了．");
 PlayBGM(3);
talk(59,"刘备，我原是韩馥的下属，叫关纯．",
 58,"我叫耿武．",
 1,"唉．",
 59,"我们的主公韩馥，被袁绍夺去了冀州，现在乡下默默的生活．我们还没向袁绍报仇雪恨，刘备，请带我们一起走．",
 1,"明白了，那就跟我走吧．",
 58,"是，谢谢刘备．");
 ModifyForce(59,1);
 ModifyForce(58,1);
 PlayWavE(11);
 DrawStrBoxCenter("关纯、耿武成为刘备下属！");
talk(2,"前面就是袁绍主力所在的界桥！",
 3,"大哥，快去界桥吧．");
 --48 显示任务目标:<去界桥支援公孙瓒>
 NextEvent(); --goto 61
 end,
 [61]=function()
talk(2,"大哥，到界桥了，请列队．");
 LvUp(13,4);
 WarIni();
 DefineWarMap(6,"第一章 界桥之战","一、袁绍撤退．*二、刘备夺取兵粮库．",40,0,9);
 SelectTerm(1,{
 0,0,14,4,0,-1,0,
 -1,2,14,4,0,-1,0,
 -1,3,13,4,0,-1,0,
 -1,1,13,4,0,-1,0,
 -1,1,15,4,0,-1,0,
 12,3,15,4,0,-1,0,
 222,6,14,4,0,-1,0,
 227,4,15,4,0,-1,0,
 53,0,17,4,0,-1,1,
 });
 if GetFlag(133) then
 SelectEnemy({
 9,25,15,3,0,13,1,0,0,-1,0,
 49,26,16,3,0,8,4,0,0,-1,0,
 52,4,16,3,0,10,7,0,0,-1,0,
 98,15,23,3,0,8,19,0,0,-1,0,
 50,7,20,3,0,8,4,0,0,-1,0,
 138,14,22,3,0,7,4,0,0,-1,0,
 60,25,19,3,0,10,7,0,0,-1,0,
 139,9,18,3,0,7,4,0,0,-1,0,
 56,24,16,3,0,7,1,0,0,-1,0,
 55,25,16,3,0,7,13,0,0,-1,0,
 92,27,3,3,0,7,1,0,0,-1,0,
 256,29,6,3,0,5,1,0,0,-1,0,
 257,28,6,3,0,5,1,0,0,-1,0,
 292,15,21,3,0,3,7,0,0,-1,0,
 293,23,19,3,0,3,7,0,0,-1,0,
 310,8,19,3,1,6,10,0,0,-1,0,
 328,10,17,3,1,5,13,0,0,-1,0,
 });
 else
 SelectEnemy({
 9,25,15,3,0,13,1,0,0,-1,0,
 49,26,16,3,0,8,4,0,0,-1,0,
 52,4,16,3,0,10,7,0,0,-1,0,
 98,15,23,3,0,8,19,0,0,-1,0,
 50,7,17,3,0,8,4,0,0,-1,0,
 138,25,16,3,0,7,4,0,0,-1,0,
 102,23,19,3,0,10,22,0,0,-1,0,
 51,25,19,3,0,10,7,0,0,-1,0,
 92,27,3,3,0,7,1,0,0,-1,0,
 91,24,16,3,0,7,1,0,0,-1,0,
 54,6,18,3,0,8,1,0,0,-1,0,
 103,9,18,3,1,7,4,0,0,-1,0,
 256,28,6,3,0,5,1,0,0,-1,0,
 257,29,6,3,0,5,1,0,0,-1,0,
 292,15,21,3,0,3,7,0,0,-1,0,
 293,5,19,3,0,3,7,0,0,-1,0,
 274,8,19,3,1,3,4,0,0,-1,0,
 328,7,20,3,1,5,13,0,0,-1,0,
 329,16,22,3,0,5,13,0,0,-1,0,
 });
 end
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [62]=function()
 PlayBGM(11);
talk(10,"敌军已经不堪一击．文丑！去取公孙瓒的首级！",
 53,"我乃文丑，公孙瓒，明年的今天就是你的忌日．",
 13,"怎么搞的！援军还没有到啊．",
 228,"主公，这交给我吧．文丑来受死吧！",
 53,"嘘，无名小卒，快滚回去吧．");
 WarAction(1,53,228);
 fight(53,228);
talk(53,"杀……");
 WarAction(4,53,228);
talk(228,"啊……");
 --WarAction(19,228);
talk(228,"太、太厉害了．",
 53,"哈哈哈，怎么样！凭你这点儿本事想赢我！");
 WarAction(17,228);
talk(53,"公孙瓒，哪里走！纳命来！",
 13,"看来我命到此休矣！");
 WarShowArmy(53);
 PlayBGM(12);
talk(54,"等一下，这次我来战你．",
 53,"你是何人？");
 WarMoveTo(54,3,16);
 WarAction(1,54,53);
 WarAction(5,54,53);
talk(53,"不知死活的家伙，和公孙瓒一起作我枪下之鬼吧．");
 if fight(54,53)==1 then
talk(54,"呸！！");
 WarAction(4,54,53);
talk(53,"哦！杀啊！妈的，好厉害，先撤吧．");
 WarAction(19,53);
 WarMoveTo(53,15,22);
 WarAction(0,53,3);
 WarLvUp(GetWarID(54));
 else
 WarAction(6,54,53);
talk(53,"哈哈哈，今天先放公孙瓒你一马．");
 WarMoveTo(53,15,22);
 WarAction(0,53,3);
 end
talk(13,"哦，刚才差一点没了命，真是太感谢你了，让我说声谢谢吧，请问大名．",
 54,"我叫赵云．",
 54,"以前跟随袁绍，我看透了他既不忠君也不爱惜百姓，就要离开他，返回故乡．",
 13,"袁绍干了件蠢事啊，怎么样，你能不能帮助我．");
talk(54,"好！",
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
talk(53,"刚才因大意受挫，这次不会了，要让你们看看我的厉害．",
 3,"喂，还有没有稍微有点骨气的？唉，我跟你玩玩吧．");
 WarAction(6,3,53);
 if fight(3,53)==1 then
talk(3,"怎么如此不中用啊．没意思．",
 53,"不，不应该这么不争气．",
 3,"你回去好啦，懒得和你交手．",
 53,"你这个家伙！不要侮辱人！");
 WarAction(9,53,3);
talk(53,"哈哈，怎、怎么样……",
 3,"……你惹恼了我，别走！");
 WarAction(8,3,53);
talk(53,"噢噢！刚才败了，这次也败了．");
 WarAction(16,53);
 WarLvUp(GetWarID(3));
 else
talk(53,"哈哈，怎、怎么样……");
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
talk(50,"主公，敌人那点儿兵力还真顽强啊，好像接近了我们．",
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
talk(93,"主公，刘备想要夺取粮仓向我们营地出发了．",
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
talk(1,"好！我们夺取了袁绍的粮仓．",
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
talk(10,"唉，刘备这个混帐，你再晚来一步我就可以杀死公孙瓒了……妈的，我不会善罢干休！公孙瓒啊，败军之恨，总有一天要报的．全军撤退！");
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
talk(10,"公孙瓒，我不会认输的！");
 SetSceneID(0);
talk(13,"刘备，你来的正好，这次多亏你来帮我们．",
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
talk(367,"主公，大事不好！",
 9,"吵闹什么？还会有比董卓死了更大的事吗？急什么．",
 367,"可是……",
 9,"平心静气讲．",
 367,"是，主公的父亲曹嵩被陶谦部下杀害了．",
 9,"什么！？是真的吗？");
 MovePerson(9,1,2);
 MovePerson(9,1,1);
 MovePerson(9,1,3);
 MovePerson(9,2,1);
talk(9,"陶谦为什么要杀我父亲！为什么！",
 367,"根据报告说，令尊在来陈留途中，陶谦招待了他，还派护卫护送他．可是令尊惨遭那护卫杀害．",
 9,"唉……陶谦，我绝不饶你．于禁！",
 63,"是．");
 MovePerson(63,1,1);
 MovePerson(63,3,2);
 MovePerson(63,0,0);
talk(9,"你马上率一军直奔徐州，杀他们以祭父亲在天之灵．我将随后率兵到小沛．你打先锋．",
 63,"是，倍感荣幸．我马上奔徐州，取陶谦首级来见你．");
 MovePerson(63,7,1);
 DecPerson(63);
 NextEvent();
 end,
 [67]=function()
 JY.Smap={};
 SetSceneID(0);
talk(63,"我马上杀往徐州，为令尊大人报仇．");
 SetSceneID(0);
talk(9,"陶谦老朽，我绝不饶你！进军小沛！");
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
talk(2,"大哥，徐州陶谦的家臣糜竺前来求见．说有话要对大哥讲．");
 --48 显示任务目标:<与糜竺谈话>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [69]=function()
 if JY.Tid==3 then--张飞
talk(3,"他好像有什么重要事要讲．大哥快听他讲话吧．");
 end
 if JY.Tid==2 then--关羽
talk(2,"兄长先去和糜竺谈话吧．");
 end
 if JY.Tid==65 then--糜竺
talk(65,"刘备，初次见面，请多关照．我是陶谦的家臣，叫糜竺．",
 1,"我和陶谦在讨伐董卓的联军时也见过面，你这次来有什么事情？",
 65,"其实此次前来是有求于刘备．",
 1,"是什么事？");
talk(65,"就在前两天，曹操的父亲经过徐州．我主公在徐州设宴招待了曹操父亲，还派人护送．",
 3,"这不是很好吗？",
 65,"可是，那个护卫起了反心，杀死了曹操父亲，掠去了财宝．曹操知道后惊怒异常，率领大军攻打徐州．",
 2,"怎么搞的嘛？原想欢迎，反倒成仇．");
talk(65,"所说的有求于刘备就是这件事．可否发兵支援徐州？请您救我们，不，是救徐州．这样下去的话，我们姑且不说连老百姓都卷进了战争．",
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
talk(3,"大哥，要发兵支援的话，打曹操，我们兵力可不够啊，怎么办？");
 end
 if JY.Tid==2 then--关羽
talk(2,"若发兵支援，抗拒曹操，我们现在没有那么多兵力啊．",
 1,"嗯，向公孙瓒借些兵吧．",
 2,"这是个好主意．那么我们快去公孙瓒所在地的北平城吧．");
 --48 显示任务目标:<为求得公孙瓒支援去北平．>
 NextEvent();
 end
 end,
 [71]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，快去北平吧．");
 end
 if JY.Tid==2 then--关羽
talk(2,"快去北平吧，北平位于平原的北面．");
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
talk(13,"哦，刘备，什么风把你吹来了？");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [73]=function()
 if JY.Tid==2 then--关羽
talk(2,"大哥，先跟公孙瓒打个招呼吧．");
 end
 if JY.Tid==3 then--张飞
talk(3,"我们没事，但跟公孙瓒还是说一下好．");
 end
 if JY.Tid==13 then--公孙瓒
talk(13,"刘备，怎么了．",
 1,"徐州陶谦派来使者，请求我支援．我想发兵前去支援，但是我这一点兵力恐怕不行．您看能不能借我一些兵？",
 13,"刘备在界桥对我有相助之恩，我很高兴借兵给你．",
 1,"谢谢．",
 13,"那就带他去吧．");
 AddPerson(54,3,20,0);
 MovePerson(54,7,0);
talk(54,"您叫我吗？",
 13,"赵云，你和刘备去支援徐州．",
 54,"去徐州？",
 13,"嗯，他们请求刘备支援．赵云，我想派你同去．",
 54,"能和刘备一起作战，我非常高兴，我愿意去．");
 ModifyForce(54,1);
 PlayWavE(11);
 DrawStrBoxCenter("赵云加入刘备军！");
talk(13,"那么，赵云让你辛苦一趟，刘备，祝你成功．",
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
talk(13,"祝你胜利．");
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
talk(65,"刘备，我一直在等你．请你准备出兵．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [76]=function()
 if JY.Tid==2 then--关羽
talk(2,"兄长，糜竺在等我们．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，糜竺等得着急了．");
 end
 if JY.Tid==54 then--赵云
talk(54,"主公，听你吩咐．");
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
talk(65,"那么快往徐州吧．");
 WarIni();
 DefineWarMap(7,"第一章 北海之战","一、管亥的溃败．",30,0,216);
 SelectTerm(1,{
 0,22,3,1,0,-1,0,
 -1,21,4,1,0,-1,0,
 -1,20,5,1,0,-1,0,
 -1,22,5,1,0,-1,0,
 -1,21,3,1,0,-1,0,
 53,21,2,1,0,-1,0,
 7,3,0,1,0,-1,0,
 149,2,0,1,0,-1,0,
 233,1,0,1,0,-1,0,
 });
 JY.Smap={};
 SetSceneID(0,3);
talk(65,"徐州在这个平原的南面，快速行军吧．");
 SetSceneID(0);
talk(3,"嗯？好像情况不对啊，怎么回事？");
 SetSceneID(0);
talk(217,"哈哈哈，进攻进攻！再攻一会儿城池就归我了．",
 150,"再这样的话，北海就要被攻陷了，孔融，请你出城逃走吧．",
 8,"不，这不行！我虽不愿意看到城池陷落，但我更不愿意弃城逃走．",
 150,"……",
 217,"冲啊！冲啊！金银财宝就在那里！");
 SetSceneID(0);
talk(2,"看来好像是草寇作乱．",
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
 216,6,7,3,6,10,10,7,10,-1,0,
 310,2,9,2,6,6,10,9,15,-1,0,
 311,3,8,2,6,6,10,9,16,-1,0,
 312,7,6,3,6,5,10,8,10,-1,0,
 313,10,10,3,0,5,10,0,0,-1,0,
 314,10,12,3,0,6,10,0,0,-1,0,
 315,8,14,3,0,6,10,0,0,-1,0,
 316,18,11,3,0,5,10,0,0,-1,0,
 317,18,12,3,0,5,10,0,0,-1,0,
 274,1,7,2,6,6,4,5,11,-1,0,
 275,9,7,3,6,6,4,14,11,-1,0,
 332,13,8,3,6,4,14,17,11,-1,0,
 333,6,12,3,6,4,14,7,13,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [79]=function()
 PlayBGM(11);
 WarModifyAI(7,2);
 WarModifyAI(149,2);
 WarModifyAI(233,2);
talk(217,"哈哈哈．这个城就等于到手了．混蛋们，把城里的金银财宝统统给我拿来．",
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
talk(54,"那是山贼的大将，在刘备面前也显示一下我的本领．",
 217,"哎呀，哈哈哈，真是蠢货，好像他还觉得能打赢我，没办法，我就陪你玩玩吧．");
 WarAction(6,54,217);
 if fight(54,217)==1 then
talk(217,"我是管亥，让你去阴曹地府……",
 54,"有破绽．");
 WarAction(4,54,217);
talk(217,"啊！");
 WarAction(18,217);
talk(54,"岂能宽容你这坑害百姓的草寇．");
 WarLvUp(GetWarID(54));
 PlayBGM(7);
 DrawMulitStrBox("赵云杀了管亥，刘备军打败了草寇．");
 GetMoney(300);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金３００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 else
talk(217,"我是管亥，让你去阴曹地府……",
 54,"啊！");
 WarAction(4,217,54);
 WarAction(17,54);
 WarLvUp(GetWarID(217));
 end
 end
 if JY.Status==GAME_WARWIN then
talk(217,"倒霉！你们再晚一点来，这个城就成我的了．");
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
talk(150,"主公，不知道来的是什么人，但我们现在应该杀出去配合他们．",
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
talk(150,"虽素不相识，但深感大德，能否请教尊姓大名．",
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
talk(150,"主公，我把刘备请出来了．",
 8,"噢，刘备．你救了北海，太感谢了．");
talk(8,"孔融感激不尽．",
 1,"不用多礼．我们这是因糜竺请求，正在赶往徐州．",
 8,"去徐州？去支援吗？我也听说曹操在攻打徐州．",
 1,"是的．我们路过这里时发现太史慈正受到攻击，所以助他一臂之力．",
 8,"是吗？那样的话，我拨给你一些粮草，也表示一下对这次帮助的感谢．");
talk(2,"大哥，再不赶路就要误事啦．",
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
talk(8,"努力啊．");
 end
 if JY.Tid==150 then--太史慈
talk(150,"谢谢你，有刘备支援，徐州就万无一失了．");
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
 0,3,16,4,0,-1,0,
 -1,1,15,4,0,-1,0,
 -1,2,15,4,0,-1,0,
 -1,2,16,4,0,-1,0,
 -1,4,17,4,0,-1,0,
 -1,3,17,4,0,-1,0,
 53,2,17,4,0,-1,0,
 15,29,12,3,0,-1,0,
 81,29,11,3,0,-1,0,
 63,29,13,3,0,-1,0,
 149,6,17,4,0,-1,1,
 });
 DrawSMap();
talk(65,"快去徐州吧．");
 JY.Smap={};
 SetSceneID(0,3);
talk(65,"刘备，徐州在北海的南面，快去吧．");
 NextEvent();
 end,
 [85]=function()
 SelectEnemy({
 62,25,12,4,6,14,1,22,13,-1,0,
 217,15,1,4,3,11,7,0,0,-1,0,
 115,26,9,4,6,11,1,22,12,-1,0,
 61,24,14,4,6,10,4,21,15,-1,0,
 19,8,1,4,1,11,23,0,0,-1,0,
 17,4,1,4,4,11,22,27,12,-1,0,
 256,5,0,4,4,7,1,27,11,-1,0,
 257,5,2,4,3,7,1,0,0,-1,0,
 336,25,14,4,6,7,15,20,12,-1,0,
 292,15,0,4,3,7,7,0,0,-1,0,
 293,15,2,4,3,7,7,0,0,-1,0,
 294,3,0,4,1,7,7,0,0,-1,0,
 295,3,2,4,1,6,7,0,0,-1,0,
 274,7,0,4,3,7,4,0,0,-1,0,
 348,6,1,4,4,6,19,27,10,-1,0,
 310,26,10,4,6,7,10,20,14,-1,0,
 328,25,16,4,6,7,13,22,14,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [86]=function()
 PlayBGM(11);
 WarModifyAI(15,2);
 WarModifyAI(63,2);
 WarModifyAI(81,2);
talk(63,"说什么？刘备攻过来了？有多少兵？……不好．一定设法等夏侯渊的到来．",
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
talk(150,"刘备，遵孔融之命，太史慈前来助你．");
 DrawStrBoxCenter("太史慈前来支援！");
 PlayBGM(9);
 SetFlag(1006,1);
 end
 if WarCheckArea(0,10,28,14,29) then
 PlayBGM(7);
talk(1,"好，放他进徐州城．大家不要打硬仗，退进城去．");
 DrawStrBoxCenter("刘备军后退了．");
 WarGetExp();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
talk(3,"太棒了，大哥．",
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
talk(2,"我就是关羽关云长，有武将的话就出来．",
 63,"无名小卒休得猖狂，我来了．");
 WarAction(6,2,63);
 if fight(2,63)==1 then
talk(2,"不愧是曹操的手下大将．只是凭你的武艺胜不了我．",
 63,"情况不妙！关羽，我记住你了．");
 WarAction(16,63);
 WarLvUp(GetWarID(2));
 else
talk(2,"不愧是曹操的手下大将．");
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
talk(63,"对不起．虽然让我当先锋，可是没打好……",
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
talk(65,"我回来了．",
 16,"哦，糜竺，这次你劝说刘备劝得好．刘备，久违了．",
 1,"我们能来得及支援，太好了．",
 16,"非常感谢．");
 --显示任务目标:<与陶谦讨论今后的事．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [90]=function()
 if JY.Tid==2 then--关羽
talk(2,"我们能来得及支援，太好了．");
 end
 if JY.Tid==3 then--张飞
talk(3,"呀，大哥，时间好紧啊，再晚一点就危险了．");
 end
 if JY.Tid==65 then--糜竺
talk(65,"刘备，太谢谢你了．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"如果刘备不来，我们都要遭杀身之祸．");
 end
 if JY.Tid==66 then--陈登
talk(66,"可是，虽然初战告捷，但敌人很强大，他们不会就此罢休的．");
 end
 if JY.Tid==16 then--陶谦
talk(16,"曹操军肯定还会打来，怎么办？",
 1,"曹操是个头脑清醒、明白事理的人，我们请求他停战吧．",
 64,"可是事情能否那么顺利呢？",
 3,"试一试看，不行再说．这交给我好啦．",
 2,"我认为应出兵作战，只有作战才能称为武将．");
talk(3,"哎，关羽，少见呀．竟比我还想打仗．",
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
talk(2,"快做出征准备吧．");
 JY.Status=GAME_SMAP_AUTO;
 WarIni();
 DefineWarMap(9,"第一章 小沛之战","一、曹操退兵",30,0,8);
 SelectTerm(1,{
 0,21,4,3,0,-1,0,
 -1,19,6,3,0,-1,0,
 -1,19,7,3,0,-1,0,
 -1,21,6,3,0,-1,0,
 -1,22,5,3,0,-1,0,
 -1,23,4,3,0,-1,0,
 53,20,7,3,0,-1,0,
 15,23,2,3,0,-1,0,
 63,20,3,3,0,-1,0,
 81,20,5,3,0,-1,0,
 --149,6,17,3,0,-1,1,
 });
 DrawSMap();
talk(2,"快出征吧．",
 16,"既然你们决定了，我们也出征．听说敌人现在在小沛．");
 JY.Smap={};
 SetSceneID(0,3);
talk(16,"从这里向西南，有个地方叫小沛．曹操军就在那里扎营．",
 2,"曹操军有什么了不起？兄长，快进军小沛吧．");
 NextEvent();
 end
 end
 if JY.Tid==3 then--张飞
 if talkYesNo( 3,"大哥，派我去向曹操军求和吗？") then
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
talk(3,"这样决定了的话就简单了．好，我马上就去．");
 --15 读入段指令:读入第<8>段指令
 NextEvent(96); --goto 96
 end
 end
 if JY.Tid==65 then--糜竺
talk(65,"曹操军非常强大，以正面与他交锋是下策．还是派张飞去求和吧．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"我选择交战．尽管对方强大，但我方在士气上没有输．");
 end
 if JY.Tid==66 then--陈登
talk(66,"敌军强大，他们是不会善罢甘休的．还是派张飞去求和吧．");
 end
 if JY.Tid==16 then--陶谦
talk(16,"莫非要我投降才是上策？");
 end
 end,
 [92]=function()
 LvUp(16,1);
 LvUp(64,1);
 LvUp(82,1);
 SelectEnemy({
 8,1,13,4,0,23,8,0,0,-1,0,
 386,0,13,4,3,18,15,8,0,-1,0,--典韦S
 68,0,14,4,0,14,13,0,0,-1,0,
 61,4,8,4,0,13,16,0,0,-1,0,
 16,2,13,4,0,14,7,0,0,-1,0,
 17,0,12,4,0,14,22,0,0,-1,0,
 115,3,12,4,0,14,1,0,0,-1,0,
 217,7,10,4,1,13,7,0,0,-1,0,
 62,8,14,4,1,14,1,0,0,-1,0,
 19,5,13,4,0,14,23,0,0,-1,0,
 256,10,14,4,1,10,1,0,0,-1,0,
 257,6,9,4,1,10,1,0,0,-1,0,
 258,6,14,4,0,10,1,0,0,-1,0,
 274,6,11,4,1,10,4,0,0,-1,0,
 275,9,13,4,1,9,4,0,0,-1,0,
 276,2,11,4,0,9,4,0,0,-1,0,
 292,7,15,4,1,10,7,0,0,-1,0,
 293,3,15,4,0,10,7,0,0,-1,0,
 294,1,14,4,0,9,7,0,0,-1,0,
 328,7,12,4,1,10,13,0,0,-1,0,
 329,0,10,4,0,10,13,0,0,-1,0,
 348,1,10,4,0,10,19,0,0,-1,0,
 349,1,15,4,0,9,19,0,0,-1,0,
 --
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [93]=function()
 PlayBGM(11);
talk(9,"刘备小儿，与我仇敌为友，我绝不宽恕你．杀尽刘备军．",
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
talk(3,"出来一战吧！废话少说！有胆子的出来．",
 18,"相当威风啊，我去战他吧．",
 3,"走！");
 WarAction(6,3,18);
 if fight(3,18)==1 then
talk(3,"看枪！");
 WarAction(5,3,18);
talk(18,"你也吃我一刀．");
 WarAction(5,18,3);
talk(3,"再来一刺，接着．");
 WarAction(4,3,18);
talk(18,"嗳，好厉害．胜不了他．");
 WarAction(16,18);
talk(3,"要逃吗，太狡猾了．乾脆认输吧．");
 WarLvUp(GetWarID(3));
 else
talk(3,"嗳，好厉害．胜不了他．");
 WarAction(17,3);
 WarLvUp(GetWarID(18));
 end
 end
 if (not GetFlag(1007)) and War.Turn==4 then
 PlayBGM(11);
talk(9,"哼，这种战斗力还能打仗吗？再狠狠地给我杀．");
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
talk(9,"不陪你们玩了，众将士，全面出击！",
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
talk(9,"什么！陈留遭吕布偷袭！坏了，忘了吕布的事．嗳，没办法．全军撤退！陶谦、刘备暂且留着你们的命！");
 WarAction(16,9);
 SetFlag(1009,1);
 PlayBGM(7);
 DrawMulitStrBox("　曹操军撤退了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
talk(9,"混蛋！再组织进攻！什么！陈留遭吕布偷袭！坏了！看来使陈留防守空虚是下策．嗳……没办法．全军撤退！陶谦、刘备暂且留着你们的命！");
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
talk(9,"全军马上折回，保住陈留！快！");
 SetSceneID(0);
talk(3,"嗳？曹操怎么突然逃跑了？",
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
talk(369,"主公，不得了啦．吕布进攻陈留了．",
 9,"什么？怎么会这样．坏了，太大意了．吕布这个畜生，乘我不在来偷袭．");
 AddPerson(367,4,21,0);
 MovePerson(367,7,0);
talk(367,"一个叫张飞的人前来请求停战，怎么办？",
 9,"张飞？刘备的那个盟弟呀．刘备请求停战？嗳，真是天助我也．告诉张飞，我接受停战．好，快速返回陈留，把吕布从陈留赶出去．");
 NextEvent();
 end,
 [97]=function()
 JY.Smap={};
 SetSceneID(0,11);
talk(9,"不能让吕布把陈留夺去．快速返回！");
 SetSceneID(0);
talk(3,"不过，曹操为什么撤退了？要是我的话就绝对进攻啦．",
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
talk(16,"刘备，这次你实在帮了大忙．");
 if GetFlag(97) then
talk(1,"不，我们什么忙也没帮，只是曹操折回去了．",
 16,"不不，来支援我们的只有你，我现在心情非常高兴．");
 end
 --显示任务目标:<与陶谦等谈话．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [99]=function()
 if JY.Tid==65 then--糜竺
talk(65,"谢谢，这样徐州得救了．");
 end
 if JY.Tid==66 then--陈登
talk(66,"刘备，谢谢．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"能有今天多亏了刘备．");
 end
 if JY.Tid==2 then--关羽
talk(2,"徐州得救太好了．");
 end
 if JY.Tid==3 then--张飞
talk(3,"还是帮助别人心里舒服．");
 end
 if JY.Tid==16 then--陶谦
 if GetFlag(97) then
talk(16,"刘备，这是我的一点心意，请你收下．");
talk(1,"这是？",
 16,"这是我们徐州自古传下来的兵器，叫雌雄双剑．",
 1,"您是说把这样贵重的东西给我？",
 16,"我们拿着他也没有意义，因为不能熟练使用，我希望把剑送给真正有用的人使用，请您一定收下．");
 GetItem(1,58);
 end
talk(16,"刘备，其实我有事相托．",
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
talk(65,"小沛就拜托你们了．");
 end
 if JY.Tid==66 then--陈登
talk(66,"刘备，谢谢．");
 end
 if JY.Tid==16 then--陶谦
talk(16,"带孙乾去小沛好啦．");
 end
 if JY.Tid==2 then--关羽
talk(2,"大哥，那就去小沛吧．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，那就去小沛吧．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"刘备，不，主公，今后请多关照．");
 ModifyForce(64,1);
 PlayWavE(11);
 DrawStrBoxCenter("孙乾成为刘备部下！");
talk(64,"马上去小沛吧，小沛是徐州西南的一个小镇．");
 JY.Smap={};
 SetSceneID(0);
talk(64,"我带你们去小沛．");
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
talk(3,"大哥，城主说我们接受此城太好了，这样我们也有城了．");
 end
 if JY.Tid==2 then--关羽
talk(2,"兄长，我们都很高兴，终于有了一个自己的城．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"主公，今后请多关照．");
 end
 if JY.Tid==54 then--赵云
talk(54,"刘备，徐州之围好像已解，我想回公孙瓒那里．",
 1,"是吗？赵云，这次你帮了大忙，我相信我们还能在一起为朝廷出力．");
 ModifyForce(54,0);
talk(2,"赵云，希望再见到你．",
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
talk(2,"大哥，曹操打败了吕布，吕布好像四处流浪．",
 3,"他活该，这是对他以前在汉都花天酒地的报应．",
 64,"可是，吕布今后怎么办呢？他又没有自己的领地．",
 1,"……");
 AddPerson(83,1,5,3);
 MovePerson(83,7,3);
talk(83,"主公，我视察完城内回来了．");
 --显示任务目标:<听简雍汇报．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [104]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，请听简雍汇报．");
 end
 if JY.Tid==2 then--关羽
talk(2,"大哥，请听简雍汇报．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"主公，请听简雍汇报．");
 end
 if JY.Tid==83 then--简雍
talk(83,"据城内百姓说，小沛这个地方经常有山贼出没．",
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
talk(3,"大哥，快出征吧，几个毛贼要是遇到我，不费吹灰之力就可以收拾他们．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"尽管是山贼草寇，也不可大意，败给他们可难堪了．");
 end
 if JY.Tid==83 then--简雍
talk(83,"不能让山贼草寇如此猖獗，平贼刻不容缓．");
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
talk(2,"大哥，去哪里？");
 NextEvent();
 end,
 [107]=function()
 local menu={
 {" 回小沛城",nil,1},
 {"　去泰山",nil,1},
 {"　去彭城",nil,1},
 {"　去夏丘",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,M_White,M_White);
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
talk(2,"大哥，一个草寇都没消灭，我们快扫平草寇吧．");
 elseif n<3 then
 if talkYesNo( 2,"大哥，草寇没消灭乾净，行吗？") then
 NextEvent(121); --goto 121
 else
talk(2,"请再一次选定进军目标．");
 end
 else
 NextEvent(121); --goto 121
 end
 elseif r==2 then
 if GetFlag(8) then
talk(2,"泰山草寇已被扫平了，我们去打别的地方吧．");
 else
talk(2,"明白了，去泰山．");
 SetSceneID(0);
 NextEvent(108); --goto 108
 end
 elseif r==3 then
 if GetFlag(9) then
talk(2,"彭城草寇已被扫平了，我们去打别的地方吧．");
 else
talk(2,"明白了，去彭城．");
 SetSceneID(0);
 NextEvent(112); --goto 112
 end
 elseif r==4 then
 if GetFlag(10) then
talk(2,"夏丘草寇已被扫平了，我们去打别的地方吧．");
 else
talk(2,"明白了，去夏丘．");
 SetSceneID(0);
 NextEvent(116); --goto 116
 end
 end
 end,
 [108]=function()
talk(2,"请列队．");
 PlayBGM(12);
 WarIni();
 DefineWarMap(10,"第一章 泰山之战","一、全数歼灭敌人．*二、敌军投降．",40,0,-1);
 SelectTerm(1,{
 0,23,11,3,0,-1,0,
 -1,22,11,3,0,-1,0,
 -1,22,12,3,0,-1,0,
 -1,24,10,3,0,-1,0,
 -1,25,10,3,0,-1,0,
 -1,25,11,3,0,-1,0,
 -1,21,10,3,0,-1,0,
 });
 SelectEnemy({
 375,4,2,4,2,12,14,0,0,-1,0,
 310,26,1,4,4,10,10,29,6,-1,0,
 311,14,5,4,1,10,10,0,0,-1,0,
 312,15,5,4,1,8,10,0,0,-1,0,
 313,9,2,4,0,10,10,0,0,-1,0,
 314,7,1,4,0,8,10,0,0,-1,0,
 315,4,1,4,0,7,10,0,0,-1,0,
 316,5,2,4,0,7,10,0,0,-1,0,
 332,25,2,4,4,8,14,29,6,-1,0,
 333,5,1,4,0,8,14,0,0,-1,0,
 336,24,3,4,4,10,15,29,6,-1,0,
 337,8,3,4,0,9,15,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [109]=function()
talk(376,"怎么要和刘备打仗？这将酿成我的终身错事，还是投降吧．",
 3,"贼将们，快出来让我消遣一下，最近我身体都有些不灵活了．");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [110]=function()
 if (not GetFlag(1010)) and War.Turn==3 then
talk(64,"主公，据说此地贼兵是由一女将率领．",
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
talk(376,"刘备，你得能打赢我吗？");
 WarAction(5,376,1);
 if fight(1,376)==1 then
talk(376,"哦，不行，我还是不能向刘备动手，我想归顺你们，刘备，刚才我错了．");
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
talk(2,"请列队．");
 PlayBGM(12);
 WarIni();
 DefineWarMap(12,"第一章 彭城之战","一、全数歼灭敌人．*二、敌军投降．",30,0,-1);
 SelectTerm(1,{
 0,7,15,4,0,-1,0,
 -1,6,14,4,0,-1,0,
 -1,5,14,4,0,-1,0,
 -1,5,15,4,0,-1,0,
 -1,8,14,4,0,-1,0,
 -1,8,15,4,0,-1,0,
 -1,9,15,4,0,-1,0,
 });
 SelectEnemy({
 223,19,2,3,2,12,10,0,0,-1,0,
 310,17,4,3,0,10,10,0,0,-1,0,
 311,18,4,3,0,10,10,0,0,-1,0,
 312,4,2,4,4,6,10,16,5,-1,0,
 313,5,3,4,4,6,10,17,5,-1,0,
 314,6,3,4,1,8,10,0,0,-1,0,
 315,6,4,4,1,7,10,0,0,-1,0,
 332,18,2,3,0,8,14,0,0,-1,0,
 292,16,5,3,1,6,7,0,0,-1,0,
 293,18,5,3,1,5,7,0,0,-1,0,
 294,2,1,4,1,6,7,0,0,-1,0,
 295,3,2,4,1,6,7,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [113]=function()
talk(224,"刘备是从平定黄巾之乱时开始强大的，现在还是乖乖地投降他好．",
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
talk(224,"刘备，你得能打赢我吗？");
 WarAction(5,224,1);
 if fight(1,224)==1 then
talk(224,"刘备，以兵刃相见，对不起了，今后我想改过自新，追随您．");
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
talk(2,"请点派军队．");
 PlayBGM(12);
 WarIni();
 DefineWarMap(11,"第一章 夏丘之战","一、全数歼灭敌人．*二、敌军投降．",30,0,-1);
 SelectTerm(1,{
 0,23,15,3,0,-1,0,
 -1,23,16,3,0,-1,0,
 -1,24,15,3,0,-1,0,
 -1,22,15,3,0,-1,0,
 -1,23,14,3,0,-1,0,
 -1,24,17,3,0,-1,0,
 -1,25,16,3,0,-1,0,
 });
 SelectEnemy({
 228,3,3,4,4,12,10,5,9,-1,0,
 310,4,2,4,4,10,10,6,8,-1,0,
 311,4,4,4,4,10,10,6,10,-1,0,
 312,5,3,4,4,9,10,8,8,-1,0,
 313,6,3,4,4,9,10,8,9,-1,0,
 314,6,4,4,4,8,10,8,10,-1,0,
 315,15,5,4,1,8,10,0,0,-1,0,
 316,17,5,4,1,7,10,0,0,-1,0,
 317,16,6,4,1,7,10,0,0,-1,0,
 336,9,7,4,1,11,15,0,0,-1,0,
 337,7,9,4,1,11,15,0,0,-1,0,
 274,8,8,4,1,10,4,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [117]=function()
talk(229,"不妙，如果是陶谦的军队还可以打赢．可是刘备的军队不好对付，别打了，还是投降吧．",
 83,"主公，讨贼吧，只有这样才能消灭这些害人精．");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [118]=function()
 if WarMeet(1,229) then
 PlayBGM(11);
 WarAction(1,1,229);
talk(229,"刘备，你得能打赢我吗？");
 WarAction(5,229,1);
 if fight(1,229)==1 then
talk(229,"坏了，怎么会是令人闻风丧胆的刘备？我实在是打不了，刘备，我投降．");
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
talk(2,"大哥，贼兵已全部消灭，我们回小沛吧．");
 NextEvent(121); --goto 121
 else
talk(2,"大哥，去哪里呢");
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
talk(2,"小沛的百姓说要谢谢大哥．");
 AddPerson(355,1,5,3);
 MovePerson(355,7,3);
talk(355,"刘备，您为我们消灭了山贼，谢谢，现在我们可以放心地外出走动了．这是我们本地百姓的一点意思，请笑纳．");
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
talk(355,"刘备，请您以后继续保护小沛，那我告辞了．");
 MovePerson(355,9,2);
 DecPerson(355);
 --显示任务目标:<与关羽等谈话．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [122]=function()
 if JY.Tid==2 then--关羽
talk(2,"我们讨完贼，这样小沛总算安定了．");
 end
 if JY.Tid==3 then--张飞
talk(3,"终究那些小毛贼不是我张飞的对手．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"不可大意，说不定还会有什么变故．");
 end
 if JY.Tid==83 then--简雍
talk(83,"主公，好像是快使．");
 AddPerson(367,1,5,3);
 MovePerson(367,7,3);
talk(367,"刘备，陶谦病情恶化，请马上去徐州．",
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
talk(65,"哦，刘备，你来得正好，快去见我们主公．");
 MovePerson(1,5,3);
 MovePerson(1,1,0);
talk(1,"陶谦，请多保重．");
talk(16,"哦，你来得正是时候，刘备，我有话对你讲，我快不行了，所以有件事想求你．",
 1,"什么事？",
 16,"你能不能担任徐州太守呢？",
 1,"这是什么话．");
talk(65,"你觉得很突然吧，然而这是要臣们商量决定的．",
 82,"刘备，您是当我们主公最合适的人选，请您保护徐州．");
 MovePerson( 2,4,3,
 3,4,3);
talk(2,"兄长，有什么可犹豫的，你就要拥有自己的领地了．",
 3,"陶谦一直在劝你，大哥，快决定吧．");
talk(65,"徐州是四面受攻之地，我们觉得与其被敌人夺走，还不如把徐州托付给刘备．",
 82,"刘备，我们求您了．");
talk(16,"如能接受我的请求，我也就没什么可牵挂的了，刘备，请你一定要接受．",
 1,"明白了，刘备不才，愿接受．",
 16,"您接受了，谢谢，这样我也没有牵挂了．糜竺，告别了．",
 65,"主公！");
 DrawMulitStrBox("　陶谦去世了．");
talk(65,"刘备，您就是我们的主公了．",
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
talk(65,"不能悲痛得无法自拔，刘备，我们先去议事厅，请您也要来．",
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
talk(2,"我们也去议事厅吧，张飞，走．",
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
talk(2,"失去一个很可惜的人．");
 end
 if JY.Tid==3 then--张飞
talk(3,"为了陶谦一定要守住徐州，是吧，大哥．");
 end
 if JY.Tid==82 then--糜芳
talk(82,"徐州四面被敌人包围，是个难守的地方．");
 end
 if JY.Tid==65 then--糜竺
talk(65,"主公，吕布来了．");
 PlayBGM(11);
 AddPerson(5,-5,24,0);
 DrawSMap();
 MovePerson(5,5,0);
talk(5,"呀，刘备，久违了，我有点事想要求您．");
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
talk(2,"是吕布吗？我反对收留吕布．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，对方是那个吕布吗？考虑都不要考虑，吕布之流，见面都没必要．");
 end
 if JY.Tid==65 then--糜竺
talk(65,"主公，吕布想说的话大概你也知道，我觉得不理他对徐州有利．");
 end
 if JY.Tid==82 then--糜芳
talk(82,"虽然我也同情吕布现在的状况，但此人毫无信义．");
 end
 if JY.Tid==76 then--陈宫
talk(76,"刘备，请你一定要帮助我们．");
 end
 if JY.Tid==80 then--张辽
talk(80,"刘备，我们正等着你的好回音．");
 end
 if JY.Tid==5 then--吕布
talk(5,"自从我们败给曹操以来，长时间到处流浪，当时听说你在徐州，就来了，请收留我们吧，求求你．");
 NextEvent();
 end
 end,
 [127]=function()
 if JY.Tid==2 then--关羽
talk(2,"吕布吗？虽然我不想违背大哥的意愿，但我还是反对．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，对方是那个吕布吗？考虑都不要考虑，吕布之流，见面都没必要．");
 end
 if JY.Tid==65 then--糜竺
talk(65,"主公，吕布想说的话大概你也知道，我觉得不理他对徐州有利．");
 end
 if JY.Tid==82 then--糜芳
talk(82,"虽然我也同情吕布现在的状况，但此人毫无信义．");
 end
 if JY.Tid==76 then--陈宫
talk(76,"刘备，请您帮助我们．");
 end
 if JY.Tid==80 then--张辽
talk(80,"刘备，请给我们一个好的答覆．");
 end
 if JY.Tid==5 then--吕布
talk(5,"刘备，请给我们一个好的答覆．",
 1,"我知道了，现在允许你在小沛落脚．",
 5,"啊，谢谢，没想到会得到如此好的答覆，徐州被曹操攻打时，也正因为我们攻打陈留，才能使你稳坐徐州，如此说来，这也是缘份，哈哈！",
 3,"胡说什么？");
 MovePerson(3,1,1);
 MovePerson(3,2,3);
 MovePerson(3,0,0);
talk(5,"张飞！",
 3,"你说我大哥和你有缘，胡说八道，我们有这徐州，难道还多亏你，吕布，我们马上决出胜负．");
 MovePerson(2,1,0);
 MovePerson(2,2,3);
 MovePerson(2,2,1);
talk(2,"张飞，住手．",
 3,"不要拦我，关羽，我要除掉此害．",
 2,"张飞，你先出去．");
 MovePerson(3,6,1);
 DecPerson(3);
 MovePerson(2,2,0);
 MovePerson(2,2,2);
 MovePerson(2,1,1);
 MovePerson(2,0,3);
talk(1,"对不起，我弟弟现在情绪很激动，没事的，请去小沛吧．",
 5,"那我们马上按您的话去小沛．",
 76,"谢谢．");
 MovePerson(5,7,1);
 DecPerson(5);
 MovePerson( 76,4,1,
 80,4,1);
 DecPerson(76);
 DrawSMap();
talk(2,"你不是张辽吗？")
 MovePerson(2,1,0);
 MovePerson(2,2,3);
 MovePerson(2,9,1);
 MovePerson(2,0,3);
 MovePerson(80,0,2);
talk(80,"关羽，有什么事？",
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
talk(2,"兄长，我不相信吕布．");
 end
 if JY.Tid==3 then--张飞
talk(3,"绝对不同意，你为什么把这种人留在徐州？");
 end
 if JY.Tid==65 then--糜竺
talk(65,"吕布连自己的义父都杀，没有信义．");
 end
 if JY.Tid==82 then--糜芳
talk(82,"哦，主公，孙乾来了．");
 AddPerson(64,5,19,0);
 DrawSMap();
 MovePerson(64,4,0);
 NextEvent();
 end
 end,
 [130]=function()
 if JY.Tid==2 then--关羽
talk(2,"孙乾来会有什么事情？");
 end
 if JY.Tid==3 then--张飞
talk(3,"绝对不同意，大哥，你为什么把那种人安置在徐州．");
 end
 if JY.Tid==65 then--糜竺
talk(65,"孙乾来了，听听他的意见吧．");
 end
 if JY.Tid==82 then--糜芳
talk(82,"先听听孙乾的意见吧．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"主公，有钦差来了，怎么办？",
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
talk(2,"大哥，请听钦差讲．");
 end
 if JY.Tid==3 then--张飞
talk(3,"绝对不能同意．");
 end
 if JY.Tid==65 then--糜竺
talk(65,"主公，请听钦差讲．");
 end
 if JY.Tid==82 then--糜芳
talk(82,"主公，先听钦差讲吧．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"我没事，先听钦差讲吧．");
 end
 if JY.Tid==365 then--使者
talk(365,"你是刘备吗？我是朝廷派来的钦差．",
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
talk(2,"按大哥的意思办．");
 end
 if JY.Tid==3 then--张飞
talk(3,"袁术不足挂齿，大哥，决定了就快出兵吧．");
 end
 if JY.Tid==82 then--糜芳
talk(82,"我们都是首次参战，让我们奋力杀敌吧．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"可是，皇帝为什么现在要下旨讨伐袁术呢？");
 end
 if JY.Tid==65 then--糜竺
talk(65,"主公，这道圣旨里面会不会有问题？",
 1,"大概这是曹操的主意，现在皇帝在曹操的庇护下，所以可以理解为这是曹操的命令．但圣旨难违呀．",
 65,"是啊，着手准备出兵吧．");
 --显示任务目标:<进军淮南，讨伐袁术．>
 NextEvent();
 end
 end,
 [133]=function()
 if JY.Tid==3 then--张飞
talk(3,"袁术不足挂齿，大哥，决定了就快出兵吧．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"既然决定出兵，也只好服从了．");
 end
 if JY.Tid==65 then--糜竺
talk(65,"准备出兵了．");
 end
 if JY.Tid==82 then--糜芳
talk(82,"我们都是首次参战，让我们奋力杀敌吧．");
 end
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"准备好了吗？") then
 RemindSave();
 PlayBGM(12);
talk(2,"请点兵派将．");
 WarIni();
 DefineWarMap(13,"第一章 淮南之战","一、全数歼灭敌人．",30,0,-1);
 SelectTerm(1,{
 0,14,5,1,0,-1,0,
 -1,15,4,1,0,-1,0,
 -1,15,6,1,0,-1,0,
 -1,13,6,1,0,-1,0,
 -1,13,4,1,0,-1,0,
 -1,16,5,1,0,-1,0,
 -1,12,5,1,0,-1,0,
 -1,12,3,1,0,-1,0,
 -1,14,3,1,0,-1,0,
 });
 DrawSMap();
talk(2,"出兵．");
 JY.Smap={};
 SetSceneID(0,3);
talk(3,"好，进军袁术所在的淮南，我的胳膊都痒了．");
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
talk(70,"刘备军已经打过来了，主公，怎么办？",
 12,"刘备小儿也想夺我的领土，也太狂妄自大了吧，袁胤，有何良策？");
talk(43,"有．",
 12,"哦，是什么？快说．",
 43,"是，现在吕布受刘备保护，驻紮在小沛，所以让吕布袭击刘备的背后．",
 12,"什么？你说挑动吕布？可是吕布会像你说的那样做吗？他不是正受刘备的照顾吗？",
 43,"可是，如我们说服得好，吕布肯定会动手的．");
talk(70,"对，因为董卓那么照顾他，他都背叛了．",
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
talk(74,"袁术来信是怎么讲的？",
 5,"唉．");
 DrawMulitStrBox("『原只是个农民的刘备，鬼迷心窍想占领我的领地，您不会允许吧，您应该从此贼手中夺回徐州，让这个狂妄自大的家伙知道自己的愚蠢．定当以厚礼相赠．*　　　　　　　　　　　　　　袁术』");
talk(75,"送一封这样的信来，袁术好像很慌乱．",
 80,"这封信口气好像很专横，看来事到如此境地，还摆什么臭架子．",
 76,"可是，主公，此事应仔细考虑呀．",
 5,"什么？怎么回事？");
talk(76,"现在徐州空虚，我们应乘此间隙夺取徐州，在那里组建精锐部队．",
 5,"可是，刘备收留了我们，那样会……",
 76,"时为战乱之秋，主公，要得到天下，这可是不会再有的机会了．",
 5,"明白了．集合部队，去徐州．");
talk(80,"可是，刘备于我们有恩，这不是背叛吗？");
talk(76,"那你是说让主公作为刘备的客人渡过一生．");
talk(75,"对呀，和主公一起打天下吧．",
 80,"……",
 5,"不必再说，全军马上向徐州进发．");
talk(81,"……张辽，你的心情我知道，然而这是战乱之秋，没办法．");
talk(80,"战乱之秋……");
 NextEvent();
 end,
 [136]=function()
 SelectEnemy({
 69,2,20,4,0,18,8,0,0,-1,0,
 66,17,20,4,0,15,2,0,0,-1,0,
 71,4,19,4,0,14,1,0,0,-1,0,
 256,15,20,4,0,11,1,0,0,-1,0,
 257,6,21,4,0,11,1,0,0,-1,0,
 292,9,20,4,0,11,7,0,0,-1,0,
 293,4,21,4,0,11,7,0,0,-1,0,
 274,18,19,4,0,11,4,0,0,-1,0,
 275,16,19,4,0,10,4,0,0,-1,0,
 276,3,18,4,0,11,4,0,0,-1,0,
 328,1,21,4,0,11,13,0,0,-1,0,
 336,7,19,4,0,11,15,0,0,-1,0,
 
 75,11,1,1,1,18,5,0,0,-1,1,
 79,11,2,1,1,17,24,0,0,-1,1,
 72,11,3,1,1,14,14,0,0,-1,1,
 73,12,1,1,1,14,1,0,0,-1,1,
 74,10,2,1,1,14,4,0,0,-1,1,
 294,9,0,1,1,11,7,0,0,-1,1,
 295,11,0,1,1,10,7,0,0,-1,1,
 296,13,0,1,1,11,7,0,0,-1,1,
 337,13,2,1,1,11,15,0,0,-1,1,
 258,9,1,1,1,10,1,0,0,-1,1,
 310,14,1,1,1,11,10,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [137]=function()
 PlayBGM(11);
talk(70,"哼，我家主公岂能被刘备这贩履小儿轻视，让他看看我的厉害．",
 2,"袁术好像没有亲征，小心他耍什么花招．");
 WarShowTarget(true);
 PlayBGM(10);
 NextEvent();
 end,
 [138]=function()
 if (not GetFlag(1011)) and War.Turn==6 then
 PlayBGM(11);
talk(65,"主公，刚才徐州来人急报，说徐州已被吕布占领．",
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
talk(76,"这场战争，将影响到主公的一生，众将，向刘备发动总攻．",
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
talk(1,"简雍说的鹿砦就是这个吧，马上就到了，总算逃出去了．");
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
talk(2,"张辽，吕布作出如此下流之事，难道你还想追随他？",
 80,"不必多言，关羽，来吧！",
 2,"没办法，此人虽然杀之可惜……");
talk(2,"我来了，张辽．",
 80,"啊！");
 WarAction(6,2,80);
 if fight(2,80)==1 then
talk(2,"不愧是张辽，但此招躲得过吗？");
 WarAction(8,2,80);
talk(80,"噢，不愧是关羽，今天我算败给你了．",
 2,"张辽，想逃跑吗？站住！");
talk(80,"撤退，我不想和关羽交战．");
 WarAction(16,80);
 WarLvUp(GetWarID(2));
 else
talk(2,"不愧是张辽，为什么偏偏要跟着刘备．");
 WarAction(16,2);
 WarLvUp(GetWarID(80));
talk(80,"撤退，我不想和刘备军交战．");
 WarAction(16,80);
 end
 end
 end,
 [139]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(3,"吕布，这个畜生，大哥，关羽，我马上返回徐州，去杀吕布．",
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
talk(9,"哦，刘备，这次落难了．");
 MovePerson(1,7,0);
 --显示任务目标:<与曹操就今后问题进行研究．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [141]=function()
 if JY.Tid==69 then--荀彧
talk(69,"这次落难了．");
 end
 if JY.Tid==62 then--郭嘉
talk(62,"我很体谅你失去徐州的心情．");
 end
 if JY.Tid==78 then--程昱
talk(78,"那是一场很艰苦的作战吧．");
 end
 if JY.Tid==17 then--夏侯惇
talk(17,"被吕布出卖了吧，吕布简直是个毫无信义的人．");
 end
 if JY.Tid==19 then--曹仁
talk(19,"吕布和袁术不敢打到这里来．");
 end
 if JY.Tid==9 then--曹操
talk(9,"听起来，你是被吕布出卖了，徐州也丢了，我很同情你的处境，关羽怎么样了？",
 1,"关羽和张飞都在城外候着，我们现在连住处都没有，是含羞前来投靠，请您关照．",
 9,"唉，你们放心地住在许昌吧，大家长途跋涉很累了吧，快去官邸休息吧．");
 --显示任务目标:<在官邸休息．>
 NextEvent();
 end
 end,
 [142]=function()
 if JY.Tid==69 then--荀彧
talk(69,"这次落难了．");
 end
 if JY.Tid==62 then--郭嘉
talk(62,"我很体谅你失去徐州的心情．");
 end
 if JY.Tid==78 then--程昱
talk(78,"官邸在城内．");
 end
 if JY.Tid==17 then--夏侯惇
talk(17,"被吕布出卖了吧，吕布简直是个毫无信义的人．");
 end
 if JY.Tid==19 then--曹仁
talk(19,"吕布和袁术不敢打到这里来．");
 end
 if JY.Tid==9 then--曹操
talk(9,"不要客气，快去官邸休息吧．",
 1,"谢谢．");
 MovePerson(1,12,1);
 DecPerson(1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [143]=function()
 SetSceneID(85,11);
talk(78,"主公，刘备可是个有雄才大略的英雄．",
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
talk(5,"唉，不只曹操，还有刘备也攻过来了，陈宫，如何是好？");
 MovePerson(76,1,0);
 MovePerson(76,2,3);
 MovePerson(76,0,0);
talk(76,"现在整顿兵马，首先在通往徐州的路上布置兵马．",
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
talk(5,"张辽，你去夏丘，按陈宫的吩咐阻止曹操军前进．",
 80,"遵令！",
 5,"高顺去彭城，好，去吧．",
 73,"遵令！");
 MovePerson( 80,10,1,
 73,10,1);
 DecPerson(80);
 DecPerson(73);
talk(76,"主公，快去下邳吧．",
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
talk(80,"那么，我们在夏丘阻止曹操军．",
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
talk(9,"哦，刘备，能夺回小沛，首先要祝贺你．",
 1,"谢谢．");
 --显示任务目标:<与曹操等就下一步作战研究．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [148]=function()
 if JY.Tid==2 then--关羽
talk(2,"请对曹操讲．");
 end
 if JY.Tid==3 then--张飞
talk(3,"太想念这里了，觉得好像终于回到了家．");
 end
 if JY.Tid==69 then--荀彧
talk(69,"这仗打得真漂亮啊，终于夺回了小沛．");
 end
 if JY.Tid==62 then--郭嘉
talk(62,"乾脆乘势进攻，消灭吕布．");
 end
 if JY.Tid==9 then--曹操
talk(9,"刘备，此次进攻徐州，我想与你分路进军．",
 1,"分成夏丘和彭城两路．",
 9,"对，敌人好像已在夏丘和彭城准备好等着我们，刘备，我分一支援军给你，如果你攻夏丘就带荀彧，攻彭城就带郭嘉，我跟他俩讲好了．");
 NextEvent();
 end
 end,
 [149]=function()
 if JY.Tid==2 then--关羽
talk(2,"选择哪条路由大哥定，可是，守夏丘的是张辽，张辽可非寻常之辈．");
 end
 if JY.Tid==3 then--张飞
talk(3,"哪条路都行，大哥，快夺回徐州吧．");
 end
 if JY.Tid==9 then--曹操
talk(9,"如果往夏丘进军就带荀彧，往彭城就带郭嘉．");
 end
 if JY.Tid==69 then--荀彧
 if talkYesNo( 69,"要进攻夏丘吗？") then
 RemindSave();
 PlayBGM(12);
talk(69,"请编组部队．");
 WarIni();
 DefineWarMap(11,"第一章 夏丘II之战","一、张辽撤退．",30,0,79);
 SelectTerm(1,{
 0,2,9,4,0,-1,0,
 -1,3,9,4,0,-1,0,
 -1,1,10,4,0,-1,0,
 -1,3,10,4,0,-1,0,
 -1,1,9,4,0,-1,0,
 -1,4,9,4,0,-1,0,
 -1,4,10,4,0,-1,0,
 68,25,17,3,0,-1,0,
 18,24,17,3,0,-1,0,
 19,25,16,3,0,-1,0,
 });
 DrawSMap();
 JY.Smap={};
 SetSceneID(0,3);
talk(69,"出兵．",
 9,"那么我们就向彭城进军吧，刘备，夏丘方面就交给你了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(150); --goto 150
 end
 end
 if JY.Tid==62 then--郭嘉
 if talkYesNo( 62,"要进攻彭城吗？") then
 RemindSave();
talk(62,"请编组部队．");
 WarIni();
 DefineWarMap(12,"第一章 彭城II之战","一、高顺撤退．",30,0,72);
 SelectTerm(1,{
 0,1,3,4,0,-1,0,
 -1,1,1,4,0,-1,0,
 -1,2,0,4,0,-1,0,
 -1,2,2,4,0,-1,0,
 -1,0,2,4,0,-1,0,
 -1,0,3,4,0,-1,0,
 -1,0,4,4,0,-1,0,
 61,6,15,4,0,-1,0,
 16,6,14,4,0,-1,0,
 17,7,15,4,0,-1,0,
 });
 DrawSMap();
 JY.Smap={};
 SetSceneID(0,3);
talk(62,"出兵．",
 9,"那么我们就向夏丘进军，刘备，彭城方面就交给你了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(154); --goto 154
 end
 end
 end,
 [150]=function()
 SelectEnemy({
 79,16,10,3,2,17,24,0,0,-1,0,
 256,16,12,4,4,14,1,24,16,-1,0,
 257,13,10,3,4,12,1,7,9,-1,0,
 258,15,10,3,2,10,1,0,0,-1,0,
 274,17,11,4,4,14,4,24,16,-1,0,
 275,13,9,3,4,12,4,7,9,-1,0,
 276,15,9,3,2,10,4,0,0,-1,0,
 292,15,12,4,4,10,7,24,16,-1,0,
 293,14,10,3,4,10,7,7,9,-1,0,
 328,15,11,3,2,12,13,0,0,-1,0,
 259,0,8,4,1,14,1,0,0,-1,1,
 277,0,9,4,1,10,4,0,0,-1,1,
 294,0,10,4,1,10,7,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [151]=function()
 PlayBGM(11);
talk(69,"好，两面夹击敌人．",
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
talk(2,"大哥，注意后面．");
 WarShowArmy(259);
 WarShowArmy(277);
 WarShowArmy(294);
 DrawStrBoxCenter("敌人的奇袭队出现了．");
talk(1,"张辽派奇袭队抄我后路．",
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
talk(2,"对面的可是张辽，你追随吕布，难道不后悔吗？",
 80,"唉！",
 2,"吕布是个视背叛如同儿戏的恶棍，决不是什么英雄，这点你不会不知吧．",
 80,"唉！");
talk(80,"全军撤退！");
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
talk(69,"刘备，主公刚派使者来，说他的部队已占领徐州，我们去徐州吧．");
 NextEvent(158); --goto 158
 end,
 [154]=function()
 SelectEnemy({
 72,17,15,3,0,17,14,0,0,-1,0,
 256,13,12,3,4,14,1,8,11,-1,0,
 257,16,13,3,4,13,1,15,9,-1,0,
 258,17,13,3,0,12,1,0,0,-1,0,
 274,16,8,3,4,14,4,14,4,-1,0,
 275,15,14,3,4,12,4,16,9,-1,0,
 292,15,9,3,4,10,7,14,4,-1,0,
 293,15,10,3,4,10,7,14,4,-1,0,
 294,14,13,3,4,9,7,8,11,-1,0,
 295,14,14,3,4,10,7,12,12,-1,0,
 296,16,14,3,0,9,7,0,0,-1,0,
 310,15,8,3,4,14,10,14,4,-1,0,
 311,13,13,3,4,12,10,8,11,-1,0,
 328,15,15,3,0,12,13,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [155]=function()
 PlayBGM(11);
talk(73,"可恶，这样打下去赢不了，吕布将军还没有回话吗？吕布是叫我去送死．",
 2,"据说彭城由高顺把守，我们不能落在曹操军的后面．");
 WarShowTarget(true);
 PlayBGM(13);
 NextEvent();
 end,
 [156]=function()
 if WarMeet(3,73) then
 WarAction(1,3,73);
talk(3,"城中大将，出来，我要一雪徐州之耻．",
 73,"张飞，我来与你单挑较量．");
 WarAction(6,3,73);
talk(73,"下马受死．",
 3,"与吕布狼狈为奸，不管是谁，我都要一枪刺死他．");
 WarAction(5,3,73);
 if fight(3,73)==1 then
talk(73,"不行，实在打不过他．");
 WarLvUp(GetWarID(3));
talk(73,"妈的！撤退！");
 WarAction(16,73);
 PlayBGM(7);
 DrawMulitStrBox("　高顺撤退了，刘备和曹操联军打败了．");
 GetMoney(500);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金５００．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 else
talk(3,"不行，实在打不过他．");
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
talk(73,"可恶！撤退！");
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
talk(62,"刘备，主公派来使者，说他的部队已经占领了徐州，我们去徐州吧．");
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
talk(9,"刘备，果然名不虚传啊，你辛苦了．吕布好像逃到了下邳．",
 1,"下邳？",
 9,"你大概也知道吧，此城坚固，现苦无攻城良策．");
 --显示任务目标:<与曹操就下一步研究．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [159]=function()
 if JY.Tid==2 then--关羽
talk(2,"大哥，先向曹操报告一下吧．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，还是徐州好呀，好像回到家似的．");
 end
 if JY.Tid==69 then--荀彧
talk(69,"下邳城特别难攻，假如吕布又逃到那里，破城就难上加难了．");
 end
 if JY.Tid==62 then--郭嘉
talk(62,"吕布逃进了下邳，我们差一点就抓到这条猛虎．");
 end
 if JY.Tid==17 then--夏侯惇
talk(17,"剩下的只是下邳了，吕布也该完蛋了．");
 end
 if JY.Tid==18 then--夏侯渊
talk(18,"吕布很快就会完蛋，这样社会也能安宁些．");
 end
 if JY.Tid==19 then--曹仁
talk(19,"吕布在下邳城，这样会难攻些．");
 end
 if JY.Tid==20 then--曹洪
talk(20,"即使攻破下邳，吕布一个人也很难对付，必须小心．");
 end
 if JY.Tid==9 then--曹操
talk(9,"刘备，该怎么打呀？噢，来人是谁？");
 AddPerson(66,5,19,0);
 MovePerson( 66,7,0)
talk(66,"刘备大人，我是陈登，是徐州的豪门之士．",
 1,"以前在徐州议事厅见过面．",
 66,"吕布占领徐州后，屈从吕布，现在想将吕布军的事情禀报大人．",
 9,"对了，陈登有话跟你说．你去听他怎么说．");
 NextEvent();
 end
 end,
 [160]=function()
 if JY.Tid==2 then--关羽
talk(2,"大哥，你听陈登讲．");
 end
 if JY.Tid==3 then--张飞
talk(3,"呀，大哥，还是徐州好呀，像回到家乡．");
 end
 if JY.Tid==69 then--荀彧
talk(69,"刘备，请听陈登讲．");
 end
 if JY.Tid==62 then--郭嘉
talk(62,"吕布逃进了下邳城，我们差一点就抓住了这条猛虎．");
 end
 if JY.Tid==17 then--夏侯惇
talk(17,"只剩下邳了，吕布快完蛋了．");
 end
 if JY.Tid==18 then--夏侯渊
talk(18,"吕布马上就完了，这样也好安宁些．");
 end
 if JY.Tid==19 then--曹仁
talk(19,"吕布在下邳，这样也许难攻些．");
 end
 if JY.Tid==20 then--曹洪
talk(20,"即使攻破下邳，但吕布一人也很难对付．");
 end
 if JY.Tid==9 then--曹操
talk(9,"刘备，听陈登讲．");
 end
 if JY.Tid==66 then--陈登
talk(66,"其实我原是吕布的下属，如果有人劝降顺利，侯成﹑魏续﹑宋宪三人也许会倒戈献城．");
talk(66,"大概此三人都在下邳城外把守，如能与他们化敌为友，下邳城则很容易攻破．");
 NextEvent();
 end
 end,
 [161]=function()
 if JY.Tid==2 then--关羽
talk(2,"大哥，一定要劝降此三人．");
 end
 if JY.Tid==3 then--张飞
talk(3,"游说劝降不在行，劝降就由大哥来吧．");
 end
 if JY.Tid==69 then--荀彧
talk(69,"言之有理，陈登之言非常重要．");
 end
 if JY.Tid==62 then--郭嘉
talk(62,"吕布逃进了下邳，差一点我们就捉到这头猛虎．");
 end
 if JY.Tid==66 then--陈登
talk(66,"刘备，一定要让侯成﹑魏续﹑宋宪倒戈，如果成功，这场仗必胜无疑．");
 end
 if JY.Tid==17 then--夏侯惇
talk(17,"只剩下下邳了，吕布也快完蛋了．");
 end
 if JY.Tid==18 then--夏侯渊
talk(18,"吕布马上就会完蛋，这样这个社会也能安宁些．");
 end
 if JY.Tid==19 then--曹仁
talk(19,"吕布在下邳，这也许会使攻城变得难一点．");
 end
 if JY.Tid==20 then--曹洪
talk(20,"即使攻破了下邳，只吕布也很难对付啊．");
 end
 if JY.Tid==9 then--曹操
talk(9,"刘备，依计而行吧，现在我们就去攻下邳，届时刘备劝降侯成﹑魏续﹑宋宪三人，如能成功，下邳则很快得以攻克，刘备，看你的了．");
 NextEvent();
 -- 显示任务目标:<出征吕布驻守的下邳．>
 end
 end,
 [162]=function()
 if JY.Tid==3 then--张飞
talk(3,"游说不在行，有劳大哥办了．");
 end
 if JY.Tid==69 then--荀彧
talk(69,"陈登说的非常重要．");
 end
 if JY.Tid==62 then--郭嘉
talk(62,"下邳城四周有护城河，所以易守难攻，只要攻下城门吊桥，就好办了．");
 end
 if JY.Tid==66 then--陈登
talk(66,"刘备，请你一定要劝降侯成﹑魏续﹑宋宪，如能成功，则这场仗必胜无疑．");
 end
 if JY.Tid==17 then--夏侯惇
talk(17,"只剩下下邳了，吕布也快完蛋了．");
 end
 if JY.Tid==18 then--夏侯渊
talk(18,"吕布马上就会完蛋，这样这个社会也能安宁些．");
 end
 if JY.Tid==19 then--曹仁
talk(19,"吕布在下邳，这也许会使攻城困难一点．");
 end
 if JY.Tid==20 then--曹洪
talk(20,"即使攻破了下邳，只吕布也很难对付啊．");
 end
 if JY.Tid==9 then--曹操
talk(9,"刘备，就看你的了．");
 end
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"出兵吗？") then
 RemindSave();
 PlayBGM(12);
talk(2,"列队！");
 WarIni();
 DefineWarMap(14,"第一章 下邳之战","一、放吊桥．",45,0,4);
 SelectTerm(1,{
 0,30,22,3,0,-1,0,
 -1,29,23,3,0,-1,0,
 -1,31,21,3,0,-1,0,
 -1,28,22,3,0,-1,0,
 -1,29,21,3,0,-1,0,
 -1,30,20,3,0,-1,0,
 -1,31,19,3,0,-1,0,
 8,0,16,4,0,-1,1,
 61,5,14,4,0,-1,1,
 68,3,13,4,0,-1,1,
 18,3,16,4,0,-1,1,
 19,4,15,4,0,-1,1,
 16,1,15,4,0,-1,1,
 17,2,14,4,0,-1,1,
 });
 DrawSMap();
talk(2,"出兵！",
 9,"好，时机来了，除掉吕布．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [163]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(9,"刘备看你的了，我们把部队埋伏好，如果你劝降成功的话，那我们就一起攻进下邳．");
 NextEvent();
 end,
 [164]=function()
 ModifyForce(5,5);
 SelectEnemy({
 4,11,0,1,2,21,8,0,0,-1,0,
 75,12,1,4,2,18,5,0,0,-1,0,
 80,9,14,4,2,18,8,0,0,-1,0,
 73,17,15,4,2,17,2,0,0,-1,0,
 74,15,20,4,2,17,5,0,0,-1,0,
 79,15,2,4,0,18,24,0,0,-1,0,
 72,14,0,3,0,18,14,0,0,-1,0,
 84,5,6,4,0,17,15,0,0,-1,0,
 85,10,1,4,2,16,19,0,0,-1,0,
 256,19,14,4,0,14,1,0,0,-1,0,
 257,6,5,4,0,14,1,0,0,-1,0,
 258,12,3,3,0,14,1,0,0,-1,0,
 259,15,3,3,0,13,1,0,0,-1,0,
 260,14,3,3,0,13,1,0,0,-1,0,
 292,17,14,4,0,14,7,0,0,-1,0,
 293,10,14,4,0,14,7,0,0,-1,0,
 294,18,5,3,0,14,7,0,0,-1,0,
 274,20,13,4,0,14,4,0,0,-1,0,
 275,18,16,4,0,14,4,0,0,-1,0,
 276,11,1,4,0,13,4,0,0,-1,0,
 277,19,6,3,0,13,4,0,0,-1,0,
 310,18,15,4,0,14,10,0,0,-1,0,
 311,18,20,4,0,14,10,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [165]=function()
 PlayBGM(11);
talk(5,"哼，不管曹操和刘备如何进攻，这座城依然固若金汤．",
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
talk(1,"怎么啦？是吊桥降下来了吗？");
 WarShowArmy(8);
 WarShowArmy(61);
 WarShowArmy(68);
 WarShowArmy(16);
 WarShowArmy(17);
 WarShowArmy(18);
 WarShowArmy(19);
 DrawStrBoxCenter("曹操军援兵出现．");
talk(69,"主公，吊桥好像放下来了．",
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
talk(81,"是刘备吗？好哇，我跟你打．",
 1,"侯成，听我说．");
talk(1,"侯成，现在吕布已经孤立，军心离散，就像你一样．",
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
talk(1,"魏续，吕布气数已尽，不要再打无谓的仗了．",
 74,"我等自以前就追随吕布将军，可是吕布只想着自己的家眷，对我等下属毫无恩赐，现在我投靠你，这就去放吊桥．");
 WarAction(16,74);
 WarLvUp(GetWarID(1));
 SetFlag(18,1)
 end
 if WarMeet(1,75) then
 WarAction(1,1,75);
talk(75,"……刘备，我们以前怎么一直跟着，这样一个人啊．",
 1,"宋宪，现在觉醒也不迟．",
 75,"唉，好吧，我现在就投靠你们，刘备，我现在马上回城去放吊桥．");
 WarAction(16,75);
 WarLvUp(GetWarID(1));
 SetFlag(19,1)
 end
 if (not GetFlag(1017)) and War.Turn==3 then
talk(5,"城外士兵为何慢吞吞的，让他们加强进攻．",
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
talk(81,"刘备，快请入城．",
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
talk(69,"主公，吊桥好像放下来了．",
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
talk(2,"张辽，快投降，吕布气数已尽，你已为他尽力了．",
 80,"……现在不必多言，举起刀来．");
 WarAction(6,2,80);
talk(2,"杀呀！",
 80,"杀呀！");
 if fight(2,80)==1 then
talk(80,"呼哧，不愧是关羽，好厉害，啊！");
 WarAction(8,2,80);
talk(2,"还不是致死命的伤，杀死这个汉子有点可惜．");
 WarAction(17,80);
 WarLvUp(GetWarID(2));
 else
talk(2,"呼哧，不愧是张辽，好厉害，啊！");
 WarAction(17,2);
 WarLvUp(GetWarID(80));
 end
 end
 WarLocationItem(0,6,8,74); --获得道具:获得道具：赤兔马
 WarLocationItem(0,20,15,164); --获得道具:获得道具：方天画戟
 if JY.Status==GAME_WARWIN then
talk(5,"唉，完了，");
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
talk(2,"我们进入下邳吧．");
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
talk(9,"刘备，现在正要决定对吕布如何处置．");
 --显示任务目标:<决定对吕布的处置．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [170]=function()
 if JY.Tid==2 then--关羽
talk(2,"毫无同情的余地，应马上处死他．");
 end
 if JY.Tid==3 then--张飞
talk(3,"快点把他砍头吧，要不然我来行刑．");
 end
 if JY.Tid==69 then--荀彧
talk(69,"留下吕布的命将留下后患．");
 end
 if JY.Tid==62 then--郭嘉
talk(62,"可是，吕布此人相当了得，只他一人就让我们吃了这么多苦头．");
 end
 if JY.Tid==5 then--吕布
talk(5,"刘备，在战场上我还不会输的，作为武将，辅助主公，天下可定也．");
 end
 if JY.Tid==9 then--曹操
talk(9,"刘备，你想一想，对他如何处置好？");
 NextEvent();
 end
 end,
 [171]=function()
 if JY.Tid==2 then--关羽
talk(2,"毫无同情的余地，应马上处死他．");
 end
 if JY.Tid==3 then--张飞
talk(3,"快点砍下他的脑袋．");
 end
 if JY.Tid==69 then--荀彧
talk(69,"留下吕布的命将留下后患．");
 end
 if JY.Tid==62 then--郭嘉
talk(62,"吕布确实很英勇，但考虑到对主公好，还是……");
 end
 if JY.Tid==9 then--曹操
talk(9,"刘备，怎么办好呢？");
 end
 if JY.Tid==5 then--吕布
 JY.Status=GAME_SMAP_AUTO;
talk(5,"刘备，你忘了我们在徐州曾一起相处过吗？请你无论如何保住我的命啊！",
 9,"刘备，你看怎么办？把你的看法讲给我听．");
 local menu={
 {" 宽恕吕布",nil,1},
 {"不宽恕吕布",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
 NextEvent(); --goto 172
 elseif r==2 then
 NextEvent(173); --goto 173
 end
 end
 end,
 [172]=function()
talk(1,"吕布确实反叛无常，但其所处境遇也有令人同情之处，而且，杀掉此人很可惜呀．",
 5,"啊！对！是这样没错！刘备！谢谢你！曹操，饶我一命吧！",
 9,"唉，刘备，你那么认为吗？我却不那么认为，此人不可救药，先杀义父投奔董卓，接着又背叛了董卓，还杀了他，我不想步其后尘，吕布，你死定了．",
 5,"等一下，我不想死！",
 3,"大哥，这次我也赞成曹操的意见，吕布，我来给你行刑．");
 NextEvent(174); --goto 174
 end,
 [173]=function()
talk(1,"吕布是个容易背叛之徒，也背叛了董卓，即便现在曹操你想留住他，不久他也将背叛你．",
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
talk(3,"喂，张飞，住手！");
 MovePerson( 3,9,2,
 5,9,2);
 DecPerson(3);
 DecPerson(5);
talk(9,"好！带下一个．");
 AddPerson(80,-4,3,3);
 MovePerson( 80,9,3);
talk(9,"张辽，如果不追随吕布小儿的话，可以留住你的命，怎么样？今后跟随我，来补偿你以前的过错．",
 80,"哼，我以前的过错就是没亲手杀死你，现在既然已不能实现，活着也没意思，快杀我吧．",
 9,"谁听你胡言乱语．");
 MovePerson( 2,2,2);
 MovePerson( 2,3,1);
 MovePerson( 2,3,3);
talk(2,"刀下留人！",
 80,"关羽……",
 2,"此人忠义，虽有愚鲁之处，但实为难得人才，愿以关羽自身性命相保．",
 9,"我是开玩笑，难道我看不出？张辽，你自由了，随你便，去哪里都行．",
 80,"您说什么？您宽恕我了吗？真有气度！吕布却……，我过去错了，曹操，不，曹操仁公，你宽大为怀，我感激不尽，请让我在你麾下效劳．",
 9,"你是说要跟随我，张辽，我能得到你这样的下属，也是我的福气．",
 80,"多谢！");
 ModifyForce(80,9);
talk(9,"那么，刘备，战场也打扫完了，回许昌吧．",
 1,"好吧．");
 NextEvent();
 end,
 [175]=function()
 JY.Smap={};
 SetSceneID(0);
talk(2,"大哥，那就回许昌吧．");
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
talk(2,"我还以为吕布一死，害圣上的人就没有了，我岂能容忍曹操这样对圣上．");
 end
 if JY.Tid==3 then--张飞
talk(3,"啊，大哥，你们起来得真早呀，嗯，大哥，好像有人来了．");
 AddPerson(365,3,20,0);
 MovePerson(365,7,0);
talk(365,"刘备，对不起．");
 NextEvent();
 end
 end,
 [179]=function()
 if JY.Tid==2 then--关羽
talk(2,"你是曹操派来的使者吗？有什么事吗？");
 end
 if JY.Tid==3 then--张飞
talk(3,"不行，我还没睡醒呢，大哥，什么都别听．");
 end
 if JY.Tid==365 then--使者
talk(365,"刘备，曹操在议事厅，请你马上去议事厅．");
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
talk(9,"噢，刘备，我一直在等你．");
 MovePerson(1,7,0);
 --显示任务目标:<与曹操谈话．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [181]=function()
 if JY.Tid==69 then--荀彧
talk(69,"刘备，早好，休息得好吗？");
 end
 if JY.Tid==62 then--郭嘉
talk(62,"我去对他说．");
 end
 if JY.Tid==17 then--夏侯惇
talk(17,"我去对他说吧．");
 end
 if JY.Tid==18 then--夏侯渊
talk(18,"我去对他说吧．");
 end
 if JY.Tid==19 then--曹仁
talk(19,"我去对他说吧．");
 end
 if JY.Tid==20 then--曹洪
talk(20,"我去对他说吧．");
 end
 --[[
 if JY.Tid==69 then--荀彧
talk(69,"请早点回来．");
 end
 if JY.Tid==62 then--郭嘉
talk(62,"在圣上面前要注意礼节．");
 end
 if JY.Tid==17 then--夏侯惇
talk(17,"晋见圣上是头一次吧，要注意礼节．");
 end
 if JY.Tid==18 then--夏侯渊
talk(18,"快进宫殿吧．");
 end
 if JY.Tid==19 then--曹仁
talk(19,"快进宫殿吧．");
 end
 if JY.Tid==20 then--曹洪
talk(20,"快进宫殿吧．");
 end
 ]]--
 if JY.Tid==9 then--曹操
talk(9,"刘备，一大早就叫你来，对不起，其实今天我想晋见圣上，在与吕布作战中你表现得很英勇，我想把你引荐给圣上，你去不去？",
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
talk(9,"陛下，他就是刘备．",
 383,"噢，刘备，平身．");
talk(384,"刘备，我是皇帝内臣，叫董承，初次见面，请多关照．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [183]=function()
 if JY.Tid==9 then--曹操
talk(9,"刘备，快拜见陛下．");
 end
 if JY.Tid==384 then--董承
talk(384,"刘备，我心里一直盼望着能见到你．");
 end
 if JY.Tid==353 then--官吏
talk(353,"陛下座前，请行大礼．");
 end
 if JY.Tid==383 then--献帝
talk(383,"噢，你就是刘备吧，听说你和曹操一起讨伐了吕布，谢谢了，……对了，你也姓刘？",
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
talk(9,"没想到刘备是汉室宗族．");
 end
 if JY.Tid==384 then--董承
talk(384,"刘备若是汉室宗族，对皇帝也是一件喜事，我也很高兴．");
 end
 if JY.Tid==383 then--献帝
talk(383,"如果刘备与朕是同宗的话，那可太好了．");
 AddPerson(353,37,23,2);
 MovePerson(353,6,2);
talk(353,"刚查过，刘备是陛下的叔叔辈．",
 383,"是这样啊，那么，刘备，你是朕的叔叔了，既然如此，朕叫你皇叔，可以吗？皇叔．",
 1,"这对我来说实在是无上殊荣．");
 --显示任务目标:<在官邸休息．>
 NextEvent();
 end
 end,
 [185]=function()
 if JY.Tid==9 then--曹操
talk(9,"刘备，恭喜你，这样你以后谒见陛下就容易了．");
 end
 if JY.Tid==384 then--董承
talk(384,"刘备，不，刘皇叔，以后就靠你了．");
 end
 if JY.Tid==353 then--官吏
talk(353,"刘皇叔，好响亮啊．");
 end
 if JY.Tid==383 then--献帝
talk(383,"你可以退下了，刚打完仗，在家里好好休息吧．");
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
talk(2,"大哥，你回来了．");
 MovePerson(1,6,0);
talk(1,"刚才我晋见了圣上．",
 3,"噢，大哥，恭喜你，都说了些什么？",
 1,"……",
 2,"嗯，大哥，好像是侍从．");
 MovePerson(1,0,1);
 AddPerson(353,3,20,1);
 MovePerson(353,4,0);
talk(353,"刘皇叔，我是从皇宫来的．");
 --显示任务目标:<去皇宫见献帝．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [187]=function()
 if JY.Tid==2 then--关羽
talk(2,"大哥，皇宫使者又来了．");
 end
 if JY.Tid==3 then--张飞
talk(3,"又来了，大哥，我接他嫌麻烦．");
 end
 if JY.Tid==353 then--官吏
talk(353,"皇叔，圣上有旨，请您再进皇宫一趟．");
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
talk(383,"噢，皇叔，朕一直等你．");
 MovePerson(1,8,2);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [189]=function()
 if JY.Tid==353 then--官吏
talk(353,"皇叔，请您来好多次，实在辛苦了．");
 end
 if JY.Tid==354 then--官吏
talk(354,"近来圣上非常疲惫，好像有什么不顺心的事．");
 end
 if JY.Tid==383 then--献帝
talk(383,"噢，皇叔，经常叫你来，对不起．",
 1,"哪里？只要陛下叫我来我就来，有什么事吗？",
 383,"嗯，这个嘛，其他人退下．");
 MovePerson( 353,11,3,
 354,11,3);
 DecPerson(353);
 DecPerson(354);
talk(1,"是什么事？",
 383,"……皇叔，我很相信你，所以赐给你这条玉带，你拿回家后仔细看一下，就这件事情．",
 1,"……谢陛下，臣小心收好，那么臣告辞了．");
 --显示任务目标:<在官邸休息．>
 MovePerson(1,10,3);
 DecPerson(1);
talk(383,"皇叔，现在你已经是我最大的依靠，拜托你了．");
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
talk(2,"大哥，你回来了．");
 MovePerson(1,6,0);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [191]=function()
 if JY.Tid==2 then--关羽
talk(2,"大哥，圣上有什么事？",
 1,"没什么？只是赐给我这条玉带．",
 2,"奇怪，专程叫去只为一条玉带．");
 --显示任务目标:<在许昌城内散步．>
 NextEvent();
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，圣上有什么事？",
 1,"没什么？只是赐给我这条玉带．",
 3,"怎么搞得嘛，要是没有别的事情，赐条玉带可以叫刚才的使者带来．");
 end
 end,
 [192]=function()
 if JY.Tid==2 then--关羽
talk(2,"大哥，不要想那么多，不如到外面转转，散散心．",
 1,"也好．");
 MovePerson(1,3,1);
 AddPerson(68,3,20,0);
 MovePerson(68,2,0);
talk(68,"刘备，您在这里呀，我乃曹操的属下许褚，主公想见您，请您去主公的官邸，就在您官邸的旁边．");
 MovePerson(68,5,1);
 DecPerson(68);
 MovePerson(1,6,1);
 DecPerson(1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，可以系上那条玉带，难得的御赐玉带呀．");
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
talk(9,"我叫你来是因为听了些传言．",
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
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"好，玉带就送给你吧．",
 9,"不不，开玩笑，这可是御赐的东西．不过我还是想要，刘备，此话当真？真要把玉带让给我吗？");
 elseif r==2 then
talk(1,"啊，这个，因为这是御赐的东西……",
 9,"刘备，别这么说，是不是肯把这条玉带让给我？");
 end
 r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"既然你如此想要，就送你了．",
 9,"真的吗？那我就不客气了．");
 SetFlag(20,1);
 elseif r==2 then
talk(1,"对不起，尽管你想要，可是……",
 9,"呀，不要介意，我是开玩笑，我想看看你为难的表情．");
 end
talk(9,"那么，既然好不容易请你来一趟，一起喝点酒吧．");
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
talk(9,"刘备，这边请．",
 1,"好，谢谢．");
 --
 MovePerson( 9,5,0,
 1,5,0)
 MovePerson( 9,0,3,
 1,0,2)
 DrawMulitStrBox("　刘备尽管感到与曹操说话很危险，但还是决定与曹操一起饮酒，喝了一会以后……");
talk(9,"刘备，说起当世英雄，该推谁呢？",
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
 local r=ShowMenu(menu,6,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(9,"哼哼哼！对，刘备有英雄的素质，正因为如此，对他不能掉以轻心，否则后患无穷．");
 SetFlag(21,1);
 break;
 elseif r==2 then
talk(9,"哼哼哼！哈哈哈！你那么认为，我也那么认为，是这样啊，你是这么想的啊，其实，我还觉得你刘备同样是英雄，对，和我一样是英雄．",
 1,"你说什么呀，我可不是什么英雄．",
 9,"你觉得自己是凡夫俗子，我能和你交往吗？刘备，我可怕你呀．");
 SetFlag(21,1);
 break;
 elseif r==3 then
talk(9,"袁绍嘛，的确名门出身，部下又出类拔萃，但袁绍自己优柔寡断，这种人又没什么威信，谈不上是英雄．");
 elseif r==4 then
talk(9,"袁术嘛，他只考虑自己的利益，不过是蠢猪，我不久就要消灭他，你说袁术是英雄？不要撒谎．");
 elseif r==5 then
talk(9,"公孙瓒嘛，刘备你以前和他交情很好，这样可能对你不太好，但这个家伙对形势过于疏忽，不是能驾御这个乱世的人．");
 elseif r==6 then
talk(9,"你是说当世没有英雄吧，我认为不对，当世之英雄是你我，至少我这样认为．",
 1,"这？不要开玩笑．",
 9,"哈哈！这是玩笑吗？是这样没错．");
 break;
 end
 end
talk(1,"……");
 if GetFlag(20) then
 if GetFlag(21) then
talk(9,"啊，今天很高兴，这条玉带我就收起来了．",
 1,"那么我告辞了．");
 else
talk(9,"今天很高兴，这条玉带我就收起来了．",
 1,"那么我告辞了．");
 SetFlag(20,0);
 end
 else
talk(9,"今天很高兴，什么时候我二人再喝个通宵．",
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
talk(2,"大哥，你回来了，听说你去了曹操那里，没事吧．");
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
talk(17,"刘备，你要死在我刀下．",
 2,"大哥，危险．",
 3,"啊！大哥！");
talk(1,"哇！");
 DecPerson(1);
 PlayBGM(4);
talk(68,"在玉带发现了密书，上面写着杀死曹操．．",
 17,"所以我们才先发制人的．",
 19,"这叫自作自受，主公早已把他视作危险人物，他却不知道，还口吐狂言，以致有这样的下场．");
 DrawMulitStrBox("　刘备被杀了，刘备重振汉室声威的梦想也同时破灭了．");
 --游戏失败:
 NextEvent(999); --Goto 999
 end,
 [197]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，在曹操那里都说了些什么？我担心曹操耍什么阴谋．");
 end
 if JY.Tid==2 then--关羽
talk(2,"兄长，你要小心些，曹操那里可不能去．好像有人来了．");
 AddPerson(384,3,20,0);
 MovePerson(1,0,1);
 MovePerson(384,5,0);
talk(384,"刘皇叔，失礼了，您忘了吗？我是刚才与圣上在一起的董承．");
 NextEvent();
 end
 end,
 [198]=function()
 if JY.Tid==2 then--关羽
talk(2,"原来是董承大人，有什么事？");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，去陪客人了．");
 end
 if JY.Tid==384 then--董承
talk(384,"突然造访，对不起，皇叔是否得到一条陛下御赐的玉带，可否让我看一下？");
 local menu={
 {"　让他看",nil,1},
 {" 不让他看",nil,1},
 }
 while true do
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(384,"噢，确实是玉带，其实我也同样得到一条玉带，而且这条玉带实际上是……");
 DrawMulitStrBox("　董承用剑割开玉带，里面掉出了一张纸片．");
talk(1,"啊呀！里面有纸片！这是什么？写的是血书，上面写着杀死曹操．．",
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
talk(384,"皇叔，不要隐瞒了，玉带的事我听说了，来，交给我．");
 end
 end
 NextEvent();
 end
 end,
 [199]=function()
 if JY.Tid==2 then--关羽
talk(2,"兄长，我和张飞都很高兴，看来不管在什么时候都有忠臣呀！但我们待在这里总被曹操盯着，实在难以倒戈，现在最好研究一下离开这里，去徐州商量一下举兵起事的计划．",
 1,"好啊，那我马上去徐州，可是得有曹操的准许，好，我去见曹操．");
 --显示任务目标:<请求曹操准许离开．>
 MovePerson(1,12,1);
 DecPerson(1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==3 then--张飞
talk(3,"好哇，我听到你们刚才说的话了，这才是我的大哥，太好了！");
 end
 --[[
 if JY.Tid==2 then--关羽
talk(2,"注意千万别被他们发现，曹操可是个狡滑的家伙．",
 1,"好啊，那我马上去徐州，可是得有曹操的准许，好，我去见曹操．");
 --显示任务目标:<请求曹操准许离开．>
 NextEvent();
 end
 if JY.Tid==3 then--张飞
talk(3,"如果那样决定了的话，我们就马上返回徐州吧．");
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
talk(9,"刘备，你来得正好，我有话要对你说．",
 1,"对我说？",
 1,"（什么事呢？不会是那个计划吧，怎么会呢？）",
 9,"听满宠说吧．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [201]=function()
 if JY.Tid==9 then--曹操
talk(9,"刘备，详细情况你问满宠吧．");
 end
 if JY.Tid==17 then--夏侯惇
talk(17,"听满宠讲．");
 end
 if JY.Tid==18 then--夏侯渊
talk(18,"听满宠讲．");
 end
 if JY.Tid==19 then--曹仁
talk(19,"听满宠讲．");
 end
 if JY.Tid==20 then--曹洪
talk(20,"听满宠讲．");
 end
 if JY.Tid==84 then--满宠
talk(1,"满宠，你想说什么？",
 84,"对您可能是个悲伤的消息．",
 1,"……（该不是那个计划吧？）",
 84,"公孙瓒被袁绍消灭了．",
 1,"什么？公孙瓒？",
 84,"是的，袁绍消灭了公孙瓒，建立一个强大的领地．",
 1,"是吗？",
 84,"还有，据说袁术听到这个消息后，为保住自己，正赶向袁绍所在的邺城，如果袁绍和袁术携手起来，就谁也不能战胜他们．",
 1,"……（对，利用这句话好摆脱曹操．）");
talk(1,"曹操，我有一个请求……",
 9,"什么请求？");
 local menu={
 {" 为讨伐袁绍出征",nil,1},
 {" 为讨伐袁术出征",nil,1},
 {" 拜谒公孙瓒之墓",nil,1},
 }
 while true do
 local r=ShowMenu(menu,3,0,0,0,0,0,2,0,16,M_White,M_White);
 if r==1 then
talk(1,"不能任袁绍这样骄横跋扈，我想出征讨伐袁绍，请求您批准我讨伐袁绍．",
 9,"是啊…………不过，现在袁绍的实力大增，以你手里的兵力不能取胜，因此不能让你出征．最近我要和袁绍有个了断，刘备，到那时你再出力吧",
 1,"……");
 elseif r==2 then
talk(1,"刚才满宠说袁术已经动身了，请允许我讨伐袁术．",
 9,"刘备，你要出征吗？",
 1,"这样既可阻止袁绍与袁术会合，又可为公孙瓒报仇．",
 9,"好．……嗯，准战．",
 1,"那我马上去作出征准备．");
talk(84,"刘备，听说袁术正在广陵驻紮．",
 1,"在广陵，我知道了，那我告辞了．",
 9,"祝你凯旋回来．");
 --显示任务目标:<为讨伐袁术进军广陵．>
 break;
 elseif r==3 then
talk(1,"以前公孙瓒十分照顾我，真遗憾，现在已没机会报答他的恩情了，我想至少该去北平拜谒一下他的陵墓．",
 9,"这是你的真心话，北平现在已是袁绍的领地了，去那里太危险，打消这个念头吧．",
 1,"……");
 end
 end
 NextEvent();
 end
 end,
 [202]=function()
 if JY.Tid==9 then--曹操
talk(9,"要彻底打垮袁术！",
 1,"那我马上去作出征准备．");
 MovePerson(1,9,1);
 DecPerson(1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==17 then--夏侯惇
talk(17,"刘备，你是为什么投奔到这里来的？");
 end
 if JY.Tid==18 then--夏侯渊
talk(18,"区区袁术小儿，根本用不着我出征．");
 end
 if JY.Tid==19 then--曹仁
talk(19,"不可大意，因为不知道会出现什么事情的．");
 end
 if JY.Tid==20 then--曹洪
talk(20,"袁术是个自封为皇帝的假皇帝，刘备，该杀死这个假皇帝．");
 end
 if JY.Tid==84 then--满宠
talk(84,"听说袁术在广陵，祝你胜利．");
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
talk(1,"关羽，张飞，出征！",
 3,"这么突然，搞什么名堂？",
 1,"我找到摆脱曹操的藉口了，听说袁术现在广陵，我们去打他．",
 2,"对啦，是不是讨伐袁术后就不回许昌了，去徐州，曹操没怀疑吧？",
 1,"没有怀疑．",
 3,"好哇，呀，我还一直担心就得这样在许昌待下去了，太好了，要打仗了，我手都痒了．那么，我去告诉简雍他们．");
 MovePerson(3,8,1);
 DecPerson(3);
talk(2,"兄长，出兵广陵前你是不是该去见一下圣上．",
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
talk(383,"噢，皇叔，刚才董承上奏朕了．朕很高兴．",
 384,"陛下，您声音太大，小心些，皇叔此来有什么事？",
 1,"其实这次是因为讨伐袁术，要离开许昌．",
 383,"什么？那样的话，不是长时间见不到皇叔了吗？这……");
talk(384,"刘备，现在你不在了，我们的誓约？",
 1,"我正是为了誓约而来．",
 384,"嗯．",
 1,"誓约我没有忘，可是在许昌总是被曹操盯着，与其这样，我还不如利用这次出征机会离开许昌，摆脱曹操．",
 384,"确实如此，而且我们见面太多，也会加重曹操的疑心．好吧，我对圣上说，你放心吧．");
talk(384,"噢，皇叔，刚才董承上奏朕了．朕很高兴．",
 383,"什么？嗯嗯，确实如此，是啊，不愧是皇叔，我知道了，那么，皇叔就慢慢地扩充实力展翅高飞吧．",
 1,"明白了，臣告辞了．");
 --显示任务目标:<为讨伐袁术出兵广陵．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [205]=function()
 if JY.Tid==384 then--董承
talk(384,"刘备，我们期待着你．");
 end
 if JY.Tid==383 then--献帝
talk(383,"皇叔，你慢慢扩充实力吧．",
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
talk(2,"兄长，我们在等你，已准备好了，赶快出发吧．");
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
 -- id,x,y,d,ai --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,4,2,4,0,-1,0,
 -1,6,2,4,0,-1,0,
 -1,5,3,4,0,-1,0,
 -1,5,5,4,0,-1,0,
 -1,4,4,4,0,-1,0,
 -1,3,1,4,0,-1,0,
 -1,3,3,4,0,-1,0,
 });
 DrawSMap();
talk(2,"那就出发吧，如果让曹操知道了我们的真实意图就惨了．");
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
talk(12,"喂！快走！想让刘备抓住我吗？快！",
 355,"唉，饶命．",
 12,"谁再慢吞吞就杀了他，挡我前进之路的就杀了他．");
 SetSceneID(0,3);
talk(2,"兄长，快向广陵进军吧．",
 83,"广陵在许昌的东面，主公，我们进军吧．");
 NextEvent();
 end,
 [209]=function()
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 11,17,15,2,1,20,2,0,0,-1,0,
 42,16,14,2,1,16,5,0,0,-1,0,
 69,17,11,2,1,17,8,0,0,-1,0,
 66,18,12,2,1,17,2,0,0,-1,0,
 71,18,14,2,1,16,2,0,0,-1,0,
 31,15,15,2,1,16,5,0,0,-1,0,
 256,18,13,2,1,14,1,0,0,-1,0,
 257,18,10,2,1,13,1,0,0,-1,0,
 274,16,12,2,1,14,4,0,0,-1,0,
 275,15,12,2,1,13,4,0,0,-1,0,
 328,17,13,2,1,13,13,0,0,-1,0,
 329,19,12,2,1,13,13,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [210]=function()
 PlayBGM(11);
talk(12,"说什么？刘备来了，嗯，可恶的卖蓆小儿，可恶，全军攻击刘备．",
 1,"好哇，要杀死那个坏蛋，进攻袁术．");
 WarShowTarget(true);
 PlayBGM(13);
 NextEvent();
 end,
 [211]=function()
 if WarMeet(3,70) then
 WarAction(1,3,70);
talk(3,"你们这些国贼，胆敢随意自封皇帝，为所欲为，我来杀你！",
 70,"谁听你的胡言乱语！张飞！看我杀你！");
 if fight(3,70)==1 then
talk(70,"看我一刀！");
 WarAction(9,70,3);
talk(3,"啊呀呀，好险呀！这次轮到我给你一枪！");
 WarAction(8,3,70);
talk(70,"妈呀！",
 3,"中枪了！");
 WarAction(18,70);
 WarLvUp(GetWarID(3));
talk(3,"这还痛快些，噢，纪灵这家伙的武器还不错，作为战利品拿回去．");
 WarGetItem(3,14);
 else
talk(70,"看我一刀！");
 WarAction(8,70,3);
talk(3,"妈呀！中枪了！");
 WarAction(17,3);
 WarLvUp(GetWarID(70));
 end
 
 end
 if JY.Status==GAME_WARWIN then
talk(12,"唉，我怎么会败给刘备小儿？");
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
talk(3,"没想到袁术也太不中用了．",
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
talk(82,"主公，不好啦！");
 --显示任务目标:<研究今后对策．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [214]=function()
 if JY.Tid==2 then--关羽
talk(2,"糜芳有话说，请听他讲．");
 end
 if JY.Tid==3 then--张飞
talk(3,"刚打了胜仗，还能有什么事．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"请听糜芳说．");
 end
 if JY.Tid==65 then--糜竺
talk(65,"请听听我弟弟说什么．");
 end
 if JY.Tid==82 then--糜芳
 JY.Status=GAME_SMAP_AUTO;
talk(82,"主公，刚刚听到消息，董承等人被曹操杀害了．",
 1,"什么？被杀了，怎么被杀的？");
 NextEvent();
 end
 if JY.Tid==83 then--简雍
talk(83,"先听糜芳说吧．");
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
talk(9,"圣上大概不至于知道这个暗杀计划吧．",
 383,"这个，朕不知道．",
 9,"那就好，呀，请圣上宽恕臣的失礼．",
 383,"……（董承，朕对不起你．）");
 MovePerson(9,0,3);
talk(9,"可是，我决不能饶恕刘备，以前他从淮南遇难逃出来时，我保护他，他却忘恩负义．全军，准备出征，我亲自出马．",
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
talk(82,"这样一来，主公参与谋杀曹操的事情也暴露了．听说曹操已命令徐州的车胄，讨伐我们．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [217]=function()
 if JY.Tid==2 then--关羽
talk(2,"怎么会呢？这么快就暴露了．");
 end
 if JY.Tid==3 then--张飞
talk(3,"不过，大哥，只要坚守这里就没问题．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"主公，怎么办？");
 end
 if JY.Tid==65 then--糜竺
 JY.Status=GAME_SMAP_AUTO;
talk(65,"以我军的力量，实在打不过曹操军．",
 1,"嗯．");
 AddPerson(369,1,5,3);
 MovePerson(369,3,3);
talk(369,"报告，徐州的车胄正着手准备进攻这里．",
 2,"什么？车胄也要进攻这里．",
 64,"主公，我们与其在这里等死，还不如去攻占徐州，然后在小沛、徐州、下邳三城迎击曹操军，这样还可以分散曹操军的兵力．",
 1,"好主意，小沛我来守．我这就去．");
 MovePerson(3,2,2);
 MovePerson(3,2,0);
 MovePerson(3,8,2);
 DecPerson(3);
talk(2,"张飞，这个急性子，也不商量就走．");
 MovePerson(2,2,3);
 MovePerson(2,2,0);
 MovePerson(2,0,3);
talk(2,"兄长，剩下的两座城由谁来把守？");
talk(1,"嗯，是啊，关羽，你守这座城．",
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
talk(82,"据说曹操已率大军杀往徐州．");
 end
 if JY.Tid==83 then--简雍
talk(83,"遭了，如果曹操亲统大军前来，我们打不过的．");
 end
 end,
 [218]=function()
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"出征吗？") then
 RemindSave();
 PlayBGM(12);
talk(2,"编成部队．");
 ModifyForce(2,0);
 ModifyForce(3,0);
 WarIni();
 DefineWarMap(8,"第一章 徐州II之战","一、车胄的毁灭．",50,0,8);
 -- id,x,y,d,ai --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,4,1,4,0,-1,0,
 -1,4,2,4,0,-1,0,
 -1,5,0,4,0,-1,0,
 -1,5,3,4,0,-1,0,
 -1,7,0,4,0,-1,0,
 -1,3,1,4,0,-1,0,
 -1,3,2,4,0,-1,0,
 -1,6,1,4,0,-1,0,
 -1,6,2,4,0,-1,0,
 });
 DrawSMap();
talk(2,"兄长，多保重．",
 1,"你也要牢牢守住这座城．",
 2,"我死守此城．");
 JY.Smap={};
 SetSceneID(0,3)
talk(64,"向徐州进军．");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 89,29,12,3,2,21,2,0,0,-1,0,
 256,17,2,3,6,17,2,19,5,-1,0,
 257,24,6,3,0,17,2,0,0,-1,0,
 258,13,14,3,6,16,1,24,13,-1,0,
 274,17,0,3,6,17,5,19,4,-1,0,
 275,26,6,3,0,17,4,0,0,-1,0,
 276,18,13,3,6,16,4,26,11,-1,0,
 292,18,6,3,0,17,8,0,0,-1,0,
 293,25,2,3,6,16,7,26,13,-1,0,
 8,3,1,4,1,30,9,0,0,-1,1,
 61,12,1,4,1,21,16,0,0,-1,1,
 16,5,3,4,1,21,8,0,0,-1,1,
 17,8,0,4,1,21,22,0,0,-1,1,
 18,5,0,4,1,21,2,0,0,-1,1,
 ---
 19,15,1,4,1,21,24,0,0,-1,1,
 62,26,3,4,1,20,2,0,0,-1,1,
 115,27,0,4,1,20,2,0,0,-1,1,
 67,2,2,4,1,21,8,0,0,-1,1,
 76,13,0,4,1,21,13,0,0,-1,1,
 77,26,1,4,1,21,5,0,0,-1,1,
 68,9,1,4,1,21,13,0,0,-1,1,
 310,18,3,4,1,17,11,0,0,-1,1,
 311,7,2,4,1,17,11,0,0,-1,1,
 348,11,2,4,1,17,19,0,0,-1,1,
 277,23,0,4,1,16,5,0,0,-1,1,
 278,10,1,4,1,17,4,0,0,-1,1,
 279,17,2,4,1,16,4,0,0,-1,1,
 332,22,1,4,1,17,14,0,0,-1,1,
 ---
 386,4,1,4,3,24,15,8,0,-1,1,--典韦S
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [219]=function()
 PlayBGM(11);
talk(90,"各位，我们虽然人少，但曹操一定会派援兵的，援兵来之前，我们要守住．",
 64,"主公，我们在这里一磨蹭，曹操就会到的，我们尽快消灭车胄吧．");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [220]=function()
 if JY.Death==90 then
 PlayBGM(7);
talk(90,"喂，刘备，你忘了主公的恩情了．全军撤退．");
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
talk(82,"好像已经没有敌人了，主公，我们进城吧．");
 PlayBGM(9);
 War.WarTarget="一、刘备进入徐州．";
 WarShowTarget(false);
 NextEvent();
 end
 end,
 [221]=function()
 if WarCheckArea(0,10,29,14,29) then
talk(1,"嗯？怎么回事？这些马蹄声？怎么会呢？");
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
talk(9,"哼！刘备！你想跑也跑不掉了！你最好知道想杀我的人有什么下场！",
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
talk(9,"噢，刘备这个家伙，还算厉害，暂且退兵，重新编组全军．",
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
talk(1,"别人怎么样了？");
 DrawMulitStrBox("　刘备逃离了战场．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end 
 end,
 [223]=function()
 SetSceneID(0,5);
talk(64,"主公！",
 1,"噢！孙乾，没事吧．其他人怎么样？",
 64,"不知道，我也是九死一生，没有简雍等人的消息．",
 1,"是吗？关羽和张飞怎么样了？也不知道是死是活？",
 64,"凭他们的二人的英勇，不会有事的，暂且去邺城吧．");
 SetSceneID(0);
talk(1,"关羽，张飞，也不知道是死是活？那是谁？",
 65,"啊呀！");
 SetSceneID(0);
talk(1,"噢，糜竺，你没事吧？糜竺，看见其他人了吗？",
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
talk(50,"先请我们主公讲话．");
 end
 if JY.Tid==51 then--沮授
talk(51,"听说是被曹操追赶来的，想必这次很落魄吧．");
 end
 if JY.Tid==92 then--审配
talk(92,"虽然战败，曹操也追不到这里，现在这块领地毕竟势力还很强大．");
 end
 if JY.Tid==93 then--郭图
talk(93,"哼，这个丧家犬，杀了主公的弟弟，却敢跑到这里来．");
 end
 if JY.Tid==10 then--袁绍
 JY.Status=GAME_SMAP_AUTO;
talk(10,"刘备，欢迎你来，听说你被曹操打得很惨．你到我这里可以放心了，我也很担心曹操最近的态度，你在这里养精蓄锐，我们一起讨伐曹操吧．");
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
talk(64,"主公，我一直在等你．");
 MovePerson(1,6,0);
 --显示任务目标:<与孙乾谈论今后之事．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [227]=function()
 if JY.Tid==64 then--孙乾
 JY.Status=GAME_SMAP_AUTO;
talk(64,"主公，袁绍派来一名快使，请你马上去白马城．",
 1,"可是现在关羽和张飞还都没有找到，我担心得不得了，那里还有心思去白马城．",
 64,"我了解您的心情．可是……");
talk(65,"主公，既然如此担心的话，我去找关羽和张飞吧．",
 1,"噢，那就快点去吧．",
 65,"我马上就去．");
 MovePerson(65,8,1);
 JY.Status=GAME_SMAP_MANUAL;
 --显示任务目标:<去白马城见袁绍．>
 NextEvent();
 end
 if JY.Tid==65 then--糜竺
talk(65,"主公，不用那么担心，关羽和张飞一定还在什么地方活着．");
 end
 end,
 [228]=function()
 if JY.Tid==64 then--孙乾
 JY.Status=GAME_SMAP_AUTO;
talk(64,"可是袁绍也请你马上就去，是什么事呢？主公，马上去白马城吧．",
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
talk(10,"是刘备吗，哼，你来得正好．");
 MovePerson(1,7,3);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [230]=function()
 if JY.Tid==51 then--沮授
talk(51,"颜良被关羽杀了．颜良是我军屈指可数的一员大将，对这一损失，你怎么说？");
 end
 if JY.Tid==93 then--郭图
talk(93,"你这个忘恩负义之徒，我主公对你有恩，你却勾结曹操．");
 end
 if JY.Tid==53 then--文丑
talk(53,"他妈的，竟敢杀我兄长！");
 end
 if JY.Tid==55 then--逢纪
talk(55,"你这个背信忘义之徒！");
 end
 if JY.Tid==103 then--张郃
talk(103,"你这个背信忘义之徒！");
 end
 if JY.Tid==92 then--审配
talk(92,"你这个背信忘义之徒！");
 end
 if JY.Tid==10 then--袁绍
 JY.Status=GAME_SMAP_AUTO;
talk(10,"哼！你还有脸来吗？",
 1,"到底是怎么回事呢？",
 10,"别装傻了，杀颜良的是不是你的部下关羽？",
 1,"那真是关羽吗？",
 10,"我的部下说，敌将是一个长髯的家伙．这不正是关羽吗？你在勾结曹操啊！快承认勾结的事吧！杀颜良的是关羽吧？");
 local menu={
 {" 是，那人是关羽",nil,1},
 {" 不，那不是关羽",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,M_White,M_White);
 if r==2 then
talk(10,"什么，你说不是关羽？",
 1,"是的，第一，我不知道关羽现在是否还活着．第二，只说有长髯，那不见得就是关羽啊！",
 10,"你说的也是．也许是个貌似关羽的武将．啊，刘备，不该对你发脾气．对不起．",
 1,"哪里，我不介意．",
 10,"让你大老远来一趟，对不起，你回邺城好好地休息一下吧．");
 PlayBGM(5);
 --显示任务目标:<回到邺城官邸．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 else
talk(10,"哼！招认倒是很老实啊，但你是个傻瓜，来人，把这个背信忘义的小人给我拉出去斩啦．");
 PlayBGM(4);
 DrawMulitStrBox("　刘备被杀了，*　刘备重振汉室声威的梦想也同时破灭了．");
 --游戏失败:
 NextEvent(999); --Goto 999
 end
 end
 end,
 [231]=function()
 if JY.Tid==51 then--沮授
talk(51,"主公……");
 end
 if JY.Tid==93 then--郭图
talk(93,"你骗不了我，颜良哪是那么简单就被无名武将杀死之人？");
 end
 if JY.Tid==53 then--文丑
talk(53,"呀，刘备，刚才怀疑你对不起．");
 end
 if JY.Tid==55 then--逢纪
talk(55,"主公……");
 end
 if JY.Tid==103 then--张郃
talk(103,"好像有些不自然呀，是不是因为心情的关系？请不要介意．");
 end
 if JY.Tid==92 then--审配
talk(92,"主公……");
 end
 if JY.Tid==10 then--袁绍
 JY.Status=GAME_SMAP_AUTO;
talk(10,"你回邺城好好休息吧．");
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
talk(64,"主公，大喜事，就在刚才，一直没有消息的糜竺和糜芳来了．");
 MovePerson(1,6,0);
 --显示任务目标:<与孙乾等谈论今后之事．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [233]=function()
 if JY.Tid==64 then--孙乾
talk(64,"主公，大喜事，就在刚才，一直没有消息的糜竺和糜芳来了．");
 end
 if JY.Tid==82 then--糜芳
talk(82,"我们也在那次交战中得以侥幸逃生，听说主公在这里，我们就来了．");
 end
 if JY.Tid==83 then--简雍
 JY.Status=GAME_SMAP_AUTO;
talk(83,"主公，终于见到您了．可是，关羽不在吗？",
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
talk(64,"颜良被人杀了的事，我在想，就是关羽杀的．");
 end
 if JY.Tid==82 then--糜芳
 JY.Status=GAME_SMAP_AUTO;
talk(82,"嗯？主公，好像是使者．");
 AddPerson(365,3,20,0);
 MovePerson(1,0,1);
 MovePerson(365,5,0);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 if JY.Tid==83 then--简雍
talk(83,"因为我没有看清楚，所以也不敢说是关羽杀的．");
 end
 end,
 [235]=function()
 if JY.Tid==64 then--孙乾
talk(64,"又是袁绍派来的吧？这次有什么事呢？");
 end
 if JY.Tid==82 then--糜芳
talk(82,"主公，听使者讲吧．");
 end
 if JY.Tid==83 then--简雍
talk(83,"主公，先听使者讲吧．");
 end
 if JY.Tid==365 then--使者
 JY.Status=GAME_SMAP_AUTO;
talk(365,"我是主公袁绍派来的使者．在白马一战，文丑被敌人杀死．主公现在回到了邺城，有事请刘备，请马上去邺城的议事厅．那么我告辞了．");
 MovePerson(365,8,1);
 DecPerson(365);
talk(64,"步颜良后尘，这次文丑也被杀了．听说文丑比颜良还要厉害．能杀死这样武将的恐怕……",
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
talk(64,"主公，请您一定要多加小心．");
 MovePerson(1,9,1);
 NextEvent();
 end
 if JY.Tid==82 then--糜芳
talk(82,"我们在这里等着主公回来．");
 end
 if JY.Tid==83 then--简雍
talk(83,"可是关羽为什么要帮助曹操呢？");
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
talk(10,"来了啊，你这个骗子！我这次可不会再让你骗了．");
 MovePerson(1,8,1)
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [238]=function()
 if JY.Tid==51 then--沮授
talk(51,"这回不要狡辩了，因为我也亲眼看见了．");
 end
 if JY.Tid==93 then--郭图
talk(93,"这次文丑被杀，你怎样补偿这一损失？这场戏有的看了．");
 end
 if JY.Tid==55 then--逢纪
talk(55,"你这个骗子！还挺会装啊！");
 end
 if JY.Tid==92 then--审配
talk(92,"你这个骗子！还挺会装啊！");
 end
 if JY.Tid==103 then--张郃
talk(103,"你这个骗子！还挺会装啊！");
 end
 if JY.Tid==106 then--淳于琼
talk(106,"你这个骗子！还挺会装啊！");
 end
 if JY.Tid==10 then--袁绍
 JY.Status=GAME_SMAP_AUTO;
talk(10,"刘备，你到底还是私通曹操啊！连文丑也给杀了，招认吧，那员武将是不是关羽．");
 local menu={
 {" 这不妙，快逃吧",nil,1},
 {" 这是曹操的计谋",nil,1},
 {" 　不是关羽",nil,1},
 }
 local r=ShowMenu(menu,3,0,0,0,0,0,2,0,16,M_White,M_White);
 if r==1 then
 MovePerson(1,2,0)
talk(10,"刘备，想逃！谁去替我杀掉这个叛逆！",
 103,"我去！");
 MovePerson(103,2,0);
 MovePerson(103,4,3);
 MovePerson(103,0,1);
talk(103,"叛逆！你死定了．",
 1,"啊……！");
 DecPerson(1);
 PlayBGM(4);
 DrawMulitStrBox("刘备被杀了．刘备重振汉室声威的梦想也在此破灭了．");
 --游戏失败:
 NextEvent(999);
 elseif r==2 then
talk(10,"什么？这是曹操的计谋？",
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
talk(10,"胡说！这次是沮授在近处亲眼看到的．把这个大骗子给我拉下去砍了．");
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
talk(10,"刘备，接连怀疑你两次，真是对不起．快回官邸去休息吧．");
 MovePerson(1,10,0);
 NextEvent();
 end
 if JY.Tid==55 then--逢纪
talk(55,"虽然有点不通，但也就算了吧．");
 end
 if JY.Tid==92 then--审配
talk(92,"唉，是曹操的计谋？是真的吗？");
 end
 if JY.Tid==103 then--张郃
talk(103,"虽然有点说不通，唉，但也就算了吧．");
 end
 if JY.Tid==106 then--淳于琼
talk(106,"虽然有点说不通，唉，但也就算了吧．");
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
talk(64,"噢，主公，你没事吧，啊．糜竺回来了．");
 MovePerson(1,6,0);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [241]=function()
 if JY.Tid==64 then--孙乾
talk(64,"主公，糜竺回来了，听他汇报情况吧．");
 end
 if JY.Tid==65 then--糜竺
 JY.Status=GAME_SMAP_AUTO;
talk(65,"主公，我回来了．关羽是在曹营．我设法和他联系上了．他现在正离开许昌，向这里赶来．",
 1,"噢，是吗．",
 65,"另外，张飞在离此不太远的南面古城，据说是和一伙山贼在一起，我和他没联系上．",
 1,"是吗？张飞也没出事啊．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 if JY.Tid==82 then--糜芳
talk(82,"主公，我哥哥回来了，听他汇报情况吧．");
 end
 if JY.Tid==83 then--简雍
talk(83,"主公，糜竺回来了，听他汇报情况吧．");
 end
 end,
 [242]=function()
 if JY.Tid==64 then--孙乾
 JY.Status=GAME_SMAP_AUTO;
talk(64,"主公，我们既然已经知道了关羽和张飞的消息，就不要再在这里住下去了．可以向袁绍假称说是去也是他的地盘的汝南，然后我们去张飞落脚的古城．快去求袁绍吧．",
 1,"好吧．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 if JY.Tid==65 then--糜竺
talk(65,"关羽正朝这里赶来，但曹操一定会阻挠他．我们最好前去迎接他．");
 end
 if JY.Tid==82 then--糜芳
talk(82,"我们不能在这种地方长住．");
 end
 if JY.Tid==83 then--简雍
talk(83,"关羽、张飞都还活着啊．太好了！");
 end
 end,
 [243]=function()
 if JY.Tid==64 then--孙乾
 JY.Status=GAME_SMAP_AUTO;
talk(64,"我们就在这里等着你．");
 MovePerson(1,9,1);
 NextEvent();
 end
 if JY.Tid==65 then--糜竺
talk(65,"我们现在做出发准备．");
 end
 if JY.Tid==82 then--糜芳
talk(82,"我们不能在这种地方长住．");
 end
 if JY.Tid==83 then--简雍
talk(83,"关羽、张飞都还活着啊．太好了！");
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
talk(10,"啊，刘备，有什么事？");
 MovePerson(1,8,1)
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [245]=function()
 if JY.Tid==51 then--沮授
talk(51,"刘备，这次是什么事啊？");
 end
 if JY.Tid==93 then--郭图
talk(93,"刘备，这次是什么事啊？");
 end
 if JY.Tid==55 then--逢纪
talk(55,"刘备，怎么啦？");
 end
 if JY.Tid==92 then--审配
talk(92,"刘备，怎么啦？");
 end
 if JY.Tid==103 then--张郃
talk(103,"刘备，怎么啦？");
 end
 if JY.Tid==106 then--淳于琼
talk(106,"刘备，怎么啦？");
 end
 if JY.Tid==10 then--袁绍
 JY.Status=GAME_SMAP_AUTO;
talk(10,"刘备，怎么啦？",
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
talk(51,"可疑……");
 end
 if JY.Tid==93 then--郭图
talk(93,"可疑……");
 end
 if JY.Tid==55 then--逢纪
talk(55,"刘备，努力吧！");
 end
 if JY.Tid==92 then--审配
talk(92,"刘备，努力啊！");
 end
 if JY.Tid==103 then--张郃
talk(103,"刘备，努力啊！");
 end
 if JY.Tid==106 then--淳于琼
talk(106,"刘备，努力啊！");
 end
 if JY.Tid==10 then--袁绍
 JY.Status=GAME_SMAP_AUTO;
talk(10,"那就拜托了．");
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
talk(64,"主公，你回来啦．");
 MovePerson(1,6,0);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [248]=function()
 if JY.Tid==64 then--孙乾
 if talkYesNo( 64,"出发吗？") then
 RemindSave();
 PlayBGM(12);
talk(64,"说不定会遭到敌军侵袭．列好队伍．");
 ModifyBZ(54,8);
 LvUp(54,7);
 WarIni();
 DefineWarMap(16,"第二章 兖州之战","一﹑郭图的败退．*二﹑刘备到达西南的鹿砦．",45,0,92);
 -- id,x,y,d,ai --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,10,5,4,0,-1,0,
 -1,11,5,4,0,-1,0,
 -1,10,4,4,0,-1,0,
 -1,10,6,4,0,-1,0,
 -1,9,3,4,0,-1,0,
 -1,9,5,4,0,-1,0,
 -1,9,6,4,0,-1,0,
 -1,12,3,4,0,-1,0,
 -1,12,4,4,0,-1,0,
 53,29,7,3,0,-1,1,
 });
 ModifyForce(54,1);
 DrawSMap();
talk(64,"出发吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==65 then--糜竺
talk(65,"赶快去和关羽、张飞会合吧．");
 end
 if JY.Tid==82 then--糜芳
talk(82,"那么，向古城进发吧．可是，主公，军械等都买好了吗？");
 end
 if JY.Tid==83 then--简雍
talk(83,"随时可以出发．请主公也准备好．");
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
talk(93,"对刘备不加监视，让他随便去汝南吗？",
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
talk(65,"我们去张飞落脚的古城吧．古城从这里向南走．",
 1,"唉，真想见到张飞呀．");
 SetSceneID(0,11);
talk(93,"追刘备，决不能让他跑掉．");
 PlayWavE(11);
 DrawStrBoxCenter("被郭图率军追上！");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 92,0,7,4,3,26,2,0,0,-1,0,
 256,7,19,4,4,19,2,11,13,-1,0,
 257,2,4,4,3,19,2,0,0,-1,0,
 258,1,6,4,3,19,2,0,0,-1,0,
 292,1,9,4,1,19,8,0,0,-1,0,
 293,3,5,4,3,19,8,0,0,-1,0,
 328,0,8,4,1,19,13,0,0,-1,0,
 274,3,6,4,3,19,5,0,0,-1,0,
 275,2,5,4,3,18,7,0,0,-1,0,
 310,2,8,4,3,19,11,0,0,-1,0,
 336,8,19,4,4,19,15,11,14,-1,0,
 337,2,7,4,3,18,15,0,0,-1,0,
 102,1,7,4,3,23,22,0,0,-1,1,
 50,7,19,4,3,23,5,0,0,-1,1,
 ---
 294,7,18,4,1,19,8,0,0,-1,1,
 295,8,0,4,3,18,8,0,0,-1,1,
 296,2,6,4,3,19,7,0,0,-1,1,
 259,6,19,4,1,19,2,0,0,-1,1,
 260,9,0,4,3,18,2,0,0,-1,1,
 276,7,1,4,3,19,5,0,0,-1,1,
 277,6,2,4,3,18,4,0,0,-1,1,
 278,2,5,4,1,19,5,0,0,-1,1,
 311,8,19,4,3,19,11,0,0,-1,1,
 312,0,7,4,1,18,10,0,0,-1,1,
 329,0,8,4,1,19,13,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [251]=function()
 PlayBGM(11);
talk(93,"哼，我已看透了刘备是怎么想的了．刘备，你休想逃掉．",
 64,"主公，那是郭图的部队，好像我们被发现了．",
 65,"跑到这里，不能被他们抓住．主公先逃到西南的那个鹿砦去吧．到了那里，郭图就没有办法了．");
 WarShowArmy(54-1);
talk(54,"那不是刘皇叔吗？真是苍天有眼，没想到会在这种地方相见……好像是被人追赶，好，我马上去帮助刘皇叔．");
 WarShowTarget(true);
 PlayBGM(13);
 NextEvent();
 end,
 [252]=function()
 if WarMeet(54,103) then
 WarAction(1,54,103);
talk(54,"这不是张颌吗？",
 103,"你是赵云．公孙瓒已经死了，你也最好投降袁绍．",
 54,"谁还会去跟一个被我抛弃的人呢？袁绍是什么样的人，你到时候就会知道的……",
 103,"什么？你这个丧家之犬，听你胡说，我送你去见公孙瓒吧！");
 if fight(54,103)==1 then
talk(103,"不愧确有其名呀！",
 54,"你也不简单呀．",
 103,"……这次我就让你了，以后还会相遇的，赵云！");
 WarAction(16,103);
talk(54,"这样的人跟着袁绍，真是可惜！");
 WarLvUp(GetWarID(54));
 else
talk(103,"看招！");
 WarAction(8,103,54);
 WarAction(17,54);
 WarLvUp(GetWarID(103));
 end
 
 end
 if (not GetFlag(1018)) and War.Turn==5 then
talk(1,"啊？那是敌人的援军！？又来了．");
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
talk(103,"郭图，让你等急了吧．",
 93,"噢，张颌，你来得太好了，我们无论如何也要捉住刘备．");
 SetFlag(1018,1)
 end
 if WarCheckLocation(0,19,3) then
talk(93,"唉，让刘备在这里溜掉了，主公让刘备给算计了，大败仗呀！");
 WarGetExp(50);
 PlayBGM(7);
 DrawMulitStrBox("刘备军躲过郭图军的追击．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end 
 if JY.Status==GAME_WARWIN then
talk(93,"唉，让刘备在这里溜掉了，主公让刘备给算计了．");
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
talk(54,"刘皇叔，久违了．",
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
talk(54,"刘皇叔，请多指教．");
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
talk(1,"那么去见张飞吧．",
 65,"是，古城从这里向南走不远就是，快走吧．");
 SetSceneID(0);
talk(1,"什，什么？",
 83,"什么！有毛贼！",
 64,"这个时候偏又出现了毛贼．主公，迎战吧．",
 1,"列队．");
 WarIni();
 DefineWarMap(17,"第二章 古城之战","一、交战？？？．",40,0,373);
 -- id,x,y,d,ai --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,12,11,4,0,-1,0,
 -1,11,12,4,0,-1,0,
 -1,13,12,4,0,-1,0,
 -1,12,13,4,0,-1,0,
 -1,13,13,4,0,-1,0,
 -1,11,10,4,0,-1,0,
 -1,12,10,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 373,10,23,2,2,23,8,0,0,-1,0,
 310,9,21,2,0,19,11,0,0,-1,0,
 311,17,9,3,1,18,11,0,0,-1,0,
 312,18,10,3,1,18,11,0,0,-1,0,
 313,16,16,3,1,16,11,0,0,-1,0,
 314,15,17,3,1,15,10,0,0,-1,0,
 315,3,8,4,1,15,10,0,0,-1,0,
 316,3,15,4,1,16,11,0,0,-1,0,
 332,13,3,1,1,20,14,0,0,-1,0,
 333,3,14,4,1,19,14,0,0,-1,0,
 336,9,22,2,0,18,15,0,0,-1,0,
 337,14,3,1,1,18,15,0,0,-1,0,
 338,4,7,4,1,17,15,0,0,-1,0,
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
talk(83,"主公，我们好像被包围了．",
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
talk(374,"怎么看那些人很眼熟呢？……啊！",
 3,"喂，喽罗们，这支部队是我们自己人．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(15);
talk(374,"畜生，好厉害的家伙！那员大将是谁？嗯？怎么很眼熟呢？……啊！！",
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
talk(3,"对不起，又糊里糊涂地干了一件蠢事．",
 1,"事情过去了也就算了．那你这段时间是怎么过的．",
 3,"我占领了这座城，想率领毛贼们抗击曹操军，没想到大哥来了．大哥，对不起．",
 1,"不要那么难过了，张飞，这不像你．",
 3,"好啊，总之我们又在一起了，今后也要跟随大哥上刀山下火海在所不辞．");
 LvUp(3,3);
 ModifyForce(3,1);
 PlayWavE(11);
 DrawStrBoxCenter("张飞又回到刘备身边．");
talk(3,"大哥，进我们这个小破城看看吧．");
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
talk(3,"大哥，关羽怎么样啦？噢，……是这样啊．那么快出发吧．");
 end
 if JY.Tid==54 then--赵云
talk(54,"我恨不得马上见到关羽．");
 end
 if JY.Tid==83 then--简雍
talk(83,"关羽现在怎么样啦？");
 end
 if JY.Tid==82 then--糜芳
talk(82,"来到这里就不用担心袁绍的追兵啦．");
 end
 if JY.Tid==64 then--孙乾
 JY.Status=GAME_SMAP_AUTO;
talk(64,"我们先在这里整顿一下队伍，然后去迎接关羽……唉？是糜竺，怎么啦？");
 AddPerson(65,1,5,3);
 MovePerson(65,7,3);
talk(65,"主公，大事不好．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [261]=function()
 if JY.Tid==3 then--张飞
talk(3,"糜竺这家伙，怎么这么慌张？");
 end
 if JY.Tid==54 then--赵云
talk(54,"突然发生了什么事？");
 end
 if JY.Tid==64 then--孙乾
talk(64,"听糜竺讲吧．");
 end
 if JY.Tid==83 then--简雍
talk(83,"听糜竺讲吧．");
 end
 if JY.Tid==82 then--糜芳
talk(82,"主公，听我哥哥讲吧．");
 end
 if JY.Tid==65 then--糜竺
talk(65,"主公，不好啦！曹操军正直奔这里而来．现在已到达颖川．",
 1,"……现在去颖川迎击．众将士准备出发．");
 --显示任务目标:<准备迎击曹操军．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [262]=function()
 if JY.Tid==54 then--赵云
talk(54,"终于又能为主公打仗了．没有比这更叫我高兴的了．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"曹操军来到这里真是意外呀．去迎击吧．");
 end
 if JY.Tid==65 then--糜竺
talk(65,"关羽还没到，可是也没办法．");
 end
 if JY.Tid==83 then--简雍
talk(83,"主公，迎战吧！");
 end
 if JY.Tid==82 then--糜芳
talk(82,"主公，迎战吧！");
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
talk(3,"大哥，请快列好队．");
 LvUp(2,3);
 WarIni();
 DefineWarMap(18,"第二章 颖川之战","一、歼灭蔡阳．",30,0,152);
 -- id,x,y,d,ai --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,30,2,3,0,-1,0,
 -1,30,1,3,0,-1,0,
 -1,30,3,3,0,-1,0,
 -1,29,2,3,0,-1,0,
 -1,29,3,3,0,-1,0,
 -1,31,0,3,0,-1,0,
 -1,31,2,3,0,-1,0,
 -1,31,1,3,0,-1,0,
 
 1,1,1,1,0,-1,1,
 127,0,2,1,0,-1,1,
 154,2,0,1,0,-1,1,
 });
 DrawSMap();
 ShowScreen();
talk(3,"那么，迎战吧．又见到了大哥，绝不会败的．");
 ModifyForce(2,1);
 ModifyForce(128,1);
 ModifyForce(155,1);
 JY.Smap={};
 SetSceneID(0,3);
talk(65,"颖川在这古城的南面．那么去颖川吧．");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 152,2,13,4,0,25,2,0,0,-1,0,
 95,14,7,4,4,22,2,16,6,-1,0,
 96,3,13,4,0,21,2,0,0,-1,0,
 256,13,9,4,4,20,2,16,7,-1,0,
 274,3,12,4,0,20,5,0,0,-1,0,
 275,15,8,4,4,19,5,17,7,-1,0,
 276,9,10,4,0,18,5,0,0,-1,0,
 292,11,10,4,4,18,8,15,6,-1,0,
 293,7,11,4,0,17,8,0,0,-1,0,
 294,8,11,4,0,17,8,0,0,-1,0,
 310,12,8,4,4,20,11,18,7,-1,0,
 311,6,10,4,0,19,11,0,0,-1,0,
 328,9,12,4,0,19,13,0,0,-1,0,
 336,13,6,4,4,20,15,16,5,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [264]=function()
 PlayBGM(11);
talk(153,"那是刘备军呀．我蔡阳要让他们知道，与曹丞相为敌有多愚蠢．",
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
talk(153,"是关羽呀．关羽，你忘记了曹丞相的恩情，又跑回到刘备的身边，你是什么重义之人．",
 2,"我与曹操有约在先，只要知道我兄长活着，随时都可以离开曹操．你难道是说曹操不讲信用？",
 153,"什么！你敢侮辱曹丞相？杀！关羽我定要取你首级．");
 WarAction(5,153,2);
 if fight(2,153)==1 then
talk(153,"招！",
 2,"纳命来！");
 WarAction(8,2,153);
talk(153,"啊！");
 WarAction(18,153);
talk(2,"……虽说有约在先，但我却杀了他的部下．这次是我欠了曹操的．");
 WarLvUp(GetWarID(2));
 PlayBGM(7);
 DrawMulitStrBox("关羽杀了蔡阳，刘备军胜利了．");
 GetMoney(700);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金７００．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 else
talk(153,"招！");
 WarAction(8,153,2);
 WarAction(17,2);
 WarLvUp(GetWarID(153));
 end
 end
 if (not GetFlag(1019)) and War.Turn==8 then
 PlayBGM(12);
talk(153,"你们是什么人？");
 WarShowArmy(2-1);
 WarShowArmy(128-1);
 WarShowArmy(155-1);
talk(128,"父亲，那里好像在进行一场交战．",
 155,"是哪里的部队？",
 2,"嗯？那是……啊，那是兄长！还有张飞．呜……现在不是感情用事的时候，关羽来参战了．关平周仓跟我来．",
 128,"遵命！",
 155,"是！");
 DrawStrBoxCenter("关羽出现．");
 PlayBGM(9);
 SetFlag(1019,1)
 end
 if JY.Status==GAME_WARWIN then
talk(153,"你，你们……我的仇，曹丞相一定会替我报的．唉．");
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
talk(2,"……兄长，终于找到你了．我关羽以前虽身在曹营可是心一直在这里呀．太高兴了，还能相见，真像做梦一样．",
 1,"……关羽，没事最好．太好了，能平安回来．呜呜呜！",
 3,"……关羽，那两个人是谁？",
 2,"噢，刚才一急忘了说了．兄长，给你介绍一下他们二人．这个年轻人叫关平，这次有缘成为我的义子．");
 MovePerson(128,6,1);
talk(128,"我叫关平，是关羽将军的义子，请多指教．",
 2,"他叫周仓，这次也有缘成了我的部下，他原是占山的草寇，我在半路上把他收下．");
 MovePerson(155,6,1);
talk(155,"皇叔幸会，我叫周仓，我虽曾占山为寇，但内心却是光明磊落的．");
 PlayWavE(11);
 DrawStrBoxCenter("关羽回到刘备身边！");
 PlayWavE(11);
 DrawStrBoxCenter("关平与周仓成为刘备部下．");
talk(54,"大家都回来了，可喜可贺，可是我们去哪里呢？",
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
talk(3,"大哥，去找曹操报仇吧！汝南的刘辟好像与曹操为敌，我们去汝南跟曹操作战吧．");
 end
 if JY.Tid==54 then--赵云
talk(54,"主公，该去哪里呢？");
 end
 if JY.Tid==128 then--关平
talk(128,"主公，请多指教．");
 end
 if JY.Tid==155 then--周仓
talk(155,"我愿意跟随主公，请随意调遣．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"主公，去哪里呢？");
 end
 if JY.Tid==83 then--简雍
talk(83,"主公，去哪里呢？");
 end
 if JY.Tid==65 then--糜竺
talk(65,"主公，去哪里呢？");
 end
 if JY.Tid==82 then--糜芳
talk(82,"主公，去哪里呢？");
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
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,M_White,M_White);
 if r==1 then
talk(64,"去襄阳吗？那我作为使者先去，主公随后再来．");
 JY.Smap={};
 SetSceneID(0);
talk(64,"主公，刘表非常欢迎我们，还给我们这些辎重粮草，说让我们整顿军马用．");
 GetMoney(2000);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金２０００．");
talk(2,"对我们真是关心得无微不至呀．去见刘表吧．");
 NextEvent(278); --goto 278
 elseif r==2 then
talk(3,"去汝南吧．大哥，我带你们去．");
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
talk(248,"噢，刘皇叔，欢迎光临敝处．我是刘辟．");
 --显示任务目标:<与汝南刘辟商量今后之事．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [269]=function()
 if JY.Tid==248 then--刘辟
talk(1,"冒昧前来，对不起．",
 248,"哪里，请不要介意．听说刘备军来了．我军的士气也高涨了．在这里请不要有顾虑．");
 AddPerson(64,-1,22,0);
 MovePerson(64,8,0);
 MovePerson(1,0,1);
talk(64,"对不起，主公，我有点事要说．");
 NextEvent();
 end
 end,
 [270]=function()
 if JY.Tid==248 then--刘辟
talk(248,"请不要介意，你们讲吧．");
 end
 if JY.Tid==64 then--孙乾
 JY.Status=GAME_SMAP_AUTO;
talk(64,"主公，我想去襄阳刘表那里，跟他商量我们在危难时投靠他行不行．",
 1,"好，快去吧．见到刘表，和他好好讲讲．",
 64,"是．");
 MovePerson(64,8,1);
 DecPerson(64);
 ModifyForce(64,0);
 --显示任务目标:<城内散步．>
talk(248,"请先看一看城里吧．");
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
talk(54,"主公，刚才间谍报告说曹操打败了袁绍．",
 1,"什么？袁绍败了？兵力悬殊那么大却败了．唉，到底是曹操呀！",
 54,"袁绍虽然侥幸逃脱得以保全性命，但这样一来曹操的势力更加强大了．");
 PlayBGM(11);
 AddPerson(248,-1,22,0);
 MovePerson(248,8,0);
talk(248,"噢，皇叔，大事不好．");
 JY.Status=GAME_SMAP_MANUAL;
 --显示任务目标:<去议事厅，商量今后之事．>
 NextEvent();
 end,
 [272]=function()
 if JY.Tid==2 then--关羽
talk(2,"噢，大哥，不好了，你听刘辟细说吧．");
 end
 if JY.Tid==3 then--张飞
talk(3,"噢，大哥，不好了，你听刘辟细说吧．");
 end
 if JY.Tid==54 then--赵云
talk(54,"主公，不好了，详细情况请听刘辟讲吧．");
 end
 if JY.Tid==128 then--关平
talk(128,"主公，不好了，详细情况请听刘辟讲吧．");
 end
 if JY.Tid==83 then--简雍
talk(83,"主公，不好了，详细情况请听刘辟讲吧．");
 end
 if JY.Tid==65 then--糜竺
talk(65,"主公，不好了，详细情况请听刘辟讲吧．");
 end
 if JY.Tid==82 then--糜芳
talk(82,"主公，不好了，详细情况请听刘辟讲吧．");
 end
 if JY.Tid==248 then--刘辟
talk(248,"皇叔，曹操打败了袁绍之后又乘势朝这里杀来了．",
 1,"什么？曹操朝这里杀来？",
 248,"据间谍报告，好像曹操自己没来，主将是曹仁．",
 1,"快做出征准备．");
 --显示任务目标:<做迎战曹操军的准备．>
 NextEvent();
 end
 end,
 [273]=function()
 if JY.Tid==248 then--刘辟
talk(248,"我也做出征准备．");
 end
 if JY.Tid==3 then--张飞
talk(3,"怎么会呢？袁绍就这么轻易地败了．");
 end
 if JY.Tid==128 then--关平
talk(128,"快做出征准备．");
 end
 if JY.Tid==83 then--简雍
talk(83,"曹操军势力难以估量，光靠我们能抵挡得住吗？");
 end
 if JY.Tid==65 then--糜竺
talk(65,"主公，做迎战准备吧．");
 end
 if JY.Tid==82 then--糜芳
talk(82,"主公，做迎战准备吧．");
 end
 if JY.Tid==54 then--赵云
talk(54,"曹操军来的真是快．");
 end
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"出征吗？") then
 RemindSave();
 PlayBGM(12);
talk(2,"请列队！");
 WarIni();
 DefineWarMap(19,"第二章 汝南之战","一、曹仁败退．",40,0,18);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,20,1,1,0,-1,0,
 -1,19,2,1,0,-1,0,
 -1,21,2,1,0,-1,0,
 -1,18,0,1,0,-1,0,
 -1,20,0,1,0,-1,0,
 -1,21,0,1,0,-1,0,
 -1,22,1,1,0,-1,0,
 -1,21,3,1,0,-1,0,
 -1,19,1,1,0,-1,0,
 247,20,3,1,0,-1,0,
 230,18,1,1,0,-1,0,
 231,18,2,1,0,-1,0,
 63,17,0,1,0,-1,1,
 });
 ModifyForce(64,1);
 DrawSMap();
talk(2,"出征！");
 JY.Smap={};
 SetSceneID(0,11);
talk(19,"刘备，逃也没用！为了我主公将来着想，一定要杀死刘备！众将士！进军汝南！跟上！");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 18,2,16,4,4,28,2,7,2,-1,0,
 93,3,17,4,4,25,19,7,2,-1,0,
 78,33,16,2,1,25,8,0,0,-1,0,
 67,32,17,2,1,25,8,0,0,-1,0,
 77,4,16,4,4,25,5,20,11,-1,0,
 103,6,10,4,4,24,5,7,2,-1,0,
 17,4,12,4,4,25,22,7,2,-1,0,
 62,33,11,2,1,24,2,0,0,-1,0,
 172,4,15,4,4,24,5,20,11,-1,0,
 170,3,15,4,4,24,8,7,2,-1,0,
 274,33,15,2,1,21,5,0,0,-1,0,
 275,32,12,2,1,21,5,0,0,-1,0,
 276,3,10,4,4,21,5,7,2,-1,0,
 292,4,13,4,4,21,8,7,2,-1,0,
 293,4,11,4,4,20,8,7,2,-1,0,
 294,34,13,2,1,20,8,0,0,-1,0,
 295,33,12,2,1,21,8,0,0,-1,0,
 310,33,14,2,1,20,10,0,0,-1,0,
 311,5,16,4,4,21,11,20,11,-1,0,
 328,4,14,4,4,20,13,7,2,-1,0,
 336,5,15,4,4,21,15,20,11,-1,0,
 337,5,11,4,4,20,15,7,2,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [274]=function()
 PlayBGM(11);
talk(19,"刘备，还想逃吗？我岂能让你逃掉？我曹仁定要杀你．",
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
talk(54,"那人不是泛泛之辈．那员大将，我赵云要与你单挑较量．",
 68,"赵云？噢，听过他的大名．正中我的下怀．杀呀！");
 WarAction(6,54,68);
 if fight(54,68)==1 then
 WarAction(19,68);
talk(54,"真能打！",
 68,"赵云，今天难分胜负，我不跟你打了，我们改天再决胜负．");
 WarLvUp(GetWarID(54));
 else
 WarAction(19,54);
talk(54,"真能打！",
 68,"赵云，今天难分胜负，我不跟你打了，我们改天再决胜负．");
 WarLvUp(GetWarID(68));
 end
 SetFlag(76,1)
 end
 if (not GetFlag(1020)) and War.Turn==3 then
 PlayBGM(12);
 WarShowArmy(64-1);
 DrawStrBoxCenter("孙乾出现！");
talk(64,"主公，我来晚了，对不起．我跟刘表谈了，他说我们危难时可以去，现在请逃到西南的那个鹿砦．那个鹿砦是曹操和刘表的边界，逃到那里，敌军就不会再追来了．");
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
talk(1,"好！撤离战场，去襄阳．",
 19,"什么？刘备逃到了刘表的领地！？妈的……看来只好撤退了．");
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
talk(19,"没办法，早晚要撤军的．");
talk(1,"好，趁敌人还没增援，去襄阳吧．");
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
talk(64,"去襄阳吧．去襄阳从这里向南走．",
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
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"当然行，那么一起去襄阳吧．",
 248,"噢，谢谢．");
 ModifyForce(248,1);
 PlayWavE(11);
 DrawStrBoxCenter("刘辟成了刘备部下！");
 elseif r==2 then
talk(1,"不能带你走，你是个不喜欢受军队规矩约束的人．以后你还是自由自在地愿意做什么就做什么吧．那样你也幸福．",
 248,"……我知道了．既然是皇叔的愿望，就这么办吧．那么我以后就自由自在了．",
 1,"刘辟，谢谢你．");
 end
talk(64,"去襄阳吧．");
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
talk(95,"刘备，欢迎来到荆州．");
 MovePerson(1,5,0);
 --显示任务目标:<拜见刘表．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [280]=function()
 if JY.Tid==113 then--蔡瑁
talk(113,"首先应拜见我们的主公，希望你懂得礼仪．");
 end
 if JY.Tid==120 then--蒯越
talk(120,"刘皇叔，幸会．我叫蒯越，以后我们就认识了．");
 end
 if JY.Tid==95 then--刘表
 JY.Status=GAME_SMAP_AUTO;
talk(95,"你来到了这里，曹操再也不敢轻易对你轻举妄动啦．你放心来这里吧．……噢，我把儿子介绍给你．蒯越，去把刘琦和刘琮叫来．",
 120,"是．");
 MovePerson(120,3,1);
 MovePerson(120,2,3);
 MovePerson(120,9,1);
 DecPerson(120);
 AddPerson(115,-4,23,0);
 AddPerson(121,-2,24,0);
 MovePerson( 115,7,0,
 121,7,0);
talk(95,"刘备弟，他俩是我的儿子，这是刘琦，那是刘琮．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end
 end,
 [281]=function()
 if JY.Tid==113 then--蔡瑁
talk(113,"刘琦是前任夫人所生，刘琮是现任夫人，也就是我的妹妹所生．");
 end
 if JY.Tid==115 then--刘琦
talk(115,"初次见面，请多关照．听说您也姓刘，和我父亲是兄弟关系，那么您就是我的叔父啦．叔父请多关照．");
 end
 if JY.Tid==121 then--刘琮
talk(121,"初次见面，我叫刘琮．请多关照．");
 end
 if JY.Tid==95 then--刘表
talk(95,"刘备弟，请多关照我这两个儿子．对啦，刘备弟，你能否为我把守新野城．",
 1,"是新野城吗？",
 95,"城虽不大，是在荆州的最北面．希望刘备弟能在那里监视曹操的动向．",
 1,"好吧，您真是关怀得无微不至，谢谢．");
 --显示任务目标:<去新野城．>
 NextEvent();
 end
 end,
 [282]=function()
 if JY.Tid==113 then--蔡瑁
talk(113,"请你好好守住新野．不过听说你是刚刚从曹操那里逃出来的，我有些担心呀．");
 end
 if JY.Tid==115 then--刘琦
talk(115,"今后也请多加关照．");
 end
 if JY.Tid==121 then--刘琮
talk(121,"请多关照．");
 end
 if JY.Tid==95 then--刘表
talk(95,"新野在襄阳的最北面，那就托付给你啦．");
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
talk(2,"这就是我们的新城了，终于有落脚之地了．");
 --显示任务目标:<视察城内．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [284]=function()
 if JY.Tid==2 then--关羽
talk(2,"这就是我们的新城啊，还是有了自己的城心里踏实些．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，这回终于踏实下来了．");
 end
 if JY.Tid==54 then--赵云
talk(54,"在这里我们要开始新的生活了．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"主公，我们刚来到此地，还是先视察一下城里，了解一下情况吧．");
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
talk(114,"……嗯？那不是刘备吗？");
 MovePerson(114,2,3);
 MovePerson(114,5,0);
talk(114,"您是刘皇叔吗？听说您在城里我就找来了．我叫伊籍．我主刘表让我来帮助你．请多关照．",
 1,"你来了，太好了，我才要请你多关照呢．");
 ModifyForce(114,1);
 PlayWavE(11);
 DrawStrBoxCenter("伊籍成了刘备下属．");
talk(114,"有一件事想告诉您，荆州有一位称为水镜先生的雅士，请您务必见一见他．",
 1,"水镜先生？为什么要见他呢？",
 114,"水镜先生和许多名士有来往，他也许对皇叔会有所帮助．",
 1,"我明白了．伊籍，谢谢你．",
 114,"只是我不知道他住在哪里．",
 1,"好吧，我有时间去寻访一下他．");
talk(114,"那么，我现在去议事厅了．我还有话要对您讲．在议事厅见吧．");
 MovePerson(114,12,1);
 DecPerson(114);
 SetFlag(1022,1);
 end
 if JY.Tid==117 then--刘封
 MovePerson(117,5,2);
 MovePerson(117,2,0);
talk(117,"您是刘皇叔吗？我叫刘封，听说皇叔来到新野，特地前来投靠，请收容我吧．",
 1,"好！好好干吧！",
 117,"啊，谢谢！");
 ModifyForce(117,1);
 PlayWavE(11);
 DrawStrBoxCenter("刘封成了刘备部下．");
talk(117,"那么，我去议事厅了．");
 MovePerson(117,12,1);
 DecPerson(117);
 SetFlag(1023,1);
 end
 if JY.Tid==355 then--农民
talk(355,"水镜先生？水镜先生住在襄阳城．只是经常不在家呀．");
 SetFlag(1024,1);
 if GetFlag(1022) and GetFlag(1023) and GetFlag(1024) and GetFlag(1025) and GetFlag(1026) then
talk(1,"那么，去议事厅吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==359 then--旅客
talk(359,"听说袁绍好像死了，他的势力那么强大，都败给曹操了啊．");
 SetFlag(1025,1);
 if GetFlag(1022) and GetFlag(1023) and GetFlag(1024) and GetFlag(1025) and GetFlag(1026) then
talk(1,"那么，去议事厅吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==357 then--商人
talk(357,"刘表现在的夫人好像想立自己的亲生儿子刘琮为继承人，不过长子是刘琦呀．");
 SetFlag(1026,1);
 if GetFlag(1022) and GetFlag(1023) and GetFlag(1024) and GetFlag(1025) and GetFlag(1026) then
talk(1,"那么，去议事厅吧．");
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
talk(2,"听说这几个人是才来投靠兄长的．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，好像突然间多了些武将啊！");
 end
 if JY.Tid==54 then--赵云
talk(54,"即使多了武将，不经练兵也不管用．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"我觉得人才多了是好事！");
 end
 if JY.Tid==117 then--刘封
talk(117,"刘皇叔，请多关照．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"我主刘表好像最近有些烦恼．大概是由于江夏叛乱的事情．",
 1,"江夏叛乱？",
 114,"对，江夏城在荆州的最东面，由于最近出现了毛贼，搞得兵荒马乱．");
 NextEvent();
 end
 end,
 [289]=function()
 if JY.Tid==3 then--张飞
talk(3,"镇压叛乱啊，尽管我觉得用不着我出马就可以讨平，但我还是去吧！");
 end
 if JY.Tid==54 then--赵云
talk(54,"即使多了武将，不经练兵也不管用．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"我觉得人才多了是好事！");
 end
 if JY.Tid==117 then--刘封
talk(117,"江夏在荆州的最东面．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"据说最近江夏出现了毛贼．");
 end
 if JY.Tid==2 then--关羽
talk(2,"兄长，既然刘表是为此事烦恼，那我们就为他去掉这块心患吧．",
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
talk(3,"山贼啊？不是我的对手．");
 end
 if JY.Tid==54 then--赵云
talk(54,"敌人是毛贼．这些恶棍，我绝不饶恕他们！");
 end
 if JY.Tid==64 then--孙乾
talk(64,"主公，做出征准备！");
 end
 if JY.Tid==117 then--刘封
talk(117,"我绝不辜负您的期望，请看我的吧．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"谢谢你为我主刘表解忧．");
 end
 if JY.Tid==2 then--关羽
 if talkYesNo( 2,"兄长，准备好了吗？") then
 RemindSave();
 PlayBGM(12);
talk(2,"请列队！");
 WarIni();
 DefineWarMap(20,"第二章 江夏之战","一、歼灭张武．",40,0,117);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,1,3,4,0,-1,0,
 -1,2,3,4,0,-1,0,
 -1,1,4,4,0,-1,0,
 -1,2,5,4,0,-1,0,
 -1,3,5,4,0,-1,0,
 -1,3,3,4,0,-1,0,
 -1,2,2,4,0,-1,0,
 -1,1,1,4,0,-1,0,
 -1,0,2,4,0,-1,0,
 -1,0,6,4,0,-1,0,
 });
 DrawSMap();
talk(2,"出征．");
 JY.Smap={};
 SetSceneID(0,3);
talk(114,"刘皇叔是第一次去江夏吧，我替你们当响导．");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 117,30,18,3,2,27,11,0,0,-1,0,
 118,29,19,3,0,24,11,0,0,-1,0,
 310,29,17,3,0,22,11,0,0,-1,0,
 311,26,10,2,4,21,11,11,4,-1,0,
 312,27,14,2,4,21,11,11,4,-1,0,
 313,21,17,3,4,20,11,9,13,-1,0,
 314,23,16,3,4,20,11,9,13,-1,0,
 274,30,16,3,0,23,5,0,0,-1,0,
 275,28,11,2,4,23,5,11,4,-1,0,
 292,27,12,2,4,21,8,11,4,-1,0,
 293,23,17,3,4,21,8,9,13,-1,0,
 332,22,16,3,4,23,14,9,13,-1,0,
 333,27,11,2,4,23,14,11,4,-1,0,
 336,27,9,2,4,23,15,11,4,-1,0,
 337,20,18,3,4,23,15,9,13,-1,0,
 340,24,16,3,4,22,17,9,13,-1,0,
 341,25,17,3,4,20,17,9,13,-1,0,
 342,26,13,2,4,21,17,11,4,-1,0,
 141,29,2,3,2,30,3,0,0,-1,1,
 142,28,1,3,2,30,16,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [291]=function()
 PlayBGM(11);
talk(118,"刘表军又来了？这些混蛋．喽罗们！杀死他们．");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [292]=function()
 if WarMeet(3,119) then
 WarAction(1,3,119);
talk(3,"毛贼，休得猖狂，拿命来！",
 119,"啊？那家伙要和我决一死战？有意思，虽然不知来人是谁，就陪他打打吧．");
 WarAction(6,3,119);
 if fight(3,119)==1 then
 WarAction(8,3,119);
talk(119,"啊……！");
 WarAction(18,119);
talk(3,"嗤，什么对手！怎么一枪就死了？筋骨都还没松开．");
 WarLvUp(GetWarID(3));
 DrawStrBoxCenter("张飞占了上风！");
 else
 WarAction(4,119,3);
talk(3,"……");
 WarAction(17,3);
 WarLvUp(GetWarID(119));
 DrawStrBoxCenter("陈孙占了上风！");
 end
 end
 if WarMeet(54,118) then
 WarAction(1,54,118);
talk(118,"嗤，你们这些乌合之众，看看我的厉害吧！待我把那员大将斩落马下！",
 54,"嗯，朝这边来的那个是……，好像是毛贼首领，好！我来杀他！");
 WarAction(6,54,118);
 if fight(54,118)==1 then
 WarAction(8,54,118);
talk(118,"太厉害了……啊！");
 WarAction(18,118);
talk(54,"这匹马挺好的呀，牵回去吧．");
 WarGetItem(GetWarID(54),7);
 --WarLvUp(GetWarID(54));
 DrawMulitStrBox("刘备军歼灭了江夏毛贼．");
 NextEvent();
 else
 WarAction(4,118,54);
talk(54,"太厉害了！");
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
talk(118,"真的是刘备军吗？太厉害了……啊！");
 DrawMulitStrBox("刘备军歼灭了江夏毛贼．");
 NextEvent();
 end
 end,
 [293]=function()
 PlayBGM(11);
 WarShowArmy(142-1);
 WarShowArmy(143-1);
talk(142,"周瑜，那支部队是哪里的？我没听说过，刘表军里有这么厉害的人呀．",
 143,"看那人的样子好像是刘备．",
 142,"刘备？刘备不是有一段时间和曹操打得不相上下吗？那些毛贼打不过他们也在情理之中．",
 143,"我原想控制那些毛贼，使江夏归我东吴，可是有了这些人，江夏恐怕难以到手了．",
 142,"为了夺取荆州，我们还是回去重新研究一下对敌之策吧．",
 143,"遵命！");
 WarAction(16,142);
 WarAction(16,143);
talk(1,"那支部队是哪里的？好像不是毛贼呀．军旗上的字是什么？是”孙”？");
 PlayBGM(7);
 GetMoney(800);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金８００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end,
 [294]=function()
 SetSceneID(0,5);
talk(2,"兄长，要去通报刘表吧．我们先回新野等候兄长．",
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
talk(95,"刘备有什么事吗？");
 MovePerson(1,5,0);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [296]=function()
 if JY.Tid==113 then--蔡瑁
talk(113,"该不是出了什么事才来的吧？");
 end
 if JY.Tid==120 then--蒯越
talk(120,"刘备，怎么啦？");
 end
 if JY.Tid==122 then--文聘
talk(122,"刘备，怎么啦？");
 end
 if JY.Tid==123 then--王威
talk(123,"刘备，怎么啦？");
 end
 if JY.Tid==95 then--刘表
talk(95,"什么？你已经把江夏毛贼讨平啦！太辛苦了！山贼也很厉害呀！我的部队都感到棘手，真不愧是刘备呀！",
 1,"哪里，承蒙刘表兄关照，把新野城借给我用，我做这点小事也不足以报答您的恩情．",
 1,"另外有一件事请教一下．",
 95,"什么事？",
 1,"就在我们撤出江夏前，看见一支和毛贼无关的部队．大旗上写着”孙”字．",
 95,"什么？写着”孙”？噢……对了……",
 1,"是谁的部队？",
 95,"刘备弟，你来荆州时日尚浅，我来给你解释一下那个部队吧．");
 PlayBGM(11);
 DrawMulitStrBox("荆州处于三大势力的中间，北面是曹操，西面是益州，另一个就是东面的东吴．吴历代由孙氏一族治理，吴主是孙权．荆州多年来一直和吴有领土纠纷，孙权的父亲孙坚就死在刘表部下的手里．");
talk(95,"……情况就是这样．",
 1,"是这样啊．如此说来，那些毛贼作乱原来是孙权指使的．",
 95,"我这里有很长时间没发生事情了．……，刘备弟，我的领地对曹操也要留心些．你回新野好好休息一下吧．");
 PlayBGM(5);
 --显示任务目标:<回新野．>
 NextEvent();
 end
 end,
 [297]=function()
 if JY.Tid==113 then--蔡瑁
talk(113,"啊！干得不是很漂亮嘛，不过，这种讨伐我也做得了．");
 end
 if JY.Tid==120 then--蒯越
talk(120,"谢谢你们镇压了江夏叛乱．");
 end
 if JY.Tid==122 then--文聘
talk(122,"谢谢你们镇压了江夏叛乱．");
 end
 if JY.Tid==123 then--王威
talk(123,"谢谢你们镇压了江夏叛乱．");
 end
 if JY.Tid==95 then--刘表
talk(95,"回新野吧，在那里好好休养．");
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
talk(2,"兄长，刚才间谍报告说，曹操已并吞了袁绍．",
 1,"什么？曹操把袁绍也兼并了啊！");
 --显示任务目标:<与关羽商量．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [299]=function()
 if JY.Tid==2 then--关羽
talk(2,"大哥，刚才间谍报告说，曹操已并吞了袁绍．");
 end
 if JY.Tid==3 then--张飞
talk(3,"果然小小山贼不是我的对手呀．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"让刘表那么棘手的江夏反贼被刘备消灭了，刘备好厉害啊！");
 end
 if JY.Tid==64 then--孙乾
talk(64,"连袁绍也没能阻挡住曹操啊！");
 end
 if JY.Tid==83 then--简雍
talk(83,"现在能跟曹操对抗的也就只有刘表啦．");
 end
 if JY.Tid==54 then--赵云
talk(54,"啊，主公，好像有客人来．");
 AddPerson(115,0,5,3);
 MovePerson(115,7,3);
 NextEvent();
 end
 end,
 [300]=function()
 if JY.Tid==2 then--关羽
talk(2,"大哥，刘琦公子好像有话要说．");
 end
 if JY.Tid==3 then--张飞
talk(3,"刘琦公子专程来访，可能有什么事吧．");
 end
 if JY.Tid==54 then--赵云
talk(54,"主公，先见刘琦吧．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"是刘琦公子呀，有什么事吧．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"主公，先见刘琦吧．");
 end
 if JY.Tid==83 then--简雍
talk(83,"主公，先见刘琦吧．");
 end
 if JY.Tid==115 then--刘琦
talk(115,"叔叔，我要去江夏．我们暂时要分开了．我这次是特意来和你们告别的．",
 1,"谢谢你专程来一趟．",
 115,"以后有什么事的话，也请跟我商量一下．那么我告辞了．");
 MovePerson(115,8,2);
 DecPerson(115);
 NextEvent();
 end
 end,
 [301]=function()
 if JY.Tid==2 then--关羽
talk(2,"听说刘琦公子在自己和刘琮公子谁是继承人的问题上很苦恼，是不是也因为这个才去江夏呢？");
 end
 if JY.Tid==3 then--张飞
talk(3,"江夏是我替他们平定的啊．");
 end
 if JY.Tid==54 then--赵云
talk(54,"刘琦公子好像有些笑逐颜开了啊，好像已没有苦恼了．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"刘皇叔，我刚才在城里见到了水镜先生．请你去见见水镜先生吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==64 then--孙乾
talk(64,"伊籍以前就一直提水镜先生，到底是谁呢？");
 end
 if JY.Tid==83 then--简雍
talk(83,"主公，到外面去散散心如何？");
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
talk(382,"呕，你是刘皇叔吗？",
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
talk(1,"关羽，张飞，现在去隆中．",
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
talk(54,"你们早点回来，我来留守．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"你们早点回来，既然是水镜先生推荐的，一定是相当了不起的人，是隆中？就是襄阳西南的一个村子．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==64 then--孙乾
talk(64,"早点回来．");
 end
 if JY.Tid==83 then--简雍
talk(83,"早点回来．");
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
talk(2,"这就是那个孔明住的房子？",
 3,"那么了不起的人，住在这种地方？",
 2,"兄长，先问问那个童子吧．")
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [306]=function()
 if JY.Tid==2 then--关羽
talk(2,"问问童子吧．");
 end
 if JY.Tid==3 then--张飞
talk(3,"问问童子吧．");
 end
 if JY.Tid==381 then--童子
talk(381,"你们是谁？",
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
talk(2,"兄长，我们回新野吧．");
 MovePerson( 2,0,2,
 3,0,2);
 DecPerson(2);
 DecPerson(3);
 NextEvent();
 end
 if JY.Tid==3 then--张飞
talk(3,"好不容易才来这里一趟，他却不在，大哥，孔明不会有什么了不起的．算了吧．");
 end
 if JY.Tid==381 then--童子
talk(381,"我一定转告先生说新野的刘备来过了．");
 end
 end,
 [308]=function()
 if JY.Tid==381 then--童子
talk(381,"先生还没有回来呀．");
talk(381,"我一定转告先生说新野的刘备来过了．");
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
talk(112,"当今之～社会");
 MovePerson(112,4,0);
talk(112,"乱之～又乱");
 MovePerson(112,4,2);
talk(112,"我在等～待～拯救社会～之人．");
 MovePerson(112,4,1);
talk(112,"我～虽～有才～．");
 MovePerson(112,2,3);
talk(112,"却无～人～用我．");
talk(3,"大哥，那家伙怎么回事？是否有些奇怪？",
 1,"不，唱这歌是有意吸引人．莫非他就是水镜先生说的伏龙或凤雏？",
 3,"说什么呢？不可能是．",
 1,"不对，肯定是．好，跟他说说看．");
 MovePerson(1,3,1);
talk(1,"那位先生．");
 MovePerson(112,3,0);
talk(112,"哎，有什么事？",
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
talk(3,"啊！他们走了．喂，二哥，最近大哥是不是有些奇怪？",
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
talk(9,"袁绍已被歼灭了，这次该攻打荆州了吧．曹仁，你先率兵试探刘备的实力，然后决定我们是否出征．",
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
talk(54,"主公，这个人是孔明吗？",
 1,"不是，他叫徐庶．据说与水镜先生是好友．");
 MovePerson(112,3,3);
talk(112,"主公，您知道孔明吗？",
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
talk(54,"请早回来．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"如果水镜先生推荐的话，那绝对不会有错．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"请早点回来．");
 end
 if JY.Tid==83 then--简雍
talk(83,"请早点回来．");
 end
 if JY.Tid==112 then--徐庶
talk(112,"请一定要把孔明带回来．");
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
talk(2,"这就是那个孔明住的房子？",
 3,"那么了不起的人，住在这种地方？",
 2,"兄长，先问问那个童子吧．")
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [314]=function()
 if JY.Tid==2 then--关羽
talk(2,"这次会不会在呢？");
 end
 if JY.Tid==3 then--张飞
talk(3,"啊，我这次不来就好了．……啊，大哥，脸色别那么吓人哪．");
 end
 if JY.Tid==380 then--诸葛均
talk(1,"……读书如此聚精会神，好像一点都没注意到我们，此人一定是孔明．");
 end
 if JY.Tid==381 then--童子
talk(381,"啊，是新野的刘皇叔啊，请稍等一下，先生今天在．");
 MovePerson(381,4,3);
 MovePerson(381,4,0);
talk(381,"先生，新野的刘皇叔来了．",
 380,"嗯……？哦，刘皇叔．");
 MovePerson(380,1,1);
 MovePerson( 380,3,1,
 381,3,1);
 MovePerson( 380,3,2,
 381,3,2);
talk(380,"刘皇叔，欢迎光临．");
 NextEvent();
 end
 end,
 [315]=function()
 if JY.Tid==2 then--关羽
talk(2,"这就是孔明吗？怎么看上去像是个农民啊．");
 end
 if JY.Tid==3 then--张飞
talk(3,"什么？这是孔明？他是孔明的话，徐庶肯定比他聪明多了．");
 end
 if JY.Tid==380 then--诸葛均
talk(380,"您是来找家兄的吧．",
 1,"嗯？那先生不是卧龙先生了？",
 380,"是的，我是他的弟弟诸葛均．我们共兄弟三人，长兄诸葛瑾在东吴为官，我是最小的弟弟，孔明是我二哥．",
 1,"卧龙先生不在这里？",
 380,"啊，他还没回来．哥哥一旦出门，我们都不知道他什么时候回来．对不起．",
 1,"是吗，又没能见到面．");
 NextEvent();
 end
 if JY.Tid==381 then--童子
talk(381,"唉，好像不是先生．");
 end
 end,
 [316]=function()
 if JY.Tid==2 then--关羽
talk(2,"又白跑一趟，没办法，回去吧．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，快回去．累死了．");
 end
 if JY.Tid==380 then--诸葛均
talk(1,"能否请您把这封信交给卧龙先生．",
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
talk(381,"请慢走．");
 end
 end,
 [317]=function()
 if JY.Tid==380 then--诸葛均
talk(380,"哥哥还没回来，对不起．",
 1,"请您一定把信交给他．我告辞了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==381 then--童子
talk(381,"先生还没回来，他去哪了呢．");
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
talk(112,"主公，刚得到消息，曹操军正奔这里来．",
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
talk(2,"曹操命曹仁为主将，据说现在率大军已到南阳．");
 end
 if JY.Tid==3 then--张飞
talk(3,"这次我们也兵多将广啦，不能像以前那样让他们占便宜．");
 end
 if JY.Tid==54 then--赵云
talk(54,"消灭袁绍后的目标就是荆州吧，曹操的慾望没有止境．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"我们坚守新野吧．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"应该快做出征准备．");
 end
 if JY.Tid==83 then--简雍
talk(83,"因为我们面对的是曹操军，所以必须做好充份的准备．");
 end
 if JY.Tid==112 then--徐庶
talk(112,"此次作战，是我表现谋略的好机会，请您一定带我同去．",
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
talk(2,"请列好部队．");
 WarIni();
 DefineWarMap(21,"第二章 南阳之战","一、曹仁败退",40,0,18);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,2,0,4,0,-1,0,
 111,2,2,4,0,-1,0,
 -1,3,3,4,0,-1,0,
 -1,1,3,4,0,-1,0,
 -1,4,2,4,0,-1,0,
 -1,0,2,4,0,-1,0,
 -1,3,1,4,0,-1,0,
 -1,1,1,4,0,-1,0,
 -1,1,0,4,0,-1,0,
 -1,0,0,4,0,-1,0,
 });
 DrawSMap();
talk(2,"好，向南阳进发．");
 JY.Smap={};
 SetSceneID(0,3);
talk(112,"主公，去南阳吧．");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 18,21,9,3,2,30,3,0,0,-1,0,
 19,19,8,3,2,27,24,0,0,-1,0,
 172,19,10,3,2,27,5,0,0,-1,0,
 123,12,6,3,1,26,11,0,0,-1,0,
 124,12,11,3,1,26,11,0,0,-1,0,
 115,18,9,3,2,27,2,0,0,-1,0,
 256,14,7,3,2,25,2,0,0,-1,0,
 257,14,11,3,2,25,2,0,0,-1,0,
 258,14,4,3,2,24,2,0,0,-1,0,
 259,14,14,3,2,24,2,0,0,-1,0,
 260,17,4,2,2,23,2,0,0,-1,0,
 261,17,14,1,2,23,2,0,0,-1,0,
 262,20,4,2,2,23,2,0,0,-1,0,
 263,20,14,1,2,23,2,0,0,-1,0,
 274,12,7,3,1,25,5,0,0,-1,0,
 275,12,10,3,1,25,5,0,0,-1,0,
 276,16,8,3,2,24,5,0,0,-1,0,
 277,16,10,3,2,22,5,0,0,-1,0,
 278,17,7,3,2,22,5,0,0,-1,0,
 279,17,11,3,2,23,5,0,0,-1,0,
 292,16,6,3,2,23,8,0,0,-1,0,
 293,16,12,3,2,22,8,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 if JY.Tid==3 then--张飞
talk(3,"这次我们也兵多将广啦，不能像以前那样让他们占便宜．");
 end
 if JY.Tid==54 then--赵云
talk(54,"消灭袁绍后的目标就是荆州吧，曹操的慾望没有止境．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"我们坚守新野吧．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"应该快做出征准备．");
 end
 if JY.Tid==83 then--简雍
talk(83,"因为我们面对的是曹操军，所以必须做好充份的准备．");
 end
 if JY.Tid==112 then--徐庶
talk(112,"这次请看我的．");
 end
 end,
 [321]=function()
 PlayBGM(11);
talk(19,"嚄，来了啊．我们恭候多时了．吕旷，先去试试敌人的实力．",
 124,"遵命！",
 19,"其余部队不要动！耐心引诱敌人，等敌人一汇集到面前，就狠狠地打！明白了吗！");
talk(1,"好，全面出击！！",
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
talk(3,"曹操军狗贼！我这次可不让你们好过！我来杀你！",
 125,"那是张飞啊，传说他很厉害，我去试试看！");
 WarAction(6,3,125);
 if fight(3,125)==1 then
talk(125,"……！不好，这样下去会输的！没想到会这样厉害．",
 3,"现在知道已经晚了！送你上西天！");
 WarAction(8,3,125);
talk(125,"啊……！");
 WarAction(18,125);
 WarLvUp(GetWarID(3));
 else
 WarAction(4,125,3);
talk(3,"……");
 WarAction(17,3);
 WarLvUp(GetWarID(125));
 end
 end
 if WarMeet(54,124) then
 WarAction(1,54,124);
talk(54,"那位大将！我来战你！",
 124,"那不是赵云吗？……在这里如能一展雄风，我的大名岂不远扬啦．好！赵云，我吕旷战你．");
 WarAction(6,54,124);
 if fight(54,124)==1 then
talk(54,"看枪！！");
 WarAction(8,54,124);
talk(124,"啊……！");
 WarAction(18,124);
 WarLvUp(GetWarID(54));
 else
 WarAction(4,124,54);
talk(54,"太厉害了！");
 WarAction(17,54);
 WarLvUp(GetWarID(124));
 end
 end
 if GetFlag(138) then
 
 elseif between(JY.Death,257,262) then
 SetFlag(138,2);
 PlayBGM(11);
talk(19,"嚄，来吧！刘备！好，全军总攻击！消灭刘备军！");
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
talk(19,"什么！刘备军怎么会知道破阵法！？不好！如果他们突破了那里，我们就不能进行有力反击！！",
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
talk(19,"他妈的……！没料到会是这样！全军，撤退！！");
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
talk(2,"呀，我算折服徐庶了，这仗打得太漂亮了．",
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
talk(2,"兄长，你在吗？正好，徐庶好像有话要对兄长讲．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [326]=function()
 if JY.Tid==2 then--关羽
talk(2,"徐庶好像有话要对兄长讲．");
 end
 if JY.Tid==3 then--张飞
talk(3,"徐庶，把你刚才的话也讲给我大哥听吧．");
 end
 if JY.Tid==54 then--赵云
talk(54,"徐庶好像有话要对主公讲．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"徐庶好像有话要对主公讲．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"徐庶好像有话要对主公讲．");
 end
 if JY.Tid==83 then--简雍
talk(83,"徐庶好像有话要对主公讲．");
 end
 if JY.Tid==112 then--徐庶
talk(112,"其实，我收到了母亲的一封信，信上说，她老人家被曹操掳走了．",
 1,"什么！",
 112,"母亲很寂寞，我想马上就去见她．虽然很难启齿，但请准许我离开．",
 1,"徐庶，没有什么能比过母子感情了，你马上去看望令堂吧，我们也许还能见面．",
 112,"主公，呜呜……谢谢了！");
 NextEvent();
 end
 end,
 [327]=function()
 if JY.Tid==2 then--关羽
talk(2,"徐庶，再见了！");
 end
 if JY.Tid==3 then--张飞
talk(3,"徐庶对母亲尽孝吧！");
 end
 if JY.Tid==54 then--赵云
talk(54,"虽然相处时间很短，但很快乐．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"好不容易水镜先生介绍他来同辅刘备，太可惜了．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"徐庶是个俊杰，太可惜了．");
 end
 if JY.Tid==83 then--简雍
talk(83,"唉，是个大损失呀．");
 end
 if JY.Tid==112 then--徐庶
talk(112,"主公，谢谢了．我将在帝都祝大家一帆风顺．呜呜……再见．");
 MovePerson(112,7,2);
 NextEvent();
 end
 end,
 [328]=function()
 if JY.Tid==2 then--关羽
talk(2,"兄长，你舍不得徐庶离去，我很理解．可是这是命啊，你想开点．");
 end
 if JY.Tid==3 then--张飞
 DrawMulitStrBox("主公！！");
talk(3,"嗯？这不是徐庶的声音吗？");
 MovePerson(112,10,3);
 NextEvent();
 end
 if JY.Tid==54 then--赵云
talk(54,"失去了一个人才，我很体谅主公的心情．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"好不容易水镜先生介绍他来同辅刘备，太可惜了．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"徐庶是个人才，是很可惜呀．");
 end
 if JY.Tid==83 then--简雍
talk(83,"唉，是个大损失呀．");
 end
 if JY.Tid==112 then--徐庶
talk(112,"主公，谢谢了．我将在帝都祝大家一帆风顺．呜呜……再见．");
 end
 end,
 [329]=function()
 if JY.Tid==2 then--关羽
talk(2,"徐庶为什么又回来了？");
 end
 if JY.Tid==3 then--张飞
talk(3,"徐庶，到底是怎么回事？");
 end
 if JY.Tid==54 then--赵云
talk(54,"徐庶，怎么啦？");
 end
 if JY.Tid==114 then--伊籍
talk(114,"徐庶，怎么啦？");
 end
 if JY.Tid==64 then--孙乾
talk(64,"徐庶，怎么啦？");
 end
 if JY.Tid==83 then--简雍
talk(83,"徐庶，怎么啦？");
 end
 if JY.Tid==112 then--徐庶
talk(112,"我，我刚才一惊慌，有一件事忘了跟主公讲了．",
 1,"是什么事？",
 112,"请您一定要请孔明来．如果孔明能为主公效力，起的作用要远比我大．",
 1,"明白了．即使是为回报你惦记我们的这片心意，我也一定要说服孔明．",
 112,"好，那么主公请多保重．");
 MovePerson(112,10,2);
 DecPerson(112);
 ModifyForce(112,0);
talk(1,"好，徐庶既然如此推荐，肯定不会有错的．关羽、张飞去隆中．",
 3,"哎，还要去呀！",
 1,"唉？张飞，你好像不服气啊．",
 3,"当然了，这已经是第三次了．");
 NextEvent();
 end
 end,
 [330]=function()
 if JY.Tid==2 then--关羽
talk(2,"兄长已经去了两次，是不是有些过份了，孔明该不是在躲避兄长吧．");
 end
 if JY.Tid==3 then--张飞
talk(3,"像孔明这样的乡巴佬不可能是人才，大哥就不要去了，我去把他给你带来．",
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
talk(54,"我只是听从主公的吩咐，如果主公觉得需要孔明，就按主公想的那样办好了．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"是水镜先生，还有徐庶极力推荐的，我想不会有错．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"如果比徐庶都强，那么，应该是个了不起的人才，可是究竟是不是真的呢？");
 end
 if JY.Tid==83 then--简雍
talk(83,"唉，的确需要有一个接替徐庶的人才呀．");
 end
 end,
 [331]=function()
 if JY.Tid==54 then--赵云
talk(54,"这已是第三次去隆中了．",
 1,"哪怕十次百次也要请到孔明．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==114 then--伊籍
talk(114,"请一定要见到卧龙先生．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"等着听好消息．");
 end
 if JY.Tid==83 then--简雍
talk(83,"请早点回来．");
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
talk(2,"今天好像在家啊．呀，孔明是个什么样的人物呢？看看再说吧．");
 end
 if JY.Tid==3 then--张飞
talk(3,"哼，孔明太可恶了．我今天可要剥掉他的皮．");
 end
 if JY.Tid==381 then--童子
talk(381,"呀，刘皇叔，欢迎欢迎．",
 1,"孔明先生在家吗？",
 381,"唉，现在正在午睡．我去叫醒他吧．",
 1,"不要，让他继续睡吧，我在这里等着．");
 NextEvent();
 end
 end,
 [334]=function()
 if JY.Tid==2 then--关羽
talk(1,"你们去外面等着，我在这里等．",
 2,"知道了．喂，张飞，去外面．",
 3,"是是．");
 MovePerson( 2,0,2,
 3,0,2);
 DecPerson(2);
 DecPerson(3);
 NextEvent();
 end
 if JY.Tid==3 then--张飞
talk(3,"孔明这个家伙，在睡觉吗？也太没礼貌了，我去叫醒他．",
 1,"张飞，站住！不得无礼．",
 3,"嘿，知道了，我不说了．");
 end
 if JY.Tid==381 then--童子
talk(381,"真的可以不用叫醒吗？",
 1,"唉，你不要介意．",
 381,"嗯……．");
 end
 end,
 [335]=function()
 if JY.Tid==381 then--童子
talk(381,"哎呀，刘皇叔，我还没打扫呢．我可以去清扫吗？",
 1,"啊，当然可以．你去打扫吧，不要介意．",
 381,"那么失陪了．");
 MovePerson(381,6,3);
 NextEvent();
 end
 end,
 [336]=function()
 if JY.Tid==381 then--童子
talk(381,"哎呀，刘皇叔，我还没打扫完呢．");
 MovePerson(381,3,0);
 NextEvent();
 end
 end,
 [337]=function()
 if JY.Tid==381 then--童子
talk(381,"哎呀，刘皇叔，我还没打扫完呢．");
 MovePerson(381,6,1);
 NextEvent();
 end
 end,
 [338]=function()
 if JY.Tid==381 then--童子
 MovePerson(1,5,3);
talk(1,"唉，好像还没醒啊．就凭这大大方方睡觉的样子，此人一定是个了不起的人物．");
 AddPerson(3,7,10,3);
 MovePerson(3,3,3);
talk(3,"这家伙还装睡？我没法忍了．我去给他房子点一把火，看他还睡不睡！");
 AddPerson(2,5,11,3);
talk(2,"张飞，不许乱来！");
 MovePerson(2,3,3);
talk(2,"你太性急了，老实待着．张飞，还是听兄长的吧．",
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
talk(381,"哎呀，刘皇叔，我还没打扫完呢．");
 MovePerson(381,6,2);
 NextEvent();
 end
 end,
 [340]=function()
 if JY.Tid==381 then--童子
talk(381,"哎呀，刘皇叔，我还没打扫完呢．");
 MovePerson(381,6,3);
 NextEvent();
 end
 end,
 [341]=function()
 --talk( 381,"唉，刘备去哪呢？");
 if JY.Tid==381 then--童子
talk(381,"啊，刘皇叔，我打扫完了．");
talk(126,"来人？",
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
talk(126,"是谁在那里？是什么俗人来了吧．",
 381,"那是刘皇叔．",
 126,"什么？为什么不早叫醒我？",
 381,"可刘皇叔不让我叫醒您．",
 126,"我知道了．");
 MovePerson(126,2,1);
 MovePerson(126,2,2);
talk(126,"啊，刘皇叔，虽说是不知大驾光临．但刚才午睡实在失礼，对不起．啊，请进！");
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
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(126,"唉，对您说些什么呢？");
 elseif r==2 then
talk(126,"您几次降尊屈驾到我这里来，我觉得应该对你有所回报．");
 elseif r==3 then
talk(126,"昨天我看过您的信，深深为刘皇叔救国忧民的志向所感动，可是我年少无知，恐怕无助于您．",
 1,"哪里．水镜先生和徐庶都极力向我推荐你，他们不会错的．",
 126,"他们都是优秀的人物，而我不过是一介书生，谈论天下大事实在无能为力．",
 1,"大丈夫抱经世奇才，却把青春空守山野．这实在太可惜了，请你一定下山帮助我．",
 126,"刘皇叔，我就告诉你用自己的力量对抗曹操的办法吧．");
 NextEvent();
 elseif r==4 then
talk(126,"刘皇叔，为何突然哭了．无论如何请你抬起头来．");
 end
 end,
 [344]=function()
 local menu={
 {"　 发问",nil,1},
 {"　 听说",nil,1},
 {"　 说服",nil,1},
 {"　 哭泣",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"对抗曹操的办法，你是说我也能对抗曹操？",
 126,"是的，这是我回报您三顾茅庐的礼物．");
 NextEvent();
 elseif r==2 then
talk(126,"好吗？请您听好．");
 elseif r==3 then
talk(126,"……．");
 elseif r==4 then
talk(126,"刘皇叔，为何突然哭了．无论如何请你抬起头来．");
 end
 end,
 [345]=function()
 local menu={
 {"　 发问",nil,1},
 {"　 听说",nil,1},
 {"　 说服",nil,1},
 {"　 哭泣",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(126,"我只是报答您的诚意，没有其它的想法．");
 elseif r==2 then
talk(126,"曹操占有天时与人和，拥有百万大军，你现在不能与他对抗．另外，东吴传孙氏三代，也很富强，你也不能马上与他抗衡．",
 126,"这荆州土地肥沃，交通便利，可以认为是上天赐与刘皇叔的．另外荆州西面的益州可以说成是自然的要塞，民富国强．",
 126,"你如取荆州和益州并加以巩固，就可以北抗曹操东拒孙权．",
 1,"你是说要三分天下？",
 126,"是的．要三分天下，需让曹操和孙权对抗．这就是三分天下之计谋．");
 NextEvent();
 elseif r==3 then
talk(126,"……．");
 elseif r==4 then
talk(126,"刘皇叔，为何突然哭了．无论如何请你抬起头来．");
 end
 end,
 [346]=function()
 local menu={
 {"　 发问",nil,1},
 {"　 听说",nil,1},
 {"　 说服",nil,1},
 {"　 哭泣",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"可是荆州刘表与益州刘璋都与我同宗，我不忍心夺他们的土地．",
 126,"哪里，刘表体弱多病，将不久于人世，刘皇叔继承其主位应不会有问题．另外，刘璋以暴君闻名，讨伐刘璋挽救百姓，理当受到感谢．");
 NextEvent();
 elseif r==2 then
talk(126,"要三分天下，需让曹操和孙权对抗．这就是三分天下之计谋．");
 elseif r==3 then
talk(1,"卧龙先生，能否请你辅佐我？",
 126,"我久耕农田矣，喜欢这样的生活．虽然您多次屈尊至此，但我还是不能与您同去．");
 elseif r==4 then
talk(126,"刘皇叔，为何突然哭了．无论如何请你抬起头来．");
 end
 end,
 [347]=function()
 local menu={
 {"　 发问",nil,1},
 {"　 听说",nil,1},
 {"　 说服",nil,1},
 {"　 哭泣",nil,1},
 }
 local r=ShowMenu(menu,4,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(126,"在这里晴耕雨读适合我的心性．");
 elseif r==2 then
talk(126,"我的话已经说完了．");
 elseif r==3 then
talk(126,"……．");
 elseif r==4 then
talk(1,"以我个人的才能，您刚才的话犹如一场梦．如果先生在隆中陡然过一辈子，那么万民将会怎样呢？我一想到这就……，呜呜……．",
 126,"明白了，只要刘皇叔矢志不移，我会全力辅佐的．");
 PlayBGM(7);
talk(1,"噢！你肯帮助我了．谢谢．");
 ModifyForce(126,1);
 AddPerson(380,2,9,3);
 MovePerson(380,4,3);
 MovePerson(380,1,0);
talk(380,"兄长，我回来了．");
 MovePerson(126,1,1);
talk(126,"均，我将辅佐刘皇叔一段时间，你要好好守着这里的田地．我功成名就之日就回来．",
 380,"明白了．");
 AddPerson(2,6,9,3);
 AddPerson(3,4,10,3);
 DrawSMap();
talk(3,"孔明能来，太好了．");
talk(2,"那么我们回新野吧．");
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
talk(9,"徐庶，听说此次刘备得到了孔明，孔明是个怎么样的人呢？",
 112,"孔明比我强一万倍，不，恐怕还要多．",
 9,"你是个能把曹仁当小孩戏弄的人，既然你这么说，那孔明大概是个了不起的人物啊．");
 MovePerson(17,4,3);
 MovePerson(17,2,1);
 MovePerson(17,3,2);
talk(17,"主公，您说什么呀．我愿南征取孔明首级献给您．",
 9,"哦，……好！趁此机会消灭刘备．",
 383,"这不可！");
 MovePerson(9,1,1);
 MovePerson(9,0,2);
talk(9,"陛下，你说什么？刘备是叛乱的逆贼，你反对讨伐他？",
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
talk(9,"夏侯惇，我代帝行令．你马上率兵消灭刘备．",
 17,"是！遵令！请您等着捷报吧！");
 MovePerson(17,13,3);
 DecPerson(17);
talk(112,"……．");
 JY.Smap={};
 SetSceneID(0);
talk(17,"刘备，我送你上西天啦！全军跟我前进！");
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
talk(2,"兄长，前去探听曹操军情的探子回来了．听听他怎么说吧．");
 --示任务目标:<与诸葛亮等探讨下一步怎么办．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [350]=function()
 if JY.Tid==2 then--关羽
talk(2,"前去探听曹操军情的探子回来了．听听他怎么说吧．");
 end
 if JY.Tid==3 then--张飞
talk(3,"最近曹操频频打过来，是不是又要攻过来了？");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"先听听探子的报告吧．");
 end
 if JY.Tid==54 then--赵云
talk(54,"士兵已训练好了，随时可以出征迎敌．");
 end
 if JY.Tid==128 then--关平
talk(128,"曹操是不是以前打了败仗就不敢来了？");
 end
 if JY.Tid==117 then--刘封
talk(117,"不打得曹仁屁滚尿流，也要打个曹操落花流水．");
 end
 if JY.Tid==369 then--武官
talk(369,"主公，有军情禀报．曹操军已出动，主将是夏侯惇，另外还有于禁、李典．");
 NextEvent();
 end
 end,
 [351]=function()
 if JY.Tid==2 then--关羽
talk(2,"形势可不好啊，怎么办？");
 end
 if JY.Tid==3 then--张飞
talk(3,"啊，形势危急．现在请孔明先生献点计谋啦．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"曹操军此次前来没有什么可怕的，只是……．",
 1,"只是？只是什么？",
 126,"只是恐怕关羽、张飞不服从我的命令，所以主公，我想求你一件事，把主公的令剑借我一用．");
 --显示任务目标:<准备出征迎击曹操军>
 NextEvent();
 end
 if JY.Tid==54 then--赵云
talk(54,"主公，应马上研究出对策来．");
 end
 if JY.Tid==128 then--关平
talk(128,"主公，怎么办？");
 end
 if JY.Tid==117 then--刘封
talk(117,"曹操派大军出动，怎么办？");
 end
 if JY.Tid==369 then--武官
talk(369,"曹操军的主将是夏侯惇，另外还有于禁、李典．");
 end
 end,
 [352]=function()
 if JY.Tid==2 then--关羽
talk(2,"这次我也赞成张飞的意见．");
 end
 if JY.Tid==3 then--张飞
talk(3,"孔明能靠得住吗？曹操军派大军进攻，应该是坚守城池．");
 if talkYesNo( 3,"大哥，坚守城池，怎么样？") then
 RemindSave();
 PlayBGM(12);
talk(3,"既然敌人来势凶猛，那我们就快编好部队吧．");
 WarIni();
 DefineWarMap(23,"第二章 新野I之战","一、夏侯惇败退．*二、诸葛亮夺取粮仓．",40,0,16);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,7,5,4,0,-1,0,
 125,10,6,4,0,-1,0,
 2,8,7,4,0,-1,0,
 -1,6,7,4,0,-1,0,
 -1,5,7,4,0,-1,0,
 -1,6,4,4,0,-1,0,
 -1,4,6,4,0,-1,0,
 -1,10,3,4,0,-1,0,
 -1,10,5,4,0,-1,0,
 -1,9,10,4,0,-1,0,
 -1,7,10,4,0,-1,0,
 });
 DrawSMap();
talk(3,"那就在新野迎击敌人吧．");
 JY.Smap={};
 SetSceneID(0,11);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 16,27,5,3,4,32,9,7,10,-1,0,
 129,24,6,3,4,29,2,7,10,-1,0,
 62,24,9,3,4,28,2,7,10,-1,0,
 115,25,1,3,2,28,2,0,0,-1,0,
 128,23,9,3,4,29,15,7,10,-1,0,
 79,25,8,3,4,29,24,7,10,-1,0,
 102,28,5,3,4,29,22,7,10,-1,0,
 348,28,4,3,4,25,19,7,10,-1,0,
 256,23,3,3,2,24,2,0,0,-1,0,
 257,26,6,3,4,25,2,7,10,-1,0,
 292,27,9,3,4,24,8,7,10,-1,0,
 293,25,5,3,4,25,8,7,10,-1,0,
 294,28,7,3,2,25,8,0,0,-1,0,
 
 274,25,3,3,2,24,5,0,0,-1,0,
 275,26,10,3,4,25,5,7,10,-1,0,
 276,28,8,3,4,25,5,7,10,-1,0,
 277,27,7,3,2,25,5,0,0,-1,0,
 278,23,4,3,4,24,5,7,10,-1,0,
 279,24,10,3,4,25,5,7,10,-1,0,
 328,29,6,3,4,25,13,7,10,-1,0,
 329,25,9,3,4,24,13,7,10,-1,0,
 78,1,5,4,1,29,8,0,0,-1,1,
 280,0,4,4,1,25,5,0,0,-1,1,
 281,0,5,4,1,25,5,0,0,-1,1,
 282,0,6,4,1,25,5,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent(356); --goto 356
 end
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"能否把令剑借我一用？") then
 RemindSave();
talk(126,"谢谢．");
 MovePerson(126,1,2);
 MovePerson(126,2,1);
 MovePerson(126,5,3);
 MovePerson(126,0,2);
talk(126,"在博望坡迎击敌人，诸将听令．");
 MovePerson(3,2,2);
 MovePerson(3,2,1);
 MovePerson(3,4,3);
talk(3,"我不想听你这黄毛小子的命令．",
 126,"住口，主公令剑在此．违令者斩！",
 3,"你这种家伙能斩得了我吗？");
 MovePerson(2,3,2);
 MovePerson(2,2,1);
 MovePerson(2,3,3);
talk(2,"张飞，这是兄长的宝剑．你现在违背命令，就等于违背了大哥．现在先打一打看看吧，打完后再说也不迟．",
 3,"好吧．哼，我先走了．");
 MovePerson( 2,12,2,
 3,12,2);
 PlayBGM(12);
talk(126,"关平，刘封．",
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
talk(126,"你们两人需如此如此……．",
 128,"是．",
 117,"明白了．");
 MovePerson( 128,9,2,
 117,9,2);
talk(126,"主公，已对各位将军下达了作战命令．");
 WarIni();
 DefineWarMap(22,"第二章 博望坡之战","一、夏侯惇败退．",40,0,16);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,0,14,4,0,-1,0,
 125,0,13,4,0,-1,0,
 53,19,9,4,0,-1,0,
 -1,2,9,4,0,-1,0,
 -1,1,10,4,0,-1,0,
 -1,1,11,4,0,-1,0,
 -1,2,11,4,0,-1,0,
 -1,1,12,4,0,-1,0,
 2,11,3,1,0,-1,1,
 1,11,14,2,0,-1,1,
 154,12,15,2,0,-1,1,
 82,10,3,1,0,-1,1,
 116,12,5,1,0,-1,1,
 127,13,13,2,0,-1,1,
 });
 DrawSMap();
talk(126,"出兵！");
 JY.Smap={};
 SetSceneID(0,3);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 16,36,13,3,0,33,8,0,0,-1,0,
 129,32,13,3,0,29,2,0,0,-1,0,
 62,35,14,3,0,28,2,0,0,-1,0,
 115,36,11,3,0,28,2,0,0,-1,0,
 128,37,10,3,0,29,15,0,0,-1,0,
 274,35,11,3,0,26,5,0,0,-1,0,
 275,39,13,3,0,26,5,0,0,-1,0,
 276,33,10,3,0,27,5,0,0,-1,0,
 277,33,14,3,0,27,5,0,0,-1,0,
 278,34,10,3,0,28,5,0,0,-1,0,
 279,36,10,3,0,28,5,0,0,-1,0,
 292,37,14,3,0,27,8,0,0,-1,0,
 293,34,13,3,0,27,8,0,0,-1,0,
 294,33,12,3,0,28,8,0,0,-1,0,
 295,37,12,3,0,28,8,0,0,-1,0,
 296,38,13,3,0,29,8,0,0,-1,0,
 256,32,12,3,0,27,2,0,0,-1,0,
 257,34,11,3,0,27,2,0,0,-1,0,
 336,35,12,3,0,27,15,0,0,-1,0,
 328,38,11,3,0,29,13,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent(); --goto 353
 end
 end
 if JY.Tid==54 then--赵云
talk(54,"不管怎么说，现在必须马上准备迎击敌人．");
 end
 if JY.Tid==128 then--关平
talk(128,"我看最好是坚守新野．");
 end
 if JY.Tid==117 then--刘封
talk(117,"准备好了吗？");
 end
 if JY.Tid==369 then--武官
talk(369,"曹操军的主将是夏侯惇，另外还有于禁、李典．");
 end
 end,
 [353]=function()
 PlayBGM(11);
talk(126,"那么，赵云把夏侯惇引到这里．据说夏侯惇虽然勇猛，但有些轻视敌人．所以他会冲过来的，你利用这点把他引到中心来．不可暴露我们的意图．",
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
talk(2,"那位大将不像是等闲之辈，敢与我关羽单挑较量！",
 116,"啊，关羽！好，来吧．");
 WarAction(6,2,116);
 if fight(2,116)==1 then
talk(2,"你不是我的对手，给我滚开！",
 116,"我滚，我滚．");
 WarAction(16,116);
 WarLvUp(GetWarID(2));
 else
 WarAction(4,116,2);
talk(2,"……");
 WarAction(17,2);
 WarLvUp(GetWarID(116));
 end
 end
 if WarMeet(54,129) then
 WarAction(1,54,129);
talk(54,"夏侯兰！你怎么会在这！",
 129,"子龙，不用多说，来吧．");
 WarAction(6,129,54);
 if fight(54,129)==1 then
talk(54,"再打下去，你也没有获胜的希望．怎么样，投降吧！",
 129,"……明白了，我愿为刘备效力．");
 ModifyForce(129,1);
 PlayWavE(11);
 DrawStrBoxCenter("夏侯兰加入我方！");
talk(129,"不过，我现在不想打了．",
 54,"好吧，你先撤退．");
 JY.Person[129]["道具1"]=0;
 JY.Person[129]["道具2"]=0;
 WarAction(16,129);
 WarLvUp(GetWarID(54));
 else
talk(54,"……");
 WarAction(16,54);
 WarLvUp(GetWarID(129));
 end
 end
 if (not GetFlag(1028)) and (not GetFlag(139)) and War.Turn==10 then
 PlayBGM(11);
talk(130,"夏侯惇将军，刚才先头部队禀报，敌人准备用火攻．",
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
talk(126,"什么，火计被识破了！？唉，再早一点诱敌过来就好了……．",
 1,"怎么回事．",
 126,"这样就没办法了．战局虽然不利也只好从正面击退敌军了．");
 WarShowArmy(2-1);
 WarShowArmy(155-1);
 WarShowArmy(83-1);
 WarShowArmy(3-1);
talk(2,"这场战争可能很艰难……．",
 3,"我早就说不能相信孔明，你还不让我说．");
 PlayBGM(9);
 SetFlag(1028,1)
 end
 if (not GetFlag(140)) and (not GetFlag(1028)) and WarCheckArea(-1,9,26,12,31) then
talk(17,"唉，看见敌人了！就逗一逗你们，好，全军出击！",
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
talk(126,"好！刘封、关平，放火！");
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
talk(17,"噢噢！怎么回事，敌人要用火攻！不好！");
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
talk(2,"好！一鼓作气消灭敌人！");
 WarShowArmy(83-1);
 WarShowArmy(3-1);
talk(3,"孔明，成功了！好！全军，杀向曹操军！",
 1,"噢，孔明果然名不虚传啊！",
 126,"哪里，雕虫小技而已．现在趁敌人混乱之际，彻底打垮它．");
 PlayBGM(9)
 SetFlag(139,1);
 end
 if (not GetFlag(1029)) and GetFlag(139) and War.Turn==15 then
talk(17,"妈的，这样下去岂不是一直被动挨打．大家马上行动！各部队分别就近向敌人进攻！");
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
talk(17,"唉，竟败给刘备小儿．撤退！");
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
talk(3,"太好了，曹操军来吧！",
 2,"唉，不过孔明真了不起！",
 3,"……是啊．没办法，服他了．",
 126,"张飞，你说什么？",
 3,"嗯，没、没有．我什么也没说过．",
 126,"是吗．夏侯惇虽然败退，但曹操必定前来，我们不能不注意．");
 elseif GetFlag(1028) then
talk(3,"太好了，曹操军他们来吧！",
 2,"唉，尽管这次火攻不顺利，但孔明仍不失为神机妙算之人啊．",
 3,"是啊，火攻失败好像也不是他的责任．",
 54,"实在惭愧……．",
 3,"哈哈哈！好了好了！我就算服孔明了．",
 126,"张飞，你说什么？",
 3,"嗯，没、没有．我什么也没说过．",
 126,"是吗．夏侯惇虽然败退，但曹操必定前来，我们不能不注意．");
 else
talk(3,"喂，大哥，我都没仗可打了．",
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
talk(17,"哼，即使固若金汤也没有什么！进军新野！",
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
talk(3,"好，我要给大哥看看这时侯没有孔明一样打胜仗．那位大将！我和你决一死战！",
 63,"哎，你是何人？好，就杀你立功！");
 WarAction(6,3,63);
 if fight(3,63)==1 then
talk(3,"哇啊！");
 WarAction(8,3,63);
talk(63,"这、这是……！",
 3,"知道我张飞长矛的厉害了吧！",
 63,"什么！你是张飞啊！我打不过你！逃吧！");
 WarAction(16,63);
talk(3,"啊，被他逃掉了．");
 WarLvUp(GetWarID(3));
 else
 WarAction(4,63,3);
talk(3,"……");
 WarAction(17,3);
 WarLvUp(GetWarID(63));
 end
 end
 if WarMeet(54,129) then
 WarAction(1,54,129);
talk(54,"夏侯兰！你怎么会在这！",
 129,"子龙，不用多说，来吧．");
 WarAction(6,129,54);
 if fight(54,129)==1 then
talk(54,"再打下去，你也没有获胜的希望．怎么样，投降吧！",
 129,"……明白了，我愿为刘备效力．");
 ModifyForce(129,1);
 PlayWavE(11);
 DrawStrBoxCenter("夏侯兰加入我方！");
talk(129,"不过，我现在不想打了．",
 54,"好吧，你先撤退．");
 JY.Person[129]["道具1"]=0;
 JY.Person[129]["道具2"]=0;
 WarAction(16,129);
 WarLvUp(GetWarID(54));
 else
talk(54,"……");
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
talk(1,"唉，敌人出现了．"); --DOS版为17夏侯惇，但是感觉怪怪的，改为1刘备
 WarShowArmy(79-1);
 WarShowArmy(281-1);
 WarShowArmy(282-1);
 WarShowArmy(283-1);
 DrawStrBoxCenter("敌人援军来了！");
talk(79,"哦，夏侯惇将军，敌人不好对付呀！",
 17,"哼，怎么会呢！你过来干什么？");
 SetFlag(1031,1);
 end
 if (not GetFlag(1032)) and War.Turn==30 then
talk(17,"什么！粮草已尽？唉，仗拖得太长了……．唉，没办法，撤退！");
 WarAction(16,17);
 SetFlag(1032,1);
 NextEvent();
 end
 if (not GetFlag(75)) and WarCheckArea(125,0,22,6,31) then
talk(17,"什么？一部分敌人去夺我们的粮草了！唉，现在岂能撤兵！全军进行总攻击，在敌人夺我粮草前拿下新野城！");
 WarModifyAI(274,1);
 WarModifyAI(277,1);
 WarModifyAI(294,1);
 WarModifyAI(256,1);
 WarModifyAI(115,1);
 SetFlag(75,1);
 end
 if (not GetFlag(65)) and WarCheckLocation(125,0,29) then
talk(126,"禀报主公，敌人粮草已被我们全部夺得．",
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
talk(3,"喂，孔明这家伙，真的夺了敌人的粮草呀．",
 2,"唉，孔明真了不起啊．",
 3,"是啊，没办法，服他啦．",
 126,"张飞，你说什么了？",
 3,"嗯，我说过什么吗？没、没有我什么也没说过．",
 126,"是吗．不过，主公，这次夏侯惇败退了，可是曹操一定会来的．我们不能轻敌啊．");
 else
talk(3,"太好啦，曹操军他们来吧！",
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
talk(17,"我口出狂言出征败战而回，请处罚我吧．",
 9,"胜败乃兵家常事，赦你无罪．但是，让刘备这样下去的话对我们今后不利，好，全军出征！先消灭刘备，然后再讨伐孙权．");
 MovePerson(17,3,3);
 MovePerson(17,3,0);
 MovePerson(17,4,2);
 MovePerson(17,0,1);
 AddPerson(367,35,22,2);
 MovePerson(367,8,2);
talk(367,"丞相，一个自称是荆州使者的人前来求见．",
 9,"什么？是荆州的使者？叫他进来．",
 367,"是．");
 MovePerson(367,10,3);
 DecPerson(367);
 AddPerson(135,35,22,2);
 MovePerson(135,8,2);
talk(135,"拜见丞相，不胜荣幸．我是荆州使者宋忠……",
 19,"废话少说，有话快讲！",
 135,"是、是．我们荆州无意与丞相作对．",
 69,"什么？",
 135,"我们荆州向丞相投降，襄阳城拱手相送．",
 9,"唉，是吗．呀，使者辛苦了．回去告诉他们，送给我曹操的东西，我当然要收下了．",
 135,"是，是．那么我告辞了．");
 MovePerson(135,10,3);
 DecPerson(135);
talk(77,"主公，荆州比预想的还要容易就得到啦．",
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
talk(365,"向您禀报一件事．就在刚才，刘表去世了．",
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
talk(2,"快走！",
 135,"是，请饶我一命吧．");
 MovePerson( 2,4,3,
 135,4,3);
talk(2,"兄长，从军师那儿听说曹操马上要攻过来，我就出去巡视，发现这个家伙有些可疑．审问一下吧．");
 MovePerson( 2,3,0);
 MovePerson( 2,3,3);
 MovePerson( 2,0,1);
 --示任务目标:<与诸葛亮等讨论今后怎么办>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [362]=function()
 if JY.Tid==2 then--关羽
talk(2,"我出去巡视时，发现这个家伙有些可疑．审问一下吧．说什么他是荆州的使者．");
 end
 if JY.Tid==3 then--张飞
talk(3,"是荆州的使者？去哪里？是什么事？");
 end
 if JY.Tid==54 then--赵云
talk(54,"这个叫宋忠的家伙是关羽捉来的．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"是荆州的使者吗？你的事情我大概猜到了．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"审问这个家伙吧．");
 end
 if JY.Tid==128 then--关平
talk(128,"审问这个家伙吧．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"审问这个家伙吧．");
 end
 if JY.Tid==135 then--宋忠
talk(135,"请、请饶命．",
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
talk(2,"现在刻不容缓，最坏的情况是我们会受到曹操和蔡瑁的两面夹击．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，去拿下襄阳吧．刘表也死了，也没有什么可介意的事了．");
 end
 if JY.Tid==54 then--赵云
talk(54,"这是一件大事，再不采取紧急措施，就无可挽回了．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公，此时不能再讲体统了，要马上夺取襄阳，在襄阳抗拒曹操这才是上策．",
 1,"可是……，刘表那么关照我们，现在去打他的儿子……．孔明现在我们放弃新野，逃到刘琦管辖的江夏去，你看怎么样？",
 126,"那样还会受到曹操追赶．还不如夺取襄阳．嗯？主公，有快使来了．");
 AddPerson(365,-4,3,3);
 MovePerson( 365,10,3);
talk(365,"主公，有急事禀报！");
 NextEvent();
 end
 if JY.Tid==64 then--孙乾
talk(64,"主公，怎么办？");
 end
 if JY.Tid==128 then--关平
talk(128,"主公，怎么办？");
 end
 if JY.Tid==114 then--伊籍
talk(114,"为什么是刘琮继位而不是刘琦？对啦，是蔡瑁搞的鬼！");
 end
 if JY.Tid==135 then--宋忠
talk(135,"我、我只是被迫的．");
 end
 end,
 [364]=function()
 if JY.Tid==2 then--关羽
talk(2,"兄长，请听使者禀报．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，听使者讲吧．");
 end
 if JY.Tid==54 then--赵云
talk(54,"主公，请听使者禀报．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"先听使者禀报．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"主公，请听使者禀报．");
 end
 if JY.Tid==128 then--关平
talk(128,"主公，请听使者禀报．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"刘皇叔，这一定是蔡瑁搞的鬼，蔡瑁必遭天诛地灭．");
 end
 if JY.Tid==135 then--宋忠
talk(135,"我、我只是被迫的．");
 end
 if JY.Tid==365 then--使者
 PlayBGM(11);
talk(365,"禀报主公，曹操军已到博望坡．",
 54,"什么？已来到了那里？",
 126,"不管去哪里，大家都得准备啦．");
talk(126,"关羽和伊籍先去江夏一步，请求刘琦支援．",
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
talk(126,"其他人快做出发准备．");
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
talk(126,"那么主公也做出发准备吧．准备好的话告诉我一声．");
 --显示任务目标:<做迎战曹操的准备>
 NextEvent();
 end
 end,
 [365]=function()
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 PlayBGM(12);
talk(126,"被曹操追赶上就不好办了，快出发……嗯？");
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
talk(355,"刘皇叔，也带我们一起走吧．",
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
talk(126,"主公，今后我们必须摆脱曹操军的追击，若带着百姓，那样会妨碍我们行军打仗的．",
 1,"孔明，他们都仰慕我．我不能对他们弃而不管．",
 126,"好吧，那就带百姓们一起走吧．");
 JY.Smap={};
 SetSceneID(0,3);
talk(126,"我们进军襄阳还是江夏，请主公决定．");
 local menu={
 {"　去襄阳",nil,1},
 {"　去江夏",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
 SetSceneID(0);
talk(126,"请列队．");
 WarIni();
 DefineWarMap(24,"第二章 襄阳I之战","一、蔡瑁被杀．",20,0,112);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,9,22,2,0,-1,0,
 -1,8,22,2,0,-1,0,
 -1,10,22,2,0,-1,0,
 -1,8,21,2,0,-1,0,
 -1,10,21,2,0,-1,0,
 -1,7,22,2,0,-1,0,
 -1,12,22,2,0,-1,0,
 -1,11,21,2,0,-1,0,
 -1,7,20,2,0,-1,0,
 -1,7,23,2,0,-1,0,
 -1,9,20,2,0,-1,0,
 -1,10,20,2,0,-1,0,
 344,6,23,2,0,-1,0,
 345,9,23,2,0,-1,0,
 346,11,23,2,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 112,18,4,1,2,31,2,0,0,-1,0,
 121,14,9,3,2,28,8,0,0,-1,0,
 122,17,5,1,0,27,8,0,0,-1,0,
 119,17,6,3,0,28,5,0,0,-1,0,
 130,12,14,1,2,28,2,0,0,-1,0,
 133,15,8,3,0,27,13,0,0,-1,0,
 256,11,4,1,4,24,2,9,8,-1,0,
 257,10,14,1,2,24,2,0,0,-1,0,
 258,11,14,1,2,23,2,0,0,-1,0,
 274,15,10,3,0,24,5,0,0,-1,0,
 275,10,4,1,4,24,5,8,8,-1,0,
 276,9,14,1,2,24,5,0,0,-1,0,
 126,3,17,4,2,27,8,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent(); --goto 366
 elseif r==2 then
 SetSceneID(0,11);
talk(9,"不要让刘备逃走！一定捉住他！");
 SetSceneID(0);
talk(1,"孔明，我们好像被曹操追上了．",
 126,"没办法．那就在这里抵抗曹操吧，请列队．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(370); --goto 370
 end
 end
 end
 if JY.Tid==135 then--宋忠
talk(135,"我要一直留在这里吗？");
 end
 end,
 [366]=function()
 PlayBGM(11);
talk(113,"好吧，不要出城，赢得时间．反正刘备不能在这儿长待的．",
 126,"主公，此战必须尽快结束，如果来不及，就迅速退往江夏吧．");
 WarShowTarget(true);
 PlayBGM(17);
 NextEvent();
 end,
 [367]=function()
 if WarMeet(54,131) then
 WarAction(1,54,131);
talk(54,"你们为什么投降曹操？",
 131,"与你们无关．与曹操对抗就不能活，所以我们投降．",
 54,"这话不对．",
 131,"少罗嗦！你们这些混蛋！想夺荆州，找死！");
 WarAction(6,54,131);
 if fight(54,131)==1 then
talk(131,"厉、厉害……．",
 54,"拿命来！");
 WarAction(8,54,131);
talk(131,"唉呦……！");
 WarAction(17,131);
 WarLvUp(GetWarID(54));
 else
 WarAction(4,131,54);
talk(54,"厉害……．");
 WarAction(17,54);
 WarLvUp(GetWarID(131));
 end
 end
 if (not GetFlag(1033)) and War.Turn==15 then
 PlayBGM(11);
talk(126,"主公，刚才探子来急报，说曹操军已到新野．我们在这里再打下去的话，有受到前后夹击的危险．现在应马上撤往江夏．",
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
talk(127,"蔡瑁卖国之贼！刘使君救民而来，何得相拒！",
 127,"皇叔快快领兵入城，共杀卖国之贼！",
 3,"大哥！杀进去吧！");
talk(122,"大胆魏延，安敢造乱！认得我大将文聘么！");
 WarModifyAI(127-1,3,122-1);
 SetFlag(1034,1);
 end
 WarLocationItem(3,10,55,152); --获得道具:获得道具：茶
 WarLocationItem(8,5,153,153); --获得道具:获得道具：猛火书 改为 153筒袖铠
 WarLocationItem(3,16,10,154); --获得道具:获得道具：倚天剑
 if JY.Status==GAME_WARWIN then
talk(113,"刘备，荆州是不会交给你们的……．");
 PlayBGM(7);
 DrawMulitStrBox("杀死了蔡瑁，刘备军打败了蔡瑁军．");
 GetMoney(900);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金９００！");
 WarGetExp();
talk(126,"主公，虽杀了蔡瑁，但襄阳城已被烧得面目全非，如果曹操军杀到此城是守不住的我们去江夏吧．",
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
talk(1,"去江夏吧．");
 --储存进度:战场存盘
 SetSceneID(0);
talk(9,"不要让刘备逃掉！");
talk(1,"孔明，我们好像快被曹操追上了．",
 126,"没办法，那么我们抵挡曹操吧．请列好队．");
 NextEvent();
 end,
 [370]=function()
 WarIni();
 DefineWarMap(25,"第二章 长阪坡I之战","一、曹操的退兵．*二、民众逃至东南村．",70,0,8);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,21,13,4,0,-1,0,
 125,21,12,4,0,-1,0,
 -1,15,12,4,0,-1,0,
 -1,15,14,4,0,-1,0,
 -1,16,11,4,0,-1,0,
 -1,17,11,4,0,-1,0,
 -1,16,15,4,0,-1,0,
 -1,16,16,4,0,-1,0,
 -1,19,11,4,0,-1,0,
 -1,20,11,4,0,-1,0,
 -1,19,15,4,0,-1,0,
 -1,20,15,4,0,-1,0,
 344,20,12,4,0,-1,0,
 345,17,15,4,0,-1,0,
 346,18,16,4,0,-1,0,
 });
 ModifyForce(138,9);
 ModifyForce(139,9);
 ModifyForce(106,9);
 ModifyForce(122,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 8,3,3,1,0,42,9,0,0,-1,0,
 18,3,5,1,3,32,2,0,0,-1,0,
 115,8,12,4,3,31,2,344,0,-1,0,
 16,6,11,4,1,32,9,0,0,-1,0,
 17,7,12,4,1,32,22,0,0,-1,0,
 217,5,3,1,3,32,8,0,0,-1,0,
 79,5,8,4,3,32,24,0,0,-1,0,
 67,1,1,1,1,32,8,0,0,-1,0,
 140,2,2,1,3,31,15,345,0,-1,0,
 105,5,5,1,3,31,8,346,0,-1,0,
 135,4,2,1,0,31,12,0,0,-1,0,
 102,9,10,4,3,31,22,0,0,-1,0,
 137,6,6,1,3,31,11,345,0,-1,0,
 138,5,10,4,3,31,5,346,0,-1,0,
 
 19,7,10,4,3,31,24,344,0,-1,0,
 121,8,6,1,1,31,8,0,0,-1,0,
 292,6,9,4,3,28,8,0,0,-1,0,
 293,2,4,1,0,28,8,0,0,-1,0,
 294,8,8,4,3,27,8,0,0,-1,1,
 295,4,9,4,1,28,8,0,0,-1,1,
 296,6,7,4,1,28,8,0,0,-1,1,
 297,4,6,1,1,27,8,0,0,-1,1,
 310,18,4,1,3,27,11,344,0,-1,0,
 311,18,5,1,3,26,11,345,0,-1,0,
 312,17,6,1,3,25,11,346,0,-1,1,
 274,7,7,4,3,28,5,0,0,-1,1,
 275,5,4,1,3,28,5,345,0,-1,1,
 276,4,8,4,1,27,5,0,0,-1,1,
 
 386,3,4,1,3,36,15,8,0,-1,0,--典韦S
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [371]=function()
 PlayBGM(11);
talk(9,"哼，刘备，你已经走投无路了．全军向刘备军发动全面攻击．",
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
talk(136,"可是，带老百姓一起走，刘备在想什么呢？",
 9,"正因为如此，这个家伙很受百姓的仰慕，不愧是雄才大略的人．但是，带百姓一起逃跑……，太愚蠢了．好！我们前进．");
 WarModifyAI(8,3,0);
 WarModifyAI(135,3,344);
 WarModifyAI(293,3,0);
 SetFlag(1035,1);
 end
 if WarCheckLocation(344,22,32) then
 PlayBGM(7);
talk(1,"哦，先把百姓带到村里去，曹操不会追来了吧？",
 126,"马上就要追来了，这只是我们摆脱曹操的一计，我们快去江夏吧．");
 WarGetExp();
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 if WarCheckLocation(345,22,32) then
 PlayBGM(7);
talk(1,"哦，先把百姓带到村里去，曹操不会追来了吧？",
 126,"马上就要追来了，这只是我们摆脱曹操的一计，我们快去江夏吧．");
 WarGetExp();
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 if WarCheckLocation(346,22,32) then
 PlayBGM(7);
talk(1,"哦，先把百姓带到村里去，曹操不会追来了吧？",
 126,"马上就要追来了，这只是我们摆脱曹操的一计，我们快去江夏吧．");
 WarGetExp();
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
talk(9,"唉……，还追不上，不能让刘备逃掉！继续追！",
 1,"曹操退兵了吗？",
 126,"没有．还会马上追来的，这只是摆脱曹操的一个办法．我们快去江夏吧．");
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 end,
 [373]=function()
 WarIni2();
 DefineWarMap(26,"第二章 长阪坡II之战","一、曹操的退兵．*二、民众逃至西北桥上．",99,0,8);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm2(1,{
 0,25,17,3,0,-1,0,
 125,26,15,3,0,-1,0,
 -1,25,14,3,0,-1,0,
 -1,27,16,3,0,-1,0,
 -1,24,20,3,0,-1,0,
 -1,24,15,3,0,-1,0,
 -1,25,19,3,0,-1,0,
 -1,26,13,3,0,-1,0,
 -1,26,18,3,0,-1,0,
 -1,25,18,3,0,-1,0,
 -1,26,14,3,0,-1,0,
 -1,27,14,3,0,-1,0,
 344,25,16,3,0,-1,0,
 345,24,16,3,0,-1,0,
 346,24,18,3,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 8,27,1,1,0,42,9,0,0,-1,0,
 18,24,1,1,3,32,2,0,0,-1,0,
 115,26,2,1,0,31,2,0,0,-1,0,
 16,29,1,1,1,32,9,0,0,-1,0,
 17,29,0,1,1,32,22,0,0,-1,0,
 217,33,2,1,3,32,8,0,0,-1,0,
 79,32,0,1,3,32,24,0,0,-1,0,
 67,31,1,1,1,32,8,0,0,-1,0,
 140,26,0,1,0,31,15,0,0,-1,0,
 105,32,3,1,3,31,8,346,0,-1,0,
 135,23,0,1,3,31,12,344,0,-1,0,
 102,24,0,1,3,31,22,0,0,-1,0,
 137,27,3,1,3,31,11,345,0,-1,0,
 138,25,3,1,3,31,5,346,0,-1,0,
 
 19,30,3,1,3,31,24,344,0,-1,0,
 121,28,1,1,0,31,8,0,0,-1,0,
 292,34,0,1,3,30,8,0,0,-1,0,
 293,33,0,1,3,29,8,0,0,-1,0,
 294,32,1,1,3,28,8,0,0,-1,1,
 295,31,2,1,3,30,8,344,0,-1,1,
 296,30,2,1,3,29,8,345,0,-1,1,
 297,28,0,1,3,28,8,346,0,-1,1,
 298,28,2,1,1,30,7,0,0,-1,0,
 299,25,1,1,1,29,7,0,0,-1,0,
 300,22,0,1,1,28,7,0,0,-1,1,
 274,29,3,1,3,30,5,0,0,-1,1,
 275,30,0,1,3,29,5,345,0,-1,1,
 276,29,2,1,1,28,5,0,0,-1,1,
 
 386,27,2,1,3,36,15,8,0,-1,0,--典韦S
 });
 NextEvent();
 end,
 [374]=function()
 PlayBGM(11);
talk(1,"再向前走一会就看到长江了，无论如何要把百姓带到渡口，到了那里就会有船的．");
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
talk(54,"那可是有名的武将，我赵云与你较量！",
 136,"妈的……！");
 WarAction(6,54,136);
 if fight(54,136)==1 then
talk(54,"杀！");
 WarAction(8,54,136);
talk(136,"啊！");
 WarAction(18,136);
talk(54,"唉，敌人拿的剑是……？寒光四射呀，我借用一下吧．");
 WarGetItem(GetWarID(54),11);
 --WarLvUp(GetWarID(54));
 else
 WarAction(4,136,54);
talk(54,"太厉害了！");
 WarAction(17,54);
 WarLvUp(GetWarID(136));
 end
 end
 if WarMeet(1,122) then
 WarAction(1,1,122);
talk(122,"刘备！你跑不了了！",
 1,"背主之贼，尚有何面目见人！",
 122,"…………");
 WarAction(16,122);
 end
 if (not GetFlag(155)) and WarCheckArea(-1,17,17,22,19) then
talk(116,"听说是百姓和他们搅合在一起……．真不愧是刘备军啊，相当能打啊．",
 9,"现在不是从容不迫品论人物的时候，只有一条路，追，快追．");
 WarModifyAI(8,3,0);
 WarModifyAI(115,3,344);
 WarModifyAI(140,3,345);
 WarModifyAI(121,1);
 SetFlag(155,1);
 end
 if WarCheckLocation(344,10,0) then
 PlayBGM(7);
talk(1,"好啦！终于逃出来了，到了这里曹操军没船就没法子追了．我们快乘船去江夏吧．");
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
talk(1,"好啦！终于逃出来了，到了这里曹操军没船就没法子追了．我们快乘船去江夏吧．");
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
talk(1,"好啦！终于逃出来了，到了这里曹操军没船就没法子追了．我们快乘船去江夏吧．");
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
talk(9,"唉，竟还会有这么强的力量啊，没办法．停止追击吧．");
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
talk(115,"你好！叔叔，恭喜你平安到达．");
 ModifyForce(2,1);
 ModifyForce(114,1);
 LvUp(2,2);
 LvUp(114,2); --剧本原本只有关羽lv+2，伊籍是没有的
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [378]=function()
 if JY.Tid==2 then--关羽
talk(2,"兄长，恭喜你平安到达．没能派出援军，很抱歉．和刘琦公子，在这里迎接兄长的到来．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"请先见刘琦公子谈一谈．");
 end
 if JY.Tid==115 then--刘琦
talk(115,"长途跋涉到这里，一定很辛苦吧．暂时在这里谋求东山再起吧．",
 1,"刘琦，谢谢啦．",
 115,"哪里，想想你们以前对我的帮助，这点事算得了什么？嗯？是谁？");
 MovePerson(126,1,0);
 MovePerson(126,1,2);
 MovePerson( 126,0,3,
 1,0,3);
 AddPerson(367,39,24,2);
 MovePerson( 367,8,2);
talk(367,"打扰了，现在东吴派使者来吊唁，怎么办？",
 115,"什么，东吴派使者来吊唁？东吴与我一向不和，怎么会……，先叫使者进来吧．",
 367,"是！");
 MovePerson( 367,8,3);
 DecPerson(367);
 AddPerson(144,39,24,2);
 MovePerson( 144,8,2);
talk(144,"初次得见公子，我叫鲁肃．");
 NextEvent();
 end
 if JY.Tid==114 then--伊籍
talk(114,"刘备啊，我在这里迎接你，到这里就安全了．");
 end
 end,
 [379]=function()
 if JY.Tid==2 then--关羽
talk(2,"东吴使者此时来有什么事？");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公不用担心，这是东吴向主公探听曹操军情来了，我有一计．");
 end
 if JY.Tid==115 then--刘琦
talk(115,"现在说来吊唁有些奇怪，如果是吊丧，应该更早一点来．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"我们与东吴一向不和，现在为什么……．");
 end
 if JY.Tid==144 then--鲁肃
talk(1,"我是刘备．",
 144,"久闻皇叔大名，今有幸相见，实为欣慰．不过听说皇叔最近正与曹操会战，能否告诉我一些曹操军情？曹操实际上有多少兵力？");
 MovePerson( 126,1,3);
talk(126,"这个由我来回答吧．",
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
talk(2,"曹操发兵前来，吴国大概也很恐慌吧．");
 end
 if JY.Tid==126 then--诸葛亮
talk(1,"孔明你对鲁肃说了那样的话，难道你真的要去吗？",
 126,"请放心．从目前情况来看，能抗拒曹操的只有孙权．我去东吴，定叫孙权和曹操相争．",
 2,"可是我听说东吴有很多谋臣，万一军师有什么不测……．",
 126,"关羽，不必担心．主公，我一定说服孙权．那么告辞了．");
 MovePerson(126,10,3);
 DecPerson(126);
 MovePerson(1,0,2);
talk(115,"孔明先生真的不会有事吗？",
 1,"不知道．不过，孙权真被说服的话，我们才得以喘息，现在我们的未来大业也只有寄望孔明一试了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==115 then--刘琦
talk(115,"孔明可能有什么想法．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"孔明要去东吴，为他的性命担忧．");
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
talk(9,"哎！可恨的刘备，可恨的孙权．这个耻辱一定要加倍奉还，一定要加倍奉还．",
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
talk(143,"曹操军在赤壁之战打了败仗，已经很疲惫了．而我军打了胜仗，士气高涨．",
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
talk(2,"兄长，听到了吗？周瑜正攻打江陵，而且曹操现在不在江陵．");
 end
 if JY.Tid==3 then--张飞
talk(3,"但是，曹操这种人不吃点苦不知天高地厚，给他点颜色，他就老实了．");
 end
 if JY.Tid==54 then--赵云
talk(54,"赤壁之战，我军与孙权军曾联手抗曹，以后也保持这种关系吧．");
 end
 if JY.Tid==115 then--刘琦
talk(115,"叔父，实在对不起．最近我身体有点不太好．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"刘琦最近身体不太好，不要紧吧．");
 end
 if JY.Tid==128 then--关平
talk(128,"赤壁之战，曹操的兵力也削弱了些吧．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"曹操不在，在下认为正是夺取荆州的良机．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公，周瑜乘赤壁大胜之势，正要把荆州夺到自己手里．",
 1,"嗯……",
 126,"荆州已经不是刘表的地盘了，是曹操所有．夺取荆州作根本，是与曹操、孙权抗衡的唯一途径．",
 1,"……",
 126,"单凭此一城，无论曹操和孙权，都能把我们消灭乾净，主公，请下决心吧！",
 1,"既然如此，夺取荆州！",
 126,"好，主公英明果决，那么，火速进攻江陵．请准备出征．");
 MovePerson(115,1,1);
 MovePerson(115,0,2);
talk(115,"叔父，我身体有点不舒服，这次请让我送您出征吧．",
 1,"好吧，贤侄，好生休养吧．",
 115,"是．如此，您多费心了．");
 MovePerson(115,12,3);
 DecPerson(115);
talk(126,"最近刘琦好像身体不行呀．",
 1,"嗯，但愿没什么事……",
 126,"真让人担心．主公，还是请做出征准备吧．");
 --显示任务目标:<进行攻打江陵的准备工作．>
 NextEvent();
 end
 end,
 [386]=function()
 if JY.Tid==2 then--关羽
talk(2,"兄长，准备好了请告诉军师，不是告诉我．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，再这么愣着，周瑜就拿下江陵了．");
 end
 if JY.Tid==54 then--赵云
talk(54,"听说现在周瑜正与曹仁出城大战，江陵城正空虚，的确是好机会．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"刘琦最近身体不太好，不要紧吧．");
 end
 if JY.Tid==128 then--关平
talk(128,"赤壁之战，曹操的兵力也削弱了些吧．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"曹操不在，在下认为正是夺取荆州的良机．");
 end
 if JY.Tid==126 then--诸葛亮
 --原剧本此处有修改关羽阵营及等级，我挪到前面去了
 if talkYesNo( 126,"出发吧？") then
 RemindSave();
 PlayBGM(12);
talk(126,"请编组队伍．");
 WarIni();
 DefineWarMap(27,"第三章 江陵之战","一、陈矫的失败",30,0,142);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,1,6,4,0,-1,0,
 -1,2,7,4,0,-1,0,
 -1,2,5,4,0,-1,0,
 -1,2,4,4,0,-1,0,
 -1,3,6,4,0,-1,0,
 -1,4,5,4,0,-1,0,
 -1,0,5,4,0,-1,0,
 -1,0,6,4,0,-1,0,
 -1,0,8,4,0,-1,0,
 });
 DrawSMap();
talk(126,"好吧，兵贵神速，马上出征．");
 JY.Smap={};
 SetSceneID(0,3);
talk(126,"好吧，向江陵进发，江陵在江夏的西南方向．");
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
 171,18,9,3,2,33,3,0,0,-1,0,
 170,14,9,3,2,31,8,0,0,-1,0,
 256,17,9,3,0,27,2,0,0,-1,0,
 257,16,11,3,0,26,2,0,0,-1,0,
 274,14,10,3,0,27,5,0,0,-1,0,
 275,18,7,3,0,27,5,0,0,-1,0,
 276,16,7,3,0,26,5,0,0,-1,0,
 277,19,8,3,0,27,5,0,0,-1,0,
 142,35,17,3,0,37,16,0,0,-1,1,
 161,33,15,3,4,31,3,24,9,-1,1,
 165,34,18,3,4,31,3,18,14,-1,1,
 164,31,17,3,4,30,3,18,14,-1,1,
 147,32,18,3,4,34,14,18,14,-1,1,
 162,30,18,3,4,34,9,12,9,-1,1,
 148,29,16,3,4,34,20,24,9,-1,1,
 166,28,19,3,4,34,9,24,9,-1,1,
 258,31,18,3,4,27,2,18,14,-1,1,
 259,33,17,3,4,27,2,14,9,-1,1,
 292,26,18,3,4,29,8,18,14,-1,1,
 293,28,18,3,4,29,8,12,9,-1,1,
 294,31,15,3,4,28,8,24,9,-1,1,
 295,32,16,3,4,28,8,24,9,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [387]=function()
 PlayBGM(11);
talk(172,"什么？刘备军来了，可是曹仁正和周瑜交战，要坚守等到曹仁回来．",
 126,"主公，曹仁正与周瑜交战，江陵就是一个空城．他们之间的战斗结束后，曹仁或周瑜，无论谁取胜都会来江陵．那样的话，就麻烦了．早点攻下城吧．");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [388]=function()
 if WarMeet(54,148) then
 WarAction(1,54,148);
talk(54,"这里已经归我们所有了，你们现在最好赶快回东吴．",
 148,"吵什么！忘记赤壁之恩了吗，看我宰了你！");
 WarAction(6,54,148);
 if fight(54,148)==1 then
talk(148,"大胆！来吧！",
 54,"你不是对手！");
 WarAction(5,54,148);
talk(148,"嘿嘿！",
 54,"有两下子！");
 WarAction(8,54,148);
talk(148,"没办法，打不过！");
 WarAction(16,148);
 WarLvUp(GetWarID(54));
 else
talk(148,"大胆！来吧！",
 54,"你不是对手！");
 WarAction(5,54,148);
talk(148,"嘿嘿！",
 54,"有两下子！");
 WarAction(9,54,148);
talk(54,"没办法，打不过！");
 WarAction(16,54);
 WarLvUp(GetWarID(148));
 end
 end
 if (not GetFlag(1036)) and War.Turn==3 then
talk(126,"主公，周瑜打败曹仁，正赶往这里，在周瑜到达这里之前，赶快攻下江陵．");
 SetFlag(1036,1);
 end
 if (not GetFlag(1037)) and War.Turn==6 then
talk(126,"主公，也许周瑜马上就会到达这里．如果在我军攻下江陵之前来到，就不好办了，赶快！");
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
talk(1,"来不及了吧……",
 143,"何事？",
 148,"周瑜都督，刘备军正在攻打江陵．",
 143,"什么！想乘我们大战曹仁之机窃取空城，办不到！马上全军攻打刘备，不能把江陵交给刘备！！");
 PlayBGM(14);
 War.WarTarget="一、周瑜退却";
 WarShowTarget(false);
 SetFlag(1038,1);
 end
 if (not GetFlag(1039)) and War.Turn==10 then
talk(143,"刘备、孔明！尝尝我的厉害！前进！");
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
talk(143,"什么事？现在正忙着！说什么……兵粮……哦，只准备了和曹仁作战所需兵粮，嗯，知道了．撤退！但刘备、孔明，此事还没完！！");
 WarAction(16,143);
talk(1,"怎么了？周瑜撤退了．",
 126,"兵粮没有了吧？也许是与曹仁作战，兵粮已耗尽了吧．",
 1,"肯定是……那我们胜利了．",
 126,"正是，主公，恭喜您．");
 SetFlag(1041,1);
 NextEvent();
 end
 if JY.Death==172 then
 if not GetFlag(1038) then
talk(172,"哇！");
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
talk(143,"何事？",
 148,"周瑜都督，江陵已被刘备军占领了．",
 143,"什么！我们与曹仁交战时，他乘机窃取空城，太卑鄙了！我绝不放过他．",
 149,"都督，我军与曹仁交战，消耗甚大，不该再战了．我们回去再想对策吧．",
 143,"啊，真是后悔莫及．就照你所说，撤退！但是，刘备、孔明，你们等着瞧！");
 NextEvent();
 else
talk(172,"可恶！撤退……");
 SetFlag(214,1);
 end
 end
 WarLocationItem(17,19,17,199); --获得道具:获得道具：弓术指南书
 if JY.Status==GAME_WARWIN then
talk(143,"可恶！此仇必报！刘备、孔明小心了！");
 NextEvent();
 end
 end,
 [389]=function()
 PlayBGM(7);
 if GetFlag(1038) then
 if not GetFlag(214) then
talk(172,"连周瑜军都……刘备军……唉，撤退！");
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
talk(126,"好吧，入城！");
 else
talk(126,"进入江陵吧．");
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
talk(143,"实在对不起，被刘备窃取了空城似的江陵，我们也曾冒死争斗……",
 142,"哼，刘备这家伙，我们在赤壁替他打败曹操军，他连这大恩都忘了！",
 143,"此仇莫齿难忘，有朝一日，必将刘备宰了！！",
 142,"周瑜！",
 149,"都督！");
 MovePerson(149,3,3);
 MovePerson(149,1,0);
talk(149,"都督，伤势不要紧吧．现在还是养伤要紧．",
 142,"是啊，周瑜，无论如何得休养．",
 143,"让您挂心，真是……",
 149,"都督，这边请．");
 MovePerson( 149,12,1,
 143,12,1);
talk(142,"刘备这个家伙，把周瑜弄得如此狼狈，光想自己占便宜，办不到！这次我要亲率全军，进攻江陵，全体将士，准备出发！");
 MovePerson(144,3,2);
 MovePerson(144,1,0);
talk(144,"主公，且慢．",
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
talk(2,"兄长，东吴鲁肃前来拜见．");
 AddPerson(144,1,5,3);
 MovePerson(144,7,3);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [393]=function()
 if JY.Tid==2 then--关羽
talk(2,"东吴鲁肃前来拜见．");
 end
 if JY.Tid==3 then--张飞
talk(3,"东吴的使者吗？哼，肯定是说客．");
 end
 if JY.Tid==54 then--赵云
talk(54,"江陵是我们的地方，好不容易才夺来的，再还回去，没有道理．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"为什么要把荆州给东吴，有必要吗？刘表有灵也会生气的．");
 end
 if JY.Tid==128 then--关平
talk(128,"东吴若想要这块地方，凭兵马来取呀！");
 end
 if JY.Tid==64 then--孙乾
talk(64,"听说东吴谋士极多，一定是他们出主意，要我们还荆州吧．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公，请放心．我有妙计．");
 end
 if JY.Tid==144 then--鲁肃
talk(144,"刘备公，这次的事，我们东吴无法理解．",
 1,"您说是……",
 144,"当然了，赤壁一战，是我军赶走了曹兵，付出了巨大代价，因此应该得到整个荆州．",
 126,"鲁肃大人，这样想可大错特错了．");
 MovePerson(126,1,2);
 MovePerson(144,1,1);
 MovePerson(144,1,3);
talk(144,"原来是孔明公，您认为我说的不对吗？",
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
talk(2,"不愧为军师，三言两语把鲁肃打发走了．");
 end
 if JY.Tid==3 then--张飞
talk(3,"哼，凭什么将这里交给吴狗．");
 end
 if JY.Tid==54 then--赵云
talk(54,"江陵是我们的地方，好不容易才夺来的，再还回去，没有道理．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"为什么要把荆州给东吴，有必要吗？刘表有灵也会生气的．");
 end
 if JY.Tid==128 then--关平
talk(128,"东吴若想要这块地方，凭兵马来取呀！");
 end
 if JY.Tid==64 then--孙乾
talk(64,"听说东吴谋士极多，一定是他们出主意，要逼还荆州吧．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公，荆州这里有个人才，把他请来吧．",
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
talk(357,"马良？啊，是那个白眉人吧，他现在肯定在集会所．");
 end
 if JY.Tid==31 then--马谡
talk(31,"啊，我不是马良，而是他弟弟马谡．在我身边的才是马良．");
 end
 if JY.Tid==175 then--马良
 MovePerson(1,2,2);
 MovePerson(1,5,1);
talk(1,"对不起，请教尊姓大名？",
 175,"我吗？在下马良．",
 1,"噢，幸会幸会．多有冒犯，在下刘备．",
 175,"啊，您就是刘备？方才不知，多有得罪．",
 1,"哪里哪里．久闻大名，特来相会．望一定助我一臂之力．",
 175,"刘备大人相请，安敢拒绝，一定尽力．",
 1,"多谢．");
 ModifyForce(175,1);
 PlayWavE(11);
 DrawStrBoxCenter("马良成为部下．");
talk(175,"还有，没来得及介绍，旁边这人乃是马谡，我的弟弟，是个非常出色的年轻人．",
 31,"初次相见，在下马谡．",
 175,"马谡也想为您效力，不知尊意如何？");
 local menu={
 {" 带马谡走",nil,1},
 {"不带马谡走",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"嗯，真是年轻有为．以后请你们二位多多出力了．",
 31,"您言重了．");
 ModifyForce(31,1);
 PlayWavE(11);
 DrawStrBoxCenter("马谡成为部下．");
 elseif r==2 then
talk(1,"呀，看来年纪尚轻，等长大些再用吧．",
 175,"如此……那，刘备大人……没什么，主公，走吧．",
 1,"嗯．");
 end
 MovePerson(175,0,2);
talk(175,"以后全靠你了，我就先往江陵去了．",
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
talk(2,"兄长，你回来了．");
 --显示任务目标:<商量今后．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [398]=function()
 if JY.Tid==2 then--关羽
talk(2,"兄长，你回来了．");
 end
 if JY.Tid==3 then--张飞
talk(3,"这个叫马良的家伙，眉毛真白啊．年纪并不那么大，真有白眉毛的人啊？");
 end
 if JY.Tid==54 then--赵云
talk(54,"文臣武将增多了，是件大好事．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"马良在这个地方是有名人物．兄弟都有才名，马良最佳．因马良眉毛是白的，所以人说马氏五常，白眉最良．其弟马谡也有才干．");
 end
 if JY.Tid==128 then--关平
talk(128,"据说马良熟悉本地情况，一定能提出好建议．");
 end
 if JY.Tid==117 then--刘封
talk(117,"主公，怎么办呢？");
 end
 if JY.Tid==175 then--马良
talk(175,"今后，请多关照．主公，荆州不光是江陵这块地方．",
 1,"怎么说？",
 175,"江陵南面的四郡是指零陵、武陵、桂阳、长沙．把它们变成自己的领土不好吗？",
 1,"嗯，从哪里进攻好呢？",
 175,"长沙有个叫黄忠的武将很难对付．先攻打零陵、武陵、桂阳，长沙放在最后再打为好．");
 MovePerson(126,0,3)
talk(126,"按马良所说，先攻打长沙以外的三个郡，最后攻打长沙．",
 1,"三个郡同时进攻吗？",
 126,"这好办！主公先率领一军，向零陵、武陵、桂阳的其中任何一个出征．张飞和赵云各自打一个郡，而江陵由关羽留守．",
 1,"那么，关羽、张飞、赵云和我分别行事．",
 126,"零陵、武陵、桂阳之中，请您挑选所要进攻的一个郡．");
 --显示任务目标:<做出征荆州南部的准备．>
 NextEvent();
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公，马良加入我们阵营了，太好了．");
 end
 end,
 [399]=function()
 if JY.Tid==2 then--关羽
talk(2,"兄长，请让我守卫江陵．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，快决定下来．我想去打仗．");
 end
 if JY.Tid==54 then--赵云
talk(54,"主公，请从三个郡之中任选一个郡攻打．余下的郡由张飞和我分担．");
 end
 if JY.Tid==114 then--伊籍
talk(114,"马良在这个地方是有名人物．兄弟都有才名，马良最佳．因马良眉毛是白的，所以人说马氏五常，白眉最良．其弟马谡也有才干．");
 end
 if JY.Tid==128 then--关平
talk(128,"下次的战斗请一定派我去．");
 end
 if JY.Tid==117 then--刘封
talk(117,"下次的战斗请一定派我去．");
 end
 if JY.Tid==175 then--马良
talk(175,"如果依仗主公的威势，攻克四个郡是很容易的．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 PlayBGM(12);
talk(126,"出发了．",
 3,"大哥，快决定攻打哪个郡．",
 54,"我们在主公之后出征．");
 ModifyForce(2,0);
 ModifyForce(3,0);
 ModifyForce(54,0);
 JY.Smap={};
 SetSceneID(0);
 PlayBGM(11);
talk(176,"据说刘备军要攻打零陵？嗯，怎么办……",
 181,"哼！刘备军是对抗曹操的一班愚蠢之徒．武陵不能交出！",
 179,"哈……我不能背叛曹操．可是，桂阳军也不能取胜．",
 183,"哼！长沙有黄忠在！只要有黄忠，就没有必要害怕刘备军．");
 PlayBGM(3);
talk(1,"这是荆州南部的四郡吗？",
 126,"是，马良已说过，长沙有个叫黄忠的豪杰．长沙放在最后再打．主公，攻打哪个？");
 local menu={
 {" 攻打武陵",nil,1},
 {" 攻打零陵",nil,1},
 {" 攻打桂阳",nil,1},
 }
 local r=ShowMenu(menu,3,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(126,"明白了，前往武陵．");
 SetSceneID(0);
talk(126,"请编组队伍．");
 PlayBGM(12);
 WarIni();
 DefineWarMap(30,"第三章 武陵之战","一、金旋的毁灭．*二、敌军投降．",35,0,180);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,7,18,4,0,-1,0,
 -1,6,17,4,0,-1,0,
 -1,5,17,4,0,-1,0,
 -1,4,17,4,0,-1,0,
 -1,4,16,4,0,-1,0,
 -1,5,16,4,0,-1,0,
 -1,6,16,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 180,28,4,3,0,36,3,0,0,-1,0,
 181,28,9,3,2,31,6,0,0,-1,0,
 232,15,13,3,2,33,12,0,0,-1,0,
 224,13,7,3,2,32,6,0,0,-1,0,
 274,9,11,3,4,27,5,14,13,-1,0,
 275,23,11,3,0,27,5,0,0,-1,0,
 276,27,7,3,0,26,5,0,0,-1,0,
 292,14,7,3,0,29,8,0,0,-1,0,
 293,16,14,3,0,29,8,0,0,-1,0,
 256,8,10,3,4,27,2,12,7,-1,0,
 257,23,7,3,0,26,2,0,0,-1,0,
 310,13,6,3,0,27,11,0,0,-1,0,
 311,16,13,3,0,27,11,0,0,-1,0,
 332,23,9,3,0,27,14,0,0,-1,0,
 333,28,7,3,0,26,14,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent(400); --goto 400
 elseif r==2 then
talk(126,"明白了，前往零陵．");
 SetSceneID(0);
talk(126,"请编组队伍．");
 PlayBGM(12);
 WarIni();
 DefineWarMap(31,"第三章 零陵之战","一、刘度的毁灭．*二、敌军投降．",35,0,175);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,2,18,4,0,-1,0,
 -1,1,17,4,0,-1,0,
 -1,2,19,4,0,-1,0,
 -1,1,18,4,0,-1,0,
 -1,4,18,4,0,-1,0,
 -1,3,17,4,0,-1,0,
 -1,2,16,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 175,7,0,1,2,35,3,0,0,-1,0,
 176,5,0,4,4,33,8,8,1,-1,0,
 336,6,1,4,4,26,15,0,4,-1,0,
 292,9,3,1,1,26,8,0,0,-1,0,
 293,7,2,1,4,26,8,0,4,-1,0,
 294,10,1,3,4,25,8,8,0,-1,0,
 295,9,0,3,1,25,8,0,0,-1,0,
 274,8,2,1,1,26,5,0,0,-1,0,
 275,7,3,1,4,26,5,0,4,-1,0,
 276,9,1,3,1,26,5,0,0,-1,0,
 277,4,1,4,4,26,5,7,1,-1,0,
 177,15,15,3,1,33,12,0,0,-1,1,
 332,14,14,3,1,30,14,0,0,-1,1,
 333,14,13,3,1,29,14,0,0,-1,1,
 340,13,14,3,1,28,17,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent(404); --goto 404
 elseif r==3 then
talk(126,"明白了，前往桂阳．");
 SetSceneID(0);
talk(126,"请编组队伍．");
 PlayBGM(12);
 WarIni();
 DefineWarMap(29,"第三章 桂阳之战","一、赵范的毁灭．*二、敌军投降．",35,0,178);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,12,22,4,0,-1,0,
 -1,12,21,4,0,-1,0,
 -1,13,23,4,0,-1,0,
 -1,11,22,4,0,-1,0,
 -1,11,20,4,0,-1,0,
 -1,14,21,4,0,-1,0,
 -1,13,20,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 178,11,1,1,2,36,3,0,0,-1,0,
 179,11,3,1,0,33,8,0,0,-1,0,
 151,16,9,4,3,33,3,0,0,-1,0,
 256,10,4,1,0,27,2,0,0,-1,0,
 257,8,5,4,0,26,2,0,0,-1,0,
 274,12,3,1,0,27,5,0,0,-1,0,
 275,8,7,4,0,26,5,0,0,-1,0,
 292,16,7,4,1,29,8,0,0,-1,0,
 293,14,9,4,1,29,8,0,0,-1,0,
 332,15,10,4,1,27,14,0,0,-1,0,
 333,8,9,4,0,27,14,0,0,-1,0,
 336,17,8,4,1,27,15,0,0,-1,0,
 337,10,3,1,0,26,15,0,0,-1,0,
 
 340,21,7,3,1,30,17,0,0,-1,1,
 341,22,8,3,1,30,17,0,0,-1,1,
 342,22,9,3,1,29,17,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent(408); --goto 408
 end
 end
 end
 end,
 [400]=function()
 PlayBGM(11);
talk(182,"主公，听说刘备很得民心，为谋求领土安泰，我想应该投降了．",
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
talk(155,"那是敌人的头目吗？好，我要杀死他立功．",
 181,"那是什么？像是土匪．你以为像土匪那样的人能胜得了我吗？好，看看我的厉害！");
 WarAction(6,155,181);
 if fight(155,181)==1 then
 WarAction(8,155,181);
talk(181,"哎呀！",
 155,"打到了！杀死敌人的头目了！");
 WarAction(18,181);
 WarLvUp(GetWarID(155));
 DrawMulitStrBox("　周仓杀死了金旋．*　刘备军占领了武陵．");
 NextEvent();
 else
 WarAction(4,181,155);
talk(155,"哎呀！");
 WarAction(17,155);
 WarLvUp(GetWarID(181));
 end
 end
 if WarMeet(1,182) then
 WarAction(1,1,182);
 PlayBGM(11);
talk(182,"刘备，我以前是遵照金旋的命令行事的……这好像是我做错事．这个武陵应归刘备所有．请暂时等待一下．我去除掉这个害虫．");
 WarAction(16,182);
talk(181,"这、这个巩志！要干什么！喔！！");
 WarAction(18,181);
talk(182,"我杀死了金旋！我投降刘备！！");
 DrawStrBoxCenter("金旋被杀．刘备军占领了武陵．");
 NextEvent();
 SetFlag(137,1);
 end
 if WarMeet(-1,225) and (not GetFlag(141)) then
talk(225,"嗯……这是刘备军的实力……真厉害．吴祖！求你帮我！",
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
talk(233,"像你们这样的还想打我吗？哼！让你们后悔莫及！！",
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
talk(225,"嗯……这是刘备军的实力吗？吴祖，以后的事靠你了！！",
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
talk(233,"我，我也打不过……走为上策，哎呀，不好！！",
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
talk(182,"刘备，今后我跟随您．请多关照．");
 ModifyForce(182,1);
 PlayWavE(11);
 DrawStrBoxCenter("巩志成为部下．");
 end
 SetSceneID(0,3);
talk(3,"打进去了！攻陷了零陵！！",
 54,"攻克了桂阳！");
 SetSceneID(0,3);
talk(126,"主公，张飞攻下了零陵、赵云攻下了桂阳．*请一同回江陵，研究攻打长沙的计划．");
 NextEvent(412); --goto 412
 end,
 [404]=function()
 PlayBGM(11);
talk(176,"好像敌不过刘备．还是乘这个机会，乾脆投降刘备军算了……",
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
talk(128,"曹操从荆州走了．如果立即投降，可留条性命．",
 178,"哈哈哈！想要零陵，就用你的实力夺取．还是害怕吧？！",
 128,"说什么！说的话别忘了！");
 WarAction(6,128,178);
 if fight(128,178)==1 then
talk(178,"什、什么！这么样可……",
 128,"看我最后一刀！");
 WarAction(8,128,178);
talk(178,"哎呀，我不行了．");
 WarAction(17,178);
talk(128,"哼，口出狂言的家伙．");
 WarLvUp(GetWarID(128));
 else
 WarAction(4,178,128);
talk(128,"哎呀，我不行了．");
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
talk(177,"邢道荣，该出征了．",
 1,"嗯？");
 WarShowArmy(177);
 WarShowArmy(332);
 WarShowArmy(333);
 WarShowArmy(340);
 DrawStrBoxCenter("敌人的另一路军出现了！");
talk(178,"好汉们！打死刘备这家伙．",
 177,"父亲！怎么样？我的战术如何？",
 176,"嗯……好极了……");
 SetFlag(77,1);
 end
 if WarMeet(1,176) then
 WarAction(1,1,176);
talk(1,"刘度，再打下去也不会有胜利的希望．怎么样，投降吧！",
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
talk(3,"打进去了！武陵攻破了！",
 54,"攻克了桂阳！");
 SetSceneID(0,3);
talk(126,"主公，张飞攻下武陵、赵云拿下桂阳．*请一同回江陵，研究攻打长沙的计划．");
 NextEvent(412); --goto 412
 end,
 [408]=function()
 PlayBGM(11);
talk(179,"无论如何也敌不过刘备军，乾脆投降算了……",
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
talk(117,"敌将在哪！刘封来挑战！",
 152,"混蛋．刘备军别自鸣得意！我来对付！");
 WarAction(6,117,152);
 if fight(117,152)==1 then
talk(152,"有空档！");
 WarAction(5,152,117);
 WarAction(8,117,152);
talk(152,"完了，完了……我完了……");
 WarAction(18,152);
talk(117,"好，杀死了敌将！");
 WarLvUp(GetWarID(117));
 else
talk(152,"有空档！");
 WarAction(4,152,117);
talk(117,"太厉害了！");
 WarAction(17,117);
 WarLvUp(GetWarID(152));
 end
 end
 if WarMeet(1,179) then
 WarAction(1,1,179);
talk(1,"赵范，再打下去，你也没有获胜的希望．怎么样，投降吧！",
 179,"是，明白了．这片领土奉送给你．");
 PlayBGM(7);
 DrawMulitStrBox("赵范投降了．刘备军占领了桂阳．");
 SetFlag(1043,1);
 NextEvent();
 end
 if (not GetFlag(142)) and WarCheckArea(-1,4,8,9,16) then
 PlayBGM(11);
talk(179,"嗯？那是？");
 WarShowArmy(340);
 WarShowArmy(341);
 WarShowArmy(342);
 WarModifyAI(333,1);
 WarModifyAI(275,1);
 WarModifyAI(256,1);
 WarModifyAI(257,1);
 DrawStrBoxCenter("异民族出现了！");
talk(180,"那是？主公！请求的援军来了．和他们通力合作，击退刘备！",
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
talk(3,"打进去了！攻破了武陵！",
 54,"攻陷了零陵！");
 SetSceneID(0,3);
talk(126,"主公，张飞攻下了武陵，赵云攻下了零陵，两个城都打下来了．那么，一同回江陵，研究攻打长沙的计划．");
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
talk(175,"主公，占领了三个郡，真是可喜可贺．");
 --显示任务目标:<商量所剩长沙之事．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [413]=function()
 if JY.Tid==2 then--关羽
talk(2,"主公，你回来了．");
 end
 if JY.Tid==3 then--张飞
talk(3,"我来打的话，攻下一个或两个城，如囊中取物．");
 end
 if JY.Tid==54 then--赵云
talk(54,"在新的领地，人民都敬仰主公的声望．");
 end
 if JY.Tid==128 then--关平
talk(128,"已经占领了三郡，可喜可贺．");
 end
 if JY.Tid==117 then--刘封
talk(117,"还剩下一个，一旦攻破长沙，荆州全境就成为我们的啦．");
 end
 if JY.Tid==175 then--马良
talk(175,"主公，占领了三郡，可喜可贺．",
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
talk(126,"四个郡中，已占领了三郡，就只剩下长沙．");
 end
 end,
 [414]=function()
 if JY.Tid==2 then--关羽
talk(2,"兄长，这次请交给我办．一定把黄忠活捉回来给你们看．");
 end
 if JY.Tid==3 then--张飞
talk(3,"关羽这家伙，让他留守好像委屈了他．有个请求，我也跟着去打．");
 end
 if JY.Tid==54 then--赵云
talk(54,"赶快出征吧！");
 end
 if JY.Tid==128 then--关平
talk(128,"主公，快出征吧！");
 end
 if JY.Tid==117 then--刘封
talk(117,"攻克长沙，荆州全境就是我们的．");
 end
 if JY.Tid==175 then--马良
talk(175,"你可千万要留神黄忠．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 PlayBGM(12);
talk(126,"请编组队伍．");
 WarIni();
 DefineWarMap(32,"第三章 长沙之战","一、韩玄的毁灭．*二、敌军投降．",40,0,182);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,2,3,4,0,-1,0,
 -1,3,3,4,0,-1,0,
 -1,2,4,4,0,-1,0,
 -1,3,2,4,0,-1,0,
 -1,1,4,4,0,-1,0,
 -1,1,2,4,0,-1,0,
 -1,4,3,4,0,-1,0,
 -1,3,4,4,0,-1,0,
 -1,2,5,4,0,-1,0,
 -1,5,3,4,0,-1,0,
 -1,2,6,4,0,-1,0,
 });
 DrawSMap();
talk(126,"出征长沙．");
 JY.Smap={};
 SetSceneID(0,11);
talk(183,"什么？三个郡陷落了？这些家伙太软弱了．我这里有黄忠．喂，黄忠！",
 170,"交给我办，一定不辜负你的期望．");
 SetSceneID(0,3);
talk(1,"好！再攻克了长沙，荆州全境将归我们所有！向长沙进发！");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 182,33,19,2,2,38,2,0,0,-1,0,
 183,18,9,3,2,32,8,0,0,-1,0,
 169,33,14,3,0,33,22,0,0,-1,0,
 126,33,17,2,2,33,15,0,0,-1,0,
 256,18,7,3,2,32,3,0,0,-1,0,
 257,34,13,3,0,30,3,0,0,-1,0,
 274,17,8,3,2,32,6,0,0,-1,0,
 275,27,7,3,0,30,6,0,0,-1,0,
 276,23,15,3,0,30,6,0,0,-1,0,
 277,24,14,3,0,30,6,0,0,-1,0,
 278,31,15,3,0,32,21,0,0,-1,0,
 292,27,9,3,0,32,9,0,0,-1,0,
 293,24,16,3,0,32,9,0,0,-1,0,
 294,22,16,3,0,31,9,0,0,-1,0,
 295,32,16,3,0,31,9,0,0,-1,0,
 336,28,8,3,0,30,15,0,0,-1,0,
 332,16,9,3,2,30,14,0,0,-1,0,
 310,28,6,3,0,30,12,0,0,-1,0,
 296,34,15,3,0,30,9,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [415]=function()
 PlayBGM(11);
talk(183,"黄忠，刘备军究竟怎么样，你去打一仗看看．我在这里观察战况．",
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
talk(1,"嗯？那个声音是什么？",
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
talk(184,"我，我……韩玄，你这个……");
 WarAction(17,184);
 WarAction(17,257);
 WarAction(17,275);
 WarAction(17,333);
talk(1,"连自己部队的生死都不顾就……",
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
talk(127,"到底还是刘备军，真厉害……",
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
talk(127,"嗯？那是……太好了，刘备大人？",
 1,"呀？是谁？",
 127,"刘备大人，我原是刘表的部下，名叫魏延．我的事情以后再谈，现在我要去除掉藏在长沙的害人虫．再见！");
 WarMoveTo(127,33,18);
 WarAction(1,127,183);
talk(183,"什，什么？魏延，你这个叛徒！",
 127,"这不是背叛．这是愤怒的民众对你的所作所为的回报．去死吧！");
 WarAction(8,127,183);
talk(183,"啊！！");
 WarAction(18,183);
talk(126,"主公，敌人好像投降了．");
 PlayBGM(7);
 DrawMulitStrBox("　韩玄被杀．刘备军占领了长沙．");
 SetFlag(1044,1);
 NextEvent();
 end
 if WarMeet(2,170) then
 WarAction(1,2,170);
talk(2,"嗯，这个老头……不像等闲之辈．老头，报上名来！",
 170,"匹夫！你休得无礼！我乃黄忠是也！",
 2,"你就是黄忠？我关羽要与你单挑．",
 170,"嗯，你大概以为我老了就好欺负．年轻人，你打错算盘了．去死吧！");
 WarAction(6,2,170);
 if fight(2,170)==1 then
talk(2,"打！");
 WarAction(5,2,170);
talk(170,"哎呀！",
 2,"怎么？……战马失蹄了……",
 170,"真倒楣．这也是命吗？快杀了我吧！");
 WarAction(15,2);
talk(2,"……我且饶你性命．快去换马继续厮杀．",
 170,"什么？太感谢你了，那我去换马了．");
 WarAction(16,170);
 WarLvUp(GetWarID(2));
talk(183,"黄忠！你竟敢通敌！",
 170,"不要错怪我．我绝不是那种人．",
 183,"住口！我看见你与关羽单挑，关羽不杀你反而把你放了回来，这不是通敌的证据是什么？",
 170,"不．这……",
 183,"不听你辩解！快把这家伙的头砍下来！");
 WarMoveTo(127,33,18);
 WarAction(1,127,183);
talk(127,"韩玄！全然不记以前的功绩，要杀黄忠，这不是君子所为．我要替天行道惩罚你！",
 183,"啊，魏延！把魏延杀了！快来人呀！");
 WarAction(8,127,183);
talk(183,"啊……");
 WarAction(18,183);
talk(126,"主公，敌人好像投降了．");
 PlayBGM(7);
 DrawMulitStrBox("　韩玄被杀．刘备军占领了长沙．");
 NextEvent();
 else
 WarAction(4,170,2);
talk(170,"关羽休得猖狂，看我黄忠一箭！",
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
talk(126,"那就进长沙城吧．");
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
talk(127,"刘备主公，我叫魏延．");
 --显示任务目标:<和魏延谈话>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [420]=function()
 if JY.Tid==2 then--关羽
talk(2,"黄忠尽管年老，但仍然武艺高强．");
 end
 if JY.Tid==3 then--张飞
talk(3,"没能和黄忠交手，真是件憾事．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公，怎么处置这个人？");
 end
 if JY.Tid==127 then--魏延
talk(127,"残余的长沙军，向刘备大人投降了．从今以后，我也要为刘备效劳．",
 126,"主公，请等一下．");
 MovePerson(126,0,3);
talk(1,"孔明，怎么了？",
 126,"我不赞成收这个人为部下．",
 1,"为什么？",
 126,"这个人以前曾为刘表效力过．",
 127,"……是这样的．",
 126,"刘表一死投向韩玄，现在看见韩玄出现危机，就马上背叛旧主，改投主公，这样的人，不知什么时候就又会投靠别人？",
 1,"可是，孔明，如果拒绝了想投降我的人，今后就没有人向我投降了．不能这样做．",
 126,"……我明白了，那么您看着办吧．");
 MovePerson(126,0,2);
talk(1,"魏延，别放在心上，我会好好对待你，今后要好好工作．",
 127,"……是！是！");
 ModifyForce(127,1);
 PlayWavE(11);
 DrawStrBoxCenter("魏延成为部下！");
talk(1,"嗯……怎么，一直没见到黄忠？",
 127,"黄忠听说韩玄死讯后，一直待在家中，不出门见客．");
 --显示任务目标:<去官邸会见黄忠>
 NextEvent();
 end
 end,
 [421]=function()
 if JY.Tid==2 then--关羽
talk(2,"兄长，去拜访黄忠吧．这样的人才可不多见．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==3 then--张飞
talk(3,"没能和黄忠交手，真是件憾事．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公既然有录用魏延的意思，我没有意见．");
 end
 if JY.Tid==127 then--魏延
talk(127,"黄忠听说韩玄死讯后，一直待在家中，不出门见客．");
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
talk(170,"我不是说了吗，我谁也不见．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [423]=function()
 if JY.Tid==170 then--黄忠
 MovePerson(1,5,3);
 MovePerson(1,2,0);
talk(170,"我说过了，什么人都不想见．……啊，不像个佣人．",
 1,"突然拜访，我叫刘备．",
 170,"什么？是刘备大人吗？未曾远迎，失礼．",
 1,"黄忠，我很需要像你这样的豪杰．怎么样？加入我们军队吧．",
 170,"……我被处死也是应该的，您亲自来说……知道了，我黄忠愿意为您效劳．");
 ModifyForce(170,1);
 PlayWavE(11);
 DrawStrBoxCenter("黄忠成为部下！");
talk(1,"太好了．那就一起去江陵吧．",
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
talk(126,"主公，你来得正好．有个部下前来报告情况．");
 --显示任务目标:<在议事厅商讨今后>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [425]=function()
 if JY.Tid==2 then--关羽
talk(2,"听说鲁肃又来了．");
 end
 if JY.Tid==3 then--张飞
talk(3,"但是，吴也太纠缠不休了．好像还没有受够教训．");
 end
 if JY.Tid==54 then--赵云
talk(54,"真是．周瑜想荆州想得入迷了．");
 end
 if JY.Tid==175 then--马良
talk(175,"荆州的土地肥沃，人民众多．吴当然想得到了．");
 end
 if JY.Tid==367 then--文官
talk(367,"鲁肃从吴来了．怎么办？");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公，听说鲁肃来了．",
 1,"又是为荆州的事吧．这次的来意是什么？",
 126,"我有办法．鲁肃一提到荆州的事，主公您就哭．",
 1,"哭？光哭行吗？",
 126,"没问题．主公哭一会，到了不可收拾的时候，我有良策．");
 NextEvent();
 end
 end,
 [426]=function()
 if JY.Tid==2 then--关羽
talk(2,"军师有什么良策吗？");
 end
 if JY.Tid==3 then--张飞
talk(3,"让吴断了得到荆州的念头．");
 end
 if JY.Tid==54 then--赵云
talk(54,"请鲁肃来吧．");
 end
 if JY.Tid==175 then--马良
talk(175,"荆州的土地肥沃，人民众多．吴当然想得到了．");
 end
 if JY.Tid==367 then--文官
talk(1,"请鲁肃进来．",
 367,"是．");
 MovePerson(367,10,2);
 DecPerson(367);
 AddPerson(144,-5,2,3);
 MovePerson(144,10,3);
talk(144,"刘备大人，好久不见了．");
 NextEvent();
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"您只管哭就行了．那么请鲁肃进来．");
 end
 end,
 [427]=function()
 if JY.Tid==2 then--关羽
talk(2,"兄长，请与鲁肃谈话．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，鲁肃等着您呢．");
 end
 if JY.Tid==54 then--赵云
talk(54,"主公，请与鲁肃谈谈吧．");
 end
 if JY.Tid==175 then--马良
talk(175,"主公，请与鲁肃谈谈吧．");
 end
 if JY.Tid==144 then--鲁肃
talk(1,"您这次来有何贵干？",
 144,"噢，这次来是受我主孙权的吩咐，专为荆州之事．出借荆州已经这么长时间了，该还给我们了吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"与鲁肃谈谈吧．");
 end
 end,
 [428]=function()
 local menu={
 {"　 忽视",nil,1},
 {" 假装不知",nil,1},
 {"　　哭",nil,1},
 }
 local r=ShowMenu(menu,3,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"……",
 144,"刘备大人，事到如今，沈默也没用．");
 elseif r==2 then
talk(1,"您想说什么？",
 144,"事到如今，沈默也没用．刘备大人，请回答．");
 elseif r==3 then
talk(1,"呜呜呜……",
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
 local r=ShowMenu(menu,3,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"……",
 144,"刘备大人，事到如今，沈默也没用．");
 NextEvent(428);
 elseif r==2 then
talk(1,"您想说什么？",
 144,"事到如今，沈默也没用．刘备大人，请回答．");
 NextEvent(428);
 elseif r==3 then
talk(1,"呜呜呜……",
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
 local r=ShowMenu(menu,3,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"……",
 144,"……？什么呀，是装哭啊？你是说谎的骗子．");
 NextEvent(428);
 elseif r==2 then
talk(1,"嗯……今天的饭不错．",
 144,"刘备大人，你严肃些．");
 NextEvent(428);
 elseif r==3 then
talk(1,"呜呜呜……",
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
 local r=ShowMenu(menu,3,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(1,"……",
 144,"……？什么呀，是装哭啊？你是说谎的骗子．");
 NextEvent(428);
 elseif r==2 then
talk(1,"嗯……．今天的饭不错．",
 144,"刘备大人，你严肃些．");
 NextEvent(428);
 elseif r==3 then
talk(1,"呜呜呜……",
 144,"刘备大人，您怎么了？为什么要哭？",
 126,"我来解释主公哭的原因．");
 MovePerson(126,1,2);
 MovePerson(126,1,0);
 MovePerson(126,1,2);
talk(144,"他为什么哭？",
 126,"主公本打算一得到益州，就把荆州还给你们．可是益州的刘璋是主公的同宗．进攻同宗对主公而言是痛苦的，因此就哭泣了．");
talk(1,"呜呜呜……",
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
talk(2,"军师认为怎样？");
 end
 if JY.Tid==3 then--张飞
talk(3,"我每回都想，军师怎么能猜中别人的心思呢？");
 end
 if JY.Tid==54 then--赵云
talk(54,"军师神机妙算．");
 end
 if JY.Tid==175 then--马良
talk(175,"吴军替我们攻打益州，可信吗？");
 end
 if JY.Tid==126 then--诸葛亮
talk(1,"军师，这件事你看怎样？",
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
talk(144,"我鲁肃回来了．",
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
talk(143,"鲁肃，孔明真的允许咱们通过江陵吗？",
 144,"是，他确实是这么说的．",
 143,"太好了．这回骗过了孔明．",
 142,"怎么回事？我都糊涂了．")
 MovePerson(143,1,3);
 MovePerson(143,4,0);
 MovePerson(143,0,2);
talk(143,"噢，我还没对主公讲呢．是这样，……");
 DrawMulitStrBox("　周瑜的假道灭虢之计已经被诸葛亮识破．周瑜是想假称通过江陵取益州，趁刘备未防备之机，一举攻克江陵．");
talk(142,"原来如此．刘备、诸葛亮已经中计了，还是周瑜足智多谋啊．",
 143,"那在孔明察觉前，赶紧行动吧．",
 142,"那就全靠你了，周瑜．",
 143,"是．");
 
 JY.Smap={};
 SetSceneID(0);
talk(143,"快！不要给孔明思考的时间！");
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
talk(126,"主公，准备好了．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [435]=function()
 if JY.Tid==2 then--关羽
talk(2,"真要和周瑜决战了吗？我们一定要战胜他．");
 end
 if JY.Tid==3 then--张飞
talk(3,"和吴军战斗是一种乐趣．");
 end
 if JY.Tid==54 then--赵云
talk(54,"荆州不能让给周瑜．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"我虽然岁数大了，也绝不会输给年轻人．");
 end
 if JY.Tid==127 then--魏延
talk(127,"这次战役请一定带我一起上阵．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公，周瑜理应已经出征了．已经派出了糜竺当使者，我们也准备吧．");
 AddPerson(65,-5,2,3);
 MovePerson(65,10,3);
talk(65,"主公，周瑜已经到达了公安．要求咱们去迎接．",
 3,"真没办法．去出迎．",
 126,"好吧．请作出征准备．");
 NextEvent();
 end
 end,
 [436]=function()
 if JY.Tid==2 then--关羽
talk(2,"真要和周瑜决战了吗？我们一定要战胜他．");
 end
 if JY.Tid==3 then--张飞
talk(3,"和吴军战斗是一种乐趣．");
 end
 if JY.Tid==54 then--赵云
talk(54,"荆州不能让给周瑜．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"我虽然岁数大了，也绝不会输给年轻人．");
 end
 if JY.Tid==127 then--魏延
talk(127,"这次战役请一定带我一起上阵．");
 end
 if JY.Tid==65 then--糜竺
talk(65,"主公，周瑜已经到达了公安．要求咱们去迎接．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"出征吗？") then
 RemindSave();
 PlayBGM(12);
talk(126,"请编组部队．");
 WarIni();
 DefineWarMap(28,"第三章 公安之战","一、周瑜撤退．*二、占领四个鹿砦．",40,0,142);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,10,21,4,0,-1,0,
 125,12,20,4,0,-1,0,
 -1,12,21,4,0,-1,0,
 -1,11,19,4,0,-1,0,
 -1,11,22,4,0,-1,0,
 -1,10,18,4,0,-1,0,
 -1,10,20,4,0,-1,0,
 -1,9,19,4,0,-1,0,
 -1,9,21,4,0,-1,0,
 -1,8,20,4,0,-1,0,
 -1,10,23,4,0,-1,0,
 -1,8,22,4,0,-1,0,
 });
 DrawSMap();
talk(126,"主公，那么去公安迎接周瑜吧．");
 JY.Smap={};
 SetSceneID(0,3);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 142,36,10,3,2,44,16,0,0,-1,0,
 161,24,12,3,2,38,3,0,0,-1,0,
 165,26,14,3,2,39,3,0,0,-1,0,
 164,34,12,3,2,38,3,0,0,-1,0,
 147,32,13,3,2,40,14,0,0,-1,0,
 162,30,11,3,2,40,9,0,0,-1,0,
 148,25,13,3,2,41,20,0,0,-1,0,
 173,26,12,3,2,40,25,0,0,-1,0,
 292,28,11,3,2,34,9,0,0,-1,0,
 293,28,12,3,2,35,9,0,0,-1,0,
 294,33,12,3,2,35,9,0,0,-1,0,
 274,31,12,3,2,34,6,0,0,-1,0,
 
 275,25,11,3,2,33,6,0,0,-1,0,
 276,27,13,3,2,33,6,0,0,-1,0,
 277,33,10,3,2,34,6,0,0,-1,0,
 297,35,11,3,2,35,9,0,0,-1,0,
 332,32,11,3,2,33,14,0,0,-1,0,
 184,38,11,3,1,40,6,0,0,-1,1,
 166,37,11,3,1,40,9,0,0,-1,1,
 150,38,12,3,1,41,16,0,0,-1,1,
 295,37,9,3,1,36,9,0,0,-1,1,
 296,37,13,3,1,36,9,0,0,-1,1,
 278,36,12,3,1,34,21,0,0,-1,1,
 336,35,9,3,1,34,15,0,0,-1,1,
 340,39,11,3,1,36,17,0,0,-1,1,
 341,38,10,3,1,36,17,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [437]=function()
 PlayBGM(11);
talk(143,"哼．你们看，刘备这个傻瓜来欢迎了．好不容易才骗过孔明．在刘备靠近之前，不许轻举妄动．但是一旦靠近就发动总攻击．明白了吗？",
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
talk(2,"我是关羽关云长！谁能与我做对手？",
 149,"关羽！我吕蒙来也！",
 2,"你的胆子倒不小！看刀！");
 WarAction(6,2,149);
 if fight(2,149)==1 then
talk(2,"这家伙不容易对付……",
 149,"……看你以后还敢……",
 2,"看这刀！别发呆．");
 WarAction(4,2,149);
talk(149,"……打不过，不愧是关羽．关羽，以后再见分晓．");
 WarAction(16,149);
talk(2,"只有些小破绽，这家伙不太好对付．以后再见吧．");
 WarLvUp(GetWarID(2));
 else
 WarAction(4,149,2);
talk(2,"这家伙不容易对付……以后再见吧．");
 WarAction(16,2);
 WarLvUp(GetWarID(149));
 end
 end
 if not GetFlag(1045) then
 if WarCheckArea(-1,8,21,17,39) then
 PlayBGM(11);
talk(143,"哼！刘备军发动进攻了吗？孔明，到底让你识破了，咱们战场上见输赢！全军，向刘备军进攻！");
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
talk(185,"周瑜都督，我们来迟了．",
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
talk(126,"主公，据说以孙瑜为大将的敌方援军正向这里推进．这支援军一到，周瑜就准备进攻．形势对我军很不利，赶紧占领鹿砦！");
 SetFlag(1046,1);
 end
 if (not GetFlag(1047)) and War.Turn==8 then
talk(126,"敌人的行动相当的快．孙瑜很快就要赶到了，要赶紧行动！");
 SetFlag(1047,1);
 end
 if (not GetFlag(1048)) and War.Turn==12 then
talk(126,"孙瑜马上就要到了，主公，行动要快！");
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
talk(185,"周瑜都督，我们来迟了．",
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
talk(126,"嗯．占领了全部鹿砦．那么，向各砦武将下命令，让他们大声叫喊．");
talk(143,"嗯？这是什么声音？",
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
talk(143,"孔明，刘备……你们……哇……",
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
talk(126,"这下周瑜再也不敢挑衅了，那就回江陵吧．");
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
talk(126,"主公，周瑜死了．可喜可贺．");
 --显示任务目标:<商讨今后．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [442]=function()
 if JY.Tid==2 then--关羽
talk(2,"兄长，这样荆州就完全是兄长的了．");
 end
 if JY.Tid==3 then--张飞
talk(3,"吴也会记取教训，暂时不敢来攻打吧．");
 end
 if JY.Tid==54 then--赵云
talk(54,"荆州就可放心了．");
 end
 if JY.Tid==175 then--马良
talk(175,"荆州就可放心了．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公，为了给周瑜最后一击，我已经给周瑜送信，这就会有结果的……来人了．");
 AddPerson(367,-5,2,3);
 MovePerson(367,10,3);
talk(367,"禀报主公．");
 NextEvent();
 end
 end,
 [443]=function()
 if JY.Tid==2 then--关羽
talk(2,"兄长，请听一下报告．");
 end
 if JY.Tid==3 then--张飞
talk(3,"虽说把信送去了，可是结果会怎么样呢？我老想着这件事．");
 end
 if JY.Tid==54 then--赵云
talk(54,"周瑜在与曹仁交战时，肩部中箭受伤．据说箭伤还没痊癒．");
 end
 if JY.Tid==175 then--马良
talk(175,"暂且听一下报告．");
 end
 if JY.Tid==367 then--文官
talk(367,"刚才接到探子报告，说周瑜死了．");
 NextEvent();
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"请听一下结果如何．");
 end
 end,
 [444]=function()
 if JY.Tid==2 then--关羽
talk(2,"周瑜虽是强敌，也不能战胜疾病．");
 end
 if JY.Tid==3 then--张飞
talk(3,"周瑜死了？要是这样，吴国暂时不会攻打来了．");
 end
 if JY.Tid==54 then--赵云
talk(54,"周瑜在与曹仁交战时，肩部中箭受伤．据说箭伤还没痊癒．");
 end
 if JY.Tid==175 then--马良
talk(175,"作为敌人，是个可怕的对手．和吴的关系将会怎样？");
 end
 if JY.Tid==367 then--文官
talk(367,"据说周瑜是大量出血死的．");
 end
 if JY.Tid==126 then--诸葛亮
 MovePerson(126,0,3);
talk(126,"这是预料之中的事．主公，我想去吴吊唁周瑜．",
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
talk(2,"兄长，那就按军师所说，我也去寻访人才．",
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
talk(3,"找人才吧．不过大哥，人才在哪里？有目标吗？",
 1,"去寻访人才吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==1 then--刘备
talk(1,"去寻访人才吧．");
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
talk(1,"去哪里寻访人才呢？");
 local menu={
 {" 寻访江陵",nil,1},
 {" 寻访襄阳",nil,1},
 {" 寻访江夏",nil,1},
 {" 寻访长沙",nil,1},
 {" 回议事厅",nil,1},
 }
 local r=ShowMenu(menu,5,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==5 then
talk(1,"时间不早了，回议事厅吧．");
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
talk(1,"好像没有什么人才啊．");
 end
 NextEvent();
 end
 else
talk(1,"时间不早了，回议事厅吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(449);
 end
 end,
 [447]=function()
 local pid=JY.Base["事件150"];
 if pid>0 and JY.Tid==pid then--pid
 MovePerson(1,7,1);
 if JY.Person[pid]["君主"]==1 then
talk(pid,"今后请多关照．过几天我要去江陵．");
 else
talk(1,"请问您尊姓大名？",
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
talk(pid,"今后请多关照．过几天我要去江陵．");
 else
talk(pid,"我能做您的部下吗？");
 if WarDrawStrBoxYesNo("要收留"..JY.Person[pid]["姓名"].."做部下吗？",M_White,true) then
talk(pid,"喔，那就谢谢了．今后请多关照．");
 ModifyForce(pid,1);
 PlayWavE(11);
 DrawStrBoxCenter(JY.Person[pid]["姓名"].."成为部下！");
 else
talk(pid,"是吗？……");
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
talk(3,"大哥，有个叫庞统的来了．");
 AddPerson(133,-5,2,3);
 MovePerson(133,10,3);
 --显示任务目标:<让庞统成为部下>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [450]=function()
 if JY.Tid==3 then--张飞
talk(3,"怎么，是个其貌不扬的家伙．他究竟来干什么？");
 end
 if JY.Tid==64 then--孙乾
talk(64,"主公，暂且和来客谈谈吧．");
 end
 if JY.Tid==133 then--庞统
talk(133,"初次见面，我叫庞统．",
 1,"您专程来到这里，辛苦了．今天有什么事吗？",
 133,"没什么事．我是来这里谋职的．",
 1,"（要说庞统应该是水镜先生所说的伏龙、凤雏两个人之一的凤雏……）",
 1,"（外貌可不像个奇才，是他吗？真是个能与孔明相提并论的经纶济世之才吗？）");
 NextEvent();
 end
 end,
 [451]=function()
 if JY.Tid==3 then--张飞
talk(3,"怎么是个连话都不想回答的人，这家伙是真的了不起吗？");
 end
 if JY.Tid==64 then--孙乾
talk(64,"我想起来了，耒阳县的县令有个空缺．");
 NextEvent();
 end
 if JY.Tid==133 then--庞统
talk(133,"要是没什么职位我就先告辞了．",
 1,"请您等一下．");
 end
 end,
 [452]=function()
 if JY.Tid==3 then--张飞
talk(3,"怎么是个连话都不想回答的人，这家伙是真的了不起吗？");
 end
 if JY.Tid==64 then--孙乾
talk(64,"耒阳县是个小村子，居民很少．");
 end
 if JY.Tid==133 then--庞统
talk(1,"耒阳县缺少一个县令，您愿意去那里吗？",
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
talk(367,"禀报主公，有百姓报告说，耒阳县县令不做事．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [454]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，这家伙果然是个腐儒，我去教训教训他．",
 1,"三弟，你性子太急，还是跟我一起去吧．",
 3,"那我先去耒阳县吧．");
 MovePerson(3,3,2);
 MovePerson(3,2,1);
 MovePerson(3,8,2);
talk(64,"那就视察去吧．");
 JY.Smap={};
 SetSceneID(0);
talk(64,"耒阳县位于这里的东北部．");
 --显示任务目标:<去耒阳县视察情况>
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==64 then--孙乾
talk(64,"主公，我觉得最好调查一下这件事．");
 end
 if JY.Tid==367 then--文官
talk(367,"报告主公，有百姓报告说，耒阳县县令不做事．");
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
talk(363,"刘备大人，欢迎您来耒阳县．听张飞吩咐，特在这里等候．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [456]=function()
 if JY.Tid==3 then--张飞
talk(3,"官差不愿意对我说庞统的事．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"主公，咱们先找到庞统，再听听他的解释．");
 end
 if JY.Tid==363 then--官差
talk(1,"喂．庞统在那里？是在办公地点吗？",
 363,"这……这个……",
 1,"这……这个……你想说什么？",
 363,"那个，这事很难启齿．县令上任以来，没有处理过任何公务．",
 3,"什么？！",
 363,"哎呀！这不关我的事，再说这也是实情啊……");
 AddPerson(133,-5,24,0);
talk(133,"这里喧闹什么？怎么了？");
 MovePerson(133,13,0);
talk(3,"这个家伙！大哥，不管怎样得教训教训他．");
 NextEvent();
 end
 end,
 [457]=function()
 if JY.Tid==3 then--张飞
talk(3,"到这里这么长时间一件公务也未处理？这可不是闹着玩．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"到这里一看，才知道官差所说的事是真的．");
 end
 if JY.Tid==363 then--官差
talk(363,"对，对不起！我没有做到．");
 end
 if JY.Tid==133 then--庞统
talk(133,"这不是刘备大人吗？什么风把您给吹来了？",
 1,"我听说你自从上任以来，就不曾处理过公务，因此特来这里查看．",
 133,"哦，是为这事呀．没错，是这样，来这里后没有处理过公务．");
 MovePerson(3,2,1);
talk(3,"你说什么！大哥信任你才让你作县令，你怎么能这样怠忽职守呢？",
 133,"怠忽职守？像这种乡村的事务我马上就可以处理完．现在就让你们看看．");
 MovePerson(133,2,1);
talk(363,"县令，请等一下．");
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
talk(3,"大哥，咱们进去看看这个家伙到底是个什么货色．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"等看完结果再决定如何处罚他也不迟．");
 end
 if JY.Tid==1 then--刘备
talk(1,"去议事厅看看情况吧．");
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
 
talk(133,"这位商人，你骗了这位农民，以贵３倍的价钱把锄头卖给了他．",
 357,"那有这么回事．不是您听错了，就是有人在造谣．");
 MovePerson(355,1,1);
talk(355,"你说什么！是你的邻居告诉我的，要不然我带证人来．");
 MovePerson(357,0,0);
talk(357,"什么！你别找碴儿！",
 133,"肃静！你们两人都给我安静！");
 MovePerson( 355,1,0);
 MovePerson( 355,0,3,
 357,0,3);
talk(133,"农民，你过来．本官问你，这个锄头你用过了吗？",
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
talk(3,"这个判决很通情达理嘛．",
 64,"而且也合乎道理．这样谁也不会有意见．");
 DrawMulitStrBox("　就这样审判一个接一个地进行．*　到了晚上，就已经把以前积压的所有案件了结了．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [460]=function()
 if JY.Tid==3 then--张飞
talk(3,"我以前从没见过这样乾脆利索的审判．");
 end
 if JY.Tid==64 then--孙乾
talk(64,"真是让人惊讶．看来人不可貌相啊．");
 end
 if JY.Tid==363 then--官差
talk(363,"有这么能干的人，就没什么可担心的了．");
 end
 if JY.Tid==133 then--庞统
talk(133,"刘备大人，怎么样？",
 1,"您真是天下少见的奇才，我多有冒犯，失礼失礼．",
 133,"没有关系．噢，这里有封信．",
 1,"……？");
 DrawMulitStrBox("信上写道：*『主公，庞统是能成大事之人，其才十倍于我．主公不可以貌取人，否则将失大贤．请务必收庞统为部下．*　　　　　　　　　　　　　诸葛亮』");
talk(1,"这不是孔明的信吗？",
 133,"不错．孔明来吴时，我碰巧见到了他．*那时他说，一定要把此信交给刘备大人．",
 1,"误会误会，为什么当初你不把信给我呢？否则……");
 AddPerson(126,-3,3,3);
 MovePerson(126,10,3);
talk(126,"主公，你怎么在这里？咦，这不是庞统吗？你怎么也会在这里？",
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
talk(126,"主公，张松从益州来了．",
 1,"从益州来？",
 126,"是的．和张松谈谈吧．");
 MovePerson(126,0,2);
 AddPerson(187,-5,2,3);
 MovePerson(187,10,3);
talk(187,"这位就是刘备大人吗？我是益州来的张松．");
 --显示任务目标:<会见张松>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [463]=function()
 if JY.Tid==2 then--关羽
talk(2,"兄长，和张松谈谈吧．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，要先招呼客人．");
 end
 if JY.Tid==54 then--赵云
talk(54,"先与张松谈谈吧．");
 end
 if JY.Tid==187 then--张松
talk(1,"欢迎欢迎，我是刘备．",
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
talk(175,"先接见张松吧．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"和张松谈谈吧．");
 end
 if JY.Tid==133 then--庞统
talk(133,"主公，要先招呼客人呀．");
 end
 end,
 [464]=function()
 if JY.Tid==2 then--关羽
talk(2,"为了能与曹操抗衡，一定要得到益州．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，这样的好事错过太可惜了．");
 end
 if JY.Tid==54 then--赵云
talk(54,"如果我们不仅得到了荆州，而且得到了益州，就足以与曹操对抗了．");
 end
 if JY.Tid==175 then--马良
talk(175,"荆州确实是兵家用武之地，然而也容易被外敌窥伺．如果只有荆州……");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公，为什么不马上答应呢？",
 1,"即使要夺益州，难道没别的办法了吗？",
 126,"刘璋的部下愿意帮助，哪里还有这样好的机会？",
 1,"可……",
 126,"张松说要推荐主公，咱们就等着益州的使者吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==133 then--庞统
talk(133,"主公，这不是很好的事吗？这样的好事一定要接受．");
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
talk(187,"我张松回来了．",
 189,"嗯，曹操怎么回答的？他愿不愿意帮助我们抵御汉中的张鲁？",
 187,"曹操不会帮助我们的．我推荐近邻荆州的刘备．",
 189,"是刘备吗？听说他有善战的部下．好，向刘备请求援军．",
 187,"使者由法正担任最合适．",
 189,"那么法正，你去刘备处请求援军吧．",
 188,"是．");
 MovePerson(24,1,1);
 MovePerson(24,0,2);
talk(24,"主公，等等！",
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
talk(188,"刘备大人，初次见面．我叫法正，是张松的好友．");
 --显示任务目标:<会见法正>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [467]=function()
 if JY.Tid==126 then--诸葛亮
talk(126,"主公，和法正谈谈吧．");
 end
 if JY.Tid==133 then--庞统
talk(133,"既然是张松的好友，那么就是与张松有同样想法的人吧．");
 end
 if JY.Tid==188 then--法正
talk(188,"我想张松已经对您说了，刘璋黯弱，不能抵御外敌．因此我们想把益州献给刘备大人．",
 1,"可是，刘璋与我是同宗，我不忍心夺刘璋的基业．",
 188,"刘璋的蜀国早晚会让别人夺走．与其这样，还不如献给英主．而这个英主，我们认为就是您刘备．请您不要推辞．",
 1,"……明白了．我想再与孔明和庞统商量一下．今天已经很晚了，您先去驿馆休息吧．",
 188,"谢谢．");
 MovePerson(126,3,2);
 MovePerson(126,3,1);
 MovePerson(126,1,3);
talk(126,"我来带路吧．")
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
talk(133,"主公，有这等好事，为何不行动呢？张松和法正已经把话说明了，您不认为这是天赐之物吗？",
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
talk(133,"人都到齐了吗？开会了．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [470]=function()
 if JY.Tid==2 then--关羽
talk(2,"益州是险要之地．要想攻取，必须先做好充分的准备．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，带我去打益州吧．");
 end
 if JY.Tid==175 then--马良
talk(175,"听从主公的调遣．");
 end
 if JY.Tid==54 then--赵云
talk(54,"益州虽重要，但荆州也同样重要，必须要留能征惯战的武将把守．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"主公，我虽然上了年纪，但武艺丝毫未减退．请一定要带我去益州．");
 end
 if JY.Tid==127 then--魏延
talk(127,"请务必让我当先锋．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公，我来守荆州吧．为此，请把关羽、张飞和赵云留下．",
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
talk(188,"下决心了吗？那么就去雒城吧．刘璋正等着我们呢．今后，我也要为刘备大人效力，还要请您多关照．");
 ModifyForce(188,1);
 PlayWavE(11);
 DrawStrBoxCenter("法正成为部下！");
 JY.Smap={};
 SetSceneID(0,3);
talk(188,"那么我带路去雒城．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==133 then--庞统
talk(133,"我要和主公去一趟益州．");
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
talk(188,"我带刘备来了．",
 189,"啊，刘备，我等你多时了．");
 MovePerson(188,3,0);
 MovePerson(188,1,2);
 MovePerson(188,0,1);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [472]=function()
 if JY.Tid==189 then--刘璋
talk(189,"刘备大人，虽然我的部下七嘴八舌，然而我还是相信你的．",
 1,"我来了，您就放心吧．张鲁那边，由我去对付．",
 189,"那太感谢了．那么，请您去北面的涪城整顿兵马．");
 --显示任务目标:<去涪城>
 NextEvent();
 end
 if JY.Tid==24 then--黄权
talk(24,"我叫黄权，我不想见到你．");
 end
 if JY.Tid==194 then--刘贵
talk(194,"你最好不要在这惹事生非．蜀民可不好惹．");
 end
 if JY.Tid==195 then--冷苞
talk(195,"张鲁来攻，我们并不怕．总之一句话，我国不需要外来者．");
 end
 if JY.Tid==196 then--张任
talk(196,"远道而来辛苦了．可是，你为什么来此呢？");
 end
 if JY.Tid==197 then--邓贤
talk(197,"哼！你不就是为了益州而来的吗？");
 end
 if JY.Tid==188 then--法正
talk(188,"刘备大人，请先问候我家主公．");
 end
 end,
 [473]=function()
 if JY.Tid==189 then--刘璋
talk(189,"那么，请您去北面的涪城整顿兵马．",
 1,"那我就去涪城了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==24 then--黄权
talk(24,"我们的敌人太多了．有外患，有内奸……");
 end
 if JY.Tid==194 then--刘贵
talk(194,"你最好不要在这惹事生非．蜀民可不好惹．");
 end
 if JY.Tid==195 then--冷苞
talk(195,"张鲁来攻，我们并不怕．总之一句话，我国不需要外来者．");
 end
 if JY.Tid==196 then--张任
talk(196,"那就去打张鲁吧．");
 end
 if JY.Tid==197 then--邓贤
talk(197,"哼！你不就是为了益州而来的吗？");
 end
 if JY.Tid==188 then--法正
talk(188,"在这里行动不自在．快去涪城吧．",
 1,"那我就去涪城了．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==1 then--刘备
talk(1,"那我就去涪城了．");
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
talk(189,"张松，临死前你想说什么？",
 187,"您为什么要杀我？",
 189,"你还在装傻！你酒后对你哥哥说，你已经把国家献给了刘备，你哥哥已经将你告发了．你还说不知道！",
 187,"……！哥哥……你难道看不出我这样做的理由吗？",
 189,"来人！把这个叛徒斩首！",
 196,"是！");
 MovePerson( 196,1,0,
 194,1,1);
talk(194,"你这个叛徒该死！",
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
talk(188,"刘备大人，张松被刘璋杀了．",
 1,"什么？这是真的吗？",
 188,"总之，我们的计划已经暴露了，怎么办？");
talk(133,"主公，快下决定吧．");
 --显示任务目标:<商讨今后>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [476]=function()
 if JY.Tid==170 then--黄忠
talk(170,"为了主公，我们百死不辞！");
 end
 if JY.Tid==127 then--魏延
talk(127,"主公，使者来了．");
 AddPerson(365,43,0,1);
 MovePerson(365,10,1);
talk(365,"主公，我从荆州来，带来了诸葛军师的话，");
 NextEvent();
 end
 if JY.Tid==128 then--关平
talk(128,"主公，一定要把益州拿下！");
 end
 if JY.Tid==117 then--刘封
talk(117,"主公，如果能夺取益州，就有了与曹操抗衡的力量了．");
 end
 if JY.Tid==188 then--法正
talk(188,"刘备大人，请一定为张松报仇．不能让张松死的没有代价！");
 end
 if JY.Tid==133 then--庞统
talk(133,"主公，到了这个地步，请下决断！攻打益州吧．");
 end
 end,
 [477]=function()
 if JY.Tid==170 then--黄忠
talk(170,"军师不知有什么事．");
 end
 if JY.Tid==127 then--魏延
talk(127,"先听听使者说什么．");
 end
 if JY.Tid==365 then--使者
talk(365,"孔明捎来的口信说，从星象看，主公不宜出行．出征的事要谨慎．");
 NextEvent();
 end
 if JY.Tid==128 then--关平
talk(128,"是军师派来的使者吗？怎么回事？");
 end
 if JY.Tid==117 then--刘封
talk(117,"是军师派来的使者吗？怎么回事？");
 end
 if JY.Tid==188 then--法正
talk(188,"刘备大人，请一定要为张松报仇．不能让张松死的无价值！");
 end
 if JY.Tid==133 then--庞统
talk(133,"孔明想说什么？主公，听听使者的话吧．");
 end
 end,
 [478]=function()
 if JY.Tid==170 then--黄忠
talk(170,"星象？我真不能理解．");
 end
 if JY.Tid==127 then--魏延
talk(127,"既然军师这么说，就不要出征了．");
 end
 if JY.Tid==365 then--使者
talk(365,"军师是说，出征作战最好等一下．");
 end
 if JY.Tid==128 then--关平
talk(128,"难道星象真那么重要吗？");
 end
 if JY.Tid==117 then--刘封
talk(117,"我听人说过，军师会看星象．");
 end
 if JY.Tid==188 then--法正
talk(188,"刘备大人，请一定要为张松报仇．不能让张松死的没有价值！");
 end
 if JY.Tid==133 then--庞统
talk(1,"孔明这么说，庞统你说该怎么办？",
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
talk(170,"既然决定出征，我听从就是了．");
 end
 if JY.Tid==127 then--魏延
talk(127,"出征吧．");
 end
 if JY.Tid==365 then--使者
talk(365,"那我告辞了．");
 MovePerson(365,10,0);
 DecPerson(365);
 end
 if JY.Tid==128 then--关平
talk(128,"主公，出征吧．");
 end
 if JY.Tid==117 then--刘封
talk(117,"我也要加入战斗．");
 end
 if JY.Tid==188 then--法正
talk(188,"刘备大人，请一定要为张松报仇．不能让张松死的没有价值！");
 end
 if JY.Tid==133 then--庞统
 if talkYesNo( 133,"做好准备了吗？") then
 RemindSave();
 PlayBGM(12);
talk(133,"请编组队伍．");
 WarIni();
 DefineWarMap(33,"第三章 雒I之战","一、刘贵的退却",30,0,193);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,5,17,4,0,-1,0,
 132,23,17,4,0,-1,0,
 -1,22,16,4,0,-1,0,
 -1,7,17,4,0,-1,0,
 -1,6,16,4,0,-1,0,
 -1,22,18,4,0,-1,0,
 -1,23,18,4,0,-1,0,
 -1,6,18,4,0,-1,0,
 -1,5,16,4,0,-1,0,
 -1,4,18,4,0,-1,0,
 -1,4,19,4,0,-1,0,
 });
 DrawSMap();
 JY.Smap={};
 SetSceneID(0,3);
talk(133,"那么向雒城进发．");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 193,23,3,1,0,40,9,0,0,-1,0,
 194,22,5,1,0,36,3,0,0,-1,0,
 196,20,19,4,1,36,3,0,0,-1,1,
 248,26,17,3,1,37,20,0,0,-1,1,
 199,14,4,3,0,37,6,0,0,-1,0,
 200,7,6,3,1,37,9,0,0,-1,0,
 201,8,7,3,1,37,9,0,0,-1,0,
 
 256,5,7,3,1,33,3,0,0,-1,0,
 257,16,4,3,0,33,3,0,0,-1,0,
 292,19,17,4,1,35,9,0,0,-1,1,
 293,20,17,4,1,35,9,0,0,-1,1,
 274,19,18,4,1,32,6,0,0,-1,1,
 275,26,4,1,0,33,6,0,0,-1,0,
 294,6,8,3,1,34,9,0,0,-1,0,
 277,24,5,1,0,33,6,0,0,-1,0,
 310,22,14,1,1,33,12,0,0,-1,1,
 332,21,15,1,1,33,14,0,0,-1,1,
 333,15,5,3,0,32,14,0,0,-1,0,
 295,15,3,3,0,34,9,0,0,-1,0,
 340,25,3,1,0,33,17,0,0,-1,0,
 195,24,14,1,1,37,6,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [480]=function()
 PlayBGM(11);
talk(194,"刘备终于暴露了本性．原来，他还是想夺益州．",
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
talk(196,"果不出我所料．有敌军企图偷越山道．",
 133,"啊……我的计策被识破了．",
 170,"副军师！",
 1,"如果没有庞统，就不能夺得益州．全军去营救副军师！");
 PlayBGM(9);
 NextEvent();
 end,
 [481]=function()
 if JY.Death==133 then
 PlayBGM(2);
talk(133,"我……我要死在这里了吗？……事业未成……我死不瞑目……");
 WarAction(18,133);
 --DrawStrBoxCenter("庞统战死！");
 SetFlag(38,1);
talk(170,"……主公，副军师已经撤退了，我们也退回涪城吧．",
 1,"嗯……那就撤退吧．……庞统，你怎么样了？……");
 DrawMulitStrBox("　刘备放弃攻打雒城．");
 WarGetExp();
 ModifyForce(133,0);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if War.Turn==8 then
talk(196,"……快出来！",
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
talk(194,"没办法，只有固守城池了．",
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
talk(170,"那么回涪城吧．");
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
talk(1,"庞统怎么样了？平安无事吧．",
 117,"……遭到张任伏击，全身中箭身亡……",
 1,"什，什么？刘封，消息确实吗？",
 117,"是……",
 1,"怎么会这样！庞统……");
 else
talk(170,"主公，副军师因去阵地视察，因此不能到这里来了．特向您致歉．",
 1,"是吗？刚才我吓了一跳．万一庞统有个闪失……");
 end
 --显示任务目标:<商讨今后>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [484]=function()
 if JY.Tid==170 then--黄忠
talk(170,"主公，重整队伍，进攻雒城吧，");
 end
 if JY.Tid==127 then--魏延
talk(127,"话虽如此，可是益州兵比想像得厉害．");
 end
 if JY.Tid==128 then--关平
talk(128,"主公，这事最好与孔明商量一下．",
 1,"嗯．你说得不错．那么关平，你就辛苦一趟吧．",
 128,"好的．我马上动身．",
 1,"嗯……把周仓也带去吧．");
 AddPerson(155,44,0,1);
 MovePerson(155,10,1);
talk(155,"是您叫我吗？",
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
talk(117,"雒城是很难攻下的．");
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
talk(128,"……就是如此这般．军师，有什么好主意吗？",
 126,"我立刻派援军．嗯，关羽．还有关平、周仓留下，守卫荆州．",
 2,"知道了．荆州就交给我吧．",
 126,"关羽，他们是你的部下，听从你的调遣．");
 AddPerson(34,3,4,3);
 AddPerson(38,1,5,3);
 AddPerson(39,-1,6,3);
 MovePerson( 38,5,3,
 34,5,3,
 39,5,3)
talk(38,"我是王甫．听从关羽将军的吩咐．",
 34,"我是廖化．很高兴在关羽手下工作．",
 39,"我叫赵累．请多关照．",
 2,"今后请你们多帮助．");
talk(126,"那么，张飞、赵云，你们二人兵分两路，入川支援主公．",
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
talk(369,"报告大人，张飞的援军到了．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [487]=function()
 if JY.Tid==170 then--黄忠
talk(170,"好像是军师很快采取措施了．");
 end
 if JY.Tid==127 then--魏延
talk(127,"能这么快地长驱直入，不愧是猛张飞呀．");
 end
 if JY.Tid==133 then--庞统
talk(133,"因为我没有做好准备，就冒然进攻，竟落到如此结果．");
 end
 if JY.Tid==369 then--武官
talk(1,"快叫张飞来．",
 369,"是！");
 MovePerson(369,10,0);
 DecPerson(369);
talk(1,"来得真快呀！从荆州到蜀的这一路上都有蜀军把守吧．",
 170,"是呀……哎，主公，张飞到了．");
 AddPerson(3,43,0,1);
 AddPerson(203,45,-1,1);
 MovePerson( 3,12,1,
 203,12,1);
talk(3,"大哥，我来了．",
 1,"嗯，张飞，你可来了！你后面的人是谁？",
 3,"这位是严颜，一路上多亏有他给我们带路．");
 NextEvent();
 end
 end,
 [488]=function()
 if JY.Tid==170 then--黄忠
talk(170,"是严颜吗？看上去也是员老将．");
 end
 if JY.Tid==127 then--魏延
talk(127,"黄忠和严颜真可谓老当益壮．");
 end
 if JY.Tid==133 then--庞统
talk(133,"张飞不但有勇，而且有谋，不愧是主公义弟呀！");
 end
 if JY.Tid==3 then--张飞
talk(3,"按照军师的命令，军师、赵云和我分三路入川．在途中，我说服了守城的老将军严颜．后来，严颜为我军做向导，所以很快就到达了．");
if CC.Enhancement then
if not GetFlag(38) then
DrawStrBoxCenter("张飞获得隐藏天赋攻心！");
end
end
 NextEvent();
 end
 if JY.Tid==203 then--严颜
talk(203,"您好．我叫严颜．");
 end
 end,
 [489]=function()
 if JY.Tid==170 then--黄忠
talk(170,"是严颜吗？看上去也是员老将．");
 end
 if JY.Tid==127 then--魏延
talk(127,"黄忠和严颜真可谓老当益壮．");
 end
 if JY.Tid==133 then--庞统
talk(133,"张飞不但有勇，而且有谋，不愧是主公义弟呀！能说服敌人武将，不是只凭武力所能做到的．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，向严颜道谢吧．");
 end
 if JY.Tid==203 then--严颜
talk(1,"蒙您给张飞带路，我刘备特向您道谢．",
 203,"不，不敢当．您太客气了．",
 1,"今后，请全力支持．",
 203,"那是当然，谢谢您让我加入．");
 ModifyForce(203,1);
 PlayWavE(11);
 DrawStrBoxCenter("严颜成为部下！");
talk(203,"刘备主公，益州的武将，也就是我的同仁，也有为益州的前途担忧的．如果向他们说清楚，我想会有向您投诚的．",
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
talk(170,"重编队伍吧．");
 WarIni();
 DefineWarMap(33,"第三章 雒II之战","一、刘贵的毁灭",40,0,193);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,18,22,3,0,-1,0,
 -1,16,22,3,0,-1,0,
 -1,17,22,3,0,-1,0,
 -1,19,22,3,0,-1,0,
 -1,18,21,3,0,-1,0,
 -1,20,21,3,0,-1,0,
 -1,19,20,3,0,-1,0,
 -1,17,23,3,0,-1,0,
 -1,19,23,3,0,-1,0,
 53,3,19,4,0,-1,1,
 125,1,20,4,0,-1,1,
 113,2,19,4,0,-1,1,
 82,0,20,4,0,-1,1,
 });
 DrawSMap();
talk(170,"这次一定要攻克雒城，");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==127 then--魏延
talk(127,"援军到了，该出征了．");
 end
 if JY.Tid==133 then--庞统
 if talkYesNo( 133,"那么出征吗？") then
 RemindSave();
 PlayBGM(12);
talk(133,"重编队伍吧．");
 WarIni();
 DefineWarMap(33,"第三章 雒II之战","一、刘贵的毁灭",40,0,193);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,18,22,3,0,-1,0,
 -1,16,22,3,0,-1,0,
 -1,17,22,3,0,-1,0,
 -1,19,22,3,0,-1,0,
 -1,18,21,3,0,-1,0,
 -1,20,21,3,0,-1,0,
 -1,19,20,3,0,-1,0,
 -1,17,23,3,0,-1,0,
 -1,19,23,3,0,-1,0,
 53,3,19,4,0,-1,1,
 125,1,20,4,0,-1,1,
 113,2,19,4,0,-1,1,
 82,0,20,4,0,-1,1,
 });
 DrawSMap();
talk(133,"这次一定要攻克雒城，");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，我来了．您就放心吧．");
 end
 if JY.Tid==203 then--严颜
talk(203,"我虽然岁数大了，但一定会尽力的．");
 end
 end,
 [491]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(3,"雒城就在前面吧．大哥，快走！");
 ModifyForce(126,1);
 ModifyForce(54,1);
 ModifyForce(114,1);
 ModifyForce(83,1);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 193,23,3,1,0,44,9,0,0,-1,0,
 194,22,4,1,0,39,3,0,0,-1,0,
 196,12,16,4,1,39,3,0,0,-1,0,
 195,24,4,1,0,39,6,0,0,-1,0,
 199,6,6,1,0,37,6,0,0,-1,0,
 200,5,8,1,0,37,9,0,0,-1,0,
 201,7,16,4,1,37,9,0,0,-1,0,
 248,10,18,4,1,41,20,0,0,-1,0,
 274,7,7,1,0,33,6,0,0,-1,0,
 275,12,18,4,1,32,6,0,0,-1,0,
 256,21,3,3,0,33,3,0,0,-1,0,
 257,11,19,4,1,33,3,0,0,-1,0,
 292,25,3,1,0,36,9,0,0,-1,0,
 293,5,14,4,1,35,9,0,0,-1,0,
 332,13,17,4,1,35,14,0,0,-1,0,
 333,6,15,4,1,34,14,0,0,-1,0,
 294,11,17,4,1,35,9,0,0,-1,0,
 340,5,6,1,0,35,17,0,0,-1,0,
 341,4,7,1,0,34,17,0,0,-1,0,
 197,14,1,3,1,40,3,0,0,-1,1,
 198,15,2,3,1,40,9,0,0,-1,1,
 253,15,0,3,1,36,6,0,0,-1,1,
 254,16,1,3,1,36,3,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [492]=function()
 PlayBGM(11);
talk(194,"刘备不顾打了败仗，又打来了．各位，为了刘璋主公好好打！",
 201,"……",
 202,"为了刘璋，唉……");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [493]=function()
 if WarMeet(3,196) then
 WarAction(1,3,196);
talk(3,"谁敢与我张飞交手？出来吧．",
 196,"什么？是张飞？如果我能打败张飞，会大大提高我军士气．好吧，张飞．我张任来与你交手．",
 3,"张任？谁都行．过来吧．");
 WarAction(6,3,196);
 if fight(3,196)==1 then
talk(196,"好家伙，真打不过他．",
 3,"别在那里发呆！");
 WarAction(4,3,196);
talk(3,"你不是我的对手．",
 196,"……你在干什么？快过来交手？",
 3,"杀死你真是易如反掌．我说，刘璋大势已去，你不如投降我们，胜于白白送死．",
 196,"……你在说什么？想要我投降？不！我宁死不降．",
 3,"你真是个忠臣，我了解你．那么，我只有杀死你了！",
 196,"哎呀！",
 3,"……哼！");
 WarAction(8,3,196);
talk(196,"杀死我吧……谢谢……");
 WarAction(18,196);
talk(3,"……真可惜．这小子是个武将！");
 WarLvUp(GetWarID(3));
 else
 WarAction(4,196,3);
talk(3,"哎呀！好家伙，真打不过他．");
 WarAction(17,3);
 WarLvUp(GetWarID(196));
 end
 end
 if (not GetFlag(39)) and WarMeet(1,200) then
 WarAction(1,1,200);
 PlayBGM(11);
talk(1,"吴懿，连严颜都投降我们了，你又为什么要白白流血呢？怎么样，投降我们吧？",
 200,"……明白了，我愿为刘备效力．");
 ModifyForce(200,1);
 PlayWavE(11);
 DrawStrBoxCenter("吴懿成为部下！");
talk(200,"不过，我不想跟以前的同伴交战，我先撤退了．");
 WarAction(16,200);
 SetFlag(39,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if (not GetFlag(40)) and WarMeet(1,201) then
 WarAction(1,1,201);
 PlayBGM(11);
talk(1,"吴兰，不想建设新益州吗？与我们一起努力吧．",
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
talk(1,"雷铜，我不是来这里抢掠的．而是因为刘璋黯弱，不能抵御曹操．怎么样，与我一起抵御曹操好吗？",
 202,"嗯，确实是这样．刘璋不知何时就会被打垮，不如……好吧，我雷铜从今天起就是刘备的部下了．");
 ModifyForce(202,1);
 PlayWavE(11);
 DrawStrBoxCenter("雷铜成为部下！");
talk(202,"不过，我不忍与过去的朋友交手，我先走了．");
 WarAction(16,202);
 SetFlag(41,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if (not GetFlag(42)) and WarMeet(1,254) then
 WarAction(1,1,254);
 PlayBGM(11);
talk(1,"李严，益州的归属已定，不如老老实实的投降，胜于白白送死．",
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
talk(1,"费观，同严颜一样，其他的武将都投降了．你投不投降？",
 255,"说的不错．连严颜都加入了你们，他是不会看错人的．好吧，我投降．");
 ModifyForce(255,1);
 PlayWavE(11);
 DrawStrBoxCenter("费观成为部下！");
talk(255,"那么，打完仗再见．");
 WarAction(16,255);
 SetFlag(43,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if (not GetFlag(1050)) and War.Turn==2 then
talk(1,"不好……这次又要苦战了．",
 1,"哎！那是谁？");
 PlayBGM(12);
 WarShowArmy(54-1);
 WarShowArmy(114-1);
 WarShowArmy(83-1);
 WarShowArmy(126-1);
talk(54,"我是赵云，支援您来了！诸位，跟我来！",
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
talk(54,"那是……敌人援军吗？");
 WarShowArmy(197);
 WarShowArmy(198);
 WarShowArmy(253);
 WarShowArmy(254);
talk(198,"刘备军终于来了．诸位，为了蜀国，勇敢地战斗啊！",
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
talk(54,"那是……敌人援军吗？");
 WarShowArmy(197);
 WarShowArmy(198);
 WarShowArmy(253);
 WarShowArmy(254);
talk(198,"刘备军终于来了．诸位，为了蜀国，勇敢地战斗啊！",
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
talk(194,"什么？部分敌人越过山道，逼近城池了？",
 196,"刘备这小子怎么又来了……嗯！？");
 WarShowArmy(197);
 WarShowArmy(198);
 WarShowArmy(253);
 WarShowArmy(254);
talk(198,"刘备军终于来了．诸位，为了蜀国，勇敢地战斗啊！",
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
talk(1,"好，城内几乎没有敌人了．各位，一鼓作气攻陷雒城！");
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
talk(126,"主公，该进雒城了．");
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
talk(369,"报告！我军在雒城吃了大败仗，主要将领全部阵亡！",
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
talk(369,"……就是这样，请张鲁大人一定要同意．",
 205,"我明白了．我要考虑一下，你先去休息吧．",
 369,"好的．");
 MovePerson(369,12,0);
 DecPerson(369);
talk(205,"怎么办？对刘璋采取什么态度？",
 206,"以前与我们打仗的事，您难道忘了吗？",
 250,"嗯．如果让刘璋和刘备互相争斗，那就再好不过了．",
 205,"是啊……");
 AddPerson(190,43,-1,1);
 MovePerson(190,12,1);
talk(190,"张鲁大人，听说刘璋派人请求援军是吗？",
 205,"不错．我们正在考虑如何答覆．",
 190,"如果出兵的话，请一定带我一起上阵．",
 190,"遭曹操所败投奔到此的我，受到这么周到的照顾，因此我要报恩．",
 205,"嗯……有马超就放心了．好吧，我决定出兵！马超，看你的了！",
 190,"噢，太谢谢了．");
 JY.Smap={};
 SetSceneID(0);
talk(205,"好！那么，向蜀国边境上的葭萌关进发！");
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
talk(126,"主公，祝贺您攻取雒城．使者来了．");
 AddPerson(365,41,25,2);
 MovePerson(365,12,2);
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [498]=function()
 if JY.Tid==3 then--张飞
talk(3,"怎么回事？这时候会有什么事？");
 end
 if JY.Tid==54 then--赵云
talk(54,"猜不出来发生了什么事．还是先听听报告吧．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"发生了什么事？");
 end
 if JY.Tid==127 then--魏延
talk(127,"主公，听听使者的汇报吧．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公，先听听使者说什么．");
 end
 if JY.Tid==133 then--庞统
talk(133,"主公，先听听使者说什么．");
 end
 if JY.Tid==365 then--使者
talk(365,"主公，大事不好！益州北边的汉中张鲁，发兵攻打我们．",
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
talk(3,"听说马超很厉害．大哥，务必带我去．");
 end
 if JY.Tid==54 then--赵云
talk(54,"徵求一下军师的意见．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"赶快制定对策．");
 end
 if JY.Tid==127 then--魏延
talk(127,"马上就要进攻蜀都了，又遇见了麻烦．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"这是刘璋的策略．刘璋想让张鲁插入我背后，形成对我军的夹击．而且，有马超在，对我军是个威胁．因此必须迎击张鲁．",
 1,"孔明，马超真的这么厉害吗？",
 126,"是的．听说曹操曾被马超杀得割须弃袍，咱们不能小看他．",
 1,"嗯……那就派援军吧．可是，让谁在这里抗拒刘璋呢？",
 126,"那么我留守在这里吧．请主公亲自率兵，对付张鲁．请做好出征的准备．");
 ModifyForce(126,0);
 NextEvent();
 end
 if JY.Tid==133 then--庞统
talk(133,"果然来了．这大概是刘璋策划的．");
 end
 if JY.Tid==365 then--使者
talk(365,"张鲁军人数不少．");
 end
 end,
 [500]=function()
 if JY.Tid==3 then--张飞
talk(3,"听说马超很厉害．大哥，一定要带我去．");
 end
 if JY.Tid==54 then--赵云
talk(54,"主公，请做好出征的准备．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"听说马超是个武艺出众的人．可是主公，没人能打败我．");
 end
 if JY.Tid==127 then--魏延
talk(127,"马上就要进攻蜀都了，又遇见了麻烦．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"主公，准备好了吗？") then
 RemindSave();
 PlayBGM(12);
talk(126,"请列好部队．");
 WarIni();
 DefineWarMap(37,"第三章 葭萌关I之战","一、张鲁撤退",30,0,204);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,1,8,4,0,-1,0,
 2,1,9,4,0,-1,0,
 -1,2,7,4,0,-1,0,
 -1,2,9,4,0,-1,0,
 -1,2,10,4,0,-1,0,
 -1,4,7,4,0,-1,0,
 -1,4,8,4,0,-1,0,
 -1,3,8,4,0,-1,0,
 -1,3,9,4,0,-1,0,
 -1,0,7,4,0,-1,0,
 });
 DrawSMap();
talk(126,"那么，早点出发吧．");
 JY.Smap={};
 SetSceneID(0,3);
talk(1,"据说敌人在葭萌关．那么赶快出发吧．");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 204,18,9,3,2,45,12,0,0,-1,0,
 205,18,10,3,0,40,6,0,0,-1,0,
 249,17,9,3,0,40,21,0,0,-1,0,
 24,17,6,3,4,39,12,11,3,-1,0,
 22,16,12,3,4,39,6,11,15,-1,0,
 256,17,10,3,0,34,3,0,0,-1,0,
 257,15,7,3,4,34,3,11,3,-1,0,
 258,15,11,3,4,35,3,11,15,-1,0,
 259,16,7,3,4,35,3,11,3,-1,0,
 
 274,17,8,3,4,36,6,11,3,-1,0,
 275,16,11,3,0,35,6,0,0,-1,0,
 276,16,8,3,0,36,6,0,0,-1,0,
 292,16,10,3,4,38,9,11,15,-1,0,
 293,15,9,3,4,39,9,11,15,-1,0,
 189,8,16,2,3,41,9,2,0,-1,1,
 203,8,18,2,1,40,9,0,0,-1,1,
 294,8,15,2,1,39,9,0,0,-1,1,
 295,7,16,2,1,39,9,0,0,-1,1,
 296,9,17,2,1,39,9,0,0,-1,1,
 297,8,19,2,1,39,9,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 if JY.Tid==133 then--庞统
talk(133,"主公，请做好准备．");
 end
 if JY.Tid==365 then--使者
talk(365,"张鲁军人数不少．");
 end
 end,
 [501]=function()
 PlayBGM(11);
talk(205,"那是刘备军吗？如果能打败他，益州的一半就归我了．各位，冲啊！",
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
talk(205,"马超怎么还不来？嗯，终于来了．");
 PlayBGM(11);
 WarShowArmy(189);
 WarShowArmy(203);
 WarShowArmy(294);
 WarShowArmy(295);
 WarShowArmy(296);
 WarShowArmy(297);
 DrawStrBoxCenter("马超军出现了！");
talk(190,"张鲁好像陷入了苦战．我要让刘备知道知道我马超的厉害！走，跟我来！",
 1,"嗯？那就是马超吗？早就听说他是员勇将，但究竟是何等人物啊……");
 SetFlag(170,1);
 end
 if WarMeet(3,190) then
 WarAction(1,3,190);
talk(190,"在那里的看样子是有名的武将，我是马超，敌将通名！",
 3,"我乃张飞是也！你就是马超吗？",
 190,"张飞？没听说过．山野村夫我可没听过．",
 3,"什么？！你敢如此无礼！我要杀了你！");
 WarAction(6,3,190);
 if fight(3,190)==1 then
talk(3,"这，挺厉害．这小子还有两下子．",
 190,"他还挺能打．不过越是勇将，能杀死他越过瘾．");
 WarAction(6,3,190);
 WarAction(6,3,190);
 WarAction(10,3,190);
talk(190,"……好了，今天就打到这里，收兵！",
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
talk(3,"这，挺厉害．这小子还有两下子．",
 190,"他还挺能打．不过越是勇将，能杀死他越过瘾．");
 WarAction(6,3,190);
 WarAction(6,3,190);
 WarAction(10,3,190);
talk(3,"日后再分胜负吧！");
 WarAction(16,3);
 WarLvUp(GetWarID(190));
 end
 end
 if JY.Status==GAME_WARWIN then
talk(205,"没打赢，收兵吧！");
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
talk(126,"主公，您辛苦了．",
 1,"嗯？这不是孔明吗？你怎么来了？",
 126,"我不放心战况，因此赶到这里，想商量一下马超的事．");
 ModifyForce(126,1);
 --显示任务目标:<商讨今后>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [504]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，军师来了．");
 end
 if JY.Tid==54 then--赵云
talk(54,"军师来了，与他谈谈吧．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"军师驾到．");
 end
 if JY.Tid==127 then--魏延
talk(127,"军师驾到．");
 end
 if JY.Tid==133 then--庞统
talk(133,"孔明来了．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"听说马超是一员虎将．",
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
talk(126,"主公，马超来投降了．马超，请进．");
 AddPerson(190,33,7,1);
 AddPerson(204,31,6,1);
 MovePerson( 190,6,1,
 204,6,1);
talk(190,"我是马超．我马超和旁边的马岱，愿意一起投效您，刘备．");
 NextEvent();
 end
 end,
 [505]=function()
 if JY.Tid==3 then--张飞
talk(3,"是个勇将，可以大增战斗力．");
 end
 if JY.Tid==54 then--赵云
talk(54,"能这样增强战斗力是一件大好事．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"看上去，他还是个年轻人，我应该比他强．");
 end
 if JY.Tid==127 then--魏延
talk(127,"我虽然也算强者，可是在刘备军中，确实有不少勇将．");
 end
 if JY.Tid==133 then--庞统
talk(133,"马超可以成为我军中少有的勇猛之将，从而大大增强我军战斗力．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公，马超投降来了．");
 end
 if JY.Tid==190 then--马超
talk(1,"欢迎你，马超．",
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
talk(190,"刘备主公，我愿意去说服刘璋，作为归顺的见面礼．",
 1,"劝说刘璋？",
 190,"是的，就交给我吧．张鲁也已经撤回汉中，刘璋已失去得力部下，我想一定能说服他．",
 1,"孔明，你怎么看？",
 126,"马超说的不错，现在可以使刘璋不战而降．不过，你要是想用武力征服他，也是可行的．",
 1,"嗯……那怎么办呢？");
 NextEvent();
 end
 if JY.Tid==204 then--马岱
talk(204,"我是马超的亲戚，名叫马岱．");
 end
 end,
 [506]=function()
 if JY.Tid==3 then--张飞
talk(3,"我宁愿选择战争．");
 end
 if JY.Tid==54 then--赵云
talk(54,"到底选择那个，您看着办吧．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"我想战．军人就应该战争．");
 end
 if JY.Tid==127 then--魏延
talk(127,"听从主公的意愿．");
 end
 if JY.Tid==133 then--庞统
talk(133,"刘璋已无战斗力．不论降伏还是打败他，都不是件困难事．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"马超说的不错，现在可以使刘璋不战而降．不过，你要是想用武力征服他，也是可行的．");
 end
 if JY.Tid==190 then--马超
 if talkYesNo( 190,"下决心了吗？") then
 RemindSave();
 DrawSMap();
 local menu={
 {"　 交给马超办",nil,1},
 {"　不交给马超办",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,M_White,M_White);
 if r==1 then
talk(190,"啊！能得到批准，太感谢了．那我们就去成都了．马岱，走吧．",
 204,"是．");
 MovePerson( 190,6,0,
 204,6,0);
 DecPerson(190);
 DecPerson(204);
 DrawSMap();
 JY.Smap={};
 SetSceneID(0);
talk(126,"那么主公，我们回雒城吧．");
 JY.Base["现在地"]="雒";
 DrawMulitStrBox("　马超去说服刘璋．*　刘璋已经既无战斗力，也无得力部下．*　刘璋为了避免流血，接受了马超的劝降．");
 SetSceneID(0);
talk(190,"刘备主公，恭喜你！刘璋同意投降．",
 1,"啊！太好了．",
 190,"这是刘璋归降的证据，我带了过来，请收下吧．");
 GetItem(1,6);
talk(190,"刘璋现在正在成都等候您，请速去成都．",
 126,"马超，谢谢你．那么主公，快去成都吧．");
 SetSceneID(0,3);
talk(190,"刘璋在成都等候，快点走吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(512); --goto 512
 elseif r==2 then
talk(190,"是吗……那我愿意为您在沙场上建立功勳．",
 126,"据说刘璋据守成都．做好出征准备．",
 3,"好．那么大哥，我们先去做准备了．",
 126,"不必在这里做准备，去涪城吧．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end
 if JY.Tid==204 then--马岱
talk(204,"我们西凉人是马上民族，与叫做羌族的异族有血缘关系．");
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
talk(126,"主公，其他武将已经整装待发，请您也做好准备．");
 --显示任务目标:<做出征成都的准备>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [508]=function()
 if JY.Tid==190 then--马超
talk(190,"驰骋疆场，建立功勳．");
 end
 if JY.Tid==204 then--马岱
talk(204,"请多关照我和马超．");
 end
 if JY.Tid==133 then--庞统
talk(133,"刘璋已无战斗力．打败他不是件困难事．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 PlayBGM(12);
 WarIni();
 DefineWarMap(34,"第三章 成都之战","一、刘璋投降．",40,0,188);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,26,1,3,0,-1,0,
 -1,24,1,3,0,-1,0,
 -1,25,0,3,0,-1,0,
 -1,25,2,3,0,-1,0,
 -1,25,3,3,0,-1,0,
 -1,26,3,3,0,-1,0,
 -1,27,0,3,0,-1,0,
 -1,27,2,3,0,-1,0,
 -1,27,4,3,0,-1,0,
 });
 DrawSMap();
talk(126,"出征．");
 JY.Smap={};
 SetSceneID(0,3);
talk(126,"成都是在南方的大城市．向成都进发吧．");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 188,1,10,4,2,44,3,0,0,-1,0,
 23,11,5,4,2,38,20,0,0,-1,0,
 208,8,16,4,2,36,15,0,0,-1,0,
 34,16,13,4,2,37,17,0,0,-1,0,
 90,18,5,4,2,36,6,0,0,-1,0,
 207,8,15,4,2,37,14,0,0,-1,0,
 190,11,6,4,2,37,3,0,0,-1,0,
 274,2,10,4,0,36,6,0,0,-1,0,
 275,10,4,4,4,36,6,11,4,-1,0,
 276,16,12,4,0,36,6,0,0,-1,0,
 
 292,10,6,4,4,37,9,10,5,-1,0,
 293,15,13,4,0,37,9,0,0,-1,0,
 294,7,14,4,4,37,9,8,14,-1,0,
 295,9,5,4,0,36,9,0,0,-1,0,
 296,7,16,4,0,36,9,0,0,-1,0,
 332,3,9,4,0,34,14,0,0,-1,0,
 333,19,9,4,4,34,14,19,7,-1,0,
 277,6,13,4,4,35,6,7,15,-1,0,
 340,3,11,4,0,36,17,0,0,-1,0,
 341,17,4,4,0,35,17,0,0,-1,0,
 342,21,9,4,0,35,17,0,0,-1,0,
 343,16,14,4,0,36,17,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [509]=function()
 PlayBGM(11);
talk(189,"刘备打过来了！各位，你们要好好保护我．",
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
talk(191,"您就是刘备吗？我是张松和法正的至友，名叫孟达．我也想像他们那样，做您的部下．");
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
talk(24,"刘璋不听我的忠言，才落到今天这个境地．刘备大人，我相信你能挽救益州．");
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
talk(208,"刘备大人，请收我做部下．");
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
talk(91,"刘备大人，我愿做您的部下．");
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
talk(209,"我已经对刘璋失去了信心．刘备大人，请收下我做部下吧．");
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
talk(35,"我是刘璋用钱雇用来的．但是，刘璋已经不能再付我钱了．那样的话，我与其战死还不如归降您．");
 ModifyForce(35,1);
 PlayWavE(11);
 DrawStrBoxCenter("沙摩可成为部下！");
 SetFlag(49,1);
 WarLvUp(GetWarID(1));
 PlayBGM(14);
 end
 if WarMeet(1,189) then
 WarAction(1,1,189);
talk(189,"唉……益州的武将和民众都已经离开我了吗？没办法，投降吧……");
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
talk(189,"唉……益州的武将和民众都已经离开我了吗？没办法，投降吧……");
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
talk(126,"那么，就进成都吧．");
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
talk(189,"那么，这是统治益州的证物印绶，请收下它吧．",
 1,"嗯……，刘璋，我这样做是为了与曹操斗争到底，恢复汉朝威严，我希望你能了解我．",
 189,"我很了解．",
 126,"那么，刘璋，我已经在荆州为你准备了住处，请到那里去住吧．",
 189,"好的．");
 MovePerson(189,12,3);
talk(1,"那么今后益州由我刘备治理．诸位，你们要更加努力把国家建设好！");
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
talk(9,"陛下，请给我们下达出击的命令．",
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
talk(9,"那么，我替陛下向全军下达出击的命令．曹洪听令！",
 20,"曹洪在！");
 MovePerson(20,3,3);
 MovePerson(20,0,0);
talk(9,"命你为汉中主将，指挥全军，夏侯渊为副将，一定要把逆贼刘备杀死！",
 20,"是！遵命！");
 MovePerson( 20,12,1,
 103,12,1,
 18,12,1,
 79,12,1);
talk(383,"皇叔……对不起……");
 
 JY.Smap={};
 SetSceneID(0);
talk(20,"好．在汉中召开军事会议！");
 
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
talk(20,"诸位将军，我要分派任务了．夏侯渊听令！",
 18,"在！");
 MovePerson(18,3,0);
 MovePerson(18,3,3);
 MovePerson(18,3,1);
talk(20,"夏侯渊，命你镇守定军山．此山位于蜀国边境，是很重要的军事阵地．",
 18,"明白了．那么我走了．",
 20,"嗯．");
 MovePerson(18,14,0);
talk(20,"夏侯德听令！",
 211,"在！");
 MovePerson(211,2,0);
 MovePerson(211,3,3);
 MovePerson(211,3,1);
talk(20,"命你镇守天荡山，此处与定军山一样，都是边境重地．",
 211,"明白了！");
 MovePerson(211,14,0);
talk(20,"其余的人作为预备队留守这里．要注意观察刘备的动向，随时准备投入战斗．");
 MovePerson(103,2,0);
 MovePerson(103,3,2);
 MovePerson(103,3,1);
talk(103,"将军，咱们就在这里静观战局吗？",
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
talk(18,"好啦，向定军山进发！",
 211,"咱们去天荡山！前进！");
 SetSceneID(0);
talk(103,"哼！刘备的情况，我以前在袁绍手下时就知道，刘备没什么可怕的！我们向瓦口关出击，在瓦口关消灭他们！");
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
talk(126,"主公，你听说了吗？曹操已经占领了汉中．",
 1,"嗯．曹操占领汉中是想最终占领蜀．",
 126,"是呀，确实是这样，而且曹操已经行动了……主公，好像来了使者．");
 AddPerson(369,37,23,2);
 MovePerson(369,11,2);
talk(369,"禀报主公．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [516]=function()
 if JY.Tid==3 then--张飞
talk(3,"怎么啦？曹操要进攻我们吗？");
 end
 if JY.Tid==54 then--赵云
talk(54,"主公，先听听报告吧．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"说实话，我是第一次与曹军交战，很想打一仗．");
 end
 if JY.Tid==190 then--马超
talk(190,"以前，我曾败于曹军．要在这一战中报此仇，雪先父之恨．");
 end
 if JY.Tid==133 then--庞统
talk(133,"夺取益州后，我军士气高昂．现在正是与曹操交手的时候．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"先听听报告吧．");
 end
 if JY.Tid==369 then--武官
talk(369,"报告，曹操部下武将张颌，率军入侵瓦口关．",
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
talk(3,"大哥，交给我吧．");
 end
 if JY.Tid==54 then--赵云
talk(54,"不能只让张飞立功，我也要去．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"说实话，我是第一次与曹军交战，很想打一仗．");
 end
 if JY.Tid==190 then--马超
talk(190,"以前，我曾败于曹军．要在这一战中报此仇，雪先父之恨．");
 end
 if JY.Tid==133 then--庞统
talk(133,"夺取益州后，我军士气高昂．现在正是与曹操交手的时候．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"出征吗？") then
 RemindSave();
 PlayBGM(12);
talk(126,"请点兵派将．");
 WarIni();
 DefineWarMap(35,"第三章 瓦口关I之战","一、张颌的败退",40,0,102);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,17,13,3,0,-1,0,
 -1,16,12,3,0,-1,0,
 -1,18,13,3,0,-1,0,
 -1,15,11,3,0,-1,0,
 -1,15,13,3,0,-1,0,
 -1,19,12,3,0,-1,0,
 -1,19,14,3,0,-1,0,
 -1,14,12,3,0,-1,0,
 -1,13,11,3,0,-1,0,
 -1,13,12,3,0,-1,0,
 -1,20,13,3,0,-1,0,
 -1,20,14,3,0,-1,0,
 });
 DrawSMap();
talk(126,"那么，向瓦口关进发．");
 JY.Smap={};
 SetSceneID(0,3);
talk(126,"瓦口关位于葭萌关东面．快点出发吧．");
 ModifyForce(103,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 102,16,1,3,0,46,22,0,0,-1,0,
 256,23,17,3,1,40,3,0,0,-1,1,
 257,27,17,3,1,39,3,0,0,-1,1,
 258,15,1,3,0,39,3,0,0,-1,0,
 259,13,1,3,1,40,3,0,0,-1,0,
 260,11,3,3,1,40,3,0,0,-1,0,
 274,20,18,3,1,37,6,0,0,-1,1,
 275,15,16,2,1,36,6,0,0,-1,1,
 276,14,2,3,0,37,6,0,0,-1,0,
 292,7,7,4,1,42,9,0,0,-1,0,
 293,8,6,4,1,42,9,0,0,-1,0,
 294,12,2,3,1,41,9,0,0,-1,0,
 295,25,18,3,1,40,9,0,0,-1,1,
 296,6,8,4,1,41,9,0,0,-1,0,
 332,22,18,3,1,41,14,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [518]=function()
 PlayBGM(11);
talk(103,"到底打来了，刘备啊！我知道你虎视眈眈．会打进汉中来．我先来一步打你们．将士们，刘备在哪里，全体进攻！",
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
talk(202,"魏军，还想得陇望蜀．我雷铜把你们打垮了．",
 103,"好大胆，你胆敢和我张颌较量！有意思，我来逗逗你．过来！");
 WarAction(6,202,103);
 if fight(202,103)==1 then
talk(103,"一招，两招……怎么样？",
 202,"还杀不了你，再砍过一刀．");
 WarAction(4,202,103);
talk(103,"啊……！",
 103,"好家伙！刘备的兵不好打．退兵，回瓦口关防守敌人．");
 WarLvUp(GetWarID(202));
 WarAction(16,103);
 NextEvent();
 else
talk(103,"一招，两招……怎么样？",
 202,"还杀不了你，再砍过一刀．");
 WarAction(4,103,202);
talk(202,"不行！杀不过他！",
 103,"这么点本事，还想杀我．看我一刺．");
 WarAction(8,103,202);
talk(202,"哎呀！",
 202,"好厉害，打不过他．……逃吧．");
 WarAction(17,202);
talk(103,"嘿嘿！蜀军都不经一打．");
 WarLvUp(GetWarID(103));
 end
 end
 if (not GetFlag(1054)) and War.Turn==3 then
talk(103,"刘备，你已被四面包围，束手待毙．我来取你首级！好！全军前进！");
 WarModifyAI(102,1);
 WarModifyAI(258,1);
 WarModifyAI(276,1);
 SetFlag(1054,1);
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(11);
talk(103,"好家伙！刘备的兵不好打．退兵，回瓦口关防守敌人．");
 NextEvent();
 end
 end,
 [520]=function()
 PlayBGM(7);
talk(126,"主公，敌军退回瓦口关了．我们追击敌军吧！");
 JY.Status=GAME_WMAP2;
 NextEvent();
 end,
 [521]=function()
 WarIni2();
 DefineWarMap(36,"第三章 瓦口关II之战","一、张颌的撤退",40,0,102);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm2(1,{
 0,23,17,3,0,-1,0,
 -1,23,16,3,0,-1,0,
 -1,21,16,3,0,-1,0,
 -1,21,18,3,0,-1,0,
 -1,24,17,3,0,-1,0,
 -1,24,18,3,0,-1,0,
 -1,20,17,3,0,-1,0,
 -1,20,19,3,0,-1,0,
 -1,22,17,3,0,-1,0,
 -1,25,15,3,0,-1,0,
 -1,25,17,3,0,-1,0,
 -1,26,16,3,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 102,10,2,1,2,48,22,0,0,-1,0,
 129,8,4,1,4,42,3,5,8,-1,0,
 209,12,4,1,4,42,21,12,11,-1,0,
 256,9,2,1,0,41,3,0,0,-1,0,
 257,11,2,1,0,41,3,0,0,-1,0,
 258,8,5,1,4,40,3,4,9,-1,0,
 259,8,3,1,4,38,3,3,10,-1,0,
 260,9,4,1,4,40,3,2,10,-1,0,
 261,12,5,1,4,38,3,11,12,-1,0,
 262,11,4,1,4,39,3,12,12,-1,0,
 263,12,3,1,4,39,3,13,12,-1,0,
 336,10,3,1,0,41,15,0,0,-1,0,
 337,7,4,1,4,40,15,5,10,-1,0,
 338,13,4,1,4,41,15,12,13,-1,0,
 });
 War.Turn=1;
 NextEvent();
 end,
 [522]=function()
 PlayBGM(11);
talk(103,"刚才没有打好仗，这次能好好打了．而且已给汉中的曹洪去信，要求派兵支援．刘备，来攻打吧！",
 126,"主公，往上看那是瓦口关．我们要把张颌赶出瓦口关．");
 WarShowTarget(true);
 PlayBGM(19);
 NextEvent();
 end,
 [523]=function()
 if WarMeet(202,103) then
 WarAction(1,202,103);
talk(202,"魏军，还想得陇望蜀．我雷铜把你们打垮了．",
 103,"好大胆，你胆敢和我张颌较量！有意思，我来逗逗你．过来！");
 WarAction(6,202,103);
 if fight(202,103)==1 then
talk(103,"一招，两招……怎么样？",
 202,"还杀不了你，再砍过一刀．");
 WarAction(4,202,103);
talk(103,"啊……！",
 103,"可！可没有想到刘备军这么凶，撤……，撤退！");
 WarLvUp(GetWarID(202));
 WarAction(16,103);
 DrawMulitStrBox("　张颌军撤退了．");
 NextEvent();
 else
talk(103,"一招，两招……怎么样？",
 202,"还杀不了你，再砍过一刀．");
 WarAction(4,103,202);
talk(202,"不行！杀不过他！",
 103,"这么点本事，还想杀我．看我一刺．");
 WarAction(8,103,202);
talk(202,"哎呀！",
 202,"好厉害，打不过他．……逃吧．");
 WarAction(17,202);
talk(103,"嘿嘿！蜀军都不经一打．");
 WarLvUp(GetWarID(103));
 end
 end
 if (not GetFlag(1055)) and War.Turn==7 then
 PlayBGM(11);
talk(103,"来了，援兵？什么，不派援兵来了．为什么？原来主帅对上次的争吵抱有成见．还记仇啊！这就不好打了．");
 PlayBGM(19);
 SetFlag(1055,1);
 end
 if JY.Status==GAME_WARWIN then
talk(103,"可！可没有想到刘备军这么凶，撤……，撤退！");
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
talk(126,"虽然击退了张颌，可是曹操是不会善罢干休的，他一定还会采取什么军事行动．");
 SetSceneID(0,11);
talk(20,"什么？！张颌被刘备打败了，我立即报告曹操大人．徐晃，你速去天荡山，命令夏侯德立即进攻葭萌关，天荡山就转由你来镇守．",
 79,"遵命．我马上去天荡山．");
 SetSceneID(0);
talk(79,"夏侯德将军，曹洪有令，命你立即进攻葭萌关．",
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
talk(369,"刘备大人，刚刚收到葭萌关的报告，说曹军进攻，要求速派援军．",
 54,"说到曹操，曹操就来了．",
 3,"又来了，败仗还没吃够吗？",
 170,"主公，那就作出征准备吧．");
talk(126,"主公，我们有两个对策，一个是派援军；另一个是乾脆进攻定军山．葭萌关的曹军是由夏侯德指挥，定军山是由夏侯渊镇守．");
 --显示任务目标:<请选择是向葭萌关派援军，还是进攻定军山．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [527]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，究竟向那里派兵，快决定吧．");
 end
 if JY.Tid==54 then--赵云
talk(54,"定军山，顾名思义，一定山势险要，是兵家必争之地．要攻克定军山，需要选派适合山地战的部队．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"主公，快决定吧．管他是夏侯德还是夏侯渊，我去提来首级献给主公．");
 end
 if JY.Tid==190 then--马超
talk(190,"以前我进攻过葭萌关，我觉得那是个易守难攻的关隘．");
 end
 if JY.Tid==133 then--庞统
talk(133,"葭萌关有夏侯德，定军山有夏侯渊．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"决定了吗？") then
 RemindSave();
 DrawSMap();
 local menu={
 {"增援葭萌关",nil,1},
 {"进攻定军山",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(126,"明白了．那就增援葭萌关．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(); --goto 528
 elseif r==2 then
talk(126,"好．那就攻打定军山．");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
talk(79,"什么，刘备军去攻打定军山了？我立即去援救夏侯渊．");
 SetSceneID(0);
talk(211,"怎么回事？刘备不来救援葭萌关，反而去进攻定军山．如果被他得逞，那汉中就危险了．全军停止进攻，速返回天荡山，加强那里的防守．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(534); --goto 534
 end
 end
 end
 if JY.Tid==369 then--武官
talk(369,"夏侯德在葭萌关前布下了几道复杂的阵势．据侦察其中有许多宝物库．");
 end
 end,
 [528]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(126,"请编排部队．");
 WarIni();
 DefineWarMap(38,"第三章 葭萌关II之战","一、夏侯德的溃灭",35,0,210);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,7,9,4,0,-1,0,
 -1,7,8,4,0,-1,0,
 -1,7,10,4,0,-1,0,
 -1,6,7,4,0,-1,0,
 -1,6,9,4,0,-1,0,
 -1,6,11,4,0,-1,0,
 -1,8,6,4,0,-1,0,
 -1,8,8,4,0,-1,0,
 -1,8,10,4,0,-1,0,
 -1,8,12,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 210,33,13,3,2,48,20,0,0,-1,0,
 256,33,12,3,0,43,3,0,0,-1,0,
 257,28,6,3,4,39,3,26,8,-1,0,
 274,32,13,3,0,39,6,0,0,-1,0,
 275,28,5,3,0,43,6,0,0,-1,0,
 276,30,7,3,0,43,6,0,0,-1,0,
 277,29,7,3,4,39,21,27,8,-1,0,
 278,28,12,3,4,41,21,26,12,-1,0,
 279,18,8,3,0,41,6,0,0,-1,0,
 292,32,12,3,0,45,9,0,0,-1,0,
 293,29,6,3,0,45,9,0,0,-1,0,
 294,25,11,3,0,44,9,0,0,-1,0,
 295,21,13,3,4,44,9,19,10,-1,0,
 
 310,27,13,3,4,43,12,25,13,-1,0,
 311,18,9,3,0,42,12,0,0,-1,0,
 280,28,10,3,4,43,21,24,10,-1,0,
 340,21,1,1,1,45,17,0,0,-1,1,
 341,20,18,2,1,44,17,0,0,-1,1,
 336,21,18,2,1,39,15,0,0,-1,1,
 342,24,1,1,1,45,17,0,0,-1,1,
 343,23,18,2,1,44,17,0,0,-1,1,
 337,24,18,2,1,39,15,0,0,-1,1,
 332,27,1,1,1,45,14,0,0,-1,1,
 333,26,18,2,1,44,14,0,0,-1,1,
 338,27,18,2,1,39,15,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [529]=function()
 PlayBGM(11);
talk(211,"又派了援兵？没什么，我把他们打垮．",
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
talk(1,"果然如孔明所料．大家要镇静，不要惊慌，敌人出现一批就打垮他一批．");
 SetFlag(1056,1);
 end
 if (not GetFlag(1057)) and War.Turn==10 then
 WarShowArmy(342);
 WarShowArmy(343);
 WarShowArmy(337);
 DrawStrBoxCenter("出现敌人伏兵．");
talk(1,"还有埋伏的敌兵．夏侯德真会用兵．");
 SetFlag(1057,1);
 end
 if (not GetFlag(1058)) and War.Turn==15 then
 WarShowArmy(332);
 WarShowArmy(333);
 WarShowArmy(338);
 DrawStrBoxCenter("出现敌人伏兵．");
talk(1,"怎么还有伏兵？究竟埋伏了多少伏兵？");
 SetFlag(1058,1);
 end
 if WarMeet(203,211) then
 WarAction(1,203,211);
talk(203,"来将是夏侯德吗？我严颜要与你单挑．",
 211,"你这个老家伙，胆敢侵略我国，我绝不饶你！");
 WarAction(6,203,211);
 if fight(203,211)==1 then
talk(203,"看招！");
 WarAction(4,203,211);
talk(211,"噢，不好．招架不住了．",
 203,"敌人露出了破绽．");
 WarAction(8,203,211);
talk(211,"啊……");
 WarAction(18,211);
talk(203,"我杀死了敌将夏侯德．");
 WarLvUp(GetWarID(203));
 PlayBGM(7);
 DrawMulitStrBox("　严颜杀死了夏侯德，曹操军败退了．");
 SetFlag(902,0); --夏侯德死亡
 NextEvent();
 else
 WarAction(4,211,203);
talk(203,"噢，不好．招架不住了．");
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
talk(126,"主公，打败了敌军，士气正旺．乘此时机一举攻下汉中．汉中的路上还有定军山、天荡山和汉水，都有敌将把守．",
 126,"那么，我们是进攻定军山还是进攻天荡山，请主公选择．定军山由夏侯渊把守，天荡山由徐晃把守．");
 --显示任务目标:<请选择是进攻定军山还是进攻天荡山．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [533]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，究竟进攻那里，请赶快决定吧．");
 end
 if JY.Tid==54 then--赵云
talk(54,"定军山、天荡山都是险山峻岭，要进攻需要注意选择适合山地作战的部队．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"主公，快下决心吧．管他是徐晃还是夏侯渊，我都能把他们砍落马下．");
 end
 if JY.Tid==190 then--马超
talk(190,"我曾与徐晃交过手，他是个厉害的对手．");
 end
 if JY.Tid==133 then--庞统
talk(133,"天荡山有徐晃，定军山有夏侯渊．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"究竟进攻那一个，决定了吗？") then
 RemindSave();
 DrawSMap();
 local menu={
 {"进攻定军山",nil,1},
 {"进攻天荡山",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(126,"遵命．那就进攻定军山．");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
talk(79,"蜀军进攻定军山了，快去支援夏侯渊．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(); --goto 534
 elseif r==2 then
talk(126,"遵命．那就进攻天荡山．");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
talk(18,"蜀军进攻天荡山了，快去支援徐晃．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(547); --goto 547
 end
 end
 end
 end,
 [534]=function()
 SetSceneID(0);
talk(126,"请编排部队．");
 WarIni();
 DefineWarMap(39,"第三章 定军山之战","一、夏侯渊的溃灭",35,0,17);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,6,16,2,0,-1,0,
 -1,5,15,2,0,-1,0,
 -1,7,15,2,0,-1,0,
 -1,7,17,2,0,-1,0,
 -1,6,17,2,0,-1,0,
 -1,5,17,2,0,-1,0,
 -1,5,16,2,0,-1,0,
 -1,9,15,2,0,-1,0,
 -1,8,16,2,0,-1,0,
 -1,9,17,2,0,-1,0,
 -1,4,14,2,0,-1,0,
 -1,4,15,2,0,-1,0,
 -1,4,17,2,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 17,30,0,1,4,50,22,33,12,-1,0,
 102,34,1,1,4,49,22,27,14,-1,0,
 209,33,3,1,4,48,21,25,12,-1,0,
 36,14,7,3,0,42,12,0,0,-1,0,
 256,15,6,3,0,41,3,0,0,-1,0,
 257,35,4,1,4,41,3,25,14,-1,0,
 292,16,7,3,0,45,9,0,0,-1,0,
 293,33,1,1,4,45,9,30,8,-1,0,
 294,37,0,1,4,44,9,29,7,-1,0,
 295,32,0,1,4,44,9,31,13,-1,0,
 274,15,8,3,0,39,6,0,0,-1,0,
 340,35,2,1,4,40,17,28,8,-1,0,
 341,34,2,1,4,40,17,29,9,-1,0,
 342,36,1,1,4,40,17,26,13,-1,0,
 
 336,36,3,1,4,43,15,30,15,-1,0,
 299,34,0,1,4,44,9,32,9,-1,0,
 300,31,1,1,4,44,9,29,14,-1,0,
 301,32,3,1,4,45,9,24,14,-1,0,
 78,1,6,4,3,49,9,0,0,-1,1,
 251,4,7,4,1,42,3,0,0,-1,1,
 296,4,5,4,1,45,9,0,0,-1,1,
 297,2,7,4,1,44,9,0,0,-1,1,
 298,0,7,4,1,44,9,0,0,-1,1,
 258,2,5,4,1,39,3,0,0,-1,1,
 275,3,6,4,1,39,6,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [535]=function()
 PlayBGM(11);
talk(18,"不能让刘备夺取汉中．竭尽全力制止刘备的进攻．");
 WarShowTarget(true);
 SetFlag(901,1); --夏侯渊存活，默认
 PlayBGM(9);
 NextEvent();
 end,
 [536]=function()
 if WarMeet(170,18) then
 WarAction(1,170,18);
talk(170,"来将像是夏侯渊．我黄忠来单挑结果你！",
 18,"你这帮蜀国乡巴佬，胆敢犯我疆土，看我大刀！",
 170,"我黄忠宝刀未老，你就做我的刀下鬼吧．");
 WarAction(6,170,18);
 if fight(170,18)==1 then
talk(170,"吃这一刀！");
 WarAction(8,170,18);
talk(18,"不好！哎哟……");
 WarAction(18,18);
talk(170,"我杀死了敌将夏侯渊．");
 WarLvUp(GetWarID(170));
 PlayBGM(7);
 DrawMulitStrBox("　黄忠杀死了夏侯渊，*　刘备军占领了定军山．");
 SetFlag(901,0); --夏侯渊死亡
 NextEvent();
 else
 WarAction(4,18,170);
talk(170,"不好！哎哟……");
 WarAction(17,170);
 WarLvUp(GetWarID(18));
 end
 end
 if (not GetFlag(1059)) and War.Turn==8 then
talk(1,"嗯，这些兵是……？");
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
talk(79,"夏侯渊将军，我来帮你把刘备赶出定军山．",
 252,"……",
 18,"噢，徐晃你来了．好，全军向刘备军冲锋！我军要夹击刘备军．");
 PlayBGM(9);
 SetFlag(1059,1);
 end
 if (not GetFlag(134)) and WarMeet(1,252) then
 WarAction(1,1,252);
 PlayBGM(11);
talk(252,"刘备大人，我想向刘备军投降，请收容我．");
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
talk(126,"这样，只要渡过汉水就可以占领汉中了，可是……");
 SetSceneID(0,11);
talk(9,"刘备小儿，趁我不在偷袭汉中，我绝不饶你！",
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
talk(126,"那就进攻汉水吧．请做好进攻汉水的准备．");
 --显示任务目标:<做进攻汉水的准备．>
 else
talk(126,"那么，是进攻天荡山还是进攻汉水，请主公定夺．汉水是由曹洪把守，天荡山是由夏侯德把守．");
 --显示任务目标:<请决定是进攻天荡山，还是进攻汉水．>
 end
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [540]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，快出征吧．");
 end
 if JY.Tid==54 then--赵云
talk(54,"听说汉水是有条大河的平原，可以集结快速部队．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"主公，快出发吧．");
 end
 if JY.Tid==190 then--马超
talk(190,"我与曹洪交过几次手，这个家伙脾气暴躁．");
 end
 if JY.Tid==133 then--庞统
 if GetFlag(57) then
talk(133,"汉水是由曹洪把守．");
 else
talk(133,"汉水有曹洪，天荡山有夏侯德把守．");
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
talk(126,"那就进攻汉水．");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
talk(212,"什么，刘备进攻汉水？我们快去支援那里．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(554); --goto 554
 else
talk(126,"究竟进攻那里，请选择．");
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(126,"明白了．那么向天荡山进发．");
 JY.Smap={};
 SetSceneID(0,3);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(); --goto 541
 elseif r==2 then
talk(126,"是，进攻汉水．");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
talk(212,"什么，刘备进攻汉水？我们快去支援那里．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(554); --goto 554
 end
 end
 end
 end
 end,
 [541]=function()
 SetSceneID(0);
talk(126,"请列队．");
 WarIni();
 DefineWarMap(40,"第三章 天荡山I之战","一、歼灭夏侯德",40,0,210);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,4,5,4,0,-1,0,
 -1,5,4,4,0,-1,0,
 -1,5,6,4,0,-1,0,
 -1,5,8,4,0,-1,0,
 -1,3,4,4,0,-1,0,
 -1,3,5,4,0,-1,0,
 -1,3,6,4,0,-1,0,
 -1,3,8,4,0,-1,0,
 -1,6,5,4,0,-1,0,
 -1,6,7,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 210,33,7,3,1,52,20,0,0,-1,0,
 256,33,6,3,1,48,3,0,0,-1,0,
 257,20,13,3,1,44,3,0,0,-1,0,
 274,31,5,3,1,48,6,0,0,-1,0,
 275,23,7,3,1,45,6,0,0,-1,0,
 296,21,5,3,1,48,9,0,0,-1,0,
 297,19,12,3,1,46,9,0,0,-1,0,
 298,20,11,3,1,46,9,0,0,-1,0,
 299,21,14,3,1,45,9,0,0,-1,0,
 292,21,12,3,1,45,9,0,0,-1,0,
 293,22,6,3,1,45,6,0,0,-1,0,
 294,30,6,3,1,48,9,0,0,-1,0,
 295,32,7,3,1,45,9,0,0,-1,0,
 310,31,7,3,1,40,12,0,0,-1,0,
 311,23,5,3,1,43,12,0,0,-1,0,
 300,22,13,3,1,45,9,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [542]=function()
 PlayBGM(11);
talk(211,"让敌人占领天荡山，我军的粮草就没了！无论如何我们也要守住天荡山！",
 1,"敌人的兵力不多！一鼓作气攻下它！");
 WarShowTarget(true);
 SetFlag(902,1); --夏侯德存活，默认
 PlayBGM(9);
 NextEvent();
 end,
 [543]=function()
 if WarMeet(203,211) then
 WarAction(1,203,211);
talk(203,"夏侯德，我严颜要和你单挑！",
 211,"你这个老朽，胆敢侵占我们领土！杀呀！！");
 WarAction(6,203,211);
 if fight(203,211)==1 then
talk(203,"杀！");
 WarAction(4,203,211);
talk(211,"嗯、嗯……！不……好了！",
 203,"纳命来！");
 WarAction(8,203,211);
talk(211,"啊……！");
 WarAction(18,211);
talk(203,"敌将夏侯德，被我严颜杀了！！");
 WarLvUp(GetWarID(203));
 PlayBGM(7);
 DrawMulitStrBox("　严颜杀了夏侯德，曹操军败退了．");
 SetFlag(902,0); --夏侯德死亡
 NextEvent();
 else
 WarAction(4,211,203);
talk(203,"嗯、嗯……！不……好了！");
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
talk(126,"再过了汉水就是汉中了．进军汉水．");
 --显示任务目标:<准备进军汉水．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [546]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，快出兵吧．");
 end
 if JY.Tid==54 then--赵云
talk(54,"听说汉水是个有一条大河的平原，可以集结快速部队．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"主公，快些出兵吧．");
 end
 if JY.Tid==190 then--马超
talk(190,"我和曹洪交过几次手，这个家伙脾气暴躁．");
 end
 if JY.Tid==133 then--庞统
talk(133,"汉水是曹洪把守．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 DrawSMap();
talk(126,"出发吧．");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
talk(212,"什么，刘备军到了汉水？我们马上去汉水．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(554); --goto 554
 end
 end
 end,
 [547]=function()
 SetSceneID(0);
talk(126,"请列好队．");
 WarIni();
 DefineWarMap(40,"第三章 天荡山II之战","一、徐晃败退",40,0,78);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,4,5,4,0,-1,0,
 -1,5,4,4,0,-1,0,
 -1,5,6,4,0,-1,0,
 -1,5,8,4,0,-1,0,
 -1,3,4,4,0,-1,0,
 -1,3,5,4,0,-1,0,
 -1,3,6,4,0,-1,0,
 -1,3,8,4,0,-1,0,
 -1,6,5,4,0,-1,0,
 -1,6,7,4,0,-1,0,
 -1,2,5,4,0,-1,0,
 -1,4,3,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 78,33,7,3,2,52,9,0,0,-1,0,
 251,21,12,3,4,45,3,19,12,-1,0,
 295,19,12,3,1,46,9,0,0,-1,0,
 296,20,11,3,1,46,9,0,0,-1,0,
 297,29,5,3,4,45,9,23,6,-1,0,
 298,30,6,3,0,45,9,0,0,-1,0,
 292,23,7,3,4,46,9,20,11,-1,0,
 293,22,13,3,4,46,9,20,14,-1,0,
 294,20,13,3,1,46,9,0,0,-1,0,
 256,21,14,3,1,43,3,0,0,-1,0,
 257,32,7,3,0,42,3,0,0,-1,0,
 310,21,5,3,4,41,12,19,11,-1,0,
 311,22,6,3,4,40,12,19,13,-1,0,
 336,31,7,3,0,41,15,0,0,-1,0,
 337,29,7,3,4,40,15,23,7,-1,0,
 
 332,23,5,3,0,46,14,0,0,-1,0,
 274,31,5,3,0,45,6,0,0,-1,0,
 275,33,6,3,0,44,6,0,0,-1,0,
 17,29,18,3,1,50,22,0,0,-1,1,
 102,28,19,3,1,48,22,0,0,-1,1,
 209,27,17,3,1,48,21,0,0,-1,1,
 36,16,1,1,1,42,12,0,0,-1,1,
 258,17,0,1,1,43,3,0,0,-1,1,
 259,28,17,3,1,42,3,0,0,-1,1,
 299,30,19,3,1,46,9,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [548]=function()
 PlayBGM(11);
talk(79,"守不住这里，汉中也就丢了！将士们，无论如何得守住这个天荡山！");
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
talk(252,"刘皇叔，我遭徐晃忌恨，所以我想投降刘皇叔．今后请您多关照．");
 ModifyForce(252,1);
 PlayWavE(11);
 DrawStrBoxCenter("王平倒戈到这里！");
 SetFlag(134,1);
 WarLvUp(GetWarID(1));
 PlayBGM(9);
 end
 if (not GetFlag(1060)) and War.Turn==8 then
talk(1,"嗯！那莫非是？");
 PlayBGM(11);
 WarShowArmy(17);
 WarShowArmy(102);
 WarShowArmy(209);
 WarShowArmy(36);
 WarShowArmy(258);
 WarShowArmy(259);
 WarShowArmy(299);
 DrawStrBoxCenter("敌人援军出现了！");
talk(18,"救出徐晃！把刘备军赶出天荡山！",
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
talk(170,"喂，夏侯渊！我黄忠与你单挑！！",
 18,"你们这些乡巴佬，竟敢来抢占我们领土！我岂能饶你！",
 170,"哈哈，我黄忠虽已年迈，但还不至于败给你这鼠辈．");
 WarAction(6,170,18);
 if fight(170,18)==1 then
talk(170,"看刀！");
 WarAction(8,170,18);
talk(18,"啊……！！");
 WarAction(18,18);
talk(170,"我杀死了敌将夏侯渊！");
 WarLvUp(GetWarID(170));
 SetFlag(901,0); --夏侯渊死亡
 else
 WarAction(4,18,170);
talk(170,"不好！哎哟……");
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
talk(126,"这样，只要渡过汉水就可以占领汉中了，可是……");
 SetSceneID(0,11);
talk(9,"刘备小儿，趁我不在偷袭汉中，我绝不饶你！",
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
talk(126,"曹操终于出来了．那么主公，我军进攻汉水吧．汉水是由曹洪把守．");
 --显示任务目标:<准备进军汉水．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [553]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，快出征吧．");
 end
 if JY.Tid==54 then--赵云
talk(54,"听说汉水是有条大河的平原，可以集结快速部队．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"主公，快出发吧．");
 end
 if JY.Tid==190 then--马超
talk(190,"我与曹洪交过几次手，这个家伙脾气暴躁．");
 end
 if JY.Tid==133 then--庞统
talk(133,"汉水是由曹洪把守．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 DrawSMap();
talk(126,"出发吧．");
 JY.Smap={};
 SetSceneID(0,3);
 SetSceneID(0,11);
talk(212,"什么，刘备进攻汉水？我们快去支援那里．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end
 end,
 [554]=function()
 SetSceneID(0);
talk(126,"请列好队．");
 WarIni();
 DefineWarMap(41,"第三章 汉水之战","一、曹洪的败退．",40,0,19);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,14,22,4,0,-1,0,
 -1,2,16,4,0,-1,0,
 -1,16,19,4,0,-1,0,
 -1,2,13,4,0,-1,0,
 -1,14,20,4,0,-1,0,
 -1,3,14,4,0,-1,0,
 -1,13,21,4,0,-1,0,
 -1,2,15,4,0,-1,0,
 -1,15,21,4,0,-1,0,
 -1,1,16,4,0,-1,0,
 -1,16,21,4,0,-1,0,
 -1,3,17,4,0,-1,0,
 -1,13,23,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 19,28,1,3,0,54,25,0,0,-1,0,
 17,27,3,3,0,52,22,0,0,901,0,--夏侯渊
 210,30,3,3,0,52,20,0,0,902,0,--夏侯德
 256,10,9,3,4,47,3,8,8,-1,0,
 257,23,13,3,4,43,3,21,15,-1,0,
 258,21,11,3,4,43,3,21,14,-1,0,
 259,26,10,3,0,46,3,0,0,-1,0,
 260,28,4,3,0,42,3,0,0,-1,0,
 292,11,9,3,4,50,9,9,9,-1,0,
 293,23,12,3,4,47,9,22,14,-1,0,
 294,25,9,3,0,47,9,0,0,-1,0,
 295,16,1,3,0,50,9,0,0,-1,0,
 274,9,8,3,4,47,6,8,9,-1,0,
 275,24,14,3,4,43,6,20,15,-1,0,
 276,21,12,3,4,43,6,20,14,-1,0,
 277,24,9,3,0,46,6,0,0,-1,0,
 
 301,15,0,3,0,46,9,0,0,-1,0,
 302,23,1,3,0,46,9,0,0,-1,0,
 278,12,11,3,4,50,6,9,10,-1,0,
 279,17,13,4,4,50,6,19,13,-1,0,
 348,13,10,3,4,43,19,10,9,-1,0,
 349,16,14,4,4,42,19,19,14,-1,0,
 211,29,1,3,0,53,22,0,0,-1,1,
 261,26,2,3,0,46,3,0,0,-1,1,
 280,27,4,3,0,45,6,0,0,-1,1,
 296,29,4,3,0,50,9,0,0,-1,1,
 297,29,3,3,0,47,9,0,0,-1,1,
 298,28,2,3,0,50,9,0,0,-1,1,
 299,27,1,3,0,47,9,0,0,-1,1,
 300,24,2,3,0,47,9,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [555]=function()
 PlayBGM(11);
talk(20,"在这里阻住刘备军．万一这里失守，则汉中危矣！各位将军，一定要死守这里！");
 WarShowTarget(true);
 PlayBGM(16);
 NextEvent();
 end,
 [556]=function()
 if WarMeet(201,212) then
 WarAction(1,201,212);
talk(201,"我是蜀将吴兰！谁敢与我单挑？",
 201,"你能赢我吗？我来了．");
 WarAction(6,201,212);
 if fight(201,212)==1 then
talk(201,"这是……",
 212,"怎么了，不想打了？如果这样我曹彰就不杀你了．",
 201,"你是曹彰？那么你是曹操的儿子？",
 212,"正是．",
 201,"……好，我要取你首级立功！曹彰，接招！");
 WarAction(8,201,212);
talk(212,"噢……");
 WarAction(17,212);
talk(201,"哼，胜得太容易了．还有没有人敢与我交手？");
 WarLvUp(GetWarID(201));
 else
talk(201,"这是……",
 212,"怎么了，不想打了？如果这样我曹彰就不杀你了．",
 201,"你是曹彰？那么你是曹操的儿子？",
 212,"正是．",
 201,"……好，我要取你首级立功！曹彰，接招！");
 WarAction(5,201,212);
 WarAction(5,201,212);
talk(212,"哈哈哈．你这点本事还能赢我？该我了，接招！");
 WarAction(8,212,201);
talk(201,"噢……",
 212,"吓傻了吧．我的本事还没完全使出来呢．",
 201,"……看来是胜不了他了……真不该轻敌．没办法，撤吧．");
 WarAction(17,201);
talk(212,"哼，胜得太容易了．还有没有人敢与我交手？");
 WarLvUp(GetWarID(212));
 end
 end
 if (not GetFlag(1061)) and War.Turn==10 then
talk(20,"刘备小儿，的确厉害……嗯？！");
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
talk(212,"不能让蜀军再猖狂了．我来让你们知道我的厉害！",
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
talk(9,"唉……既然如此，在阳平关迎击敌人！");
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
talk(126,"主公，曹操到阳平关以后好像就不前进了．咱们进军阳平关吧．");
 --显示任务目标:<准备进军阳平关．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [560]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，只要拿下阳平关，汉中就是我们的了．");
 end
 if JY.Tid==54 then--赵云
talk(54,"曹操军此次前来，其阵容之强大前所未见，咱们要当心．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"主公，我还是很有用的，到时候看我的吧．");
 end
 if JY.Tid==190 then--马超
talk(190,"我要亲手取曹操的首级，主公，请派我出征吧．");
 end
 if JY.Tid==133 then--庞统
talk(133,"阳平关是天险，易守难攻，我们派精锐去那里吧．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 DrawSMap();
talk(126,"请编队．");
 WarIni();
 DefineWarMap(42,"第三章 阳平关之战","一、曹操的败退",45,0,8);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,33,8,3,0,-1,0,
 -1,32,7,3,0,-1,0,
 -1,33,7,3,0,-1,0,
 -1,34,10,3,0,-1,0,
 -1,34,8,3,0,-1,0,
 -1,33,9,3,0,-1,0,
 -1,32,6,3,0,-1,0,
 -1,33,5,3,0,-1,0,
 -1,35,7,3,0,-1,0,
 -1,34,13,3,0,-1,0,
 -1,35,12,3,0,-1,0,
 -1,33,11,3,0,-1,0,
 -1,34,11,3,0,-1,0,
 -1,35,9,3,0,-1,0,
 });
 DrawSMap();
talk(126,"在阳平关击溃曹操！");
 JY.Smap={};
 SetSceneID(0,3);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 8,2,3,1,2,58,9,0,0,-1,0,
 386,1,3,1,3,57,15,8,0,-1,0,--典韦S
 17,6,8,4,0,55,22,0,0,901,0,--夏侯渊
 210,2,4,1,0,55,20,0,0,902,0,--夏侯德
 209,1,4,1,0,54,21,0,0,-1,0,--夏侯尚
 78,5,4,1,0,55,9,0,0,-1,0,
 67,3,4,1,0,54,9,0,0,-1,0,
 102,17,13,4,0,55,22,0,0,-1,0,
 16,7,9,4,0,55,9,0,0,-1,0,
 19,4,6,1,0,54,25,0,0,-1,0,
 211,13,13,4,0,54,22,0,0,-1,0,
 250,8,12,4,0,53,19,0,0,-1,0,
 215,18,14,4,0,53,9,0,0,-1,0,
 213,1,5,1,0,53,16,0,0,-1,0,
 274,5,5,1,0,45,6,0,0,-1,0,
 275,2,6,1,0,45,6,0,0,-1,0,
 276,4,4,1,0,48,6,0,0,-1,0,
 277,6,9,4,0,48,6,0,0,-1,0,
 
 278,9,13,4,0,47,6,0,0,-1,0,
 279,18,12,4,0,47,6,0,0,-1,0,
 280,19,13,4,0,47,6,0,0,-1,0,
 293,12,12,4,0,49,9,0,0,-1,0,
 256,3,7,1,0,45,3,0,0,-1,0,
 257,5,3,1,0,45,3,0,0,-1,0,
 258,7,8,4,0,47,3,0,0,-1,0,
 259,20,12,4,0,47,3,0,0,-1,0,
 260,12,14,4,0,47,3,0,0,-1,0,
 292,9,11,4,0,49,9,0,0,-1,0,
 336,3,6,1,0,45,15,0,0,-1,0,
 294,3,3,1,0,48,9,0,0,-1,0,
 281,11,13,4,0,45,6,0,0,-1,0,
 348,2,5,1,0,44,19,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [561]=function()
 PlayBGM(11);
talk(9,"大胆的刘备！你竟敢背叛汉朝！我曹操要把你千刀万剐！",
 1,"住口！你欺辱皇帝，侮辱汉朝，是想取而代之吧．你才是叛逆，你才该千刀万剐．");
 WarShowTarget(true);
 PlayBGM(10);
 NextEvent();
 end,
 [562]=function()
 if WarMeet(190,216) then
 if GetFlag(176) then
talk(190,"庞德！再好好想一下．",
 216,"……不要再说了．战斗吧．");
 else
 WarAction(1,190,216);
talk(190,"庞德，你不是庞德吗？你还活着．",
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
talk(190,"庞德，你再想一下．",
 216,"不要再说了．……马超将军，再见．",
 190,"庞德，等一下！");
 --WarAction(16,216);
talk(190,"庞德……");
 WarLvUp(GetWarID(190));
 SetFlag(176,1);
 else
 WarAction(4,216,190);
talk(190,"庞德……");
 WarAction(17,190);
 WarLvUp(GetWarID(216));
 end
 end
 end
 if (not GetFlag(145)) and WarCheckArea(-1,6,20,15,25) then
talk(103,"好，让我当先锋，我一定不辜负曹丞相的厚望，冲啊！",
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
talk(214,"妈的，刘备．不能让他们再靠近阳平关．大家跟我来！",
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
talk(9,"唉……没办法，撤回长安．");
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
talk(9,"撤回长安．刘备，我会再找你算这次和赤壁那笔帐的！");
 SetSceneID(0,3);
talk(126,"主公，终于占领了汉中，恭喜．那么，进汉中城吧．");
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
talk(126,"主公，您终于得到了汉中，这样我三分天下的战略就实现了．这也是您实力的表现．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [566]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，恭喜你．我高兴得……");
 end
 if JY.Tid==54 then--赵云
talk(54,"我从很久以前就跟随主公，可是这么高兴还是第一次．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"主公，您给我这个老朽留下了如此辉煌的回忆，太谢谢了．");
 end
 if JY.Tid==190 then--马超
talk(190,"主公，恭喜您把曹操赶出了汉中，也雪了家父之恨．");
 end
 if JY.Tid==133 then--庞统
talk(133,"这样，魏、蜀、吴三足鼎立之势就形成了．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公，请进位汉中王．",
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
talk(3,"大哥在汉中称王，二哥在荆州也会高兴了．大哥你就同意称汉中王吧．");
 end
 if JY.Tid==54 then--赵云
talk(54,"大家都同意您称王，我更是不例外．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"主公，您就同意称汉中王吧，就别让老臣空等了．");
 end
 if JY.Tid==190 then--马超
talk(190,"不能默认曹操称魏王，主公称汉中王也是为了对抗曹操．");
 end
 if JY.Tid==133 then--庞统
talk(133,"主公，即使您称了汉中王，也不是什么大不了的事．您就不要推辞了．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"您决定称汉中王了吗？") then
talk(126,"噢，您同意了！",
 1,"唉……我当汉中王．诸位，这样行吗？",
 3,"谁会反对呢？啊，大家都赞成．",
 54,"大家当然都赞成．请汉中王今后多关照我们．",
 170,"汉中王万岁！",
 190,"恭喜您．家父在九泉之下，也会高兴的．");
 if not GetFlag(38) then
talk(133,"我们会更忠心地跟随您．");
 end
 PlayBGM(8);
 DrawMulitStrBox("　刘备从曹操手里夺取了汉中．这样，刘备据有了荆州、益州和汉中，成为强大的蜀之主．孔明在隆中为刘备设计的魏、蜀、吴三分天下之计成功了．从此，刘备做了汉中王．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 else
talk(126,"主公，请下决心吧．这不光为您自己，也是为大家．");
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
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 1,20,8,3,0,-1,0,
 127,19,8,3,0,-1,0,
 154,20,9,3,0,-1,0,
 33,21,7,3,0,-1,0,
 37,20,7,3,0,-1,0,
 38,22,8,3,0,-1,0,
 });
 ModifyForce(256+1,9);
 ModifyForce(274+1,9);
 ModifyForce(292+1,9);
 ModifyForce(293+1,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 148,3,3,4,0,52,20,0,0,-1,0,
 161,16,13,4,0,48,3,0,0,-1,0,
 162,7,16,4,0,48,9,0,0,-1,0,
 44,7,4,4,0,47,3,0,0,-1,0,
 173,15,12,4,0,47,25,0,0,-1,0,
 150,8,5,4,0,47,16,0,0,-1,0,
 45,6,15,4,0,47,3,0,0,-1,0,
 18,30,7,3,1,52,3,0,0,-1,1,
 83,31,7,3,1,48,21,0,0,-1,1,
 28,27,6,3,1,47,6,0,0,-1,1,
 32,26,7,3,1,47,6,0,0,-1,1,
 78,29,6,3,1,48,9,0,0,-1,1,
 256,30,8,3,1,44,3,0,0,-1,1,
 274,25,5,3,1,45,6,0,0,-1,1,
 292,24,6,3,1,45,9,0,0,-1,1,
 293,28,7,3,1,44,9,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [569]=function()
 PlayBGM(11);
talk(39,"关羽将军，现在没别的办法，只有退回成都以求东山再起．到那时再让他们交还荆州．",
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
talk(2,"嗯！追兵来了！");
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
talk(19,"不能让吴把功劳抢走了，关羽的首级就由我们来取吧！",
 149,"那可不行．关羽的首级要由吴来取！");
 SetFlag(1062,1);
 end
 WarLocationItem(14,16,49,209); --获得道具:获得道具：援军书
 WarLocationItem(17,9,55,210); --获得道具:获得道具：茶
 WarLocationItem(8,7,49,211); --获得道具:获得道具：援军书
 if JY.Status==GAME_WARLOSE then
 PlayBGM(4);
talk(2,"兄长，自从桃园结义以来，我一直跟随着你．可是今天我命将休矣．请你替我实现没能完成的梦想．……兄长，三弟，永别了！");
 DrawMulitStrBox("　关羽被活捉后斩首．");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if WarCheckLocation(1,3,0) then
talk(149,"完了！被关羽逃走了，这样将后患无穷．决不能让关羽跑掉！");
 PlayBGM(2);
 DrawMulitStrBox("　关羽逃离了战场．");
 SetFlag(58,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
talk(2,"趁敌人援军还没赶到之前，快走．");
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
talk(9,"……要统一天下谈何容易啊．我拥有如此强大的实力……也没有做到．",
 20,"您说什么，不要气馁啊．",
 9,"我快不行了．我死以后，……曹丕继承我的位子．曹丕，到这里来．",
 213,"是．");
 MovePerson(213,2,2);
talk(9,"你来继承我的位子．我死以后，吴蜀必然要发生冲突，这时你千万不要轻举妄动．等他们分出胜负后，再慢慢收拾那个胜利的国家．你一定要记住，千万不要做错！否则灭亡的是我们．",
 213,"我记住了．我一定不辜负父亲厚望．",
 9,"……如果你做错了，我不会放过你．我会从阴曹地府中回来找你的．",
 213,"是！是！",
 9,"唉，……那我就放心地去了．各位，多保重……");
talk(94,"主公！呜呜……",
 214,"……");
 MovePerson(213,1,3);
talk(213,"那么从今天起，国家就由我来执掌．你们要像对我父亲那样向我尽忠．",
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
talk(365,"禀报主公，大势不好！关羽被吕蒙打败，关将军据说已被害．",
 1,"什么！……",
 3,"你这个混蛋，不许胡说，二哥不会死．",
 365,"可，可是这是千真万确的事实……");
 MovePerson(3,2,1);
talk(3,"关羽绝不会死！那不可能，那不可能……");
 MovePerson(3,2,2);
talk(3,"大哥，你也这么认为吧．",
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
talk(1,"关羽……你怎么能这样就……我们不是对天起过誓吗？你怎么这么快就去了？……");
 AddPerson(369,37,23,2);
 MovePerson(369,11,2);
 PlayBGM(11);
talk(369,"主公，我刚从许昌回来，有大事禀报．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [574]=function()
 if JY.Tid==3 then--张飞
talk(3,"畜生！东吴狗贼！孙权混蛋！大哥，什么时候出师伐吴？我一定要去！");
 end
 if JY.Tid==54 then--赵云
talk(54,"虽然我们丢失了荆州，但现在需要冷静，不要太激动了．");
 end
 if JY.Tid==369 then--武官
talk(1,"不要着急．发生了什么事？",
 369,"首先是曹操死了，他的长子曹丕继位．",
 1,"什么？曹操死了？！……还有什么事？",
 369,"曹丕继位后，废掉了献帝，自己当上皇帝，改国号为“魏”．",
 1,"什么！那献帝怎么样了？",
 369,"……据说被赶出了许昌，放逐到荒郊，寂寞度日．",
 1,"岂有此理……难道我毕生的奋斗目标重振汉室就这样毁于曹丕之手吗？只因我力量不够啊……",
 369,"那我先退了．");
 MovePerson(369,12,3);
 DecPerson(369);
talk(1,"我，还有关羽终生追求的重振汉室的理想难道实现不了了吗？怎么会这样？");
 AddPerson(367,37,23,2);
 MovePerson(367,11,2);
talk(367,"主公，诸葛瑾来了．",
 1,"谁？好吧，叫他进来．",
 367,"是．");
 MovePerson(367,12,3);
 DecPerson(367);
talk(3,"是东吴的使者？偷袭了关羽，现在还到这里来干什么？大哥，杀了他吧．",
 1,"……不能这样．先问问他想说什么，再杀他也不迟．",
 3,"妈的！还敢厚着脸皮来啊！");
 AddPerson(146,37,23,2);
 MovePerson(146,11,2);
talk(146,"诸葛瑾作为吴国特使前来求见．");
 DrawMulitStrBox("　现在出现的诸葛瑾，是诸葛亮的哥哥．年龄比诸葛亮大很多．在孔明很小的时候就开始为吴国效力．*　孙权非常信任他．这次派他来蜀国，就证明了这点．");
talk(3,"嗤！吴国狗贼，派我们军师的哥哥来当使者，太卑鄙了．这样我可不好下手了．",
 126,"……先听听我哥哥说什么吧．");
 NextEvent();
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"许昌发生了什么事，听听使者报告吧．");
 end
 end,
 [575]=function()
 if JY.Tid==3 then--张飞
talk(3,"畜生，孙权狗贼！派使者来干什么？*如果不是军师的哥哥，我早就把他杀了．");
 end
 if JY.Tid==54 then--赵云
talk(54,"主公，现在请控制情绪，不要感情用事．");
 end
 if JY.Tid==146 then--诸葛瑾
talk(1,"诸葛瑾，你来有何贵干？",
 146,"曹丕称帝的消息想必皇叔已经知道了．这种事我们也难以容忍．我此次来，就是想与魏废除盟约，而与蜀国结盟．如果缔结了盟约，我们打算奉还荆州．请您能给我一个满意的答覆．");
 --显示任务目标:<回答诸葛瑾的结盟提案>
 NextEvent();
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"主公，我很了解你的心情，可是请看在我的面子上不要杀了我哥哥．");
 end
 end,
 [576]=function()
 if JY.Tid==3 then--张飞
talk(3,"不要听他胡说．二哥如此惨遭杀害，这岂能忘掉．大哥，决不能结盟．");
 end
 if JY.Tid==54 then--赵云
talk(54,"我觉得应该与吴结盟．伐吴是主公的私事，不会得到天下人的响应．");
 end
 if JY.Tid==146 then--诸葛瑾
 if talkYesNo( 146,"您作出决定了吗？") then
 RemindSave();
talk(146,"那就请您答覆．");
 local menu={
 {"　 结盟",nil,1},
 {"　不结盟",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(146,"噢，谢谢．我马上去向吴侯报喜讯．这是吴国的一点心意，请您笑纳．");
 GetItem(1,4);
talk(146,"那我马上回去报告我家主公．");
 MovePerson(146,12,3);
 DecPerson(146);
talk(126,"主公，您作出了正确的决断．但您内心一定很痛苦吧．",
 1,"……吴国确实可恨，但现在不能与吴争斗．应先讨伐曹丕，重兴汉室．张飞，请你谅解我．",
 3,"……以前我信任大哥，……今后也会．",
 1,"张飞，谢谢．");
 SetFlag(132,1);
 SetFlag(135,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(592); --goto 592
 elseif r==2 then
 PlayBGM(12);
talk(1,"你回去对孙权说，我忘不了夺去荆州和杀害关羽的仇恨．想结盟，做梦！",
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
talk(126,"我认为不应与吴作战．如果我们与吴国交战，得利的是魏国．现在应忘记荆州和关羽，与吴结盟．");
 end
 end,
 [577]=function()
 if GetFlag(58) then
talk(3,"大哥，下令出征吧．");
 SetFlag(135,1);
 else
talk(3,"到底是我的大哥！我马上就去准备．",
 1,"张飞，不要太着急．",
 3,"已经等了这么长时间，不能再慢吞吞了．大哥也快点准备吧．");
 MovePerson(3,2,1);
 MovePerson(3,12,3);
 DecPerson(3);
 end
talk(126,"……",
 1,"孔明，对不起．刚才我过分了．",
 126,"没有关系．我也有错．",
 1,"孔明，应该怎样伐吴？",
 126,"先攻下西陵城，再以那里为据点，然后再进军．",
 1,"嗯，孔明，你留下抵御曹丕，赵云、马超辅佐你．");
 ModifyForce(54,0);
 ModifyForce(126,0);
 ModifyForce(190,0);
 ModifyForce(204,0);
talk(1,"出征．");
 NextEvent();
 end,
 [578]=function()
 JY.Smap={};
 SetSceneID(0,3);
talk(175,"西陵在去江陵的路上，快出发吧．");
 SetSceneID(0);
 if GetFlag(58) then
talk(1,"要为关羽报仇．噢，张飞来了啊．",
 3,"大哥，对不起，我来晚了．我回去做了些准备，时间就过了．",
 1,"好，现在人到齐了．进军西陵！");
 else
talk(1,"要为关羽报仇……嗯，那不是吴班吗？",
 91,"主公……",
 1,"怎么啦？神色慌张，出什么事了？");
 PlayBGM(4);
talk(91,"禀报主公，……张飞被部下范疆、张达杀害了．",
 1,"什么！这次出师，最高兴的就是张飞．那抓到范疆、张达了吗？",
 91,"他们都逃到东吴去了．",
 1,"关羽、张飞，你们都离我而去了．可是……，关羽、张飞，我不会失败，一定会为你们报仇．");
 ModifyForce(3,0);
 end
 RemindSave();
talk(175,"主公，请编队．");
 WarIni();
 DefineWarMap(43,"第三章 西陵之战","一、孙桓败退．",40,0,41);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,11,4,4,0,-1,0,
 -1,12,3,4,0,-1,0,
 -1,10,5,4,0,-1,0,
 -1,11,5,4,0,-1,0,
 -1,12,5,4,0,-1,0,
 -1,9,4,4,0,-1,0,
 -1,13,4,4,0,-1,0,
 -1,14,4,4,0,-1,0,
 -1,9,6,4,0,-1,0,
 252,5,4,4,0,-1,1,
 29,6,3,4,0,-1,1,
 43,7,2,4,0,-1,1,
 });
 ModifyForce(252+1,1);
 ModifyForce(29+1,1);
 ModifyForce(43+1,1);
 SetSceneID(0,3);
talk(1,"向西陵进军．");
 
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
talk(45,"嗯，都督，您不打算增援西陵了？",
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
 41,18,19,3,0,54,20,0,0,-1,0,
 45,14,11,4,4,50,3,21,9,-1,0,
 108,22,7,2,4,49,6,22,4,-1,0,
 109,18,17,3,0,49,6,0,0,-1,0,
 159,17,19,3,0,49,6,0,0,-1,0,
 160,14,17,3,0,50,3,0,0,-1,0,
 173,12,16,3,4,49,25,14,11,-1,0,
 256,18,10,4,4,45,3,22,9,-1,0,
 274,21,9,4,4,45,6,23,2,-1,0,
 292,20,10,4,4,48,9,24,4,-1,0,
 293,19,9,4,4,48,9,24,3,-1,0,
 294,15,12,4,4,48,9,21,10,-1,0,
 295,13,17,3,0,47,9,0,0,-1,0,
 296,16,18,3,0,47,9,0,0,-1,0,
 
 310,13,10,4,0,45,12,0,0,-1,0,
 311,12,11,4,0,44,12,0,0,-1,0,
 336,22,10,4,4,45,15,23,4,-1,0,
 332,19,18,3,0,46,14,0,0,-1,0,
 297,14,12,4,0,47,9,0,0,-1,0,
 348,14,18,3,0,43,19,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [579]=function()
 PlayBGM(11);
talk(1,"众将官，要为关羽报仇，向孙权军雪恨！",
 42,"哎呀呀……大家一定要守住，等待援军的到来．");
 WarShowTarget(true);
 PlayBGM(12);
 WarShowArmy(29);
 --talk( 30,"主公，我来迟了，对不起．我是关羽的儿子关兴．*我此次来是为了报父仇，请让我加入战斗．");
talk(30,"主公，我来迟了，对不起．我是关羽的儿子关兴．我此次来是为了报父仇，请让我加入战斗．");
 WarShowArmy(43);
talk(44,"我岂能落在关兴后面？主公，我是张飞之子张苞，此次作战我也要参加．");
 WarShowArmy(252);
talk(253,"父亲，请带我去．不过，刀箭很可怕呀．");
 PlayWavE(11);
 DrawStrBoxCenter("刘禅、张苞、关兴成为部下！");
 PlayBGM(14);
 NextEvent();
 end,
 [580]=function()
 if WarMeet(44,110) then
 WarAction(1,44,110);
talk(44,"敌将何在！我是张飞之子张苞！",
 110,"喔，你就是张飞的儿子．我来教训你！");
 WarAction(6,44,110);
 if fight(44,110)==1 then
talk(44,"杀！");
 WarAction(8,44,110);
talk(110,"哎呀！");
 WarAction(18,110);
talk(44,"杀死了敌将！");
 WarLvUp(GetWarID(44));
 else
 WarAction(4,110,44);
talk(44,"哎呀！");
 WarAction(17,44);
 WarLvUp(GetWarID(110));
 end
 end
 if WarMeet(30,109) then
 WarAction(1,30,109);
talk(30,"我是关羽的儿子关兴，谁敢与我单挑！",
 109,"黄毛小儿，休得猖狂！我来了！");
 WarAction(6,30,109);
 if fight(30,109)==1 then
talk(109,"你就是关兴？还在想爸爸吧．",
 30,"住口！你给我过来！",
 109,"过去又怎样．");
 WarAction(15,30);
talk(109,"一刀结果你……");
 WarAction(5,109,30);
 WarAction(8,30,109);
 WarAction(18,109);
talk(30,"这种对手也敢口出狂言？");
 WarLvUp(GetWarID(30));
 else
talk(109,"你就是关兴？还在想爸爸吧．",
 30,"住口！你给我过来！",
 109,"过去又怎样．");
 WarAction(15,30);
talk(109,"一刀结果你……");
 WarAction(4,109,30);
talk(30,"太厉害了！");
 WarAction(17,30);
 WarLvUp(GetWarID(109));
 end
 end
 if JY.Status==GAME_WARWIN then
talk(42,"混蛋！……撤退！");
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
talk(175,"那么进西陵城吧．");
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
talk(369,"孙桓军被刘备击败，正往这里退却．",
 151,"孙桓怎么样？",
 369,"他没什么事．",
 151,"是吗？那太好了．你辛苦了．",
 369,"我退下去了．");
 MovePerson(369,12,2);
 DecPerson(369);
 MovePerson(45,3,2);
 MovePerson(45,2,1);
 MovePerson(45,3,3);
talk(45,"有什么好的，是我们吃败仗啊！",
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
talk(175,"主公，诸葛瑾来求见．",
 1,"他又来了．让他进来．",
 175,"是．");
 AddPerson(146,41,25,2);
 MovePerson(146,12,2);
talk(146,"刘备大人，我诸葛瑾又来了．");
 --显示任务目标:<回答诸葛瑾的结盟提案>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [584]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，答覆其实早有了．");
 end
 if JY.Tid==175 then--马良
talk(175,"主公，请与诸葛瑾交谈．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"最近年轻人生龙活虎，屡立战功，难道我老了，不中用了……");
 end
 if JY.Tid==253 then--刘禅
talk(253,"父亲，这个地方不舒服．");
 end
 if JY.Tid==30 then--关兴
talk(30,"杀父之仇，不共戴天．主公，请允许我杀了这个家伙．",
 1,"不可，他毕竟是孔明的哥哥，你要忍忍．");
 end
 if JY.Tid==44 then--张苞
 if GetFlag(135) then
talk(44,"关兴的父亲被东吴杀了，不能就此罢休．");
 else
talk(44,"父亲是死于东吴之手，决不能放过他们．");
 end
 end
 if JY.Tid==146 then--诸葛瑾
talk(1,"又是为结盟而来的吧．");
 if GetFlag(135) then
talk(146,"我家主公非常后悔与魏国结盟，所以想与魏国绝交，改与蜀国结盟修好，今后不断加深两国的友谊，刘备大人，你意下如何？",
 1,"……");
 else
talk(146,"是的，我家主公愿意把谋害张飞的凶手交还给蜀国，并且愿意归还荆州．希望与蜀国结盟修好，今后不断加深两国的友谊，刘备大人，你意下如何？",
 1,"……");
 end
 NextEvent();
 end
 end,
 [585]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，答覆其实早有了．");
 end
 if JY.Tid==175 then--马良
talk(175,"主公，我们大败孙桓率领的孙权军，应该说，在某种程度上已经雪恨了，如果再处死那些叛逆，就再也没有仇恨了．所以，我觉得应该与吴结盟．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"最近年轻人生龙活虎，屡立战功，难道我老了，不中用了……");
 end
 if JY.Tid==253 then--刘禅
talk(253,"父亲，这个地方不舒服．");
 end
 if JY.Tid==30 then--关兴
talk(30,"杀父之仇，不共戴天．主公，请允许我杀了这个家伙．",
 1,"不可，他毕竟是孔明的哥哥，你要忍忍．");
 end
 if JY.Tid==44 then--张苞
 if GetFlag(135) then
talk(44,"关兴的父亲被东吴杀了，不能就此罢休．");
 else
talk(44,"父亲是死于东吴之手，决不能放过他们．");
 end
 end
 if JY.Tid==146 then--诸葛瑾
 if talkYesNo( 146,"刘备大人，您决定了吗？") then
 RemindSave();
talk(146,"刘备大人，您将做何答覆？");
 local menu={
 {"　 结盟",nil,1},
 {"　不结盟",nil,1},
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,3,0,16,M_White,M_White);
 if r==1 then
talk(146,"噢，谢谢．我马上去向吴侯报喜讯．这是吴国的一点心意，请您笑纳．");
 GetItem(1,63);
talk(146,"那我马上回去报告我家主公．");
 MovePerson(146,14,3);
 DecPerson(146);
talk(175,"主公，您作出了正确的决断．但您内心一定很痛苦吧．",
 1,"……吴国确实可恨，但现在没时间为关羽悲伤．现在应该讨伐曹丕，重兴汉室．");
 SetFlag(136,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(592); --goto 592
 elseif r==2 then
 PlayBGM(12);
talk(1,"诸葛瑾，我的答覆没有变，你还是回去吧．",
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
talk(175,"主公，现在应该与他们修好．",
 1,"不要再说了，我意已决．",
 175,"……我知道了．那就考虑进攻吧．听说吴国都督是陆逊．",
 1,"陆逊？没听说过呀．",
 175,"虽然他名声不大，但我听说此人深有谋略，主公不可小看他．");
talk(175,"请列队．");
 WarIni();
 DefineWarMap(44,"第三章 夷陵之战","一、陆逊败退．",50,0,150);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,4,11,4,0,-1,0,
 -1,5,12,4,0,-1,0,
 -1,6,11,4,0,-1,0,
 -1,6,18,4,0,-1,0,
 -1,7,19,4,0,-1,0,
 -1,6,12,4,0,-1,0,
 -1,8,12,4,0,-1,0,
 -1,9,11,4,0,-1,0,
 -1,5,17,4,0,-1,0,
 -1,5,19,4,0,-1,0,
 -1,2,10,4,0,-1,0,
 -1,3,10,4,0,-1,0,
 -1,2,11,4,0,-1,0,
 -1,3,12,4,0,-1,0,
 -1,3,16,4,0,-1,0,
 53,1,15,4,0,-1,1,--赵云
 });
talk(1,"出征．");
 JY.Smap={};
 SetSceneID(0,3);
talk(1,"敌人在江陵，快跟上！");
 SetSceneID(0,11);
talk(151,"什么！刘备出动了．我等候他多时了．现在正是击溃刘备的最好时机，全军，进军彝陵！");
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 150,29,16,3,0,56,16,0,0,-1,0,
 44,27,17,3,0,52,3,0,0,-1,0,
 162,20,18,3,1,53,9,0,0,-1,0,
 147,29,10,3,0,53,14,0,0,-1,0,
 166,27,10,3,0,53,9,0,0,-1,0,
 165,26,10,3,1,53,3,0,0,-1,0,
 164,26,16,3,0,52,3,0,0,-1,0,
 173,22,10,3,3,52,25,0,0,-1,0,
 107,29,12,3,0,51,3,0,0,-1,0,
 45,29,15,3,0,52,3,0,0,-1,0,
 155,30,17,3,0,51,3,0,0,-1,0,
 156,24,18,3,0,51,3,0,0,-1,0,
 157,18,19,3,1,51,6,0,0,-1,0,
 158,23,9,3,1,51,6,0,0,-1,0,
 
 274,18,11,3,1,45,6,0,0,-1,0,
 275,17,18,3,1,45,6,0,0,-1,0,
 276,22,19,3,1,44,6,0,0,-1,0,
 292,20,7,3,1,50,9,0,0,-1,0,
 293,21,16,3,1,50,9,0,0,-1,0,
 294,29,13,3,0,50,9,0,0,-1,0,
 310,19,17,3,1,45,12,0,0,-1,0,
 311,26,18,3,0,45,12,0,0,-1,0,
 340,21,9,3,1,44,17,0,0,-1,0,
 341,28,8,3,0,45,17,0,0,-1,0,
 
 295,17,10,3,1,49,9,0,0,-1,0,
 296,17,12,3,1,49,9,0,0,-1,0,
 297,17,16,3,1,49,9,0,0,-1,0,
 298,24,17,3,1,48,9,0,0,-1,0,
 299,24,8,3,1,48,9,0,0,-1,0,
 300,22,12,3,1,48,9,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [587]=function()
 PlayBGM(11);
talk(151,"呵呵呵．孔明不在这里真乃天助我也，只有他才能识破我的战略．刘备真是个糊涂虫，竟敢率军冒然突进．看来刘备的气数已尽．",
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
talk(175,"主，主公．大事不好！敌人用火攻了．",
 1,"唉……现在我军众多倒成为累赘了．前方道路越来越窄了．");
 WarEnemyWeak(1,1);
 WarEnemyWeak(1,1);
 WarEnemyWeak(1,2);
talk(151,"取胜的时机到了！不要放走了刘备！吴国的命运在此一战！");
 PlayBGM(10);
 NextEvent();
 end,
 [588]=function()
 if WarMeet(163,35) then
 WarAction(1,163,35);
talk(163,"怎么？这支部队是？主将是谁？",
 35,"我就是主将．",
 163,"吓，是蛮族啊，一看你就知道是蛮族，我还是第一次见到蛮族．好，与我单挑吧．",
 35,"好，来吧！");
 WarAction(6,163,35);
 if fight(163,35)==1 then
talk(163,"招！怎么只有招架之功．");
 WarAction(5,163,35);
 WarAction(19,35);
talk(35,"唉呀……太累了……",
 163,"你怎么了，动作这么慢？");
 WarAction(9,163,35);
talk(35,"嘿！这几下怎么样？");
 WarAction(4,35,163);
 WarAction(4,35,163);
talk(35,"哈哈……",
 163,"你好像累了，我送你去歇歇．");
 WarAction(8,163,35);
talk(35,"啊……！");
talk(35,"我命休矣……");
 WarAction(18,35);
 ModifyForce(35,0);
 WarLvUp(GetWarID(163));
 else
talk(35,"嘿！这几下怎么样？");
 WarAction(4,35,163);
talk(163,"啊……！");
 WarAction(17,163);
 WarLvUp(GetWarID(35));
 end
 end
 if (not GetFlag(1063)) and War.Turn==5 then
talk(151,"哈哈哈．机不可失！全军总攻！刘备，这次你休想逃脱．");
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
talk(54,"主公勿慌，赵云来了！");
 SetFlag(1064,1);
 end
 if JY.Status==GAME_WARWIN then
talk(151,"真倒霉！好不容易有此良机……全军撤退！");
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
talk(1,"唉，难道我要死在这里吗……",
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
talk(3,"大哥，你没事吧．",
 1,"是你呀，张飞．对不起……我没能给关羽报仇．",
 3,"大哥，不要害怕！关羽还活着！",
 1,"唉……唉……哇！",
 3,"啊，大哥，振作些！");
 else
talk(1,"关羽，张飞，对不起．没能杀死你们的仇人，请原谅你们的大哥……");
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
talk(1,"张飞，对不起．关羽的仇没能报……",
 3,"说什么呀！大哥，求求你！不要让我一个人留下．",
 1,"哈哈哈……到什么时候你都还是急脾气……张飞，我的天寿也到尽头了．",
 3,"大哥，振作些！");
 end
talk(1,"孔明，多亏了你，我才能夺得汉中，才有今天这样的局面．",
 1,"这次，我没听你的劝告而去讨伐东吴，以致遭到如此惨败，这是报应啊．");
 if GetFlag(135) then
 MovePerson( 3,2,2,
 126,2,2);
 else
 MovePerson( 126,2,2);
 end
talk(126,"主公，不要再想这些了．我心里连一次都没报怨过你．",
 1,"唉．……孔明，我有一事相求．",
 126,"什么事啊？",
 1,"老天已经在召唤我啦．我是想让刘禅继位．可是刘禅不成器，必要的时候请你取而代之．孔明，只有你才能消灭曹丕．",
 126,"主公，不要那么想，我孔明誓死效忠蜀国．呜呜……",
 1,"谢谢．……赵云，我们同甘共苦到今天，我在这里与你告别很伤感啊．",
 54,"主，主公……");
 if GetFlag(58) then
talk(1,"希望大家尽力辅佐刘禅．",
 126,"主公！主公……！",
 54,"呜……，呜……！");
 end
 if GetFlag(135) then
talk(3,"大哥！为什么把我扔在一边都不理我！");
 end
 if not (GetFlag(58) or GetFlag(135)) then
talk(1,"……对不起，让我一个人静一静，我有些累了……",
 126,"……是，臣告退……");
 MovePerson( 126,2,3);
 MovePerson( 126,15,3,
 54,15,3,
 190,15,3,
 170,15,3,
 127,15,3);
talk(1,"呼呼……．…………嗯？是谁？");
 AddPerson(2,15,16,2);
 DrawSMap();
talk(2,"兄长，我来接你了．",
 1,"噢，关羽！你还活着啊！",
 2,"不，我已经死了．张飞也……");
 AddPerson(3,19,14,2);
 DrawSMap();
talk(3,"大哥，我和关羽已先来到这里．大哥也累了吧．怎么样？来不来这里？",
 1,"是啊……．好吧……．");
 MovePerson( 126,7,2)
talk(126,"噢，怎么回事！怎么会是……关羽？还有张飞！");
 MovePerson( 126,4,2)
talk(2,"兄长，走吧……",
 126,"等一等！关羽求求你，先别把主公从这个世界上带走！");
 DecPerson(2);
 DrawSMap();
 MovePerson( 126,3,2)
talk(3,"大哥，我们在等着你呢……．",
 126,"主公！！");
 DecPerson(3);
 MovePerson( 126,3,2)
talk(126,"主公！你要好好考虑！",
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
talk(151,"什么，曹丕打过来了？不好！我们还没消灭蜀国．看来这次也得派使者与蜀国结盟了．快返回吴！");
 SetSceneID(0,3);
talk(1,"很危险啊．陆逊这个人不可小看啊．",
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
talk(126,"主公，关羽之子关兴，张飞之子张苞来见．",
 1,"哦，快让进来．",
 126,"是．张苞、关兴进来．");
 AddPerson(44,37,22,2);
 AddPerson(30,35,23,2);
 MovePerson( 44,11,2,
 30,11,2);
talk(44,"我是张飞之子张苞，今后想和父亲一样，为主公效命．",
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
talk(253,"嗯，父亲，我已长大成人，也要去打仗吗？",
 1,"我如果把你编排在部队里，当然要去打仗．你不愿意吗？",
 253,"不，不是！没那么想……好吧，我先退下了……真烦人……");
 ModifyForce(253,1);
 PlayWavE(11);
 DrawStrBoxCenter("刘禅加入臣下！");
 MovePerson( 253,12,3);
talk(1,"孔明，如此安排行吗？",
 126,"以后如不好生培养，恐不能成大器．他好像还不懂得战争的严酷，主公，我还有要事与您商量……");
 end
 MovePerson(126,0,2);
talk(126,"已与东吴结盟，这样就只有魏国是敌人了．",
 1,"嗯，必须伐魏，复兴汉室．");
 --显示任务目标:<商议今后行动．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [594]=function()
 if JY.Tid==3 then--张飞
talk(3,"二哥的仇不能忘，但复兴汉室是头等大事，二哥一定也是这么想的．");
 end
 if JY.Tid==175 then--马良
talk(175,"尽快伐魏吧．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"决战的时刻终于到了，请看我一展身手吧．");
 end
 if JY.Tid==203 then--严颜
talk(203,"决战的时刻终于到了，请看我一展身手吧．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"到魏国洛阳，有两条路可走，一条是从荆州的襄阳走，另一条是从汉中取道关中长安．");
 DrawMulitStrBox("　诸葛亮在此所言”关中”，不是指刘备已夺取的汉中，是指汉中再往北．*　有长安和陈仓二处险要．");
talk(126,"荆州和关中都有魏国精锐把守．",
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
talk(3,"向关中派兵是可以，但如果那样……就得分兵，可是我们哪里有那么多人马可分呀？");
 end
 if JY.Tid==175 then--马良
talk(175,"是呀……诚如军师所言，我也认为有必要分兵．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"我想跟随主公一齐作战．");
 end
 if JY.Tid==203 then--严颜
talk(203,"关中吗？关中是汉中以北一带的总称，陈仓和长安等处也属关中．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"主公，下决定了吗？") then
 RemindSave();
 DrawSMap();
 local menu={
 {"　 派遣奇袭队",nil,1},
 {"　不派遣奇袭队",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,M_White,M_White);
 if r==1 then
 if not GetFlag(38) then
talk(126,"奇袭队的主帅，派庞统是合适人选．",
 1,"嗯，快唤庞统来．");
 AddPerson(133,37,23,2);
 MovePerson(133,3,2);
talk(133,"主公，找我何事？");
 MovePerson(133,8,2);
talk(1,"庞统，你来指挥关中奇袭队．",
 133,"决定向关中出兵了吧．",
 1,"不错，你所料极是．",
 133,"得令．我马上去阳平关．",
 1,"嗯，带赵云等人同去吧．",
 133,"是，我先去了．");
 MovePerson( 133,12,3);
 else
talk(126,"奇袭队的主帅，赵云是合适人选．",
 1,"嗯，快唤赵云来．");
 AddPerson(54,37,23,2);
 MovePerson(54,3,2);
talk(54,"主公，找我何事？");
 MovePerson(54,8,2);
talk(1,"赵云，你来指挥关中奇袭队．",
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
talk(126,"是，全军进发荆州吧．");
 end
talk(175,"那，去东吴邀请共同发兵吧．",
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
talk(214,"陛下，蜀吴已结成同盟，很明显要共同进攻我们，我们如何应付？",
 213,"嗯，派援军去襄阳．那，夏侯惇．",
 17,"在！");
 MovePerson(17,2,2);
 MovePerson(17,0,0);
talk(213,"马上率军增援襄阳，与襄阳守将曹仁协力，顶住蜀军．",
 17,"遵命，我马上去！");
 MovePerson(17,14,1);
talk(213,"还有，曹洪、贾诩．",
 20,"在．",
 94,"有何吩咐．");
 MovePerson( 20,2,3,
 94,2,2);
 MovePerson( 20,1,0,
 94,1,0);
talk(213,"曹洪，你去关中向曹真传命，敌人若攻来就迎击，否则就增援襄阳．",
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
talk(17,"奉圣上之命，前来增援．",
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
talk(175,"主公，我刚从东吴回来．");
 --显示任务目标:<商议今后行动>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [599]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，听听报告吧．");
 end
 if JY.Tid==175 then--马良
talk(1,"马良，联合起兵的事如何了？",
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
talk(170,"主公，有没有东吴参加无所谓，有我在就够了．");
 end
 if JY.Tid==203 then--严颜
talk(203,"与东吴交涉很顺利吧．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"先请听听马良的报告吧．");
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
talk(175,"主公，孙权到达江陵了．",
 1,"是吗，请到这里来．",
 175,"是．");
 MovePerson(175,12,2);
talk(1,"东吴……．关羽遭东吴毒手时，哪里想到今日会与孙权联合攻曹魏．",
 126,"主公的英明决断，才造成今日的有利局势．主公，孙权好像已经到了．");
 AddPerson(142,-5,2,3);
 MovePerson(142,10,3);
talk(142,"刘备公，幸会幸会．");
 --显示任务目标:<与孙权等人商议今后的事．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [601]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，先问客人吧．");
 end
 if JY.Tid==142 then--孙权
talk(142,"我率部来此，只为伐魏．我先介绍一下我军统帅陆逊．陆逊，有请．");
 AddPerson(151,-5,1,3)
 MovePerson(151,9,3);
talk(151,"在下陆逊，大家一回生，二回熟．",
 1,"孙权公，陆逊公，我们一起伐魏，共诛国贼吧．",
 142,"好吧．消灭了曹丕，天下也就太平了．");
 NextEvent();
 end
 if JY.Tid==170 then--黄忠
talk(170,"主公，先听孙权公妙策吧．");
 end
 if JY.Tid==203 then--严颜
talk(203,"主公，先听孙权公妙策吧．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"先听孙权公妙策吧．");
 end
 end,
 [602]=function()
 if JY.Tid==3 then--张飞
talk(3,"要与东吴一起作战？在此之前，想都不敢想．");
 end
 if JY.Tid==142 then--孙权
talk(142,"我们也会尽力伐魏．");
 end
 if JY.Tid==151 then--陆逊
talk(151,"一同伐魏吧．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"一同伐魏吧．");
 end
 if JY.Tid==203 then--严颜
talk(203,"一同伐魏吧．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"请孙权派奇袭队，分散敌军兵力为好．",
 1,"让奇袭队进攻何处呢？",
 126,"东吴之北是合淝，由张辽镇守．如果进攻合淝，张辽就不能抽身增援他处．请主公熟思决断．");
 --显示任务目标:<考虑是否请孙权派奇袭队．>
 NextEvent();
 end
 end,
 [603]=function()
 if JY.Tid==3 then--张飞
talk(3,"要与东吴一起作战？在此之前，想都不敢想．");
 end
 if JY.Tid==142 then--孙权
talk(142,"我们也会尽力伐魏．");
 end
 if JY.Tid==151 then--陆逊
talk(151,"一同伐魏吧．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"一同伐魏吧．");
 end
 if JY.Tid==203 then--严颜
talk(203,"一同伐魏吧．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"主公，考虑得如何了？") then
 RemindSave();
 DrawSMap();
 local menu={
 {"　请孙权攻合淝",nil,1},
 {"　　 不邀请",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,M_White,M_White);
 if r==1 then
talk(1,"孙权公，派奇袭队如何？",
 142,"奇袭队？",
 1,"想请您进攻东吴北面的合淝．",
 142,"让我牵制敌军．好，我发兵合淝．");
 SetFlag(90,1);
talk(142,"那好，我马上回去，做发兵合淝的准备．");
 elseif r==2 then
talk(142,"我军想资助些军需，请笑纳．");
 GetMoney(2000);
 PlayWavE(11);
 DrawStrBoxCenter("接受了东吴２０００黄金的援助！");
talk(142,"以后有什么事，请吩咐陆逊．那我先告退．");
 end
 MovePerson(142,12,2)
talk(126,"那我们也准备出征吧．");
 --显示任务目标:<进行出征准备．>
 NextEvent();
 end
 end
 end,
 [604]=function()
 if JY.Tid==3 then--张飞
talk(3,"要与东吴一起作战？在此之前，想都不敢想．");
 end
 if JY.Tid==151 then--陆逊
talk(151,"一同伐魏吧．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"一同伐魏吧．");
 end
 if JY.Tid==203 then--严颜
talk(203,"一同伐魏吧．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"出征吗？") then
 RemindSave();
 PlayBGM(12);
talk(126,"请编组部队．");
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
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,8,20,2,0,-1,0,
 125,8,21,2,0,-1,0,
 -1,7,19,2,0,-1,0,
 -1,9,19,2,0,-1,0,
 -1,8,18,2,0,-1,0,
 -1,10,20,2,0,-1,0,
 -1,9,21,2,0,-1,0,
 -1,7,22,2,0,-1,0,
 150,12,22,2,0,-1,0,
 147,11,21,2,0,-1,0,
 166,11,19,2,0,-1,0,
 165,12,20,2,0,-1,0,
 164,13,21,2,0,-1,0,
 372,1,16,4,0,-1,1,
 });
 DrawSMap();
talk(126,"首先进攻离此最近的襄阳吧．");
 JY.Smap={};
 SetSceneID(0,3);
 ModifyForce(121+1,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 18,18,4,1,2,55,3,0,0,-1,0,
 168,14,9,1,2,52,3,0,0,-1,0,
 121,16,6,1,0,52,9,0,0,-1,0,--文聘
 256,17,5,1,2,48,3,0,0,-1,0,
 257,17,6,1,2,48,3,0,0,-1,0,
 258,11,15,1,2,47,3,0,0,-1,0,
 259,10,15,1,2,47,3,0,0,-1,0,
 260,9,8,1,2,48,3,0,0,-1,0,
 261,11,9,1,1,47,3,0,0,-1,0,
 292,8,11,1,1,51,9,0,0,-1,0,
 293,13,11,1,1,51,9,0,0,-1,0,
 274,18,5,1,1,48,6,0,0,-1,0,
 275,7,8,1,0,48,6,0,0,-1,0,
 276,11,14,1,2,48,6,0,0,-1,0,
 277,10,14,1,2,48,6,0,0,-1,0,
 
 83,21,18,3,3,51,21,0,0,-1,1,
 170,18,18,3,3,50,9,0,0,-1,1,
 294,17,18,3,3,45,9,0,0,-1,1,
 295,19,17,3,3,45,9,0,0,-1,1,
 296,22,17,3,3,44,9,0,0,-1,1,
 297,23,18,3,3,44,9,0,0,-1,1,
 298,22,19,3,3,45,9,0,0,-1,1,
 262,14,3,3,0,47,3,0,0,-1,0,
 263,14,4,3,0,48,3,0,0,-1,0,
 264,4,8,1,2,48,3,0,0,-1,0,
 278,9,10,1,2,46,6,0,0,-1,0,
 279,10,10,1,2,46,6,0,0,-1,0,
 280,15,8,1,2,47,6,0,0,-1,0,
 281,15,11,1,2,47,6,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end
 end,
 [605]=function()
 PlayBGM(11);
talk(19,"蜀军就要攻来了！一定要挡住他们！",
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
talk(19,"哦，援军来了吗？大家加把劲！援军已到，一鼓作气杀回去！",
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
talk(372+1,"不能让魏国长期霸占荆州．");
 end
 PlayBGM(9);
 SetFlag(1065,1);
 end
 if WarMeet(373,19) then
 WarAction(1,373,19);
talk(373,"曹仁，久违了．",
 19,"哦，何人？你……，是你！还活着！？",
 373,"我怎会这么容易就死，现在我要雪荆州之恨！",
 19,"哼！来吧！");
 WarAction(6,373,19);
 if fight(373,19)==1 then
talk(19,"我来也！",
 373,"好小子！你哪里是我的对手！");
 WarAction(5,19,373);
talk(373,"不陪你玩了！先宰了再说！！");
 WarAction(8,373,19);
talk(19,"哇！");
 WarAction(18,19);
 DrawStrBoxCenter("神秘武将杀了曹仁！");
 SetFlag(903,0); --曹仁死亡
talk(1,"怎么？发生了什么事？",
 126,"敌人内哄了？一定要抓住这个时机！",
 1,"好，猛劲杀过去！");
 NextEvent();
 else
 WarAction(4,19,373);
talk(373,"………………");
 WarAction(17,373);
 WarLvUp(GetWarID(19));
 end
 end
 if JY.Status==GAME_WARWIN then
talk(19,"可、可恶……刘备小儿！哇！！",
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
talk(373,"……我哪有面目去见兄长……");
 WarAction(16,373);
 DrawStrBoxCenter("神秘武将走了．");
talk(1,"嗯！那是……？莫非……",
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
talk(126,"那就进襄阳城吧．");
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
talk(126,"恭喜主公，终于又夺回了襄阳．");
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [610]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，二哥虽已过世，但总觉得他还活着．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"贺喜主公，能重夺襄阳．");
 end
 if JY.Tid==151 then--陆逊
talk(151,"虽然打败了曹仁，但若要打到洛阳，还得先攻下宛城，于路上，敌人也会严阵以待．");
 end
 if JY.Tid==148 then--甘宁
talk(148,"初次相见，我乃东吴之臣甘宁．以后，我们会相处的很好的．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"要去洛阳，必须先通过新野或南郡，然后过宛城．",
 1,"嗯，若不攻下新野和南郡，有在宛城被夹击的危险．",
 126,"正是，应该请陆逊支援，同时进攻新野和南郡．");
 NextEvent();
 end
 end,
 [611]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，二哥虽已过世，但总觉得他还活着．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"贺喜主公，能重夺襄阳．");
 end
 if JY.Tid==151 then--陆逊
talk(151,"你们的话，我都听到了．我是去打新野还是南郡？决定后告诉我．");
 NextEvent();
 end
 if JY.Tid==148 then--甘宁
talk(148,"我们东吴之臣也愿与蜀军合力对付魏国．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"正是，应该请陆逊支援，同时进攻新野和南郡．");
 end
 end,
 [612]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，二哥虽已过世，但总觉得他还活着．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"贺喜主公，能重夺襄阳．");
 end
 if JY.Tid==151 then--陆逊
 if talkYesNo( 151,"考虑的如何了？") then
 RemindSave();
 DrawSMap();
 local menu={
 {"请陆逊去攻打南郡",nil,1},
 {"请陆逊去攻打新野",nil,1}
 }
 local r=ShowMenu(menu,2,0,0,0,0,0,2,0,16,M_White,M_White);
 if r==1 then
 SetFlag(92,1);
talk(151,"好吧，那我就去打南郡．");
 elseif r==2 then
talk(151,"好吧，那我就去打新野．");
 end
 MovePerson( 151,12,1,
 148,12,1);
 DecPerson(151);
 DecPerson(148);
talk(126,"我们也出发吧，准备好了，请告诉我．",
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
talk(148,"如果拿下新野和南郡，后面就只剩下宛城了．");
 end
 if JY.Tid==126 then--诸葛亮
talk(126,"听说于禁镇守新野，徐晃镇守南郡．");
 end
 end,
 [613]=function()
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 PlayBGM(12);
talk(126,"请编组部队．");
 WarIni();
 if GetFlag(92) then
 DefineWarMap(47,"第四章 新野II之战","一、于禁的撤退．*二、自军部队夺取粮仓．",40,0,62);
 SelectTerm(1,{
 0,3,6,4,0,-1,0,
 125,4,7,4,0,-1,0,
 -1,2,6,4,0,-1,0,
 -1,2,7,4,0,-1,0,
 -1,5,8,4,0,-1,0,
 -1,7,4,4,0,-1,0,
 -1,7,5,4,0,-1,0,
 -1,8,3,4,0,-1,0,
 -1,9,5,4,0,-1,0,
 -1,3,9,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 62,22,12,3,2,55,25,0,0,-1,0,
 256,24,14,3,2,45,3,0,0,-1,0,
 101,20,13,3,0,52,9,0,0,-1,0,--张绣
 115,21,15,3,0,52,3,0,0,-1,0,--李典
 299,13,13,3,0,52,9,0,0,-1,0,
 300,13,15,3,0,49,9,0,0,-1,0,
 301,15,11,3,0,50,9,0,0,-1,0,
 260,17,13,3,2,51,3,0,0,-1,0,
 261,21,17,3,2,51,3,0,0,-1,0,
 274,14,7,3,2,48,6,0,0,-1,0,
 275,16,7,3,2,48,6,0,0,-1,0,
 276,18,13,3,2,46,6,0,0,-1,0,
 277,21,16,3,2,46,6,0,0,-1,0,
 292,8,14,3,0,49,9,0,0,-1,0,
 293,19,13,3,0,52,9,0,0,-1,0,
 294,22,13,3,0,51,9,0,0,-1,0,
 
 332,15,13,3,0,45,14,0,0,-1,0,
 278,21,11,3,2,44,6,0,0,-1,0,
 257,15,6,3,2,43,3,0,0,-1,0,
 67,0,18,4,1,55,9,0,0,-1,1,
 295,1,19,4,1,52,9,0,0,-1,1,
 296,17,0,3,1,49,9,0,0,-1,1,
 297,18,0,3,1,49,9,0,0,-1,1,
 298,19,1,3,1,50,9,0,0,-1,1,
 });
 else
 DefineWarMap(46,"第四章 南郡之战","一、徐晃的撤退．*二、占领两个鹿砦．",40,0,78);
 SelectTerm(1,{
 0,3,18,4,0,-1,0,
 125,2,18,4,0,-1,0,
 -1,1,15,4,0,-1,0,
 -1,1,17,4,0,-1,0,
 -1,1,19,4,0,-1,0,
 -1,2,16,4,0,-1,0,
 -1,3,17,4,0,-1,0,
 -1,4,16,4,0,-1,0,
 -1,5,18,4,0,-1,0,
 -1,6,17,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 78,22,6,3,2,56,9,0,0,-1,0,
 209,16,14,3,2,53,21,0,0,-1,0,
 101,22,7,3,0,52,9,0,0,-1,0,--张绣
 115,22,8,3,0,52,3,0,0,-1,0,--李典
 274,17,17,3,2,49,6,0,0,-1,0,
 256,10,3,3,4,47,3,3,11,-1,0,
 257,13,5,3,4,47,3,3,11,-1,0,
 258,16,18,3,2,47,3,0,0,-1,0,
 292,5,5,3,0,48,9,0,0,-1,0,
 293,3,5,3,0,48,9,0,0,-1,0,
 294,4,5,3,0,52,9,0,0,-1,0,
 295,13,6,3,0,48,9,0,0,-1,0,
 296,19,6,3,0,52,9,0,0,-1,0,
 275,4,4,3,0,49,6,0,0,-1,0,
 276,14,8,3,0,46,6,0,0,-1,0,
 277,21,7,3,0,46,6,0,0,-1,0,
 
 310,12,10,3,0,48,12,0,0,-1,0,
 311,12,12,3,0,47,12,0,0,-1,0,
 297,8,0,3,1,52,9,0,0,-1,1,
 298,9,1,3,1,52,9,0,0,-1,1,
 299,11,1,3,1,48,9,0,0,-1,1,
 300,7,1,3,1,48,9,0,0,-1,1,
 });
 end
 JY.Smap={};
 SetSceneID(0,3);
 if GetFlag(92) then
talk(151,"那好刘备公，我们去打南郡．",
 1,"嗯，拜托了．",
 126,"我们也向新野出发吧．");
 NextEvent(614); --goto 614
 else
talk(151,"那好刘备公，我们去打新野．",
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
talk(63,"别放刘备军过去，一个兵也不行．",
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
talk(68,"别放刘备军过去，将其赶回江陵！",
 63,"啊，援军！兄弟们，援军来了！大家坚守住！");
 PlayBGM(9);
 SetFlag(1066,1);
 end
 if (not GetFlag(1067)) and WarCheckLocation(-1,14,24) then
talk(63,"什么？粮仓丢了！如此，怎么守城！可恶，撤到宛城！");
 WarAction(16,63);
 SetFlag(1067,1);
 NextEvent();
 end
 if WarMeet(3,63) then
 WarAction(1,3,63);
talk(3,"对面可是于禁！敢与我张飞一战！",
 63,"坏了！张飞！！哇！",
 3,"为我二哥关羽报仇！你等死吧！我来也！");
 WarAction(6,3,63);
 if fight(3,63)==1 then
 WarAction(8,3,63);
talk(3,"如何！你不是我对手！",
 63,"可恶！活命要紧！张飞，后会有期！！",
 3,"呸！别跑！这岂是大将所为！");
talk(63,"撤退！快回宛城！");
 WarAction(16,63);
 WarLvUp(GetWarID(3));
 NextEvent();
 else
 WarAction(4,63,3);
talk(3,"可恶！");
 WarAction(17,3);
 WarLvUp(GetWarID(63));
 end
 end
 if JY.Status==GAME_WARWIN then
talk(63,"可、可恶！撤退！回宛城！");
 NextEvent();
 end
 end,
 [616]=function()
 PlayBGM(7);
 DrawMulitStrBox("　于禁撤退了，刘备军占领新野．");
talk(1,"干得好！如此，再攻下宛城，就直逼洛阳了！");
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
talk(79,"刘备虽来了！但是绝不让他们过去，我们用水攻．",
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
talk(44,"我乃张飞之子张苞是也！来将可敢与我单打独斗！",
 210,"原来是张飞之子．我夏侯尚不以为怪，来得好，先打再说吧！");
 WarAction(6,44,210);
 if fight(44,210)==1 then
talk(210,"打就打吧……",
 44,"哼！刚才不知天高地厚，现在后悔了吧！");
 WarAction(8,44,210);
talk(210,"啊！不、不愧为张飞之……子……");
 WarAction(17,210);
talk(44,"夏侯尚，俺张苞送你见阎王！");
 WarLvUp(GetWarID(44));
 else
 WarAction(4,210,44);
talk(44,"啊！不……不……");
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
talk(1,"干得漂亮！占领了城堡，无须担心敌人水攻了．一口气击垮徐晃！",
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
talk(1,"干得漂亮！占领了城堡，无须担心敌人水攻了．一口气击垮徐晃！",
 79,"什么！城堡被占领了！哼，我的妙计不成，没办法，回军宛城！");
 WarAction(16,79);
 NextEvent();
 end
 end
 if (not GetFlag(1068)) and War.Turn==10 then
talk(79,"太好了，现在马上决堤，放水淹刘备军．");
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
talk(126,"来不及了……",
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
talk(79,"可恶！先撤退再说！回宛城！");
 PlayBGM(7);
 NextEvent();
 end
 end,
 [619]=function()
 DrawMulitStrBox("　徐晃撤退了，刘备军占领了南郡．");
talk(1,"干得漂亮！此去陷落宛城，洛阳就在眼前了！");
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
talk(1,"陆逊大人，辛苦了．",
 151,"此须小事，何足挂齿．蜀军如此强大，也让人惊奇．刘备公，我主有令，命我返回，实在对不起……",
 1,"好吧，那就请代我向孙权致意．",
 151,"多谢．那我留下他们留在这里帮忙．");
 if GetFlag(132) then
 AddPerson(148,5,22,0);
 MovePerson( 148,6,0);
talk(148,"奉陆逊都督之命，我与凌统、徐盛、丁奉留在这里与刘备公并肩作战，听从您的调遣．");
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
talk(167,"奉陆逊都督之命，我与徐盛、丁奉留在这里与刘备公并肩作战，听从您的调遣．");
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
talk(166,"奉陆逊都督之命，我与丁奉留在这里与刘备公并肩作战，听从您的调遣．");
 ModifyForce(166,1);
 ModifyForce(165,1);
 JY.Person[166]["道具1"]=0;
 JY.Person[166]["道具2"]=0;
 JY.Person[165]["道具1"]=0;
 JY.Person[165]["道具2"]=0;
 PlayWavE(11);
 DrawStrBoxCenter("徐盛、丁奉加入！");
 end
talk(1,"哦，这下有倚仗了．陆逊都督，多谢了．",
 151,"那我先走一步．");
 MovePerson( 151,7,1);
talk(151,"（刘备、还有孔明……与之为敌不会有好下场．如果主公也不了解我的苦心……）");
 MovePerson( 151,2,1);
 DecPerson(151);
talk(126,"那就乘势进攻宛城吧，请作出征准备．");
 --显示任务目标:<进行出征准备>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [621]=function()
 if JY.Tid==3 then--张飞
talk(3,"大哥，早做准备．");
 end
 if JY.Tid==175 then--马良
talk(175,"主公，请作出征准备．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"主公，请让我出征吧．");
 end
 if JY.Tid==203 then--严颜
talk(203,"主公，请让我出征吧．");
 end
 if JY.Tid==148 then--甘宁
talk(148,"刘备公，以后请多关照．");
 end
 if JY.Tid==167 then--凌统
talk(167,"刘备公，以后请多关照．");
 end
 if JY.Tid==166 then--徐盛
talk(166,"刘备公，以后请多关照．");
 end
 if JY.Tid==165 then--丁奉
talk(165,"刘备公，以后请多关照．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 PlayBGM(12);
talk(126,"请编组部队．");
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
 0,8,20,2,0,-1,0,
 125,7,20,2,0,-1,0,
 -1,4,18,2,0,-1,0,
 -1,6,17,2,0,-1,0,
 -1,6,19,2,0,-1,0,
 -1,7,18,2,0,-1,0,
 -1,9,18,2,0,-1,0,
 -1,9,19,2,0,-1,0,
 -1,9,21,2,0,-1,0,
 -1,11,19,2,0,-1,0,
 1,23,5,3,0,-1,1,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 16,12,3,1,2,59,9,0,0,-1,0,
 78,11,8,1,2,56,9,0,0,-1,0,
 62,15,14,1,2,55,25,0,0,-1,0,--原版居然是发石车
 93,9,4,1,0,58,16,0,0,-1,0,--贾诩
 18,15,5,1,0,58,3,0,0,903,0,--曹仁
 209,9,9,1,0,55,21,0,0,-1,0,--夏侯尚
 256,4,8,1,2,54,3,0,0,-1,0,
 257,16,10,1,2,54,3,0,0,-1,0,
 258,8,11,1,2,49,3,0,0,-1,0,
 259,9,3,1,0,49,3,0,0,-1,0,
 260,8,6,1,0,50,3,0,0,-1,0,
 261,9,11,1,2,50,3,0,0,-1,0,
 262,18,5,1,0,49,3,0,0,-1,0,
 292,5,3,1,0,54,9,0,0,-1,0,
 293,5,11,1,2,54,9,0,0,-1,0,
 294,6,4,1,0,52,9,0,0,-1,0,
 295,8,9,1,0,52,9,0,0,-1,0,
 296,19,7,1,0,53,9,0,0,-1,0,
 297,13,7,1,0,53,9,0,0,-1,0,
 298,13,9,1,0,52,9,0,0,-1,0,
 299,16,7,1,0,52,9,0,0,-1,0,
 300,18,7,1,0,51,9,0,0,-1,0,
 274,5,7,1,2,50,6,0,0,-1,0,
 275,6,13,1,2,54,6,0,0,-1,0,
 276,7,12,1,2,54,6,0,0,-1,0,
 277,8,4,1,0,50,6,0,0,-1,0,
 278,18,4,1,0,50,6,0,0,-1,0,
 279,12,5,1,0,50,6,0,0,-1,0,
 --援兵
 67,18,21,3,3,57,12,0,0,-1,1,--许褚/贼兵
 310,19,21,3,3,52,12,0,0,-1,1,
 311,19,22,3,3,52,12,0,0,-1,1,
 312,18,22,3,3,51,12,0,0,-1,1,
 313,20,22,3,3,51,12,0,0,-1,1,
 --援兵
 79,4,22,4,1,58,9,0,0,-1,1,--张辽/骑兵
 115,3,21,4,1,54,3,0,0,-1,1,--李典
 217,2,20,4,1,54,9,0,0,-1,1,--乐进
 263,0,20,4,1,51,3,0,0,-1,1,
 264,1,21,4,1,51,3,0,0,-1,1,
 265,2,22,4,1,50,3,0,0,-1,1,
 266,3,23,4,1,49,3,0,0,-1,1,
 });
 else
 DefineWarMap(48,"第四章 宛I之战","一、张辽的撤退",40,0,79);
 SelectTerm(1,{
 0,2,15,4,0,-1,0,
 125,2,14,4,0,-1,0,
 -1,0,13,4,0,-1,0,
 -1,0,17,4,0,-1,0,
 -1,1,14,4,0,-1,0,
 -1,1,16,4,0,-1,0,
 -1,2,17,4,0,-1,0,
 -1,3,16,4,0,-1,0,
 -1,3,19,4,0,-1,0,
 -1,4,17,4,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 79,15,6,3,2,58,25,0,0,-1,0,
 256,12,10,3,0,52,3,0,0,-1,0,
 257,12,12,3,0,50,3,0,0,-1,0,
 258,10,9,3,0,50,3,3,11,-1,0,
 259,13,7,3,0,49,3,3,11,-1,0,
 260,14,7,3,0,50,3,0,0,-1,0,
 261,13,14,3,0,49,3,0,0,-1,0,
 274,13,11,3,0,52,6,0,0,-1,0,
 275,13,9,3,0,50,6,0,0,-1,0,
 276,15,12,3,0,49,6,0,0,-1,0,
 332,12,9,3,0,50,14,0,0,-1,0,
 
 217,25,15,3,1,54,9,0,0,-1,1,
 292,24,15,3,1,52,9,0,0,-1,1,
 293,25,17,3,1,51,9,0,0,-1,1,
 294,26,14,3,1,51,9,0,0,-1,1,
 295,26,16,3,1,50,9,0,0,-1,1,
 296,27,15,3,1,50,9,0,0,-1,1,
 115,14,1,3,1,54,3,0,0,-1,1,
 297,12,1,3,1,52,9,0,0,-1,1,
 298,13,2,3,1,51,9,0,0,-1,1,
 299,14,3,3,1,51,9,0,0,-1,1,
 300,15,2,3,1,50,9,0,0,-1,1,
 301,16,1,3,1,50,9,0,0,-1,1,
 });
 end
 DrawSMap();
talk(126,"现在进兵宛城吧．")
 JY.Smap={};
 if GetFlag(90) then
 SetSceneID(0,3);
talk(142,"我军攻打合淝，绊住张辽，全军！出发！")
 SetSceneID(0);
talk(80,"哎呀！不能去增援夏侯惇了，可恶！")
 NextEvent(626); --goto 626
 else
 SetSceneID(0,11);
talk(142,"我们先坐山观蜀魏两虎相斗．凭什么帮刘备，对我来说，最好两败俱伤．")
 SetSceneID(0,11);
talk(80,"吴军不来进攻合淝，太好了，全军马上行动，袭击刘备军侧翼．")
 NextEvent(622); --goto 622
 end
 JY.Status=GAME_WMAP;
 end
 end
 end,
 [622]=function()
 PlayBGM(11);
talk(80,"太好了，好像来得及，全军注意，突击刘备军侧翼．",
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
talk(218,"张辽！别松劲！乐进来了！",
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
talk(116,"张辽，抱歉，来晚了！",
 80,"哦，李典终于来了！好，发动总攻击！");
 PlayBGM(9);
 SetFlag(1073,1);
 end
 if WarMeet(3,80) then
 WarAction(1,3,80);
talk(3,"张辽，好久不见了！",
 80,"张飞吗？来得好！单挑！",
 3,"哼，输给你，我就不是张飞！来吧，张辽！");
 WarAction(6,3,80);
 if fight(3,80)==1 then
talk(3,"喂，你不行了吧！",
 80,"呀，还是你厉害！",
 3,"看枪！！");
 WarAction(8,3,80);
talk(80,"哇！哼，没办法，全军撤退！张飞，后会有期！");
 WarAction(16,80);
talk(3,"呸，跑得倒快．哈，吕布一死，我就无敌于天下了！");
 WarLvUp(GetWarID(3));
 NextEvent();
 else
 WarAction(4,80,3);
talk(3,"……");
 WarAction(17,3);
 WarLvUp(GetWarID(80));
 end
 end
 if JY.Status==GAME_WARWIN then
talk(80,"哼，没办法，撤退！快撤！");
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
talk(1,"终于顶住了，好，全军重新整编，马上进攻宛城．",
 126,"请编组部队．");
 WarIni();
 DefineWarMap(49,"第四章 宛II之战","一、夏侯惇的撤退",50,0,16);
 SelectTerm(1,{
 0,8,20,2,0,-1,0,
 125,7,20,2,0,-1,0,
 -1,4,18,2,0,-1,0,
 -1,6,17,2,0,-1,0,
 -1,6,19,2,0,-1,0,
 -1,7,18,2,0,-1,0,
 -1,9,18,2,0,-1,0,
 -1,9,19,2,0,-1,0,
 -1,9,21,2,0,-1,0,
 -1,11,19,2,0,-1,0,
 1,23,5,3,0,-1,1,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 16,12,3,1,2,59,9,0,0,-1,0,
 78,11,8,1,2,56,9,0,0,-1,0,
 62,15,14,1,2,55,25,0,0,-1,0,--原版居然是发石车
 93,9,4,1,0,58,16,0,0,-1,0,--贾诩
 18,15,5,1,0,58,3,0,0,903,0,--曹仁
 209,9,9,1,0,55,21,0,0,-1,0,--夏侯尚
 256,4,8,1,2,54,3,0,0,-1,0,
 257,16,10,1,2,54,3,0,0,-1,0,
 258,8,11,1,2,49,3,0,0,-1,0,
 259,9,3,1,0,49,3,0,0,-1,0,
 260,8,6,1,0,50,3,0,0,-1,0,
 261,9,11,1,2,50,3,0,0,-1,0,
 262,18,5,1,0,49,3,0,0,-1,0,
 292,5,3,1,0,54,9,0,0,-1,0,
 293,5,11,1,2,54,9,0,0,-1,0,
 294,6,4,1,0,52,9,0,0,-1,0,
 295,8,9,1,0,52,9,0,0,-1,0,
 296,19,7,1,0,53,9,0,0,-1,0,
 297,13,7,1,0,53,9,0,0,-1,0,
 298,13,9,1,0,52,9,0,0,-1,0,
 299,16,7,1,0,52,9,0,0,-1,0,
 300,18,7,1,0,51,9,0,0,-1,0,
 274,5,7,1,2,50,6,0,0,-1,0,
 275,6,13,1,2,54,6,0,0,-1,0,
 276,7,12,1,2,54,6,0,0,-1,0,
 277,8,4,1,0,50,6,0,0,-1,0,
 278,18,4,1,0,50,6,0,0,-1,0,
 279,12,5,1,0,50,6,0,0,-1,0,
 --援兵
 67,18,21,3,3,57,12,0,0,-1,1,--许褚/贼兵
 310,19,21,3,3,52,12,0,0,-1,1,
 311,19,22,3,3,52,12,0,0,-1,1,
 312,18,22,3,3,51,12,0,0,-1,1,
 313,20,22,3,3,51,12,0,0,-1,1,
 --援兵
 79,4,22,4,1,58,9,0,0,-1,1,--张辽/骑兵
 115,3,21,4,1,54,3,0,0,-1,1,--李典
 217,2,20,4,1,54,9,0,0,-1,1,--乐进
 263,0,20,4,1,51,3,0,0,-1,1,
 264,1,21,4,1,51,3,0,0,-1,1,
 265,2,22,4,1,50,3,0,0,-1,1,
 266,3,23,4,1,49,3,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [626]=function()
 PlayBGM(11);
talk(17,"刘备，你太得意了！我夏侯惇要让你见识一下魏军的真正实力．",
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
talk(1,"好！降下吊桥！");
 --
 SetWarMap(16,17,1,4);
 PlayWavE(18);
 WarDelay(48);
 War.MapID=62;
 WarDelay(12);
 --
 DrawStrBoxCenter("吊桥降下来了！");
talk(79,"什么，吊桥被降下来了！？哼，于禁这家伙真靠不住！唉！以后再跟你算帐，迎击！");
 WarModifyAI(297,1);
 WarModifyAI(298,1);
 WarModifyAI(299,1);
 SetFlag(216,1);
 end
 if WarMeet(3,79) then
 WarAction(1,3,79);
talk(3,"徐晃！明年今日就是你的忌日！碰上我，你算完了！",
 79,"放屁！你也想尝尝关羽一样的下场吗？",
 3,"放肆！不容你猖獗，看枪！");
 WarAction(6,3,79);
 if fight(3,79)==1 then
talk(79,"啊！太，太强了！",
 3,"哼，你以为能赢我吗？看枪！死吧！");
 WarAction(8,3,79);
talk(79,"呜……",
 79,"后，后悔莫及……");
 WarAction(17,79);
 WarLvUp(GetWarID(3));
 else
 WarAction(4,79,3);
talk(3,"呜……");
 WarAction(17,3);
 WarLvUp(GetWarID(79));
 end
 end
 if (not GetFlag(215)) and WarCheckArea(-1,11,4,13,15) then
talk(17,"进城里来了吗，哈哈哈，按我的计谋上当了，也不想想，为什么特意留一座桥，那里进退不自如．机会来了！一口气冲垮敌人！！");
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
talk(68,"终于赶上了，快！");
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
talk(80,"夏侯将军，抱歉，来晚了！击退孙权花了不少时间。",
 17,"哦，张辽终于来了！");
 SetFlag(1075,1);
 end
 if GetFlag(58) and WarCheckArea(-1,3,9,5,14) then
 PlayBGM(11);
talk(17,"大胆刘备军！竟敢来此！");
 PlayBGM(12);
 WarShowArmy(1);
talk(2,"听说兄长处境艰难，关羽特来参见！想要命的，离我远点！",
 1,"噢……！我没认错吧！关羽，是你吧！",
 2,"夏侯惇，俺关羽特来会你！");
 WarMoveTo(2,12,2);
 WarAction(1,2,17);
talk(17,"你，你是关羽！你没死！",
 2,"魏国不亡，我还不能死．我从阎王那里又回来了．",
 17,"那好，我再把你送回去！");
 WarAction(5,17,2);
talk(17,"你这个死不了的，再宰死你．",
 2,"你这两下子，不足为敌！");
 WarAction(4,2,17);
talk(17,"噢！",
 2,"夏侯惇！小心！");
 WarAction(8,2,17);
talk(17,"哇！！");
 WarAction(18,17);
talk(2,"哼……夏侯惇，再见了……");
 WarLvUp(GetWarID(2));
 NextEvent();
 end
 if JY.Status==GAME_WARWIN then
 --talk( 17,"你，你们……我虽死，魏国也不会亡！嗷！嗷！");
talk(17,"你，你们……魏国不会亡！嗷！嗷！");
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
talk(213,"去许昌！在许昌迎击敌军！");
 if GetFlag(90) then
 SetSceneID(0,0);
 DrawMulitStrBox("　造成宛城陷落这样的结果的重要原因，是蜀和吴同时对魏作战．*　由于东吴进攻合淝，魏的兵力被分散．在合淝的张辽等人被牵制住，所以在宛城魏国不能集中充份的战斗力．");
 end
 if GetFlag(89) then
 NextEvent(631); --goto 631
 else
 SetSceneID(0,11);
talk(242,"曹丕皇上危险！在洛阳顶住刘备军！");
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
talk(2,"兄长，失了荆州，本无面目见人，听说兄长在此厮杀，甘冒矢石来与您相见．",
 1,"瞧你说的，我只听到你还活着就足够了，荆州也夺回来了，没什么好惦记的，一起完成伐魏大业吧．",
 2,"啊！多谢兄长．");
 MovePerson(3,2,2);
 MovePerson(3,2,1);
 MovePerson(3,2,3);
 MovePerson( 3,1,1,
 2,0,0);
talk(3,"二哥，今日畅饮一番！来，举杯！",
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
talk(175,"主公，魏国丢掉这个宛城，肯定会惊惶失措．一口气进攻吧．",
 126,"此言极是，但是，现在还是等关中的奇袭队吧，如果不与他们会合，很难战胜魏军精锐．");
 if GetFlag(38) then
talk(1,"赵云他们不会出什么事吧……");
 else
talk(1,"庞统他们不会出什么事吧……");
 end
 --显示任务目标:<谈论今后的话．>
 JY.Status=GAME_SMAP_MANUAL;
 NextEvent();
 end,
 [632]=function()
 if JY.Tid==126 then--诸葛亮
talk(126,"等奇袭队吧．");
 RemindSave();
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 if JY.Tid==175 then--马良
talk(175,"奇袭队早点到达才好．");
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
talk(54,"大概主力部队正顺利进攻洛阳，如果这样下去，将在许昌决战吧．",
 190,"赵将军，我们也别晚了，赶快去与主力部队会合吧．",
 127,"是啊，已完成虚攻的任务，已没有必要待在这里了？",
 54,"可是，不能放着关中、长安魏军不管，否则，主力部队的背后就会遭到袭击．能打击多少就打击多少吧．",
 190,"出击吧．",
 54,"嗯，但是别太浪费时间，与主力部队会合才是最重要的．",
 127,"知道了．");
 DefineWarMap(52,"第四章 陈仓之战","一、郝昭的结局",30,53,242);
 SelectTerm(1,{
 53,3,13,4,0,-1,0,
 189,3,12,4,0,-1,0,
 126,2,10,4,0,-1,0,
 82,4,11,4,0,-1,0,
 64,0,13,4,0,-1,0,
 81,1,12,4,0,-1,0,
 113,1,11,4,0,-1,0,
 116,5,13,4,0,-1,0,
 187,1,9,4,0,-1,0,
 });
 else
talk(133,"大概主力部队正顺利进攻洛阳，如果这样下去，将在许昌决战吧．",
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
 132,2,13,4,0,-1,0,
 53,3,13,4,0,-1,0,
 189,3,12,4,0,-1,0,
 126,2,10,4,0,-1,0,
 82,4,11,4,0,-1,0,
 64,0,13,4,0,-1,0,
 81,1,12,4,0,-1,0,
 113,1,11,4,0,-1,0,
 116,5,13,4,0,-1,0,
 187,1,9,4,0,-1,0,
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
 242,30,9,3,2,54,20,0,0,-1,0,
 243,16,10,3,4,50,9,20,12,-1,0,
 235,14,10,3,0,49,17,0,0,-1,0,
 234,15,9,3,0,48,17,0,0,-1,0,
 236,15,12,3,0,48,17,0,0,-1,0,
 332,14,11,3,0,45,14,0,0,-1,0,
 256,5,3,3,0,45,3,0,0,-1,0,
 257,17,4,3,0,44,3,0,0,-1,0,
 258,4,1,3,0,45,3,0,0,-1,0,
 259,13,5,3,0,45,3,0,0,-1,0,
 260,14,3,3,0,44,3,0,0,-1,0,
 261,24,9,3,2,44,3,0,0,-1,0,
 262,28,9,3,0,44,3,0,0,-1,0,
 292,29,10,3,0,48,9,0,0,-1,0,
 293,20,10,3,0,47,9,0,0,-1,0,
 294,21,9,3,0,48,9,0,0,-1,0,
 295,19,5,3,0,47,9,0,0,-1,0,
 296,20,8,3,0,47,9,0,0,-1,0,
 297,29,8,3,0,46,9,0,0,-1,0,
 274,5,1,3,0,45,6,0,0,-1,0,
 275,10,3,3,0,46,6,0,0,-1,0,
 276,18,4,3,0,46,6,0,0,-1,0,
 277,24,6,3,2,47,21,0,0,-1,0,
 278,24,12,3,2,47,21,0,0,-1,0,
 279,25,9,3,2,47,21,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [634]=function()
 PlayBGM(11);
talk(243,"蜀军终于攻来了，但是别想从陈仓这里过去，有种的过来一战！");
 if GetFlag(38) then
talk(54,"陈仓乃咽喉要地，别浪费时间！火速攻下！");
 else
talk(133,"陈仓乃咽喉要地，别浪费时间！火速攻下！");
 end
talk(244,"魏军乃逆贼．我是不是助纣为虐了．");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [635]=function()
 if WarMeet(127,243) then
 WarAction(1,127,243);
talk(127,"来将可是敌方统帅．来得正好，单挑！",
 243,"可恶……！让你们打到这里，只有决一胜负！");
 WarAction(6,127,243);
 if fight(127,243)==1 or true then
talk(127,"不愧是统帅！好厉害！",
 243,"嘿……！");
 WarAction(4,127,243);
talk(127,"哈、哈……",
 243,"看招！",
 127,"啊！不好！");
 WarAction(8,243,127);
talk(127,"哇啊！……，……，……？我还活着吗？",
 243,"啊！心，心脏……在这种……地方……犯老病……．",
 127,"怎么回事？");
 WarAction(19,243);
talk(243,"不好……．因病……倒下……．",
 127,"好险啊！");
 WarAction(18,243);
 WarLvUp(GetWarID(127));
 PlayBGM(7);
 DrawMulitStrBox("　刘备军奇袭队击毙郝昭，*　占领陈仓．");
 NextEvent();
 else
 WarAction(4,243,127);
talk(127,"太厉害了！");
 WarAction(17,127);
 WarLvUp(GetWarID(243));
 end
 end
 WarLocationItem(0,14,61,115); --获得道具:获得道具：六韬
 WarLocationItem(3,18,17,116); --获得道具:获得道具：弓术指南书
 WarLocationItem(6,26,62,117); --获得道具:获得道具：三略
 if (not GetFlag(94)) and WarMeet(-1,244) then
 PlayBGM(11);
talk(244,"不能再待在魏军了！我姜维现在加入蜀军！");
 ModifyForce(244,1);
 PlayWavE(11);
 DrawStrBoxCenter("姜维加入我方！");
 PlayBGM(9);
 SetFlag(94,1);
 end
 if (not GetFlag(114)) and WarMeet(190,236) then
 PlayBGM(11);
talk(190,"你们可是羌族人？为何跟着魏军，阻挡我军前进！",
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
talk(190,"你们可是羌族人？为何跟着魏军，阻挡我军前进！",
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
talk(190,"你们可是羌族人？为何跟着魏军，阻挡我军前进！",
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
talk(54,"不行，要赶不上决战了！全军，加速前进！");
 else
talk(133,"不行，要赶不上决战了！全军，加速前进！");
 end
 SetFlag(93,1);
 SetFlag(1076,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(642); --goto 642
 end
 if JY.Status==GAME_WARLOSE then
 PlayBGM(11);
 if GetFlag(38) then
talk(54,"可恶！这样赶不上决战了！");
 else
talk(133,"可恶！这样赶不上决战了！");
 end
 SetFlag(93,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(642); --goto 642
 end
 if JY.Status==GAME_WARWIN then
talk(243,"可恶．挡不住刘备军，我与阵地共存亡．");
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
talk(54,"好，快进攻长安！");
 else
talk(133,"好，快进攻长安！");
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
 -1,1,9,4,0,-1,0,
 -1,2,8,4,0,-1,0,
 -1,4,8,4,0,-1,0,
 -1,4,10,4,0,-1,0,
 -1,2,6,4,0,-1,0,
 -1,0,7,4,0,-1,0,
 -1,3,12,4,0,-1,0,
 -1,0,11,4,0,-1,0,
 -1,2,10,4,0,-1,0,
 -1,1,13,4,0,-1,0,
 -1,3,5,4,0,-1,0,
 -1,1,5,4,0,-1,0,
 -1,1,6,4,0,-1,0,
 -1,0,9,4,0,-1,0,
 });
 ModifyForce(112,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 241,30,8,3,2,57,20,0,0,-1,0,
 102,18,3,3,2,55,22,20,12,-1,0,
 111,18,14,3,2,52,16,0,0,-1,0,
 100,28,8,3,2,53,21,0,0,-1,0,
 19,9,8,3,2,53,25,0,0,-1,0,
 214,9,9,3,2,53,25,0,0,-1,0,--dos兵种设定为3
 215,18,13,3,2,54,9,0,0,-1,0,--庞德
 17,26,8,3,2,55,22,0,0,901,0,--夏侯渊
 256,27,6,3,2,49,3,0,0,-1,0,
 257,30,11,3,2,47,3,0,0,-1,0,
 258,25,8,3,2,48,3,0,0,-1,0,
 259,9,7,3,2,48,3,0,0,-1,0,
 260,9,10,3,2,48,3,0,0,-1,0,
 261,14,4,3,2,48,3,0,0,-1,0,
 274,28,9,3,2,48,6,0,0,-1,0,
 275,19,3,3,2,47,6,0,0,-1,0,
 
 276,19,13,3,2,49,6,0,0,-1,0,
 277,15,5,3,2,48,6,0,0,-1,0,
 292,11,7,3,0,50,9,0,0,-1,0,
 293,20,5,3,2,50,9,0,0,-1,0,
 294,20,11,3,2,49,9,0,0,-1,0,
 295,12,7,3,0,50,9,0,0,-1,0,
 332,16,13,3,2,50,14,0,0,-1,0,
 348,11,8,3,0,49,19,0,0,-1,0,
 278,12,12,3,4,47,6,10,10,-1,0,
 336,23,7,3,2,48,15,0,0,-1,0,
 337,23,9,3,2,47,15,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [638]=function()
 PlayBGM(11);
talk(242,"在这里箝制住蜀军！不能让蜀军再为所欲为了．");
 if GetFlag(38) then
talk(54,"越过长安，马上就到洛阳了．大家再加把劲！");
 else
talk(133,"越过长安，马上就到洛阳了．大家再加把劲！");
 end
talk(112,"当初玄德公的实力何其渺小，现在如此壮大……我的眼光果然没错．");
 WarShowTarget(true);
 PlayBGM(17);
 NextEvent();
 end,
 [639]=function()
 WarLocationItem(2,26,49,119); --获得道具:获得道具：援军书
 if (not GetFlag(217)) and WarCheckArea(-1,2,10,13,14) then
talk(242,"已经打进城里了！各军要迎击敌军！！不惜一切要阻止敌军去许昌与主力会合！");
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
talk(112,"且慢，不要打！我乃徐庶，现在回归蜀军．");
 ModifyForce(112,1);
 PlayWavE(11);
 DrawStrBoxCenter("徐庶加入我方！");
 PlayBGM(17);
 SetFlag(95,1);
 end
 if WarMeet(54,103) then
 WarAction(1,54,103);
talk(54,"那边可是张颌！",
 103,"赵云吗？久违了，有何事指教？来劝降？别开这种玩笑．",
 54,"张颌，乾脆投降吧！魏国亡定了．",
 103,"别逗了，我自弃袁绍效力曹公，绝不会再投降了．",
 54,"那就打吧！");
 WarAction(6,54,103);
 if fight(54,103)==1 then
talk(54,"看招！");
 WarAction(8,54,103);
talk(103,"啊！不愧……是……赵云，我不行了！");
 WarAction(17,103);
talk(54,"……张颌，真乃义士．");
 WarLvUp(GetWarID(54));
 else
 WarAction(4,103,54);
talk(54,"太厉害了！");
 WarAction(17,54);
 WarLvUp(GetWarID(103));
 end
 end
 if (not GetFlag(1077)) and War.Turn==60 then
 PlayBGM(11);
 if GetFlag(38) then
talk(54,"不好，赶不上决战了！全军，加速前进！");
 else
talk(133,"不好，赶不上决战了！全军，加速前进！");
 end
 SetFlag(93,1);
 SetFlag(1077,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(642); --goto 642
 end
 if JY.Status==GAME_WARLOSE then
 PlayBGM(11);
 if GetFlag(38) then
talk(54,"糟了！这样要赶不上决战了．");
 else
talk(133,"糟了！这样要赶不上决战了．");
 end
 SetFlag(93,1);
 JY.Status=GAME_SMAP_AUTO;
 NextEvent(642); --goto 642
 end
 if JY.Status==GAME_WARWIN then
talk(242,"蜀军太厉害了……！啊！");
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
talk(54,"好，马上进军洛阳！");
 else
talk(133,"好，马上进军洛阳！");
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
talk(175,"奇袭队还没任何消息，大概被魏军绊住了．",
 126,"如果再等奇袭队来，只会给敌人时间加固设防．",
 1,"正是，很遗憾，但也别无他法．他们不久就会赶到，曹丕在许昌，我们先发兵许昌．");
 else
talk(175,"主公，刚接到报告，奇袭队已达到洛阳．",
 126,"好样的，马上与奇袭队合兵一处，一口气直攻许昌．",
 1,"好！全军准备出征，直指许昌！");
 end
 else
talk(175,"主公，关中的魏军已移动到洛阳．",
 126,"敌人要在洛阳防守．",
 1,"已经打到这里，没有可犹豫的，进军洛阳！");
 end
 if GetFlag(58) then
talk(2,"现在正是雪荆州之耻的时候．",
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
talk(133,"终于要与魏决战了，请进行出征准备．");
 end
 if JY.Tid==2 then--关羽
talk(2,"兄长，终于要与魏决战了．我等兄弟的梦想，就要实现了．");
 end
 if JY.Tid==3 then--张飞
talk(3,"大哥，派我吧！没多久，我们的梦想就实现了．");
 end
 if JY.Tid==54 then--赵云
talk(54,"完成伐魏大业吧．");
 end
 if JY.Tid==190 then--马超
talk(190,"想早日报杀父之仇．");
 end
 if JY.Tid==170 then--黄忠
talk(170,"我也想为主公拼了我这把老骨头．");
 end
 if JY.Tid==127 then--魏延
talk(127,"快点出征吧！");
 end
 if JY.Tid==175 then--马良
talk(175,"终于要与魏国决战了．");
 end
 if JY.Tid==126 then--诸葛亮
 if talkYesNo( 126,"准备好了吗？") then
 RemindSave();
 WarIni();
 if GetFlag(89) then
 if GetFlag(93) then
talk(126,"请分派部队．");
 DefineWarMap(50,"第四章 许昌I之战","一、司马懿的撤退",40,0,213);
 SelectTerm(1,{
 0,12,21,3,0,-1,0,
 125,11,21,3,0,-1,0,
 -1,8,23,3,0,-1,0,
 -1,10,20,3,0,-1,0,
 -1,10,23,3,0,-1,0,
 -1,11,19,3,0,-1,0,
 -1,11,22,3,0,-1,0,
 -1,12,23,3,0,-1,0,
 -1,13,22,3,0,-1,0,
 -1,14,21,3,0,-1,0,
 132,1,3,4,0,-1,1,
 53,2,2,4,0,-1,1,
 189,2,4,4,0,-1,1,
 126,0,2,4,0,-1,1,
 243,0,4,4,0,-1,1,
 111,0,3,4,0,-1,1,
 });
 DrawSMap();
 JY.Smap={};
 SetSceneID(0,3);
talk(126,"进兵许昌吧！");
 NextEvent(647); --goto 647
 JY.Status=GAME_WMAP;
 else
talk(126,"顺路去洛阳与奇袭队会合，在那里重新编排部队吧．");
 JY.Smap={};
 SetSceneID(0,3);
talk(1,"奇袭队众将士，辛苦了．想必大家很疲劳，但还得一口气进攻许昌！",
 126,"进兵许昌吧！");
 NextEvent(652); --goto 652
 JY.Status=GAME_SMAP_AUTO;
 end
 else
talk(126,"请分派部队．");
 DefineWarMap(54,"第四章 洛阳之战","一、曹真的结局",40,0,241);
 SelectTerm(1,{
 0,29,8,3,0,-1,0,
 125,29,7,3,0,-1,0,
 -1,27,7,3,0,-1,0,
 -1,27,10,3,0,-1,0,
 -1,28,9,3,0,-1,0,
 -1,28,11,3,0,-1,0,
 -1,29,11,3,0,-1,0,
 -1,30,6,3,0,-1,0,
 -1,30,10,3,0,-1,0,
 -1,31,9,3,0,-1,0,
 });
 ModifyForce(112,9);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 241,1,3,4,2,60,20,0,0,-1,0,
 102,5,7,1,2,57,22,20,12,-1,0,
 111,4,16,4,5,54,16,0,0,-1,0,
 100,9,5,4,2,54,21,0,0,-1,0,
 19,19,19,4,2,56,25,0,0,-1,0,
 214,6,7,1,2,55,25,0,0,-1,0,--dos兵种设定为3
 215,21,17,4,1,56,9,0,0,-1,0,--庞德
 17,16,17,4,0,58,22,0,0,901,0,--夏侯渊
 256,2,3,4,0,56,3,0,0,-1,0,
 257,1,4,4,0,55,3,0,0,-1,0,
 258,11,5,4,2,53,3,0,0,-1,0,
 295,16,19,4,0,53,9,0,0,-1,0,
 296,14,18,4,0,52,9,0,0,-1,0,
 297,15,16,4,0,54,9,0,0,-1,0,
 292,20,16,4,1,54,9,0,0,-1,0,
 
 293,21,16,4,1,53,9,0,0,-1,0,
 294,22,17,4,1,42,9,0,0,-1,0,
 274,11,4,4,2,54,6,0,0,-1,0,
 336,14,6,4,0,50,15,0,0,-1,0,
 337,15,6,4,0,48,15,0,0,-1,0,
 338,16,3,4,0,48,15,0,0,-1,0,
 339,16,5,4,0,47,15,0,0,-1,0,
 275,11,6,4,0,54,6,0,0,-1,0,
 276,3,8,4,0,52,21,0,0,-1,0,
 277,8,8,3,2,52,21,0,0,-1,0,
 278,3,7,4,2,52,21,0,0,-1,0,
 298,5,14,4,0,53,9,0,0,-1,0,
 299,7,14,4,0,53,9,0,0,-1,0,
 });
 DrawSMap();
 JY.Smap={};
 SetSceneID(0,3);
talk(126,"去洛阳吧．");
 NextEvent();
 JY.Status=GAME_WMAP;
 end
 end
 end
 end,
 [644]=function()
 PlayBGM(11);
talk(242,"此战关系到魏国的命运，决不能输！",
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
talk(112,"且慢，不要打！我乃徐庶，现在回归蜀军．");
 ModifyForce(112,1);
 PlayWavE(11);
 DrawStrBoxCenter("徐庶加入我方！");
 PlayBGM(17);
 SetFlag(95,1);
 end
 if WarMeet(3,103) then
 WarAction(1,3,103);
talk(3,"那边可是张颌！",
 103,"张飞吗，久违了，有何指教？来劝降吗？别开这样的玩笑．",
 3,"张颌，乾脆投降吧，魏国亡定了．",
 103,"别逗了，我自弃袁绍效力曹公，绝不会再投降了．",
 3,"既然如此，只有打了！");
 WarAction(6,3,103);
 if fight(3,103)==1 then
talk(3,"看招！");
 WarAction(8,3,103);
talk(103,"啊！不愧……是……张飞，我不行了！");
 WarAction(17,103);
talk(3,"……真乃义士，令人敬佩．");
 WarLvUp(GetWarID(3));
 else
 WarAction(4,103,3);
talk(3,"太厉害了！");
 WarAction(17,3);
 WarLvUp(GetWarID(103));
 end
 end
 if JY.Status==GAME_WARWIN then
talk(242,"刘备军如此强大……哎呀！");
 PlayBGM(7);
 DrawMulitStrBox("　刘备军击毙曹真，占领洛阳．");
 GetMoney(1600);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１６００！");
talk(126,"主公，乘势一鼓作气进攻许昌吧！",
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
 0,12,21,3,0,-1,0,
 125,11,21,3,0,-1,0,
 -1,8,23,3,0,-1,0,
 -1,10,20,3,0,-1,0,
 -1,10,23,3,0,-1,0,
 -1,11,19,3,0,-1,0,
 -1,11,22,3,0,-1,0,
 -1,12,23,3,0,-1,0,
 -1,13,22,3,0,-1,0,
 -1,14,21,3,0,-1,0,
 });
 DrawSMap();
talk(1,"全军，进兵许昌．");
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
 213,21,2,1,2,61,16,0,0,-1,0,
 239,20,3,1,2,58,16,20,12,-1,0,
 240,22,3,1,2,58,16,0,0,-1,0,
 211,20,13,3,0,57,22,0,0,-1,0,
 238,20,12,3,0,56,13,0,0,-1,0,
 67,15,17,3,4,58,9,11,12,-1,0,
 93,16,16,3,4,57,16,12,12,-1,0,
 79,4,13,1,0,58,25,0,0,-1,0,
 217,3,15,1,0,57,9,0,0,-1,0,
 115,2,13,1,0,53,3,0,0,-1,0,
 78,21,14,3,0,57,9,0,0,-1,0,--徐晃
 170,20,15,3,0,57,9,0,0,-1,0,--牛金
 102,21,8,1,0,57,22,0,0,-1,0,--张郃
 19,17,11,3,4,57,25,11,9,-1,0,--曹洪
 215,23,8,1,0,57,9,0,0,-1,0,--庞德
 17,19,6,1,0,59,22,0,0,901,0,--夏侯渊
 16,18,7,1,0,60,9,0,0,904,0,--夏侯惇
 18,22,7,1,2,60,25,0,0,903,0,--曹仁
 256,5,16,1,2,55,3,0,0,-1,0,
 257,14,16,3,4,53,3,11,11,-1,0,
 258,18,13,3,4,53,3,13,10,-1,0,
 297,19,11,3,0,54,9,0,0,-1,0,
 298,21,6,1,0,54,9,0,0,-1,0,
 292,19,14,3,0,54,9,0,0,-1,0,
 293,19,4,1,0,55,9,0,0,-1,0,
 294,22,4,1,0,54,9,0,0,-1,0,
 274,5,15,1,2,53,21,0,0,-1,0,
 275,17,15,3,4,54,6,13,11,-1,0,
 295,18,12,3,0,54,9,0,0,-1,0,
 296,20,7,1,0,54,9,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [648]=function()
 PlayBGM(11);
talk(214,"蜀军，别那么得意，我司马懿想让你们尝尝魏军的厉害．",
 126,"主公，敌军统帅司马懿是个对手，不能大意．请多留神．");
 WarShowTarget(true);
 PlayBGM(9);
 NextEvent();
 end,
 [649]=function()
 if WarMeet(30,68) then
 WarAction(1,30,68);
talk(30,"我乃关羽之子关兴！有谁敢与我单挑？",
 68,"哦，关羽的儿子吗？如此，打起来也带劲．好吧！我许褚与你单挑．",
 30,"成全你了！来吧！");
 WarAction(6,30,68);
 if fight(30,68)==1 then
talk(30,"嘿，是许褚！有点真本事！",
 68,"哈哈哈！我许褚还不老，不会轻易败阵！来吧！");
 WarAction(6,30,68);
 WarAction(6,30,68);
 WarAction(6,30,68);
talk(30,"嘿嘿嘿……！这刀如何！");
 WarAction(9,30,68);
talk(68,"喂，且住！哈哈，还是年轻人体力足……我得撤了．",
 30,"想逃跑！留下首级！",
 68,"关兴，以后再见！");
 WarAction(16,68);
 WarLvUp(GetWarID(30));
 else
 WarAction(6,30,68);
 WarAction(6,30,68);
 WarAction(6,30,68);
talk(68,"嘿嘿嘿……！这刀如何！");
 WarAction(8,68,30);
talk(30,"太厉害了！");
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
talk(190,"马上赶去！还来得及参战！",
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
talk(214,"蜀军好厉害呀！全军先退回城里！在城内消灭敌军！");
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
talk(126,"大概魏军要据守城池，怎么办？",
 1,"嗯，一口气攻下这？孔明，那边是？",
 126,"哦，主公，好像奇袭队赶到了．",
 1,"如此甚好，全军突击许昌！");
 else
talk(126,"大概魏军要据守城池，怎么办？",
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
talk(170,"主公，请一定带我去．让您看看我这把老骨头，还能上战场厮杀．",
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
talk(126,"请调兵遣将．");
 ModifyForce(170,0);
 ModifyForce(203,0);
 WarIni();
 DefineWarMap(51,"第四章 许昌II之战","一、我军部队到达内城城门．",40,0,213);
 SelectTerm(1,{
 0,24,18,3,0,-1,0,
 125,24,17,3,0,-1,0,
 -1,2,17,4,0,-1,0,
 -1,21,19,3,0,-1,0,
 -1,2,19,4,0,-1,0,
 -1,22,18,3,0,-1,0,
 -1,3,18,4,0,-1,0,
 -1,23,19,3,0,-1,0,
 -1,4,19,4,0,-1,0,
 -1,25,17,3,0,-1,0,
 -1,5,18,4,0,-1,0,
 -1,26,18,3,0,-1,0,
 -1,5,19,4,0,-1,0,
 169,8,0,4,0,-1,1,
 202,8,1,4,0,-1,1,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 213,13,2,1,4,65,16,13,1,-1,0,
 212,13,1,1,4,62,9,8,0,-1,0,
 239,12,2,1,4,61,16,12,1,-1,0,
 240,14,2,1,4,61,16,14,1,-1,0,
 211,13,13,1,0,60,22,0,0,-1,0,
 238,13,14,1,0,60,13,0,0,-1,0,
 67,20,7,1,2,62,9,0,0,-1,0,
 93,27,7,1,2,61,16,0,0,-1,0,
 79,6,7,1,2,62,25,0,0,-1,0,
 217,0,4,1,0,61,9,0,0,-1,0,
 115,7,11,1,2,61,3,0,0,-1,0,
 78,21,6,4,1,62,9,0,0,-1,0,--徐晃
 170,20,5,4,1,61,9,0,0,-1,0,--牛金
 102,7,7,3,1,62,22,0,0,-1,0,--张郃
 215,6,6,3,1,61,9,0,0,-1,0,--庞德
 17,14,15,4,0,62,22,0,0,901,0,--夏侯渊
 16,12,15,3,0,63,9,0,0,904,0,--夏侯惇
 18,26,7,1,0,63,25,0,0,903,0,--曹仁
 19,1,4,1,0,62,25,0,0,-1,0,--曹洪
 256,1,3,1,0,57,3,0,0,-1,0,
 257,20,12,1,2,57,3,0,0,-1,0,
 258,26,6,1,2,56,3,0,0,-1,0,
 292,11,16,3,0,59,9,0,0,-1,0,
 293,15,16,4,0,59,9,0,0,-1,0,
 274,4,13,1,0,57,21,0,0,-1,0,
 275,6,8,1,0,57,21,0,0,-1,0,
 276,9,14,1,0,56,21,0,0,-1,0,
 277,9,15,1,0,56,21,0,0,-1,0,
 278,17,14,1,0,55,21,0,0,-1,0,
 279,17,15,1,0,55,21,0,0,-1,0,
 280,20,8,1,0,55,21,0,0,-1,0,
 281,22,13,1,0,57,21,0,0,-1,0,
 282,24,8,1,0,56,21,0,0,-1,0,
 283,12,7,4,0,55,6,0,0,-1,1,
 284,13,6,1,0,55,6,0,0,-1,1,
 285,14,7,3,0,52,6,0,0,-1,1,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [653]=function()
 PlayBGM(11);
talk(213,"刘备之流，与朕作对！朕身为大魏皇帝，这种态度，绝不容许！",
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
talk(2,"文远，又见面了．",
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
talk(80,"可是，让我稍微平静一下心绪．现在不想打了．",
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
talk(213,"刘备，我会报此仇的！");
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
talk(1,"什么？城门没开？嗯，如何是好……");
 PlayBGM(12);
 WarShowArmy(169);
 WarShowArmy(202);
talk(203,"黄忠老将军，很容易就混进城了．",
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
talk(203,"太好了，城门打开了！",
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
talk(285,"快射敌将！");
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
talk(170,"啊，没想……到！有……伏兵！",
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
talk(170,"啊！再……再不能…………领兵讨贼了…………");
 WarAction(18,170);
 SetFlag(1080,1);
 end
 if JY.Death==203 then
talk(203,"这点伤……啊！…………");
 WarAction(18,203);
 SetFlag(1080,1);
 end
 if JY.Status==GAME_WARWIN then
talk(214,"啊！蜀军如此厉害……向邺城撤退！");
 PlayBGM(7);
 DrawMulitStrBox("　司马懿撤退了，刘备军占领许昌．");
 GetMoney(1600);
 PlayWavE(11);
 DrawStrBoxCenter("得到黄金１６００！");
 if GetFlag(1080) then
talk(126,"主公，我们胜利了！",
 1,"嗯！黄忠！黄忠怎么样了？严颜呢？",
 126,"还活着，不过……",
 1,"什么！黄忠在哪？马上去看黄忠！");
 PlayBGM(4);
 DrawMulitStrBox("　刘备等人，收起了占领许昌的欣喜，立刻赶到黄忠和严颜的身边探视．*　黄忠和严颜，由于遭突袭而受重伤，危在旦夕．*　没有生还的希望了……");
talk(1,"黄忠！严颜！许昌攻下来了，多亏你二人之力！",
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
talk(126,"主公，我们胜利了！",
 1,"嗯！黄忠！黄忠怎么样了？严颜呢？",
 126,"虽然伤势比较重，但是还活着……",
 1,"什么！黄忠在哪？马上去看黄忠！");
 PlayBGM(4);
 DrawMulitStrBox("　刘备等人，收起了占领许昌的欣喜，立刻赶到黄忠和严颜的身边探视．*　黄忠和严颜，由于遭突袭而受重伤……");
talk(1,"黄忠！严颜！许昌攻下来了，多亏你二人之力！",
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
talk(213,"在邺城决战！全军向邺城集结！绝不把魏国交给刘备之流！");
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
talk(175,"主公，向您报告．曹丕在邺城集结了全部兵力，大概要与我军决战．",
 1,"嗯，这一时刻终于来了．");
 MovePerson(127,2,3);
 MovePerson(127,2,1);
 MovePerson(127,2,2);
talk(127,"既然这样，已经什么都不想了，只等厮杀！");
 MovePerson(190,3,3);
 MovePerson(190,2,0);
 MovePerson(190,2,2);
talk(190,"是的！重振汉王朝的威严．");
 MovePerson(54,3,3);
 MovePerson(54,3,1);
 MovePerson(54,2,2);
talk(54,"复兴汉室！平息战乱！");
 if GetFlag(135) then
 MovePerson(3,4,3);
 MovePerson(3,2,0);
 MovePerson(3,3,2);
talk(3,"大哥，我们多年来的梦想就要实现了．");
 end
 if GetFlag(58) then
 MovePerson(2,4,3);
 MovePerson(2,2,1);
 MovePerson(2,3,2);
talk(2,"正如三弟所说，兄长，我等三人的梦想就要成真了．");
 end
 if not GetFlag(38) then
 MovePerson(133,1,3);
 MovePerson(133,0,2);
talk(133,"主公，请快下令出征吧！");
 end
 MovePerson(126,1,3);
 MovePerson(126,0,2);
talk(126,"主公，现在众将士气高涨，正是出击的绝好机会．",
 1,"嗯……往事不堪回首，一路苦难．我从平黄巾之乱起拯救乱世，与关、张二弟联手，那时至今已历多年．现在，终于到了结束这乱世的时候了．好不容易实现夙愿．",
 126,"主公，还不能松懈，为复兴汉室，还有最后的大事．",
 1,"嗯……好！全体将士，开始准备出征．");
 DrawMulitStrBox("噢！");
talk(175,"主公，再加把劲，讨伐曹丕，复兴汉室．");
 MovePerson(175,10,3);
 DecPerson(175);
talk(127,"多谢您能用我这样新来乍到的人，以后也请您多提携．");
 MovePerson(127,12,3);
 DecPerson(127);
talk(190,"杀了曹丕，报亡父之仇，也为万民报仇．愿将其首级祭于亡父灵前．下命令吧！");
 MovePerson(190,12,3);
 DecPerson(190);
talk(54,"吾与主公患难相随，今后也将荣辱与共．这最后一战，愿冒死当先．");
 MovePerson(54,12,3);
 DecPerson(54);
 if GetFlag(135) then
talk(3,"大哥，关键时刻到了．怎么身子有些发颤！",
 1,"怎么了？还怕吗？",
 3,"瞧您说的！我这是精神抖擞，让我出征！");
 MovePerson(3,14,3);
 DecPerson(3);
 end
 if GetFlag(58) then
talk(2,"兄长，我等夙愿就要实现了．",
 1,"是啊！说实话，当时听说二弟你败走荆州时，我以为你以不在了……现在真好！",
 2,"兄长说哪儿话，我等不是发誓宁愿同死吗？俺关羽绝不背弃誓言．兄长，我先准备准备．");
 MovePerson(2,14,3);
 DecPerson(2);
 end
 if not GetFlag(38) then
talk(133,"主公，我也准备去了．",
 1,"庞统，若没有你，有不会迎来今日，多谢了．",
 133,"哪里哪里，实不敢当．我也蒙受主公知遇之恩，欣喜异常．好吧，我先去准备出征．");
 MovePerson(133,16,3);
 DecPerson(133);
 end
talk(1,"太好了．我也该准备……？");
 if GetFlag(1080) then
 AddPerson(170,20,16,2);
 AddPerson(203,22,15,2);
 else
 AddPerson(170,36,24,2);
 AddPerson(203,38,23,2);
 MovePerson( 170,8,2,
 203,8,2);
 end
talk(170,"主公，就在此一战了．",
 203,"我们随时接应．",
 1,"黄忠！严颜！");
 if GetFlag(1080) then
 DecPerson(170);
 DecPerson(203);
talk(126,"……？主公，怎么了？",
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
talk(126,"请调兵派将．");
 WarIni();
 DefineWarMap(55,"第四章 邺I之战","一、曹丕的结局",40,0,212);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm(1,{
 0,19,23,2,0,-1,0,
 125,20,23,2,0,-1,0,
 -1,14,23,2,0,-1,0,
 -1,16,23,2,0,-1,0,
 -1,17,22,2,0,-1,0,
 -1,18,22,2,0,-1,0,
 -1,18,23,2,0,-1,0,
 -1,19,21,2,0,-1,0,
 -1,20,22,2,0,-1,0,
 -1,21,21,2,0,-1,0,
 -1,21,22,2,0,-1,0,
 -1,22,22,2,0,-1,0,
 -1,22,23,2,0,-1,0,
 -1,23,23,2,0,-1,0,
 -1,25,23,2,0,-1,0,
 });
 DrawSMap();
talk(126,"向邺城进军！");
 JY.Smap={};
 SetSceneID(0,3);
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 212,18,0,1,2,65,9,0,0,-1,0,
 211,17,1,1,0,62,22,0,0,-1,0,
 238,17,0,1,2,61,16,0,0,-1,0,
 67,13,6,3,1,62,9,0,0,-1,0,
 93,17,7,1,0,61,16,0,0,-1,0,
 79,18,7,1,0,62,25,0,0,218,0,
 217,22,6,4,1,61,9,0,0,-1,0,
 115,31,15,3,1,61,3,0,0,-1,0,
 19,17,5,1,2,61,25,0,0,-1,0,--曹洪
 214,18,5,1,2,61,20,0,0,-1,0,
 78,9,6,3,1,62,9,0,0,-1,0,--徐晃
 170,10,7,3,1,61,9,0,0,-1,0,--牛金
 102,26,6,4,1,62,22,0,0,-1,0,--张郃
 215,25,7,4,1,61,9,0,0,-1,0,--庞德
 17,13,4,4,4,62,22,14,17,901,0,--夏侯渊
 16,21,4,3,4,64,9,24,17,904,0,--夏侯惇
 18,18,2,1,1,63,25,0,0,903,0,--曹仁
 278,14,8,1,0,55,6,0,0,-1,0,
 256,5,15,4,1,58,3,0,0,-1,0,
 257,29,15,3,1,57,3,0,0,-1,0,
 258,7,15,4,1,58,3,0,0,-1,0,
 
 259,16,8,1,0,57,3,0,0,-1,0,
 260,19,8,1,0,57,3,0,0,-1,0,
 279,21,8,1,0,55,6,0,0,-1,0,
 274,13,3,1,0,55,21,0,0,-1,0,
 275,12,4,1,0,55,21,0,0,-1,0,
 276,22,4,1,0,55,21,0,0,-1,0,
 277,21,3,1,0,55,21,0,0,-1,0,
 213,18,0,1,2,65,16,0,0,-1,1,
 292,7,6,3,1,58,9,0,0,-1,0,
 293,8,7,3,1,58,9,0,0,-1,0,
 294,9,8,3,1,57,9,0,0,-1,0,
 295,10,9,3,1,57,9,0,0,-1,0,
 296,28,6,4,1,58,9,0,0,-1,0,
 297,27,7,4,1,58,9,0,0,-1,0,
 298,26,8,4,1,57,9,0,0,-1,0,
 299,25,9,4,1,57,9,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end,
 [659]=function()
 PlayBGM(11);
talk(213,"你们这些东西，侵犯朕的领土．这个国家是父亲传给我的，比什么都重要，不能交给任何人．",
 126,"曹丕已来到城外决战了，奋勇进攻吧！");
 WarShowTarget(true);
 PlayBGM(16);
 NextEvent();
 end,
 [660]=function()
 if WarMeet(44,212) then
 WarAction(1,44,212);
talk(44,"来将可是曹彰？喂，那个黄毛小子！速来与我决战！",
 212,"呸，少废话，我曹彰可不是吃素的！");
 WarAction(6,44,212);
 if fight(44,212)==1 then
talk(212,"真是对手，看我一戟？");
 WarAction(4,212,44);
talk(44,"哦，这……",
 212,"招家伙！");
 WarAction(9,212,44);
talk(44,"好险！",
 212,"好小子！躲过去了！",
 44,"该我的了．");
 WarAction(8,44,212);
talk(212,"哎呀！可惜……");
 WarAction(18,212);
talk(44,"刺中了！干掉这小子！");
 WarLvUp(GetWarID(44));
 else
talk(212,"真是对手，看我一戟？");
 WarAction(4,212,44);
talk(44,"哦，这……",
 212,"招家伙！");
 WarAction(8,212,44);
talk(44,"哎呀！可惜……");
 WarAction(17,44);
 WarLvUp(GetWarID(212));
 end
 end
 if WarMeet(30,239) then
 WarAction(1,30,239);
talk(30,"曹氏兄弟也亲自出征了，好吧，看我宰了你！曹植，小心了！",
 239,"啊……既然如此，不战也不行了．");
 WarAction(6,30,239);
 if fight(30,239)==1 then
talk(30,"我乃关羽之子关兴，曹植，你死定了！",
 239,"打就打吧！");
 WarAction(8,30,239);
talk(239,"啊！");
 WarAction(18,239);
talk(30,"曹植，宰你的是我关兴！");
 WarLvUp(GetWarID(30));
 else
 WarAction(4,239,30);
talk(30,"啊！");
 WarAction(17,30);
 WarLvUp(GetWarID(239));
 end
 end
 WarLocationItem(2,9,49,124); --获得道具:获得道具：援军书
 WarLocationItem(2,26,60,125); --获得道具:获得道具：霸王之剑
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
talk(213,"哎呀！你们要干什么？朕可是大魏皇帝！",
 1,"杀了你，拯救乱世！准备受死吧！",
 213,"朕知道，可是朕还不想死！我投降！这总可以吧？",
 1,"这也是曹操的儿子吗？可悲，可叹……");
 PlayBGM(11);
 WarShowArmy(213);
talk(213,"哦，司马懿！你去哪里了？来，快杀了这群家伙！",
 214,"是，如您所望，杀给你看……",
 213,"嗯？司、司马懿！你疯了吗？敌人在对面！为何以剑指朕？",
 1,"怎么？发生了什么事？",
 214,"你这不成器的家伙，玷污了曹操主公一世盛名！我替他老人家惩罚你！",
 213,"喂！司马懿！住手！哇啊！！");
 WarAction(8,214,213);
 --WarAction(18,213);
 DrawStrBoxCenter("司马懿手刃了曹丕！");
talk(214,"刘备！曹丕虽死，但魏国不会灭亡，我将继承曹操主公的意志！我在城内等你！");
 WarAction(16,214);
 PlayBGM(3);
talk(1,"究竟怎么回事？",
 126,"不知道．能说的就是，大战还没结束．进攻城内吧！");
 JY.Status=GAME_WMAP2;
 NextEvent();
 end
 end,
 [661]=function()
 WarIni2();
 DefineWarMap(56,"第四章 邺II之战","一、司马懿的结局",40,0,213);
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm2(1,{
 0,14,19,2,0,-1,0,
 125,15,19,2,0,-1,0,
 -1,6,20,2,0,-1,0,
 -1,22,20,2,0,-1,0,
 -1,5,19,2,0,-1,0,
 -1,23,20,2,0,-1,0,
 -1,13,18,2,0,-1,0,
 -1,4,18,2,0,-1,0,
 -1,24,19,2,0,-1,0,
 -1,16,18,2,0,-1,0,
 -1,4,20,2,0,-1,0,
 -1,25,18,2,0,-1,0,
 -1,17,18,2,0,-1,0,
 -1,3,18,2,0,-1,0,
 -1,25,20,2,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 213,14,5,1,2,67,16,0,0,-1,0,
 239,10,6,1,0,64,16,0,0,-1,0,
 240,17,6,1,0,64,16,0,0,-1,0,
 67,15,5,1,0,64,9,0,0,-1,0,
 93,25,13,1,2,63,16,0,0,-1,0,
 79,13,11,1,2,64,25,0,0,218,0,
 217,13,13,1,0,63,9,0,0,-1,0,
 115,14,13,1,0,63,3,0,0,-1,0,
 18,14,7,1,0,65,25,0,0,903,0,--曹仁
 19,13,7,1,0,63,25,0,0,-1,0,--曹洪
 214,15,7,1,0,63,20,0,0,-1,0,--曹休
 78,5,6,3,1,64,9,0,0,-1,0,--徐晃
 170,6,7,3,1,63,9,0,0,-1,0,--牛金
 102,26,12,1,1,64,22,0,0,-1,0,--张郃
 215,25,11,1,1,63,9,0,0,-1,0,--庞德
 17,14,9,1,1,65,22,0,0,901,0,--夏侯渊
 16,15,9,1,1,66,9,0,0,904,0,--夏侯惇
 256,12,10,1,0,60,3,0,0,-1,0,
 257,14,11,1,2,59,3,0,0,-1,0,
 292,6,10,3,0,62,9,0,0,-1,0,
 293,4,11,3,0,62,9,0,0,-1,0,
 294,4,12,3,2,60,9,0,0,-1,0,
 295,25,14,3,2,60,9,0,0,-1,0,
 296,19,7,4,0,59,9,0,0,-1,0,
 297,23,7,3,0,60,9,0,0,-1,0,
 274,12,13,1,2,58,6,0,0,-1,0,
 275,14,12,1,0,58,6,0,0,-1,0,
 276,18,9,4,0,58,21,0,0,-1,0,
 277,5,11,3,2,58,6,0,0,-1,0,
 278,5,13,3,0,58,6,0,0,-1,0,
 279,13,10,1,2,58,21,0,0,-1,0,
 280,14,10,1,0,58,21,0,0,-1,0,
 281,22,11,4,0,58,6,0,0,-1,0,
 282,7,8,3,2,58,6,0,0,-1,0,
 
 8,14,2,1,2,77,9,0,0,-1,1,
 
 258,18,5,4,0,60,3,0,0,-1,0,
 259,18,6,4,0,59,3,0,0,-1,0,
 298,9,5,3,0,60,9,0,0,-1,0,
 299,9,6,3,0,59,9,0,0,-1,0,
 });
 War.Turn=1;
 NextEvent();
 end,
 [662]=function()
 PlayBGM(11);
talk(214,"哈哈！如此魏国不会灭亡了！蜀军，来受死吧！");
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
talk(1,"哦，怎么？在自家城里放火！",
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
talk(1,"可恶！怎么连退路都没有！",
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
talk(126,"主公，危险！请赶快吧！");
 PlayWavE(51);
 WarFireWater(0,11,1);
 PlayBGM(9);
 SetFlag(1081,1)
 end
 if (not GetFlag(1082)) and War.Turn==16 then
 PlayBGM(11);
talk(126,"主公，请赶快！");
 PlayWavE(51);
 WarFireWater(23,13,1);
 PlayBGM(9);
 SetFlag(1082,1)
 end
 if (not GetFlag(1083)) and War.Turn==20 then
 PlayBGM(11);
talk(126,"主公，赶快！");
 PlayWavE(51);
 WarFireWater(11,10,1);
 WarFireWater(6,5,1);
 PlayBGM(9);
 SetFlag(1083,1)
 end
 if (not GetFlag(1084)) and War.Turn==24 then
 PlayBGM(11);
talk(126,"主公，请赶快！城墙已不坚固了，危险！");
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
talk(214,"时候到了．刘备，再见了．和邺城一起毁灭吧．",
 126,"主公，城崩塌了．",
 1,"什么！啊！");
 DrawMulitStrBox("　邺城被烧毁．*　刘备军中了司马懿的火计，全军覆没．");
 SetFlag(1085,1)
 JY.Status=GAME_START;
 NextEvent(999); --goto ???
 end
 if JY.Status==GAME_WARWIN then
 PlayBGM(7);
talk(214,"可恶……即使竭我之力，也无法遏制蜀军……",
 1,"司马懿，等死吧！",
 214,"呀！");
 PlayBGM(11);
 DrawMulitStrBox("　司马懿再坚持一下．");
talk(1,"嗯？什么声音？",
 214,"此声……呀，但是，绝不……");
 DrawMulitStrBox("　司马懿还要坚持．只要有我在……");
 PlayBGM(10);
 WarShowArmy(8);
talk(9,"司马懿，还没结束！",
 214,"哦，曹操主公！",
 1,"什么！是曹操！为何曹操……",
 9,"刘备，你把魏国折腾得够苦，也就到此为止了．我正在此等着你，你运气还可以．但是，打到我这里……哈哈哈！");
 WarMoveTo(9,10,0);
 WarAction(16,9);
 PlayBGM(3);
talk(214,"曹操主公，请稍等！",
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
 -- id,x,y,d,ai,?,伏兵 --1,2,3,4 下 上 左 右
 SelectTerm2(1,{
 0,24,21,2,0,-1,0,
 125,25,21,2,0,-1,0,
 -1,13,23,2,0,-1,0,
 -1,8,23,2,0,-1,0,
 -1,23,22,2,0,-1,0,
 -1,9,21,2,0,-1,0,
 -1,14,23,2,0,-1,0,
 -1,25,23,2,0,-1,0,
 -1,10,22,2,0,-1,0,
 -1,22,21,2,0,-1,0,
 -1,26,22,2,0,-1,0,
 -1,12,22,2,0,-1,0,
 -1,11,22,2,0,-1,0,
 -1,12,23,2,0,-1,0,
 -1,15,22,2,0,-1,0,
 });
 SelectEnemy({
 -- id,x,y d,ai,lv,bz t_x,t_y,event,hide
 --1 4 7 10 13 14 15 16 17 18 19 20 21 22
 --步兵 弓兵 骑兵 贼兵 乐队 猛兽 武术家 妖术师 异族 民众 输送 战车 投石车 突骑兵
 8,19,1,1,2,77,9,0,0,-1,0,
 213,19,3,1,2,70,16,0,0,-1,0,
 239,18,3,1,2,65,16,0,0,-1,0,
 240,20,3,1,2,65,16,0,0,-1,0,
 68,30,8,1,0,64,16,0,0,-1,0,
 76,35,14,1,0,64,16,0,0,-1,0,
 67,31,9,1,2,65,25,0,0,-1,0,
 93,34,16,1,2,64,16,0,0,-1,0,
 79,10,9,4,2,65,25,0,0,218,0,
 217,4,8,1,0,63,9,0,0,-1,0,
 115,23,16,3,0,63,3,0,0,-1,0,
 386,19,2,1,3,72,25,8,0,-1,0,--典韦S
 61,18,1,1,0,67,16,0,0,-1,0,--郭嘉
 77,20,1,1,0,65,16,0,0,-1,0,--程昱
 18,20,12,1,0,66,25,0,0,903,0,--曹仁
 19,21,12,1,0,65,25,0,0,-1,0,--曹洪
 241,17,5,3,0,65,20,0,0,-1,0,--曹真
 214,21,5,4,0,63,20,0,0,-1,0,--曹休
 78,6,6,1,0,65,9,0,0,-1,0,--徐晃
 215,3,9,1,0,64,9,0,0,-1,0,--庞德
 121,3,7,1,0,64,9,0,0,-1,0,--文聘
 101,5,7,1,0,63,9,0,0,-1,0,--张绣
 170,4,6,1,0,63,9,0,0,-1,0,--牛金
 17,18,6,4,0,66,22,0,0,901,0,--夏侯渊
 16,19,5,1,0,67,9,0,0,904,0,--夏侯惇
 209,28,5,4,0,63,21,0,0,-1,0,--夏侯尚
 210,29,6,4,0,64,20,0,0,902,0,--夏侯德
 102,20,6,3,0,65,22,0,0,-1,0,--张郃
 103,30,5,4,0,63,6,0,0,-1,0,--高览
 83,16,2,1,0,64,21,0,0,-1,0,--满宠
 100,22,2,1,0,64,21,0,0,-1,0,--刘晔
 172,31,8,1,0,63,21,0,0,-1,0,--曹纯
 129,3,17,1,2,63,3,0,0,-1,0,--韩浩
 62,27,6,1,2,64,25,0,0,-1,0,--于禁
 274,2,17,1,2,61,21,0,0,-1,0,
 275,11,11,1,2,61,21,0,0,-1,0,
 276,18,17,3,2,60,21,0,0,-1,0,
 277,32,9,3,2,60,21,0,0,-1,0,
 278,35,16,1,2,59,21,0,0,-1,0,
 256,6,16,3,0,61,3,0,0,-1,0,
 257,8,11,4,2,61,3,0,0,-1,0,
 258,23,15,3,0,60,3,0,0,-1,0,
 259,32,5,4,0,60,3,0,0,-1,0,
 260,30,15,4,0,59,3,0,0,-1,0,
 292,6,17,3,0,62,9,0,0,-1,0,
 293,16,11,4,0,62,9,0,0,-1,0,
 294,16,10,4,0,62,9,0,0,-1,0,
 295,35,17,1,2,61,9,0,0,-1,0,
 296,34,17,1,2,61,9,0,0,-1,0,
 297,32,6,4,0,61,9,0,0,-1,0,
 261,17,15,3,2,61,3,0,0,-1,0,
 262,17,16,3,2,60,3,0,0,-1,0,
 298,3,8,3,0,61,9,0,0,-1,0,
 });
 War.Turn=1;
 NextEvent();
 end,
 [665]=function()
 PlayBGM(11);
talk(1,"曹操，没想到吧！你不是就要完了吗！",
 9,"连曹丕、司马懿等人都被骗了，你一定不知道，好吧，我为你解释一下．",
 9,"魏、蜀、吴这三国，关系微妙，势均力敌，互相牵制．如果这种状况持续下去，我无法统一天下．所以，我决定诈死．",
 1,"诈死？",
 9,"正是．如果我死了，料想三国的平衡就打破了．接着，我播下了祸种，先杀了关羽，把责任推给东吴，想让吴蜀相争．");
talk(126,"什么！如此说，吴、蜀相争竟是曹操的圈套．",
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
talk(3,"来将可是许褚．张飞在此，特来送你见阎王，许褚，一决胜负．",
 68,"呸！张飞，过来受死！");
 WarAction(6,3,68);
 if fight(3,68)==1 then
talk(68,"哦，果然有两下子！",
 3,"看不出，你还有两手！呀！");
 WarAction(10,3,68);
talk(68,"难决胜负．张飞，这刀结束你算了．",
 3,"来呀！",
 68,"看招！");
 WarAction(9,68,3);
talk(3,"不过如此！");
 WarAction(4,3,68);
talk(3,"真可惜．",
 68,"杀了我吧．",
 3,"死吧！");
 WarAction(8,3,68);
talk(68,"啊……！");
 WarAction(18,68);
talk(3,"……刚才真惊险．");
 WarLvUp(GetWarID(3));
 else
talk(68,"哦，果然有两下子！",
 3,"看不出，你还有两手！呀！");
 WarAction(10,3,68);
talk(68,"难决胜负．张飞，这刀结束你算了．",
 3,"来呀！",
 68,"看招！");
 WarAction(8,68,3);
talk(3,"啊……！");
 WarAction(17,3);
 WarLvUp(GetWarID(68));
 end
 end

 if JY.Person[80]["君主"]~=1 and GetFlag(218) and WarMeet(2,80) then
 WarAction(1,2,80);
talk(2,"张辽……",
 80,"关羽……",
 2,"张辽，我和你势必一战……",
 80,"什么也别说了．来吧，亮武器吧！",
 2,"……");
 WarAction(6,2,80);
 if fight(2,80)==1 then
talk(80,"关羽！别愣着！好好打！不然，会被我杀了！来吧！");
 WarAction(4,80,2);
talk(80,"哈哈……",
 2,"张辽，死定了！");
 WarAction(8,2,80);
talk(80,"哎呀！！不好！");
 WarAction(19,80);
talk(2,"张辽……",
 80,"别那么伤心．现在，我感觉很清爽，为了我所效忠的君主……而死．士为知己者死，这是我的梦想……没想到现在实现了．",
 2,"可是，我……发生了这样的结果……",
 80,"关羽，如果当年在下邳没有你，也到不了今日．有……礼了，多……谢了！",
 2,"张辽……为什么？注定要如此悲惨的结局！呜！！");
 WarAction(18,80);
 WarLvUp(GetWarID(2));
 else
talk(2,"关羽！别愣着！好好打！不然，会被我杀了！来吧！");
 WarAction(4,80,2);
talk(2,"哈哈……");
 WarAction(17,2);
 WarLvUp(GetWarID(80));
 end
 end
 if WarMeet(54,116) then
 WarAction(1,54,116);
talk(54,"李典！与我决一死战！",
 116,"既然如此，我也无计可施．赵云，放马过来！");
 WarAction(6,54,116);
 if fight(54,116)==1 then
talk(116,"啊！");
 WarAction(8,54,116);
talk(116,"啊，魏国也要亡了……");
 WarAction(18,116);
 WarLvUp(GetWarID(54));
 else
 WarAction(4,116,54);
talk(54,"啊！");
 WarAction(17,54);
 WarLvUp(GetWarID(116));
 end
 end
 if WarMeet(190,218) then
 WarAction(1,190,218);
talk(190,"乐进！在渭水多蒙你”关照”！现在在此，我要报仇雪恨！看招！",
 218,"嘿！");
 WarAction(6,190,218);
 if fight(190,218)==1 then
talk(190,"呀！");
 WarAction(4,190,218);
talk(218,"哇！",
 190,"嘿！");
 WarAction(8,190,218);
talk(218,"啊！");
 WarAction(18,218);
talk(190,"哼！渭水之恨，稍稍得雪！");
 WarLvUp(GetWarID(190));
 else
 WarAction(4,218,190);
talk(190,"哇！");
 WarAction(17,190);
 WarLvUp(GetWarID(218));
 end
 end
 if (not GetFlag(1086)) and War.Turn==4 then
 PlayBGM(11);
talk(9,"我要出征了．");
 PlayWavE(51);
 WarFireWater(0,16,1);
 WarFireWater(0,17,1);
 WarFireWater(0,18,1);
 DrawStrBoxCenter("城内起火了！");
talk(9,"太好了，哈哈哈……刘备，没想到我预先在城中做了手脚．啊，火啊，着得好！用火打断刘备军！");
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
talk(126,"哦，主公，前面路上！",
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
talk(1,"啊！还有火！",
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
talk(9,"刘备，当年，在许昌的花园煮酒论英雄，那时的话还记得吗？当时说到最后，只有两个英雄，就是你我二人……我的眼力还是没有错．",
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
talk(9,"哼！刘、刘备……！你把我的梦想……都搅乱了……！啊！！");
 PlayBGM(7);
 DrawMulitStrBox("　刘备打败了曹操，率军占领了邺城．");
talk(1,"成功了，终于打败曹操！",
 126,"主公，大功告成了．");
 if GetFlag(58) then
talk(2,"大哥，恭喜您了，实现了多年的愿望，真不容易．",
 3,"啊，等太久了．");
 end
talk(54,"去迎接圣上吧！",
 1,"好！高奏凯歌回洛阳！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
 end,
 [667]=function()
 SetSceneID(0,12);
 DrawMulitStrBox("　曹操的梦想破灭了．*　在这里，随着曹操的灭亡……*　结了魏、蜀、吴三国时代．");
 NextEvent();
if JY.Base["游戏模式"]==0 then
RemindSave()
JY.Status=GAME_START;
end
 end,
 [668]=function()
if JY.Base["游戏模式"]==0 then
NextEvent(1)
else
JY.Status=GAME_START;
end
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
 JY.Status=GAME_SMAP_AUTO
if WarDrawStrBoxYesNo("隐藏关 小沛之战*吕布放弃坚守下邳突袭刘备，危在旦夕*能坚守到曹操的援军吗？",M_White,true) then
 RemindSave();
 PlayBGM(12);
talk(2,"列队！");
WarIni();
 DefineWarMap(33,"隐藏关 小沛之战","一、吕布撤退．*二、援军到达．",30,0,5);
 SelectTerm(1,{
 0,23,3,1,0,-1,0,
 1,22,3,1,0,-1,0,
 2,24,3,1,0,-1,0,
 -1,28,22,3,0,-1,0,
 -1,29,21,3,0,-1,0,
 -1,30,20,3,0,-1,0,
 -1,31,19,3,0,-1,0,
 });
 SelectEnemy({
 4,6,5,1,2,6,7,0,0,-1,0,
 79,3,7,1,0,3,23,0,0,-1,0,
 80,6,8,1,0,3,7,0,0,-1,0,
 74,10,8,1,0,3,4,0,0,-1,0,
 73,10,11,1,1,2,1,0,0,-1,0,
 274,8,8,1,0,1,4,0,0,-1,0,
 275,5,11,1,1,1,4,0,0,-1,0,
 });
 JY.Status=GAME_WMAP;
 NextEvent();
 end
 end,
 [701]=function()
 PlayBGM(11);
talk(6,"吃一次亏也不长一智，联军还来自找麻烦，是谁的部队？",
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
 [702]=function()
 if JY.Status==GAME_WARWIN then
talk(217,"倒霉！你们再晚一点来，这个城就成我的了．");
 PlayBGM(7);
 DrawMulitStrBox("刘备军打败了草寇．");
 GetMoney(300);
 PlayWavE(11);
 DrawStrBoxCenter("缴获黄金３００！");
 JY.Status=GAME_SMAP_AUTO;
 NextEvent();
 end
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
 };
