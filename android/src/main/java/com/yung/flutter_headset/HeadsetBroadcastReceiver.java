package com.yung.flutter_headset;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.KeyEvent;

interface HeadsetEventListener {
    void onHeadsetConnect();

    void onHeadsetDisconnect();
}

public class HeadsetBroadcastReceiver extends BroadcastReceiver {

    HeadsetEventListener headsetEventListener;

    public HeadsetBroadcastReceiver(final HeadsetEventListener listener) {
        this.headsetEventListener = listener;
    }

    @Override
    public void onReceive(final Context context, final Intent intent) {
        if (intent.getAction().equals(Intent.ACTION_HEADSET_PLUG)) {
            final int state = intent.getIntExtra("state", -1);
            FlutterHeadsetPlugin.currentState = state;
            switch (state) {
                case 0:
                    headsetEventListener.onHeadsetDisconnect();
                    break;
                case 1:
                    headsetEventListener.onHeadsetConnect();
                    break;
                default:
                    Log.d("log", "I have no idea what the headset state is");
            }
        }
    }
}