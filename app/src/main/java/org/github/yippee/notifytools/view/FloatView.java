package org.github.yippee.notifytools.view;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.net.Uri;
import android.os.Build;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;

import org.github.yippee.notifytools.MainApp;
import org.github.yippee.notifytools.R;
import org.github.yippee.notifytools.utils.CalcJump;
import org.github.yippee.notifytools.utils.Logs;

import java.io.File;

/**
 * Created by sf on 2018/1/12.
 */

public class FloatView {
    Logs log= Logs.getLogger(FloatView.class);
    WindowManager windowManager;
    Context cxt;
    public FloatView(Context cxtt){
        cxt=cxtt;
        windowManager=
                  (WindowManager) cxt.getSystemService(Context.WINDOW_SERVICE);

    }
    public void setLayout(){
        //获取param对象
        paramsBtn= new WindowManager.LayoutParams();

        if (Build.VERSION.SDK_INT >= 23)
            this.paramsBtn.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT;
        else this.paramsBtn.type = WindowManager.LayoutParams.TYPE_TOAST;
        this.paramsBtn.format = PixelFormat.RGBA_8888;
        this.paramsBtn.flags =WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH ;

        this.paramsBtn.gravity = Gravity.LEFT | Gravity.TOP;

        paramsBtn.width = 100;
        paramsBtn.height = 100;
        paramsBtn.x = 300;
        paramsBtn.y = 300;



//        paramsBtn.format = PixelFormat.RGBA_8888;
//        paramsBtn.gravity = Gravity.LEFT | Gravity.TOP;
//        paramsBtn.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL;
        //设置可以显示在状态栏上
//        paramsBtn.flags =  WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE| WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL|
//                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN| WindowManager.LayoutParams.FLAG_LAYOUT_INSET_DECOR|
//                WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH;

//        paramsBtn.type = WindowManager.LayoutParams.TYPE_SYSTEM_OVERLAY;

        button= new Button(cxt);
        button.setText("Jump");
        button.setBackgroundColor(Color.RED);

        windowManager.addView(button, paramsBtn);

        addImageView();

        initEvent();
    }

    public void setLayout1(){
        //获取param对象
        paramsBtn= new WindowManager.LayoutParams(WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_TOAST,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL, PixelFormat.TRANSLUCENT);

        if (Build.VERSION.SDK_INT >= 23)
            this.paramsBtn.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT;
        else
            this.paramsBtn.type = WindowManager.LayoutParams.TYPE_TOAST;

        paramsBtn.format = PixelFormat.RGBA_8888;
        paramsBtn.gravity = Gravity.LEFT | Gravity.TOP;
//        paramsBtn.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL;
        //设置可以显示在状态栏上
//        paramsBtn.flags =  WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE| WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL|
//                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN| WindowManager.LayoutParams.FLAG_LAYOUT_INSET_DECOR|
//                WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH;

        paramsBtn.width = 100;
        paramsBtn.height = 100;
        paramsBtn.x = 300;
        paramsBtn.y = 300;
//        paramsBtn.type = WindowManager.LayoutParams.TYPE_SYSTEM_OVERLAY;

          button = new Button(cxt);
        button.setText("Jump");
        button.setBackgroundColor(Color.RED);
        button.setWidth(100);
        button.setHeight(100);
        windowManager.addView(button, paramsBtn);

        addImageView();

        initEvent();
    }

