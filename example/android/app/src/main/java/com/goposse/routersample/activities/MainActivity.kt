package com.goposse.routersample.activities

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.WindowManager

import com.goposse.routersample.constants.Channels

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.view.FlutterView

class MainActivity : FlutterActivity() {

	private val LOG_TAG = "A:Main"
	private var deepLinkChannel: MethodChannel? = null

	override fun createFlutterView(context: Context?): FlutterView {
		val flutterView = FlutterView(this)
		flutterView.layoutParams = WindowManager.LayoutParams(
				WindowManager.LayoutParams.MATCH_PARENT,
				WindowManager.LayoutParams.MATCH_PARENT
		)
		setContentView(flutterView)
		Log.d(LOG_TAG, "...")
		checkForLinkEvent(intent, flutterView)
		return flutterView
	}

	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		GeneratedPluginRegistrant.registerWith(this)
		deepLinkChannel = MethodChannel(flutterView, Channels.DEEP_LINK_RECEIVED)
	}

	private fun checkForLinkEvent(intent: Intent, flutterView: FlutterView) {
		if (intent.action == Intent.ACTION_VIEW && intent.data != null) {
			val path = intent.data.getQueryParameter("path")
			if (path != null) {
				val passedObjs = mutableMapOf<String, Any>("path" to path)
				Log.d(LOG_TAG, "Passed objs = $passedObjs")
				deepLinkChannel?.invokeMethod("linkReceived", passedObjs)
				flutterView.setInitialRoute(path)
				Log.d(LOG_TAG, "Sent message to flutter: linkReceived=$path")
				Log.d(LOG_TAG, "Set initial route: route=$path")
			}
		}
	}
}
