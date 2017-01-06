package org.github.yippee.notifytools;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import org.github.yippee.notifytools.utils.Logs;

public class MainActivity extends AppCompatActivity {
    private Logs log = Logs.getLogger(this.getClass());
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        log.d("oncreate ");
        setContentView(R.layout.activity_main);
        startService(new Intent(this, NotifyService.class));
    }
}
