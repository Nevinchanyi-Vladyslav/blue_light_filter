package com.example.overlay_service

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class ActionsReceiver : BroadcastReceiver(){
override fun onReceive(context: Context?, intent: Intent?) {
        val action = intent?.action
    Log.d(OverlayConstants.LOG_TAG, "Received action: $action")
    when (action) {
        OverlayActions.STOP_OVERLAY_SERVICE -> {
            context?.stopService(Intent(context, OverlayService::class.java))
        }
        OverlayActions.PAUSE_OVERLAY_SERVICE -> {
            context?.startService(Intent(context, OverlayService::class.java).apply {
                setAction(OverlayActions.PAUSE_OVERLAY_SERVICE)
            })
        }
        OverlayActions.RESUME_OVERLAY_SERVICE -> {
            context?.startService(Intent(context, OverlayService::class.java).apply {
                setAction(OverlayActions.RESUME_OVERLAY_SERVICE)
            })
        }
    }
    }

}