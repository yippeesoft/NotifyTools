package com.ziv.ntptimeservice;

import android.os.SystemClock;

import android.os.Bundle;
import android.util.Log;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class MainActivity  {
    public static final String TAG = "MainActivity";

    private static final String[] DATE_PATTERNS = {
            "EEE, dd MMM yyyy HH:mm:ss Z", // RFC 822, updated by RFC 1123
            "EEEE, dd-MMM-yy HH:mm:ss Z", // RFC 850, obsoleted by RFC 1036
            "EEE MMM d HH:mm:ss yyyy", // ANSI C's asctime() format
            "EEE MMM dd kk:mm:ss z yyyy" // Local Date Time
    };
    private static final TimeZone GMT_ZONE = TimeZone.getTimeZone("GMT");


    protected void onCreate(Bundle savedInstanceState) {


        TimeTask timeTask = new TimeTask();

        ExecutorService threadExecutor = Executors.newSingleThreadExecutor();
        threadExecutor.submit(timeTask);

        Log.d(TAG, "Date parse start.");
        String time = new Date(1578885054910L).toString();
        String lastModify = "Tue, 19 Nov 2019 11:01:23 GMT";
        Log.d(TAG, "Date time: " + time);
        Date date = parseDate(time);
        Date modifyDate = parseDate(lastModify);

        if (date != null) {
            Log.d(TAG, "Date: " + date.getTime());
            Log.d(TAG, "Date: modifyDate = " + modifyDate.getTime());
        } else {
            Log.e(TAG, "Date parse failed.");
        }
        Log.d(TAG, "Date parse end.");
    }

    private static Date parseDate(String time) {
        for (String pattern : DATE_PATTERNS) {
            try {
                Log.d(TAG, "DATE_PATTERNS: " + pattern);
                SimpleDateFormat df = new SimpleDateFormat(pattern, Locale.ENGLISH);
                df.setTimeZone(GMT_ZONE);
                return df.parse(time);
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    private class TimeTask implements Runnable {
        private String[] ntpServerPool = {"ntp1.aliyun.com", "ntp2.aliyun.com", "ntp3.aliyun.com", "ntp4.aliyun.com", "ntp5.aliyun.com", "ntp6.aliyun.com", "ntp7.aliyun.com",
                "cn.pool.ntp.org", "cn.ntp.org.cn", "sg.pool.ntp.org", "tw.pool.ntp.org", "jp.pool.ntp.org", "hk.pool.ntp.org", "th.pool.ntp.org",
                "time.windows.com", "time.nist.gov", "time.apple.com", "time.asia.apple.com",
                "dns1.synet.edu.cn", "news.neu.edu.cn", "dns.sjtu.edu.cn", "dns2.synet.edu.cn", "ntp.glnet.edu.cn", "s2g.time.edu.cn",
                "ntp-sz.chl.la", "ntp.gwadar.cn", "3.asia.pool.ntp.org"};

        @Override
        public void run() {
            SntpClient sntpClient = new SntpClient();
            for (String serverHost : ntpServerPool) {
                if (sntpClient.requestTime(serverHost, 30000)) {
                    long ntpTime = sntpClient.getNtpTime();
                    long elapsedRealtime = SystemClock.elapsedRealtime();
                    long ntpTimeReference = sntpClient.getNtpTimeReference();
                    long now = sntpClient.getNtpTime() + SystemClock.elapsedRealtime() - sntpClient.getNtpTimeReference();
                    Log.d(TAG, String.format("Host:%s -> ntpTime = %s, elapsedRealtime = %s, ntpTimeReference = %s.", serverHost, ntpTime, elapsedRealtime, ntpTimeReference));
                    Date current = new Date(now);
                    Log.d(TAG, current.toString());
                }else{
                    Log.e(TAG,"err "+serverHost);
                }
            }
        }
    }
}
