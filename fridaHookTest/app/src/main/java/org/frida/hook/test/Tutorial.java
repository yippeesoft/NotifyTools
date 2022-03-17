package org.frida.hook.test;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XC_MethodReplacement;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage.LoadPackageParam;

import static de.robv.android.xposed.XposedHelpers.findAndHookMethod;

public class Tutorial implements IXposedHookLoadPackage {
    @Override
    public void handleLoadPackage(final LoadPackageParam lpparam) throws Throwable {
        XposedBridge.log("Loaded app: " + lpparam.packageName);
        if (lpparam.packageName.contains("com.android") && lpparam.packageName.contains("systemui")) {
            XposedBridge.log("we are in settings!");
            XposedHelpers.findAndHookMethod("com.android.systemui.BatteryMeterView", lpparam.classLoader, "setPercentTextAtCurrentLevel", new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                    XposedBridge.log("setPercentTextAtCurrentLevel beforeHookedMethod!");

                }

                @Override
                protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                    XposedBridge.log("setPercentTextAtCurrentLevel afterHookedMethod!");
                }
            });
            XposedHelpers.findAndHookMethod("com.android.systemui.BatteryMeterView", lpparam.classLoader,
                    "setPercentTextAtCurrentLevel", new XC_MethodReplacement() {
                        @Override
                        protected Object replaceHookedMethod(MethodHookParam param) throws Throwable {
                            XposedBridge.log("setPercentTextAtCurrentLevel replaceHookedMethod!");
                            return null;
                        }
                    });
        }


    }
}