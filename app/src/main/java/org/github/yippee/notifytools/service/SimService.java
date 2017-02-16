package org.github.yippee.notifytools.service;

import android.Manifest;
import android.app.IntentService;
import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.AssetFileDescriptor;
import android.database.Cursor;
import android.net.Uri;
import android.os.Environment;
import android.provider.ContactsContract;
import android.support.v4.app.ActivityCompat;
import android.telecom.PhoneAccountHandle;
import android.telecom.TelecomManager;
import android.telephony.SubscriptionInfo;
import android.telephony.SubscriptionManager;
import android.util.Log;

import org.github.yippee.notifytools.R;
import org.github.yippee.notifytools.utils.Logs;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**
 * Created by sf on 2017/1/10.
 */

public class SimService extends IntentService {
    private Logs log = Logs.getLogger(this.getClass());
    NotificationManager noteMng;
    Cursor cursor;
    ArrayList<String> vCard;
    String vfile;
    private static final int NOTIFICATION_FLAG = 1;

    public SimService() {
        super("org.github.yippee.notifytools.service.SimService");
        log.d(this + " is constructed");
    }

    /**
     * Creates an IntentService.  Invoked by your subclass's constructor.
     *
     * @param name Used to name the worker thread, important only for debugging.
     */
    public SimService(String name) {
        super(name);
    }


    @Override
    protected void onHandleIntent(Intent intent) {
        log.d("onHandleIntent");
        //SubscriptionManager  该类主要包含了所有sim卡的信息
        SubscriptionManager mSubscriptionManager = SubscriptionManager.from(this);
        int simcnt = mSubscriptionManager.getActiveSubscriptionInfoCount();
        List<SubscriptionInfo> lstSim = mSubscriptionManager.getActiveSubscriptionInfoList();
        for (int i = 0; i < lstSim.size(); i++) {
            SubscriptionInfo si = lstSim.get(i);
            if (si != null)
                log.d(si.toString());
        }
        TelecomManager telecomManager = (TelecomManager) getSystemService(Context.TELECOM_SERVICE);
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED) {
            List<PhoneAccountHandle> lstPA=telecomManager.getCallCapablePhoneAccounts();
            int accoutSum =lstPA.size();
            for(int i=0;i<accoutSum;i++)
                log.d("accountSum: " + accoutSum +lstPA.get(i) );
        }

    }

//    @Override
//    public int onStartCommand(Intent intent, int flags, int startId) {
//        log.d("onStartCommand");
//        return Service.START_NOT_STICKY;
//    }

    FileOutputStream mFileOutputStream;
    @Override
    public void onCreate() {
        log.d("onCreate");
        super.onCreate();
    }

    @Override
    public void onDestroy() {
        log.d("onDestroy");
        super.onDestroy();
    }
}