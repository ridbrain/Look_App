package com.ridbrain.ibeauty;

import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;

public class MainActivity extends FlutterActivity {

    private EventChannel eventChannel;
    private String channelName = "looklike.beauty";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        eventChannel = new EventChannel(flutterEngine.getDartExecutor(), channelName);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        sendDeepLink(getIntent());
    }

    @Override
    public void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        sendDeepLink(intent);
    }

    private void sendDeepLink(Intent intent) {
        if (intent.getAction().equals(Intent.ACTION_VIEW) && eventChannel != null) {
            eventChannel.setStreamHandler(
                    new EventChannel.StreamHandler() {
                        @Override
                        public void onListen(Object args, final EventChannel.EventSink events) {
                            String data = intent.getDataString();
                            if (data != null) {
                                events.success(intent.getDataString());
                            }
                        }
                        @Override
                        public void onCancel(Object args) {
                        }
                    }
            );
        }
    }
}
