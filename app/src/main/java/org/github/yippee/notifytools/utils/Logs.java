package org.github.yippee.notifytools.utils;

import android.util.Log;

/**
 * Created by sf on 2017/1/6.
 */

public class Logs {
    private String tag;
    private Logs(Class<?> name) {
        tag = name.getSimpleName();

    }
    public static Logs getLogger(Class<?> name) {
        return new Logs(name);
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
         Log.w(tag, msg);
    }

    public void e(Throwable e) {
        getMethodNames(new Throwable().getStackTrace());
        String msg=e.toString();
        msg=createLog(msg);
        Log.e(tag, msg);
    }
    public  void v(String msg) {
        getMethodNames(new Throwable().getStackTrace());
        msg = createLog(msg);
        System.out.println(msg);
        Log.v(tag, msg);
    }
    public  void d(String msg) {
        getMethodNames(new Throwable().getStackTrace());
        msg = createLog(msg);
        System.out.println(msg);
        Log.d(tag, msg);
    }
    public  void d(String arg0, Object... arg1){
        getMethodNames(new Throwable().getStackTrace());
        arg0=createLog(arg0);
        String msg=String.format(arg0,arg1);
        Log.d(tag,msg);
    }
}
