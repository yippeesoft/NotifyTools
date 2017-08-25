package org.github.yippee.china_poem.view.Rx;

import com.jakewharton.rxrelay2.BehaviorRelay;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.annotations.NonNull;
import io.reactivex.functions.Action;
import io.reactivex.functions.Consumer;
import io.reactivex.functions.Function;
import org.github.yippee.china_poem.MainActivity;
import org.github.yippee.china_poem.Utils.LogUtils;
import org.github.yippee.china_poem.poem2db.bean.SongCi;
import org.github.yippee.china_poem.poem2db.bean.Tangshi;
import org.github.yippee.china_poem.view.DataBuilder;
import org.github.yippee.china_poem.view.ViewBuilder;

/**
 * Created by sf on 2017/8/14.
 */

public class RxView {
  LogUtils log=LogUtils.getLogger(RxView.class);

  public BehaviorRelay<SongCi> relay=BehaviorRelay.create();

  ViewBuilder viewBuilder;
  MainActivity main;
  public RxView(MainActivity main){
    this.main=main;
  }

  public void init(){
    viewBuilder=new ViewBuilder(main);
    viewBuilder.initView();
    log.d("Consumer init:"+(System.currentTimeMillis() ));

    relay.observeOn(AndroidSchedulers.mainThread()) .subscribe(new Consumer<SongCi>() {
      @Override public void accept(SongCi s) throws Exception {

        viewBuilder.initData(s);
      }
    });
    final long start=System.currentTimeMillis();
    log.d("Consumer init2:"+(System.currentTimeMillis() ));
    new DataBuilder().getAuthors().map(new Function<SongCi, String>() {
      @Override public String apply(@NonNull SongCi s) throws Exception {
        relay.accept(s);
        return "";
      }
    }).subscribe(new Consumer<String>() {
      @Override public void accept(String s) throws Exception {

      }
    }, new Consumer<Throwable>() {
      @Override public void accept(Throwable throwable) throws Exception {

      }
    }, new Action() {
      @Override public void run() throws Exception {
         log.d("Consumer onend:"+(System.currentTimeMillis() ));
      }
    });
  }
}
