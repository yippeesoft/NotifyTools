package org.github.yippee.china_poem.view;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.animation.OvershootInterpolator;
import java.util.List;
import android.support.v7.widget.RecyclerView.ViewHolder;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import net.cachapa.expandablelayout.ExpandableLayout;
import org.github.yippee.china_poem.R;
import org.github.yippee.china_poem.Utils.LogUtils;

/**
 * Created by sf on 2017/8/11.
 */

public class PoemAdapter extends RecyclerView.Adapter<PoemAdapter.PoemViewHolder> {
  LogUtils log=LogUtils.getLogger(PoemAdapter.class);
  private List<String> mDatas;
  private Context mContext;
  private LayoutInflater inflater;
  private RecyclerView recyclerView;

  private static final int UNSELECTED = -1;
  private int selectedItem = UNSELECTED;

  public PoemAdapter(Context context, List<String> datas,RecyclerView recyclerView){
    this. mContext=context;
    this. mDatas=datas;
    inflater=LayoutInflater. from(mContext);
    this.recyclerView = recyclerView;
  }

  @Override
  public int getItemCount() {

    return mDatas.size();
  }

  //填充onCreateViewHolder方法返回的holder中的控件
  @Override
  public void onBindViewHolder(PoemViewHolder holder, final int position) {

    holder.bind(position);
  }

  //重写onCreateViewHolder方法，返回一个自定义的ViewHolder
  @Override
  public PoemViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

    View view = inflater.inflate(R.layout.view_rv_item,parent, false);
    PoemViewHolder holder= new PoemViewHolder(view);
    return holder;
  }

  class PoemViewHolder extends ViewHolder implements View.OnClickListener, ExpandableLayout.OnExpansionUpdateListener{

    TextView tv;
    private ExpandableLayout expandableLayout;
    private TextView expandText;
    private int position;

    public PoemViewHolder(View view) {
      super(view);
      tv=(TextView) view.findViewById(R.id.item_tv);
      expandableLayout = (ExpandableLayout) itemView.findViewById(R.id.expandable_layout);
      expandText=(TextView)itemView.findViewById(R.id.expandable_text);
      expandableLayout.setInterpolator(new OvershootInterpolator());
      expandableLayout.setOnExpansionUpdateListener(this);

      tv.setOnClickListener(this);
    }

    public void bind(int position) {
      log.d("bind "+position+mDatas.get(position));
      this.position = position;
      tv.setSelected(false);
      tv.setText( mDatas.get(position));
      expandableLayout.collapse(false);
    }

    @Override
    public void onExpansionUpdate(float expansionFraction, int state) {
      Log.d("ExpandableLayout", "State: " + state);
      recyclerView.smoothScrollToPosition(getAdapterPosition());
    }
    @Override
    public void onClick(View view) {
      PoemViewHolder holder = (PoemViewHolder) recyclerView.findViewHolderForAdapterPosition(selectedItem);
      if (holder != null) {
        holder.tv.setSelected(false);
        holder.expandableLayout.collapse();
      }

      if (position == selectedItem) {
        selectedItem = UNSELECTED;
      } else {
        tv.setSelected(true);
        expandableLayout.expand();
        selectedItem = position;
      }
    }

  }
}