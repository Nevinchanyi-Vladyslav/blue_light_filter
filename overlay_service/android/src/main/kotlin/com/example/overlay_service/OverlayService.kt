package com.example.overlay_service

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
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
import android.widget.FrameLayout
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
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
    private var blackView: View? = null
    private var overlayLayout: FrameLayout? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId)
        when (intent?.action) {
            OverlayActions.STOP_OVERLAY_SERVICE -> {
                Log.d(OverlayConstants.LOG_TAG, "Stopping overlay window service")
                stopSelf()
                return START_NOT_STICKY
            }
            OverlayActions.PAUSE_OVERLAY_SERVICE -> {
                Log.d(OverlayConstants.LOG_TAG, "Pausing overlay window service")
                windowManager?.removeView(overlayLayout)
                val notification = createNotification(
                    contentText = "Filter paused. Expand notification for more options",
                    resumeAction = true
                )
                val notificationManager = NotificationManagerCompat.from(this)
                notificationManager.notify(OverlayConstants.NOTIFICATION_ID, notification)
                return START_NOT_STICKY
            }
            OverlayActions.RESUME_OVERLAY_SERVICE -> {
                Log.d(OverlayConstants.LOG_TAG, "Resuming overlay window service")
                windowManager?.addView(overlayLayout, createParams(getMaxDimension(windowManager!!)))
                val notification = createNotification(
                    contentText = "Filter running in background. Expand notification for more options",
                    pauseAction = true
                )
                val notificationManager = NotificationManagerCompat.from(this)
                notificationManager.notify(OverlayConstants.NOTIFICATION_ID, notification)
                return START_NOT_STICKY
            }
            else -> {
                var colorValue: Int? = null
                var blackColor: Int? = null

                intent?.let {
                    if (it.hasExtra(OverlayConstants.COLOR_VALUE_EXTRA)) {
                        colorValue = it.getIntExtra(OverlayConstants.COLOR_VALUE_EXTRA, Color.GRAY)
                    }
                    if (it.hasExtra(OverlayConstants.BLACK_COLOR_EXTRA)) {
                        blackColor = it.getIntExtra(OverlayConstants.BLACK_COLOR_EXTRA, Color.BLACK)
                    }
                }
                Log.d(OverlayConstants.LOG_TAG, "blackColor: $blackColor")

                if (windowManager != null) {
                    Log.d(OverlayConstants.LOG_TAG, "Updating overlay window service")
                    if (colorValue != null) {
                        overlayView?.setBackgroundColor(colorValue!!)
                    }
                    if (blackColor != null) {
                        blackView?.setBackgroundColor(blackColor!!)
                    }
                } else {
                    Log.d(OverlayConstants.LOG_TAG, "Starting overlay window service")
                    mResources = applicationContext.resources
                    isRunning = true

                    windowManager = (getSystemService(WINDOW_SERVICE) as WindowManager)

                    val dimension = getMaxDimension(windowManager!!)
                    val params = createParams(dimension)
                    params.alpha = 0.8f

                    Log.d(OverlayConstants.LOG_TAG, "Created overlay params")

                    overlayView = createOverlayView(colorValue)
                    blackView = createOverlayView(blackColor)

                    Log.d(OverlayConstants.LOG_TAG, "Created overlay views")

                    overlayLayout = FrameLayout(this).apply {
                        addView(overlayView)
                        addView(blackView)
                    }

                    Log.d(OverlayConstants.LOG_TAG, "Created overlay layout")

                    windowManager?.addView(overlayLayout, params)
                }

                return START_STICKY
            }
        }
    }

    private fun createOverlayView(
        colorValue: Int? = null
    ): View {
        val view = View(this).apply {
            fitsSystemWindows = true
            isFocusable = true
            isFocusableInTouchMode = true
        }
        view.setBackgroundColor(colorValue ?: Color.GRAY)
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

    private fun getMaxDimension(windowManager: WindowManager): Int {
        val display = windowManager.defaultDisplay
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

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun navigationBarHeightPx(): Int {
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

    override fun onDestroy() {
        Log.d(OverlayConstants.LOG_TAG, "Destroying the overlay window service")
        isRunning = false

        windowManager?.let {
            it.removeView(overlayLayout)
            overlayView = null
            blackView = null
            overlayLayout = null
        }

        windowManager = null

        //Create api version check for stopForeground function
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N)
            stopForeground(STOP_FOREGROUND_REMOVE)
        else
            stopForeground(true)
        val notificationManager =
            applicationContext.getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(OverlayConstants.NOTIFICATION_ID)

        super.onDestroy()
    }

    private fun createBroadcastPendingIntentWithAction(
        action: String,
        pendingFlags: Int
    ): PendingIntent {
        val intent = Intent(this, ActionsReceiver::class.java)
        intent.action = action
        return PendingIntent.getBroadcast(
            this,
            0,
            intent,
            pendingFlags
        )
    }

    private fun createPendingFlags(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            PendingIntent.FLAG_IMMUTABLE
        } else {
            PendingIntent.FLAG_UPDATE_CURRENT
        }
    }

    private fun createNotification(
        contentText: String = "Expand notification for more options",
        stopAction: Boolean = true,
        pauseAction: Boolean = false,
        resumeAction: Boolean = false
    ): Notification {
        val notificationIntent = Intent(this, OverlayServicePlugin::class.java)
        val pendingFlags = createPendingFlags()
        val pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, pendingFlags)

        val notifyIcon = getDrawableResourceId("drawable", "ic_app_notification")
        val notificationBuilder = NotificationCompat.Builder(this, OverlayConstants.CHANNEL_ID)
            .setSmallIcon(if (notifyIcon == 0) R.drawable.outline_shield_24 else notifyIcon)
            .setContentTitle("Blue Light Filter")
            .setContentText(contentText)
            .setContentIntent(pendingIntent)
            //.setStyle(NotificationCompat.BigTextStyle().bigText(expandedText))
            .setPriority(NotificationCompat.PRIORITY_MAX)


        if (stopAction) {
            val stopPendingIntent = createBroadcastPendingIntentWithAction(
                OverlayActions.STOP_OVERLAY_SERVICE, pendingFlags
            )
            notificationBuilder.addAction(R.drawable.baseline_close_24, "Stop", stopPendingIntent)
        }
        if (pauseAction) {
            val pausePendingIntent = createBroadcastPendingIntentWithAction(
                OverlayActions.PAUSE_OVERLAY_SERVICE, pendingFlags
            )
            notificationBuilder.addAction(R.drawable.outline_pause_24, "Pause", pausePendingIntent)
        }
        if (resumeAction) {
            val resumePendingIntent = createBroadcastPendingIntentWithAction(
                OverlayActions.RESUME_OVERLAY_SERVICE, pendingFlags
            )
            notificationBuilder.addAction(
                R.drawable.baseline_play_arrow_24,
                "Resume",
                resumePendingIntent
            )
        }

        return notificationBuilder.build()
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        val notification = createNotification(
            contentText = "Filter running in background. Expand notification for more options",
            pauseAction = true,
        )
        startForeground(
            OverlayConstants.NOTIFICATION_ID,
            notification
        )
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