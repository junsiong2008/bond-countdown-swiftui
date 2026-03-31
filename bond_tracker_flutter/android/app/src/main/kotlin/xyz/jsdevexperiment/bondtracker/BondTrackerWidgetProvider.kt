package xyz.jsdevexperiment.bondtracker

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import java.text.NumberFormat
import java.util.Locale

class BondTrackerWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val data = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.bond_tracker_widget)

            val isConfigured = data.getBoolean("isConfigured", false)

            if (isConfigured) {
                val bondRemaining = data.getFloat("bondRemaining", 0f).toDouble()
                val completionPercentage = data.getFloat("completionPercentage", 0f).toDouble()
                val daysRemaining = data.getInt("daysRemaining", 0)

                val currency = NumberFormat.getCurrencyInstance(Locale.US)

                views.setViewVisibility(R.id.widget_configured, View.VISIBLE)
                views.setViewVisibility(R.id.widget_unconfigured, View.GONE)

                views.setTextViewText(R.id.widget_bond_remaining, currency.format(bondRemaining))
                views.setTextViewText(R.id.widget_days_remaining, "$daysRemaining days left")
                views.setTextViewText(
                    R.id.widget_progress_text,
                    "${completionPercentage.toInt()}%"
                )
                views.setProgressBar(
                    R.id.widget_progress_bar,
                    100,
                    completionPercentage.toInt(),
                    false
                )
            } else {
                views.setViewVisibility(R.id.widget_configured, View.GONE)
                views.setViewVisibility(R.id.widget_unconfigured, View.VISIBLE)
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
