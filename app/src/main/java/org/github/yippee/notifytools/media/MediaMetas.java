package org.github.yippee.notifytools.media;

import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.media.ThumbnailUtils;
import android.provider.MediaStore;

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
    /**
     * 获取视频文件缩略图 API>=8(2.2)
     *
     * @param path 视频文件的路径
     * @param kind 缩略图的分辨率：MINI_KIND、MICRO_KIND、FULL_SCREEN_KIND
     * @return Bitmap 返回获取的Bitmap
     */
    public static Bitmap getVideoThumb2(String path, int kind) {
        return ThumbnailUtils.createVideoThumbnail(path, kind);
    }

    public static Bitmap getVideoThumb2(String path) {
        return getVideoThumb2(path, MediaStore.Video.Thumbnails.FULL_SCREEN_KIND);
    }
}
