package com.classic.clearprocesses;

import android.content.Context;

import com.classic.adapter.BaseAdapterHelper;
import com.classic.adapter.CommonRecyclerAdapter;

import org.github.yippee.notifytools.R;

import java.util.List;

import io.reactivex.Observer;
import io.reactivex.annotations.NonNull;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.Consumer;


/**
 * 应用名称: ClearProcesses
 * 包 名 称: com.classic.clearprocesses
 *
 * 文件描述: TODO
 * 创 建 人: 续写经典
 * 创建时间: 2016/7/25 18:05
 */
public class PackageAdapter extends CommonRecyclerAdapter<String>   {

    public PackageAdapter(Context context) {
        super(context, R.layout.item_app_info);
    }

    @Override public void onUpdate(BaseAdapterHelper helper, String item, int position) {
        helper.setText(R.id.item_pkg, item);
    }




}
