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
import java.util.List;
import org.github.yippee.china_poem.MainActivity;
import org.github.yippee.china_poem.PoemApp;
import org.github.yippee.china_poem.Utils.LogUtils;
import org.github.yippee.china_poem.poem2db.DBManager;
import org.github.yippee.china_poem.poem2db.dao.gen.TangshiDao;
import org.reactivestreams.Publisher;
import org.reactivestreams.Subscriber;

/**
 * Created by sf on 2017/8/11.
 */

public class DataBuilder {
  LogUtils log=LogUtils.getLogger(DataBuilder.class);

  public DataBuilder( ){

    dbManager = DBManager.getInstance(PoemApp.getContext());
    tsDao=dbManager.getTangshiDao();
  }

  DBManager dbManager ;
  TangshiDao tsDao;
  final String SQL_DISTINCT_ENAME = "SELECT DISTINCT "+TangshiDao.Properties.Author.columnName+" FROM "+TangshiDao.TABLENAME;

  public Flowable<String> getAuthors(){

    final Cursor c = dbManager.getDaoSession().getDatabase().rawQuery(SQL_DISTINCT_ENAME, null);

    Flowable<String> source = StatementFlowable.whileDo(

        Flowable.just(c).flatMap(new Function<Cursor, Publisher<String>>() {
          String ftName,jtName,pyName;
          List<Pinyin> pinyinList;
          @Override public Publisher<String> apply(@NonNull Cursor cursor)   {
            try {
              ftName=new String(c.getBlob(0),"UTF-16LE");
              jtName= HanLP.convertToSimplifiedChinese(ftName);
              pinyinList = HanLP.convertToPinyinList(ftName) ;
              pyName="";
              for (Pinyin pinyin : pinyinList)
              {
                pyName+= pinyin.getPinyinWithToneMark()+" ";
              }
              //log.d("ftName {},jtName {} ,pyName {}",ftName,jtName,pyName);

            } catch (UnsupportedEncodingException e) {
              log.e(e);
            }
            return Flowable.just(ftName);
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
