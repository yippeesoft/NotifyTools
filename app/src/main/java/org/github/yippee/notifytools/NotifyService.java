package org.github.yippee.notifytools;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.support.annotation.Nullable;
import android.widget.RemoteViews;

import org.github.yippee.notifytools.utils.Logs;

/**
 * Created by sf on 2017/1/6.
 */

public class NotifyService extends Service{
    private Logs log = Logs.getLogger(this.getClass());
    NotificationManager noteMng;
    private static final int NOTIFICATION_FLAG = 1;

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        log.d("onStartCommand");
        return Service.START_NOT_STICKY;
    }

    @Override
    public void onCreate() {
        log.d("onCreate");
        super.onCreate();
        noteMng = (NotificationManager)getSystemService(NOTIFICATION_SERVICE);
        Notification myNotify = new Notification();
        myNotify.icon=R.drawable.ic_notify;
        myNotify.tickerText = "TickerText:您有新短消息，请注意查收！";
        myNotify.when = System.currentTimeMillis();
        myNotify.flags = Notification.FLAG_NO_CLEAR;// 不能够自动清除
        RemoteViews rv = new RemoteViews(getPackageName(),
                R.layout.notification);
        myNotify.contentView=rv;
        myNotify.contentView.setProgressBar(R.id.pb, 100,0, false);
        //设置进度条，最大值 为100,当前值为0，最后一个参数为true时显示条纹
        myNotify.contentView.setProgressBar(R.id.pb, 100,50, false);
        noteMng.notify(NOTIFICATION_FLAG, myNotify);
    }

    @Override
    public void onDestroy() {
        log.d("onDestroy");
        super.onDestroy();
    }
}
