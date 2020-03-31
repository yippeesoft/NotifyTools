package cn.vip.ldcr;

import android.view.InputDevice;
import android.view.InputDevice.MotionRange;
import android.view.MotionEvent;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/* compiled from: SDLActivity */
class SDLJoystickHandler_API12 extends SDLJoystickHandler {
    private ArrayList<SDLJoystick> mJoysticks = new ArrayList<>();

    /* compiled from: SDLActivity */
    static class RangeComparator implements Comparator<MotionRange> {
        RangeComparator() {
        }

        public int compare(MotionRange arg0, MotionRange arg1) {
            return arg0.getAxis() - arg1.getAxis();
        }
    }

    /* compiled from: SDLActivity */
    static class SDLJoystick {
        public ArrayList<MotionRange> axes;
        public int device_id;
        public ArrayList<MotionRange> hats;
        public String name;

        SDLJoystick() {
        }
    }

    public void pollInputDevices() {
        int[] deviceIds = InputDevice.getDeviceIds();
        for (int i = deviceIds.length - 1; i > -1; i--) {
            if (getJoystick(deviceIds[i]) == null) {
                SDLJoystick joystick = new SDLJoystick();
                InputDevice joystickDevice = InputDevice.getDevice(deviceIds[i]);
                if ((joystickDevice.getSources() & 16) != 0) {
                    joystick.device_id = deviceIds[i];
                    joystick.name = joystickDevice.getName();
                    joystick.axes = new ArrayList<>();
                    joystick.hats = new ArrayList<>();
                    List<MotionRange> ranges = joystickDevice.getMotionRanges();
                    Collections.sort(ranges, new RangeComparator());
                    for (MotionRange range : ranges) {
                        if ((range.getSource() & 16) != 0) {
                            if (range.getAxis() == 15 || range.getAxis() == 16) {
                                joystick.hats.add(range);
                            } else {
                                joystick.axes.add(range);
                            }
                        }
                    }
                    this.mJoysticks.add(joystick);
                    SDLActivity.nativeAddJoystick(joystick.device_id, joystick.name, 0, -1, joystick.axes.size(), joystick.hats.size() / 2, 0);
                }
            }
        }
        ArrayList<Integer> removedDevices = new ArrayList<>();
        for (int i2 = 0; i2 < this.mJoysticks.size(); i2++) {
            int device_id = ((SDLJoystick) this.mJoysticks.get(i2)).device_id;
            int j = 0;
            while (j < deviceIds.length && device_id != deviceIds[j]) {
                j++;
            }
            if (j == deviceIds.length) {
                removedDevices.add(Integer.valueOf(device_id));
            }
        }
        for (int i3 = 0; i3 < removedDevices.size(); i3++) {
            int device_id2 = ((Integer) removedDevices.get(i3)).intValue();
            SDLActivity.nativeRemoveJoystick(device_id2);
            int j2 = 0;
            while (true) {
                if (j2 >= this.mJoysticks.size()) {
                    break;
                } else if (((SDLJoystick) this.mJoysticks.get(j2)).device_id == device_id2) {
                    this.mJoysticks.remove(j2);
                    break;
                } else {
                    j2++;
                }
            }
        }
    }

    /* access modifiers changed from: protected */
    public SDLJoystick getJoystick(int device_id) {
        for (int i = 0; i < this.mJoysticks.size(); i++) {
            if (((SDLJoystick) this.mJoysticks.get(i)).device_id == device_id) {
                return (SDLJoystick) this.mJoysticks.get(i);
            }
        }
        return null;
    }

    public boolean handleMotionEvent(MotionEvent event) {
        if ((event.getSource() & 16777232) != 0) {
            int actionPointerIndex = event.getActionIndex();
            switch (event.getActionMasked()) {
                case 2:
                    SDLJoystick joystick = getJoystick(event.getDeviceId());
                    if (joystick != null) {
                        for (int i = 0; i < joystick.axes.size(); i++) {
                            MotionRange range = (MotionRange) joystick.axes.get(i);
                            SDLActivity.onNativeJoy(joystick.device_id, i, (((event.getAxisValue(range.getAxis(), actionPointerIndex) - range.getMin()) / range.getRange()) * 2.0f) - 1.0f);
                        }
                        for (int i2 = 0; i2 < joystick.hats.size(); i2 += 2) {
                            SDLActivity.onNativeHat(joystick.device_id, i2 / 2, Math.round(event.getAxisValue(((MotionRange) joystick.hats.get(i2)).getAxis(), actionPointerIndex)), Math.round(event.getAxisValue(((MotionRange) joystick.hats.get(i2 + 1)).getAxis(), actionPointerIndex)));
                        }
                        break;
                    }
                    break;
            }
        }
        return true;
    }
}