package cn.vip.ldcr;

import android.content.Context;
import android.graphics.Canvas;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Build;
import android.os.Handler;
import android.support.v4.view.MotionEventCompat;
import android.util.Log;
import android.view.Display;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.WindowManager;

/* compiled from: SDLActivity */
class SDLSurface extends SurfaceView implements SurfaceHolder.Callback, View.OnKeyListener, View.OnTouchListener, SensorEventListener {
    protected static Display mDisplay;
    protected static float mHeight;
    protected static SensorManager mSensorManager;
    protected static float mWidth;

    public SDLSurface(Context context) {
        super(context);
        getHolder().addCallback(this);
        setFocusable(true);
        setFocusableInTouchMode(true);
        requestFocus();
        setOnKeyListener(this);
        setOnTouchListener(this);
        mDisplay = ((WindowManager) context.getSystemService("window")).getDefaultDisplay();
        mSensorManager = (SensorManager) context.getSystemService("sensor");
        if (Build.VERSION.SDK_INT >= 12) {
            setOnGenericMotionListener(new SDLGenericMotionListener_API12());
        }
        mWidth = 1.0f;
        mHeight = 1.0f;
    }

    public void handleResume() {
        setFocusable(true);
        setFocusableInTouchMode(true);
        requestFocus();
        setOnKeyListener(this);
        setOnTouchListener(this);
        enableSensor(1, true);
    }

    public Surface getNativeSurface() {
        return getHolder().getSurface();
    }

    public void surfaceCreated(SurfaceHolder holder) {
        Log.v("SDL", "surfaceCreated()");
        holder.setType(2);
    }

