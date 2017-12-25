package org.yippeesoft.java_js_2screen;

import android.annotation.TargetApi;
import android.app.Presentation;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.hardware.display.DisplayManager;
import android.media.MediaPlayer;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.AttributeSet;
import android.util.Log;
import android.view.Display;
import android.view.WindowManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.VideoView;

import android.annotation.TargetApi;
import android.app.Presentation;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.hardware.display.DisplayManager;

import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.util.AttributeSet;
import android.util.Log;
import android.view.Display;
import android.view.View;
import android.view.WindowManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.VideoView;

public class MainActivity extends AppCompatActivity {
    String TAG="MainActivity";


    public class CustomVideoView extends VideoView {
        public CustomVideoView(Context context) {
            super(context);
        }

        public CustomVideoView(Context context, AttributeSet attrs) {
            super(context, attrs);
        }

        public CustomVideoView(Context context, AttributeSet attrs, int defStyleAttr) {
            super(context, attrs, defStyleAttr);
        }

        @TargetApi(21)
        public CustomVideoView(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
            super(context, attrs, defStyleAttr, defStyleRes);
        }

        @Override
        protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
            int width;
            int height;
//        int widthSpecMode = MeasureSpec.getMode(widthMeasureSpec);
            int widthSpecSize = MeasureSpec.getSize(widthMeasureSpec);
//        int heightSpecMode = MeasureSpec.getMode(heightMeasureSpec);
            int heightSpecSize = MeasureSpec.getSize(heightMeasureSpec);
            width = widthSpecSize;
            height = heightSpecSize;
            setMeasuredDimension(width, height);
        }
    }
    public class JSBridge {
        @JavascriptInterface
        public void jsMessage(String message) {
            Log.i(TAG, "jsMessage" + message);
            Toast.makeText(MainActivity.this,message,Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        final CustomVideoView vv=new CustomVideoView(this );
        RelativeLayout rlmain=new RelativeLayout(this );
        rlmain.setBackgroundColor(Color.RED);

        final   String JS_FUNCTION =
                " function jsFun(msg) {\n" +
                        "          alert(\"jsFun...\" + msg); " +
                        "           } ";
        final WebView webView=new WebView(this);
        this.setContentView(webView);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.setWebChromeClient(new WebChromeClient() {});
        webView.loadUrl("file:///sdcard/1.html");
        webView.addJavascriptInterface(new JSBridge(),"slack");

        webView.setWebViewClient(new WebViewClient(){
            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                webView.loadUrl("javascript:" + JS_FUNCTION);//注入js函数

                webView.loadUrl("javascript:doHelp()");//调用js函数
            }
        });

        vv.setVideoPath("/sdcard/1.mp4");

        vv.start();
        vv.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
            @Override
            public void onCompletion(MediaPlayer mp) {
                vv.start();
            }
        });



        DisplayManager mDisplayManager;//屏幕管理类

        Display[]  displays;//屏幕数组

        mDisplayManager = (DisplayManager)getSystemService(Context.DISPLAY_SERVICE);

        displays =mDisplayManager.getDisplays();

        if(displays.length>1) {
            Log.d(TAG, "displays " + displays[1].toString());


            DifferentDislay mPresentation = new DifferentDislay(this, displays[1]);//displays[1]是副屏

            mPresentation.getWindow().setType(

                    WindowManager.LayoutParams.TYPE_SYSTEM_ALERT);

            mPresentation.show();
        }

    }

    private class DifferentDislay extends Presentation {

        public DifferentDislay(Context outerContext, Display display) {

            super(outerContext,display);

            //TODOAuto-generated constructor stub

        }

        @Override

        protected void onCreate(Bundle savedInstanceState) {

            super.onCreate(savedInstanceState);
            setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);//强制竖屏
            final VideoView vv=new VideoView(this.getContext());
            RelativeLayout rlmain=new RelativeLayout(this.getContext());
            this.setContentView(vv);
            TextView txt=new TextView(rlmain.getContext());
            rlmain.addView(txt);
            txt.setText("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
//            rlmain.setBackgroundColor(Color.RED);
            vv.setVideoPath("/sdcard/mwwyt.mpg");
            vv.start();

            vv.setOnCompletionListener(new MediaPlayer.OnCompletionListener() {
                @Override
                public void onCompletion(MediaPlayer mp) {
                    vv.start();
                }
            });


        }

    }
}
