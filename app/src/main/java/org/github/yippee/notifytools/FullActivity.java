package org.github.yippee.notifytools;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.media.Image;
import android.net.Uri;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.AttributeSet;
import android.util.Log;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;

import org.github.yippee.notifytools.utils.Logs;
import org.github.yippee.notifytools.view.DrawImageView;
import org.github.yippee.notifytools.view.FloatView;

import java.io.File;
import java.nio.ByteBuffer;
import java.util.HashMap;

public class FullActivity extends Activity {
    private Logs log = Logs.getLogger(this.getClass());
    String png="/sdcard/11.png";
    DrawImageView imageView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);//隐藏标题
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);//设置全屏


        setContentView(R.layout.activity_full);
        imageView=(DrawImageView)findViewById(R.id.imageView);
        imageView.setImageURI(Uri.fromFile(new File(png)));

        bmp();

    }

    boolean  tolerenceHelper(int r, int g, int b, int rt, int gt, int bt, int t) {

        return (r > rt - t) && (r < rt + t)
                && (g > gt - t) && (g < gt + t)
                && (b > bt - t) && (b < bt + t);

    }

    void bmp(){
        // 小人的颜色值
        int playerR = 40;
        int playerG = 43;
        int playerB = 86;

        // 获取Bitmap图像大小与类型属性
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        Bitmap bitmap=BitmapFactory.decodeFile(png);
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
        int xx= ((maxX + minX) / 2);
        int yy=maxY;
        log.e(xx+" ddd position  "+maxY);
        imageView.drawC(xx,yy);

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
            HashMap<String,Integer> apex=new HashMap<String,Integer>();
            endY=Math.min(endY,y);



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
                if (apex.size() !=  0 && !find) {
                    gapcount++;
                }
                if (gapcount == 3) {
                    break;
                }
            }

            log.e("APEX "+apex.toString());
              yy= (maxY + apex.get("y")) / 2;
              xx=posX;
            log.e(xx+" position  "+maxY);
            imageView.drawC(xx,yy);

        }

    }

    void FillMap(HashMap map,int r,int g,int b,int x,int y){
        map.put("r",r);
        map.put("g",g);
        map.put("b",b);
        map.put("x",x);
        map.put("y",y);
    }

}
