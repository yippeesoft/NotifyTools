package org.github.yippee.china_poem.view;

import android.app.Activity;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import java.util.ArrayList;
import org.github.yippee.china_poem.R;

/**
 * Created by sf on 2017/8/11.
 */

public class ViewBuilder {
  Activity cxt;
  public ViewBuilder(Activity cxt){
    this.cxt=cxt;
  }
  RecyclerView poemRecyclerView;
  PoemAdapter poemAdapter;
  ArrayList<String> poemData=new ArrayList<>();

  public void initData(String s){
    poemData.add(s );
    poemAdapter.notifyItemInserted(poemData.size()-1);
  }
  public void initView(){
    //initdata();
    poemData = new ArrayList<String>();

    poemRecyclerView = (RecyclerView) cxt.findViewById(R.id.recycler_view);

    poemAdapter = new PoemAdapter(cxt, poemData);
    poemRecyclerView.setAdapter(poemAdapter);//设置适配器
    poemRecyclerView.setVerticalScrollBarEnabled(true);
    //设置布局管理器 , 将布局设置成纵向
    LinearLayoutManager
        linerLayoutManager = new LinearLayoutManager(cxt, LinearLayoutManager.VERTICAL, false);
    poemRecyclerView.setLayoutManager(linerLayoutManager);

    //设置分隔线
    //mRecycleView.addItemDecoration(new DividerItemDecoration(this , DividerItemDecoration.VERTICAL_LIST));

    //设置增加或删除条目动画
    poemRecyclerView.setItemAnimator(new DefaultItemAnimator());

  }
}
