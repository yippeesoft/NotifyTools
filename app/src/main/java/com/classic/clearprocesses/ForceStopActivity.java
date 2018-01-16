package com.classic.clearprocesses;

import android.accessibilityservice.AccessibilityServiceInfo;
import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.Settings;
import android.support.design.widget.FloatingActionButton;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.accessibility.AccessibilityManager;

import com.classic.adapter.CommonRecyclerAdapter;

import org.github.yippee.notifytools.R;

import java.util.ArrayList;
import java.util.List;

import io.reactivex.Flowable;
import io.reactivex.FlowableEmitter;
import io.reactivex.FlowableOnSubscribe;
import io.reactivex.Observable;
import io.reactivex.ObservableEmitter;
import io.reactivex.ObservableOnSubscribe;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.annotations.NonNull;
import io.reactivex.disposables.CompositeDisposable;
import io.reactivex.schedulers.Schedulers;


public class ForceStopActivity extends AppCompatActivity implements CommonRecyclerAdapter.OnItemClickListener {
    String TAG="ForceStopActivity";
    private static final String SERVICE_NAME    = "com.classic.clearprocesses/.HelpService";
    private static final String CURRENT_PACKAGE = "com.classic.clearprocesses";
    private static final String PACKAGE         = "package";
    private static final String[] PACKAGE_PREFIX = {
            "com.android",
            "com.eg.android",
            "com.google",
            "android",
            "system",
            "com.cyanogenmod",
            "org.cyanogenmod",
            "com.qualcomm", //高通cpu监控进程
            "com.huawei",
            "com.miui",
            "in.zhaoj",
            CURRENT_PACKAGE
    };

    private Context               mAppContext;
    private ActivityManager       mActivityManager;
    private RecyclerView          mRecyclerView;
    private CompositeDisposable mCompositeDisposable ;
    private AccessibilityManager  mAccessibilityManager;
    private ArrayList<String>     mPackageList;
    private PackageAdapter mPackageAdapter;

