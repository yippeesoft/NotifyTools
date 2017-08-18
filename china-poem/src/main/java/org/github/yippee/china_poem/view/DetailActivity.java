package org.github.yippee.china_poem.view;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.View;
import com.google.gson.Gson;
import java.util.List;
import org.github.yippee.china_poem.MainActivity;
import org.github.yippee.china_poem.PoemApp;
import org.github.yippee.china_poem.R;
import org.github.yippee.china_poem.Utils.LogUtils;
import org.github.yippee.china_poem.poem2db.DBCiManager;
import org.github.yippee.china_poem.poem2db.DBManager;
import org.github.yippee.china_poem.poem2db.bean.SongCi;
import org.github.yippee.china_poem.poem2db.bean.Tangshi;
import org.github.yippee.china_poem.poem2db.dao.gen.SongCiDao;
import org.github.yippee.china_poem.poem2db.dao.gen.TangshiDao;

public class DetailActivity extends AppCompatActivity {
  LogUtils log=LogUtils.getLogger(DetailActivity.class);


  DBCiManager dbManager ;
  SongCiDao tsDao;

  RecyclerView rvDetail;
  List<SongCi> tsList;
  PoemDetailAdapter poemDetailAdapter;
  @Override protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    log.d("DetailActivity onCreate");

    setContentView(R.layout.activity_detail);
    Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
    rvDetail=(RecyclerView)findViewById(R.id.rv_detail);
    setSupportActionBar(toolbar);

    Intent it=getIntent();
    if(it==null || it.getParcelableExtra("tangshi")==null){
      this.finish();
    }
    Tangshi ts=it.getParcelableExtra("tangshi");
    log.d("DetailActivity "+new Gson().toJson(ts,Tangshi.class));
    this.setTitle(ts.getAuthor());

    FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
    fab.setOnClickListener(new View.OnClickListener() {
      @Override public void onClick(View view) {
        Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
            .setAction("Action", null)
            .show();
      }
    });

    dbManager = DBCiManager.getInstance(PoemApp.getContext());
    tsDao=dbManager.getSongCiDao();
    tsList=tsDao.queryBuilder().where(SongCiDao.Properties.Author.eq(ts.getAuthor())).list();
    for (SongCi t : tsList){
      log.d("DetailActivity where "+new Gson().toJson(t,SongCi.class));
    }
    poemDetailAdapter = new PoemDetailAdapter(this, tsList,rvDetail);
    rvDetail.setAdapter(poemDetailAdapter);//设置适配器
    rvDetail.setVerticalScrollBarEnabled(true);
    //设置布局管理器 , 将布局设置成纵向
    LinearLayoutManager
        linerLayoutManager = new LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false);
    rvDetail.setLayoutManager(linerLayoutManager);

    //设置分隔线
    rvDetail.addItemDecoration(new DividerItemDecoration(this , DividerItemDecoration.VERTICAL));

    //设置增加或删除条目动画
    rvDetail.setItemAnimator(new DefaultItemAnimator());
  }
}
