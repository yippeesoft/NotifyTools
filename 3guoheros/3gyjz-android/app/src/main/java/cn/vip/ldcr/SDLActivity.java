package cn.vip.ldcr;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.util.DisplayMetrics;
import android.util.Log;
import android.util.SparseArray;
import android.view.InputDevice;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.Surface;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.inputmethod.InputMethodManager;
import android.widget.AbsoluteLayout;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class SDLActivity extends Activity {
    static final int COMMAND_CHANGE_TITLE = 1;
    static final int COMMAND_SET_KEEP_SCREEN_ON = 5;
    static final int COMMAND_TEXTEDIT_HIDE = 3;
    static final int COMMAND_UNUSED = 2;
    protected static final int COMMAND_USER = 32768;
    private static final String TAG = "SDL";
    protected static AudioTrack mAudioTrack;
    public static boolean mBrokenLibraries;
    public static boolean mExitCalledFromJava;
    public static boolean mHasFocus;
    public static boolean mIsPaused;
    public static boolean mIsSurfaceReady;
    protected static SDLJoystickHandler mJoystickHandler;
    protected static ViewGroup mLayout;
    protected static Thread mSDLThread;
    protected static SDLActivity mSingleton;
    protected static SDLSurface mSurface;
    protected static View mTextEdit;
    Handler commandHandler = new SDLCommandHandler();
    protected int dialogs = 0;
    private Object expansionFile;
    private Method expansionFileMethod;
    protected final int[] messageboxSelection = new int[1];

    public static native int nativeAddJoystick(int i, String str, int i2, int i3, int i4, int i5, int i6);

    private native void nativeCustomPaused();

    private native void nativeCustomResume();

    public static native void nativeFlipBuffers();

    public static native String nativeGetHint(String str);

    public static native int nativeInit(Object obj);

    public static native void nativeLowMemory();

    public static native void nativePause();

    public static native void nativeQuit();

    public static native int nativeRemoveJoystick(int i);

    public static native void nativeResume();

    /* access modifiers changed from: private */
    public native void nativeSetGamePath(String str);

    private native void nativeSetResolution(int i, int i2);

    private native void nativeSetVolume(int i);

    public static native void onNativeAccel(float f, float f2, float f3);

    public static native void onNativeHat(int i, int i2, int i3, int i4);

    public static native void onNativeJoy(int i, int i2, float f);

    public static native void onNativeKeyDown(int i);

    public static native void onNativeKeyUp(int i);

    public static native void onNativeKeyboardFocusLost();

    public static native int onNativePadDown(int i, int i2);

    public static native int onNativePadUp(int i, int i2);

    public static native void onNativeResize(int i, int i2, int i3);

    public static native void onNativeSurfaceChanged();

    public static native void onNativeSurfaceDestroyed();

    public static native void onNativeTouch(int i, int i2, int i3, float f, float f2, float f3);

    /* access modifiers changed from: protected */
    public String[] getLibraries() {
        return new String[]{"SDL2", "SDL2_image", "SDL2_ttf", "lua", "bass", "bassmidi", "main"};
    }

    public void loadLibraries() {
        for (String lib : getLibraries()) {
            System.loadLibrary(lib);
        }
    }

    /* access modifiers changed from: protected */
    public String[] getArguments() {
        return new String[0];
    }

    public static void initialize() {
        mSingleton = null;
        mSurface = null;
        mTextEdit = null;
        mLayout = null;
//        mJoystickHandler = null;
        mSDLThread = null;
        mAudioTrack = null;
        mExitCalledFromJava = false;
        mBrokenLibraries = false;
        mIsPaused = false;
        mIsSurfaceReady = false;
        mHasFocus = true;
    }

    /* access modifiers changed from: protected */
    public void onCreate(Bundle savedInstanceState) {
        Log.v(TAG, "onCreate():" + mSingleton);
        super.onCreate(savedInstanceState);
        setRequestedOrientation(0);
        initialize();
        mSingleton = this;
        String errorMsgBrokenLib = "";
        try {
            loadLibraries();
            DisplayMetrics dm = new DisplayMetrics();
            getWindowManager().getDefaultDisplay().getMetrics(dm);
            nativeSetResolution(dm.widthPixels, dm.heightPixels);
        } catch (UnsatisfiedLinkError e) {
            System.err.println(e.getMessage());
            mBrokenLibraries = true;
            errorMsgBrokenLib = e.getMessage();
        } catch (Exception e2) {
            System.err.println(e2.getMessage());
            mBrokenLibraries = true;
            errorMsgBrokenLib = e2.getMessage();
        }
        if (mBrokenLibraries) {
            AlertDialog.Builder dlgAlert = new AlertDialog.Builder(this);
            dlgAlert.setMessage("An error occurred while trying to start the application. Please try again and/or reinstall." + System.getProperty("line.separator") + System.getProperty("line.separator") + "Error: " + errorMsgBrokenLib);
            dlgAlert.setTitle("SDL Error");
            dlgAlert.setPositiveButton("Exit", new DialogInterface.OnClickListener() {
                public void onClick(DialogInterface dialog, int id) {
                    SDLActivity.mSingleton.finish();
                }
            });
            dlgAlert.setCancelable(false);
            dlgAlert.create().show();
            return;
        }
        mSurface = new SDLSurface(getApplication());
//        if (Build.VERSION.SDK_INT >= 12) {
            mJoystickHandler = new SDLJoystickHandler_API12();
//        } else {
//            mJoystickHandler = new SDLJoystickHandler();
//        }
        mLayout = new AbsoluteLayout(this);
        mLayout.addView(mSurface);
        setContentView(mLayout);
        try {
            List<String> list = new ArrayList<>();
            File file = new File("/sdcard");
            if (file.exists() && file.canRead()) {
                File[] files = file.listFiles();
                int length = files.length;
                for (int i = 0; i < length; i++) {
                    File f = files[i];
                    if (f.canRead() && f.isDirectory() && f.getName().indexOf("JY_LLK") >= 0) {
                        list.add(f.getName());
                    }
                }
            }
            if (list.size() == 1) {
                nativeSetGamePath("/sdcard/" + list.get(0) + "/");
            } else if (list.size() > 1) {
                List<String> gameList = new ArrayList<>();
                for (String s : list) {
                    int index = s.indexOf("_");
                    if (index > 0) {
                        gameList.add(s.substring(index + 1));
                    } else {
                        gameList.add("JY_LLK_");
                    }
                }
                Handler r0 = new Handler() {
                    public void handleMessage(Message msg) {
                        throw new RuntimeException();
                    }
                };
                AlertDialog.Builder builder = new AlertDialog.Builder(this);
                builder.setTitle("JY_LLK, please select");
                final List<String> list2 = list;
                final Handler r3 = r0;
                builder.setItems((CharSequence[]) gameList.toArray(new String[gameList.size()]), new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        SDLActivity.this.nativeSetGamePath("/sdcard/" + ((String) list2.get(which)) + "/");
                        r3.sendMessage(Message.obtain());
                    }
                });
                builder.setCancelable(false);
                builder.create().show();
                Looper.loop();
            }
        } catch (RuntimeException e3) {
            e3.printStackTrace();
        }
        AudioManager am = (AudioManager) getSystemService("audio");
        int value = (am.getStreamVolume(3) * 100) / am.getStreamMaxVolume(3);
        nativeSetVolume(value);
        Log.v("jy", "music = " + value);
    }

    /* access modifiers changed from: protected */
    public void onPause() {
        Log.v(TAG, "onPause()");
        super.onPause();
        if (!mBrokenLibraries) {
            handlePause();
            nativeCustomPaused();
        }
    }

    /* access modifiers changed from: protected */
    public void onResume() {
        Log.v(TAG, "onResume()");
        super.onResume();
        if (!mBrokenLibraries) {
            handleResume();
            nativeCustomResume();
        }
    }

    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        Log.v(TAG, "onWindowFocusChanged(): " + hasFocus);
        if (!mBrokenLibraries) {
            mHasFocus = hasFocus;
            if (hasFocus) {
                handleResume();
            }
        }
    }

    public void onLowMemory() {
        Log.v(TAG, "onLowMemory()");
        super.onLowMemory();
        if (!mBrokenLibraries) {
            nativeLowMemory();
        }
    }

    /* access modifiers changed from: protected */
    public void onDestroy() {
        Log.v(TAG, "onDestroy()");
        if (mBrokenLibraries) {
            super.onDestroy();
            initialize();
            return;
        }
        mExitCalledFromJava = true;
        nativeQuit();
        if (mSDLThread != null) {
            try {
                mSDLThread.join();
            } catch (Exception e) {
                Log.v(TAG, "Problem stopping thread: " + e);
            }
            mSDLThread = null;
        }
        super.onDestroy();
        initialize();
    }

    public boolean dispatchKeyEvent(KeyEvent event) {
        int keyCode;
        if (mBrokenLibraries || (keyCode = event.getKeyCode()) == 25 || keyCode == 24 || keyCode == 27 || keyCode == 168 || keyCode == 169) {
            return false;
        }
        return super.dispatchKeyEvent(event);
    }

    public static void handlePause() {
        if (!mIsPaused && mIsSurfaceReady) {
            mIsPaused = true;
            nativePause();
            mSurface.enableSensor(1, false);
        }
    }

    public static void handleResume() {
        if (mIsPaused && mIsSurfaceReady && mHasFocus) {
            mIsPaused = false;
            nativeResume();
            mSurface.handleResume();
        }
    }

    public static void handleNativeExit() {
        mSDLThread = null;
        mSingleton.finish();
    }

    /* access modifiers changed from: protected */
    public boolean onUnhandledMessage(int command, Object param) {
        return false;
    }

    protected static class SDLCommandHandler extends Handler {
        protected SDLCommandHandler() {
        }

        public void handleMessage(Message msg) {
            Context context = SDLActivity.getContext();
            if (context == null) {
                Log.e(SDLActivity.TAG, "error handling message, getContext() returned null");
                return;
            }
            switch (msg.arg1) {
                case 1:
                    if (context instanceof Activity) {
                        ((Activity) context).setTitle((String) msg.obj);
                        return;
                    } else {
                        Log.e(SDLActivity.TAG, "error handling message, getContext() returned no Activity");
                        return;
                    }
                case 3:
                    if (SDLActivity.mTextEdit != null) {
                        SDLActivity.mTextEdit.setVisibility(8);
                        ((InputMethodManager) context.getSystemService("input_method")).hideSoftInputFromWindow(SDLActivity.mTextEdit.getWindowToken(), 0);
                        return;
                    }
                    return;
                case 5:
                    Window window = ((Activity) context).getWindow();
                    if (window == null) {
                        return;
                    }
                    if (!(msg.obj instanceof Integer) || ((Integer) msg.obj).intValue() == 0) {
                        window.clearFlags(128);
                        return;
                    } else {
                        window.addFlags(128);
                        return;
                    }
                default:
                    if ((context instanceof SDLActivity) && !((SDLActivity) context).onUnhandledMessage(msg.arg1, msg.obj)) {
                        Log.e(SDLActivity.TAG, "error handling message, command is " + msg.arg1);
                        return;
                    }
                    return;
            }
        }
    }

    /* access modifiers changed from: package-private */
    public boolean sendCommand(int command, Object data) {
        Message msg = this.commandHandler.obtainMessage();
        msg.arg1 = command;
        msg.obj = data;
        return this.commandHandler.sendMessage(msg);
    }

    public static void flipBuffers() {
        nativeFlipBuffers();
    }

    public static boolean setActivityTitle(String title) {
        return mSingleton.sendCommand(1, title);
    }

    public static boolean sendMessage(int command, int param) {
        return mSingleton.sendCommand(command, Integer.valueOf(param));
    }

    public static Context getContext() {
        return mSingleton;
    }

    public Object getSystemServiceFromUiThread(final String name) {
        final Object lock = new Object();
        final Object[] results = new Object[2];
        synchronized (lock) {
            runOnUiThread(new Runnable() {
                public void run() {
                    synchronized (lock) {
                        results[0] = SDLActivity.this.getSystemService(name);
                        results[1] = Boolean.TRUE;
                        lock.notify();
                    }
                }
            });
            if (results[1] == null) {
                try {
                    lock.wait();
                } catch (InterruptedException ex) {
                    ex.printStackTrace();
                }
            }
        }
        return results[0];
    }

    static class ShowTextInputTask implements Runnable {
        static final int HEIGHT_PADDING = 15;
        public int h;
        public int w;
        public int x;
        public int y;

        public ShowTextInputTask(int x2, int y2, int w2, int h2) {
            this.x = x2;
            this.y = y2;
            this.w = w2;
            this.h = h2;
        }

        public void run() {
//            AbsoluteLayout.LayoutParams params = new AbsoluteLayout.LayoutParams(this.w, this.h + HEIGHT_PADDING, this.x, this.y);
//            if (SDLActivity.mTextEdit == null) {
//                SDLActivity.mTextEdit = new DummyEdit(SDLActivity.getContext());
//                SDLActivity.mLayout.addView(SDLActivity.mTextEdit, params);
//            } else {
//                SDLActivity.mTextEdit.setLayoutParams(params);
//            }
//            SDLActivity.mTextEdit.setVisibility(0);
//            SDLActivity.mTextEdit.requestFocus();
//            ((InputMethodManager) SDLActivity.getContext().getSystemService("input_method")).showSoftInput(SDLActivity.mTextEdit, 0);
        }
    }

    public static boolean showTextInput(int x, int y, int w, int h) {
        return mSingleton.commandHandler.post(new ShowTextInputTask(x, y, w, h));
    }

    public static Surface getNativeSurface() {
        return mSurface.getNativeSurface();
    }

    public static int audioInit(int sampleRate, boolean is16Bit, boolean isStereo, int desiredFrames) {
        int channelConfig;
        int audioFormat;
        int i;
        String str;
        if (isStereo) {
            channelConfig = 3;
        } else {
            channelConfig = 2;
        }
        if (is16Bit) {
            audioFormat = 2;
        } else {
            audioFormat = 3;
        }
        if (isStereo) {
            i = 2;
        } else {
            i = 1;
        }
        int frameSize = i * (is16Bit ? 2 : 1);
        StringBuilder append = new StringBuilder("SDL audio: wanted ").append(isStereo ? "stereo" : "mono").append(" ");
        if (is16Bit) {
            str = "16-bit";
        } else {
            str = "8-bit";
        }
        Log.v(TAG, append.append(str).append(" ").append(((float) sampleRate) / 1000.0f).append("kHz, ").append(desiredFrames).append(" frames buffer").toString());
        int desiredFrames2 = Math.max(desiredFrames, ((AudioTrack.getMinBufferSize(sampleRate, channelConfig, audioFormat) + frameSize) - 1) / frameSize);
        if (mAudioTrack == null) {
            mAudioTrack = new AudioTrack(3, sampleRate, channelConfig, audioFormat, desiredFrames2 * frameSize, 1);
            if (mAudioTrack.getState() != 1) {
                Log.e(TAG, "Failed during initialization of Audio Track");
                mAudioTrack = null;
                return -1;
            }
            mAudioTrack.play();
        }
        Log.v(TAG, "SDL audio: got " + (mAudioTrack.getChannelCount() >= 2 ? "stereo" : "mono") + " " + (mAudioTrack.getAudioFormat() == 2 ? "16-bit" : "8-bit") + " " + (((float) mAudioTrack.getSampleRate()) / 1000.0f) + "kHz, " + desiredFrames2 + " frames buffer");
        return 0;
    }

    public static void audioWriteShortBuffer(short[] buffer) {
        int i = 0;
        while (i < buffer.length) {
            int result = mAudioTrack.write(buffer, i, buffer.length - i);
            if (result > 0) {
                i += result;
            } else if (result == 0) {
                try {
                    Thread.sleep(1);
                } catch (InterruptedException e) {
                }
            } else {
                Log.w(TAG, "SDL audio: error return from write(short)");
                return;
            }
        }
    }

    public static void audioWriteByteBuffer(byte[] buffer) {
        int i = 0;
        while (i < buffer.length) {
            int result = mAudioTrack.write(buffer, i, buffer.length - i);
            if (result > 0) {
                i += result;
            } else if (result == 0) {
                try {
                    Thread.sleep(1);
                } catch (InterruptedException e) {
                }
            } else {
                Log.w(TAG, "SDL audio: error return from write(byte)");
                return;
            }
        }
    }

    public static void audioQuit() {
        if (mAudioTrack != null) {
            mAudioTrack.stop();
            mAudioTrack = null;
        }
    }

    public static int[] inputGetInputDeviceIds(int sources) {
        int[] ids = InputDevice.getDeviceIds();
        int[] filtered = new int[ids.length];
        int used = 0;
        for (int device : ids) {
            InputDevice device2 = InputDevice.getDevice(device);
            if (!(device2 == null || (device2.getSources() & sources) == 0)) {
                filtered[used] = device2.getId();
                used++;
            }
        }
        return Arrays.copyOf(filtered, used);
    }

    public static boolean handleJoystickMotionEvent(MotionEvent event) {
        return mJoystickHandler.handleMotionEvent(event);
    }

    public static void pollInputDevices() {
        if (mSDLThread != null) {
            mJoystickHandler.pollInputDevices();
        }
    }

    public InputStream openAPKExtensionInputStream(String fileName) throws IOException {
        InputStream fileStream;
        if (this.expansionFile == null) {
            Integer mainVersion = Integer.valueOf(nativeGetHint("SDL_ANDROID_APK_EXPANSION_MAIN_FILE_VERSION"));
            Integer patchVersion = Integer.valueOf(nativeGetHint("SDL_ANDROID_APK_EXPANSION_PATCH_FILE_VERSION"));
            try {
                this.expansionFile = Class.forName("com.android.vending.expansion.zipfile.APKExpansionSupport").getMethod("getAPKExpansionZipFile", new Class[]{Context.class, Integer.TYPE, Integer.TYPE}).invoke((Object) null, new Object[]{this, mainVersion, patchVersion});
                this.expansionFileMethod = this.expansionFile.getClass().getMethod("getInputStream", new Class[]{String.class});
            } catch (Exception ex) {
                ex.printStackTrace();
                this.expansionFile = null;
                this.expansionFileMethod = null;
            }
        }
        try {
            fileStream = (InputStream) this.expansionFileMethod.invoke(this.expansionFile, new Object[]{fileName});
        } catch (Exception ex2) {
            ex2.printStackTrace();
            fileStream = null;
        }
        if (fileStream != null) {
            return fileStream;
        }
        throw new IOException();
    }

    public int messageboxShowMessageBox(int flags, String title, String message, int[] buttonFlags, int[] buttonIds, String[] buttonTexts, int[] colors) {
        this.messageboxSelection[0] = -1;
        if (buttonFlags.length != buttonIds.length && buttonIds.length != buttonTexts.length) {
            return -1;
        }
        final Bundle args = new Bundle();
        args.putInt("flags", flags);
        args.putString("title", title);
        args.putString("message", message);
        args.putIntArray("buttonFlags", buttonFlags);
        args.putIntArray("buttonIds", buttonIds);
        args.putStringArray("buttonTexts", buttonTexts);
        args.putIntArray("colors", colors);
        runOnUiThread(new Runnable() {
            public void run() {
                SDLActivity sDLActivity = SDLActivity.this;
                SDLActivity sDLActivity2 = SDLActivity.this;
                int i = sDLActivity2.dialogs;
                sDLActivity2.dialogs = i + 1;
                sDLActivity.showDialog(i, args);
            }
        });
        synchronized (this.messageboxSelection) {
            try {
                this.messageboxSelection.wait();
            } catch (InterruptedException ex) {
                ex.printStackTrace();
                return -1;
            }
        }
        return this.messageboxSelection[0];
    }

    /* access modifiers changed from: protected */
    public Dialog onCreateDialog(int ignore, Bundle args) {
        int backgroundColor;
        int textColor;
        int buttonBackgroundColor;
        int[] colors = args.getIntArray("colors");
        if (colors != null) {
            int i = -1 + 1;
            backgroundColor = colors[i];
            int i2 = i + 1;
            textColor = colors[i2];
            int i3 = i2 + 1;
            int i4 = colors[i3];
            int i5 = i3 + 1;
            buttonBackgroundColor = colors[i5];
            int i6 = colors[i5 + 1];
        } else {
            backgroundColor = 0;
            textColor = 0;
            buttonBackgroundColor = 0;
        }
        final Dialog dialog = new Dialog(this);
        dialog.setTitle(args.getString("title"));
        dialog.setCancelable(false);
        dialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
            public void onDismiss(DialogInterface unused) {
                synchronized (SDLActivity.this.messageboxSelection) {
                    SDLActivity.this.messageboxSelection.notify();
                }
            }
        });
        TextView textView = new TextView(this);
        textView.setGravity(17);
        textView.setText(args.getString("message"));
        if (textColor != 0) {
            textView.setTextColor(textColor);
        }
        int[] buttonFlags = args.getIntArray("buttonFlags");
        int[] buttonIds = args.getIntArray("buttonIds");
        String[] buttonTexts = args.getStringArray("buttonTexts");
        SparseArray<Button> mapping = new SparseArray<>();
        LinearLayout buttons = new LinearLayout(this);
        buttons.setOrientation(0);
        buttons.setGravity(17);
        for (int i7 = 0; i7 < buttonTexts.length; i7++) {
            Button button = new Button(this);
            final int i8 = buttonIds[i7];
            button.setOnClickListener(new View.OnClickListener() {
                public void onClick(View v) {
                    SDLActivity.this.messageboxSelection[0] = i8;
                    dialog.dismiss();
                }
            });
            if (buttonFlags[i7] != 0) {
                if ((buttonFlags[i7] & 1) != 0) {
                    mapping.put(66, button);
                }
                if ((buttonFlags[i7] & 2) != 0) {
                    mapping.put(111, button);
                }
            }
            button.setText(buttonTexts[i7]);
            if (textColor != 0) {
                button.setTextColor(textColor);
            }
            if (buttonBackgroundColor != 0) {
                Drawable drawable = button.getBackground();
                if (drawable == null) {
                    button.setBackgroundColor(buttonBackgroundColor);
                } else {
                    drawable.setColorFilter(buttonBackgroundColor, PorterDuff.Mode.MULTIPLY);
                }
            }
            buttons.addView(button);
        }
        LinearLayout content = new LinearLayout(this);
        content.setOrientation(1);
        content.addView(textView);
        content.addView(buttons);
        if (backgroundColor != 0) {
            content.setBackgroundColor(backgroundColor);
        }
        dialog.setContentView(content);
        final SparseArray<Button> sparseArray = mapping;
        dialog.setOnKeyListener(new DialogInterface.OnKeyListener() {
            public boolean onKey(DialogInterface d, int keyCode, KeyEvent event) {
                Button button = (Button) sparseArray.get(keyCode);
                if (button == null) {
                    return false;
                }
                if (event.getAction() != 1) {
                    return true;
                }
                button.performClick();
                return true;
            }
        });
        return dialog;
    }
}