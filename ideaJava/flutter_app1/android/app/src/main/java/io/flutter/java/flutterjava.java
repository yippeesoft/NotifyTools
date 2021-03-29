package io.flutter.java

import android.os.Bundle;
import android.widget.Toast;

import java.util.Random;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "cn.mrlong.flutterplayer/plugin";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, Result result) {
                if (call.method.equals("dataInteraction")) {
                    //获取来自于Flutter的数据
                    if (null != call.arguments)
                        Toast.makeText(MainActivity.this, "Java收到：" + call.arguments.toString(), Toast.LENGTH_SHORT).show();
                    int data = getData();
                    //返回数据
                    result.success("来源java平台：" + data);
                } else {
                    result.notImplemented();
                }
            }
        });

        GeneratedPluginRegistrant.registerWith(this);
    }

    private int getData() {
        Random random = new Random();
        return random.nextInt(1000);
    }
}
