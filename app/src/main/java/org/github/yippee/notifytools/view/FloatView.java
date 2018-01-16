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
import java.util.HashMap;

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
    HashMap<View,WindowManager.LayoutParams> map=new HashMap<>();




    public WindowManager.LayoutParams createLayoutParams(int x,int y,int w,int h){
        WindowManager.LayoutParams params = new WindowManager.LayoutParams();

        if (Build.VERSION.SDK_INT >= 23)
            params.type = WindowManager.LayoutParams.TYPE_SYSTEM_ALERT;
        else
            params.type = WindowManager.LayoutParams.TYPE_TOAST;
        params.format = PixelFormat.RGBA_8888;
        params.flags =WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE | WindowManager.LayoutParams.FLAG_WATCH_OUTSIDE_TOUCH ;

        params.gravity = Gravity.LEFT | Gravity.TOP;

        params.width = w;
        params.height = h;
        params.x = x;
        params.y = y;

        return params;

    }

    public void Show(){
        showBtn();
        showImg();
    }

    void initEvents(View v){
        v.setOnClickListener(onClickListener);
        v.setOnLongClickListener(longClickListener);
        v.setOnTouchListener(onTouchListener);
    }
    void showBtn(){
        String strs[]=new String[]{"Calc","Jump"};
        int x=200,y=100,w=100,h=100;
        for(int i=0;i<strs.length;i++) {
            Button button = new Button(cxt);
            button.setText(strs[i]);
            button.setTag(strs[i]);
            button.setBackgroundColor(Color.RED);
            WindowManager.LayoutParams p = createLayoutParams(x*i+50, y, w, h);
            initEvents(button);
            map.put(button, p);
            windowManager.addView(button, p);
        }
    }
    public static String PIECE="piece",BOARD="board";
      static String IMGTAGS[]=new String[]{PIECE ,BOARD};

    void showImg(){
        String strs[]=new String[]{"/sdcard/1.png","/sdcard/2.png"};

        int x=200,y=0,w=20,h=20;
        for(int i=0;i<strs.length;i++) {
            ImageView img = new ImageView(cxt);
            img.setImageURI(Uri.fromFile(new File(strs[i])));
            img.setTag(IMGTAGS[i]);
            initEvents(img);
            WindowManager.LayoutParams p = createLayoutParams(x*i+50, y, w, h);
            map.put(img, p);
            windowManager.addView(img, p);
        }
    }


    public void layoutImageView(String tag,int x,int y){
        for (View key : map.keySet()) {
            if(key instanceof ImageView && key.getTag().toString().equalsIgnoreCase(tag)){
                windowManager.updateViewLayout(key,map.get(key));
            }
        }
    }

//    private float mTouchStartX;
//    private float mTouchStartY;
//    private float x;
//    private float y;
//    private boolean initViewPlace = false;

    public View.OnLongClickListener longClickListener=new View.OnLongClickListener() {
        @Override
        public boolean onLongClick(View v) {
            log.e(" onLongClick "+v.getTag());
            return true;
        }
    };

    public View.OnTouchListener onTouchListener=new View.OnTouchListener() {
        @Override
        public boolean onTouch(View v, MotionEvent event) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
//                    if (!initViewPlace) {
//                        initViewPlace = true;
//                        //获取初始位置
//                        mTouchStartX += (event.getRawX() - map.get(v).x);
//                        mTouchStartY += (event.getRawY() - map.get(v).y);
//                    } else {
//                        //根据上次手指离开的位置与此次点击的位置进行初始位置微调
//                        mTouchStartX += (event.getRawX() - x);
//                        mTouchStartY += (event.getRawY() - y);
//                    }
                    break;
                case MotionEvent.ACTION_MOVE:
                    // 获取相对屏幕的坐标，以屏幕左上角为原点
//                    x = event.getRawX();
//                    y = event.getRawY();
                    map.get(v).x =(int) event.getRawX();//int) (x - mTouchStartX);
                    map.get(v).y = (int)event.getRawY(); //(y - mTouchStartY);

                    windowManager.updateViewLayout(v,map.get(v)  );
                    break;

                case MotionEvent.ACTION_UP:
                    break;
            }
            return false;
        }
    };

    View.OnClickListener onClickListener=new View.OnClickListener() {
        @Override
        public void onClick(final View v) {
            log.d("setOnClickListener");
            new Thread(new Runnable() {
                @Override
                public void run() {
                    if(v instanceof ImageView && v.getTag().toString().equalsIgnoreCase("calc")) {

                        Bitmap bmp = MainApp.getCaputeHelper().screenShot();
                        calcJump.bmp(bmp);
                    }
                }
            }).start();
        }
    };

    CalcJump calcJump=new CalcJump();

}
