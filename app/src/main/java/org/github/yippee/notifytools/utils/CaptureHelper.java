package org.github.yippee.notifytools.utils;

/**
 * Created by shengfang on 2018/1/10.
 */

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.media.projection.MediaProjection;
import android.media.projection.MediaProjectionManager;


import org.github.yippee.notifytools.MainApp;

import static android.content.Context.MEDIA_PROJECTION_SERVICE;

public class CaptureHelper {
    private static final int CREATE_SCREEN_CAPTURE = 4242;
    static Logs log=Logs.getLogger(CaptureHelper.class);

    private  CaptureHelper() {
        throw new AssertionError("No instances.");
    }

    public  static  void fireScreenCaptureIntent(Activity activity ) {
        MediaProjectionManager manager =
                (MediaProjectionManager) activity.getSystemService(MEDIA_PROJECTION_SERVICE);
        Intent intent = manager.createScreenCaptureIntent();
        activity.startActivityForResult(intent, CREATE_SCREEN_CAPTURE);

    }

    public static  boolean handleActivityResult(Activity activity, int requestCode, int resultCode,
                                         Intent data ) {
        if (requestCode != CREATE_SCREEN_CAPTURE) {
            return false;
        }

        if (resultCode == Activity.RESULT_OK) {
            log.d("Acquired permission to screen capture. Starting service.");
            MainApp.getMediaProjection(resultCode,data);
        } else {
            log.d("Failed to acquire permission to screen capture.");
        }



        return true;
    }
}