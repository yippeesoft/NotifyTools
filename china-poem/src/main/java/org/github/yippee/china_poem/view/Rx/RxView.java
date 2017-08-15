package org.github.yippee.china_poem.view.Rx;

import com.jakewharton.rxrelay2.BehaviorRelay;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.annotations.NonNull;
import io.reactivex.functions.Consumer;
import io.reactivex.functions.Function;
import org.github.yippee.china_poem.MainActivity;
import org.github.yippee.china_poem.Utils.LogUtils;
import org.github.yippee.china_poem.poem2db.bean.Tangshi;
import org.github.yippee.china_poem.view.DataBuilder;
import org.github.yippee.china_poem.view.ViewBuilder;

/**
 * Created by sf on 2017/8/14.
 */

public class RxView {
  LogUtils log=LogUtils.getLogger(RxView.class);

  public BehaviorRelay<Tangshi> relay=BehaviorRelay.create();

  ViewBuilder viewBuilder;
  MainActivity main;
  public RxView(MainActivity main){
    this.main=main;
  }

  public void init(){
    viewBuilder=new ViewBuilder(main);
    viewBuilder.initView();


    relay.observeOn(AndroidSchedulers.mainThread()) .subscribe(new Consumer<Tangshi>() {
      @Override public void accept(Tangshi s) throws Exception {
        //log.d("Consumer:"+s);
        viewBuilder.initData(s);
      }
    });
    new DataBuilder().getAuthors().map(new Function<Tangshi, String>() {
      @Override public String apply(@NonNull Tangshi s) throws Exception {
        relay.accept(s);
        return "";
      }
    }).subscribe( );
  }
}
