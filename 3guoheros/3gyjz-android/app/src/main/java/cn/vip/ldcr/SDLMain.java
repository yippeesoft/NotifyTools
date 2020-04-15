package cn.vip.ldcr;

/* compiled from: SDLActivity */
class SDLMain implements Runnable {
    SDLMain() {
    }

    public void run() {
        SDLActivity.nativeInit(SDLActivity.mSingleton.getArguments());
    }
}
