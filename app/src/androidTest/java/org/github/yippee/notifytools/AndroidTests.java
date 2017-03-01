package org.github.yippee.notifytools ;

import android.content.Context;
import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.support.test.InstrumentationRegistry;
import android.support.test.runner.AndroidJUnit4;


import org.github.yippee.notifytools.media.BmpUtils;
import org.github.yippee.notifytools.media.MediaMetas;
import org.junit.Test;
import org.junit.runner.RunWith;

import static org.junit.Assert.assertEquals;

@RunWith(AndroidJUnit4.class)
public class AndroidTests {

    @Test
    public void testMediaMeta(){
        Bitmap b= MediaMetas.getVideoBmp("/sdcard/1_smooth.mp4",3*1000*1000, MediaMetadataRetriever.OPTION_CLOSEST);
        BmpUtils.savePic(b,"/sdcard/","111.png");
    }
}
