package org.github.yippee.notifytools;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.Intent;
import android.support.v4.app.NotificationCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import org.github.yippee.notifytools.bean.Heweather7bean;
import org.github.yippee.notifytools.utils.Logs;

import java.util.List;

public class MainActivity extends AppCompatActivity {
    private Logs log = Logs.getLogger(this.getClass());
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        log.d("oncreate ");
        setContentView(R.layout.activity_main);
//        sendTenNotifications();
        startService(new Intent(this, NotifyService.class));
        this.finish();
    }

    /**
     * 循环发送十个通知
     */
    private void sendTenNotifications() {
        NotificationManager noteMng = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        log.d("sendTenNotifications：" );
        for (int i = 0; i < 2; i++) {
            Notification.Builder builder = new Notification.Builder(this);
            builder.setSmallIcon(R.drawable.ic_notify);
            builder.setTicker("");

            builder.setWhen(System.currentTimeMillis() );

            Notification.BigTextStyle inboxStyle =
                    new Notification.BigTextStyle();


            StringBuilder sb=new StringBuilder();
            String s="";
            for(int j=0;j<2;j++){

                s+=String.format("aaaaaaaaaaaaaaaaaaaaaaaa\r\n"
                       );

            }
            log.d("DailyForecastBean：" + s);
            inboxStyle.bigText(s);
            inboxStyle.setBigContentTitle( "天气");
            inboxStyle.setSummaryText( i+"天天气");
            builder.setStyle(inboxStyle);
            noteMng.notify(i+"",i, builder.build());
            try {
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
