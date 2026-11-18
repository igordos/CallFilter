package com.callfilter.call_filter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        CallFilterChannel(
            this,
            flutterEngine.dartExecutor.binaryMessenger,
        ).register()
    }
}
