package org.github.yippee.china_poem;

import android.app.Application;
import android.content.Context;
import android.os.Environment;
import android.support.multidex.MultiDex;
import android.util.Log;
import org.github.yippee.china_poem.Utils.LogUtils;

/**
 * Created by sf on 2017/8/14.
 */

public class PoemApp extends Application{
  private LogUtils log = LogUtils.getLogger(this.getClass());

  public class CrashHandler implements Thread.UncaughtExceptionHandler {
    private LogUtils log = LogUtils.getLogger(this.getClass());

    @Override
    public void uncaughtException(Thread arg0, Throwable arg1) {
      Log.e(arg0.toString(),arg1.toString());
      log.e(arg1);

      log.d("uncaughtException procname PoemApp");
      android.os.Process.killProcess(android.os.Process.myPid());
      System.exit(3);
    }
  }
  private static Context context = null;

  public static Context getContext(){
    return context;
  }
  @Override
  protected void attachBaseContext(Context base) {
    super.attachBaseContext(base);
    MultiDex.install(this);
  }

  @Override
  public void onCreate() {
    if (!Environment.getExternalStorageState().equals(android.os.Environment.MEDIA_MOUNTED)) {
      Log.e("DpsPlatoApp", "sd not mounted！");
      System.exit(2);
      return;
    }
    if (context != null) {
      Log.d("DpsPlatoApp", "DpsPlatoApp inited");
      return;
    }
    Thread.setDefaultUncaughtExceptionHandler(new CrashHandler());
    context = getApplicationContext();

    super.onCreate();
  }

}
