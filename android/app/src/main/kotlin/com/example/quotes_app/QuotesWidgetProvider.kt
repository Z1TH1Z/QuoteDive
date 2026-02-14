package com.example.quotes_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.app.AlarmManager
import android.app.PendingIntent
import java.util.Calendar
import es.antonborri.home_widget.HomeWidgetPlugin

class QuotesWidgetProvider : AppWidgetProvider() {
    
    companion object {
        private const val ACTION_DAILY_UPDATE = "com.example.quotes_app.DAILY_WIDGET_UPDATE"
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
        // Schedule daily update at 12:00
        scheduleDailyUpdate(context)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == ACTION_DAILY_UPDATE) {
            // Trigger widget update at 12:00
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val componentName = android.content.ComponentName(context, QuotesWidgetProvider::class.java)
            val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
            for (appWidgetId in appWidgetIds) {
                updateAppWidget(context, appWidgetManager, appWidgetId)
            }
        }
    }

    private fun scheduleDailyUpdate(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        
        val intent = Intent(context, QuotesWidgetProvider::class.java).apply {
            action = ACTION_DAILY_UPDATE
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        // Set alarm for 12:00 PM today, or tomorrow if already past 12:00
        val calendar = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 12)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
            if (before(Calendar.getInstance())) {
                add(Calendar.DAY_OF_YEAR, 1)
            }
        }
        
        // Repeat daily
        alarmManager.setRepeating(
            AlarmManager.RTC_WAKEUP,
            calendar.timeInMillis,
            AlarmManager.INTERVAL_DAY,
            pendingIntent
        )
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)
        val views = RemoteViews(context.packageName, R.layout.widget_layout)

        // Get data from shared preferences
        val quoteText = widgetData.getString("quote_text", "Tap to see today's quote")
        val quoteAuthor = widgetData.getString("quote_author", "Philosopher")
        val streak = widgetData.getInt("current_streak", 0)

        // Update views
        views.setTextViewText(R.id.widget_quote_text, "\u201C$quoteText\u201D")
        views.setTextViewText(R.id.widget_quote_author, "— $quoteAuthor")
        views.setTextViewText(R.id.widget_streak, streak.toString())

        // Set click intent to open app (whole widget tappable)
        val intent = Intent(context, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}
