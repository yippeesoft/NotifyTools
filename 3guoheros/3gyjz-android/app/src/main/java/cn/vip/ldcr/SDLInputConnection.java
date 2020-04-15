package cn.vip.ldcr;

import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.BaseInputConnection;

/* compiled from: SDLActivity */
class SDLInputConnection extends BaseInputConnection {
    public native void nativeCommitText(String str, int i);

    public native void nativeSetComposingText(String str, int i);

    public SDLInputConnection(View targetView, boolean fullEditor) {
        super(targetView, fullEditor);
    }

    public boolean sendKeyEvent(KeyEvent event) {
        int keyCode = event.getKeyCode();
        if (event.getAction() == 0) {
            if (event.isPrintingKey()) {
                commitText(String.valueOf((char) event.getUnicodeChar()), 1);
            }
            SDLActivity.onNativeKeyDown(keyCode);
            return true;
        } else if (event.getAction() != 1) {
            return super.sendKeyEvent(event);
        } else {
            SDLActivity.onNativeKeyUp(keyCode);
            return true;
        }
    }

    public boolean commitText(CharSequence text, int newCursorPosition) {
        nativeCommitText(text.toString(), newCursorPosition);
        return super.commitText(text, newCursorPosition);
    }

    public boolean setComposingText(CharSequence text, int newCursorPosition) {
        nativeSetComposingText(text.toString(), newCursorPosition);
        return super.setComposingText(text, newCursorPosition);
    }

    public boolean deleteSurroundingText(int beforeLength, int afterLength) {
        if (beforeLength != 1 || afterLength != 0) {
            return super.deleteSurroundingText(beforeLength, afterLength);
        }
        if (!super.sendKeyEvent(new KeyEvent(0, 67)) || !super.sendKeyEvent(new KeyEvent(1, 67))) {
            return false;
        }
        return true;
    }
}
