package com.example.overlay_service

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Log
import androidx.core.content.ContextCompat
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.FlutterEngineGroup
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class OverlayServicePlugin :
    FlutterPlugin, ActivityAware,
    MethodChannel.MethodCallHandler,
    PluginRegistry.ActivityResultListener {

    private var channel: MethodChannel? = null
    private var context: Context? = null
    private var activity: Activity? = null
    private var pendingResult: MethodChannel.Result? = null

    companion object {
        private const val REQUEST_CODE_FOR_OVERLAY_PERMISSION = 1248
        var isServiceRunningMethodChannel:MethodChannel? = null
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, OverlayConstants.MAIN_CHANNEL).apply {
            setMethodCallHandler(this@OverlayServicePlugin)
        }
        isServiceRunningMethodChannel = MethodChannel(binding.binaryMessenger, OverlayConstants.IS_SERVICE_RUNNING_CHANNEL)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        pendingResult = result
        when (call.method) {
            "startOverlay" -> handleStartOverlay(call, result)
            "checkOverlayPermission" -> result.success(checkOverlayPermission())
            "requestPermission" -> handleRequestPermission(result)
            "stopOverlay" -> handleStopOverlay(result)
            "isActive" -> result.success(OverlayService.isRunning)
            "updateColor" -> handleUpdateColor(call, result)
            "updateDim" -> handleUpdateDim(call, result)
            else -> {
                Log.d(OverlayConstants.LOG_TAG, "Unsupported method call ${call.method}")
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == REQUEST_CODE_FOR_OVERLAY_PERMISSION) {
            pendingResult?.success(checkOverlayPermission())
            return true
        }
        return false
    }

    private fun handleStartOverlay(call: MethodCall, result: MethodChannel.Result) {
        Log.d(OverlayConstants.LOG_TAG, "startOverlay: ${call.arguments}")
        val arguments = call.arguments<List<Int>>()!!
//        val colorValue = call.argument<Int>("colorValue")
//        val blackColor = call.argument<Int>("blackColor")
        val colorValue = arguments[0]
        val blackColor = arguments[1]
        Log.d(OverlayConstants.LOG_TAG, "startOverlay: $colorValue, $blackColor")
        startOverlay(colorValue, blackColor)
        result.success(null)
    }

    private fun handleRequestPermission(result: MethodChannel.Result) {
        requestPermission()
        result.success(null)
    }

    private fun handleStopOverlay(result: MethodChannel.Result) {
        stopOverlay()
        result.success(null)
    }

    private fun handleUpdateColor(call: MethodCall, result: MethodChannel.Result) {
        val colorValue = call.argument<Int>("colorValue")!!
        startOverlay(colorValue = colorValue)
        result.success(null)
    }

    private fun handleUpdateDim(call: MethodCall, result: MethodChannel.Result) {
        val blackColor = call.argument<Int>("blackColor")!!
        startOverlay(blackColor = blackColor)
        result.success(null)
    }

    private fun startOverlay(colorValue: Int? = null, blackColor: Int? = null) {
        val serviceIntent = Intent(context, OverlayService::class.java).apply {
            colorValue?.let { putExtra(OverlayConstants.COLOR_VALUE_EXTRA, it) }
            blackColor?.let { putExtra(OverlayConstants.BLACK_COLOR_EXTRA, it) }
        }
        ContextCompat.startForegroundService(context!!, serviceIntent)
    }

    private fun checkOverlayPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(context)
        } else true
    }

    private fun requestPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION).apply {
                data = Uri.parse("package:${activity?.packageName}")
            }
            activity?.startActivityForResult(intent, REQUEST_CODE_FOR_OVERLAY_PERMISSION)
        }
    }

    private fun stopOverlay() {
        if (OverlayService.isRunning) {
            val serviceIntent = Intent(context, OverlayService::class.java)
            context?.stopService(serviceIntent)
        }
    }
}