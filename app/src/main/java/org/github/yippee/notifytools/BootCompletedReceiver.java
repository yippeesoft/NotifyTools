package org.github.yippee.notifytools;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import org.github.yippee.notifytools.utils.Logs;

/**
 * Created by sf on 2017/1/6.
 */


public class BootCompletedReceiver extends BroadcastReceiver {
    Logs log= Logs.getLogger(BootCompletedReceiver.class);
    @Override
    public void onReceive(Context context, Intent intent) {
        log.d( "recevie boot completed ... ");
        context.startService(new Intent(context, NotifyService.class));
    }
}