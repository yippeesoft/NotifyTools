package cn.vip.ldcr;

import android.content.Context;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputConnection;

/* compiled from: SDLActivity */
class DummyEdit extends View implements View.OnKeyListener {
    InputConnection ic;

    public DummyEdit(Context context) {
        super(context);
        setFocusableInTouchMode(true);
        setFocusable(true);
        setOnKeyListener(this);
    }

    public boolean onCheckIsTextEditor() {
        return true;
    }

    public boolean onKey(View v, int keyCode, KeyEvent event) {
        if (event.isPrintingKey()) {
            if (event.getAction() != 0) {
                return true;
            }
            this.ic.commitText(String.valueOf((char) event.getUnicodeChar()), 1);
            return true;
        } else if (event.getAction() == 0) {
            SDLActivity.onNativeKeyDown(keyCode);
            return true;
        } else if (event.getAction() != 1) {
            return false;
        } else {
            SDLActivity.onNativeKeyUp(keyCode);
            return true;
        }
    }

    public boolean onKeyPreIme(int keyCode, KeyEvent event) {
        if (event.getAction() == 1 && keyCode == 4 && SDLActivity.mTextEdit != null && SDLActivity.mTextEdit.getVisibility() == 0) {
            SDLActivity.onNativeKeyboardFocusLost();
        }
        return super.onKeyPreIme(keyCode, event);
    }

    public InputConnection onCreateInputConnection(EditorInfo outAttrs) {
        this.ic = new SDLInputConnection(this, true);
        outAttrs.imeOptions = 301989888;
        return this.ic;
    }
}
