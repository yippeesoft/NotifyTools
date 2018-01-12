package org.github.yippee.notifytools.utils;

/**
 * Created by sf on 2018/1/10.
 */

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.PixelFormat;
import android.graphics.Point;
import android.hardware.display.DisplayManager;
import android.hardware.display.VirtualDisplay;
import android.media.Image;
import android.media.ImageReader;
import android.media.projection.MediaProjection;
import android.media.projection.MediaProjectionManager;
import android.os.Build;
import android.os.Handler;
import android.os.HandlerThread;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.WindowManager;



import java.nio.ByteBuffer;

import static android.content.Context.MEDIA_PROJECTION_SERVICE;

public class CaptureHelper {
    private static final int CREATE_SCREEN_CAPTURE = 4242;
    static Logs log=Logs.getLogger(CaptureHelper.class);
    private MediaProjection mediaProjection;
    private VirtualDisplay virtualDisplay;
    private ImageReader imageReader;

    MediaProjectionManager projectionManager;

    Context cxt;
    public   CaptureHelper(Context c) {
         cxt=c;
    }

    public  static  void fireScreenCaptureIntent(Activity activity ) {
        MediaProjectionManager manager =
                (MediaProjectionManager) activity.getSystemService(MEDIA_PROJECTION_SERVICE);
        Intent intent = manager.createScreenCaptureIntent();
        activity.startActivityForResult(intent, CREATE_SCREEN_CAPTURE);

    }


    public   void getMediaProjection(int resultCode,Intent data){
        mediaProjection = ((MediaProjectionManager)cxt. getSystemService(
                Context.MEDIA_PROJECTION_SERVICE)).getMediaProjection(resultCode,
                data);

    }

    public    boolean handleActivityResult(Activity activity, int requestCode, int resultCode,
                                         Intent data ) {
        if (requestCode != CREATE_SCREEN_CAPTURE) {
            return false;
        }

        if (resultCode == Activity.RESULT_OK) {
            log.d("Acquired permission to screen capture. Starting service.");
             getMediaProjection(resultCode,data);
        } else {
            log.d("Failed to acquire permission to screen capture.");
        }



        return true;
    }

    DisplayMetrics metrics;
    int width,height;
    /**
     * 初始化截屏相关设置
     * MediaProjectionManager -> MediaProjection -> VirtualDisplay
     * */
    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    public void screenShotPrepare() {
        initLooper();
//        mediaProjection = MainApp.mediaProjection;
//        SysUtils.hideStatusBar(this);
        if(mediaProjection==null) {
            log.d("screenShotPrepare mediaProjection null ");
            return;
        }
        log.d("screenShotPrepare");
        Display display = ((WindowManager)cxt.getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay();
        metrics = new DisplayMetrics();
        display.getRealMetrics(metrics);
        Point point = new Point();
        display.getRealSize(point);
        width = point.x;
        height = point.y;

        //将屏幕画面放入ImageReader关联的Surface中
        imageReader = ImageReader.newInstance(width, height, PixelFormat.RGBA_8888, 1);
        log.d("screenShotPrepare2 "+imageReader);
//        imageReader.setOnImageAvailableListener(new ImageReader.OnImageAvailableListener() {
//            @Override
//            public void onImageAvailable(ImageReader reader) {
//                log.d("onImageAvailable ");
//            }
//        },null);
        virtualDisplay = mediaProjection.createVirtualDisplay("ScreenShotDemo",
                width, height, metrics.densityDpi,
                DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
                imageReader.getSurface(),
                null, null/*Handler*/);
    }
    //很多过程都变成了异步的了，所以这里需要一个子线程的looper
    HandlerThread mThreadHandler;
    Handler mHandler;
    private void initLooper() {
        mThreadHandler = new HandlerThread("CAMERA2");
        mThreadHandler.start();
        mHandler = new Handler(mThreadHandler.getLooper());
    }

    public Bitmap screenShot() {
        log.d("screenShot " + imageReader);
        Image image = imageReader.acquireLatestImage();  //获取缓冲区中的图像，关键代码

        if (image == null)
            return null;
        boolean b = true;
        if (b) {
            int width = image.getWidth();
            int height = image.getHeight();
            final Image.Plane[] planes = image.getPlanes();
            final ByteBuffer buffer = planes[0].getBuffer();
            //每个像素的间距
            int pixelStride = planes[0].getPixelStride();
            //总的间距
            int rowStride = planes[0].getRowStride();
            int rowPadding = rowStride - pixelStride * width;
            Bitmap bitmap = Bitmap.createBitmap(width + rowPadding / pixelStride, height,
                    Bitmap.Config.ARGB_8888);
            bitmap.copyPixelsFromBuffer(buffer);
            bitmap = Bitmap.createBitmap(bitmap, 0, 0, width, height);
            image.close();
            return bitmap;

        }
        return null;
    }
            /**
             * 进行截屏
             * */
    public boolean screenShot1()
    {
        log.d("screenShot "+imageReader);
        Image image = imageReader.acquireLatestImage();  //获取缓冲区中的图像，关键代码

        if(image==null)
            return false;
        boolean b=true;
        if(b){
            int width = image.getWidth();
            int height = image.getHeight();
            final Image.Plane[] planes = image.getPlanes();
            final ByteBuffer buffer = planes[0].getBuffer();
            //每个像素的间距
            int pixelStride = planes[0].getPixelStride();
            //总的间距
            int rowStride = planes[0].getRowStride();
            int rowPadding = rowStride - pixelStride * width;
            Bitmap bitmap = Bitmap.createBitmap(width + rowPadding / pixelStride, height,
                    Bitmap.Config.ARGB_8888);
            bitmap.copyPixelsFromBuffer(buffer);
            bitmap = Bitmap.createBitmap(bitmap, 0, 0, width, height);
            image.close();
            FileUtil.saveImage("/sdcard/11.png",bitmap);
        }else {
            //Image -> Bitmap
            final Image.Plane[] planes = image.getPlanes();
            final ByteBuffer buffer = planes[0].getBuffer();
            int rowStride = planes[0].getRowStride();  //Image中的行宽，大于Bitmap所设的真实行宽
            byte[] oldBuffer = new byte[rowStride * height];
            buffer.get(oldBuffer);
            byte[] newBuffer = new byte[width * 4 * height];

            Bitmap bitmap = Bitmap.createBitmap(metrics, width, height, Bitmap.Config.ARGB_8888);
            for (int i = 0; i < height; ++i) {
                System.arraycopy(oldBuffer, i * rowStride, newBuffer, i * width * 4, width * 4);  //跳过多余的行宽部分，关键代码
            }
            bitmap.copyPixelsFromBuffer(ByteBuffer.wrap(newBuffer));  //用byte数组填充bitmap，关键代码
            image.close();
            FileUtil.saveImage(""+width+"×"+height+"-ScreenShot.png",bitmap);
        }
        return true;//
    }
}