package com.example.quotes_app

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.app.PendingIntent
import es.antonborri.home_widget.HomeWidgetPlugin

class TranslucentWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)
        val views = RemoteViews(context.packageName, R.layout.widget_layout_translucent)

        // Get data from shared preferences
        val quoteText = widgetData.getString("quote_text", "Tap to see today's quote")
        val quoteAuthor = widgetData.getString("quote_author", "Philosopher")
        val streak = widgetData.getInt("current_streak", 0)

        // Update views
        views.setTextViewText(R.id.widget_quote_text, "\u201C$quoteText\u201D")
        views.setTextViewText(R.id.widget_quote_author, "— $quoteAuthor")
        views.setTextViewText(R.id.widget_streak, streak.toString())

        // Set click intent to open app
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