    @Override protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mAppContext = getApplicationContext();
        mAccessibilityManager = (AccessibilityManager) getSystemService(ACCESSIBILITY_SERVICE);
        mPackageList = new ArrayList<>();
        mCompositeDisposable = new CompositeDisposable();
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
//        setSupportActionBar(toolbar);
        mRecyclerView = (RecyclerView) findViewById(R.id.main_rv);
        RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(mRecyclerView.getContext());
        mRecyclerView.setLayoutManager(layoutManager);
        mActivityManager = (ActivityManager) mAppContext.getSystemService(Context.ACTIVITY_SERVICE);
        mPackageAdapter = new PackageAdapter(mAppContext);
        mRecyclerView.setAdapter(mPackageAdapter);
        mPackageAdapter.setOnItemClickListener(this);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        assert fab != null;
        fab.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View view) {
                if (checkEnabledAccessibilityService()) {
                    clearAllProcesses();
                }
            }
        });
    }

    @Override protected void onResume() {
        super.onResume();
        queryBackgroundProcesses();
    }

    private void query() {
//        CompositeDisposable.add(Observable.create(new Observable.OnSubscribe<List<String>>() {
//                                    @Override public void call(Subscriber<? super List<String>> subscriber) {
//                                        mPackageList.clear();
//                                        mPackageList.addAll(queryBackgroundProcesses());
//                                        subscriber.onNext(mPackageList);
//                                        subscriber.onCompleted();
//                                    }
//                                })
//                                .subscribeOn(Schedulers.newThread())
//                                .unsubscribeOn(Schedulers.newThread())
//                                .observeOn(AndroidSchedulers.mainThread())
//                                .subscribe(mPackageAdapter));

    }

    private List<String> queryBackgroundProcesses(){
        List<String> packageList = new ArrayList<>();
        List<ActivityManager.RunningAppProcessInfo> appProcesses = mActivityManager.getRunningAppProcesses();
        for (ActivityManager.RunningAppProcessInfo info : appProcesses) {
            if (verifyPackageName(info.processName)) continue;
            final String packageName = getPackageName(info.processName);
            if(!packageList.contains(packageName)){
                packageList.add(packageName);
            }
        }
        List<ActivityManager.RunningServiceInfo> allServices = mActivityManager.getRunningServices(1000);
        for (ActivityManager.RunningServiceInfo info : allServices) {
            if (verifyPackageName(info.process)) continue;
            final String packageName = getPackageName(info.process);
            if(!packageList.contains(packageName)){
                packageList.add(packageName);
            }
        }
        mPackageList.clear();
        mPackageList.addAll(packageList);
        mPackageAdapter.clear();
        mPackageAdapter.addAll(packageList);
        return packageList;
    }

    private String getPackageName(String processName){
        return processName.contains(":") ? processName.split(":")[0] : processName;
    }

    private boolean verifyPackageName(String process) {
        for(String prefix : PACKAGE_PREFIX){
            if(process.startsWith(prefix)){
                return true;
            }
        }
        return false;
    }

    private void clearAllProcesses(){
//        mCompositeSubscription.add(
//                Observable.from(mPackageList)
//                        .subscribeOn(Schedulers.io())
//                        .unsubscribeOn(Schedulers.io())
//                        .observeOn(Schedulers.io())
//                        .subscribe(new Subscriber<String>() {
//                            @Override public void onCompleted() {  }
//
//                            @Override public void onError(Throwable e) {
//                                e.printStackTrace();
//                            }
//
//                            @Override public void onNext(String packageName) {
//                                showPackageDetail(packageName);
//                            }
//                        }));
    }

    private void showPackageDetail(String packageName){
        Intent intent = new Intent();
        intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        Uri uri = Uri.fromParts(PACKAGE, packageName, null);
        intent.setData(uri);
        startActivity(intent);
    }

    // To check if service is enabled
    private boolean isAccessibilitySettingsOn(Context mContext) {
        int accessibilityEnabled = 0;
        final String service = getPackageName() + "/" + HelpService.class.getCanonicalName();
        try {
            accessibilityEnabled = Settings.Secure.getInt(
                    mContext.getApplicationContext().getContentResolver(),
                    android.provider.Settings.Secure.ACCESSIBILITY_ENABLED);
            Log.v(TAG, "accessibilityEnabled = " + accessibilityEnabled);
        } catch (Settings.SettingNotFoundException e) {
            Log.e(TAG, "Error finding setting, default accessibility to not found: "
                    + e.getMessage());
        }
        TextUtils.SimpleStringSplitter mStringColonSplitter = new TextUtils.SimpleStringSplitter(':');

        if (accessibilityEnabled == 1) {
            Log.v(TAG, "***ACCESSIBILITY IS ENABLED*** -----------------");
            String settingValue = Settings.Secure.getString(
                    mContext.getApplicationContext().getContentResolver(),
                    Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES);
            if (settingValue != null) {
                mStringColonSplitter.setString(settingValue);
                while (mStringColonSplitter.hasNext()) {
                    String accessibilityService = mStringColonSplitter.next();

                    Log.v(TAG, "-------------- > accessibilityService :: " + accessibilityService + " " + service);
                    if (accessibilityService.equalsIgnoreCase(service)) {
                        Log.v(TAG, "We've found the correct setting - accessibility is switched on!");
                        return true;
                    }
                }
            }
        } else {
            Log.v(TAG, "***ACCESSIBILITY IS DISABLED***");
        }

        return false;
    }
    //https://stackoverflow.com/questions/5081145/android-how-do-you-check-if-a-particular-accessibilityservice-is-enabled

    private boolean checkEnabledAccessibilityService() {
        if(isAccessibilitySettingsOn(this))
            return true;;
        List<AccessibilityServiceInfo> accessibilityServices =
                mAccessibilityManager.getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_ALL_MASK);
        for (AccessibilityServiceInfo info : accessibilityServices) {
            if (info.getId().equals(SERVICE_NAME)) {
                Log.d("checkAS",info.getId()+" "+info.toString());
                return true;
            }
        }
        Intent intent = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
        startActivity(intent);
        return false;
    }

    @Override public void onItemClick(RecyclerView.ViewHolder viewHolder, View view, int position) {
        if(checkEnabledAccessibilityService()){
            showPackageDetail(mPackageList.get(position));
            mPackageAdapter.remove(position);
        }
    }

    @Override protected void onDestroy() {
        super.onDestroy();
        if (null != mCompositeDisposable) {
            mCompositeDisposable.dispose();
            mCompositeDisposable=null;
        }
    }
}
