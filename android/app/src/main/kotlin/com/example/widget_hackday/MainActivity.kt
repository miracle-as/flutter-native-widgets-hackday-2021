package com.example.widget_hackday

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.widget.RemoteViews
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, "dk.miracle.flutter-native-widget-hackday-2021.appGroup")
        methodChannel.setMethodCallHandler { call, result ->

            when (call.method) {
                "reloadAllTimelines" -> {
                    reloadAllWidgets()
                    result.success(null)
                }
                else -> Log.d("duck", call.method)
            }
        }
    }

    private fun reloadAllWidgets() {
        val remoteViews = RemoteViews(context.packageName, R.layout.counter_widget)

        val manager = AppWidgetManager.getInstance(context)
        val appWidgetIds = manager.getAppWidgetIds(ComponentName(context, CounterAppWidget::class.java))

        val views = RemoteViews(context.packageName, R.layout.counter_widget)

        val applicationDir = applicationContext.getDir("flutter", Context.MODE_PRIVATE).path
        val imagePath = "$applicationDir/counter.png"

        views.setImageViewUri(R.id.counterImageView, Uri.parse(imagePath))
        views.setTextViewText(R.id.counterTextView, "duck duck")

        for (appWidgetId in appWidgetIds) {
            manager.updateAppWidget(appWidgetId, remoteViews)
        }
    }
}
