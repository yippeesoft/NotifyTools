package org.github.yippee.china_poem.Utils;

import android.util.Log;

import static com.hankcs.hanlp.utility.Predefine.logger;

/**
 * Created by sf on 2017/8/11.
 */

public class LogUtils {


  String tag;
  private LogUtils log;
  private LogUtils(Class<?> name) {
    tag = name.getSimpleName();

  }

  public static LogUtils getLogger(Class<?> name) {
    return new LogUtils(name);
  }
  static String className;
  static String methodName;
  static int lineNumber;
  private static String createLog( String log ) {
    StringBuffer buffer = new StringBuffer();
    buffer.append("[");
    buffer.append(methodName);
    buffer.append(":");
    buffer.append(lineNumber);
    buffer.append("]");
    buffer.append(log);
    return buffer.toString();
  }
  private static void getMethodNames(StackTraceElement[] sElements){
    className = sElements[1].getFileName();
    methodName = sElements[1].getMethodName();
    lineNumber = sElements[1].getLineNumber();
  }

  public void e(String msg) {
    getMethodNames(new Throwable().getStackTrace());
    msg=createLog(msg);

      Log.e(tag, msg);
  }

  public void i(String msg) {
    getMethodNames(new Throwable().getStackTrace());
    msg=createLog(msg);

      Log.i(tag, msg);
  }

  public void w(String msg) {
    getMethodNames(new Throwable().getStackTrace());
    msg=createLog(msg);
    //logger.warn(msg);
      Log.w(tag, msg);
  }

  public void e(Throwable e) {
    getMethodNames(new Throwable().getStackTrace());
    //logger.error(tag, e);
    e.printStackTrace();;
    Log.d(tag, e.toString());
  }

  public  void d(String msg) {
    getMethodNames(new Throwable().getStackTrace());
    msg = createLog(msg);
    //logger.debug(msg);
    	Log.d(tag, msg);
  }
  public  void d(String arg0, Object... arg1){
    getMethodNames(new Throwable().getStackTrace());
    arg0=createLog(arg0);
    //logger.debug(arg0,arg1);
    Log.d(tag, String.format(arg0,arg1));
  }


}
