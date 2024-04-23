package com.example.overlay_service.overlay

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.content.res.Configuration
import android.content.res.Resources
import android.graphics.Color
import android.graphics.PixelFormat
import android.os.Build
import android.os.IBinder
import android.util.DisplayMetrics
import android.util.Log
import android.util.TypedValue
import android.view.View
import android.view.WindowManager
import android.view.WindowManager.LayoutParams
import androidx.core.app.NotificationCompat
import com.example.overlay_service.OverlayServicePlugin
import com.example.overlay_service.R
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel
import kotlin.math.max

class OverlayService : Service() {

    private var mStatusBarHeight = -1
    private var mNavigationBarHeight = -1

    private var mResources: Resources? = null

    companion object {
        var isRunning = false

        //var instance: OverlayService? = null
        private const val DEFAULT_NAV_BAR_HEIGHT_DP = 48
        private const val DEFAULT_STATUS_BAR_HEIGHT_DP = 25
    }

    private var windowManager: WindowManager? = null
    private var overlayView: View? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val channel = MethodChannel(
            FlutterEngineCache.getInstance()[OverlayConstants.CACHED_TAG]!!.dartExecutor.binaryMessenger,
            OverlayConstants.OVERLAY_SERVICE_CHANNEL
        )
        channel.setMethodCallHandler { call, result ->
            if (call.method == "updateColor") {
                val colorValue = call.argument<Int>("colorValue")!!
                overlayView?.setBackgroundColor(colorValue)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
        var colorValue: Int? = null
        var alpha:Float? = null
        intent?.let {
            if (it.hasExtra(OverlayConstants.COLOR_VALUE_EXTRA)) {
                colorValue = it.getIntExtra(OverlayConstants.COLOR_VALUE_EXTRA, Color.GRAY)
                alpha = it.getFloatExtra(OverlayConstants.ALPHA_EXTRA, 0.8f)
            }
        }
        mResources = applicationContext.resources
        isRunning = true

        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager

        val dimension = getMaxDimension()
        val params = createParams(dimension)
        params.alpha = alpha ?: 0.8f
        overlayView = setupOverlay(windowManager!!, params, colorValue)

        return START_STICKY
    }

    private fun setupOverlay(
        windowManager: WindowManager,
        params: LayoutParams,
        colorValue: Int? = null
    ): View {
        val view = View(this).apply {
            fitsSystemWindows = true
            isFocusable = true
            isFocusableInTouchMode = true
        }
        view.setBackgroundColor(colorValue ?: Color.GRAY)
        windowManager.addView(view, params)
        return view
    }

    private fun createParams(maxDimension: Int): LayoutParams {
        return LayoutParams(
            maxDimension,
            maxDimension,
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) LayoutParams.TYPE_SYSTEM_OVERLAY else LayoutParams.TYPE_APPLICATION_OVERLAY,
            LayoutParams.FLAG_NOT_TOUCHABLE
                    or LayoutParams.FLAG_NOT_FOCUSABLE
                    or LayoutParams.FLAG_LAYOUT_NO_LIMITS
                    or LayoutParams.FLAG_LAYOUT_IN_SCREEN
                    or LayoutParams.FLAG_LAYOUT_INSET_DECOR
                    or LayoutParams.FLAG_HARDWARE_ACCELERATED,
            PixelFormat.TRANSLUCENT
        )
    }

    private fun getMaxDimension(): Int {
        val display = windowManager!!.defaultDisplay
        val dm = DisplayMetrics()
        display.getRealMetrics(dm)
        val statusBarHeight = statusBarHeightPx()
        val navigationBarHeight = navigationBarHeightPx()
        val height = dm.heightPixels + statusBarHeight + navigationBarHeight
        val width = dm.widthPixels + statusBarHeight + navigationBarHeight
        return max(height, width)
    }

    private fun statusBarHeightPx(): Int {
        if (mStatusBarHeight == -1) {
            val statusBarHeightId: Int =
                mResources!!.getIdentifier("status_bar_height", "dimen", "android")
            mStatusBarHeight = if (statusBarHeightId > 0) {
                mResources!!.getDimensionPixelSize(statusBarHeightId)
            } else {
                dpToPx(DEFAULT_STATUS_BAR_HEIGHT_DP)
            }
        }
        return mStatusBarHeight
    }

    private fun dpToPx(dp: Int): Int {
        return TypedValue.applyDimension(
            TypedValue.COMPLEX_UNIT_DIP,
            (dp.toString() + "").toFloat(),
            mResources!!.displayMetrics
        ).toInt()
    }

    private fun pxToDp(px: Int): Double {
        return px.toDouble() / mResources!!.displayMetrics!!.density
    }

    private fun inPortrait(): Boolean {
        return mResources!!.configuration.orientation == Configuration.ORIENTATION_PORTRAIT
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    fun navigationBarHeightPx(): Int {
        if (mNavigationBarHeight == -1) {
            val navBarHeightId =
                mResources!!.getIdentifier("navigation_bar_height", "dimen", "android")
            mNavigationBarHeight = if (navBarHeightId > 0) {
                mResources!!.getDimensionPixelSize(navBarHeightId)
            } else {
                dpToPx(DEFAULT_NAV_BAR_HEIGHT_DP)
            }
        }
        return mNavigationBarHeight
    }

    //@RequiresApi(api = Build.VERSION_CODES.M)
    override fun onDestroy() {
        Log.d(OverlayConstants.LOG_TAG, "Destroying the overlay window service")
        if (windowManager != null) {
            windowManager!!.removeView(overlayView)
            overlayView = null
        }
        windowManager = null
        isRunning = false
        val notificationManager =
            applicationContext.getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(OverlayConstants.NOTIFICATION_ID)
        //instance = null
    }

    override fun onCreate() {
        createNotificationChannel()
        val notificationIntent = Intent(this, OverlayServicePlugin::class.java)
        val pendingFlags: Int = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
        val pendingIntent = PendingIntent.getActivity(
            this,
            0, notificationIntent, pendingFlags
        )
        val notifyIcon: Int = getDrawableResourceId("mipmap", "launcher")
        val notification = NotificationCompat.Builder(
            this,
            OverlayConstants.CHANNEL_ID
        )

            .setSmallIcon(if (notifyIcon == 0) R.drawable.notification_icon else notifyIcon)
            .setContentIntent(pendingIntent)
            .build()
        startForeground(
            OverlayConstants.NOTIFICATION_ID,
            notification
        )
        //instance = this
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                OverlayConstants.CHANNEL_ID,
                "Foreground Service Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(
                NotificationManager::class.java
            )!!
            manager.createNotificationChannel(serviceChannel)
        }
    }

    private fun getDrawableResourceId(resType: String, name: String): Int {
        return applicationContext.resources.getIdentifier(
            String.format("ic_%s", name),
            resType,
            applicationContext.packageName
        )
    }
}