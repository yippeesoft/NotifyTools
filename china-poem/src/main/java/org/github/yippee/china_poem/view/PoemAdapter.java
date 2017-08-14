package org.github.yippee.china_poem.view;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import java.util.List;
import android.support.v7.widget.RecyclerView.ViewHolder;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import org.github.yippee.china_poem.R;

/**
 * Created by sf on 2017/8/11.
 */

public class PoemAdapter extends RecyclerView.Adapter<PoemAdapter.PoemViewHolder> {

  private List<String> mDatas;
  private Context mContext;
  private LayoutInflater inflater;

  public PoemAdapter(Context context, List<String> datas){
    this. mContext=context;
    this. mDatas=datas;
    inflater=LayoutInflater. from(mContext);
  }

  @Override
  public int getItemCount() {

    return mDatas.size();
  }

  //填充onCreateViewHolder方法返回的holder中的控件
  @Override
  public void onBindViewHolder(PoemViewHolder holder, final int position) {

    holder.tv.setText( mDatas.get(position));
  }

  //重写onCreateViewHolder方法，返回一个自定义的ViewHolder
  @Override
  public PoemViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

    View view = inflater.inflate(R.layout.view_rv_item,parent, false);
    PoemViewHolder holder= new PoemViewHolder(view);
    return holder;
  }

  class PoemViewHolder extends ViewHolder{

    TextView tv;

    public PoemViewHolder(View view) {
      super(view);
      tv=(TextView) view.findViewById(R.id.item_tv);
    }

  }
}