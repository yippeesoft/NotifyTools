package org.github.yippee.notifytools.utils;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.os.Handler;

import org.github.yippee.notifytools.MainApp;

import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Random;

/**
 * Created by sf on 2018/1/12.
 */

public class CalcJump {
    Logs log=Logs.getLogger(CalcJump.class);

    boolean  tolerenceHelper(int r, int g, int b, int rt, int gt, int bt, int t) {

        return (r > rt - t) && (r < rt + t)
                && (g > gt - t) && (g < gt + t)
                && (b > bt - t) && (b < bt + t);

    }

    public void bmp(Bitmap bitmap){
        // 小人的颜色值
        int playerR = 40;
        int playerG = 43;
        int playerB = 86;

        // 获取Bitmap图像大小与类型属性
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
//        Bitmap bitmap=BitmapFactory.decodeFile(png);
        int height = bitmap.getHeight();
        int width = bitmap.getWidth();
//        String imageType = bitmap.get;

        int startY= (height/4);
        int endY=height*3/4;
        int posX=0, posY=0;
        int minX = Integer.MAX_VALUE;

        int maxX = -1;

        int maxY = -1;

        for(int x=0;x<width;x++){
            for(int y=startY;y<endY;y++){
                int pixel = bitmap.getPixel(x, y);// ARGB
                int red = Color.red(pixel); // same as (pixel >> 16) &0xff
                int green = Color.green(pixel); // same as (pixel >> 8) &0xff
                int blue = Color.blue(pixel); // same as (pixel & 0xff)
                int alpha = Color.alpha(pixel); // same as (pixel >>> 24)

                if (y > posY && tolerenceHelper(red, green, blue, playerR, playerG, playerB, 16)) {
                    minX = Math.min(minX, x);
                    maxX = Math.max(maxX, x);
                    maxY = Math.max(maxY, y);
                }
            }
        }
        final int xx1= ((maxX + minX) / 2);
        final int yy1=maxY;
        log.e(xx1+" AAA position  "+yy1);
        handler.post(new Runnable() {
            @Override
            public void run() {
                MainApp.getFloatView().layoutImageView(1,xx1,yy1);
            }
        });
//        imageView.drawC(xx,yy);

        boolean bbak=true;
        if(bbak) {
            startY =  (height / 4);

            endY = (height * 3 / 4);

            int bytes = bitmap.getByteCount();
            ByteBuffer buf = ByteBuffer.allocate(bytes);
            bitmap.copyPixelsToBuffer(buf);
            byte[] data = buf.array();
            // 去除背景色
            int startX = startY * width * 4;

            int r = data[startX];
            int     g = data[startX + 1];
            int      b = data[startX + 2];



            maxY=-1;
            int y = height;
            int x=-1;

            int endX=width;
            int gapcount=0;
            final HashMap<String,Integer> apex=new HashMap<String,Integer>();
            endY=Math.min(endY,yy1);



            for(y=startY;y<endY;y++){
                boolean find=false;
                for(x=1;x<endX;x++){
                    int i = y * (width * 4) + x * 4;
                    int rt = data[i];
                    int gt = data[i + 1];
                    int bt = data[i + 2];
                    // 不是默认背景颜色
                    if (!tolerenceHelper(rt, gt, bt, r, g, b, 30)) {
                        if(apex.size()==0){
                            if (!tolerenceHelper(data[i + 4], data[i + 5], data[i + 6], r, g, b, 30)) {
                                //椭圆形找中心，往后找30个像素点
                                int len = 2;
                                while (len++ != 30) {
                                    i += len * 4;
                                    if (tolerenceHelper(data[i + 4], data[i + 5], data[i + 6], r, g, b, 30)) {
                                        break;
                                    }
                                }
                                x += len;
                            }
                            //找出顶点
                            FillMap(apex ,rt, gt, bt, x, y);
                            posX = x;
                            // 减少循环范围
                            endX = x;
                            break;
                        }else if (tolerenceHelper(rt, gt, bt, apex.get("r"), apex.get("g"), apex.get("b"), 5)) {
                            //存在顶点了，则根据颜色值开始匹配
                            maxY = Math.max(maxY, y);
                            find = true;
                            break;
                        }
                    }
                }
//                if (apex.size() !=  0 && !find) {
//                    gapcount++;
//                }
//                if (gapcount == 3) {
//                    break;
//                }
            }

//            log.e("APEX "+apex.toString());
            final int yy= (maxY + apex.get("y")) / 2;
            final int xx=posX;
            log.e(xx+" BBBposition  "+maxY);
            final int finalMaxY = maxY;
            handler.post(new Runnable() {
                @Override
                public void run() {
                    MainApp.getFloatView().layoutImageView(2,xx, yy);
                }
            });

            double distance =  Math.sqrt(Math.abs((xx1 -xx)
                    * (xx1 -xx)+(yy1 -yy)
                    * (yy1 -yy)));
            log.e("两点间的距离是:" + distance);
            log.e(distance+" adb shell input swipe  "+random()+" "+random()+" "+random()+" "+random()+" "+( (int)(distance* (2.0))));  //1.35
        } //2.0 720P 1.35 1080P

    }

    int random(){
        int max=600;
        int min=100;
        Random random = new Random();

        int s = random.nextInt(max)%(max-min+1) + min;
        return s;
    }
    Handler handler=new Handler();
    void FillMap(HashMap map,int r,int g,int b,int x,int y){
        map.put("r",r);
        map.put("g",g);
        map.put("b",b);
        map.put("x",x);
        map.put("y",y);
    }
}


