package org.github.yippee.notifytools.utils;

import android.os.Environment;

import java.io.File;

/**
 * Created by sf on 2017/3/1.
 */

public class PathUtils {

    public static final String RootPath = "yippee";//
    public static final String AppPath = "notifytool";//

    public static final String FtpPath = "ftp";// ftp路径

    public static final String ExtPath = Environment.getExternalStorageDirectory().getPath();

    public static String getExtPath() {
        return ExtPath;
    }
    public static String getRootPath() {
        String dpsPath = getExtPath() + File.separator + RootPath;
        File file = new File(dpsPath);
        if (file.isFile())
            file.delete();
        if (!file.exists())
            file.mkdirs();
        return dpsPath;
    }
    public static String getRootPath(String name) {
        String dpsPath = getRootPath() + File.separator + name;
        return dpsPath;
    }
    public static String getFtpPath() {
        String ftpPath = getRootPath() + File.separator + FtpPath;
        File file = new File(ftpPath);
        if (file.isFile())
            file.delete();
        if (!file.exists())
            file.mkdirs();
        return ftpPath;
    }

    public static String getFtpPath(String name) {
        String ftpPath = getFtpPath() + File.separator + name;
        return ftpPath;
    }

    public static String getLogPath() {
        String logPath = getRootPath() + File.separator + "log";
        File file = new File(logPath);
        if (file.isFile())
            file.delete();
        if (!file.exists())
            file.mkdirs();
        return logPath;
    }

    public static String getLogPath(String name) {
        String logPath = getLogPath() + File.separator + name;
        return logPath;
    }

    public static String getDbPath() {
        String logPath = getRootPath() + File.separator + "db";
        File file = new File(logPath);
        if (file.isFile())
            file.delete();
        if (!file.exists())
            file.mkdirs();
        return logPath;
    }

    public static String getDbPath(String name) {
        String logPath = getLogPath() + File.separator + name;
        return logPath;
    }
}
