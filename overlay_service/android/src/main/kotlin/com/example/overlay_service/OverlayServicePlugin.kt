package com.example.overlay_service

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Log
import androidx.core.content.ContextCompat
import com.example.overlay_service.overlay.OverlayConstants
import com.example.overlay_service.overlay.OverlayService
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
    private var mActivity: Activity? = null
    private var pendingResult: MethodChannel.Result? = null

    companion object {
        private const val REQUEST_CODE_FOR_OVERLAY_PERMISSION = 1248
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel =
            MethodChannel(binding.binaryMessenger, OverlayConstants.MAIN_CHANNEL)
        channel!!.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel!!.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mActivity = binding.activity
        if (FlutterEngineCache.getInstance()[OverlayConstants.CACHED_TAG] == null) {
            val enn = FlutterEngineGroup(context!!)
            val dEntry = DartEntrypoint(
                FlutterInjector.instance().flutterLoader().findAppBundlePath(),
                "overlayMain"
            )
            val engine = enn.createAndRunEngine(context!!, dEntry)
            FlutterEngineCache.getInstance().put(OverlayConstants.CACHED_TAG, engine)
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        mActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        mActivity = binding.activity
    }

    override fun onDetachedFromActivity() {
        mActivity = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        pendingResult = result
        when (call.method) {
            "startOverlay" -> {
                val colorValue = call.argument<Int>("colorValue")!!
                val alpha = call.argument<Float>("alpha")!!
                startOverlay(colorValue, alpha)
                result.success(null)
            }

            "checkOverlayPermission" -> result.success(checkOverlayPermission())
            "requestPermission" -> {
                requestPermission()
                result.success(null)
            }

            "stopOverlay" -> {
                stopOverlay()
                result.success(null)
            }

            "isActive" ->{
                result.success(OverlayService.isRunning)
            }

            else -> {
                Log.d(OverlayConstants.LOG_TAG, "Unsupported method call ${call.method}")
                result.notImplemented() // Handle unsupported methods
            }
        }

    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == REQUEST_CODE_FOR_OVERLAY_PERMISSION) {
            pendingResult!!.success(checkOverlayPermission())
            return true
        }
        return false
    }

    private fun startOverlay(colorValue: Int, alpha: Float) {
        val serviceIntent = Intent(context, OverlayService::class.java)
        serviceIntent.putExtra(OverlayConstants.COLOR_VALUE_EXTRA, colorValue)
        serviceIntent.putExtra(OverlayConstants.ALPHA_EXTRA, alpha)
        ContextCompat.startForegroundService(context!!, serviceIntent)
    }

    private fun checkOverlayPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(context)
        } else true
    }

    private fun requestPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION)
            intent.data = Uri.parse("package:${mActivity!!.packageName}")
            mActivity!!.startActivityForResult(intent, REQUEST_CODE_FOR_OVERLAY_PERMISSION)
        }
    }

    private fun stopOverlay() {
        if (OverlayService.isRunning) {
            val i = Intent(
                context,
                OverlayService::class.java
            )
            context!!.stopService(i)
        }
    }
}