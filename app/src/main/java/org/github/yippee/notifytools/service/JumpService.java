package org.github.yippee.notifytools.service;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Service;
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
import android.os.IBinder;
import android.os.Looper;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.WindowManager;
import android.widget.Toast;

import org.github.yippee.notifytools.MainApp;
import org.github.yippee.notifytools.utils.CaptureHelper;
import org.github.yippee.notifytools.utils.FileUtil;
import org.github.yippee.notifytools.utils.Logs;
import org.github.yippee.notifytools.utils.SysUtils;

import java.nio.ByteBuffer;

import static android.graphics.PixelFormat.RGBA_8888;

public class JumpService extends Service {
    private Logs log = Logs.getLogger(this.getClass());

    private MediaProjection mediaProjection;
    private VirtualDisplay virtualDisplay;
    private ImageReader imageReader;

    MediaProjectionManager projectionManager;
    public JumpService() {

    }

    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        log.d("onStartCommand");
        // 获取MediaProjectionManager管理器

//        new Thread(new Runnable() {
//            @Override
//            public void run() {
//                screenShotPrepare();
//            }
//        }).start();

        final Handler handler=new Handler(Looper.getMainLooper());
        new Thread(new Runnable() {
            @Override
            public void run() {
                screenShotPrepare();

                SysUtils.hideStatusBar(JumpService.this);
                handler.post(new Runnable(){
                    public void run(){
                        Toast.makeText(getApplicationContext(),"screenShotPrepare",Toast.LENGTH_LONG).show();
                    }
                });

                try {
                    Thread.sleep(3000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                screenShot();
                handler.post(new Runnable(){
                    public void run(){
                        Toast.makeText(getApplicationContext(),"screenShotEnd",Toast.LENGTH_LONG).show();
                    }
                });
                log.d("screenShotEnd");

            }
        }).start();
        log.d("onStartCommand end");
        return Service.START_NOT_STICKY;
    }


    DisplayMetrics metrics;
    int width,height;
    /**
     * 初始化截屏相关设置
     * MediaProjectionManager -> MediaProjection -> VirtualDisplay
     * */
    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    protected void screenShotPrepare() {
        initLooper();
//        mediaProjection = MainApp.mediaProjection;
//        SysUtils.hideStatusBar(this);
        if(mediaProjection==null) {
            log.d("screenShotPrepare mediaProjection null ");
            return;
        }
        log.d("screenShotPrepare");
        Display display = ((WindowManager) getApplicationContext().getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay();
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
    /**
     * 进行截屏
     * */
    protected boolean screenShot()
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
