package org.github.yippee.notifytools.media;

import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;

/**
 * Created by sf on 2017/3/1.
 */

public class MediaMetas {

    //MediaMetas.getVideoBmp("/sdcard/1_smooth.mp4",3*1000*1000, MediaMetadataRetriever.OPTION_CLOSEST)
    public static Bitmap getVideoBmp(String mFilePath,long timeUs , int option){
        MediaMetadataRetriever retriever = new MediaMetadataRetriever();
        Bitmap bitmap=null;
        try {
            retriever.setDataSource(mFilePath);
            bitmap = retriever.getFrameAtTime(timeUs);

        } catch (IllegalArgumentException e) {
            e.printStackTrace();

        }
        return bitmap;
    }
}
