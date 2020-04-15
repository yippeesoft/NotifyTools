package cn.vip.ldcr;

import android.view.MotionEvent;
import android.view.View;

/* compiled from: SDLActivity */
class SDLGenericMotionListener_API12 implements View.OnGenericMotionListener {
    SDLGenericMotionListener_API12() {
    }

    public boolean onGenericMotion(View v, MotionEvent event) {
        return SDLActivity.handleJoystickMotionEvent(event);
    }
}
