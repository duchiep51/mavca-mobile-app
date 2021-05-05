package com.example.Mobile

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService

class Application : FlutterApplication(), PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingService.setPluginRegistrant(this);
        // if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        //     val channelID = getString(R.string.notification_channel_id)
        //     val name = getString(R.string.notification_channel_name)
        //     val descriptionText = getString(R.string.notification_channel_desc)
        //     val importance = NotificationManager.IMPORTANCE_HIGH
        //     val channel = NotificationChannel(channelID, name, importance).apply {
        //         description = descriptionText
        //     }
        //     // Register the channel with the system
        //     val notificationManager: NotificationManager =
        //         getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        //     notificationManager.createNotificationChannel(channel)
        // }
    }

     override fun registerWith(registry: PluginRegistry) {
        FirebaseCloudMessagingPluginRegistrant.registerWith(registry)
    }
}