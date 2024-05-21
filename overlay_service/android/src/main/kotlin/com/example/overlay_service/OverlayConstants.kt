package com.example.overlay_service

object OverlayConstants {
    const val CACHED_ENGINE = "cachedEngine"
    const val MAIN_CHANNEL = "com.example.blue_light_filter_main"

    // const val OVERLAY_SERVICE_CHANNEL = "overlay_service"
    const val CHANNEL_ID = "Overlay Channel"
    const val NOTIFICATION_ID = 4579
    const val LOG_TAG = "Overlay Service"

    const val COLOR_VALUE_EXTRA = "color_value_extra"
    const val BLACK_COLOR_EXTRA = "black_color_extra"
}

object OverlayActions {
    const val STOP_OVERLAY_SERVICE = "stop_overlay_service"
    const val PAUSE_OVERLAY_SERVICE = "pause_overlay_service"
    const val RESUME_OVERLAY_SERVICE = "resume_overlay_service"
}