package com.classic.clearprocesses;

import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.GestureDescription;
import android.annotation.TargetApi;
import android.graphics.Path;
import android.os.Build;
import android.os.Handler;
import android.os.Message;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;

import java.util.List;

/**
 * 应用名称: ClearProcesses
 * 包 名 称: com.classic.clearprocesses
 *
 * 文件描述: TODO
 * 创 建 人: 续写经典
 * 创建时间: 2016/8/2 11:53
 */
public class HelpService extends AccessibilityService {
    String TAG="HelpService";
    private static final String       TEXT_FORCE_STOP = "强行停止";
    private static final String       TEXT_DETERMINE  = "确定";
    private static final CharSequence PACKAGE         = "com.android.settings";
    private static final CharSequence NAME_APP_DETAILS  = "com.android.settings.applications.InstalledAppDetailsTop";
    private static final CharSequence NAME_ALERT_DIALOG = "android.app.AlertDialog";

    boolean bRun=false;

    Handler handler=new Handler(){
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what){
                case 1:
                    handler.sendEmptyMessageDelayed(1,1000);
                    if(JumpInfo.getInstance().getbSwipe()==true){
                        Swipte(JumpInfo.getInstance().getpStart().x,JumpInfo.getInstance().getpStart().y,
                                JumpInfo.getInstance().getpEnd().x,JumpInfo.getInstance().getpEnd().y,
                                JumpInfo.getInstance().getTime());
                        JumpInfo.getInstance().setbSwipe(false);

                    }
                    break;
            }
        }
    };

    private boolean isAppDetail;
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN) @Override public void onAccessibilityEvent(final AccessibilityEvent event) {
        Log.d(TAG,"onAccessibilityEvent "+event.getSource()+event.toString());
        if(bRun==false){
            handler.sendEmptyMessage(1);
            bRun=true;
        }
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

    public void Swipte(int x1,int y1,int x2,int y2,int time){
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
            Log.e(TAG,"Swipte");

            GestureDescription.Builder gestureBuilder = new GestureDescription.Builder();
            Path path = new Path();
            path.moveTo(x1,y1);
            path.lineTo(x2,y2);
//            if (event.getText() != null && event.getText().toString().contains("1")) {
//                //Swipe left
//                path.moveTo(rightSizeOfScreen, middleYValue);
//                path.lineTo(leftSideOfScreen, middleYValue);
//            } else {
//                //Swipe right
//                path.moveTo(leftSideOfScreen, middleYValue);
//                path.lineTo(rightSizeOfScreen, middleYValue);
//            }

            gestureBuilder.addStroke(new GestureDescription.StrokeDescription(path, 0, time));
            dispatchGesture(gestureBuilder.build(), new GestureResultCallback() {
                @Override
                public void onCompleted(GestureDescription gestureDescription) {

                    super.onCompleted(gestureDescription);
                }
            }, null);
        }

    }

    @Override public void onInterrupt() {
        handler.removeMessages(1);
    }
}
