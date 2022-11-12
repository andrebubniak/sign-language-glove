package com.example.luva;

import io.flutter.embedding.android.FlutterActivity;
import android.util.Log;
import com.polidea.rxandroidble2.LogConstants;
import com.polidea.rxandroidble2.LogOptions;
import com.polidea.rxandroidble2.RxBleClient;
import com.polidea.rxandroidble2.exceptions.BleException;
import io.reactivex.exceptions.UndeliverableException;
import io.reactivex.plugins.RxJavaPlugins;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import java.io.*;

public class MainActivity extends FlutterActivity 
{

    /* 
    RxJavaPlugins.@setErrorHandler(throwable -> {
        if (throwable instanceof UndeliverableException && throwable.getCause() instanceof BleException) {
            Log.v("SampleApplication", "Suppressed UndeliverableException: " + throwable.toString());
            return; // ignore BleExceptions as they were surely delivered at least once
        }
        // add other custom handlers if needed
        throw new RuntimeException("Unexpected Throwable in RxJavaPlugins error handler", throwable);
    });
    */
    /* 
    RxJavaPlugins.setErrorHandler ( throwable -> {
        if (throwable instanceof UndeliverableException && throwable.getCause() instanceof BleException) 
        {
            Log.v("SampleApplication", "Suppressed UndeliverableException: " + throwable.toString());
            return; // ignore BleExceptions as they were surely delivered at least once
        }
        else 
        {
            throw new RuntimeException("Unexpected Throwable in RxJavaPlugins error handler", throwable);
        }
    }
    );
    */
    private FlutterEngine flutterEngineInstance;

    private static final String CHANNEL = "com.example.luva/BleException";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) 
    {
        super.configureFlutterEngine(flutterEngine);
        flutterEngineInstance = flutterEngine;
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
            (call, result) -> 
            {
                if(call.method.equals("setBleErrorHandler"))
                {
                    setBleErrorHandler();
                    result.success(null);
                }
                else
                {
                    result.notImplemented();
                }
            }
            );
    }


    private void setBleErrorHandler()
    {
        RxJavaPlugins.setErrorHandler ( throwable -> {
            if (throwable instanceof UndeliverableException && throwable.getCause() instanceof BleException) 
            {
                Log.v("SampleApplication", "Suppressed UndeliverableException: " + throwable.toString());
                return; // ignore BleExceptions as they were surely delivered at least once
            }
            else 
            {
                throw new RuntimeException("Unexpected Throwable in RxJavaPlugins error handler", throwable);
            }
        });
    }

}
