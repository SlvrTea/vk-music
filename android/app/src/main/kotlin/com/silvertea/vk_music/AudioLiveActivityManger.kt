package com.silvertea.vk_music

import android.app.Notification
import android.app.PendingIntent
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.RemoteViews
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class AudioLiveActivityManager(private val context: Context) {

    private val remoteViews = RemoteViews("com.vkmusic.channel.audio", R.layout.live_activity)

    private val notificationId = "testaudioremoteview";

    private val channelWithHighPriority = "channelWithHighPriority"

    private val channelWithDefaultPriority = "channelWithDefaultPriority"

    private val pendingIntent = PendingIntent.getActivity(
        context, 
        200,
        Intent(context, MainActivity::class.java).apply { 
            flags = Intent.FLAG_ACTIVITY_REORDER_TO_FRONT 
        },
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )

    private val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    init {
        createNotificationChannel(channelWithDefaultPriority)
        createNotificationChannel(channelWithHighPriority, true)
    }

    private fun createNotificationChannel(channelName: String, importanceHigh: Boolean = false) {
        val importance = if (importanceHigh) NotificationManager.IMPORTANCE_HIGH else NotificationManager.IMPORTANCE_DEFAULT
        val existingChannel = notificationManager.getNotificationChannel(channelName)
        if (existingChannel == null) { 
            val channel = NotificationChannel(channelName, "", importance).apply {
                setSound(null, null)
                vibrationPattern = longArrayOf(0L)
            }
            notificationManager.createNotificationChannel(channel)
        }
    }

    fun onStartAudio(): Notification {
        return Notification.Builder(context, channelWithHighPriority)
            .setContentIntent(pendingIntent)
            .setWhen(3000)
            .setOngoing(true)
            .setCustomBigContentView(remoteViews)
            .build()
    }

    fun showNotification() {
        val notification = onStartAudio();
        notificationManager.notify(notificationId, notification)
    }
}