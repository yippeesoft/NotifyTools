package org.github.yippee.notifytools.service;

import android.accessibilityservice.AccessibilityService;
import android.annotation.TargetApi;
import android.os.Build;
import android.util.Log;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;

import org.github.yippee.notifytools.utils.Logs;

import java.util.List;

/**
 * Created by sf on 2018/1/16.
 */

public class RobService extends AccessibilityService {
    String TAG="HelpService";
    Logs log=Logs.getLogger(RobService.class);

    private static final String       TEXT_FORCE_STOP = "强行停止";
    private static final String       TEXT_DETERMINE  = "确定";
    private static final CharSequence PACKAGE         = "com.android.settings";
    private static final CharSequence NAME_APP_DETAILS  = "com.android.settings.applications.InstalledAppDetailsTop";
    private static final CharSequence NAME_ALERT_DIALOG = "android.app.AlertDialog";

    private boolean isAppDetail;
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN) @Override public void onAccessibilityEvent(final AccessibilityEvent event) {
        Log.d(TAG,"onAccessibilityEvent "+event.getSource()+event.toString());
        if(null == event || null == event.getSource()) { return; }
        if(event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED &&
                event.getPackageName().equals(PACKAGE)){
            final CharSequence className = event.getClassName();
            Log.d(TAG,"onAccessibilityEvent "+className);
            if(className.equals(NAME_APP_DETAILS)){
                simulationClick(event, TEXT_FORCE_STOP);
                performGlobalAction(GLOBAL_ACTION_BACK);
                isAppDetail = true;
            }
            if(isAppDetail && className.equals(NAME_ALERT_DIALOG)){
                simulationClick(event, TEXT_DETERMINE);
                performGlobalAction(GLOBAL_ACTION_BACK);
                isAppDetail = false;
            }
        }
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN) private void simulationClick(AccessibilityEvent event, String text){
        List<AccessibilityNodeInfo> nodeInfoList = event.getSource().findAccessibilityNodeInfosByText(text);
        Log.d(TAG,"simulationClick "+nodeInfoList.size());
        for (AccessibilityNodeInfo node : nodeInfoList) {

            if (node.isClickable() && node.isEnabled()) {
                node.performAction(AccessibilityNodeInfo.ACTION_CLICK);

            }
        }
    }

    @Override public void onInterrupt() { }
}
