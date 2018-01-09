package org.github.yippee.notifytools.service;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.os.SystemClock;
import android.support.annotation.Nullable;
import android.support.v4.app.NotificationCompat;

import com.google.gson.Gson;

import org.github.yippee.notifytools.R;
import org.github.yippee.notifytools.bean.Heweather7bean;
import org.github.yippee.notifytools.utils.LocalConst;
import org.github.yippee.notifytools.utils.LocalConstsf;
import org.github.yippee.notifytools.utils.Logs;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.TimeUnit;

import io.reactivex.Observable;
import io.reactivex.ObservableSource;
import io.reactivex.Observer;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.annotations.NonNull;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.Consumer;
import io.reactivex.functions.Function;
import io.reactivex.schedulers.Schedulers;
import okhttp3.OkHttpClient;
import okhttp3.ResponseBody;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Response;
import retrofit2.Retrofit;
//import retrofit2.adapter.rxjava.RxJavaCallAdapterFactory;
import retrofit2.adapter.rxjava2.RxJava2CallAdapterFactory;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.Headers;
import retrofit2.http.POST;
import retrofit2.http.Streaming;
import retrofit2.http.Url;
//import rx.Observable;
//import rx.Scheduler;
//import rx.android.schedulers.AndroidSchedulers;
//import rx.functions.Action0;
//import rx.functions.Action1;
//import rx.functions.Func1;
//import rx.schedulers.Schedulers;

/**
 * Created by sf on 2017/1/6.
 */

public class HeWeatherService  extends Service {
    private Logs log = Logs.getLogger(this.getClass());
    String baseUrl="https://free-api.heweather.com/v5/";
    String [] citys={"福州"};
    Gson gson = new Gson();
    Retrofit retrofit;
    OkHttpClient okHttpClient;
    IHeWeatherService weatherService;
    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        log.d("onStartCommand");
        get7();
        return Service.START_NOT_STICKY;
    }

    int notifyID=10;
    void get7(){
        for(int i=0;i<citys.length;i++){
            String url=baseUrl+"forecast?"+"city="+citys[i]+"&key="+ LocalConstsf.heweatherKey;
            log.d(url);
            weatherService.get7(url).subscribeOn(Schedulers.io())
                    .flatMap(new Function<Response<ResponseBody>, ObservableSource<Heweather7bean>>() {
                        @Override
                        public ObservableSource<Heweather7bean> apply(@NonNull Response<ResponseBody> response) throws Exception {
                            Heweather7bean resp = null;
                            if (response != null && !response.isSuccessful()) {
                                try {
                                    log.d(response.errorBody().string());
                                } catch (IOException e) {
                                    log.e(e);
                                }
                            }
                            if (response != null && response.body() != null) {
                                try {
                                    String respp = response.body().string();
                                    log.d("resp：" + respp);
                                    resp=new Gson().fromJson(respp,Heweather7bean.class);
                                } catch (IOException e) {
                                    log.e(e);
                                }
                            }

                            return Observable.just(resp);
                        }

                    })
                    .observeOn(AndroidSchedulers.mainThread())
                    .subscribe(new Consumer<Heweather7bean>() {
                        @Override
                        public void accept(Heweather7bean heweather7bean) throws Exception {
                            log.d("onnext：" + heweather7bean);
//                            noteMng = (NotificationManager)getSystemService(NOTIFICATION_SERVICE);
//                            Notification myNotify = new Notification();
                            Notification.Builder mBuilder = new Notification.Builder(HeWeatherService.this);
                            mBuilder.setSmallIcon(R.drawable.ic_notify);
                            mBuilder.setTicker("");
                            notifyID+=10;
                            mBuilder.setWhen(System.currentTimeMillis() );
                            Notification.BigTextStyle inboxStyle =
                                    new Notification.BigTextStyle();

                            List<Heweather7bean.HeWeather5Bean.DailyForecastBean> lst=heweather7bean.getHeWeather5().get(0).getDaily_forecast();
                            StringBuilder sb=new StringBuilder();
                            String s="";
                            for(int i=0;i<lst.size();i++){
                                Heweather7bean.HeWeather5Bean.DailyForecastBean db=lst.get(i);
                                s+=String.format("%s%s转%s%s°到%s°%s 风力%s\r\n",
                                        db.getDate(),db.getCond().getTxt_d(),db.getCond().getTxt_n(),db.getTmp().getMax(), db.getTmp().getMin(),db.getWind().getDir(),db.getWind().getSc());

                            }
                            log.d("DailyForecastBean：" + s);
                            inboxStyle.bigText(s);
                            inboxStyle.setBigContentTitle(heweather7bean.getHeWeather5().get(0).getBasic().getCity()+"天气");
                            inboxStyle.setSummaryText(heweather7bean.getHeWeather5().get(0).getBasic().getCity()+lst.size()+"天天气");
                            mBuilder.setStyle(inboxStyle);

                            noteMng.notify(notifyID, mBuilder.build());
                        }
                    });


        }

    }


    NotificationManager noteMng;
    Notification.Builder mBuilder;
    @Override
    public void onCreate() {
        log.d("onCreate");
        super.onCreate();

        HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
        interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
        okHttpClient = new OkHttpClient.Builder()
                .readTimeout(15, TimeUnit.SECONDS)//设置读取超时时间
                .writeTimeout(15,TimeUnit.SECONDS)//设置写的超时时间
                .connectTimeout(15,TimeUnit.SECONDS)//设置连接超时时间
                .addInterceptor(interceptor)
                .build();
        retrofit = new Retrofit.Builder()
                .baseUrl(baseUrl)
                .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                .addConverterFactory(StringConverterFactory.create())
                .client(okHttpClient)
                .build();

        weatherService = retrofit.create(IHeWeatherService.class);

        mBuilder = new Notification.Builder(HeWeatherService.this);
        noteMng = (NotificationManager)getSystemService(NOTIFICATION_SERVICE);
    }

    public interface IHeWeatherService {
        @Headers({"Content-Type: application/json", "Accept: application/json"})
        @GET
        Observable<Response<ResponseBody>> get7(@Url String url);
    }
    @Override
    public void onDestroy() {
        log.d("onDestroy");
        close();
        super.onDestroy();
    }
    public void close() {
//        OkHttpClient的线程池和连接池在空闲的时候会自动释放，所以一般情况下不需要手动关闭，但是如果出现极端内存不足的情况，可以使用以下代码释放内存：
        try {

            okHttpClient.connectionPool().evictAll();                 //清除并关闭连接池
            log.d("OKHTTP connections iddle: {}, all: {}", okHttpClient.connectionPool().idleConnectionCount(),
                    okHttpClient.connectionPool().connectionCount());
            okHttpClient.dispatcher().executorService().shutdown();   //清除并关闭线程池
            try {
                okHttpClient.dispatcher().executorService().awaitTermination(10 * 1000, TimeUnit.MILLISECONDS);
                log.d("OKHTTP ExecutorService closed.");
            } catch (InterruptedException e) {
                log.d("InterruptedException on destroy()", e);
            }
//            okHttpClient.cache().close();
        } catch (Exception e) {
            log.e(e);
        }
    }
}
