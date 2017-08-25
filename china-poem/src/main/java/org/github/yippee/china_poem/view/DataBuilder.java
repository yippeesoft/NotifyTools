package org.github.yippee.china_poem.view;

import android.app.Activity;
import android.content.Context;
import android.database.Cursor;
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
import java.util.ArrayList;
import java.util.List;
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

public class DataBuilder {
  LogUtils log=LogUtils.getLogger(DataBuilder.class);

  public DataBuilder( ){

    dbManager = DBCiManager.getInstance(PoemApp.getContext());
    tsDao=dbManager.getSongCiDao();
  }

  DBCiManager dbManager ;
  SongCiDao tsDao;
  //final String SQL_DISTINCT_ENAME = "SELECT DISTINCT "+TangshiDao.Properties.Author.columnName+","+TangshiDao.Properties.Pyquany.columnName
  //    +","+TangshiDao.Properties.Pyjian.columnName+","+TangshiDao.Properties.Authorjt.columnName+","+TangshiDao.Properties.Pyquan.columnName
  //    +" FROM "+TangshiDao.TABLENAME
  //    +" order by pyquan";

  final String SQL_DISTINCT_ENAME = "SELECT DISTINCT "+ SongCiDao.Properties.Author.columnName+","+SongCiDao.Properties.Pyquany.columnName
      +","+SongCiDao.Properties.Pyjian.columnName+"," +SongCiDao.Properties.Pyquan.columnName
      +" FROM "+SongCiDao.TABLENAME
      +" order by pyquan";

  //Select Name,Count(*) From A Group By Name Having Count(*) > 1

  public Flowable<SongCi> getAuthors(){
    log.d("SQL_DISTINCT_ENAME:"+SQL_DISTINCT_ENAME);
    final long start=System.currentTimeMillis();
    log.d("Consumer startt:"+start);
    final Cursor cursor = dbManager.getDaoSession().getDatabase().rawQuery("select * from ci", null);
    //List<SongCi> ll=new ArrayList<>();
    //SongCi point;
    //while (cursor.moveToNext()){
    //  point = new SongCi();
    //  point.setPyquan(cursor.getString(cursor
    //      .getColumnIndex("pyquan")));
    //  point.setRhythmic(cursor.getString(cursor
    //      .getColumnIndex("rhythmic")));
    //  point.setAuthor(cursor.getString(cursor
    //      .getColumnIndex("author")));
    //  point.setContent(cursor.getString(cursor
    //      .getColumnIndex("content")));
    //  point.setPyjian(cursor.getString(cursor
    //      .getColumnIndex("pyjian")));
    //  point.setPyquany(cursor.getString(cursor
    //      .getColumnIndex("pyquany")));
    //  ll.add(point);
    //}
    //log.d("Consumer enddd:"+System.currentTimeMillis());
    final Cursor c=cursor;
    Flowable<SongCi> source = StatementFlowable.whileDo(

        Flowable.just(c).flatMap(new Function<Cursor, Publisher<SongCi>>() {

          @Override public Publisher<SongCi> apply(@NonNull Cursor cursor)   {
            SongCi ts=new SongCi();
            try {
              //log.d("Publisher0:"+c.getString(0));
              ts.setAuthor(c.getString(0));  //new String(c.getBlob(0),"UTF-16LE");
              //log.d("Publisher1:"+new String(c.getBlob(cursor.getColumnIndex("title")),"UTF-8"));
              //ts.setTitle(c.getString(1));
              //ts.setParagraphs(c.getString(2));
              //ts.setStrains(c.getString(3));
              ts.setPyquany(c.getString(1));
              ts.setPyjian(c.getString(2));
              //ts.setAuthorjt(c.getString(3));
              ts.setPyquan(c.getString(3));
            } catch (Exception e) {
              log.e(e);
            }
            return Flowable.just(ts);
          }
        })
        , new BooleanSupplier() {
          @Override public boolean getAsBoolean() throws Exception {
            boolean b=c.moveToNext();
            //log.d("getAsBoolean"+b);
            return b;
          }
        }).subscribeOn(Schedulers.newThread());



    return source;

  }
}
