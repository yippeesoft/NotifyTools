package org.github.yippee.notifytools;

import android.Manifest;
import android.app.Notification;
import android.app.NotificationManager;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;
import android.support.annotation.NonNull;
import android.support.design.widget.Snackbar;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.NotificationCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.widget.Toast;

//import com.tbruyelle.rxpermissions.Permission;
//import com.tbruyelle.rxpermissions.RxPermissions;

import com.tbruyelle.rxpermissions2.Permission;
import com.tbruyelle.rxpermissions2.RxPermissions;

import org.github.yippee.notifytools.bean.Heweather7bean;
import org.github.yippee.notifytools.utils.CaptureHelper;
import org.github.yippee.notifytools.utils.Logs;
import org.github.yippee.notifytools.view.FloatView;

import java.util.List;

import io.reactivex.functions.Consumer;

import static android.provider.Settings.ACTION_MANAGE_OVERLAY_PERMISSION;


public class MainActivity extends AppCompatActivity {
    private Logs log = Logs.getLogger(this.getClass());
    int REQUEST_READ_CONTACTS = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        log.d("oncreate ");
//        setContentView(R.layout.activity_main);
//        sendTenNotifications();

//        1. 第一次请求权限时，用户拒绝了，下一次：shouldShowRequestPermissionRationale()  返回 true，应该显示一些为什么需要这个权限的说明
//        2.第二次请求权限时，用户拒绝了，并选择了“不在提醒”的选项时：shouldShowRequestPermissionRationale()  返回 false
//        3. 设备的策略禁止当前应用获取这个权限的授权：shouldShowRequestPermissionRationale()  返回 false
        permission();
        requestPermissions();

        CaptureHelper.fireScreenCaptureIntent(this);

        startService(new Intent(this, NotifyService.class));
//        this.finish();
    }
    @Override
    public  void onActivityResult(int requestCode, int resultCode, Intent data) {
        log.d(resultCode+" acquire permission to screen capture."+requestCode);
         MainApp.getCaputeHelper().handleActivityResult(this,requestCode,resultCode,data);
        MainApp.getCaputeHelper().screenShotPrepare();

        if(Build.VERSION.SDK_INT>=23 && canDrawOverlays==false) {
            if (!Settings.canDrawOverlays(this)) {
                log.e( "权限授予失败，无法开启悬浮窗");
            } else {
//                Toast.makeText(this, "权限授予成功！", Toast.LENGTH_SHORT).show();
                log.e( "权限授予成功");
                //有悬浮窗权限开启服务绑定 绑定权限
                MainApp.getFloatView().setLayout();

            }
        }else {

        }



        this.finish();
    }

    boolean canDrawOverlays=false;
    public void permission(){
        if (Build.VERSION.SDK_INT >= 23) {
            if(!Settings.canDrawOverlays(this)) {
                Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                        Uri.parse("package:" + getPackageName()));
                startActivity(intent);
                log.e( "permission1");
                return;
            } else {
                //Android6.0以上
                log.e( "permission2");
                MainApp.getFloatView().setLayout();
                canDrawOverlays=true;
            }
        } else {
            //Android6.0以下，不用动态声明权限
            log.e( "permission3");
            MainApp.getFloatView().setLayout1();
            canDrawOverlays=true;
        }
    }

    void simInfo(){
        //SubscriptionManager  该类主要包含了所有sim卡的信息
//        SubscriptionManager mSubscriptionManager = SubscriptionManager.from(this);
//        int simcnt=mSubscriptionManager.getActiveSubscriptionInfoCount();
//        List<SubscriptionInfo> lstSim=mSubscriptionManager.getActiveSubscriptionInfoList();
//        for(int i=0;i<lstSim.size();i++){
//            SubscriptionInfo si=lstSim.get(i);
//
//            if(si!=null)
//                log.d(si.toString());
//        }
    }

    private boolean requestPermissions() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return true;
        }
        RxPermissions rxp=new RxPermissions(this);
        rxp.requestEach(Manifest.permission.CAMERA,Manifest.permission.READ_CONTACTS,  //requestEach or ensureEach
                        Manifest.permission.READ_PHONE_STATE
                 )
                .subscribe(new Consumer<Permission>() {
                    @Override
                    public void accept(Permission permission) throws Exception {
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


}
