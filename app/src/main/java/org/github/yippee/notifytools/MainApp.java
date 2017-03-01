package org.github.yippee.notifytools;

import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Environment;
import android.support.multidex.MultiDex;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;
import android.util.Log;

import org.github.yippee.notifytools.db.DBUtils;
import org.github.yippee.notifytools.utils.Logs;

import java.util.HashMap;

import static android.support.multidex.MultiDex.*;


/**
 * Created by sf on 2016/9/14.
 */
public class MainApp extends Application {
    private Logs log = Logs.getLogger(this.getClass());

    public class CrashHandler implements Thread.UncaughtExceptionHandler {
        private Logs log = Logs.getLogger(this.getClass());

        @Override
        public void uncaughtException(Thread arg0, Throwable arg1) {
            arg1.printStackTrace();
            Log.e("uncaughtException:  " + arg0.toString(), arg1.toString());
            log.e("uncaughtException:  " + arg1);
            android.os.Process.killProcess(android.os.Process.myPid());
            System.exit(3);
        }
    }


    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        install(this);

    }

    @Override
    public void onCreate() {

        log.d("DpsApp onCreate ");
        super.onCreate();
        Thread.setDefaultUncaughtExceptionHandler(new CrashHandler());
        application=this;
        DBUtils.getSingleTon().setDatabase();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        log.d("onConfigurationChanged");
        super.onConfigurationChanged(newConfig);
    }

    @Override
    public void onTerminate() {
        log.d("onTerminate ");
        super.onTerminate();

    }
    private static MainApp application;
    public static MainApp getApplication() {
        return application;
    }

}
