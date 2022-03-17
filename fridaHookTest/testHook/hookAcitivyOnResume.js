Java.perform(function () {
    var Activity = Java.use("android.app.Activity");
    Activity.onResume.implementation = function () {
        send("onResume() " + this);
        this.onResume();
    };

    console.log("Inside java perform function");

    var ver = Java.use('android.os.Build') ;
    ver.MODEL.value = 'testtttttttt' ;

    var ver2 = Java.use('android.os.Build$VERSION') ;
    ver2.RELEASE_OR_CODENAME.value = '33333333' ;
    //定位类
//    var my_class = Java.use("org.frida.hook.test.MainActivity"); //org.frida.hook.test.MainActivity
    console.log("Java.Use.Successfully!");//定位类成功！
    //在这里更改类的方法的实现（implementation）
    // my_class.add.implementation = function(x,y){
    //     //打印替换前的参数
    //     console.log( "original call: fun("+ x + ", " + y + ")");
    //     //把参数替换成2和5，依旧调用原函数
    //     var ret_value = this.add(x+100, y+100);
    //     return ret_value;
    // }

//   var WindowManagerDebigConfig
//        = Java.use('com.android.server.wm.WindowManagerDebugConfig');
//    WindowManagerDebigConfig.DEBUG_LAYOUT.value = true;
//    console.log("WindowManagerDebigConfig.DEBUG_LAYOUT: " + WindowManagerDebigConfig.DEBUG_LAYOUT.value);

//    var ActivityStarter = Java.use('com.android.server.wm.ActivityStarter');
//    var startActivityUnchecked = ActivityStarter.startActivityUnchecked;
//    console.log("Hook startActivityUnchecked: " + startActivityUnchecked);
//    startActivityUnchecked.implementation = function (r, sourceRecord, voiceSession, voiceInteractor, startFlags, doResume, options, inTask, outActivity, restrictedBgActivity) {
//        console.log("startActivityUnchecked: options: " + options + ", r: " + r);
//        //调用原方法，注：传参多个this变量
//        var result = startActivityUnchecked.call(this, r, sourceRecord, voiceSession, voiceInteractor, startFlags, doResume, options, inTask, outActivity, restrictedBgActivity);
//        console.log("startActivityUnchecked: result: " + result);
//        return result;
//    }
    //定位类
    var pw_class = Java.use("android.os.PowerManager");
    console.log("android.os.PowerManager Java.Use.Successfully!");//定位类成功！
    //在这里更改类的方法的实现（implementation）
    pw_class.isPowerSaveMode.implementation = function(){
        //打印替换前的参数
        console.log( "isPowerSaveMode call: fun(");

        return true;
    }

    pw_class.reboot.implementation = function(reson){
        //打印替换前的参数
        console.log( "reboot call: fun(")+reson;

        return ;
    }


    var WifiManager = Java.use("android.net.wifi.WifiManager");
    Java.use("android.app.Activity").onCreate.overload("android.os.Bundle").implementation = function(bundle) {
        var wManager = Java.cast(this.getSystemService("wifi"), WifiManager);
        console.log('isWifiEnabled ?', wManager.isWifiEnabled());
        wManager.setWifiEnabled(false);
        this.$init(bundle);
    }
});

//frida -U org.frida.hook.test -l hookAcitivyOnResume.js