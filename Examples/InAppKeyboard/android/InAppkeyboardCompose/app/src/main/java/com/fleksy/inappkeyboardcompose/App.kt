package com.fleksy.inappkeyboardcompose

import android.app.Application
import co.thingthing.fleksy.core.keyboard.inapp.InAppKeyboardSDK

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        val integration = Integration(applicationContext)
        InAppKeyboardSDK.initialise(integration)
    }
}