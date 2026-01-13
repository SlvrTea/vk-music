package com.silvertea.vk_music

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    private val CHANNEL = "audioRemoteActivity";

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
         MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { 
            call, result ->
             if (call.method == "create") {
                AudioLiveActivityManager(this@MainActivity).showNotification()                          
            }
        }
    }
}
