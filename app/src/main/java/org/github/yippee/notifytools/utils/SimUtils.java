package org.github.yippee.notifytools.utils;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.provider.CallLog;
import android.support.v4.app.ActivityCompat;
import android.telecom.PhoneAccount;
import android.telecom.PhoneAccountHandle;
import android.telecom.TelecomManager;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.List;

/**
 * Created by sf on 2017/1/10.
 */

public class SimUtils {
    private static Logs log = Logs.getLogger(SimUtils.class);

    public static int getSimColor(Context context, int id) {
        int highlightColor = 0;
        TelecomManager telecomManager = (TelecomManager) context.getSystemService(Context.TELECOM_SERVICE);
        if (telecomManager != null) {
            if (ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
                // TODO: Consider calling
                //    ActivityCompat#requestPermissions
                // here to request the missing permissions, and then overriding
                //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                //                                          int[] grantResults)
                // to handle the case where the user grants the permission. See the documentation
                // for ActivityCompat#requestPermissions for more details.
                return -1;
            }
            List<PhoneAccountHandle> phoneAccountHandleList = telecomManager.getCallCapablePhoneAccounts();

            PhoneAccount phoneAccount = telecomManager.getPhoneAccount(phoneAccountHandleList.get(id));
            if (phoneAccount != null) {
                highlightColor = phoneAccount.getHighlightColor();
            }
        }
        return highlightColor;
    }
    public static String getLastestSim(Context context, String telNum) {
        String result = "SIM1";
        Cursor cursor = null;
        try {
            if (ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_CALL_LOG) != PackageManager.PERMISSION_GRANTED) {
                // TODO: Consider calling
                //    ActivityCompat#requestPermissions
                // here to request the missing permissions, and then overriding
                //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
                //                                          int[] grantResults)
                // to handle the case where the user grants the permission. See the documentation
                // for ActivityCompat#requestPermissions for more details.
                return "";
            }
            cursor = context.getContentResolver().query(CallLog.Calls.CONTENT_URI, new String[]{CallLog.Calls.NUMBER, CallLog.Calls.PHONE_ACCOUNT_ID},
                    CallLog.Calls.NUMBER + " = ?", new String[]{telNum}, CallLog.Calls.DEFAULT_SORT_ORDER);
            if (cursor != null && cursor.moveToFirst()) {
                int subId = cursor.getInt(cursor.getColumnIndex(CallLog.Calls.PHONE_ACCOUNT_ID));
                log.d("getLastestSim subId:" + subId);
                int slotId = getSlotIdUsingSubId(subId, context);
                log.d( "getLastestSim slotId:" + slotId);
                if(1 == slotId){
                    result = "SIM2";
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(cursor != null){
                cursor.close();
            }
        }
        log.d("getLastestSim result:" + result);

        return result;
    }
    public static int getSlotIdUsingSubId(int subId,Context context) throws InvocationTargetException {
        int  result = 0;
        try {
            Class<?> clz = Class.forName("android.telephony.SubscriptionManager");
            Object subSm;
            Constructor<?> constructor = clz.getDeclaredConstructor(Context.class);
            subSm  = constructor.newInstance(context);
            Method mth = clz.getMethod("getSlotId", int.class);
            result = (int)mth.invoke(subSm, subId);

        } catch (ClassNotFoundException | InstantiationException | IllegalAccessException
                | IllegalArgumentException | NoSuchMethodException | InvocationTargetException e) {
            e.printStackTrace();
        }
        return result;
    }
}
