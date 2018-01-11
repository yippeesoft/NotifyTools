package org.github.yippee.notifytools.utils;

import android.content.Context;
import android.os.Build;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

/**
 * Created by shengfang on 2018/1/10.
 */

public class SysUtils {
    /**
     * 收起通知栏
     *
     * @param context
     */
    public static void collapseStatusBar1(Context context) {
        try {
            Object statusBarManager = context.getSystemService("statusbar");
            Method collapse;

            if (Build.VERSION.SDK_INT <= 16) {
                collapse = statusBarManager.getClass().getMethod("collapse");
            } else {
                collapse = statusBarManager.getClass().getMethod("collapsePanels");
            }
            collapse.invoke(statusBarManager);
        } catch (Exception localException) {
            localException.printStackTrace();
        }
    }
    public static void hideStatusBar(Context context) {
        context = context.getApplicationContext();
        Object sbservice = context.getSystemService("statusbar");
        Class<?> statusbarManager = null;
        try {
            statusbarManager = Class.forName("android.app.StatusBarManager");
            Method hidesb;
            if ((Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.JELLY_BEAN_MR1))
                hidesb = statusbarManager.getMethod("collapse");
            else
                hidesb = statusbarManager.getMethod("collapsePanels");
            hidesb.invoke(sbservice);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }
    }
    public static void collapseStatusBar(Context context) {
        try {
            Object service = context.getSystemService("statusbar");
            Class<?> statusBarManager = Class.forName("android.app.StatusBarManager");
            Method contract = statusBarManager.getMethod("contract");
            contract.invoke(service);
        } catch (Exception e) {
        }
    }
}