    public void addImageView(){
        //获取param对象
//        params1= new WindowManager.LayoutParams();
//
//        if (Build.VERSION.SDK_INT >= 23)
//            this.params1.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT;
//        else this.params1.type = WindowManager.LayoutParams.TYPE_TOAST;
        params1= new WindowManager.LayoutParams(WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_TOAST,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL, PixelFormat.TRANSLUCENT);
        if (Build.VERSION.SDK_INT >= 23)
            this.params1.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT;
        else this.params1.type = WindowManager.LayoutParams.TYPE_TOAST;
        this.params1.format = PixelFormat.RGBA_8888;
        params1.gravity = Gravity.LEFT | Gravity.TOP;
//        params.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL | WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE;
        //设置可以显示在状态栏上
//        params1.flags =  WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE| WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL|
//                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN| WindowManager.LayoutParams.FLAG_LAYOUT_INSET_DECOR|
//                WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH;

        params1.width = 20;
        params1.height = 20;
//        params1.type = WindowManager.LayoutParams.TYPE_TOAST;

        params1.x = 0;
        params1.y = 0;

        imageView1 = new ImageView(cxt);
        imageView1.setImageURI(Uri.fromFile(new File("/sdcard/1.png")));
        windowManager.addView(imageView1, params1);

        //获取param对象
        params2= new WindowManager.LayoutParams(WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_TOAST,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL, PixelFormat.TRANSLUCENT);
        if (Build.VERSION.SDK_INT >= 23)
            this.params2.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT;
        else
            this.params2.type = WindowManager.LayoutParams.TYPE_TOAST;
        this.params2.format = PixelFormat.RGBA_8888;
//        params2.type = WindowManager.LayoutParams.TYPE_PHONE;

        params2.gravity = Gravity.LEFT | Gravity.TOP;
//        params.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL | WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE;
        //设置可以显示在状态栏上
//        params2.flags =  WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE| WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL|
//                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN| WindowManager.LayoutParams.FLAG_LAYOUT_INSET_DECOR|
//                WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH;

        params2.width = 20;
        params2.height = 20;
//        params2.type = WindowManager.LayoutParams.TYPE_TOAST;
        params2.x = 20;
        params2.y = 20;

        imageView2 = new ImageView(cxt);
        imageView2.setImageURI(Uri.fromFile(new File("/sdcard/2.png")));
        windowManager.addView(imageView2, params2);

        //获取param对象
        params3= new WindowManager.LayoutParams(WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.WRAP_CONTENT,
                WindowManager.LayoutParams.TYPE_TOAST,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL, PixelFormat.TRANSLUCENT);
        this.params3.format = PixelFormat.RGBA_8888;
        if (Build.VERSION.SDK_INT >= 23)
            this.params3.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT;
        else
            this.params3.type = WindowManager.LayoutParams.TYPE_TOAST;
        params3.gravity = Gravity.LEFT | Gravity.TOP;
//        params.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL | WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE;
        //设置可以显示在状态栏上
//        params3.flags =  WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE| WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL|
//                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN| WindowManager.LayoutParams.FLAG_LAYOUT_INSET_DECOR|
//                WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH;

        params3.width = 20;
        params3.height = 20;
//        params3.type = WindowManager.LayoutParams.TYPE_TOAST;
        params3.x = 40;
        params3.y = 40;

        imageView3 = new ImageView(cxt);
        imageView3.setImageURI(Uri.fromFile(new File("/sdcard/3.png")));
        windowManager.addView(imageView3, params3);
    }

    public void layoutImageView(int index,int x,int y){
        switch (index){
            case 1:
                params1.x=x;
                params1.y=y;
                windowManager.updateViewLayout(imageView1,params1);
                break;
            case 2:
                params2.x=x;
                params2.y=y;
                windowManager.updateViewLayout(imageView2,params2);
                break;
            case 3:
                params3.x=x;
                params3.y=y;
                windowManager.updateViewLayout(imageView3,params3);
                break;
            default:
                break;
        }

    }
    Button button;
    private float mTouchStartX;
    private float mTouchStartY;
    private float x;
    private float y;
    private boolean initViewPlace = false;
    private WindowManager.LayoutParams params1, params2,params3,paramsBtn ;

    ImageView imageView1,imageView2,imageView3;
    /**
     * 设置悬浮窗监听事件
     */
    private void initEvent() {
        button.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View view) {

                return true;
            }
        });
        button.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:
                        if (!initViewPlace) {
                            initViewPlace = true;
                            //获取初始位置
                            mTouchStartX += (event.getRawX() - paramsBtn.x);
                            mTouchStartY += (event.getRawY() - paramsBtn.y);
                        } else {
                            //根据上次手指离开的位置与此次点击的位置进行初始位置微调
                            mTouchStartX += (event.getRawX() - x);
                            mTouchStartY += (event.getRawY() - y);
                        }
                        break;
                    case MotionEvent.ACTION_MOVE:
                        // 获取相对屏幕的坐标，以屏幕左上角为原点
                        x = event.getRawX();
                        y = event.getRawY();
                        updateViewPosition();
                        break;

                    case MotionEvent.ACTION_UP:
                        break;
                }
                return false;
            }
        });
        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                log.d("setOnClickListener");
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        Bitmap bmp=MainApp.getCaputeHelper().screenShot();
                        calcJump.bmp(bmp);
                    }
                }).start();

            }
        });
    }
    CalcJump calcJump=new CalcJump();
    /**
     * 更新浮动窗口位置
     */
    private void updateViewPosition() {

        paramsBtn.x = (int) (x - mTouchStartX);
        paramsBtn.y = (int) (y - mTouchStartY);

        windowManager.updateViewLayout(button,paramsBtn  );
    }
}
