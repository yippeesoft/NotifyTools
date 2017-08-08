package org.github.yippee.notifytools.service;

import android.Manifest;
import android.app.IntentService;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.AssetFileDescriptor;
import android.database.Cursor;
import android.net.Uri;
import android.os.Environment;
import android.os.IBinder;
import android.provider.ContactsContract;
import android.support.annotation.Nullable;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.text.format.Time;
import android.util.Log;
import android.widget.RemoteViews;
import android.widget.Toast;

import org.github.yippee.notifytools.MainActivity;
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

/**
 * Created by sf on 2017/1/6.
 */

public class VcardService extends IntentService {
    private Logs log = Logs.getLogger(this.getClass());
    NotificationManager noteMng;
    Cursor cursor;
    ArrayList<String> vCard;
    String vfile;
    private static final int NOTIFICATION_FLAG = 1;

    public VcardService() {
        super("org.github.yippee.notifytools.service.VcardService");
        log.d(this + " is constructed");
    }

    /**
     * Creates an IntentService.  Invoked by your subclass's constructor.
     *
     * @param name Used to name the worker thread, important only for debugging.
     */
    public VcardService(String name) {
        super(name);
    }


    @Override
    protected void onHandleIntent(Intent intent) {
        log.d("onHandleIntent");

        vCard = new ArrayList<String>();
        int nid = 100;
        cursor = getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null, null, null, android.provider.ContactsContract.Contacts.DISPLAY_NAME);
        log.d("Contact " + (cursor.getCount()) + "VcF String is " + vfile);
        int cnt = cursor.getCount();
        Notification.Builder builder = new Notification.Builder(this);
        builder.setSmallIcon(R.drawable.ic_notify);
        builder.setTicker("");
        builder.setWhen(System.currentTimeMillis());
        Notification.BigTextStyle inboxStyle = new Notification.BigTextStyle();
        String s = String.format("准备导出联系人···", cnt);

        log.d("onHandleIntent：" + s);
        inboxStyle.bigText(s);
        inboxStyle.setBigContentTitle("联系人导出");
        inboxStyle.setSummaryText(String.format("%s个联系人···", cnt));
        builder.setStyle(inboxStyle);
        noteMng.notify(nid + "", nid, builder.build());
        if (cursor != null && cursor.getCount() > 0) {
            cursor.moveToFirst();
            for (int i = 0; i < 500; i++) {
                String ss=get(cursor);
                log.d("Contact " + (i + 1) + "VcF String is" + ss);
                s = String.format("导出第%d个联系人：%s", i, ss);
                inboxStyle.bigText(s);
                noteMng.notify(nid + "", nid, builder.build());
                cursor.moveToNext();
            }
        } else {
            log.d("No Contacts in Your Phone");
            s = String.format("No Contacts in Your Phone···", cnt);
        }
        cursor.close();
        cursor = getContentResolver().query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null, null, null, android.provider.ContactsContract.Contacts.DISPLAY_NAME);

        cursor.moveToPosition(500);
        for (int i = 500; i < cursor.getCount(); i++) {
            String ss=get(cursor);
            log.d("Contact " + (i + 1) + "VcF String is" + ss);
            s = String.format("导出第%d个联系人：%s", i, ss);
            inboxStyle.bigText(s);
            noteMng.notify(nid + "", nid, builder.build());
            cursor.moveToNext();
        }
        cursor.close();
        try {
            mFileOutputStream.close();
        } catch (IOException e) {
            log.e(e);
        }
        s = String.format("导出%d联系人完成···",mapVcard.size());
        inboxStyle.bigText(s);
        noteMng.notify(nid + "", nid, builder.build());
    }
    HashMap<String,String> mapVcard=new HashMap<String,String>();

    public String get(Cursor cursor) {
        //cursor.moveToFirst();
        String lookupKey = cursor.getString(cursor.getColumnIndex(ContactsContract.Contacts.LOOKUP_KEY));
        Log.d("Vcard lookupKey ", lookupKey);
        Uri uri = Uri.withAppendedPath(ContactsContract.Contacts.CONTENT_VCARD_URI, lookupKey);
        Log.d("Vcard uri ", uri.toString());
        AssetFileDescriptor fd;
        try {
            fd = this.getContentResolver().openAssetFileDescriptor(uri, "r");

            // Your Complex Code and you used function without loop so how can you get all Contacts Vcard.??


           /* FileInputStream fis = fd.createInputStream();
            byte[] buf = new byte[(int) fd.getDeclaredLength()];
            fis.read(buf);
            String VCard = new String(buf);
            String path = Environment.getExternalStorageDirectory().toString() + File.separator + vfile;
            FileOutputStream out = new FileOutputStream(path);
            out.write(VCard.toString().getBytes());
            Log.d("Vcard",  VCard);*/
            //https://stackoverflow.com/questions/42017591/in-android-7-contentresolvers-method-openassetfiledescriptorvcarduri-r-re
            FileInputStream fis = fd.createInputStream();
            byte[] buf = new byte[fis.available()];
            fis.read(buf);
            String vcardstring = new String(buf);
            if(mapVcard.containsKey(uri.toString())){
                String vv=mapVcard.get(uri.toString());
                if(vv.equals(vcardstring)){
                    Log.d("Vcard lookupKey 重复", lookupKey);
                    return vv;
                }
            }

            mapVcard.put(uri.toString(),vcardstring);
            //log.d("write "+vcardstring);
//            FileOutputStream mFileOutputStream = new FileOutputStream(storage_path, true);
            mFileOutputStream.write(buf);//vcardstring.toString().getBytes());
            return vcardstring;

        } catch (Exception e1) {
            e1.printStackTrace();
            log.e(e1);
        }
        return "";
    }
//
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


        noteMng = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        long currentTime = System.currentTimeMillis();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        Date date = new Date(currentTime);
        vfile = Environment.getExternalStorageDirectory().toString() + File.separator +"Contacts" + formatter.format(date) + ".vcf";
        try {
            mFileOutputStream = new FileOutputStream(vfile);
        } catch (FileNotFoundException e) {
            log.e(e);
        }
    }

    @Override
    public void onDestroy() {
        log.d("onDestroy");
        super.onDestroy();
    }
}
