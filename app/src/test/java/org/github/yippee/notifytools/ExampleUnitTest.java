package org.github.yippee.notifytools;

import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;

import org.github.yippee.notifytools.java.WardService;
import org.github.yippee.notifytools.media.BmpUtils;
import org.github.yippee.notifytools.media.MediaMetas;
import org.junit.Test;


import static org.junit.Assert.*;

/**
 * Example local unit test, which will execute on the development machine (host).
 *
 * @see <a href="http://d.android.com/tools/testing">Testing documentation</a>
 */
public class ExampleUnitTest {
    @Test
    public void addition_isCorrect() throws Exception {
        assertEquals(4, 2 + 2);
        new WardService().getWard();

        Thread.sleep(600000);
    }


    @Test
    public void testMediaMeta(){
        Bitmap b= MediaMetas.getVideoBmp("/sdcard/1_smooth.mp4",3*1000*1000, MediaMetadataRetriever.OPTION_CLOSEST);
        BmpUtils.savePic(b,"/sdcard/","111.png");
    }
}