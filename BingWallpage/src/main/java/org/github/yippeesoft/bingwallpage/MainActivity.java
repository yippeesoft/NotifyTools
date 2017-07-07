package org.github.yippeesoft.bingwallpage;

import android.graphics.Color;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.StaggeredGridLayoutManager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import com.bumptech.glide.Glide;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.orhanobut.logger.Logger;
import io.reactivex.Observer;
import io.reactivex.disposables.Disposable;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import okhttp3.Interceptor;
import okhttp3.Response;
import org.reactivestreams.Subscriber;
import org.reactivestreams.Subscription;

public class MainActivity extends AppCompatActivity {
    String TAG="MainActivity";
    RecyclerView rv;
    BingAdapter bingAdapter;
    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        rv=(RecyclerView)findViewById(R.id.list);


        // 两列
        int spanCount = 2;

        // StaggeredGridLayoutManager管理RecyclerView的布局。
        RecyclerView.LayoutManager mLayoutManager = new StaggeredGridLayoutManager(
            spanCount, StaggeredGridLayoutManager.VERTICAL);
        rv.setLayoutManager(mLayoutManager);
        rv.setHasFixedSize(true);
        //mLayoutManager.setMeasuredDimension(500,600);

        Logger.d(TAG,"onCreate");

        net.getBingWall().subscribeWith(bingObserver());


        new Thread(new Runnable() {
            @Override public void run() {
                Samba smb=new Samba();
                smb.getShare("smb://sf:sfsf123123@192.168.1.143/ffplay/");
            }
        }).start();


    }
    Net net=new Net();
    public Observer<List<Net.BingWallBean>> bingObserver() {
        Observer<List<Net.BingWallBean>> observer = new Observer<List<Net.BingWallBean>>() {
            Disposable dd;

            @Override
            public void onSubscribe(Disposable d) {
                //                d.dispose();//断开订阅关系；
                //                d.isDisposed();//判断是否还有订阅关系
                //                dd = d;
                Log.d(TAG, "onSubscribe: ");
            }

            @Override
            public void onNext(List<Net.BingWallBean> ll) {
                Log.d(TAG, "onNext: " + ll.size());
                bingAdapter=new BingAdapter(ll);
                rv.setAdapter(bingAdapter);
                bingAdapter.notifyDataSetChanged();
            }

            @Override
            public void onError(Throwable e) {
                Log.d(TAG, "onError: ");
            }

            @Override
            public void onComplete() {
                Log.d(TAG, "onComplete: ");
            }
        };
        return observer;
    }

    public class BingAdapter extends RecyclerView.Adapter<BingViewHolder> {

        private List<Net.BingWallBean> data = null;

        public BingAdapter(List<Net.BingWallBean> data) {
            Logger.d("BingAdapter");
            this.data = data;
        }

        @Override
        public BingViewHolder onCreateViewHolder(ViewGroup viewGroup, int viewType) {
            Logger.d("onCreateViewHolder");
            View view = LayoutInflater.from(viewGroup.getContext()).inflate(
                R.layout.card_view, null);
            //view.setLayoutParams(new RecyclerView.LayoutParams(500,500));
            BingViewHolder bingViewHolder = new BingViewHolder(view);
            return bingViewHolder;
        }

        @Override
        public int getItemViewType(int position) {
            Logger.d("getItemViewType");
            return super.getItemViewType(position);
        }

        @Override
        public void onBindViewHolder(BingViewHolder viewHolder, int position) {

            viewHolder.position = position;
            Net.BingWallBean s = data.get(position);
            viewHolder.text.setText(s.getCopyright());
            Logger.d("onBindViewHolder "+net.getBASE_URL()+ s.getUrl());
            Glide.with(MainActivity.this).load(net.getBASE_URL()+ s.getUrl()).into(viewHolder.img);
        }

        @Override
        public int getItemCount() {
            return data.size();
        }
    }

    private class BingViewHolder extends RecyclerView.ViewHolder {
        public ImageView img;
        public TextView text;

        // 埋入一个值position,记录在RecyclerView的位置。
        private int position;

        public BingViewHolder(View itemView) {
            super(itemView);

            // 为RecyclerView的子item增加点击事件。
            itemView.setOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(View v) {
                    Toast.makeText(getApplicationContext(), "点击:" + position,
                        Toast.LENGTH_SHORT).show();
                }
            });

            img = (ImageView) itemView.findViewById(R.id.img);
            img.setImageResource(R.drawable.leak_canary_icon);
            //img.setBackgroundColor(Color.RED);
            //img.setLayoutParams(new RelativeLayout.LayoutParams(300,400));
            text = (TextView) itemView.findViewById(R.id.txt);
        }
    }
}
