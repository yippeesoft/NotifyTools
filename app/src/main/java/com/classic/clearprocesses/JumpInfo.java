package com.classic.clearprocesses;

import android.graphics.Point;
import android.util.Log;

/**
 * Created by sf on 2018/1/17.
 */

public class JumpInfo {
    private static volatile JumpInfo instance = null;
    private JumpInfo(){}
    public static JumpInfo getInstance() {
        if (instance == null) {
            Log.e("JumpInfo","JumpInfo~~~~");
            instance = new JumpInfo();
        }
        return instance;
    }
    private Point pStart=new Point();

    public Point getpStart() {
        return pStart;
    }

    public void setpStart(Point pStart) {
        this.pStart = pStart;
    }

    public Point getpEnd() {
        return pEnd;
    }

    public void setpEnd(Point pEnd) {
        this.pEnd = pEnd;
    }

    public Boolean getbSwipe() {
        return bSwipe;
    }

    public void setbSwipe(Boolean bSwipe) {
        this.bSwipe = bSwipe;
    }

    private Point pEnd=new Point();
    private   Boolean bSwipe=false;
    private int time;

    public int getTime() {
        return time;
    }

    public void setTime(int time) {
        this.time = time;
    }
}
