package org.github.yippee.china_poem.view;

import android.app.Activity;
import android.content.Context;
import android.database.Cursor;
import android.os.SystemClock;
import com.google.common.collect.HashMultiset;
import com.google.common.collect.Iterables;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.google.common.collect.Multimap;
import com.google.common.collect.Multimaps;
import com.google.common.collect.Multiset;
import com.hankcs.hanlp.HanLP;
import com.hankcs.hanlp.dictionary.py.Pinyin;
import hu.akarnokd.rxjava2.expr.StatementFlowable;
import io.reactivex.BackpressureStrategy;
import io.reactivex.Flowable;
import io.reactivex.FlowableEmitter;
import io.reactivex.FlowableOnSubscribe;
import io.reactivex.Observable;
import io.reactivex.ObservableEmitter;
import io.reactivex.ObservableOnSubscribe;
import io.reactivex.ObservableSource;
import io.reactivex.Observer;
import io.reactivex.annotations.NonNull;
import io.reactivex.functions.BooleanSupplier;
import io.reactivex.functions.Function;
import io.reactivex.processors.PublishProcessor;
import io.reactivex.schedulers.Schedulers;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;

import javax.annotation.Nullable;
import org.github.yippee.china_poem.MainActivity;
import org.github.yippee.china_poem.PoemApp;
import org.github.yippee.china_poem.Utils.LogUtils;
import org.github.yippee.china_poem.poem2db.DBCiManager;
import org.github.yippee.china_poem.poem2db.DBManager;
import org.github.yippee.china_poem.poem2db.bean.SongCi;
import org.github.yippee.china_poem.poem2db.bean.Tangshi;
import org.github.yippee.china_poem.poem2db.dao.gen.SongCiDao;
import org.github.yippee.china_poem.poem2db.dao.gen.TangshiDao;
import org.reactivestreams.Publisher;
import org.reactivestreams.Subscriber;

/**
 * Created by sf on 2017/8/11.
 */

public class DataBuilderGuava {
  LogUtils log=LogUtils.getLogger(DataBuilderGuava.class);

  public DataBuilderGuava( ){

    dbManager = DBCiManager.getInstance(PoemApp.getContext());
    tsDao=dbManager.getSongCiDao();
  }

  DBCiManager dbManager ;
  SongCiDao tsDao;


  public Flowable<List<SongCi>> getAuthors(){
    log.d("getAuthors:");
    //final Cursor c = dbManager.getDaoSession().getDatabase().rawQuery(SQL_DISTINCT_ENAME, null);
    final long start=System.currentTimeMillis();
    List<SongCi> listSongCi=tsDao.loadAll();
    log.d("Consumer enddd "+ (System.currentTimeMillis()-start));
    Flowable<List<SongCi>> source = Flowable.empty().flatMap(new Function<Object, Publisher<List<SongCi>>>() {
      @Override public Publisher<List<SongCi>> apply(@NonNull Object o)   {
        log.d("getAuthors1:");
        List<SongCi> listSongCi=tsDao.loadAll();
        log.d("enddd "+ (System.currentTimeMillis()-start));
        return Flowable.just(listSongCi);
      }
    }).subscribeOn(Schedulers.newThread());

    //    .flatMap(new Function<List<SongCi>, Publisher<Multimap<String,SongCi> >>() {
    //  @Override public Publisher<Multimap<String,SongCi> > apply(@NonNull List<SongCi> songCis)   {
    //    Multimap<String,SongCi> map= Multimaps.index(songCis, new com.google.common.base.Function<SongCi, String>() {
    //      @Nullable @Override public String apply(@Nullable SongCi songCi) {
    //        return songCi.getAuthor();
    //      }
    //    });
    //    return Flowable.just(map);
    //  }
    //}).flatMap(new Function<Multimap<String, SongCi>, Publisher<List<SongCi>>>() {
    //  @Override public Publisher<List<SongCi>> apply(@NonNull Multimap<String, SongCi> stringSongCiMultimap)
    //       {
    //         // Iterables.transform(stringSongCiMultimap.asMap().entrySet(), new com
    //         //        .google.common.base.Function<Map.Entry<String,SongCi>, SongCi>() {
    //         //
    //         //  @Nullable @Override
    //         //  public SongCi apply(@Nullable Map.Entry<String, SongCi> stringSongCiEntry) {
    //         //    return null;
    //         //  }
    //         //});
    //
    //    log.d("enddd "+ (System.currentTimeMillis()-start));
    //    return null;
    //  }
    //})



        //
        //StatementFlowable.whileDo(
        //
        //Flowable.just(c).flatMap(new Function<Cursor, Publisher<SongCi>>() {
        //
        //  @Override public Publisher<SongCi> apply(@NonNull Cursor cursor)   {
        //    SongCi ts=new SongCi();
        //    try {
        //      //log.d("Publisher0:"+c.getString(0));
        //      ts.setAuthor(c.getString(0));  //new String(c.getBlob(0),"UTF-16LE");
        //      //log.d("Publisher1:"+new String(c.getBlob(cursor.getColumnIndex("title")),"UTF-8"));
        //      //ts.setTitle(c.getString(1));
        //      //ts.setParagraphs(c.getString(2));
        //      //ts.setStrains(c.getString(3));
        //      ts.setPyquany(c.getString(1));
        //      ts.setPyjian(c.getString(2));
        //      //ts.setAuthorjt(c.getString(3));
        //      ts.setPyquan(c.getString(3));
        //    } catch (Exception e) {
        //      log.e(e);
        //    }
        //    return Flowable.just(ts);
        //  }
        //})
        //, new BooleanSupplier() {
        //  @Override public boolean getAsBoolean() throws Exception {
        //    boolean b=c.moveToNext();
        //    //log.d("getAsBoolean"+b);
        //    return b;
        //  }
        //}).subscribeOn(Schedulers.newThread());



    return source;
    //.flatMap(new Function<List<SongCi>, Publisher<SongCi>>() {
    //  @Override public Publisher<SongCi> apply(@NonNull List<SongCi> songCis) throws Exception {
    //    return null;
    //  }
    //});

  }
}
