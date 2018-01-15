package org.github.yippee.notifytools.view;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.ImageView;

/**
 * Created by sf on 2018/1/12.
 */


public class DrawImageView extends ImageView {

    private final Paint paint;
    private final Context context;
    public DrawImageView(Context context, AttributeSet attrs) {
        super(context, attrs);
        // TODO Auto-generated constructor stub
        this.context = context;
        this.paint = new Paint();
        this.paint.setAntiAlias(true); //消除锯齿
        this.paint.setStyle(Paint.Style.STROKE);  //绘制空心圆或 空心矩形
        paint.setStrokeWidth(5);
        paint.setColor(Color.RED);
    }
    int x=-1,y = -1;
    int innerCircle = 10; //内圆半径



    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);



            // 第一种方法绘制圆环
            //绘制内圆
//            this.paint.setARGB(255, 138, 43, 226);
        if(x!=-1) {
//            this.paint.setStrokeWidth(2);
            paint.setColor(color);
            canvas.drawCircle(x, y, innerCircle, this.paint);
        }
//
        //绘制圆环
//        this.paint.setARGB(255, 138, 43, 226);
//        this.paint.setStrokeWidth(ringWidth);
//        canvas.drawCircle(center, center, innerCircle + 1 +ringWidth/2, this.paint);
//
            //绘制外圆
//            this.paint.setARGB(255, 138, 43, 226);
//            this.paint.setStrokeWidth(2);
//            canvas.drawCircle(center, center, innerCircle + ringWidth, this.paint);





    }
    int color;
    public void drawC(int col,int xx,int yy){
        x=xx;
        y=yy;
        color=col;
        this.invalidate();
    }

    /* 根据手机的分辨率从 dp 的单位 转成为 px(像素) */
    public   int dip2px(Context context, float dpValue) {
        final float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dpValue * scale + 0.5f);
    }
}