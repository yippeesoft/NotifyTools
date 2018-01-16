package org.github.yippee.notifytools.service;

import android.accessibilityservice.AccessibilityServiceInfo;
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
import android.os.Message;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.WindowManager;
import android.view.accessibility.AccessibilityManager;
import android.widget.Toast;

import org.github.yippee.notifytools.MainApp;
import org.github.yippee.notifytools.utils.CaptureHelper;
import org.github.yippee.notifytools.utils.FileUtil;
import org.github.yippee.notifytools.utils.Logs;
import org.github.yippee.notifytools.utils.SysUtils;
import org.github.yippee.notifytools.view.FloatView;

import java.nio.ByteBuffer;
import java.util.List;

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
    private static FloatView floatView;
    public static FloatView getFloatView() {
        return floatView;
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
        if(mAccessibilityManager==null)
         mAccessibilityManager = (AccessibilityManager) getSystemService(ACCESSIBILITY_SERVICE);
        checkEnabledAccessibilityService();
        if(floatView==null)
            floatView=new FloatView(this);
        floatView.Show();
        log.d("onStartCommand end");
        return Service.START_NOT_STICKY;
    }


    // To check if service is enabled
    private boolean isAccessibilitySettingsOn(Context mContext) {
        int accessibilityEnabled = 0;
        final String service = getPackageName() + "/" + JumpService.class.getCanonicalName();
        try {
            accessibilityEnabled = Settings.Secure.getInt(
                    mContext.getApplicationContext().getContentResolver(),
                    android.provider.Settings.Secure.ACCESSIBILITY_ENABLED);
            log.v( "accessibilityEnabled = " + accessibilityEnabled);
        } catch (Settings.SettingNotFoundException e) {
            log.d( "Error finding setting, default accessibility to not found: "
                    + e.getMessage());
        }
        TextUtils.SimpleStringSplitter mStringColonSplitter = new TextUtils.SimpleStringSplitter(':');

        if (accessibilityEnabled == 1) {
            log.v( "***ACCESSIBILITY IS ENABLED*** -----------------");
            String settingValue = Settings.Secure.getString(
                    mContext.getApplicationContext().getContentResolver(),
                    Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES);
            if (settingValue != null) {
                mStringColonSplitter.setString(settingValue);
                while (mStringColonSplitter.hasNext()) {
                    String accessibilityService = mStringColonSplitter.next();

                    log.v( "-------------- > accessibilityService :: " + accessibilityService + " " + service);
                    if (accessibilityService.equalsIgnoreCase(service)) {
                        log.v( "We've found the correct setting - accessibility is switched on!");
                        return true;
                    }
                }
            }
        } else {
            log.v( "***ACCESSIBILITY IS DISABLED***");
        }

        return false;
    }
    //https://stackoverflow.com/questions/5081145/android-how-do-you-check-if-a-particular-accessibilityservice-is-enabled
    private AccessibilityManager mAccessibilityManager;
    private static final String SERVICE_NAME    = "org.github.yippee.notifytools.service/.JumpService";
    private boolean checkEnabledAccessibilityService() {
        if(isAccessibilitySettingsOn(this))
            return true;;
        List<AccessibilityServiceInfo> accessibilityServices =
                mAccessibilityManager.getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_ALL_MASK);
        for (AccessibilityServiceInfo info : accessibilityServices) {
            if (info.getId().equals(SERVICE_NAME)) {
                log.d(info.getId()+" "+info.toString());
                return true;
            }
        }
        Intent intent = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
        return false;
    }
    
    void shot(){
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
