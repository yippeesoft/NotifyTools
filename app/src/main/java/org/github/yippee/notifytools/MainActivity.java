package org.github.yippee.notifytools;

import android.Manifest;
import android.app.Notification;
import android.app.NotificationManager;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.support.annotation.NonNull;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.NotificationCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;

import com.tbruyelle.rxpermissions.Permission;
import com.tbruyelle.rxpermissions.RxPermissions;

import org.github.yippee.notifytools.bean.Heweather7bean;
import org.github.yippee.notifytools.utils.Logs;

import java.util.List;

import rx.functions.Action1;

public class MainActivity extends AppCompatActivity {
    private Logs log = Logs.getLogger(this.getClass());
    int REQUEST_READ_CONTACTS = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        log.d("oncreate ");
        setContentView(R.layout.activity_main);
//        sendTenNotifications();

//        1. 第一次请求权限时，用户拒绝了，下一次：shouldShowRequestPermissionRationale()  返回 true，应该显示一些为什么需要这个权限的说明
//        2.第二次请求权限时，用户拒绝了，并选择了“不在提醒”的选项时：shouldShowRequestPermissionRationale()  返回 false
//        3. 设备的策略禁止当前应用获取这个权限的授权：shouldShowRequestPermissionRationale()  返回 false
        requestPermissions();
        startService(new Intent(this, NotifyService.class));
//        this.finish();
    }

    void simInfo(){
        //SubscriptionManager  该类主要包含了所有sim卡的信息
        SubscriptionManager mSubscriptionManager = SubscriptionManager.from(this);
        int simcnt=mSubscriptionManager.getActiveSubscriptionInfoCount();
        List<SubscriptionInfo> lstSim=mSubscriptionManager.getActiveSubscriptionInfoList();
        for(int i=0;i<lstSim.size();i++){
            SubscriptionInfo si=lstSim.get(i);

            if(si!=null)
                log.d(si.toString());
        }
    }

    private boolean requestPermissions() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return true;
        }
        RxPermissions rxp=new RxPermissions(this);
        rxp.requestEach(Manifest.permission.CAMERA,Manifest.permission.READ_CONTACTS,  //requestEach or ensureEach
                        Manifest.permission.READ_PHONE_STATE)
                .subscribe(new Action1<Permission>() {
                    @Override
                    public void call(Permission permission) {
                        log.d("mayRequestPermissions "+permission.toString());
                    }
                });
//        if (checkSelfPermission(Manifest.permission.READ_CONTACTS) == PackageManager.PERMISSION_GRANTED) {
//            return true;
//        }
//        if (shouldShowRequestPermissionRationale(Manifest.permission.READ_CONTACTS)) {
//            requestPermissions(new String[]{Manifest.permission.READ_CONTACTS}, REQUEST_READ_CONTACTS);
//        } else {
//            requestPermissions(new String[]{Manifest.permission.READ_CONTACTS}, REQUEST_READ_CONTACTS);
//        }
        return false;
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        if (requestCode == REQUEST_READ_CONTACTS) {
            if (grantResults.length == 1 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permission granted , Access contacts here or do whatever you need.
            }
        }
    }

    /**
     * 循环发送十个通知
     */
    private void sendTenNotifications() {
        NotificationManager noteMng = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        log.d("sendTenNotifications：");
        for (int i = 0; i < 2; i++) {
            Notification.Builder builder = new Notification.Builder(this);
            builder.setSmallIcon(R.drawable.ic_notify);
            builder.setTicker("");

            builder.setWhen(System.currentTimeMillis());

            Notification.BigTextStyle inboxStyle =
                    new Notification.BigTextStyle();


            StringBuilder sb = new StringBuilder();
            String s = "";
            for (int j = 0; j < 2; j++) {

                s += String.format("aaaaaaaaaaaaaaaaaaaaaaaa\r\n"
                );

            }
            log.d("DailyForecastBean：" + s);
            inboxStyle.bigText(s);
            inboxStyle.setBigContentTitle("天气");
            inboxStyle.setSummaryText(i + "天天气");
            builder.setStyle(inboxStyle);
            noteMng.notify(i + "", i, builder.build());
            try {
                Thread.sleep(3000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