    public void surfaceDestroyed(SurfaceHolder holder) {
        Log.v("SDL", "surfaceDestroyed()");
        SDLActivity.handlePause();
        SDLActivity.mIsSurfaceReady = false;
        SDLActivity.onNativeSurfaceDestroyed();
    }

    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
        Log.v("SDL", "surfaceChanged()");
        int sdlFormat = 353701890;
        switch (format) {
            case 1:
                Log.v("SDL", "pixel format RGBA_8888");
                sdlFormat = 373694468;
                break;
            case 2:
                Log.v("SDL", "pixel format RGBX_8888");
                sdlFormat = 371595268;
                break;
            case 3:
                Log.v("SDL", "pixel format RGB_888");
                sdlFormat = 370546692;
                break;
            case 4:
                Log.v("SDL", "pixel format RGB_565");
                sdlFormat = 353701890;
                break;
            case 6:
                Log.v("SDL", "pixel format RGBA_5551");
                sdlFormat = 356782082;
                break;
            case MotionEventCompat.ACTION_HOVER_MOVE /*7*/:
                Log.v("SDL", "pixel format RGBA_4444");
                sdlFormat = 356651010;
                break;
            case 8:
                Log.v("SDL", "pixel format A_8");
                break;
            case MotionEventCompat.ACTION_HOVER_ENTER /*9*/:
                Log.v("SDL", "pixel format L_8");
                break;
            case MotionEventCompat.ACTION_HOVER_EXIT /*10*/:
                Log.v("SDL", "pixel format LA_88");
                break;
            case 11:
                Log.v("SDL", "pixel format RGB_332");
                sdlFormat = 336660481;
                break;
            default:
                Log.v("SDL", "pixel format unknown " + format);
                break;
        }
        mWidth = (float) width;
        mHeight = (float) height;
        SDLActivity.onNativeResize(width, height, sdlFormat);
        Log.v("SDL", "Window size:" + width + "x" + height);
        SDLActivity.mIsSurfaceReady = true;
        SDLActivity.onNativeSurfaceChanged();
        if (SDLActivity.mSDLThread == null) {
            final Thread sdlThread = new Thread(new SDLMain(), "SDLThread");
            enableSensor(1, true);
            sdlThread.start();
            SDLActivity.mSDLThread = new Thread(new Runnable() {
                public void run() {
                    try {
                        sdlThread.join();
                        if (!SDLActivity.mExitCalledFromJava) {
                            SDLActivity.handleNativeExit();
                        }
                    } catch (Exception e) {
                        if (!SDLActivity.mExitCalledFromJava) {
                            SDLActivity.handleNativeExit();
                        }
                    } catch (Throwable th) {
                        if (!SDLActivity.mExitCalledFromJava) {
                            SDLActivity.handleNativeExit();
                        }
                        throw th;
                    }
                }
            }, "SDLThreadListener");
            SDLActivity.mSDLThread.start();
        }
    }

    public void onDraw(Canvas canvas) {
    }

    public boolean onKey(View v, int keyCode, KeyEvent event) {
        if (!((event.getSource() & 1025) == 0 && (event.getSource() & 513) == 0)) {
            if (event.getAction() == 0) {
                if (SDLActivity.onNativePadDown(event.getDeviceId(), keyCode) == 0) {
                    return true;
                }
            } else if (event.getAction() == 1 && SDLActivity.onNativePadUp(event.getDeviceId(), keyCode) == 0) {
                return true;
            }
        }
        if ((event.getSource() & 257) != 0) {
            if (event.getAction() == 0) {
                SDLActivity.onNativeKeyDown(keyCode);
                return true;
            } else if (event.getAction() == 1) {
                SDLActivity.onNativeKeyUp(keyCode);
                return true;
            }
        }
        return false;
    }

    public boolean onTouch(View v, MotionEvent event) {
        int touchDevId = event.getDeviceId();
        int pointerCount = event.getPointerCount();
        int action = event.getActionMasked();
        int i = -1;

        Log.d("sf","onTouch "+event.toString()+" "+action);
        switch (action) {
            case 0:
            case 1:
                i = 0;
                break;
            case 2:
                for (int i2 = 0; i2 < pointerCount; i2++) {
                    SDLActivity.onNativeTouch(touchDevId, event.getPointerId(i2), action, event.getX(i2) / mWidth, event.getY(i2) / mHeight, event.getPressure(i2));
                }
                return true;
            case 3:
                for (int i3 = 0; i3 < pointerCount; i3++) {
                    SDLActivity.onNativeTouch(touchDevId, event.getPointerId(i3), 1, event.getX(i3) / mWidth, event.getY(i3) / mHeight, event.getPressure(i3));
                }
                return true;
            case 5:
            case 6:
                break;
            default:
                return true;
        }
        if (i == -1) {
            i = event.getActionIndex();
        }
        SDLActivity.onNativeTouch(touchDevId, event.getPointerId(i), action, event.getX(i) / mWidth, event.getY(i) / mHeight, event.getPressure(i));
        return true;
    }

    public void enableSensor(int sensortype, boolean enabled) {
        if (enabled) {
            mSensorManager.registerListener(this, mSensorManager.getDefaultSensor(sensortype), 1, (Handler) null);
        } else {
            mSensorManager.unregisterListener(this, mSensorManager.getDefaultSensor(sensortype));
        }
    }

    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }

    public void onSensorChanged(SensorEvent event) {
        float x;
        float y;
        if (event.sensor.getType() == 1) {
            switch (mDisplay.getRotation()) {
                case 1:
                    x = -event.values[1];
                    y = event.values[0];
                    break;
                case 2:
                    x = -event.values[1];
                    y = -event.values[0];
                    break;
                case 3:
                    x = event.values[1];
                    y = -event.values[0];
                    break;
                default:
                    x = event.values[0];
                    y = event.values[1];
                    break;
            }
            SDLActivity.onNativeAccel((-x) / 9.80665f, y / 9.80665f, (event.values[2] / 9.80665f) - 1.0f);
        }
    }

    class SDLGenericMotionListener_API12 implements View.OnGenericMotionListener {
        SDLGenericMotionListener_API12() {
        }

        public boolean onGenericMotion(View v, MotionEvent event) {
            return true;//SDLActivity.handleJoystickMotionEvent(event);
        }
    }

    class SDLMain implements Runnable {
        SDLMain() {
        }

        public void run() {
            SDLActivity.nativeInit(SDLActivity.mSingleton.getArguments());
        }
    }
}