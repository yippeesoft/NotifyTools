package org.github.yippee.notifytools.view;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;

import org.github.yippee.notifytools.MainApp;
import org.github.yippee.notifytools.utils.CalcJump;
import org.github.yippee.notifytools.utils.Logs;

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
         params=new WindowManager.LayoutParams(WindowManager.LayoutParams.TYPE_TOAST);

        params.type = WindowManager.LayoutParams.TYPE_PHONE;
        params.format = PixelFormat.RGBA_8888;
        params.gravity = Gravity.LEFT | Gravity.TOP;
//        params.flags = WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL | WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE;
        //设置可以显示在状态栏上
        params.flags =  WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE| WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL|
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN| WindowManager.LayoutParams.FLAG_LAYOUT_INSET_DECOR|
                WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH;

        params.width = 100;
        params.height = 100;
        params.x = 300;
        params.y = 300;
        params.type = WindowManager.LayoutParams.TYPE_TOAST;

          button = new Button(cxt);
        button.setText("Jump");
        button.setBackgroundColor(Color.RED);
        button.setWidth(100);
        button.setHeight(100);
        windowManager.addView(button, params);

        initEvent();
    }
    Button button;
    private float mTouchStartX;
    private float mTouchStartY;
    private float x;
    private float y;
    private boolean initViewPlace = false;
    private WindowManager.LayoutParams params  ;
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
                            mTouchStartX += (event.getRawX() - params.x);
                            mTouchStartY += (event.getRawY() - params.y);
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
        params.x = (int) (x - mTouchStartX);
        params.y = (int) (y - mTouchStartY);
        windowManager.updateViewLayout(button, params);
    }
}
