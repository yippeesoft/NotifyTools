package org.frida.hook.test;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.os.PowerManager;
import android.os.RemoteException;
import android.os.ServiceManager;
import android.os.SystemClock;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.IWindowManager;
import android.view.MotionEvent;
import android.view.Surface;
import android.view.View;

import androidx.navigation.NavController;
import androidx.navigation.Navigation;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;

import org.frida.hook.test.databinding.ActivityMainBinding;

import android.view.Menu;
import android.view.MenuItem;
import android.view.WindowManager;
import android.widget.Toast;

import com.android.internal.app.LocalePicker;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Locale;


public class MainActivity extends AppCompatActivity {

    private AppBarConfiguration appBarConfiguration;
    private ActivityMainBinding binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        setSupportActionBar(binding.toolbar);

        NavController navController = Navigation.findNavController(this, R.id.nav_host_fragment_content_main);
        appBarConfiguration = new AppBarConfiguration.Builder(navController.getGraph()).build();
        NavigationUI.setupActionBarWithNavController(this, navController, appBarConfiguration);

        binding.fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, android.os.Build.VERSION.RELEASE_OR_CODENAME + "   " + android.os.Build.MODEL + add(1, 1), Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
//                rebooot();
                WindowManager manager = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
//                manager.
                IWindowManager mWindowManager = IWindowManager.Stub.asInterface(
                        ServiceManager.getService(Context.WINDOW_SERVICE));
                try {
                    mWindowManager.freezeRotation(Surface.ROTATION_270);
                } catch (RemoteException e) {
                    e.printStackTrace();
                }
            }
        });

        new Thread(new Runnable() {
            @Override
            public void run() {
                testJump(1);
            }
        }).start();

        try {
            Thread.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        Intent intent = new Intent("android.intent.action.MASTER_CLEAR");
        intent.addFlags(Intent.FLAG_RECEIVER_FOREGROUND);

        sendBroadcast(intent);
//        getAllLocal();
        IntentFilter filter = new IntentFilter();
        filter.addAction("ssss");
        TestBroadcastReceiver ttt = new TestBroadcastReceiver();
        //注册广播接收
//        registerReceiver(ttt, filter);

        intent = new Intent();
        intent.setAction("ssss");
        intent.addFlags(Intent.FLAG_RECEIVER_FOREGROUND);
        sendBroadcast(intent);
//        this.onStop();
    }

//    @Override
//    public boolean onTouchEvent(MotionEvent event) {
//        Log.d("AAA", "onTouchEvent");
//        while (true) {
//        }
////        return true;
//    }

//    protected void onStop() {
//
//        for (int i = 0; i < 20000; i++) {
//            try {
//                SystemClock.sleep(10);
//                Log.d("AA", i + "");
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//        }
//
//    }

    @Override
    protected void onResume() {
        super.onResume();
//        for (int i = 0; i < 20000; i++) {
//            try {
//                SystemClock.sleep(10);
//                Log.d("AA", i + "");
//            } catch (Exception e) {
//                e.printStackTrace();
//            }
//        }
    }

    class TestBroadcastReceiver extends BroadcastReceiver {

        @Override
        public void onReceive(Context context, Intent intent) {
//            SystemClock.sleep(150000);
            System.out.println("onReceiver Boardcast test2");

            if ("android.intent.action.EDIT".equals(intent.getAction())) {

                String msg = intent.getStringExtra("msg");
                System.out.println("msg" + msg);
                Toast.makeText(context, "TestBroadcastReceiver2", Toast.LENGTH_SHORT).show();
            }
        }
    }

    void testJump(int k) {
        int i = 0;
        if (k > 0) {
            Log.d("BBBB", "1" + i);
        } else {
            Log.d("ABBBBAAA", "1" + i);
        }
        Log.d("AAAA", "1" + i);
        i++;
        Log.d("AAAA", "1" + i);
        i++;
        Log.d("AAAA", "1" + i);
        i++;
        Log.d("AAAA", "1" + i);
        i++;
        Log.d("AAAA", "1" + i);
        i++;
        Log.d("AAAA", "1" + i);
        i++;

    }

    String toTitleCase(String s) {
        return s.length() == 0 ? s : Character.toUpperCase(s.charAt(0)) + s.substring(1);
    }

    void getAllLocal() {
        //getting the languages that are shown same as in our device settings
        final String[] locales = Resources.getSystem().getAssets().getLocales();
        List<String> localeList = new ArrayList<String>(locales.length);
        Collections.addAll(localeList, locales);
        Collections.sort(localeList);

        final ArrayList<LocalePicker.LocaleInfo> localeInfos = new ArrayList<LocalePicker.LocaleInfo>(localeList.size());
        for (String locale : localeList) {
            final Locale l = Locale.forLanguageTag(locale.replace('_', '-'));
            Log.d("AAAAlocal ", l.toString());
            if (l.toString().equalsIgnoreCase("zh_CN")) {
                change_setting(l);
            }
        }

        Collections.sort(localeInfos);
    }

    //to change the locale
    public static void change_setting(Locale loc) {
        try {
            Class<?> activityManagerNative = Class.forName("android.app.ActivityManagerNative");
            Object am = activityManagerNative.getMethod("getDefault", new Class[0]).invoke(activityManagerNative, new Object[0]);
            Object config = am.getClass().getMethod("getConfiguration", new Class[0]).invoke(am, new Object[0]);
            config.getClass().getDeclaredField("locale").set(config, loc);
            config.getClass().getDeclaredField("userSetLocale").setBoolean(config, true);
            am.getClass().getMethod("updateConfiguration", new Class[]{Configuration.class}).invoke(am, new Object[]{config});
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    void rebooot() {
        PowerManager pm = (PowerManager) getSystemService(Context.POWER_SERVICE);
        String reason = "PowerManager.";

        boolean b = pm.isPowerSaveMode();
        Log.e("AAAA", "cccc   " + b);
//        pm.reboot(reason);
    }

    int add(int x, int y) {
        return x + y;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @Override
    public boolean onSupportNavigateUp() {
        NavController navController = Navigation.findNavController(this, R.id.nav_host_fragment_content_main);
        return NavigationUI.navigateUp(navController, appBarConfiguration)
                || super.onSupportNavigateUp();
    }
}